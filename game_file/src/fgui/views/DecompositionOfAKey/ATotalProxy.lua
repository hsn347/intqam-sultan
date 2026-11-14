local baseProxy = require("fgui.base.baseProxy")
local ATotalProxy = class("ATotalProxy", baseProxy)
function ATotalProxy:onRegisterEvent()
	print("=======ATotalProxy:onRegisterEvent")
end
return ATotalProxy
