local collegeDesRead = include("aAReadClass").new()
local technologyDef = include("technologyDef")
local isInited = false
local init = function()
	if isInited then
		return
	end
	collegeDesRead = nil
	;(nil)[1] = "technologytree"
	collegeDesRead:defineValue("tree", nil)
	collegeDesRead = nil
	;(nil)[1] = "technologydes"
	collegeDesRead:defineValue("data", nil)
	_ENV = nil
	;(nil)[1] = "technology"
	;(nil)[2] = true
	collegeDesRead:defineValue("tech", nil)
	collegeDesRead:defineValue("techConfig", function()
		local _ENV, ret
		for __, v in ipairs(collegeDesRead.tech) do
			if not ret[v.type] then
				_ENV = ret[v.type]
			end
			ret[v.type] = ret[v.type]
			ret[v.type][v.technologyID] = v
		end
		return ret
	end)
	function collegeDesRead()
		local _ENV, ret
		for __, v in ipairs(collegeDesRead.tech) do
			if not ret[v.type] then
				_ENV = ret[v.type]
			end
			ret[v.type] = ret[v.type]
			ret[v.type][v.technologyID] = v
		end
		return ret
	end
	;(function()
		local _ENV, ret
		for __, v in ipairs(collegeDesRead.tech) do
			if not ret[v.type] then
				_ENV = ret[v.type]
			end
			ret[v.type] = ret[v.type]
			ret[v.type][v.technologyID] = v
		end
		return ret
	end)[1] = "technology_special_des"
	collegeDesRead:defineValue("special", function()
		local _ENV, ret
		for __, v in ipairs(collegeDesRead.tech) do
			if not ret[v.type] then
				_ENV = ret[v.type]
			end
			ret[v.type] = ret[v.type]
			ret[v.type][v.technologyID] = v
		end
		return ret
	end)
	collegeDesRead:defineValue("technology_buff_des", function()
		local _ENV, ret
		local config = require_data("technology_buff_des").data
		for _, v in ipairs(config) do
			ret[v.techBuffType] = v
		end
		return ret
	end)
	collegeDesRead:defineValue("singleData", function()
		local _ENV, singleData
		if IsArClient then
			_ENV = IsArClient
			_ENV = nil
			;(nil).title = "common_text_045"
			;(nil).icon = "icon_technology_junshi.png"
			;(nil).color = cc.c3b(160, 250, 0)
			IsArClient[TECHNOLOGY_ATTR.military], (nil).base = nil, "frame_round_tech_04.png"
			_ENV = nil
			;(nil).title = "common_text_331"
			;(nil).icon = "icon_technology_chengshifazhan.png"
			;(nil).color = cc.c3b(216, 0, 0)
			IsArClient[TECHNOLOGY_ATTR.cityDevelop], (nil).base = nil, "frame_round_tech_02.png"
			_ENV = nil
			;(nil).title = "common_text_332"
			;(nil).icon = "icon_technology_chengfang.png"
			;(nil).color = cc.c3b(216, 0, 0)
			IsArClient[TECHNOLOGY_ATTR.anchor], (nil).base = nil, "frame_round_tech_03.png"
			_ENV = nil
			;(nil).title = "common_text_123"
			;(nil).icon = "icon_technology_ziyuan.png"
			;(nil).color = cc.c3b(190, 30, 30)
			IsArClient[TECHNOLOGY_ATTR.resource], (nil).base = nil, "frame_round_tech_01.png"
			_ENV = nil
			;(nil).title = "common_text_1962"
			;(nil).icon = "icon_technology_teshu.png"
			;(nil).color = cc.c3b(160, 250, 0)
			IsArClient[TECHNOLOGY_ATTR.special], (nil).base = nil, "frame_round_tech_05.png"
			_ENV = nil
			;(nil).title = "common_text_3772"
			;(nil).icon = "icon_technology_jingyingzhanshi.png"
			;(nil).color = cc.c3b(160, 250, 0)
			IsArClient[TECHNOLOGY_ATTR.soldier], (nil).base = nil, "frame_round_tech_06.png"
			_ENV = nil
			;(nil).title = "common_text_4055"
			;(nil).icon = "icon_technology_tongshuai.png"
			;(nil).color = cc.c3b(160, 250, 0)
			IsArClient[TECHNOLOGY_ATTR.leader], (nil).base = nil, "frame_round_tech_07.png"
			_ENV = nil
			;(nil).title = "common_name_01"
			;(nil).icon = "icon_technology_yingxiong.png"
			;(nil).color = cc.c3b(160, 250, 0)
			IsArClient[TECHNOLOGY_ATTR.hero], (nil).base = nil, "frame_round_tech_008.png"
			_ENV = nil
			;(nil).title = "common_name_02"
			;(nil).icon = "icon_technology_gaojijunshi.png"
			;(nil).color = cc.c3b(160, 250, 0)
			IsArClient[TECHNOLOGY_ATTR.advancedmilitary], (nil).base = nil, "frame_round_tech_04.png"
			_ENV = nil
			;(nil).title = "warSkill_name_01"
			;(nil).icon = "icon_science_hero.png"
			;(nil).color = cc.c3b(160, 250, 0)
			IsArClient[TECHNOLOGY_ATTR.wartechnology], (nil).base = nil, "frame_round_tech_008.png"
			_ENV = nil
			;(nil).title = "warSkill_name_02"
			;(nil).icon = "icon_science_hero.png"
			;(nil).color = cc.c3b(160, 250, 0)
			IsArClient[TECHNOLOGY_ATTR.warbattle], (nil).base = nil, "frame_round_tech_008.png"
			_ENV = nil
			;(nil).title = "warSkill_name_03"
			;(nil).icon = "icon_science_hero.png"
			;(nil).color = cc.c3b(160, 250, 0)
			IsArClient[TECHNOLOGY_ATTR.warmilitary], (nil).base = nil, "frame_round_tech_008.png"
			_ENV = nil
			;(nil).title = "warSkill_name_04"
			;(nil).icon = "icon_science_hero.png"
			;(nil).color = cc.c3b(160, 250, 0)
			IsArClient[TECHNOLOGY_ATTR.warcommand], (nil).base = nil, "frame_round_tech_008.png"
			_ENV = nil
			;(nil).title = "warSkill_name_05"
			;(nil).icon = "icon_science_hero.png"
			;(nil).color = cc.c3b(160, 250, 0)
			singleData, IsArClient[TECHNOLOGY_ATTR.warlight], (nil).base = IsArClient, nil, "frame_round_tech_008.png"
		else
			_ENV = IsArClient
			_ENV = nil
			;(nil).title = "common_text_045"
			;(nil).icon = "icon_technology_junshi.png"
			;(nil).color = cc.c3b(160, 250, 0)
			IsArClient[TECHNOLOGY_ATTR.military], (nil).base = nil, "frame_round_tech_04.png"
			_ENV = nil
			;(nil).title = "common_text_331"
			;(nil).icon = "icon_technology_chengshifazhan.png"
			;(nil).color = cc.c3b(216, 0, 0)
			IsArClient[TECHNOLOGY_ATTR.cityDevelop], (nil).base = nil, "frame_round_tech_02.png"
			_ENV = nil
			;(nil).title = "common_text_332"
			;(nil).icon = "icon_technology_chengfang.png"
			;(nil).color = cc.c3b(216, 0, 0)
			IsArClient[TECHNOLOGY_ATTR.anchor], (nil).base = nil, "frame_round_tech_03.png"
			_ENV = nil
			;(nil).title = "common_text_123"
			;(nil).icon = "icon_technology_ziyuan.png"
			;(nil).color = cc.c3b(190, 30, 30)
			IsArClient[TECHNOLOGY_ATTR.resource], (nil).base = nil, "frame_round_tech_01.png"
			_ENV = nil
			;(nil).title = "common_text_1962"
			;(nil).icon = "icon_technology_teshu.png"
			;(nil).color = cc.c3b(160, 250, 0)
			IsArClient[TECHNOLOGY_ATTR.special], (nil).base = nil, "frame_round_tech_05.png"
			_ENV = nil
			;(nil).title = "common_text_3772"
			;(nil).icon = "icon_technology_jingyingzhanshi.png"
			;(nil).color = cc.c3b(160, 250, 0)
			IsArClient[TECHNOLOGY_ATTR.soldier], (nil).base = nil, "frame_round_tech_06.png"
			_ENV = nil
			;(nil).title = "common_text_4055"
			;(nil).icon = "icon_technology_tongshuai.png"
			;(nil).color = cc.c3b(160, 250, 0)
			IsArClient[TECHNOLOGY_ATTR.leader], (nil).base = nil, "frame_round_tech_07.png"
			_ENV = nil
			;(nil).title = "common_name_01"
			;(nil).icon = "icon_technology_yingxiong.png"
			;(nil).color = cc.c3b(160, 250, 0)
			IsArClient[TECHNOLOGY_ATTR.hero], (nil).base = nil, "frame_round_tech_008.png"
			_ENV = nil
			;(nil).title = "warSkill_name_01"
			;(nil).icon = "icon_science_hero.png"
			;(nil).color = cc.c3b(160, 250, 0)
			IsArClient[TECHNOLOGY_ATTR.wartechnology], (nil).base = nil, "frame_round_tech_008.png"
			_ENV = nil
			;(nil).title = "warSkill_name_02"
			;(nil).icon = "icon_science_hero.png"
			;(nil).color = cc.c3b(160, 250, 0)
			IsArClient[TECHNOLOGY_ATTR.warbattle], (nil).base = nil, "frame_round_tech_008.png"
			_ENV = nil
			;(nil).title = "warSkill_name_04"
			;(nil).icon = "icon_science_hero.png"
			;(nil).color = cc.c3b(160, 250, 0)
			singleData, IsArClient[TECHNOLOGY_ATTR.warcommand], (nil).base = IsArClient, nil, "frame_round_tech_008.png"
		end
		return singleData
	end)
	collegeDesRead:defineValue("singleData2", function()
		_ENV = nil
		_ENV = nil
		;(nil).title = "warSkill_name_01"
		;(nil).icon = "icon_science_hero.png"
		;(nil).color = cc.c3b(160, 250, 0)
		;(nil)[TECHNOLOGY_ATTR.wartechnology], (nil).base = nil, "frame_round_tech_008.png"
		_ENV = nil
		;(nil).title = "warSkill_name_02"
		;(nil).icon = "icon_science_hero.png"
		;(nil).color = cc.c3b(160, 250, 0)
		;(nil)[TECHNOLOGY_ATTR.warbattle], (nil).base = nil, "frame_round_tech_008.png"
		_ENV = nil
		;(nil).title = "warSkill_name_03"
		;(nil).icon = "icon_science_hero.png"
		;(nil).color = cc.c3b(160, 250, 0)
		;(nil)[TECHNOLOGY_ATTR.warmilitary], (nil).base = nil, "frame_round_tech_008.png"
		_ENV = nil
		;(nil).title = "warSkill_name_04"
		;(nil).icon = "icon_science_hero.png"
		;(nil).color = cc.c3b(160, 250, 0)
		;(nil)[TECHNOLOGY_ATTR.warcommand], (nil).base = nil, "frame_round_tech_008.png"
		_ENV = nil
		;(nil).title = "warSkill_name_05"
		;(nil).icon = "icon_science_hero.png"
		;(nil).color = cc.c3b(160, 250, 0)
		;(nil)[TECHNOLOGY_ATTR.warlight], (nil).base = nil, "frame_round_tech_008.png"
		local singleData2
		return singleData2
	end)
	collegeDesRead:defineValue("IDRefColor", function()
		_UPVALUE15_, _UPVALUE0_ = nil, nil
		_UPVALUE16_, (nil).red, (nil)[1] = nil, nil, 6
		_UPVALUE16_, (nil).red, (nil)[2] = nil, nil, 8
		_UPVALUE16_, (nil).red, (nil)[3] = nil, nil, 11
		_UPVALUE16_, (nil).red, (nil)[4] = nil, nil, 14
		_UPVALUE16_, (nil).red, (nil)[5] = nil, nil, 18
		_UPVALUE16_, (nil).red, (nil)[6] = nil, nil, 21
		_UPVALUE16_, (nil).red, (nil)[7] = nil, nil, 22
		_UPVALUE16_, (nil).red, (nil)[8] = nil, nil, 24
		_UPVALUE16_, (nil).red, (nil)[9] = nil, nil, 26
		_UPVALUE16_, (nil).red, (nil)[10] = nil, nil, 27
		_UPVALUE16_, (nil).red, (nil)[11] = nil, nil, 29
		_UPVALUE16_, (nil).red, (nil)[12] = nil, nil, 32
		_UPVALUE16_, (nil).red, (nil)[13] = nil, nil, 42
		_UPVALUE16_, (nil).red, (nil)[14] = nil, nil, 52
		_UPVALUE16_, (nil).red, (nil)[15] = nil, nil, 55
		_UPVALUE16_, (nil).yellow, (nil)[1] = nil, nil, 2
		_UPVALUE16_, (nil).yellow, (nil)[2] = nil, nil, 7
		_UPVALUE16_, (nil).yellow, (nil)[3] = nil, nil, 9
		_UPVALUE16_, (nil).yellow, (nil)[4] = nil, nil, 13
		_UPVALUE16_, (nil).yellow, (nil)[5] = nil, nil, 17
		_UPVALUE16_, (nil).yellow, (nil)[6] = nil, nil, 23
		_UPVALUE16_, (nil).yellow, (nil)[7] = nil, nil, 25
		_UPVALUE16_, (nil).yellow, (nil)[8] = nil, nil, 28
		_UPVALUE16_, (nil).yellow, (nil)[9] = nil, nil, 30
		_UPVALUE16_, (nil).yellow, (nil)[10] = nil, nil, 33
		_UPVALUE16_, (nil).yellow, (nil)[11] = nil, nil, 34
		_UPVALUE16_, (nil).yellow, (nil)[12] = nil, nil, 37
		_UPVALUE16_, (nil).yellow, (nil)[13] = nil, nil, 43
		_UPVALUE16_, (nil).yellow, (nil)[14] = nil, nil, 48
		_UPVALUE16_, (nil).yellow, (nil)[15] = nil, nil, 53
		_UPVALUE16_, (nil).yellow, (nil)[16] = nil, nil, 57
		_UPVALUE5_, (nil).blue, (nil)[1] = nil, nil, 1
		_UPVALUE5_, (nil).blue, (nil)[2] = nil, nil, 5
		_UPVALUE5_, (nil).blue, (nil)[3] = nil, nil, 10
		_UPVALUE5_, (nil).blue, (nil)[4] = nil, nil, 12
		_UPVALUE5_, (nil).blue, (nil)[5] = nil, nil, 15
		_UPVALUE5_, (nil).blue, (nil)[6] = nil, nil, 16
		_UPVALUE5_, (nil).blue, (nil)[7] = nil, nil, 20
		_UPVALUE5_, (nil).blue, (nil)[8] = nil, nil, 31
		_UPVALUE5_, (nil).blue, (nil)[9] = nil, nil, 35
		_UPVALUE5_, (nil).blue, (nil)[10] = nil, nil, 38
		_UPVALUE5_, (nil).blue, (nil)[11] = nil, nil, 40
		_UPVALUE5_, (nil).blue, (nil)[12] = nil, nil, 44
		_UPVALUE5_, (nil).blue, (nil)[13] = nil, nil, 46
		_UPVALUE5_, (nil).blue, (nil)[14] = nil, nil, 47
		_UPVALUE5_, (nil).blue, (nil)[15] = nil, nil, 53
		_UPVALUE5_, (nil).blue, (nil)[16] = nil, nil, 56
		_UPVALUE6_, (nil).green, (nil)[1] = nil, nil, 19
		_UPVALUE6_, (nil).green, (nil)[2] = nil, nil, 36
		_UPVALUE6_, (nil).green, (nil)[3] = nil, nil, 39
		_UPVALUE6_, (nil).green, (nil)[4] = nil, nil, 41
		_UPVALUE6_, (nil).green, (nil)[5] = nil, nil, 45
		;(nil).purple, (nil)[1] = nil, 3
		;(nil).purple, (nil)[2] = nil, 4
		;(nil).purple, (nil)[3] = nil, 19
		;(nil).purple, (nil)[4] = nil, 49
		;(nil).purple, (nil)[5] = nil, 50
		;(nil).purple, (nil)[6] = nil, 51
		local IDRefColor
		return IDRefColor
	end)
