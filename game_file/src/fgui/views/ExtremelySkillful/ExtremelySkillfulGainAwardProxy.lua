local baseProxy = require("fgui.base.baseProxy")
local ExtremelySkillfulGainAwardProxy = class("ExtremelySkillfulGainAwardProxy", baseProxy)
function ExtremelySkillfulGainAwardProxy:onRegisterEvent()
	print("=======ExtremelySkillfulGainAwardProxy:onRegisterEvent")
end
return ExtremelySkillfulGainAwardProxy
