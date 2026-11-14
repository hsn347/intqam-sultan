local magicLampSkillRead = include("aAReadClass").new()
_ENV = "aAReadClass"
;("aAReadClass").SKILLTYPE = 1
gJinnSkillNeedSkillType, ("aAReadClass").QUALITY = "aAReadClass", 2
_UPVALUE2_ = nil
;(nil)[1] = "jinn_skill"
;(nil)[2] = true
magicLampSkillRead:defineValue("jinn_skill", nil)
magicLampSkillRead:defineValue("skillConfig", function()
	magicLampSkillRead.skillConfig, magicLampSkillRead = nil, nil
	for i, v in ipairs(magicLampSkillRead.jinn_skill) do
		magicLampSkillRead.skillConfig[v.type] = v
	end
	return magicLampSkillRead.skillConfig
end)
function magicLampSkillRead.getSkillQuality(skillType)
	local cfg = magicLampSkillRead.skillConfig[skillType]
	return cfg.quality
end
function magicLampSkillRead.getSkillLvGroup(skillType)
	local cfg = magicLampSkillRead.skillConfig[skillType]
	return cfg.lvGroup
end
function magicLampSkillRead.getSkillStageGroup(skillType)
	local cfg = magicLampSkillRead.skillConfig[skillType]
	return cfg.stageGroup
end
function magicLampSkillRead.getSkillTypeByItemID(itemID)
	for i, v in ipairs(magicLampSkillRead.jinn_skill) do
		if v.compound[1] == itemID then
			return v.type, v.compound[2]
		end
	end
end
function magicLampSkillRead.getSkillCompound(skillType)
	local cfg = magicLampSkillRead.skillConfig[skillType]
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	return serviceFunctions.tableFormat(cfg.compound, nil)
end
function magicLampSkillRead.getSkillSkillGroup(skillType)
	local cfg = magicLampSkillRead.skillConfig[skillType]
	return cfg.skillGroup
end
function magicLampSkillRead.getFirstBuffClassLv(skillGroup)
	local firstClassLv
	for i = 1, #skillGroup do
		if skillGroup[i] ~= 0 then
			firstClassLv = i - 1
			break
		end
	end
	return firstClassLv
end
function magicLampSkillRead.getBuffCount(skillGroup)
	local count = 0
	for i = 1, #skillGroup do
		if skillGroup[i] ~= 0 then
			count = count + 1
		end
	end
	return count
end
magicLampSkillRead:defineValue("skillTypeList", function()
	local _ENV, ret
	for i, v in ipairs(magicLampSkillRead.jinn_skill) do
		if v.show == 1 then
			if not ret[v.quality] then
				_ENV = ret[v.quality]
			end
			ret[v.quality] = ret[v.quality]
			table.insert(ret[v.quality], v.type)
		end
	end
	magicLampSkillRead.skillTypeList = ret
	return ret
end)
magicLampSkillRead:defineValue("skillTypeMap", function()
	local _ENV, ret
	for i, v in ipairs(magicLampSkillRead.jinn_skill) do
		ret[v.type] = v
	end
	return ret
end)
function magicLampSkillRead.getSkillTypeList(...)
	return magicLampSkillRead.skillTypeList
end
function magicLampSkillRead.getSkillTypeCfg(skillType)
	return magicLampSkillRead.skillTypeMap[skillType]
end
function _UPVALUE1_()
	local _ENV, ret
	for i, v in ipairs(magicLampSkillRead.jinn_skill) do
		ret[v.type] = v
	end
	return ret
end
;(function()
	local _ENV, ret
	for i, v in ipairs(magicLampSkillRead.jinn_skill) do
		ret[v.type] = v
	end
	return ret
end)[1] = "jinn_skill_des"
magicLampSkillRead:defineValue("jinn_skill_des", function()
	local _ENV, ret
	for i, v in ipairs(magicLampSkillRead.jinn_skill) do
		ret[v.type] = v
	end
	return ret
end)
magicLampSkillRead:defineValue("skillDesConfig", function()
	magicLampSkillRead.skillDesConfig, magicLampSkillRead = nil, nil
	for i, v in ipairs(magicLampSkillRead.jinn_skill_des) do
		magicLampSkillRead.skillDesConfig[v.type] = v
	end
	return magicLampSkillRead.skillDesConfig
end)
function magicLampSkillRead.getSkillName(skillType)
	local cfg = magicLampSkillRead.skillDesConfig[skillType]
	return i18n(cfg.name)
