local instanceCacheMgr = include("instanceCacheMgr")
local mapSyncUtilClient = include("mapSyncUtilClient")
local worldMapUtil = include("worldMapUtil")
local worldMapInstanceLod = class("worldMapInstanceLod", function(target)
	if not target or type(target) ~= "userdata" then
		target = include("worldMapInstanceBase").new()
	end
	return target
end)
local DEFAULT_TILE_POINT = cc.p(0, 0)
function worldMapInstanceLod:ctor()
	local size = self:getContentSize()
	self.centerPoint = cc.p(size.width / 2, size.height / 2)
	self.instanceType = 0
	self.instanceID = 0
	self.kingdomID = 0
	self.worldMapCell = nil
	self.lod = 0
	self.tilePoint = DEFAULT_TILE_POINT
	self.holdInstace = 1
	self.isCanCache = false
	self.isDirt_data = false
	self.pieceID = nil
	self._isVisible = true
	self:toggle3D()
end
function worldMapInstanceLod:getBoundingBox()
	local width = self.holdInstace * 200
	local height = self.holdInstace * 120
	local offsetX = 0
	local offsetY = 0
	if self.instanceType == gMapObjTypeDef.mapObjTypePlayer then
		offsetY = 50
	end
	return cc.rect(self:getPositionX() - 0.5 * width + offsetX, self:getPositionY() - 0.5 * height + offsetY, width, height)
end
function worldMapInstanceLod:toggle3D()
end
function worldMapInstanceLod:_showDebugUI(data, delayTime)
	if not self._debugUI then
		_ENV = nil
		;(nil).UILabelType = 2
		;(nil).text = "1"
		;(nil).size = 14
		;(nil).align = cc.TEXT_ALIGNMENT_CENTER
		self._debugUI = SoraDCreateLabel(nil)
		self._debugUI:setAnchorPoint(cc.p(0.5, 0.5))
		self._debugUI:setPosition(cc.p(0, -20))
		self._debugUI:setGroupID(worldMapDefine.GROU_ID.group_text)
		self._debugUI:addTo(self, 1)
	end
	if self._debugUI then
		self._debugUI:setString(string.format([[
%s
LOD:%s]], self.instanceID, self.lod))
	end
end
function worldMapInstanceLod:initInstanceData(objData, worldInstanceData, instanceData)
	self:_showDebugUI()
	self:updateData(objData)
end
function worldMapInstanceLod:updateData(data, delayTime)
end
function worldMapInstanceLod:updateInstanceData(data, objData)
	self.isDirt_data = false
	local delayTime = worldMapUtil.getDelayTimeInstance(objData)
	if delayTime <= 0 then
		self:updateData(data)
	else
		local worldMapUtil, actionsArray = self.updateData, self.updateData
		actionsArray[#actionsArray + 1] = cc.DelayTime:create(delayTime)
		actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
			self:updateData(data)
		end)
		local action = transition.sequence(actionsArray)
		self:runAction(action)
	end
end
function worldMapInstanceLod:showInstance(show, delayTime)
	if not show then
		self:removeInstanceSelf()
	else
		delayTime = delayTime or 0
		if 0 < delayTime then
			local _ENV, actionsArray = self.removeInstanceSelf, self.removeInstanceSelf
			actionsArray[#actionsArray + 1] = cc.DelayTime:create(delayTime)
			actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
				self:setVisible(show)
			end)
			local action = transition.sequence(actionsArray)
			self:runAction(action)
		else
			self:setVisible(show)
		end
	end
end
function worldMapInstanceLod:setInstanceType(instanceType)
	self.instanceType = instanceType
end
function worldMapInstanceLod:getInstanceType()
	return self.instanceType
end
function worldMapInstanceLod:setClassType(classType)
	self._classType = classType
end
function worldMapInstanceLod:getClassType()
	return self._classType
end
function worldMapInstanceLod:setInstanceID(instanceID)
	self.instanceID = instanceID
end
function worldMapInstanceLod:getInstanceID()
	return self.instanceID
end
function worldMapInstanceLod:setKingdomID(kingdomID)
	self.kingdomID = kingdomID
end
function worldMapInstanceLod:setMapTypeClass(mapTypeClass)
	self.mapTypeClass = mapTypeClass
end
function worldMapInstanceLod:getKingdomID()
	return self.kingdomID
end
function worldMapInstanceLod:setWorldMapCell(worldMapCell)
	self.worldMapCell = worldMapCell
