local baseProxy = require("fgui.base.baseProxy")
local FlyingStarWishTaskProxy = class("FlyingStarWishTaskProxy", baseProxy)
function FlyingStarWishTaskProxy:onRegisterEvent()
	print("=======FlyingStarWishTaskProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_FLYING_STAR_WISH", handler(self, self.refreshView))
end
function FlyingStarWishTaskProxy:refreshView(target, data)
	if self.view and data.subMsg == "task" then
		self.view:initData()
	end
end
return FlyingStarWishTaskProxy
