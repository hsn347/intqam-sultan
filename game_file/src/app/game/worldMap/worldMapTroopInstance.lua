local worldMapTroopInstance = class("worldMapTroopInstance", function(size)
	local target = display.newNode()
	target:setContentSize(size)
	target:setAnchorPoint(0.5, 0.5)
	target:setPosition(display.cx, display.cy)
	local baseView = include("baseView")
	local view = baseView.new(size, false, target)
	return view
end)
local GROU_ID = worldMapDefine.GROU_ID
local socket = require("socket")
function worldMapTroopInstance:ctor()
	self:setVisible(false)
	self.playerID = 0
	self.sourceID = 0
	self.isMainQueue = true
	self.isRecall = false
	self.isKing = false
	self.isLegendLord = false
	self.isLegendLordForSep = false
	self.hasJoin = false
	self.leagueID = 0
	self.moveLineType = gMapMoveLineType.moveLineTypeAttackLord
	self.moveLineColor = gMapMoveLineColor.moveLineColorWhite
	self.moveLineModel = gMapMoveLineModel.moveLineModelGoOut
	self:setAnchorPoint(cc.p(0.5, 0.5))
	self.moveLine = nil
	self.moveTimeSpan, _ENV, self.moveLineID = self.setAnchorPoint, self.setAnchorPoint, nil
	self.currentMoveTime = 0
	self.totalMoveTime = 0
	self.isLod = false
	self.matrixState = gMapMoveLineStatusType.moveLineStatusTypeRally
	self.beginPoint = nil
	self.endPoint = nil
	self.beginTilePoint = nil
	self.endTilePoint = nil
	self.armyData = nil
	self.emoji = nil
	self.soliderNode = display.newNode()
	self.soliderNode:retain()
end
function worldMapTroopInstance:initData(beginPoint, endPoint, beginTilePoint, endTilePoint, data)
	self.beginPoint = beginPoint
	self.endPoint = endPoint
	self.beginTilePoint = beginTilePoint
	self.endTilePoint = endTilePoint
	self.armyData = data
