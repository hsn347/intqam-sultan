local baseProxy = require("fgui.base.baseProxy")
local Activity_9001623_MainProxy = include_fgui("Activity_9001623_MainProxy")
local Activity_9001687_MainProxy = class("Activity_9001687_MainProxy", Activity_9001623_MainProxy)
function Activity_9001687_MainProxy:onRegisterEvent()
	print("=======Activity_9001687_MainProxy:onRegisterEvent")
	Activity_9001687_MainProxy.super.onRegisterEvent(self)
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onUpdateItem))
end
function Activity_9001687_MainProxy:onUpdateItem()
	self.view:updateItem()
end
return Activity_9001687_MainProxy
