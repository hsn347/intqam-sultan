local baseProxy = require("fgui.base.baseProxy")
local Activity_9001573_RankProxy = class("Activity_9001573_RankProxy", baseProxy)
function Activity_9001573_RankProxy:onRegisterEvent()
	print("=======Activity_9001573_RankProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001573_RANK", handler(self, self.updateData))
end
function Activity_9001573_RankProxy:updateData(target, data)
	self.view:onMsgUpdateRank(target, data)
end
return Activity_9001573_RankProxy
