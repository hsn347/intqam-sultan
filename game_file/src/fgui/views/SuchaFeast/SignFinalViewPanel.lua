local signRewadRead = include("signRewadRead")
local signReward2022Ctrl = SoraDGetCtrl("signReward2022Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SignFinalViewPanel = class("SignFinalViewPanel", baseFguiPanel)
function SignFinalViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("SignFinalViewPanel:ctor", self.viewName)
end
function SignFinalViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function SignFinalViewPanel:onInit()
	print("=======SignFinalViewPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("eid_banquet_03"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_claim:addClickListener(handler(self, self.onBtnClick))
end
function SignFinalViewPanel:onItemRenderer(index, obj)
	local item = self.rewardCfg[index + 1]
	obj:initData(item.id, item.count)
end
function SignFinalViewPanel:onShow()
	print("=======SignFinalViewPanel:onShow")
	self.rewardCfg, self.cumuDay = signRewadRead.getCumuSignCfg()
	_ENV = nil
	;(nil).day = self.cumuDay
	self.fields.Text_tip:setString(i18n("newyear_signin_text_02", nil))
	self.fields.List_reward:setNumItems(#self.rewardCfg)
	self:initData()
end
function SignFinalViewPanel:initData()
	self.status = signReward2022Ctrl:getExtraRewardInfoByDay(self.cumuDay)
	self.fields.Button_claim:setString(self.status == gSignRewardStatus.ALREADY_RECEIVE and i18n("common_text_1892") or i18n("common_text_854"))
	self.fields.Button_claim:setEnabled(self.status ~= gSignRewardStatus.ALREADY_RECEIVE)
end
function SignFinalViewPanel:onHide()
	print("=======SignFinalViewPanel:onHide")
end
function SignFinalViewPanel:onDispose()
	print("=======SignFinalViewPanel:onDispose")
end
function SignFinalViewPanel:onBtnClick()
	SoraDPlaySound()
	if self.status == gSignRewardStatus.CAN_RECEIVE then
		signReward2022Ctrl:sendGetExtraRewardMsg(self.cumuDay)
	elseif self.status == gSignRewardStatus.CAN_NOT_RECEIVE then
		_ENV = nil
		;(nil).day = self.cumuDay
		SoraDShowMsgTip(i18n("newyear_signin_text_02", nil))
	end
end
return SignFinalViewPanel
