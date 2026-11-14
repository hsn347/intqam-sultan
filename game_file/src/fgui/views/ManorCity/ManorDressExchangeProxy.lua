local baseProxy = require("fgui.base.baseProxy")
local ManorDressExchangeProxy = class("ManorDressExchangeProxy", baseProxy)
function ManorDressExchangeProxy:onRegisterEvent()
	print("=======ManorDressExchangeProxy:onRegisterEvent")
end
return ManorDressExchangeProxy
