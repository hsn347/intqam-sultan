local instanceFactory = include("instanceFactory")
local worldMapMonster = class("worldMapMonster", function()
	local target = include("worldMapInstance").new("worldMapMonster")
	return target
end)
function worldMapMonster:ctor()
	self.monsterClassID = nil
	self.imgName = nil
	self.imgNameAngle = nil
	self.isFlipX = nil
	self:_initUI()
	self:_initData()
end
function worldMapMonster:_initData()
	self.monsterState = 1
	self.isCanKill = false
	self.fightingFrames = nil
	self.fightingImgNameAngle = nil
	self.fightingIsFlipX = nil
	self.framesNumber = 8
	self.framesTimes = 0.15
	self.groupID = nil
end
function worldMapMonster:_initUI()
	self.monster = display.newSpriteNoChild("#anbs_dj_ws_01.png")
	self:addChild(self.monster, -1)
	self.monsterNameBg = display.newSpriteNoChild("#frame_sheer_black_01.png")
	self.monsterNameBg:setOpacity(178.5)
	self.monsterNameBg:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y - 70))
	self.monsterNameBg:setScaleX(0.6)
	self.monsterNameBg:addTo(self, 0)
	self.monsterNameBg:setVisible(false)
	_ENV = self.monsterNameBg
	self.monsterNameBg.UILabelType = 2
	self.monsterNameBg.text = ""
	self.monsterNameBg.size = 16
	self.monsterNameLabel = SoraDCreateLabelNoChild(self.monsterNameBg)
	self.monsterNameLabel:setColor(cc.c3b(82, 51, 21))
	self.monsterNameLabel:setAnchorPoint(cc.p(0.5, 0.5))
	self.monsterNameLabel:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 70))
	self.monsterNameLabel:addTo(self, 1)
	self.monsterNameLabel:setGroupID(worldMapDefine.GROU_ID.group_text_monster)
	self.campIcon = display.newSpriteNoChild("#frame_zynt_shuxing01.png")
	self.campIcon:setPosition(cc.p(self.centerPoint.x + 70, self.centerPoint.y - 70))
	self.campIcon:setScale(0.6)
	self.campIcon:addTo(self, 1)
	self.campIcon:setVisible(false)
	self.campIcon:setGroupID(worldMapDefine.GROU_ID.group_camp_icon)
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
	self.monsterLevelLabel:setColor(cc.c3b(255, 251, 213))
	self.monsterLevelLabel:setPosition(cc.p(self.centerPoint.x - 64, self.centerPoint.y - 66))
	self.monsterLevelLabel:addTo(self, 1)
	self.monsterLevelLabel:setGroupID(worldMapDefine.GROU_ID.group_text_monster)
end
function worldMapMonster:addCacheBefore()
	self:doStopAllActions()
	if self.imgName == "mny" then
		if self:getChildByName("sp_mny") then
			self:removeChildByName("sp_mny", true)
		end
	elseif self.imgName == "jsmny" then
		if self:getChildByName("sp_jsmny") then
			self:removeChildByName("sp_jsmny", true)
		end
	else
		local et_node = self:getChildByName("attackNode")
		if et_node then
			self:removeChildByName("attackNode", true)
		end
	end
end
function worldMapMonster:setBatchNodeGroupID(groupID)
	self.monster:setGroupID(groupID)
	self.groupID = groupID
end
function worldMapMonster:initInstanceData(monsterClassID, imgNameAngle, isFlipX, npcData)
	self.monsterClassID = monsterClassID
	self.imgName = worldMapDefine.getMonsterImageName(monsterClassID)
	self.imgNameAngle = imgNameAngle
	self.isFlipX = isFlipX
	self.isWastelandMonster = self:checkIsWastelandMonster()
	if self.imgName == "falake" or self.imgName == "shuangtougou" or self.imgName == "26sjbBoss" then
		self.framesNumber = 24
		self.framesTimes = 0.05
	end
	self.monsterName = worldMapDefine.getMonsterName(monsterClassID)
	self.monsterLevel = worldMapDefine.getMonsterLevel(monsterClassID)
	self.instanceLevel = self.monsterLevel
	self:refreshNameLabel(npcData)
	self.monsterLevelLabel:setString(self.monsterLevel)
	if self.isWastelandMonster then
		self.monsterLevelLabel:setVisible(false)
		self.image_level:setSpriteFrame("icon_hhzz_guaiwu.png")
	else
		self.monsterLevelLabel:setVisible(true)
		self.image_level:setSpriteFrame("frame_YX_kapaidengji.png")
	end
	self.monster:setSpriteFrame(self.imgName .. "_dj_" .. "ws" .. "_01.png")
	self.monster:setFlippedX(self.isFlipX)
	self:updateData(npcData)
end
function worldMapMonster:updateData(data)
	if not data then
		return
	end
	self.npcData = data
	if data.isCanKill ~= nil then
		local worldMapWarDef = include("worldMapWarDef")
		self.isCanKill = data.isCanKill or worldMapWarDef.isMonsterCanKill()
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
	self:refreshNameLabel(data)
