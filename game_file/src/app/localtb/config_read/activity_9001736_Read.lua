local activity_9001736_Read = include("aAReadClass").new()
function activity_9001736_Read.getClassType()
	local activity_9001736_Ctrl = SoraDGetCtrl("activity_9001736_Ctrl")
	return activity_9001736_Ctrl:getClassType()
end
_UPVALUE2_ = nil
_UPVALUE1_ = nil
;(nil).keyMap, (nil)[1] = nil, "seedID"
;(nil)[1] = "seed_footballmatch_main"
;(nil)[2] = true
activity_9001736_Read:defineValue("seed_footballmatch_main", nil)
function activity_9001736_Read.getSeedConfig(seedID)
	return activity_9001736_Read.seed_footballmatch_main[seedID]
end
function activity_9001736_Read.getSeedMark(seedID)
	local cfg = activity_9001736_Read.getSeedConfig(seedID)
	return cfg.seedMark
end
function activity_9001736_Read.getSeedType(seedID)
	local cfg = activity_9001736_Read.getSeedConfig(seedID)
	return cfg.seedType
end
function activity_9001736_Read.getSeedQuality(seedID)
	local cfg = activity_9001736_Read.getSeedConfig(seedID)
	return cfg.seedQuality
end
function activity_9001736_Read.getSeedPosition(seedID)
	local cfg = activity_9001736_Read.getSeedConfig(seedID)
	return cfg.position
end
function activity_9001736_Read.getSeedPower(seedID)
	local cfg = activity_9001736_Read.getSeedConfig(seedID)
	return cfg.seedPower
end
function activity_9001736_Read.getSeedName(seedID)
	local cfg = activity_9001736_Read.getSeedConfig(seedID)
	return i18n(cfg.name)
end
function activity_9001736_Read.getSeedImage(seedID)
	local cfg = activity_9001736_Read.getSeedConfig(seedID)
	return cfg.image
end
_UPVALUE2_ = nil
_UPVALUE1_ = nil
;(nil).keyMap, (nil)[1] = nil, "seedType"
;(nil)[1] = "seed_footballmatch_seedtype"
;(nil)[2] = true
activity_9001736_Read:defineValue("seed_footballmatch_seedtype", nil)
function activity_9001736_Read.getSeedTypeConfig(seedType)
	return activity_9001736_Read.seed_footballmatch_seedtype[seedType]
end
function activity_9001736_Read.getSeedTypeName(seedType)
	local cfg = activity_9001736_Read.getSeedTypeConfig(seedType)
	return i18n(cfg.typeName)
end
function activity_9001736_Read.getSeedTypeIcon(seedType)
	local manorFarmRead = include("manorFarmRead")
	return manorFarmRead.getSeedTypeIcon(seedType)
end
function activity_9001736_Read.getSeedTypeMax()
	local manorFarmRead = include("manorFarmRead")
	return manorFarmRead.getSeedTypeNum() - 1
end
_UPVALUE2_ = nil
_UPVALUE2_ = nil
;(nil).keyMap, (nil)[1] = nil, "seedQuality"
;(nil).keyMap, (nil)[2] = nil, "lv"
;(nil)[1] = "seed_footballmatch_lvup"
;(nil)[2] = true
activity_9001736_Read:defineValue("seed_footballmatch_lvup", nil)
function activity_9001736_Read.getSeedLvupConfig(seedQuality, lv)
	return activity_9001736_Read.seed_footballmatch_lvup[seedQuality][lv]
end
function activity_9001736_Read.getSeedLvupExp(seedQuality, lv)
	local cfg = activity_9001736_Read.getSeedLvupConfig(seedQuality, lv)
	return cfg.exp
end
function activity_9001736_Read.getSeedLvByExp(seedQuality, exp)
	local config = activity_9001736_Read.seed_footballmatch_lvup[seedQuality]
	for lv = #config, 1, -1 do
		local cfg = config[lv]
		if exp >= cfg.exp then
			return lv
		end
	end
	return 1
end
function activity_9001736_Read.getSeedLvupPowerArise(seedQuality, lv)
	local cfg = activity_9001736_Read.getSeedLvupConfig(seedQuality, lv)
	return cfg.powerArise
end
function activity_9001736_Read.getSeedMaxLv(seedQuality)
	local config = activity_9001736_Read.seed_footballmatch_lvup[seedQuality]
	return #config
