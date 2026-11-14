local activity_9001479_Ctrl = SoraDGetCtrl("activity_9001479_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001479_PreviewPanel = class("Activity_9001479_PreviewPanel", baseFguiPanel)
function Activity_9001479_PreviewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001479_PreviewPanel:ctor", self.viewName)
end
function Activity_9001479_PreviewPanel:onInit()
	print("=======Activity_9001479_PreviewPanel:onInit")
	local childrens = self.fields.Com_preview:getChildren()
	for i, v in ipairs(childrens) do
		self.fields[v:getName()] = v
	end
	self.fields.Com_title:initData(i18n("camp_integral_1"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_des:setString(i18n("camp_integral_3"))
	self.fields.Button_reward:setString(i18n("common_text_2078"))
	self.fields.Button_reward:addClickListener(handler(self, self.onClickBtnReward))
	self.fields.Text_begin:setString(i18n("camp_integral_4"))
	self.fields.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	local remainTime = activity_9001479_Ctrl:getStageRemainTime()
	if activity_9001479_Ctrl:checkIsSpecial() then
		self.fields.Text_begin:setString(i18n("camp_integral_29"))
		remainTime = activity_9001479_Ctrl:getStageRemainTime(5)
	end
	self.fields.Text_time:beginTime(remainTime)
end
function Activity_9001479_PreviewPanel:onShow()
	print("=======Activity_9001479_PreviewPanel:onShow")
end
function Activity_9001479_PreviewPanel:onClickHelp()
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("camp_integral_2"))
end
function Activity_9001479_PreviewPanel:onClickBtnReward(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).showRound = 1
	uiManager:show("Activity_9001479_Reward", nil)
end
return Activity_9001479_PreviewPanel
