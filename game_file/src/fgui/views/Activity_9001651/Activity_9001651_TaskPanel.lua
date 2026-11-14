local eventQuestRead = include("eventQuestRead")
local activity_9001651_Read = include("activity_9001651_Read")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local activity_9001651_Ctrl = SoraDGetCtrl("activity_9001651_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001651_TaskPanel = class("Activity_9001651_TaskPanel", baseFguiPanel)
function Activity_9001651_TaskPanel:ctor(...)
	Activity_9001651_TaskPanel.super.ctor(self, ...)
	print("Activity_9001651_TaskPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NEBULA_FURNACE_ACTIVITY
	self.classType = SoraDGetActivityClassType(self.activityID)
end
function Activity_9001651_TaskPanel:onInit()
	print("=======Activity_9001651_TaskPanel:onInit")
	self.fields.Panel_bg:setString(i18n("weapon_creating_04"))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Activity_9001651_TaskPanel:onItemRenderer(index, obj)
	obj:initData(self.taskList[index + 1], self)
end
function Activity_9001651_TaskPanel:onShow()
	print("=======Activity_9001651_TaskPanel:onShow")
	self.taskIDList = activity_9001651_Read.getTaslConfig(self.classType)
	self:updateView()
end
function Activity_9001651_TaskPanel:updateView(target, data)
	SoraDCloseLoading(self)
	self.taskList = activityTaskComponentCtrl:getTaskList(self.activityID, self.taskIDList)
	for k, v in ipairs(self.taskList) do
		v.taskStatus = gBtnTargetStatusDef.GO
		if activity_9001651_Ctrl:isTaskClaimed(v.taskID) then
			v.taskStatus = gBtnTargetStatusDef.GOT
		elseif activity_9001651_Ctrl:isTaskFinished(v.taskID) then
			v.taskStatus = gBtnTargetStatusDef.GET
		end
	end
	table.sort(self.taskList, function(a, b)
		if a.taskStatus == b.taskStatus then
			return a.taskID < b.taskID
		else
			return a.taskStatus < b.taskStatus
		end
	end)
	self.fields.List:setNumItems(#self.taskList)
end
return Activity_9001651_TaskPanel
