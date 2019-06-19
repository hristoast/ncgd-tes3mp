-- TODO:
-- 1. Acceleration of decay on death

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
   decayRates = {
      none = 0,
      slow = 1,
      standard = 2,
      fast = 3
   },
   growthRates = {
      slow = 1,
      standard = 2,
      fast = 3
   },
   deathDecay = {
      durationHrs = 1,
      enabled = true,
      modifier = 2,
      stacks = false
   },
   attributeCapMsg = "Your %s is being held back by otherworldly forces...",
   cmdCooldown = 30,
   decayMinLvl = 15,
   decayRate = fast,
   forceLoadOnPlayerAuthentified = false,
   forceLoadOnPlayerDeath = false,
   forceLoadOnPlayerDisconnect = false,
   forceLoadOnPlayerEndCharGen = false,
   forceLoadOnPlayerLevel = false,
   forceLoadOnPlayerSkill = false,
   growthRate = slow,
   healthMod = true,
   levelCap = 0,
   levelCapMsg = "Your level is being held back by otherworldly forces...",
   rankErr = "This command requires admin privileges!",
   reqRank = 2,
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

local healthAttributes = { Endurance, Strength, Willpower }

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

local function chatMsg(pid, msg)
   tes3mp.SendMessage(pid, "[NCGD]: " .. msg .. "\n")
end

local function gameMsg(pid, msg)
   tes3mp.MessageBox(pid, -1, msg)
end

local function randInt(rangeStart, rangeEnd)
   -- THANKS: https://stackoverflow.com/a/20157671
   math.random()
   math.random()
   math.random()
   return math.random(rangeStart, rangeEnd)
end

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
   return tes3mp.GetLevel(pid)
end

local function setPlayerLevel(pid, value)
   dbg("Called \"setPlayerLevel\" for pid \"" .. pid .. "\" and value \"" .. value .. "\"")
   Players[pid].data.stats.level = value
   Players[pid]:LoadLevel()
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
   if Players[pid].data.customVariables[NCGD] ~= nil then
      return Players[pid].data.customVariables[NCGD][key]
   end
end

local function setSkill(pid, skill, value)
   dbg("Called \"setSkill\" for pid \"" .. pid .. "\" and skill \""
          .. skill .. "\" and value \"" .. value .. "\"")
   if value > getCustomVar(pid, "max" .. skill) then
      setCustomVar(pid, "max" .. skill, value)
   end
   -- TODO: Can this be optimized to only send the changed skill?
   Players[pid].data.skills[skill].base = value
   Players[pid]:LoadSkills()
end

local function setCustomVar(pid, key, val)
   dbg("Called \"setCustomVar\" for pid \"" .. pid .. "\", key \"" ..
          key .. "\", and value \"" .. tostring(val) .. "\".")
   if Players[pid].data.customVariables[NCGD] ~= nil then
      Players[pid].data.customVariables[NCGD][key] = val
   end
end

local function getAttributeSkills(attribute)
   dbg("Called \"getAttributeSkills\" on attribute \"" .. attribute .. "\".")
   return ncgdTES3MP.config.modifiers[attribute]
end

local function getGrowthRate()
   dbg("Called \"getGrowthRate\"")
   return ncgdTES3MP.config.growthRates[string.lower(ncgdTES3MP.config.growthRate)]
end

local function recalculateDecayMemory(pid, rate, force)
   if getCustomVar(pid, "charGenDone") == nil and not force then
      return
   end

   dbg("Called \"recalculateDecayMemory\" for pid \"" .. pid .. "\" and rate \"" .. tostring(rate) .. "\".")
   local decayMemory
   local baseINT = getCustomVar(pid, "baseIntelligence")
   local playerLvl = getPlayerLevel(pid)

   local twoWeeks = 336
   local oneWeek = 168
   local threeDays = 72
   local oneDay = 24
   local halfDay = 12

   decayMemory = playerLvl * playerLvl
   decayMemory = math.floor((baseINT * baseINT) / decayMemory)

   if rate == ncgdTES3MP.config.decayRates.slow then
      decayMemory = decayMemory * twoWeeks
      decayMemory = decayMemory + threeDays
   elseif rate == ncgdTES3MP.config.decayRates.standard then
      decayMemory = decayMemory * oneWeek
      decayMemory = decayMemory + oneDay
   elseif rate == ncgdTES3MP.config.decayRates.fast then
      decayMemory = decayMemory * threeDays
      decayMemory = decayMemory + halfDay
   end

   setCustomVar(pid, "decayMemory", decayMemory)
