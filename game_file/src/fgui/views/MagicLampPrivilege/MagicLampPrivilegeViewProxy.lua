local baseProxy = require("fgui.base.baseProxy")
local MagicLampPrivilegeViewProxy = class("MagicLampPrivilegeViewProxy", baseProxy)
function MagicLampPrivilegeViewProxy:onRegisterEvent()
	print("=======MagicLampPrivilegeViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAINCITY_CASTLE_GIFT_MSG", handler(self, self.initData))
end
function MagicLampPrivilegeViewProxy:initData()
	self.view:initData()
end
return MagicLampPrivilegeViewProxy
