local baseProxy = require("fgui.base.baseProxy")
local RoaringFlame_SkillBookProxy = class("RoaringFlame_SkillBookProxy", baseProxy)
function RoaringFlame_SkillBookProxy:onRegisterEvent()
	print("=======RoaringFlame_SkillBookProxy:onRegisterEvent")
end
return RoaringFlame_SkillBookProxy
