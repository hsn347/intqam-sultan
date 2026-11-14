local activity_9001700_Read = include("activity_9001700_Read")
local activity_9001700_Ctrl = SoraDGetCtrl("activity_9001700_Ctrl")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001700_TaskPanel = class("Activity_9001700_TaskPanel", baseFguiPanel)
function Activity_9001700_TaskPanel:ctor(...)
	self.isLRU = true
	Activity_9001700_TaskPanel.super.ctor(self, ...)
	print("Activity_9001700_TaskPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001700
	self.curTag = 1
end
function Activity_9001700_TaskPanel:onInit()
	print("=======Activity_9001700_TaskPanel:onInit")
	self.fields.Panel_bg:setString(i18n("eid_fireworks_003"))
	self.fields.List_task:setItemRenderer(handler(self, self.onItemTaskRenderer))
end
function Activity_9001700_TaskPanel:endShow()
	print("=======Activity_9001700_TaskPanel:endShow")
	_ENV = print
	_ENV, _ENV, print.defaultClick = nil, "=======Activity_9001700_TaskPanel:endShow", 1
	_ENV, ("=======Activity_9001700_TaskPanel:endShow")[1], (nil).title = nil, nil, i18n("eid_fireworks_010")
	print.tabsetArray, ("=======Activity_9001700_TaskPanel:endShow")[2], (nil).title = "=======Activity_9001700_TaskPanel:endShow", nil, i18n("eid_fireworks_011")
	local print.callback, param = handler(self, self.onClickTab), print
	self.fields.com_TabW:initView(param)
end
function Activity_9001700_TaskPanel:onClickTab(tag)
	print("==Activity_9001700_TaskPanel:onClickTab==", tag)
	self.curTag = tag
	self:updateTaskList()
	local taskType = 2 - self.curTag + 1
	local taskIDList = activity_9001700_Read.getTaskIDList(taskType)
	local ret, num = activity_9001700_Ctrl:getQuestListRedNum(taskIDList)
	self.fields.com_TabW:setBtnRedDot(taskType, ret, num)
	self.fields.com_TabW:setBtnRedDot(self.curTag, false)
end
function Activity_9001700_TaskPanel:updateTaskList(...)
	local taskIDList = activity_9001700_Read.getTaskIDList(self.curTag)
	self.taskList = activityTaskComponentCtrl:getTaskList(self.activityID, taskIDList)
	self.fields.List_task:setNumItems(#self.taskList)
	if #self.taskList > 0 then
		self.fields.List_task:scrollToView(0)
	end
end
function Activity_9001700_TaskPanel:onItemTaskRenderer(index, obj)
	local task = self.taskList[index + 1]
	_ENV = nil
	;(nil).activityID = self.activityID
	;(nil).taskID = task.taskID
	obj:initDataTaskID(nil)
	obj:setHandler(handler(self, self.getAwardHandler))
end
function Activity_9001700_TaskPanel:getAwardHandler(taskID)
	activity_9001700_Ctrl:reqQuestReward(taskID)
end
function Activity_9001700_TaskPanel:onMsgUpdateData(target, event)
	local subMsg = event.subMsg
	if subMsg == "questReward" then
		self:updateTaskList()
	end
end
return Activity_9001700_TaskPanel
