local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local artisanHouseCtrl = SoraDGetCtrl("artisanHouseCtrl")
local artisanHouseltCtrl = include("artisanHouseltCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local basePanel = require("fgui.base.baseFguiPanel")
local ArtisanHouseBlessLightPanel = class("ArtisanHouseBlessLightPanel", basePanel)
function ArtisanHouseBlessLightPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
end
function ArtisanHouseBlessLightPanel:getPackageList()
	if not self._packageList then
		_UPVALUE3_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ArtisanHouse"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "WiseTutor"
	end
	return self._packageList
end
function ArtisanHouseBlessLightPanel:onInit()
	artisanHouseCtrl = nil
	;(nil)[1] = "Button_BuyItem"
	;(nil)[2] = "Button_Buy"
	for i, v in ipairs(nil) do
		self.fields[v]:fixPos()
	end
	self.fields.Text_Title:setString(i18n("Artisan_House_05"))
	self.itemInfo = artisanHouseltCtrl.getUnlockItem(artisanHouseCtrl:getLevelIndex())
	self.fields.Button_BuyItem:setCost(self.itemInfo[1], self.itemInfo[2])
	self.fields.Button_BuyItem:setTitle(i18n("common_text_843"))
	local curNum = backpackCtrl:getItemCount(self.itemInfo[1])
	local total = self.itemInfo[2]
	self.fields.Button_BuyItem:setNumTotal2(curNum, total, curNum >= total and "#FFFFFF" or "#F02828")
	self.fields.Button_Buy:addClickListener(handler(self, self.onGuyGift))
	self.fields.Button_BuyItem:addClickListener(handler(self, self.onItemUnlock))
	self.fields.Button_help:addClickListener(handler(self, self.onClickHelp))
	self.fields.Button_BuyOAP:addClickListener(handler(self, self.onGuyGift))
	self.controllers.c2:setSelectedIndex(SoraDCheckOAPIsOpen() and 1 or 0)
end
function ArtisanHouseBlessLightPanel:onShow()
	self.isUnLock = artisanHouseCtrl:isUnLock()
	self.controllers.c1:setSelectedIndex(self.isUnLock and 1 or 0)
	self.giftInfo = artisanHouseltCtrl.getGiftAwardInfo(artisanHouseCtrl:getLevelIndex())
	self.fields.Button_BuyOAP:initData(nil, nil, self.giftInfo.RechargeID)
	local nowPrice = paymentManager.judgePrice(self.giftInfo.RechargeID, self.giftInfo.Price)
	local discount = self.giftInfo.OriginalPrice / self.giftInfo.Price
	local oriPrice = paymentManager.calculateDiscount(self.giftInfo.RechargeID, nowPrice, discount, self.giftInfo.OriginalPrice)
	self.fields.Button_Buy:initData(nowPrice, oriPrice, self.giftInfo.RechargeID)
end
function ArtisanHouseBlessLightPanel:onGuyGift(eventContext)
	local name = eventContext:getSender():getName()
	print("name", name)
	SoraDPlaySound()
	if SoraDGetCastleLv() < CASTLE_LV6_LIMITED then
		_ENV = nil
		;(nil).num = CASTLE_LV6_LIMITED
		SoraDShowMsgTip(i18n("common_text_1795", nil))
		return
	end
	if artisanHouseCtrl:isUnLock() then
		SoraDShowMsgTip(i18n("Artisan_House_15"))
		return
	end
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.ARTISAN_HOUSE_ACTIVITY)
	local leftTime = eventTime.timerNode.timer:getRemainTime()
	_ENV = i18n("Artisan_House_15")
	i18n("Artisan_House_15").cancleColorIndex = 0
	_ENV = i18n("Artisan_House_15")
	_ENV, _ENV, i18n("Artisan_House_15").item = leftTime, SoraDConvertSecondToString(leftTime), SoraDConvertSecondToString(leftTime)
	_ENV, leftTime.color = i18n("Artisan_House_15")
	SoraDConvertSecondToString(leftTime).item, leftTime.__default, i18n("Artisan_House_15").color = leftTime, i18n("Artisan_House_15")
	i18n("Artisan_House_15").content = i18n("Artisan_House_12") .. "\n" .. i18n_html("Artisan_House_13", i18n("Artisan_House_15"))
	i18n("Artisan_House_15").confirmString = i18n("common_text_282")
	i18n("Artisan_House_15").cancelString = i18n("common_text_185")
	i18n("Artisan_House_15").confirmFunc = function()
		if name == "Button_Buy" then
			artisanHouseCtrl:reqPalaceOfCraftsmanGift()
			paymentManager.OnemtReadyBuy(self.giftInfo.RechargeID, gRechargeActiveFromEnum.ROAD32)
		elseif name == "Button_BuyOAP" then
			name = nil
			;(nil).fromCenter = gRechargeActiveFromEnum.ROAD32
			SoraDShowH5PurchaseView(self.giftInfo.RechargeID, param, nil)
		end
		self:removeFromParent()
	end
	uiManager:show("MessageBox", i18n("Artisan_House_15"))
end
function ArtisanHouseBlessLightPanel:onItemUnlock(...)
	SoraDPlaySound()
	local curNum = backpackCtrl:getItemCount(self.itemInfo[1])
	if curNum < self.itemInfo[2] then
		_ENV = nil
		;(nil).item = publicRead.getName(self.itemInfo[1])
		SoraDShowMsgTip(i18n("Artisan_House_16", nil))
		return
	end
	artisanHouseCtrl:reqPalaceOfCraftsmanUnlock()
	self:removeFromParent()
end
function ArtisanHouseBlessLightPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = SoraDPlaySound
	local SoraDPlaySound.title, param = i18n("Battle_Towers_23"), SoraDPlaySound
	uiManager:show("ArtisanHouseBuffPreview", param):setOwnerKey(self)
end
return ArtisanHouseBlessLightPanel
