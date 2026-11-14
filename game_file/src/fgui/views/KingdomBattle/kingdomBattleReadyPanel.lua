local conquestWarReinforcementsCtrl = SoraDGetCtrl("conquestWarReinforcementsCtrl")
local gametop = gModuleMgr.getObject("gametop")
local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local kingdomBattleReadyPanel = class("kingdomBattleReadyPanel", baseFguiPanel)
function kingdomBattleReadyPanel:ctor(...)
	self.super.ctor(self, ...)
	print("kingdomBattleReadyPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
	self.shopActivityID = gActivityTimeActivityID.EXCHANGE_MALL_ACTIVITY_9010009
end
function kingdomBattleReadyPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function kingdomBattleReadyPanel:onInit()
	print("=======kingdomBattleReadyPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_2182"), handler(self, self.onClickClose), handler(self, self.btnHelpClick))
	self.fields.Button_go:addClickEventListener(handler(self, self.btnGoClick))
	self.fields.Button_target:addClickEventListener(handler(self, self.btnTargetClick))
	self.fields.Button_rank:addClickEventListener(handler(self, self.btnRankClick))
	self.fields.Button_price:addClickEventListener(handler(self, self.btnPriceClick))
	self.fields.Button_history:addClickEventListener(handler(self, self.btnHistoryClick))
	self.fields.Button_honour:addClickEventListener(handler(self, self.btnHonourClick))
	self.fields.Button_report:addClickEventListener(handler(self, self.btnReportClick))
	self.fields.Button_helper:addClickEventListener(handler(self, self.btnHelperClick))
	self.fields.Button_InviteOption:addClickEventListener(handler(self, self.btnInviteOptionClick))
	self.fields.Button_hospital:addClickEventListener(handler(self, self.btnHospitalSwitchClick))
	self.fields.Button_warList:addClickEventListener(handler(self, self.btnWarListClick))
	self.fields.Button_shop:addClickEventListener(handler(self, self.btnShopClick))
	self.txtReport = self.fields.Button_report:getChild("title")
	self.fields.Button_report:setVisible(false)
	self.fields.Button_honour:setString(i18n("common_text_3361"))
	self.fields.Text_connectTitle:setString(i18n("common_text_2184"))
	self.fields.Button_target:setTitleText(i18n("common_text_3141"))
	self.fields.Button_rank:setTitleText(i18n("common_text_2187"))
	self.fields.Button_price:setTitleText(i18n("common_text_1235"))
	self.fields.Button_history:setTitleText(i18n("common_text_3031"))
	self.fields.Button_helper:setString(i18n("conquestwar_text_11"))
	self.fields.Button_InviteOption:setString(i18n("conquestwar_text_57"))
	self.fields.Button_hospital:setString(i18n("common_text_4759"))
	self.fields.Button_warList:setString(i18n("common_text_4904"))
	self.fields.Button_shop:setString(i18n("allianceWar_shop_title"))
	self.fields.Text_findTips:setString(i18n("common_text_4763"))
	_ENV = i18n("common_text_4763")
	i18n("common_text_4763").byUID = true
	if not SoraDConfigGet("Game:kingdomBattle:hospitalSwitch~bool", i18n("common_text_4763")) then
		self.fields.Button_hospital:setReddot(true, -1)
	end
	self.fields.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.fields.Com_recover:setVisible(false)
	self.fields.Usm_1:setPrepareCallback(function()
		self.fields.Usm_1:play(false)
		self = false
		;(false).frame = 44
		self.fields.Usm_1:getCriSprite():addFrameEventData(false)
		self = false
		;(false).frame = 25
		self.fields.Usm_1:getCriSprite():addFrameEventData(false)
		self.fields.Usm_1:getCriSprite():setFrameEventCallback(handler(self, self.showUsm2))
	end)
end
function kingdomBattleReadyPanel:onShow()
	conquestWarReinforcementsCtrl:sendReqInitDataMsg()
	conquestWarCtrl:getConquestWarInfoReq()
	SoraDShowLoading()
	print("=======kingdomBattleReadyPanel:onShow")
end
function kingdomBattleReadyPanel:initData()
	self.localBattleState = conquestWarCtrl:getConquestWarState()
	self.myTicket = conquestWarCtrl:getLeftTime()
	self:initView()
end
function kingdomBattleReadyPanel:updateRecover()
	local isRecovering = conquestWarCtrl:isRecovering()
	local isKingdomRecovered = conquestWarCtrl:isRecoverd()
	local kingdomRecoverScore = conquestWarCtrl:getRecoverScore()
	if not isKingdomRecovered and not isRecovering then
		self.fields.Com_recover:setVisible(false)
	else
		self.fields.Com_recover:setVisible(true)
		self.fields.Com_recover:initData(isKingdomRecovered, isRecovering, kingdomRecoverScore, self.kingNumForward)
	end
