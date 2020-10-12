---
layout: page
title: Application Manager
permalink: /am/
---

The Connected Apps protocol was created at an earlier era in mobile phone technology, and so one aspect of the API provides an optimization for limited memory handsets.

Instead of initializing a full RHMI application, a phone application can register an AM placeholder icon to show in the car interface. When the user selects this icon in the dashboard, a callback is sent to the phone application to initialize a full RHMI application, which seamlessly replaces the AM icon and automatically opens up. This allows full initialization to be deferred until the user wants to use the application.

## Application Manager API

After creating a handle with `am_create()`, the app should register for events with `am_addAppEventHandler()` and add one or more icons with `am_registerApp()`. The car will call `am_onAppEvent()` when the user selects an icon, and the icon will show a loading spinner. The phone app should create an RHMI app with the same appId as was given to the `am_registerApp`, or the app should call another `am_registerApp` with the same appId to reset the icon to the normal state.

```
sequenceDiagram
participant App as Connected App
participant Car as BMW Car
App ->> Car: am_create(deviceId: string, bluetoothAddress: byte[8])
Car ->> App: _result_am_create(handle: int)
App ->> Car: am_addAppEventHandler(handle: int, ident: string)
App ->> Car: am_registerApp(handle: int, appId: string, values: Map)

Note right of App: User selects an icon in the dashboard
Car ->> App: am_onAppEvent(handle: int, ident: string, appId: string, event: AMEvent)

Note right of App: Icon is now in a loading animation, do this to reset it:
App ->> Car: am_registerApp(handle: int, appId: string, values: Map)
```
{: class="mermaid"}

The `deviceId` is typically 0. The exact value of `bluetoothAddress` doesn't seem to be important, just that it needs to be 8 bytes long.

The `ident` for the event handler doesn't matter too much, it'll be passed back during the event handler but otherwisen't doesn't affect anything.

The `appId` should match the RHMI appId for the full app, if any. Otherwise, any arbitrary string seems to work just as well.

The `values` map describes the actual entry to add:

| Key | Name | Description |
| 0 | basecore version | Typically is 145 |
| 1 | Label | Whatever text label should be displayed |
| 2 | Icon | A png bytearray to show as the icon |
| 3 | Section | Where to place the entry, one of: [Addressbook, Multimedia, Navigation, OnlineServices, Phone, Radio, Settings, VehicleInformation] |
| 4 | true | true |
| 5 | weight | Ordering, larger numbers are at the top |
| 8 | mainstate ID | Typically is -1 |
| 101 - 123 | Various translations | Not usually found to be different than the main label |

