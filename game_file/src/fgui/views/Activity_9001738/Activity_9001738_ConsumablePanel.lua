local activity_9001738_Read = include("activity_9001738_Read")
local activity_9001738_Ctrl = SoraDGetCtrl("activity_9001738_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001738_ConsumablePanel = class("Activity_9001738_ConsumablePanel", baseFguiPanel)
function Activity_9001738_ConsumablePanel:ctor(...)
	self.isLRU = true
	Activity_9001738_ConsumablePanel.super.ctor(self, ...)
	print("Activity_9001738_ConsumablePanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.GREEN_GRASS_FLIP_ACTIVITY
end
function Activity_9001738_ConsumablePanel:onInit()
	print("=======Activity_9001738_ConsumablePanel:onInit")
	self.fields.List_reward:setDefaultItem("ui://Activity_9001738/ComConsumableDesc")
	self.fields.List_reward:setItemRenderer(handler(self, self.itemRenderer_List_reward))
	self.fields.Panel_bg:setString(i18n("memory_flip_text_07"))
	self.fields.btnGetway:setTitle(i18n("common_text_337"))
	self.fields.btnGetway:addClickListener(handler(self, self.onClick_btnGetway))
end
function Activity_9001738_ConsumablePanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("memory_flip_text_01")
	uiManager:show("RuleView", nil)
end
function Activity_9001738_ConsumablePanel:endShow()
	print("=======Activity_9001738_ConsumablePanel:endShow")
	self:initData()
end
function Activity_9001738_ConsumablePanel:itemRenderer_List_reward(index, obj)
	local data = self.List_rewardData[index + 1]
	obj:initData(data)
end
function Activity_9001738_ConsumablePanel:initData()
	self.List_rewardData = activity_9001738_Read.getItemList()
	self.fields.Panel_bg:setString(i18n("memory_flip_text_07"))
	self.fields.List_reward:setNumItems(#self.List_rewardData)
end
function Activity_9001738_ConsumablePanel:onClick_btnGetway(context)
	SoraDPlaySound()
	uiManager:show("Activity_9001738_Package")
end
return Activity_9001738_ConsumablePanel
