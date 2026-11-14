local baseProxy = require("fgui.base.baseProxy")
local Activity_9001643_ChapterProxy = class("Activity_9001643_ChapterProxy", baseProxy)
function Activity_9001643_ChapterProxy:onRegisterEvent()
	print("=======Activity_9001643_ChapterProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001643_UPDATE", handler(self, self.updateView))
end
function Activity_9001643_ChapterProxy:updateView(target, data)
	self.view:updateView(target, data)
end
return Activity_9001643_ChapterProxy
