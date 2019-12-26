---
layout: page
title: Benefits
permalink: /benefits/
---

The BMW Connected Apps protocol provides some unique features that aren't commonly found in other cars. When compared to the defacto frame buffer standards (Android Auto, Apple CarPlay, MirrorLink), this protocol provides tighter integration and a few extra special advantages.

### Tactile-Driven Interface

As opposed to the touch-screen-driven frame buffer protocols, the IDrive is built around the tactile controller knob. This reduces driver distraction with less focus required for selection inputs.
The remote UI framework is built with these same principles in mind, offering quick navigation through app functionality with the rotary knob.

### Tighter Integration

While a remote frame buffer is usually sequested within a single screen of the car's infotainment system, Connected Apps are much more flexible and have more integration points. Apps can add themselves to a general App menu, or within the Media and Radio sections of the car. Hardware shortcut buttons can deep link to any app, and even to specific screens within each app. Music apps submit song metadata and cover art directly to the car, side-stepping Bluetooth peculiarities.

Apps can trigger car actions, such as starting navigation, calling a contact, or reading out text. Similar to Android Auto, the Connected Calendar app shows upcoming appointments and offers to navigate or call them. However, any app can use these same APIs for new creative uses. For example, the original Connected app could read out new Facebook, Twitter, and RSS posts.

The car map provides an API for any app to add new Points of Interest to navigate to. The main use is for dynamic EV charger information, but it's entirely flexible for any additional information.

Even with this increased flexibility, the API boundary makes it safe for arbitrary third-party apps to add themselves to their designated places, without the risk of interfering with other functionality.

### High-level UI Widgets

As opposed to sending a full-screen frame, each Connected App sends a widget layout and then dynamically updates the contents of the widgets. Aesthetically, this means the car provides its own theme and animations to seamlessly fit the app into the car interface. It also allows for much lower bandwidth usage. In fact, IDrive 5 and 6 can run this protocol over the Bluetooth connection, allowing for wireless convenience without significant power draw.

This allows the car interface to upgrade functionality without needing to modify the apps: The car's Input widget has gained speech-to-text support in IDrive 5, and the entire interface is touch-screen enabled on equipped cars.

### Car Data

The apps running on the phone can also fetch information from the car, as well as displaying information to the user. This unlocks quite a few exciting user experiences: Driving Excitement was an early prototype of the current Sports Displays by showing the car's power output in the dashboard, Green Driving helped train a driver to motor more efficiently, and Dynamic Music played music that swelled in excitement with the driving performance.

### Phone Resource Friendly

This protocol definitely shows signs of evolving on early low-resource phones. The interface supports adding placeholder app icons in the car, which cause the respective app to be launched only after the user picks it. The car's smooth animations increase the responsiveness of the car even while negotiating data with the phone. The architecture allows for other small optimizations, such as sending compressed image and text packs for the car to use in its widget contents, and caching those packs in the car across connections.
