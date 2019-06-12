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
   skillAttributes = {
      -- Combat skills
      Block = {
         Strength,
         Agility,
         Endurance
      },
      Armorer = {
         Strength,
         Endurance,
         Personality
      },
      Mediumarmor = {
         Endurance,
         Speed,
         Willpower
      },
      Heavyarmor = {
         Strength,
         Endurance,
         Speed
      },
      Bluntweapon = {
         Strength,
         Endurance,
         Willpower
      },
      Longblade = {
         Strength,
         Agility,
         Speed
      },
      Axe = {
         Strength,
         Agility,
         Willpower
      },
      Spear = {
         Strength,
         Endurance,
         Speed
      },
      Athletics = {
         Endurance,
         Speed,
         Willpower
      },
      -- Magical Skills
      Enchant = {
         Intelligence,
         Willpower,
         Personality
      },
      Destruction = {
         Intelligence,
         Willpower,
         Personality
      },
      Alteration = {
         Speed,
         Intelligence,
         Willpower
      },
      Illusion = {
         Agility,
         Intelligence,
         Personality
      },
      Conjuration = {
         Intelligence,
         Willpower,
         Personality
      },
      Mysticism = {
         Intelligence,
         Willpower,
         Personality
      },
      Restoration = {
         Endurance,
         Willpower,
         Personality
      },
      Alchemy = {
         Endurance,
         Intelligence,
         Personality
      },
      Unarmored = {
         Endurance,
         Speed,
         Willpower
      },
      -- Thief skills
      Security = {
         Agility,
         Intelligence,
         Personality
      },
      Sneak = {
         Agility,
         Speed,
         Personality
      },
      Acrobatics = {
         Strength,
         Agility,
         Speed
      },
      Lightarmor = {
         Agility,
         Endurance,
         Speed
      },
      Shortblade = {
         Agility,
         Speed,
         Personality
      },
      Marksman = {
         Strength,
         Agility,
         Speed
      },
      Mercantile = {
         Intelligence,
         Willpower,
         Personality
      },
      Speechcraft = {
         Intelligence,
         Willpower,
         Personality
      },
      Handtohand = {
         Strength,
         Agility,
         Endurance
      }
   },
   deathDecay = {
      durationHrs = 1,
      enabled = true,
      modifier = 2,
      stacks = false
   },
   decayRate = fast,
   forceLoadOnPlayerAuthentified = false,
   forceLoadOnPlayerDeath = false,
   forceLoadOnPlayerDisconnect = false,
   forceLoadOnPlayerEndCharGen = false,
   forceLoadOnPlayerLevel = false,
   forceLoadOnPlayerSkill = false,
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
   Players[pid].data.attributes[attribute].skillIncrease = 0
   if save ~= nil then
      Players[pid]:LoadAttributes()
   end
end

local function getPlayerLevel(pid)
   dbg("Called \"getPlayerLevel\" for pid \"" .. pid .. "\".")
   if Players[pid].stats == nil then
      return 1
   else
      return tes3mp.GetLevel(pid)
   end
end

local function setPlayerLevel(pid, value)
   dbg("Called \"setPlayerLevel\" for pid \"" .. pid .. "\" and value \"" .. value .. "\"")
   if Players[pid].stats == nil then
      -- This must be a new player, just finishing CharGen
      Players[pid].stats = { ["level"] = 1 }
   end
   Players[pid].stats.level = value
   Players[pid].stats.levelProgress = 0
   Players[pid]:LoadLevel()
   -- Players[pid]:SaveLevel()
end

local function getSkill(pid, skill, base)
   dbg("Called \"getSkill\" for pid \"" .. pid .. "\" and skill \"" .. skill .. "\"")
   local skillId = tes3mp.GetSkillId(skill)
   if base then
      return tes3mp.GetSkillBase(pid, skillId)
   else
      return tes3mp.GetSkillBase(pid, skillId) - tes3mp.GetSkillModifier(pid, skillId)
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
   -- TODO: give these better names
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
      dbg("Luck is being recalculated...")
      temp2 = temp * 2
      temp2 = math.floor(temp2 / 27)
      temp2 = math.floor(math.sqrt(temp2))

      if temp2 > 25 then
         dbg("A leveling event is happening...")
         dbg("temp2: " .. tostring(temp2))
         local oldLevel = getPlayerLevel(pid)
         dbg("oldLevel: " .. tostring(oldLevel))
         local newLevel = temp2 - 25
         dbg("newLevel: " .. tostring(newLevel))
         setPlayerLevel(pid, temp2)
         -- customEventHooks.triggerValidators("OnPlayerLevel", {pid, newLevel})
         dbg("getPlayerLevel(pid): " .. tostring(getPlayerLevel(pid)))

         if newLevel > oldLevel then
            dbg("Player with pid \"" .. pid .. "\" reached level " .. newLevel .. ".")
            gameMsg(pid, "You have reached Level " .. temp2 .. ".")
         elseif newLevel < oldLevel then
            dbg("Player with pid \"" .. pid .. "\" decayed to level " .. newLevel .. ".")
            gameMsg(pid, "You have regressed to Level " .. newLevel .. ".")
         end

      else
         -- TODO: calculate level progress here.
         if Players[pid].stats ~= nil then
            if getPlayerLevel(pid) > 1 then
               dbg("Player with pid \"" .. pid .. "\" regressed to level 1.")
               gameMsg(pid, "You have regressed to Level 1.")
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
      setAttribute(pid, attribute, temp, true)
      setCustomVar(pid, "base" .. attribute, temp)
      if attribute ~= Luck then
         recalculateLuck = true
      end
   elseif temp < baseAttr then
      gameMsg(pid, "Your " .. attribute ..  " has decayed to " .. temp .. ".")
      setAttribute(pid, attribute, temp, true)
      setCustomVar(pid, "base" .. attribute, temp)
      if attribute ~= Luck then
         recalculateLuck = true
      end
   end

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
end

