local baseProxy = require("fgui.base.baseProxy")
local kohMigrateMobilityViewProxy = class("kohMigrateMobilityViewProxy", baseProxy)
function kohMigrateMobilityViewProxy:onRegisterEvent()
	print("=======kohMigrateMobilityViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_KOHMIGRATE_REFRESH_RECORD", handler(self, self.refreshData))
end
function kohMigrateMobilityViewProxy:refreshData(...)
	self.view:refreshData(...)
end
return kohMigrateMobilityViewProxy
