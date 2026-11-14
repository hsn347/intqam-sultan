local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activityCommonSignCtrl = SoraDGetCtrl("activityCommonSignCtrl")
local activityCommonSignRead = include("activityCommonSignRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001636_MainPanel = class("Activity_9001636_MainPanel", baseFguiPanel)
function Activity_9001636_MainPanel:ctor(...)
	Activity_9001636_MainPanel.super.ctor(self, ...)
	print("Activity_9001636_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.SIGN_REWARD_9001636_ACTIVITY
	self.totalArray = activityCommonSignRead.getCumuDayArray(self.activityID)
	self.signArray = activityCommonSignRead.getRewardConfig(self.activityID)
end
function Activity_9001636_MainPanel:onInit()
	print("=======Activity_9001636_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_signBox:setString(i18n("eid_al_adha_dec1"))
	self.Com_signDayList, _ENV = self.fields.Text_signBox.setString, self.fields.Text_signBox.setString
	local dayMax = 7
	for day = 1, dayMax do
		local Com_signDay = self.fields["Com_signDay" .. day]
		if Com_signDay then
			table.insert(self.Com_signDayList, Com_signDay)
		end
	end
	local Com_signDay = self.Com_signDayList[1]
	Com_signDay:getChild("mv_fire"):setAllFrameName("dh_dxtanxian_%.2d.png", 1)
	Com_signDay:getChild("mv_light"):setAllFrameName("dh_zhaiyueqd7_%.3d.png", 0)
end
function Activity_9001636_MainPanel:onShow()
	print("=======Activity_9001636_MainPanel:onShow")
	self:initData()
end
function Activity_9001636_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Ramadan_2024_test51")
	uiManager:show("RuleView", nil)
end
function Activity_9001636_MainPanel:onDayRenderer(index, obj)
	_UPVALUE0_ = nil
	;(nil).activityID = self.activityID
	;(nil).day = index + 1
	obj:initData(nil)
end
function Activity_9001636_MainPanel:initData()
	self:updateListTotal()
	self:updateListDay()
end
function Activity_9001636_MainPanel:updateListTotal(...)
	local dayMax = self.totalArray[#self.totalArray] or 0
	_UPVALUE0_ = nil
	;(nil).activityID = self.activityID
	;(nil).day = dayMax
	self.fields.Com_signBox:initData(nil)
end
function Activity_9001636_MainPanel:updateListDay(...)
	for day, obj in ipairs(self.Com_signDayList) do
		self:onDayRenderer(day - 1, obj)
	end
end
function Activity_9001636_MainPanel:onMsgCommonSignUpdate(target, event)
	if event.activityID ~= self.activityID then
		return
	end
	local subMsg = event.subMsg
	if subMsg == "extraReward" then
		self:updateListTotal()
	else
		self:updateListTotal()
		self:updateListDay()
	end
end
function Activity_9001636_MainPanel:onMsgNewDay(...)
	self:updateListTotal()
	self:updateListDay()
end
return Activity_9001636_MainPanel
