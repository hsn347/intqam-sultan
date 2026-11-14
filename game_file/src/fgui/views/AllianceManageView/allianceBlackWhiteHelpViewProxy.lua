local baseProxy = require("fgui.base.baseProxy")
local allianceBlackWhiteHelpViewProxy = class("allianceBlackWhiteHelpViewProxy", baseProxy)
function allianceBlackWhiteHelpViewProxy:onRegisterEvent()
	print("=======allianceBlackWhiteHelpViewProxy:onRegisterEvent")
end
return allianceBlackWhiteHelpViewProxy
