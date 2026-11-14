local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local luckyGiftCtrl = SoraDGetCtrl("luckyGiftCtrl")
local cumuActiveCtrl = SoraDGetCtrl("cumuActiveCtrl")
local princeGiftNewCtrl = SoraDGetCtrl("princeGiftNewCtrl")
local castleRewardCtrl = SoraDGetCtrl("castleRewardCtrl")
local funUnlockRead = include("funUnlockRead")
local baseComponent = require("fgui.base.baseComponent")
local mainUITop = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/mainUITop", mainUITop)
function mainUITop:onInit()
	self.offsetY = 0
	self.isInitEventDone = true
	self.lordInfo, _ENV, self.currentViewType = VIEW_TYPE_CITY, VIEW_TYPE_CITY, VIEW_TYPE_CITY
	self.fields.Button_cheat:setTitleText("作弊")
	self.fields.Button_test:setTitleText("测试")
	self.fields.Button_cheat:addClickListener(handler(self, self.onBtnCheatClick))
	self.fields.Button_test:addClickListener(handler(self, self.onBtnTestClick))
	if device.platform == "mac" or userSDKManager.isBeta() or userSDKManager.isGameDevelop() then
		self.fields.Button_cheat:setVisible(true)
		self.fields.Button_test:setVisible(true)
	else
		self.fields.Button_cheat:setVisible(false)
		self.fields.Button_test:setVisible(false)
	end
	self.fields.btn_head:addClickListener(handler(self, self.onBtnHeadClick))
	self.fields.com_res:isRunAnimation(true)
	self.fields.com_res:hiddleMainUI(false)
	self.fields.com_gold:setUIModel(1)
	local isView = false
	self.rtFields = fguiHelper.get_fields(self.fields.Node_area_rt)
	local metatable = getmetatable(self.fields)
	local __index = metatable.__index
	function metatable.__index(t, k)
		local v = __index(t, k)
		v = v or self.rtFields[k]
		return v
	end
	self.fields.Node_recharge:setVisible(isView)
	self.fields.Node_rechargeLucky:setVisible(isView)
	self.fields.Node_event:setVisible(isView)
	self.fields.Node_newJourney:setVisible(isView)
	self.fields.Node_newServerBack:setVisible(isView)
	self.fields.Node_crazy:setVisible(isView)
	self.fields.Node_choiceLucky:setVisible(isView)
	self.fields.Node_kingCom:setVisible(isView)
	self.fields.Node_sultansBack:setVisible(isView)
	self.fields.Node_recruitment:setVisible(isView)
	self.fields.Node_activity9001605:setVisible(isView)
	self.fields.Node_activity9001614:setVisible(isView)
	self:getNodeLTTarget("btn_gameExplain"):setVisible(isView)
	self:getNodeLTTarget("btn_gameExplain"):addClickListener(handler(self, self.btnExplainClick))
	self.tableBuilder, _ENV = self:getNodeLTTarget("btn_gameExplain").addClickListener, self:getNodeLTTarget("btn_gameExplain").addClickListener
	self:getNodeLTTarget("builderIcon_iron"):setModel(0)
	self:getNodeLTTarget("builderIcon_iron"):initData(gQueueTypeDef.free_build_queue)
	self:getNodeLTTarget("builderIcon_gold"):setModel(1)
	self:getNodeLTTarget("builderIcon_gold"):initData(gQueueTypeDef.charge_build_queue)
	self.tableBuilder[1] = self:getNodeLTTarget("builderIcon_iron")
	self.tableBuilder[2] = self:getNodeLTTarget("builderIcon_gold")
	self:getNodeLTTarget("builderIcon_qh_free"):setVisible(false)
	self:getNodeLTTarget("builderIcon_qh_gold"):setVisible(false)
	self:getNodeLTTarget("troop"):setVisible(false)
	self.fields.Node_LostRuins:setVisible(false)
	self.fields.teamMainUIWidget:setVisible(false)
	self.fields.newTrialMainUI:setVisible(false)
	self.fields.windTowerMainWidget:setVisible(false)
	self.fields.remainsWarAttackWidget:setVisible(false)
	self.fields.Node_area_lt:fixPos()
end
function mainUITop:onShow()
	self:initData()
	self:initView()
end
function mainUITop:registerEvent()
	SoraDAddMessage(self, "MESSAGE_MONTHLY_CARD_REFRESH_BACK", handler(self, self.initRechargeBtn))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_LOGINFINSH", handler(self, self.reLoginFinish))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_ONSHOW", handler(self, self.setMarchingTroopsVisible))
	SoraDAddMessage(self, "MESSAGE_WAR_BARRAGE_VISIBLE", handler(self, self.setWarUIBarrageVisible))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_BASE", handler(self, self.updateLordInfo))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_PHYSICAL_RECOVERY", handler(self, self.updateLordInfo))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_MAINUITOP_EVENT_REFRESH", handler(self, self.refreshNodeEvent))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_LUCKYGIFTREFRESH", handler(self, self.initLuckyBtn))
	SoraDAddMessage(self, "MESSAGE_UI_EVENTCENTER_REFRESHISNEW", handler(self, self.initEventNode))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.initEventNode))
	SoraDAddMessage(self, "MESSAGE_GREEN_POINT_UPDATE", handler(self, self.initEventNode))
	SoraDAddMessage(self, "MESSAGE_CUMUACTIVITY_CRAZYTRIO_RELASH", handler(self, self.initCrazyBtn))
	SoraDAddMessage(self, "MESSAGE_HERO_GIFT_RECHARGE_REFRESH", handler(self, self.initHeroGiftBtn))
	SoraDAddMessage(self, "MESSAGE_SERVER_KING_COMPETITION_GET_REWARD_SUCCESS", handler(self, self.initKingNode))
	SoraDAddMessage(self, "MESSAGE_SULTANSBACK_SETTING_REFRESH", handler(self, self.initSultansBackNode))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001606_UPDATE", handler(self, self.initActivity9001605Btn))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001606_CANINVITE_UPDATE", handler(self, self.initActivity9001605Btn))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_TEAM_MSG", handler(self, self.updateNewTeamChat))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001614_UPDATE", handler(self, self.initActivity9001614Btn))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001711_UPDATE", handler(self, self.initActivity9001711Btn))
	SoraDAddMessage(self, "MESSAGE_MARKET_TRADEBOARDRETURN_MSGGETTIP", handler(self, self.tradeBoardMsgShowTip))
	SoraDAddMessage(self, "MESSAGE_SERVER_ESCORT_REQ_CLOSEST_BUILD", handler(self, self.handlEscort))
	SoraDAddMessage(self, "MESSAGE_UI_EQUIP_GET_SUCCESS", handler(self, self.getEquipSuccess))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_WEAR_BACK", handler(self, self.getEquipSuccess))
	SoraDAddMessage(self, "MESSAGE_EXCLUSIVE_VIP_BIRTHDAY_SET_BACK", handler(self, self.updateBirthdayYearReddot))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_DAILYFREEGIFT_REFRESH", handler(self, self.updateRechargeRedPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_DAILYSPECIALGIFTBUY_REFRESH", handler(self, self.updateRechargeRedPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_DAILYSPECIALGIFT_REFRESH", handler(self, self.updateRechargeRedPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.getEventCenterReturn))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_ACTIVETIMEOUT", handler(self, self.updateRechargeRedPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_WEEKLY_REFRESH", handler(self, self.updateRechargeRedPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_MONTHLY_REFRESH", handler(self, self.updateRechargeRedPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_TAKE_REFRESH", handler(self, self.updateRechargeRedPoint))
	SoraDAddMessage(self, "MESSAGE_LORDVALUE_VIP", handler(self, self.updateVip))
	SoraDAddMessage(self, "MESSAGE_LORDVALUE_VIP_GIFTREFRESH", handler(self, self.updateVip))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.updateNewDay))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_TEAM_INVITED_INFO", handler(self, self.msgInvitedInfo))
	SoraDAddMessage(self, "MESSAGE_CLIENT_RECHARGECENTER_LUCKYGIFTPOINTREFRESH", handler(self, self.luckyBtnPoint))
	SoraDAddMessage(self, "MESSAGE_WALLS_DEFENCE_DESTROY", handler(self, self.defineWallDestroy))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_KINGDOMBATTLE_VICTORY", handler(self, self.kingBattleFun))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_WAR_END", handler(self, self.legendLordBattleVectoryFun))
	SoraDAddMessage(self, "MESSAGE_MAIN_SERVERTIME_CALLBAK", handler(self, self.checkServerIsOK4SDKCallBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REFRESH", handler(self, self.rechargeCloseLoading))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDLORD_PERSONAL_RESULT", handler(self, self.endLegendLordWar))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_PERSONAL_RESULT", handler(self, self.endPyramid))
	SoraDAddMessage(self, "MESSAGE_UI_TEAM_MY_INFO", handler(self, self.updateTeamMainUIWidget))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_TEAM_MATCH_SUC", handler(self, self.onTeamMatchSuc))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_BATTLE_END", handler(self, self.onRemainsWarEnd))
	SoraDAddMessage(self, "MESSAGE_SERVER_RADIANCE_WAR_BATTLE_END", handler(self, self.onRadianceWarEnd))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_TEAM_JOIN", handler(self, self.onRemainsWarTeamJoin))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_ATTACK_INFO", handler(self, self.updateAttackInfo))
	SoraDAddMessage(self, "MESSAGE_UI_NEWTRIALMAINUI", handler(self, self.refreshNewTrialUI))
	SoraDAddMessage(self, "MESSAGE_NEWTRIAL_JOINTEAMLIST_REFRESH", handler(self, self.refreshNewTrialTeam))
	SoraDAddMessage(self, "MESSAGE_NEWTRIAL_BEGIN_REFRESH", handler(self, self.refreshBeginNewTrial))
	SoraDAddMessage(self, "MESSAGE_NEWTRIAL_END_REFRESH", handler(self, self.newTrialEndRefresh))
	SoraDAddMessage(self, "MESSAGE_SERVER_ROYAL_SUMMONS_GOLD", handler(self, self.royalSummonsGold))
	SoraDAddMessage(self, "MESSAGE_SERVER_ANCIENT_REEL_GOLD", handler(self, self.ancientReelGold))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_CASTLE_LEVELUP", handler(self, self.castleLevelUp))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLDKINGDOM_LV_CHANGE", handler(self, self.kingdomLevelUp))
	SoraDAddMessage(self, "MESSAGE_SECOND_STAR_BUILDING_BTN_REFRESH", handler(self, self.initStarBuilder))
	SoraDAddMessage(self, "MESSAGE_EXCLUSIVE_VIP_INIT", handler(self, self.initStarBuilder))
	SoraDAddMessage(self, "MESSAGE_SERVER_GUIDE_HIDE_AND_SHOW", handler(self, self.showOrHideGuideView))
	SoraDAddMessage(self, "MESSAGE_NEWS_ERVER_BACK_REFRESH", handler(self, self.initNewServerBackNode))
	SoraDAddMessage(self, "MESSAGE_NEWS_ERVER_BACK_RED_POINT", handler(self, self.initNewServerBackNode))
	SoraDAddMessage(self, "MESSAGE_NEW_START_INITNEW", handler(self, self.initNewServerBackNode))
	SoraDAddMessage(self, "MESSAGE_SERVER_HONOR_PET_REFRESH", handler(self, self.initNewServerBackNode))
	SoraDAddMessage(self, "MESSAGE_NEW_START_CORRELTION_REFRESH", handler(self, self.initNewServerBackNode))
	SoraDAddMessage(self, "MESSAGE_SNOWWOLF_LOST_REFRESH", handler(self, self.updateSnowWolfLostNode))
	SoraDAddMessage(self, "MESSAGE_ICEDRAGON_LOST_REFRESH", handler(self, self.updateIceDragonLostNode))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_NOVICE_GIFT_REFRESH", handler(self, self.initRecruitmentBtn))
	SoraDAddMessage(self, "MESSAGE_MAINUI_TOP_EVENT_CENTER_REFRESH", handler(self, self.refreshEventCenter))
	SoraDAddMessage(self, "MESSAGE_MAINUI_TOP_LEFTNODE_1_REFRESH", handler(self, self.rangeLeftNodes))
	SoraDAddMessage(self, "MESSAGE_MAINUI_TOP_LEFTNODE_2_REFRESH", handler(self, self.rangeLeftNodes))
	SoraDAddMessage(self, "MESSAGE_MAINCITY_UPDATE_MAINUITOP_HEADPOS", handler(self, self.updateHeadPos))
