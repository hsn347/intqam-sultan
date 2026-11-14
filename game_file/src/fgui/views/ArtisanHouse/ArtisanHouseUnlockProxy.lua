local baseProxy = require("fgui.base.baseProxy")
local ArtisanHouseUnlockProxy = class("ArtisanHouseUnlockProxy", baseProxy)
function ArtisanHouseUnlockProxy:onRegisterEvent()
	print("=======ArtisanHouseUnlockProxy:onRegisterEvent")
end
return ArtisanHouseUnlockProxy
