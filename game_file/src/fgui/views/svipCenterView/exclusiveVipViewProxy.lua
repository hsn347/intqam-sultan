local baseProxy = require("fgui.base.baseProxy")
local exclusiveVipViewProxy = class("exclusiveVipViewProxy", baseProxy)
function exclusiveVipViewProxy:onRegisterEvent()
	print("=======exclusiveVipViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_EXCLUSIVE_VIP_REFRESH_DATA", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_EXCLUSIVE_VIP_BUY_PACKAGE", handler(self, self.purchaseBack))
	SoraDAddMessage(self, "MESSAGE_EXCLUSIVE_VIP_BIRTHDAY_SET_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_EXCLUSIVE_VIP_WELFARE_REFRESH", handler(self, self.initData2))
	SoraDAddMessage(self, "MESSAGE_EXCLUSIVE_VIP_NEW_WINDOWS", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_EXCLUSIVE_VIP_CLEAN_NEW_FLAG", function(target, data)
		SoraDCloseLoading(self.view)
		self.view:checkButtonState()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIP_SHOWPWD", handler(self, self.initData))
end
function exclusiveVipViewProxy:initData(...)
	self.view:initData(...)
end
function exclusiveVipViewProxy:initData2(...)
	SoraDCloseLoading(self.view)
	self.view.fields.nodeBirthday.curMailIndex = 1
	self.view:checkButtonState()
	self.view:initData(...)
end
function exclusiveVipViewProxy:purchaseBack(...)
	self.view:purchaseBack(...)
end
return exclusiveVipViewProxy
