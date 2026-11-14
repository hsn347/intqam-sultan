local baseProxy = require("fgui.base.baseProxy")
local Activity_9001658_MainProxy = class("Activity_9001658_MainProxy", baseProxy)
function Activity_9001658_MainProxy:onRegisterEvent()
	print("=======Activity_9001658_MainProxy:onRegisterEvent")
	self.activityID = self.view.activityID
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.onMsgActivityUpdate))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onMsgUpdateItemCount))
end
function Activity_9001658_MainProxy:onMsgActivityUpdate(target, event)
	local activityIDList = event.activityID
	if not activityIDList or type(activityIDList) ~= "table" then
		return
	end
	if table.indexof(activityIDList, self.activityID) and not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
		return
	end
	local activity_9001658_Read = include("activity_9001658_Read")
	local isDirty = false
	for __, activityID in ipairs(activityIDList) do
		if activity_9001658_Read.IsBubbleLegendActivity(activityID) then
			isDirty = true
			break
		end
	end
	if isDirty then
		self.view:updateStage()
	end
	local isDirty = false
	local activityIDConfig = self.view.activityIDConfig
	for __, activityID in ipairs(activityIDList) do
		if table.indexof(activityIDConfig, activityID) then
			isDirty = true
			break
		end
	end
	if isDirty then
		self.view:updateActivityIDList()
	end
end
function Activity_9001658_MainProxy:onMsgUpdateItemCount(...)
	self.view:updateItemCount(...)
end
return Activity_9001658_MainProxy
