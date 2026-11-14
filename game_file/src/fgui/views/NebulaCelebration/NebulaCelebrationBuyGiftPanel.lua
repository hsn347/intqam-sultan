local nebulaCelebrationCtrl = SoraDGetCtrl("nebulaCelebrationCtrl")
local nebulaCelebrationRead = include("nebulaCelebrationRead")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaCelebrationBuyGiftPanel = class("NebulaCelebrationBuyGiftPanel", baseFguiPanel)
function NebulaCelebrationBuyGiftPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("NebulaCelebrationBuyGiftPanel:ctor", self.viewName)
end
function NebulaCelebrationBuyGiftPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Effect_baoxiang"
	end
	return self._packageList
end
function NebulaCelebrationBuyGiftPanel:onInit()
	print("=======NebulaCelebrationBuyGiftPanel:onInit")
	self.fields.Text_title:setString(i18n("Nebula_Celebration_button02"))
	self.fields.Text_gift:setString(i18n("celebrationgift_text_6"))
	self.fields.Text_unlock:setString(i18n("Nebula_Celebration_text05"))
	self.fields.Text_rechargeTip:setString(i18n("common_text_789"))
	self.fields.Button_buy:addClickListener(handler(self, self.onClickBuy))
	self.fields.Button_buyOAP:addClickListener(handler(self, self.onClickBuyOAP))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List1:setItemRenderer(handler(self, self.onItemRenderer1))
	self.controllers.c1:setSelectedIndex(SoraDCheckOAPIsOpen() and 1 or 0)
end
function NebulaCelebrationBuyGiftPanel:onClickBuy()
	SoraDPlaySound()
	if nebulaCelebrationCtrl:isActiveGold() then
		SoraDShowMsgTip(i18n("Nebula_Celebration_text19"))
		return
	end
	nebulaCelebrationCtrl:sendReqBuyGift()
end
function NebulaCelebrationBuyGiftPanel:onClickBuyOAP()
	SoraDPlaySound()
	if nebulaCelebrationCtrl:isActiveGold() then
		SoraDShowMsgTip(i18n("Nebula_Celebration_text19"))
		return
	end
	local rechargeID = nebulaCelebrationRead.getRecharge().RechargeID
	_ENV = i18n("Nebula_Celebration_text19")
	i18n("Nebula_Celebration_text19").fromCenter = gRechargeActiveFromEnum.ROAD32
	SoraDShowH5PurchaseView(rechargeID, nil, i18n("Nebula_Celebration_text19"))
end
function NebulaCelebrationBuyGiftPanel:onItemRenderer(index, obj)
	obj:initData(self.rewardList[2 * index + 1], self.rewardList[2 * index + 2])
end
function NebulaCelebrationBuyGiftPanel:onItemRenderer1(index, obj)
	local data = self.rewardList1[index + 1]
	obj:initData(data.id, data.count)
end
function NebulaCelebrationBuyGiftPanel:onShow()
	print("=======NebulaCelebrationBuyGiftPanel:onShow")
	local rewards = nebulaCelebrationCtrl:getRewardList()
	local _ENV, t = nebulaCelebrationCtrl, nebulaCelebrationCtrl
	local id, num, sortV
	for _, v in ipairs(rewards) do
		for i = 1, #v.seniorReward / 2 do
			id = v.seniorReward[i * 2 - 1]
			num = v.seniorReward[i * 2]
			if not t[id] then
				t[id] = 0
			end
			t[id] = t[id] + num
		end
	end
	local rechargeInfo = nebulaCelebrationRead.getRecharge()
	self.rewardList = rechargeInfo.Rewards
	self.fields.List:setNumItems(#self.rewardList / 2)
	_ENV = 1
	;(1).price = rechargeInfo.Price
	self.fields.Button_buy:setString(i18n("$%{price}", 1))
	self.rewardList1, _ENV = self.fields.Button_buy.setString, self.fields.Button_buy.setString
	for k, v in pairs(t) do
		_ENV = i18n("$%{price}", 1)
		i18n("$%{price}", 1).id = k
		i18n("$%{price}", 1).count = v
		i18n("$%{price}", 1).quality = publicRead.getQuality(k) or 0
		table.insert(self.rewardList1, i18n("$%{price}", 1))
	end
	table.sort(self.rewardList1, function(a, b)
		if a.quality > b.quality then
			return true
		elseif a.quality == b.quality then
			return a.id > b.id
		else
			return false
		end
	end)
	self.fields.List1:setNumItems(#self.rewardList1)
	local rechargeID = rechargeInfo.RechargeID
	local OriginalPrice = rechargeInfo.OriginalPrice
	local price = rechargeInfo.Price
	self.fields.Button_buyOAP:initData(nil, nil, rechargeID)
	local nowPrice = paymentManager.judgePrice(rechargeID, price)
	local discount = OriginalPrice / price
	local oriPrice = paymentManager.calculateDiscount(rechargeID, nowPrice, discount, OriginalPrice)
	self.fields.Button_buy:initData(nowPrice, oriPrice, rechargeID)
end
return NebulaCelebrationBuyGiftPanel
