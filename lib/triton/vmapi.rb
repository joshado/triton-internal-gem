module Triton
  class Vmapi < ApiBase

    # The commit used to compile this itnerface:
    # https://github.com/joyent/sdc-vmapi/blob/590a4e09c0c76093f66f4ff69d6b4fd66de09bb6/docs/index.md
    #

    self.name = "vmapi"

    call('Ping',      :method => :get,    :path => '/ping')
    call('ListVms',   :method => :get,    :path => '/vms' )
    call('GetVm',     :method => :get,    :path => '/vms/:uuid')
    call('CreateVm',  :method => :post,   :path => '/vms')
    call("DeleteVm",  :method => :delete, :path => '/vms/:uuid')

    {
      'StartVm'          => 'start',
      'StopVm'           => 'stop',
      'RebootVm'         => 'reboot',
      'ReprovisionVm'    => 'reprovision',
      'UpdateVm'         => 'update',
      'AddNics'          => 'add_nics',
      'UpdateNics'       => 'update_nics',
      'RemoveNics'       => 'remove_nics',
      'CreateSnapshot'   => 'create_snapshot',
      'DeleteSnapshot'   => 'delete_snapshot',
      'RollbackSnapshot' => 'rollback_snapshot'
    }.each do |api_name, action_name|
      call(api_name, :method => :post, :path   => "/vms/:uuid?action=#{action_name}")
    end

    # :type in the following calls must be one of 'tags', 'customer_metadata', or 'internal_metadata'
    call("ListMetadata",      :method => :get,    :path => '/vms/:uuid/:type')
    call("GetMetadata",       :method => :get,    :path => '/vms/:uuid/:type/:key')
    call("AddMetadata",       :method => :post,   :path => '/vms/:uuid/:type', :body_param => 'metadata')
    call("SetMetadata",       :method => :put,    :path => '/vms/:uuid/:type', :body_param => 'metadata')
    call("DeleteMetadata",    :method => :delete, :path => '/vms/:uuid/:type/:key')
    call("DeleteAllMetadata", :method => :delete, :path => '/vms/:uuid/:type')
    call("AddRoleTags",       :method => :post,   :path => '/vms/:uuid/role_tags')
    call("SetRoleTags",       :method => :put,    :path => '/vms/:uuid/role_tags')
    call("DeleteRoleTag",     :method => :delete, :path => '/vms/:uuid/role_tags/:role_tag')
    call("DeleteAllRoleTags", :method => :delete, :path => '/vms/:uuid/role_tags')

    call("GetJobs",     :method => :get, :path => '/jobs')
    call("ListVmJobs",  :method => :get, :path => '/vms/:uuid/jobs')
    call("GetJob",      :method => :get, :path => '/jobs/:uuid')
    call("GetStatuses", :method => :get, :path => '/statuses')

  end
end
