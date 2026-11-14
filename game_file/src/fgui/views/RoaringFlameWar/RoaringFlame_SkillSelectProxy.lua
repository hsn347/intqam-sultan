local baseProxy = require("fgui.base.baseProxy")
local RoaringFlame_SkillSelectProxy = class("RoaringFlame_SkillSelectProxy", baseProxy)
function RoaringFlame_SkillSelectProxy:onRegisterEvent()
	print("=======RoaringFlame_SkillSelectProxy:onRegisterEvent")
end
return RoaringFlame_SkillSelectProxy
