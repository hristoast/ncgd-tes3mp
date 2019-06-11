local ncgdTES3MP = {}

ncgdTES3MP.scriptName = "ncgdTES3MP"

local Agility = "Agility"
local Endurance = "Endurance"
local Intelligence = "Intelligence"
local Luck = "Luck"
local Personality = "Personality"
local Speed = "Speed"
local Strength = "Strength"
local Willpower = "Willpower"

local Acrobatics = "Acrobatics"
local Alchemy = "Alchemy"
local Alteration = "Alteration"
local Armorer = "Armorer"
local Athletics = "Athletics"
local Axe = "Axe"
local Block = "Block"
local Bluntweapon = "Bluntweapon"
local Conjuration = "Conjuration"
local Destruction = "Destruction"
local Enchant = "Enchant"
local Handtohand = "Handtohand"
local Heavyarmor = "Heavyarmor"
local Illusion = "Illusion"
local Lightarmor = "Lightarmor"
local Longblade = "Longblade"
local Marksman = "Marksman"
local Mediumarmor = "Mediumarmor"
local Mercantile = "Mercantile"
local Mysticism = "Mysticism"
local Restoration = "Restoration"
local Security = "Security"
local Shortblade = "Shortblade"
local Sneak = "Sneak"
local Spear = "Spear"
local Speechcraft = "Speechcraft"
local Unarmored = "Unarmored"

local none = "none"
local slow = "slow"
local standard = "standard"
local fast = "fast"

local NO_DECAY = 0
local SLOW_DECAY = 1
local STANDARD_DECAY = 2
local FAST_DECAY = 3

local SLOW_GROWTH = 1
local STANDARD_GROWTH = 2
local FAST_GROWTH = 3

local Attributes = {
   Strength, Intelligence, Willpower, Agility, Speed, Endurance, Personality, Luck
}

local Skills = {
   Block, Armorer, Mediumarmor, Heavyarmor, Bluntweapon, Longblade, Axe, Spear,
   Athletics, Enchant, Destruction, Alteration, Illusion, Conjuration, Mysticism,
   Restoration, Alchemy, Unarmored, Security, Sneak, Acrobatics, Lightarmor,
   Shortblade, Marksman, Mercantile, Speechcraft, Handtohand
}

local NCGD = "NCGD"

ncgdTES3MP.defaultConfig = {
   -- TODO: Configurable attribute skills (e.g. which skills affect which attributes)
   deathDecay = {
      durationHrs = 1,
      enabled = true,
      modifier = 2,
      stacks = false
   },
   decayRate = fast,
   forceLoadOnPlayerAttribute = false,
   forceLoadOnPlayerAuthentified = false,
   forceLoadOnPlayerDeath = false,
   forceLoadOnPlayerDisconnect = false,
   forceLoadOnPlayerEndCharGen = false,
   growthRate = slow,
   modifiers = {
      -- These default values come from the original NCGD.
      Strength = {
         Longblade = 2,
         Bluntweapon = 4,
         Axe = 4,
         Armorer = 0,
         Heavyarmor = 0,
         Spear = 4,
         Block = 2,
         Acrobatics = 0,
         Marksman = 4,
         Handtohand = 4
      },
      Intelligence = {
         Alchemy = 4,
         Enchant = 4,
         Conjuration = 4,
         Alteration = 2,
         Destruction = 2,
         Mysticism = 4,
         Illusion = 2,
         Security = 2,
         Mercantile = 2,
         Speechcraft = 0
      },
      Willpower = {
         Bluntweapon = 2,
         Axe = 0,
         Mediumarmor = 0,
         Athletics = 0,
         Enchant = 2,
         Conjuration = 0,
         Alteration = 4,
         Destruction = 4,
         Mysticism = 2,
         Restoration = 4,
         Unarmored = 2,
         Mercantile = 0,
         Speechcraft = 2
      },
      Agility = {
         Longblade = 4,
         Axe = 2,
         Block = 0,
         Illusion = 0,
         Acrobatics = 2,
         Security = 4,
         Sneak = 4,
         Lightarmor = 0,
         Marksman = 2,
         Shortblade = 4,
         Handtohand = 2
      },
      Speed = {
         Longblade = 0,
         Mediumarmor = 2,
         Heavyarmor = 2,
         Spear = 0,
         Athletics = 4,
         Alteration = 0,
         Unarmored = 4,
         Acrobatics = 4,
         Sneak = 0,
         Lightarmor = 4,
         Marksman = 0,
         Shortblade = 2
      },
      Endurance = {
         Bluntweapon = 0,
         Armorer = 4,
         Mediumarmor = 4,
         Heavyarmor = 4,
         Spear = 2,
         Block = 4,
         Athletics = 2,
         Alchemy = 0,
         Restoration = 0,
         Unarmored = 0,
         Lightarmor = 2,
         Handtohand = 0
      },
      Personality = {
         Armorer = 2,
         Alchemy = 2,
         Enchant = 0,
         Conjuration = 2,
         Destruction = 0,
         Mysticism = 0,
         Restoration = 2,
         Illusion = 4,
         Security = 0,
         Sneak = 2,
         Shortblade = 0,
         Mercantile = 4,
         Speechcraft = 4
      },
      Luck = {
         Acrobatics = 0,
         Alchemy = 0,
         Alteration = 0,
         Armorer = 0,
         Athletics = 0,
         Axe = 0,
         Block = 0,
         Bluntweapon = 0,
         Conjuration = 0,
         Destruction = 0,
         Enchant = 0,
         Handtohand = 0,
         Heavyarmor = 0,
         Illusion = 0,
         Lightarmor = 0,
         Longblade = 0,
         Marksman = 0,
         Mediumarmor = 0,
         Mercantile = 0,
         Mysticism = 0,
         Restoration = 0,
         Security = 0,
         Shortblade = 0,
         Sneak = 0,
         Spear = 0,
         Speechcraft = 0,
         Unarmored = 0
      }
   }
}

