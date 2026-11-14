local signRewardCtrl = SoraDGetCtrl("signRewardCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001038_signPopPanel = class("Activity_9001038_signPopPanel", baseFguiPanel)
function Activity_9001038_signPopPanel:ctor(...)
	Activity_9001038_signPopPanel.super.ctor(self, ...)
	print("Activity_9001038_signPopPanel:ctor", self.viewName)
end
function Activity_9001038_signPopPanel:onInit()
	print("=======Activity_9001038_signPopPanel:onInit")
	self.rewardCfg, _ENV = print, print
	self.fields.Panel_bg:setTitle(i18n("decrypt_text_03"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_comfirm:addClickListener(handler(self, self.onBtnNormalClick))
	self.fields.Button_cost:addClickListener(handler(self, self.onBtnGoldClick))
end
function Activity_9001038_signPopPanel:onShow()
	print("=======Activity_9001038_signPopPanel:onShow")
end
function Activity_9001038_signPopPanel:onItemRenderer(index, obj)
	obj:initData(self.rewardCfg[index + 1].id, self.rewardCfg[index + 1].count)
end
function Activity_9001038_signPopPanel:onShow()
	print("=======Activity_9001038_signPopPanel:onShow")
	self.day = self.param.day
	self.mode = self.param.mode
	if self.mode == 1 then
		_ENV = nil
		;(nil).num = fguiHelper.getColorString("#EBE53B", self.day)
		self.fields.Text_tip:setString(i18n("common_text_2877", nil))
		local rewards = signRewardCtrl:getExtraAwardByDay(self.day)
		_UPVALUE2_ = i18n("common_text_2877", nil)
		i18n("common_text_2877", nil)[1] = "id"
		i18n("common_text_2877", nil)[2] = "count"
		self.rewardCfg = serviceFunctions.tableFormat(rewards, i18n("common_text_2877", nil))
		self:initCumu()
	else
		_ENV = "id"
		;("id").day = fguiHelper.getColorString("#EBE53B", self.day)
		self.fields.Text_tip:setString(i18n("common_text_2872", "id"))
		local rewards = signRewardCtrl:getAwardByDay(self.day)
		_UPVALUE2_ = i18n("common_text_2872", "id")
		i18n("common_text_2872", "id")[1] = "id"
		i18n("common_text_2872", "id")[2] = "count"
		self.rewardCfg = serviceFunctions.tableFormat(rewards, i18n("common_text_2872", "id"))
		self:initData()
	end
	self.fields.List_reward:setNumItems(#self.rewardCfg)
end
function Activity_9001038_signPopPanel:initCumu()
	self.fields.Button_cost:setVisible(false)
	self.fields.Button_comfirm:setVisible(true)
	self.status = signRewardCtrl:getExtraRewardInfoByDay(self.day)
	if self.status == gSignRewardStatus.ALREADY_RECEIVE then
		self.fields.Button_comfirm:setString(i18n("common_text_1892"))
		self.fields.Button_comfirm:setEnabled(false)
	else
		local totalSignDay = signRewardCtrl:getTotalSignDay()
		self.fields.Button_comfirm:setString(i18n("common_text_854"))
		self.fields.Button_comfirm:setEnabled(totalSignDay >= self.day)
	end
end
function Activity_9001038_signPopPanel:initData()
	self.status = signRewardCtrl:getSignTypeByDay(self.day)
	self.useGoldDay = signRewardCtrl:getUseGoldDay()
	self.needGold = signRewardCtrl:getCostGold()
	self.curSignDay = signRewardCtrl:getCurDay()
	if self.day > self.curSignDay then
		self.fields.Button_comfirm:setVisible(true)
		self.fields.Button_comfirm:setString(i18n("common_text_2477"))
		self.fields.Button_comfirm:setEnabled(false)
		self.fields.Button_cost:setVisible(false)
	elseif self.day == self.curSignDay then
		if self.status == gSignRewardType.NORMAL_SIGN then
			self.fields.Button_comfirm:setVisible(true)
			self.fields.Button_comfirm:setString(i18n("common_text_2874"))
			self.fields.Button_comfirm:setEnabled(false)
			self.fields.Button_cost:setVisible(false)
		else
			self.fields.Button_comfirm:setVisible(true)
			self.fields.Button_comfirm:setString(i18n("common_text_2477"))
			self.fields.Button_cost:setVisible(false)
		end
	elseif self.day < self.curSignDay then
		if self.status == gSignRewardType.NO_SIGN then
			self.fields.Button_comfirm:setVisible(false)
			self.fields.Button_cost:setVisible(true)
			self.fields.Button_cost:setCost(gIDDef.GOLD, self.needGold)
			self.fields.Button_cost:setString(i18n("common_text_2875"))
			self.fields.Button_cost:setGoldColor(SoraDEnoughGold(self.needGold, true) and cc.c3b(255, 255, 0) or cc.c3b(190, 40, 40))
		else
			self.fields.Button_comfirm:setVisible(true)
			self.fields.Button_comfirm:setString(i18n("common_text_2874"))
			self.fields.Button_comfirm:setEnabled(false)
			self.fields.Button_cost:setVisible(false)
		end
	end
end
function Activity_9001038_signPopPanel:onBtnNormalClick()
	SoraDPlaySound()
	if self.mode == 1 then
		signRewardCtrl:sendGetExtraRewardMsg(self.day)
		self:close()
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
	signRewardCtrl:sendSignMsg()
	self:close()
end
function Activity_9001038_signPopPanel:onBtnGoldClick()
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
				signRewardCtrl:sendUseGoldSignMsg(self.day)
				self:close()
			end
		end
	end)
end
return Activity_9001038_signPopPanel
