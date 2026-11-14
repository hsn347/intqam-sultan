local allianceBuilding = include("allianceBuilding")
local allianceFlag = class("allianceFlag", allianceBuilding)
function allianceFlag:ctor(...)
	allianceFlag.super.ctor(self, ...)
end
return allianceFlag
