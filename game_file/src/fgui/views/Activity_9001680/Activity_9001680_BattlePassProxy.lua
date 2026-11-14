local baseProxy = require("fgui.base.baseProxy")
local Activity_9001680_BattlePassProxy = class("Activity_9001680_BattlePassProxy", baseProxy)
function Activity_9001680_BattlePassProxy:onRegisterEvent()
	print("=======Activity_9001680_BattlePassProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001680_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.updateView))
end
function Activity_9001680_BattlePassProxy:updateView(target, data)
	self.view:updateView(data.msgType)
end
return Activity_9001680_BattlePassProxy