end
init()
function collegeDesRead.getTypeTitleIcon(techType)
	local cfg = collegeDesRead.singleData[techType]
	return cfg
end
function collegeDesRead.getWarTypeTitleIcon(techType)
	local cfg = collegeDesRead.singleData2[techType]
	return cfg
end
function collegeDesRead.getTechTypeBuild(techType)
	return collegeDesRead.tree[techType].technologybuild
end
function collegeDesRead.getTechTypeStarBuild(techType)
	return collegeDesRead.tree[techType].starbuild
end
function collegeDesRead.getTechTypeName(techType)
	return collegeDesRead.tree[techType].technologyname
end
function collegeDesRead.getTechTypeIcon(techType)
	return collegeDesRead.tree[techType].icon
end
function collegeDesRead.getFight(tid, lv)
	tid = tonumber(string.format("%s%.2d", tid, lv))
	local fighting = 0
	local nebulaWarUtil = include("nebulaWarUtil")
	local group = nebulaWarUtil.getRegionGroup()
	local cfg = collegeDesRead.techConfig[group][tid]
	if cfg then
		fighting = cfg.fighting
	end
	return fighting
end
function collegeDesRead.getTechCfgByBuffType(buffType)
	local _ENV, ret
	for _, v in ipairs(collegeDesRead.tech) do
		if v.buffType == buffType then
			table.insert(ret, v)
		end
	end
	return ret
