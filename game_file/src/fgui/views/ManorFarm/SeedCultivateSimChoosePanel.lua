local manorFarmRead = include("manorFarmRead")
local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SeedCultivateSimChoosePanel = class("SeedCultivateSimChoosePanel", baseFguiPanel)
function SeedCultivateSimChoosePanel:ctor(...)
	self.isLRU = true
	SeedCultivateSimChoosePanel.super.ctor(self, ...)
	print("SeedCultivateSimChoosePanel:ctor", self.viewName)
end
function SeedCultivateSimChoosePanel:onInit()
	print("=======SeedCultivateSimChoosePanel:onInit")
	self.fields.listType:setItemRenderer(handler(self, self.itemRenderer_listType))
	self.fields.listType:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem_listType))
	self.fields.listSeed:setItemRenderer(handler(self, self.itemRenderer_listSeed))
	self.fields.listSeed:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem_listSeed))
	self.fields.Panel_bg:setString(i18n("treasure_crystal_btn_02"))
	self.fields.btnMerge:setTitle(i18n("farmland_text_79"))
	self.fields.btnMerge:addClickListener(handler(self, self.onClick_btnMerge))
end
function SeedCultivateSimChoosePanel:endShow()
	print("=======SeedCultivateSimChoosePanel:endShow")
	if not self.param.isFruit then
		self:initData(self.param.isSource)
	else
		self.selectedType = nil
		self:initData_Fruit(0)
	end
end
function SeedCultivateSimChoosePanel:itemRenderer_listType(index, obj)
	local icon = manorFarmRead.getSeedTypeIcon(index)
	obj:initData(index, icon)
	if self.selectedType then
		if self.selectedType == index then
			obj.controllers.ctrlSelected:setSelectedIndex(2)
		else
			obj.controllers.ctrlSelected:setSelectedIndex(0)
		end
	else
		obj.controllers.ctrlSelected:setSelectedIndex(0)
	end
end
function SeedCultivateSimChoosePanel:onClickItem_listType(context)
	local seedType = context.data.type
	self.selectedType = seedType
	self.fields.listType:setNumItems(manorFarmRead.getSeedTypeNum())
	if self.param.isFruit then
		self:initData_Fruit(seedType)
	else
		self:initData(self.isSource, seedType)
	end
end
function SeedCultivateSimChoosePanel:itemRenderer_listSeed(index, obj)
	local data = self.param.isFruit and self.fruits[index + 1] or self.seeds[index + 1]
	if data then
		obj:initData(self.param.isFruit and data or data.seedID)
		if not self.param.isFruit then
			obj:setSelected(data.seedID == self.param.id)
		else
			obj:setSelected(data == self.selectedFruitID)
		end
	else
		obj:setEmpty()
	end
end
function SeedCultivateSimChoosePanel:onClickItem_listSeed(context)
	if not self.param.isFruit then
		self.param.callback(context.data.id, self.param.type)
		self:close()
	else
		self.selectedFruitID = context.data.id
		if self.selectedFruitID ~= self.param.fruitId then
			self.fields.btnMerge:setEnabled(true)
		else
			self.fields.btnMerge:setEnabled(false)
		end
	end
end
function SeedCultivateSimChoosePanel:onClick_btnMerge(context)
	if not self.selectedFruitID or self.param.fruitId == self.selectedFruitID then
		return
	end
	if self.param.isFruit then
		manorCityCtrl:reqFarmlandCultivateFruit(self.param.queue, self.selectedFruitID)
		self:close()
	else
		manorCityCtrl:reqFarmlandCultivateFruit(self.param.queue, self.selectedFruitID)
		self:close()
	end
end
function SeedCultivateSimChoosePanel:initData(isSource, type)
	self.controllers.ctrlType:setSelectedIndex(0)
	self.selectedType = self.selectedType or 0
	self.isSource = isSource
	type = type or 0
	self.fields.listType:setNumItems(manorFarmRead.getSeedTypeNum())
	self.seeds, manorFarmRead = self.fields.listType.setNumItems, self.fields.listType.setNumItems
	local _seeds = manorFarmRead.getAllSeedInfo()
	for i, v in ipairs(_seeds) do
		if isSource then
			_ENV = manorFarmRead.getSeedTypeNum()
			manorFarmRead.getSeedTypeNum()[1] = v.seedQuality < 6
			if manorFarmRead.getSeedTypeNum() then
				goto lbl_47
			end
		end
		_ENV = manorFarmRead.getSeedTypeNum()
		manorFarmRead.getSeedTypeNum()[1] = v.seedQuality > 1
		::lbl_47::
		if manorFarmRead.getSeedTypeNum()[1] and (type == 0 or v.seedType == type) then
			table.insert(self.seeds, v)
		end
	end
	table.sort(self.seeds, function(a, b)
		if a.seedQuality == b.seedQuality then
			return a.seedID < b.seedID
		else
			return a.seedQuality < b.seedQuality
		end
	end)
	self.fields.listSeed:setNumItems(#self.seeds)
end
function SeedCultivateSimChoosePanel:initData_Fruit(type)
	self.selectedFruitID = self.param.fruitId
	self.fields.btnMerge:setEnabled(false)
	type = type or 0
	self.selectedType = self.selectedType or 0
	self.fields.listType:setNumItems(manorFarmRead.getSeedTypeNum())
	self.controllers.ctrlType:setSelectedIndex(1)
	self.fruits = manorCityCtrl:getAllReceivedBookFruits(self.selectedType)
	table.sort(self.fruits, function(a, b)
		if not manorFarmRead.getSeedInfoByFruitID(tonumber(a)) then
			local manorFarmRead, seedA = manorFarmRead.getSeedInfoByFruitID(tonumber(a)), manorFarmRead.getSeedInfoByFruitID(tonumber(a))
		end
		if not manorFarmRead.getSeedInfoByFruitID(tonumber(b)) then
			local manorFarmRead, seedB = manorFarmRead.getSeedInfoByFruitID(tonumber(b)), manorFarmRead.getSeedInfoByFruitID(tonumber(b))
		end
		if (seedA.seedQuality or 0) == (seedB.seedQuality or 0) then
			return tonumber(a) > tonumber(b)
		end
		return (seedA.seedQuality or 0) > (seedB.seedQuality or 0)
	end)
	self.fields.listSeed:setNumItems(#self.fruits)
end
function SeedCultivateSimChoosePanel:gameGuide_getTarget(itemName, parameters)
