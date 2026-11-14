local baseProxy = require("fgui.base.baseProxy")
local ShopSingleBuyProxy = class("ShopSingleBuyProxy", baseProxy)
function ShopSingleBuyProxy:onRegisterEvent()
	print("=======ShopSingleBuyProxy:onRegisterEvent")
end
return ShopSingleBuyProxy
