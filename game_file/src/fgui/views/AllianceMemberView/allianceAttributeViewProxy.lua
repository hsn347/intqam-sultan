local baseProxy = require("fgui.base.baseProxy")
local allianceAttributeViewProxy = class("allianceAttributeViewProxy", baseProxy)
function allianceAttributeViewProxy:onRegisterEvent()
	print("=======allianceAttributeViewProxy:onRegisterEvent")
end
return allianceAttributeViewProxy
