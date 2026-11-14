local baseProxy = require("fgui.base.baseProxy")
local gameBlockedUsersProxy = class("gameBlockedUsersProxy", baseProxy)
function gameBlockedUsersProxy:onRegisterEvent()
	print("=======gameBlockedUsersProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_CHAT_UNSHIELD_USER", handler(self, self.refreshData))
end
function gameBlockedUsersProxy:refreshData()
	SoraDCloseLoading(self.view)
	self.view:initData()
end
return gameBlockedUsersProxy
