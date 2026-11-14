local buffltCtrl = include("newBuffltCtrl")
local attributeBuffList = include("attributeBuffList")
local dailyCountLife = include("dailyCountLife")
local _ENV, meta = "dailyCountLife", "dailyCountLife"
meta.__index = meta
local _ENV, dailyResetCountBuff
function dailyResetCountBuff.new(conf, lifeData)
	dailyCountLife = nil
	;(nil).conf = conf
	;(nil).countData = dailyCountLife.new(lifeData and lifeData.countData)
	local (nil).attrBuffList, buff = attributeBuffList.new(lifeData and lifeData.attrBuffList), nil
	return setmetatable(buff, meta)
end
function meta:destory()
	self.conf = nil
	self.countData = nil
	self.attrBuffList = nil
end
function meta:exist(buffID)
	local count = self.countData:get(buffID)
	if 0 <= count then
		return true
	else
		return false
	end
end
function meta:add(buffID)
	local count = buffltCtrl.getLifeCount(buffID)
	local attrID = buffltCtrl.getAttrID(buffID)
	self.countData:add(buffID, attrID, count)
	self.attrBuffList:add(attrID, buffID)
	return true
end
function meta:remove(buffID)
	if self:buffExist(buffID) then
		self.countData:remove(buffID)
		local attrID = buffltCtrl.getAttrID(buffID)
		self.attrBuffList:remove(attrID, buffID)
		return true
	else
		return false
	end
end
local decreaseBuffCount = function(self, buffID, attrID, count)
	local ok, curCount = self.countData:decrease(buffID, count)
	if ok then
		if curCount <= 0 then
			self.conf.lifeEndCallback(buffID, attrID)
			return true
		else
			return false
		end
	else
		return false
	end
end
function meta:useAttr(attrID)
	local buffMap = self.attrList:get(attrID)
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
function meta:useAttrs(attrMap)
	local success
	for attrID, _ in pairs(attrMap) do
		if self:useAttr(attrID) then
			success = true
		end
	end
	return success
end
function meta:reset(callback)
	local success
	for buffIDStr, v in pairs(self.countData) do
		if v:current() <= 0 then
			callback(tonumber(buffIDStr))
		end
		v:refresh()
		success = true
	end
	return success
end
function meta:getData()
	_UPVALUE0_ = nil
	;(nil).countData = self.countData
	;(nil).attrBuffList = self.attrBuffList
	return nil
end
return dailyResetCountBuff
