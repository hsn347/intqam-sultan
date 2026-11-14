local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local publicRead = include("publicRead")
local kindomCtrl = SoraDGetCtrl("kingdomCtrl")
local manorFarmRead = include("manorFarmRead")
local baseComponent = require("fgui.base.baseComponent")
local ComTradeItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorFarm/ComTradeItem", ComTradeItem)
function ComTradeItem:onInit()
	self.fields.btnBuy:setTitle(i18n("common_text_282"))
	self.fields.btnBuy:addClickListener(handler(self, self.onClick_btnBuy))
	self.fields.btnDetail:addClickListener(handler(self, self.onClick_btnDetail))
end
function ComTradeItem:onShow()
end
function ComTradeItem:onClick_btnBuy(context)
	SoraDPlaySound()
	local info = manorFarmRead.getSeedInfo(self.itemId)
	_ENV, _ENV = nil, nil
	;(nil).id = self.itemId
	_ENV, (nil).itemData, (nil).price = nil, nil, self.price.price
	;(nil).maxCount = self.data.n
	;(nil).otherData, (nil).exchangeID = nil, info.buyPrice[1]
	;(nil).buyHandle = function(count)
		manorCityCtrl:reqMarketBuy(self.itemId, count, self.data.uid)
		local proxy = uiManager:getProxy("FarmTrade")
		if proxy then
			SoraDShowLoading(proxy.view, nil, gCmd.REQ_GARDEN_FARMLAND_MARKET_BUY)
		end
	end
	uiManager:show("newShopSingleBuy", nil)
end
function ComTradeItem:onClick_btnDetail(context)
	SoraDPlaySound()
	local proxy = uiManager:getProxy("FarmTrade")
	proxy:showHistoryPrice(context.sender, self.price)
end
function ComTradeItem:initData(data, price, itemId)
	self.data = data
	self.itemId = itemId
	self.price = price
	self.fields.txtNum:setString(tostring(data.n))
	self.fields.txtPrice:setString(tostring(price.price))
	self.fields.txtKindom:setString(kindomCtrl:getKindomName(data.kid))
	_ENV = kindomCtrl:getKindomName(data.kid)
	kindomCtrl:getKindomName(data.kid).name = data.name
	kindomCtrl:getKindomName(data.kid).abbr = data.allianceAbb
	self.fields.txtName:setString(i18n(data.allianceAbb and "common_text_186" or "common_text_035", kindomCtrl:getKindomName(data.kid)))
	self.fields.comItem:initData(itemId)
end
return ComTradeItem