end
function worldMapInstanceLod:getWorldMapCell()
	return self.worldMapCell
end
function worldMapInstanceLod:setTilePoint(tilePoint)
	self.tilePoint = cc.p(tonumber(tilePoint.x), tonumber(tilePoint.y))
end
function worldMapInstanceLod:getTilePoint()
	return self.tilePoint
end
function worldMapInstanceLod:getHoldInstace(holdInstace)
	return self.holdInstace
end
function worldMapInstanceLod:setHoldInstace(holdInstace)
	self.holdInstace = holdInstace
end
function worldMapInstanceLod:addCacheInstanceBefore()
	self.worldMapCell = nil
	self.lod = 0
	self.pieceID = nil
	self._isVisible = true
	self.tilePoint = DEFAULT_TILE_POINT
	self.rect = nil
	self.isDirt_data = false
	self:stopAllActions()
	self:addCacheBefore()
end
function worldMapInstanceLod:addCacheBefore()
end
function worldMapInstanceLod:_initData()
end
function worldMapInstanceLod:removeCacheBefore()
	self:toggle3D()
	self:_initData()
end
function worldMapInstanceLod:setCacheStatus(cache)
	self.isCanCache = cache
end
function worldMapInstanceLod:isCanCache()
	return self.isCanCache
end
function worldMapInstanceLod:removeInstanceSelf()
	if self.isCanCache then
		instanceCacheMgr.addInstance(self)
		self:removeFromParent(false)
	else
		self:removeFromParent()
	end
end
function worldMapInstanceLod:initCheckVisible(uncheck)
	self:updateCullRect()
	self:setCullRect(self.rect.x, self.rect.y, self.rect.width, self.rect.height)
	self.curTimerNum = 0
	self.curTimerMax = 1
	if uncheck then
		self:updateCheckVisible()
	end
end
function worldMapInstanceLod:updateCullRect()
	local offset = self.holdInstace * 256
	self.rect = cc.rect(-offset, -offset, display.width + 2 * offset, display.height + 2 * offset)
end
function worldMapInstanceLod:isEnableCheckVisible()
	return self._isVisible
end
function worldMapInstanceLod:enableCheckVisible(enable)
	if self._isVisible ~= enable then
		self._isVisible = enable
		self:setVisible(enable)
	end
end
function worldMapInstanceLod:updateCheckVisible(force)
	if self._isVisible then
		self.curTimerNum = self.curTimerNum + 1
		if (self.curTimerNum >= self.curTimerMax or force) and self.checkIsVisibleInCullRect then
			local isVisible = self:checkIsVisibleInCullRect()
			self:setInstanceVisible(isVisible)
			self.curTimerNum = 0
		end
	end
end
function worldMapInstanceLod:setInstanceVisible(isVisible)
	local isRunning = self:isVisible()
	if isVisible ~= isRunning then
		if isVisible and self._isVisible then
			self:setVisible(true)
			self.curTimerMax = 60
			self.curTimerNum = 0
		else
			self:setVisible(false)
			self.curTimerMax = 10
			self.curTimerNum = 0
		end
	end
end
function worldMapInstanceLod:setLod(lod)
	self.lod = lod
end
function worldMapInstanceLod:doLodChange(lod)
	if self.lod ~= lod then
		self.lod = lod
		if self._debugUI then
			self:_showDebugUI()
		end
		self:updateLodChange()
	end
end
function worldMapInstanceLod:updateLodChange()
end
function worldMapInstanceLod:updateScaleChange(revertScale, scale)
	self:setScale(revertScale)
end
function worldMapInstanceLod:getPieceID(lod)
	lod = lod or self.lod
	if not self.pieceID then
		self.pieceID, mapSyncUtilClient = self.pieceID, self.pieceID
	end
	if not self.pieceID[lod] then
		local kingdomID = self:getKingdomID()
		local pos = self:getTilePoint()
		local id = mapSyncUtilClient.getPieceId(pos, self.mapTypeClass, lod or self.lod)
		local strkey = kingdomID .. "-" .. tostring(id)
		self.pieceID[lod] = strkey
	end
	return self.pieceID[lod]
end
function worldMapInstanceLod:setDirtyData(dirty)
	self.isDirt_data = dirty
end
function worldMapInstanceLod:isDirtyData(dirty)
	return self.isDirt_data
end
return worldMapInstanceLod
