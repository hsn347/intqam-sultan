local baseProxy = require("fgui.base.baseProxy")
local Activity_9001703_GameProxy = class("Activity_9001703_GameProxy", baseProxy)
function Activity_9001703_GameProxy:onRegisterEvent()
	print("=======Activity_9001703_GameProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001703_UPDATE", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001703_ENDGAME", handler(self, self.endGame))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001703_RANDOMSKILL", handler(self, self.randomSkill))
	SoraDAddMessage(self, "MESSAGE_SERVER_GUIDE_LAST_FINISH", handler(self, self.endGuide))
end
function Activity_9001703_GameProxy:initView(target, data)
	self.view:initView(target, data)
end
function Activity_9001703_GameProxy:endGame(target, data)
	self.view:endGame(target, data)
end
function Activity_9001703_GameProxy:randomSkill(target, data)
	self.view:randomSkill(target, data)
end
function Activity_9001703_GameProxy:endGuide(target, data)
	self.view:endGuide(target, data)
end
return Activity_9001703_GameProxy
