local instanceFactory = include("instanceFactory")
local worldMapBoss = class("worldMapBoss", function()
	local target = include("worldMapInstance").new("worldMapBoss")
	return target
end)
function worldMapBoss:ctor()
	self.bossClassID = nil
	self.imgName = "bhmt"
	self.leftLife = 0
	self.shield = 0
	self.imgNameAngle = nil
	self.isFlipX = nil
	self:_initUI()
	self:_initData()
end
function worldMapBoss:_initData()
	self.bossState = 1
	self.fightingFrames = nil
	self.fightingImgNameAngle = nil
	self.fightingIsFlipX = nil
	self.framesNumber = 8
	self.framesTimes = 0.15
	self.groupID = nil
end
function worldMapBoss:_initUI()
	self.bossImg = display.newSpriteNoChild("#" .. self.imgName .. "_dj_ws.png")
	self:addChild(self.bossImg, -1)
	self.bossImg:setScale(1.5)
	self.image_name = display.newSpriteNoChild("#frame_xlmz_daojishi.png")
	self.image_name:setScale(0.7)
	self.image_name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 93))
	self.image_name:addTo(self, 1)
	self.image_name:setGroupID(worldMapDefine.GROU_ID.group_name_monster)
	self.image_name:setVisible(false)
	_ENV = self.image_name
	self.image_name.UILabelType = 2
	self.image_name.text = ""
	self.image_name.size = 16
	self.nameLabel = SoraDCreateLabelNoChild(self.image_name)
	self.nameLabel:setColor(cc.c3b(82, 51, 21))
	self.nameLabel:setAnchorPoint(cc.p(0.5, 0.5))
	self.nameLabel:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 93))
	self.nameLabel:addTo(self, 1)
	self.nameLabel:setGroupID(worldMapDefine.GROU_ID.group_text_monster)
	self.image_level = display.newSpriteNoChild("#frame_YX_kapaidengji.png")
	self.image_level:setPosition(cc.p(self.centerPoint.x - 88, self.centerPoint.y - 69))
	self.image_level:addTo(self, 1)
	self.image_level:setGroupID(worldMapDefine.GROU_ID.group_level_monster)
	_ENV = self.image_level
	self.image_level.UILabelType = 2
	self.image_level.text = ""
	self.image_level.size = 14
	self.levelLabel = SoraDCreateLabelNoChild(self.image_level)
	self.levelLabel:setAnchorPoint(cc.p(0.5, 0.5))
	self.levelLabel:setPosition(cc.p(self.centerPoint.x - 89, self.centerPoint.y - 65))
	self.levelLabel:addTo(self, 1)
	self.levelLabel:setColor(cc.c3b(255, 251, 213))
	self.levelLabel:setGroupID(worldMapDefine.GROU_ID.group_text_monster)
	self.progressBar = SoraDCreatePanel("worldMapBossProgressBar")
	self.progressBar:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 70))
	self.progressBar:setAnchorPoint(cc.p(0.5, 0.5))
	self.progressBar:addTo(self, 1)
	self.progressBar:setVisible(false)
	self.progressBar:setGroupID(worldMapDefine.GROU_ID.group_progress_monster)
	self.progressBar:setGroupAuto(true)
	local refNode = display.newNode()
	refNode:addTo(self, 1)
	refNode:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 50))
	refNode:setVisible(false)
	self.refNode = refNode
	local image = display.newSpriteNoChild("#frame_sheer_black_01.png")
	image:addTo(refNode)
	image:setScale(0.5, 0.7)
	_ENV = image
	image.UILabelType = 2
	image.text = ""
	image.size = 16
	local label = SoraDCreateLabelNoChild(image)
	label:setColor(cc.c3b(255, 255, 255))
	label:setAnchorPoint(cc.p(0.5, 0.5))
	label:addTo(refNode)
	label:setGroupID(worldMapDefine.GROU_ID.group_text_monster)
	self.refLabel = label
end
function worldMapBoss:addCacheBefore()
	self:doStopAllActions()
	local et_node = self:getChildByName("attackNode")
	if et_node then
		et_node:removeFromParent()
	end
	self.refNode:setVisible(false)
