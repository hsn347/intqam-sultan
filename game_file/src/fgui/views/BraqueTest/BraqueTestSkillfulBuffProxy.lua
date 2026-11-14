local baseProxy = require("fgui.base.baseProxy")
local BraqueTestSkillfulBuffProxy = class("BraqueTestSkillfulBuffProxy", baseProxy)
function BraqueTestSkillfulBuffProxy:onRegisterEvent()
	print("=======BraqueTestSkillfulBuffProxy:onRegisterEvent")
end
return BraqueTestSkillfulBuffProxy
