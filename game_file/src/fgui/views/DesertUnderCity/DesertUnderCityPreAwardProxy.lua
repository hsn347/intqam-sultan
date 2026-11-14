local baseProxy = require("fgui.base.baseProxy")
local DesertUnderCityPreAwardProxy = class("DesertUnderCityPreAwardProxy", baseProxy)
function DesertUnderCityPreAwardProxy:onRegisterEvent()
	print("=======DesertUnderCityPreAwardProxy:onRegisterEvent")
end
return DesertUnderCityPreAwardProxy