end
function mainUITop:updateHeadPos()
end
function mainUITop:updateLostRuinsNode()
	local lostRuinsCtrl = SoraDGetCtrl("lostRuinsCtrl")
	local questInfo = lostRuinsCtrl:getRunningQuestInfo()
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.LOST_RUINS_ACTIVITY, false) and next(questInfo) then
		if self.fields.teamMainUIWidget:isVisible() then
			self.fields.Node_LostRuins:setPositionY(270)
		elseif self.fields.newTrialMainUI:isVisible() then
			self.fields.Node_LostRuins:setPositionY(260)
		else
			self.fields.Node_LostRuins:setPositionY(130)
		end
		self.fields.Node_LostRuins:setVisible(true)
		self.fields.Node_LostRuins:setShowType(0)
		if questInfo.isFinish then
			self.fields.Node_LostRuins:setControlIndex(1)
		else
			self.fields.Node_LostRuins:setControlIndex(0)
			local lostRuinsRead = include("lostRuinsRead")
			local totalTime = lostRuinsRead.getTaskTimeByQuestId(questInfo.questId)
			local leftTime = math.max(0, totalTime - (serviceFunctions.systemTime() - lostRuinsCtrl:getRunningQuestInfo(questInfo.questId).startTime))
			self.fields.Node_LostRuins:setTime(leftTime)
			local eventQuestRead = include("eventQuestRead")
			local progress = lostRuinsCtrl:getQuestProgress(questInfo.questId)
			local aim = eventQuestRead.getAim(questInfo.questId)
			self.fields.Node_LostRuins:setProgress(progress, aim)
		end
	else
		self.fields.Node_LostRuins:setVisible(false)
	end
end
function mainUITop:updateWindTowerNode()
end
function mainUITop:updateSnowWolfLostNode()
	local snowWolfLostCtrl = SoraDGetCtrl("snowWolfLostCtrl")
	local questInfo = snowWolfLostCtrl:getRunningQuestInfo()
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SNOWWOLF_LOST_ACTIVITY, false) and next(questInfo) then
		if self.fields.teamMainUIWidget:isVisible() then
			self.fields.Node_LostRuins:setPositionY(270)
		elseif self.fields.newTrialMainUI:isVisible() then
			self.fields.Node_LostRuins:setPositionY(260)
		else
			self.fields.Node_LostRuins:setPositionY(130)
		end
		self.fields.Node_LostRuins:setVisible(true)
		self.fields.Node_LostRuins:setShowType(1)
		if questInfo.isFinish then
			self.fields.Node_LostRuins:setControlIndex(1)
		else
			self.fields.Node_LostRuins:setControlIndex(0)
			local snowWolfLostRead = include("snowWolfLostRead")
			local totalTime = snowWolfLostRead.getTaskTimeByQuestId(questInfo.questId)
			local leftTime = math.max(0, totalTime - (serviceFunctions.systemTime() - snowWolfLostCtrl:getRunningQuestInfo(questInfo.questId).startTime))
			self.fields.Node_LostRuins:setTime(leftTime)
			local eventQuestRead = include("eventQuestRead")
			local lostRuinsCtrl = SoraDGetCtrl("lostRuinsCtrl")
			local progress = lostRuinsCtrl:getQuestProgress(questInfo.questId)
			local aim = eventQuestRead.getAim(questInfo.questId)
			self.fields.Node_LostRuins:setProgress(progress, aim)
		end
	else
		self.fields.Node_LostRuins:setVisible(false)
	end
end
function mainUITop:updateIceDragonLostNode()
end
function mainUITop:setWarUIBarrageVisible(target, data)
	self.isInCenter = data.isInCenter
	self:updateWarUITop(self.currentViewType, data.isInCenter)
end
function mainUITop:setMarchingTroopsVisible(target, data)
	self:updateNebulaAllStarUITop(data.viewType)
	self:updateRoaringFlameUITop(data.viewType)
	self:updateWarUITop(data.viewType, true)
	if data.viewType == VIEW_TYPE_NONE or self.currentViewType == data.viewType then
		return
	end
	self.showBuilder = data.viewType == VIEW_TYPE_CITY
	self:getNodeLTTarget("troop"):initData(not self.showBuilder)
	self.fields.Node_area_lt:setShowModel(self.showBuilder and 0 or 1)
	self:refreshNewTrialUI()
	self:updateGold()
	self.currentViewType = data.viewType
end
function mainUITop:updateLordInfo()
	self.lordInfo = lordInfoCtrl:getBaseInfo()
	self:updatePlayer()
end
function mainUITop:getCurPower()
	return self.fields.btn_power:getPower()
end
function mainUITop:kingBattleFun(target, redata)
	if redata and redata.mid and SoraDGetCastleLv() >= CASTLE_LV10_LIMITED and SoraDIsGameGuide() == nil then
		local panel = SoraDCreatePanel("kingdomBattleWinWar")
		panel:initData(redata.mid)
		panel:show()
	end
end
function mainUITop:legendLordBattleVectoryFun(target, redata)
	local gametop = gModuleMgr.getObject("gametop")
	if worldMapDefine.isKingStarMapId(gametop.playertop_:getMapID()) then
		_ENV = gametop.playertop_:getMapID()
		gametop.playertop_:getMapID().data = redata.data
		uiManager:show("KingStarWinPop", gametop.playertop_:getMapID())
	else
		local panel = SoraDCreatePanel("pyramidBattleWinPopView")
		panel:setStyle(3)
		panel:initLegendData(redata.data)
		panel:show()
		panel:setLocalZOrder(5)
	end
end
function mainUITop:checkServerIsOK4SDKCallBack(target, redata)
	if redata and redata.otherData and redata.otherData.checkServerIsOK4SDKCallBack then
		print("checkServerIsOK4SDKCallBack = 成功触发：userSDKManager.reportReline()")
		userSDKManager.reportReline()
	end
end
function mainUITop:getEventCenterReturn_imp(v)
	if v == gActivityTimeActivityID.DAILY_DISCOUNT_GIFT_ACTIVITY then
		self:updateRechargeRedPoint()
	elseif v == cumuActiveCtrl:getActivityID() then
		self:initCrazyBtn()
		local cityBuildFunction = include("cityBuildFunction")
		local ret = cityBuildFunction:checkCrazyTrio()
		print("nodeCrazy", ret)
	elseif v == gActivityTimeActivityID.NEW_SERVER_RANK_MATCH then
		self:initKingNode()
	elseif v == gActivityCenterUIEnum.SULTAN_BACK then
		self:initSultansBackNode()
	elseif v == gActivityTimeActivityID.NEW_SERVER_JOURNEY_ACTIVITY then
		self:initNewJourney()
		self:initCrazyBtn()
	elseif v == gActivityTimeActivityID.NEW_START_OLDMAIN_ACTIVITY or v == gActivityTimeActivityID.NEW_START_NEWMAIN_ACTIVITY then
		self:initNewServerBackNode()
	end
	self:rangeLeftNodes()