end
function magicLampSkillRead.getSkillIcon(skillType)
	local cfg = magicLampSkillRead.skillDesConfig[skillType]
	return cfg.image
end
function magicLampSkillRead.getSkillClassify(skillType)
	local cfg = magicLampSkillRead.skillDesConfig[skillType]
	return cfg.classify
end
function magicLampSkillRead.checkSkillIsMaterial(skillType)
	local cfg = magicLampSkillRead.skillDesConfig[skillType]
	return cfg.material == 1
end
function _UPVALUE2_()
	magicLampSkillRead.skillDesConfig, magicLampSkillRead = nil, nil
	for i, v in ipairs(magicLampSkillRead.jinn_skill_des) do
		magicLampSkillRead.skillDesConfig[v.type] = v
	end
	return magicLampSkillRead.skillDesConfig
end
;(function()
	magicLampSkillRead.skillDesConfig, magicLampSkillRead = nil, nil
	for i, v in ipairs(magicLampSkillRead.jinn_skill_des) do
		magicLampSkillRead.skillDesConfig[v.type] = v
	end
	return magicLampSkillRead.skillDesConfig
end)[1] = "jinn_skill_lv"
;(function()
	magicLampSkillRead.skillDesConfig, magicLampSkillRead = nil, nil
	for i, v in ipairs(magicLampSkillRead.jinn_skill_des) do
		magicLampSkillRead.skillDesConfig[v.type] = v
	end
	return magicLampSkillRead.skillDesConfig
end)[2] = true
magicLampSkillRead:defineValue("jinn_skill_lv", function()
	magicLampSkillRead.skillDesConfig, magicLampSkillRead = nil, nil
	for i, v in ipairs(magicLampSkillRead.jinn_skill_des) do
		magicLampSkillRead.skillDesConfig[v.type] = v
	end
	return magicLampSkillRead.skillDesConfig
end)
magicLampSkillRead:defineValue("skillLvConfig", function()
	local _ENV, ret
	for i, v in ipairs(magicLampSkillRead.jinn_skill_lv) do
		if not ret[v.lvGroup] then
			_ENV = ret[v.lvGroup]
		end
		ret[v.lvGroup] = ret[v.lvGroup]
		ret[v.lvGroup][v.lv] = v
	end
	magicLampSkillRead.skillLvConfig = ret
	return ret
end)
function magicLampSkillRead.getUpgradeLvNeedItem(group, lv)
	local cfg = magicLampSkillRead.skillLvConfig[group][lv]
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	return serviceFunctions.tableFormat(cfg.exp, nil)
end
function magicLampSkillRead.getSkillLvBuff(group, lv)
	local cfg = magicLampSkillRead.skillLvConfig[group][lv]
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	return serviceFunctions.tableFormat(cfg.buff, nil)
end
function magicLampSkillRead.getSkillLvBuffMap(group, lv)
	local cfg = magicLampSkillRead.skillLvConfig[group][lv]
	return serviceFunctions.tableFormatToMap(cfg.buff)
end
function magicLampSkillRead.getSkillLvTotalBuff(group, lv)
	local magicLampSkillRead, ret
	local magicLampSkillRead, temp
	for i = 1, lv do
		local buffs = magicLampSkillRead.getSkillLvBuff(group, i)
		for __, v in ipairs(buffs) do
			serviceFunctions.addValueToArray(ret, temp, v.id, v.count)
		end
	end
	return ret
end
function magicLampSkillRead.getSkillUpgradeLvBuffList(buffList, nextMap)
	local ret = clone(buffList)
	local _ENV, buffMap = buffList, buffList
	for i, v in ipairs(buffList) do
		buffMap[v.id] = i
	end
	for buffId, value in pairs(nextMap) do
		if not buffMap[buffId] then
			_ENV = nil
			;(nil).id = buffId
			;(nil).count = 0
			;(nil).addCount = value
			table.insert(ret, nil)
		else
			local index = buffMap[buffId]
			ret[index].addCount = value
		end
	end
	return ret