end
function worldMapMonster:refreshNameLabel(data)
	if worldMapDefine.isRoaringFlameKingdomID() then
		local camp = data.camp
		if camp then
			local roaringFlameWarRead = include("roaringFlameWarRead")
			local campName = roaringFlameWarRead.getCampName(camp)
			local nameStr = string.format("%s[%s]", self.monsterName, campName)
			self.monsterNameLabel:setString(nameStr)
			return
		end
	end
	if data.lifeCount and self.isWastelandMonster then
		self.lifeCount = data.lifeCount
		self.monsterNameLabel:setString(string.format("x%d", data.lifeCount))
	else
		self.monsterNameLabel:setString(self.monsterName)
	end
	local offsetX = SoraDGetTextLen(self.monsterNameLabel) * 0.5 + 25
	self.image_level:setPosition(cc.p(self.centerPoint.x - offsetX, self.centerPoint.y - 70))
	self.monsterLevelLabel:setPosition(cc.p(self.centerPoint.x - offsetX, self.centerPoint.y - 66))
	if self.imgName == "26sjbBoss" then
		self.monster:setPositionY(30)
		self.monsterNameBg:setVisible(true)
		self.monsterNameLabel:setColor(cc.c3b(240, 230, 210))
		self.campIcon:setVisible(true)
		local activity_9001737_Read = include("activity_9001737_Read")
		local cfg = activity_9001737_Read.getCampCfgByCampType(data.subMapType or 1)
		self.campIcon:setSpriteFrame(cfg.campIcon)
		local offsetX = SoraDGetTextLen(self.monsterNameLabel) * 0.5
		self.campIcon:setPositionX(self.centerPoint.x + offsetX + 40)
	else
		self.monster:setPositionY(0)
		self.monsterNameBg:setVisible(false)
		self.monsterNameLabel:setColor(cc.c3b(82, 51, 21))
		self.campIcon:setVisible(false)
	end
end
function worldMapMonster:addFireEffect(fightTime, data)
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
function worldMapMonster:getMonsterClassID()
	return self.monsterClassID
end
function worldMapMonster:doStopAllActions(...)
	self.monster:stopAllActions()
	self.monster:setVisible(true)
	local attackEffectNode = self:getChildByName("attackEffectNode")
	if attackEffectNode then
		attackEffectNode:removeFromParent()
	end
end
function worldMapMonster:beginAttack(facePoint)
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
	self.fightingFrameName = self.imgName .. "_gj_" .. self.fightingImgNameAngle .. "_%.2d.png"
	self:doStopAllActions()
	self:doFightingAnimation()
	SoraDPlaySound("worldmap", 3)
end
function worldMapMonster:doStandingAnimation()
	self:doStopAllActions()
	local frameName = self.imgName .. "_dj_" .. "ws" .. "_%.2d.png"
	local animation = display.getAnimationCache(frameName)
	if animation == nil then
		animation = display.newAnimationEx(frameName, 1, self.framesNumber, self.framesTimes)
		gAnimationCache[frameName] = true
		display.setAnimationCache(frameName, animation)
	end
	self.monster:playAnimationForever(animation)
	self.monster:setFlippedX(self.isFlipX)
end
function worldMapMonster:doFightingAnimation()
	local nodeName = worldMapDefine.getAttackEffectCsbName(self.imgName, self.fightingImgNameAngle)
	if nodeName then
		self.monster:setVisible(false)
		local nodeName = worldMapDefine.getAttackEffectCsbName(self.imgName, self.fightingImgNameAngle)
		_ENV = self.fightingImgNameAngle
		self.fightingImgNameAngle.nodeName = nodeName
		self.fightingImgNameAngle.groupID1 = instanceFactory.batchNode.attackEffectBatchNode
		self.fightingImgNameAngle.groupID2 = self.groupID
		self.fightingImgNameAngle.pos = cc.p(self.monster:getPositionX(), self.monster:getPositionY())
		self.fightingImgNameAngle.scale = self.monster:getScaleX()
		self.fightingImgNameAngle.isFlipX = self.fightingIsFlipX
		local node = worldMapDefine.createAttackEffectCsb(self.fightingImgNameAngle)
		node:addTo(self, 99)
		return
	end
	local animation = display.newAnimationEx(self.fightingFrameName, 1, self.framesNumber, self.framesTimes)
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
function worldMapMonster:doDieingAnimation()
	self:doStopAllActions()
	local animation = display.newAnimationEx(self.imgName .. "_sw_" .. "ws" .. "_%.2d.png", 1, self.framesNumber, self.framesTimes)
	self.monster:playAnimationOnce(animation, false, handler(self, self.finishedAfterDead), 0.0)
	self.monster:setFlippedX(self.fightingIsFlipX)
