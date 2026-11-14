local baseProxy = require("fgui.base.baseProxy")
local Activity_9001688_AwardProxy = class("Activity_9001688_AwardProxy", baseProxy)
function Activity_9001688_AwardProxy:onRegisterEvent()
	print("=======Activity_9001688_AwardProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_COMMON_SIGN_UPDATE", handler(self, self.signBack))
end
function Activity_9001688_AwardProxy:signBack(target, data)
	if data and data.activityID == self.view.activityID then
		self.view:initView(target, data)
	end
end
return Activity_9001688_AwardProxy
