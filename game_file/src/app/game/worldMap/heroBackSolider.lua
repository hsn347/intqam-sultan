local heroBackSolider = class("heroBackSolider", function()
	local view = include("worldMapTroopInstance").new(cc.size(80, 80))
	return view
end)
function heroBackSolider:ctor()
	self:setAnchorPoint(cc.p(0.5, 0.5))
	local size = self:getContentSize()
	self.particle_node = display.newNode()
	self.particle_node:setPosition(cc.p(size.width / 2, size.height / 2))
	self.soliderNode:addChild(self.particle_node, 1)
end
function heroBackSolider:initData(beginPoint, endPoint, beginTilePoint, endTilePoint, data)
	self.beginPoint = beginPoint
	self.endPoint = endPoint
	self.beginTilePoint = beginTilePoint
	self.endTilePoint = endTilePoint
	self.heroInfo = data
	local size = self:getContentSize()
	local _, imgNameAngle, isFlipX = worldMapFunction.getSoliderImgAngel(beginPoint, endPoint)
	local soldier = display.newSprite("#defeated_man_yd_n_01.png")
	soldier:setPosition(cc.p(size.width / 2, size.height / 2))
	soldier:setScale(0.7)
	self.soliderNode:addChild(soldier, 1)
	local frames = display.newFrames("defeated_man_yd_" .. imgNameAngle .. "_0%d.png", 1, 8)
	local animation = display.newAnimation(frames, 0.125)
	soldier:playAnimationForever(animation)
	soldier:setFlippedX(isFlipX)
	self:kingTroopEffect(self.isKing)
	self:initCheckVisible()
end
function heroBackSolider:kingTroopEffect(isShow)
	self.particle_node:removeAllChildren()
	if isShow then
		local et_node = SoraDCreateTroopNode("#troop_king.png")
		et_node:setPosition(cc.p(0, -10))
		et_node:setScale(0.6)
		et_node:addTo(self.particle_node)
	end
end
return heroBackSolider
