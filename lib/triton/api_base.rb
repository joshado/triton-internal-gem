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


    attr_reader :path

    def initialize(name, params={})
      @name = name
      @params = params.dup || {}
      @call = DefinedMethods[self.class][name]
      raise UnknownCall, "#{@name} isn't a known API method." unless @call

      @method = @call.fetch(:method, :get).intern
      @path = @call[:path]
      @body_param = @call[:body_param] && @params.delete(@call[:body_param])

      @params.each do |k,v|
        @path = @path.gsub(":#{k.to_s}") do |_|
          @params.delete(k)
          CGI.escape(v.to_s)
        end
      end

      @query_string_params = if @method == :get || !!@body_param
        @params
      else
        [@call.fetch(:querystring, [])].flatten.map do |key|
          value = @params.delete(key.to_s)
          [key, value] if value
        end.compact
      end
    end

    def execute
      if Triton.test_mode
        raise Triton::TestModeLeak, "Request '#{@name}' leaked when in test mode\n#{request.method.upcase} #{URI.parse(request.url).path}\n#{JSON.pretty_generate(@params)}"
      end
      Triton.logger.debug("#{self.class.name}/#{@name}: #{request.method.upcase} #{URI.parse(request.url).path}\n#{JSON.pretty_generate(@params)}")
      object = parse(request.execute)
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

    def parse(body)
      parser = @call.fetch(:response, :json)
      if parser.respond_to?(:call)
        parser.call(body)
      else
        case parser
        when :json_lines
          body.split("\n").map { |a| JSON.parse(a) }
        when :json
          JSON.parse(body)
        else
          raise ArgumentError, "Unknown parser '#{parser}'"
        end
      end
    end

    def request
      @request ||= begin

        # Now generate the payload, unless it's a GET
        payload = if @method == :get
          nil
        elsif !!@body_param
          JSON.generate(@body_param)
        else
          JSON.generate(@params)
        end

        query = @query_string_params.map { |k,v| [CGI.escape(k.to_s), CGI.escape(v.to_s)].join("=")}.join("&")

        url = URI.parse("http://#{self.class.hostname}#{path}")
        if query.length > 0
          url.query = if url.query
            url.query = "#{url.query}&#{query}"
          else
            query
          end
        end

        RestClient::Request.new({
          :method => @method,
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
