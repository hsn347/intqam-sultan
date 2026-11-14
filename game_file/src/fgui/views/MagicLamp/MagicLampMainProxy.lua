local baseProxy = require("fgui.base.baseProxy")
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
local MagicLampMainProxy = class("MagicLampMainProxy", baseProxy)
function MagicLampMainProxy:onRegisterEvent()
	print("=======MagicLampMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_UPDATE", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_SPEED_UP_BACK", handler(self, self.onTimerUpdate))
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_HATCH_UPDATE", handler(self, self.upadteHatchBtn))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.onMsgUpdateActivity))
	SoraDAddMessage(self, "MESSAGE_MAGIC_LAMP_FIRE_UNLOCK", handler(self, self.onReqUnlockFireJinn))
	SoraDAddMessage(self, "MESSAGE_MAGIC_LAMP_FIRE_UNLOCK_SUCCESS", handler(self, self.onUnlockFireJinnSuccess))
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_UNLOCK_EXTRASLOT", handler(self, self.onUnlockNewSlot))
end
function MagicLampMainProxy:msgUpdateView()
	self.view:updateView()
end
function MagicLampMainProxy:onTimerUpdate()
	self.view:updateTimers()
end
function MagicLampMainProxy:upadteHatchBtn()
	self.view:upadteHatchBtn()
end
function MagicLampMainProxy:onMsgUpdateActivity()
	self.view:updateListBuffData()
end
function MagicLampMainProxy:onReqUnlockFireJinn()
	magicLampCtrl:reqUnlockFireJinn()
end
function MagicLampMainProxy:onUnlockFireJinnSuccess()
	uiManager:close("MagicLampHatch")
	self.view:unlockJinn(gJinnType.JINN_TWO)
end
function MagicLampMainProxy:onUnlockNewSlot(target, data)
	self.view:unlockNewSlot(data.newSlots)
end
return MagicLampMainProxy
