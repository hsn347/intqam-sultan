local baseProxy = require("fgui.base.baseProxy")
local exaltedPrivilegeCtrl = SoraDGetCtrl("exaltedPrivilegeCtrl")
local telephoneInputPopViewProxy = class("telephoneInputPopViewProxy", baseProxy)
function telephoneInputPopViewProxy:onRegisterEvent()
	print("=======telephoneInputPopViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_EXCLUSIVE_VIP_PHONE_SET_BACK", function(target, data)
		SoraDCloseLoading(self.view)
		local inputTel = exaltedPrivilegeCtrl:getTelephoneNum()
		self.view:initData(inputTel ~= 0 and 1 or 0)
	end)
	SoraDAddMessage(self, "MESSAGE_EXCLUSIVE_VIP_PHONE_CHECK_BACK", function(target, data)
		if self.view.realTelNum then
			SoraDShowLoading(self.view)
			exaltedPrivilegeCtrl:reqSetPhoneNum(tostring(self.view.realTelNum), self.view.areatype)
		end
	end)
end
return telephoneInputPopViewProxy
