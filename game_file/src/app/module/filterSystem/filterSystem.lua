include("filterDef")
local filterltCtrl = include("filterltCtrl")
local _ENV, filterSystem = "filterltCtrl", "filterltCtrl"
function filterSystem.init()
	filterltCtrl:init()
end
local ARMY_ATTR = ARMY_ATTR
local string = string
local pairs = pairs
local ipairs = ipairs
local type = type
local next = next
local unlockContainLock = function(key, lockValue)
	if lockValue[key] then
		return true
	else
		return false
	end
end
local unlockRangeLock = function(key, lockValue)
	local min = lockValue[1]
	local max = lockValue[2]
	if 0 == max then
		return key >= min
	else
		return key >= min and key <= max
	end
end
local unlockMatchStringLock = function(key, lockValue)
	for str, _ in pairs(lockValue) do
		if string.match(key, str) then
			return true
		end
	end
	return false
end
local unlockUnitPercentLock = function(key, lockValue)
	if not lockValue then
		return false
	end
	local armyTab = lockValue.armyTab
	if type(armyTab) ~= "table" then
		return false
	end
	local totalPercent = 0
	for k, v in pairs(armyTab) do
		local armyType = v
		local curPercent = key[tonumber(armyType)] or 0
		totalPercent = totalPercent + curPercent
	end
	if lockValue.min and lockValue.max then
		if totalPercent >= lockValue.min and totalPercent <= lockValue.max then
			return true
		else
			return false
		end
	else
		return false
	end
end
local unlockBeContainedLock = function(key, lockValue)
	for _, v in pairs(lockValue) do
		if not key[v] then
			return false
		end
	end
	return true
end
_ENV = nil
;(nil)[gFilterLockType.CONTAINS] = unlockContainLock
;(nil)[gFilterLockType.RANGE] = unlockRangeLock
;(nil)[gFilterLockType.MATCH_STRING] = unlockMatchStringLock
;(nil)[gFilterLockType.BE_CONTAINED] = unlockBeContainedLock
local (nil)[gFilterLockType.UNIT_PERCENT], unlockConfig = unlockUnitPercentLock, nil
local unlock = function(key, lock)
	local lockType = lock.type
	if unlockConfig[lockType](key, lock.value) then
		return true
	else
		return false
	end
end
function filterSystem.pass(lock, key)
	assert(lock)
	assert(key)
	if unlock(key, lock) then
		return true
	else
		return false
	end
end
local noEmptyTable = function(t)
	if "table" == type(t) and next(t) then
		return true
	else
		return false
	end
end
function filterSystem.batchPass(filters, filterKeys)
	assert(noEmptyTable(filters))
	assert(noEmptyTable(filterKeys))
	for _, filterID in pairs(filters) do
		local filter = filterltCtrl:getFilter(filterID)
		local filterType = filter.filterType
		local key = filterKeys[filterType]
		if key then
			local lock = filter.lock
			if not unlock(key, lock) then
				return false
			end
		else
			return false
		end
	end
	return true
end
local NO_FILTER_GROUPID = 0
function filterSystem.batchPassByGroup(groupID, filterKeys)
	if NO_FILTER_GROUPID == groupID then
		return true
	elseif "table" == type(filterKeys) and next(filterKeys) then
		local filters = filterltCtrl:getFilterGroup(groupID)
		local pass = filterSystem.batchPass(filters, filterKeys)
		return pass
	else
		return false
	end
end
local convertBattleUnitIDToBattleUnitType = function(battleUnitID)
	local armyltCtrl = include("armyltCtrl")
	return armyltCtrl:armyAttr(battleUnitID, ARMY_ATTR.ARMY_TYPE)
end
local convertBattleUnitIDToBattleUnitLevel = function(battleUnitID)
	local armyltCtrl = include("armyltCtrl")
	local _, level = armyltCtrl:getArmyTypeAndLv(battleUnitID)
	return level
