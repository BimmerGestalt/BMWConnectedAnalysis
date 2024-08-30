---
layout: page
title: Known Apps
permalink: /known-apps/
---

When an RHMI app authenticates to the car, its certificate describes the allowed resources that the app can send to the car by containing a list of SHA256 checksums. As custom apps are developed, they must use these existing certificates and their associated resources. This page is an inventory of known apps to help developers select the resources to use for their own apps.

Not only do different apps have specific icon packs and labels, but different UI Descriptions provide different features, which may be an important consideration for certain custom apps.

### 3rd Party Android Basecore Descriptions

BMW Connected for Android included official support for hosting 3rd party applications, using a custom [CarAPI Protocol]({% link carapi.md %}). BMW Connected included a set of common UI Descriptions and the app would pick one to use, and then provide its specific icons and texts resources. These descriptions contain a wide variety of states and are very flexible in arrangement, and most actions use a `<combinedAction>` to allow the app to dynamically set a destination state.

| Category       | Version        | Sha256  | Notable Features |
| -------------- | -------------- | ------- | ---------------- |
| Multimedia     | id4/id5/id6 v1 | 2cba25a | Call, EntICPlaylist, Input, Navigate, Record |
| Multimedia     | id4/id5/id6 v2 | d29028f | Call, EntICPlaylist, Input, Navigate |
| Multimedia     | id4 v3         | d8dcd4c | Call, EntICPlaylist, Input, Navigate |
| Multimedia     | id5/id6 v3     | 8e1d0b2 | AudioHmiState, Call, EntICPlaylist, Input, Navigate |
| OnlineServices | id4/id5/id6 v1 | aaade0b | Call, EntICPlaylist, Input, Navigate, Record |
| OnlineServices | id4/id5/id6 v2 | ab8f2a8 | Call, EntICPlaylist, Input, Navigate |
| OnlineServices | id4 v3         | cb2e39d | Call, EntICPlaylist, Input, Navigate |
| OnlineServices | id5/id6 v3     | af247e2 | AudioHmiState, Call, EntICPlaylist, Input, Navigate |
| Radio          | id4/id5/id6 v1 | af99c08 | Call, EntICPlaylist, Input, Navigate, Record |
| Radio          | id4/id5/id6 v2 | 17be0ce | Call, EntICPlaylist, Input, Navigate |
| Radio          | id4 v3         | 6add559 | Call, EntICPlaylist, Input, Navigate |
| Radio          | id5/id6 v3     | 9928f4d | AudioHmiState, Call, EntICPlaylist, Input, Navigate |

### 3rd Party Android Apps

| Application         | Basecore Version  | Entrybutton                                       | Notes |
| ------------------- | ----------------- | -----------                                       | ----- |
| iHeartRadio         | Radio v3          | ![](apps/iheartradio-entrybutton.png) iHeartRadio | |
| Pandora             | Radio v1          | ![](apps/pandora-entrybutton.png) Pandora         | Restricted to G11/G12 models |
| SmartThings Classic | OnlineServices v2 | ![](apps/smartthings-entrybutton.png) SmartThings | |
| Spotify             | Multimedia v3     | ![](apps/spotify-entrybutton.png) Spotify         | |
 
### BMW Connected Apps for Android

BMW/Mini Connected includes its own RHMI apps, with their own unique resources. Connected Classic has even more apps. All of these apps exist within the OnlineServices menu, and some apps add extra entries.

| Application | Entrybutton | Notes |
| BMWOne | ![](apps/bmwconnected-entrybutton.png) BMW Connected | Call, Navigate, NotificationEvent, PopupHmiState, adds to Navigation menu |
| Calendar | ![](apps/calendar-entrybutton.png) BMW Calendar | Call, Navigate, Has a CalendarHmiState, adds to the Office menu |
| Audioplayer | ![](apps/classic-entrybutton.png) Audioplayer | Basecore v1 or v2 |
| Analyzer | ![](apps/analyzer-entrybutton.png) ECO PRO Analyzer | |
| News | ![](apps/news-entrybutton.png) News | Readout |
| Online Search | ![](apps/onlinesearch-entrybutton.png) Online search | Call, Navigate, Only available for Mini |
| Twitter | ![](apps/twitter-entrybutton.png) Twitter | Dictate, Readout |
| Wikilocal | ![](apps/wikilocal-entrybutton.png) Wiki Local | Navigate, Readout, Only available for BMW |
