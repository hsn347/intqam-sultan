local baseProxy = require("fgui.base.baseProxy")
local RoaringFlame_MileStoneProxy = class("RoaringFlame_MileStoneProxy", baseProxy)
function RoaringFlame_MileStoneProxy:onRegisterEvent()
	print("=======RoaringFlame_MileStoneProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_MILESTONE", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_STATEDATA", handler(self, self.initView))
end
function RoaringFlame_MileStoneProxy:initView(target, data)
	self.view:initView(target, data)
end
return RoaringFlame_MileStoneProxy
