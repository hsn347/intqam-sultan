local mailFunctions = include("mailFunctions")
local endlessTrialsCtrl = SoraDGetCtrl("endlessTrialsCtrl")
local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WorldMapBossViewPanel = class("WorldMapBossViewPanel", baseFguiPanel)
function WorldMapBossViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("WorldMapBossViewPanel:ctor", self.viewName)
end
function WorldMapBossViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function WorldMapBossViewPanel:onInit()
	print("=======WorldMapBossViewPanel:onInit")
	self.boss = nil
	self.bossState = nil
	self.tilePoint = nil
	self.isSelfKindom = gametop.playertop_:getMapID() == worldMapDefine.currentMapKindomID
	self.massButton = SoraDGetChildByName(self, "Button_mass")
	if self.massButton then
		self.massButton:setTitle(i18n("common_text_2079"))
		self.massButton:addClickEventListener(function(ref, type)
			self:massButtonCallFun(ref, type)
		end)
		self.massButton:setVisible(false)
		if not self.isSelfKindom then
			self.massButton:setEnabled(false)
			self.massButton:setBright(false)
		end
	end
	self.attackButton = SoraDGetChildByName(self, "Button_attack")
	self.attackButton:addClickEventListener(handler(self, self.atttackButtonCallFun))
	self.attackButton:setVisible(false)
	self.rewards, _ENV, self.text_Name = SoraDGetChildByName(self, "Text_bossName"), SoraDGetChildByName(self, "Text_bossName"), SoraDGetChildByName(self, "Text_bossName")
	for i = 1, 4 do
		local rewardItem = SoraDGetChildByName(self, "image_kuang_" .. i)
		self.rewards[i] = fguiHelper.get_fields(rewardItem)
		rewardItem:fixPos()
	end
	self.progress_blood = SoraDGetChildByName(self, "LoadingBar_progress")
	self.text_progress = fguiHelper.get_fields(self.progress_blood).title
	self.progress_blood:fixChildrenPos()
	local rewardItemName4 = self.rewards[4].title
	rewardItemName4:setString(i18n("common_text_486"))
	self.rewards[4].item:initData()
	self.rewards[4].item:setIcon("icon_equip_storagebox.png")
	self.text_talk = SoraDGetChildByName(self, "Text_desInfo")
	self.text_talk:setNeedAutoFix(false)
	self.text_talk:setAlign(cc.TEXT_ALIGNMENT_RIGHT)
	self.text_Info = SoraDGetChildByName(self, "Text_info")
	if self.text_Info then
		self.text_Info:setVisible(false)
	end
	self.imgBoss = SoraDGetChildByName(self, "Image_boss")
	self.Sprite_class = SoraDGetChildByName(self, "Sprite_class")
	local randomInfoLabel = SoraDGetChildByName(self, "Text_random")
	randomInfoLabel:setString(i18n("common_text_488"))
	self.warningLabel = SoraDGetChildByName(self, "Text_warning")
	self.textHeroBossTip = SoraDGetChildByName(self, "Text_heroBoss_tip")
	self.textHeroBossTip:setVisible(false)
	self.txtTime = SoraDGetChildByName(self, "Text_time")
	self.txtTime:setVisible(false)
	self.hourglass = SoraDGetChildByName(self, "icon_hourglass_3")
	self.hourglass:fixPos()
	self.hourglass:setVisible(false)
end
function WorldMapBossViewPanel:onShow()
	print("=======WorldMapBossViewPanel:onShow")
	self.fitWidth = self.view:getSize().width / 2
