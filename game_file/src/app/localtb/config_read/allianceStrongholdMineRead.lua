local allianceStrongholdMineRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "alliance_stronghold_mine"
	;(nil)[2] = true
	allianceStrongholdMineRead:defineValue("mineInfo", nil)
	allianceStrongholdMineRead = nil
	;(nil)[1] = "alliance_stronghold_mine_config"
	allianceStrongholdMineRead:defineValue("mineCfg", nil)
	allianceStrongholdMineRead = nil
	;(nil)[1] = "stronghold_build_config"
	allianceStrongholdMineRead:defineValue("buildCfg", nil)
	allianceStrongholdMineRead = nil
	;(nil)[1] = "stronghold_army_config"
	allianceStrongholdMineRead:defineValue("armyCfg", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "alliance_stronghold_build"
	;(nil)[2] = true
	allianceStrongholdMineRead:defineValue("strongholdBuildCfg", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "alliance_stronghold_buff"
	;(nil)[2] = true
	allianceStrongholdMineRead:defineValue("buffCfg", nil)
end
init()
function allianceStrongholdMineRead.getMineName(id)
	local id = id or 6001
	return i18n(allianceStrongholdMineRead.mineCfg[id].name)
end
function allianceStrongholdMineRead.getMineImage(id)
	local id = id or 6001
	return allianceStrongholdMineRead.mineCfg[id].image
end
function allianceStrongholdMineRead.getMineIconLod(id)
	local id = id or 6001
	return allianceStrongholdMineRead.mineCfg[id].iconLod
end
function allianceStrongholdMineRead.getMineOutputId(id)
	return allianceStrongholdMineRead.mineInfo[id].outputId
end
function allianceStrongholdMineRead.getMineOutputNum(id)
	return allianceStrongholdMineRead.mineInfo[id].outputNum
end
function allianceStrongholdMineRead.getGateLv(id)
	return allianceStrongholdMineRead.strongholdBuildCfg[id].level
end
function allianceStrongholdMineRead.getGateBuffType(id)
	return allianceStrongholdMineRead.strongholdBuildCfg[id].type
end
function allianceStrongholdMineRead.getGatePos(id)
	return cc.p(allianceStrongholdMineRead.strongholdBuildCfg[id].x, allianceStrongholdMineRead.strongholdBuildCfg[id].y)
end
function allianceStrongholdMineRead.getFirstRewards(id)
	return allianceStrongholdMineRead.strongholdBuildCfg[id].rewards
end
function allianceStrongholdMineRead.getBosstime(id)
	return allianceStrongholdMineRead.strongholdBuildCfg[id].bosstime
end
function allianceStrongholdMineRead.getGateClientCfg(id)
	return allianceStrongholdMineRead.buildCfg[id]
end
function allianceStrongholdMineRead.getBuffByType(bType)
	local allianceStrongholdMineRead, ret
	local buffList = allianceStrongholdMineRead.buffCfg[bType].buff
	_UPVALUE2_ = nil
	;(nil)[1] = "buffType"
	;(nil)[2] = "buffVal"
	local blist = serviceFunctions.tableFormat(buffList, nil)
	local buffDesRead = include("buffDesRead")
	for k, v in ipairs(blist) do
		local val = buffDesRead.getTitleValueWithValue(v.buffType, v.buffVal)
		if v.buffType == gBuffEffect.INSTANT_BUILD_SPEED_BOOST then
			val = val .. "s"
		end
		allianceStrongholdMineRead = nil
		;(nil).des = buffDesRead.getTitleBase(v.buffType)
		;(nil).val = val
		;(nil).buffType = v.buffType
		table.insert(ret, nil)
	end
	return ret, blist
end
function allianceStrongholdMineRead.isInHoldArea(pos)
	local isIn = false
	for k, v in pairs(allianceStrongholdMineRead.strongholdBuildCfg) do
		_ENV = nil
		;(nil).x11 = v.x - 5
		;(nil).x12 = v.x + 4
		;(nil).y11 = v.y - 5
		local (nil).y12, area = v.y + 4, nil
		if pos.x >= area.x11 and pos.x <= area.x12 and pos.y >= area.y11 and pos.y <= area.y12 then
			isIn = true
			break
		end
	end
	return isIn
end
function allianceStrongholdMineRead.isNearHoldArea(pos)
	local rectUtil = include("rectUtil")
	local constantRead = include("constantRead")
	local mapSyncUtilClient = include("mapSyncUtilClient")
	local rect = rectUtil.getRectBySize(pos.x, pos.y, 2)
	local strongHoldGap = constantRead.getConstValue("ALIANCE_BUILD_STRONGHOLD_GAP")
	local strongHoldLevel = constantRead.getConstValue("ALIANCE_BUILD_STRONGHOLD_LEVEL")
	for k, v in pairs(allianceStrongholdMineRead.strongholdBuildCfg) do
		if strongHoldLevel <= v.level then
			local clientPos = mapSyncUtilClient.serverTOClientPos(cc.p(v.x, v.y))
			local strongholdRect = rectUtil.expRect(rectUtil.getRectBySize(clientPos.x, clientPos.y, 2), strongHoldGap)
			if rectUtil.isOverlap(rect, strongholdRect) then
				return true
			end
		end
	end
	return false
end
function allianceStrongholdMineRead.getHoldLeaderIcon(id)
	return allianceStrongholdMineRead.buildCfg[id].leader
end
function allianceStrongholdMineRead.getHoldMonsterName(id)
	return i18n(allianceStrongholdMineRead.buildCfg[id].name)
end
function allianceStrongholdMineRead.getHoldMonsterIcon(id)
	allianceStrongholdMineRead = nil
	;(nil)[1] = allianceStrongholdMineRead.buildCfg[id].bosstroops1
	;(nil)[2] = allianceStrongholdMineRead.buildCfg[id].bosstroops2
	;(nil)[3] = allianceStrongholdMineRead.buildCfg[id].bosstroops3
	return nil
end
function allianceStrongholdMineRead.getHoldMonsterKillNum(id)
	allianceStrongholdMineRead = nil
	;(nil)[1] = allianceStrongholdMineRead.strongholdBuildCfg[id].num1
	;(nil)[2] = allianceStrongholdMineRead.strongholdBuildCfg[id].num2
	;(nil)[3] = allianceStrongholdMineRead.strongholdBuildCfg[id].num3
	return nil
end
function allianceStrongholdMineRead.getHoldMonsterDetails(id)
	allianceStrongholdMineRead, allianceStrongholdMineRead, allianceStrongholdMineRead, allianceStrongholdMineRead, _UPVALUE4_ = nil, nil, nil, nil, nil
	;(nil)[1] = nil
	;(nil)[2] = nil
	;(nil)[3] = nil
	local (nil)[4], monsterDetail
	local buildCfg = allianceStrongholdMineRead.strongholdBuildCfg[id]
	for index = 1, 3 do
		_UPVALUE2_ = index
		index[1] = "id"
		index[2] = "num"
		local bosstroops = serviceFunctions.tableFormat(buildCfg["bosstroops" .. index], index)
		for index2, value in ipairs(bosstroops) do
			allianceStrongholdMineRead = nil
			;(nil).cfg = allianceStrongholdMineRead.armyCfg[value.id]
			;(nil).num = value.num
			table.insert(monsterDetail[index], nil)
		end
	end
	_UPVALUE2_ = 1
	;(1)[1] = "id"
	;(1)[2] = "num"
	local bosstroops = serviceFunctions.tableFormat(buildCfg.leader, 1)
	for index2, value in ipairs(bosstroops) do
		allianceStrongholdMineRead = "num"
		;("num").cfg = allianceStrongholdMineRead.armyCfg[value.id]
		;("num").num = value.num
		table.insert(monsterDetail[4], "num")
	end
	return monsterDetail
end
function allianceStrongholdMineRead.getShortestPosByType(pos, level)
	local constantRead = include("constantRead")
	local mapSyncUtilClient = include("mapSyncUtilClient")
	local retPos
	local strongHoldGap = constantRead.getConstValue("ALIANCE_BUILD_STRONGHOLD_GAP")
	local strongHoldLevel = constantRead.getConstValue("ALIANCE_BUILD_STRONGHOLD_LEVEL")
	local distance = 0
	for k, v in pairs(allianceStrongholdMineRead.strongholdBuildCfg) do
		if v.level == level then
			local clientPos = mapSyncUtilClient.serverTOClientPos(cc.p(v.x, v.y))
			local newDistance = cc.pDistanceSQ(pos, clientPos)
			if distance == 0 or distance > newDistance then
				distance = newDistance
				retPos = clientPos
			end
		end
	end
	return retPos
end
return allianceStrongholdMineRead
