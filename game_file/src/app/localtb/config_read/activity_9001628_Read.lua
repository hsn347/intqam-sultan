local activity_9001628_Read = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "nebula_treasure_hunt_data"
	;(nil)[2] = true
	activity_9001628_Read:defineValue("thd", nil)
	_ENV = nil
	;(nil)[1] = "nebula_treasure_hunt_adventure"
	;(nil)[2] = true
	activity_9001628_Read:defineValue("tha", nil)
	_ENV = nil
	;(nil)[1] = "recharge_treasure_hunt_recharge"
	;(nil)[2] = true
	activity_9001628_Read:defineValue("rth", nil)
	_ENV = nil
	;(nil)[1] = "nebulatreasure_hunt_achievement"
	;(nil)[2] = true
	activity_9001628_Read:defineValue("nebulatreasure_hunt_achievement", nil)
	activity_9001628_Read:defineValue("thga", function()
		local _ENV, ret
		for i, v in ipairs(activity_9001628_Read.nebulatreasure_hunt_achievement) do
			if not ret[v.classtype] then
				_ENV = ret[v.classtype]
			end
			ret[v.classtype] = ret[v.classtype]
			table.insert(ret[v.classtype], v)
		end
		return ret
	end)
	function _ENV()
		local _ENV, ret
		for i, v in ipairs(activity_9001628_Read.nebulatreasure_hunt_achievement) do
			if not ret[v.classtype] then
				_ENV = ret[v.classtype]
			end
			ret[v.classtype] = ret[v.classtype]
			table.insert(ret[v.classtype], v)
		end
		return ret
	end
	;(function()
		local _ENV, ret
		for i, v in ipairs(activity_9001628_Read.nebulatreasure_hunt_achievement) do
			if not ret[v.classtype] then
				_ENV = ret[v.classtype]
			end
			ret[v.classtype] = ret[v.classtype]
			table.insert(ret[v.classtype], v)
		end
		return ret
	end)[1] = "nebula_treasure_hunt_map"
	;(function()
		local _ENV, ret
		for i, v in ipairs(activity_9001628_Read.nebulatreasure_hunt_achievement) do
			if not ret[v.classtype] then
				_ENV = ret[v.classtype]
			end
			ret[v.classtype] = ret[v.classtype]
			table.insert(ret[v.classtype], v)
		end
		return ret
	end)[2] = true
	activity_9001628_Read:defineValue("thm", function()
		local _ENV, ret
		for i, v in ipairs(activity_9001628_Read.nebulatreasure_hunt_achievement) do
			if not ret[v.classtype] then
				_ENV = ret[v.classtype]
			end
			ret[v.classtype] = ret[v.classtype]
			table.insert(ret[v.classtype], v)
		end
		return ret
	end)
	function _ENV()
		local _ENV, ret
		for i, v in ipairs(activity_9001628_Read.nebulatreasure_hunt_achievement) do
			if not ret[v.classtype] then
				_ENV = ret[v.classtype]
			end
			ret[v.classtype] = ret[v.classtype]
			table.insert(ret[v.classtype], v)
		end
		return ret
	end
	;(function()
		local _ENV, ret
		for i, v in ipairs(activity_9001628_Read.nebulatreasure_hunt_achievement) do
			if not ret[v.classtype] then
				_ENV = ret[v.classtype]
			end
			ret[v.classtype] = ret[v.classtype]
			table.insert(ret[v.classtype], v)
		end
		return ret
	end)[1] = "nebutreasure_hunt_gift_merchant"
	;(function()
		local _ENV, ret
		for i, v in ipairs(activity_9001628_Read.nebulatreasure_hunt_achievement) do
			if not ret[v.classtype] then
				_ENV = ret[v.classtype]
			end
			ret[v.classtype] = ret[v.classtype]
			table.insert(ret[v.classtype], v)
		end
		return ret
	end)[2] = true
	activity_9001628_Read:defineValue("nebutreasure_hunt_gift_merchant", function()
		local _ENV, ret
		for i, v in ipairs(activity_9001628_Read.nebulatreasure_hunt_achievement) do
			if not ret[v.classtype] then
				_ENV = ret[v.classtype]
			end
			ret[v.classtype] = ret[v.classtype]
			table.insert(ret[v.classtype], v)
		end
		return ret
	end)
	activity_9001628_Read:defineValue("thgm", function()
		local _ENV, ret
		for i, v in ipairs(activity_9001628_Read.nebutreasure_hunt_gift_merchant) do
			if not ret[v.classtype] then
				_ENV = ret[v.classtype]
			end
			ret[v.classtype] = ret[v.classtype]
			table.insert(ret[v.classtype], v)
		end
		return ret
	end)
	function _ENV()
		local _ENV, ret
		for i, v in ipairs(activity_9001628_Read.nebutreasure_hunt_gift_merchant) do
			if not ret[v.classtype] then
				_ENV = ret[v.classtype]
			end
			ret[v.classtype] = ret[v.classtype]
			table.insert(ret[v.classtype], v)
		end
		return ret
	end
	;(function()
		local _ENV, ret
		for i, v in ipairs(activity_9001628_Read.nebutreasure_hunt_gift_merchant) do
			if not ret[v.classtype] then
				_ENV = ret[v.classtype]
			end
			ret[v.classtype] = ret[v.classtype]
			table.insert(ret[v.classtype], v)
		end
		return ret
	end)[1] = "treasure_hunt_secret"
	;(function()
		local _ENV, ret
		for i, v in ipairs(activity_9001628_Read.nebutreasure_hunt_gift_merchant) do
			if not ret[v.classtype] then
				_ENV = ret[v.classtype]
			end
			ret[v.classtype] = ret[v.classtype]
			table.insert(ret[v.classtype], v)
		end
		return ret
	end)[2] = true
	activity_9001628_Read:defineValue("treasure_hunt_secret", function()
		local _ENV, ret
		for i, v in ipairs(activity_9001628_Read.nebutreasure_hunt_gift_merchant) do
			if not ret[v.classtype] then
				_ENV = ret[v.classtype]
			end
			ret[v.classtype] = ret[v.classtype]
			table.insert(ret[v.classtype], v)
		end
		return ret
	end)
