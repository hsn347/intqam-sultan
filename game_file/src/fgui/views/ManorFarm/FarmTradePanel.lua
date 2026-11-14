local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local manorFarmRead = include("manorFarmRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local FarmTradePanel = class("FarmTradePanel", baseFguiPanel)
function FarmTradePanel:ctor(...)
	self.isLRU = true
	FarmTradePanel.super.ctor(self, ...)
	print("FarmTradePanel:ctor", self.viewName)
end
function FarmTradePanel:onInit()
	print("=======FarmTradePanel:onInit")
	fguiHelper.SoraDSetComFields(self)
	self.fields.listGoods:setVirtual()
	self.fields.listGoods:setItemRenderer(handler(self, self.itemRenderer_listGoods))
	self.fields.listMyGoods:setVirtual()
	self.fields.listMyGoods:setItemRenderer(handler(self, self.itemRenderer_listMyGoods))
	self.fields.btnFilter:setTitle(i18n("gem_btn_01"))
	self.fields.btnFilter:addClickListener(handler(self, self.onClick_btnFilter))
	self.fields.btnHistory:addClickListener(handler(self, self.onClick_btnHistory))
	self.fields.btnSearch:addClickListener(handler(self, self.onClick_btnSearch))
	self.fields.btnTip:addClickListener(handler(self, self.onClick_btnTip))
	self.fields.titlePrice:setString(i18n("farmland_text_57"))
	self.fields.titleNum:setString(i18n("common_text_2709"))
	self.fields.titlePlayer:setString(i18n("history_text_57"))
	self.fields.titleItem:setString(i18n("farmland_text_56"))
	self.fields.txtNoGood:setString(i18n("farmland_text_55"))
	self.fields.Com_title:initData(i18n("farmland_text_50"), handler(self, self.onClickClose))
	_ENV = i18n("farmland_text_50")
	_ENV, _ENV, i18n("farmland_text_50").defaultClick = handler(self, self.onClickClose)
	handler(self, self.onClickClose).title = i18n("farmland_text_52")
	_ENV, handler(self, self.onClickClose)[1], handler(self, self.onClickClose).tag = handler(self, self.onClickClose)
	handler(self, self.onClickClose).title = i18n("farmland_text_53")
	_ENV, handler(self, self.onClickClose)[2], handler(self, self.onClickClose).tag = handler(self, self.onClickClose)
	handler(self, self.onClickClose).title = i18n("farmland_text_54")
	i18n("farmland_text_50").tabsetArray, handler(self, self.onClickClose)[3], handler(self, self.onClickClose).tag = handler(self, self.onClickClose)
	i18n("farmland_text_50").callback = handler(self, self.onClickTab)
	self.fields.Com_title:initTab((i18n("farmland_text_50")))
	_ENV = i18n("farmland_text_50")
	i18n("farmland_text_50").prompt = i18n("lordequip_text_05")
	i18n("farmland_text_50").cleanHandler = handler(self, self.onClick_btnSearchClear)
	i18n("farmland_text_50").onChangedHandler = handler(self, self.onChange_inputBar)
	self.fields.inputBar:initInputData((i18n("farmland_text_50")))
	self.fields.btnPriceDetail:addClickListener(handler(self, self.onClick_btnPriceDetail))
	self.fields.txtTip:setString(i18n("farmland_text_65"))
	self.fields.seedBagTitle:setTitle(i18n("garden_btn_09"))
	self.fields.Button_max:addClickListener(handler(self, self.onClick_Button_max))
	self.fields.listType:setItemRenderer(handler(self, self.itemRenderer_listType))
	self.fields.listType:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem_listType))
	self.fields.listSeed:setVirtual()
	self.fields.listSeed:setItemRenderer(handler(self, self.itemRenderer_listSeed))
	self.fields.listSeed:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem_listSeed))
	self.fields.btnConfirm:setTitle(i18n("farmland_text_77"))
	self.fields.btnConfirm:addClickListener(handler(self, self.onClick_btnConfirm))
	self.fields.comSelectedItem.fields.btnReduce:addClickListener(handler(self, self.onClick_btnReduce))
	self.fields.comSlider:setSliderCallBack(handler(self, self.onSliderChange))
end
function FarmTradePanel:endShow()
	print("=======FarmTradePanel:endShow")
	self.fields.Com_title.fields.com_Tab:setTabIndex(1, true)
	self.selectedType = 0
	self.controllers.ctrlPrice:setSelectedIndex(0)
	self.controllers.ctrlHistory:setSelectedIndex(0)
	self:showFilter()
	self:updateCurrency()
	if not self.mySaleListLoaded then
		manorCityCtrl:reqMarketMySaleList()
	end
