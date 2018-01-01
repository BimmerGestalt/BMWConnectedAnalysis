---
layout: page
title: RHMI Resources
permalink: /rhmi-resources/
---

Each Connected App can upload an XML description of additional menus and windows to add to the iDrive system. These UI Descriptions essentially describe a set of `components`, grouped into pages called `hmiStates`, which present data from `models`. The Connected App, from the phone, presents this description, and then subscribes to event callbacks from user interaction. At any time, the Connected App can update the state of the display.

These UI Description files, and accompanying ImageDBs and TextDBs, are protected from modification by a SHA256 hash that is specified in the Connected app's SAS authentication cert.

For examples, look inside the `assets/carapplications/*/rhmi` directory of any Connected App APK. There is usually a `ui_description.xml` file with an example layout.

## RPC Setup and Interaction

The Connected App first calls `rhmi_create` to begin loading a Remote Human-Machine Interface description into the car's dashboard. Using the returned handle, the app uses `rhmi_setResource` to upload the XML layout describing the new menu functionality, a zip file of translated strings, a zip file of icons, and some other data. To save time, the app can use `rhmi_checkResource` to validate that the car's cache has the correct TextDB and ImageDB from previous launches. The app uses `rhmi_addActionEventHandler` and `rhmi_addHmiEventHandler` to establish callbacks from user interactions, and can use `rhmi_setData` and `rhmi_setProperty` to change the displayed information dynamically.

## UI Description

The main XML layout file, termed `DESCRIPTION`, is broken into several parts. The top level element is `<pluginApps>`, and contains several `<pluginApp>` nodes. Each `pluginApp` has some high-level descriptive attributes, including `applicationType` or `applicationType`, `text="basecore"` and `applicationWeight="500"`. Each `pluginApp` node contains a set of child nodes named `actions`, `models`, `events`, and `hmiStates`. There can also be a single `entryButton` element to describe the icon used to enter the application, and an `instrumentCluster` element to populate the three-line display in the instrument cluster.

`entryButton` attributes:

- id
- action - What action should be triggered when selected
- model - The label text for this menu entry
- imageModel - The menu entry's icon

`pluginApp` types:

- OnlineServices
- radio
- Addressbook

### Actions

Each app defines a big list of `<actions>` at the top, containing multiple childs of the following types. These events are referenced in the later sections.

- `<raAction>` is just a plain callback from a component
- `<combinedAction>` contains both an `<raAction>` and an `<hmiAction>` with a `targetModel` attribute
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


### Models

Next is a list of `models`, which define structured locations for the app to provide data. Each model has a unique `id` which is referenced in the `rhmi_setData` call

- `<raIntModel>` can have a starting `value` attribute
- `<raDataModel>`, can have an optional `modelType` attribute of: `Info`, `Address`, `Phonenumber`
- `<raListModel>`, can have an optional `modelType` attribute of: `Richtext`, `EntICDetails`, `EntICPlaylist`
- `<raImageModel>`
- `<raGaugeModel>`, with the following attributes:
    - `modelType="Progress"`
    - `min="0"`
    - `min="100"`
    - `value="0"`
    - `increment="1"`
- `<imageIdModel>`, an optional `imageId` attribute references a IMAGEDB icon
- `<textIdModel>` can contain a `textId` attribute that references a TEXTDB string, and can have a `speechTextId` attribute
- `<formatDataModel>` contains a `formatString="%0%1"` attribute that combines some inner-nested `<models>` in some way


### HMI States

An RHMI App is split into several different states, which act as windows, and these definitions are found inside `<hmiStates>`. Each main page of the app is described in each `<hmiState>`, and there are also `<popupHmiState>` and `<toolbarHmiState>` specializations. Each `hmiState` has a numeric `id` and a `textModel` attribute.

`hmiState` shows an unadorned screen, while `toolbarHmiState` shows a navigation bar along the left side of the screen. `popupHmiState` can not be the destination of an `hmiAction`.

Each `state` contains a `<components>` node containing nodes to represent each graphical widget, termed a `component`.
States can additionally contain `<properties>` and `<optionComponents>`.

### Components

Every component has an `id` parameter, and the behavior can be modified by these component-specific attributes and properties.

