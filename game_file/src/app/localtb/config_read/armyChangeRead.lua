armyChangeRead = include("aAReadClass").new()
function armyChangeRead.init()
	_UPVALUE1_ = nil
	;(nil)[1] = "armyexchange_activityname"
	armyChangeRead:defineValue("taskCfg", nil)
	armyChangeRead:defineValue("armyExchangeCfg", function()
		armyChangeRead.armyExchangeCfg, _ENV = nil, nil
		local armyarmyexchange_army = require_once("app." .. LocalTblPath .. ".config_server.armyarmyexchange_army")
		for i, v in ipairs(armyarmyexchange_army) do
			if not armyChangeRead.armyExchangeCfg[v.armyType] then
				armyChangeRead.armyExchangeCfg[v.armyType], _ENV = nil, nil
			end
			if not armyChangeRead.armyExchangeCfg[v.armyType][v.armyLevel] then
				armyChangeRead.armyExchangeCfg[v.armyType][v.armyLevel], _ENV = nil, nil
			end
			_ENV = nil
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			;(nil).cost = serviceFunctions.tableFormat(v.cost, nil)
			;(nil).armyCostNum = v.armyCostNum
			armyChangeRead.armyExchangeCfg[v.armyType][v.armyLevel][v.type], (nil).armyGetNum = nil, v.armyGetNum
		end
		return armyChangeRead.armyExchangeCfg
	end)
	armyChangeRead:defineValue("armyTypeLevelList", function()
		armyChangeRead.armyTypeLevelList, _ENV = nil, nil
		for armyType, v in pairs(armyChangeRead.armyExchangeCfg) do
			if not armyChangeRead.armyTypeLevelList[armyType] then
				armyChangeRead.armyTypeLevelList[armyType], _ENV = nil, nil
			end
			for armyLevel, _ in pairs(v) do
				table.insert(armyChangeRead.armyTypeLevelList[armyType], armyLevel)
			end
			table.sort(armyChangeRead.armyTypeLevelList[armyType], function(l, r)
				return r < l
			end)
		end
		return armyChangeRead.armyTypeLevelList
	end)
	local createData = function(name)
		armyChangeRead.stoneTypeList, _ENV = nil, nil
		armyChangeRead.stoneIDList, _ENV = nil, nil
		local armyarmyexchange_stone = require_once("app." .. LocalTblPath .. ".config_server.armyarmyexchange_stone")
		for _, v in ipairs(armyarmyexchange_stone) do
			if not armyChangeRead.stoneTypeList[v.type] then
				armyChangeRead.stoneTypeList[v.type], _ENV = nil, nil
			end
			if not armyChangeRead.stoneTypeList[v.type][v.type2] then
				armyChangeRead.stoneTypeList[v.type][v.type2], _ENV = nil, nil
			end
			table.insert(armyChangeRead.stoneTypeList[v.type][v.type2], v.index)
			_ENV = v.index
			v.index.stoneID = v.stoneID[1]
			v.index.rate = v.rate
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.index.cost1 = serviceFunctions.tableFormat(v.cost1, nil)
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.index.cost2 = serviceFunctions.tableFormat(v.cost2, nil)
			armyChangeRead.stoneIDList[v.index], v.index.num = v.index, v.stoneID[2]
		end
		if name == "stoneTypeList" then
			return armyChangeRead.stoneTypeList
		elseif name == "stoneIDList" then
			return armyChangeRead.stoneIDList
		end
	end
	armyChangeRead:defineValue("stoneTypeList", createData)
	armyChangeRead:defineValue("stoneIDList", createData)
end
function armyChangeRead.getTaskConfig()
	return armyChangeRead.taskCfg
end
function armyChangeRead.getStoneExchangeList(type, type2)
	if type and type2 then
		if not armyChangeRead.stoneTypeList[tonumber(type)][tonumber(type2)] then
			_ENV = armyChangeRead.stoneTypeList[tonumber(type)][tonumber(type2)]
		end
		return armyChangeRead.stoneTypeList[tonumber(type)][tonumber(type2)]
	elseif type then
		if not armyChangeRead.stoneTypeList[tonumber(type)] then
			_ENV = armyChangeRead.stoneTypeList[tonumber(type)]
		end
		return armyChangeRead.stoneTypeList[tonumber(type)]
	else
		return armyChangeRead.stoneTypeList
	end
end
function armyChangeRead.getStoneExchangeInfo(index)
	return armyChangeRead.stoneIDList[index]
end
function armyChangeRead.getTargetArmyIDList(armyType)
	local bid = gTroopTypeRefBuildID[armyType]
	local armyList = include("armyLogic").getCanTrainList(bid)
	local _ENV, armyIdList = bid, bid
	for _, level in ipairs(armyChangeRead.armyTypeLevelList[armyType]) do
		if armyList[tonumber(level)] then
			table.insert(armyIdList, armyList[tonumber(level)].armyid)
		end
	end
	return armyIdList
end
function armyChangeRead.getOrignArmyIDList(armyType, level)
	local _ENV, armyIdList
	for i, v in pairs(gTroopType) do
		local armyId = include("armyLogic").getArmyIdByLevelAndBid(gTroopTypeRefBuildID[v], level)
		if v ~= armyType and armyId then
			table.insert(armyIdList, armyId)
		end
	end
	return armyIdList
end
function armyChangeRead.getArmyTranferCost(armyType, level)
	return armyChangeRead.armyExchangeCfg[armyType][level]
end
function armyChangeRead.getKey(armyType, armyLevel, type)
	return string.format("%d_%d_%d", armyType, armyLevel, type)
end
function armyChangeRead.getExchangeitemByType(type, type2)
	local index = armyChangeRead.stoneTypeList[type][type2][1]
	local detaiInfo = armyChangeRead.getStoneExchangeInfo(index)
	return detaiInfo.cost1[1].id
end
armyChangeRead.init()
return armyChangeRead
