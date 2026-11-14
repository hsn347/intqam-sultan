local baseProxy = require("fgui.base.baseProxy")
local MainCityGuideMadelinProxy = class("MainCityGuideMadelinProxy", baseProxy)
function MainCityGuideMadelinProxy:onRegisterEvent()
	print("=======MainCityGuideMadelinProxy:onRegisterEvent")
end
return MainCityGuideMadelinProxy
