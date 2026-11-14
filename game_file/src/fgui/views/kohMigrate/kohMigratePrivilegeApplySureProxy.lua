local baseProxy = require("fgui.base.baseProxy")
local kohMigratePrivilegeApplySureProxy = class("kohMigratePrivilegeApplySureProxy", baseProxy)
function kohMigratePrivilegeApplySureProxy:onRegisterEvent()
	print("=======kohMigratePrivilegeApplySureProxy:onRegisterEvent")
end
return kohMigratePrivilegeApplySureProxy
