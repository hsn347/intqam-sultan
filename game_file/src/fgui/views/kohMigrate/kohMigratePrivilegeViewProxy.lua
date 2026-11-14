local baseProxy = require("fgui.base.baseProxy")
local kohMigratePrivilegeViewProxy = class("kohMigratePrivilegeViewProxy", baseProxy)
function kohMigratePrivilegeViewProxy:onRegisterEvent()
	print("=======kohMigratePrivilegeViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMUSR_CHANGED", function(target, redata)
		local kohMigrateCtrl = SoraDGetCtrl("kohMigrateCtrl")
		if not kohMigrateCtrl:isShowPrivilegeBtn() then
			SoraDRemoveAllAfterPanelFromManager(self.view)
		end
	end)
	SoraDAddMessage(self, "MESSAGE_KOHMIGRATE_REFRESH_REDPOINT", handler(self, self.refreshRedPoint))
end
function kohMigratePrivilegeViewProxy:refreshRedPoint(...)
	self.view:refreshRedPoint(...)
end
return kohMigratePrivilegeViewProxy
