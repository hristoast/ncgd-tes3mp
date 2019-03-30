local ncgdTES3MP = {}

local ncgdConfig = {}


ncgdConfig.deathDecay = true
ncgdConfig.levelCap = nil
ncgdConfig.decayRate = "fast"
ncgdConfig.growthRate = "slow"


local function dbg(msg)
   --[[ Convenient logging wrapper. ]]--
   tes3mp.LogMessage(enumerations.log.VERBOSE, "[ ncgdTES3MP ]: " .. msg)
end


local function err(msg)
   --[[ Convenient logging wrapper. ]]--
   tes3mp.LogMessage(enumerations.log.ERROR, "[ ncgdTES3MP ]: " .. msg)
end


local function fatal(msg)
   --[[ Convenient logging wrapper. ]]--
   tes3mp.LogMessage(enumerations.log.FATAL, "[ ncgdTES3MP ]: " .. msg)
end


local function warn(msg)
   --[[ Convenient logging wrapper. ]]--
   tes3mp.LogMessage(enumerations.log.WARN, "[ ncgdTES3MP ]: " .. msg)
end


local function info(msg)
   --[[ Convenient logging wrapper. ]]--
   tes3mp.LogMessage(enumerations.log.INFO, "[ ncgdTES3MP ]: " .. msg)
end


local function randInt(rangeStart, rangeEnd)
   -- THANKS: https://stackoverflow.com/a/20157671
   math.random()
   math.random()
   math.random()
   -- TODO: math.ceil() does not work at all.  Nor does math.floor()
   return math.ceil(math.random(rangeStart, rangeEnd))
end


local function savePlayer(pid)
   dbg("Called \"savePlayer\" for pid \"" .. pid .. "\"")
   Players[pid]:LoadAttributes()
   Players[pid]:LoadSkills()

   Players[pid]:LoadInventory()
   Players[pid]:LoadEquipment()
   Players[pid]:LoadQuickKeys()
end


local function getSkillValue(pid, skill)
   dbg("Called \"getSkillValue\" for pid \"" .. pid .. "\" and skill \"" .. skill .. "\"")
   return Players[pid].data.skills[skill]
end

local function getCustomVar(pid, key)
   dbg("Called \"getCustomVar\" for pid \"" .. pid .. "\" and key \"" .. key .. "\"")
   return Players[pid].data.customVariables[key]
end


local function setCustomVar(pid, key, val, save)
   dbg("Called \"setCustomVar\" for pid \"" .. pid .. "\", key \"" .. key .. "\", and value \"" .. val .. "\".")

   Players[pid].data.customVariables["NCGD"][key] = val

   if save ~= nil then
      savePlayer(pid)
   end
end


local function calculateDecayMemory(pid)
   dbg("Called \"calculateDecayMemory\" for pid \"" .. pid .. "\"")
   local baseInt = getCustomVar(pid, "baseIntelligence")
   local decayMemory

   -- Values represent hours
   local one_day = 24
   local three_days = 72
   local seven_days = 168
   local fourteen_days = 336

   local player = Players[pid]
   local playerLevel = player.data.stats.level

   decayMemory = playerLevel * playerLevel
   decayMemory = (baseInt * baseInt) / decayMemory

   if ncgdConfig.decayRate == "slow" then
      decayMemory = decayMemory * fourteen_days
      decayMemory = decayMemory + three_days

   elseif ncgdConfig.decayRate == "standard" then
      decayMemory = decayMemory * seven_days
      decayMemory = decayMemory + one_day

   elseif ncgdConfig.decayRate == "fast" then
      decayMemory = decayMemory * three_days
      decayMemory = decayMemory + 12
   end

   setCustomVar(pid, "decayMemory", decayMemory)
end


local function getNewAttributeValue(pid, attribute)
   dbg("Called \"getNewAttributeValue\" for pid \"" .. pid .. "\" and attribute \"" .. attribute .. "\"")
   local player = Players[pid]

   -- Record current attribute value
   local currentAttribute = player.data.attributes[attribute]

   -- NCGD uses 1000 as a very high value for finding fortifications
   local magicNumber = 1000

   -- Set base attribute to a known value
   player.data.attributes[attribute] = magicNumber

   -- Get fortification, if any
   local fortification = player.data.attributes[attribute] - magicNumber

   -- Find the base attribute value, less any fortification
   local baseValue = currentAttribute - fortification

   -- Reduce attribute to account for gain from skills
   local newValue = baseValue / 2

   return newValue
