local allianceBuildingMgr = include("allianceBuildingMgr")
local allianceBuildingltCtrl = include("allianceBuildingltCtrl")
local allianceTaxModule = include("allianceTaxModule")
local allianceTerritoryAreas = include("allianceTerritoryAreas")
local allianceTerritory = class("allianceTerritory")
function allianceTerritory:ctor(aid)
	_UPVALUE0_ = nil
	self.property, (nil).aid = nil, aid
	self:initializeBuildingModule()
	self:initializeTaxModule()
	self:initializeAreasModule()
end
function allianceTerritory:initialize(data)
	local buildingModule = data.buildingModule
	self:getBuildingModule():initialize(buildingModule)
	local taxModule = data.taxModule
	self:getTaxModule():initialize(taxModule)
	local areasModule = data.areasModule
	self:getAreasModule():initialize(areasModule)
	self:setGoalActivityData(data.activityInfo)
end
function allianceTerritory:destroy()
	self:destroyBuildingModule()
	self:destroyTaxModule()
	self:destroyAreasModule()
end
function allianceTerritory:getAID()
	return self.property.aid
end
function allianceTerritory:buildBuildingUseGold(bid, pos, creator)
	return self:getBuildingModule():createBuildingUseGold(bid, pos, creator)
end
function allianceTerritory:buildBuildingUseBonus(bid, pos, creator)
	return self:getBuildingModule():createBuildingUseBonus(bid, pos, creator)
end
function allianceTerritory:demolishBuilding(id, bid)
	return self:getBuildingModule():destroyBuilding(id, bid)
end
function allianceTerritory:initializeBuildingModule()
	local aid = self:getAID()
	self.property.buildingMgr = allianceBuildingMgr.new(aid)
end
function allianceTerritory:destroyBuildingModule()
	local buildingMgr = self:getBuildingModule()
	if buildingMgr then
		buildingMgr:destroy()
		self.property.buildingMgr = nil
	end
end
function allianceTerritory:getBuildingModule()
	return self.property.buildingMgr
end
function allianceTerritory:initializeTaxModule()
	self.property.taxModule = allianceTaxModule.new()
end
function allianceTerritory:getTaxModule()
	return self.property.taxModule
end
function allianceTerritory:destroyTaxModule()
	self:getTaxModule():destroy()
end
function allianceTerritory:initializeAreasModule()
	self.property.areaModule = allianceTerritoryAreas.new()
end
function allianceTerritory:getAreasModule()
	return self.property.areaModule
end
function allianceTerritory:destroyAreasModule()
	self:getAreasModule():destroy()
end
function allianceTerritory:setGoalActivityData(data)
	self.property.targetActivity = data
end
function allianceTerritory:getGoalActivityData()
	return self.property.targetActivity
end
return allianceTerritory