end
function collegeDesRead.getTechCfg(technologyID, lv, isFromShow)
	local techID = isFromShow and tonumber(string.format("%d%.2d", technologyID, lv or 1)) or technologyID
	local _ENV, preTechID = string.format("%d%.2d", technologyID, lv or 1)
	for _, v in ipairs(collegeDesRead.tech) do
		if v.technologyID == techID then
			_UPVALUE2_ = string.format("%d%.2d", technologyID, lv or 1)
			string.format("%d%.2d", technologyID, lv or 1)[1] = "tid"
			string.format("%d%.2d", technologyID, lv or 1)[2] = "level"
			local technologyPrepose = serviceFunctions.tableFormat(v.technologyPrepose, string.format("%d%.2d", technologyID, lv or 1))
			for _, m in ipairs(technologyPrepose) do
				if m.tid > 0 and m.level > 0 then
					table.insert(preTechID, m.tid)
				end
			end
		end
	end
	return preTechID
end
function collegeDesRead.getTechBuffCfg(tid, lv)
	local _ENV, ret
	local technologyID = tonumber(string.format("%d%.2d", tid, lv))
	for _, v in ipairs(collegeDesRead.tech) do
		if v.technologyID == technologyID and v.technologyLevel == lv then
			ret.buffType = v.buffType
			ret.buffNumType = v.buffNumType
			ret.powerNum = v.powerNum
			ret.battle = v.battle
			break
		end
	end
	return ret
