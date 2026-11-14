local activity_9001727_Read = include("activity_9001727_Read")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001727_BuffShowPanel = class("Activity_9001727_BuffShowPanel", baseFguiPanel)
function Activity_9001727_BuffShowPanel:ctor(...)
	self.isLRU = true
	Activity_9001727_BuffShowPanel.super.ctor(self, ...)
	print("Activity_9001727_BuffShowPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.ALBARQ_DECREE_ACTIVITY
end
function Activity_9001727_BuffShowPanel:onInit()
	print("=======Activity_9001727_BuffShowPanel:onInit")
	self.fields.BuffList:setItemRenderer(handler(self, self.itemRenderer_BuffList))
	self.fields.Panel_bg:setString(i18n("activity_name_9001727"))
	self.fields.Button_Ques:addClickListener(handler(self, self.onClick_Button_Ques))
	self.fields.Button_ok:setTitle(i18n("common_text_678"))
	self.fields.Button_ok:addClickListener(handler(self, self.onClick_Button_ok))
	self.fields.Text_Tips:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("Braque_text_09", nil)
	end)
end
function Activity_9001727_BuffShowPanel:endShow()
	print("=======Activity_9001727_BuffShowPanel:endShow")
	self.fields.Text_Tips:beginTime(activityShowCtrl:getRemainTime(self.activityID))
	self.giftInfo = activity_9001727_Read.getRecharge()
	self.buffList = activity_9001727_Read.getEffectShow(self.giftInfo.RechargeID)
	self.fields.BuffList:setNumItems(#self.buffList)
end
function Activity_9001727_BuffShowPanel:itemRenderer_BuffList(index, obj)
	local data = self.buffList[index + 1]
	obj:getChild("icon"):setIcon(data.EffectIcon)
	obj:setTitle(i18n(data.EffectDescription))
end
function Activity_9001727_BuffShowPanel:onClick_Button_Ques(context)
	SoraDPlaySound()
	uiManager:show("Activity_9001727_Buff")
end
function Activity_9001727_BuffShowPanel:onClick_Button_ok(context)
	SoraDPlaySound()
	clientEventMgr.singleClickEvent(self.activityID)
end
return Activity_9001727_BuffShowPanel
