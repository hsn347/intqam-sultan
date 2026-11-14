local baseProxy = require("fgui.base.baseProxy")
local DessertsKingGiftRewardProxy = class("DessertsKingGiftRewardProxy", baseProxy)
function DessertsKingGiftRewardProxy:onRegisterEvent()
	print("=======DessertsKingGiftRewardProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001538_UPDATE", handler(self, self.msgCallBack))
end
function DessertsKingGiftRewardProxy:msgCallBack(target, data)
	SoraDCloseLoading(self.view)
	self.view:updateButton()
end
return DessertsKingGiftRewardProxy
