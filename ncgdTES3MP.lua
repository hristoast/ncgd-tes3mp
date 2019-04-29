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

   setCustomVar(pid, "max" .. skill, config.maxSkillValue)

   setCustomVar(pid, "mastery" .. skill, 0)
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


local function getDecayRate()
   dbg("Called \"getDecayRate\"")
   --[[ Helper for returning the current global decay rate value as an int. ]]--
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
   --[[ Helper for returning the current global growth rate value as an int. ]]--
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


local function getAttrsToRecalc(skill)
   dbg("Called \"getAttrsToRecalc\"")
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


local function getAttrSkills(attribute)
   dbg("Called \"getAttrSkills\" on attribute \"" .. attribute .. "\".")
   --[[ TODO: verify these numbers ]]--
   if attribute == Strength then
      return { Longblade = 2,
               Bluntweapon = 4,
               Axe = 4,
               Armorer = nil,
               Heavyarmor = nil,
               Spear = 4,
               Block = 2,
               Acrobatics = nil,
               Marksman = 4,
               Handtohand = 4 }

   elseif attribute == Intelligence then
      return { Alchemy = 4,
               Enchant = 4,
               Conjuration = 4,
               Alteration = 2,
               Destruction = 2,
               Mysticism = 4,
               Illusion = 2,
               Security = 2,
               Mercantile = 2,
               Speechcraft = 2 }

   elseif attribute == Willpower then
      return { Bluntweapon = 2,
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
               Speechcraft = 2 }

   elseif attribute == Agility then
      return { Longblade = 4,
               Axe = 2,
               Block = nil,
               Illusion = nil,
               Acrobatics = 2,
               Security = 4,
               Sneak = 4,
               Lightarmor = nil,
               Marksman = 2,
               Shortblade = 4,
               Handtohand = 2 }

   elseif attribute == Speed then
      return { Longblade = nil,
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
               Shortblade = 2 }

   elseif attribute == Endurance then
      return { Bluntweapon = nil,
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
               Handtohand = nil }

   elseif attribute == Personality then
      return { Armorer = 2,
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
               Speechcraft = 4 }

   elseif attribute == Luck then
      return { Acrobatics = nil,
               Alchemy = nil,
               Alteration = nil,
               Armorer = nil,
               Athletics = nil,
               Axe = nil,
               Block = nil,
               Bluntweapon = nil,
               Conjuration = nil,
               Destruction = nil,
               Enchant = nil,
               Handtohand = nil,
               Heavyarmor = nil,
               Illusion = nil,
               Lightarmor = nil,
               Longblade = nil,
               Marksman = nil,
               Mediumarmor = nil,
               Mercantile = nil,
               Mysticism = nil,
               Restoration = nil,
               Security = nil,
               Shortblade = nil,
               Sneak = nil,
               Spear = nil,
               Speechcraft = nil,
               Unarmored = nil }
   else
      -- WTF?  This should never happen.
      return nil
   end
end


