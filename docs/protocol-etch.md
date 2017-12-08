---
layout: page
title: BMW Etch RPC
permalink: /etch/
---

Once the main BMW Connected app has connected to the car, individual Connected Apps connect to the car through the BMW Connected BCL tunnel. Each app virtually communicates directly to the car, with the main BMW Connected app only provides basic relaying functionality.

The protocol that these Connected Apps use is based on Apache Etch RPC, using an IDL compiled down to normal RPC stubs and proxies.
The Apache Etch wire protocol only stores hashes of any function or argument symbols, so the Etch compiler also produces an `ewh` file which can be used by Wireshark to more conveniently analyze packet captures. One such `ewh` file has been recreated based on examining the BMW Connected app, and is available [here](https://github.com/hufman/wireshark_bmw_bcl/blob/master/BMW%20BCL.ewh).

The first thing an app does after connecting is call `sas_certificate(byte[] p7b)`, providing its BMW-signed app-specific cert. The car returns a `byte[] challenge`, observed to be 16 bytes long. The app then calls `sas_login(byte[] response)`, with some data that looks the right size to be an RSA4096 signature.