end
function mainUITop:getEventCenterReturn(target, redata)
	if type(redata.activityID) == "table" then
		for _, v in pairs(redata.activityID) do
			self:getEventCenterReturn_imp(v)
		end
	elseif type(redata.activityID) == "number" then
		self:getEventCenterReturn_imp(redata.activityID)
	end
end
function mainUITop:endLegendLordWar(target, data)
	if data.data then
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_LEGENDLORD_WAR_END"
		;(nil).data = data.data
		SoraDSendMessage(nil)
	end
end
function mainUITop:endPyramid(target, data)
	if data.data then
		SoraDManagerRemoveAllTimer()
		if SoraDGetCastleLv() >= CASTLE_LV10_LIMITED then
			SoraDRemoveAllPanelFromManager()
			local panel = SoraDCreatePanel("pyramidBattleNewWinPopView")
			panel:initData(data.data)
			panel:prepare4Action()
			panel:show()
			panel:start2Action()
		end
	end
end
function mainUITop:onTeamMatchSuc(target, data)
	local panel = SoraDCreatePanel("teamMatchView")
	panel:show()
	panel:initView(data)
end
function mainUITop:onRemainsWarEnd(target, data)
	local resultInfo = data.resultInfo
	if resultInfo then
		if not resultInfo.ruinsWarSettleData then
			local panel = SoraDCreatePanel("remainsWarScoreView")
			panel:show()
			panel:initData(resultInfo)
		else
			local panel = SoraDCreatePanel("remainsWarResultView")
			panel:show()
			panel:initData(data)
		end
	end
end
function mainUITop:onRadianceWarEnd()
	SoraDCreatePanel("radianceWarResultView"):show()
end
function mainUITop:onRemainsWarTeamJoin(target, data)
	local remainsWarUtil = include("remainsWarUtil")
	if data.err == gErrDef.Err_None then
		remainsWarUtil.doAllianceInvite(data.extraData)
	else
		remainsWarUtil.errShowTips(data.err)
	end
end
function mainUITop:updateAttackInfo(target, data)
	self.fields.remainsWarAttackWidget:setEffectPath("remainsWarAttackWidget")
	self.fields.remainsWarAttackWidget:setVisible(true)
	self.fields.remainsWarAttackWidget:getEffect():updateAttackInfo(data)
end
function mainUITop:refreshNewTrialTeam()
	local devilValleyCtrl = SoraDGetCtrl("devilValleyCtrl")
	if devilValleyCtrl:hasTeams() then
		SoraDCreatePanel("newTrialMyTeamView"):show()
	end
end
function mainUITop:refreshBeginNewTrial()
	local devilValleyCtrl = SoraDGetCtrl("devilValleyCtrl")
	local teams = devilValleyCtrl:getMyTeams()
	if teams.start and not devilValleyCtrl:getSelfIsStart() and (not self.hasShowNewTrialBox or not not tolua.isnull(self.hasShowNewTrialBox)) then
		if worldMapDefine.inInCrossWar() then
			_ENV = nil
			;(nil).content = i18n("common_text_4952")
			uiManager:show("MessageBox", nil)
			return
		end
		local panel = SoraDShowMsgBox(i18n("devilvalley_tips_07"), i18n("devilvalley_btn_14"), i18n("devilvalley_btn_13"), function(eventType)
			self.hasShowNewTrialBox = nil
			if MSGBOX_CALLBACK_YES == eventType and SoraDGetCtrl("devilValleyCtrl"):checkEnterCondition() then
				SoraDGetCtrl("devilValleyCtrl"):sendReqStartChallenge()
			end
		end)
		self.hasShowNewTrialBox = panel
		if panel then
			SoraDAddMessage(panel, "MESSAGE_NEWTRIAL_TEAM_REFRESH", function()
				if not devilValleyCtrl:hasTeams() then
					panel:removeFromParent()
					self.hasShowNewTrialBox = nil
				end
			end)
		end
	end
end
function mainUITop:newTrialEndRefresh(target, data)
	local panel = SoraDCreatePanel("newTrialResultView")
	panel:initData(data.data)
	panel:show()
end
function mainUITop:royalSummonsGold()
	local royalSummonsCtrl = SoraDGetCtrl("royalSummonsCtrl")
	if royalSummonsCtrl:isActiveGold() then
		local panelName = "royalSummonsActivity"
		if royalSummonsCtrl:getClassType() == 2 then
			panelName = "dashToSkyActivity"
		end
		local panel = SoraDCreatePanel(panelName)
		panel:show()
	end
end
function mainUITop:ancientReelGold()
	local ancientReelCtrl = SoraDGetCtrl("ancientReelCtrl")
	if ancientReelCtrl:isActiveGold() then
		local panelName = "ancientReelActivity"
		local panel = SoraDCreatePanel(panelName)
		panel:show()
	end
end
function mainUITop:castleLevelUp()
	if SoraDGetCastleLv() == CASTLE_LV90_LIMITED then
		self:initStarBuilder()
	end
	self:refreshNodeEvent()
end
function mainUITop:kingdomLevelUp()
	local cityltCtrl = include("cityltCtrl")
	local unlockLv = cityltCtrl.buildStarLvInfo(BUILDID.CASTLE, 1, BUILD_LVINFO.KINGDOMLV)
	local kingdomLevelDataModuleAPI = include("kingdomLevelDataModuleAPI")
	local kingdomLevel = kingdomLevelDataModuleAPI:getKingdomLevel()
	if kingdomLevel == unlockLv then
		self:initStarBuilder()
	end
