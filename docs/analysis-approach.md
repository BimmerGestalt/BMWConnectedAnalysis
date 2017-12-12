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

Android apps are packaged in renamed zip files, and the actual class files are easy to convert out of the files names `classes.dex` and `classes2.dex`. Once the dex files are converted to jar files, decompilation tools such as [cfr](http://www.benf.org/other/cfr/) can be used to decompile the apps back to readable Java source files. This can then be imported into Android Studio, which is very helpful when deobfuscating member names. Strangely, BMW Connected Classic has more obfuscation than the new BMW Connected app.

### App Metadata

Inside the BMW Connected app's APK, the AndroidManifest.xml lists out several broadcast intents that are entrypoints into the app, pointing directly to very interesting classes.
