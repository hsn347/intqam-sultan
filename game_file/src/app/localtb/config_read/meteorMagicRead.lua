local meteorMagicRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "meteoritesmagic"
;(nil)[2] = true
meteorMagicRead:defineValue("meteoritesmagic", nil)
_UPVALUE2_ = nil
;(nil)[1] = "meteoritesmagiclv"
;(nil)[2] = true
meteorMagicRead:defineValue("meteoritesmagiclv", nil)
_UPVALUE1_ = nil
;(nil)[1] = "meteoritesmagicdata"
meteorMagicRead:defineValue("meteoritesmagicdata", nil)
_UPVALUE2_ = nil
;(nil)[1] = "meteoritesmagicplan"
;(nil)[2] = true
meteorMagicRead:defineValue("meteoritesmagicplan", nil)
_UPVALUE1_ = nil
;(nil)[1] = "meteoritesmagicnebula"
meteorMagicRead:defineValue("meteoritesmagicTree", nil)
_UPVALUE1_ = nil
;(nil)[1] = "meteoritesmagicstrategy"
meteorMagicRead:defineValue("MeteoritesMagicStrategy", nil)
_UPVALUE1_ = nil
;(nil)[1] = "meteoritesmagicbuffdata"
meteorMagicRead:defineValue("buff", nil)
local createData = function(name)
	meteorMagicRead.buffTypeMap, meteorMagicRead, meteorMagicRead.meteoritesMaxLevels, meteorMagicRead, meteorMagicRead.meteoritesConfig, meteorMagicRead = nil, nil, nil, nil, nil, nil
	for k, v in pairs(meteorMagicRead.meteoritesmagic) do
		_UPVALUE4_ = nil
		;(nil)[1] = "buffType"
		;(nil)[2] = "type"
		;(nil)[3] = "value"
		;(nil)[4] = "isSelf"
		v.buff = serviceFunctions.tableFormat(v.buff, nil)
		meteorMagicRead.meteoritesConfig[v.id] = v
		if v.buffNum then
			_UPVALUE2_ = nil
			;(nil)[1] = "valueType"
			;(nil)[2] = "value"
			v.buffNum = serviceFunctions.tableFormat(v.buffNum, nil)
		else
			v.buffNum, meteorMagicRead = serviceFunctions.tableFormat(v.buffNum, nil), serviceFunctions.tableFormat(v.buffNum, nil)
		end
		if meteorMagicRead.meteoritesMaxLevels[v.idGroup] == nil or meteorMagicRead.meteoritesMaxLevels[v.idGroup] < v.id then
			meteorMagicRead.meteoritesMaxLevels[v.idGroup] = v.id
		end
		for k2, v2 in pairs(v.buff) do
			meteorMagicRead.buffTypeMap[v2.buffType] = v2.type
		end
	end
	return meteorMagicRead[name]
end
meteorMagicRead:defineValue("meteoritesConfig", createData)
meteorMagicRead:defineValue("meteoritesMaxLevels", createData)
meteorMagicRead:defineValue("buffTypeMap", createData)
function meteorMagicRead.getIdGroup(magicId)
	return math.floor(magicId / 100), magicId % 100
end
function meteorMagicRead.getMagicId(idGroup, lv)
	return idGroup * 100 + lv
end
function meteorMagicRead.getMagicInfo(idGroup)
	return meteorMagicRead.meteoritesmagicdata[tonumber(idGroup)]
end
function meteorMagicRead.getMagicPlans()
	return meteorMagicRead.meteoritesmagicplan
end
function meteorMagicRead.getIsUnlock(id, level)
	local activeData = meteorMagicRead.meteoritesmagicplan[id]
	if activeData and level >= activeData.activateLv then
		return true
	end
	return false
end
function meteorMagicRead.getMagicCfg(magicId)
	return meteorMagicRead.meteoritesConfig[tonumber(magicId)]
end
function meteorMagicRead.getMagicTrees()
	return meteorMagicRead.meteoritesmagicTree
end
function meteorMagicRead.getMagicTree(tType)
	for k, v in pairs(meteorMagicRead.meteoritesmagicTree) do
		if v.type == tonumber(tType) then
			return v
		end
	end
end
function meteorMagicRead.getCurLvExp(curExp)
	local isMax = false
	local lastLvCfg
	lastLvCfg = meteorMagicRead.meteoritesmagiclv[0]
	while lastLvCfg do
		if curExp >= lastLvCfg.needExp then
			curExp = curExp - lastLvCfg.needExp
		end
		lastLvCfg = meteorMagicRead.meteoritesmagiclv[lastLvCfg.lv + 1]
	end
	return curExp