end
function activity_9001736_Read.getSeedMaxExp(seedQuality)
	local maxLv = activity_9001736_Read.getSeedMaxLv(seedQuality)
	return activity_9001736_Read.getSeedLvupExp(seedQuality, maxLv)
end
_UPVALUE2_ = nil
;(nil)[1] = "seed_footballmatch_bond"
;(nil)[2] = true
activity_9001736_Read:defineValue("seed_footballmatch_bond", nil)
function activity_9001736_Read.getBondConfig()
	return activity_9001736_Read.seed_footballmatch_bond
end
function activity_9001736_Read.getBondPowerUp(bondNum)
	local bondIdx = activity_9001736_Read.getBondIdx(bondNum)
	local cfg = activity_9001736_Read.seed_footballmatch_bond[bondIdx]
	return cfg and cfg.powerUp or 0
end
function activity_9001736_Read.getBondIdx(bondNum)
	local bondIdx = 0
	for i, cfg in ipairs(activity_9001736_Read.seed_footballmatch_bond) do
		if bondNum >= cfg.bondNum then
			bondIdx = i
		else
			break
		end
	end
	return bondIdx
end
_UPVALUE2_ = nil
_UPVALUE2_ = nil
_UPVALUE2_, _ENV, (nil).keyMap, (nil)[1] = "classType", nil, nil, "classType"
_UPVALUE2_, _ENV, (nil).keyMap, (nil)[2] = "classType", nil, nil, "taskId"
;(nil).tableFormat, (nil).taskReward, ("classType")[1] = nil, "classType", "id"
;(nil).tableFormat, (nil).taskReward, ("classType")[2] = nil, "classType", "count"
;(nil)[1] = "seed_footballmatch_task"
;(nil)[2] = true
activity_9001736_Read:defineValue("seed_footballmatch_task", nil)
function activity_9001736_Read.getTaskConfig(taskId)
	local classType = activity_9001736_Read.getClassType()
	return activity_9001736_Read.seed_footballmatch_task[classType][taskId]
end
function activity_9001736_Read.getTaskType(taskId)
	local cfg = activity_9001736_Read.getTaskConfig(taskId)
	return cfg.taskType
end
function activity_9001736_Read.getTaskNum(taskId)
	local cfg = activity_9001736_Read.getTaskConfig(taskId)
	return cfg.taskNum
end
_UPVALUE2_ = nil
_UPVALUE1_ = nil
;(nil).keyList, (nil)[1] = nil, "classType"
;(nil).insertKey = "taskId"
;(nil)[1] = "seed_footballmatch_task"
;(nil)[2] = true
activity_9001736_Read:defineValue("taskIdList", nil)
function activity_9001736_Read.getTaskIdList()
	local classType = activity_9001736_Read.getClassType()
	if not activity_9001736_Read.taskIdList[classType] then
		activity_9001736_Read = activity_9001736_Read.taskIdList[classType]
	end
	return activity_9001736_Read.taskIdList[classType]
end
_UPVALUE2_ = nil
_UPVALUE2_ = nil
;(nil).keyList, (nil)[1] = nil, "classType"
;(nil).keyList, (nil)[2] = nil, "taskType"
;(nil).insertKey = "taskId"
;(nil)[1] = "seed_footballmatch_task"
;(nil)[2] = true
activity_9001736_Read:defineValue("taskGroupList", nil)
function activity_9001736_Read.getTaskGroupList()
	local classType = activity_9001736_Read.getClassType()
	if not activity_9001736_Read.taskGroupList[classType] then
		activity_9001736_Read = activity_9001736_Read.taskGroupList[classType]
	end
	return activity_9001736_Read.taskGroupList[classType]
end
function activity_9001736_Read.getSortList()
	local activity_9001736_Ctrl = SoraDGetCtrl("activity_9001736_Ctrl")
	local taskIdList = activity_9001736_Ctrl:getShowTaskIdList()
	local _ENV, ret = activity_9001736_Ctrl, activity_9001736_Ctrl
	for __, v in ipairs(taskIdList) do
		local taskId = v.taskId
		local taskStatus = v.taskStatus
		local cfg = activity_9001736_Read.getTaskConfig(taskId)
		local count = activity_9001736_Ctrl:getTaskProgress(taskId) or 0
		_ENV = nil
		;(nil).activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001736
		;(nil).taskID = taskId
		;(nil).count = count
		;(nil).award = cfg.taskReward
		;(nil).total = cfg.taskNum
		activity_9001736_Read, (nil).taskStatus = cfg.taskNum, taskStatus
		cfg.taskNum.num = cfg.taskNum
		;(nil).taskDes, cfg.taskNum[1] = cfg.taskNum, cfg.taskDes
		;(nil).isAct = 0
		table.insert(ret, nil)
	end
	table.sort(ret, function(a, b)
		if a.taskStatus ~= b.taskStatus then
			return a.taskStatus < b.taskStatus
		end
		return a.taskID < b.taskID
	end)
	return ret
