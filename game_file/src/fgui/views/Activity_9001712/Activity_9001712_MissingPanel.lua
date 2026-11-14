local activity_9001712_Read = include("activity_9001712_Read")
local activity_9001712_Ctrl = SoraDGetCtrl("activity_9001712_Ctrl")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001712_MissingPanel = class("Activity_9001712_MissingPanel", baseFguiPanel)
function Activity_9001712_MissingPanel:ctor(...)
	self.isLRU = true
	Activity_9001712_MissingPanel.super.ctor(self, ...)
	print("Activity_9001712_MissingPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.CELEBRATION_SIGN_ACTIVITY
end
function Activity_9001712_MissingPanel:onInit()
	print("=======Activity_9001712_MissingPanel:onInit")
	self.fields.Panel_bg:setString(i18n("anniversary_ten_daily_06"))
	self.fields.btnConfirm:setTitle(i18n("common_text_204"))
	self.fields.btnConfirm:addClickListener(handler(self, self.onClick_btnConfirm))
end
function Activity_9001712_MissingPanel:endShow()
	print("=======Activity_9001712_MissingPanel:endShow")
	self:initData()
end
function Activity_9001712_MissingPanel:onClick_btnConfirm(context)
	SoraDPlaySound()
	local goldNum = constantRead.getConstValue("ANNIVERSARY_2025_GOLD_COST")
	local ticketNum = self.fields.comNumSlider:getSliderCurValue()
	if SoraDEnoughGold(goldNum * ticketNum, true) then
		activity_9001712_Ctrl:reqBuyTimes(self.fields.comNumSlider:getSliderCurValue())
	else
		SoraDShowMsgTip(i18n("artifact_text_20"))
	end
end
function Activity_9001712_MissingPanel:onChange_Slider(value, context)
	local goldNum = constantRead.getConstValue("ANNIVERSARY_2025_GOLD_COST")
	constantRead = nil
	;(nil).num = value * goldNum
	self.fields.txtDes:setString(i18n("anniversary_ten_daily_12", nil))
end
function Activity_9001712_MissingPanel:initData()
	local initNum = activity_9001712_Ctrl:getCanByNum()
	activity_9001712_Ctrl = nil
	;(nil).maxValue = activity_9001712_Ctrl:getCanByNum()
	;(nil).minValue = 1
	;(nil).curValue = initNum
	;(nil).allowZero = false
	self.fields.comNumSlider:initData(nil)
	self.fields.comNumSlider:setSliderCallBack(handler(self, self.onChange_Slider))
	local goldNum = constantRead.getConstValue("ANNIVERSARY_2025_GOLD_COST")
	activity_9001712_Ctrl = handler(self, self.onChange_Slider)
	handler(self, self.onChange_Slider).num = initNum * goldNum
	self.fields.txtDes:setString(i18n("anniversary_ten_daily_12", handler(self, self.onChange_Slider)))
end
return Activity_9001712_MissingPanel
