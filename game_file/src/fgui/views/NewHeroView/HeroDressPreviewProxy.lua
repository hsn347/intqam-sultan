local baseProxy = require("fgui.base.baseProxy")
local HeroDressPreviewProxy = class("HeroDressPreviewProxy", baseProxy)
function HeroDressPreviewProxy:onRegisterEvent()
	print("=======HeroDressPreviewProxy:onRegisterEvent")
end
return HeroDressPreviewProxy
