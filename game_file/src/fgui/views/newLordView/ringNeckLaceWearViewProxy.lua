local baseProxy = require("fgui.base.baseProxy")
local ringNeckLaceWearViewProxy = class("ringNeckLaceWearViewProxy", baseProxy)
function ringNeckLaceWearViewProxy:onRegisterEvent()
	print("=======ringNeckLaceWearViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_ADD_SUCCESS", handler(self, self.updateScrollData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_LIMIT_TIMEOUT", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_SET_WEAR_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_EXCHANGE_BACK", handler(self, self.updateScrollData))
end
function ringNeckLaceWearViewProxy:updateScrollData(target, data)
	self.view:updateScrollData(target, data)
end
function ringNeckLaceWearViewProxy:updateView(target, data)
	self.view:updateView(target, data)
end
return ringNeckLaceWearViewProxy
