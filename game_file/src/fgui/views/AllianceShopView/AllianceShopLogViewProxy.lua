local baseProxy = require("fgui.base.baseProxy")
local AllianceShopLogViewProxy = class("AllianceShopLogViewProxy", baseProxy)
function AllianceShopLogViewProxy:onRegisterEvent()
	print("=======AllianceShopLogViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_SHOP_LOG_BACK", handler(self, self.msgCallBack))
end
function AllianceShopLogViewProxy:msgCallBack(target, data)
	if not data.log then
		_UPVALUE0_ = data.log
	end
	self.view:updateScrollWithData(data.log)
end
return AllianceShopLogViewProxy
