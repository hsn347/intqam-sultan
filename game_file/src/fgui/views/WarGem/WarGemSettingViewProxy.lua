local baseProxy = require("fgui.base.baseProxy")
local WarGemSettingViewProxy = class("WarGemSettingViewProxy", baseProxy)
function WarGemSettingViewProxy:onRegisterEvent()
	print("=======WarGemSettingViewProxy:onRegisterEvent")
end
return WarGemSettingViewProxy
