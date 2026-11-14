local baseProxy = require("fgui.base.baseProxy")
local collegeWaitCancelViewProxy = class("collegeWaitCancelViewProxy", baseProxy)
function collegeWaitCancelViewProxy:onRegisterEvent()
	print("=======collegeWaitCancelViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_TECHNOLOGY_WAITQUEUE", handler(self, self.refreshWaitQueue))
end
function collegeWaitCancelViewProxy:refreshWaitQueue()
	self.view:refreshWaitQueue()
end
return collegeWaitCancelViewProxy
