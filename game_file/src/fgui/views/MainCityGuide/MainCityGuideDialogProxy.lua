local baseProxy = require("fgui.base.baseProxy")
local MainCityGuideDialogProxy = class("MainCityGuideDialogProxy", baseProxy)
function MainCityGuideDialogProxy:onRegisterEvent()
	print("=======MainCityGuideDialogProxy:onRegisterEvent")
end
return MainCityGuideDialogProxy
