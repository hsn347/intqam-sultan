local baseProxy = require("fgui.base.baseProxy")
local RoaringFlame_CampRewardProxy = class("RoaringFlame_CampRewardProxy", baseProxy)
function RoaringFlame_CampRewardProxy:onRegisterEvent()
	print("=======RoaringFlame_CampRewardProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_REFRESHDATA", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_DECREEGIFT", handler(self, self.initData))
end
function RoaringFlame_CampRewardProxy:initData()
	self.view:initData()
end
return RoaringFlame_CampRewardProxy
