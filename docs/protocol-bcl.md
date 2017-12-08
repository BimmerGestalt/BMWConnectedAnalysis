---
layout: page
title: BMW BCL Tunneling
permalink: /bcl/
---

BMW Connected can connect to the car in multiple ways, such as Bluetooth, USB Accessory, and via the ENET cable. When the app connects to the car, it establishes a TCP server on the handset and announces to content apps to connect to this server to reach the car.

BMW Connected takes car of multiplexing these multiple connections through a single stream connection to the car, using a simple structured encapsulation that is named BCL.

A BCL packet starts out with an 8 byte header, containing 4 fields of 2 byte network-endian unsigned integers. along with up to 4000 bytes of the data from the encapsulated stream.

| Name | Type | Description |
| ---- | ---- | ----------- |
| Command | uint16 | The BCL command that describes the function of this packet |
| Source | uint16 | The connection ID from the phone app |
| Dest | uint16 | The destination service in the car. 0x0FA4 is the Etch RPC service |
| DataLen | uint16 | The size of the remaining data |
{: .protocol }

The most exciting stuff happens in packets where Command=2 and Dest=0x0FA4, which contain [Apache Etch RPC streams]({% link protocol-etch.md %}).

A Wireshark protocol dissector has been created by observing packet captures, and is available [here](https://github.com/hufman/wireshark_bmw_bcl).