end
function magicLampSkillRead.getSkillLvMax(skillType)
	local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
	local nebulaMileStoneLimit = nebulaMileStoneCtrl:getPlusByUnlockTypeEx(gNebulaMileStoneUnlockType.UP_JINN_SKILL_LV)
	local group = magicLampSkillRead.getSkillLvGroup(skillType)
	local lvMax1 = table.nums(magicLampSkillRead.skillLvConfig[group])
	local cfg = magicLampSkillRead.skillConfig[skillType]
	if nebulaMileStoneLimit ~= 0 then
		return math.min(nebulaMileStoneLimit, lvMax1)
	else
		local nebulaWarUtil = include("nebulaWarUtil")
		local group = nebulaWarUtil.getRegionGroup()
		local lvMax2 = cfg.lvMax[group]
		return math.min(lvMax1, lvMax2)
	end
end
function _UPVALUE2_()
	local _ENV, ret
	for i, v in ipairs(magicLampSkillRead.jinn_skill_lv) do
		if not ret[v.lvGroup] then
			_ENV = ret[v.lvGroup]
		end
		ret[v.lvGroup] = ret[v.lvGroup]
		ret[v.lvGroup][v.lv] = v
	end
	magicLampSkillRead.skillLvConfig = ret
	return ret
end
;(function()
	local _ENV, ret
	for i, v in ipairs(magicLampSkillRead.jinn_skill_lv) do
		if not ret[v.lvGroup] then
			_ENV = ret[v.lvGroup]
		end
		ret[v.lvGroup] = ret[v.lvGroup]
		ret[v.lvGroup][v.lv] = v
	end
	magicLampSkillRead.skillLvConfig = ret
	return ret
end)[1] = "jinn_skill_stage"
;(function()
	local _ENV, ret
	for i, v in ipairs(magicLampSkillRead.jinn_skill_lv) do
		if not ret[v.lvGroup] then
			_ENV = ret[v.lvGroup]
		end
		ret[v.lvGroup] = ret[v.lvGroup]
		ret[v.lvGroup][v.lv] = v
	end
	magicLampSkillRead.skillLvConfig = ret
	return ret
end)[2] = true
magicLampSkillRead:defineValue("jinn_skill_stage", function()
	local _ENV, ret
	for i, v in ipairs(magicLampSkillRead.jinn_skill_lv) do
		if not ret[v.lvGroup] then
			_ENV = ret[v.lvGroup]
		end
		ret[v.lvGroup] = ret[v.lvGroup]
		ret[v.lvGroup][v.lv] = v
	end
	magicLampSkillRead.skillLvConfig = ret
	return ret
end)
magicLampSkillRead:defineValue("skillStageConfig", function()
	local _ENV, ret
	for i, v in ipairs(magicLampSkillRead.jinn_skill_stage) do
		if not ret[v.stageGroup] then
			_ENV = ret[v.stageGroup]
		end
		ret[v.stageGroup] = ret[v.stageGroup]
		ret[v.stageGroup][v.lv] = v
	end
	magicLampSkillRead.skillStageConfig = ret
	return ret
end)
function magicLampSkillRead.getSkillStageMax(skillType)
	local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
	local nebulaMileStoneLimit = nebulaMileStoneCtrl:getPlusByUnlockTypeEx(gNebulaMileStoneUnlockType.UP_JINN_SKILL_STAR)
	local group = magicLampSkillRead.getSkillStageGroup(skillType)
	local stageMax1 = table.nums(magicLampSkillRead.skillStageConfig[group]) - 1
	local cfg = magicLampSkillRead.skillConfig[skillType]
	if nebulaMileStoneLimit ~= 0 then
		return math.min(stageMax1, nebulaMileStoneLimit)
	else
		local nebulaWarUtil = include("nebulaWarUtil")
		local group = nebulaWarUtil.getRegionGroup()
		local stageMax2 = cfg.stageMax[group]
		return math.min(stageMax1, stageMax2)
	end
