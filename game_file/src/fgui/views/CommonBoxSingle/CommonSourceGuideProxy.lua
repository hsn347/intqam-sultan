local baseProxy = require("fgui.base.baseProxy")
local CommonSourceGuideProxy = class("CommonSourceGuideProxy", baseProxy)
function CommonSourceGuideProxy:onRegisterEvent()
	print("=======CommonSourceGuideProxy:onRegisterEvent")
end
return CommonSourceGuideProxy
