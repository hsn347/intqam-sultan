local activity_9001738_Read = include("activity_9001738_Read")
local activity_9001738_Ctrl = SoraDGetCtrl("activity_9001738_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001738_winPanel = class("Activity_9001738_winPanel", baseFguiPanel)
function Activity_9001738_winPanel:ctor(...)
	self.isLRU = true
	Activity_9001738_winPanel.super.ctor(self, ...)
	print("Activity_9001738_winPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.GREEN_GRASS_FLIP_ACTIVITY
end
function Activity_9001738_winPanel:onInit()
	print("=======Activity_9001738_winPanel:onInit")
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Button_ok:setVisible(false)
	self.fields.Text_reward:setString(i18n("memory_flip_text_14"))
	self.fields.txtNoReward:setString(i18n("memory_flip_text_12"))
	self.controllers.c1:setSelectedIndex(SoraDFIsRA() and 0 or 1)
end
function Activity_9001738_winPanel:endShow()
	print("=======Activity_9001738_winPanel:endShow")
	local clearanceTime = self.param.clearanceTime or 0
	local isFirstPass = self.param.isFirstPass
	if not self.param.rewards then
		local _ENV, rewards = self.param.rewards, self.param.rewards
	end
	self.rewardData = rewards
	_ENV = nil
	;(nil).time = string.format("%.2f", clearanceTime / 100)
	self.fields.Text_tip:setString(i18n("memory_flip_text_13", nil))
	if isFirstPass then
		self.controllers.ctrlHasReward:setSelectedIndex(1)
		self.fields.List:setNumItems(#rewards)
	else
		self.controllers.ctrlHasReward:setSelectedIndex(0)
		self.fields.List:setNumItems(0)
	end
end
function Activity_9001738_winPanel:itemRenderer_List(index, obj)
	local data = self.rewardData[index + 1]
	obj:initData(data.id, data.count)
end
function Activity_9001738_winPanel:onClick_Button_ok(context)
	SoraDPlaySound()
	self:close()
end
function Activity_9001738_winPanel:onHide()
	if self.rewardData and #self.rewardData > 0 then
		SoraDMailGainItems(self.rewardData, true)
	end
end
return Activity_9001738_winPanel
