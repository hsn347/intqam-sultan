local allianceBuilding = include("allianceBuilding")
local allianceKnowledgeTower = class("allianceKnowledgeTower", allianceBuilding)
function allianceKnowledgeTower:ctor(...)
	allianceKnowledgeTower.super.ctor(self, ...)
end
function allianceKnowledgeTower:destroy()
	allianceKnowledgeTower.super.destroy(self)
end
return allianceKnowledgeTower
