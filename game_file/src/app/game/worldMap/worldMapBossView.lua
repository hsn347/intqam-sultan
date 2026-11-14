local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local publicRead = include("publicRead")
local worldMapBossView = class("worldMapBossView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapBossView")
	end
	return target
end)
function worldMapBossView:ctor()
	self.boss = nil
	self.bossState = nil
	self.tilePoint = nil
	self.isSelfKindom = gametop.playertop_:getMapID() == worldMapDefine.currentMapKindomID
	self.massButton = SoraDGetChildByName(self, "Button_mass")
	if self.massButton then
		self.massButton:setTitleText(i18n("common_text_2079"))
		SoraDAutoSizeButtonTextByContent(self.massButton)
		self.massButton:addTouchEventListener(function(ref, type)
			self:massButtonCallFun(ref, type)
		end)
		self.massButton:setVisible(false)
		if not self.isSelfKindom then
			self.massButton:setEnabled(false)
			self.massButton:setBright(false)
		end
	end
	self.rewards, gametop, self.text_Name = SoraDGetChildByName(self, "Text_bossName"), SoraDGetChildByName(self, "Text_bossName"), SoraDGetChildByName(self, "Text_bossName")
	for i = 1, 4 do
		self.rewards[i] = SoraDGetChildByName(self, "image_kuang_" .. i)
		local posx = SoraDFSign(350 - 140 * i)
		self.rewards[i]:setPositionX(posx)
		SoraDGetChildByName(self, "Text_item_name_" .. i):setPositionX(posx)
	end
	self.progress_blood = SoraDGetChildByName(self, "LoadingBar_progress")
	self.text_progress = SoraDGetChildByName(self, "Text_progress")
	local rewardItemName4 = SoraDGetChildByName(self, "Text_item_name_4")
	rewardItemName4:setString(i18n("common_text_486"))
	self.text_talk = SoraDGetChildByName(self, "Text_desInfo")
	self.text_Info = SoraDGetChildByName(self, "Text_info")
	if self.text_Info then
		self.text_Info:setVisible(false)
	end
	self.imgBoss = SoraDGetChildByName(self, "Image_boss")
	local randomInfoLabel = SoraDGetChildByName(self, "Text_random")
	randomInfoLabel:setString(i18n("common_text_488"))
	self.warningLabel = SoraDGetChildByName(self, "Text_warning")
	self.textHeroBossTip = SoraDGetChildByName(self, "Text_heroBoss_tip")
	self.textHeroBossTip:setVisible(false)
	SoraDSetTextWidthHeight(self.textHeroBossTip, cc.size(570, 40))
	self.txtTime = SoraDGetChildByName(self, "Text_time")
	self.txtTime:setVisible(false)
	self.hourglass = SoraDGetChildByName(self, "icon_hourglass_3")
	self.hourglass:setVisible(false)
	local Node_kk = SoraDGetChildByName(self, "Node_kk")
	local Image_1 = SoraDGetChildByName(Node_kk, "Image_1")
	Image_1:setCapInsets(cc.rect(66, 20, 68, 10))
