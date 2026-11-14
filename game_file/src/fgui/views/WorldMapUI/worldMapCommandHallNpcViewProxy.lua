local baseProxy = require("fgui.base.baseProxy")
local worldMapCommandHallNpcViewProxy = class("worldMapCommandHallNpcViewProxy", baseProxy)
function worldMapCommandHallNpcViewProxy:onRegisterEvent()
	print("=======worldMapCommandHallNpcViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_BASE", handler(self, self.onMsgUpdateLordInfo))
end
function worldMapCommandHallNpcViewProxy:onMsgUpdateLordInfo(...)
	self.view:onMsgUpdateLordInfo(...)
end
return worldMapCommandHallNpcViewProxy
