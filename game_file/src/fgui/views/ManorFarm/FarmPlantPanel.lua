local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local manorFarmRead = include("manorFarmRead")
local manorCityUtil = include("manorCityUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local FarmPlantPanel = class("FarmPlantPanel", baseFguiPanel)
function FarmPlantPanel:ctor(...)
	self.isLRU = true
	FarmPlantPanel.super.ctor(self, ...)
	print("FarmPlantPanel:ctor", self.viewName)
end
function FarmPlantPanel:onInit()
	print("=======FarmPlantPanel:onInit")
	self.fields.listPlant:setVirtual()
	self.fields.listPlant:setItemRenderer(handler(self, self.itemRenderer_listPlant))
	self.fields.listPlant:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem_listPlant))
	self.fields.listSeed:setVirtual()
	self.fields.listSeed:setItemRenderer(handler(self, self.itemRenderer_listSeed))
	self.fields.listSeed:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem_listSeed))
	self.fields.listType:setItemRenderer(handler(self, self.itemRenderer_listType))
	self.fields.listType:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem_listType))
	self.fields.Com_title:initData(i18n("farmland_text_15"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.btnAutoPlant:setTitle(i18n("farmland_text_20"))
	self.fields.btnAutoPlant:addClickListener(handler(self, self.onClick_btnAutoPlant))
	self.fields.btnReceive:setTitle(i18n("ice_carnival_text05"))
	self.fields.btnReceive:addClickListener(handler(self, self.onClick_btnReceive))
	self.fields.btnPlant:setTitle(i18n("farmland_text_21"))
	self.fields.btnPlant:addClickListener(handler(self, self.onClick_btnPlant))
	self.fields.txtBag:setString(i18n("farmland_text_10"))
end
function FarmPlantPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("farmland_text_86")
	uiManager:show("RuleView", nil)
end
function FarmPlantPanel:endShow()
	print("=======FarmPlantPanel:endShow")
	_ENV = nil
	;(nil).byUID = true
	local fakePlants = SoraDConfigGet("Game:ManorFarm:FakePlant~string", nil) or ""
	local strTable = SoraDStringSplit(fakePlants, ",")
	self.fakePlants, _ENV = fakePlants, fakePlants
	for i = 1, #strTable, 2 do
		local iid = tonumber(strTable[i])
		local seedId = tonumber(strTable[i + 1])
		if iid and seedId then
			self.fakePlants[iid] = seedId
		end
	end
	self.selectedType = 0
	self:initData()
end
function FarmPlantPanel:onHide()
	self:saveFakePlant()
end
function FarmPlantPanel:saveFakePlant()
	local str = ""
	for k, v in pairs(self.fakePlants) do
		str = str .. k .. "," .. v .. ","
	end
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:ManorFarm:FakePlant~string", str, nil)
end
function FarmPlantPanel:itemRenderer_listPlant(index, obj)
	local data = self.plants[index + 1]
	local ret = obj:initData(data, self.fakePlants[data.iid])
	if ret and ret == -1 then
		self.fakePlants[data.iid] = nil
		self:initData()
	end
end
function FarmPlantPanel:itemRenderer_listSeed(index, obj)
	local data = self.seeds[index + 1]
	obj:initData(data.id, data.count)
	obj:setSelected(false)
	for k, v in pairs(self.fakePlants) do
		if v == data.id then
			obj:setSelected(true)
			return
		end
	end
end
function FarmPlantPanel:itemRenderer_listType(index, obj)
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
function FarmPlantPanel:onClickItem_listType(context)
	SoraDPlaySound()
	self.selectedType = context.data.type
	self.fields.listType:setNumItems(manorFarmRead.getSeedTypeNum())
	self:initData()
end
function FarmPlantPanel:onClick_btnAutoPlant(context)
	SoraDPlaySound()
	self:autoPlant()
	self:updateAutoPlantEnabled()
end
function FarmPlantPanel:onClick_btnReceive(context)
	SoraDPlaySound()
	self.savedPlants, _ENV = SoraDPlaySound, SoraDPlaySound
	for i, v in ipairs(self.plants) do
		local canReceive = manorCityUtil.canReceiveFarmFruit(v.iid)
		if canReceive then
			self.savedPlants[v.iid] = v.extra.plant.seedId
		end
	end
	manorCityCtrl:reqFarmlandPickFruit()
	SoraDShowLoading(self, nil, gCmd.REQ_GARDEN_FARMLAND_PICK_FRUIT)
end
function FarmPlantPanel:autoReplant()
	if not self.savedPlants or table.nums(self.savedPlants) == 0 then
		return
	end
	for k, v in pairs(self.savedPlants) do
		for i, seed in ipairs(self.allSeeds or self.seeds) do
			if seed.id == v and 0 < seed.count then
				self:plantFakeSeed(k, v, true)
				self:updateFakeSeedNum(self.allSeeds or self.seeds)
			end
		end
	end
	self.savedPlants, _ENV = pairs(self.savedPlants)
	self:initData()
end
function FarmPlantPanel:onClick_btnPlant(context)
	SoraDPlaySound()
	local _ENV, data = SoraDPlaySound, SoraDPlaySound
	for k, v in pairs(self.fakePlants) do
		_ENV = nil
		;(nil).iid = k
		;(nil).seedId = v
		table.insert(data, nil)
	end
	manorCityCtrl:reqFarmlandPlant(data)
	SoraDShowLoading(self, nil, gCmd.REQ_GARDEN_FARMLAND_PLANT)
end
function FarmPlantPanel:onClickItem_listPlant(context)
	local obj = context.data
	local status = manorCityUtil.getFarmStatus(obj.data.iid)
	if status == 0 then
		SoraDShowMsgTip(i18n("farmland_text_17"))
	elseif status == 1 and not self.fakePlants[obj.data.iid] then
		SoraDShowMsgTip(i18n("farmland_text_16"))
	else
		if status == 2 then
			manorCityCtrl:reqFarmlandPickFruit(obj.data.iid)
			SoraDShowLoading(self, nil, gCmd.REQ_GARDEN_FARMLAND_PICK_FRUIT)
		else
		end
	end
end
function FarmPlantPanel:onClickItem_listSeed(context)
	local obj = context.data
	local result = self:autoPlant(obj.id)
	self:initData()
end
function FarmPlantPanel:getSortedBagSeeds()
	return manorCityCtrl:getBagSeeds(function(a, b)
		if a.seedData.seedQuality == b.seedData.seedQuality then
			return a.seedData.seedID < b.seedData.seedID
		else
			return a.seedData.seedQuality > b.seedData.seedQuality
		end
	end)
end
function FarmPlantPanel:filterSeedsByType(seeds)
	if not self.selectedType or self.selectedType == 0 then
		return seeds
	end
	local _ENV, result = self.selectedType, self.selectedType
	for __, seed in ipairs(seeds) do
		if seed.seedData and seed.seedData.seedType == self.selectedType then
			table.insert(result, seed)
		end
	end
	return result
end
function FarmPlantPanel:initData()
	self.plants = manorCityCtrl:getPlants()
	table.sort(self.plants, function(a, b)
		local statusA, statusB = manorCityUtil.getFarmStatus(a), manorCityUtil.getFarmStatus(b)
		if statusA == statusB then
			if a.lv == b.lv then
				return a.extra.type < b.extra.type
			else
				return a.lv > b.lv
			end
		else
			return statusA > statusB
		end
	end)
	self.fields.listPlant:setNumItems(#self.plants)
	self.fields.listType:setNumItems(manorFarmRead.getSeedTypeNum())
	self.allSeeds = self:getSortedBagSeeds()
	self.allSeeds = self:updateFakeSeedNum(self.allSeeds)
	self.seeds = self:filterSeedsByType(self.allSeeds)
	self.fields.listSeed:setNumItems(#self.seeds)
	self.fields.btnReceive:setEnabled(false)
	for i, v in ipairs(self.plants) do
		if manorCityUtil.canReceiveFarmFruit(v.iid) then
			self.fields.btnReceive:setEnabled(true)
			break
		end
	end
	self:updateAutoPlantEnabled()
end
function FarmPlantPanel:plantFakeSeed(iid, seedId, noRefresh)
	if not self.fakePlants then
		_UPVALUE0_ = self.fakePlants
	end
	self.fakePlants = self.fakePlants
	self.fakePlants[iid] = seedId
	if not noRefresh then
		self:initData()
	end
end
function FarmPlantPanel:removeFakeSeed(iid)
	if self.fakePlants[iid] then
		self.fakePlants[iid] = nil
		self:initData()
	end
end
function FarmPlantPanel:updateFakeSeedNum(seeds)
	local canReqPlant = false
	for iid, seedId in pairs(self.fakePlants) do
		canReqPlant = true
		for i, v in ipairs(seeds) do
			if v.id == seedId then
				v.count = v.count - 1
				if v.count < 0 then
					v.count = 0
				end
			end
		end
	end
	if canReqPlant then
		self.fields.btnPlant:setEnabled(true)
	else
		self.fields.btnPlant:setEnabled(false)
	end
	return seeds
end
function FarmPlantPanel:isSeedFruitBookUnlocked(seedData)
	return manorCityCtrl:getReceivedFarmBookItem(seedData.fruitID) == true
end
function FarmPlantPanel:buildAutoPlantSeedUnits(seedStacks, maxCount)
	local _ENV, seedUnits
	for __, seed in ipairs(seedStacks) do
		local count = math.min(seed.count, maxCount)
		local isBookUnlocked = self:isSeedFruitBookUnlocked(seed.seedData)
		for _ = 1, count do
			_ENV = nil
			;(nil).id = seed.id
			;(nil).seedData = seed.seedData
			;(nil).isBookUnlocked = isBookUnlocked
			;(nil).randomKey = math.random()
			table.insert(seedUnits, nil)
		end
	end
	return seedUnits
end
function FarmPlantPanel:getAutoPlantSeedMatch(seed, plants)
	local matchProduction = 0
	for __, plant in ipairs(plants) do
		local match = manorFarmRead.getTypeMatch(plant.data.extra.type, seed.seedData.seedType)
		if matchProduction < match.production then
			matchProduction = match.production
		end
	end
	return matchProduction
end
function FarmPlantPanel:isBetterAutoPlantSeed(seed, otherSeed, plants)
	if not otherSeed then
		return true
	end
	local matchProduction = self:getAutoPlantSeedMatch(seed, plants)
	local otherMatchProduction = self:getAutoPlantSeedMatch(otherSeed, plants)
	if matchProduction ~= otherMatchProduction then
		return matchProduction > otherMatchProduction
	end
	if seed.isBookUnlocked ~= otherSeed.isBookUnlocked then
		return not seed.isBookUnlocked
	end
	if seed.seedData.seedQuality ~= otherSeed.seedData.seedQuality then
		return seed.seedData.seedQuality > otherSeed.seedData.seedQuality
	end
	return seed.randomKey < otherSeed.randomKey
end
function FarmPlantPanel:getAutoPlantTarget(seed, plants)
	local targetIndex
	local targetMatchProduction = 0
	local targetLevel = 0
	local targetRandomKey = 0
	for index, plant in ipairs(plants) do
		local match = manorFarmRead.getTypeMatch(plant.data.extra.type, seed.seedData.seedType)
		local isBetterMatch = targetMatchProduction < match.production
		local isSameMatch = match.production == targetMatchProduction
		local isBetterLevel = targetLevel < plant.data.lv
		local isSameLevel = plant.data.lv == targetLevel
		if isBetterMatch or isSameMatch and (isBetterLevel or isSameLevel and targetRandomKey > plant.randomKey) then
			targetIndex = index
			targetMatchProduction = match.production
			targetLevel = plant.data.lv
			targetRandomKey = plant.randomKey
		end
	end
	return targetIndex
end
function FarmPlantPanel:autoPlant(seedId)
	local _ENV, result
	if seedId then
		for i, v in ipairs(self.allSeeds or self.seeds) do
			if v.id == seedId and v.count == 0 then
				return result
			end
		end
		local plants = manorCityCtrl:getEmptyPlants(self.fakePlants)
		if #plants == 0 then
			return result
		end
		local seedType = manorFarmRead.getSeedInfo(seedId).seedType
		table.sort(plants, function(a, b)
			local matchA = manorFarmRead.getTypeMatch(a.extra.type, seedType)
			local matchB = manorFarmRead.getTypeMatch(b.extra.type, seedType)
			if matchA.production == matchB.production then
				return a.lv > b.lv
			else
				return matchA.production > matchB.production
			end
		end)
		result[plants[1].iid] = seedId
		self:plantFakeSeed(plants[1].iid, seedId)
	else
		local seedStacks = manorCityCtrl:getBagSeeds()
		seedStacks = self:updateFakeSeedNum(seedStacks)
		local emptyPlants = manorCityCtrl:getEmptyPlants(self.fakePlants)
		local _ENV, plants = manorCityCtrl, manorCityCtrl
		for __, plant in ipairs(emptyPlants) do
			_ENV = nil
			;(nil).data = plant
			;(nil).randomKey = math.random()
			table.insert(plants, nil)
		end
		local seedUnits = self:buildAutoPlantSeedUnits(seedStacks, #plants)
		while 0 < #plants and 0 < #seedUnits do
			local seedIndex, seed
			for index, candidate in ipairs(seedUnits) do
				if self:isBetterAutoPlantSeed(candidate, seed, plants) then
					seedIndex = index
					seed = candidate
				end
			end
			if not seed then
				break
			end
			local plantIndex = self:getAutoPlantTarget(seed, plants)
			local plant = plants[plantIndex].data
			result[plant.iid] = seed.id
			self:plantFakeSeed(plant.iid, seed.id, true)
			table.remove(seedUnits, seedIndex)
			table.remove(plants, plantIndex)
		end
		if next(result) then
			self:initData()
		end
	end
	return result
end
function FarmPlantPanel:updateAutoPlantEnabled()
	local canAutoPlant1, canAutoPlant2, canAutoPlant3 = false, false, table.nums(self.fakePlants) ~= #self.plants
	for i, v in ipairs(self.plants) do
		if manorCityUtil.getFarmStatus(v.iid) == 1 then
			canAutoPlant1 = true
			break
		end
	end
	for i, v in ipairs(self.allSeeds or self.seeds) do
		if v.count > 0 then
			canAutoPlant2 = true
			break
		end
	end
	if canAutoPlant3 then
		for k, v in pairs(self.fakePlants) do
			if v == 0 then
				canAutoPlant3 = true
				break
			end
		end
	end
	self.fields.btnAutoPlant:setEnabled(canAutoPlant1 and canAutoPlant2 and canAutoPlant3)
end
return FarmPlantPanel
