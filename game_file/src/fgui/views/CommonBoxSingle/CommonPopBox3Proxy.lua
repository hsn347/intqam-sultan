local baseProxy = require("fgui.base.baseProxy")
local CommonPopBox3Proxy = class("CommonPopBox3Proxy", baseProxy)
function CommonPopBox3Proxy:onRegisterEvent()
	print("=======CommonPopBox3Proxy:onRegisterEvent")
end
return CommonPopBox3Proxy
