---
layout: page
title: Home
tagline: OCCI the erlang way !
---
{% include JB/setup %}

All you need is code ? Go to [Quickstart](quickstart)

Complete usage and documentation available at: [Documentation](documentation)

## What is erocci ?

*erocci* is an erlang framework for building [OCCI](http://occi-wg.org)-like web services.

If you don't know OCCI, just take it as highly scalable framework for
building REST APIs independants from rendering (JSON. XML, HTTP
headers supported), transport (HTTP, XMPP inside) and storage (Mnesia
today, Riak planned).

If you know OCCI, *erocci* is a complete implementation of this
powerful meta-model based standard. It uses a formal XML description
of the categories for providing OCCI web services.

## What makes *erocci* unique ?

*erocci* is not 'yet another OCCI implementation'. It has been
designed with simplicity, flexibility and performance in mind.

### Simplicity

You just need to expose an OCCI API with database backend ? Look at the code:

{% highlight erlang linenos %}
start() ->
  application:start(occi),
  Extensions = {extensions, {
                  [{xml, "schemas/occi-infrastructure.xml"}],
                  [
                    {#occi_cid{scheme=?SCHEME_INFRA, term='compute', class=kind}, "/compute/"},
                    {#occi_cid{scheme=?SCHEME_INFRA, term='storage', class=kind}, "/storage/"},
                    {#occi_cid{scheme=?SCHEME_INFRA, term='storagelink', class=kind}, "/storagelink/"},
                    {#occi_cid{scheme=?SCHEME_INFRA, term='network', class=kind}, "/network/"},
                    {#occi_cid{scheme=?SCHEME_INFRA, term='networkinterface', class=kind}, "/networkinterface/"},
                    {#occi_cid{scheme=?SCHEME_NET, term='ipnetwork', class=mixin}, "/ipnetwork/"},
                    {#occi_cid{scheme=?SCHEME_NET_IF, term='ipnetworkinterface', class=mixin}, "/ipnetworkinterface/"},
                    {#occi_cid{scheme=?SCHEME_INFRA, term='os_tpl', class=mixin}, "/os_tpl/"},
                    {#occi_cid{scheme=?SCHEME_INFRA, term='resource_tpl', class=mixin}, "/resource_tpl/"}
                  ]
               }},
	Backends = {backends, [{mnesia, occi_backend_mnesia, [], "/"}]},
	Listeners = {listeners, [{http, occi_http, [{port, 8080}]}]},
	occi:config([Extensions, Backends, Listeners]).
{% endhighlight %}

And that's all !

### Flexibility

* You want to use another transport than HTTP: just change the
  listener to HTTPS, XMPP, etc or write your own.

* You want to use different backends for different categories/resource
  paths ? Backends can be mounted, like filesystems, on arbitrary
  paths.

Thanks to the use of erlang/OTP, *erocci* can be easily deployed on any OS, and even on a cluster.

### Performance

*erocci* is based on erlang/OTP platform plus state-of-the-art external libraries like:
* Mnesia for distributed storage
* Cowboy for HTTP/HTTPS,
* erim (exmpp fork) for XMPP and XML parsing/generation.

erlang/OTP is naturally distributed, which means it can be used on a
cluster as on a single machine, handling smoothly all requests your
audience requires.

Multiple backends are handled in parallel, giving another level of distribution.