end
function worldMapBoss:setBatchNodeGroupID(groupID)
	if self:checkIsEndlessTrialBoss() then
		groupID = worldMapDefine.GROU_ID.endlessTrialBatchNode
	end
	self.bossImg:setGroupID(groupID)
	self.groupID = groupID
end
function worldMapBoss:initInstanceData(bossClassID, imgNameAngle, isFlipX, bossData)
	print("==worldMapBoss:initInstanceData==", bossClassID)
	local hasHD = worldMapDefine.hasBossHdRes(bossClassID, bossData.level)
	self.hasHD = hasHD
	self.imgNameAngle = imgNameAngle
	self.isFlipX = isFlipX
	self.bossClassID = bossClassID
	self.leftLife = bossData.leftLife
	self.shield = bossData.shield
	if self.recalculateLeftLife then
		self:recalculateLeftLife()
	end
	self.isManuPlace = bossData.isManuPlace or false
	if bossData.leftTime and bossData.leftTime > serviceFunctions.systemTime() then
		self.leftTime = bossData.leftTime
	else
		self.leftTime = nil
	end
	self.bossData = worldMapDefine.getWorldBossShow(self.bossClassID, bossData.level)
	self.imgName = self.bossData.effects
	if self.bossData.frams then
		self.framesNumber = self.bossData.frams
	end
	if self.framesNumber == 8 then
		self.framesTimes = 0.15
	elseif self.bossClassID >= gBossType.windTowerBoss then
		self.framesTimes = 0.06666666666666667
	else
		self.framesTimes = 0.08333333333333333
	end
	self.bossName = i18n(self.bossData.name)
	self.bossLevel = bossData.level
	self.instanceLevel = self.bossLevel
	dump(bossData, "bossData====")
	if self.bossClassID == gBossType.gholdEmergenceBoss then
		self.nameLabel:setString(textParser.formatPlayerName(bossData.abbr, self.bossName))
	elseif self.bossClassID == gBossType.phoenixChallengeBoss then
		self.nameLabel:setString(textParser.formatPlayerName(bossData.abbr, self.bossName))
	else
		self.nameLabel:setString(self.bossName)
	end
	self.levelLabel:setString(self.bossLevel)
	self.settingId = bossData.settingId
	if self.hasHD then
		self.bossImg:setSpriteFrame(self.imgName .. "_dj_ws_01.png")
	else
		self.bossImg:setSpriteFrame(self.imgName .. "_dj_ws.png")
	end
	if self.bossClassID == gBossType.windTowerBoss then
		self.isFlipX = false
	end
	self.bossImg:setFlippedX(self.isFlipX)
	self:setScaleAndPositionY()
	self:updateData(bossData)
end
function worldMapBoss:getBossClassID()
	return self.bossClassID
end
function worldMapBoss:updateData(data)
	if not data then
		return
	end
	self.instanceData = data
	if data.leftLife then
		self.leftLife = data.leftLife
		if self.recalculateLeftLife then
			self:recalculateLeftLife()
		end
	end
	if data.shield ~= nil then
		self.shield = data.shield
	end
	if data.aid ~= nil then
		self.aid = data.aid
	end
	if data.status then
		self.bossState = data.status
	end
	if data.placeUid then
		self.placeUid = data.placeUid
	end
	if self.bossState == gMapObjStateTypeDef.gMapObjStateTypeFree then
		self:doStandingAnimation()
	elseif self.bossState == gMapObjStateTypeDef.gMapObjStateTypeHurtDie then
		self:doDieingAnimation()
	end
	self.recoverBeginTime = data.recoverBeginTime
	self:updateProcessBar()
end
function worldMapBoss:addFireEffect(fightTime, data)
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
	self.bossImg:runAction(seq)
end
function worldMapBoss:setScaleAndPositionY(...)
	local bossData = self.bossData
	self.bossImg:setScale(bossData.scale or 1.5)
	self.bossImg:setPositionY(bossData.offsety or 0)
end
function worldMapBoss:doStopAllActions(...)
	self.bossImg:stopAllActions()
	self.bossImg:setVisible(true)
	local attackEffectNode = self:getChildByName("attackEffectNode")
	if attackEffectNode then
		attackEffectNode:removeFromParent()
	end