end
function WorldMapBossViewPanel:initData(mapInstance)
	self.boss = mapInstance
	self.leftLife = self.boss.leftLife
	self.shield = self.boss.shield
	self.text_Name:setString(self.boss.bossName .. " LV." .. self.boss.bossLevel)
	dump(self.boss.bossData, "self.boss")
	local bossClassID = self.boss:getBossClassID()
	self.bossData = worldMapDefine.getWorldBossShow(bossClassID, self.boss.bossLevel)
	self.imgBoss:setIcon(self.bossData.image)
	local sourceKid = lordInfoCtrl:getLordInfo().base.sourceKid
	self.massButton:setVisible(true)
	local reward = worldMapDefine.getWorldBossReward(bossClassID, self.boss.bossLevel)
	if bossClassID == gBossType.sweetMeatRobber then
		local dessertThiefRead = include("dessertThiefRead")
		reward = dessertThiefRead.getWorldBossReward(self.boss.bossLevel)
	end
	if reward then
		for i = 1, 3 do
			self.rewards[i].item:initData(reward[i])
			self.rewards[i].title:setString(publicRead.getName(reward[i]))
		end
	end
	self:initProgressBlood()
	if self.boss.leftTime then
		self:beginTime(self.boss.leftTime)
	else
		self:endTime(false)
	end
	if bossClassID == gBossType.heroBattleBoss1 then
		self.textHeroBossTip:setVisible(true)
		_ENV = self.rewards[i].title.setString
		self.rewards[i].title.setString.BossName = self.boss.bossName
		self.rewards[i].title.setString.num = HEROBOSS_SINGLE_SCORE
		self.textHeroBossTip:setString(i18n("herobattle_text_07", self.rewards[i].title.setString))
		self.text_Name:setString(self.boss.bossName)
	elseif bossClassID >= gBossType.endlessTrialBoss1 and bossClassID <= gBossType.endlessTrialBoss8 then
		local info = endlessTrialsCtrl:getBossTypeInfo(self.boss:getBossClassID())
		dump(mailFunctions:getSoldierClassIcon(info.arms[1]), "mailFunctions:getSoldierClassIcon(info.arms[1])")
		self.Sprite_class:setURL(mailFunctions:getSoldierClassIcon(info.arms[1]))
		local config = endlessTrialsCtrl:getScoreConfig(info.type, self.boss.bossLevel)
		_ENV = mailFunctions:getSoldierClassIcon(info.arms[1])
		mailFunctions:getSoldierClassIcon(info.arms[1]).num1 = config.perScore
		mailFunctions:getSoldierClassIcon(info.arms[1]).num2 = config.allienceScore
		self.textHeroBossTip:setString(i18n("Endless_trial_text_17", mailFunctions:getSoldierClassIcon(info.arms[1])))
		self.textHeroBossTip:setVisible(true)
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
			self.massButton:removeEventListener(fgui.UIEventType.Click)
			self.massButton:addClickEventListener(function(ref, type)
				SoraDPlaySound()
				SoraDShowMsgTip(i18n("common_text_3302"))
				self:close(ref, type)
			end)
		end
	elseif worldMapDefine.isWorldBossCanAttackAlone(bossClassID, 1) and bossClassID ~= gBossType.fireDragon1 then
		self.text_talk:setString(i18n("npc_text_06"))
		self.attackButton:setVisible(true)
		self.attackButton:setPositionX(SoraDFIsRA() and self.fitWidth + 150 or self.fitWidth - 150)
		self.massButton:setPositionX(SoraDFIsRA() and self.fitWidth - 150 or self.fitWidth + 150)
		self.attackButton:setBtnColorIndex(1)
		self.attackButton:setTitle(i18n("common_text_008"))
		self.attackButton:setBright(self.massButton:isBright())
	elseif bossClassID == gBossType.huntFairBoss and 0 < sourceKid then
		self.massButton:setBright(false)
	elseif self.boss:getBossClassID() == gBossType.windTowerBoss then
		self.text_talk:setString(i18n("windActive_text_16"))
	elseif bossClassID == gBossType.gholdEmergenceBoss then
		local instanceData = self.boss:getInstanceData()
		_ENV = i18n("windActive_text_16")
		i18n("windActive_text_16").name = instanceData.nickName
		i18n("windActive_text_16").alliance = instanceData.abbr
		self.text_talk:setString(i18n("sunmmon_ghoul_text11", i18n("windActive_text_16")))
		if not self.isSelfKindom then
			self.massButton:setVisible(false)
		end
	end
	if bossClassID == gBossType.monsterInvasionBoss then
		self.massButton:setVisible(false)
		self.attackButton:setPositionX(self.fitWidth)
	end
	if bossClassID == gBossType.huntFairBoss then
		self.text_talk:setString(i18n("Npc_talk_snowman_leader_01"))
	end
	if bossClassID == gBossType.mirajBoss then
		self.massButton:setVisible(false)
		self.attackButton:setPositionX(self.fitWidth)
		self.warningLabel:setVisible(false)
		_ENV = i18n("Npc_talk_snowman_leader_01")
		_ENV = i18n("Npc_talk_snowman_leader_01")
		i18n("Npc_talk_snowman_leader_01").abbr = allianceMgr:getAllianceProperty("name")
		i18n("Npc_talk_snowman_leader_01").name = lordInfoCtrl:getBaseInfo().nickName
		i18n("Npc_talk_snowman_leader_01").name = i18n("common_text_186", i18n("Npc_talk_snowman_leader_01"))
		self.text_talk:setString(i18n("almirajChange_text17", i18n("Npc_talk_snowman_leader_01")))
	elseif bossClassID == gBossType.firedragonOfAnger2025Boss then
		self.massButton:setVisible(false)
		self.attackButton:setTitle(i18n("common_text_008"))
		self.attackButton:setVisible(true)
		self.attackButton:setPositionX(self.fitWidth)
	end
	if bossClassID == gBossType.fireDragon1 or bossClassID == gBossType.fireDragon2 then
		local physical = worldMapDefine.getWorldBossStamina(bossClassID, 1)
		_ENV = i18n("common_text_008")
		i18n("common_text_008").num = physical
		self.warningLabel:setString(i18n("fierydragon_text_9", i18n("common_text_008")))
	elseif bossClassID == gBossType.monsterInvasionBoss or bossClassID == gBossType.firedragonOfAnger2025Boss then
		local physical = worldMapDefine.getWorldBossStamina(bossClassID, 1)
		_ENV = i18n("fierydragon_text_9", i18n("common_text_008"))
		i18n("fierydragon_text_9", i18n("common_text_008")).var = physical
		self.warningLabel:setString(i18n("wasteland_text_013", i18n("fierydragon_text_9", i18n("common_text_008"))))
	elseif bossClassID == gBossType.sweetMeatRobber then
		local physical = worldMapDefine.getWorldBossStamina(bossClassID, 1)
		_ENV = i18n("wasteland_text_013", i18n("fierydragon_text_9", i18n("common_text_008")))
		i18n("wasteland_text_013", i18n("fierydragon_text_9", i18n("common_text_008"))).num = physical
		self.warningLabel:setString(i18n("common_text_2081", i18n("wasteland_text_013", i18n("fierydragon_text_9", i18n("common_text_008")))))
	else
		local physical = worldMapDefine.isInRemains() and 1 or 20
		_ENV = i18n("common_text_2081", i18n("wasteland_text_013", i18n("fierydragon_text_9", i18n("common_text_008"))))
		i18n("common_text_2081", i18n("wasteland_text_013", i18n("fierydragon_text_9", i18n("common_text_008")))).num = physical
		self.warningLabel:setString(i18n("common_text_2081", i18n("common_text_2081", i18n("wasteland_text_013", i18n("fierydragon_text_9", i18n("common_text_008"))))))
	end
	if bossClassID == gBossType.wastelandBoss then
		self.text_talk:setString(i18n("wasteland_text_019"))
		if self.isSelfKindom then
			self:refreshWastelandBoss()
		end
		if not self.wasteland_text then
			_ENV = self
			self.text = ""
			self.size = 20
			local text_count = SoraDCreateLabelNoChild(self)
			text_count:addTo(self.view)
			text_count:setAnchorPoint(0.5, 0.5)
			text_count:setPosition(cc.p(320, 260))
			SoraDChangeTextToHtml(text_count)
			self.wasteland_text = text_count
		else
			self.wasteland_text:setVisible(true)
		end
		local wastelandCtrl = SoraDGetCtrl("wastelandCtrl")
		local countStr = wastelandCtrl:getBossCountStr()
		self.wasteland_text:setString(countStr)
	elseif self.wasteland_text then
		self.wasteland_text:setVisible(false)
	end
