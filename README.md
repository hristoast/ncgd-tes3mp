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

## Differences from MWscript NCGD

* No mastery effects; skills can raise to whatever the server max values are without them.
* Scripts are not ran every frame or tick, but when `OnPlayerSkill` fires (among other events used).
* There are no in-game player dialogue GUIs, and there is currently no way to migrate a non-NCGD player.
* Decay rates are gotten from an individual player's in-game hours spent playing, not the total world time that's passed.
* This version is highly configurable; almost every value that matters is tweakable (see below).
* Optional decay acceleration when a player dies, that is optionally stackable if they keep dying (see below).
* In-game chat commands for recalculating things on the fly.  Optionally for admins only (see below).
* No client plugin is needed.

## Commands

Several commands are offered for recalculating data on the fly:

* `/ncgd health`: Recalculates health (shortcut: `h`)
* `/ncgd recalcattrs`: Recalculates all attributes from skill values (shortcut: `a`)
* `/ncgd reloadskilldata`: Reloads NCGD's internal skill numbers from player data (shortcut: `s`)
* `/ncgd all`: All of the above, in one

All commands have a configurable cooldown (see below).

## Configuration

* Attribute modifiers

Each attribute modifier is fully configurable.  Look for the `modifiers` key in the config file and edit to suit your needs.  Default: what's in mwscript NCGD

* Skill Attributes

An array of strings.  Indicates which attributes are affected by a particular skill's increase.  Default: what's in mwscript NCGD

* `attributeCapMsg`

String.  Message that's displayed to players when they reach the server's attribute cap.  The string is passed to `string.format()` with an attribute name as an argument.  Default: `Your %s is being limited by otherworldly forces...`

* `cmdCooldown`

Integer.  The number of seconds between commands.  Default: `30`

* `deathDecay.enabled`

Boolean.  Enables a period of accelerated decay after death.  Default: `true`

* `deathDecay.durationHrs`

Integer.  The number of real world hours accelerated decay caused by death will last.  Default: `1`

* `deathDecay.modifier`

Integer.  The default decay rate is multipled by this value after death.  Default: `2`

* `deathDecay.stack`

Boolean.  Controls whether decay acceleration will be stacked if multiple deaths occur before the duration expires.  Default: `false`

* `decayMinLvl`

Integer.  The minimum level a skill can decay to.  Default: `15`

* `decayRate`

String.  Set the rate of skill decay: `fast`, `standard`, `slow` or `none`.  Default: `fast`

* `decayRates.*`

Integer.  Control the weight of each decay level.  Default: `0`, `1`, `2`, and `3` for `none`, `slow`, `standard`, and `fast`, respectively.

* `forceLoad*`

Boolean.  Force load the related event hook for this mod in the event another one has disabled custom hooks.  Default: `false`

* `growthRate`

String.  Set the rate of attribute growth:  `fast`, `standard`, or `slow`.  Default: `slow`

* `growthRates.*`

Integers.  Control the weight of each growth level.  Default: `1`, `2`, and `3` for `slow`, `standard`, and `fast`, respectively.

* `healthMod`

Boolean.  Set whether or not health modifications should be applied.  Default: `true`

* `levelCap`

Integer.  Set whether or not a level cap should be applied, `0` to disable.  Default: `0`

* `levelCapMsg`

String.  Message that's displayed to players when they reach the level cap.  Default: `Your level is being held back by otherworldly forces...`

* `rankErr`

String.  Message that's displayed to players when they try to use a command but lack the required rank.  Default: `This command requires admin privileges!`

* `reqRank`

Integer.  The player rank that's required to use commands.  Default: `2`
