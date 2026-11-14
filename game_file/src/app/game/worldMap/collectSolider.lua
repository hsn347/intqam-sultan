local collectSolider = class("collectSolider", function()
	local view = include("worldMapTroopInstance").new(cc.size(80, 80))
	return view
end)
local JACK_O_LANTERN_ID = worldMapCastleEffectID.JACK_O_LANTERN_ID
function collectSolider:ctor()
	self:setAnchorPoint(cc.p(0.5, 0.5))
	local size = self:getContentSize()
	self.particle_node = display.newNode()
	self.particle_node:setPosition(cc.p(size.width / 2, size.height / 2))
	self.soliderNode:addChild(self.particle_node, 1)
	self.soldiersArray, _ENV = self.soliderNode.addChild, self.soliderNode.addChild
	self.hasJackOLantern = false
end
function collectSolider:initData(beginPoint, endPoint, beginTilePoint, endTilePoint, data)
	self.beginPoint = beginPoint
	self.endPoint = endPoint
	self.beginTilePoint = beginTilePoint
	self.endTilePoint = endTilePoint
	self.armyData = data
	self.hasJackOLantern = self.marchArmyEffectId == JACK_O_LANTERN_ID
	self:switchSolider(self.hasJackOLantern)
	self:initCheckVisible()
end
function collectSolider:initSolider()
	local rotation, imgNameAngle, isFlipX, moveAngle = worldMapFunction.getSoliderImgAngel(self.beginPoint, self.endPoint)
	local size = self:getContentSize()
	local soldier = display.newSprite("#caiji_yd_n_01.png")
	soldier:setPosition(cc.p(size.width / 2, size.height / 2))
	self.soliderNode:addChild(soldier, 1)
	self.soldiersArray[#self.soldiersArray + 1] = soldier
	soldier:setScale(0.7)
	local frames = display.newFrames("caiji_yd_" .. imgNameAngle .. "_0%d.png", 1, 8)
	local animation = display.newAnimation(frames, 0.125)
	soldier:playAnimationForever(animation)
	soldier:setFlippedX(isFlipX)
	self:setRotation(0)
end
local sharedSpriteFrameCache = cc.SpriteFrameCache:getInstance()
local newFramesMod = function(pattern, begin, length, isReversed)
	local _ENV, frames
	local last = begin + length - 1
	local step = 1
	if isReversed then
		last, begin = begin, last
		step = -1
	end
	for index = begin, last, step do
		if length < index then
			index = index - length
		end
		local frameName = string.format(pattern, index)
		local frame = sharedSpriteFrameCache:getSpriteFrame(frameName)
		if not frame then
			printError("display.newFrames() - invalid frame, name %s", tostring(frameName))
			return
		end
		frames[#frames + 1] = frame
	end
	return frames
end
function collectSolider:createSoliderJack()
	local soldier = display.newSprite("#caiji_yd_n_01.png")
	self.soliderNode:addChild(soldier, 1)
	self.soldiersArray[#self.soldiersArray + 1] = soldier
	soldier:setScale(0.8)
	local beginFrame = math.random(1, 5)
	local frames = newFramesMod("nanguat_s_0%d.png", beginFrame, 8)
	local animation = display.newAnimation(frames, 0.08333333333333333)
	soldier:playAnimationForever(animation)
	return soldier
end
function collectSolider:initSoliderJack()
	local rotation, imgNameAngle, isFlipX, moveAngle = worldMapFunction.getSoliderImgAngel(self.beginPoint, self.endPoint)
	local size = self:getContentSize()
	local soldier1 = self:createSoliderJack()
	soldier1:setPosition(cc.p(size.width / 2, size.height / 2))
	soldier1:setFlippedX(isFlipX)
	soldier1:setRotation(-moveAngle)
	local soldier2 = self:createSoliderJack()
	soldier2:setPosition(cc.p(size.width / 2 - 55, size.height / 2))
	soldier2:setFlippedX(isFlipX)
	soldier2:setRotation(-moveAngle)
	self:setRotation(rotation)
end
function collectSolider:switchSolider(hasJackOLantern)
	for index, soldier in pairs(self.soldiersArray) do
		soldier:removeFromParent()
	end
	self.soldiersArray, _ENV = pairs(self.soldiersArray)
	if hasJackOLantern then
		self:initSoliderJack()
		self:kingTroopEffect(false)
	else
		self:initSolider()
		self:kingTroopEffect(self.isKing)
	end
end
function collectSolider:kingTroopEffect(isShow)
	self.particle_node:removeAllChildren()
	if isShow and not self.hasJackOLantern then
		local et_node = SoraDCreateTroopNode("#troop_king.png")
		et_node:setPosition(cc.p(0, -10))
		et_node:setScale(1.75)
		et_node:addTo(self.particle_node)
	end
end
function collectSolider:setHasJackOLantern(hasJackOLantern)
	hasJackOLantern = hasJackOLantern or false
	if self.hasJackOLantern == hasJackOLantern then
		return
	end
	self.hasJackOLantern = hasJackOLantern
	if self.matrixState == gMapMoveLineStatusType.moveLineStatusTypeMoving then
		self:switchSolider(self.hasJackOLantern)
	end
end
function collectSolider:setMarchArmyEffectID(effectID)
	self.marchArmyEffectId = effectID or 0
	self:setHasJackOLantern(self.marchArmyEffectId == JACK_O_LANTERN_ID)
end
return collectSolider
