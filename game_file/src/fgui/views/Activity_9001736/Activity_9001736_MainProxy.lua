local baseProxy = require("fgui.base.baseProxy")
local Activity_9001736_MainProxy = class("Activity_9001736_MainProxy", baseProxy)
function Activity_9001736_MainProxy:onRegisterEvent()
	print("=======Activity_9001736_MainProxy:onRegisterEvent")
	self:registerActivityCloseEvent(self.view.activityID, handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001736_BATTLE_PASS", handler(self, self.onMsgUpdateBattlePass))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001736_BUY_GIFT", handler(self, self.onMsgUpdateBattlePass))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001736_ITEM_COUNT", handler(self, self.onMsgUpdateItemCount))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001736_QUEST_UPDATE", handler(self, self.onMsgUpdateQuest))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001736_BATTLE_BACK", handler(self, self.onMsgUpdateBattleBack))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001736_UPDATE_DATA", handler(self, self.onMsgUpdateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", handler(self, self.onMsgExchangeMallRefresh))
end
function Activity_9001736_MainProxy:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
		return
	end
	self.view:updateDoStage()
end
function Activity_9001736_MainProxy:onMsgUpdateBattlePass(...)
	self.view:onMsgUpdateBattlePass(...)
end
function Activity_9001736_MainProxy:onMsgUpdateItemCount(...)
	self.view:onMsgUpdateItemCount(...)
end
function Activity_9001736_MainProxy:onMsgUpdateQuest(...)
	self.view:onMsgUpdateQuest(...)
end
function Activity_9001736_MainProxy:onMsgUpdateBattleBack(...)
	self.view:onMsgUpdateBattleBack(...)
end
function Activity_9001736_MainProxy:onMsgUpdateData(...)
	self.view:onMsgUpdateData(...)
end
function Activity_9001736_MainProxy:onMsgExchangeMallRefresh(...)
	self.view:onMsgExchangeMallRefresh(...)
end
return Activity_9001736_MainProxy
