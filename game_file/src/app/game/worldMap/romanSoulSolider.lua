local worldMapTroopInstance = include("worldMapTroopInstance")
local romanSoulSolider = class("romanSoulSolider", function()
	local view = worldMapTroopInstance.new(cc.size(150, 150))
	return view
end)
function romanSoulSolider:ctor()
	self:setAnchorPoint(cc.p(1.0, 0.5))
end
function romanSoulSolider:initData(beginPoint, endPoint, beginTilePoint, endTilePoint, data)
	self.beginPoint = beginPoint
	self.endPoint = endPoint
	self.beginTilePoint = beginTilePoint
	self.endTilePoint = endTilePoint
	self.armyData = data
	local size = self:getContentSize()
	local rotation, imgNameAngle, isFlipX, moveAngle = worldMapFunction.getSoliderImgAngel(beginPoint, endPoint)
	local hasHD = worldMapDefine.hasLmqbHdRes()
	self.soliderImgs, _ENV, self.hasHD = nil, nil, hasHD
	if self.hasHD then
		self.soliderImg = display.newSprite("#lmzh_yd_n_01.png")
		self.soliderImg:setAnchorPoint(cc.p(0.5, 0.5))
		self.soliderImg:setPosition(cc.p(size.width / 2, size.height / 2))
		self.soliderImg:setScale(0.65)
		self.soliderNode:addChild(self.soliderImg, 1)
		local frames = display.newFrames("lmzh_yd_" .. imgNameAngle .. "_0%d.png", 1, 8)
		local animation = display.newAnimation(frames, 0.125)
		self.soliderImg:playAnimationForever(animation)
		for i = 1, 2 do
			local soliderImg = display.newSprite("#lmxd_yd_n_01.png")
			soliderImg:setAnchorPoint(cc.p(0.5, 0.5))
			soliderImg:setPosition(cc.p(size.width / 2 - 100, size.height / 2 + 20 - 40 * (i - 1)))
			soliderImg:setScale(0.65)
			self.soliderNode:addChild(soliderImg, 1)
			local frames = display.newFrames("lmxd_yd_" .. imgNameAngle .. "_0%d.png", 1, 8)
			local animation = display.newAnimation(frames, 0.125)
			soliderImg:playAnimationForever(animation)
			table.insert(self.soliderImgs, soliderImg)
		end
	else
		if not worldMapDefine.hasLmqbNormalRes() then
			local plistName = "worldMap/worldMapLmzhIcon.plist"
			local imageName = getImageFileNameByPlatform("worldMap/worldMapLmzhIcon")
			display.addSpriteFrames(plistName, imageName)
		end
		self.soliderImg = display.newSprite("#lmzh_yd_" .. imgNameAngle .. ".png")
		self.soliderImg:setAnchorPoint(cc.p(0.5, 0.5))
		self.soliderImg:setPosition(cc.p(size.width / 2, size.height / 2))
		self.soliderImg:setScale(0.65)
		self.soliderNode:addChild(self.soliderImg, 1)
	end
	self.soliderImg:setFlippedX(isFlipX)
	self.soliderImg:setRotation(-moveAngle)
	for i, v in ipairs(self.soliderImgs) do
		v:setFlippedX(isFlipX)
		v:setRotation(-moveAngle)
	end
	self:setRotation(rotation)
	self:initCheckVisible()
end
function romanSoulSolider:beginWork()
	worldMapTroopInstance.beginWork(self)
	local targetPointX = self:getContentSize().width * 0.5
	local targetPointY = self:getContentSize().height * 0.5
	local standPointX = -self:getContentSize().width / 4
	local standPointY = self:getContentSize().height * 0.5
	self:goFighting(cc.p(standPointX, standPointY), cc.p(targetPointX, targetPointY))
