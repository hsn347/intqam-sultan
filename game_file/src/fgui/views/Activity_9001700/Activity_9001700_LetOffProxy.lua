local baseProxy = require("fgui.base.baseProxy")
local Activity_9001700_LetOffProxy = class("Activity_9001700_LetOffProxy", baseProxy)
function Activity_9001700_LetOffProxy:onRegisterEvent()
	print("=======Activity_9001700_LetOffProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID)
end
return Activity_9001700_LetOffProxy