end
function collegeDesRead.getTechGroupCfg(tid)
	local _ENV, ret
	for _, v in ipairs(collegeDesRead.tech) do
		local technologyID = math.floor(v.technologyID / 100)
		if tid == technologyID then
			table.insert(ret, v)
		end
	end
	return ret
end
function collegeDesRead.getName(tid)
	tid = tonumber(tid)
	local name = collegeDesRead.data[tid] and i18n(collegeDesRead.data[tid].name) or nil
	if not name then
		local manorTechRead = include("manorTechRead")
		name = manorTechRead.getName(tid)
	end
	return name
end
function collegeDesRead.getDes(tid)
	tid = tonumber(tid)
	return collegeDesRead.data[tid] and i18n(collegeDesRead.data[tid].describe) or nil
end
function collegeDesRead.getBg(tid, fromMemory)
	tid = tonumber(tid)
	if fromMemory then
		return collegeDesRead.data[tid] and "#" .. collegeDesRead.data[tid].base or nil
	end
	return collegeDesRead.data[tid] and collegeDesRead.data[tid].base or nil
end
function collegeDesRead.getIcon(tid, fromMemory)
	tid = tonumber(tid)
	local img = collegeDesRead.data[tid].icon
	if fromMemory then
		return collegeDesRead.data[tid] and "#" .. img or nil
	end
	return collegeDesRead.data[tid] and img or nil
