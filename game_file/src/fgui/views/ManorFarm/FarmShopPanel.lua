local newExchangeMallCtrl = SoraDGetCtrl("newExchangeMallCtrl")
local publicRead = include("publicRead")
local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local manorFarmRead = include("manorFarmRead")
local publicUtil = include("publicUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local FarmShopPanel = class("FarmShopPanel", baseFguiPanel)
local currencyItemID = CONST_VALUE.GARDEN_RECYCLE_STORE_CURRENCY or 1728
function FarmShopPanel:ctor(...)
	self.isLRU = true
	FarmShopPanel.super.ctor(self, ...)
	print("FarmShopPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.EXCHANGE_ACTIVITY_9001726
	self.classType = 1
end
function FarmShopPanel:onInit()
	print("=======FarmShopPanel:onInit")
	self.fields.Com_title:initData(i18n("farmland_text_01"), handler(self, self.onClickClose))
	self.fields.Com_title:getLabelTime():setTimeEndListener(function()
		self.fields.Com_title:initSpecialTime(serviceFunctions.getNextWeekDayUTC(1) - serviceFunctions.systemTime(), "commandhall_text_78")
		self:updateView()
	end)
	self.fields.listExchange:setVirtual()
	self.fields.listExchange:setItemRenderer(handler(self, self.itemRenderer_listExchange))
	self.fields.listFruit:setVirtual()
	self.fields.listFruit:setItemRenderer(handler(self, self.itemRenderer_listFruit))
	self.fields.listFruit:setItemProvider(handler(self, self.itemProvider_listFruit))
	self.fields.listSeed:setVirtual()
	self.fields.listSeed:setItemRenderer(handler(self, self.itemRenderer_listSeed))
	self.fields.listSeed:setItemProvider(handler(self, self.itemProvider_listSeed))
	self.fields.btnAutoSell:setTitle(i18n("farmland_text_78"))
	self.fields.btnAutoSell:addClickListener(handler(self, self.onClick_btnAutoSell))
	_ENV = handler(self, self.onClick_btnAutoSell)
	_ENV, _ENV, handler(self, self.onClick_btnAutoSell).defaultClick = handler(self, self.onClick_btnAutoSell)
	handler(self, self.onClick_btnAutoSell).title = i18n("eidTycoon2024_text_04")
	_ENV, handler(self, self.onClick_btnAutoSell)[1], handler(self, self.onClick_btnAutoSell).tag = handler(self, self.onClick_btnAutoSell)
	handler(self, self.onClick_btnAutoSell).title = i18n("farmland_text_81")
	_ENV, handler(self, self.onClick_btnAutoSell)[2], handler(self, self.onClick_btnAutoSell).tag = handler(self, self.onClick_btnAutoSell)
	handler(self, self.onClick_btnAutoSell).title = i18n("farmland_text_02")
	handler(self, self.onClick_btnAutoSell).tabsetArray, handler(self, self.onClick_btnAutoSell)[3], handler(self, self.onClick_btnAutoSell).tag = handler(self, self.onClick_btnAutoSell)
	handler(self, self.onClick_btnAutoSell).callback = handler(self, self.onClickTab)
	self.fields.comTab:initView(handler(self, self.onClick_btnAutoSell))
end
function FarmShopPanel:endShow()
	print("=======FarmShopPanel:endShow")
	self.fields.Com_title:initSpecialTime(serviceFunctions.getNextWeekDayUTC(1) - serviceFunctions.systemTime(), "commandhall_text_78")
	self.fields.comTab:clickTab(1, true)
	self.fields.comTab:setToTag(1)
end
function FarmShopPanel:itemRenderer_listExchange(index, obj)
	local data = self.exchangeData[index + 1]
	obj:initData(data, true)
end
function FarmShopPanel:itemRenderer_listFruit(index, obj)
	local _data = self.fruitData[index + 1]
	if _data.itemType == 1 then
		obj:initData(_data, index + 1)
		obj:setOnClickItem(handler(self, self.onClickFruitItem))
	elseif _data.itemType == 2 then
		obj:initData(_data)
	end
end
function FarmShopPanel:itemRenderer_listSeed(index, obj)
	local data = self.seedData[index + 1]
	if data.itemType == 1 then
		obj:initData(data, index + 1)
		obj:setOnClickItem(handler(self, self.onClickSeedItem))
	elseif data.itemType == 2 then
		obj:initData(data)
	end
end
function FarmShopPanel:itemProvider_listFruit(index)
	local itemData = self.fruitData[index + 1]
	if itemData.itemType == 1 then
		return "ui://ManorFarm/ComBagLine"
	elseif itemData.itemType == 2 then
		return "ui://ManorFarm/Com_bagItemInfo"
	end
end
function FarmShopPanel:itemProvider_listSeed(index)
	local itemData = self.seedData[index + 1]
	if itemData.itemType == 1 then
		return "ui://ManorFarm/ComBagLine"
	elseif itemData.itemType == 2 then
		return "ui://ManorFarm/itemSingleRecycle_farm"
	end
end
function FarmShopPanel:onClickFruitItem(context, index)
	SoraDPlaySound()
	local obj = context.data
	local removedLastInfo = false
	for i, v in ipairs(self.fruitData) do
		if v.itemType == 2 then
			table.remove(self.fruitData, i)
			removedLastInfo = i
			break
		end
	end
	if not obj.id then
		self.fields.listFruit:setNumItems(#self.fruitData)
		self.fields.listFruit:EnsureBoundsCorrect()
		return
	end
	local insertIndex = index + 1 + (removedLastInfo and index >= removedLastInfo and -1 or 0)
	_ENV = nil
	_ENV, (nil).itemType = table.remove, 2
	table.remove.itemId = obj.id
	;(nil).data, table.remove.curPosX = table.remove, obj:getPositionX() + obj:getWidth() / 2
	;(nil).fruitData = manorFarmRead.getFruitInfo(obj.id)
	table.insert(self.fruitData, insertIndex, nil)
	self.fields.listFruit:setNumItems(#self.fruitData)
	obj:setMovieBorder(true)
end
function FarmShopPanel:onClickSeedItem(context, index)
	SoraDPlaySound()
	local obj = context.data
	local removedLastInfo = false
	for i, v in ipairs(self.seedData) do
		if v.itemType == 2 then
			table.remove(self.seedData, i)
			removedLastInfo = i
			break
		end
	end
	if not obj.id then
		self.fields.listSeed:setNumItems(#self.seedData)
		self.fields.listSeed:EnsureBoundsCorrect()
		return
	end
	local insertIndex = index + 1 + (removedLastInfo and index >= removedLastInfo and -1 or 0)
	_ENV = nil
	;(nil).itemType = 2
	;(nil).id = obj.id
	;(nil).seedData = manorFarmRead.getSeedInfo(obj.id)
	;(nil).curPosX = obj:getPositionX() + obj:getWidth() / 2
	;(nil).fruitData = manorFarmRead.getFruitInfo(obj.id)
	table.insert(self.seedData, insertIndex, nil)
	self.fields.listSeed:setNumItems(#self.seedData)
	obj:setMovieBorder(true)
end
function FarmShopPanel:onClick_btnAutoSell(context)
	SoraDPlaySound()
	local _ENV, items = SoraDPlaySound, SoraDPlaySound
	local fruitdata = manorCityCtrl:getBagFruits()
	for i = #fruitdata, 1, -1 do
		if not manorFarmRead.getRecycle(fruitdata[i].id) then
			table.remove(fruitdata, i)
		end
	end
	for i, v in ipairs(fruitdata) do
		_ENV = nil
		;(nil).id = v.id
		;(nil).count = v.count
		table.insert(items, nil)
	end
	manorCityCtrl:reqFarmlandRecycle(items)
	SoraDShowLoading(self, nil, gCmd.REQ_GARDEN_FARMLAND_RECYCLE)
end
function FarmShopPanel:onClickTab(tag)
	self:initData(tag)
end
function FarmShopPanel:initData(page)
	self.controllers.ctrlPage:setSelectedIndex(page - 1)
	self:updateCurrencyNum()
	self.fields.icon:setURL(publicRead.getIcon(currencyItemID))
	if page == 1 then
		self:updateExchangeStore()
	elseif page == 2 then
		self:updateFruitStore()
	elseif page == 3 then
		self:updateSeedStore()
	end
end
function FarmShopPanel:updateCurrencyNum()
	_ENV = nil
	;(nil).name = publicRead.getName(currencyItemID)
	self.fields.txtNum:setString(i18n("farmland_text_03", nil) .. publicUtil.getCount(currencyItemID))
end
function FarmShopPanel:updateExchangeStore()
	local activityExchangeMallRead = include("activityExchangeMallRead")
	self.exchangeData = activityExchangeMallRead:getShopItemList(self.activityID)
	self.fields.listExchange:setNumItems(#self.exchangeData)
end
local numsPerLine = 5
function FarmShopPanel:updateFruitStore()
	self.fruitData, manorCityCtrl = nil, nil
	local fruitdata = manorCityCtrl:getBagFruits()
	for i = #fruitdata, 1, -1 do
		if not manorFarmRead.getRecycle(fruitdata[i].id) then
			table.remove(fruitdata, i)
		end
	end
	for i, v in ipairs(fruitdata) do
		if i % numsPerLine == 1 then
			manorCityCtrl = nil
			;(nil).itemType = 1
			;(nil).list, manorCityCtrl, (nil).num = numsPerLine, numsPerLine, numsPerLine
			table.insert(self.fruitData, nil)
		end
		local line = self.fruitData[#self.fruitData]
		table.insert(line.list, v)
	end
	local lineCount = self.fields.listFruit:getHeight() / 120
	if lineCount > #self.fruitData then
		local diff = lineCount - #self.fruitData
		for i = 1, diff do
			manorCityCtrl = v
			v.list, manorCityCtrl, v.itemType = nil, nil, 1
			v.num = numsPerLine
			table.insert(self.fruitData, v)
		end
	end
	self.fields.listFruit:setNumItems(#self.fruitData)
	self.fields.btnAutoSell:setEnabled(0 < #fruitdata)
end
function FarmShopPanel:updateSeedStore()
	self.seedData, manorCityCtrl = nil, nil
	local seeddata = manorCityCtrl:getBagSeeds(function(a, b)
		if a.seedData.seedQuality == b.seedData.seedQuality then
			return a.seedData.seedID < b.seedData.seedID
		else
			return a.seedData.seedQuality > b.seedData.seedQuality
		end
	end)
	for i = #seeddata, 1, -1 do
		if not manorFarmRead.getRecycle(seeddata[i].id) then
			table.remove(seeddata, i)
		end
	end
	for i, v in ipairs(seeddata) do
		if i % numsPerLine == 1 then
			manorCityCtrl = nil
			;(nil).itemType = 1
			;(nil).list, manorCityCtrl, (nil).num = numsPerLine, numsPerLine, numsPerLine
			table.insert(self.seedData, nil)
		end
		local line = self.seedData[#self.seedData]
		table.insert(line.list, v)
	end
	local lineCount = self.fields.listSeed:getHeight() / 120
	if lineCount > #self.seedData then
		local diff = lineCount - #self.seedData
		for i = 1, diff do
			manorCityCtrl = v
			v.list, manorCityCtrl, v.itemType = nil, nil, 1
			v.num = numsPerLine
			table.insert(self.seedData, v)
		end
	end
	self.fields.listSeed:setNumItems(#self.seedData)
end
function FarmShopPanel:updateView()
	self.fields.comTab:clickTab(self.fields.comTab.curTab, true)
	self.fields.comTab:setToTag(self.fields.comTab.curTab)
end
return FarmShopPanel
