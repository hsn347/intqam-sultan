local Activity_9001623_MainPanel = include_fgui("Activity_9001623_MainPanel")
local Activity_9001659_MainPanel = class("Activity_9001659_MainPanel", Activity_9001623_MainPanel)
function Activity_9001659_MainPanel:ctor(...)
	Activity_9001659_MainPanel.super.ctor(self, ...)
	print("Activity_9001659_MainPanel:ctor", self.viewName)
	self.debug = true
	self.activityID = gActivityTimeActivityID.SIGN_REWARD_9001659_ACTIVITY
end
function Activity_9001659_MainPanel:getPackageList()
	_UPVALUE1_ = nil
	;(nil)[1] = "Activity_9001623"
	return nil
end
function Activity_9001659_MainPanel:onInit()
	print("=======Activity_9001659_MainPanel:onInit")
	Activity_9001659_MainPanel.super.onInit(self)
end
return Activity_9001659_MainPanel
