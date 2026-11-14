local baseProxy = require("fgui.base.baseProxy")
local kohMigrateHelpViewProxy = class("kohMigrateHelpViewProxy", baseProxy)
function kohMigrateHelpViewProxy:onRegisterEvent()
	print("=======kohMigrateHelpViewProxy:onRegisterEvent")
end
return kohMigrateHelpViewProxy
