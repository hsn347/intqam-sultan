local backpackCell = include("backpackCell")
local itemLogic = include("itemLogic")
local backpack = class("backpack")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local limitSize = 999999
local initUnits = 40
local unlockUnits = 4
backpack.size_ = 0
backpack.items, _ENV, backpack.typeID_ = nil, nil, 0
function backpack:ctor(typeID)
	self.items, _UPVALUE0_, self.typeID_ = nil, nil, typeID
	self.classify_item_list, _UPVALUE0_, self.itemlist, _UPVALUE0_, self.listDirty = nil, nil, nil, nil, false
end
function backpack:clean()
	self.items, _UPVALUE0_, self.size_ = nil, nil, 0
	self.classify_item_list, _UPVALUE0_, self.itemlist, _UPVALUE0_, self.listDirty = nil, nil, nil, nil, false
end
local addItem_ = function(self, itemID, count, invalidtime)
	local item = self.items[itemID]
	if not item then
		item = backpackCell.new(itemID)
		self.items[itemID] = item
	end
	if invalidtime then
		item:invalidtime(invalidtime)
	end
	local val = item:add(count)
	self.size_ = self.size_ + val
end
local useItem_ = function(self, itemID, count)
	local item = self.items[itemID]
	local subCount, totalCount = item:sub(count)
	self.size_ = self.size_ + subCount
	if totalCount <= 0 then
		self.items[itemID] = nil
	end
end
function backpack:checkAddCount(params)
	local addCount = 0
	for _, v in pairs(params) do
		local itemID = v.id
		local count = v.count
		local item = self.items[itemID]
		local totalCount = 0
		if item then
			totalCount = item:count() + count
			local oldCount = item:cellCount()
			local newCount = itemLogic.calCellCount(itemID, totalCount)
			local val = newCount - oldCount
			addCount = addCount + val
		else
			totalCount = count
			local newCount = itemLogic.calCellCount(itemID, totalCount)
			addCount = addCount + newCount
		end
		local status, err = itemLogic.checkCountLimit(itemID, totalCount)
		if not status then
			return status, err
		end
	end
	local remain = limitSize - self:size()
	if addCount <= remain then
		return true, addCount
	else
		return false, gErrDef.Err_BACKPACK_IS_FULL
	end
end
function backpack:checkItemCountEnough(params)
	for itemID, count in pairs(params) do
		if count <= 0 then
			return false, gErrDef.Err_ILLEGAL_PARAMS
		end
		local item = self.items[itemID]
		local ownCount = 0
		if item then
			ownCount = item:count()
		end
		if ownCount <= 0 or count > ownCount then
			return false, gErrDef.Err_ITEM_IS_NOT_ENOUGH
		end
	end
	return true
end
local checkUseCount = function(self, params)
	for _, v in pairs(params) do
		local itemID = v.id
		local count = v.count
		if count <= 0 then
			return false, gErrDef.Err_ILLEGAL_PARAMS
		end
		_ENV = nil
		;(nil)[itemID] = count
		local status, err = self:checkItemCountEnough(nil)
		if not status then
			return status, err
		end
	end
	return true
end
function backpack:addItems(params)
	if "table" ~= type(params) then
		print("the params is not a table, it's a " .. type(params))
		if table.nums(params) == 0 then
			print("the params is empty")
		end
		return
	end
	for _, v in pairs(params) do
		local itemID = v.id
		local count = v.count
		local invalidtime = v.invalidtime
		addItem_(self, itemID, count, invalidtime)
	end
	self:updateItemList()
	return true
end
function backpack:useItem(itemID, count, isServerSync)
	print("itemID, count, isServerSync", itemID, count, isServerSync)
	if not isServerSync then
		local status, err = itemLogic.checkCastleLevelCond(itemID)
		if not status then
			return status, err
		end
		status, err = itemLogic.checkLordLevelCond(itemID)
		if not status then
			return status, err
		end
		_ENV, itemLogic = nil, isServerSync
		;(nil).id = itemID
		;(nil).count = count
		isServerSync[1] = nil
		status, err = checkUseCount(self, isServerSync)
		if not status then
			return status, err
		end
	elseif not self.items[itemID] then
		return false
	end
	useItem_(self, itemID, count)
	self:updateItemList()
	return true
end
function backpack:useItems(params)
	local status, err = checkUseCount(self, params)
	if not status then
		return status, err
	end
	for _, v in pairs(params) do
		local itemID = v.id
		local count = v.count
		useItem_(self, itemID, count)
	end
	self:updateItemList()
	return true
