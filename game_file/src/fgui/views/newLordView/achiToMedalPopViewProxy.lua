local baseProxy = require("fgui.base.baseProxy")
local achiToMedalPopViewProxy = class("achiToMedalPopViewProxy", baseProxy)
function achiToMedalPopViewProxy:onRegisterEvent()
	print("=======achiToMedalPopViewProxy:onRegisterEvent")
end
return achiToMedalPopViewProxy
