module Triton
  class Napi < ApiBase

    # The commit used to compile this itnerface:
    # https://github.com/joyent/sdc-napi/blob/6dcd7540d5171e71260f54150ac6b5e43cf75acc/docs/index.md
    #

    self.name = "napi"

    call('Ping', :method => :get, :path => '/ping')
    call('ListNicTags', :method => :get, :path => '/nic_tags')
    call('GetNicTag', :method => :get, :path => '/nic_tags/:name')
    call('CreateNicTag', :method => :post, :path => '/nic_tags')
    call('UpdateNicTag', :method => :put, :path => '/nic_tags/:name')
    call('DeleteNicTag', :method => :delete, :path => '/nic_tags/:name')
    call('ListNetworks', :method => :get, :path => '/networks')
    call('CreateNetwork', :method => :post, :path => '/networks')
    call('UpdateNetwork', :method => :put, :path => '/networks/:network_uuid')
    call('GetNetwork', :method => :get, :path => '/networks/:network_uuid')
    call('DeleteNetwork', :method => :delete, :path => '/networks/:network_uuid')
    call('ProvisionNic', :method => :post, :path => '/networks/:network_uuid/nics')
    call('ListIPs', :method => :get, :path => '/networks/:network_uuid/ips')
    call('GetIP', :method => :get, :path => '/networks/:network_uuid/ips/:ip_address')
    call('UpdateIP', :method => :put, :path => '/networks/:network_uuid/ips/:ip_address')
    call('ListFabricVLANs', :method => :get, :path => '/fabrics/:owner_uuid/vlans')
    call('CreateFabricVLAN', :method => :post, :path => '/fabrics/:owner_uuid/vlans')
    call('GetFabricVLAN', :method => :get, :path => '/fabrics/:owner_uuid/vlans/:vlan_id')
    call('UpdateFabricVLAN', :method => :put, :path => '/fabrics/:owner_uuid/vlans/:vlan_id')
    call('DeleteFabricVLAN', :method => :delete, :path => '/fabrics/:owner_uuid/vlans/:vlan_id')
    call('ListFabricNetworks', :method => :get, :path => '/fabrics/:owner_uuid/vlans/:vlan_id/networks')
    call('CreateFabricNetwork', :method => :post, :path => '/fabrics/:owner_uuid/vlans/:vlan_id/networks')
    call('GetFabricNetwork', :method => :get, :path => '/fabrics/:owner_uuid/vlans/:vlan_id/networks/:network_uuid')
    call('DeleteFabricNetwork', :method => :delete, :path => '/fabrics/:owner_uuid/vlans/:vlan_id/networks/:network_uuid')
    call('ListNics', :method => :get, :path => '/nics')
    call('CreateNic', :method => :post, :path => '/nics')
    call('GetNic', :method => :get, :path => '/nics/:mac_address')
    call('UpdateNic', :method => :put, :path => '/nics/:mac_address')
    call('DeleteNic', :method => :delete, :path => '/nics/:mac_address')
    call('ListNetworkPools', :method => :get, :path => '/network_pools')
    call('CreateNetworkPool', :method => :post, :path => '/network_pools')
    call('GetNetworkPool', :method => :get, :path => '/network_pools/:uuid')
    call('UpdateNetworkPool', :method => :put, :path => '/network_pools/:uuid')
    call('DeleteNetworkPool', :method => :delete, :path => '/network_pools/:uuid')
    call('SearchIPs', :method => :get, :path => '/search/ips')
    call('ListAggregations', :method => :get, :path => '/aggregations')
    call('GetAggregation', :method => :get, :path => '/aggregations/:id')
    call('CreateAggregation', :method => :post, :path => '/aggregations')
    call('UpdateAggregation', :method => :put, :path => '/aggregations/:id')
    call('DeleteAggregation', :method => :delete, :path => '/aggregations/:id')
  end
end
