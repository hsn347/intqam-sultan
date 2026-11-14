local gametop = gModuleMgr.getObject("gametop")
local royalSummonsCtrl = gametop.playertop_:getModule("royalSummonsCtrl")
local royalSummonsUtil = include("royalSummonsUtil")
local royalSummonsMainTaskSingle = class("royalSummonsMainTaskSingle", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("royalSummonsMainTaskSingle")
	end
	local commonTaskSingle = include("commonTaskSingle")
	target = commonTaskSingle.new(target)
	return target
end)
local gBtnTargetStatusDef = _G.gBtnTargetStatusDef
function royalSummonsMainTaskSingle:ctor()
end
function royalSummonsMainTaskSingle:initData(data, otherData)
	if otherData then
		self.mainView = otherData.mainView
	end
	local taskID = data.taskID
	data.count = royalSummonsUtil:getTaskProgress(taskID)
	data.total = royalSummonsUtil:getTaskAmount(taskID)
	self:initData_imp(data, otherData)
	if self.taskStatus == gBtnTargetStatusDef.GO and royalSummonsUtil:isSpiceilTask(self.data) then
		self.Button_go:setVisible(false)
	else
		self.Button_go:setVisible(true)
	end
end
function royalSummonsMainTaskSingle:doAction()
	local taskID = self.data.taskID
	SoraDShowLoading(self.mainView)
	royalSummonsCtrl:reqActivityGetTaskReward(taskID)
end
function royalSummonsMainTaskSingle:skipTo(taskDes)
	local data = self.data
	royalSummonsUtil:skipTo(data, taskDes)
end
return royalSummonsMainTaskSingle
