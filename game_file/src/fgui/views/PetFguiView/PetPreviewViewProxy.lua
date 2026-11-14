local baseProxy = require("fgui.base.baseProxy")
local PetPreviewViewProxy = class("PetPreviewViewProxy", baseProxy)
function PetPreviewViewProxy:onRegisterEvent()
	print("=======PetPreviewViewProxy:onRegisterEvent")
end
return PetPreviewViewProxy
