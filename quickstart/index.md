---
layout: page
title: "Quickstart"
description: "The 'plug and dev' way"
---
{% include JB/setup %}

With the following instructions, you should be able to build your
first OCCI web service. You don't need to know erlang at this point.

### Step 1

- Install dependancies
  - erlang, version 16 or greater
  - rebar, for building
  - openssl and headers
  - libxml2 and headers
  - libexpat and headers
  - a C compiler

On a Debian box, run:

{% highlight sh %}
sudo apt-get install erlang rebar libssl-dev libxml2-dev libexpat1-dev build-essential
{% endhighlight %}

Other erlang dependancies are managed with rebar.

### Step 2

Create a dir for your application and cd into it:
{% highlight sh %}
mkdir myocci && cd myocci
{% endhighlight %}

### Step 3

Create a rebar configuration file:

`rebar.config`
{% highlight erlang linenos %}
{erl_opts, [{i, "deps/erim/include"}
	    ,{i, "deps/occi/include"}
	   ]}.

{deps, [{occi, ".*",
	 {git, "git://github.com/jeanparpaillon/erocci.git", "master"}}
       ]}.
{% endhighlight %}

Create an app file for rebar to understand this is an app.

`src/myocci.app.src`
{% highlight erlang linenos %}
{application, myocci,
 [
  {description, "myocci"},
  {vsn, "1"},
  {modules, []},
  {registered, []},
  {applications, [
                  kernel,
                  stdlib
                 ]},
  {mod, { myocci, []}},
  {env, []}
 ]}.
{% endhighlight %}

Ok, this is erlang boilerplate. You would go further in developing
erlang app, you will discover the power of this bizarre pieces of
code. For the moment, just copy'n'paste.

### Step 5

Create your OCCI extension file or choose existing one.

`schemas/occi-infrastructure.xml`
{% highlight xml linenos %}
<?xml version="1.0" encoding="UTF-8"?>
<occi:extension xmlns:occi="http://schemas.ogf.org/occi"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xsi:schemaLocation="http://schemas.ogf.org/occi occi.xsd " name="Infrastructure"
		status="stable" version="1">
  <!-- Compute Kind -->
  <occi:kind term="compute" scheme="http://schemas.ogf.org/occi/infrastructure#"
	     title="Compute Resource">
    <occi:parent scheme="http://schemas.ogf.org/occi/core#"
		 term="resource" />
    <occi:attribute name="occi.compute.architecture" type="xs:string" title="CPU Architecture" />
    <occi:attribute name="occi.compute.cores" type="xs:integer" title="CPU cores number" />
    <occi:attribute name="occi.compute.hostname" type="xs:string" title="System hostname" />
    <occi:attribute name="occi.compute.speed" type="xs:float" title="CPU speed (GHz)" />
    <occi:attribute name="occi.compute.memory" type="xs:float" title="System RAM (GB)" />
    <occi:attribute name="occi.compute.state" use="required"
		    default="inactive" immutable="true"
		    title="System state" type="xs:string" />
    <occi:action term="start"
		 scheme="http://schemas.ogf.org/occi/infrastructure/compute/action#"
		 title="Start the system" ></occi:action>
    <occi:action term="stop"
		 scheme="http://schemas.ogf.org/occi/infrastructure/compute/action#"
		 title="Stop the system (graceful, acpioff or poweroff)" >
      <occi:attribute name="method" type="xs:string" />
    </occi:action>
    <occi:action term="restart"
		 scheme="http://schemas.ogf.org/occi/infrastructure/compute/action#"
		 title="Restart the system (graceful, warm or cold)" >
      <occi:attribute name="method" type="xs:string" />
    </occi:action>
    <occi:action term="suspend"
		 scheme="http://schemas.ogf.org/occi/infrastructure/compute/action#"
		 title="Suspend the system (hibernate or in RAM)" >
      <occi:attribute name="method" type="xs:string" />
    </occi:action>
  </occi:kind>

  <!-- Storage Resource -->
  <occi:kind scheme="http://schemas.ogf.org/occi/infrastructure#"
	     term="storage" title="Storage Resource">
    <occi:parent scheme="http://schemas.ogf.org/occi/core#" term="resource" />
    <occi:attribute name="occi.storage.size" type="xs:float" use="required" title="Storage size" />
    <occi:attribute name="occi.storage.state" use="required" title="Storage state" type="xs:string" />
    <occi:action
	scheme="http://schemas.ogf.org/occi/infrastructure/storage/action#"
	term="online" title="Set storage online" />
    <occi:action
	scheme="http://schemas.ogf.org/occi/infrastructure/storage/action#"
	term="offline" title="Set storage offline" />
    <occi:action
	scheme="http://schemas.ogf.org/occi/infrastructure/storage/action#"
	term="backup" title="Set storage as backup" />
    <occi:action
	scheme="http://schemas.ogf.org/occi/infrastructure/storage/action#"
	term="snapshot" title="Take storage snapshot" />
    <occi:action
	scheme="http://schemas.ogf.org/occi/infrastructure/storage/action#"
	term="resize" title="Resize storage" >
      <occi:attribute name="size" type="xs:float" />
    </occi:action>
  </occi:kind>

  <!-- StorageLink Link -->
  <occi:kind scheme="http://schemas.ogf.org/occi/infrastructure#"
	     term="storagelink" title="StorageLink Link">
    <occi:parent scheme="http://schemas.ogf.org/occi/core#"
		 term="link" />
    <occi:attribute name="occi.storagelink.deviceid" use="required" type="xs:string" />
    <occi:attribute name="occi.storagelink.mountpoint" type="xs:string" />
    <occi:attribute name="occi.storagelink.state" use="required" immutable="true" type="xs:string" />
  </occi:kind>

  <!-- Network -->
  <occi:kind scheme="http://schemas.ogf.org/occi/infrastructure#"
	     term="network" title="Network Resource">
    <occi:parent scheme="http://schemas.ogf.org/occi/core#"
		 term="resource" />
    <occi:attribute name="occi.network.vlan" type="xs:integer" />
    <occi:attribute name="occi.network.label" type="xs:string" />
    <occi:attribute name="occi.network.state" immutable="true" use="required" type="xs:string" />
    <occi:action scheme="http://schemas.ogf.org/occi/infrastructure/action#"
		 term="up" title="Set network up" />
    <occi:action scheme="http://schemas.ogf.org/occi/infrastructure/action#"
		 term="down" title="Set network down" />
  </occi:kind>

  <!-- NetworkInterface Link -->
  <occi:kind scheme="http://schemas.ogf.org/occi/infrastructure#"
	     term="networkinterface" title="NetworkInterface Link">
    <occi:parent scheme="http://schemas.ogf.org/occi/core#"
		 term="link" />
    <occi:attribute name="occi.networkinterface.interface"
		    immutable="true" type="xs:string" use="required" />
    <occi:attribute name="occi.networkinterface.mac" type="xs:string" use="required" />
    <occi:attribute name="occi.networkinterface.state" immutable="true" use="required" type="xs:string" />
  </occi:kind>

  <!-- IP Networking Mixin -->
  <occi:mixin scheme="http://schemas.ogf.org/occi/infrastructure/network#"
	      term="ipnetwork" title="IP Networking Mixin">
    <occi:attribute name="occi.network.address" type="xs:string" />
    <occi:attribute name="occi.network.gateway" type="xs:string" />
    <occi:attribute name="occi.network.allocation" use="required" type="xs:string" />
  </occi:mixin>

  <!-- IP NetworkInterface Mixin -->
  <occi:mixin term="ipnetworkinterface" title="IP Network Interface Mixin"
	      scheme="http://schemas.ogf.org/occi/infrastructure/networkinterface#">
    <occi:attribute name="occi.networkinterface.address" type="xs:string" use="required" />
    <occi:attribute name="occi.networkinterface.gateway" type="xs:string" />
    <occi:attribute name="occi.networkinterface.allocation" use="required" type="xs:string" />
  </occi:mixin>

  <!-- OS template -->
  <occi:mixin scheme="http://schemas.ogf.org/occi/infrastructure#" term="os_tpl" title="OS Template" />

  <!-- Resource template -->
  <occi:mixin scheme="http://schemas.ogf.org/occi/infrastructure#" term="resource_tpl" title="Resource template" />