end
_UPVALUE1_, _UPVALUE1_, _ENV = nil, nil, nil
;(nil)[1] = gFilterType.BATTLE_FIELD
_UPVALUE1_, _UPVALUE1_, (nil).battleField, (nil)[1] = nil, nil, nil, nil
;(nil)[1] = gFilterType.BATTLE_TYPE
_UPVALUE1_, _UPVALUE1_, (nil).battleType, (nil)[1] = nil, nil, nil, nil
;(nil)[1] = gFilterType.BATTLE_UNIT
_UPVALUE2_, _UPVALUE2_, (nil).battleUnit, (nil)[1] = nil, nil, nil, nil
_UPVALUE2_, (nil)[1] = gFilterType.BATTLE_UNIT, gFilterType.BATTLE_UNIT
_UPVALUE2_, (nil)[2] = gFilterType.BATTLE_UNIT, convertBattleUnitIDToBattleUnitType
gFilterType.BATTLE_UNIT[1] = gFilterType.BATTLE_UNIT_LEVEL
gFilterType.BATTLE_UNIT[2] = convertBattleUnitIDToBattleUnitLevel
_UPVALUE1_, _UPVALUE1_, (nil).battleUnitID, (nil)[1] = nil, nil, nil, nil
_UPVALUE1_, _UPVALUE1_, (nil).battleUnitID, (nil)[2] = nil, nil, nil, gFilterType.BATTLE_UNIT
;(nil)[1] = gFilterType.MATCH_STRING
_UPVALUE1_, _UPVALUE1_, (nil).matchString, (nil)[1] = nil, nil, nil, nil
;(nil)[1] = gFilterType.RESOURCE
_UPVALUE1_, _UPVALUE1_, (nil).resourceID, (nil)[1] = nil, nil, nil, nil
;(nil)[1] = gFilterType.DISPATCH_TYPE
_UPVALUE1_, _UPVALUE1_, (nil).dispatchType, (nil)[1] = nil, nil, nil, nil
;(nil)[1] = gFilterType.BUILDING
_UPVALUE1_, _UPVALUE1_, (nil).buildingID, (nil)[1] = nil, nil, nil, nil
;(nil)[1] = gFilterType.USE_ARMS
_UPVALUE1_, _UPVALUE1_, (nil).useGodArms, (nil)[1] = nil, nil, nil, nil
;(nil)[1] = gFilterType.BATTLE_UNIT_PERCENT
_UPVALUE1_, _UPVALUE1_, (nil).unitPercent, (nil)[1] = nil, nil, nil, nil
;(nil)[1] = gFilterType.TARGET_TAG
_UPVALUE1_, _UPVALUE1_, (nil).targetTag, (nil)[1] = nil, nil, nil, nil
;(nil)[1] = gFilterType.MAP_OBJ_TYPE
_UPVALUE1_, _UPVALUE1_, (nil).mapObjType, (nil)[1] = nil, nil, nil, nil
;(nil)[1] = gFilterType.SUB_MAP_OBJ_TYPE
_UPVALUE1_, _UPVALUE1_, (nil).subMapObjType, (nil)[1] = nil, nil, nil, nil
;(nil)[1] = gFilterType.SHOP_ITEM_ID
;(nil).shopItemID, (nil)[1] = nil, nil
local keyConfig
local getFilterType = function(config)
	return config[1]
end
local getFilterKey = function(config, v)
	local f = config[2]
	if f then
		return f(v)
	else
		return v
	end
end
local replace = function(t, k, v)
	t[k] = nil
	local configArray = keyConfig[k]
	for _, config in ipairs(configArray) do
		local filterType = getFilterType(config)
		local filterKey = getFilterKey(config, v)
		if filterType and filterKey then
			t[filterType] = filterKey
		end
	end
end
local function convert(t, lastK)
	local k, v = next(t, lastK)
	if k and v then
		convert(t, k)
		replace(t, k, v)
		return t
	end
end
function filterSystem.convertKey(input)
	if "table" == type(input) then
		local filterKeys = convert(input)
		return filterKeys
	else
		return
	end
end
return filterSystem
