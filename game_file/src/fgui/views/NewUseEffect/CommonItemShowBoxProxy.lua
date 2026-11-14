local baseProxy = require("fgui.base.baseProxy")
local CommonItemShowBoxProxy = class("CommonItemShowBoxProxy", baseProxy)
function CommonItemShowBoxProxy:onRegisterEvent()
	print("=======CommonItemShowBoxProxy:onRegisterEvent")
end
return CommonItemShowBoxProxy
