---
layout: page
title: BMW Connected App Behavior
permalink: /app-behavior/
---

BMW Connected starts up some services and waits for either a USB Accessory connection or a Bluetooth device connection.

### Connected Apps

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

Once it is connected and the [BCL]({{ site.baseurl }}{% link protocol-bcl.md %}) tunnel is established, the main BMW Connected app broadcasts an Android intent encouraging the actual Connected Apps to connect to the tunnel endpoint and begin talking the [Etch]({{ site.baseurl }}{% link protocol-etch.md %}) protocol virtually directly to the car.

The broadcast Intent `com.bmwgroup.connected.accessory.ACTION_CAR_ACCESSORY_ATTACHED` has the following extra attributes:

| Name | Type | Description |
| `EXTRA_BRAND` | String | One of `{bmw|mini|bmwi|all}`, BMW Connected Classic's embedded apps require that this match the app's brand |
| `EXTRA_ACCESSORY_BRAND` | String | One of `{bmw|mini|bmwi|all}` |
| `EXTRA_HOST` | String | `127.0.0.1` The ip address where the Etch proxy is running |
| `EXTRA_PORT` | int | The port where the Etch proxy is running, perhaps `4007` or `4008` |
| `EXTRA_INSTANCE_ID` | int | `-1` |

### Authentication

```
sequenceDiagram
participant App as ConnectedApp
participant Sign as CarSecurityService
participant Car as CarEtchServer
App --> Sign: Binder
App --> Car: Etch
App ->> Sign: initSecurityContext(packageName:String, appName:String)
Note right of Sign: Preloads encrypted cert from SD card based on {packageName}/key.p7b
Sign ->> App: contextHandle:long
App ->> Sign: loadApplicationCert(contextHandle:long)
Sign ->> App: cert:byte[]
App ->> Car: sas_certificate(cert:byte[])
Car ->> App: _result_sas_certificate(challenge:byte[])
App ->> Sign: signChallenge(contextHandle:long, challenge:byte[])
Sign ->> App: response:byte[]
App ->> Car: sas_login(response:byte[])
```
{: class="mermaid"}

Each of these Connected Apps is associated with an individual P7B cert bundle. The first thing an app does, after connecting to the Etch service, is send this bundle to the car. The car returns a byte array of challenge data to the app, which must sign the challenge correctly and send it back to the car to authenticate.

In the BMW Connected Classic app, which has undergone the most analysis, it hosts an Android Binder service to provide a signing service for these apps. Each app, when starting the authentication process with the car, first initiates an Binder RPC conversation with `com.bmwgroup.connected.core.services.security.CarSecurityService`. It requests a security context, which loads up the P7B certificate bundle for the application by name and prepares the JNI/NDK security service to be ready to sign. The JNI/NDK service is given the package name, appname, and the cert bundle. After the app receives the security challenge, it asks the `CarSecurityService` to sign the challenge, passing the previously loaded security context and the authentication challenge. The returned signed response is handed directly to the car, to unlock access to the rest of the functionality.

The BMW Connected Classic app, when it starts, extracts all of the APK Resources to the SD card. When written to the SD card, key.p7b file for each Connected App is symmetrically AES encrypted using utility methods in `com.bmwgroup.connected.car.util.CryptoUtil`. When the `CarSecurityService` is requested to load the cert, it checks that `{sdcard}/{applicationName.replaceAll("_", "\\.")}` exists and usually fails to load the cert from `/{packageName.replaceAll("_", "\\.")}/key.p7b` and decrypts the cert. If either of those existence checks fail, it tries to load the cert from within the BMW Connected Classic assetManager, looking up `carapplications/{applicationName}/{applicationName}.p7b`.

The AIDL for the BMW Connected Classic `CarSecurityService` has been reconstructed [here](https://github.com/hufman/BMWConnectedAnalysis/tree/master/aidl/com/bmwgroup/connected/internal/ICarSecurityService.aidl). `createSecurityContext` requires that the given `packageName` is valid for the RPC client. `loadAppCert` returns a cert from somewhere, and doesn't seem to change based on `appName`. `signChallenge` returns the same responses for challenges as seen in packet captures.
