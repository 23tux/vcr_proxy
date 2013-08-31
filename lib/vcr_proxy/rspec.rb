require 'rspec'
require 'vcr_proxy/settings'

RSpec.configure do |config|
  config.before(:suite) do
    Settings.namespace 'defaults'
    VCRProxy.start_with_pid
  end

  config.after(:suite) do
    VCRProxy.stop_with_pid
  end
end
