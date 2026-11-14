local eventQuestRead = include("eventQuestRead")
local activity_9001736_Read = include("activity_9001736_Read")
local activity_9001736_Ctrl = SoraDGetCtrl("activity_9001736_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001736_TaskPanel = class("Activity_9001736_TaskPanel", baseFguiPanel)
_ENV = "Activity_9001736_TaskPanel"
;("Activity_9001736_TaskPanel").DAILY = 1
local ("Activity_9001736_TaskPanel").ACCUMULATIVE, TASK_TYPE = 2, "Activity_9001736_TaskPanel"
function Activity_9001736_TaskPanel:ctor(...)
	self.isLRU = true
	Activity_9001736_TaskPanel.super.ctor(self, ...)
	print("Activity_9001736_TaskPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001736
end
function Activity_9001736_TaskPanel:onInit()
	print("=======Activity_9001736_TaskPanel:onInit")
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Com_title:initData(i18n("eidTycoon2024_text_03"), handler(self, self.onClickClose))
end
function Activity_9001736_TaskPanel:endShow()
	print("=======Activity_9001736_TaskPanel:endShow")
	_ENV = print
	_ENV, print.defaultClick = TASK_TYPE.DAILY, TASK_TYPE.DAILY
	_ENV = nil
	TASK_TYPE.DAILY[TASK_TYPE.DAILY], (nil).title = nil, i18n("eid_fireworks_010")
	_ENV = nil
	print.tabsetArray, TASK_TYPE.DAILY[TASK_TYPE.ACCUMULATIVE], (nil).title = TASK_TYPE.DAILY, nil, i18n("eid_fireworks_011")
	local print.callback, param = handler(self, self.onClickTab), print
	self.fields.Com_title:initTab(param)
	self:updateTabRedDot()
end
function Activity_9001736_TaskPanel:onClickTab(tag)
	self.curTag = tag
	self:updateTaskList()
end
function Activity_9001736_TaskPanel:updateTaskList(...)
	if self.curTag == TASK_TYPE.DAILY then
		local serverData = activity_9001736_Ctrl:getQuestData()
		self.taskList = eventQuestRead.getSortList(self.activityID, serverData)
	else
		self.taskList = activity_9001736_Read.getSortList()
	end
	dump(self.taskList, "updateTaskList")
	self.fields.List:setNumItems(#self.taskList)
	if #self.taskList > 0 then
		self.fields.List:scrollToView(0)
	end
end
function Activity_9001736_TaskPanel:updateTabRedDot(...)
	local _isRed, _num = activity_9001736_Ctrl:getQuestRedPointAndNum()
	self.fields.Com_title:setBtnRedDot(TASK_TYPE.DAILY, _isRed, _num)
	local _isRed, _num = activity_9001736_Ctrl:getTaskRedPointAndNum()
	self.fields.Com_title:setBtnRedDot(TASK_TYPE.ACCUMULATIVE, _isRed, _num)
end
function Activity_9001736_TaskPanel:itemRenderer_List(index, obj)
	local task = self.taskList[index + 1]
	obj:initData(task)
	obj:setHandler(handler(self, self.getAwardHandler))
end
function Activity_9001736_TaskPanel:getAwardHandler(taskId)
	local activity_9001736_Ctrl = SoraDGetCtrl("activity_9001736_Ctrl")
	if self.curTag == TASK_TYPE.DAILY then
		activity_9001736_Ctrl:reqQuestReward(taskId)
	else
		activity_9001736_Ctrl:reqTaskReward(taskId)
	end
end
function Activity_9001736_TaskPanel:onMsgUpdateQuest()
	self:updateTaskList()
	self:updateTabRedDot()
end
function Activity_9001736_TaskPanel:onMsgUpdateData()
	self:updateTaskList()
	self:updateTabRedDot()
end
return Activity_9001736_TaskPanel
