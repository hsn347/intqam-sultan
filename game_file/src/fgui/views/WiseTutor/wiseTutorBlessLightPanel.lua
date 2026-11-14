local wiseTutorCtrl = SoraDGetCtrl("wiseTutorCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local wiseTutorRead = include("wiseTutorRead")
local publicRead = include("publicRead")
local basePanel = require("fgui.base.baseFguiPanel")
local wiseTutorBlessLightPanel = class("wiseTutorBlessLightPanel", basePanel)
function wiseTutorBlessLightPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
end
function wiseTutorBlessLightPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "WiseTutor"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
	end
	return self._packageList
end
function wiseTutorBlessLightPanel:onInit()
	wiseTutorCtrl = nil
	;(nil)[1] = "Button_BuyItem"
	;(nil)[2] = "Button_Buy"
	for i, v in ipairs(nil) do
		self.fields[v]:fixPos()
	end
	self.fields.Text_Title:setString(i18n("Battle_Towers_06"))
	self.itemInfo = wiseTutorRead.getUnlockItem(wiseTutorCtrl:getLevelIndex())
	self.fields.Button_BuyItem:setCost(self.itemInfo[1], self.itemInfo[2])
	self.fields.Button_BuyItem:setTitle(i18n("common_text_843"))
	self.fields.Button_Buy:addClickListener(handler(self, self.onGuyGift))
	self.fields.Button_BuyItem:addClickListener(handler(self, self.onItemUnlock))
	self.fields.Button_BuyOAP:addClickListener(handler(self, self.onGuyGift))
	self.controllers.c2:setSelectedIndex(SoraDCheckOAPIsOpen() and 1 or 0)
	self.fields.Particle_1:setAutoCull(false)
end
function wiseTutorBlessLightPanel:onShow()
	self.isUnLock = wiseTutorCtrl:isUnLock()
	self.controllers.c1:setSelectedIndex(self.isUnLock and 1 or 0)
	self.giftInfo = wiseTutorRead.getGiftAwardInfo(wiseTutorCtrl:getLevelIndex())
	self.fields.Button_BuyOAP:initData(nil, nil, self.giftInfo.RechargeID)
	local nowPrice = paymentManager.judgePrice(self.giftInfo.RechargeID, self.giftInfo.Price)
	local discount = self.giftInfo.OriginalPrice / self.giftInfo.Price
	local oriPrice = paymentManager.calculateDiscount(self.giftInfo.RechargeID, nowPrice, discount, self.giftInfo.OriginalPrice)
	self.fields.Button_Buy:initData(nowPrice, oriPrice, self.giftInfo.RechargeID)
end
function wiseTutorBlessLightPanel:onGuyGift(eventContext)
	local name = eventContext:getSender():getName()
	print("name", name)
	SoraDPlaySound()
	if SoraDGetCastleLv() < CASTLE_LV6_LIMITED then
		_ENV = nil
		;(nil).num = CASTLE_LV6_LIMITED
		SoraDShowMsgTip(i18n("common_text_1795", nil))
		return
	end
	if wiseTutorCtrl:isUnLock() then
		SoraDShowMsgTip(i18n("Battle_Towers_31"))
		return
	end
	local state, leftTime = wiseTutorCtrl:getStateInfo()
	_ENV = i18n("Battle_Towers_31")
	i18n("Battle_Towers_31").cancleColorIndex = 2
	_ENV = i18n("Battle_Towers_31")
	_ENV, _ENV, i18n("Battle_Towers_31").item = leftTime, SoraDConvertSecondToString(leftTime), SoraDConvertSecondToString(leftTime)
	_ENV, leftTime.color = i18n("Battle_Towers_31")
	SoraDConvertSecondToString(leftTime).item, leftTime.__default, i18n("Battle_Towers_31").color = leftTime, i18n("Battle_Towers_31")
	i18n("Battle_Towers_31").content = i18n("Battle_Towers_27") .. "\n" .. i18n_html("Battle_Towers_28", i18n("Battle_Towers_31"))
	i18n("Battle_Towers_31").confirmString = i18n("common_text_282")
	i18n("Battle_Towers_31").cancelString = i18n("common_text_185")
	i18n("Battle_Towers_31").confirmFunc = function()
		if name == "Button_Buy" then
			SoraDShowLoading()
			wiseTutorCtrl:reqPalaceOfWisdomGift()
			paymentManager.OnemtReadyBuy(self.giftInfo.RechargeID, gRechargeActiveFromEnum.ROAD32)
		elseif name == "Button_BuyOAP" then
			local param
			name = nil
			;(nil).fromCenter = gRechargeActiveFromEnum.ROAD32
			SoraDShowH5PurchaseView(self.giftInfo.RechargeID, param, nil)
		end
		self:removeFromParent()
	end
	uiManager:show("MessageBox", i18n("Battle_Towers_31"))
end
function wiseTutorBlessLightPanel:onItemUnlock(eventContext)
	SoraDPlaySound()
	if SoraDGetCastleLv() < CASTLE_LV6_LIMITED then
		_ENV = nil
		;(nil).num = CASTLE_LV6_LIMITED
		SoraDShowMsgTip(i18n("common_text_1795", nil))
		return
	end
	local curNum = backpackCtrl:getItemCount(self.itemInfo[1])
	if curNum < self.itemInfo[2] then
		_ENV = i18n("common_text_1795", nil)
		i18n("common_text_1795", nil).item = publicRead.getName(self.itemInfo[1])
		SoraDShowMsgTip(i18n("Battle_Towers_32", i18n("common_text_1795", nil)))
		return
	end
	SoraDShowLoading()
	wiseTutorCtrl:reqPalaceOfWisdomUnlock()
	self:removeFromParent()
end
return wiseTutorBlessLightPanel