end
function WorldMapBossViewPanel:initProgressBlood(...)
	local bossType = self.boss:getBossClassID()
	if bossType == gBossType.gholdEmergenceBoss then
		self.progress_blood:setVisible(false)
		return
	end
	local progress_bar = fguiHelper.get_fields(self.progress_blood).bar
	if self.shield and self.shield > 0 then
		progress_bar:setIcon("frame_wjpj_jdt.png")
		local shieldMax = worldMapDefine.getWorldBossShield(bossClassID, self.boss.bossLevel)
		self.progress_blood:setPercent(self.shield / shieldMax)
		_ENV = nil
		;(nil).num1 = self.shield
		;(nil).num2 = shieldMax
		self.text_progress:setString(i18n("Dessert_Thief_25", nil))
	else
		progress_bar:setIcon("frame_shmc_barred.png")
		self.progress_blood:setPercent(self.leftLife / 100)
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
		SoraDFadeINOUT(progress_bar, self.boss:getReleaseLeftTime())
	end
end
function WorldMapBossViewPanel:serverMessage_RequestMapInstaceInfo(target, data)
	if not data.data then
		return
	end
end
function WorldMapBossViewPanel:setTilePoint(tilePoint)
	self.tilePoint = cc.p(tonumber(tilePoint.x), tonumber(tilePoint.y))
