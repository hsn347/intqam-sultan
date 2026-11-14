local commandHallSolider = class("commandHallSolider", function()
	local view = include("worldMapTroopInstance").new(cc.size(80, 80))
	return view
end)
function commandHallSolider:ctor()
	self:setAnchorPoint(cc.p(0.5, 0.5))
end
function commandHallSolider:initData(beginPoint, endPoint, beginTilePoint, endTilePoint, data)
	self.beginPoint = beginPoint
	self.endPoint = endPoint
	self.beginTilePoint = beginTilePoint
	self.endTilePoint = endTilePoint
	self.armyData = data
	local size = self:getContentSize()
	local rotation, imgNameAngle, isFlipX, moveAngle = worldMapFunction.getSoliderImgAngel(beginPoint, endPoint)
	local soldier = display.newSprite("#zhencha_yd_n_01.png")
	soldier:setPosition(cc.p(size.width / 2, size.height / 2))
	soldier:setScale(0.7)
	self.soliderNode:addChild(soldier, 1)
	local animation = display.newAnimationEx("zhencha_yd_" .. imgNameAngle .. "_0%d.png", 1, 8, 0.125)
	soldier:playAnimationForever(animation)
	soldier:setFlippedX(isFlipX)
	self:initCheckVisible()
end
return commandHallSolider
