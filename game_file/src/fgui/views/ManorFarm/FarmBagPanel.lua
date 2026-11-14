local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local publicRead = include("publicRead")
local manorFarmRead = include("manorFarmRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local FarmBagPanel = class("FarmBagPanel", baseFguiPanel)
function FarmBagPanel:ctor(...)
	self.isLRU = true
	FarmBagPanel.super.ctor(self, ...)
	print("FarmBagPanel:ctor", self.viewName)
end
function FarmBagPanel:onInit()
	print("=======FarmBagPanel:onInit")
	self.fields.listBag:setVirtual()
	self.fields.listBag:setItemProvider(handler(self, self.itemProvider_listBag))
	self.fields.listBag:setItemRenderer(handler(self, self.itemRenderer_listBag))
	self.fields.listFruit:setVirtual()
	self.fields.listFruit:setItemProvider(handler(self, self.itemProvider_listFruit))
	self.fields.listFruit:setItemRenderer(handler(self, self.itemRenderer_listFruit))
	self.fields.listSeed:setVirtual()
	self.fields.listSeed:setItemProvider(handler(self, self.itemProvider_listSeed))
	self.fields.listSeed:setItemRenderer(handler(self, self.itemRenderer_listSeed))
	self.fields.Com_title:initData(i18n("garden_btn_09"), handler(self, self.onClickClose))
	self.fields.btnSearch:setTitle(i18n("common_text_166"))
	self.fields.btnSearch:addClickListener(handler(self, self.onClick_btnSearch))
	_ENV = handler(self, self.onClick_btnSearch)
	handler(self, self.onClick_btnSearch).prompt = i18n("common_text_4670")
	handler(self, self.onClick_btnSearch).cleanHandler = handler(self, self.onClick_btnSearchClear)
	handler(self, self.onClick_btnSearch).onChangedHandler = handler(self, self.onChange_inputBar)
	self.fields.inputBar:initInputData(handler(self, self.onClick_btnSearch))
	self.fields.inputBar:getChild("Button_all"):setVisible(false)
	_ENV = false
	_ENV, _ENV, (false).defaultClick = self, handler(self, self.onChange_inputBar), 1
	self.title = i18n("farmland_text_39")
	_ENV, handler(self, self.onChange_inputBar)[1], self.tag = self, self, 1
	self.title = i18n("farmland_text_40")
	_ENV, handler(self, self.onChange_inputBar)[2], self.tag = self, self, 2
	self.title = i18n("farmland_text_41")
	;(false).tabsetArray, handler(self, self.onChange_inputBar)[3], self.tag = handler(self, self.onChange_inputBar), self, 3
	;(false).callback = handler(self, self.onClickTab)
	self.fields.comTab:initView(false)
	self.fields.listType:setItemRenderer(handler(self, self.itemRenderer_listType))
	self.fields.listType:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem_listType))
end
function FarmBagPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("xxxx")
	uiManager:show("RuleView", nil)
end
function FarmBagPanel:endShow()
	print("=======FarmBagPanel:endShow")
	self.fields.inputBar:getChild("input"):setString("")
	self.fields.comTab:clickTab(1, true)
	self.fields.comTab:setToTag(1)
end
function FarmBagPanel:onHide()
	self.rawListData = nil
	self.showListData = nil
end
function FarmBagPanel:itemRenderer_listBag(index, obj)
	local data = self.showListData[index + 1]
	obj:initData(data, index + 1)
	if data.itemType == 1 then
		obj:setOnClickItem(handler(self, self.onClickItem_listBag))
	end
end
function FarmBagPanel:itemRenderer_listFruit(index, obj)
	local data = self.showListData[index + 1]
	obj:initData(data, index + 1)
	if data.itemType == 1 then
		obj:setOnClickItem(handler(self, self.onClickItem_listFruit))
	end
end
function FarmBagPanel:itemRenderer_listSeed(index, obj)
	local data = self.showListData[index + 1]
	obj:initData(data, index + 1)
	if data.itemType == 1 then
		obj:setOnClickItem(handler(self, self.onClickItem_listSeed))
	end
end
function FarmBagPanel:itemProvider_listBag(index)
	local data = self.showListData[index + 1]
	if data.itemType == 1 then
		return "ui://ManorFarm/ComBagLine"
	elseif data.itemType == 2 then
		return "ui://ManorFarm/Com_bagItemInfo"
	end
