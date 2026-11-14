local divineBeastRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "divine_beast_config"
;(nil)[2] = true
divineBeastRead:defineValue("divine_beast_config", nil)
_UPVALUE2_ = nil
;(nil)[1] = "divine_beast_attribute_config"
;(nil)[2] = true
divineBeastRead:defineValue("divine_beast_attribute_config", nil)
_UPVALUE2_ = nil
;(nil)[1] = "divine_beast_refresh_config"
;(nil)[2] = true
divineBeastRead:defineValue("divine_beast_refresh_config", nil)
_UPVALUE2_ = nil
;(nil)[1] = "divine_beast_skill_config"
;(nil)[2] = true
divineBeastRead:defineValue("divine_beast_skill_config", nil)
_UPVALUE2_ = nil
;(nil)[1] = "divine_beast_star_config"
;(nil)[2] = true
divineBeastRead:defineValue("divine_beast_star_config", nil)
_UPVALUE2_ = nil
;(nil)[1] = "divine_beast_step_config"
;(nil)[2] = true
divineBeastRead:defineValue("divine_beast_step_config", nil)
_UPVALUE2_ = nil
;(nil)[1] = "divine_beast_treat_config"
;(nil)[2] = true
divineBeastRead:defineValue("divine_beast_treat_config", nil)
_UPVALUE1_ = nil
;(nil)[1] = "divine_beast_grow_des"
divineBeastRead:defineValue("divine_beast_grow_des", nil)
_UPVALUE1_ = nil
;(nil)[1] = "divine_beast_march"
divineBeastRead:defineValue("divine_beast_march", nil)
divineBeastRead:defineValue("dbCfgs", function()
	local _ENV, dbCfgs
	for i, v in ipairs(divineBeastRead.divine_beast_config) do
		_UPVALUE3_ = nil
		;(nil)[1] = "buffType"
		;(nil)[2] = "vtype"
		;(nil)[3] = "value"
		v.buff = serviceFunctions.tableFormat(v.buff, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "type"
		;(nil)[2] = "lv"
		v.unlockDispatch = serviceFunctions.tableFormat(v.unlockDispatch, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "type"
		;(nil)[2] = "lv"
		v.unlockDefend = serviceFunctions.tableFormat(v.unlockDefend, nil)
		dbCfgs[v.divineID] = v
	end
	return dbCfgs
end)
function _UPVALUE2_()
	local _ENV, dbCfgs
	for i, v in ipairs(divineBeastRead.divine_beast_config) do
		_UPVALUE3_ = nil
		;(nil)[1] = "buffType"
		;(nil)[2] = "vtype"
		;(nil)[3] = "value"
		v.buff = serviceFunctions.tableFormat(v.buff, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "type"
		;(nil)[2] = "lv"
		v.unlockDispatch = serviceFunctions.tableFormat(v.unlockDispatch, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "type"
		;(nil)[2] = "lv"
		v.unlockDefend = serviceFunctions.tableFormat(v.unlockDefend, nil)
		dbCfgs[v.divineID] = v
	end
	return dbCfgs
end
_UPVALUE1_ = nil
;(function()
	local _ENV, dbCfgs
	for i, v in ipairs(divineBeastRead.divine_beast_config) do
		_UPVALUE3_ = nil
		;(nil)[1] = "buffType"
		;(nil)[2] = "vtype"
		;(nil)[3] = "value"
		v.buff = serviceFunctions.tableFormat(v.buff, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "type"
		;(nil)[2] = "lv"
		v.unlockDispatch = serviceFunctions.tableFormat(v.unlockDispatch, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "type"
		;(nil)[2] = "lv"
		v.unlockDefend = serviceFunctions.tableFormat(v.unlockDefend, nil)
		dbCfgs[v.divineID] = v
	end
	return dbCfgs
end).keyMap, (nil)[1] = nil, "questID"
;(function()
	local _ENV, dbCfgs
	for i, v in ipairs(divineBeastRead.divine_beast_config) do
		_UPVALUE3_ = nil
		;(nil)[1] = "buffType"
		;(nil)[2] = "vtype"
		;(nil)[3] = "value"
		v.buff = serviceFunctions.tableFormat(v.buff, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "type"
		;(nil)[2] = "lv"
		v.unlockDispatch = serviceFunctions.tableFormat(v.unlockDispatch, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "type"
		;(nil)[2] = "lv"
		v.unlockDefend = serviceFunctions.tableFormat(v.unlockDefend, nil)
		dbCfgs[v.divineID] = v
	end
	return dbCfgs
end)[1] = "divine_beast_quest_config"
;(function()
	local _ENV, dbCfgs
	for i, v in ipairs(divineBeastRead.divine_beast_config) do
		_UPVALUE3_ = nil
		;(nil)[1] = "buffType"
		;(nil)[2] = "vtype"
		;(nil)[3] = "value"
		v.buff = serviceFunctions.tableFormat(v.buff, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "type"
		;(nil)[2] = "lv"
		v.unlockDispatch = serviceFunctions.tableFormat(v.unlockDispatch, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "type"
		;(nil)[2] = "lv"
		v.unlockDefend = serviceFunctions.tableFormat(v.unlockDefend, nil)
		dbCfgs[v.divineID] = v
	end
	return dbCfgs
end)[2] = true
divineBeastRead:defineValue("questCfgs", function()
	local _ENV, dbCfgs
	for i, v in ipairs(divineBeastRead.divine_beast_config) do
		_UPVALUE3_ = nil
		;(nil)[1] = "buffType"
		;(nil)[2] = "vtype"
		;(nil)[3] = "value"
		v.buff = serviceFunctions.tableFormat(v.buff, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "type"
		;(nil)[2] = "lv"
		v.unlockDispatch = serviceFunctions.tableFormat(v.unlockDispatch, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "type"
		;(nil)[2] = "lv"
		v.unlockDefend = serviceFunctions.tableFormat(v.unlockDefend, nil)
		dbCfgs[v.divineID] = v
	end
	return dbCfgs
end)
function divineBeastRead.getTaskFastPassCost(questID)
	local cfg = divineBeastRead.questCfgs[tonumber(questID)]
	if cfg and cfg.fastpass == 1 then
		return cfg.cost[1], cfg.cost[2]
	end
end
divineBeastRead:defineValue("attributeCfgs", function()
	local _ENV, attributeCfgs
	for i, v in ipairs(divineBeastRead.divine_beast_attribute_config) do
		if not attributeCfgs[v.attributeType] then
			_ENV = attributeCfgs[v.attributeType]
		end
		attributeCfgs[v.attributeType] = attributeCfgs[v.attributeType]
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "num"
		v.promoteItem = serviceFunctions.tableFormat(v.promoteItem, nil)
		attributeCfgs[v.attributeType][v.stepLevel] = v
	end
	return attributeCfgs
end)
divineBeastRead:defineValue("refreshCfgs", function()
	local _ENV, refreshCfgs
	for i, v in ipairs(divineBeastRead.divine_beast_refresh_config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "num"
		v.cost = serviceFunctions.tableFormat(v.cost, nil)
		refreshCfgs[v.refreshes] = v
	end
	return refreshCfgs
end)
divineBeastRead:defineValue("skillCfgs", function()
	local _ENV, skillCfgs
	for i, v in ipairs(divineBeastRead.divine_beast_skill_config) do
		_UPVALUE3_ = nil
		;(nil)[1] = "buffType"
		;(nil)[2] = "vtype"
		;(nil)[3] = "value"
		v.buff = serviceFunctions.tableFormat(v.buff, nil)
		if not skillCfgs[v.skillID] then
			_ENV = skillCfgs[v.skillID]
		end
		skillCfgs[v.skillID] = skillCfgs[v.skillID]
		skillCfgs[v.skillID][v.skillLevel] = v
	end
	return skillCfgs
end)
divineBeastRead:defineValue("starCfgs", function()
	local _ENV, starCfgs
	for i, v in ipairs(divineBeastRead.divine_beast_star_config) do
		if not starCfgs[v.starType] then
			_ENV = starCfgs[v.starType]
		end
		starCfgs[v.starType] = starCfgs[v.starType]
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "num"
		v.promoteItem = serviceFunctions.tableFormat(v.promoteItem, nil)
		starCfgs[v.starType][v.starLevel] = v
	end
	return starCfgs
end)
divineBeastRead:defineValue("stepCfgs", function()
	local _ENV, stepCfgs
	for i, v in ipairs(divineBeastRead.divine_beast_step_config) do
		if not stepCfgs[v.stepType] then
			_ENV = stepCfgs[v.stepType]
		end
		stepCfgs[v.stepType] = stepCfgs[v.stepType]
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "num"
		v.promoteItem = serviceFunctions.tableFormat(v.promoteItem, nil)
		stepCfgs[v.stepType][v.stepLevel] = v
	end
	return stepCfgs
end)
divineBeastRead:defineValue("treatCfgs", function()
	local _ENV, treatCfgs
	for i, v in ipairs(divineBeastRead.divine_beast_treat_config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "num"
		v.promoteItem = serviceFunctions.tableFormat(v.promoteItem, nil)
		_UPVALUE3_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "num"
		;(nil)[3] = "weight"
		v.extraReward = serviceFunctions.tableFormat(v.extraReward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "num"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		treatCfgs[v.divineID] = v
	end
	return treatCfgs
end)
divineBeastRead:defineValue("growDesCfgs", function()
	local _ENV, growDesCfgs
	for i, v in ipairs(divineBeastRead.divine_beast_grow_des) do
		if not growDesCfgs[v.divineID] then
			_ENV = growDesCfgs[v.divineID]
		end
		growDesCfgs[v.divineID] = growDesCfgs[v.divineID]
		if not growDesCfgs[v.divineID][v.starLevel] then
			_ENV = growDesCfgs[v.divineID][v.starLevel]
		end
		growDesCfgs[v.divineID][v.starLevel] = growDesCfgs[v.divineID][v.starLevel]
		table.insert(growDesCfgs[v.divineID][v.starLevel], v)
	end
	return growDesCfgs
end)
divineBeastRead:defineValue("marchCfgs", function()
	local _ENV, marchCfgs
	for i, v in ipairs(divineBeastRead.divine_beast_march) do
		marchCfgs[v.marchID] = v
	end
	return marchCfgs
end)
function divineBeastRead.getDefaultDivineID()
	return divineBeastRead.divine_beast_config[1].divineID
end
function divineBeastRead.getBeastConfigs()
	return divineBeastRead.divine_beast_config
end
function divineBeastRead.getDbCfg(divineID)
	return divineID and divineBeastRead.dbCfgs[tonumber(divineID)] or divineBeastRead.dbCfgs
end
function divineBeastRead.getMarkUnlockStepLv(divineID)
	return divineBeastRead.dbCfgs[tonumber(divineID)].unlockMark
end
function divineBeastRead.getIsUnlockDispatch(divineID, starLv, stepLv)
	local dbCfg = divineBeastRead.dbCfgs[tonumber(divineID)]
	local isAllUnlock = true
	for i, v in ipairs(dbCfg.unlockDispatch) do
		if v.type == 1 and starLv < v.lv then
			isAllUnlock = false
			break
		elseif v.type == 2 and stepLv < v.lv then
			isAllUnlock = false
			break
		end
	end
	return isAllUnlock
end
function divineBeastRead.getIsUnlockDefend(divineID, starLv, stepLv)
	local dbCfg = divineBeastRead.dbCfgs[tonumber(divineID)]
	local isAllUnlock = true
	for i, v in ipairs(dbCfg.unlockDefend) do
		if v.type == 1 and starLv < v.lv then
			isAllUnlock = false
			break
		elseif v.type == 2 and stepLv < v.lv then
			isAllUnlock = false
			break
		end
	end
	return isAllUnlock
end
function divineBeastRead.getTreatCfg(divineID)
	return divineID and divineBeastRead.treatCfgs[tonumber(divineID)] or divineBeastRead.treatCfgs
end
function divineBeastRead.getRefreshCfg(count)
	local refreshCfg = divineBeastRead.refreshCfgs[count]
	if refreshCfg == nil then
		return divineBeastRead.refreshCfgs[#divineBeastRead.refreshCfgs]
	end
	return refreshCfg
end
function divineBeastRead.getName(divineID)
	return i18n(divineBeastRead.dbCfgs[tonumber(divineID)].divineName)
end
function divineBeastRead.getSkillCfg(skillID)
	return skillID and divineBeastRead.skillCfgs[skillID] or divineBeastRead.skillCfgs
end
function divineBeastRead.getAttributeCfg(divineID, level)
	local dbCfg = divineBeastRead.dbCfgs[tonumber(divineID)]
	local type = dbCfg and dbCfg.attributeType or 1
	return divineBeastRead.attributeCfgs[type][level]
end
function divineBeastRead.getAttributeCfgs(divineID)
	local dbCfg = divineBeastRead.dbCfgs[tonumber(divineID)]
	local type = dbCfg and dbCfg.attributeType or 1
	return divineBeastRead.attributeCfgs[type]
end
function divineBeastRead.getStarCfg(divineID, level)
	local dbCfg = divineBeastRead.dbCfgs[tonumber(divineID)]
	local type = dbCfg and dbCfg.starType or 1
	return divineBeastRead.starCfgs[type][level]
end
function divineBeastRead.getStarCfgs(divineID)
	local dbCfg = divineBeastRead.dbCfgs[tonumber(divineID)]
	local type = dbCfg and dbCfg.starType or 1
	return divineBeastRead.starCfgs[type]
end
function divineBeastRead.getStepCfg(divineID, level)
	local dbCfg = divineBeastRead.dbCfgs[tonumber(divineID)]
	local type = dbCfg and dbCfg.stepType or 1
	return divineBeastRead.stepCfgs[type][level]
end
function divineBeastRead.getMaxStepLv(divineID)
	local dbCfg = divineBeastRead.dbCfgs[tonumber(divineID)]
	local type = dbCfg and dbCfg.stepType or 1
	local stepCfgs = divineBeastRead.stepCfgs[type]
	return table.nums(stepCfgs) - 1
end
function divineBeastRead.getMaxStarLv(divineID)
	local dbCfg = divineBeastRead.dbCfgs[tonumber(divineID)]
	local type = dbCfg and dbCfg.starType or 1
	local starCfgs = divineBeastRead.starCfgs[type]
	return table.nums(starCfgs) - 1
end
function divineBeastRead.getIcon(divineID)
	local dbCfg = divineBeastRead.dbCfgs[tonumber(divineID)]
	return dbCfg.divineIcon
end
function divineBeastRead.getGrowDes(divineID, starLv)
	return divineBeastRead.growDesCfgs[divineID][starLv]
end
function divineBeastRead.getUsmData(divineID)
	return divineBeastRead.beast_usm[tonumber(divineID)]
end
_ENV, divineBeastRead.getMarchCfg = function(marchType)
	return divineBeastRead.marchCfgs[marchType]
end, function(marchType)
	return divineBeastRead.marchCfgs[marchType]
end
;(function(marchType)
	return divineBeastRead.marchCfgs[marchType]
end)[1900] = "frame_artifact_600131.png"
local (function(marchType)
	return divineBeastRead.marchCfgs[marchType]
end)[1901], combinationGroupIcon = "icon_battle_Maahes.png", function(marchType)
	return divineBeastRead.marchCfgs[marchType]
end
_ENV, divineBeastRead.getCombinationGroupIcon = function(divineID)
	return combinationGroupIcon[divineID]
end, function(divineID)
	return combinationGroupIcon[divineID]
end
;(function(divineID)
	return combinationGroupIcon[divineID]
end)[1900] = "activity_bg_ssyj.png"
local (function(divineID)
	return combinationGroupIcon[divineID]
end)[1901], beastMarkBg = "activity_bg_ssyj_01.png", function(divineID)
	return combinationGroupIcon[divineID]
end
function divineBeastRead.getBeastMarkBg(divineID)
	return beastMarkBg[divineID] or "activity_bg_ssyj_01.png"
end
divineBeastRead:defineValue("beast_usm", function()
	_ENV = nil
	_ENV, _ENV = nil, nil
	;(nil).bg = "shenshou_chuniaodaiji.png"
	;(nil).daiji = "shenshou_chuniaodaiji.usm"
	_ENV, _ENV, (nil).treating, (nil).treat = nil, nil, nil, "SS_leiniaozl_01.usm,shenshou_chuniaodaiji.usm"
	;(nil).bg = "shenshou_yijiedaiji.png"
	;(nil).daiji = "shenshou_yijiedaiji.usm"
	;(nil).treat = "SS_leiniaosj_01.usm,shenshou_yijiedaiji.usm"
	;(nil).stepUp = "SS_leiniaodjzs_01.usm,shenshou_yijiedaiji.usm"
	_ENV, (nil)[0], (nil).heal = nil, nil, "SS_leiniaosx_01.usm,shenshou_yijiedaiji.usm"
	;(nil).bg = "shenshou_yijiedaiji.png"
	;(nil).daiji = "shenshou_yijiedaiji.usm"
	;(nil).treat = "SS_leiniaosj_01.usm,shenshou_yijiedaiji.usm"
	_ENV, (nil)[1], (nil).stepUp = nil, nil, "SS_leiniaodjzs_01.usm,shenshou_yijiedaiji.usm"
	;(nil).bg = "shenshou_yijiedaiji.png"
	;(nil).daiji = "shenshou_yijiedaiji.usm"
	;(nil).treat = "SS_leiniaosj_01.usm,shenshou_yijiedaiji.usm"
	_ENV, (nil)[2], (nil).stepUp = nil, nil, "SS_leiniaodjzs_01.usm,shenshou_yijiedaiji.usm"
	;(nil).bg = "shenshou_dierjie.png"
	;(nil).daiji = "shenshou_dierjie.usm"
	;(nil).treat = "lnejzs.usm,shenshou_dierjie.usm"
	_ENV, (nil)[3], (nil).starUp = nil, nil, "lnejsj.usm,shenshou_dierjie.usm"
	;(nil).bg = "shenshou_dierjie.png"
	;(nil).daiji = "shenshou_dierjie.usm"
	_ENV, (nil)[4], (nil).treat = nil, nil, "lnejzs.usm,shenshou_dierjie.usm"
	;(nil).bg = "shenshou_disanjie.png"
	;(nil).daiji = "shenshou_disanjie.usm"
	;(nil).treat = "lnejsj2_3.usm,shenshou_disanjie.usm"
	_ENV, (nil)[5], (nil).starUp = nil, nil, "ln3ejzs.usm,shenshou_disanjie.usm"
	;(nil).bg = "shenshou_disanjie.png"
	;(nil).daiji = "shenshou_disanjie.usm"
	_ENV, (nil)[6], (nil).treat = nil, nil, "lnejsj2_3.usm,shenshou_disanjie.usm"
	;(nil).bg = "shenshou_disijie_first.png"
	;(nil).daiji = "shenshou_disijie.usm"
	;(nil).treat = "shenshou_disjie_treat.usm,shenshou_disijie.usm"
	_ENV, (nil)[7], (nil).starUp = nil, nil, "shenshou_disjie_up.usm,shenshou_disijie.usm"
	;(nil).bg = "shenshou_disijie_first.png"
	;(nil).daiji = "shenshou_disijie.usm"
	_ENV, (nil)[8], (nil).treat = nil, nil, "shenshou_disjie_treat.usm,shenshou_disijie.usm"
	;(nil).bg = "shenshou_disijie_first.png"
	;(nil).daiji = "shenshou_disijie.usm"
	;(nil)[gBestID.ONE], (nil).star, (nil).default, (nil).treat = nil, nil, nil, "shenshou_disjie_treat.usm,shenshou_disijie.usm"
	_ENV, _ENV = nil, nil
	;(nil).bg = "sehnshou1901_01ss.png"
	;(nil).daiji = "sssz1_dj.usm"
	_ENV, _ENV, (nil).treating, (nil).treat = nil, nil, nil, "sssz1_xx.usm,sssz1_dj.usm"
	;(nil).bg = "sehnshou1901_02ss.png"
	;(nil).daiji = "sssz2_dj.usm"
	;(nil).treat = "sssz2_xx.usm,sssz2_dj.usm"
	_ENV, (nil)[0], (nil).heal = nil, nil, "sssz1_sj.usm,sssz2_dj.usm"
	;(nil).bg = "sehnshou1901_02ss.png"
	;(nil).daiji = "sssz2_dj.usm"
	_ENV, (nil)[1], (nil).treat = nil, nil, "sssz2_xx.usm,sssz2_dj.usm"
	;(nil).bg = "sehnshou1901_02ss.png"
	;(nil).daiji = "sssz2_dj.usm"
	_ENV, (nil)[2], (nil).treat = nil, nil, "sssz2_xx.usm,sssz2_dj.usm"
	;(nil).bg = "sehnshou1901_03ss.png"
	;(nil).daiji = "sssz3_dj.usm"
	;(nil).treat = "sssz3_xx.usm,sssz3_dj.usm"
	;(nil).stepUp = "sssz3_sx.usm,sssz3_dj.usm"
	_ENV, (nil)[3], (nil).starUp = nil, nil, "sssz2_sj.usm,sssz3_dj.usm"
	;(nil).bg = "sehnshou1901_03ss.png"
	;(nil).daiji = "sssz3_dj.usm"
	;(nil).treat = "sssz3_xx.usm,sssz3_dj.usm"
	;(nil).stepUp = "sssz3_sx.usm,sssz3_dj.usm"
	_ENV, (nil)[4], (nil).starUp = nil, nil, "sssz3_sx.usm,sssz3_dj.usm"
	;(nil).bg = "sehnshou1901_04ss.png"
	;(nil).daiji = "sssz4_dj.usm"
	;(nil).treat = "sssz4_xx.usm,sssz4_dj.usm"
	;(nil).stepUp = "sssz4_sx.usm,sssz4_dj.usm"
	_ENV, (nil)[5], (nil).starUp = nil, nil, "sssz3_sj.usm,sssz4_dj.usm"
	;(nil).bg = "sehnshou1901_04ss.png"
	;(nil).daiji = "sssz4_dj.usm"
	;(nil).treat = "sssz4_xx.usm,sssz4_dj.usm"
	;(nil).stepUp = "sssz4_sx.usm,sssz4_dj.usm"
	_ENV, (nil)[6], (nil).starUp = nil, nil, "sssz4_sx.usm,sssz4_dj.usm"
	;(nil).bg = "sehnshou1901_05ss.png"
	;(nil).daiji = "sssz5_dj.usm"
	;(nil).treat = "sssz5_xx.usm,sssz5_dj.usm"
	;(nil).stepUp = "sssz5_sx.usm,sssz5_dj.usm"
	_ENV, (nil)[7], (nil).starUp = nil, nil, "sssz4_sj.usm,sssz5_dj.usm"
	;(nil).bg = "sehnshou1901_05ss.png"
	;(nil).daiji = "sssz5_dj.usm"
	;(nil).treat = "sssz5_xx.usm,sssz5_dj.usm"
	;(nil).stepUp = "sssz5_sx.usm,sssz5_dj.usm"
	_ENV, (nil)[8], (nil).starUp = nil, nil, "sssz5_sx.usm,sssz5_dj.usm"
	;(nil).bg = "sehnshou1901_05ss.png"
	;(nil).daiji = "sssz5_dj.usm"
	;(nil)[gBestID.TWO], (nil).star, (nil).default, (nil).treat = nil, nil, nil, "sssz5_xx.usm,sssz5_dj.usm"
	return nil
end)
return divineBeastRead