end
function FarmTradePanel:updateCurrency()
	self.fields.btnCurrency:initData(manorFarmRead.getExchangeRId())
	self.fields.btnCurrency:updateOther()
	self.fields.btnCurrency:setTouchable(false)
end
function FarmTradePanel:itemRenderer_listGoods(index, obj)
	local data = self.saleListData[index + 1]
	obj:initData(data, self.salePriceData[data.itemId], data.itemId)
end
function FarmTradePanel:itemRenderer_listMyGoods(index, obj)
	local data = self.mySaleListData[index + 1]
	obj:initData(data, true)
end
function FarmTradePanel:itemRenderer_listType(index, obj)
	local icon = manorFarmRead.getSeedTypeIcon(index)
	obj:initData(index, icon)
	if self.selectedType then
		if self.selectedType == index then
			obj.controllers.ctrlSelected:setSelectedIndex(2)
		else
			obj.controllers.ctrlSelected:setSelectedIndex(1)
		end
	else
		obj.controllers.ctrlSelected:setSelectedIndex(0)
	end
end
function FarmTradePanel:itemRenderer_listSeed(index, obj)
	local data = self.mySeeds[index + 1]
	obj:initData(data.id, data.count)
end
function FarmTradePanel:onClickItem_listType(context)
	local seedType = context.data.type
	self.selectedType = seedType
	self:updateUpShelfPage()
end
function FarmTradePanel:onClickItem_listSeed(context)
	local obj = context.data
	self:updateShelfInfo(obj.id)
end
function FarmTradePanel:onClick_btnFilter(context)
	SoraDPlaySound()
	self:showFilter()
end
function FarmTradePanel:onClick_btnHistory(context)
	SoraDPlaySound()
	if self.searchHistory then
		self.controllers.ctrlHistory:setSelectedIndex(1)
		self.fields.comHistory:initData(self.searchHistory)
	end
end
function FarmTradePanel:onClick_btnSearch(context)
	SoraDPlaySound()
	if not self.searchData then
		return
	end
	manorCityCtrl:reqMarketSaleList(self.searchData.id)
	if not self.searchHistory then
		self.searchHistory, _ENV = self.searchHistory, self.searchHistory
	end
	local duplicate = false
	for i, v in ipairs(self.searchHistory) do
		if self.searchData.id == v.id then
			table.remove(self.searchHistory, i)
			table.insert(self.searchHistory, self.searchData)
			duplicate = true
			break
		end
	end
	if not duplicate then
		table.insert(self.searchHistory, self.searchData)
	end
	if #self.searchHistory > 10 then
		table.remove(self.searchHistory, 1)
	end
	SoraDShowLoading(self, nil, gCmd.REQ_GARDEN_FARMLAND_MARKET_SALE_LIST)
end
function FarmTradePanel:onClick_btnTip(context)
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("farmland_text_51")
	uiManager:show("RuleView", nil)
end
function FarmTradePanel:onClick_comSelectedItem(context)
	SoraDPlaySound()
end
function FarmTradePanel:onClick_Button_max(context)
	SoraDPlaySound()
	self.fields.comSlider:setSliderCurValue(self.fields.comSlider.maxValue)
end
function FarmTradePanel:onClick_btnConfirm(context)
	SoraDPlaySound()
	if not self.shelfItemId then
		return
	end
	if not self.mySaleListLoaded then
		self.pendingOnSale = true
		manorCityCtrl:reqMarketMySaleList()
		SoraDShowLoading(self, nil, gCmd.REQ_GARDEN_FARMLAND_MARKET_MY_SALE_LIST, nil, 15)
		return
	end
	self:tryOnSale()
end
function FarmTradePanel:tryOnSale()
	if not self.mySaleListData then
		local _ENV, mySaleListData = self.mySaleListData, self.mySaleListData
	end
	local hasSameItemOnSale = false
	for _, saleData in ipairs(mySaleListData) do
		if tonumber(saleData.itemId) == tonumber(self.shelfItemId) then
			hasSameItemOnSale = true
			break
		end
	end
	if CONST_VALUE.FARMLAND_EXCHANGE_GOODS_LIMIT > #mySaleListData or hasSameItemOnSale then
		manorCityCtrl:reqMarketOnSale(self.shelfItemId, self.fields.comSlider:getSliderCurValue())
		SoraDShowLoading(self, nil, gCmd.REQ_GARDEN_FARMLAND_MARKET_ON_SALE)
	else
		SoraDShowMsgTip(i18n("farmland_text_76"))
	end
end
function FarmTradePanel:onClick_btnPriceDetail(context)
	SoraDPlaySound()
	self:showHistoryPrice(self.fields.btnPriceDetail, self.shelfPriceData)
