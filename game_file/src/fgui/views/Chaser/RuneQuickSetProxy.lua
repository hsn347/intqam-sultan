local baseProxy = require("fgui.base.baseProxy")
local RuneQuickSetProxy = class("RuneQuickSetProxy", baseProxy)
function RuneQuickSetProxy:onRegisterEvent()
	print("=======RuneQuickSetProxy:onRegisterEvent")
end
return RuneQuickSetProxy
