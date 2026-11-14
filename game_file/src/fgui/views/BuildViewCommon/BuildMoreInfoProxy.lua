local baseProxy = require("fgui.base.baseProxy")
local BuildMoreInfoProxy = class("BuildMoreInfoProxy", baseProxy)
function BuildMoreInfoProxy:onRegisterEvent()
	print("=======BuildMoreInfoProxy:onRegisterEvent")
end
return BuildMoreInfoProxy
