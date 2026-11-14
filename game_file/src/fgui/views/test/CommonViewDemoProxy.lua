local baseProxy = require("fgui.base.baseProxy")
local CommonViewDemoProxy = class("CommonViewDemoProxy", baseProxy)
function CommonViewDemoProxy:onRegisterEvent()
	print("=======CommonViewDemoProxy:onRegisterEvent")
end
return CommonViewDemoProxy