end

local function canLevel(newLevel)
   if ncgdTES3MP.config.levelCap > 0 then
      if newLevel >= ncgdTES3MP.config.levelCap then
         return false
      end
   end
   return true
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
      temp2 = math.floor(temp2 / tes3mp.GetSkillCount())
      temp2 = math.floor(math.sqrt(temp2))

      if temp2 > 25 then
         local oldLevel = getPlayerLevel(pid)
         local newLevel = temp2 - 25

         if canLevel(newLevel) then
            if newLevel > oldLevel then
               setPlayerLevel(pid, newLevel)
               dbg("Player with pid \"" .. pid .. "\" reached level " .. newLevel .. ".")
               gameMsg(pid, "You have reached Level " .. newLevel .. ".")
            elseif newLevel < oldLevel then
               setPlayerLevel(pid, newLevel)
               dbg("Player with pid \"" .. pid .. "\" decayed to level " .. newLevel .. ".")
               gameMsg(pid, "You have regressed to Level " .. newLevel .. ".")
            end
         else

            dbg("Player with pid \"" .. pid .. "\" denied going to level "
                   .. newLevel .. " due to hitting the level cap.")
            gameMsg(pid, ncgdTES3MP.config.levelCapMsg)
         end

      else
         if getPlayerLevel(pid) > 1 then
            dbg("Player with pid \"" .. pid .. "\" regressed to level 1.")
            gameMsg(pid, "You have regressed to Level 1.")
            setPlayerLevel(pid, 1)
         end
      end
   end

   -- Adjust XP based on growth speed
   temp2 = temp * getGrowthRate()
   temp = math.floor(temp2 / tes3mp.GetSkillCount())

   -- Converts XP into attributes
   temp2 = math.floor(math.sqrt(temp))
   temp = temp2 + startAttr

   if (temp <= config.maxAttributeValue and attribute ~= Speed)
   or (temp <= config.maxSpeedValue and attribute == Speed) then
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
   else
      dbg("Attribute increase denied to pid \"" .. pid .. "\" due to hitting the server cap.")
      gameMsg(pid, string.format(ncgdTES3MP.config.attributeCapMsg, attribute))
   end

   dbg("Recalculation of attribute \"" .. attribute .. "\" has completed.")

   return recalculateLuck
end

local function initAttribute(pid, attribute)
   dbg("Called \"initAttribute\" for pid \"" .. pid .. "\" and attribute \"" .. attribute .. "\"")

   local startAttr = getAttribute(pid, attribute, true)
   -- Reduces the attribute to account for gain from skills
   startAttr = math.floor(startAttr / 2)

   setCustomVar(pid, "base" .. attribute, startAttr)
   setCustomVar(pid, "start" .. attribute, startAttr)
   setAttribute(pid, attribute, startAttr)

   recalculateAttribute(pid, attribute)
end

local function initSkill(pid, skill)
   dbg("Called \"initSkill\" for pid \"" .. pid .. "\" and skill \"" .. skill .. "\"")
   local baseSkill = getSkill(pid, skill, true)
   setCustomVar(pid, "base" .. skill, baseSkill)
   setCustomVar(pid, "max" .. skill, baseSkill)
   -- TODO: remove this if it doesn't get used.
   setCustomVar(pid, "start" .. skill, baseSkill)
end

local function initSkillDecay(pid, skill)
   dbg("Called \"initSkillDecay\" for pid \"" .. pid .. "\" and skill \"" .. skill .. "\"")
   local decayRate = randInt(0, 359)
   -- The 30 below comes from the mwscript.  I'm not clear if it's random or what.
   setCustomVar(pid, "decay" .. skill, math.floor(decayRate / 30))
end

local function getDecayRate()
   dbg("Called \"getDecayRate\"")
   return ncgdTES3MP.config.decayRates[string.lower(ncgdTES3MP.config.decayRate)]
end

local function getAttrsToRecalc(skill)
   dbg("Called \"getAttrsToRecalc\"")
   return ncgdTES3MP.config.skillAttributes[skill]
end

