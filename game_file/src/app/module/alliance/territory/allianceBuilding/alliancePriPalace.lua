local allianceBuilding = include("allianceBuilding")
local alliancePriPalace = class("alliancePriPalace", allianceBuilding)
function alliancePriPalace:ctor(...)
	alliancePriPalace.super.ctor(self, ...)
end
return alliancePriPalace
