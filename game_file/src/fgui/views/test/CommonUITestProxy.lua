local baseProxy = require("fgui.base.baseProxy")
local CommonUITestProxy = class("CommonUITestProxy", baseProxy)
function CommonUITestProxy:onRegisterEvent()
	print("=======CommonUITestProxy:onRegisterEvent")
end
return CommonUITestProxy
