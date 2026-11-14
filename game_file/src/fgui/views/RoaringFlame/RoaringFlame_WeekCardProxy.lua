local baseProxy = require("fgui.base.baseProxy")
local RoaringFlame_WeekCardProxy = class("RoaringFlame_WeekCardProxy", baseProxy)
function RoaringFlame_WeekCardProxy:onRegisterEvent()
	print("=======RoaringFlame_WeekCardProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_BUYGIFT", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_CLAIMWEEKLY", handler(self, self.initView))
end
function RoaringFlame_WeekCardProxy:initView(target, data)
	self.view:initView(target, data)
end
return RoaringFlame_WeekCardProxy
