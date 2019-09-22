---
layout: page
title: Speech API
permalink: /speech/
---

The car system has a cohesive Speech API, providing Text-To-Speech, Dictation, and Recording. A ui\_description.xml file can have a set of `<linkAction>` elements with an `actionType` of readout, dictate, or record, and the `linkModel` points to a model with some parameters. There are some `<actionEvent>` elements that have a reference from an `action` parameter to these `<linkAction>` elements.

After setting up the model with the appropriate data, the related `<actionEvent>` should be triggered with `rhmi_triggerHMIEvent()` with args of `{0:null}`.

## Readout

There are two `<linkAction actionType="readout">` objects, and they point to two different `raListModel` objects. The event that points to the first linkAction is used to trigger general commands (let's call it Command Event), and the event that points to a second linkAction is used to start the actual readout (let's call it Start Event).

Basic TTS is very easy. The `linkModel` from the second `linkAction[actionType=readout]` is updated with a list with 2 columns and 1 row: The first column holds the text to read, and the second column is a name that will show up in progress report callbacks. Then, the `actionEvent` that refers to this second `linkAction` is triggered with `rhmi_triggerHMIEvent()` with args of `{0:null}`.

```
sequenceDiagram
participant App as Connected App
participant Car as BMW Car
App ->> Car: rhmi_setModel(startAction.model, ['words to read', 'application name'])
App ->> Car: rhmi_triggerHMIEvent(startEvent, {0:null})
Car ->> App: cds_onPropertyChangedEvent(cdsHandle, 113, "hmi.tts", {"TTSState": {}})
```
{: class="mermaid"}

After the car has started reading out the text, the Command Event can be used to control the playback. Progress can be monitored through the [CDS system]({% link cds.md %}), as the car updates the `hmi.tts` data..

```
sequenceDiagram
participant App as Connected App
participant Car as BMW Car
App ->> Car: rhmi_setModel(controlAction.model, ['STR_READOUT_PAUSE', 'application name'])
App ->> Car: rhmi_triggerHMIEvent(commandEvent, {0:null})
Car ->> App: cds_onPropertyChangedEvent(cdsHandle, 113, "hmi.tts", {"TTSState": {}})
```
{: class="mermaid"}

The known commands are:

  - STR\_READOUT\_PAUSE
  - STR\_READOUT\_STOP
  - STR\_READOUT\_PREV\_BLOCK
  - STR\_READOUT\_NEXT\_BLOCK
  - STR\_READOUT\_JUMP\_TO\_BEGIN

The TTSState object has some interesting data, which may be useful when controlling playback:

  - `state` is a value from 0 to 4, representing the following values: UNDEFINED, IDLE, PAUSED, ACTIVE, BUSY
  - `currentblock` shows the current playback progress. This is observed to be `-2` while it is parsing the text and the state is `BUSY`, `-1` when the state flips to `ACTIVE` but before it has started outputting audio, and then counts up from 0 to the `blocks` count.
  - `blocks` is the number of total blocks to read out
  - `type` is the name given by the app, as the second column of the RaListModel that was sent to be read
  - `languageavailable` shows `1` for English

