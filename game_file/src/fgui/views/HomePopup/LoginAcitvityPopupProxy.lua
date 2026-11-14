local baseProxy = require("fgui.base.baseProxy")
local LoginAcitvityPopupProxy = class("LoginAcitvityPopupProxy", baseProxy)
function LoginAcitvityPopupProxy:onRegisterEvent()
	print("=======LoginAcitvityPopupProxy:onRegisterEvent")
end
return LoginAcitvityPopupProxy
