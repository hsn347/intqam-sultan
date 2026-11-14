local baseProxy = require("fgui.base.baseProxy")
local ItemSendRecordProxy = class("ItemSendRecordProxy", baseProxy)
function ItemSendRecordProxy:onRegisterEvent()
	print("=======ItemSendRecordProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_REQ_GIVE_HISTORY_NEW_SUCCESS", handler(self, self.updateView))
end
function ItemSendRecordProxy:updateView(target, data)
	self.view:updateView(target, data)
end
return ItemSendRecordProxy
