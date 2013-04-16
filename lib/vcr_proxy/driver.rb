module VCRProxy
  class << self
    def register_poltergeist_driver
      ::Capybara.register_driver :poltergeist_billy do |app|
        options = {
          phantomjs_options: [
            '--ignore-ssl-errors=yes',
            "--proxy=#{VCRProxy.host}:#{VCRProxy.port}",
          ]
        }

        ::Capybara::Poltergeist::Driver.new(app, options)
      end
    end
  end
end
