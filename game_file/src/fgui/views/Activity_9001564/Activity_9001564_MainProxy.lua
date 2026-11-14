local baseProxy = require("fgui.base.baseProxy")
local Activity_9001564_MainProxy = class("Activity_9001564_MainProxy", baseProxy)
function Activity_9001564_MainProxy:onRegisterEvent()
	print("=======Activity_9001564_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001564_UPDATE", handler(self, self.onMsgCallBack))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onMsgUpdateItem))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function Activity_9001564_MainProxy:onMsgCallBack(target, data)
	SoraDCloseLoading(self.view)
	self.view:updateButton()
	self.view:updateItemNum()
	if data.ids then
		local _ENV, reward = data.ids, data.ids
		for i, v in ipairs(data.ids) do
			_ENV = nil
			;(nil).reward = data.rewardDetail[i]
			;(nil).prize = v
			table.insert(reward, nil)
		end
		self.view:playLotteryAction(reward)
	end
end
function Activity_9001564_MainProxy:onMsgUpdateItem()
	self.view:updateButton()
	self.view:updateItemNum()
end
function Activity_9001564_MainProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return Activity_9001564_MainProxy