end
function worldMapBossView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_REQUEST_OBJECT_INFO", handler(self, self.serverMessage_RequestMapInstaceInfo))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_MONSTERSEARCH_DATAARRIVE", handler(self, self.msgBackData))
end
function worldMapBossView:initData(mapInstance)
	self.boss = mapInstance
	self.leftLife = self.boss.leftLife
	self.shield = self.boss.shield
	self.text_Name:setString(self.boss.bossName .. " LV." .. self.boss.bossLevel)
	dump(self.boss.bossData, "self.boss")
	local bossClassID = self.boss:getBossClassID()
	self.bossData = worldMapDefine.getWorldBossShow(bossClassID, self.boss.bossLevel)
	if bossClassID == gBossType.seaInvadeBoss2 then
		self.imgBoss:setAnchorPoint(cc.p(0, 0))
		self.imgBoss:setPositionX(-320)
	elseif bossClassID == gBossType.baboonBoss then
		self.imgBoss:setPositionX(-70)
	elseif bossClassID == gBossType.snowWolfLostBoss then
		self.imgBoss:setPositionX(-78)
	end
	self.imgBoss:setSpriteFrame(self.bossData.image)
	local sourceKid = lordInfoCtrl:getLordInfo().base.sourceKid
	self.massButton:setVisible(true)
	local reward = worldMapDefine.getWorldBossReward(bossClassID, self.boss.bossLevel)
	if bossClassID == gBossType.sweetMeatRobber then
		local dessertThiefRead = include("dessertThiefRead")
		reward = dessertThiefRead.getWorldBossReward(self.boss.bossLevel)
	end
	if reward then
		for i = 1, 3 do
			SoraDGetChildByName(self.rewards[i], "Sprite_item"):setSpriteFrame(publicRead.getIcon(reward[i]))
			SoraDGetChildByName(self, "Text_item_name_" .. i):setString(publicRead.getName(reward[i]))
			local btnItem = SoraDGetChildByName(self.rewards[i], "Button_Item")
			if btnItem then
				btnItem = include("commonBtnInstance").new(btnItem)
				btnItem:setItemInfo(self, reward[i], 1)
			end
		end
	end
	if self.shield and self.shield > 0 then
		self.progress_blood:loadTexture("frame_wjpj_jdt.png", ccui.TextureResType.plistType)
		local shieldMax = worldMapDefine.getWorldBossShield(bossClassID, self.boss.bossLevel)
		self.progress_blood:setPercent(self.shield * 100 / shieldMax)
		_ENV = btnItem.setItemInfo
		btnItem.setItemInfo.num1 = self.shield
		btnItem.setItemInfo.num2 = shieldMax
		self.text_progress:setString(i18n("Dessert_Thief_25", btnItem.setItemInfo))
	else
		self.progress_blood:loadTexture("progressbar_01_red.png", ccui.TextureResType.plistType)
		self.progress_blood:setPercent(self.leftLife)
		self.text_progress:setString(SoraDFValueSuit(self.leftLife, "%"))
		self:setReleaseTime(self.boss:getReleaseLeftTime())
		local fade = math.max(self.leftLife / 100, 0.01)
		local delay = math.max(self.leftLife / 200, 0.1)
		_ENV = self.boss:getReleaseLeftTime()
		self.boss:getReleaseLeftTime().fadeIn = fade
		self.boss:getReleaseLeftTime().fadeOut = fade
		self.boss:getReleaseLeftTime().delay = delay
		self.boss:getReleaseLeftTime().beginOpacity = 0.5
		self.boss:getReleaseLeftTime().endOpacity = 1
		SoraDFadeINOUT(self.progress_blood, self.boss:getReleaseLeftTime())
	end
	if self.boss.leftTime then
		self:beginTime(self.boss.leftTime)
	else
		self:endTime(false)
	end
	if bossClassID == gBossType.heroBattleBoss1 then
		self.textHeroBossTip:setVisible(true)
		_ENV = self.boss:getReleaseLeftTime()
		self.boss:getReleaseLeftTime().BossName = self.boss.bossName
		self.boss:getReleaseLeftTime().num = HEROBOSS_SINGLE_SCORE
		self.textHeroBossTip:setString(i18n("herobattle_text_07", self.boss:getReleaseLeftTime()))
		self.text_Name:setString(self.boss.bossName)
	elseif bossClassID == gBossType.baboonBoss then
		self.text_talk:setString(i18n("artifact_befall_text_04"))
	elseif bossClassID == gBossType.heroBattleBoss2 then
		self.textHeroBossTip:setVisible(true)
		_ENV = i18n("artifact_befall_text_04")
		i18n("artifact_befall_text_04").BossName = self.boss.bossName
		i18n("artifact_befall_text_04").num = HEROBOSS_GROUP_SCORE
		self.textHeroBossTip:setString(i18n("herobattle_text_07", i18n("artifact_befall_text_04")))
		self.text_Name:setString(self.boss.bossName)
	elseif bossClassID == gBossType.seaInvadeBoss or bossClassID == gBossType.seaInvadeBoss2 or bossClassID == gBossType.snowWolfLostBoss or bossClassID == gBossType.iceDragonLostBoss or bossClassID == gBossType.legendOfPegasusBoss then
		if bossClassID == gBossType.seaInvadeBoss then
			self.text_talk:setString(i18n("Npc_talk_ylcz_01"))
		elseif bossClassID == gBossType.seaInvadeBoss2 then
			self.text_talk:setString(i18n("Npc_talk_bztsb_02"))
		end
		if self.boss:getBossClassID() == gBossType.snowWolfLostBoss or self.boss:getBossClassID() == gBossType.iceDragonLostBoss or self.boss:getBossClassID() == gBossType.legendOfPegasusBoss then
			self.text_Name:setString(self.boss.bossName)
		end
		if worldMapDefine.isInKingdomBattle() then
			self.massButton:setEnabled(true)
			self.massButton:setBright(true)
			self.massButton:addTouchEventListener(function(ref, type)
				if type == ccui.TouchEventType.ended then
					SoraDPlaySound()
					SoraDShowMsgTip(i18n("common_text_3302"))
					self:close(ref, type)
				end
			end)
		end
	elseif worldMapDefine.isWorldBossCanAttackAlone(bossClassID, 1) and bossClassID ~= gBossType.fireDragon1 then
		self.text_talk:setString(i18n("npc_text_06"))
		self.attackButton = self.massButton:clone()
		self.attackButton:addTo(self.massButton:getParent())
		self.attackButton:setPosition(SoraDFPosX(150, 0), self.massButton:getPositionY())
		self.massButton:setPositionX(SoraDFPosX(-150, 0))
		self.attackButton:loadTextureNormal("btn_yellow_normal_01.png", ccui.TextureResType.plistType)
		self.attackButton:setTitleText(i18n("common_text_008"))
		self.attackButton:addTouchEventListener(handler(self, self.atttackButtonCallFun))
		SoraDAutoSizeButtonText(self.attackButton)
		self.attackButton:setBright(self.massButton:isBright())
	elseif bossClassID == gBossType.huntFairBoss and 0 < sourceKid then
		self.massButton:setBright(false)
	elseif self.boss:getBossClassID() == gBossType.windTowerBoss then
		self.text_talk:setString(i18n("windActive_text_16"))
	end
	if bossClassID == gBossType.monsterInvasionBoss then
		self.massButton:setVisible(false)
		self.attackButton:setPositionX(0)
	end
	if bossClassID == gBossType.huntFairBoss then
		self.text_talk:setString(i18n("Npc_talk_snowman_leader_01"))
	end
	if bossClassID == gBossType.mirajBoss then
		self.massButton:setVisible(false)
		self.attackButton:setPositionX(0)
		self.warningLabel:setVisible(false)
		_ENV = i18n("Npc_talk_snowman_leader_01")
		_ENV = i18n("Npc_talk_snowman_leader_01")
		i18n("Npc_talk_snowman_leader_01").abbr = allianceMgr:getAllianceProperty("name")
		i18n("Npc_talk_snowman_leader_01").name = lordInfoCtrl:getBaseInfo().nickName
		i18n("Npc_talk_snowman_leader_01").name = i18n("common_text_186", i18n("Npc_talk_snowman_leader_01"))
		self.text_talk:setString(i18n("almirajChange_text17", i18n("Npc_talk_snowman_leader_01")))
	end
	if bossClassID == gBossType.fireDragon1 or bossClassID == gBossType.fireDragon2 then
		local physical = worldMapDefine.getWorldBossStamina(bossClassID, 1)
		_ENV = i18n("almirajChange_text17", i18n("Npc_talk_snowman_leader_01"))
		i18n("almirajChange_text17", i18n("Npc_talk_snowman_leader_01")).num = physical
		self.warningLabel:setString(i18n("fierydragon_text_9", i18n("almirajChange_text17", i18n("Npc_talk_snowman_leader_01"))))
	elseif bossClassID == gBossType.monsterInvasionBoss then
		local physical = worldMapDefine.getWorldBossStamina(bossClassID, 1)
		_ENV = i18n("fierydragon_text_9", i18n("almirajChange_text17", i18n("Npc_talk_snowman_leader_01")))
		i18n("fierydragon_text_9", i18n("almirajChange_text17", i18n("Npc_talk_snowman_leader_01"))).var = physical
		self.warningLabel:setString(i18n("wasteland_text_013", i18n("fierydragon_text_9", i18n("almirajChange_text17", i18n("Npc_talk_snowman_leader_01")))))
	elseif bossClassID == gBossType.sweetMeatRobber then
		local physical = worldMapDefine.getWorldBossStamina(bossClassID, 1)
		_ENV = i18n("wasteland_text_013", i18n("fierydragon_text_9", i18n("almirajChange_text17", i18n("Npc_talk_snowman_leader_01"))))
		i18n("wasteland_text_013", i18n("fierydragon_text_9", i18n("almirajChange_text17", i18n("Npc_talk_snowman_leader_01")))).num = physical
		self.warningLabel:setString(i18n("common_text_2081", i18n("wasteland_text_013", i18n("fierydragon_text_9", i18n("almirajChange_text17", i18n("Npc_talk_snowman_leader_01"))))))
	else
		local physical = worldMapDefine.isInRemains() and 1 or 20
		_ENV = i18n("common_text_2081", i18n("wasteland_text_013", i18n("fierydragon_text_9", i18n("almirajChange_text17", i18n("Npc_talk_snowman_leader_01")))))
		i18n("common_text_2081", i18n("wasteland_text_013", i18n("fierydragon_text_9", i18n("almirajChange_text17", i18n("Npc_talk_snowman_leader_01"))))).num = physical
		self.warningLabel:setString(i18n("common_text_2081", i18n("common_text_2081", i18n("wasteland_text_013", i18n("fierydragon_text_9", i18n("almirajChange_text17", i18n("Npc_talk_snowman_leader_01")))))))
	end
	if bossClassID == gBossType.wastelandBoss then
		self.text_talk:setString(i18n("wasteland_text_019"))
		if self.isSelfKindom then
			self:refreshWastelandBoss()
		end
	end
