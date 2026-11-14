local baseProxy = require("fgui.base.baseProxy")
local Activity_9001680_ItemGetProxy = class("Activity_9001680_ItemGetProxy", baseProxy)
function Activity_9001680_ItemGetProxy:onRegisterEvent()
	print("=======Activity_9001680_ItemGetProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001680_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateView))
end
function Activity_9001680_ItemGetProxy:updateView(target, data)
	self.view:updateView()
end
return Activity_9001680_ItemGetProxy
