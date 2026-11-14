local instanceCacheMgr = include("instanceCacheMgr")
local worldMapMoveLine = class("worldMapMoveLine", function(beginPoint, endPoint)
	local moveLineStepWidth = 16
	local distance = cc.pGetDistance(beginPoint, endPoint)
	local preLength = distance
	local preSprite = display.newTilesSprite("SinglePicture/mapfoot.png", cc.rect(0, 0, preLength, moveLineStepWidth), true)
	preSprite = SoraDcreateMarchSprite(preSprite, 5)
	preSprite:setAutoCull(false)
	preSprite:setAnchorPoint(0, 0.5)
	return preSprite
end)
local POINT_ZERO = cc.p(0, 0)
function worldMapMoveLine:ctor(beginPoint, endPoint)
	self:setNodeEventEnabled(true)
	self:initWithPoint(beginPoint, endPoint)
end
function worldMapMoveLine:getShowTimerKey()
	return "worldMapMoveLine:showMoveline" .. tostring(self)
end
function worldMapMoveLine:getDeleteTimerKey()
	return "worldMapMoveLine:deleteMoveLine" .. tostring(self)
end
function worldMapMoveLine:clearMoveLineTimers()
	SoraDManagerRemoveTimerByTarget(self:getShowTimerKey())
	SoraDManagerRemoveTimerByTarget(self:getDeleteTimerKey())
end
function worldMapMoveLine:resetForCache()
	self:setVisible(false)
	self.isHideMoveLine = false
	self.tilePoint1 = POINT_ZERO
	self.tilePoint2 = POINT_ZERO
	self.kingdomID = 0
	self.worldMapCell = nil
	self.lineID = nil
	self.troopInstance = nil
	self.tilePointShowEnd = POINT_ZERO
	self.tilePointShowBegin = POINT_ZERO
	self.deleteCallback = nil
end
function worldMapMoveLine:onExit()
	SoraDRemoveMessageByTarget(self)
	SoraDManagerRemoveTimerByTarget(self:getShowTimerKey())
	SoraDManagerRemoveTimerByTarget(self:getDeleteTimerKey())
	SoraDManagerRemoveTimerByTarget(self)
end
function worldMapMoveLine:initWithPoint(beginPoint, endPoint, isNeedSetRect)
	self:clearMoveLineTimers()
	if isNeedSetRect then
		local moveLineStepWidth = 16
		local distance = cc.pGetDistance(beginPoint, endPoint)
		local preLength = distance
		self:setRect(cc.rect(0, 0, preLength, moveLineStepWidth))
	end
	self:setVisible(false)
	self.isHideMoveLine = false
	self.tilePoint1 = POINT_ZERO
	self.tilePoint2 = POINT_ZERO
	self.kingdomID = 0
	self.worldMapCell = nil
	self.lineID = nil
	self.troopInstance = nil
	self.tilePointShowEnd = POINT_ZERO
	self.tilePointShowBegin = POINT_ZERO
	local distance = cc.pGetDistance(beginPoint, endPoint)
	local rotation = -SoraDGetAngleByPos(beginPoint, endPoint)
	self.stepLength = 64
	self.stepWidth = 16
	self.plusStepNum = 3
	local stepNum = math.floor(distance / self.stepLength) + self.plusStepNum
	if stepNum < 0 then
		stepNum = 0
	end
	local plusStepNodeLength = (self.plusStepNum + 2) * self.stepLength
	self.unitMoveLength = (self.plusStepNum - 1) * self.stepLength
	self.nodePointX = distance - stepNum * self.stepLength
	self.node1PointX = plusStepNodeLength - (self.plusStepNum + 1) * self.stepLength
	self.node2PointX = -(distance - stepNum * self.stepLength)
	self.normalSpeed = 9
	self.normalTime = 3
	self:doMoveingAction(self.normalTime)
	self:setRotation(rotation)
end
function worldMapMoveLine:doMoveingAction(time)
	local speed = time * 2
	if speed < 1 then
		speed = 1
	elseif 50 < speed then
		speed = 50
	end
	self:setMoveSpeed(speed)
end
function worldMapMoveLine:updateMoveLineSpeed(speed)
	local time = self.normalTime + speed / (self.normalSpeed * 1.5)
	self:doMoveingAction(time)
end
function worldMapMoveLine:setLineTilePoints(tilePoint1, tilePoint2)
	self.tilePoint1 = tilePoint1
	self.tilePoint2 = tilePoint2
end
function worldMapMoveLine:getLineTilePoints()
	return self.tilePoint1, self.tilePoint2
