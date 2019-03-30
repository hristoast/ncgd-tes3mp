local ncgdTES3MP = {}

local ncgdConfig = {}

ncgdConfig.levelCap = nil
ncgdConfig.decayRate = "fast"
ncgdConfig.growthRate = "slow"

local function dbg(msg)
   --[[ Convenient logging wrapper. ]]--
   tes3mp.LogMessage(enumerations.log.VERBOSE, "[ ncgdTES3MP ]: " .. msg)
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

local function setCustomVar(pid, key, val, save)
   dbg("Called \"setCustomVar\" for pid \"" .. pid .. "\", key \"" .. key .. "\", and value \"" .. val .. "\".")

   Players[pid].data.customVariables["NCGD"][key] = val

   if save ~= nil then
      savePlayer(pid)
   end
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
   player.data.attributes[attribute] = newValue

   -- Record the base attribute value for future reference, don't save because we're about to do that
   setCustomVar(pid, "base" .. attribute, player.data.attributes[attribute])

   -- Revert values.
   config.maxAttributeValue = oldMaxAttributeValue
   config.maxSkillValue = oldMaxSkillValue
end

local function initSkill(pid, skill)
   dbg("Called \"initSkill\" for pid \"" .. pid .. "\" and skill \"" .. skill .. "\"")
   setCustomVar(pid, "skill" .. skill, getSkillValue(pid, skill))
end

local function initSkillDecay(pid, skill)
   dbg("Called \"initSkillDecay\" for pid \"" .. pid .. "\" and skill \"" .. skill .. "\"")

   local decayRate = randInt(0, 359)

   -- NCGD uses 30 for this.  I'm not sure if that is a special number or what.
   local magicNumber = 30

   setCustomVar(pid, "decay" .. skill, decayRate / magicNumber)
end

function ncgdTES3MP.OnPlayerEndChargen(eventStatus, pid)
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

function ncgdTES3MP.OnPlayerAttribute(eventStatus, pid)
   info("Called \"ncgdTES3MP.OnPlayerAttribute\" for pid \"" .. pid .. "\"")
   -- TODO: handle stuff here
end

function ncgdTES3MP.OnPlayerDeath(eventStatus, pid)
   info("Called \"ncgdTES3MP.OnPlayerDeath\" for pid \"" .. pid .. "\"")
   -- TODO: make decay happen faster or more slowly depending on config.  or neither.
end

function ncgdTES3MP.OnPlayerLevel(eventStatus, pid)
   info("Called \"ncgdTES3MP.OnPlayerLevel\" for pid \"" .. pid .. "\"")
   -- TODO: handle stuff here
end

function ncgdTES3MP.OnPlayerSkill(eventStatus, pid)
   info("Called \"ncgdTES3MP.OnPlayerSkill\" for pid \"" .. pid .. "\"")
   -- TODO: calculate attributes and level

   -- Please no custom behavior for skills.
   eventStatus.validCustomHandlers = false

   local player = Players[pid]
end

-- TODO: support player import by inspecting data on login and looking for the NCGD customVariables key
customEventHooks.registerHandler("OnPlayerAttribute", ncgdTES3MP.OnPlayerAttribute)
customEventHooks.registerHandler("OnPlayerDeath", ncgdTES3MP.OnPlayerDeath)
customEventHooks.registerHandler("OnPlayerEndCharGen", ncgdTES3MP.OnPlayerEndChargen)
customEventHooks.registerHandler("OnPlayerLevel", ncgdTES3MP.OnPlayerLevel)
customEventHooks.registerValidator("OnPlayerSkill", ncgdTES3MP.OnPlayerSkill)
