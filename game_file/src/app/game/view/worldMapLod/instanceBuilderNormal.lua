local instanceBuilderNormal = class("instanceBuilderNormal", include("instanceBuilder"))
local instanceFactory = include("instanceFactory")
function instanceBuilderNormal:ctor()
	instanceBuilderNormal.super.ctor(self)
	self.lod = worldMapDefine.worldLodDef.LOD1
	self._layerName = "LayerLod_1"
end
local super_createMapInstance_imp = instanceBuilderNormal.super.createMapInstance_imp
function instanceBuilderNormal:createMapInstance_imp(worldMapCell, instanceData)
	local worldMapInstance = super_createMapInstance_imp(self, worldMapCell, instanceData)
	if worldMapInstance and instanceData.isCreateByKing and instanceData.type == gMapObjTypeDef.mapObjTypeResource then
		local pos = cc.p(instanceData.x, instanceData.y)
		worldMapCell:createTransferEffect(1, pos, nil, nil)
	end
	return worldMapInstance
end
local getInstanceConfigByType = function(config, lod)
	lod = lod or worldMapDefine.worldLodDef.LOD1
	local lod_cfg = config.lod
	if lod_cfg[lod] then
		return lod_cfg[lod]
	end
end
function instanceBuilderNormal:createMapInstanceConfig(worldMapCell, instanceData, worldInstanceData, config)
	local lodcfg = getInstanceConfigByType(config, self.lod)
	if not lodcfg then
		return
	end
	local worldInstance
	local createFun = lodcfg.createFun
	if createFun then
		worldInstance = createFun(self, lodcfg, worldMapCell, worldInstanceData, instanceData)
		if lodcfg.cache then
			worldInstance:setCacheStatus(lodcfg.cache)
		end
	else
		print("[instanceFactory] createFun is nil", instanceData.type)
	end
	return worldInstance
end
local getInstanceByType = function(lodcfg, classType)
	if lodcfg then
		local class = lodcfg.class
		if classType and lodcfg.classTable and lodcfg.classTable[classType] then
			class = lodcfg.classTable[classType]
		end
		if class then
			return instanceFactory.getInstanceByType(class, lodcfg.cache)
		end
	end
end
local getInstanceBatchNodeType = function(lodcfg, tileInstanceType)
	local batchNodeType = 1
	if lodcfg then
		batchNodeType = lodcfg.batchNode
	end
	return batchNodeType
end
function instanceBuilderNormal:addMapInstance(lodcfg, worldMapCell, worldInstanceData)
	local tilePoint = worldInstanceData.tilePoint
	local tileInstanceType = worldInstanceData.tileInstanceType
	local holdInstace = instanceFactory.getHoldInstaceByType(tileInstanceType, worldInstanceData.class, worldInstanceData.subMapType)
	local worldInstance, cache = getInstanceByType(lodcfg, worldInstanceData.class)
	local instancePoint = worldMapCell:getPointWithTile(tilePoint, holdInstace)
	local distance = cc.pGetDistance(tilePoint, cc.p(0, 0))
	local layerType = getInstanceBatchNodeType(lodcfg)
	if layerType then
		worldInstance:setBatchNodeGroupID(layerType)
	end
	worldInstance:setPosition(instancePoint)
	worldInstance:setLocalZOrder(distance)
	self:addWorldInstance(worldMapCell, worldInstance)
	if cache then
		worldInstance:release()
	end
	worldInstance:setInstanceType(tileInstanceType)
	worldInstance:setWorldMapCell(worldMapCell)
	worldInstance:setKingdomID(worldMapCell.kingdomID)
	worldInstance:setMapTypeClass(worldMapCell.mapClassType)
	worldInstance:setInstanceID(worldInstanceData.tileInstanceID)
	local tilesArray = instanceFactory.getTilesArrayByInstace(tilePoint, holdInstace)
	worldInstance:setTilesArray(tilesArray)
	worldInstance:setTilePoint(tilePoint)
	worldInstance:setHoldInstace(holdInstace)
	worldInstance:initCheckVisible()
	return worldInstance
end
return instanceBuilderNormal
