local buffltCtrl = include("newBuffltCtrl")
local attributeBuffList = include("attributeBuffList")
local _ENV, countDataMeta = "attributeBuffList", "attributeBuffList"
countDataMeta.__index = countDataMeta
function countDataMeta:set(key, count)
	self[tostring(key)] = count
end
function countDataMeta:get(key)
	return self[tostring(key)]
end
function countDataMeta:remove(key, count)
	self[tostring(key)] = nil
end
function countDataMeta:decrease(key, count)
	local curCount = self[tostring(key)]
	if curCount then
		if count <= curCount then
			local newCount = curCount - count
			self[tostring(key)] = newCount
			return true, newCount
		else
			return false
		end
	else
		return false
	end
end
local createCountData = function(data)
