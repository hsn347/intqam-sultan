local baseProxy = require("fgui.base.baseProxy")
local RadiantDecreeBlessLightProxy = class("RadiantDecreeBlessLightProxy", baseProxy)
function RadiantDecreeBlessLightProxy:onRegisterEvent()
	print("=======RadiantDecreeBlessLightProxy:onRegisterEvent")
end
return RadiantDecreeBlessLightProxy
