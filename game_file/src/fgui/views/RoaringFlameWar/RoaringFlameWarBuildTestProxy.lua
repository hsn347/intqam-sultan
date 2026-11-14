local baseProxy = require("fgui.base.baseProxy")
local RoaringFlameWarBuildTestProxy = class("RoaringFlameWarBuildTestProxy", baseProxy)
function RoaringFlameWarBuildTestProxy:onRegisterEvent()
	print("=======RoaringFlameWarBuildTestProxy:onRegisterEvent")
end
return RoaringFlameWarBuildTestProxy
