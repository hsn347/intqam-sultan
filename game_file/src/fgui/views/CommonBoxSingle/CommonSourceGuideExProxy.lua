local baseProxy = require("fgui.base.baseProxy")
local CommonSourceGuideExProxy = class("CommonSourceGuideExProxy", baseProxy)
function CommonSourceGuideExProxy:onRegisterEvent()
	print("=======CommonSourceGuideExProxy:onRegisterEvent")
end
return CommonSourceGuideExProxy
