local baseProxy = require("fgui.base.baseProxy")
local BuildCreateInfoProxy = class("BuildCreateInfoProxy", baseProxy)
function BuildCreateInfoProxy:onRegisterEvent()
	print("=======BuildCreateInfoProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_BUILDER_OPEN", handler(self, self.resUpdate))
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.resUpdate))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.resUpdate))
	SoraDAddMessage(self, "MESSAGE_SERVER_BADGE_EXCHANGE_BACK", handler(self, self.resUpdate))
	SoraDAddMessage(self, "MESSAGE_SERVER_LUCKY_DAY_UPDATE", handler(self, self.updateLuckyBless))
	SoraDAddMessage(self, "MESSAGE_SERVER_LUCKYBLESS_UPDATE", handler(self, self.updateLuckyBless))
	SoraDAddMessage(self, "MESSAGE_WISE_TUTOR_REFRESH", handler(self, self.resUpdate))
	SoraDAddMessage(self, "MESSAGE_EXTREMELY_SKILLFUL_REFRESH", handler(self, self.resUpdate))
	SoraDAddMessage(self, "MESSAGE_CHEAT_BUILD_SUCCESS", handler(self, self.closeLoading))
	SoraDAddMessage(self, "MESSAGE_ARTISAN_HOUSE_REFRESH", handler(self, self.resUpdate))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.onMsgUpdateActivity))
	SoraDAddMessage(self, "MESSAGE_BUILD_INFO_UPGRADE", handler(self, self.closeByBuildLock))
	SoraDAddMessage(self, "MESSAGE_BUILD_UPGRADE_MSG_BACK", handler(self, self.upgradeMsgBack))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_BUILD_QUEQUE_CALLBACK", handler(self, self.onMsgBuildQueueCallback))
end
function BuildCreateInfoProxy:resUpdate(...)
	self.view:resUpdate(...)
end
function BuildCreateInfoProxy:updateLuckyBless(...)
	self.view:updateLuckyBless(...)
end
function BuildCreateInfoProxy:closeLoading(target, data)
	SoraDCloseLoading(self.view:displayObject())
end
function BuildCreateInfoProxy:onMsgUpdateActivity(...)
	self.view:updateListBuffData(...)
end
function BuildCreateInfoProxy:closeByBuildLock(...)
	self.view:closeByBuildLock(...)
end
function BuildCreateInfoProxy:upgradeMsgBack(...)
	self.view:upgradeMsgBack(...)
end
function BuildCreateInfoProxy:onMsgBuildQueueCallback(...)
	self.view:onMsgBuildQueueCallback(...)
end
return BuildCreateInfoProxy
