local baseProxy = require("fgui.base.baseProxy")
local DjViewProxy = class("DjViewProxy", baseProxy)
function DjViewProxy:onRegisterEvent()
	print("=======DjViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_INFO_UPDATE", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_ROOM_DISMISS", handler(self, self.djRoomDismiss))
end
function DjViewProxy:updateData(target, data)
	self.view:updateData(target, data)
end
function DjViewProxy:djRoomDismiss(target, data)
	self.view:djRoomDismiss(target, data)
end
return DjViewProxy
