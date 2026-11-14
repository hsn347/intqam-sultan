local attributeBuffList = include("attributeBuffList")
local dailyResetValue = include("dailyResetValue")
local _ENV, dailyCountDataMeta = "dailyResetValue", "dailyResetValue"
dailyCountDataMeta.__index = dailyCountDataMeta
function dailyCountDataMeta:set(key, count)
	self[tostring(key)] = dailyResetValue.new(count, count)
end
function dailyCountDataMeta:remove(key)
	self[tostring(key)] = nil
end
function dailyCountDataMeta:get(key)
	local value = self[tostring(key)]
	if value then
		return value:current()
	else
		return 0
	end
end
function dailyCountDataMeta:decrease(key, count)
	local value = self[tostring(key)]
	if value then
		if count <= value:current() then
			return true, value:decrease(count)
		end
	else
		return false
	end
end
local createCountData = function(data)
	if data then
		for _, v in pairs(data) do
			dailyResetValue.init(v)
		end
	else
		data, _ENV = pairs(data)
	end
	return setmetatable(data, dailyCountDataMeta)
end
local _ENV, lifeMeta
lifeMeta.__index = lifeMeta
function lifeMeta:destory()
	self.lifeEndCallback = nil
	self.countData = nil
	self.attrBuffList = nil
end
function lifeMeta:exist(buffID)
	local count = self.countData:get(buffID)
	if 0 <= count then
		return true
	else
		return false
	end
end
function lifeMeta:add(buffID, attrID, count)
	if count and 0 < count then
		self.countData:set(buffID, count)
		self.attrBuffList:add(attrID, buffID)
		return true
	else
		return false
	end
end
function lifeMeta:remove(buffID, attrID)
	if self:buffExist(buffID) then
		self.countData:remove(buffID)
		self.attrBuffList:remove(attrID, buffID)
		return true
	else
		return false
	end
end
function lifeMeta:decrease(buffID, attrID, count)
	local ok, curCount = self.countData:decrease(buffID, count)
	if ok then
		if curCount <= 0 then
			self.lifeEndCallback(buffID, attrID)
			return true
		else
			return false
		end
	else
		return false
	end
end
local decreaseBuffCount = function(self, buffID, attrID, count)
	local ok, curCount = self.countData:decrease(buffID, count)
	if ok then
		if curCount <= 0 then
			self.lifeEndCallback(buffID, attrID)
			return true
		else
			return false
		end
	else
		return false
	end
end
function lifeMeta:reset(callback)
	local success
	for buffIDStr, v in pairs(self.countData) do
		if v:value() <= 0 then
			callback(tonumber(buffIDStr))
		end
		v:refresh()
		success = true
	end
	return success
end
function lifeMeta:useAttr(attrID)
	local buffMap = self.attrBuffList:get(attrID)
	if buffMap then
		local success = false
		for packBuffID, _ in pairs(buffMap) do
			local buffID = attributeBuffList.unpackBuffID(packBuffID)
			if decreaseBuffCount(self, buffID, attrID, 1) then
				success = true
			end
		end
		return success
	else
		return false
	end
end
function lifeMeta:useAttrs(attrMap)
	local success
	for attrID, _ in pairs(attrMap) do
		if self:useAttr(attrID) then
			success = true
		end
	end
	return success
end
function lifeMeta:getData()
	return self.countData
end
local _ENV, countLife = function(self)
	return self.countData
end, function(self)
	return self.countData
end
function countLife.new(lifeEndCallback, lifeData)
	createCountData = nil
	;(nil).lifeEndCallback = lifeEndCallback
	local (nil).countData, life = createCountData(lifeData and lifeData.countData), nil
	return setmetatable(life, lifeMeta)
end
return countLife
