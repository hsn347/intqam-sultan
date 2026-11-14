_ENV = nil
;(nil).JINN_ONE = 1
gJinnType, (nil).JINN_TWO = nil, 2
local magicLampRead = include("aAReadClass").new()
magicLampRead.extraSkillSlotStartIndex = 10000000
_UPVALUE1_ = nil
;(nil)[1] = "jinn_show"
magicLampRead:defineValue("jinn_show", nil)
_UPVALUE1_ = nil
;(nil)[1] = "jinn_blessing_buff_sort"
magicLampRead:defineValue("jinn_blessing_buff_sort", nil)
_UPVALUE2_ = nil
;(nil)[1] = "jinn_break_through"
;(nil)[2] = true
magicLampRead:defineValue("jinn_break_through", nil)
_UPVALUE2_ = nil
;(nil)[1] = "jinn_strengthen"
;(nil)[2] = true
magicLampRead:defineValue("jinn_strengthen", nil)
_UPVALUE2_ = nil
;(nil)[1] = "jinn_class"
;(nil)[2] = true
magicLampRead:defineValue("jinn_class", nil)
_UPVALUE2_ = nil
;(nil)[1] = "jinn_blessing"
;(nil)[2] = true
magicLampRead:defineValue("jinn_blessing", nil)
_UPVALUE2_ = nil
;(nil)[1] = "jinn_galaxy"
;(nil)[2] = true
magicLampRead:defineValue("jinn_galaxy", nil)
magicLampRead:defineValue("showCfg", function()
	magicLampRead.showCfg, magicLampRead = nil, nil
	for i, v in ipairs(magicLampRead.jinn_show) do
		if magicLampRead.showCfg[v.JinnType] == nil then
			magicLampRead.showCfg[v.JinnType], magicLampRead = nil, nil
		end
		magicLampRead.showCfg[v.JinnType][v.Star] = v
	end
	return magicLampRead.showCfg
end)
magicLampRead:defineValue("starCfg", function()
	magicLampRead.starCfg, magicLampRead = nil, nil
	for i, v in ipairs(magicLampRead.jinn_break_through) do
		if magicLampRead.starCfg[v.JinnType] == nil then
			magicLampRead.starCfg[v.JinnType], magicLampRead = nil, nil
		end
		_UPVALUE4_ = nil
		;(nil)[1] = "buffType"
		;(nil)[2] = "type"
		;(nil)[3] = "value"
		;(nil)[4] = "add"
		v.buff = serviceFunctions.tableFormat(v.Attribute, nil)
		_UPVALUE3_ = nil
		;(nil)[1] = "needType"
		;(nil)[2] = "value1"
		;(nil)[3] = "value2"
		v.need = serviceFunctions.tableFormat(v.Need, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "num"
		v.cost = serviceFunctions.tableFormat(v.Cost, nil)
		magicLampRead.starCfg[v.JinnType][v.Star] = v
	end
	return magicLampRead.starCfg
end)
magicLampRead:defineValue("strengthenCfg", function()
	magicLampRead.strengthenCfg, magicLampRead = nil, nil
	for i, v in ipairs(magicLampRead.jinn_strengthen) do
		if magicLampRead.strengthenCfg[v.JinnType] == nil then
			magicLampRead.strengthenCfg[v.JinnType], magicLampRead = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "num"
		v.spxCost = serviceFunctions.tableFormat(v.SpxCost, nil)
		magicLampRead.strengthenCfg[v.JinnType][v.level] = v
	end
	return magicLampRead.strengthenCfg
end)
magicLampRead:defineValue("classCfg", function()
	magicLampRead.classCfg, magicLampRead = nil, nil
	for i, v in ipairs(magicLampRead.jinn_class) do
		if magicLampRead.classCfg[v.JinnType] == nil then
			magicLampRead.classCfg[v.JinnType], magicLampRead = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "num"
		v.resource = serviceFunctions.tableFormat(v.Resource, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "num"
		v.cost = serviceFunctions.tableFormat(v.Cost, nil)
		magicLampRead.classCfg[v.JinnType][v.Class] = v
	end
	return magicLampRead.classCfg
end)
local defineData = function(name)
	magicLampRead.blessMaxCfg, magicLampRead, magicLampRead.blessCfg, magicLampRead, magicLampRead.bigBlessCfg, magicLampRead = nil, nil, nil, nil, nil, nil
	local magicLampRead, nextBlessIDMap
	for i, v in pairs(magicLampRead.jinn_blessing) do
		_UPVALUE3_ = nil
		;(nil)[1] = "buffType"
		;(nil)[2] = "type"
		;(nil)[3] = "value"
		v.buff = serviceFunctions.tableFormat(v.Attribute, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "BlessID"
		;(nil)[2] = "lv"
		v.PreBlessID = serviceFunctions.tableFormat(v.PreBlessID, nil)
		for __, data in ipairs(v.PreBlessID) do
			if data.BlessID ~= v.BlessID then
				if not nextBlessIDMap[data.BlessID] then
					magicLampRead = nextBlessIDMap[data.BlessID]
				end
				nextBlessIDMap[data.BlessID] = nextBlessIDMap[data.BlessID]
				magicLampRead = nil
				;(nil).blessID = v.BlessID
				;(nil).needLv = data.lv
				table.insert(nextBlessIDMap[data.BlessID], nil)
			end
		end
		if v.PointType == 2 then
			if magicLampRead.bigBlessCfg[v.JinnType] == nil then
				magicLampRead.bigBlessCfg[v.JinnType], magicLampRead = ipairs(v.PreBlessID)
			end
			table.insert(magicLampRead.bigBlessCfg[v.JinnType], v)
		end
		if magicLampRead.blessCfg[v.JinnType] == nil then
			magicLampRead.blessCfg[v.JinnType], magicLampRead = v, v
		end
		if magicLampRead.blessCfg[v.JinnType][v.BlessID] == nil then
			magicLampRead.blessCfg[v.JinnType][v.BlessID], magicLampRead = v, v
		end
		magicLampRead.blessCfg[v.JinnType][v.BlessID][v.Level] = v
		if magicLampRead.blessMaxCfg[v.JinnType] == nil then
			magicLampRead.blessMaxCfg[v.JinnType], magicLampRead = v, v
		end
		magicLampRead = v.JinnType
		v.JinnType.BlessID = v.BlessID
		v.JinnType.MaxLv = v.MaxLv
		table.insert(magicLampRead.blessMaxCfg[v.JinnType], v.JinnType)
	end
	magicLampRead.nextBlessIDMap = nextBlessIDMap
	for i, v in pairs(magicLampRead.bigBlessCfg) do
		table.sort(v, function(a, b)
			return a.BlessID < b.BlessID
		end)
	end
	return magicLampRead[name]
end
magicLampRead:defineValue("bigBlessCfg", defineData)
magicLampRead:defineValue("blessCfg", defineData)
magicLampRead:defineValue("nextBlessIDMap", defineData)
magicLampRead:defineValue("blessMaxCfg", defineData)
magicLampRead:defineValue("buffSort", function()
	magicLampRead.buffSort, magicLampRead = nil, nil
	for i, v in ipairs(magicLampRead.jinn_blessing_buff_sort) do
		magicLampRead.buffSort[v.BuffType] = v.Sort
	end
	return magicLampRead.buffSort
end)
magicLampRead:defineValue("jinnGalaxyCfg", function()
	magicLampRead.jinnGalaxyCfg, magicLampRead = nil, nil
	for i, v in ipairs(magicLampRead.jinn_galaxy) do
		if magicLampRead.jinnGalaxyCfg[v.Jinn_type] == nil then
			magicLampRead.jinnGalaxyCfg[v.Jinn_type], magicLampRead = nil, nil
		end
		if not magicLampRead.jinnGalaxyCfg[v.Jinn_type][v.galaxy_card_slot] then
			magicLampRead = magicLampRead.jinnGalaxyCfg[v.Jinn_type][v.galaxy_card_slot]
		end
		magicLampRead.jinnGalaxyCfg[v.Jinn_type][v.galaxy_card_slot] = magicLampRead.jinnGalaxyCfg[v.Jinn_type][v.galaxy_card_slot]
		table.insert(magicLampRead.jinnGalaxyCfg[v.Jinn_type][v.galaxy_card_slot], v)
	end
	return magicLampRead.jinnGalaxyCfg
end)
function magicLampRead.getJinnCfg(jinnType, star)
	return magicLampRead.showCfg[jinnType][star]
end
function magicLampRead.getMaxStar(jinnType)
	return #magicLampRead.starCfg[jinnType]
end
function magicLampRead.getBreakThroughCfg(jinnType, star)
	return magicLampRead.starCfg[jinnType][star]
end
function magicLampRead.getStrengthenCfg(jinnType, level)
	if not level then
		return magicLampRead.strengthenCfg[jinnType]
	end
	return magicLampRead.strengthenCfg[jinnType][level]
end
function magicLampRead.getClassCfg(jinnType, class)
	return magicLampRead.classCfg[jinnType][class]
end
function magicLampRead.getMaxClass(jinnType, class)
	return #magicLampRead.classCfg[jinnType]
end
function magicLampRead.getMaxLv(jinnType)
	return #magicLampRead.strengthenCfg[jinnType]
end
function magicLampRead.getBlessCfg(ID)
	local blessCfg = magicLampRead.blessCfg
	return magicLampRead.jinn_blessing[ID]
end
function magicLampRead.getBlessUseID(BlessID, lv)
	return BlessID * 100 + lv
end
function magicLampRead.getBigBlessList(jinnType)
	return magicLampRead.bigBlessCfg[jinnType]
end
function magicLampRead.checkIsBigBless(jinnType, blessID)
	for i, v in ipairs(magicLampRead.getBigBlessList(jinnType)) do
		if v.BlessID == blessID then
			return true
		end
	end
	return false
end
function magicLampRead.getBlessCfgs(jinnType)
	return magicLampRead.blessCfg[jinnType]
end
function magicLampRead.getBlessMaxCfgs(jinnType)
	return magicLampRead.blessMaxCfg[jinnType]
end
function magicLampRead.getBuffSort(buffType)
	return magicLampRead.buffSort[buffType] or 0
end
function magicLampRead.getJinnName(jinnType, star)
	star = star or 0
	local cfg = magicLampRead.getJinnCfg(jinnType, star)
	return i18n(cfg.Name)
end
function magicLampRead.getJinnIcon(jinnType, star)
	star = star or 0
	local cfg = magicLampRead.getJinnCfg(jinnType, star)
	return cfg.Icon
end
function magicLampRead.getNextBlessIDList(BlessID)
	if not magicLampRead.nextBlessIDMap[BlessID] then
		magicLampRead = magicLampRead.nextBlessIDMap[BlessID]
	end
	return magicLampRead.nextBlessIDMap[BlessID]
end
function magicLampRead.getBlessLvToLvPointCost(BlessID, fromLv, toLv)
	local cost = 0
	for lv = fromLv, toLv + 1, -1 do
		local useID = magicLampRead.getBlessUseID(BlessID, lv)
		cost = cost + magicLampRead.getBlessPointCost(useID)
	end
	return cost
end
function magicLampRead.getBlessPointCost(useID)
	local cfg = magicLampRead.getBlessCfg(useID)
	return cfg and cfg.PointCost or 0
end
function magicLampRead.getJinnEffect(jinnType)
	local effects = magicLampRead.jinn_effect[jinnType] and magicLampRead.jinn_effect[jinnType] or magicLampRead.jinn_effect[1]
	return effects
end
function magicLampRead.getJinnGalaxyCfgs(jinnType)
	if not magicLampRead.jinnGalaxyCfg[jinnType] then
		magicLampRead = magicLampRead.jinnGalaxyCfg[jinnType]
	end
	return magicLampRead.jinnGalaxyCfg[jinnType]
end
magicLampRead:defineValue("jinn_effect", function()
	_UPVALUE0_, _UPVALUE0_, _UPVALUE0_ = nil, nil, nil
	;(nil)[0] = "Shendengzjm_01.usm"
	;(nil)[1] = "shendengdjL1_01.usm"
	;(nil)[2] = "shendengdjL2_01.usm"
	;(nil)[3] = "shendengdjL3_01.usm"
	;(nil)[4] = "shendengdjL4_01.usm"
	;(nil)[5] = "shendengdjL5_01.usm"
	_UPVALUE0_, (nil).effects, (nil)[6] = nil, nil, "shendengdjL5_01.usm"
	;(nil)[0] = "qysdbg.png"
	;(nil)[1] = "qysdbg1.png"
	;(nil)[2] = "qysdbg2.png"
	;(nil)[3] = "qysdbg3.png"
	;(nil)[4] = "qysdbg4.png"
	;(nil)[5] = "qysdbg5.png"
	_UPVALUE0_, (nil).effectsBg, (nil)[6] = nil, nil, "qysdbg5.png"
	;(nil)[0] = "shendengsj.usm"
	;(nil)[1] = "shendengsj.usm"
	;(nil)[2] = "shendengsj.usm"
	;(nil)[3] = "shendengsjL3.usm"
	;(nil)[4] = "shendengsjL4.usm"
	;(nil)[5] = "shendengsjL4.usm"
	_UPVALUE0_, (nil).sx_effects, (nil)[6] = nil, nil, "shendengsjL4.usm"
	;(nil)[0] = 30
	;(nil)[1] = 30
	;(nil)[2] = 30
	;(nil)[3] = 30
	;(nil)[4] = 30
	;(nil)[5] = 30
	_UPVALUE0_, (nil).sx_frame, (nil)[6] = nil, nil, 30
	;(nil)[0] = "G_SD_LV2_shengjie.usm"
	;(nil)[1] = "G_SD_LV2_shengjie.usm"
	;(nil)[2] = "G_SD_LV2_shengjie.usm"
	;(nil)[3] = "G_SD_LV3_shengjie.usm"
	;(nil)[4] = "G_SD_LV4_shengjie.usm"
	;(nil)[5] = "G_SD_LV4_shengjie.usm"
	_UPVALUE0_, (nil).sj_effects, (nil)[6] = nil, nil, "G_SD_LV4_shengjie.usm"
	;(nil)[0] = "G_Shendengqh_01.usm"
	;(nil)[1] = "G_Shendengqh_01.usm"
	;(nil)[2] = "G_Shendengqh_01.usm"
	;(nil)[3] = "G_Shendengqh_01.usm"
	;(nil)[4] = "G_SD_LV4_qianghua.usm"
	;(nil)[5] = "G_SD_LV4_qianghua.usm"
	_UPVALUE0_, _UPVALUE0_, (nil)[1], (nil).qh_effects, (nil)[6] = nil, nil, nil, nil, "G_SD_LV4_qianghua.usm"
	;(nil)[0] = "SD_yijiedjfire_01.usm"
	;(nil)[1] = "SD_erjiedjfire_01.usm"
	;(nil)[2] = "SD_sanjiedjfire_01.usm"
	;(nil)[3] = "SD_sijiedjfire_01.usm"
	;(nil)[4] = "SD_wujiedjfire_01.usm"
	;(nil)[5] = "SD_wujiedjfire_01.usm"
	;(nil)[6] = "SD_wujiedjfire_01.usm"
	;(nil)[7] = "SD_wujiedjfire_01.usm"
	_UPVALUE0_, (nil).effects, (nil)[8] = nil, nil, "SD_wujiedjfire_01.usm"
	;(nil)[0] = "SD_yijie_first.png"
	;(nil)[1] = "SD_erjie_first.png"
	;(nil)[2] = "SD_sanjiedjfire_01.png"
	;(nil)[3] = "SD_wujiedjfire_01.png"
	;(nil)[4] = "SD_wujiedjfire_01.png"
	;(nil)[5] = "SD_wujiedjfire_01.png"
	;(nil)[6] = "SD_wujiedjfire_01.png"
	;(nil)[7] = "SD_wujiedjfire_01.png"
	_UPVALUE0_, (nil).effectsBg, (nil)[8] = nil, nil, "SD_wujiedjfire_01.png"
	;(nil)[0] = "SD_shengjiefire_01.usm"
	;(nil)[1] = "SD_shengjiefire_01.usm"
	;(nil)[2] = "SD_shengjiefire_01.usm"
	;(nil)[3] = "SD_shengjiefire_01.usm"
	;(nil)[4] = "SD_shengjiefire_01.usm"
	;(nil)[5] = "SD_shengjiefire_01.usm"
	;(nil)[6] = "SD_shengjiefire_01.usm"
	;(nil)[7] = "SD_shengjiefire_01.usm"
	_UPVALUE0_, (nil).sx_effects, (nil)[8] = nil, nil, "SD_shengjiefire_01.usm"
	;(nil)[0] = 30
	;(nil)[1] = 30
	;(nil)[2] = 30
	;(nil)[3] = 30
	;(nil)[4] = 30
	;(nil)[5] = 30
	;(nil)[6] = 30
	;(nil)[7] = 30
	_UPVALUE0_, (nil).sx_frame, (nil)[8] = nil, nil, 30
	;(nil)[0] = "SD_shengjifire_01.usm"
	;(nil)[1] = "SD_shengjifire_01.usm"
	;(nil)[2] = "SD_shengjifire_01.usm"
	;(nil)[3] = "SD_shengjifire_01.usm"
	;(nil)[4] = "SD_shengjifire_01.usm"
	;(nil)[5] = "SD_shengjifire_01.usm"
	;(nil)[6] = "SD_shengjifire_01.usm"
	;(nil)[7] = "SD_shengjifire_01.usm"
	_UPVALUE0_, (nil).sj_effects, (nil)[8] = nil, nil, "SD_shengjifire_01.usm"
	;(nil)[0] = "SD_tupofire_01.usm"
	;(nil)[1] = "SD_tupofire_01.usm"
	;(nil)[2] = "SD_tupofire_01.usm"
	;(nil)[3] = "SD_tupofire_01.usm"
	;(nil)[4] = "SD_tupofire_01.usm"
	;(nil)[5] = "SD_tupofire_01.usm"
	;(nil)[6] = "SD_tupofire_01.usm"
	;(nil)[7] = "SD_tupofire_01.usm"
	;(nil)[2], (nil).qh_effects, (nil)[8] = nil, nil, "SD_tupofire_01.usm"
	return nil
end)
return magicLampRead
