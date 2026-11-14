local baseProxy = require("fgui.base.baseProxy")
local intetiorMainProxy = class("intetiorMainProxy", baseProxy)
function intetiorMainProxy:onRegisterEvent()
	print("=======intetiorMainProxy:onRegisterEvent")
end
return intetiorMainProxy
