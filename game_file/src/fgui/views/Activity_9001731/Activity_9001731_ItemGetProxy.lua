local baseProxy = require("fgui.base.baseProxy")
local Activity_9001731_ItemGetProxy = class("Activity_9001731_ItemGetProxy", baseProxy)
function Activity_9001731_ItemGetProxy:onRegisterEvent()
	print("=======Activity_9001731_ItemGetProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001731_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REFRESH", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.closeView))
end
function Activity_9001731_ItemGetProxy:updateView(target, data)
	self.view:updateView()
end
function Activity_9001731_ItemGetProxy:closeView(target, data)
	self.view:close()
end
return Activity_9001731_ItemGetProxy
