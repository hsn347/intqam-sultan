local baseProxy = require("fgui.base.baseProxy")
local ForceBlessingPopViewProxy = class("ForceBlessingPopViewProxy", baseProxy)
function ForceBlessingPopViewProxy:onRegisterEvent()
	print("=======ForceBlessingPopViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_ARENA_REFRESH_BUFF", handler(self, self.onMsgRefreshBuff))
end
function ForceBlessingPopViewProxy:onMsgRefreshBuff(...)
	self.view:onMsgRefreshBuff(...)
end
return ForceBlessingPopViewProxy
