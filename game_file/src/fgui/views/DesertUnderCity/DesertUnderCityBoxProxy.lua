local baseProxy = require("fgui.base.baseProxy")
local DesertUnderCityBoxProxy = class("DesertUnderCityBoxProxy", baseProxy)
function DesertUnderCityBoxProxy:onRegisterEvent()
	print("=======DesertUnderCityBoxProxy:onRegisterEvent")
end
return DesertUnderCityBoxProxy