end
function activity_9001628_Read:getHuntSecretCfg()
	return activity_9001628_Read.treasure_hunt_secret
end
function activity_9001628_Read:getHuntSecretTimes(rounds)
	local times = 0
	for _, v in ipairs(activity_9001628_Read.treasure_hunt_secret) do
		if rounds >= v.require then
			times = v.index
		end
	end
	return times
end
function activity_9001628_Read:getRechargeName(rechargeID)
	for _, v in ipairs(activity_9001628_Read.treasure_hunt_secret) do
		if rechargeID == v.RechargeID then
			return i18n(v.name)
		end
	end
end
function activity_9001628_Read:getBuyThrowDiceNumLimit()
	return tonumber(activity_9001628_Read.thd[1].limit) or 0
end
function activity_9001628_Read:getBuySingleDiceCountCost()
	return tonumber(activity_9001628_Read.thd[1].price) or 1
end
function activity_9001628_Read:getRoundRewards()
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	return serviceFunctions.tableFormat(activity_9001628_Read.thd[1].roundReward, nil)
end
function activity_9001628_Read:getTreasureHuntPackageInfo(packageID)
	if activity_9001628_Read.rth[packageID] then
		return activity_9001628_Read.rth[packageID]
	end
end
function activity_9001628_Read:getTreasureHuntPackageInfoByPrice(price)
	local _ENV, packageList
	for k, v in pairs(activity_9001628_Read.rth) do
		if v.price == price then
			table.insert(packageList, v)
		end
	end
	return packageList
end
function activity_9001628_Read:getTreasureHuntAchievementInfo()
	local group = SoraDGetCtrl("activity_9001628_Ctrl"):getGroupID()
	if not activity_9001628_Read.thga[group] then
		_ENV = activity_9001628_Read.thga[group]
	end
	return activity_9001628_Read.thga[group]
end
function activity_9001628_Read:getTreasureHuntMapInfo()
	if not activity_9001628_Read.thm then
		activity_9001628_Read = activity_9001628_Read.thm
	end
	return activity_9001628_Read.thm
end
function activity_9001628_Read:getMapRealType(index)
	if activity_9001628_Read.thm[index] then
		return activity_9001628_Read.thm[index].type
	end
end
function activity_9001628_Read:getMerchantPackageInfoByID(packageID)
	local _ENV, packageInfo
	local group = SoraDGetCtrl("activity_9001628_Ctrl"):getGroupID()
	if not activity_9001628_Read.thgm[group] then
		local _ENV, cfgs = activity_9001628_Read.thgm[group], activity_9001628_Read.thgm[group]
	end
	for i, v in ipairs(cfgs) do
		if packageID == v.packageId then
			packageInfo = v
		end
	end
	return packageInfo
end
function activity_9001628_Read:getMerchantPackageInfoList()
	local group = SoraDGetCtrl("activity_9001628_Ctrl"):getGroupID()
	if not activity_9001628_Read.thgm[group] then
		local _ENV, cfgs = activity_9001628_Read.thgm[group], activity_9001628_Read.thgm[group]
	end
	return cfgs
end
function activity_9001628_Read:getThaCfg(thaType, eventNum)
	for i, v in ipairs(activity_9001628_Read.tha) do
		if v.type == thaType then
			if v.type == gNTHAdveType.MOVE_FORWARD_NOW or v.type == gNTHAdveType.BACK_OFF_NOW then
				if eventNum == v.parameter then
					return v
				end
			else
				return v
			end
		end
	end
end
init()
return activity_9001628_Read
