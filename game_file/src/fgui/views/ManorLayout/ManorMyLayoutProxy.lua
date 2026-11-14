local baseProxy = require("fgui.base.baseProxy")
local ManorMyLayoutProxy = class("ManorMyLayoutProxy", baseProxy)
function ManorMyLayoutProxy:onRegisterEvent()
	print("=======ManorMyLayoutProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MANOR_LAYOUT_SAVE", handler(self, self.onMsgLayoutSave))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_MAP_INIT", handler(self, self.onMsgMapInit))
	SoraDAddMessage(self, "MESSAGE_MANOR_LAYOUT_DELETE", handler(self, self.onMsgLayoutDelete))
end
function ManorMyLayoutProxy:onMsgLayoutSave(...)
	self.view:onMsgLayoutSave(...)
end
function ManorMyLayoutProxy:onMsgMapInit(...)
	self.view:onMsgMapInit(...)
end
function ManorMyLayoutProxy:onMsgLayoutDelete(...)
	self.view:onMsgLayoutDelete(...)
end
return ManorMyLayoutProxy
