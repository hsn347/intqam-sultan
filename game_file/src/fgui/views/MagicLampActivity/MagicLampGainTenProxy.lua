local baseProxy = require("fgui.base.baseProxy")
local MagicLampGainTenProxy = class("MagicLampGainTenProxy", baseProxy)
function MagicLampGainTenProxy:onRegisterEvent()
	print("=======MagicLampGainTenProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.msgRefreshItemNum))
end
function MagicLampGainTenProxy:msgRefreshItemNum(target, data)
	self.view:updateButton()
end
return MagicLampGainTenProxy
