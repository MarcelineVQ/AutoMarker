if not SetAutoloot then
  DEFAULT_CHAT_FRAME:AddMessage("AutoMarker requires SuperWoW to operate.");
  return
end

local function auto_print(msg)
  DEFAULT_CHAT_FRAME:AddMessage(msg)
end

AutoMarker = {};
local autoMarkerFrame = CreateFrame("Frame")

-- Any events
autoMarkerFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
autoMarkerFrame:RegisterEvent("ADDON_LOADED")

local function guidToPack(id, zone)
  if not npcsToMark or not npcsToMark[zone] then
    return
  end
  for packName, packInfo in pairs(npcsToMark[zone]) do
    for guid, _ in pairs(packInfo) do
      if guid==id then
        return packName, npcsToMark[zone][packName]
      end
    end
  end
end

local function PlayerCanMark()
  for i = 1, GetNumRaidMembers() do
    local name, rank = GetRaidRosterInfo(i)
    if name==UnitName("player") then
      return rank>0
    end
  end
  return UnitIsPartyLeader("player") or false
end

local function OnMouseover()
  local modifier_pressed = IsShiftKeyDown() and (IsControlKeyDown() or IsAltKeyDown())

  if modifier_pressed then
    local _, targetGuid = UnitExists("mouseover");
    local can_mark = targetGuid and not UnitIsDead(targetGuid) and PlayerCanMark()
    if can_mark then
      local _, packMobs = guidToPack(targetGuid, GetRealZoneText())
      if packMobs then
        for mob, mark in pairs(packMobs) do
          SetRaidTarget(mob, mark)
        end
      end
    end
  end
end

-- Event handler
autoMarkerFrame:SetScript("OnEvent", function()
  if event=="ADDON_LOADED" then
    if not npcsToMark then
      npcsToMark = defaultNpcsToMark
    end
    auto_print("AutoMarker loaded.  Commands: /am set <packname>, /am get, /am clear, /am add, /am remove.  Can also do first letter of each command like /am s or /am g.")
  elseif event=="UPDATE_MOUSEOVER_UNIT" then
    OnMouseover()
  end
end)

local currentPackName = nil

local function handleCommands(msg, editbox)
  local args = {};
  for word in string.gfind(msg, '%S+') do
    table.insert(args, word)
  end

  if args[1]=="set" or args[1]=="s" and args[2] and type(args[2])=="string" then
    currentPackName = args[2]
    auto_print("Packname set to: "..currentPackName)
  elseif args[1]=="get" or args[1]=="g" then
    auto_print("Packname set to: "..tostring(currentPackName))
    local _, guid = UnitExists("mouseover")
    if not guid then
      _, guid = UnitExists("target")
    end
    if guid then
      local packName, _ = guidToPack(guid, GetRealZoneText())
      if packName then
        auto_print("Mob "..UnitName(guid).." is in pack: "..packName)
      else
        auto_print("Mob "..UnitName(guid).." is not in any pack.")
      end
    end
  elseif args[1]=="clear" or args[1]=="c" then
    if npcsToMark[currentZoneName] and npcsToMark[currentZoneName][currentPackName] then
      npcsToMark[currentZoneName][currentPackName] = nil
    end
    auto_print("Mobs in "..currentPackName.." have been cleared.")
  elseif args[1]=="remove" or args[1]=="r" then
    local currentZoneName = GetRealZoneText()

    local _, guid = UnitExists("mouseover")
    if not guid then
      _, guid = UnitExists("target")
    end

    if not guid then
      auto_print("Must mouseover a mob or target a mob to remove it from its pack.")
      return
    end

    local packName, _ = guidToPack(guid, GetRealZoneText())
    if not packName then
      auto_print("Mob not in any pack.")
      return
    end

    auto_print("Removing mob "..UnitName(guid).." from pack: "..packName)
    npcsToMark[currentZoneName][packName][guid] = nil
  elseif args[1]=="add" or args[1]=="a" then
    local currentZoneName = GetRealZoneText()

    if not currentPackName then
      auto_print("Must set packname before adding to pack.")
      return
    end

    local _, guid = UnitExists("mouseover")
    if not guid then
      _, guid = UnitExists("target")
    end

    if not guid then
      auto_print("Must mouseover a mob or target a mob to add to current pack.")
      return
    end

    -- check if already added to pack
    local packName, _ = guidToPack(guid, GetRealZoneText())
    if packName then
      auto_print("Mob already added to pack "..packName)
      return
    end

    local unitName = tostring(UnitName(guid))
    local raidmark = GetRaidTargetIndex(guid)
    if not raidmark then
      raidmark = 0
    end

    local markName = "Unmarked"
    if raidmark==1 then
      markName = "Star"
    elseif raidmark==2 then
      markName = "Circle"
    elseif raidmark==3 then
      markName = "Diamond"
    elseif raidmark==4 then
      markName = "Triangle"
    elseif raidmark==5 then
      markName = "Moon"
    elseif raidmark==6 then
      markName = "Square"
    elseif raidmark==7 then
      markName = "Cross"
    elseif raidmark==8 then
      markName = "Skull"
    end

    local zoneName = GetRealZoneText()
    auto_print("Adding "..unitName.."("..guid..")".." to pack: "..currentPackName.." with mark: "..markName.." in zone: "..zoneName)

    if not npcsToMark[currentZoneName] then
      npcsToMark[currentZoneName] = {}
    end
    if not npcsToMark[currentZoneName][currentPackName] then
      npcsToMark[currentZoneName][currentPackName] = {}
    end
    npcsToMark[currentZoneName][currentPackName][guid] = raidmark
  end
end

SLASH_AUTOMARKER1 = "/automarker";
SLASH_AUTOMARKER2 = "/am";
SlashCmdList["AUTOMARKER"] = handleCommands
