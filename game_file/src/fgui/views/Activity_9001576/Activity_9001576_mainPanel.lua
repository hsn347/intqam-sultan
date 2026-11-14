local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activity_9001576_Ctrl = SoraDGetCtrl("activity_9001576_Ctrl")
local signRewadRead = include("signRewadRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001576_mainPanel = class("Activity_9001576_mainPanel", baseFguiPanel)
function Activity_9001576_mainPanel:ctor(...)
	Activity_9001576_mainPanel.super.ctor(self, ...)
	print("Activity_9001576_mainPanel:ctor", self.viewName)
end
function Activity_9001576_mainPanel:onInit()
	print("=======Activity_9001576_mainPanel:onInit")
	self.signCfg, _ENV, self.activityID = gActivityTimeActivityID.SIGN_REWARD_9001576_ACTIVITY, gActivityTimeActivityID.SIGN_REWARD_9001576_ACTIVITY, gActivityTimeActivityID.SIGN_REWARD_9001576_ACTIVITY
	self.fields.Com_title:initData(i18n("activity_name_9001576"), handler(self, self.onClickClose))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.List_sign:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_sign:setAlignCenter(true)
end
function Activity_9001576_mainPanel:onShow()
	print("=======Activity_9001576_mainPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.signCfg = signRewadRead.getSonwComSignCfg()
	self:initData()
end
function Activity_9001576_mainPanel:onItemRenderer(index, obj)
	obj:initData(self.signCfg[index + 1])
end
function Activity_9001576_mainPanel:initData(target, data)
	self.fields.List_sign:setNumItems(#self.signCfg)
	self.fields.Btn_cumu:initData()
end
return Activity_9001576_mainPanel
