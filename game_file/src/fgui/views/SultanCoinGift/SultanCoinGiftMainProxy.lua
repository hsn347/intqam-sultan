local baseProxy = require("fgui.base.baseProxy")
local SultanCoinGiftMainProxy = class("SultanCoinGiftMainProxy", baseProxy)
function SultanCoinGiftMainProxy:onRegisterEvent()
	print("=======SultanCoinGiftMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001533_UPDATE", handler(self, self.msgCallBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function SultanCoinGiftMainProxy:msgCallBack(target, data)
	SoraDCloseLoading(self.view)
	self.view:updateTaskList()
end
function SultanCoinGiftMainProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return SultanCoinGiftMainProxy
