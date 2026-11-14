local worldMapComTileEffect = class("worldMapComTileEffect", include("worldMapCom"))
local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
function worldMapComTileEffect:ctor()
	worldMapComTileEffect.super.ctor(self, "worldMapComTileEffect")
	self.tileEffectCache, worldMapComTileEffect = worldMapComTileEffect.super.ctor, worldMapComTileEffect.super.ctor
end
_ENV, worldMapComTileEffect.onMessageListener = function(self)
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_UPDATE_TILE_EFFECT", handler(self, self.updateTileEffectData))
end, function(self)
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_UPDATE_TILE_EFFECT", handler(self, self.updateTileEffectData))
end
;(function(self)
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_UPDATE_TILE_EFFECT", handler(self, self.updateTileEffectData))
end).BLUE = 1
;(function(self)
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_UPDATE_TILE_EFFECT", handler(self, self.updateTileEffectData))
end).RED = 2
local _ENV, (function(self)
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_UPDATE_TILE_EFFECT", handler(self, self.updateTileEffectData))
end).PURPLE, TYPE_EFFECT = "conquestWarCtrl", 3, function(self)
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_UPDATE_TILE_EFFECT", handler(self, self.updateTileEffectData))
end
_ENV = include("worldMapCom")
include("worldMapCom").icon = "dh_kongdils_01.png"
;("conquestWarCtrl")[TYPE_EFFECT.BLUE], include("worldMapCom").bigCsbName = include("worldMapCom")
_ENV = include("worldMapCom")
include("worldMapCom").icon = "dh_kongdihs_01.png"
;("conquestWarCtrl")[TYPE_EFFECT.RED], include("worldMapCom").bigCsbName = include("worldMapCom")
_ENV = include("worldMapCom")
;("conquestWarCtrl")[TYPE_EFFECT.PURPLE], include("worldMapCom").icon = include("worldMapCom")
local effectConfig = "conquestWarCtrl"
function worldMapComTileEffect:updateTileEffectData(target, data)
	local tilePoint = data.tilePoint
	local size = data.holdInstace
	local radiation = data.radiation
	local isSelf = data.isSelf
	local instanceID = data.instanceID
	local updateType = data.updateType
	if updateType == worldMapLeagueManorUpdateType.leagueManorInstanceAdd then
		print("==leagueManorInstanceAdd==")
		self:removeOneTileData(instanceID)
		_UPVALUE4_ = self.removeOneTileData
		self.removeOneTileData[1] = tonumber(tilePoint.x) - radiation
		self.removeOneTileData[2] = tonumber(tilePoint.y) - radiation
		self.removeOneTileData[3] = 2 * radiation + size
		local self.removeOneTileData[4], lineData = 2 * radiation + size, self.removeOneTileData
		if isSelf then
			lineData.effectType = TYPE_EFFECT.BLUE
		else
			lineData.effectType = TYPE_EFFECT.RED
		end
		local mapViewCell = self.target_:getWorldMapCell()
		local mapSize = mapViewCell.mapSize
		local _ENV, arrary = 2 * radiation + size, 2 * radiation + size
		for i = 0, lineData[3] - 1 do
			for j = 0, lineData[4] - 1 do
				local curTile = cc.p(lineData[1] + i, lineData[2] + j)
				local rect = cc.rect(0, 0, mapSize.width - 1, mapSize.height - 1)
				local rectSelf = cc.rect(tilePoint.x, tilePoint.y, size - 1, size - 1)
				if cc.rectContainsPoint(rect, curTile) and not cc.rectContainsPoint(rectSelf, curTile) then
					local key = string.format("%d_%d", curTile.x, curTile.y)
					_ENV = "%d_%d"
					;("%d_%d").effectType = lineData.effectType
					;("%d_%d").tilePoint = curTile
					;("%d_%d").needShow = false
					arrary[key], ("%d_%d").initType = "%d_%d", lineData.effectType
				end
			end
		end
		local curTile = cc.p(tilePoint.x + (size - 1) / 2, tilePoint.y + (size - 1) / 2)
		local key = string.format("%.1f_%.1f", curTile.x, curTile.y)
		_ENV = "%.1f_%.1f"
		;("%.1f_%.1f").effectType = lineData.effectType
		;("%.1f_%.1f").tilePoint = curTile
		;("%.1f_%.1f").needShow = true
		;("%.1f_%.1f").initType = lineData.effectType
		arrary[key], ("%.1f_%.1f").radiation = "%.1f_%.1f", radiation
		self.tileDataArrary[instanceID] = arrary
	elseif updateType == worldMapLeagueManorUpdateType.leagueManorInstanceRemove then
		self:removeOneTileData(instanceID)
	end
	self:drawTileEffect()
