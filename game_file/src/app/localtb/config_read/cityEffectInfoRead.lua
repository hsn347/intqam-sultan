local cityEffectInfoRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	cityEffectInfoRead = nil
	;(nil)[1] = "cityeffectinfo"
	cityEffectInfoRead:defineValue("cityeffectinfo", nil)
	cityEffectInfoRead = nil
	;(nil)[1] = "conquestwar_buff_des"
	cityEffectInfoRead:defineValue("kingBattleEffectInfo", nil)
	local createData = function(name)
		cityEffectInfoRead.cityLegendMTable, cityEffectInfoRead, cityEffectInfoRead.cityEffectNewPlayer, cityEffectInfoRead, cityEffectInfoRead.cityEffectTable, cityEffectInfoRead = nil, nil, nil, nil, nil, nil
		for _, v in ipairs(cityEffectInfoRead.cityeffectinfo) do
			if v.newplayer == 0 then
				cityEffectInfoRead.cityEffectTable[v.effectType] = v
			end
			if v.newplayer == 1 then
				cityEffectInfoRead.cityEffectNewPlayer[v.effectType] = v
			end
			if v.newplayer == 2 then
				cityEffectInfoRead.cityLegendMTable[v.buffId] = v
			end
		end
		if name == "cityEffectTable" then
			return cityEffectInfoRead.cityEffectTable
		elseif name == "cityEffectNewPlayer" then
			return cityEffectInfoRead.cityEffectNewPlayer
		elseif name == "cityLegendMTable" then
			return cityEffectInfoRead.cityLegendMTable
		end
	end
	cityEffectInfoRead:defineValue("cityEffectTable", createData)
	cityEffectInfoRead:defineValue("cityEffectNewPlayer", createData)
	cityEffectInfoRead:defineValue("cityLegendMTable", createData)
end
init()
function cityEffectInfoRead.getList()
	local _ENV, buffList
	for _, v in ipairs(cityEffectInfoRead.cityeffectinfo) do
		if v.show == 1 and v.newplayer == 0 then
			table.insert(buffList, v.effectType)
		end
	end
	return buffList
end
function cityEffectInfoRead.getName(bid, isNewPlayer, buffID)
	bid = tonumber(bid)
	if isNewPlayer == 1 then
		return i18n(cityEffectInfoRead.cityEffectNewPlayer[bid].name)
	end
	if isNewPlayer == 2 then
		return i18n(cityEffectInfoRead.cityLegendMTable[buffID].name)
	end
	return i18n(cityEffectInfoRead.cityEffectTable[bid].name)
end
function cityEffectInfoRead.getDes(bid, isNewPlayer, buffID)
	bid = tonumber(bid)
	if isNewPlayer == 1 then
		return i18n(cityEffectInfoRead.cityEffectNewPlayer[bid].describe)
	end
	if isNewPlayer == 2 then
		return i18n(cityEffectInfoRead.cityLegendMTable[buffID].describe)
	end
	return i18n(cityEffectInfoRead.cityEffectTable[bid].describe)
end
function cityEffectInfoRead.getTip(bid, isNewPlayer, buffID)
	bid = tonumber(bid)
	if isNewPlayer == 1 then
		return i18n(cityEffectInfoRead.cityEffectNewPlayer[bid].tip)
	end
	if isNewPlayer == 2 then
		return string.len(cityEffectInfoRead.cityLegendMTable[buffID].tip) > 0 and i18n(cityEffectInfoRead.cityLegendMTable[buffID].tip) or cityEffectInfoRead.cityLegendMTable[buffID].tip
	end
	return i18n(cityEffectInfoRead.cityEffectTable[bid].tip)
end
function cityEffectInfoRead.getClashType(bid, isNewPlayer, buffID)
	bid = tonumber(bid)
	if isNewPlayer == 1 then
		return cityEffectInfoRead.cityEffectNewPlayer[bid].clashType
	end
	if isNewPlayer == 2 then
		return cityEffectInfoRead.cityLegendMTable[buffID].clashType
	end
	return cityEffectInfoRead.cityEffectTable[bid].clashType
end
function cityEffectInfoRead.getIcon(bid, isNewPlayer, buffID)
	bid = tonumber(bid)
	if isNewPlayer == 1 then
		return cityEffectInfoRead.cityEffectNewPlayer[bid].icon
	end
	if isNewPlayer == 2 then
		return cityEffectInfoRead.cityLegendMTable[buffID].icon
	end
	return cityEffectInfoRead.cityEffectTable[bid].icon
end
function cityEffectInfoRead.getQuaitly(bid, isNewPlayer, buffID)
	bid = tonumber(bid)
	if isNewPlayer == 1 then
		return cityEffectInfoRead.cityEffectNewPlayer[bid].itemquality
	end
	if isNewPlayer == 2 then
		return cityEffectInfoRead.cityLegendMTable[buffID].itemquality
	end
	return cityEffectInfoRead.cityEffectTable[bid].itemquality
end
function cityEffectInfoRead.getKingBattleInfoInfo()
	return cityEffectInfoRead.kingBattleEffectInfo
end
return cityEffectInfoRead
