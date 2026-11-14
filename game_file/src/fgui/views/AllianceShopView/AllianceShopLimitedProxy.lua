local baseProxy = require("fgui.base.baseProxy")
local AllianceShopLimitedProxy = class("AllianceShopLimitedProxy", baseProxy)
function AllianceShopLimitedProxy:onRegisterEvent()
	print("=======AllianceShopLimitedProxy:onRegisterEvent")
end
return AllianceShopLimitedProxy
