# Triton

Gem to wrap and mock the Triton internal APIs.

Currently supports:

 * Vmapi
 * Cnapi
 * Napi
 * Papi
 * Imgapi

## Usage

This library simply exposes the internal Triton API layer as cleaner Ruby function calls with a consistent interface. Rather than re-implement and re-document all the calls, a relatively small set of conventions map the function calls to the HTTP requests allowing the the Joyent documentation to be used directly.

    https://github.com/joyent/sdc-vmapi/blob/master/docs/index.md

### Configuration

When making requests, it calls APIs via their hostnames the suffix needs to be specified. This is dependent on the configuration of the triton cluster. You'll also need access to the Triton `admin` network to make the calls - you can either use this library on a host directly connected to the `admin` network or, alternatively, make calls via a SOCKS proxy.

It's possible to use the SOCKS proxy built into the `ssh` client:

    ssh -D 1234 root@<headnode ip>

    ...

    Triton.socks = '127.0.0.1:1234'

### Calling methods

Each (supported) API has a module under the `Triton` namespace - CNAPI, for example, becomes `Triton::Cnapi`. Each API function can be accessed either via the execute method using CamelCase method name from the Joyent documentation:

  > Triton::Vmapi.execute("ListVms", :fields => 'uuid')
  => [{"uuid"=>"ff64a98e-3a8a-4d90-a726-0c2fd33e378c"}, ...

or it can be be called via a direct class method, using a dynamically mapped `snake_case` method name:

  > Triton::Vmapi.list_vms(:fields => 'uuid')
  => [{"uuid"=>"ff64a98e-3a8a-4d90-a726-0c2fd33e378c"}, ...

Note that symbols are mapped out to strings automatically, and the returned object is indifferent to string or symbol access.

### Handling Responses

A response hash is returned in the event of a successful response code from the server. If a unsuccessful code is returned, then a `Triton::RemoteException` subclass is raised with the code passed from the server.

The CreateVm could, for example, return a `ValidationFailed` error code, this is raised as `Triton::RemoteExceptions::ValidationFailed` which inherits from `Triton::RemoteException`. So, code such this should "just work":

  begin
    Triton::Vmapi.execute("CreateVm", { })
  rescue Triton::RemoteExceptions::ValidationFailed => e
    # valiation failed response
  rescue Triton::RemoteException => e
    # another server error
  end

All `RemoteExceptions` expose a `body` accessor returning the full deserialised JSON error and also the specific `code`, `message` and `errors` accessors.

## Testing

There is a set of rspec tests that exercise the various mapping behaviours outlined above, these are purely offline only tests. None of the testing exercises the Triton functionality - this library makes no claims about the behaviour of the various function calls, but does make it easier for consumer applications to mock the calls in it's own testing. The following rspec code should work as expected:

    allow(Triton::Vmapi).to receive(:list_vms)

    ...

    expect(Triton::Vmapi).to have_received(:list_vms) do |args|
      expect(args[:uuid]).to eq('12345....')
    end

In addition, you can enable a "test-mode" which will refuse to make live calls and, instead, raise exceptions about leaking calls. This is enabled by specifying

    Triton.test_mode = true

in your rspec configuration.

Finally, you can use the console to interact with a live Triton cluster - be careful. You can specify the suffix and SOCKS configuration on the command line:

    $ bundle exec bin/console  --suffix ovh-1 --socks 1234
    irb(main):001:0> Triton::Vmapi.list_vms(:limit => 3, :fields => 'uuid')
    => [{"uuid"=>"fffeb0d0-ed59-46e7-b212-5d64d02db417"}, {"uuid"=>"ffe29552-8186-c22f-9a8d-f06ee619c444"}, {"uuid"=>"ff8a2abb-d270-e323-81c2-f0f7f7dff8a1"}]
    irb(main):002:0>

