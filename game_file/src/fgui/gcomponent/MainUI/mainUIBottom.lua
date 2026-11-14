local gametop = gModuleMgr.getObject("gametop")
local mailMgr = gModuleMgr.sharedMgr("mailMgr")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local expostulationLogic = include("expostulationLogic")
local cityBuildData = include("cityBuildData")
local chatAudioMgr = gChatMgrs:getMgr("chatAudioMgr")
local effectEventGift = include("effectEventGift")
local allianceGuideCtrl = SoraDGetCtrl("allianceGuideCtrl")
local cityBuildFunction = include("cityBuildFunction")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local funUnlockRead = include("funUnlockRead")
local mainUIDef = include("mainUIDef")
local baseComponent = require("fgui.base.baseComponent")
local mainUIBottom = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/mainUIBottom", mainUIBottom)
function mainUIBottom:onInit()
	self.isInitGreenPointDone = true
	self.isCheckWatchTowerDone = true
	cityBuildData:removeMessageListener()
	cityBuildData:registerMessageListener()
	userSDKManager.setAudioTarget(chatAudioMgr)
	self.viewChangeType = VIEW_TYPE_CITY
	self.btnSwitchType = 1
	local animationCollectItems = include("animationCollectItems").new()
	animationCollectItems:setName("animationCollectItems")
	self.fields.Csd_collect:clearContent()
	self.fields.Csd_collect:setContent(animationCollectItems)
	self:getAreaBTarget("Button_worldCity"):setViewType(self.viewChangeType - 1)
	self:getAreaBTarget("Button_worldCity"):addClickListener(handler(self, self.OnWorldCityClick))
	self.fields.Button_account:setVisible(false)
	self.fields.Button_account:setShowType(0)
	local teamAreaEnum = include("teamDef").teamAreaEnum
	self.fields.Button_legendInvite:setTeamType(teamAreaEnum.LEGEND_LORD)
	self.fields.Button_kingStarInvite:setTeamType(teamAreaEnum.LEGEND_LORD_FOR_SEP)
	self.fields.Button_invite12:setTeamType(teamAreaEnum.NEBULA_EMPEROR)
	self.fields.Button_invite13:setTeamType(teamAreaEnum.NEBULA_ALL_STAR)
	self.fields.Button_skill:addClickListener(handler(self, self.OnSkillClick))
	self.fields.Button_meteorite_skill:addClickListener(handler(self, self.OnMeteoriteSkillClick))
	self.fields.questGuideNode:fixPos()
	self.fields.Button_quest:fixPos()
	self.fields.Button_skill:fixPos()
	self.fields.Button_meteorite_skill:fixPos()
	self.fields.switch:fixPos()
end
function mainUIBottom:onShow()
	self:initStyle()
	self:initView()
