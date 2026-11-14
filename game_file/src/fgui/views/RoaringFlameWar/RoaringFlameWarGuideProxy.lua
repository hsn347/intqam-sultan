local baseProxy = require("fgui.base.baseProxy")
local RoaringFlameWarGuideProxy = class("RoaringFlameWarGuideProxy", baseProxy)
function RoaringFlameWarGuideProxy:onRegisterEvent()
	print("=======RoaringFlameWarGuideProxy:onRegisterEvent")
end
return RoaringFlameWarGuideProxy
