---
layout: page
title: "Backends API"
description: "Extending erocci"
---
{% include JB/setup %}

### Why extending ?

The backend API is the first place to extend _erocci_. It will handle
[CRUD](http://en.wikipedia.org/wiki/Create,_read,_update_and_delete)
operations for OCCI entities, collections and user mixins.

### Backend URL handling

As backends are mounted like filesystems, they only deal with URL
relative to their mountpoint. `occi_store` module is responsible for
dealing with absolute/relative transformation.

It can appear that a resource contains pointers to other
resources. In this case:
* is an URL is relative, it must be handled by the backend itself;
* if an URL is absolute, it must be handled by the `occi_store`
module, which will dispatch to the right backend.

`occi_uri:is_rel/1` function must be used to check absolute/relative
URL.

### Backend behaviour

The `occi_backend` behaviour is defined with the below callbacks.

* `init(Mountpoint :: occi_node(), Args :: term()) -> {ok, State :: term()} | {error, Reason :: term()}.`

Is called for backend initialization.

* `terminate(State :: term()) -> ok.`

  is called for backend termination.

* `update(Node :: occi_node(), State :: term()) -> {ok, State :: term()} | { {error, Reason :: term()}, State :: term()}.`

  is called for updating a resource.