end
function collegeDesRead.isSpecialShow(tid)
	tid = tonumber(tid)
	return collegeDesRead.data[tid] and collegeDesRead.data[tid].specialdes == 1 or false
end
function collegeDesRead.getSpecialDes(tid, lv)
	local id = tonumber(string.format("%d%.2d", tid, lv))
	return collegeDesRead.special[id]
end
function collegeDesRead.getTree(key)
	return collegeDesRead.tree[key].tree
end
function collegeDesRead.getType(tid)
	tid = tostring(tid)
	for k, v in pairs(TECHNOLOGY_ATTR) do
		for i, id in ipairs(collegeDesRead.tree[v].tree) do
			if tid == id then
				return v
			end
		end
	end
	return TECHNOLOGY_ATTR.resource
end
function collegeDesRead.getColorByID(colorID)
	for colorName, list in pairs(collegeDesRead.IDRefColor) do
		for _, techId in ipairs(list) do
			if colorID == techId then
				return colorName
			end
		end
	end
end
function collegeDesRead.getTechBuffDes(techBuffType)
	return collegeDesRead.technology_buff_des[techBuffType] and i18n(collegeDesRead.technology_buff_des[techBuffType].buffDes)
end
function collegeDesRead.getTechBuffValue(techBuffType, value)
	local buffDesConfig = collegeDesRead.technology_buff_des[techBuffType]
	if buffDesConfig then
		local val = buffDesConfig.buffNumType == 1 and value / 10 .. "%" or value
		return val
	end
	return value
end
function collegeDesRead.getTechBuffSortIdx(techBuffType)
	local buffDesConfig = collegeDesRead.technology_buff_des[techBuffType]
	if buffDesConfig then
		return buffDesConfig.index
	end
	return 0
end
return collegeDesRead
