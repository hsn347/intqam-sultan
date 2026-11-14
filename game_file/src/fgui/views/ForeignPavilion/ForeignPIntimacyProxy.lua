local baseProxy = require("fgui.base.baseProxy")
local ForeignPIntimacyProxy = class("ForeignPIntimacyProxy", baseProxy)
function ForeignPIntimacyProxy:onRegisterEvent()
	print("=======ForeignPIntimacyProxy:onRegisterEvent")
end
return ForeignPIntimacyProxy