ncgdTES3MP.config = DataManager.loadConfiguration(ncgdTES3MP.scriptName, ncgdTES3MP.defaultConfig)

ncgdTES3MP.chargenDone = false

local logPrefix = "[ " .. ncgdTES3MP.scriptName .. " ] : "

local function dbg(msg)
   tes3mp.LogMessage(enumerations.log.VERBOSE, logPrefix .. msg)
end

local function fatal(msg)
   tes3mp.LogMessage(enumerations.log.FATAL, logPrefix .. msg)
end

local function warn(msg)
   tes3mp.LogMessage(enumerations.log.WARN, logPrefix .. msg)
end

local function info(msg)
   tes3mp.LogMessage(enumerations.log.INFO, logPrefix .. msg)
end

local function gameMsg(pid, msg)
   tes3mp.MessageBox(pid, -1, msg)
end

-- local function randInt(rangeStart, rangeEnd)
--    -- THANKS: https://stackoverflow.com/a/20157671
--    math.random()
--    math.random()
--    math.random()
--    return math.random(rangeStart, rangeEnd)
-- end

local function getAttribute(pid, attribute, base)
   dbg("Called \"getAttribute\" for pid \"" .. pid .. "\" and attribute \"" .. attribute .. "\"")
   if base then
      return Players[pid].data.attributes[attribute].base
   else
      return Players[pid].data.attributes[attribute].base - Players[pid].data.attributes[attribute].damage
   end
end

local function setAttribute(pid, attribute, value, save)
   dbg("Called \"setAttribute\" for pid \"" .. pid .. "\" and attribute \""
          .. attribute .. "\" and value \"" .. value .. "\"")
   Players[pid].data.attributes[attribute].base = value
   if save ~= nil then
      Players[pid]:SaveAttributes()
   end
end

local function getPlayerLevel(pid)
   dbg("Called \"getPlayerLevel\" for pid \"" .. pid .. "\".")
   if Players[pid].stats == nil then
      return 1
   else
      return Players[pid].stats.level
   end
end

local function setPlayerLevel(pid, value)
   dbg("Called \"setPlayerLevel\" for pid \"" .. pid .. "\" and value \"" .. value .. "\"")
   if Players[pid].stats == nil then
      -- This must be a new player, just finishing CharGen
      -- TODO: if a player starts out with a level up it doesn't get applied here...
      Players[pid].stats = { ["level"] = 1 }
   end
   Players[pid].stats.level = value
   Players[pid].stats.levelProgress = 0
   Players[pid]:LoadLevel()
end