end
function kingdomBattleReadyPanel:initView()
	self.controllers.c1:setSelectedIndex(self.localBattleState - 1)
	self.fields.Button_go:setEnabled(true)
	self.fields.Button_target:setEnabled(true)
	self.kingNumForward = conquestWarCtrl.matchKid
	if gConquestWarState.PREPARE == self.localBattleState then
		self.fields.com_Fight:initdata(false)
		conquestWarCtrl = nil
		;(nil).time = ""
		self.fields.Text_timeTips:setString(i18n("common_text_2554", nil))
		self:setTextTime(self.fields.Text_time, self.myTicket, "common_text_2554")
		self.fields.Button_go:setEnabled(false)
		self.fields.Button_target:setEnabled(false)
		self.fields.Button_helper:setString(i18n("conquestwar_text_11"))
	elseif gConquestWarState.OPENING == self.localBattleState then
		self.fields.com_Fight:initdata(true)
		conquestWarCtrl = i18n("conquestwar_text_11")
		i18n("conquestwar_text_11").time = ""
		self.fields.Text_timeTips:setString(i18n("common_text_2553", i18n("conquestwar_text_11")))
		self:setTextTime(self.fields.Text_time, self.myTicket, "common_text_2553")
		self.fields.Button_helper:setString(i18n("conquestwar_text_12"))
		self:updateRecover()
	elseif gConquestWarState.NOT_MATCH == self.localBattleState then
		conquestWarCtrl = i18n("conquestwar_text_12")
		i18n("conquestwar_text_12").time = ""
		self.fields.Text_timeTips:setString(i18n("common_text_2559", i18n("conquestwar_text_12")))
		self:setTextTime(self.fields.Text_time, self.myTicket, "common_text_2559")
	else
		conquestWarCtrl = "common_text_2559"
		;("common_text_2559").time = ""
		self.fields.Text_timeTips:setString(i18n("common_text_2555", "common_text_2559"))
		self:setTextTime(self.fields.Text_time, self.myTicket, "common_text_2555")
	end
	self:juegeRepotBtn()
	self:updateReinforceButton()
	self:updatRed()
	local nowKingdom = gametop.playertop_:getKingdomID()
	if lordInfoCtrl:getSourceKid() > 0 then
		if self.agreeKindom then
			if self.agreeKindom == gametop.playertop_:getKingdomID() then
				self.fields.Button_go:setTitleText(i18n("common_text_2186"))
				self.fields.Button_helper:setString(i18n("common_text_4256"))
			elseif self.agreeMatchKindom == gametop.playertop_:getKingdomID() then
				self.fields.Button_go:setTitleText(i18n("conquestwar_text_47"))
				self.fields.Button_helper:setString(i18n("common_text_4256"))
			else
				self.fields.Button_go:setTitleText(i18n("common_text_2718"))
			end
		else
			self.fields.Button_go:setTitleText(i18n("common_text_2718"))
		end
	else
		self.fields.Button_go:setTitleText(i18n("common_text_2186"))
	end
