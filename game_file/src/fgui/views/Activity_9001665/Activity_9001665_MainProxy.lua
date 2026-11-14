local baseProxy = require("fgui.base.baseProxy")
local Activity_9001665_MainProxy = class("Activity_9001665_MainProxy", baseProxy)
function Activity_9001665_MainProxy:onRegisterEvent()
	print("=======Activity_9001665_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001665_UPDATE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001665_PLAY", handler(self, self.showReward))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateView))
end
function Activity_9001665_MainProxy:updateView()
	self.view:updateView()
end
function Activity_9001665_MainProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function Activity_9001665_MainProxy:showReward(target, data)
	_ENV = nil
	;(nil).fishId = data.fishId
	;(nil).extraData = data.extraData
	;(nil).isNew = data.isNew
	;(nil).newRecord = data.newRecord
	uiManager:show("Activity_9001665_Reward", nil)
end
return Activity_9001665_MainProxy
