local activity_9001700_Read = include("activity_9001700_Read")
local activity_9001700_Ctrl = SoraDGetCtrl("activity_9001700_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001700_LetOffPanel = class("Activity_9001700_LetOffPanel", baseFguiPanel)
function Activity_9001700_LetOffPanel:ctor(...)
	self.isLRU = true
	Activity_9001700_LetOffPanel.super.ctor(self, ...)
	print("Activity_9001700_LetOffPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001700
end
function Activity_9001700_LetOffPanel:onInit()
	print("=======Activity_9001700_LetOffPanel:onInit")
	_ENV = nil
	;(nil).time = ""
	self.fields.Text_tip1:setString(i18n("eid_fireworks_028", nil))
	self.fields.Text_time = SoraDCreateTimerLabel(nil, self.fields.Text_time)
	self.fields.Text_time:setTimeEndListener(function(...)
		self:updateTimeEnd()
	end)
	self.fields.Button_make:setString(i18n("eid_fireworks_008"))
	self.fields.Button_make:addClickListener(handler(self, self.onClickBtnMake))
	self.fields.Text_tip2:setString(i18n("eid_fireworks_029"))
	self.fields.Text_shield:setString(i18n("eid_fireworks_034"))
	self.fields.Button_go:setString(i18n("eid_fireworks_030"))
	self.fields.Button_go:addClickListener(handler(self, self.onClickBtnGo))
end
function Activity_9001700_LetOffPanel:endShow()
	print("=======Activity_9001700_LetOffPanel:endShow")
	local remainTime = activity_9001700_Read.getLetOffRemainTime() + 1
	if 0 < remainTime then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Text_time:beginTime(remainTime)
	else
		self:updateTimeEnd()
		activity_9001700_Ctrl:addLetOffRemindToManager()
	end
	local isShield = activity_9001700_Ctrl:getIsShieldOther()
	self.fields.Check_tick:setSelected(isShield)
end
function Activity_9001700_LetOffPanel:onClickBtnMake(...)
	SoraDPlaySound()
	clientEventMgr.singleClickEvent(self.activityID)
	self:closePanel()
end
function Activity_9001700_LetOffPanel:onClickBtnGo(...)
	SoraDPlaySound()
	activity_9001700_Ctrl:onClickBtnLetOff()
end
function Activity_9001700_LetOffPanel:onHide(...)
	local isShield = self.fields.Check_tick:isSelected()
	activity_9001700_Ctrl:setShieldOther(isShield)
end
function Activity_9001700_LetOffPanel:updateTimeEnd(...)
	self.controllers.c1:setSelectedIndex(1)
	if activity_9001700_Ctrl:checkSaluteCount() then
		self.fields.Button_make:setVisible(false)
		self.fields.Button_go:setVisible(true)
		if not activity_9001700_Ctrl:checkLetOffEndTime() then
			self.fields.Button_go:setBright(false)
		else
			self.fields.Button_go:setBright(true)
		end
	else
		self.fields.Button_make:setVisible(true)
		self.fields.Button_go:setVisible(false)
	end
end
return Activity_9001700_LetOffPanel
