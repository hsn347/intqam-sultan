local baseProxy = require("fgui.base.baseProxy")
local kohMigrateKidGroupProxy = class("kohMigrateKidGroupProxy", baseProxy)
function kohMigrateKidGroupProxy:onRegisterEvent()
	print("=======kohMigrateKidGroupProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_KOHMIGRATE_GROUPLIST", function(target, event)
		SoraDCloseLoading(self.view)
		self.view:initKingdomGroup(event.data)
	end)
end
return kohMigrateKidGroupProxy
