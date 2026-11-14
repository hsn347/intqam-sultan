local buffltCtrl = include("newBuffltCtrl")
local attributeLife = include("attributeLife")
local addBuffAttr = function(attrModule, buffID)
	local attrID = buffltCtrl.getAttrID(buffID)
	local attrValue = buffltCtrl.getAttrValue(buffID)
	local source = buffltCtrl.getSource(buffID)
	attrModule:add(attrID, buffID, attrValue, source)
	return attrID, attrValue
end
local removeBuffAttr = function(attrModule, buffID)
	local attrID = buffltCtrl.getAttrID(buffID)
	local attrValue = buffltCtrl.getAttrValue(buffID)
	local source = buffltCtrl.getSource(buffID)
	attrModule:remove(attrID, buffID, attrValue, source)
	return attrID, attrValue
end
local _ENV, meta
meta.__index = meta
function meta:init(attrModule, timerModule, buffEndCallback, buffData)
	self.buffEndCallback = buffEndCallback
	self.attrModule = attrModule
	local lifeEndCallback = function(buffID)
		Log.i("new buff life end", buffID)
		removeBuffAttr(self.attrModule, buffID)
		self.buffEndCallback(buffID)
	end
	self.attributeLife = attributeLife.new(timerModule, lifeEndCallback, buffData)
	local addAttr = function(buffID)
		addBuffAttr(self.attrModule, buffID)
	end
	attributeLife.traverseBuff(self.attributeLife, addAttr)
end
function meta:destory()
	self.timeLife:destory()
	self.countLife:destory()
end
function meta:add(buffID)
	local excludeList = self:getExcludeList(buffID)
	if excludeList then
		for _, v in ipairs(excludeList) do
			self:remove(v)
		end
	end
	if self.attributeLife:add(buffID) then
		addBuffAttr(self.attrModule, buffID)
		return true
	else
		return false
	end
end
function meta:getExcludeList(buffID)
	return buffltCtrl.getExclude(buffID)
end
function meta:addCustomBuff(buffID, ti)
	if ti and self.attributeLife:addCustomLife(buffID, ti) then
		addBuffAttr(self.attrModule, buffID)
	end
end
function meta:remove(buffID)
	if self.attributeLife:remove(buffID) then
		removeBuffAttr(self.attrModule, buffID)
		return true
	else
		return false
	end
end
function meta:useAttr(attrID)
	return self.attributeLife:useAttr(attrID)
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
function meta:getBuffData()
	return self.attributeLife:getData()
end
local _ENV, buffModule = function(self)
	return self.attributeLife:getData()
end, function(self)
	return self.attributeLife:getData()
end
function buffModule.new(attrModule, timerModule, buffEndCallback, buffData)
	_ENV = nil
	local m = setmetatable(nil, meta)
	m:init(attrModule, timerModule, buffEndCallback, buffData)
	return m
end
return buffModule
