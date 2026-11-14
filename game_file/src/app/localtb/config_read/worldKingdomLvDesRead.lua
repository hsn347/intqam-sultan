local worldKingdomLvDesRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	worldKingdomLvDesRead = nil
	;(nil)[1] = "kingdom_lv_privilege"
	worldKingdomLvDesRead:defineValue("privilegeTb", nil)
	worldKingdomLvDesRead = nil
	;(nil)[1] = "kingdom_lv_exp_list"
	worldKingdomLvDesRead:defineValue("expTb", nil)
	worldKingdomLvDesRead = nil
	;(nil)[1] = "kingdom_lv_describe_config"
	worldKingdomLvDesRead:defineValue("desTb", nil)
	worldKingdomLvDesRead:defineValue("expCfgTb", function()
		_ENV, _ENV = nil, nil
		_ENV, (nil)[1], (nil).size = nil, nil, cc.size(50, 50)
		_ENV, (nil)[2], (nil).size = nil, nil, cc.size(55, 55)
		_ENV, (nil)[3], (nil).size = nil, nil, cc.size(40, 40)
		_ENV, (nil)[4], (nil).size = nil, nil, cc.size(45, 45)
		_ENV, (nil)[5], (nil).size = nil, nil, cc.size(60, 60)
		;(nil)[6], (nil).size = nil, cc.size(45, 45)
		return nil
	end)
	worldKingdomLvDesRead:defineValue("desKeyTb", function()
		worldKingdomLvDesRead.desKeyTb, worldKingdomLvDesRead = nil, nil
		for i, v in ipairs(worldKingdomLvDesRead.desTb) do
			worldKingdomLvDesRead.desKeyTb[v.kingdomLv] = v
		end
		return worldKingdomLvDesRead.desKeyTb
	end)
end
function worldKingdomLvDesRead.getExpItemSize(id)
	if worldKingdomLvDesRead.expCfgTb[id] then
		return worldKingdomLvDesRead.expCfgTb[id]
	end
	return cc.size(50, 50)
end
function worldKingdomLvDesRead.getExpItem(id)
	return worldKingdomLvDesRead.expTb[id]
end
function worldKingdomLvDesRead.getExpItemRank(id)
	return worldKingdomLvDesRead.expTb[id].rank
end
function worldKingdomLvDesRead.getExpList()
	return worldKingdomLvDesRead.expTb
end
function worldKingdomLvDesRead.getMaxLevel()
	return #worldKingdomLvDesRead.privilegeTb
end
function worldKingdomLvDesRead.getDes(buffId, condition)
	if not condition then
		return i18n(worldKingdomLvDesRead.desKeyTb[buffId].buffDes)
	elseif condition[buffId] then
		if buffId == 102 then
			local key = worldKingdomLvDesRead.desKeyTb[buffId].buffDes
			_ENV = nil
			;(nil).lv = condition[buffId]
			return i18n(key, nil)
		else
			local key = worldKingdomLvDesRead.desKeyTb[buffId].buffDes
			return i18n(key)
		end
	else
		local key = worldKingdomLvDesRead.desKeyTb[buffId].buffDes
		return i18n(key)
	end
end
function worldKingdomLvDesRead.getBuffIcon(buffId)
	return worldKingdomLvDesRead.desKeyTb[buffId].picture
end
function worldKingdomLvDesRead.queryBuffData(level)
	local worldKingdomLvDesRead, buffRet
	local worldKingdomLvDesRead, buffRetKey
	if worldKingdomLvDesRead.privilegeTb and type(worldKingdomLvDesRead.privilegeTb) == "table" then
		local data = worldKingdomLvDesRead.privilegeTb[level]
		if data then
			_UPVALUE3_ = nil
			;(nil)[1] = "buffType"
			;(nil)[2] = "effectType"
			;(nil)[3] = "value"
			buffRet = serviceFunctions.tableFormat(data.buff, nil)
			for k, v in pairs(buffRet) do
				buffRetKey[v.buffType] = v
			end
		end
	end
	return buffRet, buffRetKey
end
function worldKingdomLvDesRead.queryBuffDataDif(level1, level2)
	local larger1, larger2
	if level2 <= level1 then
		larger1 = level1
		larger2 = level2
	else
		larger2 = level1
		larger1 = level2
	end
	local buff1, buffkey1 = worldKingdomLvDesRead.queryBuffData(larger1)
	local buff2, buffkey2 = worldKingdomLvDesRead.queryBuffData(larger2)
	local worldKingdomLvDesRead, ret
	for k, v in pairs(buffkey1) do
		local tmpValue = buffkey2[k]
		if tmpValue then
			v.value1 = tmpValue.value
		else
			v.value1 = 0
		end
		local showRank = worldKingdomLvDesRead.desKeyTb[v.buffType]
		if showRank then
			v.rank = showRank.rank
		else
			v.rank = 999
		end
		local conditionRet = worldKingdomLvDesRead.privilegeTb[larger1].condition
		if not worldKingdomLvDesRead.privilegeTb[larger2] or not worldKingdomLvDesRead.privilegeTb[larger2].condition then
			local worldKingdomLvDesRead, conditionRet1 = worldKingdomLvDesRead.privilegeTb[larger2].condition, worldKingdomLvDesRead.privilegeTb[larger2].condition
		end
		if 1 < #conditionRet then
			conditionRet = serviceFunctions.tableFormatToMap(conditionRet)
		end
		if 1 < #conditionRet1 then
			conditionRet1 = serviceFunctions.tableFormatToMap(conditionRet1)
		end
		for k, v in pairs(conditionRet) do
			if not conditionRet1[k] then
				conditionRet1[k] = v
			end
		end
		v.condition = conditionRet
		v.condition1 = conditionRet1
	end
	return buffkey1
end
function worldKingdomLvDesRead.getExpListMap()
	local _ENV, ret
	for k, v in pairs(worldKingdomLvDesRead.expTb) do
		ret[k] = v.origin
	end
	return ret
end
init()
return worldKingdomLvDesRead
