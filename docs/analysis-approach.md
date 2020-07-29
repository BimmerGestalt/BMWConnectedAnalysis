---
layout: page
title: Analysis Approach
permalink: /analysis-approach/
---

BMW Connected exposes several analysis methods. Nothing is encrypted, which makes investigation very easy.

### Packet Capture - Bluetooth

On the Android platform, the Developer Options menu contains a setting named `Enable Bluetooth HCI snoop log`. [Enabling this](https://blog.bluetooth.com/debugging-bluetooth-with-an-android-app) will cause a btsnoop.log file to be generated on the phone containing all traffic to the Bluetooth chipset, which can be opened in Wireshark.

Note: This file's location varies on different devices, and is found in a config file:

```
adb shell "cat /etc/bluetooth/bt_stack.conf | grep FileName"
```

This packet capture will have the raw [BCL]({{ site.baseurl }}{% link protocol-bcl.md %}) traffic over the Bluetooth SPP connection.

### Packet Capture - TCP

Once BMW Connected establishes the BCL connection to the car, it starts a TCP proxy server on the phone, bound to localhost. If the phone is rooted, tcpdump can be used to record the traffic to this TCP Proxy. This is useful for the original Mini Connected, which only communicates over USB, or if Wireshark doesn't have the BCL dissector installed.

### Decompilation

Android apps are packaged in apk files, which are identical to jar files, which are just renamed zip files, and the actual class files are easy to convert out of the files names `classes.dex` and `classes2.dex` using the [dex2jar](https://sourceforge.net/projects/dex2jar/files/) suite of utilities. Once the dex files are converted to jar files, decompilation tools such as [cfr](http://www.benf.org/other/cfr/) can be used to decompile the apps back to readable Java source files, for example by running `java -jar cfr_0_123.jar classes.jar --outputdir "decompilation_output"`. This can then be imported into Android Studio, which is very helpful when deobfuscating member names. Strangely, BMW Connected Classic has more obfuscation than the new BMW Connected app.

### App Metadata

Inside the BMW Connected app's APK, the AndroidManifest.xml lists out several broadcast intents that are entrypoints into the app, pointing directly to very interesting classes.

### Enabling Debug Logging

The BMW Connected apps have a logging infrastructure built in, which is mainly very helpful for deobfuscating function names. However, the logging calls only forward messages to the Android Logger based on a log level condition. BMW Connected Classic has this hard-coded, while the newer BMW Connected is a little more flexible.

Because Android apps can be converted losslessly back to .class files and then back into APK, this conditional logging can be enabled with a minor change. Then, following [this guide](https://blogs.sap.com/2014/05/21/how-to-modify-an-apk-file/), the modified class files can be packaged back into an app and installed instead of the original BMW Connected app.

1. Extract the classes.dex file from the original apk. Note that some APKs have multiple dex archives, but only the one with the desired class file needs to be extracted
2. Use the `d2j-dex2jar` command to convert that dex file to a jar file
3. Locate the class file to be modified, perhaps by using decompilation techniques. For example, BMW Connected Classic's `com.bmwgroup.connected.internal.util.Logger` has a line `private static int h = 7` which specifies the logging threshold. This is a minimum threshold to pass, so 0 would be a good option.
4. Open the file in a classfile editor of your choice, such as dirtyJOE or ce Class Editor.
5. Make the desired changes. In this example, there is a `<clinit>` method that initializes that static field. Assuming some familiarity with Java disassembly, one can identify the `bipush` command to load a constant onto the stack and then `putstatic` command to put that constant int othe class member.
6. Put that modified class file back into the jar file
7. Use `d2j-jar2dex` to convert that jar file back to a classes.dex format
8. Put that classes.dex file back into the APK file
9. Delete the META-INF directory from the APK, to clear out the previous, now invalid, signature.
10. Use jarsigner to generate a signature: `jarsigner -verbose -sigalg MD5withRSA -digestalg SHA1 -keystore <myKeystore> myApp.apk <myKeyAlias>`.

 The above assumes that a keystore already exists, if not run this: `keytool.exe -genkey -v -keystore <myKeystore> -alias <myKeyAlias> -sigalg MD5withRSA -keyalg RSA -keysize 2048 -validity 10000`

However, the app is very chatty! Logcat may start showing messages saying something like: `1799 12017 I logd: uid=10007 chatty ... expire 4 lines`. This means that Android is dropping log messages from this excessively-logging app. To resolve this, run `adb logcat -P ""`.

In the new BMW/Mini Connected app, the default at `com.bmwgroup.connected.logger.Logger.LEVEL` is ignored. Instead, inside `de.bmw.connected.app.BMWOneBaseApplication` or `de.mini.connected.MINIOneBaseApplication`, there is a function named `b()` that calls `this.configureA4A`, and the last integer value to that call specifies a logging level (perhaps set it to 0). Another level of logs opens up if the `isDebug()` and `isDebugRequestExternalWritableStorage()` functions are modified to return true, which enables logging to `/sdcard/connected_app/log`.

Another fun unrelated trick is the `com.bmwgroup.connected.core.am.ApplicationManagerCarApplication.startAllApps()` function, which refuses to enable external audio apps such as Spotify if it thinks it is running over USB. Disabling this check enables full functionality, but perhaps some phones don't support USB Audio output.
