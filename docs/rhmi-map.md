---
layout: page
title: RHMI Map State
permalink: /rhmi-map/
---

IDrive 5 introduced a Map State, which shows a small map and usually a few other widgets such as lists. The RHMI app can use some special RPC commands to prepare and upload a KMZ file into the car, and while this Map State is open, can display the placemarks data from this KMZ file in the mini map. This is used by BMW Connected to provide Gas Station and Parking search results.

## RHMI Map API

The Map API is split into two main parts: Preparing and uploading the KMZ can happen at any time, and showing the KMZ layer and toggling the highlight style requires that a Map State is in the foreground.

```
sequenceDiagram
participant BMWApp as BMW Connected
participant Car as BMW Car
BMWApp ->> Car: map_create()
Car ->> BMWApp: _result_map_create(handle:int)
BMWApp ->> Car: map_initializeImport(handle:int, filename:Str, transferId:int, size:int)
Car ->> BMWApp: _result_map_initializeImport(chunkSize:int)
Car ->> BMWApp: map_onEvent(handle:int, transferId:int, event:MapEvent=MAP_IMPORT_READY)
BMWApp ->> Car: map_importData(handle:int, transferId:int, seq:int, data:byte[])
BMWApp ->> Car: map_importData(handle:int, transferId:int, seq:int, data:byte[])
Car ->> BMWApp: map_onEvent(handle:int, transferId:int, event:MapEvent=MAP_IMPORT_DONE)
BMWApp ->> Car: map_finalizeImport(handle:int, transferId:int)

Note right of BMWApp: User opens the app's map state in the BMW App
BMWApp ->> Car: map_showOverlay(handle:int, filename:Str, overlayId:int)
BMWApp ->> Car: map_setMode(handle:int, mode:MapMode)
BMWApp ->> Car: map_highlight(handle:int, filename:Str, overlayId:int, location:Str)
BMWApp ->> Car: map_hideOverlay(handle:int, filename:Str, overlayId:int)
```
{: class="mermaid"}

The Map Import process firsts prepares the car for importing, and the car responds with the chunk size to send. The car app than repeatedly calls importData to progressively send the data. The car also sends a `map_onEvent` callback to indicate when the car is ready to receive data.

The BMW App drives a significant amount of functionality in this Map State: The KMZ acts only as a structured format to add icons to the car map at specific coordinates. The other list widgets on the Map State are responsible for handling user input, using the `selectAction` to trigger `map_highlight` calls and the `action` to open a further details screen or to trigger the car navigation.

`map_highlight` can be provided with an empty `location` to clear a previous highlight.

There's an additional `map_setMode` function, with a related `MapMode` enum in the Etch IDL. The app calls `map_setMode(MAP_MODE_HIGHLIGHTED_LOCATION)` when highlighting a location and calls `map_setMode(MAP_MODE_ALL_LOCATIONS_WITH_CCP)` when clearing the previous highlight, and this may be related to camera zoom settings.

## KMZ Example

A simulated example KML is presented here, based on the reverse-engineered logic within BMW Connected, but has not been tested in the car. The KMZ zip file contains this KML file, named doc.kml, with other png files included as referenced by the KML file:

```
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
<Folder>
<open>1</open>
<Style id="kmz_poi_normal.png"><IconStyle><Icon><href>kmz_poi_normal.png</href></Icon></IconStyle></Style>
<Style id="kmz_poi_highlight.png"><IconStyle><Icon><href>kmz_poi_highlight.png</href></Icon></IconStyle></Style>
<StyleMap id="f8cd938bc6f6fa2f39172a8f46c03cfbf26b6a07">
<Pair><key>normal</key><styleUrl>#kmz_poi_normal.png</styleUrl></Pair>
<Pair><key>highlight</key><styleUrl>#kmz_poi_highlight.png</styleUrl></Pair>
</StyleMap>
<Placemark id="1">
<name></name>
<styleUrl>#f8cd938bc6f6fa2f39172a8f46c03cfbf26b6a07</styleUrl>
<Point><coordinates>-121.8959279,37.3105937</coordinates></Point>
</Placemark>
</Folder>
</kml>
```

### Folder

KML is organized into Folders, which might correlate to the `map_showOverlay` overlayId. The example implementation only has a single Folder, however.

### Style

There are two Style objects, referencing the icon filenames to be displayed for each placemark. The StyleMap is used by the car, based on the magic strings `normal` and `highlight`, to decide to show specific icons depending on the API's `map_highlight` calls. The app uses this specific styleUrl, but this may just be a constant for easy access from disparate sections of code.

The BMW app only provides a KMZ with a single pair of Style icons, correlated the current map search mode (such as parking or gas). It would seem possible to have many different icons displayed on the map too, perhaps including some creative composition of the [IconStyle](https://developers.google.com/kml/documentation/kmlreference#iconstyle) attributes.

### Placemarks

The KML file then has a series of Placemarks, representing places of interest to show on the map. The `styleUrl` references the above `StyleMap`, and the `Point` specifies the GPS coordinates of where to show the point.

## Testing Limits

Unfortunately, only BMW Connected for Android included Map State functionality. Mini Connected for Android does not include the Map permission in the SAS cert or the Map State in the UI Description, and so I can not verify the reverse-engineered description above in my personal Mini.

Mini Connected for iOS did include this functionality, which may be a possible avenue of exploration if ever iOS certs are able to be used.