end
function FarmTradePanel:onClick_btnSearchClear(context)
	self:setSearchData(nil)
	self.controllers.ctrlCandidate:setSelectedIndex(0)
end
function FarmTradePanel:onClick_btnReduce(context)
	SoraDPlaySound()
end
function FarmTradePanel:onClickTab(tag)
	if tag == 1 then
		self:updateTradePage()
	elseif tag == 2 then
		self:updateMyTradePage()
	elseif tag == 3 then
		self:updateUpShelfPage(false, true)
	end
end
function FarmTradePanel:onChange_inputBar(text)
	local str = text
	if str ~= "" then
		local searchResult = manorFarmRead.searchSeedIdByName(str)
		self.controllers.ctrlCandidate:setSelectedIndex(1)
		self.fields.comCandidate:initData_candidate(searchResult)
	else
		self.controllers.ctrlCandidate:setSelectedIndex(0)
	end
end
function FarmTradePanel:onSliderChange(value)
	if self.shelfPriceData then
		_ENV = nil
		;(nil).price = math.floor(self.shelfPriceData.price)
		self.fields.txtCurPrice:setString(i18n("farmland_text_66", nil))
		_ENV = i18n("farmland_text_66", nil)
		i18n("farmland_text_66", nil).price = math.floor(self.shelfPriceData.price * value * (1 - CONST_VALUE.FARMLAND_EXCHANGE_COMMISSION / 1000))
		self.fields.txtCanGet:setString(i18n("farmland_text_67", i18n("farmland_text_66", nil)))
	end
end
function FarmTradePanel:initData(pageType, ...)
	self:updateCurrency()
	if pageType == 1 then
		self:updateTradePage()
	elseif pageType == 2 then
		self:updateMyTradePage()
	elseif pageType == 3 then
		self:updateUpShelfPage()
	end
