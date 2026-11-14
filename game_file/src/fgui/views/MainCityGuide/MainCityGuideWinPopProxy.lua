local baseProxy = require("fgui.base.baseProxy")
local MainCityGuideWinPopProxy = class("MainCityGuideWinPopProxy", baseProxy)
function MainCityGuideWinPopProxy:onRegisterEvent()
	print("=======MainCityGuideWinPopProxy:onRegisterEvent")
end
return MainCityGuideWinPopProxy
