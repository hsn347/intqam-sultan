local newWeekcardPopView = class("newWeekcardPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("newWeekcardPopView")
	end
	return target
end)
function newWeekcardPopView:ctor()
	self.enableTouchCloseSelf = true
	self:initWidget()
end
function newWeekcardPopView:initWidget()
	local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
	local weekcardData = rechargeActivityCtrl:getNewWeekcardData()
	if not weekcardData then
		print("没有新手周卡数据")
		return
	end
	self.weekcardData = weekcardData
	local Top_Image_close = SoraDGetChildByName(self, "Top_Image_close")
	Top_Image_close:setTouchEnabled(true)
	Top_Image_close:addTouchEventListener(handler(self, self.close))
	local Center_Node = SoraDGetChildByName(self, "Center_Node")
	_UPVALUE1_ = handler(self, self.close)
	handler(self, self.close)[1] = "Node_info"
	local Node_info = SoraDGetChildByFullPath(Center_Node, handler(self, self.close))
	_UPVALUE1_ = "Node_info"
	;("Node_info")[1] = "Text_1"
	SoraDGetChildByFullPath(Node_info, "Node_info"):setString(i18n("mail_weekly_card_title_01"))
	_UPVALUE1_ = i18n("mail_weekly_card_title_01")
	i18n("mail_weekly_card_title_01")[1] = "Text_2"
	SoraDGetChildByFullPath(Node_info, i18n("mail_weekly_card_title_01")):setString(i18n("new_weeklycard_text_02"))
	_ENV = i18n("new_weeklycard_text_02")
	i18n("new_weeklycard_text_02").count = "10%"
	local str = string.format([[
%s
%s]], i18n("common_text_2661", i18n("new_weeklycard_text_02")), i18n("new_weeklycard_text_04"))
	_UPVALUE1_ = i18n("new_weeklycard_text_04")
	i18n("new_weeklycard_text_04")[1] = "Text_3"
	local Text_3 = SoraDGetChildByFullPath(Node_info, i18n("new_weeklycard_text_04"))
	Text_3:setString(str)
	local heigh = SoraDGetAutoHeightLabel(Text_3, 400)
	if 69 < heigh then
		heigh = 69
		SoraDSetTextWidthHeight(Text_3, cc.size(400, heigh))
	end
	_UPVALUE1_ = cc.size(400, heigh)
	cc.size(400, heigh)[1] = "Text_4"
	local Text_4 = SoraDGetChildByFullPath(Node_info, cc.size(400, heigh))
	Text_4:setString(i18n("new_weeklycard_text_05"))
	Text_4:setPositionY(Text_3:getPositionY() - heigh - 4)
	_UPVALUE1_ = Text_3:getPositionY() - heigh - 4
	;(Text_3:getPositionY() - heigh - 4)[1] = "Node_get"
	local Node_get = SoraDGetChildByFullPath(Node_info, Text_3:getPositionY() - heigh - 4)
	_UPVALUE1_ = "Node_get"
	;("Node_get")[1] = "Text_get"
	SoraDGetChildByFullPath(Node_get, "Node_get"):setString(i18n("common_text_4061"))
	SoraDToCenter(Node_get, 10)
	_UPVALUE1_ = 10
	;(10)[1] = "Node_receive"
	local Node_receive = SoraDGetChildByFullPath(Node_info, 10)
	_UPVALUE1_ = "Node_receive"
	;("Node_receive")[1] = "Text_receive"
	SoraDGetChildByFullPath(Node_receive, "Node_receive"):setString(i18n("new_weeklycard_text_03"))
	local itemList = rechargeActivityCtrl:getMonthAwardList(weekcardData.ID)
	local golds = 0
	for k, v in pairs(itemList) do
		if v.id == "1001" then
			golds = v.count
			table.remove(itemList, k)
			break
		end
	end
	_UPVALUE1_ = pairs(itemList)
	pairs(itemList)[1] = "Text_value"
	SoraDGetChildByFullPath(Node_receive, pairs(itemList)):setString(golds)
	SoraDToCenter(Node_receive, 10)
	_UPVALUE1_ = 10
	;(10)[1] = "Node_rewards"
	local Node_rewards = SoraDGetChildByFullPath(Node_info, 10)
	self:showRewards(itemList, Node_rewards)
	_UPVALUE1_ = itemList
	itemList[1] = "Button_buy"
	local Button_buy = SoraDGetChildByFullPath(Center_Node, itemList)
	Button_buy:addTouchEventListener(handler(self, self.onClick_buy))
	local nowPrice = paymentManager.judgePrice(weekcardData.ID, weekcardData.price)
	_UPVALUE2_ = handler(self, self.onClick_buy)
	handler(self, self.onClick_buy)[1] = "Node_charge"
	handler(self, self.onClick_buy)[2] = "Text_nowPrice"
	SoraDGetChildByFullPath(Button_buy, handler(self, self.onClick_buy)):setString(tostring(nowPrice))
	local discount = weekcardData.originalPrice / weekcardData.price
	local oriPrice = paymentManager.calculateDiscount(weekcardData.ID, nowPrice, discount, weekcardData.originalPrice)
	_UPVALUE2_ = discount
	discount[1] = "Node_charge"
	discount[2] = "Text_oriPrice"
	SoraDGetChildByFullPath(Button_buy, discount):setString(tostring(oriPrice))
end
function newWeekcardPopView:onClick_buy(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		paymentManager.normalGiftBuyClassify(self.weekcardData.ID)
		paymentManager.OnemtReadyBuy(self.weekcardData.ID, gRechargeActiveFromEnum.ROAD04, false)
	end
end
function newWeekcardPopView:showRewards(itemList, parent)
	for i, v in ipairs(itemList) do
		local singleItem = include("itemSingleView").new()
		singleItem:setPosition(cc.p(i * 70 - 210, 30))
		singleItem:addTo(parent)
		singleItem:setScale(0.44000000000000006)
		_ENV, _ENV = cc.p(i * 70 - 210, 30)
		cc.p(i * 70 - 210, 30).id = v.id
		;(0.44000000000000006).itemData, cc.p(i * 70 - 210, 30).count = cc.p(i * 70 - 210, 30)
		singleItem:initData(0.44000000000000006)
		singleItem:setButtonTag(v.id)
		singleItem:setItemClickCallback(function(button, type)
			if type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
				SoraDPlaySound()
				SoraDCloseCommonTips()
			elseif type == ccui.TouchEventType.began then
				SoraDShowCommonTips(button, button:getTag())
			end
		end)
	end
end
return newWeekcardPopView
