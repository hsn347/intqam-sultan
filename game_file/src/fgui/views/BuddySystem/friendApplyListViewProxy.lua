local baseProxy = require("fgui.base.baseProxy")
local friendApplyListViewProxy = class("friendApplyListViewProxy", baseProxy)
function friendApplyListViewProxy:onRegisterEvent()
	print("=======friendApplyListViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_INVITELIST_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_INVITELIST_UPDATE", handler(self, self.initData))
end
function friendApplyListViewProxy:initData(target, data)
	self.view:initData(target, data)
end
return friendApplyListViewProxy
