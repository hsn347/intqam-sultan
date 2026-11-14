local baseProxy = require("fgui.base.baseProxy")
local vipPrivilegeGiftPopViewProxy = class("vipPrivilegeGiftPopViewProxy", baseProxy)
function vipPrivilegeGiftPopViewProxy:onRegisterEvent()
	print("=======vipPrivilegeGiftPopViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_VIP_PRIVILEGE_GIFT", handler(self, self.purchaseBack))
end
function vipPrivilegeGiftPopViewProxy:purchaseBack()
	self.view:purchaseBack()
end
return vipPrivilegeGiftPopViewProxy
