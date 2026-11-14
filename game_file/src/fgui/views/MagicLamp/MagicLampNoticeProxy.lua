local baseProxy = require("fgui.base.baseProxy")
local MagicLampNoticeProxy = class("MagicLampNoticeProxy", baseProxy)
function MagicLampNoticeProxy:onRegisterEvent()
	print("=======MagicLampNoticeProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_UPDATE_FIRE_JINN", handler(self, self.updateView))
end
function MagicLampNoticeProxy:updateView()
	self.view:initData()
end
return MagicLampNoticeProxy
