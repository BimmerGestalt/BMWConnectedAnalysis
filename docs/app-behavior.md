---
layout: page
title: BMW Connected App Behavior
permalink: /app-behavior/
---

BMW Connected starts up some services and waits for either a USB Accessory connection or a Bluetooth device connection. After connection, it signals other components and apps to start up and contribute menu entries to the dashboard.

### Connected Apps - Registering

BMW Connected Classic only provides a set of internal apps, and does not provide an official way to add external apps.

In contrast, the new BMW Connected app has a full discovery system to locate companion apps. It seems that [CarAPI]({{ site.baseurl }}{% link carapi.md %}) is the name of the discovery method for external apps, such as Spotify, while ConnectedSDK is the internal one used by apps packaged inside the BMW Connected package.

#### ConnectedSDK

In this discovery method, the main Connected app broadcasts an Intent named `com.bmwgroup.connected.app.ACTION_CAR_APPLICATION_QUERY`, and this Intent has some extras:

| Name | Type | Description |
| `EXTRA_REQUESTED_BRAND` | String | One of `{bmw|mini|bmwi|all}`, probably which Connected app is querying |
| `EXTRA_REQUESTED_APP_TYPE` | String | One of `{row|china|usa|unknown}`, some sort of region locking? |
| `EXTRA_QUERY_REQUESTOR_PKG_NAME` | String | The Connected App's package name, such as de.mini.connected.na |
| `EXTRA_KNOWN_APPS` | String[] | Hardcoded to be an empty list |

This Intent is received elsewhere in the BMW Connected app, which then goes through the packaged carapplications directory to load up the built-in apps.

#### CarAPI

In addition, when the main BMW Connected app starts, it sends out a broadcast intent named `com.bmwgroup.connected.car.app.action.CONNECTED_APP_INSTALLED`, with no attached extras, to solicit responses from any installed Connected Apps.

Connected Apps, such as IHeartRadio for Auto, are listening for this `CONNECTED_APP_INSTALLED` intent, often declared in AndroidManifest.xml as a receiver. When it receives an announcement, it broadcasts an intent in reply: `com.bmwgroup.connected.app.action.ACTION_CAR_APPLICATION_REGISTERING`. Attached to this intent, it sends along an icon and title. This registration intent includes Intent names to be notified on connection and on disconnection. The full list of extras is:

| Name | Type | Description |
| `EXTRA_APPLICATION_CATEGORY` | String | One of `Multimedia|Radio|OnlineServices`, which determines which app template to use |
| `EXTRA_APPLICATION_BRAND` | BrandType enum | One of `{bmw|mini|bmwi|all}`, probably which Connected apps to show in |
| `EXTRA_APPLICATION_ID` | String | A short name for this app |
| `EXTRA_APPLICATION_TITLE` | String | The display name of the app |
| `EXTRA_APPLICATION_APP_ICON` | String | An icon to show in the main app |
| `EXTRA_APPLICATION_VERSION` | String | A version string, such as `v3`, which ties into the RHMI app layout |
| `EXTRA_APPLICATION_CONNECT_RECEIVER_ACTION` | String | An intent to call when the car has connected |
| `EXTRA_APPLICATION_DISCONNECT_RECEIVER_ACTION` | String | An intent to call when the car has disconnected |

### Connected Apps - Car Connection

```
sequenceDiagram
participant App as Connected App
participant BMWApp as BMW Connected
participant Car as BMW Car
BMWApp ->> Car: BT or USB connection
BMWApp ->> Car: BCL knock and handshake
BMWApp -->> App: Intent("com.bmwgroup.connected.accessory.ACTION_CAR_ACCESSORY_ATTACHED")
App ->> BMWApp: TCP Connection
activate BMWApp
App ->> Car: Etch Connection
```
{: class="mermaid"}

Once it is connected and the [BCL]({{ site.baseurl }}{% link protocol-bcl.md %}) tunnel is established, the main BMW Connected app broadcasts an Android intent specifying the tunnel endpoint through which the [Etch]({{ site.baseurl }}{% link protocol-etch.md %}) protocol can be used virtually directly to the car.

The broadcast Intent `com.bmwgroup.connected.accessory.ACTION_CAR_ACCESSORY_ATTACHED` has the following extra attributes:

| Name | Type | Description |
| `EXTRA_BRAND` | String | One of `{bmw|mini|bmwi|all}`, BMW Connected Classic's embedded apps require that this match the app's brand |
| `EXTRA_ACCESSORY_BRAND` | String | One of `{bmw|mini|bmwi|all}` |
| `EXTRA_HOST` | String | `127.0.0.1` The ip address where the Etch proxy is running |
| `EXTRA_PORT` | int | The port where the Etch proxy is running, perhaps `4007` or `4008` |
| `EXTRA_INSTANCE_ID` | int | Defaults to `-1`, the new BMW Connected will always be 12<=id<=14 |

#### CarAPI

External applications using the CarAPI are started with the `EXTRA_APPLICATION_CONNECT_RECEIVER_ACTION` Intent that they previously registered with BMW Connected. This Intent has the following extras:

| Name | Type | Description |
| `EXTRA_COMMAND` | String | `start` |
| `EXTRA_APPLICATION_ID` | String | The registered app ID, which is normally the Android package name |
| `EXTRA_APPLICATION_VERSION` | String | The version provided when the app registered itself |
| `EXTRA_RHMI_VERSION` | String | The RHMI layout version to use, such as `v1`, `v2`, or `v3` |
| `EXTRA_APPLICATION_PKG_NAME` | String | The BMW Connected app's package, such as `de.bmw.connected.na` |
| `address` | String | The BCL tunnel address, usually `127.0.0.1` |
| `port` | int | The BCL tunnel port, such as `4040` |
| `instance_id` | int | The USB port that the car thinks we are attached to |
| `security_service` | int | The Service Intent name to reach the security service, such as `de.bmw.connected.na.SECURITY_SERVICE` |

Notably, CarAPI apps do not connect directly to the Etch proxy port, but instead rely on an Intent-based RPC system to request that Connected manage the connection on their behalf. This RPC system has all the names intact, and may be a useful way to trace high-level behaviors into Etch requests.