end
function mainUIBottom:registerEvent()
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_LOGINFINSH", handler(self, self.reLoginFinish))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_ONSHOW", handler(self, self.currentShowViewType))
	SoraDAddMessage(self, "MESSAGE_CHAT_OPEN_UI_ALLIANCE", handler(self, self.openUIAlliance))
	SoraDAddMessage(self, "MESSAGE_UI_EXPOSTULATION_UPDATE", handler(self, self.updateExpostulation))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BIND_AWARD", handler(self, self.initAccountBind))
	SoraDAddMessage(self, "MESSAGE_SERVER_GUIDE_HIDE_AND_SHOW", handler(self, self.showOrHideGuideView))
	SoraDAddMessage(self, "MESSAGE_PRINCE_GIFT_GUIDE_BUFF_REFRESH", handler(self, self.showPrinceGiftGuideView))
	SoraDAddMessage(self, "MESSAGE_SINBAD_TREASURE_UPDATE_LV_POP_WINDOW", handler(self, self.showSinbadPopWindow))
	SoraDAddMessage(self, "MESSAGE_SERVER_LUCKY_DAY_UPDATE", handler(self, self.showLuckyBless))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.serverMessageGetAllianceInfo))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_MAINUIINVITE_REFRESH", handler(self, self.initAllianceInvitePop))
	SoraDAddMessage(self, "MESSAGE_SERVER_GUIDE_START_BY_STEP", handler(self, self.recevieGuideMsg))
	SoraDAddMessage(self, "MESSAGE_QUESTIONNAIRE_REFRESH", handler(self, self.updateQuestionnaireButton))
	SoraDAddMessage(self, "MESSAGE_CUMUACTIVITY_CRAZYTRIO_SHOWDOWN", handler(self, self.updateCrazyTrioButton))
	SoraDAddMessage(self, "MESSAGE_CUMUACTIVITY_CRAZYTRIO_RELASH", handler(self, self.addCrazyTrioButton))
	SoraDAddMessage(self, "MESSAGE_MONTHLY_CARD_REFRESH_BACK", handler(self, self.updateMonthCardButton))
	SoraDAddMessage(self, "MESSAGE_SERVER_LUCKYBLESS_UPDATE", handler(self, self.showLuckyBless))
	SoraDAddMessage(self, "MESSAGE_UI_EVENTCENTER_REFRESHISNEW", handler(self, self.updateCommunityButton))
	SoraDAddMessage(self, "MESSAGE_GOLD_PACKAGE_STATE", handler(self, self.addGoldPackageButton))
	SoraDAddMessage(self, "MESSAGE_LUCKY_RECHARGE_REFRESH", handler(self, self.updateBtnLuckyRecharge))
	SoraDAddMessage(self, "MESSAGE_MAIN_RECORD_SCREEN", handler(self, self.startRecordScreen))
	SoraDAddMessage(self, "MESSAGE_MAIN_STOP_RECORD_SCREEN", handler(self, self.stopRecording))
	SoraDAddMessage(self, "MESSAGE_WALLS_NOTIFY_SUCCESS", handler(self, self.checkWallDefend))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_GET_ALLIANCE_HELP_LIST_SUCCESS", handler(self, self.initHelpAllBtn))
	SoraDAddMessage(self, "MESSAGE_SERVER_WATCHTOWER_ADDINFO", handler(self, self.checkWatchTower))
	SoraDAddMessage(self, "MESSAGE_SERVER_WATCHTOWER_REMOVEINFO", handler(self, self.checkWatchTower))
	SoraDAddMessage(self, "MESSAGE_SERVER_WATCHTOWER_EDITINFO", handler(self, self.checkWatchTower))
	SoraDAddMessage(self, "MESSAGE_CLIENT_WATCHTOWER_INGORECONTROL", handler(self, self.checkWatchTower))
	SoraDAddMessage(self, "MESSAGE_SERVER_WATCHTOWER_REFRESHALL", handler(self, self.checkWatchTower))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_SETTING", handler(self, self.checkWatchTower))
	SoraDAddMessage(self, "MESSAGE_SERVER_WATCHSOULTOWER_ADDINFO", handler(self, self.checkWatchTower))
	SoraDAddMessage(self, "MESSAGE_SERVER_WATCHSOULTOWER_EDITINFO", handler(self, self.checkWatchTower))
	SoraDAddMessage(self, "MESSAGE_SERVER_WATCHSOULTOWER_REMOVEINFO", handler(self, self.checkWatchTower))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_ROMANSOUL_ALLIANCEATTACK", handler(self, self.checkRomanSoul))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_MAINUIICONCHECK", handler(self, self.btnPyramidBattleCheck))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_GROUP_UPDATE", handler(self, self.btnPyramidBattleCheck))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_BE_KICKED", handler(self, self.btnPyramidBattleCheck))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_QUIT_SUCCESS", handler(self, self.btnPyramidBattleCheck))
	SoraDAddMessage(self, "MESSAGE_PAYBACK_NOTICE", handler(self, self.btnPayBackCheck))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEGEMON_LORD_NOTIFY_CLEAN", handler(self, self.msgHegemonClean))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEGEMON_LORD_NOTIFY_AP_LT", handler(self, self.btnHegemonManagerCheck))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEGEMON_LORD_TITLE_INFO_BACK", handler(self, self.btnHegemonManagerCheck))
	SoraDAddMessage(self, "MESSAGE_REQ_NEW_PRINCE_GIFT_BUY_PACKAGE", handler(self, self.addPrinceGiftNewBuffButton))
	SoraDAddMessage(self, "MESSAGE_PRINCE_GIFT_GUIDE_REFRESH", handler(self, self.addPrinceGiftBuffButton))
	SoraDAddMessage(self, "MESSAGE_PRINCE_GIFT_INIT", handler(self, self.addPrinceGiftBuffButton))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_NEWPLAYER_BUFF_END", handler(self, self.btnNewPlayerBuffCheck))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEGEMON_UPDATE_MAINUI_HEGEMON", handler(self, self.btnHegemonBattleCheck))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMUSR_CHANGED", handler(self, self.btnKingdomManagerCheck))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMALLIANCE_GIFT", handler(self, self.btnKingdomManagerCheck))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_LORD_NOTIFY_CLEAN", handler(self, self.btnLegendKingManagerCheck))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_LORD_NOTIFY_AP_LT", handler(self, self.btnLegendKingManagerCheck))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_LORD_TITLE_INFO_BACK", handler(self, self.btnLegendKingManagerCheck))
	SoraDAddMessage(self, "MESSAGE_HARVEST_SEASON_REDPOINT", handler(self, self.addHarvestSeasonButton))
	SoraDAddMessage(self, "MESSAGE_ITEM_CHANGE_TYPE", handler(self, self.recevieItemChangeMsg))
	SoraDAddMessage(self, "MESSAGE_GREEN_POINT_UPDATE", handler(self, self.initGreenPoint))
	SoraDAddMessage(self, "MESSAGE_GREEN_POINT_UPDATE_BYTYPE", handler(self, self.initGreenPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_RADIANCE_WAR_WARNING", handler(self, self.updateGreenPointRadianceWar))
	SoraDAddMessage(self, "MESSAGE_SERVER_RADIANCE_WAR_LONGTIMEUNLOGIN", handler(self, self.showLongTimeUnlogin))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_JOIN_SUCCESS", handler(self, self.RemovefirstJoinAllianceAnimation))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.getEventCenterReturn))
	SoraDAddMessage(self, "MESSAGE_PRE_DOWNLOAD_REFRESH", handler(self, self.checkPreDownloadStatus))
	SoraDAddMessage(self, "MESSAGE_PRE_DOWNLOAD_REFRESH_DOWNLOAD", handler(self, self.checkPreDownload))
	SoraDAddMessage(self, "MESSAGE_PRE_DOWNLOAD_GAME_DOWNSUC", handler(self, self.OnPreDownloadSuc))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPGRADE_LEVEL", handler(self, self.updateBtnSkillStatues))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGEND_TEAM_INVITED_INFO", handler(self, self.msgInvitedInfo_legend))
	SoraDAddMessage(self, "MESSAGE_SERVER_MAIL_REQ_BATTLE_REPORT_BACK", handler(self, self.openReportMail))
	SoraDAddMessage(self, "MESSAGE_SERVER_MAIL_REQ_SINGLE_MAIL_BACK_REPORT", handler(self, self.openReportMail))
	SoraDAddMessage(self, "MESSAGE_UI_DAILYAWARD_REFRESH_BOXES", handler(self, self.updateQuest))
	SoraDAddMessage(self, "MESSAGE_UI_DAILYAWARD_REFRESH_TREASURES", handler(self, self.updateQuest))
	SoraDAddMessage(self, "MESSAGE_UI_DAILYAWARD_REFRESH_EVENTS", handler(self, self.updateQuest))
	SoraDAddMessage(self, "MESSAGE_UI_DAILYAWARD_REFRESH_VIEW", handler(self, self.updateQuest))
	SoraDAddMessage(self, "MESSAGE_ITEM_LIMITITEM_TIMEOUT_BACK", handler(self, self.updateShopNewTag))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_BOTTOM_SWITCH_UPDATE", handler(self, self.updateSwitchContainer))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_BASE", handler(self, self.updateLordInfoBase))
	SoraDAddMessage(self, "MESSAGE_MAP_ID_CHANGE", handler(self, self.transferToSelfKingdom))
	SoraDAddMessage(self, "MESSAGE_UPDATE_METEOR_MAGIC", handler(self, self.checkMeteoriteSkillBtn))
	SoraDAddMessage(self, "MESSAGE_ITEM_CHANGE_TYPE", handler(self, self.checkMeteoriteSkillBtn))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_CASTLE_LEVELUP", handler(self, self.castleLevelUp))
	SoraDAddMessage(self, "MESSAGE_COMMANDHALL_INITDATA_UPDATE", handler(self, self.btnCommandHallChek))
	SoraDAddMessage(self, "MESSAGE_COMMANDHALL_COMMITTASK_UPDATE", handler(self, self.btnCommandHallChek))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001566_UPDATE", handler(self, self.addButtonActivity9001566))
	SoraDAddMessage(self, "MESSAGE_HERO_NEW_TRIAL_UPDATE", handler(self, self.onMsgUpdateHeroNewTrial))
	SoraDAddMessage(self, "MESSAGE_MOVELINE_SWITCH_UPDATE", handler(self, self.checkMoveLineSwitch))
	SoraDAddMessage(self, "MESSAGE_WAR_BARRAGE_VISIBLE", handler(self, self.checkWarBarrageSetting))
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_INFO_UPDATE", handler(self, self.addButtonDJ))
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_AUDIENCE_BEINVITE", handler(self, self.addButtonDJ))
	for activityID, cfg in pairs(mainUIDef.activityCfg) do
		if cfg.msg then
			SoraDAddMessage(self, cfg.msg, handlerEx(self, self.onMsgUpdateActivity, activityID))
		end
	end
end
function mainUIBottom:getAreaBTarget(name)
	return self.fields.Node_area_b:getTarget(name)
end
function mainUIBottom:castleLevelUp()
	if self.viewChangeType == VIEW_TYPE_CITY then
		self:showOrHideGuideView()
	end
	self:initBtnsStatus()
	self:initGreenPoint()
	self:btnCityUnlockCheck()
	self:btnCommandHallChek()
end
function mainUIBottom:initBtnsStatus()
	self:getAreaBTarget("Button_alliance"):setStatus()
	self:getAreaBTarget("Button_mail"):setStatus()
	self:getAreaBTarget("Button_items"):setStatus()
	self:getAreaBTarget("Button_hero"):setStatus()
	self:getAreaBTarget("Button_worldCity"):setStatus()
end
function mainUIBottom:initView()
	self:createExpostulationTimer()
	self:initBtnsStatus()
	self:updateNewTrialUI()
	self:initAccountBind()
	self:initGreenPoint()
	self:showAllianceEffect()
	self:updateBtnSkillStatues()
	self:updateQuest()
	self:showLuckyBless()
	self:initHelpAllBtn()
	self:checkWatchTower()
	self:updateGreenPointRadianceWar()
	self:checkRemainsWar()
	self:updateItemsBtn()
	self:req4AllianceInviteData()
	self:checkMeteoriteSkillBtn()
	self:msgInvitedInfo_legend()
	self.fields.switch:clearChildren()
	self:updateSwitchBtns()
	self:showOrHideGuideView()
	SoraDGetCtrl("questionnaireCtrl"):reqGetQuestData()
	self:checkBackMoney()
