local baseProxy = require("fgui.base.baseProxy")
local Activity_9001629_LikeProxy = class("Activity_9001629_LikeProxy", baseProxy)
function Activity_9001629_LikeProxy:onRegisterEvent()
	print("=======Activity_9001629_LikeProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001629_LIKE", handler(self, self.onUpdateLike))
end
function Activity_9001629_LikeProxy:onUpdateLike(target, data)
	self.view:updateLike(data.like)
end
return Activity_9001629_LikeProxy
