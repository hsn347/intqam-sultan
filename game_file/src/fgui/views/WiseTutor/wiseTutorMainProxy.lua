local baseProxy = require("fgui.base.baseProxy")
local wiseTutorMainProxy = class("wiseTutorMainProxy", baseProxy)
function wiseTutorMainProxy:onRegisterEvent()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.onUpdateTask))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.onUpdateTask))
	SoraDAddMessage(self, "MESSAGE_WISE_TUTOR_REFRESH", handler(self, self.onUpdateRewardView))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_CASTLE_LEVELUP", handler(self, self.onUpdateTips))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onUpdateNum))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function wiseTutorMainProxy:onUpdateTask(target, data)
	if data.activityID == gActivityTimeActivityID.WISE_TUTOR_ACTIVITY then
		SoraDCloseLoading()
		self.view:updatTaskScroll()
		self.view:updatRed()
	end
end
function wiseTutorMainProxy:onUpdateTips(target, data)
	self.view:updateTips()
end
function wiseTutorMainProxy:onUpdateNum(target, data)
	self.view:updateNum()
end
function wiseTutorMainProxy:onUpdateRewardView(target, data)
	SoraDCloseLoading()
	if data.subMsg == "popGiftAward" then
	else
		if data.subMsg == "upgradeLock" then
			self.view:updateUnLockEffect(data.showUnlock)
		end
		self.view:updateReward()
		self.view:onUpdateLvInfo()
		self.view:updatRed()
		self.view:updateTips()
	end
end
function wiseTutorMainProxy:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.WISE_TUTOR_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
return wiseTutorMainProxy
