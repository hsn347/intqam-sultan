local publicRead = include("publicRead")
local shopCtrl = SoraDGetCtrl("shopCtrl")
local baseComponent = require("fgui.base.baseComponent")
local shopSingleView = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://bagView/shopSingleView", shopSingleView)
function shopSingleView:onInit()
	self.isLimit = false
	self.fields.btn_buy:addClickListener(handler(self, self.onBuyClick))
	self:fixChildrenPos()
end
function shopSingleView:onShow()
end
function shopSingleView:registerEvent()
	SoraDAddMessage(self, "MESSAGE_MALL_BUY_SUCCESS", function(target, data)
		if self.data and data.shopItemID == self.data.shopItemID then
			self:initData(self.data)
		end
	end)
end
function shopSingleView:initData(data, isDiscount)
	self.data = data
	self.controllers.c1:setSelectedIndex(isDiscount and 1 or 0)
	self.fields.item:initData(data, isDiscount)
	self.fields.labelName:setString(publicRead.getName(data.id))
	self.isLimit = false
	self.fields.btn_buy:setBright(true)
	if data.cur and data.max then
		self.fields.labelCanBuy:setVisible(true)
		publicRead = publicRead.getName(data.id)
		publicRead.getName(data.id).member = fguiHelper.getColorString(0 < data.cur and "#FFFFFF" or "#E02B2B", data.cur)
		publicRead.getName(data.id).total = data.max
		self.fields.labelCanBuy:setString(i18n("common_text_155", publicRead.getName(data.id)))
	else
		local limitData = shopCtrl:getLimitDataByID(data.shopItemID)
		if limitData then
			if gShopLimitType.Day == data.limit then
				self.fields.labelCanBuy:setVisible(true)
				publicRead = i18n("common_text_155", publicRead.getName(data.id))
				i18n("common_text_155", publicRead.getName(data.id)).num = fguiHelper.getColorString(0 < limitData.cur and "#FFFFFF" or "#E02B2B", limitData.cur)
				i18n("common_text_155", publicRead.getName(data.id)).limitNum = limitData.max
				self.fields.labelCanBuy:setString(i18n("shop_text_15", i18n("common_text_155", publicRead.getName(data.id))))
			elseif gShopLimitType.All == data.limit then
				self.fields.labelCanBuy:setVisible(true)
				publicRead = i18n("shop_text_15", i18n("common_text_155", publicRead.getName(data.id)))
				i18n("shop_text_15", i18n("common_text_155", publicRead.getName(data.id))).num = fguiHelper.getColorString(0 < limitData.cur and "#FFFFFF" or "#E02B2B", limitData.cur)
				i18n("shop_text_15", i18n("common_text_155", publicRead.getName(data.id))).limitNum = limitData.max
				self.fields.labelCanBuy:setString(i18n("shop_text_16", i18n("shop_text_15", i18n("common_text_155", publicRead.getName(data.id)))))
			end
			if 0 >= limitData.cur then
				self.fields.btn_buy:setBright(false)
				self.isLimit = true
			end
		else
			self.fields.labelCanBuy:setVisible(false)
		end
	end
	self.fields.btn_buy:initData(data.price, data.originalPrice)
	if data.cur and 0 >= data.cur then
		self.fields.btn_buy:setBright(false)
		self.isLimit = true
	end
end
function shopSingleView:onBuyClick()
	SoraDPlaySound()
	if self.isLimit then
		SoraDShowMsgTip(i18n("shop_text_17"))
	else
		_ENV = i18n("shop_text_17")
		i18n("shop_text_17").itemData = self.data
		i18n("shop_text_17").isHideUseTotal = gModuleMgr.sharedMgr("backpackltCtrl"):getItemType(self.data.id) == gItemType.POWERFUL_ESSENCE
		uiManager:show("newShopSingleBuy", i18n("shop_text_17"))
	end
end
return shopSingleView
