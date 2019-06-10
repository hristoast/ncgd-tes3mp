local ncgdTES3MP = {}

ncgdTES3MP.defaultConfig = {
   deathDecay = true,
   decayRate = "fast",
   -- forceLoadOnPlayerDeath = false,
   -- forceLoadOnPlayerLevel = false,
   -- forceLoadOnPlayerAuthentified = false,
   -- forceLoadOnPlayerEndCharGen = false,
   growthRate = "slow",
   -- TODO: configurable attribute skill modifiers
}

ncgdTES3MP.config = DataManager.loadConfiguration("ncgdTES3MP", ncgdTES3MP.defaultConfig)

local NO_DECAY = 0
local SLOW_DECAY = 1
local STANDARD_DECAY = 2
local FAST_DECAY = 3

local SLOW_GROWTH = 1
local STANDARD_GROWTH = 2
local FAST_GROWTH = 3

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

-- local function err(msg)
--    --[[ Convenient logging wrapper. ]]--
--    tes3mp.LogMessage(enumerations.log.ERROR, "[ ncgdTES3MP ]: " .. msg)
-- end

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

-- local function savePlayer(pid)
--    dbg("Called \"savePlayer\" for pid \"" .. pid .. "\"")
--    -- TODO: dont do all of these every time
--    local player = Players[pid]

--    player:LoadAttributes()
--    player:LoadSkills()
--    player:LoadLevel()

--    player:LoadInventory()
--    player:LoadEquipment()
--    player:LoadQuickKeys()
-- end

