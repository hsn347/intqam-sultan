local rechargeRead = include("rechargeRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local warOrderCtrl = SoraDGetCtrl("warOrderCtrl")
local warOrderRead = include("warOrderRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local BraqueTestBuyGiftPanel = class("BraqueTestBuyGiftPanel", baseFguiPanel)
function BraqueTestBuyGiftPanel:ctor(...)
	self.super.ctor(self, ...)
	print("BraqueTestBuyGiftPanel:ctor", self.viewName)
end
function BraqueTestBuyGiftPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function BraqueTestBuyGiftPanel:onInit()
	print("=======BraqueTestBuyGiftPanel:onInit")
	self.activityID = self.param and self.param.activityID or gActivityTimeActivityID.WAR_ORDER_ACTIVITY
	self.curCtrl = warOrderCtrl:getCurCtrl(self.activityID)
	self.fields.Text_Title2:setString(i18n("Battle_Towers_30"))
	self.type = math.max(1, self.curCtrl:getBuffTypeEx())
	self.fields.GiftAward:setItemRenderer(handler(self, self.onGiftItemRenderer))
	self.fields.AllSpecialAward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.BuffList:setItemRenderer(handler(self, self.onBuffItemRenderer))
	self.fields.Button_Ques:addClickListener(handler(self, self.onClickQuestion))
	self.fields.Text_Tips = SoraDCreateTimerLabel(self, self.fields.Text_Tips)
	self.fields.Text_Tips:setTimeLast(function(str)
		_ENV = nil
		;(nil).time = str
		return i18n("Braque_text_09", nil)
	end)
	local timer = activityShowCtrl:getTimeInfoByID(self.activityID)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.fields.Text_Tips:beginTime(leftTime)
	end
end
function BraqueTestBuyGiftPanel:onShow()
	print("=======BraqueTestBuyGiftPanel:onShow", self.type)
	_ENV = print
	print[gActivityTimeActivityID.MAGIC_LAMP_ORDER_ACTIVITY] = true
	print[gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY] = true
	local print[gActivityTimeActivityID.NORMAL_ACTIVITY_9001701], config = true, print
	if config[self.activityID] then
		self.fields.Text_Title3:setString(i18n("MagiclampDecree_12"))
	else
		self.fields.Text_Title3:setString(i18n(self.type == 1 and "Braque_text_21" or "Braque_text_22"))
	end
	self:updateView()
end
function BraqueTestBuyGiftPanel:onGiftItemRenderer(index, object)
	object:initData(self.giftAward[index + 1].id, self.giftAward[index + 1].count)
end
function BraqueTestBuyGiftPanel:onItemRenderer(index, object)
	object:initData(self.allSpecialAward[index + 1].id, self.allSpecialAward[index + 1].count)
end
function BraqueTestBuyGiftPanel:onBuffItemRenderer(index, object)
	object:fixChildrenPos()
	object:setIcon(self.buffList[index + 1].EffectIcon)
	object:setText(i18n(self.buffList[index + 1].EffectDescription))
end
function BraqueTestBuyGiftPanel:onTabItemRenderer(index, object)
	print("self.tabDatas[index+1]", self.tabDatas[index + 1])
	object:setString(i18n(self.tabDatas[index + 1].title))
end
function BraqueTestBuyGiftPanel:updateView()
	self.giftInfo = warOrderRead.getGiftAwardInfo(self.activityID, self.type)
	local nowPrice = paymentManager.judgePrice(self.giftInfo.RechargeID, self.giftInfo.Price)
	local discount = self.giftInfo.OriginalPrice / self.giftInfo.Price
	local oriPrice = paymentManager.calculateDiscount(self.giftInfo.RechargeID, nowPrice, discount, self.giftInfo.OriginalPrice)
	warOrderRead = discount
	discount.rid = self.giftInfo.RechargeID
	discount.nowPrice = nowPrice
	warOrderRead, discount.oriPrice = self.giftInfo.RechargeID, oriPrice
	discount.logInfo, self.giftInfo.RechargeID.fromCenter = self.giftInfo.RechargeID, gRechargeActiveFromEnum.ROAD46
	discount.handleBuyClick = handlerEx(self, self.onGuyGift, self.giftInfo.RechargeID)
	discount.handleItemBuyClick = handlerEx(self, self.onGuyGiftByItem, self.giftInfo.RechargeID)
	self.fields.Com_OutAppPurchaseButtons:initData(discount)
	rechargeRead = discount
	discount[1] = "id"
	discount[2] = "count"
	self.allSpecialAward, warOrderRead, self.giftAward = serviceFunctions.tableFormat(self.giftInfo.Rewards, discount), serviceFunctions.tableFormat(self.giftInfo.Rewards, discount), serviceFunctions.tableFormat(self.giftInfo.Rewards, discount)
	self.fields.GiftAward:setNumItems(#self.giftAward)
	self.fields.Text_GoldNum:setString(self.giftInfo.Gold)
	local reward = warOrderRead.getAllAward(self.activityID, self.type, self.giftInfo.RechargeID)
	rechargeRead = self.giftInfo.RechargeID
	self.giftInfo.RechargeID[1] = "id"
	self.giftInfo.RechargeID[2] = "count"
	self.allSpecialAward = serviceFunctions.tableFormat(reward, self.giftInfo.RechargeID)
	self.fields.AllSpecialAward:setNumItems(#self.allSpecialAward)
	local info = rechargeRead.getPageViewData(self.giftInfo.RechargeID)
	self.fields.Text_Title:setString(i18n(info.activeName))
	self.buffList = warOrderRead.getEffectShow(self.activityID, self.giftInfo.RechargeID)
	dump(self.buffList, "self.buffList")
	self.fields.BuffList:setNumItems(#self.buffList)
end
function BraqueTestBuyGiftPanel:onGuyGift(giftId)
	SoraDPlaySound()
	print("giftId", giftId)
	self:buyGift(function()
		SoraDShowLoading()
		paymentManager.normalGiftBuyClassify(giftId)
		paymentManager.OnemtReadyBuy(giftId, gRechargeActiveFromEnum.ROAD46)
		self:removeFromParent()
	end)
end
function BraqueTestBuyGiftPanel:onGuyGiftByItem(giftId)
	print("giftId", giftId)
	self:buyGift(function()
		_ENV, _ENV = nil, nil
		;(nil).fromCenter = gRechargeActiveFromEnum.ROAD46
		SoraDShowH5PurchaseView(giftId, nil, nil)
	end)
	return false
end
function BraqueTestBuyGiftPanel:buyGift(buyHandle)
	_ENV = nil
	_ENV = nil
	;(nil).buildType = BUILD_ENUM.MAGIC_LAMP
	;(nil)[gActivityTimeActivityID.MAGIC_LAMP_ORDER_ACTIVITY], (nil).contentKey = nil, "MagiclampDecree_11"
	_ENV = nil
	;(nil).buildType = BUILD_ENUM.MAGIC_LAMP_HATCH
	;(nil)[gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY], (nil).contentKey = nil, "HatchDecree_text_09"
	_ENV = nil
	;(nil).buildType = BUILD_ENUM.TWO_MAGIC_LAMP
	;(nil)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001701], (nil).contentKey = nil, "MagiclampDecree_11"
	local config
	local cfg = config[self.activityID]
	if cfg then
		local oriLv = self.curCtrl:getInitBuildLv(cfg.buildType)
		local starLvMax = warOrderRead.getStarLvMax(self.activityID)
		if oriLv > starLvMax then
			_ENV = nil
			_ENV = nil
			;(nil).lv = starLvMax
			;(nil).content = i18n(cfg.contentKey, nil)
			;(nil).confirmString = i18n("common_text_490")
			;(nil).cancelString = i18n("common_text_185")
			;(nil).confirmFunc = function()
				self:realBuyGift(buyHandle)
			end
			uiManager:show("MessageBox", nil)
			return
		end
	end
	self:realBuyGift(buyHandle)
end
function BraqueTestBuyGiftPanel:realBuyGift(buyHandle)
	_ENV = nil
	;(nil)[gActivityTimeActivityID.MAGIC_LAMP_ORDER_ACTIVITY] = "MagiclampDecree_10"
	;(nil)[gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY] = "HatchDecree_text_10"
	local (nil)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001701], config = "MagiclampDecree_10", nil
	local contentKey
	if config[self.activityID] then
		contentKey = config[self.activityID]
	else
		contentKey = self.type == 1 and "Braque_text_23" or "Braque_text_24"
	end
	local _eventTime = SoraDGetCtrl("activityShowCtrl"):getTimeInfoByID(self.activityID)
	_ENV = nil
	_ENV = nil
	_ENV, _ENV, (nil).time = _eventTime.timerNode.timer:getRemainTime()
	_ENV, _eventTime.timerNode.timer:getRemainTime().color = _eventTime.timerNode.timer:getRemainTime()
	SoraDConvertSecondToString(_eventTime.timerNode.timer:getRemainTime()).item, _eventTime.timerNode.timer:getRemainTime().__default, _eventTime.timerNode.timer:getRemainTime().color = _eventTime.timerNode.timer:getRemainTime()
	;(nil).content = i18n_html(contentKey, nil, (SoraDConvertSecondToString(_eventTime.timerNode.timer:getRemainTime())))
	;(nil).confirmString = i18n("common_text_282")
	;(nil).cancelString = i18n("common_text_185")
	;(nil).confirmFunc = buyHandle
	uiManager:show("MessageBox", nil)
end
function BraqueTestBuyGiftPanel:onClickQuestion()
	SoraDPlaySound()
	warOrderRead.openSkillBuffView(self.activityID)
end
return BraqueTestBuyGiftPanel
