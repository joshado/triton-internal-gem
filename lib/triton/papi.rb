module Triton
  class Papi < ApiBase

    # The commit used to compile this itnerface:
    # https://github.com/joyent/sdc-papi/blob/30bcc2ce58ba5b2b27ca16fa33dc56704f865803/docs/index.md
    #
    self.name = "papi"

    call('ListPackages', :method => :get, :path => '/packages')
    call('GetPackage', :method => :get, :path =>'/packages/:uuid')
    call('CreatePackage', :method => :post, :path =>'/packages')
    call('UpdatePackage', :method => :put, :path =>'/packages/:uuid')
    call('Ping', :method => :get, :path => '/ping')
  end
end