end
function WorldMapBossViewPanel:getTilePoint()
	return self.tilePoint
end
function WorldMapBossViewPanel:massButtonCallFun(ref, type)
	SoraDPlaySound()
	local buildLogic = include("buildLogic")
	local isOwn = buildLogic.isOwnBuild(BUILDID.HALL_OF_WAR)
	if not isOwn then
		SoraDShowMsgBox(i18n("common_text_2125"), i18n("common_text_204"))
		return
	end
	local ownaid = allianceMgr:hasJoinAlliance(true)
	if not ownaid then
		SoraDShowMsgBox(i18n("common_text_583"), i18n("common_text_204"))
		return
	end
	if self.boss == nil or self.boss.getBossClassID == nil then
		self:close()
		return
	end
	local bossType = self.boss:getBossClassID()
	if (ownaid ~= self.boss:getPlaceUid() or self.boss:getPlaceUid() == nil) and bossType == gBossType.sweetMeatRobber then
		SoraDShowMsgBox(i18n("Dessert_Thief_27"), i18n("common_text_204"))
		return
	end
	local remainsWarUtil = include("remainsWarUtil")
	if remainsWarUtil.isForbitWarByInBorn() then
		SoraDShowMsgTip(i18n("remains_text_142"))
		return
	end
	local sourceKid = lordInfoCtrl:getLordInfo().base.sourceKid
	if bossType == gBossType.huntFairBoss and 0 < sourceKid then
		SoraDShowMsgTip(i18n("Snow_Monster_text_09"))
		return
	end
	local uid = lordInfoCtrl:getLordInfo().base.uid
	print("uid", uid, self.boss:getPlaceUid())
	if bossType == gBossType.baboonBoss and self.boss:getPlaceUid() ~= uid then
		SoraDShowMsgTip(i18n("artifact_befall_text_07"))
		return
	end
	if bossType == gBossType.monsterInvasionBoss and self.boss:getPlaceUid() ~= uid then
		SoraDShowMsgTip(i18n("MonsterInvade_09"))
		return
	end
	if bossType == gBossType.gholdEmergenceBoss then
		local instanceData = self.boss:getInstanceData()
		if instanceData.aid ~= ownaid then
			SoraDShowMsgTip(i18n("sunmmon_ghoul_text13"))
			return
		end
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
	self:showBossMassTip()
	self:close(ref, type)
