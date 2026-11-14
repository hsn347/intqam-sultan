local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local signRewardCtrl = SoraDGetCtrl("signRewardCtrl")
local signRewadRead = include("signRewadRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001038_MainPanel = class("Activity_9001038_MainPanel", baseFguiPanel)
function Activity_9001038_MainPanel:ctor(...)
	Activity_9001038_MainPanel.super.ctor(self, ...)
	print("Activity_9001038_MainPanel:ctor", self.viewName)
end
function Activity_9001038_MainPanel:onInit()
	print("=======Activity_9001038_MainPanel:onInit")
	self.signArray, _ENV, self.totalArray, _ENV, self.activityID = gActivityTimeActivityID.SIGN_REWARD_ACTIVITY, gActivityTimeActivityID.SIGN_REWARD_ACTIVITY, gActivityTimeActivityID.SIGN_REWARD_ACTIVITY, gActivityTimeActivityID.SIGN_REWARD_ACTIVITY, gActivityTimeActivityID.SIGN_REWARD_ACTIVITY
	self.fields.Com_title:initData(i18n("activity_name_9001038"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.Text_title:setString(i18n("common_text_2876"))
	self.fields.Text_tip:setString(i18n("common_text_2882"))
	self.fields.Com_bg:setGradientColor()
	self.fields.List_total:setItemRenderer(handler(self, self.onTotalRenderer))
	self.fields.List_total:setAlignCenter(true)
	self.fields.List_day:setItemRenderer(handler(self, self.onDayRenderer))
end
function Activity_9001038_MainPanel:onTotalRenderer(index, obj)
	obj:initData(self.totalArray[index + 1], index + 1)
end
function Activity_9001038_MainPanel:onDayRenderer(index, obj)
	obj:initData(self.signArray[index + 1])
end
function Activity_9001038_MainPanel:onShow()
	print("=======Activity_9001038_MainPanel:onShow")
	local startDate = activityShowCtrl:getBeginTimeSecond(self.activityID)
	local endDate = activityShowCtrl:getEndTimeSecond(self.activityID)
	if SoraDFIsRA() then
		_ENV = nil
		;(nil).sd = _pq(os.date("%Y-%m-%d", endDate))
		;(nil).ed = _pq(os.date("%Y-%m-%d", startDate))
		self.fields.Text_serverTime:setString(i18n("common_text_2880", nil))
	else
		_ENV = i18n("common_text_2880", nil)
		i18n("common_text_2880", nil).sd = _pq(os.date("%Y-%m-%d", startDate))
		i18n("common_text_2880", nil).ed = _pq(os.date("%Y-%m-%d", endDate))
		self.fields.Text_serverTime:setString(i18n("common_text_2880", i18n("common_text_2880", nil)))
	end
	self:initData()
end
function Activity_9001038_MainPanel:initData()
	self:initView()
end
function Activity_9001038_MainPanel:initView()
	local totalSignDays = signRewardCtrl:getTotalSignDay()
	signRewardCtrl = nil
	;(nil).day = fguiHelper.getColorString("#00FF00", totalSignDays)
	self.fields.Text_totalDay:setString(i18n("common_text_2879", nil))
	self.totalArray = signRewardCtrl:getCumuDayArray()
	self.fields.List_total:setNumItems(#self.totalArray)
	self.signArray = signRewardCtrl:getRewardConfig()
	self.fields.List_day:setNumItems(#self.signArray)
end
function Activity_9001038_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Ramadan_2024_test51")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
return Activity_9001038_MainPanel
