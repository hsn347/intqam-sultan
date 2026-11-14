local baseProxy = require("fgui.base.baseProxy")
local activity_9001716_Ctrl = SoraDGetCtrl("activity_9001716_Ctrl")
local Activity_9001716_TaskProxy = class("Activity_9001716_TaskProxy", baseProxy)
function Activity_9001716_TaskProxy:onRegisterEvent()
	print("=======Activity_9001716_TaskProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001716_COMMIT_TASK", handler(self, self.onMsgCommitTask))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001716_UPDATE_TASK", handler(self, self.onMsgActivityUpdate))
end
function Activity_9001716_TaskProxy:onMsgCommitTask(...)
	SoraDCloseLoading(self.view)
	self.view:close()
end
function Activity_9001716_TaskProxy:onMsgActivityUpdate(...)
	local bubbleTask = self.view.baseTask
	local newTaskInfo = activity_9001716_Ctrl:getTaskData(tostring(bubbleTask.taskType))
	self.view:initData(bubbleTask, newTaskInfo)
end
return Activity_9001716_TaskProxy