end
function worldMapBoss:beginAttack(facePoint)
	local worldMapView = SoraDCurrentSceneShowView("worldMapView")
	if worldMapView then
		facePoint = worldMapView:getPointWithTile(facePoint)
	end
	local pointX, pointY = self:getPosition()
	local beginPoint = cc.p(pointX, pointY)
	local endPoint = facePoint
	local rotation, fightingImgNameAngle, isFlipX = worldMapFunction.getMonsterImgAngel(beginPoint, endPoint)
	self.fightingImgNameAngle = fightingImgNameAngle
	self.fightingIsFlipX = isFlipX
	self.bossImg:setFlippedX(self.fightingIsFlipX)
	if self.hasHD then
		if self.bossClassID == gBossType.iceDragonLostBoss then
			self.fightingFrames = display.newFrames(self.imgName .. "_gj_" .. self.fightingImgNameAngle .. "_%02d.png", 0, self.framesNumber + 1)
		elseif self.bossClassID == gBossType.phoenixChallengeBoss then
			self.fightingFrames = display.newFrames(self.imgName .. "_gj_ws_%02d.png", 1, 19)
		else
			self.fightingFrames = display.newFrames(self.imgName .. "_gj_" .. self.fightingImgNameAngle .. "_%02d.png", 1, self.framesNumber)
		end
	else
		self.bossImg:setSpriteFrame(self.imgName .. "_gj_" .. self.fightingImgNameAngle .. ".png")
	end
	self:doStopAllActions()
	self:doFightingAnimation()
	SoraDPlaySound("worldmap", 3)
end
function worldMapBoss:doStandingAnimation()
	self:doStopAllActions()
	if self.hasHD then
		local frames = display.newFrames(self.imgName .. "_dj_" .. "ws" .. "_%02d.png", 1, self.framesNumber)
		local animation = display.newAnimation(frames, self.framesTimes)
		self.bossImg:playAnimationForever(animation)
	else
		self.bossImg:setSpriteFrame(self.imgName .. "_dj_ws.png")
	end
	self.bossImg:setFlippedX(self.isFlipX)
