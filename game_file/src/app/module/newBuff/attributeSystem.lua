include("attributeDef")
local attrContainer = include("attrContainer")
local attrltCtrl = include("attrltCtrl")
local filterSystem = include("filterSystem")
local string = string
local tostring = tostring
local tonumber = tonumber
local assert = assert
local gEventName = gEventName
local _ENV, attributeSystem
local totalContainer, sourceContainers
local getSourceContainer = function(source)
	return sourceContainers[source]
end
local setSourceContainer = function(source, container)
	sourceContainers[source] = container
end
local removeSourceContainer = function(source)
	sourceContainers[source] = nil
end
local getTotalContainer = function()
	return totalContainer
end
function attributeSystem.init(sourceArray)
	attrltCtrl.init()
	attrltCtrl = {}
	for _, source in pairs(sourceArray) do
		local container = attrContainer.new()
		setSourceContainer(source, container)
	end
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
function attributeSystem.initAttr(attrID, id, attrValue, source)
	assert(attrltCtrl.attrIDValid(attrID))
	getSourceContainer(source):add(attrID, id, attrValue)
	local key = packID(id, source)
	local ok, isChange = getTotalContainer():add(attrID, key, attrValue)
	return ok, isChange
end
function attributeSystem.add(attrID, id, attrValue, source)
	assert(attrltCtrl.attrIDValid(attrID))
	getSourceContainer(source):add(attrID, id, attrValue)
	local key = packID(id, source)
	local ok, isChange = getTotalContainer():add(attrID, key, attrValue)
	return ok, isChange
end
function attributeSystem.remove(attrID, id, source)
	assert(attrltCtrl.attrIDValid(attrID))
	getSourceContainer(source):remove(attrID, id)
	local key = packID(id, source)
	local ok = getTotalContainer():remove(attrID, key)
end
local getQueryContainer = function(source)
	if source then
		return getSourceContainer(source)
	else
		return getTotalContainer()
	end
end
function attributeSystem.query(attrType, key, source)
	attributeSystem.dump()
	local container = getQueryContainer(source)
	if container then
		local filterKeys = filterSystem.convertKey(key)
		local attrValue = container:query(attrType, filterKeys)
		return attrValue
	else
		return 0
	end
end
local removeTotalContainerAttr = function(source, container)
	if not container:empty() then
		local removeAttr = function(id, attrValue, attrType, attrID)
			local key = packID(id, source)
			local ok = getTotalContainer():remove(attrID, key)
		end
		attrContainer.traverseAttr(container, removeAttr)
	end
end
local addTotalContainerAttr = function(source, container)
	if not container:empty() then
		local addAttr = function(id, attrValue, attrType, attrID)
			local key = packID(id, source)
			local ok, isChange = getTotalContainer():add(attrID, key, attrValue)
		end
		attrContainer.traverseAttr(container, addAttr)
	end
end
function attributeSystem.resetSourceContainer(source, container)
	local oldContainer = getSourceContainer(source)
	if not oldContainer:empty() then
		removeSourceContainer(source)
		removeTotalContainerAttr(source, oldContainer)
	end
	setSourceContainer(source, container)
	addTotalContainerAttr(source, container)
end
function attributeSystem.cleanSourceContainer(source)
	local container = getSourceContainer(source)
	if not container:empty() then
		removeSourceContainer(source)
		removeTotalContainerAttr(source, container)
		local newContainer = attrContainer.new()
		setSourceContainer(source, newContainer)
	end
end
function attributeSystem.dump()
end
return attributeSystem
