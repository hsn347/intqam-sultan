local baseProxy = require("fgui.base.baseProxy")
local WarHornBuyGiftProxy = class("WarHornBuyGiftProxy", baseProxy)
function WarHornBuyGiftProxy:onRegisterEvent()
	print("=======WarHornBuyGiftProxy:onRegisterEvent")
end
return WarHornBuyGiftProxy
