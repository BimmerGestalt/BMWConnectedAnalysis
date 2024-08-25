---
layout: page
title: BMW Connected Authentication
permalink: /authentication/
---


### Authentication

```
sequenceDiagram
participant App as ConnectedApp
participant Sign as CarSecurityService
participant Car as CarEtchServer
App --> Sign: Binder
App --> Car: Etch
App ->> Sign: initSecurityContext(packageName:String, appName:String)
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

Each Connected App has an individual P7B cert bundle. The first thing an app does, after connecting to the Etch service, is send this bundle to the car. The car returns a byte array of challenge data to the app, which must sign the challenge correctly and send it back to the car to authenticate.

#### BMW Connected App for Android behavior

The BMW Connected app (until version 5.1) exports an Android Binder service to provide an application cert and a signing service for these challenges. Each app, when starting the authentication process with the car, first initiates an Binder RPC conversation with this provided service. The service name is always the `.SECURITY_SERVICE` class inside the main BMW Connected package, such as `com.bmwgroup.connected.bmw.usa.SECURITY_SERVICE` for BMW Connected Classic or `de.bmw.connected.na.SECURITY_SERVICE` for the new BMW Connected, and is explicitly broadcasted to CarAPI apps. The app then requests a security context, which loads up the P7B certificate bundle for the application by name and prepares the JNI/NDK library to be ready to sign. The JNI/NDK library is given the package name, appname, and the cert bundle. After the app receives the security challenge, it asks the `CarSecurityService` to sign the challenge, passing the previously loaded security context and the authentication challenge. The returned signed response is handed directly to the car, to unlock access to the rest of the functionality.

The AIDL for the BMW Connected `CarSecurityService` has been reconstructed [here](https://github.com/hufman/BMWConnectedAnalysis/tree/master/aidl/com/bmwgroup/connected/internal/ICarSecurityService.aidl). `createSecurityContext` requires that the given `packageName` is valid for the RPC client. `loadAppCert` returns a cert from somewhere, and doesn't seem to change based on `appName`. `signChallenge` returns the same responses for challenges as seen in packet captures, and isn't dependent on previous setup values.

Since Connected 5.1 and MyBMW no longer export this service, an alternative method needs to be used.

#### Certificate Details

Within the P7B bundle that is sent to the car, there are two special certificates. These certificates have a special X509v3 extension with the OID of 1.3.6.1.4.1.513.59.4.1 or 1.3.6.1.4.1.513.59.4.2, storing a basic IA5String with an ampersand-separated list of key-value pairs:

```
$ openssl pkcs7 -print_certs -noout -text -in bundle.p7b  | grep -A1  1.3.6.1.4.1.513.59.4.[12]
            1.3.6.1.4.1.513.59.4.2:
                ...SAS.CertificateType=APP_AUTH&app.device_platform=Android&AVS=false&CDS=true&RHMI=false&Make=BMW&SAS.Digests.RHMIDescriptions=0&SAS.Digests.ImageDatabases=0&SAS.Digests.TextDatabases=0
--
            1.3.6.1.4.1.513.59.4.2:
                ...9SAS.CertificateType=APP&app.device_platform=Android&AVS=true&CDS=true&RHMI=true&Make=MINI&SAS.Digests.RHMIDescriptions=2cba25a16fa36f849e053657876961c2d50808a5238de4383d638008bc1324d3,d29028f7830d353fedbf7e03635292c4b2e0a9f0189b1270e3bbe624a4136983&SAS.Digests.ImageDatabases=fe019ca268693d7b5d555279a704aaf58b2370be1dba9d51a54e27e0a471e10a&SAS.Digests.TextDatabases=d7f27e5e22dc1677e64f7150f9a148cbd89e7219fe09eb38bd0385004965c78d
```

One of the certs must have the string `SAS.CertificateType=APP_AUTH`, and this certificate holds the public key that is used for the `signChallenge` response. The other cert must have the string `SAS.CertificateType=APP`, and this cert holds other permissions relevant to the rest of the connection.
Some very important permissions are the ones starting with `SAS.Digests`. These contain the comma-separated list of SHA256 checksums of the resources that the RHMI app is allowed upload. This check is enforced by `CRHMIAuthPermHandler::verifyResource` in libhmiremoting.so in the headunit.
Another important permission is `Make`, which is a comma-separated list of car brands that will accept this cert for authentication. For example, all known RHMI app certs have either BMW or MINI, but the Toyota Supra only accepts certs with a Make of J29. This check can be disabled by coding `ENTWICKLER_MENUE=aktiv`.

Typically, the APP cert is bundled with the 3rd-party application, and Connected internally merges it with the APP\_AUTH cert when connecting to the car and authenticating on the app's behalf.

#### Challenge and Response

After presenting the certificate in `sas_certificate`, the car will respond with a byte[16] challenge, and the client is expected to send the correct response to `sas_login(byte[512])`. First, the little-endian uint32 representing 2 is passed through MD5, and this is xor'd with the challenge ([xcat.py](https://github.com/mstrand/xcat/blob/master/xcat.py) is convenient for this example). The result is RSA-signed using the MD5 digest type and the key from the `APP_AUTH` certificate above (or the only given cert, for older certs without CertificateType).

```
$ echo -en "$challenge" | xcat.py -x `echo -en '\x02\x00\x00\x00' | openssl dgst -md5 -r | cut -c1-32` | openssl dgst -md5 -sign connection.key -hex
```
