local baseProxy = require("fgui.base.baseProxy")
local WarframeExchangeProxy = class("WarframeExchangeProxy", baseProxy)
function WarframeExchangeProxy:onRegisterEvent()
	print("=======WarframeExchangeProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_WEAR_WARFRAME_EXCHANGE_BACK", handler(self, self.msgCallBack))
end
function WarframeExchangeProxy:msgCallBack(target, data)
	self.view:updateList()
end
return WarframeExchangeProxy
