local baseProxy = require("fgui.base.baseProxy")
local MainCityGuideTestProxy = class("MainCityGuideTestProxy", baseProxy)
function MainCityGuideTestProxy:onRegisterEvent()
	print("=======MainCityGuideTestProxy:onRegisterEvent")
end
return MainCityGuideTestProxy
