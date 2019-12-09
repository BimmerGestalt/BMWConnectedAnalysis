---
layout: page
title: RHMI Events
permalink: /rhmi-events/
---

## RHMI Events and Actions

Another important aspect of a UI system is responding to user interaction. The iDrive system organizes user-initiated events into two broad categories, RA Actions and HMI Events. RA Actions are more-directly initiated by the user, such as scrolling through a list or clicking the iDrive controller. HMI Events are more general, such as when an HMI window becomes visible or a component gains focus. HMI Events also trigger more system-wide events, such as setting the currently-playing app name.

### Actions

Each app defines a big `<actions>` list inside a `<pluginApp>`, containing multiple childs of the following types. These events are referenced by various components in the app.

- `<raAction>` is just a plain callback from a component
- `<combinedAction>` contains both an `<raAction>` and an `<hmiAction>`, usually with a `targetModel` attribute
- `<linkAction>` which can contain an `actionType` attribute such as `navigate` or `call`, along with a `linkModel` attribute
- `<hmiAction>` contains a `targetModel` attribute, and that model contains an ID of a `State` to show

A common paradigm looks like:

    <combinedAction id="381" sync="true">
        <actions>
            <raAction id="382"/>
            <hmiAction id="383" targetModel="384"/>
        </actions>
    </combinedAction>

Somewhere in the list of `toolbarComponents` or the `entryButton`, there is an `action="381"`. When that button is pressed, the phone app will receive an `rhmi_onActionEvent` callback where the actionId=382 (from the `raAction`). Now, the app will call `rhmi_setData` and pass `model=384, value=16` to update the related `<raIntModel id="384">` to the desired `hmiState` (in this case, id="16") that should be shown. When the app finishes handling the event by calling `rhmi_ackActionEvent`, the iDrive will present the chosen `hmiState`.
A variation of this uses an `hmiAction` with a `target` instead of a `targetModel`. This target refers directly to an `hmiState` by ID, instead of pointing to a `raIntModel` that holds the hmiState's ID.

### Triggerable HMI Events

Each `<pluginApp>` also contains a `<events>` node with some unique functonality. These `events` each have an ID, which is passed to `rhmi_triggerEvent` to trigger associated functionality.

- `<actionEvent>` contains an `action` attribute with the ID of a `<linkAction>` to trigger. This can be used to start navigation or a phonecall.
- `<focusEvent>` contains a `targetModel` attribute, which is ignored. The args object in the `rhmi_triggerEvent` command will have `{0:ID}` with the ID of the component to focus on. This can be used to focus on other states within the app without the user triggering a `<combinedAction>`
- `<multimediaInfoEvent>` contains both a `textModel1` and a `textModel2` attribute. This sets the song title and artist that is seen in the instrument cluster, and perhaps other places.
- `<notificationIconEvent>` contains an `imageIdModel`, which sets the system-wide icon depicting the currently-playing music source.
- `<popupEvent>` contains a `target` `<popupHmiState>` to show and a `priority` to enforce order
- `<statusbarEvent>` contains a `textModel` attribute. When this event is triggered, the textModel is copied to the system-wide label with the currently-playing app

The events require a Map to be passed, but generally it is sufficient to be merely `{0:null}`. One exception is the `<notificationIconEvent>`, which needs to be passed `{0:true}`.

#### Displaying a popup

1. Locate the `<popupEvent>` event. This event has a `target` attribute pointing to a `<popupHmiState>` by ID.
2. Trigger the popupEvent with '{0:true}' to show it, and '{0:false}' to hide it.

#### Updating a list's selected index

1. Locate the `<focusEvent>` event from the UI Description, and note the `id` attribute as the `eventId`
2. Prepare a map of params that looks something like `{0:[listId], 41:[selectedListIndex]}`
3. Call `rhmi_triggerHMIEvent(appHandle, eventId, params)`

#### Begin navigation

