local baseProxy = require("fgui.base.baseProxy")
local CommonBuyBoxProxy = class("CommonBuyBoxProxy", baseProxy)
function CommonBuyBoxProxy:onRegisterEvent()
	print("=======CommonBuyBoxProxy:onRegisterEvent")
end
return CommonBuyBoxProxy