end
function magicLampSkillRead.getAdvanceNeedSkill(group, lv)
	local cfg = magicLampSkillRead.skillStageConfig[group][lv]
	_UPVALUE4_ = nil
	;(nil)[1] = "type"
	;(nil)[2] = "value"
	;(nil)[3] = "classLv"
	;(nil)[4] = "count"
	return serviceFunctions.tableFormat(cfg.needSkill, nil)
end
function magicLampSkillRead.getRebirthNeed(group, lv)
	local cfg = magicLampSkillRead.skillStageConfig[group][lv]
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	return serviceFunctions.tableFormat(cfg.rebirth, nil)
end
function magicLampSkillRead.getStageLvLimit(group, lv)
	local cfg = magicLampSkillRead.skillStageConfig[group][lv]
	return cfg.lvLimit
end
function magicLampSkillRead.getStageNeedLv(group, lv)
	local cfg = magicLampSkillRead.skillStageConfig[group][lv]
	return cfg.needLv
end
function magicLampSkillRead.getSkillResolve(group, lv)
	local cfg = magicLampSkillRead.skillStageConfig[group][lv]
	return serviceFunctions.tableFormatToMap(cfg.resolve)
end
function _UPVALUE2_()
	local _ENV, ret
	for i, v in ipairs(magicLampSkillRead.jinn_skill_stage) do
		if not ret[v.stageGroup] then
			_ENV = ret[v.stageGroup]
		end
		ret[v.stageGroup] = ret[v.stageGroup]
		ret[v.stageGroup][v.lv] = v
	end
	magicLampSkillRead.skillStageConfig = ret
	return ret
end
;(function()
	local _ENV, ret
	for i, v in ipairs(magicLampSkillRead.jinn_skill_stage) do
		if not ret[v.stageGroup] then
			_ENV = ret[v.stageGroup]
		end
		ret[v.stageGroup] = ret[v.stageGroup]
		ret[v.stageGroup][v.lv] = v
	end
	magicLampSkillRead.skillStageConfig = ret
	return ret
end)[1] = "jinn_skill_return"
;(function()
	local _ENV, ret
	for i, v in ipairs(magicLampSkillRead.jinn_skill_stage) do
		if not ret[v.stageGroup] then
			_ENV = ret[v.stageGroup]
		end
		ret[v.stageGroup] = ret[v.stageGroup]
		ret[v.stageGroup][v.lv] = v
	end
	magicLampSkillRead.skillStageConfig = ret
	return ret
end)[2] = true
magicLampSkillRead:defineValue("jinn_skill_return", function()
	local _ENV, ret
	for i, v in ipairs(magicLampSkillRead.jinn_skill_stage) do
		if not ret[v.stageGroup] then
			_ENV = ret[v.stageGroup]
		end
		ret[v.stageGroup] = ret[v.stageGroup]
		ret[v.stageGroup][v.lv] = v
	end
	magicLampSkillRead.skillStageConfig = ret
	return ret
end)
magicLampSkillRead:defineValue("skillReturnConfig", function()
	local _ENV, ret
	for i, v in ipairs(magicLampSkillRead.jinn_skill_return) do
		ret[v.quality] = v
	end
	magicLampSkillRead.skillReturnConfig = ret
	return ret
end)
function magicLampSkillRead.getSkillReturn(quality)
	return magicLampSkillRead.skillReturnConfig[quality].type
end
magicLampSkillRead:defineValue("jinn_skill_skill", function()
	local _ENV, ret
	local jinn_skill_skill = require_data("jinn_skill_skill", true, true).data
	for i, v in ipairs(jinn_skill_skill) do
		_UPVALUE3_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		;(nil)[3] = "valueType"
		v.buff = serviceFunctions.tableFormat(v.buff, nil)
		ret[v.skillId] = v
	end
	magicLampSkillRead.jinn_skill_skill = ret
	return ret
end)
function magicLampSkillRead.getSkillBuffDes(skillId)
	local cfg = magicLampSkillRead.jinn_skill_skill[skillId]
	if cfg == nil then
		return ""
	end
	local magicLampSkillRead, data = "", ""
	_UPVALUE2_ = nil
	;(nil)[1] = "valueType"
	;(nil)[2] = "value"
	local buffNum = serviceFunctions.tableFormat(cfg.buffNum, nil)
	for i, v in ipairs(buffNum) do
		local value = v.value
		if v.valueType == 1 then
			value = v.value / 10 .. "%"
		elseif v.valueType == 2 then
			value = v.value
		end
		data["num" .. i] = value
	end
	return i18n(cfg.text, data)
