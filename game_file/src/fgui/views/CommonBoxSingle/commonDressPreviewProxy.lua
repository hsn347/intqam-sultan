local baseProxy = require("fgui.base.baseProxy")
local commonDressPreviewProxy = class("commonDressPreviewProxy", baseProxy)
function commonDressPreviewProxy:onRegisterEvent()
	print("=======commonDressPreviewProxy:onRegisterEvent")
end
return commonDressPreviewProxy
