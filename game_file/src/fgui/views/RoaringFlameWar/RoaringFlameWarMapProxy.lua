local baseProxy = require("fgui.base.baseProxy")
local RoaringFlameWarMapProxy = class("RoaringFlameWarMapProxy", baseProxy)
function RoaringFlameWarMapProxy:onRegisterEvent()
	print("=======RoaringFlameWarMapProxy:onRegisterEvent")
end
return RoaringFlameWarMapProxy
