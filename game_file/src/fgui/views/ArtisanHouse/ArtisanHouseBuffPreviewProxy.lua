local baseProxy = require("fgui.base.baseProxy")
local ArtisanHouseBuffPreviewProxy = class("ArtisanHouseBuffPreviewProxy", baseProxy)
function ArtisanHouseBuffPreviewProxy:onRegisterEvent()
	print("=======ArtisanHouseBuffPreviewProxy:onRegisterEvent")
end
return ArtisanHouseBuffPreviewProxy
