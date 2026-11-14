local baseProxy = require("fgui.base.baseProxy")
local AllianceStrongPointBonusProxy = class("AllianceStrongPointBonusProxy", baseProxy)
function AllianceStrongPointBonusProxy:onRegisterEvent()
	print("=======AllianceStrongPointBonusProxy:onRegisterEvent")
end
return AllianceStrongPointBonusProxy