end
function FarmBagPanel:itemProvider_listFruit(index)
	local data = self.showListData[index + 1]
	if data.itemType == 1 then
		return "ui://ManorFarm/ComBagLine"
	elseif data.itemType == 2 then
		return "ui://ManorFarm/Com_bagItemInfo"
	end
end
function FarmBagPanel:itemProvider_listSeed(index)
	local data = self.showListData[index + 1]
	if data.itemType == 1 then
		return "ui://ManorFarm/ComBagLine"
	elseif data.itemType == 2 then
		return "ui://ManorFarm/Com_bagItemInfo"
	end
end
function FarmBagPanel:onClickItem_listBag(context, index)
	SoraDPlaySound()
	local obj = context.data
	self:addInfoItem(index, obj)
end
function FarmBagPanel:onClickItem_listFruit(context, index)
	SoraDPlaySound()
	local obj = context.data
	self:addInfoItem(index, obj)
end
function FarmBagPanel:onClickItem_listSeed(context, index)
	SoraDPlaySound()
	local obj = context.data
	self:addInfoItem(index, obj)
end
function FarmBagPanel:onChange_inputBar(text)
	local str = text
	if str ~= "" then
	else
	end
end
function FarmBagPanel:addInfoItem(index, obj)
	local removedLastInfo = false
	for i, v in ipairs(self.showListData) do
		if v.itemType == 2 then
			table.remove(self.showListData, i)
			removedLastInfo = i
			break
		end
	end
	if not obj.id then
		self.listObj:setNumItems(#self.showListData)
		self.listObj:EnsureBoundsCorrect()
		return
	end
	local insertIndex = index + 1 + (removedLastInfo and index >= removedLastInfo and -1 or 0)
	_ENV = nil
	_ENV, (nil).itemType = table.remove, 2
	table.remove.itemId = obj.id
	;(nil).data, table.remove.curPosX = table.remove, obj:getPositionX() + obj:getWidth() / 2
	table.insert(self.showListData, insertIndex, nil)
	self.listObj:setNumItems(#self.showListData)
	self.listObj:EnsureBoundsCorrect()
	obj:setMovieBorder(true)
end
function FarmBagPanel:itemRenderer_listType(index, obj)
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
function FarmBagPanel:onClickItem_listType(context)
	SoraDPlaySound()
	local seedType = context.data.type
	self.selectedType = seedType
	self.fields.listType:setNumItems(manorFarmRead.getSeedTypeNum())
	self:processData(self.fields.comTab.curTab, seedType)
	self.fields.inputBar:getChild("input"):setText("")
	self.fields.inputBar:getChild("Button_all"):setVisible(false)
end
function FarmBagPanel:onClick_btnSearch(context)
	SoraDPlaySound()
	local itemName = self.fields.inputBar:getChild("input"):getText()
	if itemName == "" then
		SoraDShowMsgTip(i18n("common_text_4670"))
		return
	end
	local removedLastInfo = false
	for i, v in ipairs(self.showListData) do
		if v.itemType == 2 then
			table.remove(self.showListData, i)
			removedLastInfo = i
			break
		end
	end
	local _ENV, results = (for generator), ipairs(self.showListData)
	for index, data in ipairs(self.rawListData) do
		local thisItemName = publicRead.getName(data.id)
		if string.find(thisItemName, itemName, 1, true) then
			table.insert(results, data)
		end
	end
	self:processData(self.fields.comTab.curTab, nil, results)
end
function FarmBagPanel:onClick_btnSearchClear(context)
	self:processData(self.fields.comTab.curTab)
end
function FarmBagPanel:onClickTab(tag)
	self:initData(tag, 0)
end
function FarmBagPanel:initData(tag)
	self.controllers.ctrlPage:setSelectedIndex(tag - 1)
	self:processData(tag, 0)
end
function FarmBagPanel:processData(tag, type, listData_search)
	local rawlistData
	self.selectedType = type or self.selectedType
	local oldTag = self.fields.comTab.curTab
	if oldTag ~= tag then
		self.selectedType = 0
	end
	if listData_search then
		rawlistData = listData_search
	else
		if tag == 1 then
			self.fields.listType:setNumItems(manorFarmRead.getSeedTypeNum())
			rawlistData = manorCityCtrl:getBagSeeds(function(a, b)
				if a.seedData.seedQuality == b.seedData.seedQuality then
					return a.seedData.seedID < b.seedData.seedID
				else
					return a.seedData.seedQuality > b.seedData.seedQuality
				end
			end)
		elseif tag == 2 then
			self.fields.listType:setNumItems(manorFarmRead.getSeedTypeNum())
			rawlistData = manorCityCtrl:getBagFruits()
		elseif tag == 3 then
			self.selectedType = nil
			rawlistData = manorCityCtrl:getSeedpacks()
			table.sort(rawlistData, function(a, b)
				return a.seedpackData.index < b.seedpackData.index
			end)
		end
		if self.selectedType and self.selectedType ~= 0 then
			for i = #rawlistData, 1, -1 do
				local seed = rawlistData[i].seedData
				if seed.seedType ~= self.selectedType then
					table.remove(rawlistData, i)
				end
			end
		end
		self.rawListData = rawlistData
	end
	self.showListData, manorFarmRead = #rawlistData, #rawlistData
	local showIndex = 1
	manorFarmRead = 1
	;(1).list, manorFarmRead, (1).itemType = -1, -1, 1
	local (1).num, lineData = 5, 1
	table.insert(self.showListData, lineData)
	for i, v in ipairs(rawlistData) do
		if v.count > 99999 then
			local fullNum = math.floor(v.count / 99999)
			local lastNum = v.count % 99999
			for j = 1, fullNum do
				local newV = clone(v)
				newV.count = 99999
				table.insert(self.showListData[#self.showListData].list, newV)
				showIndex = showIndex + 1
				if (showIndex - 1) % 5 == 0 then
					manorFarmRead = (showIndex - 1) % 5
					;(showIndex - 1) % 5.list, manorFarmRead, (showIndex - 1) % 5.itemType = self.showListData[#self.showListData].list, self.showListData[#self.showListData].list, 1
					local (showIndex - 1) % 5.num, lineData = 5, (showIndex - 1) % 5
					table.insert(self.showListData, lineData)
				end
			end
			if 0 < lastNum then
				local newV = clone(v)
				newV.count = lastNum
				table.insert(self.showListData[#self.showListData].list, newV)
				showIndex = showIndex + 1
				if (showIndex - 1) % 5 == 0 then
					manorFarmRead = (showIndex - 1) % 5
					;(showIndex - 1) % 5.list, manorFarmRead, (showIndex - 1) % 5.itemType = self.showListData[#self.showListData].list, self.showListData[#self.showListData].list, 1
					local (showIndex - 1) % 5.num, lineData = 5, (showIndex - 1) % 5
					table.insert(self.showListData, lineData)
				end
			end
		else
			table.insert(self.showListData[#self.showListData].list, v)
			showIndex = showIndex + 1
			if (showIndex - 1) % 5 == 0 then
				manorFarmRead = (showIndex - 1) % 5
				;(showIndex - 1) % 5.list, manorFarmRead, (showIndex - 1) % 5.itemType = self.showListData[#self.showListData].list, self.showListData[#self.showListData].list, 1
				local (showIndex - 1) % 5.num, lineData = 5, (showIndex - 1) % 5
				table.insert(self.showListData, lineData)
			end
		end
	end
	if tag == 1 then
		self.listObj = self.fields.listSeed
	elseif tag == 2 then
		self.listObj = self.fields.listFruit
	elseif tag == 3 then
		self.listObj = self.fields.listBag
	end
	local lineCount = self.listObj:getHeight() / 120
	if lineCount > #self.showListData then
		local diff = lineCount - #self.showListData
		for i = 1, diff do
			manorFarmRead = lineData
			lineData.list, manorFarmRead, lineData.itemType = table.insert, table.insert, 1
			lineData.num = 5
			table.insert(self.showListData, lineData)
		end
	end
	self.listObj:setNumItems(#self.showListData)
end
function FarmBagPanel:getGetBagTabPos()
	local tab = self.fields.comTab:getBtn(1)
	return cc.p(tab:getPositionX() + tab:getWidth() / 2, tab:getPositionY() + tab:getHeight() / 2)
end
return FarmBagPanel