end
function mainUITop:rechargeCloseLoading(target, redata)
	dump(redata, "rechargeCloseLoading")
	SoraDCloseLoading()
	paymentManager.isInRecharging = false
	if not redata.data then
		return
	end
	local rechargePopFail = function()
		local callBackHandle = function()
			userSDKManager.openFeedback("Purchase", true)
		end
		local panel = include("commonPromptBoxTitle").new()
		_ENV = nil
		;(nil).title = i18n("common_text_1035")
		;(nil).content = i18n("common_text_3506")
		;(nil).yes = i18n("common_text_2102")
		;(nil).handle = callBackHandle
		panel:initData(nil)
		panel:show()
	end
	local rechargePopMsg = function(goods, mid, rid)
		if goods and next(goods) ~= nil then
			_ENV = nil
			;(nil).itemList = goods
			;(nil).mailID = mid
			;(nil).rid = rid
			uiManager:show("gemGoodsBuyGiftSuccess", nil)
		end
	end
	if redata.data.result then
		print("充值成功弹窗")
		local _rid = redata.data.rid
		if _rid then
			do
				local goods = redata.data.itemList
				local mailID = redata.data.mailID
				local rechargeRead = include("rechargeRead")
				local rechargeInfo = rechargeRead.getPageViewData(_rid)
				if rechargeInfo then
					if gRechargeActiveModelType.NORMAL == rechargeInfo.activeModelType or rechargeInfo.activeModelType == gRechargeActiveModelType.PETRA_GIFT then
						_ENV = gRechargeActiveModelType.PETRA_GIFT
						gRechargeActiveModelType.PETRA_GIFT.msg = "MESSAGE_CLIENT_RECHARGECENTER_POPVIEWCLOSE"
						SoraDSendMessage(gRechargeActiveModelType.PETRA_GIFT)
						_ENV = gRechargeActiveModelType.PETRA_GIFT
						gRechargeActiveModelType.PETRA_GIFT.msg = "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIEWREFRESH"
						SoraDSendMessage(gRechargeActiveModelType.PETRA_GIFT)
						self:initRechargeBtn()
						rechargePopMsg(goods, mailID, _rid)
					elseif gRechargeActiveModelType.LUCKYGIFT == rechargeInfo.activeModelType then
						_ENV = rechargeInfo.activeModelType
						rechargeInfo.activeModelType.msg = "MESSAGE_CLIENT_RECHARGECENTER_POPVIEWCLOSE"
						SoraDSendMessage(rechargeInfo.activeModelType)
						_ENV = rechargeInfo.activeModelType
						rechargeInfo.activeModelType.msg = "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIEWREFRESH"
						SoraDSendMessage(rechargeInfo.activeModelType)
						self:initLuckyBtn()
						rechargePopMsg(goods, mailID, _rid)
					elseif gRechargeActiveModelType.MONTHLYGIFT == rechargeInfo.activeModelType then
						_ENV = rechargeInfo.activeModelType
						rechargeInfo.activeModelType.msg = "MESSAGE_SERVER_RECHARGECENTER_MONTHLY_REFRESH"
						SoraDSendMessage(rechargeInfo.activeModelType)
						local monthGiftSpecialRid = 11485
						if rechargeActivityCtrl.monthAward and rechargeActivityCtrl.monthAward[tostring(monthGiftSpecialRid)] then
							local _day = rechargeActivityCtrl.monthAward[tostring(monthGiftSpecialRid)].curTotalday or rechargeActivityCtrl.monthAward[tostring(monthGiftSpecialRid)].totalday or 0
							_ENV = nil
							;(nil).num = _day
							SoraDShowMsgBox(i18n("common_text_1127", nil), i18n("common_text_204"), nil, nil)
						end
					elseif gRechargeActiveModelType.WEEKLY_GIFT == rechargeInfo.activeModelType then
						_ENV = rechargeInfo.activeModelType
						rechargeInfo.activeModelType.msg = "MESSAGE_SERVER_RECHARGECENTER_WEEKLY_REFRESH"
						SoraDSendMessage(rechargeInfo.activeModelType)
						local autoFightFun = function()
							local weekdata = rechargeActivityCtrl:getWeekActivityList()
							local weedsingle = weekdata[tostring(_rid)]
							if weedsingle then
								for i, v in ipairs(weedsingle.buff) do
									if v == 5148 then
										rechargeActivityCtrl = nil
										;(nil).msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
										;(nil).step = 60005
										SoraDSendMessage(nil)
									end
								end
							end
						end
						if rechargeActivityCtrl.monthAward and rechargeActivityCtrl.monthAward[tostring(_rid)] then
							local _day = rechargeActivityCtrl.monthAward[tostring(_rid)].curTotalday or rechargeActivityCtrl.monthAward[tostring(_rid)].totalday or 0
							if 7 < _day then
								local weekInfo = rechargeRead.getPageViewData(_rid)
								local leftTime = rechargeActivityCtrl:getRechargeLeftTime(_rid)
								if weekInfo and weekInfo.activeName and leftTime then
									_ENV = nil
									;(nil).giftname = i18n(weekInfo.activeName)
									;(nil).time = SoraDConvertSecondToString(leftTime)
									SoraDShowMsgBox(i18n("common_text_4175", nil), i18n("common_text_204"))
								else
									_ENV = i18n("common_text_204")
									i18n("common_text_204").num = _day
									SoraDShowMsgBox(i18n("common_text_1127", i18n("common_text_204")), i18n("common_text_204"), nil, autoFightFun)
								end
							else
								_ENV = i18n("common_text_1127", i18n("common_text_204"))
								i18n("common_text_1127", i18n("common_text_204")).num = _day
								SoraDShowMsgBox(i18n("common_text_1127", (i18n("common_text_1127", i18n("common_text_204")))), i18n("common_text_204"), nil, autoFightFun)
							end
						end
					elseif gRechargeActiveModelType.SUBSCRIPTION == rechargeInfo.activeModelType then
						_ENV = rechargeInfo.activeModelType
						rechargeInfo.activeModelType.msg = "MESSAGE_SERVER_RECHARGECENTER_SUBSCRIPTION_REFRESH"
						SoraDSendMessage(rechargeInfo.activeModelType)
						if redata.data.hadFreeSubed then
							SoraDShowMsgTip(i18n("subscribe_gift_text_13"))
						else
							local weekInfo = rechargeRead.getPageViewData(_rid)
							local leftTime = rechargeActivityCtrl:getRechargeLeftTime(_rid)
							if weekInfo and weekInfo.activeName and leftTime then
								_ENV = i18n("subscribe_gift_text_13")
								i18n("subscribe_gift_text_13").giftname = i18n(weekInfo.activeName)
								i18n("subscribe_gift_text_13").time = SoraDConvertSecondToString(leftTime)
								SoraDShowMsgTip(i18n("common_text_4175", i18n("subscribe_gift_text_13")))
							end
						end
						self:updateRechargeRedPoint()
					elseif gRechargeActiveModelType.KINGDOMGROUPBUY == rechargeInfo.activeModelType then
						SoraDShowMsgTip(i18n("common_text_1031"))
						_ENV = i18n("common_text_1031")
						i18n("common_text_1031").msg = "MESSAGE_SERVER_EVENTCENTER_KINGGROUPBUY_INIT"
						i18n("common_text_1031").rechargeRefresh = true
						SoraDSendMessage(i18n("common_text_1031"))
					elseif gRechargeActiveModelType.REDPACKAGE == rechargeInfo.activeModelType then
						SoraDShowMsgTip(i18n("common_text_3484"))
						_ENV = i18n("common_text_3484")
						i18n("common_text_3484").msg = "MESSAGE_SERVER_RECHARGECENTER_REDPACKETSUCCESS"
						SoraDSendMessage(i18n("common_text_3484"))
						_ENV = i18n("common_text_3484")
						i18n("common_text_3484").msg = "MESSAGE_SERVER_RECHARGECENTER_REDPACKETNEXTSUCCESS"
						SoraDSendMessage(i18n("common_text_3484"))
					elseif gRechargeActiveModelType.ICEBREAK == rechargeInfo.activeModelType then
						_ENV = rechargeInfo.activeModelType
						rechargeInfo.activeModelType.msg = "MESSAGE_CLIENT_RECHARGECENTER_POPVIEWCLOSE"
						SoraDSendMessage(rechargeInfo.activeModelType)
						_ENV = rechargeInfo.activeModelType
						rechargeInfo.activeModelType.msg = "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIEWREFRESH"
						SoraDSendMessage(rechargeInfo.activeModelType)
						rechargePopMsg(goods, mailID, _rid)
					elseif gRechargeActiveModelType.SEVEN_DAY_GIFT == rechargeInfo.activeModelType then
						_ENV = rechargeInfo.activeModelType
						rechargeInfo.activeModelType.msg = "MESSAGE_CLIENT_RECHARGECENTER_POPVIEWCLOSE"
						SoraDSendMessage(rechargeInfo.activeModelType)
						_ENV = rechargeInfo.activeModelType
						rechargeInfo.activeModelType.msg = "MESSAGE_CLIENT_RECHARGECENTER_SEVENDAYS"
						SoraDSendMessage(rechargeInfo.activeModelType)
						rechargePopMsg(goods, mailID, _rid)
					elseif gRechargeActiveModelType.PRIVILEGE_GIFT == rechargeInfo.activeModelType then
						_ENV = rechargeInfo.activeModelType
						rechargeInfo.activeModelType.msg = "MESSAGE_MAINCITY_CASTLE_GIFT_MSG"
						rechargeInfo.activeModelType.success = true
						SoraDSendMessage(rechargeInfo.activeModelType)
						_ENV = rechargeInfo.activeModelType
						rechargeInfo.activeModelType.msg = "MESSAGE_CLIENT_RECHARGECENTER_POPVIEWCLOSE"
						SoraDSendMessage(rechargeInfo.activeModelType)
						rechargePopMsg(goods, mailID, _rid)
					elseif gRechargeActiveModelType.RUIRUILADDER == rechargeInfo.activeModelType then
						_ENV = rechargeInfo.activeModelType
						rechargeInfo.activeModelType.msg = "MESSAGE_CLIENT_RECHARGECENTER_POPVIEWCLOSE"
						SoraDSendMessage(rechargeInfo.activeModelType)
						_ENV = rechargeInfo.activeModelType
						rechargeInfo.activeModelType.msg = "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIEWREFRESH"
						SoraDSendMessage(rechargeInfo.activeModelType)
						rechargePopMsg(goods, mailID, _rid)
					elseif gRechargeActiveModelType.DAILYDISCOUNT == rechargeInfo.activeModelType then
						rechargePopMsg(goods, mailID, _rid)
					elseif gRechargeActiveModelType.HONOR_BACK_GIFT == rechargeInfo.activeModelType then
						_ENV = rechargeInfo.activeModelType
						rechargeInfo.activeModelType.msg = "MESSAGE_SERVER_HONOR_BACK_UPDATE_GIFTS"
						SoraDSendMessage(rechargeInfo.activeModelType)
						rechargePopMsg(goods, mailID, _rid)
					elseif gRechargeActiveModelType.LINGLANG_GIFT == rechargeInfo.activeModelType then
						_ENV = rechargeInfo.activeModelType
						rechargeInfo.activeModelType.msg = "MESSAGE_CLIENT_RECHARGECENTER_POPVIEWCLOSE"
						SoraDSendMessage(rechargeInfo.activeModelType)
						_ENV = rechargeInfo.activeModelType
						rechargeInfo.activeModelType.msg = "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIEWREFRESH"
						SoraDSendMessage(rechargeInfo.activeModelType)
						self:initRechargeBtn()
						rechargePopMsg(goods, mailID, _rid)
					end
				elseif paymentManager.getPaymentBullets(_rid) then
					local isActive = paymentManager.getPaymentBullets(_rid).isActive
					if isActive == gBuyType.RECHARGE_ACTIVITY or isActive == gBuyType.AMAZING_FORTUNE or isActive == gBuyType.DICTATORSHIPS or isActive == gBuyType.HERO_POWER_SKILL or isActive == gBuyType.HONOR_BACK_RECHARGE_REBATE or isActive == gBuyType.SNOW_COMPETITION or isActive == gBuyType.FROSTY_MARKET or isActive == gBuyType.BALLOON_HUNTER or isActive == gBuyType.MAGIC_CARPET or isActive == gBuyType.CRESCENT_ORDER or isActive == gBuyType.ANNIVERSARY_2025_SHOP or isActive == gBuyType.SNOW_WOLF_KING or isActive == gBuyType.ALBARQ_DECREE or isActive == gBuyType.GOLD_MINER then
						rechargePopMsg(goods, mailID, _rid)
					else
						SoraDShowMsgTip(i18n("common_text_1032"))
					end
				else
					SoraDShowMsgTip(i18n("common_text_1032"))
				end
				local gold = redata.data.goldCount or 0
				if paymentManager.bullets[_rid] and paymentManager.bullets[_rid].isActive == gBuyType.RECHARGE then
					_ENV = gBuyType.RECHARGE
					gBuyType.RECHARGE.msg = "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIEWGOLDREFRESH"
					SoraDSendMessage(gBuyType.RECHARGE)
					_UPVALUE2_ = SoraDSendMessage
					SoraDSendMessage[1] = gIDDef.GOLD
					local SoraDSendMessage[2], itemList = gold, SoraDSendMessage
					rechargePopMsg(itemList, mailID, _rid)
				end
			end
		end
	else
		local _rid = redata.data.rid
		print("充值失败", _rid)
		if _rid then
			local rechargeRead = include("rechargeRead")
			local rechargeInfo = rechargeRead.getPageViewData(_rid)
			if rechargeInfo then
				if gRechargeActiveModelType.NORMAL == rechargeInfo.activeModelType then
					rechargePopFail()
				elseif gRechargeActiveModelType.LUCKYGIFT == rechargeInfo.activeModelType then
					rechargePopFail()
				elseif gRechargeActiveModelType.MONTHLYGIFT == rechargeInfo.activeModelType then
					rechargePopFail()
				elseif gRechargeActiveModelType.WEEKLY_GIFT == rechargeInfo.activeModelType then
					rechargePopFail()
				elseif gRechargeActiveModelType.SUBSCRIPTION == rechargeInfo.activeModelType then
				elseif gRechargeActiveModelType.KINGDOMGROUPBUY == rechargeInfo.activeModelType then
					if redata.data.contactMe then
						rechargePopFail()
					else
						rechargePopFail()
					end
				elseif gRechargeActiveModelType.REDPACKAGE == rechargeInfo.activeModelType then
				elseif gRechargeActiveModelType.ICEBREAK == rechargeInfo.activeModelType then
					rechargePopFail()
				elseif gRechargeActiveModelType.SEVEN_DAY_GIFT == rechargeInfo.activeModelType then
					rechargePopFail()
				elseif gRechargeActiveModelType.PRIVILEGE_GIFT == rechargeInfo.activeModelType then
					rechargePopFail()
				elseif gRechargeActiveModelType.RUIRUILADDER == rechargeInfo.activeModelType then
					rechargePopFail()
				elseif gRechargeActiveModelType.DAILYDISCOUNT == rechargeInfo.activeModelType then
					rechargePopFail()
				elseif gRechargeActiveModelType.HONOR_BACK_GIFT == rechargeInfo.activeModelType then
					rechargePopFail()
				else
					rechargePopFail()
				end
			end
			if paymentManager.bullets[_rid] and (paymentManager.bullets[_rid].isActive == gBuyType.RECHARGE or paymentManager.bullets[_rid].isActive == gBuyType.EARTH_TREASURE) and not SoraDSearchPanelFromManagerByName("commonPromptBoxTitle") then
				rechargePopFail()
			end
			if _rid == 14261 then
				rechargePopFail()
			end
		else
			rechargePopFail()
		end
	end
