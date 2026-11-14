local baseProxy = require("fgui.base.baseProxy")
local BuildUpgradeStatueBraveProxy = class("BuildUpgradeStatueBraveProxy", baseProxy)
function BuildUpgradeStatueBraveProxy:onRegisterEvent()
	print("=======BuildUpgradeStatueBraveProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.resUpdate))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.resUpdate))
	SoraDAddMessage(self, "MESSAGE_CHEAT_BUILD_SUCCESS", handler(self, self.closeLoading))
	SoraDAddMessage(self, "MESSAGE_SERVER_LUCKY_DAY_UPDATE", handler(self, self.updateLuckyBless))
	SoraDAddMessage(self, "MESSAGE_SERVER_LUCKYBLESS_UPDATE", handler(self, self.updateLuckyBless))
	SoraDAddMessage(self, "MESSAGE_RADIANT_DECREE_REFRESH", handler(self, self.onMsgUpdateActivity))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.onMsgUpdateActivity))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_STATUEBRAVE_QUEQUE_CALLBACK", handler(self, self.onMsgBuildStarQueueCallback))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_BUILD_QUEQUE_CALLBACK", handler(self, self.onMsgBuildQueueCallback))
	SoraDAddMessage(self, "MESSAGE_BUILD_STAR_UPGRADE_MSG_BACK", handler(self, self.upgradeMsgBack))
end
function BuildUpgradeStatueBraveProxy:resUpdate(...)
	self.view:resUpdate(...)
end
function BuildUpgradeStatueBraveProxy:updateLuckyBless(...)
	self.view:updateLuckyBless(...)
end
function BuildUpgradeStatueBraveProxy:closeLoading(target, data)
	SoraDCloseLoading(self.view:displayObject())
end
function BuildUpgradeStatueBraveProxy:onMsgUpdateActivity(...)
	self.view:updateListBuffData(...)
end
function BuildUpgradeStatueBraveProxy:upgradeMsgBack(...)
	self.view:upgradeMsgBack(...)
end
function BuildUpgradeStatueBraveProxy:onMsgBuildStarQueueCallback(...)
	self.view:onMsgBuildStarQueueCallback(...)
end
function BuildUpgradeStatueBraveProxy:onMsgBuildQueueCallback(...)
	self.view:onMsgBuildQueueCallback(...)
end
return BuildUpgradeStatueBraveProxy