end
function backpack:size()
	return self.size_
end
function backpack:full()
	return self.size_ >= limitSize
end
function backpack:deductItem(itemID, count)
	useItem_ = nil
	;(nil)[itemID] = count
	local status, err = self:checkItemCountEnough(nil)
	if not status then
		return status, err
	end
	useItem_(self, itemID, count)
	return true
end
function backpack:getShowUnitNum()
	if self.listDirty then
		self:updateItemList_imp()
	end
	local num = #self.itemlist
	if num <= initUnits then
		return initUnits
	end
	if num % unlockUnits == 0 then
		return num
	else
		return num + (unlockUnits - num % unlockUnits)
	end
end
function backpack:typeID()
	return self.typeID_
end
function backpack:getItemCount(itemID)
	local item = self.items[itemID]
	if item then
		return item:count()
	else
		return 0
	end
end
function backpack:getList()
	if self.listDirty then
		self:updateItemList_imp()
	end
	return self.itemlist
end
function backpack:getClassifyList(classifyType)
	if self.listDirty then
		self:updateItemList_imp()
	end
	if not self.classify_item_list[classifyType] then
		_UPVALUE0_ = self.classify_item_list[classifyType]
	end
	return self.classify_item_list[classifyType]
end
function backpack:updateItemList()
	self.listDirty = true
end
function backpack:updateItemList_imp()
	local _ENV, list
	self.classify_item_list, _ENV, self.listDirty = nil, nil, false
	for itemID, cell in pairs(self.items) do
		local cellCount = cell:cellCount()
		local limitCount = backpackltCtrl:getUnitMax(itemID)
		local classifyType = backpackltCtrl:getClassifyType(itemID)
		if not self.classify_item_list[classifyType] then
			_ENV = self.classify_item_list[classifyType]
		end
		self.classify_item_list[classifyType] = self.classify_item_list[classifyType]
		if not self.classify_item_list[gItemClassifyType.ALL] then
			_ENV = self.classify_item_list[gItemClassifyType.ALL]
		end
		self.classify_item_list[gItemClassifyType.ALL] = self.classify_item_list[gItemClassifyType.ALL]
		local totalCount = cell:count()
		local invalidtime = cell:invalidtime()
		while 0 < totalCount do
			local count = 0 < totalCount - limitCount and limitCount or totalCount
			_ENV = nil
			;(nil).id = itemID
			;(nil).count = count
			table.insert(list, nil)
			_ENV = nil
			;(nil).id = itemID
			;(nil).count = count
			;(nil).invalidtime = invalidtime
			table.insert(self.classify_item_list[classifyType], nil)
			_ENV = gItemClassifyType.ALL
			gItemClassifyType.ALL.id = itemID
			gItemClassifyType.ALL.count = count
			gItemClassifyType.ALL.invalidtime = invalidtime
			table.insert(self.classify_item_list[gItemClassifyType.ALL], gItemClassifyType.ALL)
			totalCount = totalCount - count
		end
	end
	table.sort(list, function(l, r)
		if l and r then
			local lIndex = backpackltCtrl:getIndex(l.id)
			local rIndex = backpackltCtrl:getIndex(r.id)
			if lIndex < rIndex then
				return true
			elseif lIndex == rIndex then
				return l.count < r.count
			end
		else
			return false
		end
	end)
	for k, v in pairs(self.classify_item_list) do
		table.sort(v, function(l, r)
			if l and r then
				local lIndex = backpackltCtrl:getIndex(l.id)
				local rIndex = backpackltCtrl:getIndex(r.id)
				if lIndex < rIndex then
					return true
				elseif lIndex == rIndex then
					return l.count < r.count
				end
			else
				return false
			end
		end)
	end
	self.itemlist = list
	return list
end
function backpack:getItemList()
	local _ENV, ret
	for itemID, cell in pairs(self.items) do
		local cellCount = cell:count()
		_ENV = nil
		;(nil).id = itemID
		;(nil).count = cellCount
		table.insert(ret, nil)
	end
	return ret
end
function backpack:dumpBackpack()
	print("--------------Backpack---------------")
	print("typeID = ", self:typeID())
	print("size = ", self:size())
	local _ENV, t = print, print
	for key, var in pairs(self.items) do
		t[key] = var.info
	end
end
return backpack
