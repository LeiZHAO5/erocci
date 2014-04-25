---
layout: page
title: 1, 2, 3 OCCI !
carousel:
 - image: /assets/img/123_occi-1.png
 - image: /assets/img/123_occi-2.png
 - image: /assets/img/123_occi-3.png
---
{% include JB/setup %}

All you need is code ? Go to [Quickstart](quickstart)

Complete usage and documentation available at: [Documentation](documentation)

<ul class="posts">
  {% for post in site.posts %}
    <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>
