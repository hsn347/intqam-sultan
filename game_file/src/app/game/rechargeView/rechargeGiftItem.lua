local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local MAX_SHOW_NUM = 5
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local rechargeGiftItem = class("rechargeGiftItem", function(target)
	local targetType = type(target)
	if targetType == "nil" then
		return SoraDCreateBasePanel("rechargeGiftItem")
	elseif targetType == "userdata" then
		return SoraDCreateCloneBasePanel(target, "rechargeGiftItem")
	else
		return target
	end
end)
function rechargeGiftItem:ctor()
	self.tableItem, _ENV = nil, nil
	self.Text_gift_name = SoraDGetChildByName(self, "Text_gift_name")
	self.Text_forSales = SoraDGetChildByName(self, "Text_forSales")
	self.Button_buy = SoraDGetChildByName(self, "Button_buy")
	self.Button_buy = include("commonBtnInstance").new(self.Button_buy)
	self.Button_buy:setHandle(handler(self, self.onClickBuy))
	self.Button_buy:setSwallowTouches(false)
	self.Text_brfore_price = SoraDGetChildByName(self, "Text_brfore_price")
	self.Node_items = SoraDGetChildByName(self, "Node_items")
	self.listscroll = SoraDGetChildByName(self, "ScrollView_list")
	self.listscroll = include("commonScrollView").new(self.listscroll)
	self.arrow = SoraDGetChildByName(self, "Bottom_frame_arrow")
	self.listscroll:setScrollMoveFun(function(img, eventType)
		local offset = self.listscroll:getInnerContainerPosition()
		local max = -(self.listscroll:getInnerContainerSize().width - self.listscroll:getContentSize().width)
		if max < offset.x and offset.x < 0 then
			self.arrow:setVisible(true)
		else
			self.arrow:setVisible(false)
			if SoraDFIsRA() and offset.x == max then
				self.arrow:setVisible(true)
			end
			if not SoraDFIsRA() and offset.x == 0 then
				self.arrow:setVisible(true)
			end
		end
	end)
	self.arrow:setVisible(false)
	self.giftData, _ENV = self.arrow.setVisible, self.arrow.setVisible
	self.OAPButton = SoraDGetExtendChildFromCCSByName(self, "CCS_OAPButton")
	self.OAPButton:setHandle(handler(self, self.onClickBuy))
end
function rechargeGiftItem:initData(data, otherData)
	self.giftData = data
	self.view = otherData.view
	self.scroll = otherData.scroll
	self.hasBuySuper = otherData.hasBuySuper
	self.payType = otherData.payType
	self.Button_buy:setTitleText(data.priceForDollar)
	self.Button_buy:setTitleColor(cc.c3b(255, 255, 255))
	self.Button_buy:setScroll(self.scroll)
	self.Text_brfore_price:setString(data.originalPriceForDollar)
	self.Text_gift_name:setString(data.titleName)
	self.Text_forSales:setString(tostring(math.floor(data.originalPrice / data.price * 100)) .. "%")
	_UPVALUE2_ = tostring(math.floor(data.originalPrice / data.price * 100)) .. "%"
	;(tostring(math.floor(data.originalPrice / data.price * 100)) .. "%")[1] = "id"
	;(tostring(math.floor(data.originalPrice / data.price * 100)) .. "%")[2] = "count"
	local giftsData = serviceFunctions.tableFormat(data.gift, tostring(math.floor(data.originalPrice / data.price * 100)) .. "%")
	if data.state == 1 then
		self.Text_brfore_price:setVisible(false)
		self.Button_buy:setTitleText(i18n("common_text_4376"))
		self.Button_buy:setTitleColor(cc.c3b(160, 160, 160))
		self.Button_buy:setTouchEnabled(false)
		self.Button_buy:setBright(false)
	else
		self.Text_brfore_price:setVisible(true)
		self.Button_buy:setTouchEnabled(true)
		self.Button_buy:setBright(true)
		if self.hasBuySuper then
			self.Button_buy:setBright(false)
		end
	end
	if SoraDCheckOAPIsOpen(self.giftData.rechargeID) and data.state ~= 1 then
		self.OAPButton:setVisible(true)
		self.Button_buy:setVisible(false)
		local itemNeedNum = paymentManager.rid2TokenPirce(self.giftData.rechargeID)
		local discount = SoraDGetCtrl("rechargeExchangeCtrl"):getDiscount()
		local nowPrice = math.ceil(discount / 100 * itemNeedNum)
		_ENV = cc.c3b(160, 160, 160)
		cc.c3b(160, 160, 160).payType = self.payType
		cc.c3b(160, 160, 160).rid = self.giftData.rechargeID
		cc.c3b(160, 160, 160).nowPrice = data.priceForDollar
		cc.c3b(160, 160, 160).oriPrice = data.originalPriceForDollar
		self.OAPButton:initData(cc.c3b(160, 160, 160))
		self.Text_brfore_price:setVisible(false)
	else
		self.OAPButton:setVisible(false)
		self.Button_buy:setVisible(true)
		self.Text_brfore_price:setVisible(false)
	end
	for i, v in ipairs(self.tableItem) do
		v:setVisible(false)
	end
	for i, item in ipairs(giftsData) do
		if not self.tableItem[i] then
			self.tableItem[i] = include("commonItemAward").new()
			self.tableItem[i]:setScale(0.7)
			self.tableItem[i]:setBaseScale(1.0)
			self.tableItem[i]:addTo(self.Node_items)
		end
		self.tableItem[i]:setVisible(true)
		self.tableItem[i]:setOwnView(display.getRunningScene())
		self.tableItem[i]:setOwnScroll(self.listscroll)
		self.tableItem[i]:initData(item.id, item.count)
		self.tableItem[i]:setPosition(SoraDFPosX(80 - 80 * i, 0), 0)
	end
	self.listscroll:setInnerContainerSize(cc.size(#giftsData * 80, 88))
	if SoraDFIsRA() then
		self.Node_items:setPositionX(#giftsData * 80 - 40)
		self.listscroll:jumpToRight()
	else
		self.listscroll:jumpToLeft()
	end
	self.arrow:setVisible(self.listscroll:getInnerContainerSize().width > self.listscroll:getContentSize().width)
end
function rechargeGiftItem:onClickBuy(button, event)
	if self.hasBuySuper then
		SoraDShowMsgTip(i18n("recharge_special_004"))
	elseif activityShowCtrl:isActivityOpen(gActivityTimeActivityID.DAILY_DISCOUNT_GIFT_ACTIVITY) then
		SoraDShowMsgBox(i18n("recharge_special_005"), i18n("common_text_054"), nil, function(event)
			if event == MSGBOX_CALLBACK_YES then
				if SoraDCheckOAPIsOpen(self.giftData.rechargeID) and self.payType == 2 then
					SoraDShowH5PurchaseView(self.giftData.rechargeID)
				else
					paymentManager.normalGiftBuyClassify(self.giftData.rechargeID)
				end
			end
		end)
	else
		SoraDShowMsgTip(i18n("common_text_2486"))
	end
end
return rechargeGiftItem