end
function mainUITop:initExplainBtn()
	if SoraDConfigGet("Game:GameSettingView:gameExplainSwitch~bool") then
		self:getNodeLTTarget("btn_gameExplain"):setVisible(false)
	else
		self:getNodeLTTarget("btn_gameExplain"):setVisible(true)
	end
end
function mainUITop:btnExplainClick()
	SoraDPlaySound()
	SoraDShowMsgBox(i18n("common_text_1027"), i18n("common_text_204"), nil, function(eventType)
		if eventType == MSGBOX_CALLBACK_YES then
			SoraDConfigSet("Game:GameSettingView:gameExplainSwitch~bool", true)
			self:getNodeLTTarget("btn_gameExplain"):setVisible(false)
		end
	end)
	userSDKManager.showFAQs()
end
function mainUITop:initStarBuilder()
	if SoraDCheckIsOpenBuildStar() then
		if not self.tableBuilder[3] then
			self.tableBuilder[3] = self:getNodeLTTarget("builderIcon_qh_free")
			self:getNodeLTTarget("builderIcon_qh_free"):setVisible(true)
		end
		self:getNodeLTTarget("builderIcon_qh_free"):setModel(2)
		self:getNodeLTTarget("builderIcon_qh_free"):initData(gQueueTypeDef.build_star_queue)
		if _G.SoraDGetCtrl("exaltedPrivilegeCtrl"):checkPrivilege(_G.gExaltedPrivilegeType.EXTRA_STAR_UPGRADE_QUEUENUM) then
			if not self.tableBuilder[4] then
				self.tableBuilder[4] = self:getNodeLTTarget("builderIcon_qh_gold")
				self:getNodeLTTarget("builderIcon_qh_gold"):setVisible(true)
			end
			self:getNodeLTTarget("builderIcon_qh_gold"):setModel(3)
			self:getNodeLTTarget("builderIcon_qh_gold"):initData(gQueueTypeDef.build_star_queue_privilege)
		end
		self.fields.Node_area_lt:setExplainShowModel(1)
	else
		self.fields.Node_area_lt:setExplainShowModel(0)
	end
	self:initTimer()
end
function mainUITop:initRechargeBtn()
	local popShowActiveID = function()
		local reID = 0
		local rechargeActivityCtrl, recommendList
		local rechargeActivityCtrl, normalList
		if not rechargeActivityCtrl:filterBuyRankData(rechargeActivityCtrl:getNormalAndAllianceRechargeActivityList()) then
			local rechargeActivityCtrl, copyActivityList = rechargeActivityCtrl:filterBuyRankData(rechargeActivityCtrl:getNormalAndAllianceRechargeActivityList()), rechargeActivityCtrl:filterBuyRankData(rechargeActivityCtrl:getNormalAndAllianceRechargeActivityList())
		end
		for k, v in pairs(copyActivityList) do
			if v.recommend and paymentManager.judgeGiftExclusive(tonumber(k)) then
				table.insert(recommendList, k)
			elseif not v.recommend and paymentManager.judgeGiftExclusive(tonumber(k)) then
				table.insert(normalList, k)
			end
		end
		if 0 < table.nums(recommendList) then
			reID = tonumber(recommendList[math.random(#recommendList)])
		elseif 0 < table.nums(normalList) then
			reID = tonumber(normalList[math.random(#normalList)])
		end
		return reID
	end
	self.eventIndex = popShowActiveID()
	if self.eventIndex == 0 or worldMapDefine.isInNewTrial() then
		self.fields.Node_recharge:setVisible(false)
	else
		local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.RECHARGE_CENTER)
		if unlockLv <= SoraDGetCastleLv() then
			self.fields.Node_recharge:setTime(rechargeActivityCtrl:queryQueue(self.eventIndex).timerNode.timer:getRemainTime())
			local rechargeRead = include("rechargeRead")
			local info = rechargeRead.getPageViewData(self.eventIndex)
			if info then
				self.fields.Node_recharge:setVisible(true)
				self.fields.Node_recharge:setModel(info.eventType, self.eventIndex)
				if info.hideTime and info.hideTime == 1 then
					self.fields.Node_recharge:setName(i18n(info.activeName))
				end
			end
		else
			self.fields.Node_recharge:setVisible(false)
		end
	end
	self:rangeLeftNodes()
end
function mainUITop:initLuckyBtn(target, redata)
	local newLuckyGift = luckyGiftCtrl:getNewLuckyGiftData()
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.RECHARGE_CENTER)
	if unlockLv <= SoraDGetCastleLv() then
		if not worldMapDefine.isInNewTrial() and next(newLuckyGift) then
			self.fields.Node_rechargeLucky:setVisible(true)
			if newLuckyGift.lastTime and newLuckyGift.lastTime > 0 then
				self.fields.Node_rechargeLucky:setTime(newLuckyGift.lastTime)
			else
				self.fields.Node_rechargeLucky:setName("")
			end
			self.fields.Node_rechargeLucky:setRed(luckyGiftCtrl:getRedPointNum())
			local rechargeRead = include("rechargeRead")
			local info = rechargeRead.getPageViewData(tonumber(newLuckyGift.luckyGiftID))
			self.fields.Node_rechargeLucky:setModel(info.eventType)
		else
			self.fields.Node_rechargeLucky:setVisible(false)
		end
	else
		self.fields.Node_rechargeLucky:setVisible(false)
	end
	self:rangeLeftNodes()
	if redata then
		luckyGiftCtrl = self
		self.msg = "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIEWREFRESH"
		SoraDSendMessage(self)
	end
end
function mainUITop:defineWallDestroy()
	if not worldMapDefine.isInNewTrial() then
		_ENV = nil
		;(nil).canNotClose = true
		;(nil).basePanelPowerValue = POP_WINDOW_POWERVALUE_WALLDEFINE
		;(nil).isCantCloseByReturn = true
		;(nil).align = SoraDFLabelR()
		SoraDShowMsgBox(i18n("common_text_797"), i18n("common_text_798"), nil, function(eventType)
			if eventType == MSGBOX_CALLBACK_YES then
				local wallsCtrl = SoraDGetCtrl("wallsCtrl")
				wallsCtrl:reqRebuildWall()
				_ENV = wallsCtrl
				wallsCtrl.msg = "MESSAGE_WALLS_DEFENCE_DESTROY_RECOVER"
				SoraDSendMessage(wallsCtrl)
			end
		end, nil)
	end
	if SoraDIsGameGuide() then
		_ENV = i18n("common_text_797")
		i18n("common_text_797").msg = "MESSAGE_SERVER_CLOSE_GUIDE"
		SoraDSendMessage((i18n("common_text_797")))
	end
end
function mainUITop:initEventNode(target, data)
	if target == nil then
		self:initEventNode_imp()
	elseif self.isInitEventDone then
		self.isInitEventDone = false
		SoraDDelayCallOnce("initEventNode", handler(self, self.initEventNode_imp), 0.1)
	end
end
function mainUITop:initEventNode_imp()
	self.isInitEventDone = true
	local newTB = clientEventMgr.getNewInfo()
	local redTB = clientEventMgr.getRedPointInfo()
	if next(newTB) then
		self.fields.Node_event:setNewJumpVisible(true)
		self.fields.Node_event:setRedVisible(false)
	elseif next(redTB) then
		self.fields.Node_event:setNewJumpVisible(false)
		self.fields.Node_event:setRedVisible(true)
	else
		self.fields.Node_event:setNewJumpVisible(false)
		self.fields.Node_event:setRedVisible(false)
	end
	if not self.isInitEventDone then
		self.isInitEventDone = true
		if next(newTB) and SoraDGetCastleLv() <= CASTLE_LV26_LIMITED then
			_ENV = false
			;(false).byUID = true
			local clickTime = SoraDConfigGet("Game:mainUITop:clickEventCenterView~integer", false)
			if clickTime == 0 or not serviceFunctions.isSameDay(clickTime) then
				self.fields.Node_event:showTips()
			end
		end
	end
	self:updateSultansBackRed()
	self:updateNewServerBackRed()
	local redata
	if redata and (redata.eventID == gActivityTimeActivityID.NEW_START_OLDMAIN_ACTIVITY or redata.eventID == gActivityTimeActivityID.NEW_START_NEWMAIN_ACTIVITY) then
		self:initNewServerBackNode()
	elseif redata and (redata.eid == gActivityTimeActivityID.NEW_START_OLDMAIN_ACTIVITY or redata.eid == gActivityTimeActivityID.NEW_START_NEWMAIN_ACTIVITY) then
		self:initNewServerBackNode()
	end
end
function mainUITop:updateNewServerBackRed()
	if self.fields.Node_newServerBack:isVisible() and clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEW_START_NEWMAIN_ACTIVITY) then
		local newStartMainCtrl = SoraDGetCtrl("newStartMainCtrl")
		if newStartMainCtrl:checkIsInherit() then
			local showRed = newStartMainCtrl:getReceiveStatusAndNum()
			self.fields.Node_newServerBack:setRedVisible(showRed)
			self.fields.Node_newServerBack:setNewJumpVisible(false)
		end
	end
end
function mainUITop:initNewJourney()
	local isOpen = _G.clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEW_SERVER_JOURNEY_ACTIVITY, false)
	self.fields.Node_newJourney:setVisible(isOpen)
	self:rangeLeftNodes()
	if isOpen then
		local status1 = cumuActiveCtrl:isAllCrazyTrioClaimed()
		local status2 = princeGiftNewCtrl:getIsBuy()
		local status3 = castleRewardCtrl:getIsBuy()
		local status4 = false
		local buffMonthData = rechargeActivityCtrl:getMonthActivityList()
		if next(buffMonthData) then
			for k, v in pairs(buffMonthData) do
				if v.isbuy and v.totalday and v.totalday >= 30 then
					status4 = true
					break
				end
			end
		end
		local status = status1 or status2 or status3 or status4
		self.fields.Node_newJourney:setNewJumpVisible(not status)
		if not status then
			_ENV = not status
			;(not status).byUID = true
			local readTime = SoraDConfigGet("Game:journey:readTime~integer", not status) or 0
			readTime = math.max(readTime, 0)
			local isSameDay = serviceFunctions.isSameDay(readTime)
			self.fields.Node_newJourney:setNewJumpVisible(not isSameDay)
		end
	end
end
function mainUITop:initNewServerBackNode()
	local refreshActivityTime = function(activityID)
		local activityTime = activityShowCtrl:getTimeInfoByID(activityID)
		if activityTime then
			self.fields.Node_newServerBack:setTime(activityTime.timerNode.timer:getRemainTime())
		end
	end
	local refreshActivityNew = function(activityID)
		local activityCenterUICtrl = SoraDGetCtrl("activityCenterUICtrl")
		if activityCenterUICtrl:isHaveNewFlag(activityID) then
			self.fields.Node_newServerBack:setNewJumpVisible(true)
		else
			self.fields.Node_newServerBack:setNewJumpVisible(false)
		end
	end
	local showBtn = false
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEW_START_NEWMAIN_ACTIVITY) then
		local newStartMainCtrl = SoraDGetCtrl("newStartMainCtrl")
		if newStartMainCtrl:checkIsInherit() then
			showBtn = true
			refreshActivityTime(gActivityTimeActivityID.NEW_START_NEWMAIN_ACTIVITY)
			local showRed = newStartMainCtrl:getReceiveStatusAndNum()
			self.fields.Node_newServerBack:setRedVisible(showRed)
			refreshActivityNew(gActivityTimeActivityID.NEW_START_NEWMAIN_ACTIVITY)
		end
	elseif clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEW_START_OLDMAIN_ACTIVITY) then
		showBtn = true
		refreshActivityTime(gActivityTimeActivityID.NEW_START_OLDMAIN_ACTIVITY)
		self.fields.Node_newServerBack:setRedVisible(false)
		refreshActivityNew(gActivityTimeActivityID.NEW_START_OLDMAIN_ACTIVITY)
	end
	self.fields.Node_newServerBack:setVisible(showBtn)
	self:rangeLeftNodes()
