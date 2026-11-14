local baseProxy = require("fgui.base.baseProxy")
local BeastCanyonMainProxy = class("BeastCanyonMainProxy", baseProxy)
function BeastCanyonMainProxy:onRegisterEvent()
	print("=======BeastCanyonMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001547_UPDATE", handler(self, self.msgCallBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function BeastCanyonMainProxy:msgCallBack(target, data)
	if not self.view or tolua.isnull(self.view) then
		return
	end
	if data.subMsg == "init" then
		SoraDCloseLoading(self.view)
		self.view:updateBossEnter()
		self.view:updateChallenge()
		self.view:updateTaskRed()
	elseif data.subMsg == "buyTimes" then
		SoraDCloseLoading()
		self.view:updateBossEnter()
		self.view:updateChallenge()
	elseif data.subMsg == "challenge" or data.subMsg == "sweep" then
		self.view:updateBossEnter()
		self.view:updateTaskRed()
		self.view:updateChallenge()
	elseif data.subMsg == "reward" then
		self.view:updateTaskRed()
	end
end
function BeastCanyonMainProxy:judgeClose()
	if not self.view or tolua.isnull(self.view) then
		return
	end
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return BeastCanyonMainProxy
