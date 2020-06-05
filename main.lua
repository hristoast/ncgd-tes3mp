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
local logPrefix = "[ " .. ncgdTES3MP.scriptName .. " ]: "

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
   math.randomseed(os.time())
   return math.random(rangeStart, rangeEnd)
end

local function getAttribute(pid, attribute, base)
   if base then
      return Players[pid].data.attributes[attribute].base
   else
      return Players[pid].data.attributes[attribute].base - Players[pid].data.attributes[attribute].damage
   end
end

local function setAttribute(pid, attribute, value, save)
   Players[pid].data.attributes[attribute].base = value
   Players[pid].data.attributes[attribute].skillIncrease = 0
   if save ~= nil then
      Players[pid]:LoadAttributes()
   end
end

local function setPlayerLevel(pid, value)
   Players[pid].data.stats.level = value
   Players[pid]:LoadLevel()
end

local function getCustomVar(pid, key, subkey)
   if Players[pid].data.customVariables.NCGD ~= nil then
      if subkey then
         return Players[pid].data.customVariables.NCGD[key][subkey]
      else
         return Players[pid].data.customVariables.NCGD[key]
      end
   end
end

local function setCustomVar(pid, key, val, subkey)
   if Players[pid].data.customVariables.NCGD ~= nil then
      if subkey then
         Players[pid].data.customVariables.NCGD[key][subkey] = val
      else
         Players[pid].data.customVariables.NCGD[key] = val
      end
   end
end

local function hasNCGDdata(pid)
   return Players[pid].data.customVariables.NCGD ~= nil
end

local function recalculateDecayMemory(pid, rate, force)
   if not getCustomVar(pid, "charGenDone") and not force then return end

   local decayMemory
   local baseINT = getCustomVar(pid, "attributes", Intelligence).base
   local playerLvl = tes3mp.GetLevel(pid)

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
      if newLevel >= ncgdTES3MP.config.levelCap then return false end
   end
   return true
end

local function recalculateAttribute(pid, attribute)
   dbg("Called \"recalculateAttribute\" for pid \"" .. pid .. "\" and attribute \"" .. attribute .. "\".")

   local attrsTable = getCustomVar(pid, "attributes")
   local baseAttr = attrsTable[attribute].base
   local startAttr = attrsTable[attribute].start

   local recalculateLuck = false
   -- TODO: give these better names
   local temp = 0
   local temp2

   for skill, multiplier in pairs(ncgdTES3MP.config.modifiers[attribute]) do
      local baseSkill = tes3mp.GetSkillBase(pid, tes3mp.GetSkillId(skill))

      -- This is in leiu of how real NCGD multiplies temp2 against 25 * some mastery value
      temp2 = 0

      temp2 = temp2 + baseSkill
      temp2 = temp2 * temp2

      if multiplier ~= 0 then temp2 = temp2 * multiplier end

      temp = temp + temp2
   end

   if attribute == Luck then
      temp2 = temp * 2
      temp2 = math.floor(temp2 / tes3mp.GetSkillCount())
      temp2 = math.floor(math.sqrt(temp2))

      -- TODO: Some way of reporting level progress.
      if temp2 > 25 then
         local oldLevel = Players[pid].data.stats.level
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
         if tes3mp.GetLevel(pid) > 1 then
            dbg("Player with pid \"" .. pid .. "\" regressed to level 1.")
            gameMsg(pid, "You have regressed to Level 1.")
            setPlayerLevel(pid, 1)
         end
      end
   end

   -- Adjust XP based on growth speed
   temp2 = temp * ncgdTES3MP.config.growthRates[string.lower(ncgdTES3MP.config.growthRate)]
   temp = math.floor(temp2 / tes3mp.GetSkillCount())

   -- Converts XP into attributes
   temp2 = math.floor(math.sqrt(temp))
   temp = temp2 + startAttr

   local attrChanged

   if (temp <= config.maxAttributeValue and attribute ~= Speed)
   or (temp <= config.maxSpeedValue and attribute == Speed) then
      if temp > baseAttr then
         gameMsg(pid, "Your " .. attribute ..  " has increased to " .. temp .. ".")
      elseif temp < baseAttr then
         gameMsg(pid, "Your " .. attribute ..  " has decayed to " .. temp .. ".")
      end
      setAttribute(pid, attribute, temp, true)
      attrsTable[attribute].base = temp
      attrChanged = true
      if attribute ~= Luck then recalculateLuck = true end

   else
      dbg("Attribute increase denied to pid \"" .. pid .. "\" due to hitting the server cap.")
      gameMsg(pid, string.format(ncgdTES3MP.config.attributeCapMsg, attribute))
   end

   if attrChanged then setCustomVar(pid, "attributes", attrsTable) end

   return recalculateLuck
