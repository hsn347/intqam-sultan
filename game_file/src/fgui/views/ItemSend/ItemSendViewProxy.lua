local baseProxy = require("fgui.base.baseProxy")
local ItemSendViewProxy = class("ItemSendViewProxy", baseProxy)
function ItemSendViewProxy:onRegisterEvent()
	print("=======ItemSendViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_LORD_SEARCH_BACK", handler(self, self.updateSearchList))
end
function ItemSendViewProxy:updateSearchList(target, data)
	self.view:updateSearchList(target, data)
end
return ItemSendViewProxy
