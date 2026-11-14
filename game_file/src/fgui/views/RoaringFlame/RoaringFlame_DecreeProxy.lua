local baseProxy = require("fgui.base.baseProxy")
local RoaringFlame_DecreeProxy = class("RoaringFlame_DecreeProxy", baseProxy)
function RoaringFlame_DecreeProxy:onRegisterEvent()
	print("=======RoaringFlame_DecreeProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_REFRESHDATA", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_QUESTREWARD", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_DECREEREWARD", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_DECREEGIFT", handler(self, self.initView))
end
function RoaringFlame_DecreeProxy:initView(target, data)
	self.view:initView(target, data)
end
return RoaringFlame_DecreeProxy