end


local function checkForSkillDecay(pid, skill)
   dbg("Called \"checkForSkillDecay\" for pid \"" .. pid .. "\" and skill \"" .. skill .. "\"")
   -- See line 4877 in NCGD_Main
   local decaySkill = getCustomVar(pid, "decay" .. skill)
   local decayMemory = getCustomVar(pid, "decayMemory")
   local masterySkill = getCustomVar(pid, "mastery" .. skill)
   local maxSkill = config.maxSkillValue
   local oldDay = getCustomVar(pid, "oldDay")
   local oldHour = getCustomVar(pid, "oldHour")
   local skillVal = getSkillValue(pid, skill)
   local timePassed = WorldInstance.data.time.hour

   while oldDay < WorldInstance.data.time.daysPassed do
      timePassed = timePassed + 24
      oldDay = oldDay + 1
   end

   timePassed = timePassed - oldHour
   oldHour = WorldInstance.data.time.hour
   decaySkill = decaySkill + timePassed

   if decaySkill > decayMemory then
      decaySkill = 0

      masterySkill = 25 * masterySkill
      skillVal = skillVal + masterySkill
      masterySkill = maxSkill / 2

      if skillVal > masterySkill then
         if skillVal > 15 then
            -- Skill has decayed
            skillVal = skillVal - 1
            setCustomVar(pid, "skill" .. skill, skillVal)
            Players[pid].data.skills[skill] = skillVal
            savePlayer(pid)
            -- TODO: message box "Your " .. skill .. " skill has decayed to " .. tostring(number) .. "."
            -- TODO: the mwscript version then does this:
            -- set skillBlock to 0	; Force recheck
            -- But I don't think I need this mechanism to "force a recheck"
         end
      end
   end

   -- Save up
   setCustomVar(pid, "decay" .. skill, decaySkill)
   setCustomVar(pid, "mastery" .. skill, masterySkill)
   setCustomVar(pid, "oldDay", oldDay)
   setCustomVar(pid, "oldHour", oldHour)
   setCustomVar(pid, "timePassed", timePassed)
end


local function calculateSkillUpdate(pid, skill)
   dbg("Called \"calculateSkillUpdate\" for pid \"" .. pid .. "\" and skill \"" .. skill .. "\"")
   local player = Players[pid]

   local skillProgress = getCustomVar(pid, "progress" .. skill)
   local skillVal = getCustomVar(pid, "skill" .. skill)
   local actualVal = player.data.skills[skill]

   if skillVal ~= actualVal then
      
   end

   --[[
	; Combat skill check
	if (skillBlock != player->getBlock)
		set skillBlock to player->getBlock
		player->setBlock 1000
		set temp2 to player->getBlock - 1000
		set skillBlock to skillBlock - temp2
		if (skillBlock != baseBlock) ; If Block skill has changed, recalculate attributes
			set recalcSTR to 1
			set recalcAGI to 1
			set recalcEND to 1
		endif
		if (skillBlock > baseBlock)
			set temp to skillBlock
			set temp2 to 25 * masteryBlock
			set temp to temp + temp2
			if (temp < maxBlock)
				if (progressBlock < masteryBlock)
					set progressBlock to progressBlock + 1
				else
					set temp to temp + 1
					set skillBlock to skillBlock + 1
					set progressBlock to 0
					MessageBox "Your Block skill increased to %.0g.", temp
					set decayBlock to decayBlock / 2
				endif
			elseif (progressBlock >= masteryBlock)
				set maxBlock to temp
			endif
			if (progressBlock < masteryBlock)
				set skillBlock to skillBlock - 1
				player->setBlock skillBlock
				set progressBlock to progressBlock + 1
				set skillBlock to player->getBlock
				MessageBox "You need more training before your skill will improve.  (%.0g out of %.0g)", progressBlock, (masteryBlock+1)
			elseif (skillBlock < 100)
				if (masteryBlock > 0)
					MessageBox "Your Block skill increased to %.0g.", temp
				endif
				set baseBlock to skillBlock
				player->setBlock skillBlock
				set progressBlock to 0
				set skillBlock to player->getBlock
				set decayBlock to decayBlock / 2
			else
				if (masteryBlock > 0)
					MessageBox "Your Block skill increased to %.0g.", temp
				endif
				set masteryBlock to masteryBlock + 1
				set baseBlock to skillBlock - 25
				player->setBlock baseBlock
				set progressBlock to 0
				set skillBlock to player->getBlock
				set decayBlock to decayBlock / 2
				set temp2 to masteryBlock
				player->removeSpell "NCGD_block25"
				player->removeSpell "NCGD_block50"
				player->removeSpell "NCGD_block100"
				player->removeSpell "NCGD_block200"
				if (temp2 >= 8)
					player->addSpell "NCGD_block200"
					set temp2 to temp2 - 8
				endif
				if (temp2 >= 4)
					player->addSpell "NCGD_block100"
					set temp2 to temp2 - 4
				endif
				if (temp2 >= 2)
					player->addSpell "NCGD_block50"
					set temp2 to temp2 - 2
				endif
				if (temp2 >= 1)
					player->addSpell "NCGD_block25"
				endif
			endif
		elseif (masteryBlock > 0)
			if(skillBlock < 75)
				set masteryBlock to masteryBlock - 1
				set baseBlock to skillBlock + 25
				player->setBlock baseBlock
				set skillBlock to player->getBlock
				set temp2 to masteryBlock
				player->removeSpell "NCGD_block25"
				player->removeSpell "NCGD_block50"
				player->removeSpell "NCGD_block100"
				player->removeSpell "NCGD_block200"
				if (temp2 >= 8)
					player->addSpell "NCGD_block200"
					set temp2 to temp2 - 8
				endif
				if (temp2 >= 4)
					player->addSpell "NCGD_block100"
					set temp2 to temp2 - 4
				endif
				if (temp2 >= 2)
					player->addSpell "NCGD_block50"
					set temp2 to temp2 - 2
				endif
				if (temp2 >= 1)
					player->addSpell "NCGD_block25"
				endif
			else
				set baseBlock to skillBlock
				player->setBlock skillBlock
				set skillBlock to player->getBlock
			endif
		else
			set baseBlock to skillBlock
			player->setBlock skillBlock
			set skillBlock to player->getBlock
		endif
	elseif (skillArmorer != player->getArmorer)
   ]]--