local function calcSkill(pid, skill)
   dbg("Called \"calcSkill\" with pid \"" .. pid .. "\" and skill \"" .. skill .. "\".")
   --[[
      Calculate a skill's value and return the attributes that need to be recalculated.
   ]]--

   -- local counter = 0
   local temp = 0
   local temp2 = 0

   local player = Players[pid]

   local baseSkill = getCustomVar(pid, "base" .. skill)
   local decaySkill = getCustomVar(pid, "decay" .. skill)
   local maxSkill = getCustomVar(pid, "max" .. skill)
   local masterySkill = getCustomVar(pid, "mastery" .. skill)
   local progressSkill = getCustomVar(pid, "progress" .. skill)
   local skillSkill = getCustomVar(pid, "skill" .. skill)

   if skillSkill ~= player.data.skills[skill] then
      skillSkill = player.data.skills[skill]
      player.data.skills[skill] = 1000
      temp2 = player.data.skills[skill] - 1000
      skillSkill = skillSkill - temp2

      if skillSkill > baseSkill then
         temp = skillSkill
         temp2 = 25 * masterySkill
         temp = temp + temp2

         if temp < maxSkill then
            if progressSkill < masterySkill then
               progressSkill = progressSkill + 1
            else
               temp = temp + 1
               skillSkill = skillSkill + 1
               progressSkill = 0
               tes3mp.MessageBox(pid, -1, "Your Skill skill increased to " .. temp .. ".")
               decaySkill = decaySkill / 2
            end
         elseif progressSkill >= masterySkill then
            maxSkill = temp
         end

         if progressSkill < masterySkill then
            skillSkill = skillSkill -1
            player.data.skills[skill] = skillSkill
            progressSkill = progressSkill + 1
            skillSkill = player.data.skills[skill]  -- WTF
            tes3mp.MessageBox(pid, -1, "You need more training before your skill will improve.  (" ..
                                 tostring(progressSkill) .. " out of " .. tostring(tonumber(masterySkill + 1)) .. ")")
         elseif skillSkill < 100 then
            if masterySkill > 0 then
               tes3mp.MessageBox(pid, -1, "Your Skill skill increased to " .. temp .. ".")
            end
            baseSkill = skillSkill
            player.data.skills[skill] = skillSkill
            progressSkill = 0
            skillSkill = player.data.skills[skill]  -- WTF
            decaySkill = decaySkill / 2
         else
            if masterySkill > 0 then
               tes3mp.MessageBox(pid, -1, "Your Skill skill increased to " .. temp .. ".")
            end
            masterySkill = masterySkill + 1
            -- baseSkill = skillSkill - 25  -- Don't actually do this since spells aren't needed in TES3MP
            baseSkill = skillSkill  -- Added because of the above
            player.data.skills[skill] = baseSkill
            progressSkill = 0
            skillSkill = player.data.skills[skill]
            decaySkill = decaySkill / 2

            temp2 = masterySkill

            dbg("NCGD removes all spells here...")

            if temp2 >= 8 then
               dbg("NCGD adds skill200 spell here...")
               temp2 = temp2 - 8
            end
            if temp2 >= 4 then
               dbg("NCGD adds skill100 spell here...")
               temp2 = temp2 - 4
            end
            if temp2 >= 2 then
               dbg("NCGD adds skill50 spell here...")
               temp2 = temp2 - 2
            end
            if temp2 >= 1 then
               dbg("NCGD adds skill25 spell here...")
            end
         end
      elseif masterySkill > 0 then
         if skillSkill < 75 then
            masterySkill = masterySkill - 1
            baseSkill = skillSkill + 25
            player.data.skills[skill] = baseSkill
            skillSkill = player.data.skills[skill]

            temp2 = masterySkill

            dbg("NCGD removes all spells here...")

            if temp2 >= 8 then
               dbg("NCGD adds skill200 spell here...")
               temp2 = temp2 - 8
            end
            if temp2 >= 4 then
               dbg("NCGD adds skill100 spell here...")
               temp2 = temp2 - 4
            end
            if temp2 >= 2 then
               dbg("NCGD adds skill50 spell here...")
               temp2 = temp2 - 2
            end
            if temp2 >= 1 then
               dbg("NCGD adds skill25 spell here...")
            end
         else
            baseSkill = skillSkill
            player.data.skills[skill] = skillSkill
            skillSkill = player.data.skills[skill]  -- WTF
         end
      else
         baseSkill = skillSkill
         player.data.skills[skill] = skillSkill
         skillSkill = player.data.skills[skill]  -- WTF
      end

   end

   setCustomVar(pid, "base" ..  skill, baseSkill)
   setCustomVar(pid, "decay" ..  skill, decaySkill)
   setCustomVar(pid, "max" ..  skill, maxSkill)
   setCustomVar(pid, "progress" ..  skill, progressSkill)
   setCustomVar(pid, "skill" ..  skill, skillSkill)
   savePlayer(pid)

   return getAttrsToRecalc(skill)
end