local function getSkill(pid, skill, base)
   dbg("Called \"getSkill\" for pid \"" .. pid .. "\" and skill \"" .. skill .. "\"")
   if base then
      return Players[pid].data.skills[skill].base
   else
      return Players[pid].data.skills[skill].base - Players[pid].data.skills[skill].damage
   end
end

local function getCustomVar(pid, key)
   dbg("Called \"getCustomVar\" for pid \"" .. pid .. "\" and key \"" .. key .. "\"")

   local player = Players[pid]
   local dataBase = player.data.customVariables[NCGD]

   if dataBase ~= nil then
      return player.data.customVariables[NCGD][key]
   end
   return nil
end

local function setCustomVar(pid, key, val)
   dbg("Called \"setCustomVar\" for pid \"" .. pid .. "\", key \"" .. key .. "\", and value \"" .. val .. "\".")

   local player = Players[pid]
   local dataBase = player.data.customVariables[NCGD]

   if dataBase ~= nil then
      player.data.customVariables[NCGD][key] = val
   end
end

local function getAttributeSkills(attribute)
   dbg("Called \"getAttributeSkills\" on attribute \"" .. attribute .. "\".")
   return ncgdTES3MP.config.modifiers[attribute]
end

local function getGrowthRate()
   dbg("Called \"getGrowthRate\"")
   local growString = string.lower(ncgdTES3MP.config.growthRate)
   if growString == fast then
      return FAST_GROWTH
   elseif growString == standard then
      return STANDARD_GROWTH
   elseif growString == slow then
      return SLOW_GROWTH
   end
end

local function recalculateAttribute(pid, attribute)
   dbg("Called \"recalculateAttribute\" for pid \"" .. pid .. "\" and attribute \"" .. attribute .. "\".")

   local baseAttr = getCustomVar(pid, "base" .. attribute)
   local startAttr = getCustomVar(pid, "start" .. attribute)

   local recalculateLuck = false
   local temp = 0
   local temp2

   for skill, multiplier in pairs(getAttributeSkills(attribute)) do
      local baseSkill = getSkill(pid, skill, true)

      -- This is in leiu of how real NCGD multiplies temp2 against 25 * some mastery value
      temp2 = 0

      temp2 = temp2 + baseSkill
      temp2 = temp2 * temp2

      if multiplier ~= 0 then
         temp2 = temp2 * multiplier
      end

      temp = temp + temp2
   end

   if attribute == Luck then
      temp2 = temp * 2
      temp2 = math.floor(temp2 / 27)
      temp2 = math.floor(math.sqrt(temp2))

      -- TODO: level getting/setting can probably be improved
      if temp2 > 25 then
         temp2 = temp2 - 25
         setPlayerLevel(pid, temp2)

         if temp2 > getPlayerLevel(pid) then
            dbg("Player with pid \"" .. pid .. "\" reached level " .. temp2 .. ".")
            gameMsg(pid, "You have reached Level " .. temp2 .. ".")
         elseif temp2 < getPlayerLevel(pid) then
            dbg("Player with pid \"" .. pid .. "\" decayed to level " .. temp2 .. ".")
            gameMsg(pid, "You have regressed to Level " .. temp2 .. ".")
         end

      else
         if Players[pid].stats ~= nil then
            if getPlayerLevel(pid) > 1 then
               gameMsg(pid, "You have regressed to Level " .. temp2 .. ".")
               setPlayerLevel(pid, 1)
            end
         end
      end
   end

   -- Adjust XP based on growth speed
   temp2 = temp * getGrowthRate()
   temp = math.floor(temp2 / 27)

   -- Converts XP into attributes
   temp2 = math.floor(math.sqrt(temp))
   temp = temp2 + startAttr

   if temp > baseAttr then
      gameMsg(pid, "Your " .. attribute ..  " has increased to " .. temp .. ".")
      if attribute ~= Luck then
         recalculateLuck = true
      end
   elseif temp < baseAttr then
      gameMsg(pid, "Your " .. attribute ..  " has decayed to " .. temp .. ".")
      if attribute ~= Luck then
         recalculateLuck = true
      end
   end

   setAttribute(pid, attribute, temp)
   setCustomVar(pid, "base" .. attribute, temp)
   dbg("Recalculation of attribute \"" .. attribute .. "\" has completed.")

   return recalculateLuck
end

