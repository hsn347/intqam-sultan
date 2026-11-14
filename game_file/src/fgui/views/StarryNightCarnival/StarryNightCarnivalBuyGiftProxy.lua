local baseProxy = require("fgui.base.baseProxy")
local StarryNightCarnivalBuyGiftProxy = class("StarryNightCarnivalBuyGiftProxy", baseProxy)
function StarryNightCarnivalBuyGiftProxy:onRegisterEvent()
	print("=======StarryNightCarnivalBuyGiftProxy:onRegisterEvent")
end
return StarryNightCarnivalBuyGiftProxy
