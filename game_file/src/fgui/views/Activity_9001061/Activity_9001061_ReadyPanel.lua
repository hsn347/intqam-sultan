local gametop = gModuleMgr.getObject("gametop")
local activityCtrl = gametop.playertop_:getModule("activityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001061_ReadyPanel = class("Activity_9001061_ReadyPanel", baseFguiPanel)
function Activity_9001061_ReadyPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001061_ReadyPanel:ctor", self.viewName)
end
function Activity_9001061_ReadyPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function Activity_9001061_ReadyPanel:onInit()
	print("=======Activity_9001061_ReadyPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_610"))
	self.fields.Text_content:setString(i18n("common_text_611"))
	self.fields.Button_reward:setString(i18n("common_text_609"))
	self.fields.Button_reward:addClickListener(handler(self, self.btnRewardClick))
	self.fields.Button_rank:setString(i18n("common_text_615"))
	self.fields.Button_rank:addClickListener(handler(self, self.btnHisRankClick))
	self.fields.Label_time:setTimeLast(function(times)
		_ENV = nil
		;(nil).time = times
		return i18n("common_text_606", nil)
	end)
end
function Activity_9001061_ReadyPanel:onShow()
	print("=======Activity_9001061_ReadyPanel:onShow")
	activityCtrl:reqActivityInfo()
	SoraDShowLoading(self)
end
function Activity_9001061_ReadyPanel:initData()
	self.leftTime = activityCtrl:queryQueue(activityCtrl.activityState)
	self.fields.Label_time:beginTime(self.leftTime.timerNode.timer:getRemainTime())
end
function Activity_9001061_ReadyPanel:btnRewardClick(target, event)
	local activityltCtrl = include("activityltCtrl")
	local rankData = activityltCtrl.getTotalRankReward(activityCtrl.serverLv)
	_ENV = nil
	;(nil).awardList = rankData
	uiManager:show("commonRankAwardView", nil)
end
function Activity_9001061_ReadyPanel:btnHisRankClick()
	_ENV = nil
	;(nil).defaultType = 2
	;(nil).isOnly = true
	uiManager:show("Activity_9001061_Rank", nil)
end
return Activity_9001061_ReadyPanel
