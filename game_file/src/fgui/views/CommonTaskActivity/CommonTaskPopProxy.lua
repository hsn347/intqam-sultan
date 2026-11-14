local baseProxy = require("fgui.base.baseProxy")
local CommonTaskPopProxy = class("CommonTaskPopProxy", baseProxy)
function CommonTaskPopProxy:onRegisterEvent()
	print("=======CommonTaskPopProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_COMMON_TASK_POP_UPDATE", handler(self, self.onMsgUpdateData))
end
function CommonTaskPopProxy:onMsgUpdateData(...)
	self.view:onMsgUpdateData(...)
end
return CommonTaskPopProxy
