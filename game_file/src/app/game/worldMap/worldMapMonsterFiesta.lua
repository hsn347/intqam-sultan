local worldMapMonsterFiesta = class("worldMapMonsterFiesta", function()
	local target = include("worldMapInstance").new("worldMapMonsterFiesta")
	return target
end)
function worldMapMonsterFiesta:ctor()
	self.monsterClassID = nil
	self.imgName = nil
	self.imgNameAngle = nil
	self.isFlipX = nil
	self:_initUI()
	self:_initData()
end
function worldMapMonsterFiesta:_initData()
	self.monsterState = 1
	self.isCanKill = false
	self.fightingFrames = nil
	self.fightingImgNameAngle = nil
	self.fightingIsFlipX = nil
end
function worldMapMonsterFiesta:_initUI()
	self.monster = display.newSpriteNoChild("#anbs_dj_ws_01.png")
	self:addChild(self.monster, -1)
	_ENV = self
	self.UILabelType = 2
	self.text = ""
	self.size = 16
	self.monsterNameLabel = SoraDCreateLabelNoChild(self)
	self.monsterNameLabel:setColor(cc.c3b(82, 51, 21))
	self.monsterNameLabel:setAnchorPoint(cc.p(0.5, 0.5))
	self.monsterNameLabel:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 70))
	self.monsterNameLabel:addTo(self, 1)
	self.monsterNameLabel:setGroupID(worldMapDefine.GROU_ID.group_text_monster)
	self.image_level = display.newSpriteNoChild("#frame_YX_kapaidengji.png")
	self.image_level:setPosition(cc.p(self.centerPoint.x - 63, self.centerPoint.y - 70))
	self.image_level:addTo(self, 1)
	self.image_level:setGroupID(worldMapDefine.GROU_ID.group_level_monster)
	_ENV = self.image_level
	self.image_level.UILabelType = 2
	self.image_level.text = ""
	self.image_level.size = 14
	self.monsterLevelLabel = SoraDCreateLabelNoChild(self.image_level)
	self.monsterLevelLabel:setAnchorPoint(cc.p(0.5, 0.5))
	self.monsterLevelLabel:setPosition(cc.p(self.centerPoint.x - 64, self.centerPoint.y - 66))
	self.monsterLevelLabel:addTo(self, 1)
	self.monsterLevelLabel:setColor(cc.c3b(255, 251, 213))
	self.monsterLevelLabel:setGroupID(worldMapDefine.GROU_ID.group_text_monster)
end
function worldMapMonsterFiesta:addCacheBefore()
	self.monster:stopAllActions()
end
function worldMapMonsterFiesta:setBatchNodeGroupID(groupID)
	self.monster:setGroupID(groupID)
end
function worldMapMonsterFiesta:initInstanceData(monsterClassID, imgNameAngle, isFlipX, npcData)
	self.monsterClassID = monsterClassID
	self.imgName = worldMapDefine.getMonsterImageName(monsterClassID)
	self.imgNameAngle = imgNameAngle
	self.isFlipX = isFlipX
	self.monsterName = worldMapDefine.getMonsterName(monsterClassID)
	self.monsterLevel = worldMapDefine.getMonsterLevel(monsterClassID)
	self.instanceLevel = self.monsterLevel
	self.monsterNameLabel:setString(self.monsterName)
	self.monsterLevelLabel:setString(self.monsterLevel)
	local offsetX = SoraDGetTextLen(self.monsterNameLabel) * 0.5 + 25
	if not SoraDFIsRA() and self.monsterClassID == 3104 then
		offsetX = offsetX - 60
	end
	self.image_level:setPosition(cc.p(self.centerPoint.x - offsetX, self.centerPoint.y - 70))
	self.monsterLevelLabel:setPosition(cc.p(self.centerPoint.x - offsetX, self.centerPoint.y - 70))
	self.monster:setSpriteFrame(self.imgName .. "_dj_" .. "ws" .. "_01.png")
	self.monster:setFlippedX(self.isFlipX)
	self:updateData(npcData)
end
function worldMapMonsterFiesta:updateData(data)
	if not data then
		return
	end
	if data.isCanKill ~= nil then
		self.isCanKill = data.isCanKill
		if self.isCanKill then
			self.monsterLevelLabel:setColor(cc.c3b(255, 251, 213))
		else
			self.monsterLevelLabel:setColor(cc.c3b(250, 150, 25))
		end
	end
	if data.status then
		self.monsterState = data.status
	end
	if self.monsterState == gMapObjStateTypeDef.gMapObjStateTypeFree then
		self:doStandingAnimation()
	elseif self.monsterState == gMapObjStateTypeDef.gMapObjStateTypeHurtDie then
		self:doDieingAnimation()
	end