local function initSkill(pid, skill)
   dbg("Called \"initSkill\" for pid \"" .. pid .. "\" and skill \"" .. skill .. "\"")

   local baseSkill = getSkill(pid, skill, true)
   setCustomVar(pid, "base" .. skill, baseSkill)
   -- TODO: remove this if it doesn't get used.
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
   return ncgdTES3MP.config.skillAttributes[skill]
end

function ncgdTES3MP.OnPlayerSkill(eventStatus, pid)
   if not eventStatus.validCustomHandlers and not ncgdTES3MP.config.forceLoadOnPlayerSkill then
      fatal("validCustomHandlers for `OnPlayerSkill` have been set to false!" ..
               "  ncgdTES3MP requires custom handlers to operate!")
      fatal("Exiting now to avoid problems.  Please set \"forceLoadOnPlayerSkill\"" ..
            " to \"true\" if you're sure it's OK.")
      tes3mp.StopServer()
   else
      if ncgdTES3MP.config.forceLoadOnPlayerSkill then
         warn("\"ncgdTES3MP.OnPlayerSkill\" is being force loaded!!")
      end

      if ncgdTES3MP.chargenDone then
         info("Called \"OnPlayerSkill\" for pid \"" .. pid .. "\"")

         local raisedSkill = nil

         for skill, values in pairs(Players[pid].data.skills) do
            local ncgdBase = getCustomVar(pid, "base" .. skill)
            local skillBase = getSkill(pid, skill, true)

            local skillId = tes3mp.GetSkillId(skill)
            local baseProgress = values.progress
            local changedProgress = tes3mp.GetSkillProgress(pid, skillId)

            if baseProgress ~= changedProgress and ncgdBase < skillBase then
               raisedSkill = skill
               setCustomVar(pid, "base" .. skill, skillBase)
               break
            end
         end

         if raisedSkill ~= nil then
            local recalcLuck = false
            for _, attribute in pairs(getAttrsToRecalc(raisedSkill)) do
               recalcLuck = recalculateAttribute(pid, attribute)
            end
            if recalcLuck then
               recalculateAttribute(pid, Luck)
            end
         end

         -- Allow custom behavior, and the default
         local customHandlers = true
         local defaultHandler = true
         customEventHooks.makeEventStatus(defaultHandler, customHandlers)
      else
         dbg("Not running \"OnPlayerSkill\" because CharGen hasn't completed!")
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

function ncgdTES3MP.OnPlayerLevel(eventStatus, pid, newLevel)
   if not eventStatus.validCustomHandlers and not ncgdTES3MP.config.forceLoadOnPlayerLevel then
      fatal("validCustomHandlers for `OnPlayerLevel` have been set to false!" ..
               "  ncgdTES3MP requires custom handlers to operate!")
      fatal("Exiting now to avoid problems.  Please set \"forceLoadOnPlayerLevel\"" ..
            " to \"true\" if you're sure it's OK.")
      tes3mp.StopServer()
   else
      if ncgdTES3MP.config.forceLoadOnPlayerLevel then
         warn("\"ncgdTES3MP.OnPlayerLevel\" is being force loaded!!")
      end
      info("Called \"OnPlayerLevel\" for pid \"" .. pid .. "\"")

      if newLevel ~= nil then
         setPlayerLevel(pid, newLevel)
      end

      -- Block custom behavior, and the default
      local customHandlers = false
      local defaultHandler = false
      customEventHooks.makeEventStatus(defaultHandler, customHandlers)
   end
end

-- TODO: Things that still need to be done,
-- 1. Ensure leveling works.
-- 2. Decay.
-- 3. Acceleration of decay on death
-- 4. ????

customEventHooks.registerValidator("OnPlayerLevel", ncgdTES3MP.OnPlayerLevel)
customEventHooks.registerValidator("OnPlayerSkill", ncgdTES3MP.OnPlayerSkill)

customEventHooks.registerHandler("OnPlayerAuthentified", ncgdTES3MP.OnPlayerAuthentified)
customEventHooks.registerHandler("OnPlayerDeath", ncgdTES3MP.OnPlayerDeath)
customEventHooks.registerHandler("OnPlayerDisconnect", ncgdTES3MP.OnPlayerDisconnect)
customEventHooks.registerHandler("OnPlayerEndCharGen", ncgdTES3MP.OnPlayerEndCharGen)
