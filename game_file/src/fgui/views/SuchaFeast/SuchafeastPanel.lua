local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local signReward2022Ctrl = SoraDGetCtrl("signReward2022Ctrl")
local signRewadRead = include("signRewadRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SuchafeastPanel = class("SuchafeastPanel", baseFguiPanel)
function SuchafeastPanel:ctor(...)
	self.super.ctor(self, ...)
	print("SuchafeastPanel:ctor", self.viewName)
end
function SuchafeastPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function SuchafeastPanel:onInit()
	print("=======SuchafeastPanel:onInit")
	self.activityID = gActivityTimeActivityID.SIGN_REWARD_2022_ACTIVITY
	self.fields.Com_title:initData(i18n("activity_name_9001424"), handler(self, self.onClickClose))
	self.fields.List_sign:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_sign:setAlignCenter(true)
	self.fields.n27:setAllFrameName("dh_lazhu1_%.2d.png", 1)
	self.fields.have:setVisible(IsArClient and true or false)
	self.fields.none:setVisible(false)
	self.controllers.c1:setSelectedIndex(IsArClient and 0 or 1)
end
function SuchafeastPanel:onItemRenderer(index, obj)
	obj:initData(self.signCfg[index + 1])
end
function SuchafeastPanel:onShow()
	print("=======SuchafeastPanel:onShow")
	local timeInfo = activityShowCtrl:getTimeInfoByID(self.activityID)
	if timeInfo then
		local leftTime = timeInfo.timerNode.timer:getRemainTime()
		self.fields.Label_time:setTimeLast(function(timeStr)
			return fguiHelper.getColorString("#F7C974", i18n("common_text_2669")) .. fguiHelper.getColorString("#FFFFFF", timeStr)
		end)
		self.fields.Label_time:beginTime(leftTime)
	end
	local cumuCfg, cumuDay = signRewadRead.getCumuSignCfg()
	if cumuDay then
		_ENV = nil
		;(nil).num = fguiHelper.getColorString("#85F853", cumuDay)
		self.fields.Text_tip:setString(i18n("return_text_20", nil))
	end
	self.fields.Text_sign:setString(i18n("eid_banquet_02"))
	self.signCfg = signRewadRead.getSignCfg(signReward2022Ctrl:getRefreshLv())
	self:initData()
end
function SuchafeastPanel:initData()
	self.fields.List_sign:setNumItems(#self.signCfg)
	local cumuCfg, cumuDay = signRewadRead.getCumuSignCfg()
	if cumuDay then
		local status = signReward2022Ctrl:getExtraRewardInfoByDay(cumuDay)
		self.fields.Btn_cumu:setStatus(status)
		self.controllers.c2:setSelectedIndex(status == gSignRewardStatus.ALREADY_RECEIVE and 1 or 0)
		self.fields.none:setVisible(IsArClient and status == gSignRewardStatus.ALREADY_RECEIVE)
		self.fields.have:setVisible(IsArClient and status ~= gSignRewardStatus.ALREADY_RECEIVE)
		self.fields.Btn_cumu:setVisible(not IsArClient or status ~= gSignRewardStatus.ALREADY_RECEIVE)
	else
		self.fields.none:setVisible(true)
		self.fields.have:setVisible(false)
		self.fields.Btn_cumu:setVisible(false)
	end
end
function SuchafeastPanel:onHide()
	print("=======SuchafeastPanel:onHide")
end
function SuchafeastPanel:onDispose()
	print("=======SuchafeastPanel:onDispose")
end
return SuchafeastPanel
