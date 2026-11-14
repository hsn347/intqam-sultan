local baseProxy = require("fgui.base.baseProxy")
local LordSelectViewProxy = class("LordSelectViewProxy", baseProxy)
function LordSelectViewProxy:onRegisterEvent()
	print("=======LordSelectViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_GET_MEMBER_LIST_SUCCESS", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ITEM_LORD_SEARCH_BACK", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_OPTION_SEARCH_LORD", handler(self, self.updateData))
end
function LordSelectViewProxy:updateData(...)
	self.view:updateData(...)
end
return LordSelectViewProxy