end
function worldMapMoveLine:setMoveLineColor(lineColor)
	local color = worldMapDefine.getMoveLineColor(lineColor)
	self:setColor(color)
end
function worldMapMoveLine:setMoveLineID(lineID)
	self.lineID = lineID
end
function worldMapMoveLine:getMoveLineID()
	return self.lineID
end
function worldMapMoveLine:setTroopInstance(troopInstance)
	if self.troopInstance then
		self.troopInstance:removeFromParent()
	end
	self.troopInstance = troopInstance
end
function worldMapMoveLine:getTroopInstance()
	return self.troopInstance
end
function worldMapMoveLine:setKingdomID(kingdomID)
	self.kingdomID = kingdomID
end
function worldMapMoveLine:getKingdomID()
	return self.kingdomID
end
function worldMapMoveLine:setWorldMapCell(worldMapCell)
	self.worldMapCell = worldMapCell
end
function worldMapMoveLine:getWorldMapCell()
	return self.worldMapCell
end
function worldMapMoveLine:showMoveline(delayTime)
	delayTime = delayTime or 0
	SoraDDelayCallOnce(self:getShowTimerKey(), function()
		if tolua.isnull(self) then
			return
		end
		if self.troopInstance and not tolua.isnull(self.troopInstance) then
			self.troopInstance:setVisible(true)
		end
		self:setVisible(not self.isHideMoveLine)
		self = self.setVisible
		local self.setVisible[1], tilePointArray = self.tilePoint1, self.setVisible
		_ENV = not self.isHideMoveLine
		;(not self.isHideMoveLine).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
		;(not self.isHideMoveLine).relatedTilePoints = tilePointArray
		SoraDSendMessage(not self.isHideMoveLine)
	end, delayTime, false)
end
function worldMapMoveLine:doDeleteMoveLineImp()
	self:clearMoveLineTimers()
	if self.deleteCallback then
		self.deleteCallback()
	end
	if self.troopInstance and not tolua.isnull(self.troopInstance) then
		self.troopInstance:stopAllActions()
		if self.troopInstance.stopMoveTimer then
			self.troopInstance:stopMoveTimer()
		end
		if self.troopInstance.matrix then
			self.troopInstance.matrix:removeMatrix()
		end
		self.troopInstance:removeFromParent()
	end
	self.troopInstance = nil
	if tolua.isnull(self) then
		return
	end
	instanceCacheMgr = tolua.isnull(self)
	local tolua.isnull(self)[1], tilePointArray = self.tilePoint2, tolua.isnull(self)
	if self.isAddToCache then
		self:stopAllActions()
		self:resetForCache()
		instanceCacheMgr.addNormalNodeByType(self, "worldMapMoveLine")
		self:removeFromParent(false)
	else
		self:removeFromParent()
	end
	_ENV = self
	self.msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
	self.relatedTilePoints = tilePointArray
	SoraDSendMessage(self)
end
function worldMapMoveLine:setDeleteCallback(deleteCallback)
	self.deleteCallback = deleteCallback
end
function worldMapMoveLine:deleteMoveLine(delayTime)
	if tolua.isnull(self) then
		return
	end
	delayTime = delayTime or 0
	SoraDManagerRemoveTimerByTarget(self:getShowTimerKey())
	if delayTime <= 0 then
		self:doDeleteMoveLineImp()
		return
	end
	SoraDDelayCallOnce(self:getDeleteTimerKey(), function()
		if tolua.isnull(self) then
			return
		end
		self:doDeleteMoveLineImp()
	end, delayTime, false)
end
function worldMapMoveLine:setShowTilePoint(tilePointBegin, tilePointEnd)
	self.tilePointShowBegin = tilePointBegin
	self.tilePointShowEnd = tilePointEnd
end
function worldMapMoveLine:getShowTilePointEnd()
	return self.tilePointShowEnd
end
function worldMapMoveLine:getShowTilePointBegin()
	return self.tilePointShowBegin
end
function worldMapMoveLine:doLodChange(isLod)
	if self.troopInstance then
		return self.troopInstance:switchMoveLineModel(isLod)
	end
end
function worldMapMoveLine:doMoveLineHide(isHide)
	self.isHideMoveLine = isHide
	self:setVisible(not isHide)
end
function worldMapMoveLine:setMoveLineHide(isHide)
	self.isHideMoveLine = isHide
end
function worldMapMoveLine:doScaleZoom(scale)
	if self.troopInstance then
		self.troopInstance:doScaleZoom(scale)
	end
end
return worldMapMoveLine
