---
layout: page
title: "Documentation"
description: "Everything you need to use and extend erocci"
---
{% include JB/setup %}

* _[Architecture]({{ BASE_PATH }}/documentation/architecture.html)_
* _[Framework configuration]({{ BASE_PATH }}/documentation/configuration.html)_
* _[Backends API]({{ BASE_PATH }}/documentation/backends.html)_

### OCCI specifications

As a generic OCCI framework, *erocci* conforms with the following OCCI
specifications:
* [OCCI Core](http://ogf.org/documents/GFD.183.pdf) v1.1: defines the meta-model;
* [OCCI HTTP Rendering](http://ogf.org/documents/GFD.185.pdf) v1.1:
  defines the _text/occi_, _text/plain_ and _text/uri-list_ renderings
  over HTTP.
* OCCI XML rendering: this specification has not been yet submitted to
  the OCCI working group. The XML schema as well as some examples can
  be found [here](http://github.com/jeanparpaillon/occi-schemas).
* OCCI JSON rendering: this specification is still a draft while it
  was implemented several times (by
  [rOCCI](https://github.com/gwdg/rOCCI) for instance). Draft
  [here](http://redmine.ogf.org/projects/occi-wg/repository/show?rev=json)