end
function magicLampSkillRead.getSkillBuff(skillId)
	local cfg = magicLampSkillRead.jinn_skill_skill[skillId]
	return cfg
end
function magicLampSkillRead.getQualityConfig(quality)
	_UPVALUE0_, _UPVALUE0_ = nil, nil
	;(nil).name = "B"
	_UPVALUE0_, (nil)[1], (nil).key = nil, nil, "b"
	;(nil).name = "A"
	_UPVALUE0_, (nil)[2], (nil).key = nil, nil, "a"
	;(nil).name = "S"
	_UPVALUE0_, (nil)[3], (nil).key = nil, nil, "s"
	;(nil).name = "SS"
	_UPVALUE0_, (nil)[4], (nil).key = nil, nil, "ss"
	;(nil).name = "SSS"
	;(nil)[5], (nil).key = nil, "sss"
	local config
	return config[quality]
end
function magicLampSkillRead.getQualityName(quality)
	local cfg = magicLampSkillRead.getQualityConfig(quality)
	return cfg.name
end
function magicLampSkillRead.getQualityFrameSmall(quality)
	local config = magicLampSkillRead.getQualityConfig(quality)
	return string.format("frame_sdsl_zkp_%s_xiao.png", config.key), string.format("frame_sdsl_zkp_%s_xd.png", config.key)
end
function magicLampSkillRead.getQualityFrame(quality)
	local config = magicLampSkillRead.getQualityConfig(quality)
	return string.format("frame_sdsl_zkp_%s.png", config.key)
end
function magicLampSkillRead.getQualityFrameBig(quality)
	local config = magicLampSkillRead.getQualityConfig(quality)
	return string.format("frame_sdsl_kpd_%s_da.png", config.key)
end
function magicLampSkillRead.getQualityFrameTitle(quality)
	local config = magicLampSkillRead.getQualityConfig(quality)
	return string.format("frame_sdsl_btl_%s.png", config.key)
end
function magicLampSkillRead.getQualitySkillImage(quality)
	local config = magicLampSkillRead.getQualityConfig(quality)
	return string.format("jinn_skill_image_%s.png", config.key)
end
function magicLampSkillRead.getRebirthRewardList(data)
	local _ENV, ret
	if data.skillData then
		_ENV = nil
		;(nil).type = 1
		;(nil).skillType = data.skillData.skillType
		;(nil).lock = data.skillData.lock
		table.insert(ret, nil)
	end
	if data.skillList then
		for __, v in ipairs(data.skillList) do
			_ENV = nil
			;(nil).type = 1
			;(nil).skillType = v.skillType
			table.insert(ret, nil)
		end
	end
	if data.rewards then
		for i, v in ipairs(data.rewards) do
			v.type = 2
			table.insert(ret, v)
		end
	end
	return ret
end
function magicLampSkillRead.initRebirthRewardSingle(obj, data)
	if not obj.c1 then
		obj.c1 = obj:getController("c1")
		obj.Com_item = obj:getChild("Com_item")
		obj.Com_skill = obj:getChild("Com_skill")
	end
	if data.type == 1 then
		obj.c1:setSelectedIndex(0)
		_UPVALUE0_ = 0
		;(0).skillType = data.skillType
		;(0).lock = data.lock
		obj.Com_skill:initData(0)
	else
		obj.c1:setSelectedIndex(1)
		obj.Com_item:initData(data.id, data.count)
	end
end
function magicLampSkillRead.getJinnSkillLvCostItem(group, lv, rate)
	rate = rate or 1
	local magicLampSkillRead, ret
	local magicLampSkillRead, temp
	if magicLampSkillRead.skillLvConfig[group] then
		for i = 1, lv do
			local items = magicLampSkillRead.getUpgradeLvNeedItem(group, i)
			for __, v in ipairs(items) do
				serviceFunctions.addValueToArray(ret, temp, v.id, v.count)
			end
		end
	end
	for i, v in ipairs(ret) do
		v.count = math.floor(v.count * rate)
	end
	return ret
