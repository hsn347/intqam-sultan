local baseProxy = require("fgui.base.baseProxy")
local ManorCityViewProxy = class("ManorCityViewProxy", baseProxy)
function ManorCityViewProxy:onRegisterEvent()
	print("=======ManorCityViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MANOR_BUILD_UPGRADE_QUEUE", handler(self, self.onMsgUpgradeBuildQueue))
	SoraDAddMessage(self, "MESSAGE_MANOR_BUILD_TECH_QUEUE", handler(self, self.onMsgTechBuildQueue))
	SoraDAddMessage(self, "MESSAGE_MANOR_BUILD_LV_UP", handler(self, self.onMsgBuildLvUp))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_MAP_INIT", handler(self, self.onMsgMapInit))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_MAP_PLACE", handler(self, self.onMsgMapPlace))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onMsgItemChange))
end
function ManorCityViewProxy:onMsgTechBuildQueue(...)
	self.view:onMsgTechBuildQueue(...)
end
function ManorCityViewProxy:onMsgUpgradeBuildQueue(...)
	self.view:onMsgUpgradeBuildQueue(...)
end
function ManorCityViewProxy:onMsgMapInit(...)
	self.view:onMsgMapInit(...)
end
function ManorCityViewProxy:onMsgMapPlace(...)
	self.view:onMsgMapPlace(...)
end
function ManorCityViewProxy:onMsgBuildLvUp(...)
	self.view:onMsgBuildLvUp(...)
end
function ManorCityViewProxy:onMsgItemChange(...)
	self.view:onMsgItemChange(...)
end
return ManorCityViewProxy