-- local function getSkillBase(pid, skill)
--    --[[ Helper function for retrieving a player's skill value. ]]--
--    dbg("Called \"getSkillBase\" for pid \"" .. pid .. "\" and skill \"" .. skill .. "\"")
--    return Players[pid].data.skills[skill].base
-- end

local function getAttribute(pid, attribute, base)
   dbg("Called \"getAttribute\" for pid \"" .. pid .. "\" and attribute \"" .. attribute .. "\"")
   -- if base then
   --    return tes3mp.GetAttributeBase(pid, tes3mp.GetAttributeId(pid, attribute))
   -- else
   --    return tes3mp.GetAttributeBase(pid, tes3mp.GetAttributeId(pid, attribute))
   --       - tes3mp.GetAttributeModifier(pid, tes3mp.GetAttributeId(pid, attribute))
   -- end
   if base then
      return Players[pid].data.attributes[attribute].base
   else
      return Players[pid].data.attributes[attribute].base - Players[pid].data.attributes[attribute].damage
   end
end

local function setAttribute(pid, attribute, value, save)
   dbg("Called \"setAttribute\" for pid \"" .. pid .. "\" and attribute \""
          .. attribute .. "\" and value \"" .. value .. "\"")
   -- tes3mp.SetAttributeBase(pid, tes3mp.GetAttributeId(pid, attribute), value)
   -- tes3mp.SendAttributes(pid)
   Players[pid].data.attributes[attribute].base = value
   if save ~= nil then
      Players[pid]:SaveAttributes()
   end
end

local function getPlayerLevel(pid)
   dbg("Called \"getPlayerLevel\" for pid \"" .. pid .. "\".")
   -- return tes3mp.GetLevel(pid)
   if Players[pid].stats == nil then
      return 1
   else
      return Players[pid].stats.level
   end
end

local function setPlayerLevel(pid, value)
   dbg("Called \"setPlayerLevel\" for pid \"" .. pid .. "\" and value \"" .. value .. "\"")
   -- tes3mp.SetLevel(pid, value)
   -- tes3mp.SetLevelProgress(pid, 0)
   if Players[pid].stats == nil then
      return
   end
   Players[pid].stats.level = value
   Players[pid].stats.levelProgress = 0
   tes3mp.SendLevel(pid)
end

local function getSkill(pid, skill, base)
   dbg("Called \"getSkill\" for pid \"" .. pid .. "\" and skill \"" .. skill .. "\"")
   -- TODO: this returns all zeros on chargen..
   -- if base then
   --    return tes3mp.GetSkillBase(pid, tes3mp.GetSkillId(pid, skill))
   -- else
   --    return tes3mp.GetSkillBase(pid, tes3mp.GetSkillId(pid, skill))
   --       - tes3mp.GetSkillModifier(pid, tes3mp.GetSkillId(pid, skill))
   -- end
   if base then
      return Players[pid].data.skills[skill].base
   else
      return Players[pid].data.skills[skill].base - Players[pid].data.skills[skill].damage
   end
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
      player.data.customVariables["NCGD"][key] = val

      -- if save ~= nil then
      --    savePlayer(pid)
      -- end
   end
   return nil
end

local function getAttributeSkills(attribute)
   dbg("Called \"getAttributeSkills\" on attribute \"" .. attribute .. "\".")

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
               Speechcraft = nil }

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

local function getGrowthRate()
   dbg("Called \"getGrowthRate\"")
   --[[ Helper for returning the current global growth rate value as an int. ]]--
   if ncgdTES3MP.config.growthRate == "fast" then
      return FAST_GROWTH
   elseif ncgdTES3MP.config.growthRate == "standard" then
      return STANDARD_GROWTH
   elseif ncgdTES3MP.config.growthRate == "slow" then
      return SLOW_GROWTH
   else
      return SLOW_GROWTH  -- Default to slow growth if for some reason there's no configured value...
   end
end

local function recalculateAttribute(pid, attribute)
   dbg("Called \"recalculateAttribute\" for pid \"" .. pid .. "\" and attribute \"" .. attribute .. "\".")

   -- TODO: the maths here are fucked.  huge numbers
   -- TODO: check all of this again

   local baseAttr = getCustomVar(pid, "base" .. attribute)
   local startAttr = getCustomVar(pid, "start" .. attribute)

   local recalculateLuck = false
   local temp = 0
   local temp2 = 0

   for skill, multiplier in pairs(getAttributeSkills(attribute)) do
      local baseSkill = getSkill(pid, skill, true)

      dbg("temp: " .. tostring(temp))
      dbg("temp2: " .. tostring(temp2))
      temp2 = temp2 + baseSkill
      dbg("temp: " .. tostring(temp))
      dbg("temp2: " .. tostring(temp2))
      temp2 = temp2 + temp2

      if multiplier ~= nil then
         dbg("Multiplier is not nil!")
         temp2 = temp2 * multiplier
         dbg("temp: " .. tostring(temp))
         dbg("temp2: " .. tostring(temp2))
      end

      temp = temp + temp2
      dbg("temp: " .. tostring(temp))
      dbg("temp2: " .. tostring(temp2))
   end

   if attribute == Luck then
      temp2 = temp * 2
      dbg("temp: " .. tostring(temp))
      dbg("temp2: " .. tostring(temp2))
      temp2 = temp2 / 27
      dbg("temp: " .. tostring(temp))
      dbg("temp2: " .. tostring(temp2))
      temp2 = math.floor(math.sqrt(temp2))
      dbg("temp: " .. tostring(temp))
      dbg("temp2: " .. tostring(temp2))

      if temp2 > 25 then
         temp2 = temp2 - 25
         dbg("temp: " .. tostring(temp))
         dbg("temp2: " .. tostring(temp2))
         if temp2 > getPlayerLevel(pid) then
            gameMsg(pid, "You have reached Level " .. temp2 .. ".")
         elseif temp2 < getPlayerLevel(pid) then
            gameMsg(pid, "You have regressed to Level " .. temp2 .. ".")
         end

         setPlayerLevel(pid, temp2)
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
   dbg("temp: " .. tostring(temp))
   dbg("temp2: " .. tostring(temp2))
   temp = temp2 / 27
   dbg("temp: " .. tostring(temp))
   dbg("temp2: " .. tostring(temp2))

   -- Converts XP into attributes
   temp2 = math.floor(math.sqrt(temp))
   dbg("temp: " .. tostring(temp))
   dbg("temp2: " .. tostring(temp2))
   temp = temp2 + startAttr
   dbg("temp: " .. tostring(temp))
   dbg("temp2: " .. tostring(temp2))

   -- newValue = math.floor(temp2 / 10)

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

   -- if newValue > baseAttr then
   --    gameMsg(pid, "Your " .. attribute ..  " has increased to " .. newValue .. ".")
   --    if attribute ~= Luck then
   --       recalculateLuck = true
   --    end
   -- elseif newValue < baseAttr then
   --    gameMsg(pid, "Your " .. attribute ..  " has decayed to " .. newValue .. ".")
   --    if attribute ~= Luck then
   --       recalculateLuck = true
   --    end
   -- end

   -- setAttribute(pid, attribute, newValue)
   -- setCustomVar(pid, "base" .. attribute, newValue)

   return recalculateLuck
end

local function initAttribute(pid, attribute)
   dbg("Called \"initAttribute\" for pid \"" .. pid .. "\" and attribute \"" .. attribute .. "\"")

   setCustomVar(pid, "base" .. attribute, getAttribute(pid, attribute, true))
   setCustomVar(pid, "start" .. attribute, getAttribute(pid, attribute, true))
   recalculateAttribute(pid, attribute)
end

local function initSkill(pid, skill)
   dbg("Called \"initSkill\" for pid \"" .. pid .. "\" and skill \"" .. skill .. "\"")

   local baseSkill = getSkill(pid, skill, true)
   setCustomVar(pid, "base" .. skill, baseSkill)
   setCustomVar(pid, "start" .. skill, baseSkill)
end

-- local function initSkillDecay(pid, skill)
--    --[[ Initialize decay data for new players. ]]--
--    dbg("Called \"initSkillDecay\" for pid \"" .. pid .. "\" and skill \"" .. skill .. "\"")

--    local decayRate = randInt(0, 359)

--    -- NCGD uses 30 for this.  I'm not sure if that is a special number or what.
--    local magicNumber = 30

--    setCustomVar(pid, "decay" .. skill, math.floor(decayRate / magicNumber))
-- end

local function getDecayRate()
   dbg("Called \"getDecayRate\"")
   --[[ Helper for returning the current global decay rate value as an int. ]]--
   if ncgdTES3MP.config.decayRate == "fast" then
      return FAST_DECAY
   elseif ncgdTES3MP.config.decayRate == "standard" then
      return STANDARD_DECAY
   elseif ncgdTES3MP.config.decayRate == "slow" then
      return SLOW_DECAY
   else
      return NO_DECAY  -- Default to no decay if for some reason there's no configured value...
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





function ncgdTES3MP.OnPlayerEndCharGen(eventStatus, pid)
-- function ncgdTES3MP.OnPlayerAuthentified(eventStatus, pid)
   -- if not eventStatus.validCustomHandlers and not ncgdTES3MP.config.forceLoadOnPlayerAuthentified then
   --    fatal("validCustomHandlers for `OnPlayerAuthentified` have been set to false!" ..
   --             "  ncgdTES3MP requires custom handlers to operate!")
   --    fatal("Exiting now to avoid problems.  Please set \"forceLoadOnPlayerAuthentified\"" ..
   --          " to \"true\" if you're sure it's OK.")
   --    tes3mp.StopServer()
   -- else
   --    if ncgdTES3MP.config.forceLoadOnPlayerAuthentified then
   --       warn("\"ncgdTES3MP.OnPlayerEndCharGen\" is being force loaded!!")
   --    end

      info("Called \"OnPlayerEndCharGen\" for pid \"" .. pid .. "\"")

      if Players[pid].data.customVariables["NCGD"] == nil then
         -- new player
         dbg("IDK JAJA")

         for _, skill in pairs(Skills) do
            dbg(tostring(getSkill(pid, skill)))
         end

         Players[pid].data.customVariables["NCGD"] = {}
         Players[pid]:LoadSkills()

         for _, attribute in pairs(Attributes) do
            initAttribute(pid, attribute)
            Players[pid]:LoadAttributes()
            -- Players[pid]:SaveAttributes()
         end

         for _, skill in pairs(Skills) do
            initSkill(pid, skill)
         end

      end

      -- -- dbg("init decay")
      -- if getDecayRate() ~= NO_DECAY then
      --    -- Begin decay initialization for all skills

      --    math.randomseed(os.time())

      --    for _, skill in pairs(Skills) do
      --       initSkillDecay(pid, skill)
      --    end

      --    setCustomVar(pid, "oldHour", 0)
      --    setCustomVar(pid, "oldDay", 0)
      --    setCustomVar(pid, "timePassed", 0)
      --    setCustomVar(pid, "decayMemory", 100)
      -- end

      -- savePlayer(pid)

      -- for _, skill in pairs(Skills) do
      --    -- initSkillDecay(pid, skill)
      --    -- dbg("skill! " .. skill)
      --    local tableOfAttrs = calcSkill(pid, skill)
      --    -- tableHelper.print(tableOfAttrs)
      --    if tableOfAttrs ~= nil then
      --       recalcAttrs(pid, tableOfAttrs)
      --    end
      -- end
   -- end
end


-- function ncgdTES3MP.OnPlayerDeath(eventStatus, pid)
--    if not eventStatus.validCustomHandlers and not ncgdTES3MP.config.forceLoadOnPlayerDeath then
--       fatal("validCustomHandlers for `OnPlayerDeath` have been set to false!" ..
--              "  ncgdTES3MP requires custom handlers to operate!")
--    else
--       if ncgdTES3MP.config.forceLoadOnPlayerDeath then
--          warn("\"ncgdTES3MP.OnPlayerDeath\" is being force loaded!!")
--       end

--       info("Called \"ncgdTES3MP.OnPlayerDeath\" for pid \"" .. pid .. "\"")

--       -- TODO: make decay happen faster or more slowly depending on config.  or neither.
--    end
-- end


-- function ncgdTES3MP.OnPlayerLevel(eventStatus, pid)
--    if not eventStatus.validCustomHandlers and not ncgdTES3MP.config.forceLoadOnPlayerLevel then
--       fatal("validCustomHandlers for `OnPlayerLevel` have been set to false!" ..
--              "  ncgdTES3MP requires custom handlers to operate!")
--    else
--       if ncgdTES3MP.config.forceLoadOnPlayerLevel then
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
-- customEventHooks.registerHandler("OnPlayerAuthentified", ncgdTES3MP.OnPlayerAuthentified)
customEventHooks.registerHandler("OnPlayerEndCharGen", ncgdTES3MP.OnPlayerEndCharGen)

-- dbg("JAH!")

-- customEventHooks.registerValidator("OnPlayerLevel", ncgdTES3MP.OnPlayerLevel)