local function initAttribute(pid, attribute)
   dbg("Called \"initAttribute\" for pid \"" .. pid .. "\" and attribute \"" .. attribute .. "\"")

   local startAttr = getAttribute(pid, attribute, true)
   -- Reduces the attribute to account for gain from skills
   startAttr = startAttr / 2

   setCustomVar(pid, "base" .. attribute, startAttr)
   setCustomVar(pid, "start" .. attribute, startAttr)
   setAttribute(pid, attribute, startAttr)

   recalculateAttribute(pid, attribute)
   Players[pid]:LoadAttributes()
end

local function initSkill(pid, skill)
   dbg("Called \"initSkill\" for pid \"" .. pid .. "\" and skill \"" .. skill .. "\"")

   local baseSkill = getSkill(pid, skill, true)
   setCustomVar(pid, "base" .. skill, baseSkill)
   setCustomVar(pid, "start" .. skill, baseSkill)
end

local function getDecayRate()
   dbg("Called \"getDecayRate\"")
   local decayString = string.lower(ncgdTES3MP.config.decayRate)
   -- TODO: DRY this up
   if decayString == fast then
      return FAST_DECAY
   elseif decayString == standard then
      return STANDARD_DECAY
   elseif decayString == slow then
      return SLOW_DECAY
   elseif decayString == none then
      return NO_DECAY
   end
end

local function getAttrsToRecalc(skill)
   dbg("Called \"getAttrsToRecalc\"")
   local toRecalc = {}
   -- TODO: DRY this up by making it configurable
   if skill == Block then
      table.insert(toRecalc, Strength)
      table.insert(toRecalc, Agility)
      table.insert(toRecalc, Endurance)

   elseif skill == Armorer then
      table.insert(toRecalc, Strength)
      table.insert(toRecalc, Endurance)
      table.insert(toRecalc, Personality)

   elseif skill == Mediumarmor then
      table.insert(toRecalc, Endurance)
      table.insert(toRecalc, Speed)
      table.insert(toRecalc, Willpower)

   elseif skill == Heavyarmor then
      table.insert(toRecalc, Strength)
      table.insert(toRecalc, Endurance)
      table.insert(toRecalc, Speed)

   elseif skill == Bluntweapon then
      table.insert(toRecalc, Strength)
      table.insert(toRecalc, Endurance)
      table.insert(toRecalc, Willpower)

   elseif skill == Longblade then
      table.insert(toRecalc, Strength)
      table.insert(toRecalc, Agility)
      table.insert(toRecalc, Speed)

   elseif skill == Axe then
      table.insert(toRecalc, Strength)
      table.insert(toRecalc, Agility)
      table.insert(toRecalc, Willpower)

   elseif skill == Spear then
      table.insert(toRecalc, Strength)
      table.insert(toRecalc, Endurance)
      table.insert(toRecalc, Speed)

   elseif skill == Athletics then
      table.insert(toRecalc, Endurance)
      table.insert(toRecalc, Speed)
      table.insert(toRecalc, Willpower)

      -- Magical skills
   elseif skill == Enchant then
      table.insert(toRecalc, Intelligence)
      table.insert(toRecalc, Willpower)
      table.insert(toRecalc, Personality)

   elseif skill == Destruction then
      table.insert(toRecalc, Intelligence)
      table.insert(toRecalc, Willpower)
      table.insert(toRecalc, Personality)

   elseif skill == Alteration then
      table.insert(toRecalc, Speed)
      table.insert(toRecalc, Intelligence)
      table.insert(toRecalc, Willpower)

   elseif skill == Illusion then
      table.insert(toRecalc, Agility)
      table.insert(toRecalc, Intelligence)
      table.insert(toRecalc, Personality)

   elseif skill == Conjuration then
      table.insert(toRecalc, Intelligence)
      table.insert(toRecalc, Willpower)
      table.insert(toRecalc, Personality)

   elseif skill == Mysticism then
      table.insert(toRecalc, Intelligence)
      table.insert(toRecalc, Willpower)
      table.insert(toRecalc, Personality)

   elseif skill == Restoration then
      table.insert(toRecalc, Endurance)
      table.insert(toRecalc, Willpower)
      table.insert(toRecalc, Personality)

   elseif skill == Alchemy then
      table.insert(toRecalc, Endurance)
      table.insert(toRecalc, Intelligence)
      table.insert(toRecalc, Personality)

   elseif skill == Unarmored then
      table.insert(toRecalc, Endurance)
      table.insert(toRecalc, Speed)
      table.insert(toRecalc, Willpower)

      -- Thief skills
   elseif skill == Security then
      table.insert(toRecalc, Agility)
      table.insert(toRecalc, Intelligence)
      table.insert(toRecalc, Personality)

   elseif skill == Sneak then
      table.insert(toRecalc, Agility)
      table.insert(toRecalc, Speed)
      table.insert(toRecalc, Personality)

   elseif skill == Acrobatics then
      table.insert(toRecalc, Strength)
      table.insert(toRecalc, Agility)
      table.insert(toRecalc, Speed)

   elseif skill == Lightarmor then
      table.insert(toRecalc, Agility)
      table.insert(toRecalc, Endurance)
      table.insert(toRecalc, Speed)

   elseif skill == Shortblade then
      table.insert(toRecalc, Agility)
      table.insert(toRecalc, Speed)
      table.insert(toRecalc, Personality)

   elseif skill == Marksman then
      table.insert(toRecalc, Strength)
      table.insert(toRecalc, Agility)
      table.insert(toRecalc, Speed)

   elseif skill == Mercantile then
      table.insert(toRecalc, Intelligence)
      table.insert(toRecalc, Willpower)
      table.insert(toRecalc, Personality)

   elseif skill == Speechcraft then
      table.insert(toRecalc, Intelligence)
      table.insert(toRecalc, Willpower)
      table.insert(toRecalc, Personality)

   elseif skill == Handtohand then
      table.insert(toRecalc, Strength)
      table.insert(toRecalc, Agility)
      table.insert(toRecalc, Endurance)
   end

   return toRecalc
