local baseProxy = require("fgui.base.baseProxy")
local WishMeteorChooseProxy = class("WishMeteorChooseProxy", baseProxy)
function WishMeteorChooseProxy:onRegisterEvent()
	print("=======WishMeteorChooseProxy:onRegisterEvent")
end
return WishMeteorChooseProxy
