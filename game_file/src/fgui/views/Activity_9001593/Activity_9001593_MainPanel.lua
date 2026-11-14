local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001593_MainPanel = class("Activity_9001593_MainPanel", baseFguiPanel)
function Activity_9001593_MainPanel:ctor(...)
	Activity_9001593_MainPanel.super.ctor(self, ...)
	print("Activity_9001593_MainPanel:ctor", self.viewName)
end
function Activity_9001593_MainPanel:onInit()
	print("=======Activity_9001593_MainPanel:onInit")
	self.activityID = gActivityTimeActivityID.CALENDAR_9001593_ACTIVITY
	self.fields.Com_title:initData(i18n("activity_name_9001593"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.Text_tip:setString(i18n("ramadan_pilgrimage_text03"))
	self.fields.Text_tip:setVisible(false)
	self.fields.Btn_open:setString(i18n("ramadan_pilgrimage_text01"))
	self.fields.Btn_open:addClickListener(handler(self, self.btnOpenClick))
end
function Activity_9001593_MainPanel:onShow()
	print("=======Activity_9001593_MainPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self:initData()
end
function Activity_9001593_MainPanel:initData()
	local activityData = activityShowCtrl:getActivityData(self.activityID)
	self.isOpen = activityData.doStage and activityData.doStage == 1 or false
	self.fields.Btn_open:setBright(self.isOpen)
	activityShowCtrl = self.isOpen
	self.isOpen.byUID = true
	local _isShowNew = SoraDConfigGet("Game:Activity_9001593_Main:new~bool", self.isOpen) or false
	print("_isShowNew========", _isShowNew, self.isOpen)
	local isShowNew = self.isOpen and not _isShowNew
	self.fields.Btn_open:getChildByName("new"):setVisible(isShowNew)
	if isShowNew then
		activityShowCtrl = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:Activity_9001593_Main:new~bool", true, nil)
	end
	self.fields.Text_tip:setVisible(self.isOpen)
	self.fields.Com_title:getLabelTime():setVisible(not self.isOpen)
	for hole = 1, 3 do
		self.fields["activity" .. hole]:initActivity(hole, 1)
	end
	local showConfig = activityShowCtrl:getParamByID(self.activityID).showConfig
	for week = 1, 4 do
		if showConfig[week] then
			self.fields["week" .. week]:setVisible(true)
			self.fields["week" .. week]:initWeek(week, showConfig[week], 1)
		else
			self.fields["week" .. week]:setVisible(false)
		end
	end
end
function Activity_9001593_MainPanel:btnOpenClick()
	SoraDPlaySound()
	if not self.isOpen then
		SoraDShowMsgTip(i18n("common_text_2486"))
		return
	end
	uiManager:show("Activity_9001593_MainOpen")
end
function Activity_9001593_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("ramadan_pilgrimage_text04")
	uiManager:show("RuleView", nil)
end
return Activity_9001593_MainPanel
