-- || Made by and for Weird Vibes of Turtle WoW || --

BINDING_HEADER_AUTOMARK = "|cff22CC00 - AutoMark Bindings -";
BINDING_NAME_MOUSEOVERKEY = "Keys to hold to activate mouseover mark";
BINDING_NAME_RUNKEY = "Mark mouseover or target";
BINDING_NAME_NEXTKEY = "Mark next group based on default order";
BINDING_NAME_CLEARKEY = "Clear all current marks";


-- Utility -------------------

local color = {
  white = "|cffffffff",
  red = "|cffff0000",
  green = "|cff00ff00",
  blue = "|cff0000ff",
  yellow = "|cffffff00",
  cyan = "|cff00ffff",
  magenta = "|cffff00ff",
  grey = "|cff808080",
  orange = "|cffff8000",
  purple = "|cffff00ff"}

local function c(text, color)
  return color..text.."|r"
end

if not SetAutoloot then
  -- Function to create the popup box
  local function CreatePopupBox(message)
    -- Create the frame for the popup
    local popupFrame = CreateFrame("Frame", "MyPopupFrame", UIParent)
    popupFrame:SetWidth(240)
    popupFrame:SetHeight(100)
    popupFrame:SetPoint("CENTER", 0, 0)
    popupFrame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    popupFrame:SetBackdropColor(0, 0, 0, 1)

    -- Create the title for the popup
    local title = popupFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("TOP", 0, -15)
    title:SetText("AutoMarker")

    -- Create the message text
    local messageText = popupFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    messageText:SetPoint("CENTER", 0, 10)
    messageText:SetText(message)

    -- Create the OK button
    local okButton = CreateFrame("Button", nil, popupFrame, "UIPanelButtonTemplate")
    okButton:SetWidth(40)
    okButton:SetHeight(25)
    okButton:SetPoint("BOTTOM", 0, 20)
    okButton:SetText("OK")
    okButton:SetScript("OnClick", function()
        popupFrame:Hide() -- Hide the popup when OK is clicked
    end)

    -- Show the popup
    popupFrame:Show()
  end

  CreatePopupBox(c("AutoMarker",color.yellow)..c(" requires SuperWoW to operate.",color.red))
  return

end

local function auto_print(msg)
  DEFAULT_CHAT_FRAME:AddMessage(msg)
end

local function tsize(t)
  local c = 0
  for _ in pairs(t) do c = c + 1 end
  return c
end

local function sortTableByKey(tbl)
  local sortedKeys = {}
  for key in pairs(tbl) do
      table.insert(sortedKeys, key)
  end
  table.sort(sortedKeys)

  local sortedTable = {}
  for _, key in ipairs(sortedKeys) do
      sortedTable[key] = tbl[key]
  end
  return sortedTable
end

