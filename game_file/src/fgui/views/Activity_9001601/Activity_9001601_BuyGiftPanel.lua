local activity_9001601_Read = include("activity_9001601_Read")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activity_9001601_Ctrl = SoraDGetCtrl("activity_9001601_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001601_BuyGiftPanel = class("Activity_9001601_BuyGiftPanel", baseFguiPanel)
function Activity_9001601_BuyGiftPanel:ctor(...)
	Activity_9001601_BuyGiftPanel.super.ctor(self, ...)
	print("Activity_9001601_BuyGiftPanel:ctor", self.viewName)
end
function Activity_9001601_BuyGiftPanel:onInit()
	print("=======Activity_9001601_BuyGiftPanel:onInit")
	self.giftType = self.param and self.param.giftType or 1
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001601
	if self.fields.Text_title1 then
		self.fields.Text_title1 = SoraDCreateTimerLabel(self, self.fields.Text_title1)
		self.fields.Text_title1:setTimeLast(function(timeStr)
			_ENV = nil
			;(nil).time = timeStr
			return i18n("Braque_text_09", nil)
		end)
	end
	if self.fields.Button_help then
		self.fields.Button_help:addClickListener(handler(self, self.onClickBtnHelp))
	end
	if self.fields.List_buff then
		self.fields.List_buff:setItemRenderer(handler(self, self.onBuffItemRenderer))
	end
	self.fields.Text_title2:setString(i18n("Battle_Towers_30"))
	self.fields.List_reward1:setItemRenderer(handler(self, self.onItemRenderer1))
	self.fields.List_reward2:setItemRenderer(handler(self, self.onItemRenderer2))
end
function Activity_9001601_BuyGiftPanel:onShow()
	print("=======Activity_9001601_BuyGiftPanel:onShow")
	self:updateView()
end
function Activity_9001601_BuyGiftPanel:onClickBtnHelp()
	SoraDPlaySound()
	local warOrderRead = include("warOrderRead")
	warOrderRead.openSkillBuffView(self.activityID)
end
function Activity_9001601_BuyGiftPanel:onBuffItemRenderer(index, obj)
	if not SoraDFIsRA() then
		obj:fixChildrenPos()
	end
	local cfg = self.buffList[index + 1]
	obj:setIcon(cfg.effectIcon)
	obj:setText(i18n(cfg.effectDescription))
end
function Activity_9001601_BuyGiftPanel:onItemRenderer1(index, obj)
	local cfg = self.rewardList1[index + 1]
	obj:initData(cfg.id, cfg.count)
end
function Activity_9001601_BuyGiftPanel:onItemRenderer2(index, obj)
	local cfg = self.rewardList2[index + 1]
	obj:initData(cfg.id, cfg.count)
end
function Activity_9001601_BuyGiftPanel:updateView()
	local giftInfo = activity_9001601_Read.getGiftInfo(self.giftType)
	local rechargeID = giftInfo.rechargeID
	self.fields.Text_title:setString(i18n(giftInfo.rechargeName))
	if self.fields.Text_title1 then
		local remainTime = activityShowCtrl:getRemainTime(self.activityID)
		if remainTime and 0 < remainTime then
			self.fields.Text_title1:beginTime(remainTime)
		end
	end
	if self.giftType == 1 then
		self.fields.Text_title3:setString(i18n("ramadan_bless_text_03"))
		self.fields.Text_tip:setString(i18n("ramadan_bless_text_06"))
	elseif self.giftType == 2 then
		self.fields.Text_title3:setString(i18n("ramadan_bless_text_04"))
		self.fields.Text_tip:setString(i18n("ramadan_bless_text_07"))
	end
	if self.fields.List_buff then
		self.buffList = activity_9001601_Read.getGiftBuffShowList(rechargeID)
		self.fields.List_buff:setNumItems(#self.buffList)
	end
	self.fields.Text_GoldNum:setString(giftInfo.gold)
	activityShowCtrl = giftInfo.gold
	giftInfo.gold[1] = "id"
	giftInfo.gold[2] = "count"
	self.rewardList1 = serviceFunctions.tableFormat(giftInfo.reward, giftInfo.gold)
	self.fields.List_reward1:setNumItems(#self.rewardList1)
	self.rewardList2 = activity_9001601_Read.getAllAward(self.giftType)
	self.fields.List_reward2:setNumItems(#self.rewardList2)
	local nowPrice = paymentManager.judgePrice(rechargeID, giftInfo.rechargePrice)
	local discount = giftInfo.originalPrice / giftInfo.rechargePrice
	local oriPrice = paymentManager.calculateDiscount(rechargeID, nowPrice, discount, giftInfo.originalPrice)
	activity_9001601_Read = discount
	discount.rid = rechargeID
	discount.nowPrice = nowPrice
	activity_9001601_Read, discount.oriPrice = giftInfo.originalPrice, oriPrice
	discount.logInfo, giftInfo.originalPrice.fromCenter = giftInfo.originalPrice, gRechargeActiveFromEnum.ROAD46
	discount.handleBuyClick = handlerEx(self, self.onGuyGift, rechargeID)
	discount.handleItemBuyClick = handlerEx(self, self.onGuyGiftByItem, rechargeID)
	self.fields.Com_recharge:initData(discount)
end
function Activity_9001601_BuyGiftPanel:onGuyGift(giftId)
	print("==Activity_9001601_BuyGiftPanel:onGuyGift==", giftId)
	SoraDPlaySound()
	if self.giftType == 2 and not activity_9001601_Ctrl:checkGiftTypeUnlock(self.giftType) then
		SoraDShowMsgTip(i18n("ramadan_bless_text_05"))
		return
	end
	paymentManager.normalGiftBuyClassify(giftId)
	paymentManager.OnemtReadyBuy(giftId, gRechargeActiveFromEnum.ROAD46)
	self:removeFromParent()
end
function Activity_9001601_BuyGiftPanel:onGuyGiftByItem(giftId)
	print("==Activity_9001601_BuyGiftPanel:onGuyGiftByItem==", giftId)
	if self.giftType == 2 and not activity_9001601_Ctrl:checkGiftTypeUnlock(self.giftType) then
		SoraDShowMsgTip(i18n("ramadan_bless_text_05"))
		return
	end
	_ENV, _ENV = i18n("ramadan_bless_text_05")
	i18n("ramadan_bless_text_05").fromCenter = gRechargeActiveFromEnum.ROAD46
	SoraDShowH5PurchaseView(giftId, i18n("ramadan_bless_text_05"))
end
return Activity_9001601_BuyGiftPanel
