local baseProxy = require("fgui.base.baseProxy")
local CommonItemExtraShowBoxProxy = class("CommonItemExtraShowBoxProxy", baseProxy)
function CommonItemExtraShowBoxProxy:onRegisterEvent()
	print("=======CommonItemExtraShowBoxProxy:onRegisterEvent")
end
return CommonItemExtraShowBoxProxy
