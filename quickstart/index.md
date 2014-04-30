---
layout: page
title: "Quickstart"
description: "The 'plug and dev' way"
---
{% include JB/setup %}

With the following instructions, you should be able to run your first
OCCI web service, with Mnesia backend (the erlang distributed
database). You don't need to know erlang at this point.

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

Checkout *erocci* code:
{% highlight sh %}
git checkout http://github.com/jeanparpaillon/erocci.git
{% endhighlight %}

### Step 3

Create your OCCI extension file or choose existing one. XML schema is
available
[here](http://github.com/jeanparpaillon/occi-schemas/blob/master/xml/occi.xsd).

`priv/schemas/occi-infrastructure.xml`
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

### Step 4

As other erlang applications, *erocci* uses a dedicated section in the
centralized configuration file. This sections is `occi`:

`erocci.config`
{% highlight erlang linenos %}
[
  {occi, [
	{backends, 
      [
	    {backend1, occi_backend_mnesia,
	      [{schemas, [{xml, "priv/schemas/occi-infrastructure.xml"}]}],
		  "/"}
	  ]
    },
	{listeners,
	  [{http, occi_http, [{port, 8080}]}]}
  ]}
].
{% endhighlight %}

* _Line 3_: declare backends. Backends are attached to a mountpoint,
like filesystem.
* _Line 5_: declare mnesia backend. The tuple contains:
  * `backend1`: unique reference for naming the backend,
  * `occi_backend_mnesia`: backend module name,
  * Options: mnesia backend can read schema from the XML file declared above.
  * `"/"`: the mountpoint on which backend is attached.
* _Line 10_: declare listerners. As of version 0.5, available listeners are:
  * occi_http (HTTP)
  * occi_https (HTTPS)
  * occi_xmpp_client (XMPP client)
* _Line 11_: http listener takes port as option.

### Step 5

Get erlang dependancies and build:

{% highlight sh %}
rebar get-deps
rebar compile
{% endhighlight %}

### Step 6

Start erocci framework with your config file:

{% highlight sh %}
./start.sh -c erocci.config
{% endhighlight %}

### Step 7

Test your application:
{% highlight sh %}
curl -v -H 'accept: application/occi+json' http://localhost:8080/-/
{% endhighlight %}

Have a look at OCCI specifications, especially HTTP rendering, to know
how to create, retrieve, update or delete resources ([OCCI-wg
website](http://occi-wg.org/about/specification/))

That's all folks !
