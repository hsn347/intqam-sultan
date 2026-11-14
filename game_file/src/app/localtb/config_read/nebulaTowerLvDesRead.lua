local nebulaTowerLvDesRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	nebulaTowerLvDesRead = nil
	;(nil)[1] = "tower_lv_privilege"
	nebulaTowerLvDesRead:defineValue("privilegeTb", nil)
	_ENV = nil
	;(nil)[1] = "nebula_area_tower"
	;(nil)[2] = true
	nebulaTowerLvDesRead:defineValue("lvCfg", nil)
	nebulaTowerLvDesRead = nil
	;(nil)[1] = "tower_lv_exp_list"
	nebulaTowerLvDesRead:defineValue("expTb", nil)
	nebulaTowerLvDesRead = nil
	;(nil)[1] = "tower_lv_describe_config"
	nebulaTowerLvDesRead:defineValue("desTb", nil)
	nebulaTowerLvDesRead:defineValue("expCfgTb", function()
		_ENV, _ENV = nil, nil
		_ENV, (nil)[1], (nil).size = nil, nil, cc.size(50, 50)
		_ENV, (nil)[2], (nil).size = nil, nil, cc.size(55, 55)
		_ENV, (nil)[3], (nil).size = nil, nil, cc.size(40, 40)
		_ENV, (nil)[4], (nil).size = nil, nil, cc.size(45, 45)
		_ENV, (nil)[5], (nil).size = nil, nil, cc.size(60, 60)
		;(nil)[6], (nil).size = nil, cc.size(45, 45)
		return nil
	end)
	nebulaTowerLvDesRead:defineValue("desKeyTb", function()
		nebulaTowerLvDesRead.desKeyTb, nebulaTowerLvDesRead = nil, nil
		for i, v in ipairs(nebulaTowerLvDesRead.desTb) do
			nebulaTowerLvDesRead.desKeyTb[v.kingdomLv] = v
		end
		return nebulaTowerLvDesRead.desKeyTb
	end)
	nebulaTowerLvDesRead:defineValue("privilegeTbCfg", function()
		local _ENV, ret
		for k, v in pairs(nebulaTowerLvDesRead.privilegeTb) do
			local classType = v.type
			if not ret[classType] then
				_ENV = ret[classType]
			end
			ret[classType] = ret[classType]
			if not ret[classType][v.season] then
				_ENV = ret[classType][v.season]
			end
			ret[classType][v.season] = ret[classType][v.season]
			table.insert(ret[classType][v.season], v)
		end
		for __, v in pairs(ret) do
			for __, w in pairs(v) do
				table.sort(w, function(a, b)
					return a.kingdomLv < b.kingdomLv
				end)
			end
		end
		return ret
	end)
	nebulaTowerLvDesRead:defineValue("lvSeasonCfgs", function()
		local _ENV, ret
		for __, v in ipairs(nebulaTowerLvDesRead.lvCfg) do
			if not ret[v.type] then
				_ENV = ret[v.type]
			end
			ret[v.type] = ret[v.type]
			if not ret[v.type][v.season] then
				_ENV = ret[v.type][v.season]
			end
			ret[v.type][v.season] = ret[v.type][v.season]
			table.insert(ret[v.type][v.season], v)
		end
		return ret
	end)
end
function nebulaTowerLvDesRead.getLvCfg(lv)
	local lvCfg = nebulaTowerLvDesRead.getLvConfigs()
	for k, v in pairs(lvCfg) do
		if v.towerLV == lv + 1 then
			return v
		end
	end
	return nil
end
function nebulaTowerLvDesRead.getMonsterMaxLv(lv)
	local nebulaTowerLvDesRead, cfg
	local lvCfg = nebulaTowerLvDesRead.getLvConfigs()
	for k, v in ipairs(lvCfg) do
		if v.towerLV == lv then
			cfg = v
			break
		end
	end
	local maxLv = 41
	if next(cfg) then
		for k, v in ipairs(cfg.npcId) do
			maxLv = math.max(maxLv, v % 100)
		end
	end
	return maxLv
end
function nebulaTowerLvDesRead.getExpItemSize(id)
	if nebulaTowerLvDesRead.expCfgTb[id] then
		return nebulaTowerLvDesRead.expCfgTb[id]
	end
	return cc.size(50, 50)