end
function magicLampSkillRead.getJinnSkillClassCostSkill(group, lv, skillType)
	local magicLampSkillRead, ret
	local magicLampSkillRead, temp
	local needSkillCount = 0
	if magicLampSkillRead.skillStageConfig[group] then
		for i = 0, lv do
			local needSkill = magicLampSkillRead.getAdvanceNeedSkill(group, i)
			for __, v in ipairs(needSkill) do
				if v.type == gJinnSkillNeedSkillType.SKILLTYPE then
					serviceFunctions.addValueToArray(ret, temp, skillType, v.count)
					needSkillCount = needSkillCount + v.count
				elseif v.type == gJinnSkillNeedSkillType.QUALITY then
					local returnSkillType = magicLampSkillRead.getSkillReturn(v.value)
					if returnSkillType then
						serviceFunctions.addValueToArray(ret, temp, returnSkillType, v.count)
					end
					needSkillCount = needSkillCount + v.count
				end
			end
		end
	end
	return ret, needSkillCount
end
function magicLampSkillRead.checkQualityNeedNote(costList)
	local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
	for __, skillID in ipairs(costList) do
		local data = magicLampSkillCtrl:getSkillData(skillID)
		local quality = magicLampSkillRead.getSkillQuality(data.skillType)
		if 3 <= quality then
			return true
		end
	end
	return false
end
function magicLampSkillRead.checkLvAndClassLv(costList)
	local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
	for __, skillID in ipairs(costList) do
		local data = magicLampSkillCtrl:getSkillData(skillID)
		if data.lv > 1 or data.classLv > 0 then
			return true
		end
	end
	return false
end
function magicLampSkillRead.getLvReturnNum(costList)
	local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
	local rate = magicLampSkillCtrl:getSkillResolvePro()
	local returnNum = 0
	local _ENV, returnMap
	for __, skillID in ipairs(costList) do
		local data = magicLampSkillCtrl:getSkillData(skillID)
		if data.lv > 1 then
			local lvGroup = magicLampSkillRead.getSkillLvGroup(data.skillType)
			local itemList = magicLampSkillRead.getJinnSkillLvCostItem(lvGroup, data.lv, rate)
			dump(itemList, "==itemList==")
			for i, v in ipairs(itemList) do
				returnNum = returnNum + v.count
				returnMap[v.id] = (returnMap[v.id] or 0) + v.count
			end
		end
	end
	return returnNum, returnMap
end
function magicLampSkillRead.getUpgradeLvNeedItemName(...)
	local itemID = magicLampSkillRead.getUpgradeLvNeedItemID()
	local publicRead = include("publicRead")
	return publicRead.getName(itemID)
end
function magicLampSkillRead.getUpgradeLvNeedItemID(...)
	return gIDDef.MAGIC_LAMP_SKILL_ENERGY
end
function magicLampSkillRead.getUpgradeLvNeedItemID2(...)
	return gIDDef.MAGIC_LAMP_SKILL_ENERGY_SSS
end
function magicLampSkillRead.sortAutoChooseList(skillList)
	table.sort(skillList, function(a, b)
		local isMaterialA = magicLampSkillRead.checkSkillIsMaterial(a.skillType)
		local isMaterialB = magicLampSkillRead.checkSkillIsMaterial(b.skillType)
		if isMaterialA ~= isMaterialB then
			return isMaterialA
		end
		if a.lv ~= b.lv then
			return a.lv < b.lv
		end
		if a.skillType ~= b.skillType then
			return a.skillType < b.skillType
		end
		return a.id < b.id
	end)
end
function magicLampSkillRead.sortRebirthCostList(skillList)
	table.sort(skillList, function(a, b)
		local qualityA = magicLampSkillRead.getSkillQuality(a.id)
		local qualityB = magicLampSkillRead.getSkillQuality(b.id)
		if qualityA ~= qualityB then
			return qualityA > qualityB
		end
		return a.id < b.id
	end)
