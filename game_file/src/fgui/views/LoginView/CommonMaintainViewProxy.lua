local baseProxy = require("fgui.base.baseProxy")
local CommonMaintainViewProxy = class("CommonMaintainViewProxy", baseProxy)
function CommonMaintainViewProxy:onRegisterEvent()
	print("=======CommonMaintainViewProxy:onRegisterEvent")
end
return CommonMaintainViewProxy