end
function worldMapComTileEffect:removeOneTileData(instanceID)
	local arrary = self.tileDataArrary[instanceID]
	if arrary then
		for key, v in pairs(arrary) do
			if self.tileEffectArrary[key] then
				self:addToTileEffectCache(self.tileEffectArrary[key])
				self.tileEffectArrary[key] = nil
			end
		end
		self.tileDataArrary[instanceID] = nil
	end
end
function worldMapComTileEffect:drawTileEffect(...)
	local _ENV, tileArrary
	for instanceID, arrary in pairs(self.tileDataArrary) do
		for key, v in pairs(arrary) do
			local curTile = v.tilePoint
			local data = tileArrary[key]
			if data then
				if v.effectType ~= data.effectType then
					data.effectType = TYPE_EFFECT.PURPLE
				end
			else
				v.effectType = v.initType
				tileArrary[key] = v
			end
		end
	end
	local mapViewCell = self.target_:getWorldMapCell()
	for key, v in pairs(tileArrary) do
		local tilePoint = v.tilePoint
		local effectType = v.effectType
		local sprite = self.tileEffectArrary[key]
		if sprite and sprite.effectType ~= effectType then
			self:addToTileEffectCache(sprite)
			self.tileEffectArrary[key] = nil
		end
		if not self.tileEffectArrary[key] then
			local sprite
			if v.needShow then
				v.needShow = false
				sprite = self:createShowEffect(effectType, v.radiation)
				sprite:addTo(mapViewCell)
			else
				local isFromCache
				sprite, isFromCache = self:getTileEffect(effectType)
				if not isFromCache then
					sprite:addTo(mapViewCell)
				end
				local zorder = tilePoint.x + tilePoint.y
				sprite:setLocalZOrder(-zorder)
				self.tileEffectArrary[key] = sprite
			end
			local worldPoint = mapViewCell:getPointWithTile(tilePoint)
			sprite:setPosition(worldPoint)
		end
	end
end
function worldMapComTileEffect:cleanData()
	for k, v in pairs(self.tileEffectArrary) do
		self:addToTileEffectCache(v)
	end
	self.tileEffectArrary, _ENV = pairs(self.tileEffectArrary)
end
function worldMapComTileEffect:resetData()
	self.tileDataArrary, allianceMgr, self.tileEffectArrary, allianceMgr = nil, nil, nil, nil
	self.myLeagueID = allianceMgr:getOwnTeamID()
end
function worldMapComTileEffect:addToTileEffectCache(sprite)
	local effectType = sprite.effectType
	if not self.tileEffectCache[effectType] then
		self.tileEffectCache[effectType], _ENV = nil, nil
	end
	sprite:setVisible(false)
	table.insert(self.tileEffectCache[effectType], sprite)
end
function worldMapComTileEffect:getTileEffectFromCache(effectType)
	local cache = self.tileEffectCache[effectType]
	if cache and 0 < #cache then
		local sprite = table.remove(cache)
		sprite:setVisible(true)
		return sprite
	end
end
function worldMapComTileEffect:createTileEffect(effectType)
	local effect = display.newSprite("#" .. effectConfig[effectType].icon)
	effect.effectType = effectType
	effect:setGroupID(worldMapDefine.GROU_ID.tileEffectBatchNode)
	effect:setOpacity(204.0)
	effect:setScale(0.96)
	return effect
end
function worldMapComTileEffect:createShowEffect(effectType, radiation)
	local effect
	if worldMapDefine._hasTileEffectRes then
		local csbName = effectConfig[effectType].bigCsbName
		effect = SoraDCreatAnimation(csbName, nil, false)
		SoraDMixtureGLONEByParentEx(effect, function(widget)
			widget:setGroupID(worldMapDefine.GROU_ID.tileEffectGLONEBatchNode)
		end)
		effect:setGroupID(worldMapDefine.GROU_ID.tileEffectBatchNode)
		effect:setGroupAuto(true)
		effect:setScale((radiation + 1) / 3)
	else
		effect = display.newNode()
	end
	effectConfig = (radiation + 1) / 3
	;(radiation + 1) / 3[1] = cca.delay(1.6666666666666667)
	;(radiation + 1) / 3[2] = cca.removeSelf()
	effect:runAction(cca.seq((radiation + 1) / 3))
	return effect
end
function worldMapComTileEffect:getTileEffect(effectType)
	local isFromCache = true
	local sprite = self:getTileEffectFromCache(effectType)
	if not sprite then
		sprite = self:createTileEffect(effectType)
		isFromCache = false
	end
	return sprite, isFromCache
end
function worldMapComTileEffect:exportMethods()
	_UPVALUE1_ = nil
	;(nil)[1] = "updateTileEffectData"
	self:exportMethods_(nil)
	return self.target_
end
return worldMapComTileEffect
