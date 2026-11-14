local baseProxy = require("fgui.base.baseProxy")
local searchInKingdomViewProxy = class("searchInKingdomViewProxy", baseProxy)
function searchInKingdomViewProxy:onRegisterEvent()
	print("=======searchInKingdomViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_LORD_SEARCH_BACK", handler(self, self.initSearchData))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_GET_MEMBER_LIST_SUCCESS", handler(self, self.initSearchData))
end
function searchInKingdomViewProxy:initSearchData(target, data)
	self.view:initSearchData(target, data)
end
return searchInKingdomViewProxy
