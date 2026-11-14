local baseProxy = require("fgui.base.baseProxy")
local lordChangeHeadViewProxy = class("lordChangeHeadViewProxy", baseProxy)
function lordChangeHeadViewProxy:onRegisterEvent()
	print("=======lordChangeHeadViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_LORDINFO_AVATAR_UPDATE", handler(self, self.showQueue))
	SoraDAddMessage(self, "MESSAGE_HEAD_ITEM_USE_SUCCESS", handler(self, self.updateCurIndex))
	SoraDAddMessage(self, "MESSAGE_UI_LORD_HEAD_SELECT", handler(self, self.headSelect))
	SoraDAddMessage(self, "MESSAGE_ITEM_UES_FROM_BAG_BACK", handler(self, self.updateCurIndex))
end
function lordChangeHeadViewProxy:showQueue(target, data)
	self.view:showQueue(target, data)
end
function lordChangeHeadViewProxy:updateCurIndex(target, data)
	self.view:updateCurIndex(target, data)
end
function lordChangeHeadViewProxy:headSelect(target, data)
	self.view:headSelect(target, data)
end
return lordChangeHeadViewProxy
