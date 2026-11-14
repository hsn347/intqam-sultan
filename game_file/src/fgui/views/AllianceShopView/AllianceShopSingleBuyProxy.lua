local baseProxy = require("fgui.base.baseProxy")
local AllianceShopSingleBuyProxy = class("AllianceShopSingleBuyProxy", baseProxy)
function AllianceShopSingleBuyProxy:onRegisterEvent()
	print("=======AllianceShopSingleBuyProxy:onRegisterEvent")
end
return AllianceShopSingleBuyProxy