1. Locate the `<actionEvent>` that points to a `<linkAction actionType="navigate">` by ID.
2. The linkAction's `linkModel` attribute points to a `<raDataModel modelType="Address">`.
3. Set this `linkModel` to the destination address, formatted in this style: `[lastName];[firstName];[street];[houseNumber];[zipCode];[city];[country];[latitude];[longitude];[poiName]`. The latitude and longitude are formatted by calculating the degrees divided by 360 multiplied by INT\_MAX.
4. Trigger the actionEvent with '{0:null}' to begin the navigation.

### Received HMI Events

The app can also receive a set of HMI Events through `rhmi_onHmiEvent` at any time. These events are generally associated with global widget state, such as a HMIState becoming visible, or a component gaining focus. The events have an rhmi `handle`, a relevant `componentId`, an `eventId` from the following table, and a map of `args`.

| Event Id | Event Name | Example args |
| 1 | `FOCUS` | `{4: False}` |
| 2 | `REQUESTDATA` | `{5: 0, 6: 1}` |
| 3 | `APPLICATION_INIT` | |
| 4 | `INTEGRATION_ERROR` | |
| 5 | `AUDIOCHANNEL` | |
| 6 | `VIDEOCHANNEL` | |
| 7 | `SPLITSCREEN` | |
| 8 | `APPLICATION_RELEASE` | |
| 9 | `KEYCODE` | |
| 10 | `INTERNETCONNECTION` | |
| 11 | `VISIBLE` | `{23: True}` |
| 12 | `RESTORE_HMI` | |
| 13 | `RESTORE_AUDIO` | |
| 14 | `MOVIES_PERMISSION` | |
| 15 | `VIDEO_CONTRAST` | |
| 16 | `VIDEO_BRIGHTNESS` | |
| 17 | `VIDEO_COLOR` | |
| 18 | `VIDEO_TINT` | |
| 19 | `TUIMODE` | |

### Received Event Arguments

The args that are received along with an RA Event or an HMI Event use parameter IDs from the following table.

HMIEvent parameters can also be found in triggerHMIEvent calls.

| Param Id | Param Name |
| -1 | `PARAM_INVALID` |
| 0 | `PARAM_VALUE` |
| 1 | `ACTION_PARAM_LISTINDEX` |
| 2 | `ACTION_PARAM_SELECTEDVALUE` |
| 3 | `ACTION_PARAM_CHECKED` |
| 4 | `HMIEVENT_PARAM_FOCUS` |
| 5 | `HMIEVENT_PARAM_REQUESTDATA_FROM` |
| 6 | `HMIEVENT_PARAM_REQUESTDATA_SIZE` |
| 7 | `HMIEVENT_PARAM_SPLITSCREEN` |
| 8 | `ACTION_PARAM_SPELLER_INPUT` |
| 10 | `ACTION_PARAM_SKIP` |
| 11 | `ACTION_PARAM_KEYCODE_VALUE` |
| 12 | `ACTION_PARAM_KEYCODE_PRESSED` |
| 13 | `ACTION_PARAM_KEYCODE_LONG` |
| 20 | `ACTION_PARAM_KEYCODE` |
| 21 | `HMIEVENT_PARAM_CHANNELSTATUS` |
| 22 | `HMIEVENT_PARAM_CONNECTION_STATUS` |
| 23 | `HMIEVENT_PARAM_VISIBLE` |
| 24 | `HMIEVENT_PARAM_MOVIES_PERMISSION` |
| 25 | `HMIEVENT_PARAM_TUIMODE` |
| 26 | `SETPROPERTY_PARAM_X` |
| 27 | `SETPROPERTY_PARAM_Y` |
| 28 | `SETPROPERTY_PARAM_WIDTH` |
| 29 | `SETPROPERTY_PARAM_HEIGHT` |
| 30 | `SETPROPERTY_PARAM_BEGIN` |
| 31 | `SETPROPERTY_PARAM_END` |
| 32 | `AUDIOMODEPROPERTY_PARAM_ACTIVE` |
| 33 | `AUDIOMODEPROPERTY_PARAM_INSTID` |
| 40 | `ACTION_LOCATION_INPUT` |
| 41 | `HMIEVENT_PARAM_LISTINDEX` |
| 42 | `ACTION_PARAM_SELECTIONTEXT` |
| 43 | `ACTION_PARAM_INVOKEDBY` |
