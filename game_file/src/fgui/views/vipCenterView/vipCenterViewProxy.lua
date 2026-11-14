local baseProxy = require("fgui.base.baseProxy")
local vipCenterViewProxy = class("vipCenterViewProxy", baseProxy)
function vipCenterViewProxy:onRegisterEvent()
	print("=======vipCenterViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_LORDVALUE_VIP", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_LORDVALUE_VIP_GIFTREFRESH", handler(self, self.initVipGift))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_VIP_PRIVILEGE_GIFT", handler(self, self.updateVipPrivilegeGift))
end
function vipCenterViewProxy:initData(target, data)
	self.view:initData(target, data)
end
function vipCenterViewProxy:initVipGift(target, data)
	self.view:initVipGift(target, data)
end
function vipCenterViewProxy:updateVipPrivilegeGift(target, data)
	self.view:updateVipPrivilegeGift(target, data)
end
return vipCenterViewProxy
