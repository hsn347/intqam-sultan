local baseProxy = require("fgui.base.baseProxy")
local SpineShaderTestProxy = class("SpineShaderTestProxy", baseProxy)
function SpineShaderTestProxy:onRegisterEvent()
	print("=======SpineShaderTestProxy:onRegisterEvent")
end
return SpineShaderTestProxy
