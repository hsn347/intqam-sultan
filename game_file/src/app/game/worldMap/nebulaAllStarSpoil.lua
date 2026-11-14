local worldMapTroopInstance = include("worldMapTroopInstance")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local nebulaAllStarSpoil = class("nebulaAllStarSpoil", function()
	local view = worldMapTroopInstance.new(cc.size(150, 150))
	return view
end)
function nebulaAllStarSpoil:ctor()
	self:setAnchorPoint(cc.p(1.0, 0.5))
	self.ignoreRequest = true
end
function nebulaAllStarSpoil:initData(beginPoint, endPoint, beginTilePoint, endTilePoint, data)
	self.beginPoint = beginPoint
	self.endPoint = endPoint
	self.beginTilePoint = beginTilePoint
	self.endTilePoint = endTilePoint
	self.armyData = data
	local size = self:getContentSize()
	local rotation, imgNameAngle, isFlipX, moveAngle = worldMapFunction.getSoliderImgAngel(beginPoint, endPoint)
	_ENV = nil
	;(nil).wn = "en"
	;(nil).ws = "es"
	local (nil).w, config = "e", nil
	if isFlipX and config[imgNameAngle] then
		imgNameAngle = config[imgNameAngle]
	end
	self.soliderImg = display.newSprite("#allstar_view_plunder_" .. imgNameAngle .. ".png")
	self.soliderImg:setAnchorPoint(cc.p(0.5, 0.5))
	self.soliderImg:setPosition(cc.p(size.width / 2, size.height / 2))
	self.soliderNode:addChild(self.soliderImg, 1)
	self.soliderImg:setRotation(-moveAngle)
	self:setRotation(rotation)
	self:initCheckVisible()
end
function nebulaAllStarSpoil:moveFinish()
	if self.queueData and self.queueData.isGoback then
		nebulaAllStarCtrl:removeQueuueData(self.queueData.id)
	end
end
function nebulaAllStarSpoil:setQueueData(queueData)
	self.queueData = queueData
end
function nebulaAllStarSpoil:beginWork()
	worldMapTroopInstance.beginWork(self)
end
function nebulaAllStarSpoil:onMovelineClick()
end
return nebulaAllStarSpoil