end
function magicLampSkillRead.sortResolveSkillList(skillList)
	local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
	table.sort(skillList, function(a, b)
		local isUsingA = magicLampCtrl:getIsUsing(a.id)
		local isUsingB = magicLampCtrl:getIsUsing(b.id)
		if isUsingA ~= isUsingB then
			return not isUsingA
		end
		if a.lock ~= b.lock then
			return not a.lock
		end
		local qualityA = magicLampSkillRead.getSkillQuality(a.skillType)
		local qualityB = magicLampSkillRead.getSkillQuality(b.skillType)
		if qualityA ~= qualityB then
			return qualityA > qualityB
		end
		if a.skillType ~= b.skillType then
			return a.skillType > b.skillType
		end
		if a.classLv ~= b.classLv then
			return a.classLv < b.classLv
		end
		if a.lv ~= b.lv then
			return a.lv < b.lv
		end
		return a.id < b.id
	end)
end
function magicLampSkillRead.sortChooseSkillList(skillList, selectMap)
	local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
	table.sort(skillList, function(a, b)
		local isSelectA = selectMap[a.id] or false
		local isSelectB = selectMap[b.id] or false
		if isSelectA ~= isSelectB then
			return isSelectA
		end
		local isUsingA = magicLampCtrl:getIsUsing(a.id)
		local isUsingB = magicLampCtrl:getIsUsing(b.id)
		if isUsingA ~= isUsingB then
			return not isUsingA
		end
		if a.lock ~= b.lock then
			return not a.lock
		end
		if a.lv ~= b.lv then
			return a.lv < b.lv
		end
		if a.skillType ~= b.skillType then
			return a.skillType > b.skillType
		end
		return a.id < b.id
	end)
end
function magicLampSkillRead.sortMainSkillList(skillList, sortType, skillMap)
	if sortType == 1 then
		table.sort(skillList, function(a, b)
			local isUsingA = skillMap[a.id].isUsing or false
			local isUsingB = skillMap[b.id].isUsing or false
			if isUsingA ~= isUsingB then
				return isUsingA
			end
			local qualityA = skillMap[a.id].quality
			local qualityB = skillMap[b.id].quality
			if qualityA ~= qualityB then
				return qualityA > qualityB
			end
			if a.classLv ~= b.classLv then
				return a.classLv > b.classLv
			end
			if a.lv ~= b.lv then
				return a.lv > b.lv
			end
			if a.skillType ~= b.skillType then
				return a.skillType < b.skillType
			end
			return a.id < b.id
		end)
	else
		table.sort(skillList, function(a, b)
			local isUsingA = skillMap[a.id].isUsing or false
			local isUsingB = skillMap[b.id].isUsing or false
			if isUsingA ~= isUsingB then
				return isUsingA
			end
			if a.lv ~= b.lv then
				return a.lv > b.lv
			end
			local qualityA = skillMap[a.id].quality
			local qualityB = skillMap[b.id].quality
			if qualityA ~= qualityB then
				return qualityA > qualityB
			end
			if a.classLv ~= b.classLv then
				return a.classLv > b.classLv
			end
			if a.skillType ~= b.skillType then
				return a.skillType < b.skillType
			end
			return a.id < b.id
		end)
	end
end
function magicLampSkillRead.sorPowerSkillList(skillList, usingMap)
	table.sort(skillList, function(a, b)
		local isUsingA = usingMap[a.id]
		local isUsingB = usingMap[b.id]
		if isUsingA ~= isUsingB then
			return isUsingA
		end
		local qualityA = magicLampSkillRead.getSkillQuality(a.skillType)
		local qualityB = magicLampSkillRead.getSkillQuality(b.skillType)
		if qualityA ~= qualityB then
			return qualityA > qualityB
		end
		if a.classLv ~= b.classLv then
			return a.classLv > b.classLv
		end
		if a.lv ~= b.lv then
			return a.lv > b.lv
		end
		if a.skillType ~= b.skillType then
			return a.skillType < b.skillType
		end
		return a.id < b.id
	end)
end
function magicLampSkillRead.sortHandbookSkillList(skillTypeList, hasSkillTypeMap)
	table.sort(skillTypeList, function(a, b)
		local hasA = hasSkillTypeMap[a] or false
		local hasB = hasSkillTypeMap[b] or false
		if hasA ~= hasB then
			return hasA
		end
		return a < b
	end)
end
function magicLampSkillRead.getJinnSkillCfg()
	return magicLampSkillRead.jinn_skill
end
return magicLampSkillRead
