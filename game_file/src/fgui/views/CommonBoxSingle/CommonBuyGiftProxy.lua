local baseProxy = require("fgui.base.baseProxy")
local CommonBuyGiftProxy = class("CommonBuyGiftProxy", baseProxy)
function CommonBuyGiftProxy:onRegisterEvent()
	print("=======CommonBuyGiftProxy:onRegisterEvent")
end
return CommonBuyGiftProxy
