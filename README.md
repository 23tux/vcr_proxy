# VCRProxy

A first try for a very basic implementation of a VCR proxy. VCR is an awesome tool to record and
replay HTTP interactions for your test suite (or other use cases) in Ruby. That means, when you
call an external site, VCR records the request at the first time, and replays at later requests.
The problem is, that VCR is pure Ruby, that means, it can hook into webmock or fakeweb, but not
into requests made by external applications.

Such an external application could be an automated browser for your testsuite (e.g. selenium, phantomjs...).
When you try to do ajax calls from the frontend, that calls aren't recorded, because VCR can't know about them.
But: If you can configure your browser (or any other application) to use a proxy on a specific port, it would
be possible for VCR to record the request, when the proxy is written in Ruby.

And so I did: VCRProxy is a proxy server based on WEBrick (which is included in ruby by default), that hooks
into the calls, records them with VCR and let VCR replay the records the second time.

If you have SSL calls (and that is the tricky part), a second MITM proxy is started. You just have to ensure
that you ignore SSL errors/warnings in your application, because WEBrick generates a self-signed SSL certificate
on the fly, and this certificate isn't signed.

# Usage

Clone the repo

```
git clone git://github.com/23tux/vcr_proxy.git
```

Have a look into the `vcr_proxy.rb` and look at the bottom to make sure, port `9999` is available at your machine.

Start the server with

```
ruby vcr_proxy.rb
```

Test the server with

```
curl --proxy localhost:9999 http://blekko.com/ws/?q=rails+/json
```

For now VCR records the calls into `cassettes/records.yml`, this should be configurable in the future. If you start
the command a second time, VCR replays the interaction.

If you want to mock out HTTPS calls, try this

```
curl --proxy localhost:9999 --insecure https://blekko.com/ws/?q=rails+/json
```

The `--insecure` option tells curl to ignore SSL warnings.

# Further Development

There is a lot more to improve this thing. The issue sites tracks some already known issues from my site.
This thing should also be converted into a gem, and should provide some nice helper to hook into RSpec...
