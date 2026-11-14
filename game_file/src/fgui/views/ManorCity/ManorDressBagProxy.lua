local baseProxy = require("fgui.base.baseProxy")
local ManorDressBagProxy = class("ManorDressBagProxy", baseProxy)
function ManorDressBagProxy:onRegisterEvent()
	print("=======ManorDressBagProxy:onRegisterEvent")
end
return ManorDressBagProxy
