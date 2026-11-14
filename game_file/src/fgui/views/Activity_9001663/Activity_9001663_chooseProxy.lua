local baseProxy = require("fgui.base.baseProxy")
local Activity_9001663_chooseProxy = class("Activity_9001663_chooseProxy", baseProxy)
function Activity_9001663_chooseProxy:onRegisterEvent()
	print("=======Activity_9001663_chooseProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UI_ITEM_CHOOSE", handler(self, self.chooseBack))
end
function Activity_9001663_chooseProxy:chooseBack(target, data)
	self.view:chooseBack(target, data)
end
return Activity_9001663_chooseProxy
