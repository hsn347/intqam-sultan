local baseProxy = require("fgui.base.baseProxy")
local ManorBuildUpgradeProxy = class("ManorBuildUpgradeProxy", baseProxy)
function ManorBuildUpgradeProxy:onRegisterEvent()
	print("=======ManorBuildUpgradeProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MANOR_BUILD_UPGRADE_BACK", handler(self, self.onMsgUpgradeBuildBack))
	SoraDAddMessage(self, "MESSAGE_MANOR_BUILD_UPGRADE_QUEUE", handler(self, self.onMsgUpgradeBuildQueue))
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.onMsgResourceUpdate))
end
function ManorBuildUpgradeProxy:onMsgUpgradeBuildBack(...)
	self.view:onMsgUpgradeBuildBack(...)
end
function ManorBuildUpgradeProxy:onMsgUpgradeBuildQueue(...)
	self.view:onMsgUpgradeBuildQueue(...)
end
function ManorBuildUpgradeProxy:onMsgResourceUpdate(...)
	self.view:onMsgResourceUpdate(...)
end
return ManorBuildUpgradeProxy