local function recalcAttrs(pid, attrsTable)
   dbg("Called \"recalcAttrs\"")

   local temp
   local temp2

   local recalcLuck

   local player = Players[pid]

   for _, attribute in pairs(attrsTable) do
      local baseAttr = getCustomVar(pid, "base" .. attribute)
      local startAttr = getCustomVar(pid, "start" .. attribute)

      temp = player.data.attributes[attribute]
      player.data.attributes[attribute] = 1000
      temp2 = player.data.attributes[attribute] - 1000
      temp2 = temp - temp2

      temp = 0
      temp2 = 0

      for skill, multiplier in pairs(getAttrSkills(attribute)) do
         local baseSkill = getCustomVar(pid, "base" .. skill)
         local masterySkill = getCustomVar(pid, "mastery" .. skill)
         temp2 = 25 * masterySkill
         temp2 = temp2 + baseSkill
         temp2 = temp2 * temp2
         if multiplier ~= nil then
            temp2 = temp2 * multiplier
         end
         temp = temp + temp2
      end

      if attribute == Luck then
         temp2 = temp * 2
         temp2 = temp2 / 27
         temp2 = math.floor(math.sqrt(temp2))

         if temp2 > 25 then
            temp2 = temp2 - 25
            if temp2 > player.stats.level then
               tes3mp.MessageBox(pid, -1, "You have reached Level " .. temp2 .. ".")
            elseif temp2 < player.stats.level then
               tes3mp.MessageBox(pid, -1, "You have regressed to Level " .. temp2 .. ".")
            end
            player.stats.level = temp2  -- Level = Luck - 40 (an average character starts with 41 Luck e.g. level 1)
            savePlayer(pid)
         else
            if player.stats ~= nil then
               if player.stats.level > 1 then
                  -- MessageBox "You have regressed to Level 1."
               end
               player.stats.level = 1
               savePlayer(pid)
            end
         end
      end

      -- Adjust XP based on growth speed
      temp2 = temp * getGrowthRate()
      temp = temp2 / 27

      -- Converts XP into attributes
      temp2 = math.floor(math.sqrt(temp))
      temp = temp2 + startAttr

      if temp > baseAttr then
         tes3mp.MessageBox(pid, -1, "Your " .. attribute ..  " has increased to " .. temp .. ".")
      elseif temp < baseAttr then
         tes3mp.MessageBox(pid, -1, "Your " .. attribute ..  " has decayed to " .. temp .. ".")
      end

      baseAttr = temp
      player.data.attributes[attribute] = baseAttr  -- Sets player's Strenth to new base value

      -- Any change in attributes means Luck needs to be recalculated
      if attribute ~= Luck then
         -- recalcAttrs(pid, { Luck })
         recalcLuck = true
      end

   end

   if recalcLuck then
      -- Any change in attributes means Luck needs to be recalculated
      -- TODO: Luck is way wrong.
      recalcAttrs(pid, { Luck })
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

      -- dbg("init attributes")
      for _, attribute in pairs(Attributes) do
         initAttribute(pid, attribute)
      end

      -- dbg("init skillz")
      for _, skill in pairs(Skills) do
         initSkill(pid, skill)
      end

      -- Store the decay rate regardless of whether it's enabled or not.
      setCustomVar(pid, "decayRate", getDecayRate())
      -- dbg("store decay")

      -- dbg("init decay")
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

      for _, skill in pairs(Skills) do
         -- initSkillDecay(pid, skill)
         -- dbg("skill! " .. skill)
         local tableOfAttrs = calcSkill(pid, skill)
         -- tableHelper.print(tableOfAttrs)
         if tableOfAttrs ~= nil then
            recalcAttrs(pid, tableOfAttrs)
         end
      end
   end
end


-- function ncgdTES3MP.OnPlayerDeath(eventStatus, pid)
--    if not eventStatus.validCustomHandlers and not ncgdConfig.ForceLoadOnPlayerDeath then
--       fatal("validCustomHandlers for `OnPlayerDeath` have been set to false!" ..
--              "  ncgdTES3MP requires custom handlers to operate!")
--    else
--       if ncgdConfig.ForceLoadOnPlayerDeath then
--          warn("\"ncgdTES3MP.OnPlayerDeath\" is being force loaded!!")
--       end

--       info("Called \"ncgdTES3MP.OnPlayerDeath\" for pid \"" .. pid .. "\"")

--       -- TODO: make decay happen faster or more slowly depending on config.  or neither.
--    end
-- end


-- function ncgdTES3MP.OnPlayerLevel(eventStatus, pid)
--    if not eventStatus.validCustomHandlers and not ncgdConfig.ForceLoadOnPlayerLevel then
--       fatal("validCustomHandlers for `OnPlayerLevel` have been set to false!" ..
--              "  ncgdTES3MP requires custom handlers to operate!")
--    else
--       if ncgdConfig.ForceLoadOnPlayerLevel then
--          warn("\"ncgdTES3MP.OnPlayerLevel\" is being force loaded!!")
--       end

--       info("Called \"ncgdTES3MP.OnPlayerLevel\" for pid \"" .. pid .. "\"")

--       for _, skill in pairs(Skills) do
--          local playerVal = getRealSkillValue(pid, skill)
--          local storedSkillVal = getCustomVar(pid, "skill" .. skill)

--          -- The stored skill value is nil for new players.
--          if storedSkillVal ~= nil and playerVal > storedSkillVal then
--             dbg("Player \"" .. Players[pid].accountName .. "\" has increased their " .. skill
--                    .. " to " .. tostring(playerVal) .. " from " .. storedSkillVal .. ".")
--             handleSkillIncrease(pid, skill, storedSkillVal, playerVal)

--             if getDecayRate() ~= NO_DECAY then
--                calculateAndApplyDecay(pid)
--             end

--          end
--       end

--       -- Allow custom behavior, block the default
--       local customHandlers = true
--       local defaultHandler = false
--       customEventHooks.makeEventStatus(defaultHandler, customHandlers)
--    end
-- end


-- TODO: calculate time to decay, line 4856

-- customEventHooks.registerHandler("OnPlayerDeath", ncgdTES3MP.OnPlayerDeath)
customEventHooks.registerHandler("OnPlayerEndCharGen", ncgdTES3MP.OnPlayerEndChargen)

-- customEventHooks.registerValidator("OnPlayerLevel", ncgdTES3MP.OnPlayerLevel)
