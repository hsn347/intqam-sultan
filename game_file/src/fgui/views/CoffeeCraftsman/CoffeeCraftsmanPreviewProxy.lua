local baseProxy = require("fgui.base.baseProxy")
local CoffeeCraftsmanPreviewProxy = class("CoffeeCraftsmanPreviewProxy", baseProxy)
function CoffeeCraftsmanPreviewProxy:onRegisterEvent()
	print("=======CoffeeCraftsmanPreviewProxy:onRegisterEvent")
end
function CoffeeCraftsmanPreviewProxy:onRemoveView()
	print("=======CoffeeCraftsmanPreviewProxy:onRemoveView")
end
return CoffeeCraftsmanPreviewProxy
