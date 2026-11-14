local baseProxy = require("fgui.base.baseProxy")
local CommonSignPopProxy = class("CommonSignPopProxy", baseProxy)
function CommonSignPopProxy:onRegisterEvent()
	print("=======CommonSignPopProxy:onRegisterEvent")
end
return CommonSignPopProxy
