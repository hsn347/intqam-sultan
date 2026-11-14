local baseProxy = require("fgui.base.baseProxy")
local WarframeExchangePopProxy = class("WarframeExchangePopProxy", baseProxy)
function WarframeExchangePopProxy:onRegisterEvent()
	print("=======WarframeExchangePopProxy:onRegisterEvent")
end
return WarframeExchangePopProxy
