module Triton
  class Imgapi < ApiBase

    # The commit used to compile this itnerface:
    # https://github.com/joyent/sdc-imgapi/blob/f71f1e97b49e69830aa64d45e3ab5ef141ae3357/docs/index.md
    #

    self.name = "imgapi"

    call('ListImages', :method => :get, :path => '/images')
    call('GetImage', :method => :get, :path => '/images/:uuid')
    call('GetImageFile', :method => :get, :path => '/images/:uuid/file')
    call('GetImageIcon', :method => :get, :path => '/images/:uuid/icon')
    call('DeleteImageIcon', :method => :delete, :path => '/images/:uuid/icon')
    call('DeleteImage', :method => :delete, :path => '/images/:uuid')
    call('CreateImage', :method => :post, :path => '/images')
    call('CreateImageFromVm', :method => :post, :path => '/images?action=create-from-vm')
    call('ExportImage', :method => :post, :path => '/images/:uuid?action=export')
    call('AddImageFile', :method => :put, :path => '/images/:uuid/file')
    call('AddImageIcon', :method => :put, :path => '/images/:uuid/icon')
    call('ActivateImage', :method => :post, :path => '/images/:uuid?action=activate')
    call('DisableImage', :method => :post, :path => '/images/:uuid?action=disable')
    call('EnableImage', :method => :post, :path => '/images/:uuid?action=enable')
    call('AddImageAcl', :method => :post, :path => '/images/:uuid/acl?action=add')
    call('RemoveImageAcl', :method => :post, :path => '/images/:uuid/acl?action=remove')
    call('UpdateImage', :method => :post, :path => '/images/:uuid?action=update')
    call('AdminImportImage', :method => :post, :path => '/images/:uuid?action=import')
    call('AdminImportRemoteImage', :method => :post, :path => '/images/:uuid?action=import-remote')
    call('AdminImportDockerImage', :method => :post, :path => '/images?action=import-docker-image')
    call('AdminChangeImageStor', :method => :post, :path => '/images/:uuid?action=change-stor&stor=:newstor')
    call('ListImageJobs', :method => :get, :path => '/images/:uuid/jobs')
    call('ListChannels', :method => :get, :path => '/channels')
    call('ChannelAddImage', :method => :post, :path => '/images/:uuid?action=channel-add')
    call('Ping', :method => :get, :path => '/ping')
    call('AdminGetState', :method => :get, :path => '/state')
    call('AdminReloadAuthKeys', :method => :post, :path => '/authkeys/reload')
  end
end
