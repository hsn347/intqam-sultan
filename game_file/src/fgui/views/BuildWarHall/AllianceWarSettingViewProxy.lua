local baseProxy = require("fgui.base.baseProxy")
local AllianceWarSettingViewProxy = class("AllianceWarSettingViewProxy", baseProxy)
function AllianceWarSettingViewProxy:onRegisterEvent()
	print("=======AllianceWarSettingViewProxy:onRegisterEvent")
end
return AllianceWarSettingViewProxy