end
function mainUITop:refreshEventCenter()
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.EVENT_CENTER)
	local isOpen = unlockLv <= SoraDGetCastleLv()
	self.fields.Node_event:setVisible(isOpen and not worldMapDefine.isInNewTrial())
	if isOpen then
		_ENV = nil
		;(nil)[1] = ffa.delay(0.1)
		;(nil)[2] = ffa.callFunc(function()
			local guideCtrl = SoraDGetCtrl("guideCtrl")
			if guideCtrl:isGuideNotCompleted(gGuideModule.ACTIVITY_CENTER) and not SoraDIsGameGuide() then
				local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
				_ENV = nil
				;(nil).waitDelay = 15
				mildGuideManager:starToActivity(nil)
			end
		end)
		;(nil)[3] = ffa.callFunc(function()
			local guideCtrl = SoraDGetCtrl("guideCtrl")
			if guideCtrl:isGuideNotCompleted(gGuideModule.ACTIVITY_CENTER) and not SoraDIsGameGuide() then
				local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
				_ENV = nil
				;(nil).waitDelay = 15
				mildGuideManager:starToActivity(nil)
			end
		end)
		self.fields.Node_event:runAction(ffa.seq(nil))
	end
end
function mainUITop:initCrazyBtn(target, redata)
	if redata and redata.showInDown then
		if self.fields.Node_crazy:isVisible() then
			self.fields.Node_crazy:setVisible(false)
			_ENV = nil
			;(nil).byUID = true
			SoraDConfigSet("Game:eventCrazyTrioNew:isShowInDown~bool", true, nil)
			_ENV = "Game:eventCrazyTrioNew:isShowInDown~bool"
			;("Game:eventCrazyTrioNew:isShowInDown~bool").msg = "MESSAGE_CUMUACTIVITY_CRAZYTRIO_SHOWDOWN"
			SoraDSendMessage("Game:eventCrazyTrioNew:isShowInDown~bool")
			self:rangeLeftNodes()
		end
		return
	end
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.FIRST_RECHARGE)
	if not activityShowCtrl:isActivityOpen(cumuActiveCtrl:getActivityID()) or unlockLv > SoraDGetCastleLv() then
		self.fields.Node_crazy:setVisible(false)
		self:rangeLeftNodes()
		return
	end
	local receiveAll = false
	local actOpen = false
	local rechargeltCtrl = include("rechargeltCtrl")
	local redIsVisible = cumuActiveCtrl:getInitialReceiveState()
	self.fields.Node_crazy:setRedVisible(redIsVisible)
	local crazyData = cumuActiveCtrl:getCrazyTrioData()
	local receiveNum = table.nums(crazyData.receive)
	receiveAll = receiveNum == rechargeltCtrl.getRechargeTotalConfigNum()
	_ENV = cumuActiveCtrl:getActivityID()
	cumuActiveCtrl:getActivityID().byUID = true
	if not SoraDConfigGet("Game:eventCrazyTrioNew:isShowInDown~bool", cumuActiveCtrl:getActivityID()) then
		actOpen = true
	end
	local isNewJourneyOpen = _G.clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEW_SERVER_JOURNEY_ACTIVITY, false)
	self.fields.Node_crazy:setVisible(not receiveAll and actOpen and not worldMapDefine.isInNewTrial() and isNewJourneyOpen)
	if unlockLv > SoraDGetCastleLv() then
		self.fields.Node_crazy:setVisible(false)
	end
	self:rangeLeftNodes()
end
function mainUITop:updateRechargeRedPoint()
	self.fields.com_gold:updateRechargeRedPoint()
end
function mainUITop:luckyBtnPoint()
	self.fields.Node_rechargeLucky:setRed(0)
end
function mainUITop:initHeroGiftBtn()
	local heroGiftCtrl = SoraDGetCtrl("heroGiftCtrl")
	local rechargeList = heroGiftCtrl:getRechargeList()
	if not worldMapDefine.isInNewTrial() and rechargeList and next(rechargeList) then
		self.fields.Node_choiceLucky:setVisible(true)
		local info = heroGiftCtrl:getMinimumTimeGift()
		local firstHeroID = info.heroID
		local leftTime = info.endTime - serviceFunctions.systemTime()
		self.fields.Node_choiceLucky:setTime(leftTime, firstHeroID)
		_ENV = leftTime
		leftTime.byUID = true
		local lastHeroID = SoraDConfigGet("Game:heroGiftCtrl:endHeroID~integer", leftTime)
		_ENV = firstHeroID
		firstHeroID.byUID = true
		local newGift = SoraDConfigGet("Game:heroGiftCtrl:isNewGift~bool", firstHeroID)
		local isEnd = false
		if lastHeroID ~= firstHeroID and leftTime < 86400 then
			isEnd = true
		end
		self.fields.Node_choiceLucky:setRedPoint(isEnd or newGift)
	else
		self.fields.Node_choiceLucky:setVisible(false)
	end
	self:rangeLeftNodes()
end
function mainUITop:initKingNode()
	local kingCompetitionltCtrl = include("kingCompetitionltCtrl")
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEW_SERVER_RANK_MATCH) then
		self.fields.Node_kingCom:setVisible(false)
		self:rangeLeftNodes()
		return
	else
		self.fields.Node_kingCom:setVisible(true)
		self:rangeLeftNodes()
	end
	local checkRedNode = function()
		local kingCompetitionCtrl = SoraDGetCtrl("kingCompetitionCtrl")
		local info = lordInfoCtrl:getBaseInfo()
		local first = 0
		local lv = SoraDGetCastleLv()
		_UPVALUE3_ = nil
		;(nil)[1] = SoraDGetCastleLv()
		;(nil)[2] = SoraDGetLordLv()
		local (nil)[3], lvCfg = info.totalFc, nil
		for i = 1, 3 do
			local num = kingCompetitionltCtrl:getTargetNum(i)
			lv = lvCfg[i]
			if kingCompetitionCtrl:checkRedNode(i, num, first, lv) then
				return true
			end
			first = first + num
		end
		return false
	end
	self.fields.Node_kingCom:setRed(checkRedNode())
	self.fields.Node_kingCom:setTime()
