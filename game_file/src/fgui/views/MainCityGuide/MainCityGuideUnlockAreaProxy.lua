local baseProxy = require("fgui.base.baseProxy")
local MainCityGuideUnlockAreaProxy = class("MainCityGuideUnlockAreaProxy", baseProxy)
function MainCityGuideUnlockAreaProxy:onRegisterEvent()
	print("=======MainCityGuideUnlockAreaProxy:onRegisterEvent")
end
return MainCityGuideUnlockAreaProxy
