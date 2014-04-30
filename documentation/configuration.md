---
layout: page
title: "Configuration"
description: "The values that count"
---
{% include JB/setup %}

The _erocci_ framework is largely configurable through proplist passed:
* through `occi:config/1`
* through the `occi` application env.

Application env takes precedence over `occi:config/1` proplist
argument.

### Properties

* `{backends, [Backend :: {Ref :: atom(), Mod :: atom(), Opts :: any(), Path :: string()}]}`

	* `Ref` is unique reference to the backend instance.
	* `Mod` is the name of a module implementing `occi_backend` behaviour.
	* `Opts` is an arbitrary term passed to the backend's `init/2` function.
	* `Path` is an absolute path to the mountpoint of the backend.

* `{listeners, [Listener :: {Ref :: atom(), Mod :: atom(), Opts :: any()}]}`

	* `Ref` is a unique reference to the backend instance.
	* `Mod` is the name of a module implementing `occi_listener` behaviour.
	* `Opts` is an arbitrary term passed to the listener's `start_link/2` function.
	* At the moment, only one listener at a time is supported.

* `{name, string()}`

	Name is prepended to all resource's URLs. If not specified, listeners try to detect the name, for instance:
	* http -> http://hostname:port
	* xmpp -> xmpp+occi://jid@domain

* `{backend_timeout, integer()}`

	Set the timeout (in ms) after which a request to a slow/not
    responding backend is considered failed. Default to 5000ms.
