local activity_9001610_Ctrl = SoraDGetCtrl("activity_9001610_Ctrl")
local activity_9001610_Read = include("activity_9001610_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001610_signPopPanel = class("Activity_9001610_signPopPanel", baseFguiPanel)
function Activity_9001610_signPopPanel:ctor(...)
	Activity_9001610_signPopPanel.super.ctor(self, ...)
	print("Activity_9001610_signPopPanel:ctor", self.viewName)
end
function Activity_9001610_signPopPanel:onInit()
	print("=======Activity_9001610_signPopPanel:onInit")
end
function Activity_9001610_signPopPanel:onShow()
	print("=======Activity_9001610_signPopPanel:onShow")
end
function Activity_9001610_signPopPanel:onInit()
	print("=======Activity_9001610_signPopPanel:onInit")
	self.rewardCfg, _ENV = print, print
	self.fields.Panel_bg:setTitle(i18n("decrypt_text_03"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_reward:setAlignCenter(true)
	self.fields.Button_comfirm:addClickListener(handler(self, self.onBtnNormalClick))
	self.fields.Button_cost:addClickListener(handler(self, self.onBtnGoldClick))
end
function Activity_9001610_signPopPanel:onShow()
	print("=======Activity_9001610_signPopPanel:onShow")
end
function Activity_9001610_signPopPanel:onItemRenderer(index, obj)
	obj:initData(self.rewardCfg[index + 1].id, self.rewardCfg[index + 1].count)
end
function Activity_9001610_signPopPanel:onShow()
	print("=======Activity_9001610_signPopPanel:onShow")
	self.day = self.param.day
	self.mode = self.param.mode
	self.group = activity_9001610_Ctrl:getGroup()
	if self.mode == 1 then
		_ENV = nil
		;(nil).num = fguiHelper.getColorString("#EBE53B", self.day)
		self.fields.Text_tip:setString(i18n("common_text_2877", nil))
		local rewards = activity_9001610_Read.getExtraAwardByDay(self.day, self.group)
		activity_9001610_Read = i18n("common_text_2877", nil)
		i18n("common_text_2877", nil)[1] = "id"
		i18n("common_text_2877", nil)[2] = "count"
		self.rewardCfg = serviceFunctions.tableFormat(rewards, i18n("common_text_2877", nil))
		self:initCumu()
	else
		_ENV = "id"
		;("id").day = fguiHelper.getColorString("#EBE53B", self.day)
		self.fields.Text_tip:setString(i18n("common_text_2872", "id"))
		local rewards = activity_9001610_Read.getAwardByDay(self.day, self.group)
		activity_9001610_Read = i18n("common_text_2872", "id")
		i18n("common_text_2872", "id")[1] = "id"
		i18n("common_text_2872", "id")[2] = "count"
		self.rewardCfg = serviceFunctions.tableFormat(rewards, i18n("common_text_2872", "id"))
		self:initData()
	end
	self.fields.List_reward:setNumItems(#self.rewardCfg)
	self.fields.List_reward:setScrollEnable(#self.rewardCfg > 5)
end
function Activity_9001610_signPopPanel:initCumu()
	self.fields.Button_cost:setVisible(false)
	self.fields.Button_comfirm:setVisible(true)
	self.status = activity_9001610_Ctrl:getExtraRewardInfoByDay(self.day)
	if self.status == gSignRewardStatus.ALREADY_RECEIVE then
		self.fields.Button_comfirm:setString(i18n("common_text_1892"))
		self.fields.Button_comfirm:setEnabled(false)
	else
		local totalSignDay = activity_9001610_Ctrl:getTotalSignDay()
		self.fields.Button_comfirm:setString(i18n("common_text_854"))
		self.fields.Button_comfirm:setEnabled(totalSignDay >= self.day)
	end
end
function Activity_9001610_signPopPanel:initData()
	self.status = activity_9001610_Ctrl:getSignTypeByDay(self.day)
	self.useGoldDay = activity_9001610_Ctrl:getUseGoldDay()
	self.needGold = activity_9001610_Read.getCostGold(self.day, self.group)
	self.curSignDay = activity_9001610_Ctrl:getCurDay()
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
function Activity_9001610_signPopPanel:onBtnNormalClick()
	SoraDPlaySound()
	if self.mode == 1 then
		activity_9001610_Ctrl:sendGetExtraRewardMsg(self.day)
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
	activity_9001610_Ctrl:sendSignMsg()
	self:close()
end
function Activity_9001610_signPopPanel:onBtnGoldClick()
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
				activity_9001610_Ctrl:sendUseGoldSignMsg(self.day)
				self:close()
			end
		end
	end)
end
return Activity_9001610_signPopPanel
