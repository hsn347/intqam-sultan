local baseProxy = require("fgui.base.baseProxy")
local CommonQuicklyaddProxy = class("CommonQuicklyaddProxy", baseProxy)
local resDesRead = include("resDesRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local quickuseitem = require_data("quickuseitem").data
local itemLogic = include("itemLogic")
function CommonQuicklyaddProxy:onRegisterEvent()
	print("=======CommonQuicklyaddProxy:onRegisterEvent")
end
function CommonQuicklyaddProxy:getSingleNum(result, resID, isItem)
	local singleNum = 0
	if not isItem then
		singleNum = result[1].count
	elseif type(result[1]) == "table" then
		for i, v in ipairs(result) do
			if v.id == resID then
				singleNum = v.count
				break
			end
		end
	else
		for i = 1, #result, 2 do
			if result[i] == resID then
				singleNum = result[i + 1]
				break
			end
		end
	end
	return singleNum
end
function CommonQuicklyaddProxy:getTotalNum(itemList)
	local totalNum = 0
	for __, itemID in ipairs(itemList) do
		local ownNum = backpackCtrl:getItemCount(itemID)
		if 0 < ownNum then
			local result = backpackltCtrl:getResult(itemID)
			local singleNum = self:getSingleNum(result, nil, false)
			totalNum = totalNum + singleNum * ownNum
		end
	end
	return totalNum
end
function CommonQuicklyaddProxy:getUseList(needRes)
	local enough = true
	local _ENV, useList
	local _ENV, useMap
	local _ENV, resultList
	for __, v in ipairs(needRes) do
		local _ENV, _useList
		local resID = v.resid
		local resNeed = v.rescount
		local _ENV, itemList
		local isItem = false
		if serviceFunctions.isResourceID(resID) then
			itemList = resDesRead.getItemList(resID)
			local totalNum = self:getTotalNum(itemList)
			if resNeed > totalNum then
				itemList = resDesRead.getItemList(resID, true)
			end
			self.isItem = false
		elseif quickuseitem[resID] then
			isItem = true
			self.associatedItem = quickuseitem[resID].associatedItem
			for i = 1, #self.associatedItem, 2 do
				table.insert(itemList, self.associatedItem[i])
			end
			self.isItem = true
		end
		dump(itemList, "==itemList==")
		itemList = self:checkUseCond(itemList)
		local _ENV, ret = self:checkUseCond(itemList), self:checkUseCond(itemList)
		local totalNum = 0
		for __, itemID in ipairs(itemList) do
			local ownNum = backpackCtrl:getItemCount(itemID)
			local index = useMap[tostring(itemID)]
			if index then
				ownNum = ownNum - useList[index].count
			end
			if 0 < ownNum then
				local result = backpackltCtrl:getResult(itemID)
				local singleNum = self:getSingleNum(result, resID, isItem)
				_ENV = self
				self.id = itemID
				self.count = ownNum
				local self.num, _data = singleNum, self
				if isItem then
					_data.extra, _ENV = result, result
					_ENV = isItem
					isItem.id = resID
					isItem.count = 1
					table.insert(_data.extra, isItem)
				end
				table.insert(ret, _data)
				totalNum = totalNum + singleNum * ownNum
			end
		end
		if resNeed > totalNum then
			enough = false
			print("==enough resID==", resID)
			break
		end
		dump(ret, "fsdlfkldkfldfkl")
		if not self.isItem then
			table.sort(ret, function(a, b)
				if a.num ~= b.num then
					return a.num < b.num
				end
				return a.id < b.id
			end)
		else
			table.sort(ret, function(a, b)
				if a.num ~= b.num then
					return a.num < b.num
				end
				return self:itemTableIndex(a.id) < self:itemTableIndex(b.id)
			end)
		end
		dump(ret, "==ret==", 5)
		local _resNeed = resNeed
		for i, data in ipairs(ret) do
			if _resNeed >= data.num then
				local needCount = math.floor(_resNeed / data.num)
				if i == #ret then
					needCount = math.ceil(_resNeed / data.num)
				end
				local useCount = math.min(needCount, data.count)
				_resNeed = _resNeed - useCount * data.num
				_ENV = singleNum * ownNum
				;(singleNum * ownNum).id = data.id
				;(singleNum * ownNum).count = useCount
				;(singleNum * ownNum).num = data.num
				;(singleNum * ownNum).extra = data.extra
				table.insert(_useList, singleNum * ownNum)
				if _resNeed <= 0 then
					break
				end
			end
		end
		dump(_useList, "组合型数量满足")
		if 0 < _resNeed then
			_resNeed = resNeed
			local _ENV, tempTb = dump, dump
			for i = 1, #ret do
				local data = ret[i]
				if _resNeed <= data.num or _resNeed <= data.num * data.count then
					local count = math.min(data.count, math.ceil(_resNeed / data.num))
					_ENV = math.ceil(_resNeed / data.num)
					math.ceil(_resNeed / data.num).id = data.id
					math.ceil(_resNeed / data.num).count = count
					math.ceil(_resNeed / data.num).num = data.num
					math.ceil(_resNeed / data.num).extra = data.extra
					table.insert(tempTb, math.ceil(_resNeed / data.num))
					break
				end
			end
			if 0 < #tempTb then
				_useList = tempTb
				dump(_useList, "单种数量满足")
			end
		end
		local totalNum = 0
		for __, v in ipairs(_useList) do
			local limitCount = backpackltCtrl:getUseMax(v.id)
			v.count = math.min(v.count, limitCount)
			totalNum = totalNum + v.count * v.num
			if v.extra then
				for __, w in ipairs(v.extra) do
					w.count = v.count
				end
			end
		end
		_ENV = ipairs(_useList)
		ipairs(_useList).id = resID
		ipairs(_useList).count = totalNum
		table.insert(resultList, ipairs(_useList))
		for __, v in ipairs(_useList) do
			local index = useMap[tostring(v.id)]
			if index then
				local data = useList[index]
				data.count = data.count + v.count
				table.insert(data.extra, v.extra[1])
			else
				table.insert(useList, v)
				useMap[tostring(v.id)] = #useList
			end
		end
	end
	return enough, useList, resultList
end
function CommonQuicklyaddProxy:checkUseCond(itemList)
	local _ENV, ret
	for __, itemID in ipairs(itemList) do
		if backpackCtrl:getItemCount(itemID) > 0 and itemLogic.checkCastleLevelCond(itemID) then
			table.insert(ret, itemID)
		end
	end
	return ret
end
function CommonQuicklyaddProxy:itemTableIndex(itemID)
	for i, v in ipairs(self.associatedItem) do
		dump(v, "fdskfjkdfjkdfjk")
		if v == itemID then
			return i
		end
	end
	return 0
end
function CommonQuicklyaddProxy:checkNeedRes(needRes)
	local enough, useList, resultList = self:getUseList(needRes)
	if enough then
		self.useList = useList
		self.resultList = resultList
		return true
	end
end
return CommonQuicklyaddProxy
