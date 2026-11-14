local baseProxy = require("fgui.base.baseProxy")
local Activity_9001061_MainProxy = class("Activity_9001061_MainProxy", baseProxy)
function Activity_9001061_MainProxy:onRegisterEvent()
	print("=======Activity_9001061_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_KINGSORDER", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_KINGSORDER_INITDATA", handler(self, self.updateView))
end
function Activity_9001061_MainProxy:updateView(target, data)
	SoraDCloseLoading(self.view)
	if data and data.isUpdateAll then
		SoraDRemoveAllAfterPanelFromManager(self)
		return
	end
	self.view:initData()
end
return Activity_9001061_MainProxy
