local baseProxy = require("fgui.base.baseProxy")
local SpineTestProxy = class("SpineTestProxy", baseProxy)
function SpineTestProxy:onRegisterEvent()
	print("=======SpineTestProxy:onRegisterEvent")
end
return SpineTestProxy
