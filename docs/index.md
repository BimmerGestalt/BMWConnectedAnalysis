---
layout: default
---

BMW Connected presents a unique integration in combination with the iDrive infotainment system. Instead of relying on specific apps installed in the infotainment directly, BMW Connected adds new functionality to the infotainment system, driven entirely by the mobile phone. For example, BMW Connected will read the user's calendar and show upcoming events in the dashboard, and the Spotify application, if installed on the phone, will present as a new music source in the car.

This presents an opportunity to extend the useful life of the car's infotainment system, by adding new functionality over time instead of being frozen at the time of production. Even more exciting would be the ability for a user to add their own custom functionality to their car, without being limited to what the manufacturer is willing to offer.

Let's explore the BMW Connected app and protocol, and see if we can learn how to add our own functionality to iDrive.

{% for page in site.pages %}
  {% if page.title %}* [{{ page.title }}]({{ page.url | prepend: site.baseurl }}){% endif %}
{% endfor %}
