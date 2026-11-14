local instanceBuilderLod = class("instanceBuilderLod", include("instanceBuilder"))
local instanceFactory = include("instanceFactory")
local LOD_LAYER = instanceFactory.LOD_LAYER
_ENV, instanceBuilderLod.ctor = function(self, comInstance, param)
	instanceBuilderLod.super.ctor(self, comInstance)
	local lod = param.default or worldMapDefine.worldLodDef.LOD2
	self.lod = lod or worldMapDefine.worldLodDef.LOD2
	self.lodLayer = param.lodLayer or LOD_LAYER.LOD_LAYER_NORMAL
	self._layerName = "LayerLod_" .. (param.layer or self.lod)
end, function(self, comInstance, param)
	instanceBuilderLod.super.ctor(self, comInstance)
	local lod = param.default or worldMapDefine.worldLodDef.LOD2
	self.lod = lod or worldMapDefine.worldLodDef.LOD2
	self.lodLayer = param.lodLayer or LOD_LAYER.LOD_LAYER_NORMAL
	self._layerName = "LayerLod_" .. (param.layer or self.lod)
end
;(function(self, comInstance, param)
	instanceBuilderLod.super.ctor(self, comInstance)
	local lod = param.default or worldMapDefine.worldLodDef.LOD2
	self.lod = lod or worldMapDefine.worldLodDef.LOD2
	self.lodLayer = param.lodLayer or LOD_LAYER.LOD_LAYER_NORMAL
	self._layerName = "LayerLod_" .. (param.layer or self.lod)
end).class = "worldMapInstanceLod"
local _ENV, (function(self, comInstance, param)
	instanceBuilderLod.super.ctor(self, comInstance)
	local lod = param.default or worldMapDefine.worldLodDef.LOD2
	self.lod = lod or worldMapDefine.worldLodDef.LOD2
	self.lodLayer = param.lodLayer or LOD_LAYER.LOD_LAYER_NORMAL
	self._layerName = "LayerLod_" .. (param.layer or self.lod)
end).cache, lod_default_2 = include("instanceBuilder")
include("instanceBuilder").class = "worldMapInstanceLod"
local _ENV, include("instanceBuilder").cache, lod_default_3 = include("instanceBuilder")
include("instanceBuilder").class = "worldMapInstanceLod"
local include("instanceBuilder").cache, lod_default_4 = true, include("instanceBuilder")
local worldLodDef = worldMapDefine.worldLodDef
_ENV = include("instanceBuilder")
include("instanceBuilder")[worldLodDef.LOD2] = lod_default_2
include("instanceBuilder")[worldLodDef.LOD3] = lod_default_3
include("instanceBuilder")[worldLodDef.LOD4] = lod_default_4
include("instanceBuilder")[worldLodDef.LOD5] = lod_default_4
local _ENV, include("instanceBuilder")[worldLodDef.LOD6], lod_default = worldLodDef.LOD6, lod_default_4, include("instanceBuilder")
worldLodDef.LOD6[worldLodDef.LOD3] = worldLodDef.LOD2
worldLodDef.LOD6[worldLodDef.LOD4] = worldLodDef.LOD3
worldLodDef.LOD6[worldLodDef.LOD5] = worldLodDef.LOD4
local worldLodDef.LOD6[worldLodDef.LOD6], lod_transform = worldLodDef.LOD4, worldLodDef.LOD6
local function getInstanceConfigByType_imp(lod_cfg, lod)
	if lod_cfg[lod] then
		return lod_cfg[lod]
	end
	if lod_transform[lod] then
		return getInstanceConfigByType_imp(lod_cfg, lod_transform[lod])
	end
	return lod_default[lod]
end
local getInstanceConfigByType = function(config, lod)
	lod = lod or worldMapDefine.worldLodDef.LOD2
	local lod_cfg = config.lod or lod_default
	return getInstanceConfigByType_imp(lod_cfg, lod)