end

local function initAttribute(pid, attribute)
   dbg("Called \"initAttribute\" for pid \"" .. pid .. "\" and attribute \"" .. attribute .. "\"")
   local startAttr = getAttribute(pid, attribute, true)
   -- Reduces the attribute to account for gain from skills
   startAttr = math.floor(startAttr / 2)

   local Attribute = {
      ["base"] = startAttr,
      ["start"] = startAttr
   }

   setCustomVar(pid, "attributes", Attribute, attribute)
   recalculateAttribute(pid, attribute)
end

local function initSkill(pid, skill)
   dbg("Called \"initSkill\" for pid \"" .. pid .. "\" and skill \"" .. skill .. "\"")
   local baseSkill = tes3mp.GetSkillBase(pid, tes3mp.GetSkillId(skill))

   local Skill = {
      ["base"] = baseSkill,
      ["decay"] = math.floor(randInt(0, 359) / 30),
      ["max"] = baseSkill,
      ["start"] = baseSkill
   }

   setCustomVar(pid, "skills", Skill, skill)
end

local function getDecayRate(pid)
   return Players[pid].data.customVariables.NCGD.decayRate
      or ncgdTES3MP.config.decayRates[string.lower(ncgdTES3MP.config.decayRate)]
end

local function updatePlayTime(pid)
   local pt = getCustomVar(pid, "loginPlayTime")

   -- The player might be quitting before finishing chargen,
   -- so this and more would never be set.  Bail.
   if pt == nil then return end

   local loginDaysPassed = pt["daysPassed"]
   local loginHour = pt["hour"]
   local loginPlayTime = pt["playTime"]

   local nowDaysPassed = WorldInstance.data.time.daysPassed
   local nowHour = WorldInstance.data.time.hour

   local daysPassed = nowDaysPassed - loginDaysPassed

   local totalHours = math.floor(daysPassed * 24 + loginPlayTime - loginHour + nowHour)

   setCustomVar(pid, "playTime", totalHours)
   return totalHours
end

local function processDecay(pid)
   local hoursPassed = updatePlayTime(pid)
   local daysPassed = math.floor(hoursPassed / 24)
   local worldHour = WorldInstance.data.time.hour
   local timePassed = worldHour

   local deathTime = getCustomVar(pid, "deathTime")

   if deathTime ~= nil then
      local playTime = getCustomVar(pid, "playTime")
      if playTime - deathTime > ncgdTES3MP.config.deathDecay.durationHrs then
         setCustomVar(pid, "deathTime", nil)
         -- Revert accelerated decay
         setCustomVar(pid, "decayRate", ncgdTES3MP.config.decayRates[string.lower(ncgdTES3MP.config.decayRate)])
      end
   end

   local decayMemory = getCustomVar(pid, "decayMemory")
   local oldDay = getCustomVar(pid, "oldDay") or 0

   while oldDay < daysPassed do
      timePassed = timePassed + 24
      oldDay = oldDay + 1
   end

   setCustomVar(pid, "oldDay", math.floor(hoursPassed / 24))

   local aSkillDecayed
   local skillsTable = Players[pid].data.customVariables.NCGD.skills

   for _, skill in pairs(Skills) do
      skillsTable[skill].decay = skillsTable[skill].decay + timePassed

      -- Check to see if enough decay has accumulated
      if skillsTable[skill].decay > decayMemory then
         skillsTable[skill].decay = 0
         -- Only proceed with decay if the skill isn't lower than half it's known max
         if skillsTable[skill].base > math.floor(skillsTable[skill].max / 2) then
            -- ... and if it isn't already lower than the minimum level.
            if skillsTable[skill].base > ncgdTES3MP.config.decayMinLvl then

               dbg("Player with pid \"" .. pid .. "\" had skill \"" ..  skill
                      .. "\" decay from \"" .. tostring(skillsTable[skill].base) ..
                      "\" to \"" .. tostring(skillsTable[skill].base - 1) .. "\".")

               skillsTable[skill].base = skillsTable[skill].base - 1
               Players[pid].data.skills[skill].base = skillsTable[skill].base

               aSkillDecayed = true

               local attributes = ncgdTES3MP.config.skillAttributes[skill]

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

   if aSkillDecayed then
      Players[pid]:LoadSkills()
      setCustomVar(pid, "skills", skillsTable)
   end
