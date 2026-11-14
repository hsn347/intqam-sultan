local baseProxy = require("fgui.base.baseProxy")
local RoaringFlameWarBeAttackProxy = class("RoaringFlameWarBeAttackProxy", baseProxy)
function RoaringFlameWarBeAttackProxy:onRegisterEvent()
	print("=======RoaringFlameWarBeAttackProxy:onRegisterEvent")
end
return RoaringFlameWarBeAttackProxy