end
function kingdomBattleReadyPanel:updateReinforceButton()
	local needLv = include("constantRead").getConstValue("CONQUESTWAR_REINFORCEMENT_CASTLE", 64)
	local isTriggerReinforcements = conquestWarCtrl:isTriggerReinforcements()
	local isVisible = SoraDIsSelfKing() and isTriggerReinforcements
	local isVisible2 = conquestWarCtrl:isCanReinforce() and needLv <= SoraDGetBuildStarLv()
	self.agreeKindom, self.agreeMatchKindom = conquestWarReinforcementsCtrl:getAgreeKindom()
	local isVisible3 = self.agreeKindom and true or false
	print("isVisible2", isTriggerReinforcements, isVisible2, isVisible, isVisible3, lordInfoCtrl:getSourceKid(), conquestWarCtrl:getReinforceEndTime(), conquestWarCtrl:getSettingReinforceLefttime())
	self.reinforceTime = 0
	self.fields.Button_InviteOption:setVisible(false)
	self.fields.Button_InviteOption:setEnabled(true)
	self.fields.Button_helper:setVisible(false)
	self.fields.Node_findTips:setVisible(false)
	self.fields.Button_InviteOption:setReddot(0 < conquestWarCtrl:getReinforceSettingRedNum(), -1)
	if gConquestWarState.PREPARE == self.localBattleState then
		self.fields.GroupButtons:setColumnGap(6)
		if conquestWarCtrl:getSettingReinforceLefttime() > 0 then
			self.fields.Button_go:setVisible(not SoraDIsSelfKing())
			self.fields.Button_InviteOption:setVisible(SoraDIsSelfKing())
			self.fields.Button_InviteOption:setString(i18n("conquestwar_text_59"))
		elseif 0 < conquestWarCtrl:getReinforceShowLefttime() then
			self.fields.Node_findTips:setVisible(conquestWarCtrl:gettoBeReinforcHost())
			self.fields.Button_go:setVisible(true)
		else
			self.fields.Button_go:setVisible(true)
			self.fields.Button_helper:setVisible(isVisible or isVisible2)
		end
	elseif gConquestWarState.NOT_MATCH == self.localBattleState then
		self.fields.GroupButtons:setColumnGap(100)
		if conquestWarCtrl:getSettingReinforceLefttime() > 0 then
			self.fields.Button_InviteOption:setVisible(SoraDIsSelfKing())
			self.fields.Button_InviteOption:setString(i18n("conquestwar_text_59"))
		elseif 0 < conquestWarCtrl:getReinforceShowLefttime() then
		elseif conquestWarCtrl:getReinforceEndTime() > 0 then
			self.fields.Button_helper:setVisible(isVisible2)
			self.fields.Button_helper:setString(i18n("conquestwar_text_11"))
		else
			self.fields.Button_helper:setVisible(isVisible3)
			self.fields.Button_helper:setString(i18n("conquestwar_text_12"))
		end
	elseif gConquestWarState.OPENING == self.localBattleState then
		self.fields.GroupButtons:setColumnGap(6)
		self.fields.Button_helper:setVisible(isVisible3)
	elseif gConquestWarState.WAITING == self.localBattleState then
		self.fields.GroupButtons:setColumnGap(100)
		self.fields.Button_InviteOption:setVisible(SoraDIsSelfKing())
		self.fields.Button_InviteOption:setString(i18n("conquestwar_text_57"))
		print("conquestWarCtrl:getSettingWaitingLefttime()", conquestWarCtrl:getSettingWaitingLefttime())
		if 0 >= conquestWarCtrl:getSettingWaitingLefttime() then
			self.reinforceTime = conquestWarCtrl:getSettingWaitingLefttime()
			self.fields.Button_InviteOption:setEnabled(false)
		end
	end
	if self.reinforceTime > 0 and self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
		self:openTimeUp()
	elseif self.reinforceTime <= 0 and self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
end
function kingdomBattleReadyPanel:openTimeUp()
	if self.reinforceTime <= 0 then
		if self.timer then
			self:updateReinforceButton()
		end
	else
		self.reinforceTime = self.reinforceTime - 1
	end
end
function kingdomBattleReadyPanel:updatRed()
	local haveHelpMessage, _ = conquestWarReinforcementsCtrl:getReceiveStatusAndNum()
	self.fields.Button_helper:setReddot(haveHelpMessage, -1)
	self.fields.Button_price:getChild("icon_up"):setVisible(conquestWarCtrl:isDoubleReward())
	local ret, num = activityExchangeMallCtrl:getReceiveStatusAndNum(self.shopActivityID)
	self.fields.Button_shop:setReddot(ret, num)
end
function kingdomBattleReadyPanel:setTextTime(ocx, ticket, _langStr)
	ocx:endTime()
	ocx:beginTime(ticket)
end
function kingdomBattleReadyPanel:juegeRepotBtn(...)
	local betrayQueueType = 100
	local timer = conquestWarCtrl:queryQueue(betrayQueueType)
	local hideReport = function(bool)
		local channel = userSDKManager.getChannel()
		if channel == "ar" then
			self.fields.Button_report:setVisible(bool)
			self.txtReport:setVisible(bool)
		else
			self.fields.Button_report:setVisible(false)
		end
	end
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.txtReport = SoraDCreateTimerLabel(self, self.txtReport)
		self.txtReport:setTimeLast(function(str)
			_ENV = nil
			;(nil).time = str
			local reText = i18n("common_text_4173", nil)
			return reText
		end)
		self.txtReport:setTimeEndListener(function(...)
			hideReport(false)
			hideReport = false
			;(false).msg = "MESSAGE_WORLD_MAP_CONQUESTWAR_REPORTTIMEOUT"
			SoraDSendMessage(false)
		end)
		self.txtReport:beginTime(leftTime)
		hideReport(true)
	else
		hideReport(false)
	end
end
function kingdomBattleReadyPanel:btnTargetClick(button, type)
	SoraDPlaySound()
	if gConquestWarState.PREPARE == self.localBattleState then
		SoraDShowMsgTip(i18n("common_text_2830"))
		return
	end
	uiManager:show("KingdomBattleTarget")
