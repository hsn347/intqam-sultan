local baseProxy = require("fgui.base.baseProxy")
local Activity_9001721_ShopProxy = class("Activity_9001721_ShopProxy", baseProxy)
function Activity_9001721_ShopProxy:onRegisterEvent()
	print("=======Activity_9001721_ShopProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001721_UPDATE", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_CLOSELOADING", handler(self, self.initView))
end
function Activity_9001721_ShopProxy:initView(target, data)
	self.view:initView(target, data)
end
return Activity_9001721_ShopProxy