end
function worldMapMonsterFiesta:addFireEffect(fightTime, data)
	local facePoint = cc.p(0, 0)
	if data.fightingToPointX and data.fightingToPointY then
		facePoint = cc.p(data.fightingToPointX, data.fightingToPointY)
	end
	self:beginAttack(facePoint)
	_UPVALUE1_ = self
	self[1] = cca.delay(fightTime)
	self[2] = cca.callFunc(function()
		self:doStopAllActions()
	end)
	self[3] = cca.callFunc(function()
		self:doStopAllActions()
	end)
	local seq = cca.seq(self)
	self.monster:runAction(seq)
end
function worldMapMonsterFiesta:getMonsterClassID()
	return self.monsterClassID
end
function worldMapMonsterFiesta:beginAttack(facePoint)
	local worldMapView = SoraDCurrentSceneShowView("worldMapView")
	if worldMapView then
		facePoint = worldMapView:getPointWithTile(facePoint)
	end
	local pointX, pointY = self:getPosition()
	local beginPoint = cc.p(pointX, pointY)
	local endPoint = facePoint
	local _, fightingImgNameAngle, isFlipX = worldMapFunction.getMonsterImgAngel(beginPoint, endPoint)
	self.fightingImgNameAngle = fightingImgNameAngle
	self.fightingIsFlipX = isFlipX
	self.monster:setFlippedX(self.fightingIsFlipX)
	self.fightingFrames = display.newFrames(self.imgName .. "_gj_" .. self.fightingImgNameAngle .. "_0%d.png", 1, 8)
	self:doFightingAnimation()
	SoraDPlaySound("worldmap", 3)
end
function worldMapMonsterFiesta:doStandingAnimation()
	self.monster:stopAllActions()
	local frames = display.newFrames(self.imgName .. "_dj_" .. "ws" .. "_0%d.png", 1, 8)
	local animation = display.newAnimation(frames, 0.15)
	self.monster:playAnimationForever(animation)
	self.monster:setFlippedX(self.isFlipX)
end
function worldMapMonsterFiesta:doFightingAnimation()
	self.monster:stopAllActions()
	local animation = display.newAnimation(self.fightingFrames, 0.125)
	self.monster:playAnimationOnce(animation)
	local index = worldMapDefine.getBeginAnimationByName(self.imgName)
	local _ENV, actionsArray = self.imgName, self.imgName
	actionsArray[#actionsArray + 1] = cc.DelayTime:create(0.1 * index)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		self:addFightEffect()
	end)
	actionsArray[#actionsArray + 1] = cc.DelayTime:create(1.2 - 0.1 * index)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		self:doFightingAnimation()
	end)
	local actions = transition.sequence(actionsArray)
	self.monster:runAction(actions)
end
function worldMapMonsterFiesta:doDieingAnimation()
	self.monster:stopAllActions()
	local frames = display.newFrames(self.imgName .. "_sw_" .. "ws" .. "_0%d.png", 1, 8)
	local animation = display.newAnimation(frames, 0.125)
	self.monster:playAnimationOnce(animation, false, handler(self, self.finishedAfterDead), 0.0)
	self.monster:setFlippedX(self.fightingIsFlipX)
end
function worldMapMonsterFiesta:finishedAfterDead()
	local _ENV, actionsArray
	actionsArray[#actionsArray + 1] = cc.DelayTime:create(1.0)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_MAPINSTANCE"
		;(nil).instance = self
		SoraDSendMessage(nil)
	end)
	local actions = transition.sequence(actionsArray)
	self:runAction(actions)
end
function worldMapMonsterFiesta:addFightEffect()
	local effectSource = worldMapDefine.getEffectByNameAndDir(self.imgName, self.fightingImgNameAngle)
	if effectSource and next(effectSource) then
		local et_node = self:getChildByName("attackNode")
		if et_node then
			SoraDResetEffectNode(et_node)
		else
			local attackNode = SoraDCreateEffectNode(effectSource)
			attackNode:setName("attackNode")
			local scaleX = 1
			local moveY = 1
			if self.fightingIsFlipX then
				scaleX = -1
			end
			if self.fightingImgNameAngle == "ws" then
				moveY = -1
			end
			attackNode:setScaleX(scaleX)
			self:addChild(attackNode, 5)
			if self.imgName == "b" then
				attackNode:runAction(cca.moveBy(0.5, -50 * scaleX, 50 * moveY))
			end
		end
	end
end
function worldMapMonsterFiesta:onClickInstance(onShowView)
	self:playClickSound()
	local monsterClassID = self:getMonsterClassID()
	_ENV = nil
	;(nil).mapView = self
	local selectShowPanel = uiManager:show("worldMapMonsterInfo", nil).view
	selectShowPanel:setTilePoint(cc.p(self.tilePoint.x, self.tilePoint.y))
	selectShowPanel:initMonsterFiesta(self)
	selectShowPanel:upateInfoPanel(monsterClassID)
	return selectShowPanel, true
end
function worldMapMonsterFiesta:playClickSound()
	if gSoundDataList[self.imgName] then
		SoraDPlaySound("worldMapMonster", self.imgName)
	else
		SoraDPlaySound("worldmap", 5)
	end
end
return worldMapMonsterFiesta
