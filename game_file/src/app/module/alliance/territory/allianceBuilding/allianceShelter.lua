local allianceBuilding = include("allianceBuilding")
local allianceShelter = class("allianceShelter", allianceBuilding)
function allianceShelter:ctor(...)
	allianceShelter.super.ctor(self, ...)
end
return allianceShelter
