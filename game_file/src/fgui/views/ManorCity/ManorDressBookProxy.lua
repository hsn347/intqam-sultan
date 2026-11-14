local baseProxy = require("fgui.base.baseProxy")
local ManorDressBookProxy = class("ManorDressBookProxy", baseProxy)
function ManorDressBookProxy:onRegisterEvent()
	print("=======ManorDressBookProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_DRESS_EXCHANGE", handler(self, self.onMsgDressExchange))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_DRESS_UPDATE", handler(self, self.onMsgDressUpdate))
end
function ManorDressBookProxy:onMsgDressExchange(...)
	self.view:onMsgDressExchange(...)
end
function ManorDressBookProxy:onMsgDressUpdate(...)
	self.view:onMsgDressUpdate(...)
end
return ManorDressBookProxy
