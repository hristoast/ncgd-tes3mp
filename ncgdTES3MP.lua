local ncgdTES3MP = {}

local ncgdConfig = {}


-- TODO: Use DataManager
-- deathDecay: true or false
ncgdConfig.deathDecay = true

-- decayRate: nil, "slow", "standard", or "fast"
-- quotes must be included
ncgdConfig.decayRate = "fast"

-- growthRate: "slow", "standard", or "fast"
-- quotes must be included
ncgdConfig.growthRate = "slow"

-- If you don't want accelerated decay after death, set this to false
ncgdConfig.ForceLoadOnPlayerDeath = true

-- Setting these to false will break the script
ncgdConfig.ForceLoadOnPlayerLevel = true
ncgdConfig.ForceLoadOnPlayerEndChargen = true

-- END user config for ncgdTES3MP -- Don't edit below here!

local NO_DECAY = 0
local SLOW_DECAY = 1
local STANDARD_DECAY = 2
local FAST_DECAY = 3

local SLOW_GROWTH = 1
local STANDARD_GROWTH = 2
local FAST_GROWTH = 3

-- Attributes and skills as vars; prevent typo bugs!
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


local Attributes = { Strength, Intelligence, Willpower, Agility,
                     Speed, Endurance, Personality, Luck }

local Skills = { Block, Armorer, Mediumarmor, Heavyarmor, Bluntweapon, Longblade, Axe, Spear,
                 Athletics, Enchant, Destruction, Alteration, Illusion, Conjuration, Mysticism,
                 Restoration, Alchemy, Unarmored, Security, Sneak, Acrobatics, Lightarmor,
                 Shortblade, Marksman, Mercantile, Speechcraft, Handtohand }


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
   return math.random(rangeStart, rangeEnd)
end


local function savePlayer(pid)
   dbg("Called \"savePlayer\" for pid \"" .. pid .. "\"")
   local player = Players[pid]

   player:LoadAttributes()
   player:LoadSkills()
   player:LoadLevel()

   player:LoadInventory()
   player:LoadEquipment()
   player:LoadQuickKeys()
end


