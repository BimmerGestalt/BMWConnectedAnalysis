---
layout: page
title: RHMI Audio Interaction
permalink: /rhmi-audio/
---

BMW Connected has the concept of an Audio Focus to signal to apps that they are the current audio source and should begin playback.

### RHMI Audio Connection

The official Connected app is the primary endpoint that handles the audio connection in the car. Other apps can technically request audio context, and it'll work, but the official apps all rely on the main Connected app to handle it for them.

```
sequenceDiagram
participant BMWApp as BMW Connected
participant Car as BMW Car
BMWApp ->> Car: av_create(instanceID: int, name:string)
Car ->> BMWApp: _result_av_create(handle:int)
Note right of BMWApp: User selects an app in the dashboard
BMWApp ->> Car: av_requestConnection(name:string, connectionType:AVConnectionType)
Car ->> BMWApp: _result_av_requestConnection()
Note right of BMWApp: Car begins listening to the phone for audio
Car ->> BMWApp: av_connectionGranted(handle:int, connectionType:AVConnectionType)
Note right of BMWApp: Car requests that music should begin playing
Car ->> BMWApp: av_requestPlayerState(handle:int, connectionType:AVConnectionType, playerState:AVPlayerState)
BMWApp ->> Car: av_playerStateChanged(handle:int, connectionType:AVConnectionType, playerState:AVPlayerState)
BMWApp ->> Car: _result_av_playerStateChanged()
Note right of BMWApp: User pushes a button in the dashboard
Car ->> BMWApp: av_multimediaButtonEvent(handle:int, event:AVButtonEvent)
```
{: class="mermaid"}

The `instanceID` has to be valid and must be no greater than the current ID that is found in the `ACTION_CAR_ACCESSORY_ATTACHED` announcement, or else the car will send `av_connectionDenied` in response to `av_requestConnection`.

### Connected Apps - Creating the Audio Focus

When a multimedia Connected app starts, it sends out a broadcast intent named `com.bmwgroup.connected.app.ACTION_CAR_AUDIO_FOCUS_REQUEST`. This intent contains some metadata about the multimedia app:

| Name | Type | Description |
| `EXTRA_APPLICATION_ID` | String | The name of this app |
| `EXTRA_AUDIO_CONNECTION_FOCUS` | int | A number from 0-4, representing an enum of: `GAIN, LOSS, LOSS_TRANSIENT, LOSS_TRANSIENT_CAN_DUCK, GAIN_ON_LUM` |
| `EXTRA_AUDIO_CONNECTION_TYPE` | int | A number from 0-2, representing an enum of: `ENTERTAINMENT, INTERRUPT, UNKNOWN` |

After the main BMW Connected app hears this request, it creates (if necessary) an AV Context in the car. It uses this handle to tell the car to switch the audio input to the appropriate input for the Connected app (such as USB or Bluetooth).

```
sequenceDiagram
participant App as Connected App
participant BMWApp as BMW Connected
participant Car as BMW Car
App -->> BMWApp: Intent("com.bmwgroup.connected.app.ACTION_CAR_AUDIO_FOCUS_REQUEST")
BMWApp ->> Car: av_create(name:string)
Car ->> BMWApp: _result_av_create(handle:int)
Note right of BMWApp: User selects the app in the dashboard
BMWApp ->> Car: av_requestConnection(name:string, connectionType:AVConnectionType)
Car ->> BMWApp: _result_av_requestConnection()
Note right of BMWApp: Car begins listening to the phone for audio
Car ->> BMWApp: av_connectionGranted(handle:int, connectionType:AVConnectionType)
Note right of BMWApp: Car requests that music should begin playing
Car ->> BMWApp: av_requestPlayerState(handle:int, connectionType:AVConnectionType, playerState:AVPlayerState)
BMWApp ->> Car: av_playerStateChanged(handle:int, connectionType:AVConnectionType, playerState:AVPlayerState)
BMWApp ->> Car: _result_av_playerStateChanged()
```
{: class="mermaid"}

### App Title Display

At any point, an RHMI app can trigger a `statusbarEvent` to replace displayed music app name.

Based on an event definition such as: `<statusbarEvent id="577" textModel="571"/>`, the app would do the following steps:

1. `setData(571, "App Name")`	stages the app name into an RaDataModel
2. `Map args = new HashMap(); args.put(0, null);`	prepares an arguments payload, it always contains `{0:null}`
3. `rhmi_triggerEvent(577, args);`	takes over the status label with this app's information

Similarly, the RHMI app should trigger the `notificationIconEvent`, to update the displayed music player icon alongside the status bar. This event typically points to a hard-coded imageIdModel, and does not need to be changed to point a different icon. For example, based on `<notificationIconEvent id="4" imageIdModel="62"/>`:

1. `Map args = new Hashmap(); args.put(0, true);`
2. `rhmi_triggerEvent(4, args);`

### Currently Playing Song Display

While an app is holding the active audio context, it can trigger a `multimediaInfoEvent` to update the car's knowledge of the currently-playing track. This is primarily used by the Instrument Cluster to show a track between the Back and next selections., but may also be tied into the EntICPlaylist feature.

Similar to the App Title display, the `multimediaInfoEvent` contains both a `textModel1` and a `textModel2` attribute. These point to RaDataModel fields that can be filled with data, and then the event can be triggered to enact the change. `textModel1` seems to contain the track title, while `textModel2` usually contains the artist. After setting those two models, the `multimediaInfoEvent` can be triggered with the same `{0:null}` args payload as with the `statusbarEvent`.

### Multimedia Button Presses

While an app is holding the active audio context, it will receive Multimedia Button Events when a user selects Back or Next in the Instrument Cluster display, or presses or holds the Back or Next physical buttons. These will be sent to the `av_multimediaButtonEvent` callback, and simply contain the integer `av_handle` and the `AVButtonEvent` enum of the specific button that was pressed. `AV_EVENT_SKIP_DOWN` is sent for Back, and `AV_EVENT_SKIP_UP` is sent for Next.

Alternatively, if the app is relying on BMW Connected to manage the audio context on its behalf, BMW Connected graciously broadcasts an Intent with the event information. This is announced to the `com.bmwgroup.connected.app.ACTION_CAR_AUDIO_MULTIMEDIA_BUTTON_NOTIFICATION` Intent name, and contains the following extras:

| Name | Type | Description |
| `EXTRA_APPLICATION_ID` | String | The name of the app that has the audio context, and that this event is intended for |
| `EXTRA_MULTIMEDIA_BUTTON_EVENT` | int | A number from 0-4, representing an enum of: `AV_EVENT_SKIP_DOWN, AV_EVENT_SKIP_UP, AV_EVENT_SKIP_LONG_UP, AV_EVENT_SKIP_LONG_DOWN, AV_EVENT_SKIP_LONG_STOP` |

### Resuming Music Playback

The car remembers which audio context was last active when it is turned off, and waits for that audio context to show back up when the car is turned on again.

After the app is initialized, and it calls `av_create`, the car will notice if the given name matches the previously-remembered audio context. If so, the app will automatically receive an `av_connectionGranted` callback, even without needing to call `av_requestConnection`. The car may also call `av_requestPlayerState` to initiate playback.
