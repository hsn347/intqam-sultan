local baseProxy = require("fgui.base.baseProxy")
local Activity_9001736_SeedBagProxy = class("Activity_9001736_SeedBagProxy", baseProxy)
function Activity_9001736_SeedBagProxy:onRegisterEvent()
	print("=======Activity_9001736_SeedBagProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001736_UP_LEVEL", handler(self, self.onMsgUpLevel))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001736_RESET_LEVEL", handler(self, self.onMsgResetLevel))
end
function Activity_9001736_SeedBagProxy:onMsgUpLevel(...)
	self.view:onMsgUpLevel(...)
end
function Activity_9001736_SeedBagProxy:onMsgResetLevel(...)
	self.view:onMsgResetLevel(...)
end
return Activity_9001736_SeedBagProxy
