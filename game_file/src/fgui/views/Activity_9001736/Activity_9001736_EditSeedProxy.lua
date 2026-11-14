local baseProxy = require("fgui.base.baseProxy")
local Activity_9001736_EditSeedProxy = class("Activity_9001736_EditSeedProxy", baseProxy)
function Activity_9001736_EditSeedProxy:onRegisterEvent()
	print("=======Activity_9001736_EditSeedProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001736_SELECT_SEED", handler(self, self.onMsgSelectSeed))
end
function Activity_9001736_EditSeedProxy:onMsgSelectSeed(...)
	self.view:onMsgSelectSeed(...)
end
return Activity_9001736_EditSeedProxy
