local allianceBuilding = include("allianceBuilding")
local allianceFortress = class("allianceFortress", allianceBuilding)
function allianceFortress:ctor(...)
	allianceFortress.super.ctor(self, ...)
end
return allianceFortress
