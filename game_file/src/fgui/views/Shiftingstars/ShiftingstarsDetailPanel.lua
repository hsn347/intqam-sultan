local activityCenterUICtrl = SoraDGetCtrl("activityCenterUICtrl")
local shiftingstarsRead = include("shiftingstarsRead")
local activityTimeRead = include("activityTimeRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ShiftingstarsDetailPanel = class("ShiftingstarsDetailPanel", baseFguiPanel)
function ShiftingstarsDetailPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("ShiftingstarsDetailPanel:ctor", self.viewName)
end
function ShiftingstarsDetailPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function ShiftingstarsDetailPanel:onInit()
	print("=======ShiftingstarsDetailPanel:onInit")
	self.fields.Text_get:setString(i18n("common_text_4458"))
	self.fields.Text_tip:setString(i18n("common_text_2486"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_go:setTitleText(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.onClickGo))
end
function ShiftingstarsDetailPanel:initData(data)
	self.data = data
	self.rewards = data.awardShow or shiftingstarsRead.getActRewardByIDClasstype(data.activityID, data.classtype)
	self.activityID = data.activityID
	self.fields.Panel_bg:setString(i18n(activityTimeRead.getActivityNameByID(data.activityID, data.classtype)))
	self.fields.Text_timeLast:setString(string.gsub(SoraDConvertTimeToYear(data.beginTime), "-", "/") .. "-" .. string.gsub(SoraDConvertTimeToYear(data.endTime), "-", "/"))
	self.fields.Text_desc:setString(i18n(shiftingstarsRead.getActDescByID(self.activityID)))
	self.fields.Label_banner:setIcon(shiftingstarsRead.getActBgByID(data.activityID))
	if self.rewards and next(self.rewards) then
		self.fields.List_reward:setNumItems(table.nums(self.rewards))
		self.controllers.c2:setSelectedIndex(0)
	else
		self.controllers.c2:setSelectedIndex(1)
	end
	self:refreshView()
end
function ShiftingstarsDetailPanel:refreshView()
	local open = clientEventMgr.judgeIsOpen(self.activityID)
	self.controllers.c1:setSelectedIndex(open and 0 or 1)
end
function ShiftingstarsDetailPanel:onItemRenderer(index, object)
	object:initData(self.rewards[index + 1])
end
function ShiftingstarsDetailPanel:onClickGo()
	SoraDPlaySound()
	if self.activityID == gActivityTimeActivityID.NEBULA_REGION_ACTIVITY then
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local eventState = activityShowCtrl:getStateByID(self.activityID)
		if eventState ~= gActivityState.CLOSE then
			self:showAct()
		end
	end
	if (self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_NEBULA or self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_NEBULA_ADVANCE) and clientEventMgr.judgeIsOpen(self.activityID) then
		_ENV = self
		self.id = self.activityID
		uiManager:show("ExchangeEventPage", self)
		self:close()
	end
	if self.activityID == gActivityTimeActivityID.NEBULA_KING_ACTIVITY then
		local nebulaKingCtrl = SoraDGetCtrl("nebulaKingCtrl")
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local state = activityShowCtrl:getStateByID(self.activityID)
		if nebulaKingCtrl:isActivityOpen() or nebulaKingCtrl:isActivityCalc() then
			activityCenterUICtrl:sendClearNewMsg(self.activityID)
			uiManager:show("NebulaKingMain")
			self:close()
		elseif nebulaKingCtrl:isActivityPrepare() then
			activityCenterUICtrl:sendClearNewMsg(self.activityID)
			uiManager:show("NebulaKingPreview")
			self:close()
		end
	elseif self.activityID == gActivityTimeActivityID.NEBULA_COMPETITION_ACTIVITY then
		local nebulaCompetitionCtrl = SoraDGetCtrl("nebulaCompetitionCtrl")
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local state = activityShowCtrl:getStateByID(self.activityID)
		if nebulaCompetitionCtrl:isActivityOpen() or nebulaCompetitionCtrl:isActivityCalc() then
			activityCenterUICtrl:sendClearNewMsg(self.activityID)
			uiManager:show("NebulaCompetitionMain")
			self:close()
		elseif nebulaCompetitionCtrl:isActivityPrepare() then
			activityCenterUICtrl:sendClearNewMsg(self.activityID)
			uiManager:show("NebulaCompetitionPreview")
			self:close()
		end
	end
	if clientEventMgr.judgeIsOpen(self.activityID) then
		self:showAct()
	end
end
function ShiftingstarsDetailPanel:showAct()
	activityCenterUICtrl:sendClearNewMsg(self.activityID)
	if clientEventMgr.getEventInfoByeid(self.activityID) then
		clientEventMgr.singleClickEvent(self.activityID)
	end
	self:close()
end
function ShiftingstarsDetailPanel:onShow()
	print("=======ShiftingstarsDetailPanel:onShow")
	self:initData(self.proxy.param)
end
return ShiftingstarsDetailPanel
