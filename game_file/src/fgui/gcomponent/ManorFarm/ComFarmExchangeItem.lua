local publicRead = include("publicRead")
local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local publicUtil = include("publicUtil")
local baseComponent = require("fgui.base.baseComponent")
local ComFarmExchangeItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorFarm/ComFarmExchangeItem", ComFarmExchangeItem)
function ComFarmExchangeItem:onInit()
	self.fields.btnBuy:addClickListener(handler(self, self.onClick_btnBuy))
end
function ComFarmExchangeItem:onShow()
end
function ComFarmExchangeItem:onClick_btnBuy(context)
	SoraDPlaySound()
	if self.leftTimes < 0 then
		return
	end
	if self.data.exLimit[2] > manorCityCtrl:getBuildLvByBid(MANOR_BUILD_ID.MAIN) then
		SoraDShowMsgTip(i18n("enjoyable_store_03"))
		return
	end
	local itemCount = publicUtil.getCount(self.exchangeItemID)
	if itemCount < self.exchangeItemCount then
		_ENV = i18n("enjoyable_store_03")
		i18n("enjoyable_store_03").name = publicRead.getName(self.exchangeItemID)
		SoraDShowMsgTip(i18n("Frosty_Market_text_19", i18n("enjoyable_store_03")))
		if self.addCallback then
			self.addCallback(self.exchangeItemID)
		else
			_ENV = i18n("Frosty_Market_text_19", i18n("enjoyable_store_03"))
			i18n("Frosty_Market_text_19", i18n("enjoyable_store_03")).itemID = self.exchangeItemID
			uiManager:show("CommonSourceGuide", i18n("Frosty_Market_text_19", i18n("enjoyable_store_03")))
		end
		return
	end
	if self.data.limitnum <= activityExchangeMallCtrl:getExchangeNum(self.data.activityID, self.data.shopItemID) then
		SoraDShowMsgTip(i18n("shop_text_17"))
		return
	end
	local maxNum = math.floor(itemCount / self.exchangeItemCount)
	maxNum = math.min(maxNum, self.leftTimes)
	_ENV, _ENV, _ENV = i18n("shop_text_17")
	i18n("shop_text_17").targetID = self.shopItemID
	i18n("shop_text_17").singleGet = self.shopItemCount
	i18n("shop_text_17").exchangeID = self.exchangeItemID
	i18n("shop_text_17").singCount = self.exchangeItemCount
	i18n("shop_text_17").exchangeData, i18n("shop_text_17").curNum = i18n("shop_text_17")
	i18n("shop_text_17").exchangeCfg, i18n("shop_text_17").exchangeHandler = i18n("shop_text_17")
	uiManager:show("newShopSingleBuy", i18n("shop_text_17"))
end
function ComFarmExchangeItem:initData(exchangeData)
	dump(exchangeData, "==ComFarmExchangeItem==")
	self.data = exchangeData
	self.shopItemID = exchangeData.shopitem
	self.shopItemCount = exchangeData.shopitemnum
	self.exchangeItemID = exchangeData.exchangeitem
	self.exchangeItemCount = exchangeData.exchangenum
	local curExchangeNum = activityExchangeMallCtrl:getExchangeNum(self.data.activityID, self.data.shopItemID) or 0
	self.leftTimes = math.max(0, self.data.limitnum - curExchangeNum)
	self.fields.title:setString(exchangeData.shopitem and publicRead.getName(self.data.shopitem) or "")
	if self.data.exLimit[2] > manorCityCtrl:getBuildLvByBid(MANOR_BUILD_ID.MAIN) then
		_ENV = nil
		;(nil).lv = self.data.exLimit[2]
		self.fields.txtLimit:setString(i18n("farmland_text_04", nil))
		self.fields.txtLimit:setVisible(true)
	else
		self.fields.txtLimit:setVisible(false)
	end
	_ENV = i18n("farmland_text_04", nil)
	i18n("farmland_text_04", nil).num = self.data.limitnum - activityExchangeMallCtrl:getExchangeNum(exchangeData.activityID, exchangeData.shopItemID)
	self.fields.txtLeft:setString(i18n("common_text_4600", i18n("farmland_text_04", nil)))
	self.fields.btnBuy:initData(self.data.exchangeitem, self.data.exchangenum)
	self.fields.comItem:initData(self.data.shopitem, self.data.shopitemnum)
	self.fields.btnBuy:setStatus(publicUtil.getCount(self.data.exchangeitem), self.data.exchangenum)
end
return ComFarmExchangeItem
