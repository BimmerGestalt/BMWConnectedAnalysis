---
layout: page
title: CarAPI
permalink: /carapi/
---

Third-party apps branded as BMW Connected Ready, such as Spotify, that show up in the car dashboard utilize a system called CarAPI. Built on top of a custom RPC system using Android Intents, the third-party app coordinates with BMW Connected to interact with the car.

This is a new feature of the new BMW Connected, and BMW Connected Classic does not implement it.

### Registering

When the main BMW Connected app starts, it sends out a broadcast intent named `com.bmwgroup.connected.car.app.action.CONNECTED_APP_INSTALLED`, with no attached extras, to solicit responses from any installed Connected Apps.

Connected Apps, such as Spotify or IHeartRadio for Auto, are listening for this `CONNECTED_APP_INSTALLED` intent, often declared in AndroidManifest.xml as a receiver. When it receives an announcement, it broadcasts an intent in reply: `com.bmwgroup.connected.app.action.ACTION_CAR_APPLICATION_REGISTERING`. Attached to this intent, it sends along an icon and title. This registration intent includes Intent names to be notified on connection and on disconnection. The full list of extras is:

| Name | Type | Description |
| `EXTRA_APPLICATION_CATEGORY` | String | One of `Multimedia|Radio|OnlineServices`, which determines which app template to use |
| `EXTRA_APPLICATION_BRAND` | BrandType enum | One of `{bmw|mini|bmwi|all}`, probably which Connected apps to show in |
| `EXTRA_APPLICATION_ID` | String | A short name for this app |
| `EXTRA_APPLICATION_TITLE` | String | The display name of the app |
| `EXTRA_APPLICATION_APP_ICON` | String | An icon to show in the main app |
| `EXTRA_APPLICATION_VERSION` | String | A version string, such as `v3`, which ties into the RHMI app layout |
| `EXTRA_APPLICATION_CONNECT_RECEIVER_ACTION` | String | An intent to call when the car has connected |
| `EXTRA_APPLICATION_DISCONNECT_RECEIVER_ACTION` | String | An intent to call when the car has disconnected |

### Content Provider

Each CarAPI app implements the Android ContentProvider interface, from which BMW Connected fetches the app's SAS Certificate and any extra RHMI Resources. BMW Connected looks for a `.provider` module inside the Application ID, for example `content://com.spotify.music.provider`, and checks that `getType` returns `assets_provider`. It then tries to load the SAS Certificate, which must contain a Subject CN that matches the Application ID. After authenticating to the car with it, BMW Connected then begins loading RHMI resources from the CarAPI app.

For example, if the Application ID is `com.spotify.music`, then the following calls should be implemented:

1. `getType("content://com.spotify.music.provider")` should return `"assets_provider"`
2. `openAssetFileDescriptor("content://com.spotify.music.provider/carapplications/com.spotify.music/com.spotify.music.p7b")` to return the app certificate
3. `openAssetFileDescriptor("content://com.spotify.music.provider/carapplications/com.spotify.music/rhmi/ui_description.xml")` if the app doesn't want to use the default provided layouts
4. `openAssetFileDescriptor("content://com.spotify.music.provider/carapplications/com.spotify.music/rhmi/bmw/images.zip")`
5. `openAssetFileDescriptor("content://com.spotify.music.provider/carapplications/com.spotify.music/rhmi/bmw/texts.zip")`
6. `openAssetFileDescriptor("content://com.spotify.music.provider/carapplications/com.spotify.music/rhmi/mini/images.zip")`
7. `openAssetFileDescriptor("content://com.spotify.music.provider/carapplications/com.spotify.music/rhmi/mini/texts.zip")`
8. `openAssetFileDescriptor("content://com.spotify.music.provider/carapplications/com.spotify.music/rhmi/common/images.zip")`
9. `openAssetFileDescriptor("content://com.spotify.music.provider/carapplications/com.spotify.music/rhmi/common/texts.zip")`

### App Startup

After BMW Connected connects to the car, it begins to add these third-party apps to the car. It only starts up Radio and Multimedia categorized apps if the car is connected over Bluetooth.

The Connected app iterates through each Connected Ready app and digs the app certificate out of the Content Provider. This app cert is passed through the SecurityModule to add in some extra BMW certs. At this time, the cert's CN is verified against the app's package name. Then the app is used to `sas_certificate` and `sas_login`.