end
function mainUIBottom:updateSwitchContainer(target, data)
	if data and data.sType then
		self.fields.switch:delOneChild(data.sType)
	end
end
function mainUIBottom:openUIAlliance()
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.ALLIANCE)
	if unlockLv > SoraDGetCastleLv() then
		funUnlockRead = nil
		;(nil).name = i18n("common_text_069")
		;(nil).lv = unlockLv
		SoraDShowMsgTip(i18n("common_text_2122", nil))
		return
	end
	if worldMapDefine.isInRemains() then
		uiManager:show("AllianceWarView")
	elseif worldMapDefine.isInLegendLord() then
		local legendTeamUtil = include("legendTeamUtil")
		legendTeamUtil.openTeamView(worldMapDefine.currentMapKindomID)
	elseif worldMapDefine.isInAtlantis() then
		SoraDCreatePanel("atlantisWarTeamView"):show()
	else
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		if allianceMgr:hasJoinAlliance() then
			if GLOBAL_GAME_ALLIANCE_MODE then
				uiManager:show("allianceMainView")
			else
				SoraDCreatePanel("allianceMainView"):show()
			end
		else
			uiManager:show("AllianceJoinView")
		end
	end
end
function mainUIBottom:createExpostulationTimer()
	self:deleteExpostulationTimer()
	self.expostulationTimer = SoradCreateTimer(self, handler(self, self.updateExpostulation))
	_ENV = handler(self, self.updateExpostulation)
	handler(self, self.updateExpostulation).isInit = true
	self:updateExpostulation(self, handler(self, self.updateExpostulation))
end
function mainUIBottom:deleteExpostulationTimer()
	if self.expostulationTimer then
		SoraDManagerRemoveTimer(self, self.expostulationTimer)
		self.expostulationTimer = nil
	end
end
function mainUIBottom:updateExpostulation(target, data)
	if data and data.isInit then
		GLOBAL_EXPOSTULATION_TIME = 0
	end
	GLOBAL_EXPOSTULATION_TIME = GLOBAL_EXPOSTULATION_TIME + 1
	local guideCtrl = gametop.playertop_:getModule("guideCtrl")
	local guideStep = guideCtrl:getCurForceGuideStep()
	if GLOBAL_EXPOSTULATION_TIME == EXPOSTULATION_INTERVAL and not guideStep and self.viewChangeType == VIEW_TYPE_CITY then
		local expostulationData = expostulationLogic.getExpostulation()
		GLOBAL_EXPOSTULATION_TIME = 0
		if expostulationData then
			self.fields.questGuideNode:changeToExpostulation(expostulationData)
		else
			self.fields.questGuideNode:initData()
		end
	end
end
function mainUIBottom:updateQuest()
	self.fields.Button_quest:setRed()
end
function mainUIBottom:updateNewTrialUI()
	if not worldMapDefine.isInNewTrial() then
		return
	end
	self.fields.switch:clearChildren()
end
function mainUIBottom:initAccountBind(target, data)
	local isBind = userSDKManager.returnAccountBindType(gSDKDef.platformType.email)
	local isPhoneBind = userSDKManager.returnAccountBindType(gSDKDef.platformType.mobile)
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local lordBase = lordInfoCtrl:getBaseInfo()
	local isReward = lordBase.hasBindAccountReward or false
	local isBindPhone = lordBase.receiveBindPhone or false
	local ret = false
	if IsArClient then
		if self.viewChangeType == VIEW_TYPE_CITY and (not (not (SoraDGetCastleLv() >= CASTLE_LV6_LIMITED) or isBind and (not isBind or isReward)) or SoraDGetCastleLv() >= CASTLE_LV10_LIMITED and (not isPhoneBind or isPhoneBind and not isBindPhone)) then
			ret = true
		else
			ret = false
		end
	elseif self.viewChangeType == VIEW_TYPE_CITY and SoraDGetCastleLv() >= CASTLE_LV6_LIMITED and (not isBind or isBind and not isReward) then
		ret = true
	else
		ret = false
	end
	_ENV = nil
	;(nil).byUID = true
	local isSettingHide = SoraDConfigGet("Game:GameOptionsView:bindPhoneShow~bool", nil) or false
	self.fields.Button_account:setVisible(ret and not isSettingHide and not worldMapDefine.isInWar())
	if IsArClient then
		self.fields.Button_account:setShowType(SoraDGetCastleLv() >= CASTLE_LV10_LIMITED and isBind and isReward and 1 or 0)
		self.fields.Button_account:setRedVisible(isBind and not isReward or isPhoneBind and not isBindPhone)
	else
		self.fields.Button_account:setShowType(0)
		self.fields.Button_account:setRedVisible(isBind and not isReward)
	end
	self:sortBottomQuestBtns()
end
function mainUIBottom:sortBottomQuestBtns()
	if self.viewChangeType ~= VIEW_TYPE_CITY then
		local worldMapWarDef = include("worldMapWarDef")
		local posy = worldMapWarDef.getMainUIBottomPosY()
		_UPVALUE11_ = nil
		;(nil)[1] = "Button_wallBurnning"
		;(nil)[2] = "Button_watchTower"
		;(nil)[3] = "Button_watchTowerInWar"
		;(nil)[4] = "Button_legendInvite"
		;(nil)[5] = "Button_kingStarInvite"
		;(nil)[6] = "Button_radiance"
		;(nil)[7] = "Button_meteorite_skill"
		;(nil)[8] = "Button_invite12"
		;(nil)[9] = "Button_invite13"
		;(nil)[10] = "Button_moveLineSwitch"
		local (nil)[11], btnTableName = "Button_barrageSet", nil
		for _, v in ipairs(btnTableName) do
			if self.fields[v] and self.fields[v]:isVisible() then
				self.fields[v]:setPosition(SoraDFIsRA() and self:getWidth() - 85 or 15, posy)
				posy = posy - 90
			end
		end
	else
		local basePosy = -195
		local basePosx = SoraDFIsRA() and self:getWidth() - 85 or 15
		local isRA = SoraDFIsRA()
		_UPVALUE13_ = ipairs(btnTableName)
		ipairs(btnTableName)[1] = "Button_wallBurnning"
		ipairs(btnTableName)[2] = "Button_watchTower"
		ipairs(btnTableName)[3] = "Button_watchTowerInWar"
		ipairs(btnTableName)[4] = "Button_legendInvite"
		ipairs(btnTableName)[5] = "Button_kingStarInvite"
		ipairs(btnTableName)[6] = "Button_radiance"
		ipairs(btnTableName)[7] = "btnHelpAll"
		ipairs(btnTableName)[8] = "Button_account"
		ipairs(btnTableName)[9] = "luckyBless"
		ipairs(btnTableName)[10] = "Button_moveLineSwitch"
		ipairs(btnTableName)[11] = "Button_meteorite_skill"
		ipairs(btnTableName)[12] = "Button_invite12"
		local ipairs(btnTableName)[13], btnTableName = "Button_invite13", ipairs(btnTableName)
		local hCount = 4
		local cellW, cellH = 95, 90
		local luckyOffset = 35
		local index = 0
		local showLuckyBless = false
		for _, v in ipairs(btnTableName) do
			local btn = self.fields[v]
			if btn and btn:isVisible() then
				if v == "luckyBless" then
					showLuckyBless = true
				else
					index = index + 1
					local row = (index - 1) % hCount + 1
					local col = math.ceil(index / hCount)
					local realPosx = isRA and basePosx - (col - 1) * cellW or basePosx + (col - 1) * cellW
					local realPosy = basePosy - (row - 1) * cellH
					btn:setPosition(realPosx, realPosy)
				end
			end
		end
		if showLuckyBless then
			local luckyCol = index == 0 and 1 or math.ceil(index / hCount) + 1
			local luckyPosx = isRA and basePosx - (luckyCol - 1) * cellW or basePosx + (luckyCol - 1) * cellW
			self.fields.luckyBless:setPosition(luckyPosx + luckyOffset, basePosy + luckyOffset)
		end
	end
