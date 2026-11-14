local baseProxy = require("fgui.base.baseProxy")
local RadiantDecreeAwardPreviewProxy = class("RadiantDecreeAwardPreviewProxy", baseProxy)
function RadiantDecreeAwardPreviewProxy:onRegisterEvent()
	print("=======RadiantDecreeAwardPreviewProxy:onRegisterEvent")
end
return RadiantDecreeAwardPreviewProxy
