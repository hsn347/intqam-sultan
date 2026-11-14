local baseProxy = require("fgui.base.baseProxy")
local commonSpeedUpByItemBoxProxy = class("commonSpeedUpByItemBoxProxy", baseProxy)
function commonSpeedUpByItemBoxProxy:onRegisterEvent()
	print("=======commonSpeedUpByItemBoxProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_SPEED_UP_BACK", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_LORDVALUE_VIP", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ITEM_SPEED_UP_TYPE_CHOOSE", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REFRESH", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRAIN_SPEEDSUCCESS", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_QUEUE_MERGE_NOTIFY", handler(self, self.onMsgUpdateQueue))
end
function commonSpeedUpByItemBoxProxy:updateData(target, data)
	self.view:updateData(target, data)
end
function commonSpeedUpByItemBoxProxy:onMsgUpdateQueue(...)
	self.view:onMsgUpdateQueue(...)
end
return commonSpeedUpByItemBoxProxy
