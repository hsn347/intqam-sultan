local baseProxy = require("fgui.base.baseProxy")
local ringShopViewProxy = class("ringShopViewProxy", baseProxy)
function ringShopViewProxy:onRegisterEvent()
	print("=======ringShopViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_RING_NECKLACE", handler(self, self.msgCallBack))
end
function ringShopViewProxy:msgCallBack(target, data)
	self.view:msgCallBack(target, data)
end
return ringShopViewProxy
