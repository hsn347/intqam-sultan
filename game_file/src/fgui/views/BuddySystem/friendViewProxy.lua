local baseProxy = require("fgui.base.baseProxy")
local friendViewProxy = class("friendViewProxy", baseProxy)
function friendViewProxy:onRegisterEvent()
	print("=======friendViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_DATA_BACK", handler(self, self.updateFriendList))
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_INVITELIST_BACK", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_OPTION_SEARCH_LORD", handler(self, self.updateSearchList))
	SoraDAddMessage(self, "MESSAGE_ITEM_LORD_SEARCH_BACK", handler(self, self.updateSearchList))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_GET_MEMBER_LIST_SUCCESS", handler(self, self.updateSearchList))
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_ADD", handler(self, self.updateSearchList))
end
function friendViewProxy:updateFriendList(target, data)
	self.view:updateFriendList(target, data)
end
function friendViewProxy:updateRedPoint(target, data)
	self.view:updateRedPoint(target, data)
end
function friendViewProxy:updateSearchList(target, data)
	self.view:updateSearchList(target, data)
end
return friendViewProxy