end
function kingdomBattleReadyPanel:btnGoClick(button, type)
	SoraDPlaySound()
	if gConquestWarState.PREPARE == self.localBattleState then
		SoraDShowMsgTip(i18n("common_text_2830"))
		return
	end
	SoraDGotoWorldMapPoint(cc.p(600, 600), false, self.kingNumForward)
	SoraDRemoveAllPrePanelFromManager(self)
end
function kingdomBattleReadyPanel:btnHelpClick(button, type)
	SoraDPlaySound()
	userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.KINGDOMBATTLE_HELP)
end
function kingdomBattleReadyPanel:btnPriceClick(button, type)
	SoraDPlaySound()
	uiManager:show("kingdomBattlePrice")
end
function kingdomBattleReadyPanel:btnHistoryClick(button, type)
	SoraDPlaySound()
	uiManager:show("kingdomBattleHistory")
end
function kingdomBattleReadyPanel:btnHonourClick(button, type)
	SoraDPlaySound()
	uiManager:show("kingdomBattleHonourBoard")
end
function kingdomBattleReadyPanel:btnReportClick(button, type)
	SoraDPlaySound()
	uiManager:show("kingdomBattleReport")
end
function kingdomBattleReadyPanel:btnRankClick(button, type)
	SoraDPlaySound()
	uiManager:show("kingdomBattleRank")
end
function kingdomBattleReadyPanel:btnHelperClick()
	SoraDPlaySound()
	if self.agreeKindom and conquestWarCtrl:getReinforceEndTime() <= 0 then
		local kingdom = self.agreeKindom
		if 0 < lordInfoCtrl:getSourceKid() then
			if self.agreeKindom == gametop.playertop_:getKingdomID() then
				kingdom = lordInfoCtrl:getSourceKid()
			elseif self.agreeMatchKindom == gametop.playertop_:getKingdomID() then
				SoraDShowMsgTip(i18n("conquestwar_text_54"))
				return
			else
				SoraDShowMsgTip(i18n("atlantiswar_text_0009"))
				return
			end
		end
		SoraDGotoWorldMapPoint(cc.p(600, 600), false, kingdom)
		SoraDRemoveAllPrePanelFromManager(self)
	else
		uiManager:show("kingdomBattleInvitation")
	end
end
function kingdomBattleReadyPanel:btnInviteOptionClick()
	SoraDPlaySound()
	if SoraDIsSelfKing() then
		if gConquestWarState.WAITING == self.localBattleState then
			_ENV = nil
			;(nil).viewType = 2
			uiManager:show("kingdomBattleOptions", nil)
		else
			_ENV = nil
			;(nil).viewType = 1
			uiManager:show("kingdomBattleOptions", nil)
		end
		_ENV = conquestWarCtrl
		conquestWarCtrl.byUID = true
		SoraDConfigSet("Game:kingdomBattle:prepareStatTime~string", conquestWarCtrl:getQueueStartTime(CONQUESTWAR_TO_BE_REINFORCE_QUEUE_KEY), conquestWarCtrl)
		self.fields.Button_InviteOption:setReddot(false)
		_ENV = self.fields.Button_InviteOption
		self.fields.Button_InviteOption.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.fields.Button_InviteOption.eventID = gActivityTimeActivityID.KINGDOM_BATTLE
		SoraDSendMessage(self.fields.Button_InviteOption)
	else
		SoraDShowMsgTip(i18n("conquestwar_text_56"))
	end
end
function kingdomBattleReadyPanel:btnHospitalSwitchClick()
	SoraDPlaySound()
	uiManager:show("kingdomBattleHospitalSwitch")
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:kingdomBattle:hospitalSwitch~bool", true, nil)
	self.fields.Button_hospital:setReddot(false)
end
function kingdomBattleReadyPanel:btnWarListClick()
	SoraDPlaySound()
	uiManager:show("kingdomBattleWarList")
end
function kingdomBattleReadyPanel:btnShopClick()
	SoraDPlaySound()
	if not clientEventMgr.judgeIsOpen(self.shopActivityID) then
		SoraDShowMsgTip(i18n("common_text_2486"))
		return
	end
	local commonExchangeUtil = include("commonExchangeUtil")
	commonExchangeUtil.openView(self.shopActivityID)
end
function kingdomBattleReadyPanel:showUsm2(info)
	print("showUsm2", self.fields.Usm_1:getCriSprite():getTotalFrame(), info.frame)
	if info and info.frame and 44 == self.fields.Usm_1:getCriSprite():getCurPlayFrame() then
		self.fields.Usm_2:play(true)
		self.fields.Usm_2:getCriSprite():setSpeed(2, 3)
	elseif info and info.frame and 25 == self.fields.Usm_1:getCriSprite():getCurPlayFrame() then
		self.fields.Usm_1:getCriSprite():setSpeed(2, 3)
	end
end
return kingdomBattleReadyPanel