end

local function modHealth(pid)
   local oldBaseHP = tes3mp.GetHealthBase(pid)
   local oldCurrentHP = tes3mp.GetHealthCurrent(pid)

   local hpRatio = oldCurrentHP / oldBaseHP

   if hpRatio == 0 then return end -- player died

   local End = getAttribute(pid, Endurance)
   local Str = getAttribute(pid, Strength)
   local Wil = getAttribute(pid, Willpower)

   local newBaseHP = math.floor(End) + math.floor(Str / 2) + math.floor(Wil / 4)

   -- Work-around for abilities not being saved to server
   -- https://github.com/hristoast/ncgd-tes3mp/issues/3
   if Players[pid].data.character.birthsign == "lady's favor" then
      newBaseHP = newBaseHP + 25
   end

   newCurrentHP = newBaseHP * hpRatio

   -- Do nothing if the health difference is less than 1
   -- http://lua-users.org/wiki/SimpleRound
   if math.abs(math.floor(oldCurrentHP + 0.5) - math.floor(newCurrentHP + 0.5)) < 1 then
      info("Ignored health change of pid \"" .. pid .. "\"")
      return
   end

   info("Modifying base health of pid \"" .. pid .. "\" from \"" ..
          oldBaseHP .. "\" to \"" .. tostring(newBaseHP) .. "\"")

   info("Modifying current health of pid \"" .. pid .. "\" from \"" .. oldCurrentHP
          .. "\" to \"" .. tostring(newCurrentHP) .. "\"")

   Players[pid].data.stats.healthBase = newBaseHP
   Players[pid].data.stats.healthCurrent = newCurrentHP

   tes3mp.SetHealthBase(pid, newBaseHP)
   tes3mp.SetHealthCurrent(pid, newCurrentHP)

   tes3mp.SendStatsDynamic(pid)
end

local function initPlayer(pid)
   Players[pid].data.customVariables.NCGD = {}
   Players[pid].data.customVariables.NCGD.attributes = {}
   Players[pid].data.customVariables.NCGD.skills = {}

   for _, attribute in pairs(Attributes) do
      initAttribute(pid, attribute)
   end

   for _, skill in pairs(Skills) do
      initSkill(pid, skill)
   end

   if ncgdTES3MP.config.healthMod then
      modHealth(pid)
   end

   local decayRate = getDecayRate(pid)
   recalculateDecayMemory(pid, decayRate, true)
   setCustomVar(pid, "charGenDone", true)
   setCustomVar(pid, "decayRate", decayRate)
end

local function safelyRunEvent(eventStatus, eventName, forceLoadOpt)
   if not eventStatus.validCustomHandlers and not forceLoadOpt then
      fatal("validCustomHandlers for `" .. eventName .. "` have been set to false!" ..
               "  ncgdTES3MP requires custom handlers to operate!")
      fatal("Exiting now to avoid problems.  Please set \"forceLoad" ..  eventName .. "\"" ..
            " to \"true\" if you're sure it's OK.")
      tes3mp.StopServer()
   end
   if forceLoadOpt then warn("\"ncgdTES3MP." .. eventName .. "\" is being force loaded!!") end