end
function mainUITop:initSultansBackNode()
	_ENV = nil
	;(nil).byUID = true
	local needShow = SoraDConfigGet("Game:sultansBackView:showInMainUITop~bool", nil)
	local sultansBackCtrl = SoraDGetCtrl("sultansBackCtrl")
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local activityIDList = activityShowCtrl:getActivityGroup(gActivityCenterUIEnum.SULTAN_BACK)
	local isOpen = false
	for k, v in pairs(activityIDList) do
		if clientEventMgr.judgeIsOpen(k) then
			isOpen = true
			break
		end
	end
	if not (isOpen and needShow) or worldMapDefine.isInNewTrial() then
		self.fields.Node_sultansBack:setVisible(false)
		self:rangeLeftNodes()
		return
	else
		self.fields.Node_sultansBack:setVisible(true)
		self:rangeLeftNodes()
	end
	local showRed, redNum = sultansBackCtrl:getReceiveStatusAndNum()
	self.fields.Node_sultansBack:setRed(redNum)
end
function mainUITop:initRecruitmentBtn()
	local noviceGiftCtrl = SoraDGetCtrl("noviceGiftCtrl")
	local recruitmentRead = include("recruitmentRead")
	if self.fields.Node_event:isVisible() and noviceGiftCtrl:getIsEnd() and not noviceGiftCtrl:isReceiveAllAward() then
		self.fields.Node_recruitment:setVisible(true)
		local curDay = noviceGiftCtrl:getCurrentDay()
		if noviceGiftCtrl:isCurrentCanReceive() then
			self.fields.Node_recruitment:setName(i18n("back_first_charge_text07"))
		else
			curDay = curDay + 1
			self.fields.Node_recruitment:setTime(serviceFunctions.getTodayRemainTime())
		end
		self.fields.Node_recruitment:setIcon(recruitmentRead.getIconByDay(curDay))
	else
		self.fields.Node_recruitment:setVisible(false)
	end
	self:rangeLeftNodes()
end
function mainUITop:initActivity9001605Btn()
	local activity_9001606_Ctrl = SoraDGetCtrl("activity_9001606_Ctrl")
	local isOpen = activity_9001606_Ctrl:getIsActivityOpen() and activity_9001606_Ctrl:getIsGotData()
	self.fields.Node_activity9001605:setVisible(isOpen)
	if isOpen then
		self.fields.Node_activity9001605:setTime(activity_9001606_Ctrl:getStatusLastTime())
		local activityID = activity_9001606_Ctrl:getActivityState()
		local activityCenterUICtrl = SoraDGetCtrl("activityCenterUICtrl")
		self.fields.Node_activity9001605:setNewJumpVisible(activityCenterUICtrl:isHaveNewFlag(activityID))
		self:updateActivity9001605Reddot()
	end
	self:rangeLeftNodes()
end
function mainUITop:initActivity9001614Btn()
end
function mainUITop:updateActivity9001605Reddot()
	if self.fields.Node_activity9001605:isVisible() then
		local activity_9001606_Ctrl = SoraDGetCtrl("activity_9001606_Ctrl")
		local isKing = activity_9001606_Ctrl:getIsKing()
		local teamDef = include("teamDef")
		local teamAreaEnum = teamDef.teamAreaEnum
		local teamCtrl = SoraDGetCtrl("teamCtrl")
		local teamInfo = teamCtrl:getTeamData(teamAreaEnum.MERGE_SERVER_SHOW)
		self.fields.Node_activity9001605:setRedVisible(isKing and activity_9001606_Ctrl:getRedPointNum() > 0 or teamInfo:isHasNewTeamMsg())
	end
end
function mainUITop:initActivity9001711Btn(target, data)
	local activity_9001711_Ctrl = SoraDGetCtrl("activity_9001711_Ctrl")
	local isHaveGift, giftNum = activity_9001711_Ctrl:getIsHaveGift()
	if not isHaveGift then
		self.fields.Node_activity9001711:clearContent()
		self.Btn_9001711 = nil
	else
		if not self.Btn_9001711 then
			self.fields.Node_activity9001711:setURL("ui://MainUI/Btn_9001711")
			self.Btn_9001711 = self.fields.Node_activity9001711:getComponent()
		end
		self.Btn_9001711:updateData()
		self.Btn_9001711:updateReddot(isHaveGift, giftNum)
		if data and data.popGfit then
			_ENV = giftNum
			giftNum.popGfit = data.popGfit
			uiManager:show("Activity_9001724_Main", giftNum)
		end
	end
end
function mainUITop:updateNewTeamChat()
	self:updateActivity9001605Reddot()
end
function mainUITop:tradeBoardMsgShowTip(target, redata)
	if redata and redata.info then
		local publicRead = include("publicRead")
		if redata.showType and redata.showType == "newTradeBoard" then
			_ENV = nil
			;(nil).name = publicRead.getName(redata.info._item)
			;(nil).count = redata.info._num
			local itemName = i18n("common_text_1460", nil)
			_ENV = redata.info._item
			redata.info._item.item = itemName
			SoraDShowMsgTip(i18n("auction_text_30", redata.info._item))
		else
			_ENV = i18n("auction_text_30", redata.info._item)
			i18n("auction_text_30", redata.info._item).name = publicRead.getName(redata.info._item)
			i18n("auction_text_30", redata.info._item).num = redata.info._num
			SoraDShowMsgTip(i18n("mail_text_277", i18n("auction_text_30", redata.info._item)))
		end
	end
end
function mainUITop:updateSultansBackRed()
	if self.fields.Node_sultansBack:isVisible() then
		local sultansBackCtrl = SoraDGetCtrl("sultansBackCtrl")
		local showRed, redNum = sultansBackCtrl:getReceiveStatusAndNum()
		self.fields.Node_sultansBack:setRed(redNum)
	end
end
function mainUITop:showOrHideGuideView()
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	local guideStep = guideCtrl:getCurForceGuideStep()
	if not guideStep then
		self.controllers.c3:setSelectedIndex(0)
		self:refreshEventCenter()
	else
		self.controllers.c3:setSelectedIndex(2036 <= guideStep and 0 or 1)
	end
end
function mainUITop:reLoginFinish()
	print("断线重连啦！")
	self:initData()
	self:initView()
	self:initTimer()
	userSDKManager.reportReline()
	paymentManager.isInRecharging = false
	paymentManager.reconsumePayWhenRelogin()
end
function mainUITop:initTimer()
	_UPVALUE4_ = nil
	;(nil)[1] = gQueueTypeDef.free_build_queue
	;(nil)[2] = gQueueTypeDef.charge_build_queue
	;(nil)[3] = gQueueTypeDef.build_star_queue
	local (nil)[4], queueTypeList = gQueueTypeDef.build_star_queue_privilege, nil
	local tmp = not (self.offsetY == 0 or SoraDFIsRA()) and 90 or 100
	for i, v in ipairs(self.tableBuilder) do
		if v:isVisible() then
			v:initData(queueTypeList[i])
			v:setPositionY((SoraDFIsRA() and 0 or self.offsetY) + tmp * i - 100)
		end
	end
end
function mainUITop:handlEscort(target, data)
	local retData = data.data
	SoraDCloseLoading()
	if retData.closestBuild == nil then
		return
	end
	local x = retData.closestBuild.x
	local y = retData.closestBuild.y
	if x ~= -1 and y ~= -1 then
		print("开始跳转到坐标 -------", x, " ,", y)
		SoraDRemoveTopPanelFromManager()
		SoraDGotoWorldMapPoint(cc.p(x, y), true)
	end
end
function mainUITop:getEquipSuccess()
	self.fields.btn_head:setNotice()
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	if guideCtrl:isGuideOpen(gGuideModule.WEAR_EQUIPMENT) then
		self.fields.btn_head:setNotice(true)
	else
		self.fields.btn_head:setNotice(false)
	end
	self.fields.btn_head:updateRedPoint()
end
function mainUITop:updateBirthdayYearReddot()
	self.fields.btn_head:updateRedPoint()
end
function mainUITop:rangeLeftNodes()
	_UPVALUE13_ = nil
	;(nil)[1] = "Node_rechargeLucky"
	;(nil)[2] = "Node_recharge"
	;(nil)[3] = "Node_event"
	;(nil)[4] = "Node_activity9001614"
	;(nil)[5] = "Node_newServerBack"
	;(nil)[6] = "Node_recruitment"
	;(nil)[7] = "Node_newJourney"
	;(nil)[8] = "Node_sultansBack"
	;(nil)[9] = "Node_kingCom"
	;(nil)[10] = "Node_crazy"
	;(nil)[11] = "Node_choiceLucky"
	;(nil)[12] = "Node_activity9001605"
	local (nil)[13], btnTableName = "Node_activity9001711", nil
	self:rangeNodes(btnTableName)
	_ENV = self
	self.msg = "MESSAGE_MAIN_BTN_UPDATE"
	SoraDSendMessage(self)
end
function mainUITop:rangeNodes(btnTableName, _posY)
	local _ENV, visiableNodes
	for i, v in ipairs(btnTableName) do
		if self.fields[v] and self.fields[v]:isVisible() then
			table.insert(visiableNodes, self.fields[v])
		end
	end
	_UPVALUE4_ = ipairs(btnTableName)
	local ipairs(btnTableName)[4], posY = 400, _posY or ipairs(btnTableName)
	for i, v in ipairs(visiableNodes) do
		local index = i % 4 == 0 and 4 or i % 4
		local cPosY = posY[index] or posY[index - 1] + 100
		cPosY = cPosY - 120
		local cPosx = 10 + 100 * math.floor((i - 1) / 4)
		v:setPositionX(SoraDFIsRA() and cPosx - 10 or self:getWidth() - cPosx - 80 - 10)
		v:setPositionY(cPosY + self.offsetY + 20)
	end