local function updatePlayTime(pid)
   dbg("Called \"updatePlayTime\" for pid \"" .. pid .. "\"")
   local pt = getCustomVar(pid, "loginPlayTime")
   local loginDaysPassed = pt["daysPassed"]
   local loginHour = pt["hour"]
   local loginPlayTime = pt["playTime"]

   local nowDaysPassed = WorldInstance.data.time.daysPassed
   local nowHour = WorldInstance.data.time.hour

   local daysPassed = loginDaysPassed - nowDaysPassed

   local totalHours = math.floor(daysPassed * 24 + loginPlayTime - loginHour + nowHour)

   setCustomVar(pid, "playTime", totalHours)
   return totalHours
end

local function processDecay(pid)
   dbg("Called \"processDecay\" for pid \"" .. pid .. "\".")
   local hoursPassed = updatePlayTime(pid)
   local daysPassed = math.floor(hoursPassed / 24)
   local worldHour = WorldInstance.data.time.hour
   local timePassed = worldHour

   local decayMemory = getCustomVar(pid, "decayMemory")
   local oldDay = getCustomVar(pid, "oldDay") or 0

   while oldDay < daysPassed do
      timePassed = timePassed + 24
      oldDay = oldDay + 1
   end

   setCustomVar(pid, "oldDay", math.floor(hoursPassed / 24))

   for _, skill in pairs(Skills) do
      local skillBase =  getCustomVar(pid, "base" .. skill)
      local skillDecay = getCustomVar(pid, "decay" .. skill)
      local skillMax = getCustomVar(pid, "max" .. skill)
      -- TODO: Store decay rates as a table so they can be saved all at once, vs one at a time.
      setCustomVar(pid, "decay" .. skill, skillDecay + timePassed)

      -- Check to see if enough decay has accumulated
      if skillDecay > decayMemory then
         setCustomVar(pid, "decay" .. skill, 0)

         -- Only proceed with decay if the skill isn't lower than half it's known max
         if skillBase > math.floor(skillMax / 2) then
            -- ... and if it isn't already lower than the minimum level.
            if skillBase > ncgdTES3MP.config.decayMinLvl then
               dbg("Player with pid \"" .. pid .. "\" had skill \"" ..  skill .. "\" decay from \""
                      .. tostring(skillBase) .. "\" to \"" .. tostring(skillBase - 1) .. "\".")
               setSkill(pid, skill, skillBase - 1)
               setCustomVar(pid, "base" .. skill, skillBase - 1)
               local attributes = getAttrsToRecalc(skill)

               for _, attribute in pairs(attributes) do
                  dbg("Recalculating " .. attribute .. " due to skill decay...")
                  local redoLuck = recalculateAttribute(pid, attribute)
               end

               if redoLuck then
                  dbg("Recalculating Luck due to skill decay...")
                  recalculateAttribute(pid, Luck)
               end

               -- TODO: Configurable decay sound
               logicHandler.RunConsoleCommandOnPlayer(pid, 'PlaySoundVP "skillraise", 1.0, 0.79')
               logicHandler.RunConsoleCommandOnPlayer(pid, 'PlaySoundVP "skillraise", 1.0, 0.76')
            end
         end
      end
   end
end

local function getHealthGetRatio(pid)
   -- https://en.uesp.net/wiki/Tes3Mod:GetHealthGetRatio
   -- http://lua-users.org/wiki/SimpleRound
   dbg("Called \"getHealthGetRatio\" for pid \"" .. pid .. "\".")
   local playerData = Players[pid].data
   local m = 10^1
   return math.floor((playerData.stats.healthCurrent / playerData.stats.healthBase) * m + 0.5) / m
end

local function modHealth(pid)
   if getHealthGetRatio(pid) == 0 then
      return
   end
   dbg("Called \"modHealth\" for pid \"" .. pid .. "\".")
   local player = Players[pid]

   local baseHP = player.data.stats.healthBase
   local currentHP = player.data.stats.healthCurrent

   local End = getAttribute(pid, Endurance)
   local Str = getAttribute(pid, Strength)
   local Wil = getAttribute(pid, Willpower)

   local hpRatio = getHealthGetRatio(pid)

   local maxHP = End

   -- TODO: A better name
   local temp = math.floor(Str / 2)

   maxHP = maxHP + temp
   temp = math.floor(Wil / 4)
   maxHP = math.floor(maxHP + temp)

   if currentHP > baseHP then
      currentHP = math.floor(currentHP / hpRatio)

      local fortifiedHP = currentHP - maxHP

      maxHP = End
      temp = math.floor(Str / 2)
      maxHP = maxHP + temp
      temp = math.floor(Wil / 4)
      maxHP = maxHP + temp
      maxHP = maxHP + fortifiedHP
   end

   dbg("Modifying base health of pid \"" .. pid .. "\" from \"" ..
          player.data.stats.healthBase .. "\" to \"" .. tostring(maxHP) .. "\"")

   currentHP = maxHP * hpRatio

   dbg("Modifying current health of pid \"" .. pid .. "\" from \"" .. player.data.stats.healthCurrent
          .. "\" to \"" .. tostring(currentHP) .. "\"")

   player.data.stats.healthBase = maxHP
   player.data.stats.healthCurrent = currentHP
   player:LoadStatsDynamic()
