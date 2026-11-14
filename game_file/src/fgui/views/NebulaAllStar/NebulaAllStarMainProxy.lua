local baseProxy = require("fgui.base.baseProxy")
local NebulaAllStarMainProxy = class("NebulaAllStarMainProxy", baseProxy)
function NebulaAllStarMainProxy:onRegisterEvent()
	print("=======NebulaAllStarMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.onMsgCommonRefresh))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_REFRESH_DATA", handler(self, self.onMsgRefreshData))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_DONATE_GOLD", handler(self, self.onMsgDonateGoldBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_DONATE_REWARD", handler(self, self.onMsgDonateRewardBack))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_APPLY_REMIND", handler(self, self.onMsgUpdateApplyRemind))
	SoraDAddMessage(self, "MESSAGE_NEBULA_TEAM_INFO_NOTIFY", handler(self, self.onMsgTeamInfoNotify))
	SoraDAddMessage(self, "MESSAGE_NEBULA_ALLSTAR_QUIT_TIME", handler(self, self.onMsgUpdateQuitTime))
end
function NebulaAllStarMainProxy:onMsgCommonRefresh(target, event)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	end
end
function NebulaAllStarMainProxy:onMsgRefreshData(...)
	local nebulaAllStarUtil = include("nebulaAllStarUtil")
	if not nebulaAllStarUtil.checkActivityOpen() then
		SoraDRemoveAllAfterPanelFromManager(self.view)
		return
	end
	if nebulaAllStarUtil.checkSettleState() then
		SoraDRemoveAllAfterPanelFromManager(self.view)
		uiManager:show("NebulaAllStarShow")
		return
	end
	self.view:updateActivityState(...)
end
function NebulaAllStarMainProxy:onMsgDonateGoldBack(...)
	self.view:updateBtnDonateState()
end
function NebulaAllStarMainProxy:onMsgDonateRewardBack(...)
	self.view:updateBtnDonateState()
end
function NebulaAllStarMainProxy:onMsgUpdateApplyRemind(...)
	self.view:updateTeamBtn()
end
function NebulaAllStarMainProxy:onMsgTeamInfoNotify(target, event)
	local notifyType = event.notifyType
	if notifyType == "APPLY_JOIN" or notifyType == "HAS_APPLY" then
		self.view:updateTeamBtn()
	end
end
function NebulaAllStarMainProxy:onMsgUpdateQuitTime(...)
	self.view:onMsgUpdateQuitTime(...)
end
return NebulaAllStarMainProxy
