# NCGD-TES3MP

A server-side lua implementation of [Natural Character Growth And Decay - MW](https://www.nexusmods.com/morrowind/mods/44967) for TES3MP.  No client-side plugin is needed.

## Installation

1. Place `ncgdTES3MP.lua` into your `CoreScripts/scripts/custom/` directory.

1. Add the following to `CoreScripts/scripts/customScripts.lua`:

        require("custom/ncgdTES3MP")

1. Optionally configure growth, decay, and other values.

## Configuration

By default, the following is configured:

* Accelerated decay after death (WIP)
* Fast decay rate
  * This can be `nil`, `"slow"`, `"standard"`, or `"fast"`
  * Quotes must be included unless `nil` is set.
* Slow growth rate
  * This can be`"slow"`, `"standard"`, or `"fast"`
  * Quotes must be included.