end

function ncgdTES3MP.OnPlayerSkill(eventStatus, pid)
   if getCustomVar(pid, "charGenDone") == nil then
      return
   end
   if not eventStatus.validCustomHandlers and not ncgdTES3MP.config.forceLoadOnPlayerSkill then
      fatal("validCustomHandlers for `OnPlayerSkill` have been set to false!" ..
               "  ncgdTES3MP requires custom handlers to operate!")
      fatal("Exiting now to avoid problems.  Please set \"forceLoadOnPlayerSkill\"" ..
            " to \"true\" if you're sure it's OK.")
      tes3mp.StopServer()
   end
   if ncgdTES3MP.config.forceLoadOnPlayerSkill then
      warn("\"ncgdTES3MP.OnPlayerSkill\" is being force loaded!!")
   end
   info("Called \"OnPlayerSkill\" for pid \"" .. pid .. "\"")

   local changedSkill

   for skill, _ in pairs(Players[pid].data.skills) do
      local ncgdBase = getCustomVar(pid, "base" .. skill)
      local skillBase = getSkill(pid, skill, true)

      if ncgdBase ~= skillBase then
         changedSkill = skill
         if skillBase > getCustomVar(pid, "max" .. skill) then
            -- TODO: set vars as a table so they can be saved all at once
            setCustomVar(pid, "decay" .. skill, math.floor(getCustomVar(pid, "decay" .. skill) / 2))
            setCustomVar(pid, "max" .. skill, skillBase)
         end
         setCustomVar(pid, "base" .. skill, skillBase)
      end

      -- Zero out levelProgress to stop the vanilla level up
      Players[pid].data.stats.levelProgress = 0
      Players[pid]:LoadLevel()

      if changedSkill then break end
   end

   if changedSkill then
      local recalcLuck = false
      local modHP = false
      for _, attribute in pairs(getAttrsToRecalc(changedSkill)) do
         recalcLuck = recalculateAttribute(pid, attribute)

         if ncgdTES3MP.config.healthMod
         and tableHelper.containsValue(healthAttributes, attribute) then
            modHP = true
         end
      end

      if ncgdTES3MP.config.healthMod and modHP then
         modHealth(pid)
      end

      if recalcLuck then
         recalculateAttribute(pid, Luck)
      end
   end

   if ncgdTES3MP.config.decayRate ~= none then
      processDecay(pid)
   end
end

function ncgdTES3MP.OnPlayerAuthentified(eventStatus, pid)
   if not ncgdTES3MP.config.deathDecay.enabled and ncgdTES3MP.config.decayRate == none  then
      -- This method only handles stuff related to decay and death-caused
      -- acceleration of it.  If both are disabled, exit immediately.
      return
   end
   if not eventStatus.validCustomHandlers and not ncgdTES3MP.config.forceLoadOnPlayerAuthentified then
      fatal("validCustomHandlers for `OnPlayerAuthentified` have been set to false!" ..
               "  ncgdTES3MP requires custom handlers to operate!")
      fatal("Exiting now to avoid problems.  Please set \"forceLoadOnPlayerAuthentified\"" ..
            " to \"true\" if you're sure it's OK.")
      tes3mp.StopServer()
   end
   if ncgdTES3MP.config.forceLoadOnPlayerAuthentified then
      warn("\"ncgdTES3MP.OnPlayerAuthentified\" is being force loaded!!")
   end
   info("Called \"OnPlayerAuthentified\" for pid \"" .. pid .. "\"")
   setCustomVar(pid, "loginPlayTime",
                {
                   ["daysPassed"] = WorldInstance.data.time.daysPassed,
                   ["hour"] = WorldInstance.data.time.hour,
                   -- playTime represents the total in-game hours the player has spent playing.
                   ["playTime"] = getCustomVar(pid, "playTime") or 0
                }
   )
end