end


local function initAttribute(pid, attribute)
   dbg("Called \"initAttribute\" for pid \"" .. pid .. "\" and attribute \"" .. attribute .. "\"")

   local config = require("config")
   -- Save old values
   local oldMaxAttributeValue = config.maxAttributeValue
   local oldMaxSkillValue = config.maxSkillValue

   -- TODO: maybe this is not needed.  Temporarily increase values
   config.maxAttributeValue = config.maxAttributeValue * 10
   config.maxSkillValue = config.maxSkillValue * 10

   local player = Players[pid]

   player.data.attributes[attribute] = getNewAttributeValue(pid, attribute)

   -- Record the base attribute value for future reference, don't save because we're about to do that
   setCustomVar(pid, "base" .. attribute, player.data.attributes[attribute])

   -- Revert values.
   config.maxAttributeValue = oldMaxAttributeValue
   config.maxSkillValue = oldMaxSkillValue
end


local function initSkill(pid, skill)
   dbg("Called \"initSkill\" for pid \"" .. pid .. "\" and skill \"" .. skill .. "\"")
   setCustomVar(pid, "progress" .. skill, 0)
   setCustomVar(pid, "skill" .. skill, getSkillValue(pid, skill))
end


local function initSkillDecay(pid, skill)
   dbg("Called \"initSkillDecay\" for pid \"" .. pid .. "\" and skill \"" .. skill .. "\"")

   local decayRate = randInt(0, 359)

   -- NCGD uses 30 for this.  I'm not sure if that is a special number or what.
   local magicNumber = 30

   setCustomVar(pid, "decay" .. skill, decayRate / magicNumber)
end


local function initSkillMastery(pid, skill)
   dbg("Called \"initSkillMastery\" for pid \"" .. pid .. "\" and skill \"" .. skill .. "\"")
   setCustomVar(pid, "mastery" .. skill, 0)
end


