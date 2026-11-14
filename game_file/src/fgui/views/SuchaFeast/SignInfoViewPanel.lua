local signRewadRead = include("signRewadRead")
local signReward2022Ctrl = SoraDGetCtrl("signReward2022Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SignInfoViewPanel = class("SignInfoViewPanel", baseFguiPanel)
function SignInfoViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("SignInfoViewPanel:ctor", self.viewName)
end
function SignInfoViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function SignInfoViewPanel:onInit()
	print("=======SignInfoViewPanel:onInit")
	self.fields.Usm_pop:setBlendFunc(gl.ONE, gl.ONE)
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_comfirm:addClickListener(handler(self, self.onBtnNormalClick))
	self.fields.Button_cost:addClickListener(handler(self, self.onBtnGoldClick))
end
function SignInfoViewPanel:onItemRenderer(index, obj)
	local item = self.rewardCfg[index + 1]
	obj:initData(item.id, item.count)
end
function SignInfoViewPanel:onShow()
	print("=======SignInfoViewPanel:onShow")
	self.day = self.param.cfg.day
	_ENV = nil
	;(nil).day = fguiHelper.getColorString("#EBE53B", self.day)
	self.fields.Text_tip:setString(i18n("common_text_2872", nil))
	_UPVALUE2_ = i18n("common_text_2872", nil)
	i18n("common_text_2872", nil)[1] = "id"
	i18n("common_text_2872", nil)[2] = "count"
	self.rewardCfg = serviceFunctions.tableFormat(self.param.cfg.normalReward, i18n("common_text_2872", nil))
	self.fields.List_reward:setNumItems(#self.rewardCfg)
	self:initData()
end
function SignInfoViewPanel:initData()
	self.status = signReward2022Ctrl:getSignTypeByDay(self.day)
	self.useGoldDay = signReward2022Ctrl:getUseGoldDay()
	self.needGold = signRewadRead.getRemedyPrice(self.useGoldDay + 1)
	self.curSignDay = signReward2022Ctrl:getCurDay()
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
function SignInfoViewPanel:onHide()
	print("=======SignInfoViewPanel:onHide")
end
function SignInfoViewPanel:onDispose()
	print("=======SignInfoViewPanel:onDispose")
end
function SignInfoViewPanel:onBtnNormalClick()
	SoraDPlaySound()
	if self.status ~= gSignRewardType.NO_SIGN then
		SoraDShowMsgTip(i18n("common_text_4607"))
		return
	end
	if self.day < self.curSignDay then
		SoraDShowMsgTip(i18n("common_text_4608"))
		return
	end
	signReward2022Ctrl:sendSignMsg()
end
function SignInfoViewPanel:onBtnGoldClick()
	SoraDPlaySound()
	if self.status ~= gSignRewardType.NO_SIGN then
		SoraDShowMsgTip(i18n("common_text_4609"))
		return
	end
	if SoraDEnoughGold(self.needGold) then
		signReward2022Ctrl:sendUseGoldSignMsg(self.day)
	end
end
return SignInfoViewPanel
