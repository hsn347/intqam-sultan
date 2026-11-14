local baseProxy = require("fgui.base.baseProxy")
local RoaringFlame_SkillDetailProxy = class("RoaringFlame_SkillDetailProxy", baseProxy)
function RoaringFlame_SkillDetailProxy:onRegisterEvent()
	print("=======RoaringFlame_SkillDetailProxy:onRegisterEvent")
end
return RoaringFlame_SkillDetailProxy
