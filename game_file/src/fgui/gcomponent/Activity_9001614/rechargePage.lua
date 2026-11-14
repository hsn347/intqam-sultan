local rechargeRead = include("rechargeRead")
local baseComponent = require("fgui.base.baseComponent")
local rechargePage = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001614/rechargePage", rechargePage)
function rechargePage:onInit()
	self.itemList, _ENV, self.index = nil, nil, 1
	self.fields.Text_gold:setAlign(0)
	self.fields.List_items:setVirtual()
	self.fields.List_items:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_buy:addClickListener(handler(self, self.btnBuyClick))
	self.fields.rechargeGift:fixPos()
	self.fields.rechargeGift:fixNodePos()
	self.fields.Text_discount:fixPos()
end
function rechargePage:onShow()
end
function rechargePage:onItemRenderer(index, obj)
	obj:initData(self.itemList[index + 1], index + 1)
end
function rechargePage:initData(giftList, isInit)
	self.giftList = giftList
	self.tabsetArray, _ENV, self.index = isInit and 1 or self.index, isInit and 1 or self.index, isInit and 1 or self.index
	for k, v in ipairs(self.giftList) do
		local showPrice, isGetPrice = paymentManager.judgePrice(v.rechargeid, v.rechargePrice)
		_ENV = nil
		;(nil).title = showPrice
		;(nil).tag = k
		table.insert(self.tabsetArray, nil)
	end
	_ENV = ipairs(self.giftList)
	ipairs(self.giftList).defaultClick = self.index
	ipairs(self.giftList).tabsetArray = self.tabsetArray
	ipairs(self.giftList).callback = handler(self, self.onTabClick)
	self.fields.Tab_price:initView(ipairs(self.giftList))
end
function rechargePage:onTabClick(tag)
	self.index = tag
	self.giftData = self.giftList[self.index]
	self:initView()
end
function rechargePage:initView()
	local giftStyle = rechargeRead.getPageViewData(self.giftData.rechargeid)
	self.fields.Text_title:setString(i18n(giftStyle.activeName))
	self.fields.icon:setSpriteFrame(giftStyle.popBanner)
	if giftStyle.activeExplain ~= "" then
		if type(giftStyle.activeExplain) == "string" then
			self.fields.Text_giftTip:setString(i18n(giftStyle.activeExplain))
		elseif type(giftStyle.activeExplain) == "table" then
			if next(giftStyle.activeExplain) then
				self.fields.Text_giftTip:setString(i18n(giftStyle.activeExplain))
			else
				self.fields.Text_giftTip:setString("")
			end
		end
	else
		self.fields.Text_giftTip:setString("")
	end
	self.fields.Text_tip:setString(i18n("common_text_789"))
	rechargeRead, _ENV = self.fields.Text_tip, self.fields.Text_tip.setString
	self.fields.Text_tip.rechargeID = self.giftData.rechargeid
	local self.fields.Text_tip.setString[1], rechargeIDList = self.fields.Text_tip, self.fields.Text_tip.setString
	self.fields.rechargeGift:initData(rechargeIDList)
	self.fields.Text_discount:setString(string.format("%d%%", math.ceil(self.giftData.originalPrice / self.giftData.rechargePrice) * 100))
	if self.giftData.gold > 0 then
		self.fields.Image_gold:setVisible(true)
		self.fields.Text_gold:setVisible(true)
		self.fields.Text_gold:setString(string.formatnumberthousands(self.giftData.gold))
	else
		self.fields.Image_gold:setVisible(false)
		self.fields.Text_gold:setVisible(false)
	end
	_UPVALUE2_ = false
	;(false)[1] = "id"
	;(false)[2] = "count"
	self.itemList = serviceFunctions.tableFormat(self.giftData.reward, false)
	self.fields.List_items:setNumItems(#self.itemList)
	self.fields.List_items:jumpToTop()
	self:updateOutAppPurchase()
end
function rechargePage:updateOutAppPurchase()
	local showPrice, isGetPrice = paymentManager.judgePrice(self.giftData.rechargeid, self.giftData.rechargePrice)
	local discount = tonumber(self.giftData.originalPrice) / tonumber(self.giftData.rechargePrice)
	local oriShowPrice = paymentManager.calculateDiscount(self.giftData.rechargeid, showPrice, discount, self.giftData.originalPrice)
	if SoraDCheckOAPIsOpen(self.giftData.rechargeid) then
		self.fields.outAppPurchaseButtons:setVisible(true)
		self.fields.Button_buy:setVisible(false)
		_ENV = false
		;(false).rid = self.giftData.rechargeid
		;(false).nowPrice = showPrice
		_ENV, (false).oriPrice = self.giftData.rechargeid, oriShowPrice
		;(false).logInfo, self.giftData.rechargeid.fromCenter = self.giftData.rechargeid, gRechargeActiveFromEnum.ROAD51
		;(false).handleBuyClick = handler(self, self.btnBuyClick)
		self.fields.outAppPurchaseButtons:initData(false)
	else
		self.fields.outAppPurchaseButtons:setVisible(false)
		self.fields.Button_buy:setVisible(true)
		self.fields.Button_buy:setEnabled(true)
		self.fields.Button_buy:initData(showPrice, oriShowPrice)
	end
end
function rechargePage:btnBuyClick()
	SoraDPlaySound()
	paymentManager.normalGiftBuyClassify(self.giftData.rechargeid)
	paymentManager.OnemtReadyBuy(self.giftData.rechargeid, gRechargeActiveFromEnum.ROAD51, false)
end
return rechargePage
