local baseProxy = require("fgui.base.baseProxy")
local ringShopPopViewProxy = class("ringShopPopViewProxy", baseProxy)
function ringShopPopViewProxy:onRegisterEvent()
	print("=======ringShopPopViewProxy:onRegisterEvent")
end
return ringShopPopViewProxy
