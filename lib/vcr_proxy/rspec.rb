require 'rspec'

RSpec.configure do |config|
  config.before(:suite) do
    VCRProxy.start_with_pid
  end

  config.after(:suite) do
    VCRProxy.stop_with_pid
  end
end