end
function mainUIBottom:initStyle()
	self.fields.Node_area_b:initStyle()
end
function mainUIBottom:setAllianceRed()
	if self.isInGuideStep then
		return
	end
	if worldMapDefine.isInNebulaAllStar() then
		self:getAreaBTarget("Button_alliance"):setRed(0)
		return
	end
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local allianceTreasureCtrl = gametop.playertop_:getModule("allianceTreasureCtrl")
	local allianceActiveCtrl = gametop.playertop_:getModule("allianceActiveCtrl")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local allianceCount = kingdomMapCtrl:getHallWarCount()
	if not worldMapDefine.isInWarForbid(true) and not worldMapDefine.isInLegendLord() then
		local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
		local allianceCounterSysCtrl = gametop.playertop_:getModule("allianceCounterSysCtrl")
		local allianceDesRead = include("allianceDesRead")
		if allianceDesRead.checkRank(gAllianceRank.R4) then
			allianceCount = allianceCount + allianceRelationCtrl:getAllyInviteNum()
		end
		local counterSysCount = allianceCounterSysCtrl:getNewPoint()
		local mineNum = allianceTreasureCtrl:getDigRewardCount()
		local helpNum = allianceTreasureCtrl:getHelpRewardCount()
		local playerMobilizationCtrl = gametop.playertop_:getModule("playerMobilizationCtrl")
		local hasActived = playerMobilizationCtrl:isHaveActived()
		local allianceHuntCtrl = gametop.playertop_:getModule("allianceHuntCtrl")
		local hasChallengeTimes = allianceHuntCtrl:getCheckChanllengeTimes()
		local activeNum = allianceMgr:hasJoinAlliance() and allianceActiveCtrl:getCanReceiveTaskNum() or 0
		allianceCount = allianceCount + mineNum + hasActived + hasChallengeTimes + helpNum + counterSysCount + activeNum
		local rewardsCount = SoraDGetCtrl("allianceScience"):getProsperityRewardsCount()
		if 0 < rewardsCount then
			allianceCount = allianceCount + 1
		end
		if allianceGuideCtrl:isShowEnterPoint() then
			allianceCount = allianceCount + 1
		end
	end
	if worldMapDefine.isInLegendLord() then
		local legendTeamCtrl = gametop.playertop_:getModule("legendTeamCtrl")
		local isTeamApproval = legendTeamCtrl:isTeamHasApproval()
		if isTeamApproval then
			allianceCount = allianceCount + 1
		end
		local kingStarTeamCtrl = gametop.playertop_:getModule("kingStarTeamCtrl")
		local isTeamApproval = kingStarTeamCtrl:isTeamHasApproval()
		if isTeamApproval then
			allianceCount = allianceCount + 1
		end
	elseif not worldMapDefine.isInRemains() then
		local allianceHelp = gametop.playertop_:getModule("allianceHelp")
		local allianceTerritoryAPI = include("allianceTerritoryAPI")
		allianceCount = allianceCount + #allianceHelp:getHelpList().otherhelplist
		allianceCount = allianceCount + allianceTerritoryAPI:getWellDestroyBuildingNum()
	end
	if worldMapDefine.isInAtlantis() or worldMapDefine.isInSimulatedDrill() then
		allianceCount = kingdomMapCtrl:getHallWarCount()
	end
	self:getAreaBTarget("Button_alliance"):setRed(allianceCount)
	self:showAllianceEffect()
end
function mainUIBottom:setMailRed()
	if not self.isInGuideStep then
		self:getAreaBTarget("Button_mail"):setRed(mailMgr:getNewMailNum() or 0)
	end
end
function mainUIBottom:setItemsRed()
	if not self.isInGuideStep then
		local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
		local itemsCount = backpackCtrl:getNewItemTotal() or 0
		local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
		local isNew = shopltCtrl:getShopNewTag("all")
		self:getAreaBTarget("Button_items"):setNewVisible(isNew)
		self:getAreaBTarget("Button_items"):setRed(isNew and 0 or itemsCount)
	end
end
function mainUIBottom:updateShopNewTag()
	local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
	local isNew = shopltCtrl:getShopNewTag("all")
	self:getAreaBTarget("Button_items"):setNewVisible(isNew)
	if isNew then
		self:getAreaBTarget("Button_items"):setRed(0)
	end
end
function mainUIBottom:setHeroRed()
	if not self.isInGuideStep then
		self:getAreaBTarget("Button_hero"):setRed(heroltCtrl:getHeroBottomPointNum())
	end
end
function mainUIBottom:initGreenPoint(target, data)
	if target == nil then
		self:initGreenPoint_imp()
	elseif self.isInitGreenPointDone then
		self.isInitGreenPointDone = false
		SoraDDelayCallOnce("initGreenPoint", handler(self, self.initGreenPoint_imp), 0.1)
	end
end
function mainUIBottom:initGreenPoint_imp()
	self.isInitGreenPointDone = true
	self:setAllianceRed()
	self:setMailRed()
	self:setItemsRed()
	self:setHeroRed()
end
function mainUIBottom:showAllianceEffect()
	if worldMapDefine.isInNebulaAllStar() then
		self:getAreaBTarget("Button_alliance"):isShowJoinGold(false)
		self:getAreaBTarget("Button_alliance"):isShowInWar(false)
		return
	end
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local ownmember = memberMgr:getOwnMember()
	if not worldMapDefine.inInCrossWar() and ownmember:getProperty("isfirstjoin") and not allianceMgr:hasJoinAlliance(true) then
		self:getAreaBTarget("Button_alliance"):isShowJoinGold(true)
	else
		self:getAreaBTarget("Button_alliance"):isShowJoinGold(false)
	end
	if allianceMgr:hasJoinAlliance(true) then
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		local hallWarCount = kingdomMapCtrl:getHallWarCount()
		self:getAreaBTarget("Button_alliance"):isShowInWar(0 < hallWarCount)
	else
		self:getAreaBTarget("Button_alliance"):isShowInWar(false)
	end
end
function mainUIBottom:RemovefirstJoinAllianceAnimation()
	self:getAreaBTarget("Button_alliance"):isShowJoinGold(false)
	local allianceCtrl = gametop.playertop_:getModule("allianceCtrl")
	allianceCtrl:resetAllianceInvitePopInfo()
	self:initAllianceInvitePop()
	self:setAllianceRed()
	userSDKManager.report2firebase("jointAlliance")
end
function mainUIBottom:showOrHideGuideView()
	self.isInGuideStep = false
	local unlockSwitchLv = funUnlockRead.getUnlockLevel(gFunBuildKey.FUN_OPEN_PREVIEW)
	local unlockTaskLv = funUnlockRead.getUnlockLevel(gFunBuildKey.TASK)
	local unlockChapterLv = funUnlockRead.getUnlockLevel(gFunBuildKey.CHAPTER_TASK)
	self.fields.Button_skill:setVisible(true)
	self:updateBtnSkillStatues()
	self.fields.questGuideNode:setVisible(self.viewChangeType == VIEW_TYPE_CITY and unlockChapterLv <= SoraDGetCastleLv())
	self.fields.Button_quest:setVisible(self.viewChangeType == VIEW_TYPE_CITY and unlockTaskLv <= SoraDGetCastleLv())
	self.fields.switch:updateContainer()
	self:isShowEmptyModel(false)
