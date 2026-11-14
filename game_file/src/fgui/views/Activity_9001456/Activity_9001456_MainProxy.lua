local baseProxy = require("fgui.base.baseProxy")
local Activity_9001456_MainProxy = class("Activity_9001456_MainProxy", baseProxy)
function Activity_9001456_MainProxy:onRegisterEvent()
	print("=======Activity_9001456_MainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_MONSTERSEARCH_DATAARRIVE", handler(self, self.onMsgMonsterSearchBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001456_INIT_UPDATE", handler(self, self.onMsgUpdateInit))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001456_REWARD_UPDATE", handler(self, self.onMsgUpdateReward))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001456_SCORE_UPDATE", handler(self, self.onMsgUpdateScore))
end
function Activity_9001456_MainProxy:onMsgMonsterSearchBack(target, event)
	SoraDCloseLoading(self.view:displayObject())
	local retdate = event and event.retdate
	if retdate and retdate.x ~= -1 and retdate.y ~= -1 then
		SoraDRemoveAllPanelFromManager()
		SoraDGotoWorldMapPoint(cc.p(retdate.x, retdate.y), true)
	else
		SoraDShowMsgTip(i18n("common_text_2177"))
	end
end
function Activity_9001456_MainProxy:judgeClose(target, event)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.FIRE_DRAGON_APPEAR_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function Activity_9001456_MainProxy:onMsgUpdateInit(target, event)
	self.view:refreshInfoText()
end
function Activity_9001456_MainProxy:onMsgUpdateReward(...)
	self.view:updateReward()
end
function Activity_9001456_MainProxy:onMsgUpdateScore(...)
	self.view:updateReward()
end
return Activity_9001456_MainProxy
