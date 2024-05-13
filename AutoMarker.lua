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
	if not npcsToMark or not npcsToMark[zone] then return end
	for packName, packInfo in pairs(npcsToMark[zone]) do
		for guid, _ in pairs(packInfo) do
			if guid == id then
				return npcsToMark[zone][packName]
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
  local _, targetGuid = UnitExists("mouseover");
  local modifier_pressed = IsShiftKeyDown() and (IsControlKeyDown() or IsAltKeyDown())
  local can_mark = targetGuid and not UnitIsDead(targetGuid) and PlayerCanMark()

  local target_pack = guidToPack(targetGuid, GetRealZoneText())
  if target_pack and modifier_pressed and can_mark then
    for mob, mark in pairs(target_pack) do
      SetRaidTarget(mob, mark)
    end
  end
end

-- Event handler
autoMarkerFrame:SetScript("OnEvent", function()
  if event=="ADDON_LOADED" then
    if not npcsToMark then
      npcsToMark = defaultNpcsToMark
    end
    auto_print("AutoMarker loaded.  Commands: /am setpack <packname>, /am getpack, /am clearpack, /am addtopack")
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

  if args[1]=="setpack" and args[2] and type(args[2])=="string" then
    currentPackName = args[2]
    auto_print("Packname set to: "..currentPackName)
  elseif args[1]=="getpack" then
    auto_print("Packname set to: "..tostring(currentPackName))
  elseif args[1]=="clearpack" then
    if npcsToMark[currentZoneName] and npcsToMark[currentZoneName][currentPackName] then
      npcsToMark[currentZoneName][currentPackName] = nil
    end
    auto_print("Mobs in "..currentPackName.." have been cleared.")
  elseif args[1]=="addtopack" then
    if not currentZoneName then
      currentZoneName = GetRealZoneText()
    end

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

    local unitName = tostring(UnitName(guid))
    local raidmark = GetRaidTargetIndex(guid)
    if not raidmark then
      auto_print("Unit "..unitName.." must be marked to add to pack.")
      return
    end

    local zoneName = GetRealZoneText()
    auto_print("Adding "..unitName.."("..guid..")".." to pack: "..currentPackName.." with mark: "..raidmark.." in zone: "..zoneName)

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
