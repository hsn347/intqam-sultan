local baseProxy = require("fgui.base.baseProxy")
local AlliancePetSelectPopProxy = class("AlliancePetSelectPopProxy", baseProxy)
function AlliancePetSelectPopProxy:onRegisterEvent()
	print("=======AlliancePetSelectPopProxy:onRegisterEvent")
end
return AlliancePetSelectPopProxy
