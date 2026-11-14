local activityCommonSignCtrl = SoraDGetCtrl("activityCommonSignCtrl")
local activityCommonSignRead = include("activityCommonSignRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommonSignPopPanel = class("CommonSignPopPanel", baseFguiPanel)
function CommonSignPopPanel:ctor(...)
	CommonSignPopPanel.super.ctor(self, ...)
	print("CommonSignPopPanel:ctor", self.viewName)
end
function CommonSignPopPanel:onInit()
	print("=======CommonSignPopPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("decrypt_text_03"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_comfirm:addClickListener(handler(self, self.onBtnNormalClick))
	self.fields.Button_cost:setString(i18n("common_text_2875"))
	self.fields.Button_cost:addClickListener(handler(self, self.onBtnGoldClick))
end
function CommonSignPopPanel:onShow()
	print("=======CommonSignPopPanel:onShow")
	if not self.param then
		local _ENV, param = self.param, self.param
	end
	self.activityID = param.activityID or gActivityTimeActivityID.SIGN_REWARD_9001623_ACTIVITY
	self.day = param.day or 1
	self.mode = param.mode or 2
	if self.mode == 1 then
		_ENV = nil
		;(nil).num = fguiHelper.getColorString("#EBE53B", self.day)
		self.fields.Text_tip:setString(i18n("common_text_2877", nil))
		self.rewardCfg = activityCommonSignRead.getExtraAwardByDay(self.activityID, self.day)
		self:initCumu()
	else
		_ENV = i18n("common_text_2877", nil)
		i18n("common_text_2877", nil).day = fguiHelper.getColorString("#EBE53B", self.day)
		self.fields.Text_tip:setString(i18n("common_text_2872", i18n("common_text_2877", nil)))
		self.rewardCfg = activityCommonSignRead.getAwardByDay(self.activityID, self.day)
		self:initData()
	end
	self.fields.List_reward:setNumItems(#self.rewardCfg)
end
function CommonSignPopPanel:initCumu()
	self.fields.Button_cost:setVisible(false)
	self.fields.Button_comfirm:setVisible(true)
	self.status = activityCommonSignCtrl:getExtraRewardInfoByDay(self.activityID, self.day)
	if self.status == gSignRewardStatus.ALREADY_RECEIVE then
		self.fields.Button_comfirm:setString(i18n("common_text_1892"))
		self.fields.Button_comfirm:setEnabled(false)
	else
		local totalSignDay = activityCommonSignCtrl:getTotalSignDay(self.activityID)
		self.fields.Button_comfirm:setString(i18n("common_text_854"))
		self.fields.Button_comfirm:setEnabled(totalSignDay >= self.day)
	end
end
function CommonSignPopPanel:initData()
	self.status = activityCommonSignCtrl:getSignTypeByDay(self.activityID, self.day)
	self.needGold = activityCommonSignCtrl:getCostGold(self.activityID)
	self.curSignDay = activityCommonSignCtrl:getCurDay(self.activityID)
	local sIndex = 0
	if self.day > self.curSignDay then
		sIndex = 0
	elseif self.day == self.curSignDay then
		if self.status == gSignRewardType.NORMAL_SIGN then
			sIndex = 3
		else
			sIndex = 1
		end
	elseif self.day < self.curSignDay then
		if self.status == gSignRewardType.NO_SIGN then
			sIndex = 2
		else
			sIndex = 3
		end
	end
	self.controllers.c1:setSelectedIndex(sIndex)
	if sIndex == 0 then
		self.fields.Button_comfirm:setString(i18n("common_text_2477"))
		self.fields.Button_comfirm:setEnabled(false)
	elseif sIndex == 1 then
		self.fields.Button_comfirm:setString(i18n("common_text_2477"))
	elseif sIndex == 2 then
		self.fields.Button_cost:setCost(gIDDef.GOLD, self.needGold)
		self.fields.Button_cost:setGoldColor(SoraDEnoughGold(self.needGold, true) and cc.c3b(255, 255, 0) or cc.c3b(190, 40, 40))
	elseif sIndex == 3 then
		self.fields.Button_comfirm:setString(i18n("common_text_2874"))
		self.fields.Button_comfirm:setEnabled(false)
	end
end
function CommonSignPopPanel:onItemRenderer(index, obj)
	local reward = self.rewardCfg[index + 1]
	obj:initData(reward.id, reward.count)
end
function CommonSignPopPanel:onBtnNormalClick()
	SoraDPlaySound()
	if self.mode == 1 then
		activityCommonSignCtrl:reqExtraReward(self.activityID, self.day)
		self:closePanel()
		return
	end
	if self.status ~= gSignRewardType.NO_SIGN then
		SoraDShowMsgTip(i18n("common_text_4607"))
		return
	end
	if self.day < self.curSignDay then
		SoraDShowMsgTip(i18n("common_text_4608"))
		return
	end
	activityCommonSignCtrl:reqSign(self.activityID)
	self:closePanel()
end
function CommonSignPopPanel:onBtnGoldClick()
	SoraDPlaySound()
	if self.status ~= gSignRewardType.NO_SIGN then
		SoraDShowMsgTip(i18n("common_text_4609"))
		return
	end
	_ENV = i18n("common_text_4609")
	i18n("common_text_4609").NUM = self.needGold
	local msgStr = i18n("Icefestival2024_text02", i18n("common_text_4609"))
	SoraDShowMsgBox(msgStr, i18n("common_text_204"), i18n("common_text_185"), function(callType)
		if callType ~= MSGBOX_CALLBACK_YES then
			return
		end
		SoraDPlaySound()
		if SoraDEnoughGold(self.needGold) then
			activityCommonSignCtrl:reqUseGoldSign(self.activityID, self.day)
			self:closePanel()
		end
	end)
end
return CommonSignPopPanel
