local baseProxy = require("fgui.base.baseProxy")
local LuckyWretchMainProxy = class("LuckyWretchMainProxy", baseProxy)
function LuckyWretchMainProxy:onRegisterEvent()
	print("=======LuckyWretchMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001494_UPDATE", handler(self, self.msgRefreshView))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.msgRefreshItemNum))
end
function LuckyWretchMainProxy:msgRefreshView(target, data)
	self.view:updateView()
	if data.subMsg == "one" then
		self.view:playFlipAnimation(data.grade, data.isGold)
	elseif data.subMsg == "ten" then
		self.view:playFlipAnimation(data.grade, data.isGold)
	end
end
function LuckyWretchMainProxy:msgRefreshItemNum(target, data)
	self.view:updateButton()
end
function LuckyWretchMainProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return LuckyWretchMainProxy
