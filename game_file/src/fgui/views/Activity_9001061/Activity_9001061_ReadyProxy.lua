local baseProxy = require("fgui.base.baseProxy")
local Activity_9001061_ReadyProxy = class("Activity_9001061_ReadyProxy", baseProxy)
function Activity_9001061_ReadyProxy:onRegisterEvent()
	print("=======Activity_9001061_ReadyProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_KINGSORDER_CLOSEFRAME", handler(self, self.closeSelf))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_KINGSORDER", handler(self, self.msgCallBack))
end
function Activity_9001061_ReadyProxy:msgCallBack()
	SoraDCloseLoading(self.view)
	self.view:initData()
end
function Activity_9001061_ReadyProxy:closeSelf()
	SoraDRemoveAllAfterPanelFromManager(self)
end
return Activity_9001061_ReadyProxy
