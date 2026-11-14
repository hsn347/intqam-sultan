local baseProxy = require("fgui.base.baseProxy")
local Activity_9001606_invitesProxy = class("Activity_9001606_invitesProxy", baseProxy)
function Activity_9001606_invitesProxy:onRegisterEvent()
	print("=======Activity_9001606_invitesProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001606_CANINVITE_UPDATE", handler(self, self.onCanInvite))
end
function Activity_9001606_invitesProxy:onCanInvite(target, data)
	dump(data, "Activity_9001606_kingdomsProxy:onCanInvite", 10)
	self.view:initData()
end
return Activity_9001606_invitesProxy
