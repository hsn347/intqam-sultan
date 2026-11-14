local instanceBuilderManor = class("instanceBuilderManor", include("instanceBuilder"))
local instanceFactory = include("instanceFactory")
local kingdomMapUtil = include("kingdomMapUtil")
function instanceBuilderManor:ctor()
	instanceBuilderManor.super.ctor(self)
	self.buildManor = include("worldMapBuildManor").new()
end
function instanceBuilderManor:createMapInstance_quick(worldMapCell, instanceData, updateType)
	if not instanceData.type then
		kingdomMapUtil.splitMapObjId(instanceData)
	end
	local instanceType = instanceData.type
	local config = instanceFactory.getConfigByType(instanceType)
	if config then
		local worldInstanceData = instanceFactory.getWorldMapInstanceData(worldMapCell, instanceData, config)
		local tilePoint = worldInstanceData.tilePoint
		local worldMapInstance = self.buildManor
		worldMapInstance:resetData()
		worldMapInstance:setInstanceType(instanceType)
		worldMapInstance:setKingdomID(worldMapCell.kingdomID)
		worldMapInstance:setInstanceID(worldInstanceData.tileInstanceID)
		worldMapInstance:setTilePoint(tilePoint)
		worldMapInstance:initInstanceData(worldInstanceData.objData, worldInstanceData, instanceData)
		if updateType then
			worldMapInstance:sendUpdateMsg(updateType)
		else
			worldMapInstance:showInstance(true, 0)
		end
	end
	return self.buildManor
end
function instanceBuilderManor:createMapInstance_imp(worldMapCell, instanceData)
	local worldMapInstance = instanceFactory.createMapInstance(self, worldMapCell, instanceData)
	if worldMapInstance then
		worldMapInstance:showInstance(true)
	end
	return worldMapInstance
end
function instanceBuilderManor:createMapInstanceConfig(worldMapCell, instanceData, worldInstanceData, config)
	local worldInstance = self:addMapInstance(config, worldMapCell, worldInstanceData)
	if worldInstance then
		worldInstance:initInstanceData(worldInstanceData.objData, worldInstanceData, instanceData)
	end
	return worldInstance
end
function instanceBuilderManor:addMapInstance(config, worldMapCell, worldInstanceData)
	local tilePoint = worldInstanceData.tilePoint
	local tileInstanceType = worldInstanceData.tileInstanceType
	local worldInstance = include("worldMapBuildManor").new()
	worldInstance:setInstanceType(tileInstanceType)
	worldInstance:setWorldMapCell(worldMapCell)
	worldInstance:setKingdomID(worldMapCell.kingdomID)
	worldInstance:setMapTypeClass(worldMapCell.mapClassType)
	worldInstance:setInstanceID(worldInstanceData.tileInstanceID)
	worldInstance:setTilePoint(tilePoint)
	return worldInstance
end
return instanceBuilderManor