| Name | Attributes | Properties |
| label | `model:textIdModel|raDataModel` | `SELECTABLE` `VISIBLE` `WIDTH` `HEIGHT` `POSITION_X` `POSITION_Y` |
| list | `model:raListModel` `action:raAction` `selectAction:raAction` | `SELECTABLE` `VISIBLE` `LIST_COLUMNWIDTH` |
| button | `model:textIdModel` `tooltipModel:textIdModel` `imageModel:imageIdModel` `action:combinedAction` `selectAction:raAction` | `ENABLED` `SELECTABLE` |
| checkbox | `model:raBoolModel` `textModel:raDataModel` `action:raAction` | `VISIBLE` |
| image | `model:imageIdModel|raImageModel` | `WIDTH` `HEIGHT` `POSITION_X` `POSITION_Y` |
| separator | | |
| gauge | `model:raGaugeModel` `textModel:raDataModel` `action:raAction` `changeAction:raAction` | `WIDTH` `HEIGHT` `POSITION_X` `POSITION_Y` |

Note that the `image` component does not do any image resizing, and will just crop the image. The mobile app must handle any resizing.

#### Component Properties

Inside each `component` can be found a `<properties>` with a list of `<property>` nodes. Each node has an `id` attribute from the following table, with a `value` attribute with the setting. Different properties interpret the `value` differently, most are `true` or `false`.

These definitions are found in `com.bmwgroup.connected.internal.ui.RhmiPropertyType`

| ID | Name | Example Values |
| 1 | `ENABLED` | `true` `false` |
| 2 | `SELECTABLE` | `true` `false` |
| 3 | `VISIBLE` | `true` `false` |
| 4 | `VALID` | |
| 5 | `TOOLBARHMISTATE_PAGING` | |
| 6 | `LIST_COLUMNWIDTH` | `57,100,*` |
| 7 | `LIST_HASIDCOLUMN` | |
| 8 | `LABEL_WAITINGANIMATION` | |
| 9 | `WIDTH` | `320` |
| 10 | `HEIGHT` | `240` |
| 11 | `TERMINALUI_VIDEOVIEWPORT` | |
| 12 | `TERMINALUI_SCREENVIEWPORT` | |
| 13 | `TERMINALUI_FULLSCREEN` | |
| 14 | `TERMINALUI_AUDIOMODE` | |
| 15 | `TERMINALUI_VIDEOMODE` | |
| 16 | `TERMINALUI_LEAVE` | |
| 17 | `ALIGNMENT` | |
| 18 | `OFFSET_X` | |
| 19 | `OFFSET_Y` | |
| 20 | `POSITION_X` | `0` |
| 21 | `POSITION_Y` | `0` |
| 22 | `BOOKMARKABLE` | |
| 23 | `SPEAKABLE` | |
| 24 | `HMISTATE_TABLETYPE` | `3` |
| 25 | `CURSOR_WIDTH` | |
| 26 | `HMISTATE_TABLELAYOUT` | |
| 35 | `TOOLBARHMISTATE_PAGING_LIMITED` | |
| 36 | `SPEEDLOCK` | |
| 37 | `CUTTYPE` | `0` |
| 38 | `TABSTOPOFFSET` | |
| 39 | `BACKGROUND` | |
| 40 | `TERMINALUI_REGISTER_INPUTEVENT` | |
| 41 | `TERMINALUI_DEREGISTER_INPUTEVENT` | |
| 42 | `LIST_RICHTEXT_MAX_ROWCOUNT` | |
| 43 | `LIST_RICHTEXT_LAST_LINE_WITH_THREE_DOTS` | |
| 44 | `TERMINALUI_SET_CONTRAST` | |
| 45 | `TERMINALUI_SET_BRIGHTNESS` | |
| 46 | `TERMINALUI_SET_COLOR` | |
| 47 | `TERMINALUI_SET_TINT` | |
| 48 | `TERMINALUI_STATUSBAR` | |
| 49 | `TERMINALUI_VIDEOVISIBLE` | |
| 50 | `TERMINALUI_SET_TUIMODE` | |
| 51 | `GET_VALUES` | |
| 52 | `TERMINALUI_SET_TUIUSER` | |
| 53 | `CHECKED` | |
| 55 | `UUID` | |
| 56 | `MODAL` | |

Some properties, such as `POSITION_X` and `POSITION_Y`, can contain a child node `<condition conditionType="LAYOUTBAG">`. This is perhaps to support dynamic positioning based on the size of the viewport. For example:

    <properties>
        <property id="20" value="0">
            <condition conditionType="LAYOUTBAG">
                <assignments>
                    <assignment conditionValue="0" value="361"/>
                    <assignment conditionValue="1" value="2000"/>
                    <assignment conditionValue="2" value="361"/>
                    <assignment conditionValue="3" value="2000"/>
                </assignments>
            </condition>
        </property>
    </properties>

It seems that `conditionValue="0"` or `conditionValue="2"` is triggered when the right sidebar is not displayed, and `conditionValue="1"` or `conditionValue="3"` is triggered when the right sidebar is visible.
