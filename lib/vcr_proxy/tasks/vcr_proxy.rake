namespace :vcr_proxy do
    desc 'Start the VCR Proxy server. Default VCR_PROXY_PORT=9999.'
    task :start do
      require 'vcr_proxy'
	  require 'vcr_proxy/settings'

	  Settings.namespace 'defaults'

	  VCRProxy.configure
      VCRProxy.start_with_pid
    end

    desc 'Stop the VCR Proxy server if tmp/pids/ pid files are found'
    task :stop do
      require 'vcr_proxy'

      VCRProxy.stop_with_pid
    end
end
