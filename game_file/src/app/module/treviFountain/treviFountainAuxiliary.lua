local treviFountainAuxiliary = class("treviFountainAuxiliary")
local gametop = gModuleMgr.getObject("gametop")
local treviFountainLocalData = include("treviFountainLocalData")
local cityltCtrl = include("cityltCtrl")
function treviFountainAuxiliary:ctor()
	self.treviFountainLocalData = treviFountainLocalData
end
function treviFountainAuxiliary:handleData(data)
	local _ENV, rs
	local multipleTimes = 0
	local castleLevel = SoraDGetCastleLv()
	if data and next(data) ~= nil then
		multipleTimes = data.multipleTimes
		rs.multipleTimes = multipleTimes
	end
	_ENV, _ENV = data, next(data)
	data.id = gIDDef.FOOD
	data.multipleTimes = data.foodMultipleTimes
	_ENV, next(data)[1], data.payMultipleTimes = data, data, data.payFoodMultipleTimes
	data.id = gIDDef.WOOD
	data.multipleTimes = data.woodMultipleTimes
	next(data)[2], data.payMultipleTimes = data, data.payWoodMultipleTimes
	local config = next(data)
	if castleLevel >= CASTLE_LV10_LIMITED then
		_ENV = nil
		;(nil).id = gIDDef.IRON
		;(nil).multipleTimes = data.ironMultipleTimes
		;(nil).payMultipleTimes = data.payIronMultipleTimes
		table.insert(config, nil)
		_ENV = nil
		;(nil).id = gIDDef.STEEL
		;(nil).multipleTimes = data.steelMultipleTimes
		;(nil).payMultipleTimes = data.paySteelMultipleTimes
		table.insert(config, nil)
	end
	if castleLevel >= CASTLE_LV15_LIMITED then
		_ENV = nil
		;(nil).id = gIDDef.MITHRIL
		;(nil).multipleTimes = data.mithrilMultipleTimes
		;(nil).payMultipleTimes = data.payMithrilMultipleTimes
		table.insert(config, nil)
	end
	if castleLevel >= CASTLE_LV60_LIMITED then
		_ENV = nil
		;(nil).id = gIDDef.CRYSTAL
		;(nil).multipleTimes = data.crystalMultipleTimes
		;(nil).payMultipleTimes = data.payCrystalMultipleTimes
		table.insert(config, nil)
	end
	local _ENV, temp = table.insert, table.insert
	local capacity = self:getBaseResource()
	for __, v in ipairs(config) do
		local resTotal, otherTotal, actTotal = self:resetResouce(self:getResourceCount(capacity, v.id), v.multipleTimes)
		_ENV = v.id
		v.id.resTotal = resTotal
		v.id.otherTotal = otherTotal
		v.id.actTotal = actTotal
		v.id.gold = self:getMultipleCost(multipleTimes, v.payMultipleTimes)
		temp[tostring(v.id)], v.id.goldTen = v.id, self:getTenMultipleCost(multipleTimes, v.payMultipleTimes, 10)
	end
	rs.multipleResource = temp
	if data.addResource then
		rs.addResource = data.addResource
	end
	if data.must then
		rs.must = data.must
	end
	if data.drop then
		rs.drop = data.drop
	end
	return rs, data
end
function treviFountainAuxiliary:getBaseResource()
	local buildLogic = include("buildLogic")
	local capacity = buildLogic.getBuildBaseValue(BUILDID.WISHING_WELL, "capacity")
	return capacity
end
function treviFountainAuxiliary:getResourceCount(capacity, vtype)
	local count = 0
	if capacity and next(capacity) ~= nil then
		for i, var in ipairs(capacity) do
			if var == vtype and i % 2 == 1 then
				count = capacity[i + 1]
			end
		end
	end
	return count
end
function treviFountainAuxiliary:resetResouce(resource, times)
	if times == 0 then
		times = 1
	else
		times = times + 1
	end
	if times >= TREASUREHUNT_ADD_TIMES then
		times = TREASUREHUNT_ADD_TIMES
	end
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local buff = buffCtrl:getBuffEffect(gBuffEffect.WISH_RESOURCE_BOOST) or 0
	buff = buff and buff / 1000 or 0
	local rs = math.floor(resource * (1 + 0.005 * (times - 1)) * (1 + buff))
	local actBuff = buffCtrl:getBuffEffect(gBuffEffect.WISH_RESOURCE_BOOST, gBuffSource.ACTIVITY) or 0
	local otherTotal = 0
	if 0 < actBuff then
		actBuff = actBuff / 1000
		otherTotal = math.floor(resource * (1 + 0.005 * (times - 1)) * (1 + buff - actBuff))
	else
		otherTotal = rs
	end
	local actTotal = rs - otherTotal
	return rs, otherTotal, actTotal
end
function treviFountainAuxiliary:getMultipleCost(multipleTimes, payTimes)
	local cast
	if multipleTimes == 0 then
		local castTemp = (payTimes + 1) * 2
		if castTemp ~= 0 then
			if castTemp >= TREASUREHUNT_COST_GOLD_MAX then
				cast = TREASUREHUNT_COST_GOLD_MAX
			else
				cast = castTemp
			end
		end
	end
	return cast
end
function treviFountainAuxiliary:validate(data, type, isTen)
	local err = gErrDef.Err_None
	local multipleTimes = 0
	local cast = 0
	if data and next(data) ~= nil then
		_ENV, multipleTimes = next(data), data.multipleTimes
		_ENV = gIDDef.FOOD
		next(data)[tostring(gIDDef.FOOD)], gIDDef.FOOD.payMultipleTimes = gIDDef.FOOD, data.payFoodMultipleTimes
		_ENV = gIDDef.WOOD
		next(data)[tostring(gIDDef.WOOD)], gIDDef.WOOD.payMultipleTimes = gIDDef.WOOD, data.payWoodMultipleTimes
		_ENV = gIDDef.IRON
		next(data)[tostring(gIDDef.IRON)], gIDDef.IRON.payMultipleTimes = gIDDef.IRON, data.payIronMultipleTimes
		_ENV = gIDDef.STEEL
		next(data)[tostring(gIDDef.STEEL)], gIDDef.STEEL.payMultipleTimes = gIDDef.STEEL, data.paySteelMultipleTimes
		_ENV = gIDDef.MITHRIL
		next(data)[tostring(gIDDef.MITHRIL)], gIDDef.MITHRIL.payMultipleTimes = gIDDef.MITHRIL, data.payMithrilMultipleTimes
		_ENV = gIDDef.CRYSTAL
		next(data)[tostring(gIDDef.CRYSTAL)], gIDDef.CRYSTAL.payMultipleTimes = gIDDef.CRYSTAL, data.payCrystalMultipleTimes
		local config = next(data)
		local typeData = config[tostring(type)]
		if typeData then
			if isTen then
				cast = self:getTenMultipleCost(multipleTimes, typeData.payMultipleTimes, 10)
			else
				cast = self:getMultipleCost(multipleTimes, typeData.payMultipleTimes)
			end
		end
	end
	if cast and not SoraDEnoughGold(cast) then
		err = gErrDef.Err_NOT_ENOUGH_GOLD
	end
	return err
end
function treviFountainAuxiliary:getTenMultipleCost(multipleTimes, payTimes, totalTimes)
	local cast = 0
	if multipleTimes < totalTimes then
		local costTimes = totalTimes - multipleTimes
		for i = 1, costTimes do
			cast = cast + self:getMultipleCost(0, payTimes + i - 1)
		end
	end
	return cast
end
return treviFountainAuxiliary
