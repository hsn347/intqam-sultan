local activity_9001735_Read = include("activity_9001735_Read")
local activity_9001735_Ctrl = SoraDGetCtrl("activity_9001735_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001735_winPanel = class("Activity_9001735_winPanel", baseFguiPanel)
function Activity_9001735_winPanel:ctor(...)
	self.isLRU = true
	Activity_9001735_winPanel.super.ctor(self, ...)
	print("Activity_9001735_winPanel:ctor", self.viewName)
end
function Activity_9001735_winPanel:onInit()
	print("=======Activity_9001735_winPanel:onInit")
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Button_ok:setTitle(i18n("common_text_006"))
	self.fields.Button_ok:addClickListener(handler(self, self.onClick_Button_ok))
	self.fields.Text_tip:setString(i18n("freekick_master_text_06"))
	self.fields.Text_reward:setString(i18n("feast_the_world_text_14"))
end
function Activity_9001735_winPanel:endShow()
	print("=======Activity_9001735_winPanel:endShow")
	self.controllers.c1:setSelectedIndex(SoraDFIsRA() and 0 or 1)
	self.activityID = self.param.activityID or gActivityTimeActivityID.FREE_KICK_MASTER_ACTIVITY
	local tipStr = self.param.tipStr or i18n("freekick_master_text_06")
	self.fields.Text_tip:setString(tipStr)
	self.reward_win = self.param.rewards or activity_9001735_Read.getRewardCfg(1)
	self.fields.List:setNumItems(#self.reward_win)
end
function Activity_9001735_winPanel:itemRenderer_List(index, obj)
	local data = self.reward_win[index + 1]
	obj:initData(data.id, data.count)
end
function Activity_9001735_winPanel:obSystemBackKeyClick()
end
function Activity_9001735_winPanel:onClick_Button_ok(context)
	SoraDPlaySound()
	if self.activityID == gActivityTimeActivityID.FREE_KICK_MASTER_ACTIVITY then
		uiManager:show("Activity_9001735_Main")
	end
	self:close()
end
return Activity_9001735_winPanel
