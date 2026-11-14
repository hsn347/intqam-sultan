local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local dailyDiscountGiftCtrl = gametop.playertop_:getModule("dailyDiscountGiftCtrl")
local rechargeRead = include("rechargeRead")
local rechargeViewDailyDisNode = class("rechargeViewDailyDisNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("rechargeViewDailyDisNode")
	end
	return target
end)
function rechargeViewDailyDisNode:ctor()
	self.giftItemOcxs, _ENV = nil, nil
	self.payType = 1
	self.superRID = nil
	self.buyStatus = 0
	self.Text_title = SoraDGetChildByName(self, "Text_title")
	self.Text_title:setString(i18n("spcial_office_name_01"))
	self.Image_dailyDisHead = SoraDGetChildByName(self, "Image_dailyDisHead")
	self.Text_treasury_label = SoraDGetChildByName(self, "Text_treasury_label")
	self.Text_treasury_label:setString(i18n("spcial_office_text_01"))
	self.Image_goldTextBg = SoraDGetChildByName(self, "Image_goldTextBg")
	self.sprite_box = SoraDGetChildByName(self, "Sprite_box")
	self.node_box_bg_effect = SoraDGetChildByName(self, "Node_box_bg_effect")
	self.node_box_top_effect_reset = SoraDGetChildByName(self, "Node_box_top_effect_reset")
	self.node_box_top_effect = SoraDGetChildByName(self, "Node_box_top_effect")
	self.labelDailyTreasuryAlter = SoraDGetChildByName(self, "Text_head_treasury_alter")
	self.labelDailyLeftTime = SoraDGetChildByName(self, "Text_daily_left_time")
	self.labelDailyLeftTime = SoraDCreateTimerLabel(self, self.labelDailyLeftTime)
	self.LoadingBar = SoraDGetChildByName(self, "LoadingBar")
	self.labelProgressBar = SoraDGetChildByName(self, "Text_progressBar")
	self.dailyDiscountScroll = SoraDGetChildByName(self, "ScrollView_dailyDisGiftsList")
	self.dailyDiscountScroll:setContentSize(cc.size(620, display.height - 730))
	self.dailyDiscountScroll = include("commonAutoScrollList").new(self.dailyDiscountScroll)
	self.dailyDiscountScroll:setSingleCCS("rechargeGiftItem")
	self.dailyDiscountScroll:setVisbileShowScale(2.0, 2.0)
	self.btnFreeGift = SoraDGetChildByName(self, "Button_freeGifts")
	self.btnSpecialGift = SoraDGetChildByName(self, "Button_specialGift")
	self.dailyDiscountGiftData = dailyDiscountGiftCtrl.dailyDiscountGiftData
	self.isActivityOpen = activityShowCtrl:isActivityOpen(gActivityTimeActivityID.DAILY_DISCOUNT_GIFT_ACTIVITY)
	self.dailyFreeAward = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_rechargeFreeAward_node")
	local isReceiveFreeGift = serviceFunctions.isSameDay(self.dailyDiscountGiftData.freeGiftTime)
	if self.dailyFreeAward then
		self.dailyFreeAward:updateData(true, not isReceiveFreeGift)
		self.dailyFreeAward:setTouchEventListener(handler(self, self.btnClickFreeGifts))
	end
	self.Node_effect = SoraDGetChildByName(self, "Node_effect")
	SoraDCreatAnimation("animationMRTH"):addTo(self.Node_effect)
	self.btnFreeGift:addTouchEventListener(handler(self, self.btnClickFreeGifts))
	self.btnSpecialGift:addTouchEventListener(handler(self, self.btnClickSpecialGifts))
	self.ccs_first = SoraDGetExtendChildFromCCSByName(self, "CCS_rechargeFirstAward_node")
	self.Node_superDis = SoraDGetChildByName(self, "Node_superDis")
	self.Node_superDis:setPositionY(-display.height + 155)
	self.Button_buy = SoraDGetChildByName(self.Node_superDis, "Button_buy")
	self.Button_buy:addTouchEventListener(handler(self, self.onClickBuy))
	self.OAPButton = SoraDGetExtendChildFromCCSByName(self.Node_superDis, "CCS_OAPButton")
	self.OAPButton:addTouchEventListener(handler(self, self.onClickBuy))
	self.ccs_tabOAP = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_OAP")
	self.ccs_tabOAP:setContentSize(cc.size(640, 56))
	self.ccs_tabOAP:setNewStyle()
	_ENV = cc.size(640, 56)
	_ENV, _ENV, cc.size(640, 56).tabNum = cc.size(640, 56)
	cc.size(640, 56).title = i18n("common_text_4617")
	cc.size(640, 56).tag = 1
	_ENV, cc.size(640, 56)[1], cc.size(640, 56).handle = cc.size(640, 56)
	_ENV = self.clickOAPTab
	self.clickOAPTab.item = include("publicRead").getName(TOKEN_ITEM)
	cc.size(640, 56).title = i18n("common_text_4618", self.clickOAPTab)
	cc.size(640, 56).tag = 2
	cc.size(640, 56).tabsetArray, cc.size(640, 56)[2], cc.size(640, 56).handle = cc.size(640, 56)
	self.ccs_tabOAP:initView(cc.size(640, 56))
	self:updateOutAppPurchase()
	self:initDailyDiscountPage()
