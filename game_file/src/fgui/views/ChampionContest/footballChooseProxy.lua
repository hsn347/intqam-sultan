local baseProxy = require("fgui.base.baseProxy")
local footballChooseProxy = class("footballChooseProxy", baseProxy)
function footballChooseProxy:onRegisterEvent()
	print("=======footballChooseProxy:onRegisterEvent")
end
return footballChooseProxy