end
function worldMapBoss:doFightingAnimation()
	local nodeName = worldMapDefine.getAttackEffectCsbName(self.imgName, self.fightingImgNameAngle)
	if nodeName then
		if self.hasHD then
			self.bossImg:setVisible(false)
			local nodeName = worldMapDefine.getAttackEffectCsbName(self.imgName, self.fightingImgNameAngle)
			_ENV = self.fightingImgNameAngle
			self.fightingImgNameAngle.nodeName = nodeName
			self.fightingImgNameAngle.groupID1 = instanceFactory.batchNode.attackEffectBatchNode
			self.fightingImgNameAngle.groupID2 = self.groupID
			self.fightingImgNameAngle.pos = cc.p(self.bossImg:getPositionX(), self.bossImg:getPositionY())
			self.fightingImgNameAngle.scale = self.bossImg:getScaleX()
			self.fightingImgNameAngle.isFlipX = self.fightingIsFlipX
			local node = worldMapDefine.createAttackEffectCsb(self.fightingImgNameAngle)
			node:addTo(self, 99)
			if self:checkIsEndlessTrialBoss() then
				SoraDMixtureGLONEByParent(node)
				node:setGroupID(self.groupID)
				node:setGroupAuto(true)
			else
				SoraDMixtureGLONEByParent(node)
			end
		end
		return
	end
	if self.hasHD then
		local animation = display.newAnimation(self.fightingFrames, self.framesTimes)
		self.bossImg:playAnimationOnce(animation, false, function()
			self:doFightingAnimation()
		end)
	end
	local index = worldMapDefine.getBeginAnimationByName(self.imgName)
	local _ENV, actionsArray = self.imgName, self.imgName
	actionsArray[#actionsArray + 1] = cc.DelayTime:create(0.1 * index)
	actionsArray[#actionsArray + 1] = cc.CallFunc:create(function()
		self:addFightEffect()
	end)
	local actions = transition.sequence(actionsArray)
	self.bossImg:runAction(actions)
end
function worldMapBoss:doDieingAnimation()
	self:doStopAllActions()
	if self.hasHD then
		local framesNumber = self.framesNumber
		local frames = display.newFrames(self.imgName .. "_sw_" .. "ws" .. "_%02d.png", 1, self.framesNumber)
		local animation = display.newAnimation(frames, self.framesTimes)
		self.bossImg:playAnimationOnce(animation, false, handler(self, self.finishedAfterDead), 0.0)
	else
		self.bossImg:setSpriteFrame(self.imgName .. "_sw_ws.png")
		self:finishedAfterDead()
	end
	self.bossImg:setFlippedX(self.fightingIsFlipX)
end
function worldMapBoss:finishedAfterDead()
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
function worldMapBoss:addFightEffect()
	local effectSource = worldMapDefine.getEffectByNameAndDir(self.imgName, self.fightingImgNameAngle)
	if effectSource and next(effectSource) then
		local et_node = self:getChildByName("attackNode")
		if et_node then
			SoraDResetEffectNode(et_node)
		else
			local attackNode = SoraDCreateEffectNode(effectSource)
			attackNode:setName("attackNode")
			local scaleX = 1
			if self.fightingIsFlipX then
				scaleX = -1
			end
			attackNode:setScaleX(scaleX)
			self:addChild(attackNode, 5)
		end
	end
end
function worldMapBoss:onClickInstance(onShowView)
	if self:checkIsEndlessTrialBoss() then
		return self:onClickEndlessTrialBoss(onShowView)
	end
	local gametop = gModuleMgr.getObject("gametop")
	local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	if (self:getBossClassID() == gBossType.heroBattleBoss1 or self:getBossClassID() == gBossType.heroBattleBoss2 or self:getBossClassID() == gBossType.wastelandBoss) and conquestWarCtrl:isPlayerConquestWarMigration() and lordInfoCtrl:getSourceKid() > 0 then
		SoraDShowMsgBox(i18n("common_text_3302"), i18n("common_text_204"))
		return
	end
	if self:getBossClassID() == gBossType.mirajBoss then
		if self:getPlaceUid() ~= gametop.playertop_:getPlayerID() then
			SoraDShowMsgTip(i18n("almirajChange_text16"))
			return
		end
		if not SoraDGetCtrl("allianceMgr"):hasJoinAlliance() then
			SoraDShowMsgTip(i18n("tips_place_noUnion"))
			return
		end
	end
	self:playClickSound()
	if self:getBossClassID() == gBossType.phoenixChallengeBoss then
		if not SoraDGetCtrl("allianceMgr"):hasJoinAlliance() then
			SoraDShowMsgTip(i18n("tips_place_noUnion"))
			return
		end
		if gametop.playertop_:getMapID() ~= worldMapDefine.currentMapKindomID or SoraDGetCtrl("allianceMgr"):getOwnAid() ~= self.aid then
			SoraDShowMsgTip(i18n("Phonex_Challenge_text_25"))
			return
		end
		return self:onShowWorldMapTip(onShowView)
	elseif self:getBossClassID() == gBossType.danateMeterialBoss then
		return self:onShowWorldMapTip(onShowView)
	else
		local selectShowPanel = uiManager:show("WorldMapBossView").view
		selectShowPanel:setTilePoint(cc.p(self.tilePoint.x, self.tilePoint.y))
		selectShowPanel:initData(self)
		return selectShowPanel, true
	end
end
function worldMapBoss:getInstanceOp()
	local gametop = gModuleMgr.getObject("gametop")
	self.isSelfKindom = gametop.playertop_:getMapID() == worldMapDefine.currentMapKindomID
	local _ENV, buttonTypeArray = gametop.playertop_:getMapID() == worldMapDefine.currentMapKindomID, gametop.playertop_:getMapID() == worldMapDefine.currentMapKindomID
	if self:getBossClassID() == gBossType.phoenixChallengeBoss then
		_ENV = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_activity_9001642_record
		table.insert(buttonTypeArray, nil)
		_ENV = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_activity_9001642_attack
		table.insert(buttonTypeArray, nil)
		_ENV = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_activity_9001642_rank
		table.insert(buttonTypeArray, nil)
	elseif self:getBossClassID() == gBossType.danateMeterialBoss then
		_ENV = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_9001684_attack
		table.insert(buttonTypeArray, nil)
		_ENV = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_9001684_rank
		table.insert(buttonTypeArray, nil)
	end
	return buttonTypeArray
end
function worldMapBoss:onClickTipButton(tipButtonType, tipButtonData, tipButtonExtra)
	dump(tipButtonType, "tipButtonType")
	if tipButtonType == worldMapDefine.worldMapTipButtonType_activity_9001642_record then
		uiManager:show("Activity_9001642_Harm")
		return true
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_activity_9001642_attack then
		if not SoraDGetCtrl("allianceMgr"):hasJoinAlliance() then
			SoraDShowMsgBox(i18n("common_text_583"), i18n("common_text_204"))
			return false
		end
		if SoraDEnoughTroops() then
			local dispatchPanel = uiManager:show("WorldDispatchArmyView")
			_ENV = i18n("common_text_204")
			i18n("common_text_204").toPoint = cc.p(self.tilePoint.x, self.tilePoint.y)
			i18n("common_text_204").dispatchType = worldMapDefine.worldMapTipButtonType_gongJi
			i18n("common_text_204").instanceID = self:getInstanceID()
			i18n("common_text_204").bossType = gBossType.phoenixChallengeBoss
			i18n("common_text_204").instanceType = self:getInstanceType()
			dispatchPanel:initData(i18n("common_text_204"))
		end
		return true
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_activity_9001642_rank then
		uiManager:show("Activity_9001642_Rank")
		return true
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_9001684_attack then
		if not (not worldMapDefine.isInWar() and SoraDGetCtrl("lordInfoCtrl"):isInSelfKid()) or not self.isSelfKindom then
			SoraDShowMsgTip(i18n("collect_activity_020"))
		else
			local activity_9001684_Ctrl = SoraDGetCtrl("activity_9001684_Ctrl")
			if activity_9001684_Ctrl:getBossChallengeTime() > 0 then
				if SoraDEnoughTroops() then
					local dispatchPanel = uiManager:show("WorldDispatchArmyView")
					_ENV = i18n("collect_activity_020")
					i18n("collect_activity_020").toPoint = cc.p(self.tilePoint.x, self.tilePoint.y)
					i18n("collect_activity_020").dispatchType = worldMapDefine.worldMapTipButtonType_gongJi
					i18n("collect_activity_020").instanceID = self:getInstanceID()
					i18n("collect_activity_020").bossType = gBossType.danateMeterialBoss
					i18n("collect_activity_020").instanceType = self:getInstanceType()
					dispatchPanel:initData(i18n("collect_activity_020"))
				end
			else
				SoraDShowMsgTip(i18n("collect_activity_021"))
			end
		end
		return true
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_9001684_rank then
		_ENV = i18n("collect_activity_021")
		i18n("collect_activity_021").rankType = 2
		uiManager:show("Activity_9001684_Rank", i18n("collect_activity_021"))
		return true
	end
	return false
end
function worldMapBoss:playClickSound()
	if gSoundDataList[self.imgName] then
		SoraDPlaySound("worldMapMonster", self.imgName)
	else
		SoraDPlaySound("worldmap", 5)
	end
end
function worldMapBoss:updateProcessBar()
	self.image_level:setVisible(true)
	self.levelLabel:setVisible(true)
	if self.bossClassID == gBossType.gholdEmergenceBoss then
		local remainTime = self.leftTime - serviceFunctions.systemTime()
		local removeAfterSec = worldMapDefine.getWorldBossRemoveAfterSec(self.bossClassID)
		self.progressBar:setTimeValue(remainTime, removeAfterSec)
		self.image_level:setPositionX(self.centerPoint.x - 102)
		self.levelLabel:setPositionX(self.centerPoint.x - 103)
	else
		if self.shield and self.shield > 0 then
			self.progressBar:setShieldValue(self.shield, worldMapDefine.getWorldBossShield(self.bossClassID, self.bossLevel))
			self.refNode:setPositionY(self.centerPoint.y - 25)
		elseif self.leftLife and 0 < self.leftLife then
			self.progressBar:setPercent(self.leftLife)
			self.refNode:setPositionY(self.centerPoint.y - 50)
			if self.bossClassID == gBossType.phoenixChallengeBoss then
				self.progressBar:setVisible(false)
				self.refNode:setPositionY(self.centerPoint.y - 50)
				self.image_name:setVisible(true)
				self.nameLabel:setColor(cc.c3b(240, 230, 210))
				self.nameLabel:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 65))
				self.image_name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 65))
			end
		else
			self.progressBar:setVisible(false)
			self.refNode:setPositionY(self.centerPoint.y - 50)
		end
		self.image_level:setPositionX(self.shield and self.shield > 0 and self.centerPoint.x - 102 or self.centerPoint.x - 88)
		self.levelLabel:setPositionX(self.shield and self.shield > 0 and self.centerPoint.x - 103 or self.centerPoint.x - 89)
		if self.bossClassID == gBossType.danateMeterialBoss then
			self.image_level:setVisible(false)
			self.levelLabel:setVisible(false)
		end
	end
	self.progressBar:setReleaseTime(self:getReleaseLeftTime())