end

function ncgdTES3MP.OnPlayerSkill(eventStatus, pid)
   if not getCustomVar(pid, "charGenDone") then return end
   safelyRunEvent(eventStatus, "OnPlayerSkill", ncgdTES3MP.config.forceLoadOnPlayerSkill)
   info("Called \"OnPlayerSkill\" for pid \"" .. pid .. "\"")

   local changedSkill
   local skillsTable = Players[pid].data.customVariables.NCGD.skills

   for skill, _ in pairs(Players[pid].data.skills) do
      local ncgdBase = skillsTable[skill].base
      local skillBase = tes3mp.GetSkillBase(pid, tes3mp.GetSkillId(skill))

      if ncgdBase ~= skillBase then
         changedSkill = skill
         if skillBase > skillsTable[skill].max then
            skillsTable[skill].decay = math.floor(skillsTable[skill].decay / 2)
            skillsTable[skill].max = skillBase
         end
         skillsTable[skill].base = skillBase
      end

      -- Zero out levelProgress to stop the vanilla level up
      Players[pid].data.stats.levelProgress = 0
      Players[pid]:LoadLevel()

      if changedSkill then break end
   end

   if changedSkill then
      setCustomVar(pid, "skills", skillsTable)

      -- TODO: Batch calculate and save attributes the way skills are
      local recalcLuck = false
      local modHP = false
      for _, attribute in pairs(ncgdTES3MP.config.skillAttributes[changedSkill]) do
         recalcLuck = recalculateAttribute(pid, attribute)

         if ncgdTES3MP.config.healthMod
         and tableHelper.containsValue(healthAttributes, attribute) then
            modHP = true
         end
      end

      if modHP then modHealth(pid) end

      if recalcLuck then recalculateAttribute(pid, Luck) end
   end

   if ncgdTES3MP.config.decayRate ~= none then processDecay(pid) end
end

function ncgdTES3MP.OnPlayerAuthentified(eventStatus, pid)
   if not ncgdTES3MP.config.deathDecay.enabled and ncgdTES3MP.config.decayRate == none  then return end
   safelyRunEvent(eventStatus, "OnPlayerAuthentified", ncgdTES3MP.config.forceLoadOnPlayerAuthentified)
   info("Called \"OnPlayerAuthentified\" for pid \"" .. pid .. "\"")
   if not hasNCGDdata(pid) then
      warn("Importing non-NCGD player named \"" .. Players[pid].accountName .. "\"!")
      chatMsg(pid, color.Red .. "Your stats are being converted to NCGD.  They will not be "
              .. "the same as if you started fresh with NCGD!  As such, a new "
              .. "character is advised.  At any rate, have fun!" .. color.Default)
      initPlayer(pid)
   end
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
   if not ncgdTES3MP.config.deathDecay.enabled then return end
   safelyRunEvent(eventStatus, "OnPlayerDeath", ncgdTES3MP.config.forceLoadOnPlayerDeath)
   info("Called \"OnPlayerDeath\" for pid \"" .. pid .. "\"")

   local deathTime = getCustomVar(pid, "deathTime")

   if deathTime == nil or ncgdTES3MP.config.deathDecay.stacks then
      local msg = "Death has caused your decay rate to increase " .. ncgdTES3MP.config.deathDecay.modifier
      .. "x for " .. ncgdTES3MP.config.deathDecay.durationHrs

      if ncgdTES3MP.config.deathDecay.durationHrs > 1 then
         msg = msg .. " hours..."
      else
         msg = msg .. " hour..."
      end

      chatMsg(pid, msg)
      setCustomVar(pid, "deathTime", getCustomVar(pid, "playTime"))
      setCustomVar(pid, "decayRate", getCustomVar(pid, "decayRate") * ncgdTES3MP.config.deathDecay.modifier)
   end
end

