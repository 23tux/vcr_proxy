require 'settingslogic'
require 'vcr_proxy/dependency'

  class Settings < Settingslogic
  if VCRProxy::Dependency.rails?
    source "#{Rails.root}/config/vcr_proxy.yml"
  else
    source Dir.pwd + '/vcr_proxy.yml'
    # HACK: namespace will be specified by command line parameter
  end
  end
