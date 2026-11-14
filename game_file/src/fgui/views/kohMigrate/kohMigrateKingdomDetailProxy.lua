local baseProxy = require("fgui.base.baseProxy")
local kohMigrateKingdomDetailProxy = class("kohMigrateKingdomDetailProxy", baseProxy)
function kohMigrateKingdomDetailProxy:onRegisterEvent()
	print("=======kohMigrateKingdomDetailProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_KOHMIGRATE_REFRESH_KINGDOMDATA", function(target, event)
		self.view:refreshData()
	end)
	SoraDAddMessage(self, "MESSAGE_KOHMIGRATE_REFRESH_APPLYSTATUS", function(target, event)
		self.view:onMsgUpdateApplyStatus()
	end)
	SoraDAddMessage(self, "MESSAGE_KOHMIGRATE_REFRESH_KINGDOMLIST_PRIVILEGE_CLOSE", function()
		if self.isPrivilege then
			self.view:removeFromParent()
		end
	end)
end
return kohMigrateKingdomDetailProxy
