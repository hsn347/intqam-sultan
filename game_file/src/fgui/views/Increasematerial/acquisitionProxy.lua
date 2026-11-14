local baseProxy = require("fgui.base.baseProxy")
local acquisitionProxy = class("acquisitionProxy", baseProxy)
function acquisitionProxy:onRegisterEvent()
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.judgeClose))
end
function acquisitionProxy:judgeClose(target, data)
	self.view:updateScroll()
end
return acquisitionProxy
