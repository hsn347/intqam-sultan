local baseProxy = require("fgui.base.baseProxy")
local birthdayInputPopViewProxy = class("birthdayInputPopViewProxy", baseProxy)
function birthdayInputPopViewProxy:onRegisterEvent()
	print("=======birthdayInputPopViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_EXCLUSIVE_VIP_BIRTHDAY_SET_BACK", function(target, data)
		SoraDCloseLoading()
		self.view:initData()
		SoraDShowMsgTip(i18n("petra_text_11"))
		self.view:close()
	end)
end
return birthdayInputPopViewProxy
