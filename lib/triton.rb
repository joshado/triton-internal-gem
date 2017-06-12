require 'triton/version'
require 'rest-client'
require 'cgi'

module Triton

  def self.suffix=(new_suffix)
    @suffix = new_suffix
  end
  def self.suffix
    @suffix
  end


  def self.socks=(new_socks)
    if new_socks
      server,port = new_socks.to_s.split(":")
      if port.nil?
        port = server
        server = "127.0.0.1"
      end
      begin
        require 'socksify'
        TCPSocket::socks_server = server
        TCPSocket::socks_port = port.to_i
      rescue LoadError
        $stderr.puts "Could not load 'socksify' gem. Socks forwarding won't work."
      end

    end
  end

  TestModeLeak = Class.new(RuntimeError)
  def self.test_mode=(value)
    @test_mode = value
  end
  def self.test_mode
    @test_mode
  end

  def self.logger=(logger)
    @logger = logger
  end
  def self.logger
    @logger ||= Logger.new("/dev/null")
  end

  require 'triton/remote_exception'
  require 'triton/api_base'
  require 'triton/vmapi'
  require 'triton/cnapi'
  require 'triton/napi'
  require 'triton/papi'
  require 'triton/imgapi'
  require 'triton/indifferent_hash'

end
