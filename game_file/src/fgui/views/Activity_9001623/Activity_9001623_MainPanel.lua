local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activityCommonSignCtrl = SoraDGetCtrl("activityCommonSignCtrl")
local activityCommonSignRead = include("activityCommonSignRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001623_MainPanel = class("Activity_9001623_MainPanel", baseFguiPanel)
function Activity_9001623_MainPanel:ctor(...)
	Activity_9001623_MainPanel.super.ctor(self, ...)
	print("Activity_9001623_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.SIGN_REWARD_9001623_ACTIVITY
end
function Activity_9001623_MainPanel:onInit()
	print("=======Activity_9001623_MainPanel:onInit")
	self.totalArray = activityCommonSignRead.getCumuDayArray(self.activityID)
	self.signArray = activityCommonSignRead.getRewardConfig(self.activityID)
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_title:setString(i18n("common_text_2876"))
	self.fields.List_total:setItemRenderer(handler(self, self.onTotalRenderer))
	self.fields.List_day:setItemRenderer(handler(self, self.onDayRenderer))
	self.fields.Text_tip:setString(i18n("common_text_2882"))
end
function Activity_9001623_MainPanel:onShow()
	print("=======Activity_9001623_MainPanel:onShow")
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
function Activity_9001623_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Ramadan_2024_test51")
	uiManager:show("RuleView", nil)
end
function Activity_9001623_MainPanel:onTotalRenderer(index, obj)
	local day = self.totalArray[index + 1]
	_UPVALUE0_ = nil
	;(nil).activityID = self.activityID
	;(nil).day = day
	obj:initData(nil)
end
function Activity_9001623_MainPanel:onDayRenderer(index, obj)
	_UPVALUE0_ = nil
	;(nil).activityID = self.activityID
	;(nil).day = index + 1
	obj:initData(nil)
end
function Activity_9001623_MainPanel:initData()
	self:updateTotalSignDays()
	self:updateListTotal()
	self:updateListDay()
end
function Activity_9001623_MainPanel:updateTotalSignDays(...)
	local totalSignDays = activityCommonSignCtrl:getTotalSignDay(self.activityID)
	activityCommonSignCtrl = nil
	;(nil).day = fguiHelper.getColorString("#00FF00", totalSignDays)
	self.fields.Text_totalDay:setString(i18n("common_text_2879", nil))
end
function Activity_9001623_MainPanel:updateListTotal(...)
	self.fields.List_total:setNumItems(#self.totalArray)
end
function Activity_9001623_MainPanel:updateListDay(...)
	self.fields.List_day:setNumItems(#self.signArray)
end
function Activity_9001623_MainPanel:onMsgCommonSignUpdate(target, event)
	if event.activityID ~= self.activityID then
		return
	end
	local subMsg = event.subMsg
	if subMsg == "extraReward" then
		self:updateListTotal()
	else
		self:updateTotalSignDays()
		self:updateListTotal()
		self:updateListDay()
	end
end
function Activity_9001623_MainPanel:onMsgNewDay(...)
	self:updateListTotal()
	self:updateListDay()
end
return Activity_9001623_MainPanel
