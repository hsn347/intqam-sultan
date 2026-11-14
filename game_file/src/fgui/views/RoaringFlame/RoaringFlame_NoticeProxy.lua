local baseProxy = require("fgui.base.baseProxy")
local RoaringFlame_NoticeProxy = class("RoaringFlame_NoticeProxy", baseProxy)
function RoaringFlame_NoticeProxy:onRegisterEvent()
	print("=======RoaringFlame_NoticeProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ROARINGFLAMEWAR_REFRESHDATA", handler(self, self.initData))
end
function RoaringFlame_NoticeProxy:initData()
	self.view:initData()
end
return RoaringFlame_NoticeProxy
