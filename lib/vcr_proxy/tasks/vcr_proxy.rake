namespace :vcr_proxy do
  namespace :server do
    desc 'Start the VCR Proxy server. Default VCR_PROXY_PORT=9999.'
    task :start do
      require 'vcr_proxy'

      VCRProxy.start_with_pid
    end

    desc 'Stop the VCR Proxy server if tmp/pids/ pid files are found'
    task :start do
      require 'vcr_proxy'

      VCRProxy.stop_with_pid
    end
  end
end
