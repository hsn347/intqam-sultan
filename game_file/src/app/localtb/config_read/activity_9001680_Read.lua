local activity_9001680_Read = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "gold_miner_battlepass"
;(nil)[2] = true
activity_9001680_Read:defineValue("gold_miner_battlepass", nil)
_UPVALUE2_ = nil
;(nil)[1] = "gold_miner_recharge"
;(nil)[2] = true
activity_9001680_Read:defineValue("gold_miner_recharge", nil)
_UPVALUE2_ = nil
;(nil)[1] = "gold_miner_monster"
;(nil)[2] = true
activity_9001680_Read:defineValue("gold_miner_monster", nil)
_UPVALUE2_ = nil
;(nil)[1] = "gold_miner_element"
;(nil)[2] = true
activity_9001680_Read:defineValue("gold_miner_element", nil)
_UPVALUE2_ = nil
;(nil)[1] = "gold_miner_task"
;(nil)[2] = true
activity_9001680_Read:defineValue("gold_miner_task", nil)
activity_9001680_Read:defineValue("battlepass", function()
	local _ENV, ret
	for k, v in ipairs(activity_9001680_Read.gold_miner_battlepass) do
		v.classType = 1
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.normalReward = serviceFunctions.tableFormat(v.normalReward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.advanceReward = serviceFunctions.tableFormat(v.advanceReward, nil)
		ret[v.classType][v.lv] = v
	end
	return ret
end)
activity_9001680_Read:defineValue("monsters", function()
	local _ENV, ret
	for k, v in ipairs(activity_9001680_Read.gold_miner_monster) do
		if not ret[v.type] then
			ret[v.type], _ENV = nil, nil
		end
		ret[v.type][v.level] = v
	end
	return ret
end)
function activity_9001680_Read.getRechargeCfg(gifttype)
	for i, v in ipairs(activity_9001680_Read.gold_miner_recharge) do
		if v.gifttype == gifttype then
			return v
		end
	end
end
function activity_9001680_Read.getRechargeCfgList(gifttype)
	local _ENV, ret
	for i, v in ipairs(activity_9001680_Read.gold_miner_recharge) do
		if v.gifttype == gifttype then
			table.insert(ret, v)
		end
	end
	return ret
end
function activity_9001680_Read.getRewardList()
	local activity_9001666_Ctrl = SoraDGetCtrl("activity_9001666_Ctrl")
	return activity_9001680_Read.battlepass[1]
end
function activity_9001680_Read.getLevelReward(day)
	local rewardList = activity_9001680_Read.getRewardList()
	return rewardList[day]
end
function activity_9001680_Read.getMaxLevel()
	local rewardList = activity_9001680_Read.getRewardList()
	return #rewardList
end
function activity_9001680_Read.getRewardDataSize()
	local rewardList = activity_9001680_Read.getRewardList()
	return #rewardList
end
function activity_9001680_Read.getAdvanceRewardItem()
	local activity_9001680_Read, reward
	local rewardList = activity_9001680_Read.getRewardList()
	for i, v in ipairs(rewardList) do
		if v.advanceReward[1] and not reward[tostring(v.advanceReward[1].id)] then
			reward[tostring(v.advanceReward[1].id)] = 0
		end
		if v.advanceReward[2] and not reward[tostring(v.advanceReward[2].id)] then
			reward[tostring(v.advanceReward[2].id)] = 0
		end
	end
	for i, v in ipairs(rewardList) do
		if v.advanceReward[1] then
			reward[tostring(v.advanceReward[1].id)] = reward[tostring(v.advanceReward[1].id)] + v.advanceReward[1].count
		end
		if v.advanceReward[2] then
			reward[tostring(v.advanceReward[2].id)] = reward[tostring(v.advanceReward[2].id)] + v.advanceReward[2].count
		end
	end
	local index = 1
	local activity_9001680_Read, result = ipairs(rewardList)
	for i, v in pairs(reward) do
		result[index] = i
		index = index + 1
		result[index] = v
		index = index + 1
	end
	return result
end
function activity_9001680_Read.CheckLastLevel()
	local rewardList = activity_9001680_Read.getRewardList()
	local size = table.nums(rewardList)
	if 1 <= size then
		return true, size
	end
	return false
end
function activity_9001680_Read.getLevelRewardSize()
	return activity_9001680_Read.getNormalRewardSize() + activity_9001680_Read.getExtraRewardSize()
end
function activity_9001680_Read.getNormalRewardSize(index)
	local rewardList = activity_9001680_Read.getRewardList()
	if rewardList[index] then
		return table.nums(rewardList[index].normalReward)
	else
		return 0
	end
end
function activity_9001680_Read.getExtraRewardSize(index)
	local rewardList = activity_9001680_Read.getRewardList()
	if rewardList[index] then
		return table.nums(rewardList[index].advanceReward)
	else
		return 0
	end
end
function activity_9001680_Read.getShowRewad(index)
	local rewardList = activity_9001680_Read.getRewardList()
	local cfg, cfg1
	for i = #rewardList, 1, -1 do
		cfg = rewardList[i]
		cfg1 = cfg1 or cfg
		if index > cfg.lv then
			break
		end
		cfg1 = cfg
	end
	print("==1====", index, cfg1.lv)
	return cfg1
end
function activity_9001680_Read.getElement(id)
	local cfg = activity_9001680_Read.gold_miner_element[id]
	return cfg
end
function activity_9001680_Read.getMonster(type, level)
	local monsters = activity_9001680_Read.monsters[type]
	return monsters and monsters[level] or nil
end
function activity_9001680_Read.getBoomItemID()
	for i, v in ipairs(activity_9001680_Read.gold_miner_element) do
		if v.explosives[1] ~= nil then
			return v.explosives[1]
		end
	end
	return 873601
end
function activity_9001680_Read.getDropidItemIDList(...)
	local activity_9001680_Ctrl = SoraDGetCtrl("activity_9001680_Ctrl")
	local classType = activity_9001680_Ctrl:getClassType()
	local _ENV, map = activity_9001680_Ctrl, activity_9001680_Ctrl
	for __, cfg in ipairs(activity_9001680_Read.gold_miner_element) do
		local dropids = classType == 1 and cfg.dropid1 or cfg.dropid2
		for __, packageID in ipairs(dropids) do
			map[packageID] = true
		end
	end
	for __, cfg in ipairs(activity_9001680_Read.gold_miner_monster) do
		local dropids = classType == 1 and cfg.dropid1 or cfg.dropid2
		for __, packageID in ipairs(dropids) do
			map[packageID] = true
		end
	end
	local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
	local _ENV, retMap = "backpackltCtrl", "backpackltCtrl"
	for packageID, __ in pairs(map) do
		local items = backpackltCtrl:getShowItems(packageID)
		for __, v in ipairs(items) do
			retMap[v.id] = true
		end
	end
	local ret = table.keys(retMap)
	return ret
end
local GOLD_MINER_MAP_OBJ_BITS = 6
local GOLD_MINER_MAP_PIECE_SIZE = 10
local GOLD_MINER_MAP_OBJ_VALUE_MAX = (1 << GOLD_MINER_MAP_OBJ_BITS) - 1
function _ENV()
	local _ENV, ret
	for k, v in ipairs(activity_9001680_Read.gold_miner_monster) do
		if not ret[v.type] then
			ret[v.type], _ENV = nil, nil
		end
		ret[v.type][v.level] = v
	end
	return ret
end
;(function()
	local _ENV, ret
	for k, v in ipairs(activity_9001680_Read.gold_miner_monster) do
		if not ret[v.type] then
			ret[v.type], _ENV = nil, nil
		end
		ret[v.type][v.level] = v
	end
	return ret
end).UNKNOWN = 0
;(function()
	local _ENV, ret
	for k, v in ipairs(activity_9001680_Read.gold_miner_monster) do
		if not ret[v.type] then
			ret[v.type], _ENV = nil, nil
		end
		ret[v.type][v.level] = v
	end
	return ret
end).SOIL = 1
;(function()
	local _ENV, ret
	for k, v in ipairs(activity_9001680_Read.gold_miner_monster) do
		if not ret[v.type] then
			ret[v.type], _ENV = nil, nil
		end
		ret[v.type][v.level] = v
	end
	return ret
end).ROCK = 2
;(function()
	local _ENV, ret
	for k, v in ipairs(activity_9001680_Read.gold_miner_monster) do
		if not ret[v.type] then
			ret[v.type], _ENV = nil, nil
		end
		ret[v.type][v.level] = v
	end
	return ret
end).MONSTER = 3
;(function()
	local _ENV, ret
	for k, v in ipairs(activity_9001680_Read.gold_miner_monster) do
		if not ret[v.type] then
			ret[v.type], _ENV = nil, nil
		end
		ret[v.type][v.level] = v
	end
	return ret
end).BOSS = 4
;(function()
	local _ENV, ret
	for k, v in ipairs(activity_9001680_Read.gold_miner_monster) do
		if not ret[v.type] then
			ret[v.type], _ENV = nil, nil
		end
		ret[v.type][v.level] = v
	end
	return ret
end).TREASURE_CLEW = 5
;(function()
	local _ENV, ret
	for k, v in ipairs(activity_9001680_Read.gold_miner_monster) do
		if not ret[v.type] then
			ret[v.type], _ENV = nil, nil
		end
		ret[v.type][v.level] = v
	end
	return ret
end).TREASURE = 6
;(function()
	local _ENV, ret
	for k, v in ipairs(activity_9001680_Read.gold_miner_monster) do
		if not ret[v.type] then
			ret[v.type], _ENV = nil, nil
		end
		ret[v.type][v.level] = v
	end
	return ret
end).BOX = 7
;(function()
	local _ENV, ret
	for k, v in ipairs(activity_9001680_Read.gold_miner_monster) do
		if not ret[v.type] then
			ret[v.type], _ENV = nil, nil
		end
		ret[v.type][v.level] = v
	end
	return ret
end).ORE = 8
;(function()
	local _ENV, ret
	for k, v in ipairs(activity_9001680_Read.gold_miner_monster) do
		if not ret[v.type] then
			ret[v.type], _ENV = nil, nil
		end
		ret[v.type][v.level] = v
	end
	return ret
end).GEM = 9
local _ENV, (function()
	local _ENV, ret
	for k, v in ipairs(activity_9001680_Read.gold_miner_monster) do
		if not ret[v.type] then
			ret[v.type], _ENV = nil, nil
		end
		ret[v.type][v.level] = v
	end
	return ret
end).NONE, GOLD_MINER_MAP_OBJ_TYPE = "gold_miner_task", GOLD_MINER_MAP_OBJ_VALUE_MAX, function()
	local _ENV, ret
	for k, v in ipairs(activity_9001680_Read.gold_miner_monster) do
		if not ret[v.type] then
			ret[v.type], _ENV = nil, nil
		end
		ret[v.type][v.level] = v
	end
	return ret
end
;("gold_miner_task").UNKNOWN = GOLD_MINER_MAP_OBJ_TYPE.UNKNOWN
;("gold_miner_task").SOIL = GOLD_MINER_MAP_OBJ_TYPE.SOIL
;("gold_miner_task").ROCK = GOLD_MINER_MAP_OBJ_TYPE.ROCK
;("gold_miner_task").MONSTER = GOLD_MINER_MAP_OBJ_TYPE.MONSTER
;("gold_miner_task").BOSS = GOLD_MINER_MAP_OBJ_TYPE.BOSS
;("gold_miner_task").TREASURE_CLEW = GOLD_MINER_MAP_OBJ_TYPE.TREASURE_CLEW
;("gold_miner_task").TREASURE = GOLD_MINER_MAP_OBJ_TYPE.TREASURE
local ("gold_miner_task").NONE, GOLD_MINER_MAP_OBJ = GOLD_MINER_MAP_OBJ_TYPE.NONE, "gold_miner_task"
activity_9001680_Read.MAP_OBJ_TYPE = GOLD_MINER_MAP_OBJ_TYPE
activity_9001680_Read.MAP_OBJ = GOLD_MINER_MAP_OBJ
function activity_9001680_Read.getPieceUnit(n)
	return math.ceil(n / GOLD_MINER_MAP_PIECE_SIZE), (n - 1) % GOLD_MINER_MAP_PIECE_SIZE + 1
end
function activity_9001680_Read.genId(x, y)
	return string.format("%d-%d", x, y)
end
function activity_9001680_Read.getMapPieceNumber(n, i)
	if 1 <= i and i <= GOLD_MINER_MAP_PIECE_SIZE then
		return n >> (GOLD_MINER_MAP_PIECE_SIZE - i) * GOLD_MINER_MAP_OBJ_BITS & GOLD_MINER_MAP_OBJ_VALUE_MAX
	end
end
function activity_9001680_Read.getMap(map, x, y)
	local pieceId, oX, oY = activity_9001680_Read.getPieceId(x, y)
	return map[pieceId] and map[pieceId][oY] and activity_9001680_Read.getMapPieceNumber(map[pieceId][oY], oX) or GOLD_MINER_MAP_OBJ.UNKNOWN
end
function activity_9001680_Read.getPieceId(x, y)
	local pX, oX = activity_9001680_Read.getPieceUnit(x)
	local pY, oY = activity_9001680_Read.getPieceUnit(y)
	return activity_9001680_Read.genId(pX, pY), oX, oY
end
function activity_9001680_Read.getTask(id)
	return activity_9001680_Read.gold_miner_task[id]
end
function activity_9001680_Read.getTasks()
	return activity_9001680_Read.gold_miner_task
end
return activity_9001680_Read