end

function ncgdTES3MP.OnPlayerAttribute(eventStatus, pid)
   if not eventStatus.validCustomHandlers and not ncgdTES3MP.config.forceLoadOnPlayerAttribute then
      fatal("validCustomHandlers for `OnPlayerAttribute` have been set to false!" ..
               "  ncgdTES3MP requires custom handlers to operate!")
      fatal("Exiting now to avoid problems.  Please set \"forceLoadOnPlayerAttribute\"" ..
            " to \"true\" if you're sure it's OK.")
      tes3mp.StopServer()
   else
      if ncgdTES3MP.config.forceLoadOnPlayerAttribute then
         warn("\"ncgdTES3MP.OnPlayerAttribute\" is being force loaded!!")
      end

      if ncgdTES3MP.chargenDone then
         info("Called \"OnPlayerAttribute\" for pid \"" .. pid .. "\"")
         -- TODO: Figure out which skill leveled up and recalculate the appropriate attributes.

         -- Allow custom behavior, block the default
         local customHandlers = true
         local defaultHandler = false
         customEventHooks.makeEventStatus(defaultHandler, customHandlers)
      else
         dbg("Not running \"OnPlayerAttribute\" because CharGen hasn't completed!")
      end
   end
end

function ncgdTES3MP.OnPlayerAuthentified(eventStatus, pid)
   if not eventStatus.validCustomHandlers and not ncgdTES3MP.config.forceLoadOnPlayerAuthentified then
      fatal("validCustomHandlers for `OnPlayerAuthentified` have been set to false!" ..
               "  ncgdTES3MP requires custom handlers to operate!")
      fatal("Exiting now to avoid problems.  Please set \"forceLoadOnPlayerAuthentified\"" ..
            " to \"true\" if you're sure it's OK.")
      tes3mp.StopServer()
   else
      if ncgdTES3MP.config.forceLoadOnPlayerAuthentified then
         warn("\"ncgdTES3MP.OnPlayerAuthentified\" is being force loaded!!")
      end

      info("Called \"OnPlayerAuthentified\" for pid \"" .. pid .. "\"")

      info("TODO")
      -- TODO: If there's a previous decay acceleration, resume it.

      ncgdTES3MP.chargenDone = true

      -- Allow custom behavior, and the default
      local customHandlers = true
      local defaultHandler = true
      customEventHooks.makeEventStatus(defaultHandler, customHandlers)
   end
end