end
function worldMapBossView:serverMessage_RequestMapInstaceInfo(target, data)
	if not data.data then
		return
	end
end
function worldMapBossView:setTilePoint(tilePoint)
	self.tilePoint = cc.p(tonumber(tilePoint.x), tonumber(tilePoint.y))
end
function worldMapBossView:getTilePoint()
	return self.tilePoint
end
function worldMapBossView:massButtonCallFun(ref, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local buildLogic = include("buildLogic")
		local isOwn = buildLogic.isOwnBuild(BUILDID.HALL_OF_WAR)
		if not isOwn then
			SoraDShowMsgBox(i18n("common_text_2125"), i18n("common_text_204"))
			return
		end
		local aid = allianceMgr:hasJoinAlliance(true)
		if not aid then
			SoraDShowMsgBox(i18n("common_text_583"), i18n("common_text_204"))
			return
		end
		if (aid ~= self.boss:getPlaceUid() or self.boss:getPlaceUid() == nil) and self.boss:getBossClassID() == gBossType.sweetMeatRobber then
			SoraDShowMsgBox(i18n("Dessert_Thief_27"), i18n("common_text_204"))
			return
		end
		local remainsWarUtil = include("remainsWarUtil")
		if remainsWarUtil.isForbitWarByInBorn() then
			SoraDShowMsgTip(i18n("remains_text_142"))
			return
		end
		local sourceKid = lordInfoCtrl:getLordInfo().base.sourceKid
		if self.boss:getBossClassID() == gBossType.huntFairBoss and 0 < sourceKid then
			SoraDShowMsgTip(i18n("Snow_Monster_text_09"))
			return
		end
		local uid = lordInfoCtrl:getLordInfo().base.uid
		print("uid", uid, self.boss:getPlaceUid())
		if self.boss:getBossClassID() == gBossType.baboonBoss and self.boss:getPlaceUid() ~= uid then
			SoraDShowMsgTip(i18n("artifact_befall_text_07"))
			return
		end
		if self.boss:getBossClassID() == gBossType.monsterInvasionBoss and self.boss:getPlaceUid() ~= uid then
			SoraDShowMsgTip(i18n("MonsterInvade_09"))
			return
		end
		local physical = lordInfoCtrl:getBaseInfo().physical
		if self.boss:getBossClassID() == gBossType.werewolf and physical < 20 then
			SoraDShowMsgBox(i18n("common_text_988"), i18n("common_text_204"), nil, function(callType)
				if callType == MSGBOX_CALLBACK_YES then
					SoraDCreatePanel("physicalBuyView"):show()
				end
			end)
			return
		end
		if 0 >= self.leftLife then
			SoraDShowMsgBox(i18n("notice_0026"), i18n("common_text_204"))
			return
		end
		if SoraDEnoughTroops() then
			local panel = uiManager:show("WorldMapMass")
			_ENV = i18n("common_text_204")
			i18n("common_text_204").uPos = self.tilePoint
			i18n("common_text_204").dispatchType = worldMapDefine.worldMapTipButtonType_xuanZhan
			i18n("common_text_204").instanceID = self.boss:getInstanceID()
			i18n("common_text_204").instanceType = self.boss:getInstanceType()
			i18n("common_text_204").classID = self.boss:getBossClassID()
			panel.view:bindData(i18n("common_text_204"))
		end
		local bossType = self.boss:getBossClassID()
		local limitType = _G.gBossType2LimitType[bossType] or bossType
		local isAttackReward = kingdomMapCtrl:canGetBossAttackRewards(limitType)
		local isKillReward = kingdomMapCtrl:canGetBossKillRewards(limitType)
		if not isAttackReward then
			local maxAttack = activityShowCtrl:getBossMaxAttackNum(limitType)
			if limitType == gBossType.heroBattleBoss1 or limitType == gBossType.endlessTrialBoss1 or limitType == gBossType.monsterInvasionBoss then
				_ENV = i18n("common_text_204")
				i18n("common_text_204").maxAttack = maxAttack
				SoraDShowMsgBox(i18n("herobattle_text_19", i18n("common_text_204")), i18n("common_text_204"))
			else
				_ENV = i18n("common_text_204")
				i18n("common_text_204").maxAttack = maxAttack
				SoraDShowMsgBox(i18n("common_text_2151", i18n("common_text_204")), i18n("common_text_204"))
			end
		elseif not isKillReward then
			local maxKill = activityShowCtrl:getBossMaxKillNum(limitType)
			if limitType == gBossType.heroBattleBoss1 or limitType == gBossType.endlessTrialBoss1 or limitType == gBossType.monsterInvasionBoss then
				_ENV = i18n("common_text_204")
				i18n("common_text_204").maxKill = maxKill
				SoraDShowMsgBox(i18n("herobattle_text_20", i18n("common_text_204")), i18n("common_text_204"))
			else
				_ENV = i18n("common_text_204")
				i18n("common_text_204").maxKill = maxKill
				SoraDShowMsgBox(i18n("common_text_2152", i18n("common_text_204")), i18n("common_text_204"))
			end
		end
		if bossType == gBossType.baboonBoss then
			_ENV = i18n("common_text_204")
			i18n("common_text_204").num = include("constantRead").getConstValue("ARTIFACT_BEFALL_3")
			SoraDShowMsgBox(i18n("artifact_befall_text_05", i18n("common_text_204")), i18n("common_text_204"), i18n("common_text_185"))
		end
		self:close(ref, type)
	end
end
function worldMapBossView:close(ref, type)
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
	SoraDSendMessage(nil)
end
function worldMapBossView:beginTime(time)
	local sysTime = serviceFunctions.systemTime()
	if sysTime == nil then
		sysTime = os.time()
	end
	self.timeNumber = time - sysTime
	if self.timeNumber <= 0 then
		self:endTime(true)
		return
	end
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self.txtTime:setVisible(true)
	self.hourglass:setVisible(true)
	self:updateTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function worldMapBossView:endTime(timeBoss)
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
		self.timeHandler = nil
	end
	self.txtTime:setVisible(false)
	self.hourglass:setVisible(false)
	if timeBoss then
		self:close()
	end
end
function worldMapBossView:updateTime(time)
	if self.timeNumber <= 0 then
		self:endTime(true)
		print("Boss消失了！！！")
		return
	end
	_ENV = nil
	;(nil).time = SoraDConvertSecondToString(self.timeNumber)
	self.txtTime:setString(i18n("common_text_2885", nil))
	self.hourglass:setPositionX(SoraDFSign(self.txtTime:getContentSize().width / 2 + 20))
	self.timeNumber = self.timeNumber - 1
end
function worldMapBossView:atttackButtonCallFun(ref, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local uid = lordInfoCtrl:getLordInfo().base.uid
		if self.boss:getBossClassID() == gBossType.monsterInvasionBoss and self.boss:getPlaceUid() ~= uid then
			SoraDShowMsgTip(i18n("MonsterInvade_09"))
			return
		end
		if self.boss:getBossClassID() == gBossType.fireDragon1 and not allianceMgr:hasJoinAlliance(true) then
			SoraDShowMsgBox(i18n("common_text_583"), i18n("common_text_204"))
			return
		end
		if SoraDEnoughTroops() then
			local bossType = self.boss:getBossClassID()
			print("self.boss:getInstanceType()", self.boss:getInstanceType(), self.boss:getInstanceID(), bossType, self.boss:getClassType())
			local dispatchPanel = uiManager:show("WorldDispatchArmyView")
			_ENV = self.boss:getInstanceID()
			self.boss:getInstanceID().toPoint = self.tilePoint
			self.boss:getInstanceID().dispatchType = worldMapDefine.worldMapTipButtonType_gongJi
			self.boss:getInstanceID().instanceID = self.boss:getInstanceID()
			self.boss:getInstanceID().bossType = bossType
			self.boss:getInstanceID().instanceType = self.boss:getInstanceType()
			dispatchPanel:initData((self.boss:getInstanceID()))
			local limitType = _G.gBossType2LimitType[bossType] or bossType
			local isAttackReward = kingdomMapCtrl:canGetBossAttackRewards(limitType)
			local isKillReward = kingdomMapCtrl:canGetBossKillRewards(limitType)
			if not isAttackReward then
				local maxAttack = activityShowCtrl:getBossMaxAttackNum(limitType)
				_ENV = self.boss:getClassType()
				self.boss:getClassType().maxAttack = maxAttack
				SoraDShowMsgBox(i18n("common_text_2151", self.boss:getClassType()), i18n("common_text_204"))
			elseif not isKillReward then
				local maxKill = activityShowCtrl:getBossMaxKillNum(limitType)
				local str = bossType ~= gBossType.monsterInvasionBoss and "common_text_2152" or "MonsterInvade_11"
				_ENV = i18n("common_text_204")
				i18n("common_text_204").maxKill = maxKill
				SoraDShowMsgBox(i18n(str, i18n("common_text_204")), i18n("common_text_204"))
			end
		end
		self:close(ref, type)
	end
end
function worldMapBossView:refreshWastelandBoss(...)
	local wastelandCtrl = SoraDGetCtrl("wastelandCtrl")
	local maxCanKillLevel = wastelandCtrl:getMaxAttackBossLevel()
	self.maxCanKillLevel = maxCanKillLevel
	if maxCanKillLevel < self.boss.bossLevel then
		_ENV = nil
		;(nil).lv = maxCanKillLevel
		self.warningLabel:setString(i18n("wasteland_text_012", nil))
		self.massButton:setVisible(false)
		self.attackButton:loadTextureNormal("btn_green_normal_01.png", ccui.TextureResType.plistType)
		self.attackButton:setTitleText(i18n("common_text_477"))
		self.attackButton:setPositionX(0)
		self.attackButton:addTouchEventListener(function(ref, type)
			if type == ccui.TouchEventType.ended then
				SoraDPlaySound()
				self:autoSearch()
			end
		end)
		return
	end
	local worldMapView = SoraDCurrentSceneShowView("worldMapView")
	if worldMapView then
		local ret = worldMapView:getBelongMonsterList(self.boss:getInstanceID())
		if 0 < #ret then
			local bossname = wastelandCtrl:getBossConfig(self.boss:getSettingId()).name
			local num = 0
			for i, v in ipairs(ret) do
				num = num + v:getLifeCount()
			end
			_ENV = self.boss:getSettingId()
			self.boss:getSettingId().bossname = i18n(bossname)
			self.boss:getSettingId().num = num
			self.warningLabel:setString(i18n("wasteland_text_014", self.boss:getSettingId()))
			self.massButton:setVisible(false)
			self.attackButton:loadTextureNormal("btn_green_normal_01.png", ccui.TextureResType.plistType)
			self.attackButton:setTitleText(i18n("common_text_829"))
			self.attackButton:setPositionX(0)
			self.attackButton:addTouchEventListener(handler(self, self.btnLookCallFun))
		end
	end
end
function worldMapBossView:btnLookCallFun(ref, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:showTileRolygon()
		self:close(ref, type)
	end
end
function worldMapBossView:showTileRolygon(...)
	local worldMapView = SoraDCurrentSceneShowView("worldMapView")
	if not worldMapView then
		return
	end
	local ret = worldMapView:getBelongMonsterList(self.boss:getInstanceID())
	if #ret == 0 then
		return
	end
	local uniqueKey = "worldMapBossView_rolygon"
	if SoraDManagerFindTimerByTarget(uniqueKey) then
		return
	end
	local onShowView = worldMapView.containerView
	local Node_rolygon = display.newNode()
	Node_rolygon:setName("Node_rolygon")
	onShowView:addChild(Node_rolygon, worldMapDefine.Z_ORDER.selectBgView)
	local hasFrames = SoraDIsFileExistByKey("worldMapBossWasteland")
	for _, tileInstance in ipairs(ret) do
		local x, y = tileInstance:getPosition()
		local showPoint = cc.p(x, y - 40)
		local coverShowPoint = SoraDCoverToPoint2DOr3D(worldMapView.currentInMapViewCell, showPoint, onShowView)
		local node = display.newNode()
		node:setCascadeOpacityEnabled(true)
		node:addTo(Node_rolygon)
		node:setPosition(coverShowPoint)
		local sprite = display.newSprite("#dh_jdgx_01.png")
		sprite:addTo(node)
		if hasFrames then
			local frames = display.newFrames("dh_jdgx_%02d.png", 1, 30)
			local animation = display.newAnimation(frames, 0.06666666666666667)
			sprite:playAnimationForever(animation)
		end
		local _ENV, actionsArray = frames, display.newFrames("dh_jdgx_%02d.png", 1, 30)
		actionsArray[#actionsArray + 1] = cc.FadeTo:create(1.0, 255)
		actionsArray[#actionsArray + 1] = cc.FadeTo:create(1.0, 100)
		actionsArray[#actionsArray + 1] = cc.FadeTo:create(1.0, 255)
		actionsArray[#actionsArray + 1] = cc.FadeTo:create(1.0, 0)
		local action = transition.sequence(actionsArray)
		node:setOpacity(0)
		node:stopAllActions()
		node:runAction(action)
	end
	SoraDDelayCallOnce(uniqueKey, function()
		if not tolua.isnull(Node_rolygon) then
			Node_rolygon:removeFromParent(true)
		end
	end, 4.0)
end
function worldMapBossView:msgBackData(target, redata)
	SoraDCloseLoading(self)
	self:close(ref, type)
	if redata and redata.retdate then
		if redata.retdate.x ~= -1 and redata.retdate.x ~= -1 then
			SoraDGotoWorldMapPoint(cc.p(redata.retdate.x, redata.retdate.y), true)
		else
			SoraDShowMsgTip(i18n("common_text_2177"))
		end
	elseif redata and redata.err and gErrDef.Err_PYRAMID_NOT_ENOUGH_VIP == redata.err then
		SoraDShowMsgTip(i18n("common_text_2175"))
	end
end
function worldMapBossView:autoSearch()
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	local curPos = cityCtrl:getCurCityPos()
	local _min, _max = tonumber(self.maxCanKillLevel), tonumber(self.maxCanKillLevel)
	local sendServer2Find = function()
		print("走服务")
		local findMonsterCtrl = SoraDGetCtrl("findMonsterCtrl")
		findMonsterCtrl:sendSearchBossMsg(gBossType.wastelandBoss, _min, _max)
		SoraDShowLoading(self)
	end
	local local2Find = function(_fun)
		print("走客户")
		SoraDShowLoading(self)
		_ENV = nil
		;(nil).lowLevel = _min
		;(nil).highLevel = _max
		;(nil).point = curPos
		local worldObj = SoraDGetClosestInstanceInWorldMap(gMapObjTypeDef.wastelandBoss, false, false, nil)
		if worldObj then
			local showTilePoint = worldObj:getTilePoint()
			local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
			if not kingdomMapCtrl:isLockByOtherPlayer(showTilePoint.x, showTilePoint.y, gMapObjTypeDef.wastelandBoss) then
				SoraDCloseLoading(self)
				self:close(ref, type)
				SoraDGotoWorldMapPoint(showTilePoint, true)
			else
				_fun()
			end
		else
			_fun()
		end
	end
	local2Find(sendServer2Find)
end
function worldMapBossView:setReleaseTime(releaseTime)
	if 0 < releaseTime then
		if not self.txtReaseTime then
			self.txtReaseTime = SoraDCreateTimerLabel(self, SoraDGetChildByName(self, "Text_release_time"))
			self.txtReaseTime:setTimeEndListener(function()
				self:close()
			end)
		end
		self.txtReaseTime:removeTime()
		self.txtReaseTime:setTimeLast(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("wasteland_text_024", nil)
		end)
		self.txtReaseTime:beginTime(releaseTime)
		self.txtReaseTime:setVisible(true)
	end
	if releaseTime <= 0 and self.txtReaseTime then
		self.txtReaseTime:removeTime()
		self.txtReaseTime:setVisible(false)
	end
end
return worldMapBossView