end
local getInstanceByType = function(config, classType)
	if config then
		local class = config.class
		if class then
			return instanceFactory.getInstanceByType(class, config.cache)
		end
	end
end
function instanceBuilderLod:addMapInstance(config, worldMapCell, worldInstanceData)
	local lodShowFun = config.lodShowFun
	if not lodShowFun or not lodShowFun(self.lod, worldInstanceData.objData, worldInstanceData) then
		return
	end
	local lodcfg = getInstanceConfigByType(config, self.lod)
	if not lodcfg then
		return
	end
	local tilePoint = worldInstanceData.tilePoint
	local tileInstanceType = worldInstanceData.tileInstanceType
	local holdInstace = instanceFactory.getHoldInstaceByType(tileInstanceType, worldInstanceData.class, worldInstanceData.subMapType)
	local worldInstance, cache = getInstanceByType(lodcfg, tileInstanceType, worldInstanceData.class)
	local instancePoint = worldMapCell:getPointWithTile(tilePoint, holdInstace)
	local distance = cc.pGetDistance(tilePoint, cc.p(0, 0))
	worldInstance:setPosition(instancePoint)
	worldInstance:setLocalZOrder(distance)
	self:addWorldInstance(worldMapCell, worldInstance)
	if cache then
		worldInstance:release()
	end
	if lodcfg.cache then
		worldInstance:setCacheStatus(lodcfg.cache)
	end
	worldInstance:setInstanceType(tileInstanceType)
	worldInstance:setWorldMapCell(worldMapCell)
	worldInstance:setKingdomID(worldMapCell.kingdomID)
	worldInstance:setMapTypeClass(worldMapCell.mapClassType)
	worldInstance:setInstanceID(worldInstanceData.tileInstanceID)
	worldInstance:setTilePoint(tilePoint)
	worldInstance:setHoldInstace(holdInstace)
	worldInstance:initCheckVisible()
	return worldInstance
end
function instanceBuilderLod:checkInstanceShow(data)
	local config = instanceFactory.getConfigByInstance(data)
	if not config then
		return false
	end
	local lodcfg = getInstanceConfigByType(config, self.lod)
	if not lodcfg then
		return false
	end
	local layer = lodcfg.lodLayer
	if lodcfg.lodLayerFun then
		layer = lodcfg.lodLayerFun(self.lod, data)
	end
	layer = layer or LOD_LAYER.LOD_LAYER_NORMAL
	if layer ~= self.lodLayer then
		return false
	end
	return true
end
local _ENV, empty = function(self, data)
	local config = instanceFactory.getConfigByInstance(data)
	if not config then
		return false
	end
	local lodcfg = getInstanceConfigByType(config, self.lod)
	if not lodcfg then
		return false
	end
	local layer = lodcfg.lodLayer
	if lodcfg.lodLayerFun then
		layer = lodcfg.lodLayerFun(self.lod, data)
	end
	layer = layer or LOD_LAYER.LOD_LAYER_NORMAL
	if layer ~= self.lodLayer then
		return false
	end
	return true
end, function(self, data)
	local config = instanceFactory.getConfigByInstance(data)
	if not config then
		return false
	end
	local lodcfg = getInstanceConfigByType(config, self.lod)
	if not lodcfg then
		return false
	end
	local layer = lodcfg.lodLayer
	if lodcfg.lodLayerFun then
		layer = lodcfg.lodLayerFun(self.lod, data)
	end
	layer = layer or LOD_LAYER.LOD_LAYER_NORMAL
	if layer ~= self.lodLayer then
		return false
	end
	return true
end
function instanceBuilderLod:checkInstanceShowLod(instance)
	local instanceType = instance:getInstanceType()
	local config = instanceFactory.getConfigByType(instanceType)
	if not config then
		return false
	end
	local lodShowFun = config.lodShowFun
	if not lodShowFun or not lodShowFun(self.lod, empty, empty) then
		return false
	end
	return true
end
return instanceBuilderLod