end
function romanSoulSolider:goFighting(goPoint, tagetPoint)
	self.soliderImg:setVisible(true)
	self.soliderImg:stopAllActions()
	self:stopAllActions()
	local pointX, pointY = self.soliderImg:getPosition()
	local beginPoint = SoraDCoverToPoint(self, cc.p(pointX, pointY), self:getParent())
	local endPoint = SoraDCoverToPoint(self, goPoint, self:getParent())
	local _, imgNameAngle, isFlipX = worldMapFunction.getSoliderImgAngel(beginPoint, endPoint)
	self.soliderImg:setFlippedX(isFlipX)
	if self.hasHD then
		local frames = display.newFrames("lmzh_yd_" .. imgNameAngle .. "_0%d.png", 1, 8)
		local animation = display.newAnimation(frames, 0.125)
		self.soliderImg:playAnimationForever(animation)
		for i, v in ipairs(self.soliderImgs) do
			v:setFlippedX(isFlipX)
			v:stopAllActions()
			local frames = display.newFrames("lmxd_yd_" .. imgNameAngle .. "_0%d.png", 1, 8)
			local animation = display.newAnimation(frames, 0.125)
			v:playAnimationForever(animation)
		end
	else
		self.soliderImg:setSpriteFrame("lmzh_yd_" .. imgNameAngle .. ".png")
	end
	local goTime = math.random() + 1
	local _ENV, actionsArray = self.soliderImg, self.soliderImg
	actionsArray[#actionsArray + 1] = cc.MoveTo:create(goTime, goPoint)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		self:fighting(tagetPoint)
	end)
	local action = transition.sequence(actionsArray)
	self.soliderImg:runAction(action)
	for i, v in ipairs(self.soliderImgs) do
		local _ENV, actionsArray = display.newAnimation(frames, 0.125), display.newAnimation(frames, 0.125)
		actionsArray[#actionsArray + 1] = cc.MoveTo:create(goTime, cc.p(goPoint.x, goPoint.y + 50 - 100 * (i - 1)))
		actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		end)
		local action = transition.sequence(actionsArray)
		v:runAction(action)
	end
end
function romanSoulSolider:fighting(tagetPoint)
	if self.aniCsb then
		self.aniCsb:removeFromParent()
		self.aniCsb = nil
	end
	self.soliderImg:stopAllActions()
	self:stopAllActions()
	local pointX, pointY = self.soliderImg:getPosition()
	self.fightingBeginPoint = SoraDCoverToPoint(self, cc.p(pointX, pointY), self:getParent())
	self.fightingEndPoint = SoraDCoverToPoint(self, tagetPoint, self:getParent())
	local _, imgNameAngle, isFlipX = worldMapFunction.getSoliderImgAngel(self.fightingBeginPoint, self.fightingEndPoint)
	self.soliderImg:setFlippedX(isFlipX)
	for i, v in ipairs(self.soliderImgs) do
		v:setFlippedX(isFlipX)
	end
	self.isFlipX = isFlipX
	if self.hasHD then
		self.fileName = "lmzh_gj_" .. imgNameAngle
		self.fightingFrames = display.newFrames("lmxd_gj_" .. imgNameAngle .. "_0%d.png", 1, 8)
	else
		self.soliderImg:setSpriteFrame("lmzh_gj_" .. imgNameAngle .. ".png")
	end
	self:playFightingAnimation()
end
function romanSoulSolider:playFightingAnimation()
	if self.hasHD then
		if self.aniCsb then
			self.aniCsb:removeFromParent()
			self.aniCsb = nil
		end
		local size = self:getContentSize()
		self.soliderImg:setVisible(false)
		self.aniCsb = SoraDCreatAnimation(self.fileName, nil, false)
		self.aniCsb:setPosition(self.soliderImg:getPosition())
		self.aniCsb:setScaleX(self.isFlipX and -0.65 or 0.65)
		self.aniCsb:setScaleY(0.65)
		self.aniCsb:setRotation(self.soliderImg:getRotation())
		self.soliderNode:addChild(self.aniCsb, 1)
		for i, v in ipairs(self.soliderImgs) do
			v:stopAllActions()
			local animation = display.newAnimation(self.fightingFrames, 0.125)
			v:playAnimationOnce(animation)
		end
	end
	local thowDelay = 0
	local animationDelay = 1.0
	local _ENV, actionsArray2 = ipairs(self.soliderImgs)
	actionsArray2[#actionsArray2 + 1] = cc.DelayTime:create(animationDelay)
	actionsArray2[#actionsArray2 + 1] = cc.CallFunc:create(function()
		self:playFightingAnimation()
	end)
	local actions2 = transition.sequence(actionsArray2)
	self:runAction(actions2)
end
function romanSoulSolider:playThrowAction(bulletSpriteName, scale, beginPoint)
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
return romanSoulSolider
