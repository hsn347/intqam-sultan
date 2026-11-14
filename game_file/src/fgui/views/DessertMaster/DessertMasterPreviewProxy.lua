local baseProxy = require("fgui.base.baseProxy")
local DessertMasterPreviewProxy = class("DessertMasterPreviewProxy", baseProxy)
function DessertMasterPreviewProxy:onRegisterEvent()
	print("=======DessertMasterPreviewProxy:onRegisterEvent")
end
return DessertMasterPreviewProxy