end
function nebulaTowerLvDesRead.getExpItem(id)
	return nebulaTowerLvDesRead.expTb[id]
end
function nebulaTowerLvDesRead.getExpItemRank(id)
	return nebulaTowerLvDesRead.expTb[id].rank
end
function nebulaTowerLvDesRead.getExpList()
	return nebulaTowerLvDesRead.expTb
end
function nebulaTowerLvDesRead.getMaxLevel()
	local privilegeTb = nebulaTowerLvDesRead.getConfigs()
	return #privilegeTb - 1
end
function nebulaTowerLvDesRead.getDes(buffId, condition)
	if not condition then
		return i18n(nebulaTowerLvDesRead.desKeyTb[buffId].buffDes)
	elseif condition[buffId] then
		if buffId == 102 then
			local key = nebulaTowerLvDesRead.desKeyTb[buffId].buffDes
			_ENV = nil
			;(nil).lv = condition[buffId]
			return i18n(key, nil)
		else
			local key = nebulaTowerLvDesRead.desKeyTb[buffId].buffDes
			return i18n(key)
		end
	else
		local key = nebulaTowerLvDesRead.desKeyTb[buffId].buffDes
		return i18n(key)
	end
end
function nebulaTowerLvDesRead.getBuffIcon(buffId)
	return nebulaTowerLvDesRead.desKeyTb[buffId].picture
end
function nebulaTowerLvDesRead.queryBuffData(level)
	local nebulaTowerLvDesRead, buffRet
	local nebulaTowerLvDesRead, buffRetKey
	local privilegeTb = nebulaTowerLvDesRead.getConfigs()
	if privilegeTb and type(privilegeTb) == "table" then
		local data = privilegeTb[level + 1]
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
function nebulaTowerLvDesRead.queryBuffDataDif(level1, level2)
	local larger1, larger2
	if level2 <= level1 then
		larger1 = level1
		larger2 = level2
	else
		larger2 = level1
		larger1 = level2
	end
	local privilegeTb = nebulaTowerLvDesRead.getConfigs()
	local buff1, buffkey1 = nebulaTowerLvDesRead.queryBuffData(larger1)
	local buff2, buffkey2 = nebulaTowerLvDesRead.queryBuffData(larger2)
	local nebulaTowerLvDesRead, ret
	for k, v in pairs(buffkey1) do
		local tmpValue = buffkey2[k]
		if tmpValue then
			v.value1 = tmpValue.value
		else
			v.value1 = 0
		end
		local showRank = nebulaTowerLvDesRead.desKeyTb[v.buffType]
		if showRank then
			v.rank = showRank.rank
		else
			v.rank = 999
		end
		if not privilegeTb[larger1].condition then
			local nebulaTowerLvDesRead, conditionRet = privilegeTb[larger1].condition, privilegeTb[larger1].condition
		end
		if not privilegeTb[larger2] or not privilegeTb[larger2].condition then
			local nebulaTowerLvDesRead, conditionRet1 = privilegeTb[larger2].condition, privilegeTb[larger2].condition
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
function nebulaTowerLvDesRead.getExpListMap()
	local _ENV, ret
	for k, v in pairs(nebulaTowerLvDesRead.expTb) do
		ret[k] = v.origin
	end
	return ret
end
function nebulaTowerLvDesRead.getLookCurLv(minLv)
	minLv = math.max(math.min(minLv, nebulaTowerLvDesRead.getMaxLevel() - 1), 0)
	return minLv, minLv + 1
end
function nebulaTowerLvDesRead.getConfigs()
	local nebulaWarUtil = include("nebulaWarUtil")
	local group = nebulaWarUtil.getRegionGroup()
	local privilegeTbCfg = nebulaTowerLvDesRead.privilegeTbCfg[group]
	return privilegeTbCfg[1]
end
function nebulaTowerLvDesRead.getLvConfigs()
	local nebulaWarUtil = include("nebulaWarUtil")
	local group = nebulaWarUtil.getRegionGroup()
	local lvSeasonCfgs = nebulaTowerLvDesRead.lvSeasonCfgs[group]
	local levelCfg = lvSeasonCfgs[1]
	return levelCfg
end
init()
return nebulaTowerLvDesRead