function ncgdTES3MP.OnPlayerDeath(eventStatus, pid)
   if not ncgdTES3MP.config.deathDecay.enabled then
      return
   end
   if not eventStatus.validCustomHandlers and not ncgdTES3MP.config.forceLoadOnPlayerDeath then
      fatal("validCustomHandlers for `OnPlayerDeath` have been set to false!" ..
               "  ncgdTES3MP requires custom handlers to operate!")
      fatal("Exiting now to avoid problems.  Please set \"forceLoadOnPlayerDeath\"" ..
            " to \"true\" if you're sure it's OK.")
      tes3mp.StopServer()
   end
   if ncgdTES3MP.config.forceLoadOnPlayerDeath then
      warn("\"ncgdTES3MP.OnPlayerDeath\" is being force loaded!!")
   end
   info("Called \"OnPlayerDeath\" for pid \"" .. pid .. "\"")
   -- TODO: Set a timer when the player dies, and give them a temporary accelerated decay rate.
   -- TODO: If a player disconnects, store their remaining time.  The start time of the curse will need
   -- TODO: be stored and then some method for calculating the remaining duration will be needed.
end

function ncgdTES3MP.OnPlayerDisconnect(eventStatus, pid)
   if not ncgdTES3MP.config.deathDecay.enabled then
      return
   end
   if not eventStatus.validCustomHandlers and not ncgdTES3MP.config.forceLoadOnPlayerDisconnect then
      fatal("validCustomHandlers for `OnPlayerDisconnect` have been set to false!" ..
               "  ncgdTES3MP requires custom handlers to operate!")
      fatal("Exiting now to avoid problems.  Please set \"forceLoadOnPlayerDisconnect\"" ..
            " to \"true\" if you're sure it's OK.")
      tes3mp.StopServer()
   end
   if ncgdTES3MP.config.forceLoadOnPlayerDisconnect then
      warn("\"ncgdTES3MP.OnPlayerDisconnect\" is being force loaded!!")
   end
   info("Called \"OnPlayerDisconnect\" for pid \"" .. pid .. "\"")
   updatePlayTime(pid)
end

function ncgdTES3MP.OnPlayerEndCharGen(eventStatus, pid)
   if not eventStatus.validCustomHandlers and not ncgdTES3MP.config.forceLoadOnPlayerEndCharGen then
      fatal("validCustomHandlers for `OnPlayerEndCharGen` have been set to false!" ..
               "  ncgdTES3MP requires custom handlers to operate!")
      fatal("Exiting now to avoid problems.  Please set \"forceLoadOnPlayerEndCharGen\"" ..
            " to \"true\" if you're sure it's OK.")
      tes3mp.StopServer()
   end
   if ncgdTES3MP.config.forceLoadOnPlayerEndCharGen then
      warn("\"ncgdTES3MP.OnPlayerEndCharGen\" is being force loaded!!")
   end

   info("Called \"OnPlayerEndCharGen\" for pid \"" .. pid .. "\"")

   if Players[pid].data.customVariables[NCGD] == nil then
      Players[pid].data.customVariables[NCGD] = {}
   end

   for _, attribute in pairs(Attributes) do
      initAttribute(pid, attribute)
   end

   for _, skill in pairs(Skills) do
      initSkill(pid, skill)
      initSkillDecay(pid, skill)
   end

   if ncgdTES3MP.config.healthMod then
      modHealth(pid)
   end

   local decayRate = getDecayRate()
   recalculateDecayMemory(pid, decayRate, true)
   local decayMemory = getCustomVar(pid, "decayMemory")

   setCustomVar(pid, "charGenDone", "t")
   -- The mwscript version of NCGD initializes this variable to `100`, but due to general
   -- differences doing that here causes decay to happen much too rapidly at first (instantly).
   setCustomVar(pid, "decayMemory", decayMemory)
   setCustomVar(pid, "decayRate", decayRate)

   dbg("NCGD CharGen completed for pid \"" .. pid .. "\"")
end

function ncgdTES3MP.OnPlayerLevel(eventStatus, pid)
   if not eventStatus.validCustomHandlers and not ncgdTES3MP.config.forceLoadOnPlayerLevel then
      fatal("validCustomHandlers for `OnPlayerLevel` have been set to false!" ..
               "  ncgdTES3MP requires custom handlers to operate!")
      fatal("Exiting now to avoid problems.  Please set \"forceLoadOnPlayerLevel\"" ..
            " to \"true\" if you're sure it's OK.")
      tes3mp.StopServer()
   end
   if ncgdTES3MP.config.forceLoadOnPlayerLevel then
      warn("\"ncgdTES3MP.OnPlayerLevel\" is being force loaded!!")
   end
   info("Called \"OnPlayerLevel\" for pid \"" .. pid .. "\"")

   -- Block custom behavior, and the default
   customEventHooks.makeEventStatus(false, false)
