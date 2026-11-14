local baseProxy = require("fgui.base.baseProxy")
local ExtremelySkillfulAwardPreviewProxy = class("ExtremelySkillfulAwardPreviewProxy", baseProxy)
function ExtremelySkillfulAwardPreviewProxy:onRegisterEvent()
	print("=======ExtremelySkillfulAwardPreviewProxy:onRegisterEvent")
end
return ExtremelySkillfulAwardPreviewProxy
