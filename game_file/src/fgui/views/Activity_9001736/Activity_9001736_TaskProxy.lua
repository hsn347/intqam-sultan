local baseProxy = require("fgui.base.baseProxy")
local Activity_9001736_TaskProxy = class("Activity_9001736_TaskProxy", baseProxy)
function Activity_9001736_TaskProxy:onRegisterEvent()
	print("=======Activity_9001736_TaskProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001736_QUEST_UPDATE", handler(self, self.onMsgUpdateQuest))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001736_UPDATE_DATA", handler(self, self.onMsgUpdateData))
end
function Activity_9001736_TaskProxy:onMsgUpdateQuest(...)
	self.view:onMsgUpdateQuest(...)
end
function Activity_9001736_TaskProxy:onMsgUpdateData(...)
	self.view:onMsgUpdateData(...)
end
return Activity_9001736_TaskProxy
