local baseProxy = require("fgui.base.baseProxy")
local ArtisanHouseBlessLightProxy = class("ArtisanHouseBlessLightProxy", baseProxy)
function ArtisanHouseBlessLightProxy:onRegisterEvent()
	print("=======ArtisanHouseBlessLightProxy:onRegisterEvent")
end
return ArtisanHouseBlessLightProxy
