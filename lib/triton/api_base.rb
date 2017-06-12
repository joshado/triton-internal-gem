class String
  def camelise
    return nil unless self =~ /^[a-z\d_]+$/
    self.gsub(/_?([a-z\d]*)/) { |_| $1.capitalize }
  end
end
module Triton

  class ApiBase

    UnknownCall = Class.new(NoMethodError)
    DefinedMethods = Hash.new { |hash, key| hash[key] = {} }
    ApiNames = Hash.new

    def self.call(name, opts={})
      DefinedMethods[self][name] = opts
    end

    def self.name=(name)
      ApiNames[self] = name
    end

    def self.execute(name, params={})
      new(name, params).execute
    end

    def self.hostname
      "#{ApiNames[self]}.#{Triton.suffix}"
    end

    # We dynamically map from snake_case to CamelCase here
    def self.method_missing(snake_case, *args)
      camel_case = snake_case.to_s.camelise
      if DefinedMethods[self][camel_case]
        execute(camel_case, *args)
      else
        super
      end
    end

    def self.respond_to_missing?(snake_case, include_all=false)
      camel_case = snake_case.to_s.camelise
      if DefinedMethods[self][camel_case]
        true
      else
        super(snake_case, include_all)
      end
    end

    def initialize(name, params={})
      @name = name
      @call = DefinedMethods[self.class][name]
      @params = params

      raise UnknownCall, "#{@name} isn't a known API method." unless @call
    end

    def execute
      if Triton.test_mode
        raise Triton::TestModeLeak, "Request '#{@name}' leaked when in test mode\n#{request.method.upcase} #{URI.parse(request.url).path}\n#{JSON.pretty_generate(@params)}"
      end
      Triton.logger.debug("#{self.class.name}/#{@name}: #{request.method.upcase} #{URI.parse(request.url).path}\n#{JSON.pretty_generate(@params)}")
      object =  JSON.parse(request.execute)
      if object.is_a?(Hash)
        IndifferentHash.new.merge!(object)
      else
        object
      end
    rescue RestClient::Exception => e
      begin
        payload = JSON.parse(e.response.body)
        raise Triton::RemoteException, payload
      rescue JSON::JSONError
        raise e
      end
    end

    def request
      @request ||= begin
        request_method = @call.fetch(:method, :get).intern
        path = @call[:path]

        @params.each do |k,v|
          path = path.gsub(":#{k.to_s}") do |_|
            @params.delete(k)
            CGI.escape(v.to_s)
          end
        end

        body_param = @call[:body_param] && @params.delete(@call[:body_param])

        if request_method == :get || !!body_param
          payload = !!body_param && JSON.generate(body_param)
          query = @params.map { |k,v| "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}" }.join("&")
        else
          query = nil
          payload = JSON.dump(@params)
        end

        url = URI.parse("http://#{self.class.hostname}#{path}")
        url.query = if url.query
          "#{url.query}&#{query}"
        else
          query
        end

        RestClient::Request.new({
          :method => request_method,
          :url    => url.to_s,
          :headers => {
            'Accept'       => 'application/json',
            'Content-Type' => !!payload ? 'application/json' : nil
          },
          :payload => payload
        })
      end
    end

  end
end
