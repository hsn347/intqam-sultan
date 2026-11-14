local ltBase = include("ltBase")
local backpackltCtrl = class("backpackltCtrl", ltBase, include("aAReadClass").new())
function backpackltCtrl:ctor()
	backpackltCtrl.super.ctor(self)
	self:init()
end
function backpackltCtrl:init()
	backpackltCtrl:defineValue("packagedata", function()
		local packagedataCfg = require_once("app." .. LocalTblPath .. ".config_server.packagedata")
		local _ENV, packagedata = "app." .. LocalTblPath .. ".config_server.packagedata", "app." .. LocalTblPath .. ".config_server.packagedata"
		for key, value in pairs(packagedataCfg) do
			_UPVALUE3_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			;(nil)[3] = "rate"
			packagedata[key] = serviceFunctions.tableFormat(value.packItems, nil)
		end
		return packagedata
	end)
	local itemlt = require("app." .. LocalTblPath .. ".config_server.item")
	local backpackltCtrl, list = "app." .. LocalTblPath .. ".config_server.item", "app." .. LocalTblPath .. ".config_server.item"
	local backpackltCtrl, typeList = LocalTblPath, LocalTblPath
	local backpackltCtrl, buffItem = ".config_server.item", ".config_server.item"
	local backpackltCtrl, itemTypeList
	local backpackltCtrl, cannotGiveList
	local backpackltCtrl, showGiveList
	local backpackltCtrl, dressID_itemID
	local backpackltCtrl, warGemList
	for index, item in pairs(itemlt) do
		item.index = index
		local itemID = item.itemID
		list[itemID] = item
		if not itemTypeList[item.goodType] then
			backpackltCtrl = itemTypeList[item.goodType]
		end
		itemTypeList[item.goodType] = itemTypeList[item.goodType]
		table.insert(itemTypeList[item.goodType], itemID)
		if not typeList[item.resultType] then
			backpackltCtrl = typeList[item.resultType]
		end
		typeList[item.resultType] = typeList[item.resultType]
		if item.presentedType == 1 then
			table.insert(cannotGiveList, itemID)
		end
		if item.presentShow == 1 then
			table.insert(showGiveList, itemID)
		end
		if item.gembox == 1 then
			table.insert(warGemList, itemID)
		end
		if item.resultType == gItemEffectDef.ITEM or item.resultType == gItemEffectDef.GUIDE then
			_UPVALUE2_ = itemID
			itemID[1] = "id"
			itemID[2] = "count"
			item.result = serviceFunctions.tableFormat(item.result, itemID)
			table.insert(typeList[item.resultType], itemID)
		elseif item.resultType == gItemEffectDef.BUFF then
			item.result = item.result[1]
			table.insert(typeList[item.resultType], itemID)
			buffItem[item.result] = itemID
		elseif item.resultType == gItemEffectDef.ACTIVATE_VIP or item.resultType == gItemEffectDef.ADD_BUILD_QUEUE or item.resultType == gItemEffectDef.DJ_GIFT or item.resultType == gItemEffectDef.SINGLE_TRAIN_ADD_COUNT or item.resultType == gItemEffectDef.MARCH_SPEED_UP then
			item.result = item.result[1]
			table.insert(typeList[item.resultType], itemID)
		elseif item.resultType == gItemEffectDef.LUA then
			item.result = item.result[1]
		elseif item.resultType == gItemEffectDef.ABBR_SPEED_UP then
			local key = item.result[1]
			local value = item.result[2]
			backpackltCtrl = itemID
			itemID.key = key
			item.result, itemID.value = itemID, value
			if not typeList[item.resultType][key] then
				backpackltCtrl = typeList[item.resultType][key]
			end
			typeList[item.resultType][key] = typeList[item.resultType][key]
			table.insert(typeList[item.resultType][key], itemID)
		elseif item.resultType == gItemEffectDef.DRESS then
			item.result = item.result[1]
			table.insert(typeList[item.resultType], itemID)
			dressID_itemID[item.result] = itemID
		elseif item.resultType == gItemEffectDef.LOVE_HEART then
			local result = item.result
			local effectID = table.remove(result, 1)
			local time = table.remove(result, 1)
			backpackltCtrl = result
			result.effectID = effectID
			item.result, result.time = result, time
		elseif item.resultType == gItemEffectDef.RANDOM_GIFT then
			_UPVALUE3_ = table.remove(result, 1)
			table.remove(result, 1)[1] = "id"
			table.remove(result, 1)[2] = "count"
			table.remove(result, 1)[3] = "rate"
			item.result = serviceFunctions.tableFormat(item.result, (table.remove(result, 1)))
		elseif item.resultType == gItemEffectDef.HERO_LEADER_POINT then
			_UPVALUE3_ = table.remove(result, 1)
			table.remove(result, 1)[1] = "id"
			table.remove(result, 1)[2] = "count"
			table.remove(result, 1)[3] = "heroID"
			item.result = serviceFunctions.tableFormat(item.result, (table.remove(result, 1)))
			table.insert(typeList[item.resultType], itemID)
		elseif item.resultType == gItemEffectDef.SPECIAL_LEADER_POINT then
			_UPVALUE3_ = itemID
			itemID[1] = "count"
			itemID[2] = "type"
			itemID[3] = "rarity"
			item.result = serviceFunctions.tableFormat(item.result, itemID)
			table.insert(typeList[item.resultType], itemID)
		elseif item.resultType == gItemEffectDef.RESTRICTED_OPTIONAL then
			_UPVALUE4_ = itemID
			itemID[1] = "id"
			itemID[2] = "count"
			itemID[3] = "limitType"
			itemID[4] = "lv"
			item.result = serviceFunctions.tableFormat(item.result, itemID)
		elseif item.resultType == gItemEffectDef.NEBULA_ALLSTAR_GIFT then
			table.insert(typeList[item.resultType], itemID)
		elseif item.resultType == gItemEffectDef.RECHARGE_GIFT_EXCHANGE then
			table.insert(typeList[item.resultType], itemID)
		end
		_UPVALUE3_ = itemID
		itemID[1] = "cType"
		itemID[2] = "id"
		itemID[3] = "count"
		item.condition = serviceFunctions.tableFormat(item.condition, itemID)
		if not item.extraItems then
			backpackltCtrl = item.extraItems
		end
		_UPVALUE3_ = itemID
		itemID[1] = "id"
		itemID[2] = "count"
		itemID[3] = "rate"
		local packageItem = serviceFunctions.tableFormat(item.extraItems, itemID)
		local backpackltCtrl, extraItems = item.extraItems, item.extraItems
		for i, v in ipairs(packageItem) do
			local itemList = self:getShowItems(v.id)
			for _, v in ipairs(itemList) do
				table.insert(extraItems, v)
			end
		end
		item.extraItems = extraItems
		local backpackltCtrl, cond = ipairs(packageItem)
		for i, v in ipairs(item.condition) do
			if not cond[v.cType] then
				backpackltCtrl = cond[v.cType]
			end
			cond[v.cType] = cond[v.cType]
			if gItemUseCondType.ITEM == v.cType then
				backpackltCtrl = ipairs(itemList)
				ipairs(itemList).id = v.id
				ipairs(itemList).count = v.count
				table.insert(cond[v.cType], ipairs(itemList))
			elseif gItemUseCondType.VIP == v.cType then
				backpackltCtrl = ipairs(itemList)
				ipairs(itemList).lv = v.id
				ipairs(itemList).needactive = v.count
				table.insert(cond[v.cType], ipairs(itemList))
			end
		end
		item.condition = cond
	end
	self.itemlt = itemlt
	self.itemList = list
	self.typeList = typeList
	self.buffItem = buffItem
	self.itemTypeList = itemTypeList
	self.cannotGiveList = cannotGiveList
	self.showGiveList = showGiveList
	self.dressID_itemID = dressID_itemID
	self.warGemList = warGemList
	table.sort(self.cannotGiveList, function(l, r)
		return l < r
	end)
	table.sort(self.showGiveList, function(l, r)
		return l < r
	end)
	backpackltCtrl:defineValue("mergeItemConfig", function()
		local mergeItemlt = require_once("app." .. LocalTblPath .. ".config_server.item_merge_config")
		local _ENV, mergeItemConfig = "app." .. LocalTblPath .. ".config_server.item_merge_config", "app." .. LocalTblPath .. ".config_server.item_merge_config"
		local mIndex = 1
		for k, v in pairs(mergeItemlt) do
			if type(v.mergeID) == "table" then
				_UPVALUE2_ = nil
				;(nil)[1] = "id"
				;(nil)[2] = "count"
				v.mergeID = serviceFunctions.tableFormat(v.mergeID, nil)
			end
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.material = serviceFunctions.tableFormat(v.material, nil)
			mergeItemConfig[mIndex] = v
			mIndex = mIndex + 1
		end
		return mergeItemConfig
	end)
	backpackltCtrl:defineValue("materialID_mergeID", function()
		local _ENV, materialID_mergeID
		for k, v in ipairs(backpackltCtrl.mergeItemConfig) do
			for ki, vi in ipairs(v.material) do
				materialID_mergeID[vi.id] = v.mergeID
			end
		end
		return materialID_mergeID
	end)
	backpackltCtrl:defineValue("recycle_item", function()
		local recycle_item_cfg = require_once("app." .. LocalTblPath .. ".config_server.recycle_item")
		local _ENV, recycle_item = "app." .. LocalTblPath .. ".config_server.recycle_item", "app." .. LocalTblPath .. ".config_server.recycle_item"
		for k, v in ipairs(recycle_item_cfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.exchangeitem = serviceFunctions.tableFormat(v.exchangeitem, nil)
			recycle_item[v.shopitem] = v
		end
		return recycle_item
	end)
	backpackltCtrl:defineValue("recycleItemKidMap", function()
		local _ENV, ret
		for itemID, cfg in pairs(backpackltCtrl.recycle_item) do
			if not cfg.kid then
				local _ENV, kidList = cfg.kid, cfg.kid
			end
			if next(kidList) then
				if not ret[itemID] then
					local _ENV, kidMap = ret[itemID], ret[itemID]
				end
				for __, kid in ipairs(kidList) do
					kidMap[kid] = true
				end
				ret[itemID] = kidMap
			end
		end
		return ret
	end)
	self:initActivityItem()
	backpackltCtrl:defineValue("buff_stacking", function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.buff_stacking")
		local _ENV, map = "app." .. LocalTblPath .. ".config_server.buff_stacking", "app." .. LocalTblPath .. ".config_server.buff_stacking"
		for k, v in ipairs(cfg) do
			map[v.itemID] = v.index
		end
		return map
	end)
	function _UPVALUE2_()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.buff_stacking")
		local _ENV, map = "app." .. LocalTblPath .. ".config_server.buff_stacking", "app." .. LocalTblPath .. ".config_server.buff_stacking"
		for k, v in ipairs(cfg) do
			map[v.itemID] = v.index
		end
		return map
	end
	;(function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.buff_stacking")
		local _ENV, map = "app." .. LocalTblPath .. ".config_server.buff_stacking", "app." .. LocalTblPath .. ".config_server.buff_stacking"
		for k, v in ipairs(cfg) do
			map[v.itemID] = v.index
		end
		return map
	end)[1] = "recycle_shop_view"
	;(function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.buff_stacking")
		local _ENV, map = "app." .. LocalTblPath .. ".config_server.buff_stacking", "app." .. LocalTblPath .. ".config_server.buff_stacking"
		for k, v in ipairs(cfg) do
			map[v.itemID] = v.index
		end
		return map
	end)[2] = false
	backpackltCtrl:defineValue("recycle_shop_view", function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.buff_stacking")
		local _ENV, map = "app." .. LocalTblPath .. ".config_server.buff_stacking", "app." .. LocalTblPath .. ".config_server.buff_stacking"
		for k, v in ipairs(cfg) do
			map[v.itemID] = v.index
		end
		return map
	end)
end
function backpackltCtrl:initActivityItem()
	backpackltCtrl:defineValue("activityItemList", function()
		local activityItemlt = require("app." .. LocalTblPath .. ".config_server.item_activity")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.item_activity", "app." .. LocalTblPath .. ".config_server.item_activity"
		for index, item in pairs(activityItemlt) do
			item.index = index
			local itemID = item.itemID
			list[itemID] = item
			if item.resultType == gItemEffectDef.ITEM or item.resultType == gItemEffectDef.GUIDE then
				_UPVALUE2_ = nil
				;(nil)[1] = "id"
				;(nil)[2] = "count"
				item.result = serviceFunctions.tableFormat(item.result, nil)
			elseif item.resultType == gItemEffectDef.BUFF then
				item.result = item.result[1]
			elseif item.resultType == gItemEffectDef.ACTIVATE_VIP or item.resultType == gItemEffectDef.ADD_BUILD_QUEUE or item.resultType == gItemEffectDef.MARCH_SPEED_UP then
				item.result = item.result[1]
			elseif item.resultType == gItemEffectDef.LUA then
				item.result = item.result[1]
			elseif item.resultType == gItemEffectDef.ABBR_SPEED_UP then
				local key = item.result[1]
				local value = item.result[2]
				_ENV = nil
				;(nil).key = key
				item.result, (nil).value = nil, value
			end
		end
		return list
	end)
end
function backpackltCtrl:getProperty(t, itemID, property)
	if self:isActivityItem(itemID) then
		local activityShowCtrl = gModuleMgr.getObject("gametop").playertop_:getModule("activityShowCtrl")
		local activityID = backpackltCtrl.super.getProperty(self, self.activityItemList, itemID, "activity")
		if activityShowCtrl:isActivityOpen(activityID) then
			return backpackltCtrl.super.getProperty(self, self.activityItemList, itemID, property)
		end
	end
	return backpackltCtrl.super.getProperty(self, self.itemList, itemID, property)
end
function backpackltCtrl:getIndex(itemID)
	return self:getProperty(self.itemList, itemID, "index")
end
function backpackltCtrl:getItemType(itemID)
	return self:getProperty(self.itemList, itemID, "goodType")
end
function backpackltCtrl:getItemQuality(itemID)
	return self:getProperty(self.itemList, itemID, "itemQuality")
end
function backpackltCtrl:getBackpackType(itemID)
	return self:getProperty(self.itemList, itemID, "backpackType")
end
function backpackltCtrl:getUnitMax(itemID)
	local unitMax = self:getProperty(self.itemList, itemID, "unitMax")
	local limitedTime = self:getItemLimitedTime(itemID)
	if 0 < limitedTime then
		unitMax = 1
	end
	return unitMax
end
function backpackltCtrl:getItemLimitedTime(itemID)
	return self:getProperty(self.itemList, itemID, "limitedTime") or 0
end
function backpackltCtrl:getUseMax(itemID)
	return self:getProperty(self.itemList, itemID, "useMax") or 0
end
function backpackltCtrl:getBuyMax(itemID)
	return self:getProperty(self.itemList, itemID, "buyMax")
end
function backpackltCtrl:getCastleLevelCond(itemID)
	return self:getProperty(self.itemList, itemID, "castleLevel")
end
function backpackltCtrl:getLordLevelCond(itemID)
	return self:getProperty(self.itemList, itemID, "lordLevel")
end
function backpackltCtrl:getUseCondition(itemID, cType)
	local condition = self:getProperty(self.itemList, itemID, "condition")
	if not cType then
		return condition
	end
	condition, _UPVALUE0_ = condition[cType], condition[cType]
	condition = condition and condition[cType] or self:getProperty(self.itemList, itemID, "condition")
	return condition
end
function backpackltCtrl:isChooseFull(itemID)
	local maxControl = self:getProperty(self.itemList, itemID, "maxControl")
	local isFull = false
	if maxControl and 0 < maxControl then
		isFull = true
	end
	return isFull
end
function backpackltCtrl:isSkinShow(itemID)
	local skinShow = self:getProperty(self.itemList, itemID, "skinShow")
	return skinShow and 0 < skinShow, skinShow or 0
end
function backpackltCtrl:getUseItemList(itemID)
	local condition = self:getUseCondition(itemID)
	if condition then
	end
end
function backpackltCtrl:canGetPetFeedExp(itemID)
	local exp = self:getPetFeedExp(itemID)
	if exp and 0 < exp then
		local godArmsCtrl = SoraDGetCtrl("godArmsCtrl")
		if not godArmsCtrl:isUnlockNeedItem(itemID) then
			return true, exp
		end
	end
	return false
end
function backpackltCtrl:getPetFeedExp(itemID)
	return self:getProperty(self.itemList, itemID, "feedEXP")
end
function backpackltCtrl:canGetPetAdvancedEXP(itemID)
	local exp = self:getPetAdvancedEXP(itemID)
	if exp and 0 < exp then
		return true, exp
	end
	return false
end
function backpackltCtrl:getPetAdvancedEXP(itemID)
	return self:getProperty(self.itemList, itemID, "advancedEXP")
end
function backpackltCtrl:canGetPetExchangePoint(itemID)
	local point = self:getPetExchangePoint(itemID)
	if point and 0 < point then
		return true, point
	end
	return false
end
function backpackltCtrl:getPetExchangePoint(itemID)
	return self:getProperty(self.itemList, itemID, "petPoint")
end
function backpackltCtrl:canUse(itemID)
	local useType = self:getProperty(self.itemList, itemID, "isUseType") or self:getProperty(self.itemList, itemID, "useType")
	if useType == 0 then
		return false
	elseif useType == 1 then
		return true
	end
end
function backpackltCtrl:canCompose(itemID)
	local compose = self:getProperty(self.itemList, itemID, "ifCanSynthetics")
	if compose == 0 then
		return false
	elseif compose == 1 then
		return true
	end
end
function backpackltCtrl:getSyntheticsParameter(itemID)
	return self:getProperty(self.itemList, itemID, "SyntheticsParameter")
end
function backpackltCtrl:getResultType(itemID)
	return self:getProperty(self.itemList, itemID, "resultType")
end
function backpackltCtrl:getResult(itemID)
	return self:getProperty(self.itemList, itemID, "result")
end
function backpackltCtrl:getClassifyType(itemID)
	return self:getProperty(self.itemList, itemID, "bagType")
end
function backpackltCtrl:getItemByResult(result, resultList)
	local _ENV, items
	if resultList then
		for m, n in ipairs(resultList) do
			for k, v in pairs(self.itemList) do
				if v.result == n then
					table.insert(items, v.itemID)
				end
			end
		end
	else
		for k, v in pairs(self.itemList) do
			if v.result == result then
				table.insert(items, v.itemID)
			end
		end
	end
	return items
end
function backpackltCtrl:getRandomGiftShowItems(itemID)
	local itemDesRead = include("itemDesRead")
	local isShow = false
	local _ENV, ret
	local show = 0
	local index = 1
	if gItemEffectDef.RANDOM_GIFT == self:getResultType(itemID) then
		show = self:getProperty(self.itemList, itemID, "show") or 0
		if show ~= 0 then
			local retlist = self:getProperty(self.itemList, itemID, "result")
			if retlist and next(retlist) then
				for _, value1 in ipairs(retlist) do
					local retPackageData = self.packagedata[value1.id]
					if retPackageData then
						for _, value2 in pairs(retPackageData) do
							_ENV = nil
							;(nil).id = value2.id
							;(nil).quality = value2.itemQuality or self:getItemQuality(value2.id) or 1
							ret[index], (nil).count = nil, value2.count
							index = index + 1
						end
					else
						_ENV = pairs(retPackageData)
						pairs(retPackageData).id = value1.id
						pairs(retPackageData).quality = value1.itemQuality or self:getItemQuality(value1.id) or 1
						ret[index], pairs(retPackageData).count = pairs(retPackageData)
						index = index + 1
					end
				end
			end
		end
	elseif gItemEffectDef.OPTIONAL == self:getResultType(itemID) or gItemEffectDef.OPTIONAL_HERO == self:getResultType(itemID) or gItemEffectDef.OPTIONAL_EXTRA == self:getResultType(itemID) then
		local retlist = self:getProperty(self.itemList, itemID, "result")
		_UPVALUE2_ = itemID
		itemID[1] = "id"
		itemID[2] = "count"
		local formatRetList = serviceFunctions.tableFormat(retlist, itemID)
		if formatRetList and next(formatRetList) then
			for _, value1 in ipairs(formatRetList) do
				local retPackageData = self.packagedata[value1.id]
				if retPackageData then
					for _, value2 in pairs(retPackageData) do
						_ENV = value2.count
						value2.count.id = value2.id
						value2.count.quality = value2.itemQuality or self:getItemQuality(value2.id) or 1
						ret[index], value2.count.count = value2.count, value2.count
						index = index + 1
					end
				else
					_ENV = pairs(retPackageData)
					pairs(retPackageData).id = value1.id
					pairs(retPackageData).quality = value1.itemQuality or self:getItemQuality(value1.id) or 1
					ret[index], pairs(retPackageData).count = pairs(retPackageData)
					index = index + 1
				end
			end
		end
	elseif gItemEffectDef.ACTIVITY_9001687_GIFT == self:getResultType(itemID) then
		local retlist = self:getProperty(self.itemList, itemID, "result")
		_UPVALUE3_ = itemID
		itemID[1] = "id"
		itemID[2] = "count"
		itemID[3] = "rate"
		local formatRetList = serviceFunctions.tableFormat(retlist, itemID)
		if formatRetList and next(formatRetList) then
			for _, value1 in ipairs(formatRetList) do
				local retPackageData = self.packagedata[value1.id]
				if retPackageData then
					for _, value2 in pairs(retPackageData) do
						_ENV = value2.count
						value2.count.id = value2.id
						value2.count.quality = value2.itemQuality or self:getItemQuality(value2.id) or 1
						ret[index], value2.count.count = value2.count, value2.count
						index = index + 1
					end
				else
					_ENV = pairs(retPackageData)
					pairs(retPackageData).id = value1.id
					pairs(retPackageData).quality = value1.itemQuality or self:getItemQuality(value1.id) or 1
					ret[index], pairs(retPackageData).count = pairs(retPackageData)
					index = index + 1
				end
			end
		end
	elseif gItemEffectDef.RESTRICTED_OPTIONAL == self:getResultType(itemID) then
		local retlist = self:getProperty(self.itemList, itemID, "result")
		dump(retlist, "retlist")
		for _, v in ipairs(retlist) do
			if SoraDCheckLimit(v.limitType, v.lv) then
				table.insert(ret, v)
			end
		end
	end
	if itemDesRead.config[itemID] and itemDesRead.config[itemID].describe and i18n(itemDesRead.config[itemID].describe) then
		isShow = true
	end
	return ret, show, isShow
end
function backpackltCtrl:getShowItems(packageID)
	return self.packagedata[packageID]
end
function backpackltCtrl:getItemListByType(resultType)
	if not resultType then
		return
	end
	return self.typeList[resultType]
end
function backpackltCtrl:getItemIDByBuffID(buffID)
	return self.buffItem[buffID]
end
function backpackltCtrl:getCannotGiveList()
	return self.cannotGiveList
end
function backpackltCtrl:getWarGemList()
	return self.warGemList
end
function backpackltCtrl:getCannotShowList()
	return self.showGiveList
end
function backpackltCtrl:canGive(itemID)
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local isLock = backpackCtrl:isItemLock(itemID)
	if isLock then
		return false
	end
	local presentedType = self:getProperty(self.itemList, itemID, "presentedType")
	local presentLv = self:getProperty(self.itemList, itemID, "presentLv") or 0
	return presentedType == 1 and presentLv <= SoraDGetCastleLv()
end
function backpackltCtrl:getPresentedType(itemID)
	return self:getProperty(self.itemList, itemID, "presentedType")
end
function backpackltCtrl:getExtraItems(itemID)
	return self:getProperty(self.itemList, itemID, "extraItems")
end
function backpackltCtrl:getPresentLv(itemID)
	print(self:getProperty(self.itemList, itemID, "presentLv"))
	return self:getProperty(self.itemList, itemID, "presentLv") or 0
end
function backpackltCtrl:getItemArray(itemType)
	if itemType then
		return self.itemTypeList[itemType]
	else
		print("backpackltCtrl:getItemList error: itemType is nil")
	end
end
function backpackltCtrl:isItem(id)
	if "number" == type(id) and self.itemList[id] then
		return true
	end
	return false
end
function backpackltCtrl:isItemIDCanMerge(mergeID)
	if not mergeID then
		return false
	end
	for k, v in ipairs(self.mergeItemConfig) do
		if type(v.mergeID) == "table" then
			for ki, vi in ipairs(v.mergeID) do
				if vi.id == mergeID then
					return true
				end
			end
		elseif vi.id == mergeID then
			return true
		end
	end
	return false
end
function backpackltCtrl:isFragmentOfItem(materialID)
	if not materialID then
		return false
	end
	if not self.materialID_mergeID[materialID] then
		return false
	end
	return true
end
function backpackltCtrl:getMaterialOfMergeItem(mergeID)
	if not mergeID then
		return
	end
	for k, v in ipairs(self.mergeItemConfig) do
		if type(v.mergeID) == "table" then
			for ki, vi in ipairs(v.mergeID) do
				if vi.id == mergeID then
					return v.material
				end
			end
		elseif v.mergeID == mergeID then
			return v.material
		end
	end
	return
end
function backpackltCtrl:getItemIDByMaterial(materialID)
	if not materialID then
		return
	end
	if type(self.materialID_mergeID[materialID]) == "number" then
		return self.materialID_mergeID[materialID]
	else
		return self.materialID_mergeID[materialID][1].id
	end
end
function backpackltCtrl:getDressItemID(dressID)
	return dressID and self.dressID_itemID[dressID]
end
function backpackltCtrl:getRecycleItemConfig(itemID)
	return self.recycle_item[itemID]
end
function backpackltCtrl:getRecycleShopViewList()
	if not self.recycle_shop_view then
		_UPVALUE0_ = self.recycle_shop_view
	end
	return self.recycle_shop_view
end
function backpackltCtrl:getRecycleShopViewConfig(index)
	if not index then
		return
	end
	if not self.recycle_shop_view then
		_ENV = self.recycle_shop_view
	end
	for _, v in ipairs(self.recycle_shop_view) do
		if v.index == index then
			return v
		end
	end
end
function backpackltCtrl:checkRecycleItemShow(itemID)
	if SoraDGetCtrl("backpackCtrl"):isItemLock(itemID) then
		return false
	end
	local kidMap = self.recycleItemKidMap[itemID]
	if not kidMap then
		return true
	end
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	local selfSourceKid = lordInfoCtrl:getMapSourceKid()
	return kidMap[selfSourceKid] or false
end
function backpackltCtrl:checkBuffStackingItem(itemID)
	return backpackltCtrl.buff_stacking[itemID]
end
function backpackltCtrl:isActivityItem(itemID)
	if self.activityItemList[itemID] then
		return true
	end
	return false
end
function backpackltCtrl:addUnknowItemConfig(itemID)
	if itemID and 200101 <= itemID and itemID <= 289999 then
		_ENV = nil
		table.insert(self.itemlt, nil)
		local index = #self.itemlt
		_ENV = nil
		;(nil).backpackType = 2
		;(nil).castleLevel = 1
		;(nil).goodType = 0
		;(nil).index = index
		;(nil).isLog = 0
		;(nil).itemID = itemID
		;(nil).itemQuality = 0
		;(nil).itemType = 0
		;(nil).lordLevel = 1
		;(nil).result, _ENV, (nil).presentedType = nil, nil, 0
		;(nil).resultType = 0
		;(nil).unitMax = 9999
		;(nil).useMax = 9999
		;(nil).useType = 0
		self.itemList[itemID], (nil).bagType = nil, 0
	else
		_ENV = nil
		table.insert(self.itemlt, nil)
		local index = #self.itemlt
		_ENV = nil
		;(nil).backpackType = 1
		;(nil).castleLevel = 1
		;(nil).goodType = 0
		;(nil).index = index
		;(nil).isLog = 0
		;(nil).itemID = itemID
		;(nil).itemQuality = 0
		;(nil).itemType = 0
		;(nil).lordLevel = 1
		;(nil).result, _ENV, (nil).presentedType = nil, nil, 0
		;(nil).resultType = 0
		;(nil).unitMax = 9999
		;(nil).useMax = 9999
		;(nil).useType = 0
		self.itemList[itemID], (nil).bagType = nil, 0
	end
end
return backpackltCtrl
