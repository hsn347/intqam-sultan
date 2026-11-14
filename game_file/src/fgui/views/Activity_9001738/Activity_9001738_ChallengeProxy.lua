local baseProxy = require("fgui.base.baseProxy")
local Activity_9001738_ChallengeProxy = class("Activity_9001738_ChallengeProxy", baseProxy)
function Activity_9001738_ChallengeProxy:onRegisterEvent()
	print("=======Activity_9001738_ChallengeProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001738_ENTER", handler(self, self.onEnterGame))
end
function Activity_9001738_ChallengeProxy:onEnterGame()
	if self.view then
		self.view:close()
	end
	if not uiManager:isShow("Activity_9001738_Game") then
		uiManager:show("Activity_9001738_Game")
	end
end
return Activity_9001738_ChallengeProxy
