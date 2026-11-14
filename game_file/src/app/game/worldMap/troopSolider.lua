local troopSolider = class("troopSolider", function(soliderType, imgNameAngle, troopInstance, soliderNodeBatch)
	local soliderNode = cc.Node:create()
	return soliderNode
end)
local disableAutoCull = function(sprite)
	if sprite.setAutoCull then
		sprite:setAutoCull(false)
	end
end
local troopsHelper = include("troopsHelper")
local troopsMatrixUtil = include("troopsMatrixUtil")
local EffectType = troopsMatrixUtil.EffectType
local SoldierBatchType = troopsMatrixUtil.SoldierBatchType
function troopSolider:ctor(soliderType, imgNameAngle, troopInstance)
	self.bulletList, _ENV = nil, nil
	self.soliderType = soliderType
	self.troopInstance = troopInstance
	self.commandHallTaskType = troopInstance:getCommandHallTaskType()
	self.isFighting = false
	self.batchType = self:getBatchType(soliderType, self.isFighting)
	self.nodeBatch = troopInstance:getSoliderNodeBatch(self.batchType)
	self.factionType = troopInstance.factionType
	local frameKey = self:getSoliderImageNameByType()
	local soliderName
	if self.soliderType == worldMapDefine.soldierType_Jack then
		soliderName = "#" .. frameKey .. "_s_01.png"
	elseif self.soliderType == worldMapDefine.soldierType_Snow then
		soliderName = "#" .. frameKey .. "_" .. imgNameAngle .. "_01.png"
	elseif self.soliderType == worldMapDefine.soldierType_zsjxq then
		soliderName = "#" .. frameKey .. "_yd_01.png"
	else
		soliderName = "#" .. frameKey .. "_yd_" .. imgNameAngle .. "_01.png"
	end
	self.imgNameAngle = imgNameAngle
	self.soliderImg = self:popSprite(soliderName)
	self.soliderImg:addTo(self.nodeBatch, 2)
	self.soliderImg:release()
	self.soliderImg:setVisible(true)
	disableAutoCull(self.soliderImg)
	self.fightingBeginPoint = nil
	self.fightingEndPoint = nil
end
function troopSolider:popSprite(spriteName)
	local cnt = gSoldierSpriteCache and #gSoldierSpriteCache or 0
	if 0 < cnt then
		local sprite = gSoldierSpriteCache[cnt]
		table.remove(gSoldierSpriteCache, cnt)
		if string.byte(spriteName) == 35 then
			spriteName = string.sub(spriteName, 2)
			sprite:setSpriteFrame(spriteName)
		else
			sprite:setTexture(spriteName)
		end
		sprite:setOpacity(255.0)
		sprite:setScale(1)
		sprite:setFlippedX(false)
		return sprite
	end
	local sprite = display.newSprite(spriteName)
	sprite:retain()
	return sprite
end
function troopSolider:pushSprite(sprite)
	if sprite and not tolua.isnull(sprite) then
		sprite:retain()
		sprite:stopAllActions()
		sprite:removeAllChildren()
		sprite:removeFromParent()
		table.insert(gSoldierSpriteCache, sprite)
	end
end
function troopSolider:popBullet(bulletSpriteName)
	local bullets = gBulletCache[bulletSpriteName]
	local cnt = bullets and #bullets or 0
	if 0 < cnt then
		local bulletSp = bullets[cnt]
		if bulletSp then
			table.remove(bullets, cnt)
			return bulletSp
		end
	end
	local bullet = display.newSprite(bulletSpriteName)
	bullet:retain()
	if not bullet then
		return
	end
	return bullet
end
function troopSolider:pushBullet(bulletSpriteName, bullet)
	bullet:retain()
	if not gBulletCache[bulletSpriteName] then
		_ENV = gBulletCache[bulletSpriteName]
	end
	gBulletCache[bulletSpriteName] = gBulletCache[bulletSpriteName]
	table.insert(gBulletCache[bulletSpriteName], bullet)
end
function troopSolider:getSoliderType()
	return self.soliderType
end
function troopSolider:getSoliderImg()
	return self.soliderImg
