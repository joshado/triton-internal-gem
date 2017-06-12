# Triton

Gem to wrap and mock the Triton internal APIs.

Currently supports:

 * Vmapi
 * Cnapi
 * Napi
 * Papi
 * Imgapi

## Usage

### Low level access

This library simply exposes the Triton API layer as function calls. The benefit of this layer the "mock" mode in which all the calls are emulated - but the results consistent across calls to different endpoints;

Rather than re-document all the calls, a relatively small set of conventions map the function calls to the HTTP requests, so you can use the Joyent documentation

    https://github.com/joyent/sdc-vmapi/blob/master/docs/index.md

Each API has a module under the `Triton` namespace - CNAPI becomes `Triton::Cnapi`.

Each API method is defined using the name in the Joyent documentation, so you can call:

  > Triton::Vmapi.execute("ListVms", :fields => 'uuid')
  => [{"uuid"=>"ff64a98e-3a8a-4d90-a726-0c2fd33e378c"}, ...

There is also a handy helper, dynamically mapping a snake_case name to the CamelCase name:

  > Triton::Vmapi.list_vms(:fields => 'uuid')
  => [{"uuid"=>"ff64a98e-3a8a-4d90-a726-0c2fd33e378c"}, ...

Note that symbols are mapped out to strings automatically, and the returned object is indifferent to string or symbol access.

A response hash is returned in the event of a successful response code from the server. If a unsuccessful code is returned, then an exception is raised with a class bsed on the code returned by the API.

The CreateVm could, for example, return a `ValidationFailed` error code, this is raised as `Triton::RemoteExceptions::ValidationFailed` and inherits from `Triton::RemoteException`. So, code such this should "just work":

  begin
    Triton::Vmapi.execute("CreateVm", { })
  rescue Triton::RemoteExceptions::ValidationFailed
    # valiation failed response
  rescue Triton::RemoteException
    # another server error
  end

All `RemoteExceptions` expose a `body` accessor returning the full deserialised JSON error and also the specific `code`, `message` and `errors` accessors.

### High level interface

There are also high-level objects that allow a more "object-oriented" style of access to the backend.

    TODO!

## Testing

All of the tests should be performed on the mock layer, as well as the live backend. By default, tests will be run on the mock layer:

    bundle exec rspec


To run on a live backend (which should be a pre-requisite of release) you need to provide a SOCKS tunnel (or direct access) to a Triton admin network. You'll also need to provide the DNS suffix of the triton cluster, so the API endpoints can be located:

    ssh -D 1234 root@<headnode> &
    TRITON_SOCKS=127.0.0.1 TRITON_SUFFIX=ovh-1 bundle exec rspec

Some of the rspec tests will only make sense when connected to a live cluster, these will be marked with `:live => true` metadata and skipped when running against the mock backend.


