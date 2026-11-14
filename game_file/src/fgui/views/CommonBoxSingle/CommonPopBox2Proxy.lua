local baseProxy = require("fgui.base.baseProxy")
local CommonPopBox2Proxy = class("CommonPopBox2Proxy", baseProxy)
function CommonPopBox2Proxy:onRegisterEvent()
	print("=======CommonPopBox2Proxy:onRegisterEvent")
end
return CommonPopBox2Proxy