end
function worldMapBoss:checkIsEndlessTrialBoss(...)
	_ENV = nil
	;(nil)[gBossType.endlessTrialBoss1] = true
	;(nil)[gBossType.endlessTrialBoss2] = true
	;(nil)[gBossType.endlessTrialBoss3] = true
	;(nil)[gBossType.endlessTrialBoss4] = true
	;(nil)[gBossType.endlessTrialBoss5] = true
	;(nil)[gBossType.endlessTrialBoss6] = true
	;(nil)[gBossType.endlessTrialBoss7] = true
	local (nil)[gBossType.endlessTrialBoss8], classTab = true, nil
	return classTab[self:getBossClassID()]
end
function worldMapBoss:onClickEndlessTrialBoss(onShowView)
	if worldMapDefine.isInKingdomBattle() then
		SoraDShowMsgTip(i18n("common_text_3302"))
		return
	end
	self:playClickSound()
	local selectShowPanel = uiManager:show("WorldMapBossView").view
	selectShowPanel:setTilePoint(cc.p(self.tilePoint.x, self.tilePoint.y))
	selectShowPanel:initData(self)
	return selectShowPanel, true
end
function worldMapBoss:setMassRef(ref)
	if ref and next(ref) then
		self.refNode:setVisible(true)
		if worldMapDefine.isWorldBossCanAttackAlone(self:getBossClassID(), self.bossLevel) then
			_ENV = nil
			;(nil).num = self:getRefNum(ref)
			self.refLabel:setString(i18n("lost_ruins_text_26", nil))
		else
			_ENV = i18n("lost_ruins_text_26", nil)
			i18n("lost_ruins_text_26", nil).num = self:getRefNum(ref)
			self.refLabel:setString(i18n("AncienTreasure_text_71", i18n("lost_ruins_text_26", nil)))
		end
		if self.shield and self.shield > 0 then
			self.refNode:setPositionY(self.centerPoint.y - 25)
		else
			self.refNode:setPositionY(self.centerPoint.y - 50)
		end
	else
		self.refNode:setVisible(false)
	end
end
function worldMapBoss:getReleaseLeftTime()
	if not self.recoverBeginTime then
		return 0
	end
	local releaseTime = SoraDGetCtrl("wastelandCtrl"):getBossConfigByLv(self.bossLevel).release
	return self.recoverBeginTime + releaseTime - serviceFunctions.systemTime()
end
function worldMapBoss:getRefNum(ref)
	local num = 0
	for _, v in pairs(ref) do
		num = num + table.nums(v)
	end
	return num
end
function worldMapBoss:getPlaceUid()
	return self.placeUid
end
function worldMapBoss:getSettingId(...)
	return self.settingId
end
function worldMapBoss:getInstanceData(...)
	return self.instanceData
end
return worldMapBoss
