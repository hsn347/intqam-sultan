local baseProxy = require("fgui.base.baseProxy")
local SunnyLanePopupProxy = class("SunnyLanePopupProxy", baseProxy)
function SunnyLanePopupProxy:onRegisterEvent()
	print("=======SunnyLanePopupProxy:onRegisterEvent")
end
return SunnyLanePopupProxy
