module VCRProxy
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'vcr_proxy/tasks/vcr_proxy.rake'
    end
  end
end