--[[[
This lines up the mob tables and the update table and picks out what's newer:
Say we have
  ["spider_anubrekhan"] = {
    ["0x101"] = 6, -- spider 1
    ["0x102"] = 7, -- spider 2
    ["0x10"] = 8, -- anub
  },
And
  update = {
    ["0x105"] = 6, -- spider 1
    ["0x106"] = 7, -- spider 2
  },
We get
  updated = {
    ["0x105"] = 6, -- spider 1
    ["0x106"] = 7, -- spider 2
    ["0x10"] = 8, -- anub
  },
--]]
local function sortAndReplaceKeys(defaultTable, updateTable, reverse)
  local keys = {}
  for key in pairs(defaultTable) do
      table.insert(keys, key)
  end

  local comp = function (a,b)
    if reverse then
        return a < b
    else
        return a > b
    end
  end

  table.sort(keys, comp)

  local values = {}
  for _, value in pairs(updateTable) do
      table.insert(values, value)
  end
  table.sort(values, comp)

  local updatedTable = {}
  local i = 1

  for _, key in ipairs(keys) do
      if values[i] then
          updatedTable[values[i]] = defaultTable[key]
          i = i + 1
      else
          updatedTable[key] = defaultTable[key]
      end
  end

  return updatedTable
end

-- Addon ---------------------

-- /// Util functions /// --

local function PostHookFunction(original,hook)
  return function(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10)
    original(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10)
    hook(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10)
  end
end

local function InGroup()
  return (GetNumPartyMembers() + GetNumRaidMembers() > 0)
end

local function PlayerCanRaidMark()
  return InGroup() and (IsRaidOfficer() or IsPartyLeader())
end

-- You may mark when you're a lead, assist, or you're doing soloplay
local function PlayerCanMark()
  return PlayerCanRaidMark() or not InGroup()
end

-- returns false if the mark was solo
local warned_lead = false
local function MarkUnit(unit,mark)
  if PlayerCanRaidMark() then
    SetRaidTarget(unit,mark)
    return true
  else
    if InGroup() and not warned_lead then
      DEFAULT_CHAT_FRAME:AddMessage(c("Warning:",color.red).." a mark set while not a leader/assistant is not visible to others")
      warned_lead = true
    end
    SetRaidTarget(unit,mark,1)
    return false
  end
end

local function MarkPack(pack)
  for guid,mark in pairs(pack) do
    if UnitExists(guid) then
      MarkUnit(guid,mark)
    end
  end
end

function AutoMarker_ClearMarks()
  local markfunc = InGroup() and
    SetRaidTarget or
    function (t,m) SetRaidTarget(t,m,1) end
  for i=1,8 do
    if UnitExists("mark"..i) then markfunc("mark"..i,0) end
  end
end

function AutoMarker_MarkName(name)
  local sortedCache = {}
  for guid,name in pairs(AutoMarkerDB.unitCache) do
    table.insert(sortedCache, { guid = guid, name = name })
  end

  local function sortUnitsByInteractDistance(units)
    table.sort(units, function(a, b)
        local aInRange = CheckInteractDistance(a.guid,4)
        local bInRange = CheckInteractDistance(b.guid,4)
        if aInRange and not bInRange then
            return true
        elseif not aInRange and bInRange then
            return false
        else
            return false -- Maintain original order if both are the same
        end
    end)
  end
  sortUnitsByInteractDistance(sortedCache)

  -- clear far marks to help prio close
  for i=1,8 do
    local _,m = UnitExists("mark"..i)
    if m and not CheckInteractDistance(m,4) then
      MarkUnit(m,0)
    end
  end

  local hit = false
  for _, data in ipairs(sortedCache) do
    if not UnitExists(data.guid) then
      AutoMarkerDB.unitCache[data.guid] = nil
    elseif not UnitIsDead(data.guid) and string.lower(UnitName(data.guid)) == string.lower(name) then
      hit = true
      for i=8,1,-1 do
        local _,m = UnitExists("mark"..i)
        if m and UnitExists(m) and not UnitIsDead(m) then
          -- mark is used on already
        else
          MarkUnit(data.guid,i)
          break
        end
      end
    end
  end
  if not hit then
    auto_print(name .. " wasn't found nearby!")
  end
end

-- /// Allow marking solo as well /// --

local function AM_UnitPopup_HideButtons()
  local dropdownMenu = getglobal(UIDROPDOWNMENU_INIT_MENU);

  for index, value in UnitPopupMenus[dropdownMenu.which] do
    if ( strsub(value, 1, 12)  == "RAID_TARGET_" ) then
      UnitPopupShown[index] = 1;
    end
  end
end
UnitPopup_HideButtons = PostHookFunction(UnitPopup_HideButtons,AM_UnitPopup_HideButtons)

local function AM_UnitPopup_OnClick()
  local dropdownFrame = getglobal(UIDROPDOWNMENU_INIT_MENU);
  local button = this.value;
  local unit = dropdownFrame.unit;

  if ( strsub(button, 1, 12) == "RAID_TARGET_" and button ~= "RAID_TARGET_ICON" ) then
    local raidTargetIndex = strsub(button, 13);
    if ( raidTargetIndex == "NONE" ) then
      raidTargetIndex = 0;
    end
    MarkUnit(unit, tonumber(raidTargetIndex))
  end
  PlaySound("UChatScrollButton");
end
UnitPopup_OnClick = PostHookFunction(UnitPopup_OnClick,AM_UnitPopup_OnClick)

function AM_SetRaidTargetIcon(unit, index)
  if ( GetRaidTargetIndex(unit) and GetRaidTargetIndex(unit) == index ) then
    MarkUnit(unit, 0);
  else
    MarkUnit(unit, index);
  end
end
SetRaidTargetIcon = PostHookFunction(SetRaidTargetIcon,AM_SetRaidTargetIcon)

------------------------------


local raidMarks = {"Unmarked", "Star", "Circle", "Diamond", "Triangle", "Moon", "Square", "Cross", "Skull"}

local defaultSettings = {
  enabled = true,
  debug = false,
}

local sweep_on = false
local sweepPackName = nil
local currentPackName = nil
local currentNpcsToMark = {}
local last_pack_marked = nil
local elapsed = 0

local autoMarker = CreateFrame("Frame","AutoMarkerFrame")
autoMarker:RegisterEvent("ADDON_LOADED")
autoMarker:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
autoMarker:RegisterEvent("UNIT_MODEL_CHANGED") -- mob respawn
autoMarker:RegisterEvent("PLAYER_REGEN_DISABLED") -- mob respawn
autoMarker:RegisterEvent("UNIT_CASTEVENT") -- mob respawn
autoMarker:RegisterEvent("ZONE_CHANGED_NEW_AREA") -- mob respawn

local function guidToPack(id, zone)
  if not currentNpcsToMark or not currentNpcsToMark[zone] then
    return
  end
  for packName, packInfo in pairs(currentNpcsToMark[zone]) do
    for guid, _ in pairs(packInfo) do
      if guid==id then
        return packName, currentNpcsToMark[zone][packName]
      end
    end
  end
end

function AutoMarker_MarkGroup()
  local _, mouseoverGuid = UnitExists("mouseover")
  local _, targetGuid = UnitExists("target")
  targetGuid = mouseoverGuid or targetGuid
  if targetGuid and not UnitIsDead(targetGuid) and PlayerCanMark() then
    local pack, packMobs = guidToPack(targetGuid, GetRealZoneText())
    MarkPack(packMobs or {})
    last_pack_marked = pack
  end
end

function AutoMarker_MarkNextGroup()
  local zone = GetRealZoneText()

  for i, pack in ipairs(orderedPacks) do
    if pack.instance == zone then
      if not last_pack_marked or pack.packName == last_pack_marked then
        local nextPack = orderedPacks[i + (last_pack_marked and 1 or 0)]
        if nextPack and nextPack.instance == zone then
          auto_print("Marking: " .. nextPack.packName)
          MarkPack(currentNpcsToMark[zone][nextPack.packName])
          last_pack_marked = nextPack.packName
          break
        end
      end
    end
  end
end

-- this should not spit out the result, only true or false whether it suceeded, maybe a 2nd return value of what the error was
local function AddToPack(guid,force_add,pack)
  local the_pack = pack or currentPackName
  local force = force_add or false
  if not guid then
    return false,"no_guid"
  end
  if not the_pack then
    return false,"no_pack_name"
  end

  local unitName, raidmark = UnitName(guid), GetRaidTargetIndex(guid) or 0
  local zoneName = GetRealZoneText()

  local mob_pack_name = guidToPack(guid, zoneName)
  if mob_pack_name and not force then
    return false,"mob_in_pack"
  end

  AutoMarkerDB.customNpcsToMark[zoneName] = AutoMarkerDB.customNpcsToMark[zoneName] or {}
  AutoMarkerDB.customNpcsToMark[zoneName][the_pack] = AutoMarkerDB.customNpcsToMark[zoneName][the_pack] or {}

  -- update the live table too
  currentNpcsToMark[zoneName] = currentNpcsToMark[zoneName] or {}
  currentNpcsToMark[zoneName][the_pack] = currentNpcsToMark[zoneName][the_pack] or {}

  local existing_mark = AutoMarkerDB.customNpcsToMark[zoneName][the_pack][guid]
  local same = existing_mark and (existing_mark == raidmark)
  if not same then
    auto_print((existing_mark and "Updating " or "Adding ")
      .. unitName .. "(" .. guid .. ") in pack: " .. the_pack .. " with new mark: " .. raidMarks[raidmark + 1] .. " in zone: " .. zoneName)
    AutoMarkerDB.customNpcsToMark[zoneName][the_pack][guid] = raidmark
    currentNpcsToMark[zoneName][the_pack][guid] = raidmark
  end
  return true, nil
end

local function OnMouseover()
  if AutoMarkerDB.settings.enabled and IsShiftKeyDown() and (IsControlKeyDown() or IsAltKeyDown()) then
    AutoMarker_MarkGroup()
  end
end

-- Certain bosses have script spawned adds, so their id's are not consistent, this mechanism is to assign them marks.
local temporary_mobs = {
  ["Deathknight Understudy"] = {
    minCount = 4,
    pack = "military_razuvious",
    raid = "Naxxramas",
    queue = {},
  },
  ["Crypt Guard"] = {
    minCount = 2,
    pack = "spider_anubrekhan",
    raid = "Naxxramas",
    queue = {},
  },
  ["Faerlina Add"] = {
    minCount = 6,
    pack = "spider_faerlina",
    raid = "Naxxramas",
    queue = {},
  },
  ["Domo Add"] = {
    minCount = 8,
    pack = "domo",
    raid = "Molten Core",
    queue = {},
    reverse = true, -- domo is the one boss so far where his adds have a lower id than him
  },
  ["The Prophet Skeram"] = {
    minCount = 3,
    pack = "skeram",
    raid = "Ahn'Qiraj",
    live_mark = true, -- do the mobs change in combat
    queue = {},
  },
  ["High Priestess Arlokk"] = {
    minCount = 1,
    pack = "arlokk",
    raid = "Zul'Gurub",
    live_mark = true, -- do the mobs change in combat
    queue = {},
  },
  ["Buru Egg"] = {
    minCount = 6,
    pack = "buru_eggs",
    raid = "Ruins of Ahn'Qiraj",
    live_mark = false, -- a different mechanism will handle live buru eggs
    queue = {},
  },
}

-- Order them and assign them ordered source marks
local function UpdateTemporaryMobs()
  for mob, config in pairs(temporary_mobs) do
    if GetRealZoneText() == config.raid and tsize(config.queue) >= config.minCount then
      currentNpcsToMark[config.raid][config.pack] =
        sortAndReplaceKeys(defaultNpcsToMark[config.raid][config.pack], config.queue, config.reverse)
      if config.live_mark then
        MarkPack(currentNpcsToMark[config.raid][config.pack])
      end
      config.queue = {}
      AutoMarkerDB.checkTemporaryMobs = false
    end
  end
end

-- make it obvious what is the high hp hound
local function UpdateCorehound()
  if not next(AutoMarkerDB.corehounds) or GetRealZoneText() ~= "Molten Core" then
    AutoMarkerDB.checkCoreHounds = false
    AutoMarkerDB.corehounds = {}
    return
  end
  local t = {}
  for guid, _ in pairs(AutoMarkerDB.corehounds) do
    if not UnitExists(guid) then
      AutoMarkerDB.corehounds[guid] = nil
    elseif UnitAffectingCombat(guid) then
      table.insert(t, guid)
    end
  end
  -- if hp are the same, e.g. fight start, use lexigraphical sorting to keep mark stable
  table.sort(t, function(a, b)
    if UnitHealth(a) == UnitHealth(b) then
      return a < b
    else
      return UnitHealth(a) > UnitHealth(b)
    end
  end)
  if t[1] and not GetRaidTargetIndex(t[1]) then
    MarkUnit(t[1], 8)
  end
end

-- keep close soliders visible using any spare marks
local function UpdateSoldiers()
  if not next(AutoMarkerDB.soldiers) or GetRealZoneText() ~= "The Upper Necropolis" then
    AutoMarkerDB.checkSoliders = false
    AutoMarkerDB.soldiers = {}
    return
  end

  for guid, _ in pairs(AutoMarkerDB.soldiers) do
    if not UnitExists(guid) then
      AutoMarkerDB.soldiers[guid] = nil
    elseif not GetRaidTargetIndex(guid) and UnitAffectingCombat(guid) and CheckInteractDistance(guid,4) then
      for i=8,1,-1 do
        -- local m = "mark"..i
        -- the "mark" unitid isn't performant, avoid using multiple times
        local _,m = UnitExists("mark"..i)
        if UnitExists(m) and not UnitIsDead(m) then
          -- mark is used already
        else
          MarkUnit(guid,i)
          break
        end
      end
    end
  end
end

local function UpdateKeepers()
  if not next(AutoMarkerDB.keepers) or GetRealZoneText() ~= "Blackrock Depths" then
    AutoMarkerDB.checkKeepers = false
    AutoMarkerDB.keepers = {}
    return
  end

  if GetSubZoneText() == "The Lyceum" then
    for guid, _ in pairs(AutoMarkerDB.keepers) do
      if not UnitExists(guid) then
        AutoMarkerDB.keepers[guid] = nil
      elseif not GetRaidTargetIndex(guid) then
        for i=8,1,-1 do
          -- local m = "mark"..i
          -- the "mark" unitid isn't performant, avoid using multiple times
          local _,m = UnitExists("mark"..i)
          if UnitExists(m) and not UnitIsDead(m) then
            -- mark is used already
          else
            MarkUnit(guid,i)
            break
          end
        end
      end
    end
  end
end

local core_delay = 0
local function AMUpdate()
  elapsed = elapsed + arg1
  core_delay = core_delay + arg1
  if elapsed > 0.25 then
    elapsed = 0

    if AutoMarkerDB.checkCoreHounds and core_delay > 3 then
      core_delay = 0
      UpdateCorehound()
    end
    if AutoMarkerDB.checkSoliders then UpdateSoldiers() end
    if AutoMarkerDB.checkKeepers then UpdateKeepers() end
    if AutoMarkerDB.checkTemporaryMobs then UpdateTemporaryMobs() end
  end
end
autoMarker:SetScript("OnUpdate", AMUpdate)

-- Event handler
autoMarker:SetScript("OnEvent", function()
  if event=="ADDON_LOADED" and arg1=="AutoMarker" then
    -- init vars 
    if not AutoMarkerDB then AutoMarkerDB = {} end
    if not AutoMarkerDB.customNpcsToMark then AutoMarkerDB.customNpcsToMark = {} end
    if not AutoMarkerDB.buru_egg_queue then AutoMarkerDB.buru_egg_queue = {} end
    if not AutoMarkerDB.corehounds then AutoMarkerDB.corehounds = {} end
    if not AutoMarkerDB.soldiers then AutoMarkerDB.soldiers = {} end
    if not AutoMarkerDB.keepers then AutoMarkerDB.keepers = {} end
    if not AutoMarkerDB.unitCache then AutoMarkerDB.unitCache = {} end

    if not AutoMarkerDB.checkCoreHounds then AutoMarkerDB.checkCoreHounds = false end
    if not AutoMarkerDB.checkSoliders then AutoMarkerDB.checkSoliders = false end
    if not AutoMarkerDB.started_solnius then AutoMarkerDB.started_solnius = false end

    -- clear unit cache
    for guid, _ in pairs(AutoMarkerDB.unitCache) do
      if not UnitExists(guid) then
        AutoMarkerDB.unitCache[guid] = nil
      end
    end

    -- init settings
    if not AutoMarkerDB.settings then
      AutoMarkerDB.settings = defaultSettings
    else -- update/clean settings
      local s = {}
      -- migrate old settings
      if settings then
        for k,v in defaultSettings do
          s[k] = settings[k] or v
        end
      else
        for k,v in defaultSettings do
          s[k] = AutoMarkerDB.settings[k] or v
        end
      end
      AutoMarkerDB.settings = s
    end

    -- load defaults
    for raid_name,packs in pairs(defaultNpcsToMark) do
      if not currentNpcsToMark[raid_name] then currentNpcsToMark[raid_name] = {} end
      for pack_name,pack in pairs(packs) do
        if not currentNpcsToMark[raid_name][pack_name] then
          currentNpcsToMark[raid_name][pack_name] = defaultNpcsToMark[raid_name][pack_name]
        end
      end
    end
    -- over-write with customs
    for raid_name,packs in pairs(AutoMarkerDB.customNpcsToMark) do
      if not currentNpcsToMark[raid_name] then currentNpcsToMark[raid_name] = {} end
      for pack_name,pack in pairs(packs) do
        currentNpcsToMark[raid_name][pack_name] = AutoMarkerDB.customNpcsToMark[raid_name][pack_name]
      end
    end

    -- migrate old customs
    if customNpcsToMark and next(customNpcsToMark) then
      for raid_name,packs in pairs(customNpcsToMark) do
        if not AutoMarkerDB.customNpcsToMark[raid_name] then AutoMarkerDB.customNpcsToMark[raid_name] = {} end
        for pack_name,pack in pairs(packs) do
          AutoMarkerDB.customNpcsToMark[raid_name][pack_name] = customNpcsToMark[raid_name][pack_name]
        end
      end
    end
    auto_print(c("AutoMarker loaded!",color.yellow).." Type "..c("/am",color.green).." to see commands.")
  end

  if AutoMarkerDB.settings.enabled then
    if event=="UPDATE_MOUSEOVER_UNIT" then
      OnMouseover()
      local _,guid = UnitExists("mouseover")
      if AutoMarkerDB.settings.debug then
        auto_print(guid .. " " .. UnitName(guid))
      end
      if sweep_on then
          AddToPack(guid,true,sweepPackName)
      end
    -- only use of cast event, consider finding another way to detect this
    elseif event=="UNIT_CASTEVENT" then
      -- if buru egg exploded
      if arg4 == 19593 then
        if not AutoMarkerDB.buru_egg_queue then AutoMarkerDB.buru_egg_queue = {} end
        table.insert(AutoMarkerDB.buru_egg_queue, GetRaidTargetIndex(arg1))
      end
    elseif event=="UNIT_MODEL_CHANGED" then
      -- Certain mobs are script spawned so their IDs need to be fetched

      local name = UnitName(arg1)

      -- store found guid, this is only for `/am markname` so far
      AutoMarkerDB.unitCache[arg1] = name

      if AutoMarkerDB.settings.debug then
        auto_print(arg1 .. " " .. name)
      end

      -- player unit models change _often_, exit early if it's not a mob guid
      if string.sub(arg1,3,3) ~= "F" then return end

      if name == "Naxxramas Follower" or name == "Naxxramas Worshipper" then
        name = "Faerlina Add"
      end

      if name == "Flamewaker Healer" or name == "Flamewaker Elite" then
        name = "Domo Add"
      end

      if temporary_mobs[name] then
        -- key by id in case you leave the area and come back, which would otherwise add the same mob twice
        temporary_mobs[name].queue[arg1] = arg1
        AutoMarkerDB.checkTemporaryMobs = true
        return
      end

      -- fangkriss adds
      if name == "Spawn of Fankriss" and not GetRaidTargetIndex(arg1) then
        -- mark from skull on down, any worms around
        for i=8,1,-1 do
          local m = "mark"..i
          -- local m = "mark"..i
          -- the "mark" unitid isn't performant, avoid using multiple times
          local _,m = UnitExists("mark"..i)
          if UnitExists(m) and not UnitIsDead(m) then
            -- mark is a marked worm already
          else
            MarkUnit(arg1,i)
            break
          end
        end
        return
      end

      if name == "Core Hound" then
        AutoMarkerDB.corehounds[arg1] = true
        AutoMarkerDB.checkCoreHounds = true
        return
      end

      if name == "Soldier of the Frozen Wastes" then
        AutoMarkerDB.soldiers[arg1] = true
        AutoMarkerDB.checkSoliders = true
        return
      end

      if name == "Shadowforge Flame Keeper" then
        AutoMarkerDB.keepers[arg1] = true
        AutoMarkerDB.checkKeepers = true
        return
      end

      -- untested
      -- Solnius adds
      -- did solnius go dragonform
      if name == "Solnius" and UnitAffectingCombat(arg1) then
        AutoMarkerDB.started_solnius = true
      end
      if AutoMarkerDB.started_solnius and (name == "Sanctum Supressor" or name == "Sanctum Dragonkin" or name == "Sanctum Scalebane" or name == "Sanctum Wyrmkin") and not GetRaidTargetIndex(arg1) then
        -- prio supressors
        if name == "Sanctum Supressor" then
          if not UnitExists("mark8") or UnitIsDead("mark8") then
            MarkUnit(arg1,8)
          elseif not UnitExists("mark7") or UnitIsDead("mark8") then
            MarkUnit(arg1,7)
          end
        else
          -- try anything
          for i=6,1,-1 do
            -- local m = "mark"..i
            -- the "mark" unitid isn't performant, avoid using multiple times
            local _,m = UnitExists("mark"..i)
            if UnitExists(m) and not UnitIsDead(m) then
              -- mark is used already
            else
              MarkUnit(arg1,i)
              break
            end
          end
        end
        return
      end

      -- buru eggs respawn throughout the fight but we want them marked still
      if AutoMarkerDB.buru_egg_queue and name == "Buru Egg" then
        local next_egg_mark = table.remove(AutoMarkerDB.buru_egg_queue,1)
        if next_egg_mark then
          MarkUnit(arg1, next_egg_mark)
        end
        return
      end
    elseif event=="PLAYER_REGEN_DISABLED" then
      -- As far as I know fd/vanish won't trigger this while the raid is still fighting.
      -- Combat started, reset relevant model queues in case of incomplete loads
      for _,config in pairs(temporary_mobs) do
        for _,guid in pairs(config.queue) do
          if UnitAffectingCombat(guid) then -- will this work or is it too early? does it need to work?
            config.queue = {}
            break
          end
        end
      end
      AutoMarkerDB.buru_egg_queue = nil
      AutoMarkerDB.started_solnius = false
    elseif event == "ZONE_CHANGED_NEW_AREA" and GetRealZoneText() == "Blackrock Spire" and IsInInstance() then
      if UnitExists("0xF13000290D104DD6") then
        UIErrorsFrame:AddMessage("Jed is in the instance!",0,1,0)
      end
    end
  end
end)

local function handleCommands(msg, editbox)
  local args = {}
  for word in string.gfind(msg, '%S+') do
    if word ~= "" then
      table.insert(args, word)
    end
  end

  local command, packName = args[1], args[2]
  local force_add = command == "forceadd"
  local zoneName = GetRealZoneText()
  local function getGuid()
    local _, guid = UnitExists("target")
    return guid
  end

  -- Disable sweep if another command is used after sweep is enabled
  if sweep_on then
    sweep_on = false
    auto_print("Sweep mode [ "..c("off",color.red).." ]")
    return
  end

  if command == "enabled" then
    AutoMarkerDB.settings.enabled = not AutoMarkerDB.settings.enabled
    auto_print("AutoMarker is now [".. (AutoMarkerDB.settings.enabled and c("enabled",color.green) or c("disabled",color.red)) .. "]")
  elseif command == "set" or command == "s" then
    if not packName then
      auto_print("You must provide a pack name as well when using set.")
      return
    end
    currentPackName = packName
    auto_print("Packname set to: " .. c(currentPackName,color.orange))
  elseif command == "get" or command == "g" then
    auto_print("Curent packname set to: " .. c(currentPackName or "none",color.orange))
    local guid = getGuid()
    if guid then
      local packName,pack = guidToPack(guid, zoneName)
      if packName then
        local mark = pack[guid]+1
        auto_print(format("Mob %s (%s) is %s in pack: %s",guid,UnitName(guid),raidMarks[mark],c(packName,color.orange)))
      else
        auto_print(format("Mob %s (%s) is not in any pack.",guid,UnitName(guid)))
      end
    end
  elseif command == "clear" or command == "c" then
    if currentPackName then
      if AutoMarkerDB.customNpcsToMark[zoneName] then
        AutoMarkerDB.customNpcsToMark[zoneName][currentPackName] = nil
        auto_print("Mobs in " .. currentPackName .. " have been cleared.")
      end
    else
      auto_print("A packname isn't currently set.")
    end
  elseif command == "remove" or command == "r" then
    local guid = getGuid()
    if not guid then
      auto_print("Must target a mob to remove it from its pack.")
      return
    end
    local packName = guidToPack(guid, zoneName)
    if not packName then
      auto_print("Mob not in any pack.")
      return
    end
    auto_print("Removing mob " .. UnitName(guid) .. " from pack: " .. c(packName,color.orange))
    AutoMarkerDB.customNpcsToMark[zoneName][packName][guid] = nil
  elseif command == "add" or command == "a" or force_add then
    local guid = getGuid()
    local success, err = AddToPack(guid, force_add, packName)
    if not success then
      if err == "no_guid" then
        auto_print("You must target a mob.")
      elseif err == "no_pack_name" then
        auto_print("You must provide a pack name to add the mob to.")
      elseif err == "mob_in_pack" then
        auto_print("The mob is already in a pack. Use "..c("/am forceadd",color.yellow).." to override.")
      end
    end
  elseif command == "sweep" then
    local targetPackName = packName or currentPackName
    if not targetPackName then
      auto_print("Provide the pack name to this command as well or set one using "..c("/am set",color.yellow))
      return
    end
    sweep_on = true
    sweepPackName = targetPackName
    auto_print("Sweep mode [ "..c("on",color.green).." ] sweep your mouse over enemies to add them to pack: " .. c(sweepPackName,color.orange))
  elseif command == "clearmarks" then
    AutoMarker_ClearMarks()
  elseif command == "next" then
    AutoMarker_MarkNextGroup()
  elseif command == "mark" then
    AutoMarker_MarkGroup()
  elseif command == "markname" then
    if not packName then
      auto_print("You must provide a name as well when using markname.")
      return
    end
    table.remove(args,1)
    AutoMarker_MarkName(table.concat(args, " "))
  elseif command == "debug" then
    AutoMarkerDB.settings.debug = not AutoMarkerDB.settings.debug
    auto_print("Debug mode set to: " .. (AutoMarkerDB.settings.debug and c("on",color.green) or c("off",color.red)))
  else
    auto_print("Commands:")
    auto_print("/am " .. c("e", color.green) .. "nable - enabled or disable addon.")
    auto_print("/am " .. c("s", color.green) .. "et <packname> - Set the current pack name.")
    auto_print("/am " .. c("g", color.green) .. "et - Get the current pack name and information about the targeted mob.")
    auto_print("/am " .. c("c", color.green) .. "lear - Clear all mobs in the current pack.")
    auto_print("/am " .. c("sweep", color.green) .. " [packname] - Toggle sweep mode to add mobs to a specified pack. If no pack name is provided, use the current pack name.")
    auto_print("/am " .. c("a", color.green) .. "dd [packname] - Add the targeted mob to a specified pack. If no pack name is provided, use the current pack name.")
    auto_print("/am " .. c("r", color.green) .. "emove - Remove the targeted mob from its current pack.")
    auto_print("/am clearmarks - Remove all active marks.")
    auto_print("/am next - Mark next pack.")
    auto_print("/am mark - Mark pack of current target or mouseover.")
    auto_print("/am markname - Mark all units of a given name.")

    auto_print("/am debug - Toggle debug mode.")
  end
end

SLASH_AUTOMARKER1 = "/automarker";
SLASH_AUTOMARKER2 = "/am";
SlashCmdList["AUTOMARKER"] = handleCommands
