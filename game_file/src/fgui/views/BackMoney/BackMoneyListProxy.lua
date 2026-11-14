local baseProxy = require("fgui.base.baseProxy")
local BackMoneyListProxy = class("BackMoneyListProxy", baseProxy)
function BackMoneyListProxy:onRegisterEvent()
	print("=======BackMoneyListProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_PAYBACK_NOTICE", handler(self, self.judgeClose))
end
function BackMoneyListProxy:judgeClose(target, data)
	if data.price <= 0 then
		self.view:close()
	end
end
return BackMoneyListProxy
