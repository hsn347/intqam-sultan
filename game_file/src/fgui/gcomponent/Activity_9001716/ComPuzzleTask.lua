local activity_9001716_Ctrl = SoraDGetCtrl("activity_9001716_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local ComPuzzleTask = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001716/ComPuzzleTask", ComPuzzleTask)
function ComPuzzleTask:onInit()
	self:addClickListener(handler(self, self.onClickSelf))
end
function ComPuzzleTask:onShow()
end
function ComPuzzleTask:onClickSelf(context)
	SoraDPlaySound()
	_ENV = nil
	;(nil).taskData = self.taskData
	;(nil).baseTask = self.baseTask
	uiManager:show("Activity_9001716_Task", nil)
end
function ComPuzzleTask:initData(bubbleTask)
	self.taskData = activity_9001716_Ctrl:getTaskData(tostring(bubbleTask.taskType))
	if not self.taskData then
		print_error(string.format("泡泡迷阵 %d 没有任务数据", bubbleTask.taskType))
	end
	self.baseTask = bubbleTask
	self.fields.icon:setURL(bubbleTask.taskIcon)
	if not self.taskData then
		activity_9001716_Ctrl = self.taskData
	end
	self.controllers.ctrlStatus:setSelectedIndex(self.taskData.taskStatus == activity_9001716_Ctrl.taskStatus.COMPLETE_DONE and 1 or 0)
	if not self.taskData then
		activity_9001716_Ctrl = self.taskData
	end
	if self.taskData.taskStatus == activity_9001716_Ctrl.taskStatus.COMPLETE then
		self.fields.prefabEx:setEffectPath("fx_9001716_glow.prefab")
	else
		self.fields.prefabEx:clearEffect()
	end
end
return ComPuzzleTask
