local baseProxy = require("fgui.base.baseProxy")
local ArtisanHouseAwardPreviewProxy = class("ArtisanHouseAwardPreviewProxy", baseProxy)
function ArtisanHouseAwardPreviewProxy:onRegisterEvent()
	print("=======ArtisanHouseAwardPreviewProxy:onRegisterEvent")
end
return ArtisanHouseAwardPreviewProxy
