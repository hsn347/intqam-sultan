local attrContainer = include("attrContainer")
local attrltCtrl = include("attrltCtrl")
local addContainerAttr = function(container, attrID, id, attrValue)
	if container then
		container:add(attrID, id, attrValue)
		return true
	else
		return false
	end
end
local removeContainerAttr = function(container, attrID, id, attrValue)
	if container then
		container:remove(attrID, id)
		return true
	else
		return false
	end
end
local getContainerAttr = function(container, attrType, key)
	if container then
		local _UPVALUE0_, useAttrMap
		local attrValue = container:queryByInputKey(attrType, key, useAttrMap)
		return attrValue, useAttrMap
	else
		return
	end
end
local getContainerAttrByFilter = function(container, attrType, filter)
	if container then
		local _UPVALUE0_, useAttrMap
		local attrValue = container:queryByFilter(attrType, filter, useAttrMap)
		return attrValue, useAttrMap
	else
		return
	end
end
local getContainer = function(self, source)
	if source then
		return self.attrContainerList[source]
	else
		return
	end
end
local setContainer = function(self, source, container)
	self.attrContainerList[source] = container
end
local removeContainer = function(self, source)
	self.attrContainerList[source] = nil
end
local _ENV, meta
meta.__index = meta
function meta:init(sourceArray)
	self.attrContainerList, attrContainer, self.attrTotalContainer = attrContainer.new(), attrContainer.new(), attrContainer.new()
	for _, source in pairs(sourceArray) do
		local container = attrContainer.new()
		setContainer(self, source, container)
	end
end
local cleanContainerAttr = function(self, container)
	local removeOldAttr = function(id, attrValue, attrType, attrID)
		removeContainerAttr(self.attrTotalContainer, attrID, id, attrValue)
	end
	attrContainer.traverseAttr(container, removeOldAttr)
end
local setContainerAttr = function(self, container)
	local addNewAttr = function(id, attrValue, attrType, attrID)
		addContainerAttr(self.attrTotalContainer, attrID, id, attrValue)
	end
	attrContainer.traverseAttr(container, addNewAttr)
end
function meta:resetAttrContainer(source, container)
	local oldContainer = getContainer(self, source)
	if attrContainer then
		removeContainer(self, source)
		cleanContainerAttr(self, oldContainer)
	end
	setContainerAttr(self, container)
	setContainer(self, source, container)
end
function meta:cleanSourceAttrContainer(source)
	local container = getContainer(self, source)
	if container then
		removeContainer(self, source)
		cleanContainerAttr(self, container)
	end
	local newContainer = attrContainer.new()
	setContainer(self, source, newContainer)
end
local packID = function(id, source)
	if source then
		return string.format("%s_%s", tostring(id), tostring(source))
	else
		return string.format("%s", tostring(id))
	end
end
local unpackID = function(key)
	local id, source = key:match("([^_]*)_?([^_]*)")
	source = tonumber(source)
	return id, source
end
function meta:add(attrID, id, attrValue, source)
	assert(attrltCtrl.attrIDValid(attrID))
	if source then
		local sourceContainer = getContainer(self, source)
		addContainerAttr(sourceContainer, attrID, id, attrValue)
	end
	local key = packID(id, source)
	addContainerAttr(self.attrTotalContainer, attrID, key, attrValue)
end
function meta:remove(attrID, id, attrValue, source)
	assert(attrltCtrl.attrIDValid(attrID))
	if source then
		local sourceContainer = getContainer(self, source)
		removeContainerAttr(sourceContainer, attrID, id, attrValue)
	end
	local key = packID(id, source)
	removeContainerAttr(self.attrTotalContainer, attrID, key, attrValue)
end
function meta:query(attrType, key)
	assert(attrltCtrl.attrTypeValid(attrType))
	return getContainerAttr(self.attrTotalContainer, attrType, key)
end
function meta:queryByFilter(attrType, filter)
	assert(attrltCtrl.attrTypeValid(attrType))
	return getContainerAttrByFilter(self.attrTotalContainer, attrType, filter)
end
function meta:querySourceBuff(source, attrType, key)
	assert(attrltCtrl.attrTypeValid(attrType))
	local sourceContainer = getContainer(self, source)
	return getContainerAttr(sourceContainer, attrType, key)
end
function meta:clean()
	self.attrTotalContainer = nil
end
local _ENV, attrModule = function(self)
	self.attrTotalContainer = nil
end, function(self)
	self.attrTotalContainer = nil
end
function attrModule.new(sourceArray)
	_ENV = nil
	local attr = setmetatable(nil, meta)
	attr:init(sourceArray)
	return attr
end
return attrModule
