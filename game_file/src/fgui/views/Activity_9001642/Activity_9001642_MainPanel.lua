local allianceMgr = SoraDGetCtrl("allianceMgr")
local memberMgr = SoraDGetCtrl("memberMgr")
local activity_9001642_Ctrl = SoraDGetCtrl("activity_9001642_Ctrl")
local activity_9001642_Read = include("activity_9001642_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001642_MainPanel = class("Activity_9001642_MainPanel", baseFguiPanel)
function Activity_9001642_MainPanel:ctor(...)
	Activity_9001642_MainPanel.super.ctor(self, ...)
	print("Activity_9001642_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.PHOENIX_CHALLENGE
	self.classType = SoraDGetActivityClassType(self.activityID)
end
function Activity_9001642_MainPanel:onInit()
	print("=======Activity_9001642_MainPanel:onInit")
	self.stageBoxList, _ENV = print, print
	self.fields.Com_title:initData(i18n("activity_name_9001642"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.Text_rankTip = SoraDCreateTimerLabel(self, self.fields.Text_rankTip)
	self.fields.Text_rankTip:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("Phonex_Challenge_text_22", nil)
	end)
	self.fields.Text_rankTip:setTimeEndListener(function()
		self:updateView()
	end)
	self.fields.Btn_reward:setString(i18n("soldier_rush_text_11"))
	self.fields.Btn_reward:addClickListener(handler(self, self.btnRewardClick))
	self.fields.Btn_record:setString(i18n("common_text_2315"))
	self.fields.Btn_record:addClickListener(handler(self, self.btnRecordClick))
	self.fields.Btn_rank:setString(i18n("pyramid_btn_29"))
	self.fields.Btn_rank:addClickListener(handler(self, self.btnRankClick))
	self.fields.Btn_challenge:setString(i18n("common_text_2341"))
	self.fields.Btn_challenge:addClickListener(handler(self, self.btnChallengeClick))
	self.fields.List_box:setItemRenderer(handler(self, self.onBoxRenderer))
	self.fields.Bar_score:setMax(100)
	self.fields.Bar_score:setScaleX(SoraDFIsRA() and 1 or -1)
	self.fields.List_box:fixPos()
	self.fields.Btn_reward:fixPos()
	self.fields.Btn_record:fixPos()
	self.fields.Btn_rank:fixPos()
end
function Activity_9001642_MainPanel:onBoxRenderer(index, obj)
	local data = self.stageBoxList[index + 1]
	obj:initData(data.index, data.point, data.state, data.handle)
end
function Activity_9001642_MainPanel:onShow()
	print("=======Activity_9001642_MainPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	activity_9001642_Ctrl:sendReqInitDataMsg()
	SoraDShowLoading(self)
end
function Activity_9001642_MainPanel:updateView(target, data)
	SoraDCloseLoading(self)
	if allianceMgr:hasJoinAlliance() then
		self.phoenixType = activity_9001642_Ctrl:getPhoenixType()
		self.fields.Text_phoenixType:setString(activity_9001642_Read.getPhoneixStageName(self.phoenixType))
		self.status = activity_9001642_Ctrl:getPhoenixStatus()
		print("self.status====", self.status)
		self.controllers.c1:setSelectedIndex(self.status == 3 and 2 or 1)
		local allianceScore = activity_9001642_Ctrl:getAllianceScore()
		_ENV = activity_9001642_Read.getPhoneixStageName(self.phoenixType)
		activity_9001642_Read.getPhoneixStageName(self.phoenixType).num = fguiHelper.getColorString("#FFDF2D", allianceScore)
		self.fields.Text_point:setString(i18n("Phonex_Challenge_text_5", activity_9001642_Read.getPhoneixStageName(self.phoenixType)))
		self.stageBoxList, _ENV = self.fields.Text_point.setString, self.fields.Text_point.setString
		self.stageList = activity_9001642_Read.getStageList(self.classType, self.phoenixType)
		local _ENV, numList = activity_9001642_Read.getStageList(self.classType, self.phoenixType), activity_9001642_Read.getStageList(self.classType, self.phoenixType)
		for k, v in ipairs(self.stageList) do
			table.insert(numList, v.rankNum)
			_ENV = v.rankNum
			v.rankNum.index = k
			v.rankNum.point = v.rankNum
			v.rankNum.state = 0
			v.rankNum.handle = handler(self, self.onStageBoxClick)
			table.insert(self.stageBoxList, v.rankNum)
		end
		local percent = SoraDGetStageValue(allianceScore, numList)
		self.fields.Bar_score:setValue(percent)
		self.fields.List_box:setNumItems(#self.stageBoxList)
		if self.status == 3 then
			self.fields.Text_tip:setString(i18n("Phonex_Challenge_text_11"))
		else
			local leftTimes = activity_9001642_Ctrl:getChallengeTimes()
			_ENV = i18n("Phonex_Challenge_text_11")
			i18n("Phonex_Challenge_text_11").num = fguiHelper.getColorString(leftTimes == 0 and "#E02B2B" or "#F0E6D2", leftTimes)
			self.fields.Text_leftTimes:setString(i18n("Phonex_Challenge_text_6", i18n("Phonex_Challenge_text_11")))
		end
		if self.status == 2 then
			local leftTime = activity_9001642_Ctrl:getPhoenixLeftTime()
			self.fields.Text_rankTip:beginTime(leftTime)
			self.fields.Text_leftTimes:setVisible(false)
			self.fields.Btn_challenge:setString(i18n("common_text_477"))
		else
			self.fields.Text_rankTip:setString(i18n("Phonex_Challenge_text_7"))
			self.fields.Text_leftTimes:setVisible(true)
			self.fields.Btn_challenge:setString(i18n("common_text_2341"))
		end
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Text_tip:setString(i18n("notice_0066"))
	end
end
function Activity_9001642_MainPanel:btnRewardClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001642_award")
end
function Activity_9001642_MainPanel:btnRecordClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001642_Harm")
end
function Activity_9001642_MainPanel:btnRankClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001642_Rank")
end
function Activity_9001642_MainPanel:onStageBoxClick(index)
	SoraDPlaySound()
	_ENV = nil
	;(nil).reward = self.stageList[index].reward
	uiManager:show("Activity_9001642_AwardPop", nil)
end
function Activity_9001642_MainPanel:btnChallengeClick()
	SoraDPlaySound()
	if self.status == 2 then
		local mapObj = activity_9001642_Ctrl:getPhoenixObj()
		SoraDGotoWorldMapPoint(cc.p(mapObj.x, mapObj.y), true)
		SoraDRemoveAllPanelFromManager()
	else
		local rank = memberMgr:getOwnMember():getProperty("rank")
		if rank < gAllianceRank.R4 then
			SoraDShowMsgTip(i18n("Phonex_Challenge_text_7"))
			activity_9001642_Ctrl:sendReqInitDataMsg()
			return
		end
		if activity_9001642_Ctrl:getChallengeTimes() < 1 then
			SoraDShowMsgTip(i18n("Phonex_Challenge_text_9"))
			return
		end
		_ENV = i18n("Phonex_Challenge_text_9")
		i18n("Phonex_Challenge_text_9").content = i18n("Phonex_Challenge_text_36")
		i18n("Phonex_Challenge_text_9").confirmFunc = function()
			activity_9001642_Ctrl:sendSummonMsg()
		end
		uiManager:show("MessageBox", i18n("Phonex_Challenge_text_9"))
	end
end
function Activity_9001642_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Phonex_Challenge_text_1")
	uiManager:show("RuleView", nil)
end
return Activity_9001642_MainPanel