function ncgdTES3MP.OnPlayerDeath(eventStatus, pid)
   if not eventStatus.validCustomHandlers and not ncgdTES3MP.config.forceLoadOnPlayerDeath then
      fatal("validCustomHandlers for `OnPlayerDeath` have been set to false!" ..
               "  ncgdTES3MP requires custom handlers to operate!")
      fatal("Exiting now to avoid problems.  Please set \"forceLoadOnPlayerDeath\"" ..
            " to \"true\" if you're sure it's OK.")
      tes3mp.StopServer()
   else
      if ncgdTES3MP.config.forceLoadOnPlayerDeath then
         warn("\"ncgdTES3MP.OnPlayerDeath\" is being force loaded!!")
      end

      info("Called \"OnPlayerDeath\" for pid \"" .. pid .. "\"")

      info("TODO")
      -- TODO: Set a timer when the player dies, and give them a temporary accelerated decay rate.
      -- TODO: If a player disconnects, store their remaining time.  The start time of the curse will need
      -- TODO: be stored and then some method for calculating the remaining duration will be needed.

      -- Allow custom behavior, and the default
      local customHandlers = true
      local defaultHandler = true
      customEventHooks.makeEventStatus(defaultHandler, customHandlers)
   end
end

function ncgdTES3MP.OnPlayerDisconnect(eventStatus, pid)
   if not eventStatus.validCustomHandlers and not ncgdTES3MP.config.forceLoadOnPlayerDisconnect then
      fatal("validCustomHandlers for `OnPlayerDisconnect` have been set to false!" ..
               "  ncgdTES3MP requires custom handlers to operate!")
      fatal("Exiting now to avoid problems.  Please set \"forceLoadOnPlayerDisconnect\"" ..
            " to \"true\" if you're sure it's OK.")
      tes3mp.StopServer()
   else
      if ncgdTES3MP.config.forceLoadOnPlayerDisconnect then
         warn("\"ncgdTES3MP.OnPlayerDisconnect\" is being force loaded!!")
      end

      info("Called \"OnPlayerDisconnect\" for pid \"" .. pid .. "\"")

      info("TODO")
      -- TODO: When a player disconnects, if they have an accelerated decay record the logout time so that a resume
      -- TODO: duration can be grabbed at next logon.

      -- Allow custom behavior, and the default
      local customHandlers = true
      local defaultHandler = true
      customEventHooks.makeEventStatus(defaultHandler, customHandlers)
   end
end

function ncgdTES3MP.OnPlayerEndCharGen(eventStatus, pid)
   if not eventStatus.validCustomHandlers and not ncgdTES3MP.config.forceLoadOnPlayerEndCharGen then
      fatal("validCustomHandlers for `OnPlayerEndCharGen` have been set to false!" ..
               "  ncgdTES3MP requires custom handlers to operate!")
      fatal("Exiting now to avoid problems.  Please set \"forceLoadOnPlayerEndCharGen\"" ..
            " to \"true\" if you're sure it's OK.")
      tes3mp.StopServer()
   else
      if ncgdTES3MP.config.forceLoadOnPlayerEndCharGen then
         warn("\"ncgdTES3MP.OnPlayerEndCharGen\" is being force loaded!!")
      end

      info("Called \"OnPlayerEndCharGen\" for pid \"" .. pid .. "\"")

      if Players[pid].data.customVariables[NCGD] == nil then
         Players[pid]:LoadSkills()
         Players[pid].data.customVariables[NCGD] = {}
      end

      for _, attribute in pairs(Attributes) do
         initAttribute(pid, attribute)
      end

      for _, skill in pairs(Skills) do
         initSkill(pid, skill)
      end

      setCustomVar(pid, "decayRate", getDecayRate())

      dbg("NCGD CharGen completed for pid \"" .. pid .. "\"")
   end
end


customEventHooks.registerHandler("OnPlayerAttribute", ncgdTES3MP.OnPlayerAttribute)
customEventHooks.registerHandler("OnPlayerAuthentified", ncgdTES3MP.OnPlayerAuthentified)
customEventHooks.registerHandler("OnPlayerDeath", ncgdTES3MP.OnPlayerDeath)
customEventHooks.registerHandler("OnPlayerDisconnect", ncgdTES3MP.OnPlayerDisconnect)
customEventHooks.registerHandler("OnPlayerEndCharGen", ncgdTES3MP.OnPlayerEndCharGen)
-- TODO: does OnPlayerLevel need to be blocked?