end
function worldMapTroopInstance:beginMove(delayTime, update)
	local distanceX = self.endPoint.x - self.beginPoint.x
	local distanceY = self.endPoint.y - self.beginPoint.y
	local time = 0
	local distancePrecent = 0.0
	local currentPoint = self.beginPoint
	local isBegin = false
	local isAddFirst = false
	local _ENV, moveDataArray
	self.totalMoveTime = 0
	for k, v in ipairs(self.moveTimeSpan) do
		self.totalMoveTime = self.totalMoveTime + v.time
		time = time + v.time
		if not isBegin and time >= self.currentMoveTime then
			local currentPointX = self.beginPoint.x + distanceX * distancePrecent + distanceX * v.distancePrecent * ((self.currentMoveTime - (time - v.time)) / v.time)
			local currentPointY = self.beginPoint.y + distanceY * distancePrecent + distanceY * v.distancePrecent * ((self.currentMoveTime - (time - v.time)) / v.time)
			currentPoint = cc.p(currentPointX, currentPointY)
			isBegin = true
			isAddFirst = true
			_ENV, distancePrecent = v.distancePrecent, distancePrecent + v.distancePrecent
			v.distancePrecent.point = cc.p(self.beginPoint.x + distanceX * distancePrecent, self.beginPoint.y + distanceY * distancePrecent)
			local v.distancePrecent.time, moveData = time - self.currentMoveTime, v.distancePrecent
			moveDataArray[#moveDataArray + 1] = moveData
			distancePrecent = distancePrecent - v.distancePrecent
		end
		distancePrecent = distancePrecent + v.distancePrecent
		if isAddFirst then
			isAddFirst = false
		elseif isBegin then
			_ENV = v.distancePrecent
			v.distancePrecent.point = cc.p(self.beginPoint.x + distanceX * distancePrecent, self.beginPoint.y + distanceY * distancePrecent)
			local v.distancePrecent.time, moveData = v.time, v.distancePrecent
			moveDataArray[#moveDataArray + 1] = moveData
		end
	end
	self.leftMoveTime = self.totalMoveTime - self.currentMoveTime
	if not update then
		self:setPosition(currentPoint)
	end
	self:startMoveTimer(moveDataArray)
end
function worldMapTroopInstance:stopMoveTimer()
	if self.moveTimer then
		SoraDManagerRemoveTimer(self, self.moveTimer)
		self.moveTimer = nil
	end
	self.moveTimedCallbacks = nil
	self.moveCallbackIndex = nil
	self.moveElapsedTime = nil
	self.moveTimerStartTime = nil
end
function worldMapTroopInstance:startMoveTimer(moveDataArray)
	local _ENV, timedCallbacks
	local accTime = 0
	local isNeedStopAllAction = false
	for i = 1, #moveDataArray do
		local moveData = moveDataArray[i]
		if 0 < moveData.time then
			isNeedStopAllAction = true
			local triggerTime = accTime
			local targetPoint = moveData.point
			local duration = moveData.time
			_ENV = nil
			;(nil).time = triggerTime
			timedCallbacks[#timedCallbacks + 1], (nil).func = nil, function()
				if tolua.isnull(self) then
					return
				end
				local prePoint = cc.p(self:getPositionX(), self:getPositionY())
				if prePoint.x == targetPoint.x and prePoint.y == targetPoint.y then
					return
				end
				self:stopActionByTag(1000)
				local moveToAction = cc.MoveTo:create(duration, targetPoint)
				moveToAction:setTag(1000)
				self:runAction(moveToAction)
				if self.moveLine then
					local distance = cc.pGetDistance(prePoint, targetPoint)
					self.moveLine:updateMoveLineSpeed(distance / duration)
				end
			end
			accTime = accTime + moveData.time
		end
	end
	_ENV = #moveDataArray
	;(#moveDataArray).time = accTime
	timedCallbacks[#timedCallbacks + 1], (#moveDataArray).func = #moveDataArray, function()
		if tolua.isnull(self) then
			return
		end
		self:moveFinish()
	end
	accTime = accTime + 10
	_ENV = #moveDataArray
	;(#moveDataArray).time = accTime
	timedCallbacks[#timedCallbacks + 1], (#moveDataArray).func = #moveDataArray, function()
		if tolua.isnull(self) then
			return
		end
		self:finshWork()
	end
	if isNeedStopAllAction then
		print("stop all actions")
		self:stopActionByTag(1000)
	end
	self.moveTimedCallbacks = timedCallbacks
	self.moveCallbackIndex = 1
	self.moveElapsedTime = 0
	self.moveTimerStartTime = socket.gettime()
	if 0 < #timedCallbacks then
		if self.moveTimer then
			SoraDManagerRemoveTimer(self, self.moveTimer)
		end
		self.moveTimer = SoradCreateTimer(self, handler(self, self.updateTimer), true)
	end
end
function worldMapTroopInstance:updateTimer(dt)
	if not self.moveTimedCallbacks then
		return
	end
	if self.moveTimerStartTime then
		self.moveElapsedTime = socket.gettime() - self.moveTimerStartTime
	else
		self.moveElapsedTime = self.moveElapsedTime + dt
	end
	while self.moveCallbackIndex <= #self.moveTimedCallbacks do
		local callbackData = self.moveTimedCallbacks[self.moveCallbackIndex]
		if self.moveElapsedTime < callbackData.time then
			break
		end
		callbackData.func()
		self.moveCallbackIndex = self.moveCallbackIndex + 1
	end
	if self.moveCallbackIndex > #self.moveTimedCallbacks then
		self:stopMoveTimer()
	end
end
function worldMapTroopInstance:moveFinish()
	self:stopActionByTag(1000)
	self:setPosition(self.endPoint)
	if self.moveLine and not tolua.isnull(self.moveLine) then
		self.moveLine:setVisible(false)
	end
	if self.lodNode and not tolua.isnull(self.lodNode) then
		self.lodNode:setVisible(false)
	end
end
function worldMapTroopInstance:beginWork()
	self:stopAllActions()
	self:stopMoveTimer()
	if self.endPoint then
		self:setPosition(self.endPoint)
	end
	if self.moveLine and not tolua.isnull(self.moveLine) then
		if self.moveLine.setMoveLineHide then
			self.moveLine:setMoveLineHide(true)
		end
		if self.moveLine.getShowTimerKey then
			SoraDManagerRemoveTimerByTarget(self.moveLine:getShowTimerKey())
		end
		self.moveLine:setVisible(false)
	end
	if self.lodNode then
		self.lodNode:setVisible(false)
	end
	_ENV = self.lodNode
	self.lodNode.msg = "MESSAGE_WORLD_MAP_REMOVE_TROOPTIP"
	self.lodNode.moveLineID = self.moveLineID
	self.lodNode.mapMoveToTilePoint = self.endTilePoint
	SoraDSendMessage(self.lodNode)
	_ENV = self.lodNode
	self.lodNode.msg = "MESSAGE_WORLD_MAP_REMOVE_TROOPBINDINGPANEL"
	SoraDSendMessage(self.lodNode)
end
function worldMapTroopInstance:finshWork(delayTime)
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_TROOPTIP"
	;(nil).moveLineID = self.moveLineID
	;(nil).mapMoveToTilePoint = self.endTilePoint
	SoraDSendMessage(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_TROOPBINDINGPANEL"
	SoraDSendMessage(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_MOVELINE"
	;(nil).moveLineID = self.moveLineID
	;(nil).delayTime = delayTime
	SoraDSendMessage(nil)
end
function worldMapTroopInstance:getMapMoveDataArray()
	local distanceX = self.endPoint.x - self.beginPoint.x
	local distanceY = self.endPoint.y - self.beginPoint.y
	local currentPointX, currentPointY = self:getPosition()
	local currentDistancePrecent = 1
	if distanceX ~= 0 then
		currentDistancePrecent = (currentPointX - self.beginPoint.x) / distanceX
	elseif distanceY ~= 0 then
		currentDistancePrecent = (currentPointY - self.beginPoint.y) / distanceY
	end
	local isBegin = false
	local isAddFirst = false
	local distancePrecent = 0
	local preSpanPoint = cc.p(currentPointX, currentPointY)
	local currentSpanPoint
	local leftTime = 0
	local _ENV, moveDataArray
	for k, v in pairs(self.moveTimeSpan) do
		distancePrecent = distancePrecent + v.distancePrecent
		if not isBegin and currentDistancePrecent <= distancePrecent then
			isBegin = true
			isAddFirst = true
		end
		if isBegin then
			currentSpanPoint = cc.p(self.beginPoint.x + distanceX * distancePrecent, self.beginPoint.y + distanceY * distancePrecent)
			local moveTime = v.time
			if isAddFirst then
				isAddFirst = false
				moveTime = v.time * (distancePrecent - currentDistancePrecent) / v.distancePrecent
			end
			_ENV = v.time * (distancePrecent - currentDistancePrecent)
			;(v.time * (distancePrecent - currentDistancePrecent)).point = cc.pSub(preSpanPoint, currentSpanPoint)
			local (v.time * (distancePrecent - currentDistancePrecent)).time, moveData = moveTime, v.time * (distancePrecent - currentDistancePrecent)
			moveDataArray[#moveDataArray + 1] = moveData
			preSpanPoint = currentSpanPoint
			leftTime = leftTime + moveTime
		end
	end
	return moveDataArray, leftTime
end
function worldMapTroopInstance:viewOnClick(ref, type)
	if type == ccui.TouchEventType.ended then
		self:onMovelineClick()
	end
end
function worldMapTroopInstance:setUserData(userData)
