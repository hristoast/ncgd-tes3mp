# NCGD-TES3MP

A server-side lua implementation of [Natural Character Growth And Decay - MW](https://www.nexusmods.com/morrowind/mods/44967) by Greywander, for TES3MP.

Features:

* Requires [DataManager](https://github.com/tes3mp-scripts/DataManager)!
* Your attributes grow automatically as your skills increase.
* Leveling happens automatically as attributes increase.
* Attribute modifier numbers and skill attributes (which skills increase which attributes) are fully configurable.
* Your attributes, level, and skills will also decay over time. (Optional)
* On death, the decay rate is accelerated. (Optional, with optional effect stacking)

## Installation

1. Place this repo into your `CoreScripts/scripts/custom/` directory.

1. Add the following to `CoreScripts/scripts/customScripts.lua`:

        require("custom/ncgd-tes3mp/main")

1. Optionally configure NCGD by editing the `CoreScripts/data/custom/__config_ncgdTES3MP.json` file (see below).

## Configuration

* Attribute modifiers

Each attribute modifier is fully configurable.  Look for the `modifiers` key in the config file and edit to suit your needs.  Default: what's in mwscript NCGD

* Skill Attributes

An array of strings.  Indicates which attributes are affected by a particular skill's increase.  Default: what's in mwscript NCGD

* `attributeCapMsg`

String.  Message that's displayed to players when they reach the server's attribute cap.  The string is passed to `string.format()` with an attribute name as an argument.  Default: `Your %s is being limited by otherworldly forces...`

* `deathDecay.enabled`

Boolean.  Enables a period of accelerated decay after death.  Default: `true`

* `deathDecay.durationHrs`

Integer.  The number of real world hours accelerated decay caused by death will last.  Default: `1`

* `deathDecay.modifier`

Integer.  The default decay rate is multipled by this value after death.  Default: `2`

* `deathDecay.stack`

Boolean.  Controls whether decay acceleration will be stacked if multiple deaths occur before the duration expires.  Default: `false`

* `decayRate`

String.  Set the rate of skill decay: `fast`, `standard`, `slow` or `none`.  Default: `fast`

* `forceLoad*`

Boolean.  Force load the related event hook for this mod in the event another one has disabled custom hooks.  Default: `false`

* `growthRate`

String.  Set the rate of attribute growth:  `fast`, `standard`, or `slow`.  Default: `slow`

* `healthMod`

Boolean.  Set whether or not health modifications should be applied.  Default: `true`

* `levelCap`

Integer.  Set whether or not a level cap should be applied, `0` to disable.  Default: `0`

* `levelCapMsg`

String.  Message that's displayed to players when they reach the level cap.  Default: `Your level is being held back by otherworldly forces...`
