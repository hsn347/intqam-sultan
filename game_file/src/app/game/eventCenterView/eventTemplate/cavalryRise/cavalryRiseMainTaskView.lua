local gametop = gModuleMgr.getObject("gametop")
local cavalryRiseCtrl = gametop.playertop_:getModule("cavalryRiseCtrl")
local cavalryRiseUtil = include("cavalryRiseUtil")
local cavalryRiseMainTaskView = class("cavalryRiseMainTaskView", function(ccsFileName)
	local target = SoraDCreateBasePanel(ccsFileName)
	SoraDDeviceFitOffset(target)
	return target
end)
_ENV = "cavalryRiseMainTaskView"
;("cavalryRiseMainTaskView").TASK_VIEW_TYPE_WEEK = 1
local ("cavalryRiseMainTaskView").TASK_VIEW_TYPE_SEASON, TASK_VIEW_TYPE = 2, "cavalryRiseMainTaskView"
function cavalryRiseMainTaskView:ctor()
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView_task")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("cavalryRiseMainTaskSingle")
end
function cavalryRiseMainTaskView:init()
	self:switchPanel()
end
function cavalryRiseMainTaskView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_RESET_TASK", handler(self, self.updateTaskData))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.updateTaskData))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.updateTaskData))
end
function cavalryRiseMainTaskView:updateTaskData(target, data)
	SoraDCloseLoading(self)
	self:switchPanel()
end
function cavalryRiseMainTaskView:switchPanel()
	local cavalryRiseRead = include("cavalryRiseRead")
	self.taskList = cavalryRiseCtrl:getTaskList(cavalryRiseCtrl:getClassType())
	for _, v in ipairs(self.taskList) do
		v.taskStatus = cavalryRiseUtil:getTaskStatus(v.taskID)
	end
	self:initScrollList()
end
function cavalryRiseMainTaskView:initScrollList()
	self.scroll:jumpToTop()
	local view = self:getParent():getParent()
	_ENV = nil
	;(nil).scroll = self.scroll
	;(nil).view = view
	;(nil).mainView = self
	self.scroll:updateScrollView(cc.size(640, 154), self.taskList, 1, nil)
end
return cavalryRiseMainTaskView
