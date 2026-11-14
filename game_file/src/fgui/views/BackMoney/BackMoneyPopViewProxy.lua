local baseProxy = require("fgui.base.baseProxy")
local BackMoneyPopViewProxy = class("BackMoneyPopViewProxy", baseProxy)
function BackMoneyPopViewProxy:onRegisterEvent()
	print("=======BackMoneyPopViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_PAYBACK_NOTICE", handler(self, self.judgeClose))
end
function BackMoneyPopViewProxy:judgeClose(target, data)
	if data.price <= 0 then
		self.view:close()
	else
		self.view:updateView()
	end
end
return BackMoneyPopViewProxy
