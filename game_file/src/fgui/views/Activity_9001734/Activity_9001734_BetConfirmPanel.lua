local activity_9001734_Read = include("activity_9001734_Read")
local activity_9001734_Ctrl = SoraDGetCtrl("activity_9001734_Ctrl")
local constantRead = include("constantRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001734_BetConfirmPanel = class("Activity_9001734_BetConfirmPanel", baseFguiPanel)
function Activity_9001734_BetConfirmPanel:ctor(...)
	self.isLRU = true
	Activity_9001734_BetConfirmPanel.super.ctor(self, ...)
	print("Activity_9001734_BetConfirmPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001734
	self.itemId = constantRead.getConstValue("FOOTBALL_BETTING_BETITEM", 882701)
end
function Activity_9001734_BetConfirmPanel:onInit()
	print("=======Activity_9001734_BetConfirmPanel:onInit")
	self.fields.Panel_bg:setString(i18n("football_betting_text_06"))
	self.fields.btnConfirm:setTitle(i18n("NebulaAllstar_213"))
	self.fields.btnConfirm:addClickListener(handler(self, self.onClick_btnConfirm))
	self.fields.comNumSlider:setInpuBoxFixPos(45, 180, 45)
end
function Activity_9001734_BetConfirmPanel:onHide()
	self.param.callback = nil
end
function Activity_9001734_BetConfirmPanel:endShow()
	print("=======Activity_9001734_BetConfirmPanel:endShow")
	self:initData()
end
function Activity_9001734_BetConfirmPanel:initData()
	local haveItemNum = backpackCtrl:getItemCount(self.itemId)
	local minValue = haveItemNum == 0 and 0 or 1
	backpackCtrl = nil
	;(nil).maxValue = haveItemNum
	;(nil).minValue = minValue
	;(nil).curValue = minValue
	;(nil).allowZero = haveItemNum == 0
	self.fields.comNumSlider:initData(nil)
	self.fields.btnConfirm:setEnabled(0 < haveItemNum)
	self.fields.com_item:initData(self.itemId, minValue)
	self.fields.comNumSlider:setSliderCallBack(handler(self, self.onChange_Slider))
end
function Activity_9001734_BetConfirmPanel:onClick_btnConfirm(context)
	SoraDPlaySound()
	local ticketNum = self.fields.comNumSlider:getSliderCurValue()
	local haveItemNum = backpackCtrl:getItemCount(self.itemId)
	if ticketNum <= haveItemNum then
		if self.param.callback then
			self.param.callback(ticketNum)
			self.param.callback = nil
		end
	else
		SoraDShowMsgTip(i18n("gemEnchant_text_48"))
	end
	self:close()
end
function Activity_9001734_BetConfirmPanel:onChange_Slider(value, context)
	self.fields.com_item:initData(self.itemId, value)
end
return Activity_9001734_BetConfirmPanel
