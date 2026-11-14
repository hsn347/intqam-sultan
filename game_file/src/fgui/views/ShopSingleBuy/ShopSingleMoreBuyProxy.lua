local baseProxy = require("fgui.base.baseProxy")
local ShopSingleMoreBuyProxy = class("ShopSingleMoreBuyProxy", baseProxy)
function ShopSingleMoreBuyProxy:onRegisterEvent()
	print("=======ShopSingleMoreBuyProxy:onRegisterEvent")
end
return ShopSingleMoreBuyProxy