end
function mainUITop:initView()
	self:initRechargeBtn()
	self:initCrazyBtn()
	self:initExplainBtn()
	self:initLuckyBtn()
	self:initNewJourney()
	self:updateGold()
	self:initEventNode()
	self:updateTeamMainUIWidget()
	self:refreshNewTrialUI()
	self:initHeroGiftBtn()
	self:initKingNode()
	self:initSultansBackNode()
	self:showOrHideGuideView()
	self:updateHeadPos()
	self:initNewServerBackNode()
	self:initRecruitmentBtn()
	self:updateLostRuinsNode()
	self:updateWindTowerNode()
	self:updateSnowWolfLostNode()
	self:updateIceDragonLostNode()
	self:initStarBuilder()
end
function mainUITop:initData()
	self.lordInfo = lordInfoCtrl:getBaseInfo()
	self:updatePlayer(true)
	self:updateVip()
	self.fields.com_res:updateResource()
end
function mainUITop:updateTeamMainUIWidget()
	if worldMapDefine.inInCrossWar() then
		self.fields.teamMainUIWidget:setVisible(false)
		return
	end
	local remainsTeamCtrl = SoraDGetCtrl("remainsTeamCtrl")
	if remainsTeamCtrl:isHasTeam() then
		self.fields.teamMainUIWidget:setEffectPath("teamMainUIWidget")
		self.fields.teamMainUIWidget:setVisible(true)
		self.fields.teamMainUIWidget:getEffect():initData()
	else
		self.fields.teamMainUIWidget:setVisible(false)
	end
	self:updateLostRuinsNode()
	self:updateWindTowerNode()
	self:updateSnowWolfLostNode()
	self:updateIceDragonLostNode()
end
function mainUITop:refreshNewTrialUI()
	local devilValleyCtrl = SoraDGetCtrl("devilValleyCtrl")
	if devilValleyCtrl:hasTeams() and not worldMapDefine.inInCrossWar() then
		self.fields.newTrialMainUI:setEffectPath("newTrialMainUI")
		self.fields.newTrialMainUI:setVisible(self.currentViewType == VIEW_TYPE_CITY)
		if self.currentViewType == VIEW_TYPE_CITY then
			self.fields.newTrialMainUI:getEffect():initData()
		end
	else
		self.fields.newTrialMainUI:setVisible(false)
	end
	self:updateLostRuinsNode()
	self:updateWindTowerNode()
	self:updateSnowWolfLostNode()
	self:updateIceDragonLostNode()
end
function mainUITop:updatePlayer(isFirst)
	self.fields.btn_head:initData(self.lordInfo)
	if isFirst then
		self.fields.btn_power:setPower(self.lordInfo.totalFc)
	end
end
function mainUITop:updateVip()
	self.fields.btn_vip:initData()
end
function mainUITop:updateNewDay()
	self:updateVip()
	self:updateRechargeRedPoint()
end
function mainUITop:updateGold()
	self.fields.com_gold:updateGold()
end
function mainUITop:msgInvitedInfo()
	local remainsTeamCtrl = SoraDGetCtrl("remainsTeamCtrl")
	if remainsTeamCtrl:isHasInvitedInfo() and not SoraDSearchPanelFromManagerByName("teamInvitedView") and SoraDIsGameGuide() == nil then
		SoraDCreatePanel("teamInvitedView"):show()
	end
end
function mainUITop:refreshNodeEvent()
	if worldMapDefine.isInNewTrial() then
		self.fields.Node_event:setVisible(false)
		self.fields.Node_crazy:setVisible(false)
		self.fields.Node_recharge:setVisible(false)
		self.fields.Node_rechargeLucky:setVisible(false)
		self.fields.Node_sultansBack:setVisible(false)
		self.fields.Node_recruitment:setVisible(false)
		self.fields.Node_choiceLucky:setVisible(false)
		self.fields.Node_newServerBack:setVisible(false)
		self.fields.Node_activity9001605:setVisible(false)
		self.fields.Node_activity9001614:setVisible(false)
		self.fields.Node_activity9001711:setVisible(false)
	else
		self:refreshEventCenter()
		self:initCrazyBtn()
		self:initRechargeBtn()
		self:initLuckyBtn()
		self:initNewJourney()
		self:initSultansBackNode()
		self:initHeroGiftBtn()
		self:initNewServerBackNode()
		self:initRecruitmentBtn()
		self:initActivity9001605Btn()
		self:initActivity9001614Btn()
		self:initActivity9001711Btn()
	end
	self:rangeLeftNodes()
end
function mainUITop:getResTarget(resid)
	return self.fields.com_res:getResTarget(resid)
end
function mainUITop:onBtnCheatClick()
	SoraDPlaySound()
	uiManager:show("CheatView")
end
function mainUITop:onBtnTestClick()
	SoraDPlaySound()
	package.loaded["app.game.clientFilter.shenmiButton"] = nil
	include("shenmiButton").new()
end
function mainUITop:onBtnHeadClick()
	if self.lordInfo.avatar and self.lordInfo.avatar ~= "" then
		SoraDPlaySound()
	else
		SoraDPlaySound("headClick", self.lordInfo.imageId)
	end
	SoraDOpenLordView(lordInfoCtrl:getLordInfo())
	_ENV = lordInfoCtrl:getLordInfo()
	lordInfoCtrl:getLordInfo().msg = "MESSAGE_MAINCITYVIEW_LEAVE_MOVE_MODE"
	SoraDSendMessage(lordInfoCtrl:getLordInfo())
end
function mainUITop:getNodeLTTarget(name)
	return self.fields.Node_area_lt:getTarget(name)
end
function mainUITop:getTarget(name)
	return self.fields[name]
end
function mainUITop:getNodeAreaRT()
	return self.fields.Node_area_rt
end
function mainUITop:getNodeAreaLT()
	return self.fields.Node_area_lt
end
function mainUITop:getNodeAreaTop()
	return self.fields.Node_area_t
end
function mainUITop:setGuideContorller(index)
	self.controllers.guide:setSelectedIndex(1 < index and 1 or index)
end
function mainUITop:updateNebulaAllStarUITop(viewType)
	if worldMapDefine.isInNebulaAllStar(true) then
		if not self.nebulaAllStarUITop then
			local obj = fgui.UIPackage:createObject("MainUI", "nebulaAllStarUITop")
			obj:addTo(self.fields.nebulaAllStarUITop)
			obj:setWidth(self:getWidth())
			obj:setName("nebulaAllStarUITop")
			self.nebulaAllStarUITop = obj
		end
		local showUI = viewType == VIEW_TYPE_CITY
		self.nebulaAllStarUITop:setVisible(not showUI)
		self.nebulaAllStarUITop:initData()
		self.fields.Node_area_rt:setVisible(showUI)
	elseif self.nebulaAllStarUITop then
		self.nebulaAllStarUITop:setVisible(false)
		self.fields.Node_area_rt:setVisible(true)
	end
end
function mainUITop:updateWarUITop(viewType, isInCenter)
	local targetKClass = gKingdomClassType.normal
	for kClass, v in pairs(worldMapDefine.warBarrageCfg) do
		local barrageCfg = worldMapDefine.getBarrageCfg(kClass)
		if barrageCfg.showCondition() then
			targetKClass = kClass
		end
	end
	local barrageCfg = worldMapDefine.getBarrageCfg(targetKClass)
	if barrageCfg.showCondition() then
		if not self.Com_warUITop then
			local obj = fgui.UIPackage:createObject("MainUI", "Com_warUITop")
			obj:getChild("Com_barrage"):init(targetKClass)
			obj:addTo(self.fields.nebulaAllStarUITop)
			obj:setWidth(self:getWidth())
			obj:setName("Com_warUITop")
			self.Com_warUITop = obj
		end
		local showUI = viewType == VIEW_TYPE_CITY
		if self.currentViewType == VIEW_TYPE_CITY and viewType ~= VIEW_TYPE_CITY then
			_UPVALUE1_ = self:getWidth()
			self:getWidth()[1] = ffa.delay(2)
			self:getWidth()[2] = ffa.callFunc(function()
				self.Com_warUITop:setVisible(not showUI and self.isInCenter)
			end)
			self:getWidth()[3] = ffa.callFunc(function()
				self.Com_warUITop:setVisible(not showUI and self.isInCenter)
			end)
			self.Com_warUITop:runAction(ffa.seq(self:getWidth()))
		else
			self.Com_warUITop:setVisible(not showUI and isInCenter)
		end
	elseif self.Com_warUITop then
		self.Com_warUITop:setVisible(false)
	end
end
function mainUITop:updateRoaringFlameUITop(viewType)
	if worldMapDefine.isInRoaringFlame() then
		if not self.roaringFlameWarInfo then
			local obj = fguiHelper.createObject("RoaringFlameWorldMap", "roaringFlameWarInfo")
			obj:addTo(self.fields.nebulaAllStarUITop)
			obj:setPositionX(self:getWidth() / 2)
			obj:setName("roaringFlameWarInfo")
			self.roaringFlameWarInfo = obj
			self.fields.nebulaAllStarUITop:setLocalZOrder(1)
			self.fields.Button_cheat:setLocalZOrder(1)
			self.fields.Button_test:setLocalZOrder(1)
		end
		local showUI = viewType == VIEW_TYPE_CITY
		self.roaringFlameWarInfo:initData(not showUI)
		self:getNodeLTTarget("troop"):setPositionY(94)
	else
		if self.roaringFlameWarInfo then
			self.roaringFlameWarInfo:setVisible(false)
		end
		self:getNodeLTTarget("troop"):setPositionY(20)
	end
end
return mainUITop
