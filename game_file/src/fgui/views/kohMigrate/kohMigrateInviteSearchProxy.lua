local baseProxy = require("fgui.base.baseProxy")
local kohMigrateInviteSearchProxy = class("kohMigrateInviteSearchProxy", baseProxy)
function kohMigrateInviteSearchProxy:onRegisterEvent()
	print("=======kohMigrateInviteSearchProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_KOHMIGRATE_SEARCH_BACK", handler(self, self.onSearchBack))
	SoraDAddMessage(self, "MESSAGE_KOHMIGRATE_REFRESH_PRIVILEGE_INVITELIST", function()
		self.view:refreshTextNum()
	end)
	SoraDAddMessage(self, "MESSAGE_KOHMIGRATE_REFRESH_KINGDOMDATA", function()
		self.view:refreshTextPower()
	end)
end
function kohMigrateInviteSearchProxy:onSearchBack(...)
	self.view:onSearchBack(...)
end
return kohMigrateInviteSearchProxy