end
function WorldMapBossViewPanel:showBossMassTip()
	local bossType = self.boss:getBossClassID()
	local limitType = _G.gBossType2LimitType[bossType] or bossType
	local isAttackReward = kingdomMapCtrl:canGetBossAttackRewards(limitType)
	local isKillReward = kingdomMapCtrl:canGetBossKillRewards(limitType)
	if not isAttackReward then
		local maxAttack = activityShowCtrl:getBossMaxAttackNum(limitType)
		if limitType == gBossType.heroBattleBoss1 or limitType == gBossType.endlessTrialBoss1 or limitType == gBossType.monsterInvasionBoss then
			_ENV = nil
			;(nil).maxAttack = maxAttack
			SoraDShowMsgBox(i18n("herobattle_text_19", nil), i18n("common_text_204"))
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
			local dailyRemindManager = include("dailyRemindManager")
			local REMIND_TYPE = dailyRemindManager.REMIND_TYPE
			_ENV = i18n("common_text_204")
			local i18n("common_text_204")[gBossType.wastelandBoss], config = REMIND_TYPE.attackTip_bossType35, i18n("common_text_204")
			local remindType = config[limitType]
			if remindType then
				if dailyRemindManager.checkNeedRemind(remindType) then
					_ENV = i18n("common_text_204")
					i18n("common_text_204").maxKill = maxKill
					local content = i18n("common_text_2152", i18n("common_text_204"))
					_ENV = i18n("common_text_204")
					i18n("common_text_204").content = content
					i18n("common_text_204").confirmFunc = function()
					end
					i18n("common_text_204").remindString = i18n("common_text_4776")
					i18n("common_text_204").remindFunc = function(value)
						if value then
							dailyRemindManager.addRemindToManager(remindType)
						end
					end
					uiManager:show("MessageBox", i18n("common_text_204"))
				end
			else
				_ENV = "MessageBox"
				;("MessageBox").maxKill = maxKill
				SoraDShowMsgBox(i18n("common_text_2152", "MessageBox"), i18n("common_text_204"))
			end
		end
	end
	if bossType == gBossType.baboonBoss then
		_ENV = i18n("common_text_204")
		i18n("common_text_204").num = include("constantRead").getConstValue("ARTIFACT_BEFALL_3")
		SoraDShowMsgBox(i18n("artifact_befall_text_05", i18n("common_text_204")), i18n("common_text_204"), i18n("common_text_185"))
	end
end
function WorldMapBossViewPanel:close(ref, type)
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
	SoraDSendMessage(nil)
end
function WorldMapBossViewPanel:beginTime(time)
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
function WorldMapBossViewPanel:endTime(timeBoss)
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
function WorldMapBossViewPanel:updateTime(time)
	if self.timeNumber <= 0 then
		self:endTime(true)
		print("Boss消失了！！！")
		return
	end
	_ENV = nil
	;(nil).time = SoraDConvertSecondToString(self.timeNumber)
	self.txtTime:setString(i18n("common_text_2885", nil))
	self.timeNumber = self.timeNumber - 1
end
function WorldMapBossViewPanel:atttackButtonCallFun(ref, type)
	SoraDPlaySound()
	if tolua.isnull(self.boss) then
		self:close(ref, type)
		return
	end
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
		self:showBossAttackTip(bossType)
	end
	self:close(ref, type)
