local _ENV, meta
meta.__index = meta
local pack = function(ID)
	return ID and tostring(ID)
end
local unpack = function(ID)
	return tonumber(ID)
end
function meta:add(attrID, buffID)
	local packAttrID = pack(attrID)
	if not self[packAttrID] then
		pack = self[packAttrID]
	end
	self[packAttrID] = self[packAttrID]
	local packBuffID = pack(buffID)
	self[packAttrID][packBuffID] = 1
end
function meta:remove(attrID, buffID)
	local packAttrID = pack(attrID)
	if self[packAttrID] then
		local packBuffID = pack(buffID)
		self[packAttrID][packBuffID] = nil
		if not next(self[packAttrID]) then
			self[packAttrID] = nil
		end
	end
end
function meta:get(attrID)
	local packAttrID = pack(attrID)
	return self[packAttrID]
end
function meta:traversing(callback)
	for packAttrID, buffMap in pairs(self) do
		local attrID = unpack(packAttrID)
		for packBuffID, _ in pairs(buffMap) do
			local buffID = unpack(packBuffID)
			callback(buffID, attrID)
		end
	end
end
local _ENV, attributeBuffList = function(self, callback)
	for packAttrID, buffMap in pairs(self) do
		local attrID = unpack(packAttrID)
		for packBuffID, _ in pairs(buffMap) do
			local buffID = unpack(packBuffID)
			callback(buffID, attrID)
		end
	end
end, function(self, callback)
	for packAttrID, buffMap in pairs(self) do
		local attrID = unpack(packAttrID)
		for packBuffID, _ in pairs(buffMap) do
			local buffID = unpack(packBuffID)
			callback(buffID, attrID)
		end
	end
end
function attributeBuffList.new(data)
