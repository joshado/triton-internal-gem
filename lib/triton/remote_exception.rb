module Triton

  # This module "magically" defines any constants as
  # RemoteExceptions, so when the server send back
  # error structures such as:
  #
  #    {"code" => "WidgetInvalid", ...}
  #
  # it means you can:
  #
  # begin
  #   ...
  # rescue Triton::RemoteException::WidgetInvalid
  # end
  #
  # without having to exhaustively define all such exceptions beforehand
  module RemoteExceptions
    def self.const_missing(name)
      klass = Class.new(RemoteException)
      RemoteExceptions.const_set(name, klass)
    end
  end

  #
  # In tests, you can also `raise Triton::RemoteExceptions::WidgetFailure, 'the-message'
  # and also `raise Triton::RemoteException, { "code" => 'WidgetFailure', 'message' => 'the-message' }
  # with the same behaviour
  #
  class RemoteException < RuntimeError
    def self.exception(payload)
      if payload.is_a?(Hash) && payload.keys.include?('code')
        const = Triton::RemoteExceptions.const_get(payload['code'].intern)
        const.new(payload)
      else
        self.new(payload)
      end
    end

    attr_reader :errors, :body, :code

    def initialize(hash_or_string)
      if hash_or_string.is_a?(Hash)
        @errors = hash_or_string['errors']
        @code = hash_or_string['code']
        @body = hash_or_string
        super(hash_or_string.fetch('message') { body.to_s })
      else
        super(hash_or_string)
      end
    end
  end

end
