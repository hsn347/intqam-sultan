local baseProxy = require("fgui.base.baseProxy")
local SimpleMoveLineSettingProxy = class("SimpleMoveLineSettingProxy", baseProxy)
function SimpleMoveLineSettingProxy:onRegisterEvent()
	print("=======SimpleMoveLineSettingProxy:onRegisterEvent")
end
return SimpleMoveLineSettingProxy
