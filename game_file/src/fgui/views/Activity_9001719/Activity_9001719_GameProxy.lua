local baseProxy = require("fgui.base.baseProxy")
local Activity_9001719_GameProxy = class("Activity_9001719_GameProxy", baseProxy)
function Activity_9001719_GameProxy:onRegisterEvent()
	print("=======Activity_9001719_GameProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001719_ENDGAME", handler(self, self.endGame))
	SoraDAddMessage(self, "MESSAGE_SERVER_GUIDE_LAST_FINISH", handler(self, self.endGuide))
end
function Activity_9001719_GameProxy:endGame(target, data)
	self.view:endGame(target, data)
end
function Activity_9001719_GameProxy:endGuide(target, data)
	self.view:endGuide(target, data)
end
return Activity_9001719_GameProxy
