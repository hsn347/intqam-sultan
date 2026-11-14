local beastCanyonRead = include("beastCanyonRead")
local beastCanyonCtrl = SoraDGetCtrl("beastCanyonCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local BeastCanyonTaskPanel = class("BeastCanyonTaskPanel", baseFguiPanel)
function BeastCanyonTaskPanel:ctor(...)
	self.super.ctor(self, ...)
	print("BeastCanyonTaskPanel:ctor", self.viewName)
end
function BeastCanyonTaskPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function BeastCanyonTaskPanel:onInit()
	print("=======BeastCanyonTaskPanel:onInit")
	self.activityID = self.param and self.param.activityID or gActivityTimeActivityID.DIVINE_BEAST_CANYON_ACTIVITY
	self.fields.Com_title:initData(i18n("common_text_2078"), handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function BeastCanyonTaskPanel:onShow()
	print("=======BeastCanyonTaskPanel:onShow")
	self:updatTaskScroll()
end
function BeastCanyonTaskPanel:updatTaskScroll()
	self.taskList = beastCanyonCtrl:getTaskList(self.activityID)
	self.fields.List:setNumItems(#self.taskList)
end
function BeastCanyonTaskPanel:onItemRederer(index, target)
	local taskInfo = self.taskList[index + 1]
	beastCanyonCtrl = nil
	;(nil).activityID = self.activityID
	;(nil).Index = taskInfo.Index
	;(nil).progress = beastCanyonCtrl:getWeekTimes(self.activityID)
	beastCanyonRead, (nil).taskStatus = beastCanyonCtrl:getTaskState(self.activityID, taskInfo.Index, taskInfo.num), beastCanyonCtrl:getTaskState(self.activityID, taskInfo.Index, taskInfo.num)
	beastCanyonCtrl:getTaskState(self.activityID, taskInfo.Index, taskInfo.num).num = taskInfo.num
	;(nil).taskDes, beastCanyonCtrl:getTaskState(self.activityID, taskInfo.Index, taskInfo.num)[1] = beastCanyonCtrl:getTaskState(self.activityID, taskInfo.Index, taskInfo.num), beastCanyonRead.getTaskDes(self.activityID, taskInfo.type)
	_ENV = taskInfo.num
	taskInfo.num[1] = "id"
	taskInfo.num[2] = "count"
	;(nil).award = serviceFunctions.tableFormat(taskInfo.reward, taskInfo.num)
	;(nil).aim = taskInfo.num
	target:initData(nil)
end
return BeastCanyonTaskPanel