function ncgdTES3MP.OnPlayerEndChargen(eventStatus, pid)
   if not eventStatus.validCustomHandlers then
      err("validCustomHandlers for `OnPlayerEndChargen` have been set to false!" ..
             "  ncgdTES3MP requires custom handlers to operate!")
      fatal("Exiting the server now... Please set `ForceLoad` to true if you are sure ncgdTES3MP should load anyways.")
   else
      info("Called \"OnPlayerEndChargen\" for pid \"" .. pid .. "\"")

      Players[pid].data.customVariables["NCGD"] = {}

      local Attributes = { "Strength", "Intelligence", "Willpower", "Agility",
                           "Speed", "Endurance", "Personality", "Luck" }

      local Skills = { "Block", "Armorer", "Mediumarmor", "Heavyarmor", "Bluntweapon", "Longblade", "Axe", "Spear",
                       "Athletics", "Enchant", "Destruction", "Alteration", "Illusion", "Conjuration", "Mysticism",
                       "Restoration", "Alchemy", "Unarmored", "Security", "Sneak", "Acrobatics", "Lightarmor",
                       "Shortblade", "Marksman", "Mercantile", "Speechcraft", "Handtohand" }

      for _, attribute in pairs(Attributes) do
         initAttribute(pid, attribute)
      end

      for _, skill in pairs(Skills) do
         initSkill(pid, skill)
      end

      for _, skill in pairs(Skills) do
         initSkillMastery(pid, skill)
      end

      if ncgdConfig.decayRate ~= nil then
         -- Begin decay initialization for all skills

         math.randomseed(os.time())

         for _, skill in pairs(Skills) do
            initSkillDecay(pid, skill)
         end

         setCustomVar(pid, "oldHour", 0)
         setCustomVar(pid, "oldDay", 0)
         setCustomVar(pid, "timePassed", 0)
         setCustomVar(pid, "decayMemory", 100)
      end

      savePlayer(pid)
   end
end


function ncgdTES3MP.OnPlayerAttribute(eventStatus, pid)
   if not eventStatus.validCustomHandlers then
      err("validCustomHandlers for `OnPlayerAttribute` have been set to false!" ..
             "  ncgdTES3MP requires custom handlers to operate!")
      fatal("Exiting the server now... Please set `ForceLoad` to true if you are sure ncgdTES3MP should load anyways.")
   else
      info("Called \"ncgdTES3MP.OnPlayerAttribute\" for pid \"" .. pid .. "\"")
      -- TODO: handle stuff here
   end
end


function ncgdTES3MP.OnPlayerDeath(eventStatus, pid)
   if not eventStatus.validCustomHandlers then
      err("validCustomHandlers for `OnPlayerDeath` have been set to false!" ..
             "  ncgdTES3MP requires custom handlers to operate!")
      fatal("Exiting the server now... Please set `ForceLoad` to true if you are sure ncgdTES3MP should load anyways.")
   else
      info("Called \"ncgdTES3MP.OnPlayerDeath\" for pid \"" .. pid .. "\"")
      -- TODO: make decay happen faster or more slowly depending on config.  or neither.
   end
end


function ncgdTES3MP.OnPlayerLevel(eventStatus, pid)
   if not eventStatus.validCustomHandlers then
      err("validCustomHandlers for `OnPlayerLevel` have been set to false!" ..
             "  ncgdTES3MP requires custom handlers to operate!")
      fatal("Exiting the server now... Please set `ForceLoad` to true if you are sure ncgdTES3MP should load anyways.")
   else
      info("Called \"ncgdTES3MP.OnPlayerLevel\" for pid \"" .. pid .. "\"")
      -- TODO: handle stuff here
   end
end


function ncgdTES3MP.OnPlayerSkill(eventStatus, pid)
   if not eventStatus.validCustomHandlers then
      err("validCustomHandlers for `OnPlayerSkill` have been set to false!" ..
             "  ncgdTES3MP requires custom handlers to operate!")
      fatal("Exiting the server now... Please set `ForceLoad` to true if you are sure ncgdTES3MP should load anyways.")
   else
      info("Called \"ncgdTES3MP.OnPlayerSkill\" for pid \"" .. pid .. "\"")
      -- TODO: calculate attributes and level

      -- Please no custom behavior for skills.
      eventStatus.validCustomHandlers = false

      local player = Players[pid]
   end
end


-- TODO: support player import by inspecting data on login and looking for the NCGD customVariables key
customEventHooks.registerHandler("OnPlayerAttribute", ncgdTES3MP.OnPlayerAttribute)
customEventHooks.registerHandler("OnPlayerDeath", ncgdTES3MP.OnPlayerDeath)
customEventHooks.registerHandler("OnPlayerEndCharGen", ncgdTES3MP.OnPlayerEndChargen)
customEventHooks.registerHandler("OnPlayerLevel", ncgdTES3MP.OnPlayerLevel)
customEventHooks.registerValidator("OnPlayerSkill", ncgdTES3MP.OnPlayerSkill)
