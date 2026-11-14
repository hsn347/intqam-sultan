local baseProxy = require("fgui.base.baseProxy")
local rechargeGiftRewardPopViewProxy = class("rechargeGiftRewardPopViewProxy", baseProxy)
function rechargeGiftRewardPopViewProxy:onRegisterEvent()
	print("=======rechargeGiftRewardPopViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.msgCallBack))
end
function rechargeGiftRewardPopViewProxy:msgCallBack(target, data)
	self.view:msgCallBack(target, data)
end
return rechargeGiftRewardPopViewProxy