end
function troopSolider:showAnimation(isShow)
	if isShow then
		if self.soliderImg:isRunning() then
			self.soliderImg:runAction(cca.fadeIn(1.0))
		else
			self.soliderImg:setOpacity(255.0)
		end
	else
		self.soliderImg:setOpacity(0.0)
	end
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
function troopSolider:moveing()
	local beginFrame = 1
	local frames
	local frameKey = self:getSoliderImageNameByType()
	local frameNumInfo = worldMapDefine.getSoliderFrameNum(self.soliderType, false)
	if self.soliderType == worldMapDefine.soldierType_DivineBeast then
		_UPVALUE2_ = self.soliderType
		frameNumInfo, self.soliderType[1] = self.soliderType, 20
		frameNumInfo, self.soliderType[2] = self.soliderType, 20
	end
	if troopsHelper.isSoldierRandom(self.soliderType) then
		beginFrame = math.random(1, 5)
	end
	if self.soliderType == worldMapDefine.soldierType_whale then
		beginFrame = 0
	end
	local frameName
	local frameCount = frameNumInfo[1]
	if self.soliderType == worldMapDefine.soldierType_Jack then
		frameName = frameKey .. "_s_%.2d.png"
		frameCount = 8
	elseif self.soliderType == worldMapDefine.soldierType_Snow then
		frameName = frameKey .. "_" .. self.imgNameAngle .. "_%.2d.png"
	elseif self.soliderType == worldMapDefine.soldierType_zsjxq then
		frameName = frameKey .. "_yd_%.2d.png"
	else
		frameName = frameKey .. "_yd_" .. self.imgNameAngle .. "_%.2d.png"
	end
	self:setSoldierScale()
	self.soliderImg:stopAllActions()
	local animation = display.getAnimationCache(frameName)
	if animation == nil then
		animation = display.newAnimationEx(frameName, 1, frameCount, 1.0 / frameNumInfo[2], beginFrame)
		gAnimationCache[frameName] = true
		display.setAnimationCache(frameName, animation)
	end
	self.soliderImg:playAnimationForever(animation)
end
function troopSolider:goFighting(goPoint, tagetPoint)
	self:setSoldierScale()
	self.soliderImg:stopAllActions()
	self:stopAllActions()
	self.soliderImg:setOpacity(255.0)
	local reference = self.troopInstance
	local partent = self:getParent()
	local pointX, pointY = self:getPosition()
	local beginPoint = SoraDConvertToPoint3D(partent, cc.p(pointX, pointY), reference:getParent())
	local endPoint = SoraDConvertToPoint3D(partent, goPoint, reference:getParent())
	local _, imgNameAngle, isFlipX = worldMapFunction.getSoliderImgAngel(beginPoint, endPoint)
	self.soliderImg:setFlippedX(isFlipX)
	if self.isFighting then
		self.isFighting = false
		local batchType = self:getBatchType(self.soliderType, self.isFighting)
		self:switchBatch(batchType, imgNameAngle, "_yd_")
	end
	local frameNumInfo = worldMapDefine.getSoliderFrameNum(self.soliderType, self.isFighting)
	local frameName = self:getSoliderImageNameByType() .. "_yd_" .. imgNameAngle .. "_%.2d.png"
	local animation = display.getAnimationCache(frameName)
	if animation == nil then
		animation = display.newAnimationEx(self:getSoliderImageNameByType() .. "_yd_" .. imgNameAngle .. "_%.2d.png", 1, frameNumInfo[1], 1.0 / frameNumInfo[2])
		gAnimationCache[frameName] = true
		display.setAnimationCache(frameName, animation)
	end
	self.soliderImg:playAnimationForever(animation)
	local goTime
	if self.soliderType == worldMapDefine.soliderType_Hero then
		goTime = 1
	else
		goTime = math.random() + 1
	end
	local _ENV, actionsArray = math.random(), math.random()
	actionsArray[#actionsArray + 1] = cc.MoveTo:create(goTime, goPoint)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		self:fighting(tagetPoint)
	end)
	local action = transition.sequence(actionsArray)
	self.soliderImg:runAction(cc.MoveTo:create(goTime, goPoint))
	self:runAction(action)
end
function troopSolider:fighting(tagetPoint)
	self.soliderImg:stopAllActions()
	self:stopAllActions()
	self:updateFightingPoint(tagetPoint)
	local _, imgNameAngle, isFlipX = worldMapFunction.getSoliderImgAngel(self.fightingBeginPoint, self.fightingEndPoint)
	self.soliderImg:setFlippedX(isFlipX)
	self.isFighting = true
	local batchType = self:getBatchType(self.soliderType, self.isFighting)
	self:switchBatch(batchType, imgNameAngle, "_gj_")
	self.fightFrameName = self:getSoliderImageNameByType() .. "_gj_" .. imgNameAngle .. "_%.2d.png"
	self:playFightingAnimation(tagetPoint)
