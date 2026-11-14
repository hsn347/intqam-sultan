local ltBase = include("ltBase")
local shopltCtrl = class("shopltCtrl", ltBase, include("aAReadClass").new())
function shopltCtrl:ctor()
	shopltCtrl.super.ctor(self)
	self:init()
end
function shopltCtrl:release()
	self:stopTimer()
	self:init()
end
function shopltCtrl:init()
	self.itemID_quickitem_list, _ENV, self.quick_shop_list, _ENV, self.other_item_list, _ENV, self.buff_item_list, _ENV, self.battle_item_list, _ENV, self.resource_item_list, _ENV, self.itemID_shopItem_list, _ENV, self.item_shop_list, _ENV, self.itemLadderPrice, _ENV = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	local ltTable
	if _G.IsArClient then
		ltTable = require_once("app." .. LocalTblPath .. ".config_server.shop_ar")
	else
		ltTable = require_once("app." .. LocalTblPath .. ".config_server.shop_en")
	end
	local _ENV, shoplt = require_once("app." .. LocalTblPath .. ".config_server.shop_en"), require_once("app." .. LocalTblPath .. ".config_server.shop_en")
	for index, v in pairs(ltTable) do
		v.index = index
		shoplt[v.shopItemID] = v
	end
	self.shopItemList = shoplt
	for shopItemID, v in pairs(self.shopItemList) do
		local itemID = v.itemId
		v.weight = 0
		v.id = itemID
		if gStatus.YES == v.hot or true == v.hot then
			v.hot = true
			v.weight = v.weight + 1
		else
			v.hot = false
		end
		if gStatus.YES == v.new or true == v.new then
			v.new = true
			v.weight = v.weight + 2
		else
			v.new = false
		end
		if v.shopShowType == 1 then
			self.item_shop_list[shopItemID] = v
			self.itemID_shopItem_list[itemID] = v
			if v.type == 0 then
				if shopItemID ~= 1000236 and shopItemID ~= 1000237 then
					table.insert(self.other_item_list, v)
				end
			elseif v.type == 1 then
				table.insert(self.resource_item_list, v)
			elseif v.type == 2 then
				table.insert(self.battle_item_list, v)
			elseif v.type == 3 then
				table.insert(self.buff_item_list, v)
			end
		elseif v.shopShowType == 2 then
			self.quick_shop_list[shopItemID] = v
			if not self.itemID_quickitem_list[itemID] then
				_ENV = self.itemID_quickitem_list[itemID]
			end
			self.itemID_quickitem_list[itemID] = self.itemID_quickitem_list[itemID]
			table.insert(self.itemID_quickitem_list[itemID], v)
		end
	end
	local sortFun = function(l, r)
		if l.weight == r.weight then
			return l.index < r.index
		else
			return l.weight > r.weight
		end
	end
	table.sort(self.other_item_list, sortFun)
	table.sort(self.resource_item_list, sortFun)
	table.sort(self.battle_item_list, sortFun)
	table.sort(self.buff_item_list, sortFun)
	self.treasureCourtNormal, _ENV = table.sort, table.sort
	local tlTreasureCourt = require_once("app." .. LocalTblPath .. ".config_server.treasure_court_shop")
	for i, v in ipairs(tlTreasureCourt) do
		print(i, v)
		if v.type == 1 then
			self.treasureCourtSuper = v
		else
			table.insert(self.treasureCourtNormal, v)
		end
	end
	table.sort(self.treasureCourtNormal, function(l, r)
		return l.show < r.show
	end)
	local name
	if name == "treasureCourtNormal" then
		return self.treasureCourtNormal
	elseif name == "treasureCourtSuper" then
		return self.treasureCourtSuper
	end
end
function shopltCtrl:initializeCustomConfig(customConfig)
	if customConfig then
		for _, v in pairs(customConfig) do
			local shopItemID = v.shopItemID
			self:setCustomConfig(shopItemID, v)
		end
	end
	self:sortList()
	self:createRefreshTimeList()
	self:startTimer()
	self:initShopNewTag()
end
function shopltCtrl:updateCustomConfig(shopItemID, config)
	self:setCustomConfig(shopItemID, config)
	self:sortList()
	self:createRefreshTimeList()
	self:initShopNewTag()
end
function shopltCtrl:setCustomConfig(shopItemID, config)
	if not shopItemID then
		return
	end
	config.weight = 0
	if gStatus.YES == config.hot or true == config.hot then
		config.hot = true
		config.weight = config.weight + 1
	else
		config.hot = false
	end
	if gStatus.YES == config.new or true == config.new then
		config.new = true
		config.weight = config.weight + 2
	else
		config.new = false
	end
	local currentConfig = self.shopItemList[shopItemID]
	if currentConfig then
		for k, v in pairs(config) do
			currentConfig[k] = v
		end
	end
