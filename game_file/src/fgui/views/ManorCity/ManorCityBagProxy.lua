local baseProxy = require("fgui.base.baseProxy")
local ManorCityBagProxy = class("ManorCityBagProxy", baseProxy)
function ManorCityBagProxy:onRegisterEvent()
	print("=======ManorCityBagProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_BACKPACK_UPDATE", handler(self, self.onMsgBackpackUpdate))
end
function ManorCityBagProxy:onMsgBackpackUpdate(...)
	self.view:onMsgBackpackUpdate(...)
end
return ManorCityBagProxy
