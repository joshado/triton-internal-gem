require "spec_helper"

RSpec.describe Triton do
  it "has a version number" do
    expect(Triton::VERSION).not_to be nil
  end

  it "should have a configurable suffix" do
    expect(Triton.suffix).to eq("test")
    Triton.suffix = "foo"
    expect(Triton.suffix).to eq("foo")
  end

  describe "socks config" do
    it "should accept host:port" do
      Triton.socks = "1.2.3.4:5678"
      expect(TCPSocket.socks_server).to eq("1.2.3.4")
      expect(TCPSocket.socks_port).to eq(5678)
    end
    it "should accept string 'port' and assume localhost" do
      Triton.socks = "5678"
      expect(TCPSocket.socks_server).to eq("127.0.0.1")
      expect(TCPSocket.socks_port).to eq(5678)
    end
    it "should accept an integer port, and assume localhost" do
      Triton.socks = 5678
      expect(TCPSocket.socks_server).to eq("127.0.0.1")
      expect(TCPSocket.socks_port).to eq(5678)
    end
  end

end
