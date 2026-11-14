local activityTimeRead = include("activityTimeRead")
local rechargePresentUtil = include("rechargePresentUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local hanselactivityPanel = class("hanselactivityPanel", baseFguiPanel)
function hanselactivityPanel:ctor(...)
	self.super.ctor(self, ...)
	print("hanselactivityPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NEW_YEAR_RECAHRGE_PRESENT
end
function hanselactivityPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity2112"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
	end
	return self._packageList
end
function hanselactivityPanel:onInit()
	print("=======hanselactivityPanel:onInit")
	if IsArClient then
		self.fields.Button_help:addClickListener(handler(self, self.onClickBtnHelp))
	else
		self.fields.Button_help:setVisible(false)
	end
	local activityName = activityTimeRead.getActivityNameByID(self.activityID)
	self.fields.Text_title:setString(i18n(activityName))
	self.fields.Text_explain:setString(i18n("NewYear_Gift_01"))
	local com_lab = self.fields.com_lab
	com_lab:getChild("Text_key"):setString(i18n("sheepFeed_text_10"))
	self.Text_value = com_lab:getChild("Text_value")
	com_lab:fixChildrenPos()
	local Button_go = self.fields.Button_go
	Button_go:getChild("Button_go"):setString(i18n("common_text_477"))
	Button_go:addClickListener(handler(self, self.onClickBtnGo))
	self:initActivityTime()
	self:updateePresentGold()
end
function hanselactivityPanel:onShow()
	print("=======hanselactivityPanel:onShow")
end
function hanselactivityPanel:initActivityTime(...)
	local eventTime = rechargePresentUtil.getActivityLeftTime(self.activityID)
	if eventTime and 0 < eventTime then
		local com_time = self.fields.com_time
		local Text_time = SoraDCreateTimerLabel(com_time, com_time:getChild("Text_time"))
		Text_time:beginTime(eventTime)
	end
end
function hanselactivityPanel:updateePresentGold()
	local rechargePresentCtrl = SoraDGetCtrl("rechargePresentCtrl")
	local presentGold = rechargePresentCtrl:getRechargePresentGold(self.activityID)
	self.Text_value:setString(string.formatnumberthousands(presentGold))
end
function hanselactivityPanel:onClickBtnGo(...)
	SoraDPlaySound()
	rechargePresentUtil.openRechargeView(self.activityID)
	self:closePanel()
end
function hanselactivityPanel:onClickBtnHelp()
	SoraDPlaySound()
	userSDKManager.showSingleFAQ(_G.gSDKDef.FAQSingleType.NEW_YEAR_PRESENT)
end
return hanselactivityPanel