end
function troopSolider:playFightingAnimation(tagetPoint)
	self.soliderImg:stopAllActions()
	local frameNumInfo = worldMapDefine.getSoliderFrameNum(self.soliderType, self.isFighting)
	local frameName = self.fightFrameName
	local animation = display.getAnimationCache(frameName)
	if animation == nil then
		animation = display.newAnimationEx(self.fightFrameName, 1, frameNumInfo[1], 1.0 / frameNumInfo[2])
		gAnimationCache[frameName] = true
		display.setAnimationCache(frameName, animation)
	end
	self.soliderImg:playAnimationOnce(animation)
	local thowDelay = 0
	local animationDelay = 1.0
	local bulletSpriteName
	local scale = 0.5
	local beginPoint = self.fightingBeginPoint
	if self.soliderType == worldMapDefine.soldierType_GongjianBing or self.soliderType == worldMapDefine.soldierType_StarNuBing then
		thowDelay = 0.2
		animationDelay = 1.0
		bulletSpriteName = "#icon_battle_jian_4.png"
		scale = 0.5
		beginPoint = cc.p(self.fightingBeginPoint.x, self.fightingBeginPoint.y)
	elseif self.soliderType == worldMapDefine.soldierType_Sniper or self.soliderType == worldMapDefine.soldierType_SniperBing then
		thowDelay = 0.4
		animationDelay = 1.0
		bulletSpriteName = "#icon_battle_jian_4.png"
		scale = 0.5
		beginPoint = cc.p(self.fightingBeginPoint.x, self.fightingBeginPoint.y)
	elseif self.soliderType == worldMapDefine.soldierType_ZhanChe or self.soliderType == worldMapDefine.soldierType_StarCheBing then
		thowDelay = 0.5
		animationDelay = 2.0
		bulletSpriteName = "#icon_battle_stone.png"
		scale = 0.4
		beginPoint = cc.p(self.fightingBeginPoint.x, self.fightingBeginPoint.y + 15)
	end
	if bulletSpriteName then
		local _ENV, actionsArray1 = cc.p(self.fightingBeginPoint.x, self.fightingBeginPoint.y + 15), cc.p(self.fightingBeginPoint.x, self.fightingBeginPoint.y + 15)
		actionsArray1[#actionsArray1 + 1] = cc.DelayTime:create(thowDelay)
		actionsArray1[#actionsArray1 + 1] = cc.CallFunc:create(function()
			local isRunning = self:isRunning()
			if self._isRunning ~= isRunning then
				self._isRunning = isRunning
				if isRunning then
					self:updateFightingPoint(tagetPoint)
				end
			end
			if not isRunning then
				return
			end
			self:playThrowAction(bulletSpriteName, scale, beginPoint)
		end)
		local actions1 = transition.sequence(actionsArray1)
		self:runAction(actions1)
	end
	local _ENV, actionsArray2 = actionsArray1, cc.p(self.fightingBeginPoint.x, self.fightingBeginPoint.y + 15)
	actionsArray2[#actionsArray2 + 1] = cc.DelayTime:create(animationDelay)
	actionsArray2[#actionsArray2 + 1] = cc.CallFunc:create(function()
		self:playFightingAnimation(tagetPoint)
	end)
	local actions2 = transition.sequence(actionsArray2)
	self:runAction(actions2)
end
function troopSolider:playThrowAction(bulletSpriteName, scale, beginPoint)
	local bulletSprite = self:popBullet(bulletSpriteName)
	if not bulletSprite then
		return
	end
	local reference = self.troopInstance
	local zOder = reference:getLocalZOrder()
	bulletSprite:setPosition(beginPoint)
	bulletSprite:setScale(scale)
	reference:getParent():addChild(bulletSprite, zOder)
	bulletSprite:release()
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	local radius = 10
	local angle = math.random(-180, 180)
	local radian = math.angle2radian(angle)
	local pointX = self.fightingEndPoint.x + radius * math.cos(radian)
	local pointY = self.fightingEndPoint.y + radius * math.sin(radian)
	worldMapFunction.createThrowAction(bulletSprite, beginPoint, cc.p(pointX, pointY), nil, nil, function()
		self:pushBullet(bulletSpriteName, bulletSprite)
	end)
end
function troopSolider:addToSoliderImg(et_node, fscale)
	et_node:addTo(self.soliderImg, -1)
	local pos = self.soliderImg:getAnchorPointInPoints()
	et_node:setPosition(cc.p(pos.x, pos.y - 15))
	local scale = et_node:getScale()
	local scaleSoldier = self.soliderImg:getScale()
	if fscale then
		et_node:setScale(scale / scaleSoldier * fscale)
	else
		et_node:setScale(scale / scaleSoldier)
	end
end
function troopSolider:troopEffect_imp(isShow, name, fscale)
	if self.effect_node then
		self.effect_node:removeFromParent()
		self.effect_node = nil
	end
	if isShow then
		local imgName = troopsMatrixUtil.getEffectImageName(self.batchType, name)
		local et_node = self:createTroopEffect(imgName)
		self:addToSoliderImg(et_node, fscale)
		self.effect_node = et_node
	end
end
function troopSolider:recreateTroopEffectTypeSoldier()
	if self.effectType and self.effectType ~= EffectType.EffectType_None then
		local effectType = self.effectType
		self:hideTroopEffectType(effectType)
		self:showTroopEffectTypeSoldier(effectType, false)
	end
end
function troopSolider:effectShow(effectType, isShow, isPreview)
	local effectCfg = troopsHelper.getEffectKeyCfg(effectType)
	if effectCfg and effectCfg.key then
		self:troopEffect_imp(isShow, effectCfg.key, effectCfg.scale)
	end
end
function troopSolider:showTroopEffectTypeSoldier(effectType, isPreview)
	self:effectShow(effectType, true, isPreview)
	self.effectType = effectType
end
function troopSolider:hideTroopEffectType(effectType)
	self:effectShow(effectType, false)
	self.effectType = effectType
end
function troopSolider:createTroopEffect(imgName)
	local et_node = SoraDCreateTroopNode(imgName)
	if self.soliderType == worldMapDefine.soldierType_BuBing then
		et_node:setScale(0.36)
	elseif self.soliderType == worldMapDefine.soldierType_QiBing then
		et_node:setScale(0.48)
	elseif self.soliderType == worldMapDefine.soldierType_GongjianBing then
		et_node:setScale(0.5)
	elseif self.soliderType == worldMapDefine.soldierType_ZhanChe then
		et_node:setScale(1.1)
	elseif self.soliderType == worldMapDefine.soldierType_XiangBing then
		et_node:setScale(1.188)
	elseif self.soliderType == worldMapDefine.soldierType_Jack then
		et_node:setScale(1.188)
	elseif self.soliderType == worldMapDefine.soldierType_JingYing then
		et_node:setScale(0.6)
	elseif self.soliderType == worldMapDefine.soldierType_Hero then
		et_node:setScale(1.44)
	elseif self.soliderType == worldMapDefine.soldierType_HeroBack then
		et_node:setScale(0.5)
	else
		et_node:setScale(0.6)
	end
	disableAutoCull(et_node)
	return et_node
end
function troopSolider:setSoldierScale()
	local defaultScale = 0.65
	if self.soliderType == worldMapDefine.soldierType_QiBing or self.soliderType == worldMapDefine.soldierType_ZhanChe then
		self.soliderImg:setScale(0.55)
	elseif self.soliderType == worldMapDefine.soldierType_DivineBeast or self.soliderType == worldMapDefine.soldierType_DivineBeast_1901 then
		self.soliderImg:setScale(1.15)
	elseif self.soliderType == worldMapDefine.soldierType_zbxb or self.soliderType == worldMapDefine.soldierType_zbsb then
		self.soliderImg:setScale(1.0)
	elseif troopsHelper.getSoldierScale(self.soliderType) then
		self.soliderImg:setScale(troopsHelper.getSoldierScale(self.soliderType))
	else
		self.soliderImg:setScale(defaultScale)
	end
end
function troopSolider:setSoldierPos(pos)
	self:setPosition(pos)
	self.soliderImg:setPosition(pos)
end
function troopSolider:getSoliderImageNameByType()
	local imageName = worldMapDefine.getSoliderImageNameByType(self.soliderType, self.factionType)
	if self.commandHallTaskType == gCommandHallTaskType.REBEL_ARMY_GROUP_TASK and (imageName == "bubing" or imageName == "qibing" or imageName == "gongbing") then
		return "red" .. imageName
	end
	return imageName
end
function troopSolider:switchBatch(batchType, imgNameAngle, index)
	if self.batchType ~= batchType then
		self.batchType = batchType
		self.nodeBatch = self.troopInstance:getSoliderNodeBatch(self.batchType)
		self.soliderImg:retain()
		local posx, posy = self.soliderImg:getPosition()
		self.soliderImg:removeFromParent()
		local newImage = self:getSoliderImageNameByType() .. index .. imgNameAngle .. "_01.png"
		self.soliderImg:setSpriteFrame(newImage)
		self:recreateTroopEffectTypeSoldier()
		self.soliderImg:addTo(self.nodeBatch, 2)
		self.soliderImg:setPosition(cc.p(posx, posy))
		disableAutoCull(self.soliderImg)
		self.soliderImg:release()
	end
end
function troopSolider:getBatchType(soliderType, isFighting)
	if self.commandHallTaskType == gCommandHallTaskType.REBEL_ARMY_GROUP_TASK then
		return SoldierBatchType.SoldierBatchType_Node
	else
		return troopsMatrixUtil.getSoldierBatchType(soliderType, isFighting)
	end
end
function troopSolider:updateFightingPoint(tagetPoint)
	local reference = self.troopInstance
	local partent = self:getParent()
	local pointX, pointY = self:getPosition()
	self.fightingBeginPoint = SoraDConvertToPoint3D(partent, cc.p(pointX, pointY), reference:getParent())
	self.fightingEndPoint = SoraDConvertToPoint3D(partent, tagetPoint, reference:getParent())
end
return troopSolider
