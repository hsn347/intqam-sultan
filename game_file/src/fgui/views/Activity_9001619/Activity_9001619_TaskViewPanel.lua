local gametop = gModuleMgr.getObject("gametop")
local activityTaskComponentCtrl = gametop.playertop_:getModule("activityTaskComponentCtrl")
local starRhapsodyDef = include("starRhapsodyDef")
local eventQuestRead = include("eventQuestRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001619_TaskViewPanel = class("Activity_9001619_TaskViewPanel", baseFguiPanel)
function Activity_9001619_TaskViewPanel:ctor(...)
	Activity_9001619_TaskViewPanel.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001619_TaskViewPanel:ctor", self.viewName)
end
function Activity_9001619_TaskViewPanel:onInit()
	print("=======Activity_9001619_TaskViewPanel:onInit")
	self.isHideCurrentSceneView = true
	self.activityID = gActivityTimeActivityID.RAMADAN_RHAPSODY
	self.fields.Com_title:initData(i18n("ramadan_rhapsody_text3"), handler(self, self.onClickClose))
	self.fields.List_task:setVirtual()
	self.fields.List_task:setItemRenderer(handler(self, self.onItemRenderer))
	self:initData()
end
function Activity_9001619_TaskViewPanel:onShow()
	print("=======Activity_9001619_TaskViewPanel:onShow")
end
function Activity_9001619_TaskViewPanel:initData()
	local questData = activityTaskComponentCtrl:getQuestData(self.activityID)
	self.taskList = eventQuestRead.getSortList(self.activityID, questData)
	dump(self.taskList, "Activity_9001619_TaskViewPanel:initData")
	self.fields.List_task:setNumItems(table.nums(self.taskList))
end
function Activity_9001619_TaskViewPanel:onItemRenderer(index, object)
	object:initData(self.taskList[index + 1])
end
return Activity_9001619_TaskViewPanel