end
function shopltCtrl:sortList()
	local sortFun = function(l, r)
		if l.weight == r.weight then
			return l.index < r.index
		else
			return l.weight > r.weight
		end
	end
	table.sort(self.other_item_list, sortFun)
	table.sort(self.resource_item_list, sortFun)
	table.sort(self.battle_item_list, sortFun)
	table.sort(self.buff_item_list, sortFun)
end
function shopltCtrl:initShopNewTag()
	local itemLogic = include("itemLogic")
	_UPVALUE4_, self.newTagCfg, _ENV = "itemLogic", "itemLogic", "itemLogic"
	;("itemLogic")[1] = "other_item_list"
	;("itemLogic")[2] = "resource_item_list"
	;("itemLogic")[3] = "battle_item_list"
	local ("itemLogic")[4], keyCfg = "buff_item_list", "itemLogic"
	for _, tb in ipairs(keyCfg) do
		local tmpTb = self[tb]
		for k, v in pairs(tmpTb) do
			if v.new and self:isShopItemValid(v.shopItemID) and itemLogic.checkUseCond(v.itemId) and self:isShopItemNew(v.shopItemID) then
				self.newTagCfg[tb] = true
				self.newTagCfg.all = true
			end
		end
	end
end
function shopltCtrl:getShopNewTag(tagKey)
	return self.newTagCfg[tagKey] or false
end
function shopltCtrl:getShopItemType(shopItemID)
	return self:getProperty(self.shopItemList, shopItemID, "type")
end
function shopltCtrl:getResultID(shopItemID)
	return self:getProperty(self.shopItemList, shopItemID, "itemId")
end
function shopltCtrl:getResultNum(shopItemID)
	return self:getProperty(self.shopItemList, shopItemID, "number")
end
function shopltCtrl:getPrice(shopItemID)
	return self:getProperty(self.shopItemList, shopItemID, "price")
end
function shopltCtrl:getShopType(shopItemID)
	return self:getProperty(self.shopItemList, shopItemID, "shopShowType")
end
function shopltCtrl:isHot(shopItemID)
	return self:getProperty(self.shopItemList, shopItemID, "hot")
end
function shopltCtrl:isNew(shopItemID)
	return self:getProperty(self.shopItemList, shopItemID, "new")
end
function shopltCtrl:isLimitShopItem(shopItemID)
	local value = self:getProperty(self.shopItemList, shopItemID, "limit")
	return gShopLimitType.None ~= value
end
function shopltCtrl:getLimitNum(shopItemID)
	return self:getProperty(self.shopItemList, shopItemID, "limitNum")
end
function shopltCtrl:isLadderItem(shopItemID)
	return self:getProperty(self.shopItemList, shopItemID, "isLadder")
end
function shopltCtrl:getLadderPriceCfg(shopItemID)
	return self:getProperty(self.shopItemList, shopItemID, "ladderPrice")
end
function shopltCtrl:getLadderPrice(shopItemID, count)
	if not self.itemLadderPrice[shopItemID] then
		local priceCfg = self:getLadderPriceCfg(shopItemID)
		local _ENV, tb = self, self
		for i = 1, #priceCfg - 1, 2 do
			_ENV = nil
			;(nil).num = priceCfg[i]
			;(nil).price = priceCfg[i + 1]
			table.insert(tb, nil)
		end
		self.itemLadderPrice[shopItemID] = tb
	end
	local priceInfo = self.itemLadderPrice[shopItemID]
	local price = priceInfo[1].price
	for _, v in ipairs(priceInfo) do
		if count < v.num then
			break
		end
		price = v.price
	end
	return price
end
function shopltCtrl:getShopItemList()
	return self.item_shop_list
end
function shopltCtrl:getResourceItemList()
	return self.resource_item_list
end
function shopltCtrl:getBattleItemList()
	return self.battle_item_list
end
function shopltCtrl:getBuffItemList()
	return self.buff_item_list
end
function shopltCtrl:getOtherItemList()
	return self.other_item_list
end
function shopltCtrl:getClassifyShopItemList()
	local _UPVALUE0_, list
	list.resource = self:getResourceItemList()
	list.battle = self:getBattleItemList()
	list.gain = self:getBuffItemList()
	list.other = self:getOtherItemList()
	return list
end
function shopltCtrl:isShopItem(shopItemID)
	if "number" == type(shopItemID) and self.item_shop_list[shopItemID] then
		return self.item_shop_list[shopItemID]
	end
end
function shopltCtrl:getShopItemByItemID(itemID)
	if itemID then
		local shopItem = self.itemID_shopItem_list[itemID]
		if shopItem then
			local shopItemID = shopItem.shopItemID
			if self:isShopItemValid(shopItemID) then
				return shopItem
			end
		end
	end
end
function shopltCtrl:getShopItemByShopItem(shopID)
	if shopID then
		for _, v in pairs(self.shopItemList) do
			if v.shopItemID == shopID then
				return v
			end
		end
	end
