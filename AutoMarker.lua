if SetAutoloot then
  DEFAULT_CHAT_FRAME:AddMessage("AutoMarker Loading...");
else
  DEFAULT_CHAT_FRAME:AddMessage("AutoMarker requires SuperWoW to operate.");
  return
end

AutoMarker = {};
local autoMarkerFrame = CreateFrame("Frame")

-- Any events
autoMarkerFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")

local function PlayerCanMark()
  for i=1,GetNumRaidMembers() do
    local name, rank = GetRaidRosterInfo(i)
    if name == UnitName("player") then
      return rank > 0
    end
  end
  return UnitIsPartyLeader("player") or false
end

local function OnMouseover()
  local _,targetGuid = UnitExists("mouseover");
  local modifier_pressed = IsShiftKeyDown() and (IsControlKeyDown() or IsAltKeyDown())
  local can_mark = targetGuid and not UnitIsDead(targetGuid)
    and UnitIsEnemy("player",targetGuid) and PlayerCanMark()

  local target_pack = npcsToMark:guidToPack(targetGuid,GetRealZoneText())
  if target_pack and modifier_pressed and can_mark then
    for mob,mark in pairs(target_pack) do
      SetRaidTarget(mob, mark)
    end
  end
end

-- Event handler
autoMarkerFrame:SetScript("OnEvent", function()
  if event == "UPDATE_MOUSEOVER_UNIT" then
    OnMouseover()
  end
end)
