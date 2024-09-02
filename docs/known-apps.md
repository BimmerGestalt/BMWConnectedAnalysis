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
{: .known-apps-list}

### 3rd Party Android Apps

| Application         | Basecore Version  | Entrybutton                                       | Notes |
| ------------------- | ----------------- | -----------                                       | ----- |
| iHeartRadio         | Radio v3          | ![](apps/iheartradio-entrybutton.png) iHeartRadio | |
| Pandora             | Radio v1          | ![](apps/pandora-entrybutton.png) Pandora         | Restricted to G11/G12 models |
| SmartThings Classic | OnlineServices v2 | ![](apps/smartthings-entrybutton.png) SmartThings | |
| Spotify             | Multimedia v3     | ![](apps/spotify-entrybutton.png) Spotify         | |
{: .known-apps-list}
 
### BMW Connected Apps for Android

BMW/Mini Connected includes its own RHMI apps, with their own unique resources. Connected Classic has even more apps. All of these apps exist within the OnlineServices menu, and some apps add extra entries.

| Application | Entrybutton | Notes |
| ----------- | ----------- | ----- |
| BMWOne | ![](apps/bmwconnected-entrybutton.png) BMW Connected | Call, Input, Map (in BMW), Navigate, NotificationEvent, PopupHmiState, adds to Navigation menu |
| Calendar | ![](apps/calendar-entrybutton.png) BMW Calendar | Call, Navigate, CalendarHmiState, adds to the Office menu |
| Audioplayer | ![](apps/classic-entrybutton.png) Audioplayer | Basecore v1 or v2 |
| Analyzer | ![](apps/analyzer-entrybutton.png) ECO PRO Analyzer | |
| News | ![](apps/news-entrybutton.png) News | Readout |
| Online Search | ![](apps/onlinesearch-entrybutton.png) Online search | Call, Navigate, Only available for Mini |
| Twitter | ![](apps/twitter-entrybutton.png) Twitter | Dictate, Readout |
| Wikilocal | ![](apps/wikilocal-entrybutton.png) Wiki Local | Navigate, Readout, Only available for BMW |
{: .known-apps-list}

### 3rd Party iOS Apps

iOS apps use a different certificate authentication scheme, [documented here]({% link authentication.md %}). These are the 3rd party iOS apps I've found that still have the BMW resources in their IPA bundles, perhaps others might be found in archives.

| Application | Category | Entrybutton | Notes |
| ----------- | -------- | ----------- | ----- |
| Audible | Multimedia | ![](apps/audible-entrybutton.png) Audible | AudioHmiState, Call, Input, Navigate |
| Glympse | OnlineServices | ![](apps/glympse-entrybutton.png) Glympse | Input |
| Pandora | Radio | ![](apps/pandoraI-entrybutton.png) Pandora | Input |
| Spotify | Multimedia | ![](apps/spotify-entrybutton.png) Spotify | Input |
| Stitcher | Radio | ![](apps/stitcher-entrybutton.png) Stitcher | AudioHmiState, Call, Input, Navigate |
| TuneInRadioPro | Radio | ![](apps/tunein-entrybutton.png) TuneIn | Input |
{: .known-apps-list}

### BMW Connected Apps for iOS

BMW Connected is pretty similar between iOS and Android

| Application | Category | Entrybutton | Notes |
| ----------- | -------- | ----------- | ----- |
| BMWOne | OnlineServices | ![](apps/bmwconnectedI-entrybutton.png) BMW Connected | Call, Input, Map, Navigate, NotificationEvent, PopupHmiState, adds to Navigation menu |
| Calendar | OnlineServices | ![](apps/calendar-entrybutton.png) BMW Calendar | Call, Navigate, CalendarHmiState, does NOT add to Office Menu |
{: .known-apps-list}

### Mini Connected Classic for iOS

Mini Connected Classic offered a lot of fun apps, though they changed over time:

#### Mini Connected Classic 2.7.1

| Application | Category | Entrybutton | Notes |
| ----------- | -------- | ----------- | ----- |
| DrivingExcitement | OnlineServices | ![](apps/miniclassic-entrybutton.png) Driving Excitement | Popup |
| DynamicMusic | Multimedia | ![](apps/miniclassic-entrybutton.png) Dynamic Music | |
| Facebook | OnlineServices | ![](apps/miniclassic-entrybutton.png) Facebook | Readout |
| Foursquare | OnlineServices | ![](apps/miniclassic-entrybutton.png) Foursquare® | Navigate, Readout |
| GoogleLocalSearch | OnlineServices | ![](apps/miniclassic-entrybutton.png) Online Search | Call, Navigate, Input |
| MinimalismAnalyzer | OnlineServices | ![](apps/miniclassic-entrybutton.png) MINIMALISM | |
| MissionControl | OnlineServices | ![](apps/miniclassic-entrybutton.png) Input, Mission Control | |
| News | OnlineServices | ![](apps/miniclassic-entrybutton.png) News | Readout |
| System | OnlineServices | [invisible] | Shows a popup when the phone battery is low |
| Twitter | OnlineServices | ![](apps/miniclassic-entrybutton.png) Twitter | Input, Readout |
| WebRadio | Radio | ![](apps/miniclassic-entrybutton.png) Web radio | Input, Popup |
{: .known-apps-list}

#### Mini Connected Classic 3.1.1

| Application | Category | Entrybutton | Notes |
| ----------- | -------- | ----------- | ----- |
| FoceMeter | OnlineServices | ![](apps/miniclassic-entrybutton.png) Forcemeter | |
| OnlineSearch | OnlineServices | ![](apps/miniclassic-entrybutton.png) Online Search | LocationInput |
| Routes | OnlineServices | ![](apps/miniclassic-entrybutton.png) Streetwise | |
| SportsInstruments | OnlineServices | ![](apps/miniclassic-entrybutton.png) Sports instruments | |
| System | OnlineServices | [invisible] | Call, Navigate |
{: .known-apps-list}

### Invisible Apps

There are other app certificates that do not add user-visible menus to the car, but instead enable other functionality:

| Application | Notes |
| ----------- | ----- |
| ApplicationManager | Has a few CDS permissions set to writable, includes J29 support in MyBMW |
| BMWOneAutoNav | Only to trigger navigation, no states |
| CarTelemetryService | Has a few CDS permissions set to writable |
| CDSBaseApp | MyBMW's CDS access, includes J29 support |
