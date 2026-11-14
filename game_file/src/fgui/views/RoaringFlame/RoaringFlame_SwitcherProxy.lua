local baseProxy = require("fgui.base.baseProxy")
local RoaringFlame_SwitcherProxy = class("RoaringFlame_SwitcherProxy", baseProxy)
function RoaringFlame_SwitcherProxy:onRegisterEvent()
	print("=======RoaringFlame_SwitcherProxy:onRegisterEvent")
end
return RoaringFlame_SwitcherProxy
