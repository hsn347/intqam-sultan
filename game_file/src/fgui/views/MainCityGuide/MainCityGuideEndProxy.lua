local baseProxy = require("fgui.base.baseProxy")
local MainCityGuideEndProxy = class("MainCityGuideEndProxy", baseProxy)
function MainCityGuideEndProxy:onRegisterEvent()
	print("=======MainCityGuideEndProxy:onRegisterEvent")
end
return MainCityGuideEndProxy
