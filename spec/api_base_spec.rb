require 'spec_helper'

describe "ApiMapping" do

  let(:fakeapi) do
    Class.new(Triton::ApiBase) do
      self.name = "fakeapi"
      call("TestMethod", {
        :method => :post,
        :path   => "/testmethod/path"
      })

      call("GetMethod", {
        :path   => "/testmethod/path"
      })

      call("GetThing", {
        :path => "/things/:thing/foo"
      })

      call("PostThing", {
        :method => :post,
        :path => "/things/:thing"
      })

      call("GetThingWithQueryString", {
        :path => "/things/:thing/foo?a=b"
      })

      call("SetTags", {
        :method => :post,
        :path => "/thing/:id/tag",
        :body_param => :metadata
      })

    end
  end

  describe "instance behaviour" do

    subject { fakeapi.new("TestMethod") }

    it "should memoise the request" do
      first_request = subject.request
      expect(subject.request.object_id).to eq(first_request.object_id)
    end

    it "should pass execute to the request" do
      expect(subject.request).to receive(:execute).and_return("{}")
      subject.execute
    end

    it "should have a shortcut to execute the method from the class" do
      expect(fakeapi).to respond_to(:execute)
    end
  end

  describe "init - when the call isn't defined" do
    it "should raise an exception if the call isn't recognised" do
      expect { fakeapi.new("Unknown") }.to raise_exception(Triton::ApiBase::UnknownCall)
    end

    it "should be a NoMethodError" do
      expect(Triton::ApiBase::UnknownCall.new).to be_a(NoMethodError)
    end
  end

  describe "response handling" do
    subject { fakeapi.new("TestMethod") }

    it "should decode the payload as JSON" do
      allow(subject.request).to receive(:execute).and_return('{"something": "here"}')
      expect(subject.execute).to eq({"something" => "here"})
    end

    it "should return a hash with indifferent key access" do
      allow(subject.request).to receive(:execute).and_return('{"something": "here", "nested": {"something": "inner"}}')
      expect(subject.execute[:something]).to eq("here")
      expect(subject.execute['something']).to eq("here")
      expect(subject.execute[:nested][:something]).to eq("inner")
      expect(subject.execute[:nested]['something']).to eq("inner")
    end
  end

  describe "response exception handling" do
    subject { fakeapi.new("TestMethod") }

    let(:exception) { RestClient::Exception.new(double("Response", :body => "body"))}

    before do
      # Simulate a RestClient exception when we execute
      allow(subject.request).to receive(:execute).and_raise(exception)
    end

    it "should re-raise the original RestClient exception if the body doesn't contain valid JSON" do
      expect { subject.execute }.to raise_exception(exception)
    end

    it "should raise a Triton::RemoteException if the JSON decoded, but doesn't contain a 'code' field" do
      allow(exception.response).to receive(:body).and_return("{}")
      expect { subject.execute }.to raise_exception(Triton::RemoteException)
    end

    it "should synthesize an exception class if a 'code' is present" do
      allow(exception.response).to receive(:body).and_return('{"code": "ItScrewedUp"}')
      expect { subject.execute }.to raise_exception(Triton::RemoteExceptions::ItScrewedUp)
    end

    it "should be possible to raise a RemoteException with a struct" do
      expect do
        raise Triton::RemoteExceptions::RemoteException, { 'code' => 'ResourceNotFound', 'message' => 'VM not found'}
      end.to raise_exception(Triton::RemoteExceptions::ResourceNotFound, 'VM not found')
    end

    it "should be possible to raise a RemoteException with a message directly" do
      expect do
        raise Triton::RemoteExceptions::ResourceNotFound, 'VM not found'
      end.to raise_exception(Triton::RemoteExceptions::ResourceNotFound, 'VM not found')
    end

    it "should be possible to raise a RemoteException from a mock with a message in a test" do
      object = Object.new
      allow(object).to receive(:crash).and_raise(Triton::RemoteExceptions::ResourceNotFound, 'VM not found')

      expect do
        object.crash
      end.to raise_exception(Triton::RemoteExceptions::ResourceNotFound, 'VM not found')
    end
  end

  describe "request" do
    subject { fakeapi.new("TestMethod").request }

    it "should build a RestClient request" do
      expect(subject).to be_a(RestClient::Request)
    end

    it "should use the specified name as the first part of the hostname" do
      expect(subject.url).to match(%r{^http://fakeapi})
    end

    it "should append the configured suffix to the hostname" do
      expect(subject.url).to match(%r{^http://fakeapi.test/})
    end

    it "should append the path to the url" do
      expect(URI.parse(subject.url).path).to eq("/testmethod/path")
    end


    it "should set the method" do
      expect(subject.method).to eq(:post)
    end

    it "should default the method to :get" do
      expect(fakeapi.new("GetMethod").request.method).to eq(:get)
    end
  end

  describe "path parametisation" do
    it "should replace any :<word> values with the associated argument" do
      expect(URI.parse(fakeapi.new("GetThing", :thing => "IDENT").request.url).path).to eq("/things/IDENT/foo")
    end
    it "should URL encode any value" do
      expect(URI.parse(fakeapi.new("GetThing", :thing => "IDE/NT").request.url).path).to eq("/things/IDE%2FNT/foo")
    end

    it "should exclude any arguments used to build the URL from the query string of GET requests" do
      request = fakeapi.new("GetThing", 'thing' => "123", :foo => "bar").request
      expect(URI.parse(request.url).query).to eq("foo=bar")
    end
    it "should exclude any arguments used to build the URL from the payload of non-get requests" do
      request = fakeapi.new("PostThing", 'thing' => "123", :foo => "bar").request
      expect(URI.parse(request.url).path).to eq("/things/123")
      expect(JSON.load(request.payload)).to eq("foo" => "bar")
    end
  end

  it "should accept application/json" do
    expect(fakeapi.new("GetThing", :thing => "IDENT").request.headers['Accept']).to eq("application/json")
    expect(fakeapi.new("TestMethod").request.headers['Accept']).to eq("application/json")
  end

  describe "arguments - GET requests" do
    subject { fakeapi.new("GetMethod", :foo=>"bar/baz", :bar=>"baz").request }
    it "should urlencode and append to the URL as a query string" do
      expect(URI.parse(subject.url).query).to eq("foo=bar%2Fbaz&bar=baz")
    end

    it "should append carefully if there is already a query string" do
      url = fakeapi.new("GetThingWithQueryString", :thing => 1, :foo=>"bar", :bar=>"foo/bar").request.url
      expect(URI.parse(url).query).to eq("a=b&foo=bar&bar=foo%2Fbar")

    end

    it "should not set a payload" do
      expect(subject.payload).to be_nil
    end

    it "should not set a Content-Type header" do
      expect(subject.headers["Content-Type"]).to be_nil
    end
  end

  describe "arguments - non-GET" do
    subject { fakeapi.new("TestMethod", 'some' => 'args', :live => :here).request }

    it "should set the Content-Body to application/json" do
      expect(subject.headers["Content-Type"]).to eq("application/json")
    end
    it "should serialize the arguments to JSON as the payload" do
      expect(JSON.load(subject.payload)).to eq({'some' => 'args', 'live' => 'here'})
    end

  end

  it "should generate a snake-case function call from the Api name" do
    expect(fakeapi).to respond_to(:get_method)
  end


  describe "camelise" do
    it "should return a camel_case string" do
      expect("foo".camelise).to eq("Foo")
      expect("foo_bar".camelise).to eq("FooBar")
      expect("foo_bar_baz".camelise).to eq("FooBarBaz")
      expect("foo______bar_baz".camelise).to eq("FooBarBaz")
    end
    it "should return nil if an unexpected string is encountered" do
      expect("something-wrong".camelise).to eq(nil)
      expect("Capsyousay".camelise).to eq(nil)
      expect("wow!".camelise).to eq(nil)
    end
  end

  describe "test_mode" do
    before do
      Triton.test_mode = true
    end
    it "should raise an exception if a request is attempted when test_mode is set" do
      expect do
        fakeapi.test_method()
      end.to raise_exception(Triton::TestModeLeak)
    end

    it "should include the Api call name in the exception" do
      expect do
        fakeapi.test_method()
      end.to raise_exception do |ex|
        expect(ex.message).to include("TestMethod")
      end
    end

    it "should include the call route in the exception" do
      expect do
        fakeapi.test_method()
      end.to raise_exception do |ex|
        expect(ex.message).to include("POST /testmethod/path")
      end
    end

    it "should include the parameters in the exception" do
      expect do
        fakeapi.test_method("param" => "value")
      end.to raise_exception do |ex|
        expect(ex.message).to include(%{"param": "value"})
      end
    end
  end


  describe "body_param option" do

    subject { fakeapi.new('SetTags', :id => "the-id", :other_param => "other_value", :key => 'value', :metadata => { "tag1" => "value1", "tag2" => "value2" })}

    it "should write the value of the body_param to the body" do
      expect(JSON.load(subject.request.payload)).to eq({ "tag1" => "value1", "tag2" => "value2" })
    end

    it "should set any additional parameters on the query-string" do
      expect(URI.parse(subject.request.url).query).to eq("other_param=other_value&key=value")
    end

  end

end


