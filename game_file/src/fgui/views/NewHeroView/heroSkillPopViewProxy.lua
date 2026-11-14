local baseProxy = require("fgui.base.baseProxy")
local heroSkillPopViewProxy = class("heroSkillPopViewProxy", baseProxy)
function heroSkillPopViewProxy:onRegisterEvent()
	print("=======heroSkillPopViewProxy:onRegisterEvent")
end
return heroSkillPopViewProxy
