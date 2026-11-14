local worldMapTroopInstance = include("worldMapTroopInstance")
local nebulaDefenceSolider = class("nebulaDefenceSolider", function()
	local view = worldMapTroopInstance.new(cc.size(150, 150))
	return view
end)
function nebulaDefenceSolider:ctor()
	self:setAnchorPoint(cc.p(1.0, 0.5))
end
function nebulaDefenceSolider:initData(beginPoint, endPoint, beginTilePoint, endTilePoint, data)
	self.beginPoint = beginPoint
	self.endPoint = endPoint
	self.beginTilePoint = beginTilePoint
	self.endTilePoint = endTilePoint
	self.armyData = data
	local size = self:getContentSize()
	local rotation, imgNameAngle, isFlipX, moveAngle = worldMapFunction.getSoliderImgAngel(beginPoint, endPoint)
	local hasHD = true
	self.hasHD = hasHD
	if self.hasHD then
		self.soliderImg = display.newSprite("#lanlong_yd_n_01.png")
		self.soliderImg:setAnchorPoint(cc.p(0.5, 0.5))
		self.soliderImg:setPosition(cc.p(size.width / 2, size.height / 2))
		self.soliderImg:setScale(1.5)
		self.soliderNode:addChild(self.soliderImg, 1)
		local frames = display.newFrames("lanlong_yd_" .. imgNameAngle .. "_%02d.png", 1, 24)
		local animation = display.newAnimation(frames, 0.041666666666666664)
		self.soliderImg:playAnimationForever(animation)
	else
		if not worldMapDefine.hasLmqbNormalRes() then
			local plistName = "worldMap/worldMapLmzhIcon.plist"
			local imageName = getImageFileNameByPlatform("worldMap/worldMapLmzhIcon")
			display.addSpriteFrames(plistName, imageName)
		end
		self.soliderImg = display.newSprite("#lanlong_yd_" .. imgNameAngle .. ".png")
		self.soliderImg:setAnchorPoint(cc.p(0.5, 0.5))
		self.soliderImg:setPosition(cc.p(size.width / 2, size.height / 2))
		self.soliderImg:setScale(1.5)
		self.soliderNode:addChild(self.soliderImg, 1)
	end
	self.soliderImg:setFlippedX(isFlipX)
	self.soliderImg:setRotation(-moveAngle)
	self:setRotation(rotation)
	self:initCheckVisible()
end
function nebulaDefenceSolider:beginWork()
	worldMapTroopInstance.beginWork(self)
	local targetPointX = self:getContentSize().width * 0.5
	local targetPointY = self:getContentSize().height * 0.5
	local standPointX = -self:getContentSize().width / 4
	local standPointY = self:getContentSize().height * 0.5
	self:goFighting(cc.p(standPointX, standPointY), cc.p(targetPointX, targetPointY))
end
function nebulaDefenceSolider:goFighting(goPoint, tagetPoint)
	self.soliderImg:setVisible(true)
	self.soliderImg:stopAllActions()
	self:stopAllActions()
	local pointX, pointY = self.soliderImg:getPosition()
	local beginPoint = SoraDCoverToPoint(self, cc.p(pointX, pointY), self:getParent())
	local endPoint = SoraDCoverToPoint(self, goPoint, self:getParent())
	local _, imgNameAngle, isFlipX = worldMapFunction.getSoliderImgAngel(beginPoint, endPoint)
	self.soliderImg:setFlippedX(isFlipX)
	if self.hasHD then
		local frames = display.newFrames("lanlong_yd_" .. imgNameAngle .. "_%02d.png", 1, 24)
		local animation = display.newAnimation(frames, 0.041666666666666664)
		self.soliderImg:setScale(1.5)
		self.soliderImg:playAnimationForever(animation)
	else
		self.soliderImg:setSpriteFrame("lanlong_yd_" .. imgNameAngle .. ".png")
	end
	local goTime = math.random() + 1
	local _ENV, actionsArray = self.soliderImg, self.soliderImg
	actionsArray[#actionsArray + 1] = cc.MoveTo:create(goTime, goPoint)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		self:fighting(tagetPoint)
	end)
	local action = transition.sequence(actionsArray)
	self.soliderImg:runAction(action)
end
function nebulaDefenceSolider:fighting(tagetPoint)
	self.soliderImg:stopAllActions()
	self:stopAllActions()
	local pointX, pointY = self.soliderImg:getPosition()
	self.fightingBeginPoint = SoraDCoverToPoint(self, cc.p(pointX, pointY), self:getParent())
	self.fightingEndPoint = SoraDCoverToPoint(self, tagetPoint, self:getParent())
	local _, imgNameAngle, isFlipX = worldMapFunction.getSoliderImgAngel(self.fightingBeginPoint, self.fightingEndPoint)
	self.soliderImg:setFlippedX(isFlipX)
	self.isFlipX = isFlipX
	if self.hasHD then
		self.fightingFrames = display.newFrames("lanlong_gj_" .. imgNameAngle .. "_%02d.png", 1, 24)
	else
		self.soliderImg:setSpriteFrame("lanlong_gj_" .. imgNameAngle .. ".png")
	end
	self:playFightingAnimation()
end
function nebulaDefenceSolider:playFightingAnimation()
	if self.hasHD then
		self.soliderImg:stopAllActions()
		local animation = display.newAnimation(self.fightingFrames, 0.041666666666666664)
		self.soliderImg:playAnimationOnce(animation)
	end
	local thowDelay = 0
	local animationDelay = 1.0
	local _ENV, actionsArray2 = self.soliderImg, self.soliderImg
	actionsArray2[#actionsArray2 + 1] = cc.DelayTime:create(animationDelay)
	actionsArray2[#actionsArray2 + 1] = cc.CallFunc:create(function()
		self:playFightingAnimation()
	end)
	local actions2 = transition.sequence(actionsArray2)
	self:runAction(actions2)
end
function nebulaDefenceSolider:playThrowAction(bulletSpriteName, scale, beginPoint)
	local bulletSprite = display.newSprite(bulletSpriteName)
	if not bulletSprite then
		return
	end
	local reference = self:getParent()
	local zOder = reference:getLocalZOrder()
	bulletSprite:setPosition(beginPoint)
	bulletSprite:setScale(scale)
	reference:getParent():addChild(bulletSprite, zOder)
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	local radius = 10
	local angle = math.random(-180, 180)
	local radian = math.angle2radian(angle)
	local pointX = self.fightingEndPoint.x + radius * math.cos(radian)
	local pointY = self.fightingEndPoint.y + radius * math.sin(radian)
	worldMapFunction.createThrowAction(bulletSprite, beginPoint, cc.p(pointX, pointY))
end
return nebulaDefenceSolider
