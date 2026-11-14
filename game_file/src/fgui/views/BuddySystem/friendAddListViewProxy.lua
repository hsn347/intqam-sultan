local baseProxy = require("fgui.base.baseProxy")
local friendAddListViewProxy = class("friendAddListViewProxy", baseProxy)
function friendAddListViewProxy:onRegisterEvent()
	print("=======friendAddListViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_SENDLIST_UPDATE", handler(self, self.initData))
end
function friendAddListViewProxy:initData(target, data)
	self.view:initData(target, data)
end
return friendAddListViewProxy
