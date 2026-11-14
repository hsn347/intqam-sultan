local baseProxy = require("fgui.base.baseProxy")
local gameSettingViewProxy = class("gameSettingViewProxy", baseProxy)
function gameSettingViewProxy:onRegisterEvent()
	print("=======gameSettingViewProxy:onRegisterEvent")
end
return gameSettingViewProxy