end
function worldMapMonster:finishedAfterDead()
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
function worldMapMonster:addFightEffect()
	local effectSource = worldMapDefine.getEffectByNameAndDir(self.imgName, self.fightingImgNameAngle)
	if effectSource and next(effectSource) then
		if self.imgName == "mny" then
			if self:getChildByName("sp_mny") then
				self:removeChildByName("sp_mny", true)
			end
			local sp_mny = display.newSprite("#et_mny_attack_" .. self.fightingImgNameAngle .. "_01.png")
			sp_mny:setPosition(cc.p(effectSource.x, effectSource.y))
			sp_mny:setName("sp_mny")
			sp_mny:setFlippedX(self.fightingIsFlipX)
			self:addChild(sp_mny, 5)
			local frames = display.newFrames("et_mny_attack_" .. self.fightingImgNameAngle .. "_%.2d.png", 1, 2)
			local animation = display.newAnimation(frames, 0.15)
			sp_mny:playAnimationOnce(animation, 0.6)
		elseif self.imgName == "jsmny" then
			if self:getChildByName("sp_jsmny") then
				self:removeChildByName("sp_jsmny", true)
			end
			local sp_jsmny = display.newSprite("#dh_jsmny_01.png")
			if self.fightingIsFlipX then
				sp_jsmny:setPosition(cc.p(-effectSource.x, effectSource.y))
				sp_jsmny:setRotation(-effectSource.rotation)
			else
				sp_jsmny:setPosition(cc.p(effectSource.x, effectSource.y))
				sp_jsmny:setRotation(effectSource.rotation)
			end
			sp_jsmny:setName("sp_jsmny")
			sp_jsmny:setFlippedX(self.fightingIsFlipX)
			self:addChild(sp_jsmny, 5)
			local frames = display.newFrames("dh_jsmny_%.2d.png", 1, 5)
			local animation = display.newAnimation(frames, 0.8 / #frames)
			sp_jsmny:playAnimationOnce(animation, 0.0)
		else
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
end
function worldMapMonster:bottomApertureEffect()
	_ENV, _ENV = nil, nil
	_ENV, (nil).plist = nil, "et_zhanhun_display_01.plist"
	;(nil).x = 3.32
	;(nil).scale, (nil).y = nil, 2.4
	;(nil)[1], (nil).rotate = nil, 3.17
	local param
	local parNode = SoraDCreateEffectNode(param)
	parNode:setPositionY(-self.monster:getContentSize().height / 2 + 50)
	parNode:addTo(self, 2)
end
function worldMapMonster:onClickInstance(onShowView)
	self:playClickSound()
	if self.isWastelandMonster and worldMapDefine.isInKingdomBattle() then
		SoraDShowMsgBox(i18n("common_text_3302"), i18n("common_text_204"))
		return
	end
	if worldMapDefine.isInNebula() then
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		local myTeamInfo = nebulaActivityCtrl:getMyTeamInfo()
		if myTeamInfo:getIsSuperTeam() then
			SoraDShowMsgTip(i18n("common_text_4782"))
			return
		end
	end
	if worldMapDefine.isInRoaringFlame() then
		local camp = self.npcData.camp
		local roaringFlameWarRead = include("roaringFlameWarRead")
		local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
		local selfCamp = roaringFlameWarCtrl:getSelfCamp()
		if camp ~= selfCamp then
			local subType = roaringFlameWarRead.getBuildSubType(self.npcData.buildId)
			local buildName = roaringFlameWarRead.getBuildName(subType)
			_ENV = i18n("common_text_4782")
			i18n("common_text_4782").city = buildName
			i18n("common_text_4782").monster = self.monsterName
			SoraDShowMsgTip(i18n("flames_dunes_text241", i18n("common_text_4782")))
			return
		end
	end
	local monsterClassID = self:getMonsterClassID()
	_ENV = roaringFlameWarRead.getBuildSubType(self.npcData.buildId)
	roaringFlameWarRead.getBuildSubType(self.npcData.buildId).mapView = self
	local selectShowPanel = uiManager:show("worldMapMonsterInfo", (roaringFlameWarRead.getBuildSubType(self.npcData.buildId))).view
	selectShowPanel:setTilePoint(cc.p(self.tilePoint.x, self.tilePoint.y))
	selectShowPanel:initData(self)
	selectShowPanel:upateInfoPanel(monsterClassID)
	if self.monsterLevel == 1 then
		local guideCtrl = SoraDGetCtrl("guideCtrl")
		if guideCtrl:isGuideNotCompleted(gGuideModule.WORLD_MONSTER) and guideCtrl:updateGuideModule(gGuideModule.WORLD_MONSTER) ~= nil then
			selectShowPanel:setVisible(false)
		end
	end
	return selectShowPanel, true
end
function worldMapMonster:playClickSound()
	if gSoundDataList[self.imgName] then
		SoraDPlaySound("worldMapMonster", self.imgName)
	else
		SoraDPlaySound("worldmap", 5)
	end
end
function worldMapMonster:checkIsWastelandMonster(monsterClassID)
	monsterClassID = monsterClassID or self:getMonsterClassID()
	return worldMapDefine.checkIsWastelandMonster(monsterClassID)
end
function worldMapMonster:getLifeCount(...)
	return self.lifeCount or 0
end
function worldMapMonster:getBelongInstanceID(...)
	return self.npcData.bossId
end
return worldMapMonster
