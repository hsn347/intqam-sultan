local activity_9001733_Read = include("activity_9001733_Read")
local activity_9001733_Ctrl = SoraDGetCtrl("activity_9001733_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001733_TaskPanel = class("Activity_9001733_TaskPanel", baseFguiPanel)
function Activity_9001733_TaskPanel:ctor(...)
	self.isLRU = true
	Activity_9001733_TaskPanel.super.ctor(self, ...)
	print("Activity_9001733_TaskPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.FOOTBALL_TREASURE_ACTIVITY
end
function Activity_9001733_TaskPanel:onInit()
	print("=======Activity_9001733_TaskPanel:onInit")
	self:fixChildrenPos()
	self.fields.listTask:setDefaultItem("ui://Activity_9001733/Com_Single")
	self.fields.listTask:setItemRenderer(handler(self, self.itemRenderer_listTask))
	self.fields.listTask:setVirtual()
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
end
function Activity_9001733_TaskPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("football_treasure_text_004")
	uiManager:show("RuleView", nil)
end
function Activity_9001733_TaskPanel:endShow()
	print("=======Activity_9001733_TaskPanel:endShow")
	self:updateView()
	self.fields.listTask:jumpToTop()
end
function Activity_9001733_TaskPanel:refreshTaskList()
	if not activity_9001733_Ctrl:getTaskList() then
		activity_9001733_Ctrl = activity_9001733_Ctrl:getTaskList()
	end
	self.listTaskData = activity_9001733_Ctrl:getTaskList()
	self.fields.listTask:setNumItems(#self.listTaskData)
end
function Activity_9001733_TaskPanel:updateView()
	self:refreshTaskList()
	self:updateTaskRefreshTime()
end
function Activity_9001733_TaskPanel:updateTaskRefreshTime()
	local remainTime = activity_9001733_Ctrl:getTaskRefreshRemainTime()
	if 0 < remainTime then
		self.fields.Com_title:initSpecialTime(remainTime, "football_treasure_text_016")
	else
		self.fields.Com_title:initSpecialActivityTimeNew(self.activityID)
	end
end
function Activity_9001733_TaskPanel:itemRenderer_listTask(index, obj)
	local data = self.listTaskData[index + 1]
	obj:initData(self.activityID, data)
end
return Activity_9001733_TaskPanel
