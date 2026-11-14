local signRewadRead = include("signRewadRead")
local activity_9001576_Ctrl = SoraDGetCtrl("activity_9001576_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001576_signPopPanel = class("Activity_9001576_signPopPanel", baseFguiPanel)
function Activity_9001576_signPopPanel:ctor(...)
	Activity_9001576_signPopPanel.super.ctor(self, ...)
	print("Activity_9001576_signPopPanel:ctor", self.viewName)
end
function Activity_9001576_signPopPanel:onInit()
	print("=======Activity_9001576_signPopPanel:onInit")
	self.rewardCfg, _ENV = print, print
	self.fields.Panel_bg:setTitle(i18n("common_text_2078"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_comfirm:addClickListener(handler(self, self.onBtnNormalClick))
	self.fields.Button_cost:addClickListener(handler(self, self.onBtnGoldClick))
end
function Activity_9001576_signPopPanel:onItemRenderer(index, obj)
	obj:initData(self.rewardCfg[index + 1].id, self.rewardCfg[index + 1].count)
end
function Activity_9001576_signPopPanel:onShow()
	print("=======Activity_9001576_signPopPanel:onShow")
	self.day = self.param.cfg.day
	self.isFinal = self.param.isFinal or false
	_ENV = nil
	;(nil).day = fguiHelper.getColorString("#EBE53B", self.day)
	self.fields.Text_tip:setString(i18n("common_text_2872", nil))
	if self.isFinal then
		_UPVALUE2_ = i18n("common_text_2872", nil)
		i18n("common_text_2872", nil)[1] = "id"
		i18n("common_text_2872", nil)[2] = "count"
		self.rewardCfg = serviceFunctions.tableFormat(self.param.cfg.cumulateReward, i18n("common_text_2872", nil))
	else
		_UPVALUE2_ = i18n("common_text_2872", nil)
		i18n("common_text_2872", nil)[1] = "id"
		i18n("common_text_2872", nil)[2] = "count"
		self.rewardCfg = serviceFunctions.tableFormat(self.param.cfg.reward, i18n("common_text_2872", nil))
	end
	self.fields.List_reward:setNumItems(#self.rewardCfg)
	self:initData()
end
function Activity_9001576_signPopPanel:initData()
	if self.isFinal then
		self.fields.Button_cost:setVisible(false)
		self.status = activity_9001576_Ctrl:getExtraRewardInfoByDay(self.day)
		activity_9001576_Ctrl = nil
		;(nil).day = self.day
		self.fields.Text_tip:setString(i18n("newyear_signin_text_02", nil))
		if self.status == gSignRewardStatus.ALREADY_RECEIVE then
			self.fields.Text_extra:setVisible(true)
			self.fields.Text_extra:setString(i18n("common_text_1892"))
			self.fields.Button_comfirm:setVisible(false)
		else
			self.fields.Text_extra:setVisible(false)
			self.fields.Button_comfirm:setVisible(true)
			local totalSignDay = activity_9001576_Ctrl:getTotalSignDay()
			self.fields.Button_comfirm:setString(i18n("common_text_854"))
			self.fields.Button_comfirm:setEnabled(totalSignDay >= self.day)
		end
		return
	end
	self.status = activity_9001576_Ctrl:getSignTypeByDay(self.day)
	self.useGoldDay = activity_9001576_Ctrl:getUseGoldDay()
	self.needGold = self.param.cfg.gold
	self.curSignDay = activity_9001576_Ctrl:getCurDay()
	if self.day > self.curSignDay then
		self.fields.Text_extra:setVisible(true)
		self.fields.Text_extra:setString(i18n("common_text_3070"))
		self.fields.Button_comfirm:setVisible(false)
		self.fields.Button_cost:setVisible(false)
	elseif self.day == self.curSignDay then
		if self.status == gSignRewardType.NORMAL_SIGN then
			self.fields.Text_extra:setVisible(true)
			self.fields.Text_extra:setString(i18n("common_text_2874"))
			self.fields.Button_comfirm:setVisible(false)
			self.fields.Button_cost:setVisible(false)
		else
			self.fields.Text_extra:setVisible(false)
			self.fields.Button_comfirm:setVisible(true)
			self.fields.Button_comfirm:setString(i18n("common_text_2477"))
			self.fields.Button_cost:setVisible(false)
		end
	elseif self.day < self.curSignDay then
		if self.status == gSignRewardType.NO_SIGN then
			self.fields.Text_extra:setVisible(false)
			self.fields.Button_comfirm:setVisible(false)
			self.fields.Button_cost:setVisible(true)
			self.fields.Button_cost:setCost(gIDDef.GOLD, self.needGold)
			self.fields.Button_cost:setString(i18n("common_text_2875"))
			self.fields.Button_cost:setGoldColor(SoraDEnoughGold(self.needGold, true) and cc.c3b(255, 255, 0) or cc.c3b(190, 40, 40))
		else
			self.fields.Text_extra:setVisible(true)
			self.fields.Text_extra:setString(i18n("common_text_2874"))
			self.fields.Button_comfirm:setVisible(false)
			self.fields.Button_cost:setVisible(false)
		end
	end
end
function Activity_9001576_signPopPanel:onBtnNormalClick()
	SoraDPlaySound()
	if self.isFinal then
		activity_9001576_Ctrl:sendGetExtraRewardMsg(self.day)
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
	activity_9001576_Ctrl:sendSignMsg()
end
function Activity_9001576_signPopPanel:onBtnGoldClick()
	SoraDPlaySound()
	if self.status ~= gSignRewardType.NO_SIGN then
		SoraDShowMsgTip(i18n("common_text_4609"))
		return
	end
	_ENV = i18n("common_text_4609")
	i18n("common_text_4609").NUM = self.needGold
	SoraDShowMsgBox(i18n("Icefestival2024_text02", i18n("common_text_4609")), i18n("common_text_204"), i18n("common_text_185"), function(callType)
		if callType == MSGBOX_CALLBACK_YES then
			SoraDPlaySound()
			if SoraDEnoughGold(self.needGold) then
				activity_9001576_Ctrl:sendUseGoldSignMsg(self.day)
			end
		end
	end)
end
return Activity_9001576_signPopPanel
