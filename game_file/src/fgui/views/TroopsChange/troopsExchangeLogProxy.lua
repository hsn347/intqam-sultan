local baseProxy = require("fgui.base.baseProxy")
local troopsExchangeLogProxy = class("troopsExchangeLogProxy", baseProxy)
function troopsExchangeLogProxy:onRegisterEvent()
	SoraDAddMessage(self, "MESSAGE_TROOPS_EXCHANGE_HISTORY", handler(self, self.updateScroll))
end
function troopsExchangeLogProxy:updateScroll(target, data)
	SoraDCloseLoading()
	self.view:updateScroll()
end
return troopsExchangeLogProxy
