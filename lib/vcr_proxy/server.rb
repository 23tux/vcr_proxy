module VCRProxy
  class Server < ::WEBrick::HTTPProxyServer
    def initialize(opts = {})
      super
      @mitm_port = opts[:MITMPort] || 12322
    end

    # Starts the MITM server
    #
    # @param host [String]
    # @param port [Integer]
    #
    # @return Thread object
    def start_ssl_mitm(host, port)
      # WORKAROUND for "adress is already in use", just increase
      # the port number and kill the old webrick
      @mitm_port += 1
      @mitm_server.stop if @mitm_server
      @mitm_thread.kill if @mitm_thread

      @mitm_server = ::WEBrick::HTTPServer.new({
        :Port            => @mitm_port,
        :SSLEnable       => true,
        :SSLVerifyClient => ::OpenSSL::SSL::VERIFY_NONE,
        :SSLCertName     => [ ["C", "US"], ["O", host], ["CN", host] ]
      })

      @mitm_server.mount_proc('/') do |req, res|
        method, url, version = req.request_line.split(" ")

        remote_request = case method.upcase
                         when 'GET'
                           ::Net::HTTP::Get.new(req.unparsed_uri)
                         when 'POST'
                           ::Net::HTTP::Post.new(req.unparsed_uri)
                         when 'PUT'
                           ::Net::HTTP::Put.new(req.unparsed_uri)
                         when 'DELETE'
                           ::Net::HTTP::Delete.new(req.unparsed_uri)
                         when 'HEAD'
                           ::Net::HTTP::Head.new(req.unparsed_uri)
                         when 'OPTIONS'
                           ::Net::HTTP::Options.new(req.unparsed_uri)
                         else
                           puts "HTTP method '#{method}' not supported!"
                         end

        remote_request.body = req.body
        remote_request.body = req.body
        remote_request.initialize_http_header(transform_header(req.header))

        uri = req.request_uri
        http = ::Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = ::OpenSSL::SSL::VERIFY_NONE

        remote_response = http.request(remote_request)

        remote_response.code
        res.body   = remote_response.body
        res.status = remote_response.code

        remote_response.header.each do |k|
          res.header[k] = remote_response.header[k]
        end
      end

      @mitm_thread = ::Thread.new { @mitm_server.start }
    end

    # transforms the webrick header format into the ruby net http format
    # webrick:  {"agent"=>["blabla"]}
    # net http: {"agent"=>"blabla"}
    def transform_header(header)
      # header.inject({}) do |memo, pair|
      #   if Array === value
      #     h[key] = value.first
      #   else
      #     h[key] = value
      #   end
      # end

      h = {}
      header.each do |key, value|
        if ::Array === value
          h[key] = value.first
        else
          h[key] = value
        end
      end
      h
    end

    # the proxy tries to just forward SSL connections with a "CONNECT"
    # catch that forwarding, and call ssl_mitm
    def do_CONNECT(req, res)
      host, port = req.unparsed_uri.split(":")
      port = 443 unless port
      start_ssl_mitm(host, port)
      req.unparsed_uri = "127.0.0.1:#{@mitm_port}"
      super req, res
    end

    def service(req, res)
      ::VCR.use_cassette("vcr_proxy_records", :record => :new_episodes) do
        super(req, res)
      end
    end
  end
 end
