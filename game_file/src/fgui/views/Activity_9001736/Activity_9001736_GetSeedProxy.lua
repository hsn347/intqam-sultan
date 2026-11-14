local baseProxy = require("fgui.base.baseProxy")
local Activity_9001736_GetSeedProxy = class("Activity_9001736_GetSeedProxy", baseProxy)
function Activity_9001736_GetSeedProxy:onRegisterEvent()
	print("=======Activity_9001736_GetSeedProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001736_ITEM_COUNT", handler(self, self.onMsgUpdateItemCount))
end
function Activity_9001736_GetSeedProxy:onMsgUpdateItemCount(...)
	self.view:onMsgUpdateItemCount(...)
end
return Activity_9001736_GetSeedProxy
