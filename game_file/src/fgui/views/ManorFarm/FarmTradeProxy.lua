local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local baseProxy = require("fgui.base.baseProxy")
local FarmTradeProxy = class("FarmTradeProxy", baseProxy)
function FarmTradeProxy:onRegisterEvent()
	print("=======FarmTradeProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_MARKET_SALE_LIST", handler(self, self.onMsgMarketSaleList))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_MARKET_MY_SALE_LIST", handler(self, self.onMsgMarketMySaleList))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_MARKET_ON_SALE", handler(self, self.onMsgMarketOnSale))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_MARKET_OFF_SALE", handler(self, self.onMsgMarketMySaleList))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_FARMLAND_UPDATE", handler(self, self.onMsgUpdateBagSeeds))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_MARKET_SALE_PRICE", handler(self, self.onMsgItemMarketPrice))
	SoraDAddMessage(self, "MESSAGE_MANOR_FARM_SEARCH_SEED_CANDIDATE", handler(self, self.onMsgChooseSeedCandidate))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updataItemNum))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_MARKET_SALE_LIST_UPDATE", handler(self, self.updataSaleList))
	SoraDAddMessage(self, "MESSAGE_MANOR_CITY_MARKET_MY_SALE_LIST_UPDATE", handler(self, self.updataMySaleList))
end
function FarmTradeProxy:onMsgMarketSaleList(target, data, itemId)
	self.view:updateTradeList(data, itemId)
end
function FarmTradeProxy:onMsgMarketMySaleList(target, data)
	self.view:updateMyTradeList(data.data, data.data.itemId)
end
function FarmTradeProxy:hideSearchHistory()
	self.view:hideSearchHistory()
end
function FarmTradeProxy:hideFilter()
	self.view:hideFilter()
end
function FarmTradeProxy:showHistoryPrice(obj, priceData)
	self.view:showHistoryPrice(obj, priceData)
end
function FarmTradeProxy:hideHistoryPrice()
	self.view:hideHistoryPrice()
end
function FarmTradeProxy:onMsgUpdateBagSeeds(target, data)
	self.view:updateUpShelfPage(true)
end
function FarmTradeProxy:onMsgMarketOnSale(target, data)
	self.view.mySaleListLoaded = false
	self.view:updateUpShelfPage(true, true)
end
function FarmTradeProxy:onMsgItemMarketPrice(target, data)
	self.view:updateShelfPrice(data.data)
end
function FarmTradeProxy:search(data)
	self.view:setSearchData(data)
	self:hideSearchHistory()
end
function FarmTradeProxy:onMsgChooseSeedCandidate(target, event)
	local data = event.data
	self.view:setSearchData(data)
	self.view:hideCandidate()
end
function FarmTradeProxy:hideCandidate()
	self.view:setSearchData()
	self.view:hideCandidate()
end
function FarmTradeProxy:updataItemNum()
	self.view:updateCurrency()
end
function FarmTradeProxy:updataSaleList(target, event)
	local data = event.data
	self.view:updateTradeListSingle(data)
end
function FarmTradeProxy:updataMySaleList(target, event)
	local data = event.data
	self.view:updateMyTradeListSingle(data)
end
return FarmTradeProxy
