local tradeSolider = class("tradeSolider", function()
	local view = include("worldMapTroopInstance").new(cc.size(100, 100))
	return view
end)
function tradeSolider:ctor()
	self:setAnchorPoint(cc.p(0.5, 0.5))
end
function tradeSolider:initData(beginPoint, endPoint, beginTilePoint, endTilePoint, data)
	self.beginPoint = beginPoint
	self.endPoint = endPoint
	self.beginTilePoint = beginTilePoint
	self.endTilePoint = endTilePoint
	self.armyData = data
	local size = self:getContentSize()
	local rotation, imgNameAngle, isFlipX, moveAngle = worldMapFunction.getSoliderImgAngel(beginPoint, endPoint)
	local soldier = display.newSprite("#shangdui_yd_w_01.png")
	soldier:setPosition(cc.p(size.width / 2, size.height / 2))
	soldier:setScale(0.7)
	self.soliderNode:addChild(soldier, 1)
	local frames = display.newFrames("shangdui_yd_" .. imgNameAngle .. "_0%d.png", 1, 8)
	local animation = display.newAnimation(frames, 0.125)
	soldier:playAnimationForever(animation)
	soldier:setFlippedX(isFlipX)
	self:initCheckVisible()
end
return tradeSolider
