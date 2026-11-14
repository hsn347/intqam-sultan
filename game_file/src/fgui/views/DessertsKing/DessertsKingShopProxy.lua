local baseProxy = require("fgui.base.baseProxy")
local DessertsKingShopProxy = class("DessertsKingShopProxy", baseProxy)
function DessertsKingShopProxy:onRegisterEvent()
	print("=======DessertsKingShopProxy:onRegisterEvent")
end
return DessertsKingShopProxy