end
_UPVALUE2_ = nil
_UPVALUE2_ = nil
_UPVALUE2_, _ENV, (nil).keyMap, (nil)[1] = "classType", nil, nil, "classType"
_UPVALUE2_, _ENV, (nil).keyMap, (nil)[2] = "classType", nil, nil, "rewardID"
_UPVALUE2_, (nil).normalReward, ("classType")[1] = "classType", "classType", "id"
_UPVALUE2_, (nil).normalReward, ("classType")[2] = "classType", "classType", "count"
;(nil).tableFormat, (nil).advanceReward, ("classType")[1] = nil, "classType", "id"
;(nil).tableFormat, (nil).advanceReward, ("classType")[2] = nil, "classType", "count"
;(nil)[1] = "seed_footballmatch_battlepass"
;(nil)[2] = true
activity_9001736_Read:defineValue("seed_footballmatch_battlepass", nil)
function activity_9001736_Read.getBattlePassCfg()
	local classType = activity_9001736_Read.getClassType()
	return activity_9001736_Read.seed_footballmatch_battlepass[classType]
end
function activity_9001736_Read.getBattlePassMaxOpenDay()
	local cfg = activity_9001736_Read.getBattlePassCfg()
	return #cfg
end
_UPVALUE2_ = nil
_UPVALUE1_ = nil
;(nil).keyMap, (nil)[1] = nil, "rechargeID"
;(nil)[1] = "seed_footballmatch_recharge"
;(nil)[2] = true
activity_9001736_Read:defineValue("seed_footballmatch_recharge", nil)
function activity_9001736_Read.getRechargeConfig(rechargeID)
	return activity_9001736_Read.seed_footballmatch_recharge[rechargeID]
end
function activity_9001736_Read.getRechargeName(rechargeID)
	local cfg = activity_9001736_Read.getRechargeConfig(rechargeID)
	return i18n(cfg.rechargeName)
end
function activity_9001736_Read.getAdvanceRechargeCfg()
	for _, cfg in pairs(activity_9001736_Read.seed_footballmatch_recharge) do
		if cfg.rechargeType == 1 then
			return cfg
		end
	end
	return nil
end
activity_9001736_Read:defineValue("posTypeConfig", function()
	_UPVALUE0_, _UPVALUE0_ = nil, nil
	;(nil).posType = 1
	;(nil).typeName = "football_match_text_035"
	_UPVALUE0_, (nil)[1], (nil).typeIcon = nil, nil, "frame_9001736_fw.png"
	;(nil).posType = 2
	;(nil).typeName = "football_match_text_036"
	_UPVALUE0_, (nil)[2], (nil).typeIcon = nil, nil, "frame_9001736_mf.png"
	;(nil).posType = 3
	;(nil).typeName = "football_match_text_037"
	_UPVALUE0_, (nil)[3], (nil).typeIcon = nil, nil, "frame_9001736_df.png"
	;(nil).posType = 4
	;(nil).typeName = "football_match_text_038"
	;(nil)[4], (nil).typeIcon = nil, "frame_9001736_gk.png"
	local config
	return config
end)
function activity_9001736_Read.getPosTypeName(posType)
	local cfg = activity_9001736_Read.posTypeConfig[posType]
	return i18n(cfg.typeName)
end
function activity_9001736_Read.getPosTypeIcon(posType)
	local cfg = activity_9001736_Read.posTypeConfig[posType]
	return cfg.typeIcon
end
function activity_9001736_Read.getSeedQualityBg(seedQuality)
	_UPVALUE0_ = nil
	;(nil)[1] = "frame_item_base_02.png"
	;(nil)[2] = "frame_item_base_03.png"
	;(nil)[3] = "frame_item_base_04.png"
	local (nil)[4], config = "frame_item_base_05.png", nil
	return config[seedQuality] or "frame_item_base_02.png"
end
return activity_9001736_Read