end
function FarmTradePanel:updateTradePage(silent, data)
	if not silent then
		self.controllers.ctrlPage:setSelectedIndex(0)
	end
	self.controllers.ctrlEmpty:setSelectedIndex(self.saleListData ~= nil and 0 < #self.saleListData and 0 or 1)
end
function FarmTradePanel:updateMyTradePage(silent)
	if not silent then
		self.controllers.ctrlPage:setSelectedIndex(1)
	end
	manorCityCtrl:reqMarketMySaleList()
	SoraDShowLoading(self, nil, gCmd.REQ_GARDEN_FARMLAND_MARKET_MY_SALE_LIST, nil, 15)
end
function FarmTradePanel:updateUpShelfPage(silent, clearSelect)
	if not silent then
		self.controllers.ctrlPage:setSelectedIndex(2)
	end
	if clearSelect then
		self.shelfItemId = nil
	end
	if not self.mySaleListLoaded then
		self:updateMyTradePage(true)
	end
	self.fields.listType:setNumItems(manorFarmRead.getSeedTypeNum())
	self.mySeeds = manorCityCtrl:getBagSeeds(function(a, b)
		if a.seedData.seedQuality == b.seedData.seedQuality then
			return a.seedData.seedID > b.seedData.seedID
		else
			return a.seedData.seedQuality > b.seedData.seedQuality
		end
	end, self.selectedType)
	self.fields.listSeed:setNumItems(#self.mySeeds)
	self.fields.listSeed:setSelectedIndex(-1)
	self:updateShelfInfo(self.shelfItemId)
	self.controllers.ctrlPrice:setSelectedIndex(0)
	self:hideFilter()
end
function FarmTradePanel:updateTradeList(data)
	self.saleListData, _ENV, self.salePriceData, _ENV = nil, nil, nil, nil
	for id_str, v in pairs(data.data) do
		local itemId = tonumber(id_str)
		self.salePriceData[itemId] = v.price
		for i, sale in ipairs(v.saleList) do
			sale.itemId = itemId
			table.insert(self.saleListData, sale)
		end
	end
	self.fields.listGoods:setNumItems(#self.saleListData)
	self.controllers.ctrlEmpty:setSelectedIndex(#self.saleListData == 0 and 1 or 0)
	self.controllers.ctrlFilter:setSelectedIndex(0)
end
function FarmTradePanel:updateTradeListSingle(data)
	for i, v in ipairs(self.saleListData) do
		if v.uid == data.uid then
			if data.n > 0 then
				v.n = data.n
				v.t = data.t
				break
			end
			table.remove(self.saleListData, i)
			break
		end
	end
	self.fields.listGoods:setNumItems(#self.saleListData)
	self.controllers.ctrlEmpty:setSelectedIndex(#self.saleListData == 0 and 1 or 0)
end
function FarmTradePanel:updateMyTradeList(data, offSaleId)
	if not self.mySaleListData then
		_ENV = self.mySaleListData
	end
	self.mySaleListData = self.mySaleListData
	if offSaleId then
		for i, v in ipairs(self.mySaleListData) do
			if tonumber(v.itemId) == offSaleId then
				table.remove(self.mySaleListData, i)
				break
			end
		end
	elseif data then
		self.mySaleListData, _ENV = ipairs(self.mySaleListData)
		for itemId, v in pairs(data) do
			v.itemId = itemId
			table.insert(self.mySaleListData, v)
		end
		self.mySaleListLoaded = true
	end
	self.fields.listMyGoods:setNumItems(#self.mySaleListData)
	if self.pendingOnSale then
		self.pendingOnSale = false
		if self.controllers.ctrlPage:getSelectedIndex() == 2 then
			self:tryOnSale()
		end
	end
end
function FarmTradePanel:updateMyTradeListSingle(data)
	for i, v in ipairs(self.mySaleListData) do
		if tonumber(v.itemId) == data.itemId then
			table.remove(self.mySaleListData, i)
			break
		end
	end
	self.fields.listMyGoods:setNumItems(#self.mySaleListData)
end
function FarmTradePanel:showHistoryPrice(obj, priceData)
	self.controllers.ctrlPrice:setSelectedIndex(1)
	self.fields.comPrice:initData(priceData)
	local pos = obj:TransformPoint(cc.p(0, 0), self)
	self.fields.comPrice:setPositionX(pos.x - self.fields.comPrice:getWidth() / 2)
	self.fields.comPrice:setPositionY(pos.y + obj:getHeight())
end
function FarmTradePanel:hideHistoryPrice()
	self.controllers.ctrlPrice:setSelectedIndex(0)
end
function FarmTradePanel:updateShelfInfo(itemId)
	if not itemId then
		self.fields.Mod_Shelf:getController("ctrlSetNum"):setSelectedIndex(0)
		self.fields.comSelectedItem:setReduce(0)
		self.fields.comSelectedItem:setStatus(0)
		self.shelfItemId = nil
		return
	else
		self.fields.Mod_Shelf:getController("ctrlSetNum"):setSelectedIndex(1)
		self.shelfItemId = itemId
		if self.shelfItemId then
			manorCityCtrl:reqMarketSalePrice(self.shelfItemId)
			SoraDShowLoading(self, nil, gCmd.REQ_GARDEN_FARMLAND_MARKET_SALE_PRICE)
		end
		manorCityCtrl = nil
		;(nil).maxValue = manorCityCtrl:getSeedNum(itemId)
		;(nil).minValue = 1
		;(nil).curValue = 1
		;(nil).allowZero = false
		self.fields.comSlider:initData(nil)
		self.fields.comSelectedItem:initData(itemId)
		self.fields.comSelectedItem:setReduce(1)
	end
end
function FarmTradePanel:updateShelfPrice(priceData)
	self.shelfPriceData = priceData
	_ENV = nil
	;(nil).price = math.floor(priceData.price)
	self.fields.txtCurPrice:setString(i18n("farmland_text_66", nil))
	_ENV = i18n("farmland_text_66", nil)
	i18n("farmland_text_66", nil).price = math.floor(priceData.price * self.fields.comSlider:getSliderCurValue() * (1 - CONST_VALUE.FARMLAND_EXCHANGE_COMMISSION / 1000))
	self.fields.txtCanGet:setString(i18n("farmland_text_67", i18n("farmland_text_66", nil)))
end
function FarmTradePanel:hideSearchHistory()
	self.controllers.ctrlHistory:setSelectedIndex(0)
end
function FarmTradePanel:hideFilter()
	self.controllers.ctrlFilter:setSelectedIndex(0)
end
function FarmTradePanel:showFilter()
	self.fields.comFilter:initData()
	self.controllers.ctrlFilter:setSelectedIndex(1)
end
function FarmTradePanel:hideCandidate()
	self.controllers.ctrlCandidate:setSelectedIndex(0)
end
function FarmTradePanel:setSearchData(data)
	self.searchData = data
	if not self.searchData then
		_ENV = self.searchData
	end
	self.fields.inputBar:setInputText(i18n(self.searchData.name or ""))
end
function FarmTradePanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "tabUpShelf" then
		local comTab = self.fields.Com_title and self.fields.Com_title.fields and self.fields.Com_title.fields.com_Tab
		if comTab and comTab.getBtn then
			return comTab:getBtn(3)
		end
	end
	return self.fields[itemName]
end
return FarmTradePanel
