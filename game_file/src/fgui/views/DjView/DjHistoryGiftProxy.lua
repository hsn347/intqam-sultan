local baseProxy = require("fgui.base.baseProxy")
local DjHistoryGiftProxy = class("DjHistoryGiftProxy", baseProxy)
function DjHistoryGiftProxy:onRegisterEvent()
	print("=======DjHistoryGiftProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_CHAT_DJ_HISTORY_GIFT_BACK", handler(self, self.initView))
end
function DjHistoryGiftProxy:initView(target, data)
	self.view:initView(target, data)
end
return DjHistoryGiftProxy
