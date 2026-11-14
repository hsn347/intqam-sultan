local allianceBuilding = include("allianceBuilding")
local allianceWarHall = class("allianceWarHall", allianceBuilding)
function allianceWarHall:ctor(...)
	allianceWarHall.super.ctor(self, ...)
end
return allianceWarHall
