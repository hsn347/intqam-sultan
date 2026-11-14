local attrltCtrl = include("attrltCtrl")
local filterSystem = include("filterSystem")
local tostring = tostring
local tonumber = tonumber
local pairs = pairs
local packAttrType = function(attrType)
	return tostring(attrType)
end
local unpackAttrType = function(attrType)
	return tonumber(attrType)
end
local packAttrID = function(attrID)
	return tostring(attrID)
end
local unpackAttrID = function(attrID)
	return tonumber(attrID)
end
local packID = function(id)
	return tostring(id)
end
local unpackID = function(id)
	return tostring(id)
end
local queryAttrMap = function(container, attrType)
	return container[packAttrType(attrType)]
end
local initAttrMap = function()
	_UPVALUE0_ = nil
	return nil
end
local loadAttrMap = function(container, attrType)
	attrType = packAttrType(attrType)
	local attrMap = container[attrType]
	if attrMap then
		return attrMap
	else
		attrMap = initAttrMap()
		container[attrType] = attrMap
		return attrMap
	end
end
local isAttrMapEmpty = function(attrMap)
	return not next(attrMap)
end
local removeAttrMap = function(container, attrType)
	container[packAttrType(attrType)] = nil
end
local initAttrData = function()
	_UPVALUE0_ = nil
	;(nil).total = 0
	return nil
end
local queryAttrData = function(attrMap, attrID)
	return attrMap[packAttrID(attrID)]
end
local loadAttrData = function(attrMap, attrID)
	attrID = packAttrID(attrID)
	local attrData = attrMap[attrID]
	if attrData then
		return attrData
	else
		attrData = initAttrData()
		attrMap[attrID] = attrData
		return attrData
	end
end
local removeAttrData = function(attrMap, attrID)
	attrMap[packAttrID(attrID)] = nil
end
local isAttrDataEmpty = function(attrData)
	if 0 == attrData.total then
		for key, _ in pairs(attrData) do
			if key ~= "total" then
				return false
			end
		end
		return true
	else
		return false
	end
end
local removeAttribute = function(attrData, id)
	id = packID(id)
	local curValue = attrData[id]
	if curValue then
		attrData[id] = nil
		local total = attrData.total
		total = total - curValue
		attrData.total = total
		return true
	else
		return false
	end
end
local updateAttribute = function(attrData, id, value)
	id = packID(id)
	local curValue = attrData[id]
	if curValue then
		if curValue == value then
			return false
		else
			attrData.total = attrData.total - curValue + value
			attrData[id] = value
			return true
		end
	else
		attrData.total = attrData.total + value
		attrData[id] = value
		return true
	end
end
local _ENV, attrContainerMeta
attrContainerMeta.__index = attrContainerMeta
local getAttrType = function(attrID)
	return attrltCtrl.getAttrType(attrID)
end
function attrContainerMeta:add(attrID, id, attrValue)
	assert(attrltCtrl.attrIDValid(attrID))
	assert(id)
	assert("number" == type(attrValue))
	local attrType = getAttrType(attrID)
	local attrMap = loadAttrMap(self, attrType)
	local attrData = loadAttrData(attrMap, attrID)
	local isChange = updateAttribute(attrData, id, attrValue)
	return true, isChange
end
function attrContainerMeta:remove(attrID, id)
	assert(attrltCtrl.attrIDValid(attrID))
	assert(id)
	local attrType = getAttrType(attrID)
	local attrMap = queryAttrMap(self, attrType)
	if attrMap then
		local attrData = queryAttrData(attrMap, attrID)
		if attrData then
			local ok = removeAttribute(attrData, id)
			if ok then
				if isAttrDataEmpty(attrData) then
					removeAttrData(attrMap, attrID)
					if isAttrMapEmpty(attrMap) then
						removeAttrMap(self, attrType)
					end
				end
				return true
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
end
local queryAttrValue = function(attrMap, filterKeys)
	local attrTotal = 0
	for attrID, attrValueMap in pairs(attrMap) do
		attrID = unpackAttrID(attrID)
		local filterGroupID = attrltCtrl.getFilterGroupID(attrID)
		if filterSystem.batchPassByGroup(filterGroupID, filterKeys) then
			attrTotal = attrTotal + attrValueMap.total
		end
	end
	return attrTotal
end
function attrContainerMeta:query(attrType, filterKeys)
	assert(attrType)
	local attrMap = queryAttrMap(self, attrType)
	if attrMap then
		local attrTotal = queryAttrValue(attrMap, filterKeys)
		return attrTotal
	else
		return 0
	end
end
function attrContainerMeta:empty()
	if next(self) then
		return false
	else
		return true
	end
end
local _ENV, attrContainer = function(self)
	if next(self) then
		return false
	else
		return true
	end
end, function(self)
	if next(self) then
		return false
	else
		return true
	end
end
function attrContainer.new()
	_ENV = nil
	return setmetatable(nil, attrContainerMeta)
end
function attrContainer.traverseAttr(container, callback)
	for attrType, attrMap in pairs(container) do
		for attrID, attrData in pairs(attrMap) do
			for id, attrValue in pairs(attrData) do
				callback(unpackID(id), attrValue, unpackAttrType(attrType), unpackAttrID(attrID))
			end
		end
	end
end
return attrContainer
