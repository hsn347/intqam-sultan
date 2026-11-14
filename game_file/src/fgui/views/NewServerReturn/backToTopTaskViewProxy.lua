local baseProxy = require("fgui.base.baseProxy")
local backToTopTaskViewProxy = class("backToTopTaskViewProxy", baseProxy)
function backToTopTaskViewProxy:onRegisterEvent()
	print("=======backToTopTaskViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_BACK_TO_TOP_TASK_REFRESH", handler(self, self.initData))
end
function backToTopTaskViewProxy:initData(target, data)
	self.view:initData()
end
return backToTopTaskViewProxy
