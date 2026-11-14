local baseProxy = require("fgui.base.baseProxy")
local FlyingStarWishSelectProxy = class("FlyingStarWishSelectProxy", baseProxy)
function FlyingStarWishSelectProxy:onRegisterEvent()
	print("=======FlyingStarWishSelectProxy:onRegisterEvent")
end
return FlyingStarWishSelectProxy
