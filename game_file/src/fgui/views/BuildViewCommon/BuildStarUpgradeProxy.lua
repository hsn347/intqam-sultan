local baseProxy = require("fgui.base.baseProxy")
local BuildStarUpgradeProxy = class("BuildStarUpgradeProxy", baseProxy)
function BuildStarUpgradeProxy:onRegisterEvent()
	print("=======BuildStarUpgradeProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.resUpdate))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.resUpdate))
	SoraDAddMessage(self, "MESSAGE_CHEAT_BUILD_SUCCESS", handler(self, self.closeLoading))
	SoraDAddMessage(self, "MESSAGE_SERVER_LUCKY_DAY_UPDATE", handler(self, self.updateLuckyBless))
	SoraDAddMessage(self, "MESSAGE_SERVER_LUCKYBLESS_UPDATE", handler(self, self.updateLuckyBless))
	SoraDAddMessage(self, "MESSAGE_RADIANT_DECREE_REFRESH", handler(self, self.onMsgUpdateActivity))
	SoraDAddMessage(self, "MESSAGE_EXTREMELY_SKILLFUL_REFRESH", handler(self, self.onMsgUpdateActivity))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.onMsgUpdateActivity))
	SoraDAddMessage(self, "MESSAGE_BUILD_STAR_UPGRADE_MSG_BACK", handler(self, self.upgradeMsgBack))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_BUILDSTAR_QUEQUE_CALLBACK", handler(self, self.onMsgBuildStarQueueCallback))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_BUILD_QUEQUE_CALLBACK", handler(self, self.onMsgBuildQueueCallback))
end
function BuildStarUpgradeProxy:resUpdate(...)
	self.view:resUpdate(...)
end
function BuildStarUpgradeProxy:updateLuckyBless(...)
	self.view:updateLuckyBless(...)
end
function BuildStarUpgradeProxy:closeLoading(target, data)
	SoraDCloseLoading(self.view:displayObject())
end
function BuildStarUpgradeProxy:onMsgUpdateActivity(...)
	self.view:updateListBuffData(...)
end
function BuildStarUpgradeProxy:upgradeMsgBack(...)
	self.view:upgradeMsgBack(...)
end
function BuildStarUpgradeProxy:onMsgBuildStarQueueCallback(...)
	self.view:onMsgBuildStarQueueCallback(...)
end
function BuildStarUpgradeProxy:onMsgBuildQueueCallback(...)
	self.view:onMsgBuildQueueCallback(...)
end
return BuildStarUpgradeProxy