end
function mainUIBottom:isShowEmptyModel(ret)
	self:getAreaBTarget("chatMainUI"):isHideContent(ret)
	self:getAreaBTarget("Button_alliance"):isEmptyModel(ret)
	self:getAreaBTarget("Button_mail"):isEmptyModel(ret)
	self:getAreaBTarget("Button_items"):isEmptyModel(ret)
	self:getAreaBTarget("Button_hero"):isEmptyModel(false)
end
function mainUIBottom:showPrinceGiftGuideView()
	cityBuildFunction:checkPopUnlockPrinceGift()
end
function mainUIBottom:showSinbadPopWindow()
	cityBuildFunction:checkPopUpSinbadTreasure()
end
function mainUIBottom:reLoginFinish(target, redata)
	print("断线重连啦！")
	self:createExpostulationTimer()
	self:initBtnsStatus()
	self:initAccountBind()
	self:getAreaBTarget("chatMainUI"):initWithData()
	self:initGreenPoint()
	self:updateQuest()
	self:checkWatchTower()
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	kingdomMapCtrl:reLoginFinish()
	self:checkWallDefend()
	self:showLuckyBless()
	self:req4AllianceInviteData()
	self:checkRemainsWar()
	self:msgInvitedInfo_legend()
	self:updateGreenPointRadianceWar()
	self:initHelpAllBtn()
	self:updateItemsBtn()
	self:checkMeteoriteSkillBtn()
	self.fields.switch:clearChildren()
	self:updateSwitchBtns()
	self:showOrHideGuideView()
	self:checkBackMoney()
end
function mainUIBottom:msgHegemonClean()
	self:btnHegemonManagerCheck()
	self:btnHegemonBattleCheck()
end
function mainUIBottom:showLuckyBless()
	local luckyBlessCtrl = gametop.playertop_:getModule("luckyBlessCtrl")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local guideCtrl = gametop.playertop_:getModule("guideCtrl")
	local guideStep = guideCtrl:getCurForceGuideStep()
	if (luckyBlessCtrl:getLeftActivateCount() > 0 or luckyBlessCtrl:getLuckyBlessStatus() == 2) and activityShowCtrl:isActivityOpen(gActivityTimeActivityID.LUCKY_BLESSING_ACTIVITY) then
		if self.viewChangeType == VIEW_TYPE_CITY and SoraDIsGameGuide() == nil and not guideStep then
			self.fields.luckyBless:setVisible(true)
			self.fields.luckyBless:clearContent()
			local luckyBlessNode = include("effectMainUITop").luckyBlessShow(luckyBlessCtrl:getCurEffectType())
			luckyBlessNode:setPosition(50, -50)
			self.fields.luckyBless:setSwallowTouches(false)
			self.fields.luckyBless:setContent(luckyBlessNode)
		else
			self.fields.luckyBless:setVisible(false)
		end
	else
		self.fields.luckyBless:setVisible(false)
	end
	self:sortBottomQuestBtns()
end
function mainUIBottom:serverMessageGetLordInfo(target, data)
	if data.clientData and data.lord then
		local targetName = data.clientData.targetName
		if targetName == "AllianceInvitePop" or targetName == "atlantisMemberSingle" then
			SoraDOpenLordView(data.lord)
		end
	end
end
function mainUIBottom:recevieGuideMsg(target, data)
	self.fields.Panel_AllianceInvitePop:setVisible(false)
end
function mainUIBottom:serverMessageGetAllianceInfo(target, data)
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "AllianceInvitePop" then
			SoraDOpenAllianceInfoView(alliance, alliance:getProperty("sourceKid"))
		end
	end
end
function mainUIBottom:req4AllianceInviteData()
	local allianceCtrl = gametop.playertop_:getModule("allianceCtrl")
	allianceCtrl:req4AllianceInviteData()
end
function mainUIBottom:initAllianceInvitePop()
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local allianceCtrl = gametop.playertop_:getModule("allianceCtrl")
	local allianceInviteData = allianceCtrl:getAllianceInvitePopInfo()
	if not worldMapDefine.inInCrossWar() and not allianceMgr:hasJoinAlliance() and next(allianceInviteData) and SoraDIsGameGuide() == nil then
		self.fields.Panel_AllianceInvitePop:setVisible(true)
		self.fields.Panel_AllianceInvitePop:initData(allianceInviteData)
	else
		self.fields.Panel_AllianceInvitePop:setVisible(false)
	end
end
function mainUIBottom:updateCrazyTrioButton(target, data)
	if data and data.msg == "MESSAGE_CUMUACTIVITY_CRAZYTRIO_SHOWDOWN" then
		self:addCrazyTrioButton()
	end
end
function mainUIBottom:updateLordInfoBase()
end
function mainUIBottom:transferToSelfKingdom()
end
function mainUIBottom:checkInWar()
	return worldMapDefine.inInCrossWar()
end
function mainUIBottom:recevieItemChangeMsg(target, redata)
	if redata and redata.itemType and gItemType.HERO_CHIP == redata.itemType then
		_ENV = redata.itemType
		redata.itemType.msg = "MESSAGE_GREEN_POINT_UPDATE"
		SoraDSendMessage(redata.itemType)
	end
end
function mainUIBottom:updateGreenPointRadianceWar()
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local activityStatus = activityShowCtrl:getStateByID(gActivityTimeActivityID.RADIANCE_WAR_ACTIVITY)
	if gActivityState.OPEN == activityStatus then
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		local num = kingdomMapCtrl:getHallWarCount(true)
		local isRed = 0 < num
		self.fields.Button_radiance:setVisible(isRed)
		if isRed then
			if self.fields.Button_radiance:isShowRed() ~= isRed then
				self.fields.Button_radiance:setRed(num)
				self.fields.Button_radiance:setShowType(isRed and 1 or 0)
			end
		else
			self.fields.Button_radiance:setRed(0)
		end
		_ENV = 0
		;(0).byUID = true
		local openWarning = SoraDConfigGet("Game:radianceWar:openWarning~bool", 0)
		_ENV = 0
		;(0).msg = "MESSAGE_MAINSCEN_WARNING_UPDATE"
		;(0).isVisible = openWarning and isRed
		;(0).sType = 1
		SoraDSendMessage(0)
	else
		self.fields.Button_radiance:setVisible(false)
	end
	self:sortBottomQuestBtns()
end
function mainUIBottom:showLongTimeUnlogin()
	_ENV = nil
	;(nil).canNotClose = true
	SoraDShowMsgBox(i18n("brightWar_text_155"), i18n("common_text_054"), nil, nil, nil)
end
function mainUIBottom:checkWatchTower(target, data)
	if target == nil then
		self:checkWatchTower_imp()
	elseif self.isCheckWatchTowerDone then
		self.isCheckWatchTowerDone = false
		SoraDDelayCallOnce("checkWatchTower", handler(self, self.checkWatchTower_imp), 0.1)
	end
