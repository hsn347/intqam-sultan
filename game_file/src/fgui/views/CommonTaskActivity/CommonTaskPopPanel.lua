local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommonTaskPopPanel = class("CommonTaskPopPanel", baseFguiPanel)
function CommonTaskPopPanel:ctor(...)
	self.isLRU = true
	CommonTaskPopPanel.super.ctor(self, ...)
	print("CommonTaskPopPanel:ctor", self.viewName)
	self.activityID = nil
	self.curTag = 1
end
function CommonTaskPopPanel:onInit()
	print("=======CommonTaskPopPanel:onInit")
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function CommonTaskPopPanel:endShow()
	print("=======CommonTaskPopPanel:endShow")
	_ENV = print
	_ENV = nil
	_ENV, _ENV, (nil).title = "migrant_move_text65", i18n("migrant_move_text65"), i18n("migrant_move_text65")
	_ENV, i18n("migrant_move_text65")[1], ("migrant_move_text65").title = "migrant_move_text65", "migrant_move_text65", i18n("eid_fireworks_010")
	print[gActivityTimeActivityID.KOH_MIGRATE_HELP_9001708], (nil).tabsetArray, i18n("migrant_move_text65")[2], ("migrant_move_text65").title = nil, i18n("migrant_move_text65"), "migrant_move_text65", i18n("eid_fireworks_011")
	local config = print
	self.activityID = self.param.activityID or gActivityTimeActivityID.KOH_MIGRATE_HELP_9001708
	local cfg = config[self.activityID]
	self.cfg = cfg
	self.fields.Panel_bg:setString(cfg.title)
	if cfg.sizeType then
		local c_size = self.fields.Panel_bg:getController("size")
		c_size:setSelectedIndex(cfg.sizeType)
	end
	_ENV = c_size
	self.fields.Panel_bg:getController("size").defaultClick = 1
	self.fields.Panel_bg:getController("size").tabsetArray = cfg.tabsetArray
	local self.fields.Panel_bg:getController("size").callback, param = handler(self, self.onClickTab), self.fields.Panel_bg:getController("size")
	self.fields.com_TabW:initView(param)
end
function CommonTaskPopPanel:onClickTab(tag)
	self.curTag = tag
	self:updateTaskList()
	self:updateTabRedDot()
end
function CommonTaskPopPanel:getTaskIDList(taskType)
	if self.activityID == gActivityTimeActivityID.KOH_MIGRATE_HELP_9001708 then
		local activity_9001708_Read = include("activity_9001708_Read")
		return activity_9001708_Read.getTaskIDList(taskType)
	end
	_ENV = activity_9001708_Read
	return (include("activity_9001708_Read"))
end
function CommonTaskPopPanel:updateTaskList(...)
	local taskIDList = self:getTaskIDList(self.curTag)
	self.taskList = activityTaskComponentCtrl:getTaskList(self.activityID, taskIDList)
	self.fields.List:setNumItems(#self.taskList)
	if #self.taskList > 0 then
		self.fields.List:scrollToView(0)
	end
end
function CommonTaskPopPanel:updateTabRedDot(...)
	local tabsetArray = self.cfg.tabsetArray
	for taskType = 1, #tabsetArray do
		local taskIDList = self:getTaskIDList(taskType)
		local ret, num = activityTaskComponentCtrl:getReceiveStatusAndNumByQuestList(self.activityID, taskIDList)
		self.fields.com_TabW:setBtnRedDot(taskType, ret, num)
	end
end
function CommonTaskPopPanel:onItemRenderer(index, obj)
	local task = self.taskList[index + 1]
	_ENV = nil
	;(nil).activityID = self.activityID
	;(nil).taskID = task.taskID
	obj:initDataTaskID(nil)
	obj:setHandler(handler(self, self.getAwardHandler))
end
function CommonTaskPopPanel:getAwardHandler(taskID)
	if self.activityID == gActivityTimeActivityID.KOH_MIGRATE_HELP_9001708 then
		local activity_9001708_Ctrl = SoraDGetCtrl("activity_9001708_Ctrl")
		activity_9001708_Ctrl:reqTaskReward(taskID)
	end
end
function CommonTaskPopPanel:onMsgUpdateData(target, event)
	self:updateTaskList()
	self:updateTabRedDot()
end
return CommonTaskPopPanel
