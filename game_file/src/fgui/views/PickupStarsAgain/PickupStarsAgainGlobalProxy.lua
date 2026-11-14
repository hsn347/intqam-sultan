local baseProxy = require("fgui.base.baseProxy")
local PickupStarsAgainGlobalProxy = class("PickupStarsAgainGlobalProxy", baseProxy)
function PickupStarsAgainGlobalProxy:onRegisterEvent()
	print("=======PickupStarsAgainGlobalProxy:onRegisterEvent")
end
return PickupStarsAgainGlobalProxy
