local baseProxy = require("fgui.base.baseProxy")
local Activity_9001661_MapProxy = class("Activity_9001661_MapProxy", baseProxy)
function Activity_9001661_MapProxy:onRegisterEvent()
	print("=======Activity_9001661_MapProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001661_UPDATE", handler(self, self.onMsgUpdateData))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001661_UI_MAP_JUMP", handler(self, self.onMsgJump))
end
function Activity_9001661_MapProxy:onMsgUpdateData(target, data)
	self.view:onMsgUpdateData(target, data)
end
function Activity_9001661_MapProxy:onMsgJump(target, data)
	self.view:onMsgJump(target, data)
end
return Activity_9001661_MapProxy
