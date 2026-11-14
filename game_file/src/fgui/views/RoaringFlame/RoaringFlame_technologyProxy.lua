local baseProxy = require("fgui.base.baseProxy")
local RoaringFlame_technologyProxy = class("RoaringFlame_technologyProxy", baseProxy)
function RoaringFlame_technologyProxy:onRegisterEvent()
	print("=======RoaringFlame_technologyProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_TECHNOLOGY", handler(self, self.initData))
end
function RoaringFlame_technologyProxy:initData()
	self.view:initData()
end
return RoaringFlame_technologyProxy
