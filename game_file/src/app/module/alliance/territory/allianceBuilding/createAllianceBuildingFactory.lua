local _ENV, createAllianceBuildingFactory
local alliancePalace = include("alliancePalace")
local allianceFortress = include("allianceFortress")
local allianceWarHall = include("allianceWarHall")
local allianceShelter = include("allianceShelter")
local allianceKnowledgeTower = include("allianceKnowledgeTower")
local allianceFlag = include("allianceFlag")
local allianceBuilding = include("allianceBuilding")
_ENV = "allianceBuilding"
;("allianceBuilding")[gAllianceBuilding.PALACE] = alliancePalace
;("allianceBuilding")[gAllianceBuilding.FORTRESS] = allianceFortress
;("allianceBuilding")[gAllianceBuilding.WARHALL] = allianceWarHall
;("allianceBuilding")[gAllianceBuilding.SHELTER] = allianceShelter
;("allianceBuilding")[gAllianceBuilding.KNOWLEDGE_TOWER] = allianceKnowledgeTower
;("allianceBuilding")[gAllianceBuilding.FLAG] = allianceFlag
;("allianceBuilding")[gAllianceBuilding.ALTAR] = allianceBuilding
local ("allianceBuilding")[gAllianceBuilding.PRIMARY_PALACE], buildingList = alliancePalace, "allianceBuilding"
function createAllianceBuildingFactory:createNewBuilding(bid, ...)
	local building = buildingList[bid]
	assert(building, "createAllianceBuildingFactory.createNewBuilding: not found building! bid = ", bid)
	return building:create(bid, ...)
end
function createAllianceBuildingFactory:initializeBuilding(bid, ...)
	local building = buildingList[bid]
	assert(building, "createAllianceBuildingFactory.createBuilding: not found building! bid = ", bid)
	local obj = building.new()
	obj:initialize(...)
	return obj
end
return createAllianceBuildingFactory
