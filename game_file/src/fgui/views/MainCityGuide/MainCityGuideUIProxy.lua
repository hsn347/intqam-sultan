local baseProxy = require("fgui.base.baseProxy")
local MainCityGuideUIProxy = class("MainCityGuideUIProxy", baseProxy)
function MainCityGuideUIProxy:onRegisterEvent()
	print("=======MainCityGuideUIProxy:onRegisterEvent")
end
return MainCityGuideUIProxy