end
function rechargeViewDailyDisNode:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_DAILYFREEGIFT_REFRESH", handler(self, self.initCommonLayout))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_DAILYSPECIALGIFT_REFRESH", handler(self, self.initCommonLayout))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_DAILYSPECIALGIFTBUY_REFRESH", handler(self, self.initDailyDiscountPage))
end
function rechargeViewDailyDisNode:refleshNeededData()
	self.dailyDiscountGiftData = dailyDiscountGiftCtrl.dailyDiscountGiftData
	self.isActivityOpen = activityShowCtrl:isActivityOpen(gActivityTimeActivityID.DAILY_DISCOUNT_GIFT_ACTIVITY)
end
function rechargeViewDailyDisNode:hasBoughtGreat(buyGiftList, giftData)
	local ret = false
	for k, v in pairs(buyGiftList) do
		if giftData[k] and giftData[k].isGreat == 1 then
			ret = true
			break
		end
	end
	return ret
end
function rechargeViewDailyDisNode:getTableLength(_table, noGreat)
	local leng = 0
	if _table == nil then
		return leng
	end
	for k, v in pairs(_table) do
		if noGreat then
			if v.isGreat == 0 then
				leng = leng + 1
			end
		else
			leng = leng + 1
		end
	end
	return leng
end
function rechargeViewDailyDisNode:setHandle(handle)
	self.changeRedPoint = handle
end
function rechargeViewDailyDisNode:btnClickFreeGifts(button, eventType, notSound)
	if eventType == ccui.TouchEventType.ended then
		if not notSound then
			SoraDPlaySound()
		end
		if self.isActivityOpen then
			local receiveTime = self.dailyDiscountGiftData.freeGiftTime
			if receiveTime ~= 0 and serviceFunctions.isSameDay(receiveTime) then
				local panel = SoraDCreatePanel("rechargeDailyPopView")
				_ENV = "rechargeDailyPopView"
				;("rechargeDailyPopView").content = i18n("spcial_office_text_02")
				if not dailyDiscountGiftCtrl:getFreeGiftData() then
					_ENV = dailyDiscountGiftCtrl:getFreeGiftData()
				end
				;("rechargeDailyPopView").giftsData = dailyDiscountGiftCtrl:getFreeGiftData()
				;("rechargeDailyPopView").receiveTime = receiveTime
				local ("rechargeDailyPopView").curType, data = "free", "rechargeDailyPopView"
				panel:initData(data)
				panel:show()
			else
				dailyDiscountGiftCtrl:receiveGift(gCmd.REQ_RECEIVE_FREE_GIFT)
			end
		else
			SoraDShowMsgTip(i18n("common_text_2486"))
		end
	end