</occi:extension>
{% endhighlight %}

### Step 5

Create your application main module:

`src/myocci.erl`
{% highlight erlang linenos %}
-module(myocci).

-export([start/0]).

start() ->
    application:ensure_all_started(occi),
    Ext = {extensions, {
	     [{xml, "schemas/occi-infrastructure.xml"}],
	     [{"http://schemas.ogf.org/occi/infrastructure#compute", "/compute/"},
	      {"http://schemas.ogf.org/occi/infrastructure#network", "/network/"},
	      {"http://schemas.ogf.org/occi/infrastructure#storage", "/storage/"}]
	    }
	  },
    Backends = {backends,
		[{mnesia, occi_backend_mnesia, [], "/"}]
	       },
    Listeners = {listeners, 
		 [{http, occi_http, [{port, 8080}]}]
		},
    occi:config([Ext, Backends, Listeners]),
    ok.
{% endhighlight %}

At this point, we can explain a little bit. Config is given as a list
of `{Name, Value}` tuples (see [erlang
proplists](http://www.erlang.org/doc/man/proplists.html)). All these
values can be overriden at boot time with application env (see
[erlang
doc](http://www.erlang.org/doc/design_principles/applications.html#id74397)).

* _Line 1_: declare the module
* _Line 3_: declare exported functions. As an erlang application, you
  must expose a `start/0` function.
* _Line 6_: start the occi framework.
* _Line 8_: declare the categories to use in your API, grouped in
  one or several XML files, (hence the name).
* _Line 9-11_: map categories onto paths.
* _Line 15_: mount backend onto path. As a UNIX filesystem, you can
  mount as many backend as you want.
* _Line 18_: declare a listener (here an HTTP listener on port 8080).

### Step 6

Get erlang dependancies and build:

{% highlight sh %}
rebar get-deps
rebar compile
{% endhighlight %}

### Step 7

Boot your application:
{% highlight sh %}
erl -pa ebin -pa deps/*/ebin -s myocci
{% endhighlight %}

### Step 8

Test your application:
{% highlight sh %}
curl -v -H 'accept: application/occi+json' http://localhost:8080/-/
{% endhighlight %}

That's all folks !