end
function mainUIBottom:checkWatchTower_imp()
	self.isCheckWatchTowerDone = true
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local red, blue, frm, roman = kingdomMapCtrl:getWatchTowerLightInfo()
	local isIgnoreRomanSoul = kingdomMapCtrl:getWatchTowerQueue():isIgnoreRomanSoul()
	local sType = 0
	local isShow = false
	if 0 < red then
		sType = 0
		isShow = true
		self.fields.Button_watchTower:setShowType(0)
		gametop = self.fields.Button_watchTower
		self.fields.Button_watchTower.msg = "MESSAGE_MAINSCEN_WARNING_UPDATE"
		self.fields.Button_watchTower.isVisible = 0 < frm
		self.fields.Button_watchTower.sType = sType
		SoraDSendMessage(self.fields.Button_watchTower)
	elseif 0 < blue then
		sType = 1
		isShow = true
		self.fields.Button_watchTower:setShowType(1)
		gametop = self.fields.Button_watchTower
		self.fields.Button_watchTower.msg = "MESSAGE_MAINSCEN_WARNING_UPDATE"
		self.fields.Button_watchTower.isVisible = 0 < frm
		self.fields.Button_watchTower.sType = sType
		SoraDSendMessage(self.fields.Button_watchTower)
	elseif 0 < roman then
		sType = 0
		if not isIgnoreRomanSoul and 0 < frm then
			gametop = self.fields.Button_watchTower
			self.fields.Button_watchTower.msg = "MESSAGE_MAINSCEN_WARNING_UPDATE"
			self.fields.Button_watchTower.isVisible = true
			self.fields.Button_watchTower.sType = sType
			SoraDSendMessage(self.fields.Button_watchTower)
		else
			gametop = self.fields.Button_watchTower
			self.fields.Button_watchTower.msg = "MESSAGE_MAINSCEN_WARNING_UPDATE"
			self.fields.Button_watchTower.isVisible = false
			self.fields.Button_watchTower.sType = sType
			SoraDSendMessage(self.fields.Button_watchTower)
		end
	else
		isShow = false
		gametop = self.fields.Button_watchTower
		self.fields.Button_watchTower.msg = "MESSAGE_MAINSCEN_WARNING_UPDATE"
		self.fields.Button_watchTower.isVisible = false
		self.fields.Button_watchTower.sType = sType
		SoraDSendMessage(self.fields.Button_watchTower)
	end
	print("mainUIBottom:checkWatchTower======", isShow, red, blue, frm, roman)
	self.fields.Button_watchTower:setVisible(isShow)
	if worldMapDefine.isInRoaringFlame() then
		local red, blue, frm, roman = kingdomMapCtrl:getWatchTowerQueue(true):getWatchTowerLightInfo()
		local isShow = false
		if 0 < red then
			isShow = true
			gametop = roman
			roman.msg = "MESSAGE_MAINSCEN_WARNING_UPDATE"
			roman.isVisible = 0 < frm
			roman.sType = 0
			SoraDSendMessage(roman)
		else
			gametop = roman
			roman.msg = "MESSAGE_MAINSCEN_WARNING_UPDATE"
			roman.isVisible = false
			roman.sType = 0
			SoraDSendMessage(roman)
		end
		self:initButtonWatchTowerInWar()
		self.fields.Button_watchTowerInWar:setVisible(isShow)
	elseif self.fields.Button_watchTowerInWar then
		self.fields.Button_watchTowerInWar:setVisible(false)
	end
	self:sortBottomQuestBtns()
end
function mainUIBottom:checkMoveLineSwitch(target, data)
	if self.fields.Button_moveLineSwitch:updateSwitch(data, self.viewChangeType == VIEW_TYPE_MAP) then
		self:sortBottomQuestBtns()
	end
end
function mainUIBottom:checkWarBarrageSetting(target, data)
	local targetKClass = gKingdomClassType.normal
	for kClass, v in pairs(worldMapDefine.warBarrageCfg) do
		local barrageCfg = worldMapDefine.getBarrageCfg(kClass)
		if barrageCfg.showCondition() then
			targetKClass = kClass
		end
	end
	local barrageCfg = worldMapDefine.getBarrageCfg(targetKClass)
	self.fields.Button_barrageSet:setVisible(barrageCfg.showCondition() and self.viewChangeType == VIEW_TYPE_MAP)
	self:sortBottomQuestBtns()
end
function mainUIBottom:getBtnTarget(id)
	return self.fields["Button_" .. id]
end
function mainUIBottom:getTarget(name)
	return self.fields[name]
end
function mainUIBottom:getSwitchTarget(name)
	return self.fields.switch:gameGuide_getTarget(name)
end
function mainUIBottom:OnWorldCityClick()
	SoraDPlaySound()
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.WORLD_CITY)
	if unlockLv <= SoraDGetCastleLv() then
		if self.viewChangeType == VIEW_TYPE_CITY then
			local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
			if nebulaAllStarCtrl:getIsViewer() then
				local nebulaAllStarUtil = include("nebulaAllStarUtil")
				nebulaAllStarUtil.gotoViewerWorldMap()
				return
			end
			self.viewChangeType = VIEW_TYPE_MAP
			_ENV = nebulaAllStarUtil.gotoViewerWorldMap
			nebulaAllStarUtil.gotoViewerWorldMap.msg = "MESSAGE_MAINCITYVIEW_SAVE_MAIN_CITY_POS"
			SoraDSendMessage(nebulaAllStarUtil.gotoViewerWorldMap)
			_ENV = nebulaAllStarUtil.gotoViewerWorldMap
			nebulaAllStarUtil.gotoViewerWorldMap.msg = "MESSAGE_MAINCITYVIEW_LEAVE_MOVE_MODE"
			SoraDSendMessage(nebulaAllStarUtil.gotoViewerWorldMap)
			gReGetWorldMapTroopDataCount = 0
		else
			self.viewChangeType = VIEW_TYPE_CITY
		end
		self:getAreaBTarget("Button_worldCity"):setViewType(self.viewChangeType - 1)
		_ENV = self:getAreaBTarget("Button_worldCity")
		self:getAreaBTarget("Button_worldCity").msg = "MESSAGE_MAINSCEN_ONSHOW"
		self:getAreaBTarget("Button_worldCity").viewType = self.viewChangeType
		self:getAreaBTarget("Button_worldCity").isBottom = GAME_SWITCH_MODE
		SoraDSendMessage((self:getAreaBTarget("Button_worldCity")))
	else
		_ENV = nil
		;(nil).name = i18n("common_text_528")
		;(nil).lv = unlockLv
		SoraDShowMsgTip(i18n("common_text_2122", nil))
	end
end
function mainUIBottom:OnSkillClick()
	SoraDPlaySound("uicontrol", 13)
	_ENV = "uicontrol"
	;("uicontrol").msg = "MESSAGE_MAINCITYVIEW_LEAVE_MOVE_MODE"
	SoraDSendMessage("uicontrol")
	uiManager:show("skillNewActiveView")
end
function mainUIBottom:OnMeteoriteSkillClick()
	SoraDPlaySound("uicontrol", 13)
	_ENV = "uicontrol"
	;("uicontrol").msg = "MESSAGE_MAINCITYVIEW_LEAVE_MOVE_MODE"
	SoraDSendMessage("uicontrol")
	uiManager:show("MeteoriteSkill")
end
function mainUIBottom:checkWallDefend()
	local wallsCtrl = gametop.playertop_:getModule("wallsCtrl")
	local burnningTime = wallsCtrl:getBurningTime()
	if self.viewChangeType == VIEW_TYPE_CITY then
		if 0 < burnningTime then
			self.fields.Button_wallBurnning:setVisible(true)
			local worldMapDefine = include("worldMapDefine")
			local isInWar = worldMapDefine.isInPyramid()
			self.fields.Button_wallBurnning:setShowType(isInWar and 1 or 0)
		else
			self.fields.Button_wallBurnning:setVisible(false)
		end
	else
		self.fields.Button_wallBurnning:setVisible(false)
	end
	self:sortBottomQuestBtns()
