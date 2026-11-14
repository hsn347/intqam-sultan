local baseProxy = require("fgui.base.baseProxy")
local ManorCityBuildListProxy = class("ManorCityBuildListProxy", baseProxy)
function ManorCityBuildListProxy:onRegisterEvent()
	print("=======ManorCityBuildListProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_MAP_INIT", handler(self, self.onMsgMapInit))
	SoraDAddMessage(self, "MESSAGE_MANOR_BUILD_NEW", handler(self, self.onMsgBuildNew))
end
function ManorCityBuildListProxy:onMsgMapInit(...)
	self.view:onMsgMapInit(...)
end
function ManorCityBuildListProxy:onMsgBuildNew(...)
	self.view:onMsgBuildNew(...)
end
return ManorCityBuildListProxy
