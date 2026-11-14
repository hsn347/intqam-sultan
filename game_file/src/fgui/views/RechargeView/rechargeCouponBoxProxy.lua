local baseProxy = require("fgui.base.baseProxy")
local rechargeCouponBoxProxy = class("rechargeCouponBoxProxy", baseProxy)
function rechargeCouponBoxProxy:onRegisterEvent()
	print("=======rechargeCouponBoxProxy:onRegisterEvent")
end
return rechargeCouponBoxProxy
