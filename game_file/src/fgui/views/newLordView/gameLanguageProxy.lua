local baseProxy = require("fgui.base.baseProxy")
local gameLanguageProxy = class("gameLanguageProxy", baseProxy)
function gameLanguageProxy:onRegisterEvent()
	print("=======gameLanguageProxy:onRegisterEvent")
end
return gameLanguageProxy
