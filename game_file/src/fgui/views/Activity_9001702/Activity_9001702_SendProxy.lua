local baseProxy = require("fgui.base.baseProxy")
local Activity_9001702_SendProxy = class("Activity_9001702_SendProxy", baseProxy)
function Activity_9001702_SendProxy:onRegisterEvent()
	print("=======Activity_9001702_SendProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_LORD_SEARCH_BACK", handler(self, self.onMsgSearchBack))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001702_UPDATE", handler(self, self.onMsgUpdate))
end
function Activity_9001702_SendProxy:onMsgSearchBack(...)
	self.view:onMsgSearchBack(...)
end
function Activity_9001702_SendProxy:onMsgUpdate(...)
	self.view:onMsgUpdate(...)
end
return Activity_9001702_SendProxy