end
function shopltCtrl:getPriceByItemID(itemID)
	if itemID then
		local shopItem = self.itemID_shopItem_list[itemID]
		if shopItem then
			return shopItem.price
		end
	end
end
function shopltCtrl:isShopItemValid(shopItemID)
	local beginTime = self:getProperty(self.shopItemList, shopItemID, "begintime")
	local endTime = self:getProperty(self.shopItemList, shopItemID, "endtime")
	if "number" ~= type(beginTime) or "number" ~= type(endTime) then
		return true
	end
	if 0 == beginTime and 0 == endTime then
		return true
	end
	local curTime = serviceFunctions.systemTime()
	if beginTime <= curTime and endTime >= curTime then
		return true
	end
	return false
end
function shopltCtrl:isShopItemNew(shopItemID)
	local shopType = self:getShopItemType(shopItemID)
	local timeCfgKey = shopType == 0 and 4 or shopType
	_ENV = "Game:shopltCtrl:newShopItemReadTime~integer"
	;("Game:shopltCtrl:newShopItemReadTime~integer").byUID = true
	local lastReadTime = SoraDConfigGet(string.format("Game:shopltCtrl:newShopItemReadTime~integer", timeCfgKey), "Game:shopltCtrl:newShopItemReadTime~integer") or 0
	local beginTime = self:getProperty(self.shopItemList, shopItemID, "begintime")
	if "number" ~= type(beginTime) or 0 == beginTime then
		return false
	end
	if 0 == lastReadTime then
		return true
	end
	if lastReadTime <= beginTime then
		return true
	end
	print("isShopItemNew", beginTime, lastReadTime)
	return false
end
function shopltCtrl:updateShopNewTagTime(tabTag, needSort)
	local curTime = serviceFunctions.systemTime()
	_ENV = tabTag
	tabTag.byUID = true
	local lastReadTime = SoraDConfigSet(string.format("Game:shopltCtrl:newShopItemReadTime~integer", tabTag), curTime, tabTag)
	if needSort then
		self:initShopNewTag()
	end
end
function shopltCtrl:getQuickShopItemArrayByItemID(itemID)
	if itemID then
		local list = self.itemID_quickitem_list[itemID]
		local _ENV, ret
		if list then
			for _, v in ipairs(list) do
				local shopItemID = v.shopItemID
				if self:isShopItemValid(shopItemID) then
					table.insert(ret, v)
				end
			end
		end
		return ret
	end
end
function shopltCtrl:getQuickShopItem(shopItemID)
	return self.quick_shop_list[shopItemID]
end
function shopltCtrl:getTreasureCourtNormalList()
	if not self.treasureCourtNormal then
		_UPVALUE0_ = self.treasureCourtNormal
	end
	return self.treasureCourtNormal
end
function shopltCtrl:getTreasureCourtSuper()
	if not self.treasureCourtSuper then
		_UPVALUE0_ = self.treasureCourtSuper
	end
	return self.treasureCourtSuper
end
function shopltCtrl:startTimer()
	if not self.timer_handle then
		self.timer_handle = SoradCreateTimer(self, function()
			local time = self.refreshTimeList[1]
			if time then
				local currentTime = serviceFunctions.systemTime()
				if time < currentTime then
					table.remove(self.refreshTimeList, 1)
					self:initShopNewTag()
					print("商品配置刷新============================")
					self = "商品配置刷新============================"
					;("商品配置刷新============================").msg = "MESSAGE_ITEM_LIMITITEM_TIMEOUT_BACK"
					SoraDSendMessage("商品配置刷新============================")
				end
			end
		end)
	end
end
function shopltCtrl:stopTimer()
	if self.timer_handle then
		SoraDManagerRemoveTimer(self, self.timer_handle)
		self.timer_handle = nil
	end
end
function shopltCtrl:createRefreshTimeList()
	local _ENV, timelist
	local _ENV, temp
	local addlist = function(time)
		if time and time > serviceFunctions.systemTime() and not temp[time] then
			table.insert(timelist, time)
			temp[time] = true
		end
	end
	for _, v in pairs(self.shopItemList) do
		addlist(v.begintime)
		addlist(v.endtime)
	end
	table.sort(timelist)
	self.refreshTimeList = timelist
end
function shopltCtrl:getRemakeMaterialQuickShopList()
	local _ENV, itemID2List
	local equipmentltCtrl = include("equipmentltCtrl")
	local resIDList = equipmentltCtrl.getAllRemakeMaterial()
	for i, v in ipairs(resIDList) do
		local listData = self:getQuickShopItemArrayByItemID(v)
		itemID2List[v] = listData
		table.sort(itemID2List[v], function(a, b)
			return a.shopItemID < b.shopItemID
		end)
	end
	return itemID2List
end
return shopltCtrl
