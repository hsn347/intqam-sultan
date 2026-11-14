local baseProxy = require("fgui.base.baseProxy")
local RadiantDecreeBuffPreviewProxy = class("RadiantDecreeBuffPreviewProxy", baseProxy)
function RadiantDecreeBuffPreviewProxy:onRegisterEvent()
	print("=======RadiantDecreeBuffPreviewProxy:onRegisterEvent")
end
return RadiantDecreeBuffPreviewProxy
