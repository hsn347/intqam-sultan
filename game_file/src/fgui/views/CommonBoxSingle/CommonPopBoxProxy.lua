local baseProxy = require("fgui.base.baseProxy")
local CommonPopBoxProxy = class("CommonPopBoxProxy", baseProxy)
function CommonPopBoxProxy:onRegisterEvent()
	print("=======CommonPopBoxProxy:onRegisterEvent")
end
return CommonPopBoxProxy
