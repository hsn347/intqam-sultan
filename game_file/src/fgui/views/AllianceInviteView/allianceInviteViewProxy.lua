local baseProxy = require("fgui.base.baseProxy")
local allianceInviteViewProxy = class("allianceInviteViewProxy", baseProxy)
function allianceInviteViewProxy:onRegisterEvent()
	print("=======allianceInviteViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_GET_INVITE_LIST_SUCCESS", handler(self, self.initData))
end
function allianceInviteViewProxy:initData(target, data)
	self.view:initData(target, data)
end
return allianceInviteViewProxy
