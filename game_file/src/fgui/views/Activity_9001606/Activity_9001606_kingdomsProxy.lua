local baseProxy = require("fgui.base.baseProxy")
local activity_9001606_Ctrl = SoraDGetCtrl("activity_9001606_Ctrl")
local Activity_9001606_kingdomsProxy = class("Activity_9001606_kingdomsProxy", baseProxy)
function Activity_9001606_kingdomsProxy:onRegisterEvent()
	print("=======Activity_9001606_kingdomsProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001606_CANINVITE_UPDATE", handler(self, self.onCanInvite))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", function(target, data)
		if activity_9001606_Ctrl:getActivityState() ~= gActivityTimeActivityID.NORMAL_ACTIVITY_9001605 then
			SoraDRemoveAllAfterPanelFromManager(self.view)
		end
	end)
end
function Activity_9001606_kingdomsProxy:onCanInvite(target, data)
	dump(data, "Activity_9001606_kingdomsProxy:onCanInvite", 10)
	if data.data then
		self.view:initData(data.data)
	elseif data.inviteList and data.invitedList then
		self.view:updateInviteList(data.inviteList, data.invitedList)
	end
end
return Activity_9001606_kingdomsProxy
