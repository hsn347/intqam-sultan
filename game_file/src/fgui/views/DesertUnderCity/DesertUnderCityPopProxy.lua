local baseProxy = require("fgui.base.baseProxy")
local DesertUnderCityPopProxy = class("DesertUnderCityPopProxy", baseProxy)
function DesertUnderCityPopProxy:onRegisterEvent()
	print("=======DesertUnderCityPopProxy:onRegisterEvent")
end
return DesertUnderCityPopProxy
