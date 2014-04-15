---
layout: page
title: "F.A.Q."
description: "Frequently Asked Questions"
---
{% include JB/setup %}

### How are you ?

So far, so good.

### I don't know OCCI. What is *erocci* about ?

If you don't know OCCI, *erocci* is an advanced framework for
building REST APIs, with following features:
* self-described APIs,
* multiple rendering: HTTP headers (text/occi), JSON (application/occi+json), XML (application/occi+xml)
* multiple transport: HTPP 1.1, HTTPS, XMPP
* parallel multi-backend: backends can be attached as mountpoints, and run in parallel.

### Why erlang ?

Web services can potentially scale to billions users. erlang *is*
scalable and distributed.

Web services evolve quickly. erlang/OTP is an industrial platform with
built-in deployment facilities and hot code swapping features.

Web services must be robust. erlang/OTP has builtin fault-tolerant
mechanisms, including hardware failures handling.
