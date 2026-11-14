local baseProxy = require("fgui.base.baseProxy")
local Activity_9001619_TaskViewProxy = class("Activity_9001619_TaskViewProxy", baseProxy)
function Activity_9001619_TaskViewProxy:onRegisterEvent()
	print("=======Activity_9001619_TaskViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.updateTaskData))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.updateTaskData))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_RESET_TASK", handler(self, self.updateTaskData))
end
function Activity_9001619_TaskViewProxy:updateTaskData(target, data)
	self.view:initData()
end
return Activity_9001619_TaskViewProxy