end
function rechargeViewDailyDisNode:btnClickSpecialGifts(button, eventType, notSound)
	if eventType == ccui.TouchEventType.ended then
		if self.isActivityOpen then
			if not notSound then
				SoraDPlaySound()
			end
			local panel = SoraDCreatePanel("rechargeDailyPopView")
			local _maxValue = self:getTableLength(self.dailyDiscountGiftData.giftData, true)
			local _ENV, _curValue = self, self:hasBoughtGreat(self.dailyDiscountGiftData.buyGiftList, self.dailyDiscountGiftData.giftData) and _maxValue or self:getTableLength(self.dailyDiscountGiftData.buyGiftList)
			self.content = i18n("spcial_office_text_03")
			if not dailyDiscountGiftCtrl:getspecialGiftData() then
				_ENV = dailyDiscountGiftCtrl:getspecialGiftData()
			end
			self.giftsData = dailyDiscountGiftCtrl:getspecialGiftData()
			self.receiveTime = self.dailyDiscountGiftData.rewardGiftTime
			self.curType = "special"
			local self.buyGiftCount, data = _curValue, self
			panel:initData(data)
			panel:show()
		else
			SoraDShowMsgTip(i18n("common_text_2486"))
		end
	end
end
function rechargeViewDailyDisNode:onClickBuy(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.buyStatus == 0 then
			if activityShowCtrl:isActivityOpen(gActivityTimeActivityID.DAILY_DISCOUNT_GIFT_ACTIVITY) then
				if SoraDCheckOAPIsOpen(self.superRID) and self.payType == 2 then
					SoraDShowH5PurchaseView(self.superRID, param)
				else
					paymentManager.normalGiftBuyClassify(self.superRID)
				end
			else
				SoraDShowMsgTip(i18n("common_text_2486"))
			end
		elseif self.buyStatus == 1 then
			SoraDShowMsgTip(i18n("recharge_special_003"))
		end
	end
end
function rechargeViewDailyDisNode:initCommonLayout()
	self:refleshNeededData()
	local treasureOpen = function(isRefresh)
		if isRefresh == true then
			self.node_box_bg_effect:setVisible(false)
			self.node_box_top_effect_reset:setVisible(false)
			self.node_box_top_effect:setVisible(false)
			self.sprite_box:stopAllActionsByTag(99)
			return
		end
		local actionDelay = cca.delay(0.15)
		local actionParticle = cca.callFunc(function()
			self.node_box_bg_effect:setVisible(true)
			SoraDResetEffectNode(self.node_box_bg_effect)
			self.node_box_top_effect_reset:setVisible(true)
			SoraDResetEffectNode(self.node_box_top_effect_reset)
			self.node_box_top_effect:setVisible(true)
			SoraDResetEffectNode(self.node_box_top_effect)
		end)
		_UPVALUE2_ = nil
		;(nil)[1] = actionDelay
		;(nil)[2] = actionParticle
		local seqPar = cca.seq(nil)
		seqPar:setTag(99)
		self.sprite_box:stopAllActionsByTag(99)
		self.sprite_box:runAction(seqPar)
	end
	local buyGiftList = self.dailyDiscountGiftData.buyGiftList
	local _maxValue = self:getTableLength(self.dailyDiscountGiftData.giftData, true)
	local _curValue = self:hasBoughtGreat(buyGiftList, self.dailyDiscountGiftData.giftData) and _maxValue or self:getTableLength(buyGiftList)
	local giftID = dailyDiscountGiftCtrl:getFirstGiftID()
	self.Image_dailyDisHead:loadTexture(rechargeRead.getRechargePopBg(giftID), ccui.TextureResType.plistType)
	local leftTime = self.dailyDiscountGiftData.nextRefreshTime - serviceFunctions.systemTime()
	self.labelDailyLeftTime:beginTime(leftTime)
	_ENV = nil
	;(nil).member = _curValue
	;(nil).total = _maxValue
	self.labelProgressBar:setString(i18n("common_text_155", nil))
	local isReceiveFreeGift = serviceFunctions.isSameDay(self.dailyDiscountGiftData.freeGiftTime)
	local isReceiveSpecialGift = serviceFunctions.isSameDay(self.dailyDiscountGiftData.rewardGiftTime)
	local color = cc.c3b(255, 255, 255)
	local state = 1
	if isReceiveFreeGift == false then
		state = 0
		self.labelDailyTreasuryAlter:setString(i18n("common_text_4374"))
		self.dailyFreeAward:updateData(true, not isReceiveFreeGift)
	else
		color = cc.c3b(145, 145, 145)
		self.labelDailyTreasuryAlter:setString(i18n("common_text_4375"))
		self.dailyFreeAward:updateData(false)
	end
	if self.changeRedPoint then
		self.changeRedPoint(not isReceiveFreeGift, not isReceiveSpecialGift and _maxValue == _curValue)
	end
	self.labelDailyTreasuryAlter:setColor(color)
	self.Image_goldTextBg:getVirtualRenderer():setState(state)
	if _curValue == _maxValue and not isReceiveSpecialGift then
		treasureOpen(false)
	elseif isReceiveSpecialGift then
		treasureOpen(true)
		self.sprite_box:setSpriteFrame("icon_king_road_box_02.png")
	end
	local percent = _curValue * 100 / _maxValue
	self.LoadingBar:setPercent(percent)
end
function rechargeViewDailyDisNode:initDailyDiscountPage()
	self:initCommonLayout()
	local _ENV, sortedGiftsData = self.initCommonLayout, self.initCommonLayout
	local _ENV, superGiftData = self, self
	local endIdx, beginIdx = self:getTableLength(self.dailyDiscountGiftData.giftData), 1
	local buyGiftList = self.dailyDiscountGiftData.buyGiftList
	local _ENV, priceOrder
	local curPrice, preIndex = 0
	for k, v in pairs(self.dailyDiscountGiftData.giftData) do
		_ENV = nil
		;(nil).id = k
		;(nil).price = v.price
		table.insert(priceOrder, nil)
	end
	table.sort(priceOrder, function(a, b)
		if a and b then
			return a.price < b.price
		end
		return false
	end)
	local _ENV, rechargeIDList = table.sort, table.sort
	for k, v in pairs(self.dailyDiscountGiftData.giftData) do
		local price = paymentManager.judgePrice(k, v.price)
		local discount = tonumber(v.originalPrice) / tonumber(v.price)
		local oriShowPrice = paymentManager.calculateDiscount(k, price, discount, v.originalPrice)
		local originalPrice = oriShowPrice
		v.originalPriceForDollar = originalPrice
		v.priceForDollar = price
		v.id = k
		if buyGiftList[k] and 0 < buyGiftList[k] then
			v.state = 1
		end
		local giftStyle = rechargeRead.getPageViewData(k)
		v.titleName = i18n(giftStyle.activeName)
		if v.isGreat ~= 0 then
			superGiftData = v
			self.superRID = v.rechargeID
		else
			for _k, _v in ipairs(priceOrder) do
				if _v.id == k then
					sortedGiftsData[_k] = v
				end
			end
		end
		_ENV = ipairs(priceOrder)
		ipairs(priceOrder).rechargeID = tonumber(k)
		ipairs(priceOrder).cost = v.price
		table.insert(rechargeIDList, ipairs(priceOrder))
	end
	local singleH = display.height > 960 and 210 or 190
	_ENV = tonumber(v.originalPrice) / tonumber(v.price)
	;(tonumber(v.originalPrice) / tonumber(v.price)).scroll = self.dailyDiscountScroll
	;(tonumber(v.originalPrice) / tonumber(v.price)).view = self:getParent()
	;(tonumber(v.originalPrice) / tonumber(v.price)).hasBuySuper = buyGiftList[tostring(self.superRID)]
	;(tonumber(v.originalPrice) / tonumber(v.price)).payType = self.payType
	self.dailyDiscountScroll:updateScrollView(cc.size(620, singleH), sortedGiftsData, 1, tonumber(v.originalPrice) / tonumber(v.price))
	table.sort(rechargeIDList, function(l, r)
		if l.cost ~= r.cost then
			return l.cost < r.cost
		else
			return l.rechargeID < r.rechargeID
		end
	end)
	dump(rechargeIDList, "rechargeIDList===")
	SoraDCreateRechargeGiftNode(rechargeIDList, SoraDGetChildByName(self, "Node_dailyDis_top"), cc.p(286, -231), 0.9, 2)
	if buyGiftList[tostring(self.superRID)] then
		self.Button_buy:setBright(false)
		self.Button_buy:setEnabled(false)
		self.Button_buy:setTitleText(i18n("common_text_4376"))
		self.buyStatus = 2
	else
		self.Button_buy:setTitleText(superGiftData.priceForDollar)
		if 0 < table.nums(buyGiftList) then
			self.Button_buy:setBright(false)
			self.Button_buy:setEnabled(true)
			self.buyStatus = 1
		else
			self.Button_buy:setBright(true)
			self.Button_buy:setEnabled(true)
			self.buyStatus = 0
		end
	end
	if SoraDCheckOAPIsOpen(self.superRID) and self.buyStatus == 0 then
		self.OAPButton:setVisible(true)
		self.Button_buy:setVisible(false)
		_ENV = false
		;(false).payType = self.payType
		;(false).rid = self.superRID
		;(false).nowPrice = superGiftData.priceForDollar
		;(false).oriPrice = superGiftData.originalPriceForDollar
		self.OAPButton:initData(false)
		SoraDGetChildByName(self.Node_superDis, "Text_superOriPrice"):setVisible(false)
	else
		self.OAPButton:setVisible(false)
		self.Button_buy:setVisible(true)
		SoraDGetChildByName(self.Node_superDis, "Text_superOriPrice"):setVisible(self.buyStatus ~= 2)
	end
	self:setSuperGiftInfo(superGiftData)
	print("self.buyStatus====", self.buyStatus)
end
function rechargeViewDailyDisNode:setSuperGiftInfo(data)
	local Text_superSale = SoraDGetChildByName(self.Node_superDis, "Text_superSale")
	local Text_superName = SoraDGetChildByName(self.Node_superDis, "Text_superName")
	local Text_superDes1 = SoraDGetChildByName(self.Node_superDis, "Text_superDes1")
	local Text_superDes2 = SoraDGetChildByName(self.Node_superDis, "Text_superDes2")
	local Text_superOriPrice = SoraDGetChildByName(self.Node_superDis, "Text_superOriPrice")
	Text_superSale:setString(tostring(math.floor(data.originalPrice / data.price * 100)) .. "%")
	local info = rechargeRead.getPageViewData(data.rechargeID)
	Text_superName:setString(i18n(info.activeName))
	Text_superDes1:setString(i18n("recharge_special_001"))
	Text_superDes2:setString(i18n("recharge_special_002"))
	Text_superOriPrice:setString(data.originalPriceForDollar)
end
function rechargeViewDailyDisNode:checkIsNeedRedPoint()
	self.dailyDiscountGiftData = dailyDiscountGiftCtrl.dailyDiscountGiftData
	local _maxValue = self:getTableLength(self.dailyDiscountGiftData.giftData)
	local _curValue = self:getTableLength(self.dailyDiscountGiftData.buyGiftList)
	local isReceiveFreeGift = serviceFunctions.isSameDay(self.dailyDiscountGiftData.freeGiftTime)
	local isReceiveSpecialGift = serviceFunctions.isSameDay(self.dailyDiscountGiftData.rewardGiftTime)
	local isNeedRecSpeGift = not isReceiveSpecialGift and _maxValue == _curValue
	return not isReceiveFreeGift or isNeedRecSpeGift
end
function rechargeViewDailyDisNode:updateOutAppPurchase()
	print("updateOutAppPurchase======", self.superRID)
	if SoraDCheckOAPIsOpen(self.superRID) then
		self.ccs_tabOAP:setVisible(true)
		self.dailyDiscountScroll:setPositionY(self.ccs_tabOAP:getPositionY() - 24)
		self.dailyDiscountScroll:setContentSize(cc.size(620, display.height - 730 - 56))
	else
		self.ccs_tabOAP:setVisible(false)
	end
end
function rechargeViewDailyDisNode:clickOAPTab(tag)
	self.payType = tag
	self:initDailyDiscountPage()
end
return rechargeViewDailyDisNode