end
function mainUIBottom:initHelpAllBtn()
	if self.viewChangeType ~= VIEW_TYPE_CITY then
		self.fields.btnHelpAll:setVisible(false)
		self:sortBottomQuestBtns()
		return
	end
	local allianceHelp = SoraDGetCtrl("allianceHelp")
	if allianceHelp:getIsCanHelp() then
		self.fields.btnHelpAll:setVisible(true)
		local helpCount = #allianceHelp:getHelpList().otherhelplist
		self.fields.btnHelpAll:setRed(helpCount)
	else
		self.fields.btnHelpAll:setVisible(false)
	end
	self:sortBottomQuestBtns()
end
function mainUIBottom:getEventCenterReturn(target, redata)
	self:showLuckyBless()
	if type(redata.activityID) == "table" then
		for _, v in pairs(redata.activityID) do
			self:getEventCenterReturn_imp(v)
		end
	elseif type(redata.activityID) == "number" then
		self:getEventCenterReturn_imp(redata.activityID)
	end
	self:initBattleOpenBtn()
end
function mainUIBottom:getEventCenterReturn_imp(activityID)
	if gActivityTimeActivityID.LIMITED_DISCOUNT_ACTIVITY == activityID then
		self:updateItemsBtn()
	elseif gActivityTimeActivityID.ALLIANCE_MOBILIZATION_ACTIVITY == activityID then
		self:setAllianceRed()
	elseif gActivityTimeActivityID.COMMUNITY_CENTER_MAIN_UI == activityID then
		self:updateCommunityButton()
	elseif gActivityCenterUIEnum.LEGEND_HEGEMON == activityID then
		self:btnHegemonBattleCheck()
	elseif gActivityTimeActivityID.PREDOWNLOAD_REWARD_ACTIVITY == activityID then
		self:checkPreDownload()
		self:checkPreDownloadStatus()
	elseif SoraDGetCtrl("activity_9001566_Ctrl"):isItemRebateActivityID(activityID) then
		self:addButtonActivity9001566()
	else
		self:addHarvestSeasonButton()
	end
	for activityID, v in pairs(mainUIDef.activityCfg) do
		self.fields.switch:addSwitchActivityBtn(activityID)
	end
end
function mainUIBottom:updateItemsBtn()
	local allianceDesRead = include("allianceDesRead")
	local limitTimeDiscountShopAPI = include("limitTimeDiscountShopAPI")
	local status, remainTime = limitTimeDiscountShopAPI:getActivityInfo()
	if status and not allianceDesRead.getPlayerConquestWarMigration(false) and not allianceDesRead.getPlayerBattleGroundMigration(false) then
		self:getAreaBTarget("Button_items"):isShowDiscount(true)
	else
		self:getAreaBTarget("Button_items"):isShowDiscount(false)
	end
end
function mainUIBottom:updateBtnSkillStatues()
	local lordLevel = lordInfoCtrl:getLordLevel()
	self.fields.Button_skill:setVisible(4 <= lordLevel)
end
function mainUIBottom:checkPreDownload()
	local preDownloadUtil = include("preDownloadUtil")
	preDownloadUtil.checkPreDownloadAutoStart()
end
function mainUIBottom:OnPreDownloadSuc()
	local preDownloadUtil = include("preDownloadUtil")
	preDownloadUtil.checkSendPredownloadOk()
end
function mainUIBottom:checkRemainsWar()
	local worldMapWarDef = include("worldMapWarDef")
	local btnName = worldMapWarDef.getBtnAllianceTitle()
	self:getAreaBTarget("Button_alliance"):setBtnName(btnName)
