# VCRProxy

A first try for a very basic implementation of a VCR proxy. VCR is an awesome tool to record and replay HTTP interactions for your test suite (or other use cases) in Ruby. That means, when you call an external site, VCR records the request at the first time, and replays at later requests. The problem is, that VCR is pure Ruby, that means, it can hook into webmock or fakeweb, but not into requests made by external applications.

Such an external application could be an automated browser for your testsuite (e.g. selenium, phantomjs...). When you try to do ajax calls from the frontend, that calls aren't recorded, because VCR can't know about them. But: If you can configure your browser (or any other application) to use a proxy on a specific port, it would be possible for VCR to record the request, when the proxy is written in Ruby.

And so I did: VCRProxy is a proxy server based on WEBrick (which is included in ruby by default), that hooks into the calls, records them with VCR and let VCR replay the records the second time.

If you have SSL calls (and that is the tricky part), a second MITM proxy is started. You just have to ensure that you ignore SSL errors/warnings in your application, because WEBrick generates a self-signed SSL certificate on the fly, and this certificate isn't signed.