# NCGD-TES3MP

Requires [DataManager](https://github.com/tes3mp-scripts/DataManager)!

A server-side lua implementation of [Natural Character Growth And Decay - MW](https://www.nexusmods.com/morrowind/mods/44967) for TES3MP.  Highly configurable, no client-side plugin is required.

## Installation

1. Place this repo into your `CoreScripts/scripts/custom/` directory.

1. Add the following to `CoreScripts/scripts/customScripts.lua`:

        require("custom/ncgd-tes3mp/main")

1. Optionally configure NCGD by editing the `CoreScripts/data/custom/__config_ncgdTES3MP.json` file (see below).

## Configuration

* Attribute modifiers

Each attribute modifier is fully configurable.  Look for the `modifiers` key in the config file and edit to suit your needs.  The defaults 100% mirror the original NCGD.

* Skill Attributes

An array of strings.  Indicates which attributes are affected by a particular skill's increase.  Default: what's in mwscript NCGD

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
