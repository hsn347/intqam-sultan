local allianceBuilding = include("allianceBuilding")
local alliancePalace = class("alliancePalace", allianceBuilding)
function alliancePalace:ctor(...)
	alliancePalace.super.ctor(self, ...)
end
return alliancePalace
