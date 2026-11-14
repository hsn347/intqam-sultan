local baseProxy = require("fgui.base.baseProxy")
local FlyingStarWishGiftListProxy = class("FlyingStarWishGiftListProxy", baseProxy)
function FlyingStarWishGiftListProxy:onRegisterEvent()
	print("=======FlyingStarWishGiftListProxy:onRegisterEvent")
end
return FlyingStarWishGiftListProxy