end
function WorldMapBossViewPanel:showBossAttackTip(bossType)
	local limitType = _G.gBossType2LimitType[bossType] or bossType
	local isAttackReward = kingdomMapCtrl:canGetBossAttackRewards(limitType)
	local isKillReward = kingdomMapCtrl:canGetBossKillRewards(limitType)
	if not isAttackReward then
		local maxAttack = activityShowCtrl:getBossMaxAttackNum(limitType)
		if limitType == gBossType.monsterInvasionBoss then
			local dailyRemindManager = include("dailyRemindManager")
			if dailyRemindManager.checkNeedRemind(dailyRemindManager.REMIND_TYPE.monsterInvasionTip) then
				_ENV = nil
				_ENV = nil
				;(nil).maxAttack = maxAttack
				;(nil).content = i18n("herobattle_text_19", nil)
				;(nil).confirmFunc = function()
				end
				;(nil).remindString = i18n("common_text_4776")
				;(nil).remindFunc = function(value)
					if value then
						dailyRemindManager.addRemindToManager(dailyRemindManager.REMIND_TYPE.monsterInvasionTip)
					end
				end
				uiManager:show("MessageBox", nil)
			end
		else
			_ENV = "MessageBox"
			;("MessageBox").maxAttack = maxAttack
			SoraDShowMsgBox(i18n("common_text_2151", "MessageBox"), i18n("common_text_204"))
		end
	elseif not isKillReward then
		local maxKill = activityShowCtrl:getBossMaxKillNum(limitType)
		local dailyRemindManager = include("dailyRemindManager")
		local REMIND_TYPE = dailyRemindManager.REMIND_TYPE
		_ENV = i18n("common_text_204")
		i18n("common_text_204")[gBossType.monsterInvasionBoss] = REMIND_TYPE.monsterInvasionTip
		local i18n("common_text_204")[gBossType.wastelandBoss], config = REMIND_TYPE.attackTip_bossType35, i18n("common_text_204")
		local remindType = config[limitType]
		if remindType then
			if dailyRemindManager.checkNeedRemind(remindType) then
				_ENV = i18n("common_text_204")
				i18n("common_text_204").maxKill = maxKill
				local content = i18n("common_text_2152", i18n("common_text_204"))
				if limitType == gBossType.monsterInvasionBoss then
					_ENV = i18n("common_text_204")
					i18n("common_text_204").maxKill = maxKill
					content = i18n("MonsterInvade_11", i18n("common_text_204"))
				end
				_ENV = i18n("common_text_204")
				i18n("common_text_204").content = content
				i18n("common_text_204").confirmFunc = function()
				end
				i18n("common_text_204").remindString = i18n("common_text_4776")
				i18n("common_text_204").remindFunc = function(value)
					if value then
						dailyRemindManager.addRemindToManager(remindType)
					end
				end
				uiManager:show("MessageBox", i18n("common_text_204"))
			end
		else
			_ENV = "MessageBox"
			;("MessageBox").maxKill = maxKill
			SoraDShowMsgBox(i18n("common_text_2152", "MessageBox"), i18n("common_text_204"))
		end
	end
end
function WorldMapBossViewPanel:refreshWastelandBoss(...)
	local wastelandCtrl = SoraDGetCtrl("wastelandCtrl")
	local maxCanKillLevel = wastelandCtrl:getMaxAttackBossLevel()
	self.maxCanKillLevel = maxCanKillLevel
	if maxCanKillLevel < self.boss.bossLevel then
		_ENV = nil
		;(nil).lv = maxCanKillLevel
		self.warningLabel:setString(i18n("wasteland_text_012", nil))
		self.massButton:setVisible(false)
		self.attackButton:setBtnColorIndex(2)
		self.attackButton:setTitle(i18n("common_text_477"))
		self.attackButton:setPositionX(self.fitWidth)
		self.attackButton:removeEventListener(fgui.UIEventType.Click)
		self.attackButton:addClickEventListener(function(ref, type)
			SoraDPlaySound()
			self:autoSearch()
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
			self.attackButton:setBtnColorIndex(2)
			self.attackButton:setTitle(i18n("common_text_829"))
			self.attackButton:setPositionX(self.fitWidth)
			self.attackButton:removeEventListener(fgui.UIEventType.Click)
			self.attackButton:addClickEventListener(handler(self, self.btnLookCallFun))
		end
	end
end
function WorldMapBossViewPanel:btnLookCallFun(ref, type)
	SoraDPlaySound()
	self:showTileRolygon()
	self:close(ref, type)
end
function WorldMapBossViewPanel:showTileRolygon(...)
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
function WorldMapBossViewPanel:msgBackData(target, redata)
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
function WorldMapBossViewPanel:autoSearch()
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
function WorldMapBossViewPanel:setReleaseTime(releaseTime)
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
return WorldMapBossViewPanel
