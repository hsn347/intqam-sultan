local baseProxy = require("fgui.base.baseProxy")
local DesertMiningViewProxy = class("DesertMiningViewProxy", baseProxy)
function DesertMiningViewProxy:onRegisterEvent()
	print("=======DesertMiningViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001545_UPDATE", handler(self, self.onMsgCallBack))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onMsgUpdateItem))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function DesertMiningViewProxy:onMsgCallBack(target, data)
	SoraDCloseLoading(self.view)
	self.view:updatePoint()
	self.view:updateButton()
	self.view:updateItemNum()
end
function DesertMiningViewProxy:onMsgUpdateItem()
	self.view:updateButton()
	self.view:updateItemNum()
end
function DesertMiningViewProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return DesertMiningViewProxy
