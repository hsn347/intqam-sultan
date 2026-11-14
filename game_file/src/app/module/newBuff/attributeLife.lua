local buffltCtrl = include("newBuffltCtrl")
local timeLife = include("timeLife")
local countLife = include("countLife")
include("attributeDef")
local gAttributeLifeEnum = gAttributeLifeEnum
local _ENV, meta = "attributeDef", "attributeDef"
meta.__index = meta
function meta:init(timerModule, lifeEndCallback, lifeData)
	self.timerModule = timerModule
	local timeEndCallback = function(buffID)
		self.countLife:remove(buffID)
		lifeEndCallback(buffID)
	end
	local countEndCallback = function(buffID)
		self.timeLife:remove(buffID)
		lifeEndCallback(buffID)
	end
	self.timeLife = timeLife.new(timerModule, timeEndCallback, lifeData and lifeData.timeLifeData)
	self.countLife = countLife.new(countEndCallback, lifeData and lifeData.countLifeData)
end
function meta:destory()
	self.timeLife:destory()
	self.timeLife = nil
	self.countLife:destory()
	self.countLife = nil
end
function meta:add(buffID)
	local lifeType = buffltCtrl.getLifeType(buffID)
	if gAttributeLifeEnum.TIME == lifeType then
		local params = buffltCtrl.getLifeParams(buffID)
		return self.timeLife:add(buffID, params[1])
	elseif gAttributeLifeEnum.COUNT == lifeType then
		local params = buffltCtrl.getLifeParams(buffID)
		return self.countLife:add(buffID, params[1])
	elseif gAttributeLifeEnum.TIME_AND_COUNT == lifeType then
		local params = buffltCtrl.getLifeParams(buffID)
		local ti = params[1]
		local count = params[2]
		if self.timeLife:add(buffID, ti) and self.countLife:add(buffID, count) then
			return true
		else
			return false
		end
	elseif gAttributeLifeEnum.DAILY_RESET_COUNT == lifeType then
		local params = buffltCtrl.getLifeParams(buffID)
		return self.countLife:add(buffID, params[1])
	end
end
function meta:addCustomLife(buffID, ti, count)
	if self.timeLife:add(buffID, ti) then
		return true
	else
		return false
	end
end
function meta:remove(buffID)
	local lifeType = buffltCtrl.getLifeType(buffID)
	if gAttributeLifeEnum.TIME == lifeType then
		return self.timeLife:remove(buffID)
	elseif gAttributeLifeEnum.COUNT == lifeType then
		return self.countLife:remove(buffID)
	elseif gAttributeLifeEnum.TIME_AND_COUNT == lifeType then
		if self.timeLife:remove(buffID) and self.countLife:remove(buffID) then
			return true
		else
			return false
		end
	elseif gAttributeLifeEnum.DAILY_RESET_COUNT == lifeType then
		return self.countLife:remove(buffID)
	end
end
function meta:useAttr(attrID)
	return self.countLife:useAttr(attrID)
end
function meta:getData()
	_UPVALUE0_ = nil
	;(nil).timeLifeData = self.timeLife:getData()
	;(nil).countLifeData = self.countLife:getData()
	return nil
end
local _ENV, attributeLife = function(self)
	_UPVALUE0_ = nil
	;(nil).timeLifeData = self.timeLife:getData()
	;(nil).countLifeData = self.countLife:getData()
	return nil
end, function(self)
	_UPVALUE0_ = nil
	;(nil).timeLifeData = self.timeLife:getData()
	;(nil).countLifeData = self.countLife:getData()
	return nil
end
function attributeLife.new(timerModule, lifeEndCallback, lifeData)
	_ENV = nil
	local life = setmetatable(nil, meta)
	life:init(timerModule, lifeEndCallback, lifeData)
	return life
end
function attributeLife.traverseBuff(life, callback)
	local countLife, addAttrFlag
	local addAttr = function(buffID)
		if not addAttrFlag[buffID] then
			addAttrFlag[buffID] = true
			callback(buffID)
		end
	end
	countLife.traverseBuff(life.countLife, addAttr)
	timeLife.traverseBuff(life.timeLife, addAttr)
end
return attributeLife