local function getSkillValue(pid, skill)
   --[[ Helper function for retrieving a player's skill value. ]]--
   dbg("Called \"getSkillValue\" for pid \"" .. pid .. "\" and skill \"" .. skill .. "\"")
   return Players[pid].data.skills[skill]
end


local function getCustomVar(pid, key)
   --[[ Helper function for retrieving a player's custom NCGD variable value. ]]--
   dbg("Called \"getCustomVar\" for pid \"" .. pid .. "\" and key \"" .. key .. "\"")

   local player = Players[pid]
   local dataBase = player.data.customVariables["NCGD"]

   if dataBase ~= nil then
      return player.data.customVariables["NCGD"][key]
   end
   return nil
end


local function setCustomVar(pid, key, val, save)
   --[[
      Helper function for saving a player's custom NCGD variable key and value.
      Player saving is disabled by default.
   ]]--
   dbg("Called \"setCustomVar\" for pid \"" .. pid .. "\", key \"" .. key .. "\", and value \"" .. val .. "\".")

   local player = Players[pid]
   local dataBase = player.data.customVariables["NCGD"]

   if dataBase ~= nil then
      Players[pid].data.customVariables["NCGD"][key] = val

      if save ~= nil then
         savePlayer(pid)
      end
   end
   return nil
end


local function getRealSkillValue(pid, skill)
   --[[
      Takes a skill name and returns the value less any fortifications.
   ]]--
   dbg("Called \"getRealSkillValue\" for pid \"" .. pid .. "\" and skill \"" .. skill .. "\"")
   local player = Players[pid]

   -- Record current skill value
   local currentSkill = player.data.skills[skill]

   -- NCGD uses 1000 as a very high value for finding fortifications
   local magicNumber = 1000

   -- Set base skill to a known value
   player.data.skills[skill] = magicNumber

   -- Get fortification, if any
   local fortification = player.data.skills[skill] - magicNumber

   -- Put the skill value back
   player.data.skills[skill] = currentSkill

   -- Return the base skill value, less any fortification
   return currentSkill - fortification
end


local function getRealAttributeValue(pid, attribute)
   --[[
      Takes an attribute name and returns the value less any fortifications.
   ]]--
   dbg("Called \"getRealAttributeValue\" for pid \"" .. pid .. "\" and attribute \"" .. attribute .. "\"")
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

   local newValue

   -- Reduce attribute to account for gain from skills
   newValue = baseValue / 2

   -- Put the attribute value back
   player.data.attributes[attribute] = currentAttribute

   return newValue
end


local function initAttribute(pid, attribute)
   --[[ Initialize attribute data for new players. ]]--
   dbg("Called \"initAttribute\" for pid \"" .. pid .. "\" and attribute \"" .. attribute .. "\"")

   -- Save old values
   local oldMaxAttributeValue = config.maxAttributeValue
   local oldMaxSkillValue = config.maxSkillValue

   local player = Players[pid]

   -- TODO: maybe this is not needed.  Temporarily increase values by tenfold
   config.maxAttributeValue = config.maxAttributeValue * 10
   config.maxSkillValue = config.maxSkillValue * 10

   player.data.attributes[attribute] = getRealAttributeValue(pid, attribute)

   -- Record the base attribute value for future reference
   setCustomVar(pid, "base" .. attribute, player.data.attributes[attribute])

   -- Record the start attribute value for future reference
   setCustomVar(pid, "start" .. attribute, player.data.attributes[attribute])

   -- Revert values.
   config.maxAttributeValue = oldMaxAttributeValue
   config.maxSkillValue = oldMaxSkillValue
end


local function initSkill(pid, skill)
   --[[ Initialize skill data for new players. ]]--
   dbg("Called \"initSkill\" for pid \"" .. pid .. "\" and skill \"" .. skill .. "\"")

   local skillVal = getSkillValue(pid, skill)

   setCustomVar(pid, "progress" .. skill, 0)

   setCustomVar(pid, "base" .. skill, skillVal)
   setCustomVar(pid, "skill" .. skill, skillVal)
end


local function initSkillDecay(pid, skill)
   --[[ Initialize decay data for new players. ]]--
   dbg("Called \"initSkillDecay\" for pid \"" .. pid .. "\" and skill \"" .. skill .. "\"")

   local decayRate = randInt(0, 359)

   -- NCGD uses 30 for this.  I'm not sure if that is a special number or what.
   local magicNumber = 30

   setCustomVar(pid, "decay" .. skill, math.floor(decayRate / magicNumber))
end


local function getAttrRecalcFromSkillChange(skill)
   --[[
      Returns a table of attribute names that need to
      be recalculated based on the input skill.
   ]]--
   local toRecalc = {}

   if skill == Block then
      table.insert(toRecalc, Agility)
      table.insert(toRecalc, Endurance)
      table.insert(toRecalc, Strength)

   elseif skill == Armorer then
      table.insert(toRecalc, Endurance)
      table.insert(toRecalc, Personality)
      table.insert(toRecalc, Strength)

   elseif skill == Mediumarmor then
      table.insert(toRecalc, Endurance)
      table.insert(toRecalc, Speed)
      table.insert(toRecalc, Willpower)

   elseif skill == Heavyarmor then
      table.insert(toRecalc, Endurance)
      table.insert(toRecalc, Speed)
      table.insert(toRecalc, Strength)

   elseif skill == Bluntweapon then
      table.insert(toRecalc, Endurance)
      table.insert(toRecalc, Strength)
      table.insert(toRecalc, Willpower)

   elseif skill == Longblade then
      table.insert(toRecalc, Agility)
      table.insert(toRecalc, Speed)
      table.insert(toRecalc, Strength)

   elseif skill == Axe then
      table.insert(toRecalc, Agility)
      table.insert(toRecalc, Strength)
      table.insert(toRecalc, Willpower)

   elseif skill == Spear then
      table.insert(toRecalc, Endurance)
      table.insert(toRecalc, Speed)
      table.insert(toRecalc, Strength)

   elseif skill == Athletics then
      table.insert(toRecalc, Endurance)
      table.insert(toRecalc, Speed)
      table.insert(toRecalc, Willpower)

      -- Magical skills
   elseif skill == Enchant then
      table.insert(toRecalc, Intelligence)
      table.insert(toRecalc, Personality)
      table.insert(toRecalc, Willpower)

   elseif skill == Destruction then
      table.insert(toRecalc, Intelligence)
      table.insert(toRecalc, Personality)
      table.insert(toRecalc, Willpower)

   elseif skill == Alteration then
      table.insert(toRecalc, Intelligence)
      table.insert(toRecalc, Speed)
      table.insert(toRecalc, Willpower)

   elseif skill == Illusion then
      table.insert(toRecalc, Agility)
      table.insert(toRecalc, Intelligence)
      table.insert(toRecalc, Personality)

   elseif skill == Conjuration then
      table.insert(toRecalc, Intelligence)
      table.insert(toRecalc, Personality)
      table.insert(toRecalc, Willpower)

   elseif skill == Mysticism then
      table.insert(toRecalc, Intelligence)
      table.insert(toRecalc, Personality)
      table.insert(toRecalc, Willpower)

   elseif skill == Restoration then
      table.insert(toRecalc, Intelligence)
      table.insert(toRecalc, Personality)
      table.insert(toRecalc, Willpower)

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
      table.insert(toRecalc, Personality)
      table.insert(toRecalc, Speed)

   elseif skill == Acrobatics then
      table.insert(toRecalc, Agility)
      table.insert(toRecalc, Speed)
      table.insert(toRecalc, Strength)

   elseif skill == Lightarmor then
      table.insert(toRecalc, Agility)
      table.insert(toRecalc, Endurance)
      table.insert(toRecalc, Speed)

   elseif skill == Shortblade then
      table.insert(toRecalc, Agility)
      table.insert(toRecalc, Endurance)
      table.insert(toRecalc, Speed)

   elseif skill == Marksman then
      table.insert(toRecalc, Agility)
      table.insert(toRecalc, Speed)
      table.insert(toRecalc, Strength)

   elseif skill == Mercantile then
      table.insert(toRecalc, Intelligence)
      table.insert(toRecalc, Personality)
      table.insert(toRecalc, Willpower)

   elseif skill == Speechcraft then
      table.insert(toRecalc, Intelligence)
      table.insert(toRecalc, Personality)
      table.insert(toRecalc, Willpower)

   elseif skill == Handtohand then
      table.insert(toRecalc, Agility)
      table.insert(toRecalc, Endurance)
      table.insert(toRecalc, Strength)
   end

   return toRecalc
end


local function getDecayRate()
   dbg("Called \"getDecayRate\"")
   --[[ Helper for returning the current global decay rate value. ]]--
   if ncgdConfig.decayRate == "fast" then
      return FAST_DECAY
   elseif ncgdConfig.decayRate == "standard" then
      return STANDARD_DECAY
   elseif ncgdConfig.decayRate == "slow" then
      return SLOW_DECAY
   else
      return NO_DECAY  -- Default to no decay if for some reason there's no configured value...
   end
end


local function getGrowthRate()
   dbg("Called \"getGrowthRate\"")
   --[[ Helper for returning the current global growth rate value. ]]--
   if ncgdConfig.growthRate == "fast" then
      return FAST_GROWTH
   elseif ncgdConfig.growthRate == "standard" then
      return STANDARD_GROWTH
   elseif ncgdConfig.growthRate == "slow" then
      return SLOW_GROWTH
   else
      return SLOW_GROWTH  -- Default to slow growth if for some reason there's no configured value...
   end
end


local function calculateAttrXP(pid, attribute, skillTable)
   --[[
      Calculate an attibute's "XP" based on the values of given
      skills listed in 'skillTable' and return this value.
   ]]--
   dbg("Called \"calculateAttrXP\"")

   local attrXP = 0
   local xpPlusGrowth = 0

   local player = Players[pid]

   local baseAttr = getCustomVar(pid, "base" .. attribute)
   local realAttr = getRealAttributeValue(pid, attribute)
   local startAttr = getCustomVar(pid, "start" .. attribute)

   if baseAttr ~= realAttr then
      -- At this point, NCGD prompts the player with a message stating their
      -- attribute is off.  They can opt to revert it or keep the new value.
      -- In the context of TES3MP, it's better to "fix" the problem transparently.
      -- TODO: Maybe pop up a message
      realAttr = baseAttr
      player.data.attributes[attribute] = realAttr
      savePlayer(pid)
   end

   for skill, multiplier in pairs(skillTable) do
      local skillBase = getCustomVar(pid, "base" .. skill)

      -- set temp2 to temp2 + baseHandToHand
      xpPlusGrowth = xpPlusGrowth + skillBase
      -- set temp2 to temp2 * temp2
      xpPlusGrowth = xpPlusGrowth * xpPlusGrowth
      if multiplier ~= nil then
         -- set temp2 to temp2 * 4
         xpPlusGrowth = xpPlusGrowth * multiplier
      end
      -- set temp to temp + temp2
      attrXP = attrXP + xpPlusGrowth

      -- ; Adjust XP based on growth speed
      if attribute == Luck then
         -- set temp2 to temp * 2				; Deviates from Luck derivation to get level
         xpPlusGrowth = attrXP * 2
         xpPlusGrowth = xpPlusGrowth / 27
         xpPlusGrowth = math.floor(math.sqrt(xpPlusGrowth))

         if xpPlusGrowth > 25 then

         end

        -- line 4826
		-- if (temp2 > 25)
		-- 	set temp2 to temp2 - 25
		-- 	if (temp2 > player->getLevel)
		-- 		MessageBox "You have reached Level %.0g.", temp2
		-- 	elseif (temp2 < player->getLevel)
		-- 		MessageBox "You have regressed to Level %.0g.", temp2
		-- 	endif
		-- 	player->setLevel temp2 			; Level = Luck - 40 (an average character starts with 41 Luck e.g. level 1)
		-- else
		-- 	if (player->getLevel > 1)
		-- 		MessageBox "You have regressed to Level 1."
		-- 	endif
		-- 	player->setLevel 1
		-- endif

      else
         -- set temp2 to temp * attributeMult
         xpPlusGrowth = attrXP * getGrowthRate()
      end
      -- set temp to temp2 / 27
      attrXP = xpPlusGrowth / 27

      -- ; Converts XP into attributes
      -- set temp2 to getSquareRoot temp
      xpPlusGrowth = math.floor(math.sqrt(attrXP))
      -- set temp to temp2 + startSTR	; Sets base Strength to new value
      attrXP = xpPlusGrowth + startAttr  -- Sets base attr to new value

      local attrGain = attrXP > baseAttr
      local exceedsMax = baseAttr >= config.maxAttributeValue

      if attrGain and exceedsMax then
         -- config.maxAttributeValue reached
         tes3mp.MessageBox(pid, -1, "You have reached the server attribute cap for " .. attribute .. "!")
         return nil
      end

      -- if (temp > baseSTR)
      -- 	MessageBox "Your Strength has increased to %.0g.", temp
      -- elseif (temp < baseSTR)
      -- 	MessageBox "Your Strength has decayed to %.0g.", temp
      -- endif
      if attrGain and not exceedsMax then
            dbg("Player \"" .. player.accountName .. "\" has increased their " ..
                   attribute .. " to " .. tostring(attrXP) .. " from " .. baseAttr .. ".")
            tes3mp.MessageBox(pid, -1, "Your " .. attribute .. " has increased to " ..
                                 tostring(attrXP) .. ".")

         elseif attrXP < baseAttr then
            dbg("Player \"" .. player.accountName .. "\" has decayed their " ..
                   attribute .. " to " .. tostring(attrXP) .. " from " .. baseAttr .. ".")
            tes3mp.MessageBox(pid, -1, "Your " .. attribute .. " has decayed to " ..
                                 tostring(attrXP) .. ".")
      end

      -- set baseSTR to temp
      baseAttr = attrXP
      setCustomVar(pid, "base" .. attribute, baseAttr)
      -- player->setStrength baseSTR		; Sets player's Strenth to new base value
      player.data.attributes[attribute] = baseAttr
      savePlayer(pid)

      local decayRate = getDecayRate()

      if decayRate ~= NO_DECAY then
         if attribute == Intelligence or attribute == Luck then
            local baseInt
            local decayMemory

            local fourteen_days = 336  -- 14 days = 336 hours
            local seven_days = 168  -- 7 days = 168 hours
            local three_days = 72  -- 3 days = 72 hours
            local one_day = 24 -- 1 day = 24 hours

            local playerLevel = player.data.stats.level

            if attribute == Intelligence then
               baseInt = baseAttr
            else
               baseInt = getCustomVar(pid, "base" .. Intelligence)
            end

            decayMemory = playerLevel * playerLevel
            decayMemory = (baseInt * baseInt) / decayMemory

            if decayRate == SLOW_DECAY then
               decayMemory = decayMemory * fourteen_days
               decayMemory = decayMemory + three_days
            elseif decayRate == STANDARD_DECAY then
               decayMemory = decayMemory * seven_days
               decayMemory = decayMemory + one_day
            elseif decayRate == FAST_DECAY then
               decayMemory = decayMemory * three_days
               decayMemory = decayMemory + 12
            end
         end

         setCustomVar(pid, "decayMemory", decayMemory)
      end

      -- set recalcLUK to 1	; Any change in attributes means Luck needs to be recalculated
      -- set recalcSTR to 0	; Done checking Strength
      -- TODO: recalculate luck
   end

   return attrXP
end


local function calculateAndApplyDecay(pid)
   --[[ TODO ]]--
end


local function recalcAttributes(pid, toRecalc)
   --[[
      Recalculate a player's attributes based on their current skill values.

      The attributes to be recalculated are provided in the 'toRecalc' table.
   ]]--

   for _, attribute in pairs(toRecalc) do

      if attribute == Strength then
         calculateAttrXP(pid, attribute,
                         { Longblade = 2,
                           Bluntweapon = 4,
                           Axe = 4,
                           Armorer = nil,
                           Heavyarmor = nil,
                           Spear = 4,
                           Block = 2,
                           Acrobatics = nil,
                           Marksman = 4,
                           Handtohand = 4 })

      elseif attribute == Intelligence then
         calculateAttrXP(pid, attribute,
                         { Alchemy = 4,
                           Enchant = 4,
                           Conjuration = 4,
                           Alteration = 2,
                           Destruction = 2,
                           Mysticism = 4,
                           Illusion = 2,
                           Security = 2,
                           Mercantile = 2,
                           Speechcraft = 2 })

      elseif attribute == Willpower then
         calculateAttrXP(pid, attribute,
                         { Bluntweapon = 2,
                           Axe = nil,
                           Mediumarmor = nil,
                           Athletics = nil,
                           Enchant = 2,
                           Conjuration = nil,
                           Alteration = 4,
                           Destruction = 4,
                           Mysticism = 2,
                           Restoration = 4,
                           Unarmored = 2,
                           Mercantile = nil,
                           Speechcraft = 2 })

      elseif attribute == Agility then
         calculateAttrXP(pid, attribute,
                         { Longblade = 4,
                           Axe = 2,
                           Block = nil,
                           Illusion = nil,
                           Acrobatics = 2,
                           Security = 4,
                           Sneak = 4,
                           Lightarmor = nil,
                           Marksman = 2,
                           Shortblade = 4,
                           Handtohand = 2 })

      elseif attribute == Speed then
         calculateAttrXP(pid, attribute,
                         { Longblade = nil,
                           Mediumarmor = 2,
                           Heavyarmor = 2,
                           Spear = nil,
                           Athletics = 4,
                           Alteration = nil,
                           Unarmored = 4,
                           Acrobatics = 4,
                           Sneak = nil,
                           Lightarmor = 4,
                           Marksman = nil,
                           Shortblade = 2 })

      elseif attribute == Endurance then
         calculateAttrXP(pid, attribute,
                         { Bluntweapon = nil,
                           Armorer = 4,
                           Mediumarmor = 4,
                           Heavyarmor = 4,
                           Spear = 2,
                           Block = 4,
                           Athletics = 2,
                           Alchemy = nil,
                           Restoration = nil,
                           Unarmored = nil,
                           Lightarmor = 2,
                           Handtohand = nil })

      elseif attribute == Personality then
         calculateAttrXP(pid, attribute,
                         { Armorer = 2,
                           Alchemy = 2,
                           Enchant = nil,
                           Conjuration = 2,
                           Destruction = nil,
                           Mysticism = nil,
                           Restoration = 2,
                           Illusion = 4,
                           Security = nil,
                           Sneak = 2,
                           Shortblade = nil,
                           Mercantile = 4,
                           Speechcraft = 4 })
      end
      calculateAttrXP(pid, Luck, { Skills })
   end
end


local function handleSkillIncrease(pid, skill, skillVal, playerVal)
   --[[
      Sync skill increases into NCGD custom data and apply
      decrease to the decay progress of the given skill.

      If the server's config.maxSkillValue is reached, display
      a message stating this and do not apply the increase.
   ]]--
   dbg("Called \"handleSkillIncrease\" for pid \"" .. pid .. "\" and skill \"" .. skill .. "\"")

   local skillBase = getCustomVar(pid, "base" .. skill)
   local skillDecay = getCustomVar(pid, "decay" .. skill)
   local skillMax = config.maxSkillValue
   local skillProgress = getCustomVar(pid, "progress" .. skill)

   if skillVal ~= playerVal then
      -- Store the player value as the new skill value
      skillVal = playerVal
      setCustomVar(pid, "skill" .. skill, skillVal)

      -- Recalculate attributes as needed
      local attrToRecalc = getAttrRecalcFromSkillChange(skill)
      recalcAttributes(pid, attrToRecalc)

      if skillVal > skillBase then

         if skillVal < skillMax then
            skillProgress = skillProgress + 1
            setCustomVar(pid, "progress" .. skill, skillProgress)

            skillVal = skillVal + 1
            setCustomVar(pid, "skill" .. skill, skillVal)

            skillBase = skillVal
            setCustomVar(pid, "base" .. skill, skillBase)

            skillProgress = 0
            setCustomVar(pid, "progress" .. skill, skillProgress)

            skillDecay = skillDecay / 2
            setCustomVar(pid, "decay" .. skill, skillDecay)

         else
            -- skillMax reached
            tes3mp.MessageBox(pid, -1, "You have reached the server skill cap for " .. skill .. "!")
         end
      end
   end
end


function ncgdTES3MP.OnPlayerEndChargen(eventStatus, pid)
   if not eventStatus.validCustomHandlers and not ncgdConfig.ForceLoadOnPlayerEndChargen then
      fatal("validCustomHandlers for `OnPlayerEndChargen` have been set to false!" ..
             "  ncgdTES3MP requires custom handlers to operate!")
   else
      if ncgdConfig.ForceLoadOnPlayerEndChargen then
         warn("\"ncgdTES3MP.OnPlayerEndChargen\" is being force loaded!!")
      end

      info("Called \"OnPlayerEndChargen\" for pid \"" .. pid .. "\"")

      Players[pid].data.customVariables["NCGD"] = {}

      for _, attribute in pairs(Attributes) do
         initAttribute(pid, attribute)
      end

      for _, skill in pairs(Skills) do
         initSkill(pid, skill)
      end

      -- Store the decay rate regardless of whether it's enabled or not.
      setCustomVar(pid, "decayRate", getDecayRate())

      if getDecayRate() ~= NO_DECAY then
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

      -- Do an initial recalculation of attributes
      recalcAttributes(pid, Attributes)
   end
end


function ncgdTES3MP.OnPlayerDeath(eventStatus, pid)
   if not eventStatus.validCustomHandlers and not ncgdConfig.ForceLoadOnPlayerDeath then
      fatal("validCustomHandlers for `OnPlayerDeath` have been set to false!" ..
             "  ncgdTES3MP requires custom handlers to operate!")
   else
      if ncgdConfig.ForceLoadOnPlayerDeath then
         warn("\"ncgdTES3MP.OnPlayerDeath\" is being force loaded!!")
      end

      info("Called \"ncgdTES3MP.OnPlayerDeath\" for pid \"" .. pid .. "\"")

      -- TODO: make decay happen faster or more slowly depending on config.  or neither.
   end
end


function ncgdTES3MP.OnPlayerLevel(eventStatus, pid)
   if not eventStatus.validCustomHandlers and not ncgdConfig.ForceLoadOnPlayerLevel then
      fatal("validCustomHandlers for `OnPlayerLevel` have been set to false!" ..
             "  ncgdTES3MP requires custom handlers to operate!")
   else
      if ncgdConfig.ForceLoadOnPlayerLevel then
         warn("\"ncgdTES3MP.OnPlayerLevel\" is being force loaded!!")
      end

      info("Called \"ncgdTES3MP.OnPlayerLevel\" for pid \"" .. pid .. "\"")

      for _, skill in pairs(Skills) do
         local playerVal = getRealSkillValue(pid, skill)
         local storedSkillVal = getCustomVar(pid, "skill" .. skill)

         -- The stored skill value is nil for new players.
         if storedSkillVal ~= nil and playerVal > storedSkillVal then
            dbg("Player \"" .. Players[pid].accountName .. "\" has increased their " .. skill
                   .. " to " .. tostring(playerVal) .. " from " .. storedSkillVal .. ".")
            handleSkillIncrease(pid, skill, storedSkillVal, playerVal)

            if getDecayRate() ~= NO_DECAY then
               calculateAndApplyDecay(pid)
            end

         end
      end

      -- Allow custom behavior, block the default
      local customHandlers = true
      local defaultHandler = false
      customEventHooks.makeEventStatus(defaultHandler, customHandlers)
   end
end


customEventHooks.registerHandler("OnPlayerDeath", ncgdTES3MP.OnPlayerDeath)
customEventHooks.registerHandler("OnPlayerEndCharGen", ncgdTES3MP.OnPlayerEndChargen)

customEventHooks.registerValidator("OnPlayerLevel", ncgdTES3MP.OnPlayerLevel)
