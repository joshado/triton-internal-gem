module Triton
  class Cnapi < ApiBase

    # The commit used to compile this itnerface:
    # https://github.com/joyent/sdc-cnapi/blob/ba575c6136179f74ca16f086d1d71b9032e44e8d/docs/index.md
    #

    self.name = "cnapi"

    call('SelectServer', :method => :post, :path => '/allocate')
    call('ServerCapacity', :method => :post, :path => '/capacity')
    call('BootParamsGetDefault', :method => :get, :path => '/boot/default')
    call('BootParamsSetDefault', :method => :put, :path => '/boot/default')
    call('BootParamsUpdateDefault', :method => :post, :path => '/boot/default')
    call('BootParamsGet', :method => :get, :path => '/boot/:server_uuid')
    call('BootParamsSet', :method => :put, :path => '/boot/:server_uuid')
    call('BootParamsUpdate', :method => :post, :path => '/boot/:server_uuid')
    call('TaskGet', :method => :get, :path => '/tasks/:task_id')
    call('TaskWait', :method => :get, :path => '/tasks/:task_id/wait')
    call('ImageGet', :method => :get, :path => '/servers/:server_uuid/images/:uuid')
    call('Ping', :method => :get, :path => '/ping')
    call('NicUpdate', :method => :put, :path => '/servers/:server_uuid/nics')
    call('PlatformList', :method => :get, :path => '/platforms')
    call('CommandExecute', :method => :post, :path => '/servers/:server_uuid/execute')
    call('ServerList', :method => :get, :path => '/servers')
    call('ServerGet', :method => :get, :path => '/servers/:server_uuid')
    call('ServerUpdate', :method => :post, :path => '/servers/:server_uuid')
    call('ServerReboot', :method => :post, :path => '/servers/:server_uuid/reboot')
    call('ServerFactoryReset', :method => :put, :path => '/servers/:server_uuid/factory-reset')
    call('ServerSetup', :method => :put, :path => '/servers/:server_uuid/setup')
    call('ServerSysinfoRefresh', :method => :post, :path => '/servers/:server_uuid/sysinfo-refresh')
    call('ServerDelete', :method => :delete, :path => '/servers/:server_uuid')
    call('ServerTaskHistory', :method => :get, :path => '/servers/:server_uuid/task-history')
    call('ServerEnsureImage', :method => :get, :path => '/servers/:server_uuid/ensure-image')
    call('ServerInstallAgent', :method => :post, :path => '/servers/:server_uuid/install-agent')
    call('ServerCnAgentPause', :method => :get, :path => '/servers/:server_uuid/cn-agent/pause')
    call('ServerCnAgentResume', :method => :get, :path => '/servers/:server_uuid/cn-agent/resume')
    call('VmList', :method => :get, :path => '/servers/:server_uuid/vms')
    call('VmLoad', :method => :get, :path => '/servers/:server_uuid/vms/:uuid')
    call('VmInfo', :method => :get, :path => '/servers/:server_uuid/vms/:uuid/info')
    call('VmVncInfo', :method => :get, :path => '/servers/:server_uuid/vms/:uuid/vnc')
    call('VmUpdate', :method => :post, :path => '/servers/:server_uuid/vms/:uuid/update')
    call('VmNicsUpdate', :method => :post, :path => '/servers/:server_uuid/vms/nics/update')
    call('VmStart', :method => :post, :path => '/servers/:server_uuid/vms/:uuid/start')
    call('VmStop', :method => :post, :path => '/servers/:server_uuid/vms/:uuid/stop')
    call('VmKill', :method => :post, :path => '/servers/:server_uuid/vms/:uuid/kill')
    call('VmReboot', :method => :post, :path => '/servers/:server_uuid/vms/:uuid/reboot')
    call('VmCreate', :method => :post, :path => '/servers/:server_uuid/vms')
    call('VmReprovision', :method => :post, :path => '/servers/:server_uuid/vms/:uuid/reprovision')
    call('VmDestroy', :method => :delete, :path => '/servers/:server_uuid/vms/:uuid')
    call('VmDockerExec', :method => :post, :path => '/servers/:server_uuid/vms/:uuid/docker-exec')
    call('VmDockerCopy', :method => :post, :path => '/servers/:server_uuid/vms/:uuid/docker-copy')
    call('VmDockerStats', :method => :post, :path => '/servers/:server_uuid/vms/:uuid/docker-stats')
    call('VmDockerBuild', :method => :post, :path => '/servers/:server_uuid/vms/:uuid/docker-build')
    call('VmImagesCreate', :method => :post, :path => '/servers/:server_uuid/vms/:uuid/images')
    call('VmSnapshotCreate', :method => :put, :path => '/servers/:server_uuid/vms/:uuid/snapshots')
    call('VmSnapshotRollback', :method => :put, :path => '/servers/:server_uuid/vms/:uuid/snapshots/:snapshot_name/rollback')
    call('VmSnapshotDestroy', :method => :delete, :path => '/servers/:server_uuid/vms/:uuid/snapshots/:snapshot_name')
    call('ServerWaitlistList', :method => :get, :path => '/servers/:server_uuid/tickets')
    call('ServerWaitlistTicketCreate', :method => :post, :path => '/servers/:server_uuid/tickets')
    call('ServerWaitlistGetTicket', :method => :post, :path => '/tickets/:ticket_uuid')
    call('ServerWaitlistDeleteTicket', :method => :delete, :path => '/tickets/:ticket_uuid')
    call('ServerWaitlistTicketsDeleteAll', :method => :delete, :path => '/servers/:server_uuid/tickets')
    call('ServerWaitlistTicketsWait', :method => :get, :path => '/tickets/:ticket_uuid/wait')
    call('ServerWaitlistTicketsRelease', :method => :get, :path => '/tickets/:ticket_uuid/release')
    call('DatasetsList', :method => :get, :path => '/servers/:server_uuid/datasets')
    call('DatasetCreate', :method => :post, :path => '/servers/:server_uuid/datasets')
    call('SnapshotCreate', :method => :post, :path => '/servers/:server_uuid/datasets/:dataset/snapshot')
    call('SnapshotRollback', :method => :post, :path => '/servers/:server_uuid/datasets/:dataset/rollback')
    call('SnapshotList', :method => :get, :path => '/servers/:server_uuid/datasets/:dataset/snapshots')
    call('DatasetPropertiesGetAll', :method => :get, :path => '/servers/:server_uuid/dataset-properties')
    call('DatasetPropertiesGet', :method => :get, :path => '/servers/:server_uuid/datasets/:dataset/properties')
    call('DatasetPropertiesSet', :method => :post, :path => '/servers/:server_uuid/datasets/:dataset/properties')
    call('DatasetDestroy', :method => :delete, :path => '/servers/:server_uuid/datasets/:dataset')
    call('ZpoolList', :method => :get, :path => '/servers/:server_uuid/zpools')

  end
end