end

function ncgdTES3MP.Cmd(pid, cmd)
   info("Called \"ncgdTES3MP.Cmd\" for player \"" .. logicHandler.GetChatName(pid) .. "\".")
   if Players[pid].data.settings.staffRank < ncgdTES3MP.config.reqRank then
      chatMsg(pid, ncgdTES3MP.config.rankErr)
      return
   end

   local cooldown = ncgdTES3MP.config.cmdCooldown
   local diff = os.difftime(os.time(), getCustomVar(pid, "lastCmd"))

   if diff < cooldown then
      chatMsg(pid, "You must wait " .. cooldown - diff .. " more seconds!")
      return
   end

   local command = cmd[2]
   local targetPid = cmd[3]

   if targetPid == nil then
      targetPid = pid
   end

   if Players[targetPid] == nil then
      chatMsg(pid, "That pid does not exist!")
      return
   end

   if command == "health" or command == "h" then
      if ncgdTES3MP.config.healthMod then
         modHealth(pid)
         chatMsg(targetPid, "Health has been recalculated.")
      end
      setCustomVar(pid, "lastCmd", os.time())

   elseif command == "recalcattrs" or command == "a" then
      for _, attr in pairs(Attributes) do
         recalculateAttribute(targetPid, attr)
      end
      chatMsg(targetPid, "All attributes have been recalculated.")
      setCustomVar(pid, "lastCmd", os.time())

   elseif command == "recalcdecaymem" or command == "d" then
   if ncgdTES3MP.config.decayRate ~= none then
      recalculateDecayMemory(targetPid, getDecayRate(), true)
      chatMsg(targetPid, "Decay memory has been recalculated.")
   end
   setCustomVar(pid, "lastCmd", os.time())

   elseif command == "reloadskilldata" or command == "s" then
      for _, skill in pairs(Skills) do
         local playerBase = Players[targetPid].data.skills[skill].base
         local skillMax = getCustomVar(targetPid, "max" .. skill)
         setCustomVar(targetPid, "base" .. skill, playerBase)
         if playerBase > skillMax then
            setCustomVar(targetPid, "max" .. skill, playerBase)
         end
      end
      chatMsg(targetPid, "Skill base and max value data has been updated from player data.")
      setCustomVar(pid, "lastCmd", os.time())

   elseif command == "all" then
      if ncgdTES3MP.config.healthMod then
         modHealth(pid)
      end
      for _, attr in pairs(Attributes) do
         recalculateAttribute(targetPid, attr)
      end
      if ncgdTES3MP.config.decayRate ~= none then
         recalculateDecayMemory(targetPid, getDecayRate(), true)
      end
      for _, skill in pairs(Skills) do
         local playerBase = Players[targetPid].data.skills[skill].base
         local skillMax = getCustomVar(targetPid, "max" .. skill)
         setCustomVar(targetPid, "base" .. skill, playerBase)
         if playerBase > skillMax then
            setCustomVar(targetPid, "max" .. skill, playerBase)
         end
      end
      chatMsg(targetPid, "All data and stats have been reloaded.")
      setCustomVar(pid, "lastCmd", os.time())

   else
      chatMsg(pid, "Usage: /ncgd <health|recalcattrs|reloadskilldata|all> [optional pid]")
   end
end


customCommandHooks.registerCommand("ncgd", ncgdTES3MP.Cmd)

customEventHooks.registerValidator("OnPlayerDisconnect", ncgdTES3MP.OnPlayerDisconnect)
customEventHooks.registerValidator("OnPlayerLevel", ncgdTES3MP.OnPlayerLevel)
customEventHooks.registerValidator("OnPlayerSkill", ncgdTES3MP.OnPlayerSkill)

customEventHooks.registerHandler("OnPlayerAuthentified", ncgdTES3MP.OnPlayerAuthentified)
customEventHooks.registerHandler("OnPlayerDeath", ncgdTES3MP.OnPlayerDeath)
customEventHooks.registerHandler("OnPlayerEndCharGen", ncgdTES3MP.OnPlayerEndCharGen)
