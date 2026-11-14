local gametop = gModuleMgr.getObject("gametop")
local devilValleyCtrl = gametop.playertop_:getModule("devilValleyCtrl")
local newTrialMainView = class("newTrialMainView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("newTrialMainView")
	end
	return target
end)
function newTrialMainView:ctor()
	self.isHideCurrentSceneView = true
	self:initWidget()
	self.state = SoraDGetCtrl("activityShowCtrl"):getStateByID(gActivityTimeActivityID.DEVIL_VALLEY_ACTIVITY)
	self:initData()
	SoraDGetCtrl("devilValleyCtrl"):sendReqTeamInfo()
end
function newTrialMainView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_NEWTRIAL_JOINTEAMLIST_REFRESH", function(target, data)
		SoraDCloseLoading(self)
		SoraDRemoveAllAfterPanelFromManager(self, true)
		if devilValleyCtrl:hasTeams() then
			self.Button_4:setTitleText(i18n("remains_title_01"))
			local panel = SoraDCreatePanel("newTrialMyTeamView")
			panel:initData()
			panel:show()
		else
			self.Button_4:setTitleText(i18n("devilvalley_btn_01"))
		end
	end)
	SoraDAddMessage(self, "MESSAGE_NEWTRIAL_TEAM_REFRESH", function(target, data)
		if devilValleyCtrl:hasTeams() then
			self.Button_4:setTitleText(i18n("remains_title_01"))
		else
			self.Button_4:setTitleText(i18n("devilvalley_btn_01"))
		end
		SoraDGetCtrl("devilValleyCtrl"):sendReqTeamInfo()
	end)
	SoraDAddMessage(self, "MESSAGE_NEWTRIAL_TEAMLIST_REFRESH", function(target, data)
		self.Text_4:setString(devilValleyCtrl:getTeamListNums())
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeEventClose))
	SoraDAddMessage(self, "MESSAGE_NEWTRIAL_REFRESH_AWARD", handler(self, self.updateRedPacketTip))
end
function newTrialMainView:initWidget(...)
	self.Top_Image_bg = SoraDGetChildByName(self, "Top_Image_bg")
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("devilvalley_text_01"))
	devilValleyCtrl = i18n("devilvalley_text_01")
	i18n("devilvalley_text_01")[1] = "Button_help"
	self.Button_help = SoraDGetChildByFullPath(self.Top_Node, i18n("devilvalley_text_01"))
	self.Center_Node = SoraDGetChildByName(self, "Top_Node_2")
	devilValleyCtrl = "Top_Node_2"
	;("Top_Node_2")[1] = "Text_1"
	self.Text_1 = SoraDGetChildByFullPath(self.Center_Node, "Top_Node_2")
	devilValleyCtrl = "Top_Node_2"
	;("Top_Node_2")[1] = "Text_2"
	self.Text_2 = SoraDGetChildByFullPath(self.Center_Node, "Top_Node_2")
	devilValleyCtrl = "Top_Node_2"
	;("Top_Node_2")[1] = "Button_1"
	self.Button_1 = SoraDGetChildByFullPath(self.Center_Node, "Top_Node_2")
	devilValleyCtrl = "Top_Node_2"
	;("Top_Node_2")[1] = "Button_2"
	self.Button_2 = SoraDGetChildByFullPath(self.Center_Node, "Top_Node_2")
	devilValleyCtrl = "Top_Node_2"
	;("Top_Node_2")[1] = "Button_3"
	self.Button_3 = SoraDGetChildByFullPath(self.Center_Node, "Top_Node_2")
	devilValleyCtrl = "Top_Node_2"
	;("Top_Node_2")[1] = "Button_4"
	self.Button_4 = SoraDGetChildByFullPath(self.Center_Node, "Top_Node_2")
	devilValleyCtrl = "Top_Node_2"
	;("Top_Node_2")[1] = "Node_state1"
	self.Node_state1 = SoraDGetChildByFullPath(self.Center_Node, "Top_Node_2")
	devilValleyCtrl = "Top_Node_2"
	;("Top_Node_2")[1] = "Text_3"
	self.Text_3 = SoraDGetChildByFullPath(self.Node_state1, "Top_Node_2")
	devilValleyCtrl = "Top_Node_2"
	;("Top_Node_2")[1] = "Text_4"
	self.Text_4 = SoraDGetChildByFullPath(self.Node_state1, "Top_Node_2")
	devilValleyCtrl = "Top_Node_2"
	;("Top_Node_2")[1] = "Node_state2"
	self.Node_state2 = SoraDGetChildByFullPath(self.Center_Node, "Top_Node_2")
	devilValleyCtrl = "Top_Node_2"
	;("Top_Node_2")[1] = "Text_countdown"
	self.Text_countdown = SoraDGetChildByFullPath(self.Node_state2, "Top_Node_2")
	self.Text_countdown = SoraDCreateTimerLabel(self, self.Text_countdown)
	self.Text_countdown:setTimeEndListener(function()
		self.state = SoraDGetCtrl("activityShowCtrl"):getStateByID(gActivityTimeActivityID.DEVIL_VALLEY_ACTIVITY)
		self:initData()
	end)
	self.Text_countdown:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_606", nil)
	end)
	self.Button_help:addTouchEventListener(handler(self, self.btnClickCallback))
	local beginHour, endHour = devilValleyCtrl:getBeginAndEndHour()
	_ENV = handler(self, self.btnClickCallback)
	handler(self, self.btnClickCallback).time1 = beginHour .. ":00"
	handler(self, self.btnClickCallback).time2 = endHour .. ":00"
	self.Text_1:setString(i18n("devilvalley_text_04") .. "\n" .. i18n("devilvalley_text_05", handler(self, self.btnClickCallback)))
	self.Text_2:setString(i18n("devilvalley_text_06"))
	self.Text_3:setString(i18n("devilvalley_text_07"))
	self.Button_1:addTouchEventListener(handler(self, self.btnClickCallback))
	self.Button_2:addTouchEventListener(handler(self, self.btnClickCallback))
	self.Button_3:addTouchEventListener(handler(self, self.btnClickCallback))
	self.Button_4:setTitleText(i18n("devilvalley_btn_01"))
	self.Button_4:addTouchEventListener(handler(self, self.btnClickCallback))
	SoraDAutoSizeButtonText(self.Button_4, cc.size(200, 40))
	self.spGreen = SoraDGetChildByName(self, "Sprite_green")
	local offsety = display.height - 1136
	if offsety < 0 then
		local scale = display.height / 1136
		self.Center_Node:setScale(scale)
	else
		self.Center_Node:setPositionY(self.Center_Node:getPositionY() - offsety / 2)
		self.Top_Image_bg:setScale((offsety + 1079) / 1079)
		self.Top_Image_bg:loadTexture("bg_mgyzz1.png", ccui.TextureResType.plistType)
	end
	self.Button_help:setVisible(IsArClient)