function ncgdTES3MP.OnPlayerDisconnect(eventStatus, pid)
   if not ncgdTES3MP.config.deathDecay.enabled then return end
   safelyRunEvent(eventStatus, "OnPlayerDisconnect", ncgdTES3MP.config.forceLoadOnPlayerDisconnect)
   info("Called \"OnPlayerDisconnect\" for pid \"" .. pid .. "\"")
   updatePlayTime(pid)
end

function ncgdTES3MP.OnPlayerEndCharGen(eventStatus, pid)
   safelyRunEvent(eventStatus, "OnPlayerEndCharGen", ncgdTES3MP.config.forceLoadOnPlayerEndCharGen)
   info("Called \"OnPlayerEndCharGen\" for pid \"" .. pid .. "\"")
   initPlayer(pid)
end

function ncgdTES3MP.OnPlayerLevel(eventStatus, pid)
   safelyRunEvent(eventStatus, "OnPlayerLevel", ncgdTES3MP.config.forceLoadOnPlayerLevel)
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

   local decayRate = getDecayRate(targetPid)
   local skillsTable = Players[targetPid].data.customVariables.NCGD.skills

   if command == "health" or command == "h" then
      if ncgdTES3MP.config.healthMod then
         modHealth(pid)
         chatMsg(targetPid, "Health has been recalculated.")
      end

   elseif command == "recalcattrs" or command == "a" then
      for _, attr in pairs(Attributes) do
         recalculateAttribute(targetPid, attr)
      end
      chatMsg(targetPid, "All attributes have been recalculated.")
      setCustomVar(pid, "lastCmd", os.time())

   elseif command == "recalcdecaymem" or command == "d" then
   if ncgdTES3MP.config.decayRate ~= none then
      recalculateDecayMemory(targetPid, decayRate, true)
      chatMsg(targetPid, "Decay memory has been recalculated.")
   end

   elseif command == "reloadskilldata" or command == "s" then
      for _, skill in pairs(Skills) do
         local playerBase = tes3mp.GetSkillBase(targetPid, tes3mp.GetSkillId(skill))
         local skillMax = skillsTable[skill].max
         skillsTable[skill].base = playerBase
         if playerBase > skillMax then
            skillsTable[skill].max = playerBase
         end
      end
      setCustomVar(pid, "skills", skillsTable)
      chatMsg(targetPid, "Skill base and max value data has been updated from player data.")

   elseif command == "all" then
      if ncgdTES3MP.config.healthMod then
         modHealth(pid)
      end
      for _, attr in pairs(Attributes) do
         recalculateAttribute(targetPid, attr)
      end
      if ncgdTES3MP.config.decayRate ~= none then
         recalculateDecayMemory(targetPid, decayRate, true)
      end
      for _, skill in pairs(Skills) do
         local playerBase = tes3mp.GetSkillBase(targetPid, tes3mp.GetSkillId(skill))
         local skillMax = skillsTable[skill].max
         skillsTable[skill].base = playerBase
         if playerBase > skillMax then
            skillsTable[skill].max = playerBase
         end
      end
      setCustomVar(pid, "skills", skillsTable)
      chatMsg(targetPid, "All data and stats have been reloaded.")

   else
      chatMsg(pid, "Usage: /ncgd <health|recalcattrs|reloadskilldata|all> [optional pid]")
      return
   end
   setCustomVar(pid, "lastCmd", os.time())
end


customCommandHooks.registerCommand("ncgd", ncgdTES3MP.Cmd)

customEventHooks.registerValidator("OnPlayerDisconnect", ncgdTES3MP.OnPlayerDisconnect)
customEventHooks.registerValidator("OnPlayerLevel", ncgdTES3MP.OnPlayerLevel)
customEventHooks.registerValidator("OnPlayerSkill", ncgdTES3MP.OnPlayerSkill)

customEventHooks.registerHandler("OnPlayerAuthentified", ncgdTES3MP.OnPlayerAuthentified)
customEventHooks.registerHandler("OnPlayerDeath", ncgdTES3MP.OnPlayerDeath)
customEventHooks.registerHandler("OnPlayerEndCharGen", ncgdTES3MP.OnPlayerEndCharGen)