end
function meteorMagicRead.getLvByExp(curExp)
	local isMax = false
	local curLvCfg, lastLvCfg
	curLvCfg = meteorMagicRead.meteoritesmagiclv[0]
	lastLvCfg = meteorMagicRead.meteoritesmagiclv[0]
	local maxLv = 0
	while lastLvCfg do
		if curExp >= lastLvCfg.needExp then
			curExp = curExp - lastLvCfg.needExp
			curLvCfg = meteorMagicRead.meteoritesmagiclv[lastLvCfg.lv + 1]
		end
		lastLvCfg = meteorMagicRead.meteoritesmagiclv[lastLvCfg.lv + 1]
		maxLv = lastLvCfg == nil and maxLv or lastLvCfg.lv
	end
	local isMax = curLvCfg == nil
	curLvCfg = curLvCfg == nil and meteorMagicRead.meteoritesmagiclv[maxLv] or curLvCfg
	return curLvCfg, curExp, isMax
end
function meteorMagicRead.getCurLvCfg(curLv)
	local isMax = false
	local curLvCfg = meteorMagicRead.meteoritesmagiclv[curLv + 1]
	if curLvCfg == nil then
		isMax = true
		for k, v in pairs(meteorMagicRead.meteoritesmagiclv) do
			if curLvCfg == nil or v.lv > curLvCfg.lv then
				curLvCfg = v
			end
		end
	end
	return curLvCfg, isMax
end
function meteorMagicRead.getName(idGroup)
	return meteorMagicRead.meteoritesmagicdata[tonumber(idGroup)].name
end
function meteorMagicRead.getIcon(idGroup)
	return meteorMagicRead.meteoritesmagicdata[tonumber(idGroup)].icon
end
function meteorMagicRead.getIconBg(idGroup)
	return meteorMagicRead.meteoritesmagicdata[tonumber(idGroup)].iconBg
end
function meteorMagicRead.getDes(magicId)
	local idGroup, lv = meteorMagicRead.getIdGroup(magicId)
	local str = meteorMagicRead.meteoritesmagicdata[tonumber(idGroup)].describe
	local buffNum = meteorMagicRead.getMagicCfg(magicId).buffNum
	local meteorMagicRead, strTable = magicId, magicId
	for i, v in ipairs(buffNum) do
		strTable["num" .. i] = v.valueType == 1 and "" .. v.value / 10 .. "%" or v.value
	end
	return i18n(str, strTable)
end
function meteorMagicRead.getMaxLvMagicId(idGroup)
	return meteorMagicRead.meteoritesMaxLevels[idGroup]
end
function meteorMagicRead.getStrategy()
	return meteorMagicRead.MeteoritesMagicStrategy
end
function meteorMagicRead.getBuffEffectType(buffType)
	return meteorMagicRead.buffTypeMap[buffType]
end
function meteorMagicRead.getTitleBase(eid, needData, noArgs)
	eid = tonumber(eid)
	if meteorMagicRead.buff[eid] == nil then
		eid = 1
	end
	local key = meteorMagicRead.buff[eid].title
	local args
	if noArgs then
		args, _ENV = nil, nil
		args.num = ""
		for i = 1, 5 do
			args["num" .. i] = ""
		end
	end
	if needData then
		return i18n(key, args), meteorMagicRead.buff[eid]
	else
		return i18n(key, args)
	end
end
function meteorMagicRead.getTitleValueWithValue(eid, value, noSign, reverse)
	eid = tonumber(eid)
	local buffDesRead = include("buffDesRead")
	local base, data = meteorMagicRead.getTitleBase(eid, true)
	if data.effectType == 1 then
		if reverse then
			value = "%" .. buffDesRead.addSign(value / 10, data.isIncrease, noSign, reverse)
		else
			value = buffDesRead.addSign(value / 10, data.isIncrease, noSign, reverse) .. "%"
		end
	elseif data.effectType == 2 then
		value = buffDesRead.addSign(value, data.isIncrease, noSign, reverse)
	else
		value = buffDesRead.addSign(value, data.isIncrease, noSign, reverse)
	end
	return value
end
function meteorMagicRead.getBuffOrder(eid)
	return meteorMagicRead.buff[eid].order or 0
end
return meteorMagicRead