end
function newTrialMainView:initData(...)
	if self.state == gActivityState.OPEN then
		self.Node_state1:setVisible(true)
		self.Node_state2:setVisible(false)
		SoraDToCenter(self.Node_state1, 10)
		self.Button_4:setBright(true)
		self.Text_3:setVisible(true)
	else
		self.Node_state1:setVisible(false)
		self.Node_state2:setVisible(true)
		self.Button_4:setBright(false)
		self.Text_3:setVisible(false)
		local beginTime = SoraDGetCtrl("activityShowCtrl"):getBeginTimeSecond(gActivityTimeActivityID.DEVIL_VALLEY_ACTIVITY)
		local leftTime = beginTime - serviceFunctions.systemTime()
		if 0 < leftTime then
			_ENV = nil
			;(nil).time = leftTime
			self.Text_countdown:setString(i18n("common_text_606", nil))
			self.Text_countdown:beginTime(leftTime)
			SoraDToCenter(self.Node_state2)
		end
	end
	if devilValleyCtrl:hasTeams() then
		self.Button_4:setTitleText(i18n("remains_title_01"))
	else
		self.Button_4:setTitleText(i18n("devilvalley_btn_01"))
	end
	self:updateRedPacketTip()
end
function newTrialMainView:btnClickCallback(button, type)
	if type ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	if button == self.Button_help then
		self:btnHelpCallback()
	elseif button == self.Button_1 then
		self:btnStoreCallback()
	elseif button == self.Button_2 then
		self:btnRewardCallback()
	elseif button == self.Button_3 then
		self:btnRankCallback()
	elseif button == self.Button_4 then
		self:btnStartCallback()
	end
end
function newTrialMainView:btnHelpCallback()
	if IsArClient then
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.NEW_TRIAL)
	else
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.NEW_TRIAL_EN)
	end
end
function newTrialMainView:btnStoreCallback()
	SoraDCreatePanel("newTrialStoreView"):show()
end
function newTrialMainView:btnRewardCallback()
	SoraDCreatePanel("newTrialRewardsPopView"):show()
end
function newTrialMainView:btnRankCallback()
	SoraDCreatePanel("newTrialRankView"):show()
end
function newTrialMainView:btnStartCallback()
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	if self.state ~= gActivityState.OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"))
	elseif not allianceMgr:hasJoinAlliance() then
		SoraDShowMsgTip(i18n("common_text_3692"))
	elseif devilValleyCtrl:getIsJoinTooLate() then
		SoraDShowMsgTip(i18n("devilvalley_tips_03"))
	elseif devilValleyCtrl:hasTeams() then
		local panel = SoraDCreatePanel("newTrialMyTeamView")
		panel:initData()
		panel:show()
	else
		SoraDGetCtrl("devilValleyCtrl"):sendReqTeamInfo()
		SoraDCreatePanel("newTrialTeamListView"):show()
	end
end
function newTrialMainView:updateRedPacketTip()
	local showred = devilValleyCtrl:getReceiveStatusAndNum()
	self.spGreen:setVisible(showred)
end
function newTrialMainView:judgeEventClose(target, redata)
	local state = SoraDGetCtrl("activityShowCtrl"):getStateByID(gActivityTimeActivityID.DEVIL_VALLEY_ACTIVITY)
	if gActivityState.CLOSE == state then
		SoraDRemoveAllExceptPanelFromManager(SoraDSearchPanelFromManagerByName("newTrialMyTeamView"))
	end
end
return newTrialMainView
