local extremelySkillfulRead = include("extremelySkillfulRead")
local publicRead = include("publicRead")
local ExtremelySkillfulCtrl = SoraDGetCtrl("ExtremelySkillfulCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ExtremelySkillfulBlessLightPanel = class("ExtremelySkillfulBlessLightPanel", baseFguiPanel)
function ExtremelySkillfulBlessLightPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ExtremelySkillfulBlessLightPanel:ctor", self.viewName)
end
function ExtremelySkillfulBlessLightPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function ExtremelySkillfulBlessLightPanel:onInit()
	print("=======ExtremelySkillfulBlessLightPanel:onInit")
	self.type = self.proxy.param.type or 1
	self.fields.Text_Title:setString(i18n(self.type == 1 and "MarvelousWorkmanship_03" or "MarvelousWorkmanship_04"))
	self.fields.Particle_1:setAutoCull(false)
	self.fields.Text_Tips:setString(i18n("Battle_Towers_06"))
	self.fields.Text_Title2:setString(i18n("Battle_Towers_30"))
	self.fields.GiftAward:setItemRenderer(handler(self, self.onGiftItemRenderer))
	self.fields.AllSpecialAward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_Title3:setString(i18n(self.type == 1 and "MarvelousWorkmanship_16" or "MarvelousWorkmanship_17"))
	self.fields.Text_Tips:setColorinfo("#006E00", "#66320C")
	self.fields.BuffList:setItemRenderer(handler(self, self.onBuffItemRenderer))
end
function ExtremelySkillfulBlessLightPanel:onShow()
	print("=======ExtremelySkillfulBlessLightPanel:onShow")
	self.fields.Text_Tips:initData(self.type + 1)
	self.strTips = self.type == 1 and "MarvelousWorkmanship_20" or "MarvelousWorkmanship_21"
	self.giftInfo = extremelySkillfulRead.getGiftAwardInfo(self.type, ExtremelySkillfulCtrl:getGroupIndex())
	local nowPrice = paymentManager.judgePrice(self.giftInfo.RechargeID, self.giftInfo.Price)
	local discount = self.giftInfo.OriginalPrice / self.giftInfo.Price
	local oriPrice = paymentManager.calculateDiscount(self.giftInfo.RechargeID, nowPrice, discount, self.giftInfo.OriginalPrice)
	_ENV = discount
	discount.rid = self.giftInfo.RechargeID
	discount.nowPrice = nowPrice
	discount.oriPrice = oriPrice
	discount.handleBuyClick = handler(self, self.onGuyGift)
	discount.handleItemBuyClick = handler(self, self.onGuyGiftByItem)
	self.fields.Com_OutAppPurchaseButtons:initData(discount)
	ExtremelySkillfulCtrl = discount
	discount[1] = "id"
	discount[2] = "count"
	self.giftAward = serviceFunctions.tableFormat(self.giftInfo.Rewards, discount)
	self.fields.Text_GoldNum:setString(string.formatnumberthousands(self.giftInfo.Gold))
	local _, award2, award3 = extremelySkillfulRead.getAllAwardByIndex(ExtremelySkillfulCtrl:getGroupIndex())
	self.allSpecialAward = self.type == 1 and award2 or award3
	ExtremelySkillfulCtrl = ExtremelySkillfulCtrl:getGroupIndex()
	ExtremelySkillfulCtrl:getGroupIndex()[1] = "id"
	ExtremelySkillfulCtrl:getGroupIndex()[2] = "count"
	self.allSpecialAward = serviceFunctions.tableFormat(self.allSpecialAward, ExtremelySkillfulCtrl:getGroupIndex())
	self.fields.GiftAward:setNumItems(#self.giftAward)
	self.fields.AllSpecialAward:setNumItems(#self.allSpecialAward)
	self.effectInfo = extremelySkillfulRead.getNowEffectInfo(self.type + 1)
	self.fields.BuffList:setNumItems(#self.effectInfo.EffectIcon)
end
function ExtremelySkillfulBlessLightPanel:onGiftItemRenderer(index, object)
	object:initData(self.giftAward[index + 1].id, self.giftAward[index + 1].count)
end
function ExtremelySkillfulBlessLightPanel:onItemRenderer(index, object)
	object:initData(self.allSpecialAward[index + 1].id, self.allSpecialAward[index + 1].count)
end
function ExtremelySkillfulBlessLightPanel:onBuffItemRenderer(index, object)
	local effectType, buffNum = ExtremelySkillfulCtrl:getBuffInfoByTypeIndex(self.type + 1, nil, index + 1)
	object:initData(self.effectInfo.EffectIcon[index + 1] .. ".png", self.effectInfo.PrivilegeEffect[index + 1], false, buffNum)
end
function ExtremelySkillfulBlessLightPanel:onGuyGift()
	SoraDPlaySound()
	if self.type == 1 and ExtremelySkillfulCtrl:getUnlockFurther() or self.type == 2 and ExtremelySkillfulCtrl:getUnlockFurtherEx() then
		return
	elseif self.type == 2 and not ExtremelySkillfulCtrl:getUnlockFurther() then
		SoraDShowMsgTip(i18n("MarvelousWorkmanship_27"))
		return
	end
	local _eventTime = SoraDGetCtrl("activityShowCtrl"):getTimeInfoByID(gActivityTimeActivityID.EXTREMELY_SKILLFUIL)
	_ENV = i18n("MarvelousWorkmanship_27")
	_ENV = i18n("MarvelousWorkmanship_27")
	_ENV, _ENV, i18n("MarvelousWorkmanship_27").time = _eventTime.timerNode.timer:getRemainTime()
	_ENV, _eventTime.timerNode.timer:getRemainTime().color = _eventTime.timerNode.timer:getRemainTime()
	SoraDConvertSecondToString(_eventTime.timerNode.timer:getRemainTime()).item, _eventTime.timerNode.timer:getRemainTime().__default, _eventTime.timerNode.timer:getRemainTime().color = _eventTime.timerNode.timer:getRemainTime()
	i18n("MarvelousWorkmanship_27").content = i18n_html(self.strTips, i18n("MarvelousWorkmanship_27"))
	i18n("MarvelousWorkmanship_27").confirmString = i18n("common_text_282")
	i18n("MarvelousWorkmanship_27").cancelString = i18n("common_text_185")
	i18n("MarvelousWorkmanship_27").confirmFunc = function()
		SoraDShowLoading()
		ExtremelySkillfulCtrl:reqMarvelousWorkmanshipGift(self.type)
		paymentManager.OnemtReadyBuy(self.giftInfo.RechargeID, gRechargeActiveFromEnum.ROAD32)
		self:removeFromParent()
	end
	uiManager:show("MessageBox", i18n("MarvelousWorkmanship_27"))
end
function ExtremelySkillfulBlessLightPanel:onGuyGiftByItem()
	if self.type == 1 and ExtremelySkillfulCtrl:getUnlockFurther() or self.type == 2 and ExtremelySkillfulCtrl:getUnlockFurtherEx() then
		return false
	elseif self.type == 2 and not ExtremelySkillfulCtrl:getUnlockFurther() then
		SoraDShowMsgTip(i18n("MarvelousWorkmanship_27"))
		return false
	end
	local _eventTime = SoraDGetCtrl("activityShowCtrl"):getTimeInfoByID(gActivityTimeActivityID.EXTREMELY_SKILLFUIL)
	ExtremelySkillfulCtrl = i18n("MarvelousWorkmanship_27")
	ExtremelySkillfulCtrl = i18n("MarvelousWorkmanship_27")
	ExtremelySkillfulCtrl, ExtremelySkillfulCtrl, i18n("MarvelousWorkmanship_27").time = _eventTime.timerNode.timer:getRemainTime()
	ExtremelySkillfulCtrl, _eventTime.timerNode.timer:getRemainTime().color = _eventTime.timerNode.timer:getRemainTime()
	SoraDConvertSecondToString(_eventTime.timerNode.timer:getRemainTime()).item, _eventTime.timerNode.timer:getRemainTime().__default, _eventTime.timerNode.timer:getRemainTime().color = _eventTime.timerNode.timer:getRemainTime()
	i18n("MarvelousWorkmanship_27").content = i18n_html(self.strTips, i18n("MarvelousWorkmanship_27"))
	i18n("MarvelousWorkmanship_27").confirmString = i18n("common_text_282")
	i18n("MarvelousWorkmanship_27").cancelString = i18n("common_text_185")
	i18n("MarvelousWorkmanship_27").confirmFunc = function()
		local param
		SoraDShowH5PurchaseView(self.giftInfo.RechargeID, param)
		self:removeFromParent()
	end
	uiManager:show("MessageBox", i18n("MarvelousWorkmanship_27"))
	return false
end
return ExtremelySkillfulBlessLightPanel
