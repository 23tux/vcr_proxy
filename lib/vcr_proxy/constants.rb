module VCRProxy
  module Constants
    DEFAULT_PORT = 9994
    DEFAULT_HOST = 'localhost'

    # this setting will not be used if overwritten by VCR config
    DEFAULT_CASSETTES = '/tmp/cassettes'

    # the location of the http proxy pid
    PID_FILE_PATH = 'tmp/pids'
    PID_FILE_NAME = 'vcr_proxy_server.pid'
  end
end
