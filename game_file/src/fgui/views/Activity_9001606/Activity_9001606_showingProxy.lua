local baseProxy = require("fgui.base.baseProxy")
local activity_9001606_Ctrl = SoraDGetCtrl("activity_9001606_Ctrl")
local Activity_9001606_showingProxy = class("Activity_9001606_showingProxy", baseProxy)
function Activity_9001606_showingProxy:onRegisterEvent()
	print("=======Activity_9001606_showingProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001606_BINDINFO", handler(self, self.onUpdateData))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001606_CANINVITE_UPDATE", handler(self, self.onInvitedChange))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", function(target, data)
		if activity_9001606_Ctrl:getActivityState() ~= gActivityTimeActivityID.NORMAL_ACTIVITY_9001606 then
			SoraDRemoveAllAfterPanelFromManager(self.view)
		end
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_TEAM_MSG", handler(self, self.updateNewTeamMsg))
end
function Activity_9001606_showingProxy:updateNewTeamMsg(target, data)
	self.view:updateNewTeamMsg()
end
function Activity_9001606_showingProxy:onUpdateData(target, data)
	dump(data, "Activity_9001606_showingProxy:onUpdateData", 10)
	if data.rspdata then
		self.view:updateData(data.rspdata)
	end
end
function Activity_9001606_showingProxy:onInvitedChange(target, data)
	activity_9001606_Ctrl:reqBindInfo()
end
return Activity_9001606_showingProxy
