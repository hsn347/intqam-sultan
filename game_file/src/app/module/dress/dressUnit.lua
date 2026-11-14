local dressltCtrl = include("dressltCtrl")
local dressUnit = class("dressUnit")
function dressUnit:ctor(property)
	self.property = property
	local dressID = self:getDressID()
	self.dressType = dressltCtrl.getDressType(dressID)
	self.lifeType = dressltCtrl.getDressLifeType(dressID)
end
function dressUnit:load(property)
	self.property = property
end
function dressUnit.create(dressID)
	dressUnit = nil
	;(nil).dressID = dressID
	;(nil).startTime = 0
	local (nil).stopTime, property = 0, nil
	return dressUnit.new(property)
end
function dressUnit:getDressID()
	return self.property.dressID
end
function dressUnit:getDressType()
	return self.dressType
end
function dressUnit:getDressLifeType()
	return self.lifeType
end
function dressUnit:isForever()
	if gDressLifeType.FOREVER == self.lifeType then
		return true
	end
	return false
end
function dressUnit:isTiming()
	if gDressLifeType.TIMING == self.lifeType then
		return true
	end
	return false
end
function dressUnit:getRemainTime()
	local ret = 0
	if self:isTiming() then
		ret = self:getStopTime() - serviceFunctions.systemTime()
	end
	return ret
end
function dressUnit:getStartTime()
	return self.property.startTime
end
function dressUnit:getStopTime()
	return self.property.stopTime
end
function dressUnit:getLifetime(...)
	return self.property.lifetime
end
return dressUnit
