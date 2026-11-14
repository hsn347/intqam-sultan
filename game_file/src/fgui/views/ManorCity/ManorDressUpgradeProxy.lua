local baseProxy = require("fgui.base.baseProxy")
local ManorDressUpgradeProxy = class("ManorDressUpgradeProxy", baseProxy)
function ManorDressUpgradeProxy:onRegisterEvent()
	print("=======ManorDressUpgradeProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_DRESS_EXCHANGE", handler(self, self.onMsgDressExchange))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_DRESS_UPDATE", handler(self, self.onMsgDressUpdate))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_BACKPACK_UPDATE", handler(self, self.onMsgBackpackUpdate))
end
function ManorDressUpgradeProxy:onMsgDressExchange(...)
	self.view:onMsgDressExchange(...)
end
function ManorDressUpgradeProxy:onMsgDressUpdate(...)
	self.view:onMsgDressUpdate(...)
end
function ManorDressUpgradeProxy:onMsgBackpackUpdate(...)
	self.view:onMsgBackpackUpdate(...)
end
return ManorDressUpgradeProxy