end
function mainUIBottom:msgInvitedInfo_legend()
	local legendTeamCtrl = gametop.playertop_:getModule("legendTeamCtrl")
	local hasInvite = legendTeamCtrl:isHasInvitedInfo()
	self.fields.Button_legendInvite:setVisible(hasInvite)
	if hasInvite then
		if not legendTeamCtrl:getInvitedInfo() then
			local gametop, inviteList = legendTeamCtrl:getInvitedInfo(), legendTeamCtrl:getInvitedInfo()
		end
		self.fields.Button_legendInvite:setRed(#inviteList)
	else
		self.fields.Button_legendInvite:setRed(0)
	end
	local kingStarTeamCtrl = gametop.playertop_:getModule("kingStarTeamCtrl")
	local hasInvite = kingStarTeamCtrl:isHasInvitedInfo()
	self.fields.Button_kingStarInvite:setVisible(hasInvite)
	if hasInvite then
		if not kingStarTeamCtrl:getInvitedInfo() then
			local gametop, inviteList = kingStarTeamCtrl:getInvitedInfo(), kingStarTeamCtrl:getInvitedInfo()
		end
		self.fields.Button_kingStarInvite:setRed(#inviteList)
	else
		self.fields.Button_kingStarInvite:setRed(0)
	end
	self.fields.Button_invite12:updateTeamInvitedInfo()
	local nebulaAllStarUtil = include("nebulaAllStarUtil")
	if nebulaAllStarUtil.checkShowInviteState() then
		self.fields.Button_invite13:updateTeamInvitedInfo()
	else
		self.fields.Button_invite13:setVisible(false)
	end
	self:sortBottomQuestBtns()
end
function mainUIBottom:openReportMail(target, data)
	SoraDCloseLoading()
	if data.mail == nil then
		local msgNotice = include("msgNotice")
		msgNotice.notice("common_text_1382")
		return
	end
	local panel = SoraDCreatePanel("mailItemDetailView")
	panel:show()
	panel:hideRightAndLeftBtn()
	panel:initWithData(data.mail, "key", data.senderId)
end
function mainUIBottom:checkMeteoriteSkillBtn()
	local meteorMagicCtrl = SoraDGetCtrl("meteorMagicCtrl")
	local isShowBtn, isShowEffect = meteorMagicCtrl:isShowSkillBtn()
	self.fields.Button_meteorite_skill:setVisible(isShowBtn)
	if isShowBtn then
		fguiHelper.get_fields(self.fields.Button_meteorite_skill).effect:setVisible(isShowEffect)
	end
	if isShowBtn then
		local ani = fguiHelper.get_fields(self.fields.Button_meteorite_skill).effect
		ani:setAllFrameName("dh_monengrk_%02d.png", 0)
		ani:setPlaySettings(0, -1, -1)
	end
	self:sortBottomQuestBtns()
end
function mainUIBottom:checkBackMoney()
	local payBackCtrl = SoraDGetCtrl("payBackCtrl")
	local price = payBackCtrl:getPrice()
	if 0 < price then
		uiManager:show("BackMoneyPopView")
	end
end
function mainUIBottom:currentShowViewType(target, data)
	self.viewChangeType = data.viewType
	if self.viewChangeType == VIEW_TYPE_CITY then
		local unlockChapterLv = funUnlockRead.getUnlockLevel(gFunBuildKey.CHAPTER_TASK)
		self.fields.questGuideNode:setVisible(unlockChapterLv <= SoraDGetCastleLv())
		local unlockTaskLv = funUnlockRead.getUnlockLevel(gFunBuildKey.TASK)
		self.fields.Button_quest:setVisible(unlockTaskLv <= SoraDGetCastleLv())
		self:createExpostulationTimer()
		self:initAccountBind()
		self:showOrHideGuideView()
	else
		self.fields.questGuideNode:setVisible(false)
		self.fields.Button_quest:setVisible(false)
		self:deleteExpostulationTimer()
		self.fields.Button_account:setVisible(false)
	end
	self:getAreaBTarget("Button_worldCity"):setViewType(self.viewChangeType - 1)
	self:showLuckyBless()
	self:checkWallDefend()
	self:checkWatchTower()
	self:initHelpAllBtn()
	self:sortBottomQuestBtns()
	self:checkRemainsWar()
	self:updateNebulaAllStarUIBottom()
	self:checkMoveLineSwitch()
	self:checkWarBarrageSetting()
end
function mainUIBottom:onHide()
	gChatMgrs:clean()
	userSDKManager:setAudioTarget(nil)
	local cityBuildFunction = include("cityBuildFunction")
	cityBuildFunction:removeAll()
	local cityBuildData = include("cityBuildData")
	cityBuildData:removeAll()
end
function mainUIBottom:getLodNode()
	return self.fields.Node_LOD
end
function mainUIBottom:getNodeAreaBottom()
	return self.fields.Node_area_b
end
function mainUIBottom:getTarget(name)
	return self.fields[name]
end
function mainUIBottom:setGuideContorller(index)
	self.controllers.guide:setSelectedIndex(1 <= index and 1 or 0)
	self.fields.Node_area_b:setGuideContorller(index)
end
function mainUIBottom:updateNebulaAllStarUIBottom()
	if worldMapDefine.isInNebulaAllStar(true) then
		if not self.nebulaAllStarUIBottom then
			self.fields.nebulaAllStarUIBottom:fixPos()
			local obj = fgui.UIPackage:createObject("MainUI", "nebulaAllStarUIBottom")
			obj:addTo(self.fields.nebulaAllStarUIBottom)
			obj:setName("nebulaAllStarUIBottom")
			obj:setPosition(cc.p(0, -10))
			self.nebulaAllStarUIBottom = obj
		end
		self.nebulaAllStarUIBottom:setVisible(self.viewChangeType ~= VIEW_TYPE_CITY)
		self.nebulaAllStarUIBottom:initData()
	elseif self.nebulaAllStarUIBottom then
		self.nebulaAllStarUIBottom:setVisible(false)
	end
end
function mainUIBottom:updateSwitchBtns(...)
	self:btnPyramidBattleCheck()
	self:btnCityUnlockCheck()
	self:btnNewPlayerBuffCheck()
	self:addPrinceGiftNewBuffButton()
	self:addPrinceGiftBuffButton()
	self:btnKingdomManagerCheck()
	self:btnLegendKingManagerCheck()
	self:btnHegemonManagerCheck()
	self:btnHegemonBattleCheck()
	self:checkRomanSoul()
	self:updateBtnLuckyRecharge()
	local sourceKid = lordInfoCtrl:getLordInfo().base.sourceKid
	if sourceKid and sourceKid == 0 then
		self:addGoldPackageButton()
	end
	self:updateMonthCardButton()
	self:addCrazyTrioButton()
	self:updateCommunityButton()
	self:addHarvestSeasonButton()
	self:btnPayBackCheck()
	self:checkPreDownload()
	self:checkPreDownloadStatus()
	self:initBattleOpenBtn()
	self:btnCommandHallChek()
	self:addButtonActivity9001566()
	self:addButtonDJ()
	for activityID, v in pairs(mainUIDef.activityCfg) do
		self.fields.switch:addSwitchActivityBtn(activityID)
	end
	self:checkMoveLineSwitch()
	self:checkWarBarrageSetting()
end
function mainUIBottom:btnPyramidBattleCheck()
	self.fields.switch:btnPyramidBattleCheck()
end
function mainUIBottom:btnCityUnlockCheck()
	self.fields.switch:btnCityUnlockCheck()
end
function mainUIBottom:btnNewPlayerBuffCheck()
	self.fields.switch:btnNewPlayerBuffCheck()
end
function mainUIBottom:addPrinceGiftNewBuffButton(target, data)
	self.fields.switch:addPrinceGiftNewBuffButton(target, data)
end
function mainUIBottom:addPrinceGiftBuffButton(target, data)
	self.fields.switch:addPrinceGiftBuffButton(target, data)
end
function mainUIBottom:btnKingdomManagerCheck()
	self.fields.switch:btnKingdomManagerCheck()
end
function mainUIBottom:btnLegendKingManagerCheck()
	self.fields.switch:btnLegendKingManagerCheck()
	self:btnKingStarManagerCheck()
end
function mainUIBottom:btnHegemonManagerCheck()
	self.fields.switch:btnHegemonManagerCheck()
end
function mainUIBottom:btnHegemonBattleCheck()
	self.fields.switch:btnHegemonBattleCheck()
end
function mainUIBottom:checkRomanSoul()
	local isRomanEvent = self.fields.switch:checkRomanSoul()
	if not isRomanEvent then
		self:checkWatchTower()
	end
end
function mainUIBottom:startRecordScreen()
	self.fields.switch:startRecordScreen()
end
function mainUIBottom:stopRecording()
	self.fields.switch:stopRecording()
end
function mainUIBottom:updateBtnLuckyRecharge()
	self.fields.switch:updateBtnLuckyRecharge()
end
function mainUIBottom:addGoldPackageButton()
	self.fields.switch:addGoldPackageButton()
end
function mainUIBottom:updateMonthCardButton()
	self.fields.switch:updateMonthCardButton()
end
function mainUIBottom:addCrazyTrioButton()
	self.fields.switch:addCrazyTrioButton()
end
function mainUIBottom:updateCommunityButton()
	self.fields.switch:updateCommunityButton()
end
function mainUIBottom:addHarvestSeasonButton()
	self.fields.switch:addHarvestSeasonButton()
end
function mainUIBottom:updateQuestionnaireButton()
	self.fields.switch:updateQuestionnaireButton()
end
function mainUIBottom:btnPayBackCheck()
	self.fields.switch:btnPayBackCheck()
end
function mainUIBottom:checkPreDownloadStatus()
	self.fields.switch:checkPreDownloadStatus()
end
function mainUIBottom:initBattleOpenBtn()
	self:refreshBattleOpenBtn()
end
function mainUIBottom:refreshBattleOpenBtn(...)
	self.fields.switch:refreshBattleOpenBtn(...)
end
function mainUIBottom:addEightButton(...)
	self.fields.switch:addEightButton(...)
end
function mainUIBottom:btnKingStarManagerCheck(...)
	self.fields.switch:btnKingStarManagerCheck(...)
end
function mainUIBottom:btnCommandHallChek(...)
	self.fields.switch:btnCommandHallChek(...)
end
function mainUIBottom:addButtonActivity9001566(...)
	self.fields.switch:addButtonActivity9001566(...)
end
function mainUIBottom:addButtonDJ(...)
	self.fields.switch:addButtonDJ(...)
end
function mainUIBottom:onMsgUpdateHeroNewTrial(target, event)
	local subMsg = event.subMsg
	if subMsg == "afkCliam" then
		self:setHeroRed()
	end
end
function mainUIBottom:onMsgUpdateActivity(target, event, activityID)
	self.fields.switch:addSwitchActivityBtn(activityID)
end
function mainUIBottom:initButtonWatchTowerInWar(...)
	if self.fields.Button_watchTowerInWar then
		return
	end
	local Button_watchTower = self.fields.Button_watchTower:clone()
	Button_watchTower:addTo(self)
	Button_watchTower:setName("Button_watchTowerInWar")
	Button_watchTower:setWarType(gKingdomClassType.roaringFlame)
	Button_watchTower:setShowType(0)
	Button_watchTower:setGroup(self.fields.Button_watchTower:getGroup())
	self.fields.Button_watchTowerInWar = Button_watchTower
end
return mainUIBottom
