local baseProxy = require("fgui.base.baseProxy")
local activity_9001606_Ctrl = SoraDGetCtrl("activity_9001606_Ctrl")
local Activity_9001606_noInivtesProxy = class("Activity_9001606_noInivtesProxy", baseProxy)
function Activity_9001606_noInivtesProxy:onRegisterEvent()
	print("=======Activity_9001606_noInivtesProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", function(target, data)
		if activity_9001606_Ctrl:getActivityState() ~= gActivityTimeActivityID.NORMAL_ACTIVITY_9001605 then
			SoraDRemoveAllAfterPanelFromManager(self.view)
		end
	end)
end
return Activity_9001606_noInivtesProxy
