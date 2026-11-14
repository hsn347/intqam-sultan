local activityCommonKitchenRead = include("aAReadClass").new()
function activityCommonKitchenRead.getClassType(activityID)
	return SoraDGetActivityClassType(activityID)
end
_UPVALUE2_ = nil
;(nil)[1] = "octopus_kitchen_food"
;(nil)[2] = true
activityCommonKitchenRead:defineValue("octopus_kitchen_food", nil)
_UPVALUE2_ = nil
;(nil)[1] = "eidal_kitchen_food"
;(nil)[2] = true
activityCommonKitchenRead:defineValue("eidal_kitchen_food", nil)
local createFunc = function(name)
	_ENV = nil
	;(nil).foodIDList = "octopus_kitchen_food"
	;(nil).normalFoodIDList = "octopus_kitchen_food"
	;(nil).specFoodIDList = "octopus_kitchen_food"
	;(nil).foodIDList_9001699 = "eidal_kitchen_food"
	;(nil).normalFoodIDList_9001699 = "eidal_kitchen_food"
	local (nil).specFoodIDList_9001699, config = "eidal_kitchen_food", nil
	local configKey = config[name]
	local _ENV, ret
	local _ENV, ret1
	local _ENV, ret2
	for __, v in ipairs(activityCommonKitchenRead[configKey]) do
		table.insert(ret, v.itemID)
		if v.foodType == 1 then
			table.insert(ret1, v.itemID)
		else
			table.insert(ret2, v.itemID)
		end
	end
	if name == "normalFoodIDList" or name == "normalFoodIDList_9001699" then
		return ret1
	elseif name == "specFoodIDList" or name == "specFoodIDList_9001699" then
		return ret2
	else
		return ret
	end
end
activityCommonKitchenRead:defineValue("foodIDList", createFunc)
activityCommonKitchenRead:defineValue("normalFoodIDList", createFunc)
activityCommonKitchenRead:defineValue("specFoodIDList", createFunc)
activityCommonKitchenRead:defineValue("foodIDList_9001699", createFunc)
activityCommonKitchenRead:defineValue("normalFoodIDList_9001699", createFunc)
activityCommonKitchenRead:defineValue("specFoodIDList_9001699", createFunc)
function activityCommonKitchenRead.getFoodIDList(activityID)
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001699 then
		return activityCommonKitchenRead.foodIDList_9001699
	else
		return activityCommonKitchenRead.foodIDList
	end
end
function activityCommonKitchenRead.getNormalFoodIDList(activityID)
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001699 then
		return activityCommonKitchenRead.normalFoodIDList_9001699
	else
		return activityCommonKitchenRead.normalFoodIDList
	end
end
function activityCommonKitchenRead.getSpecFoodIDList(activityID)
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001699 then
		return activityCommonKitchenRead.specFoodIDList_9001699
	else
		return activityCommonKitchenRead.specFoodIDList
	end
end
_UPVALUE2_ = createFunc
createFunc[1] = "octopus_kitchen_stage_reward"
createFunc[2] = true
activityCommonKitchenRead:defineValue("octopus_kitchen_stage_reward", createFunc)
activityCommonKitchenRead:defineValue("stageRewardConfig", function()
	local baseConfig = activityCommonKitchenRead.octopus_kitchen_stage_reward
	return activityCommonKitchenRead.getClassTypeConfig(baseConfig)
end)
function _UPVALUE2_()
	local baseConfig = activityCommonKitchenRead.octopus_kitchen_stage_reward
	return activityCommonKitchenRead.getClassTypeConfig(baseConfig)
end
;(function()
	local baseConfig = activityCommonKitchenRead.octopus_kitchen_stage_reward
	return activityCommonKitchenRead.getClassTypeConfig(baseConfig)
end)[1] = "eidal_kitchen_stage_reward"
;(function()
	local baseConfig = activityCommonKitchenRead.octopus_kitchen_stage_reward
	return activityCommonKitchenRead.getClassTypeConfig(baseConfig)
end)[2] = true
activityCommonKitchenRead:defineValue("eidal_kitchen_stage_reward", function()
	local baseConfig = activityCommonKitchenRead.octopus_kitchen_stage_reward
	return activityCommonKitchenRead.getClassTypeConfig(baseConfig)
end)
activityCommonKitchenRead:defineValue("stageRewardConfig_9001699", function()
	local baseConfig = activityCommonKitchenRead.eidal_kitchen_stage_reward
	return activityCommonKitchenRead.getClassTypeConfig(baseConfig)
end)
function activityCommonKitchenRead.getStageRewardConfig(activityID)
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001699 then
		return activityCommonKitchenRead.stageRewardConfig_9001699
	else
		return activityCommonKitchenRead.stageRewardConfig
	end
end
function activityCommonKitchenRead.getStageData(activityID)
	local activityCommonKitchenRead, ret
	local classType = activityCommonKitchenRead.getClassType(activityID)
	local stageRewardConfig = activityCommonKitchenRead.getStageRewardConfig(activityID)
	if not stageRewardConfig[classType] then
		local activityCommonKitchenRead, stageConfig = stageRewardConfig[classType], stageRewardConfig[classType]
	end
	for i, cfg in ipairs(stageConfig) do
		activityCommonKitchenRead = nil
		;(nil).stage = i
		;(nil).point = cfg.point
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		;(nil).rewards = serviceFunctions.tableFormat(cfg.reward, nil)
		table.insert(ret, nil)
	end
	return ret
end
function _UPVALUE2_()
	local baseConfig = activityCommonKitchenRead.eidal_kitchen_stage_reward
	return activityCommonKitchenRead.getClassTypeConfig(baseConfig)
end
;(function()
	local baseConfig = activityCommonKitchenRead.eidal_kitchen_stage_reward
	return activityCommonKitchenRead.getClassTypeConfig(baseConfig)
end)[1] = "octopus_kitchen_task_reward"
;(function()
	local baseConfig = activityCommonKitchenRead.eidal_kitchen_stage_reward
	return activityCommonKitchenRead.getClassTypeConfig(baseConfig)
end)[2] = true
activityCommonKitchenRead:defineValue("octopus_kitchen_task_reward", function()
	local baseConfig = activityCommonKitchenRead.eidal_kitchen_stage_reward
	return activityCommonKitchenRead.getClassTypeConfig(baseConfig)
end)
activityCommonKitchenRead:defineValue("taskRewardConfig", function()
	local baseConfig = activityCommonKitchenRead.octopus_kitchen_task_reward
	_UPVALUE2_ = nil
	;(nil)[1] = "classType"
	;(nil)[2] = "taskType"
	return activityCommonKitchenRead.getKeyListConfig(baseConfig, nil)
end)
function _UPVALUE2_()
	local baseConfig = activityCommonKitchenRead.octopus_kitchen_task_reward
	_UPVALUE2_ = nil
	;(nil)[1] = "classType"
	;(nil)[2] = "taskType"
	return activityCommonKitchenRead.getKeyListConfig(baseConfig, nil)
end
;(function()
	local baseConfig = activityCommonKitchenRead.octopus_kitchen_task_reward
	_UPVALUE2_ = nil
	;(nil)[1] = "classType"
	;(nil)[2] = "taskType"
	return activityCommonKitchenRead.getKeyListConfig(baseConfig, nil)
end)[1] = "eidal_kitchen_task_reward"
;(function()
	local baseConfig = activityCommonKitchenRead.octopus_kitchen_task_reward
	_UPVALUE2_ = nil
	;(nil)[1] = "classType"
	;(nil)[2] = "taskType"
	return activityCommonKitchenRead.getKeyListConfig(baseConfig, nil)
end)[2] = true
activityCommonKitchenRead:defineValue("eidal_kitchen_task_reward", function()
	local baseConfig = activityCommonKitchenRead.octopus_kitchen_task_reward
	_UPVALUE2_ = nil
	;(nil)[1] = "classType"
	;(nil)[2] = "taskType"
	return activityCommonKitchenRead.getKeyListConfig(baseConfig, nil)
end)
activityCommonKitchenRead:defineValue("taskRewardConfig_9001699", function()
	local baseConfig = activityCommonKitchenRead.eidal_kitchen_task_reward
	_UPVALUE2_ = nil
	;(nil)[1] = "classType"
	;(nil)[2] = "taskType"
	return activityCommonKitchenRead.getKeyListConfig(baseConfig, nil)
end)
function activityCommonKitchenRead.getTaskRewardConfig(activityID)
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001699 then
		return activityCommonKitchenRead.taskRewardConfig_9001699
	else
		return activityCommonKitchenRead.taskRewardConfig
	end
end
function activityCommonKitchenRead:getTaskRewardList(activityID, taskType)
	local activityCommonKitchenRead, ret
	local classType = activityCommonKitchenRead.getClassType(activityID)
	local taskRewardConfig = activityCommonKitchenRead.getTaskRewardConfig(activityID)
	if not taskRewardConfig[classType][taskType] then
		local activityCommonKitchenRead, config = taskRewardConfig[classType][taskType], taskRewardConfig[classType][taskType]
	end
	for i, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		ret[v.rewardType] = serviceFunctions.tableFormat(v.reward, nil)
	end
	return ret
end
function _UPVALUE1_()
	local baseConfig = activityCommonKitchenRead.eidal_kitchen_task_reward
	_UPVALUE2_ = nil
	;(nil)[1] = "classType"
	;(nil)[2] = "taskType"
	return activityCommonKitchenRead.getKeyListConfig(baseConfig, nil)
end
;(function()
	local baseConfig = activityCommonKitchenRead.eidal_kitchen_task_reward
	_UPVALUE2_ = nil
	;(nil)[1] = "classType"
	;(nil)[2] = "taskType"
	return activityCommonKitchenRead.getKeyListConfig(baseConfig, nil)
end)[1] = "octopus_kitchen_satisfaction"
activityCommonKitchenRead:defineValue("octopus_kitchen_satisfaction", function()
	local baseConfig = activityCommonKitchenRead.eidal_kitchen_task_reward
	_UPVALUE2_ = nil
	;(nil)[1] = "classType"
	;(nil)[2] = "taskType"
	return activityCommonKitchenRead.getKeyListConfig(baseConfig, nil)
end)
function _UPVALUE1_()
	local baseConfig = activityCommonKitchenRead.eidal_kitchen_task_reward
	_UPVALUE2_ = nil
	;(nil)[1] = "classType"
	;(nil)[2] = "taskType"
	return activityCommonKitchenRead.getKeyListConfig(baseConfig, nil)
end
;(function()
	local baseConfig = activityCommonKitchenRead.eidal_kitchen_task_reward
	_UPVALUE2_ = nil
	;(nil)[1] = "classType"
	;(nil)[2] = "taskType"
	return activityCommonKitchenRead.getKeyListConfig(baseConfig, nil)
end)[1] = "eidal_kitchen_satisfaction"
activityCommonKitchenRead:defineValue("eidal_kitchen_satisfaction", function()
	local baseConfig = activityCommonKitchenRead.eidal_kitchen_task_reward
	_UPVALUE2_ = nil
	;(nil)[1] = "classType"
	;(nil)[2] = "taskType"
	return activityCommonKitchenRead.getKeyListConfig(baseConfig, nil)
end)
function activityCommonKitchenRead.getRewardTypeConfig(activityID, rewardType)
	local _ENV, baseConfig
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001699 then
		baseConfig = activityCommonKitchenRead.eidal_kitchen_satisfaction
	else
		baseConfig = activityCommonKitchenRead.octopus_kitchen_satisfaction
	end
	return baseConfig[rewardType]
end
function activityCommonKitchenRead.getRewardTypeIcon(activityID, rewardType)
	local cfg = activityCommonKitchenRead.getRewardTypeConfig(activityID, rewardType)
	return cfg.icon
end
function activityCommonKitchenRead.getRewardTypeText(activityID, rewardType)
	local cfg = activityCommonKitchenRead.getRewardTypeConfig(activityID, rewardType)
	return i18n(cfg.text)
end
function _UPVALUE2_()
	local baseConfig = activityCommonKitchenRead.eidal_kitchen_task_reward
	_UPVALUE2_ = nil
	;(nil)[1] = "classType"
	;(nil)[2] = "taskType"
	return activityCommonKitchenRead.getKeyListConfig(baseConfig, nil)
end
;(function()
	local baseConfig = activityCommonKitchenRead.eidal_kitchen_task_reward
	_UPVALUE2_ = nil
	;(nil)[1] = "classType"
	;(nil)[2] = "taskType"
	return activityCommonKitchenRead.getKeyListConfig(baseConfig, nil)
end)[1] = "octopus_kitchen_customer"
;(function()
	local baseConfig = activityCommonKitchenRead.eidal_kitchen_task_reward
	_UPVALUE2_ = nil
	;(nil)[1] = "classType"
	;(nil)[2] = "taskType"
	return activityCommonKitchenRead.getKeyListConfig(baseConfig, nil)
end)[2] = true
activityCommonKitchenRead:defineValue("octopus_kitchen_customer", function()
	local baseConfig = activityCommonKitchenRead.eidal_kitchen_task_reward
	_UPVALUE2_ = nil
	;(nil)[1] = "classType"
	;(nil)[2] = "taskType"
	return activityCommonKitchenRead.getKeyListConfig(baseConfig, nil)
end)
function _UPVALUE2_()
	local baseConfig = activityCommonKitchenRead.eidal_kitchen_task_reward
	_UPVALUE2_ = nil
	;(nil)[1] = "classType"
	;(nil)[2] = "taskType"
	return activityCommonKitchenRead.getKeyListConfig(baseConfig, nil)
end
;(function()
	local baseConfig = activityCommonKitchenRead.eidal_kitchen_task_reward
	_UPVALUE2_ = nil
	;(nil)[1] = "classType"
	;(nil)[2] = "taskType"
	return activityCommonKitchenRead.getKeyListConfig(baseConfig, nil)
end)[1] = "eidal_kitchen_customer"
;(function()
	local baseConfig = activityCommonKitchenRead.eidal_kitchen_task_reward
	_UPVALUE2_ = nil
	;(nil)[1] = "classType"
	;(nil)[2] = "taskType"
	return activityCommonKitchenRead.getKeyListConfig(baseConfig, nil)
end)[2] = true
activityCommonKitchenRead:defineValue("eidal_kitchen_customer", function()
	local baseConfig = activityCommonKitchenRead.eidal_kitchen_task_reward
	_UPVALUE2_ = nil
	;(nil)[1] = "classType"
	;(nil)[2] = "taskType"
	return activityCommonKitchenRead.getKeyListConfig(baseConfig, nil)
end)
function activityCommonKitchenRead.getCustomerConfig(activityID, customerType)
	local _ENV, baseConfig
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001699 then
		baseConfig = activityCommonKitchenRead.eidal_kitchen_customer
	else
		baseConfig = activityCommonKitchenRead.octopus_kitchen_customer
	end
	return baseConfig[customerType]
end
function activityCommonKitchenRead.getCustomerName(activityID, customerType)
	local cfg = activityCommonKitchenRead.getCustomerConfig(activityID, customerType)
	return cfg and i18n(cfg.name)
end
function activityCommonKitchenRead.getSpineEffectPath(activityID, customerType)
	local cfg = activityCommonKitchenRead.getCustomerConfig(activityID, customerType)
	local heroID = cfg.heroID or 0
	if 0 < heroID then
		local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
		local info, spineCfg = heroltCtrl:getHeroSpineCfg(heroID)
		if info then
			return spineCfg
		end
	end
	local imageID = cfg.imageID or 0
	if 0 < imageID then
		local lordSpineDef = include("lordSpineDef")
		local info = lordSpineDef.getLordSpineInfo(imageID)
		if info then
			return info.json
		end
	end
end
function activityCommonKitchenRead:getSpineConfig(activityID, customerType)
	local activityCommonKitchenRead, cfg
	local effectPath = activityCommonKitchenRead.getSpineEffectPath(activityID, customerType)
	activityCommonKitchenRead, cfg.effectPath = activityID, effectPath
	activityID[1] = 80
	activityID[2] = 270
	activityID[3] = 50
	activityID[4] = 240
	activityID[5] = 270
	local activityID[6], offsetYConfig = 250, activityID
	local offsetY = offsetYConfig[customerType] or 0
	cfg.offsetY = offsetY
	return cfg
end
function _UPVALUE2_()
	local baseConfig = activityCommonKitchenRead.eidal_kitchen_task_reward
	_UPVALUE2_ = nil
	;(nil)[1] = "classType"
	;(nil)[2] = "taskType"
	return activityCommonKitchenRead.getKeyListConfig(baseConfig, nil)
end
;(function()
	local baseConfig = activityCommonKitchenRead.eidal_kitchen_task_reward
	_UPVALUE2_ = nil
	;(nil)[1] = "classType"
	;(nil)[2] = "taskType"
	return activityCommonKitchenRead.getKeyListConfig(baseConfig, nil)
end)[1] = "octopus_kitchen_achivement"
;(function()
	local baseConfig = activityCommonKitchenRead.eidal_kitchen_task_reward
	_UPVALUE2_ = nil
	;(nil)[1] = "classType"
	;(nil)[2] = "taskType"
	return activityCommonKitchenRead.getKeyListConfig(baseConfig, nil)
end)[2] = true
activityCommonKitchenRead:defineValue("octopus_kitchen_achivement", function()
	local baseConfig = activityCommonKitchenRead.eidal_kitchen_task_reward
	_UPVALUE2_ = nil
	;(nil)[1] = "classType"
	;(nil)[2] = "taskType"
	return activityCommonKitchenRead.getKeyListConfig(baseConfig, nil)
end)
activityCommonKitchenRead:defineValue("achivementConfig", function()
	local _ENV, ret
	for i, v in ipairs(activityCommonKitchenRead.octopus_kitchen_achivement) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		local classType = v.classType
		if not ret[classType] then
			_ENV = ret[classType]
		end
		ret[classType] = ret[classType]
		ret[classType][v.uniqueID] = v
	end
	return ret
end)
function _UPVALUE2_()
	local _ENV, ret
	for i, v in ipairs(activityCommonKitchenRead.octopus_kitchen_achivement) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		local classType = v.classType
		if not ret[classType] then
			_ENV = ret[classType]
		end
		ret[classType] = ret[classType]
		ret[classType][v.uniqueID] = v
	end
	return ret
end
;(function()
	local _ENV, ret
	for i, v in ipairs(activityCommonKitchenRead.octopus_kitchen_achivement) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		local classType = v.classType
		if not ret[classType] then
			_ENV = ret[classType]
		end
		ret[classType] = ret[classType]
		ret[classType][v.uniqueID] = v
	end
	return ret
end)[1] = "eidal_kitchen_achivement"
;(function()
	local _ENV, ret
	for i, v in ipairs(activityCommonKitchenRead.octopus_kitchen_achivement) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		local classType = v.classType
		if not ret[classType] then
			_ENV = ret[classType]
		end
		ret[classType] = ret[classType]
		ret[classType][v.uniqueID] = v
	end
	return ret
end)[2] = true
activityCommonKitchenRead:defineValue("eidal_kitchen_achivement", function()
	local _ENV, ret
	for i, v in ipairs(activityCommonKitchenRead.octopus_kitchen_achivement) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		local classType = v.classType
		if not ret[classType] then
			_ENV = ret[classType]
		end
		ret[classType] = ret[classType]
		ret[classType][v.uniqueID] = v
	end
	return ret
end)
activityCommonKitchenRead:defineValue("achivementConfig_9001699", function()
	local _ENV, ret
	for i, v in ipairs(activityCommonKitchenRead.eidal_kitchen_achivement) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		local classType = v.classType
		if not ret[classType] then
			_ENV = ret[classType]
		end
		ret[classType] = ret[classType]
		ret[classType][v.uniqueID] = v
	end
	return ret
end)
function activityCommonKitchenRead.getAchivementConfig(activityID, uniqueID)
	local _ENV, baseConfig
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001699 then
		baseConfig = activityCommonKitchenRead.achivementConfig_9001699
	else
		baseConfig = activityCommonKitchenRead.achivementConfig
	end
	local classType = activityCommonKitchenRead.getClassType(activityID)
	if not baseConfig[classType] then
		local _ENV, config = baseConfig[classType], baseConfig[classType]
	end
	if not config[uniqueID] then
		_ENV = config[uniqueID]
	end
	return config[uniqueID]
end
activityCommonKitchenRead:defineValue("uniqueIDList", function()
	local baseConfig = activityCommonKitchenRead.octopus_kitchen_achivement
	_UPVALUE1_ = nil
	;(nil)[1] = "classType"
	return activityCommonKitchenRead.getKeyListConfig(baseConfig, nil, "uniqueID")
end)
activityCommonKitchenRead:defineValue("uniqueIDList_9001699", function()
	local baseConfig = activityCommonKitchenRead.eidal_kitchen_achivement
	_UPVALUE1_ = nil
	;(nil)[1] = "classType"
	return activityCommonKitchenRead.getKeyListConfig(baseConfig, nil, "uniqueID")
end)
function activityCommonKitchenRead.getUniqueIDList(activityID)
	local _ENV, baseConfig
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001699 then
		baseConfig = activityCommonKitchenRead.uniqueIDList_9001699
	else
		baseConfig = activityCommonKitchenRead.uniqueIDList
	end
	local classType = activityCommonKitchenRead.getClassType(activityID)
	if not baseConfig[classType] then
		_ENV = baseConfig[classType]
	end
	return baseConfig[classType]
end
activityCommonKitchenRead:defineValue("battlePassConfig_9001699", function()
	local baseConfig = require_data("eidal_kitchen_battlepass", true).data
	local ret = activityCommonKitchenRead.getClassTypeConfig(baseConfig)
	for classType, config in pairs(ret) do
		for __, v in ipairs(config) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.normalReward = serviceFunctions.tableFormat(v.normalReward, nil)
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.advanceReward = serviceFunctions.tableFormat(v.advanceReward, nil)
		end
	end
	return ret
end)
function activityCommonKitchenRead.getBattlePassConfig(activityID)
	local _ENV, baseConfig
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001699 then
		baseConfig = activityCommonKitchenRead.battlePassConfig_9001699
	end
	local classType = activityCommonKitchenRead.getClassType(activityID)
	if not baseConfig[classType] then
		_ENV = baseConfig[classType]
	end
	return baseConfig[classType]
end
function activityCommonKitchenRead.getBattlePassMaxDay(activityID)
	local config = activityCommonKitchenRead.getBattlePassConfig(activityID)
	return #config
end
function _UPVALUE2_()
	local baseConfig = require_data("eidal_kitchen_battlepass", true).data
	local ret = activityCommonKitchenRead.getClassTypeConfig(baseConfig)
	for classType, config in pairs(ret) do
		for __, v in ipairs(config) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.normalReward = serviceFunctions.tableFormat(v.normalReward, nil)
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.advanceReward = serviceFunctions.tableFormat(v.advanceReward, nil)
		end
	end
	return ret
end
;(function()
	local baseConfig = require_data("eidal_kitchen_battlepass", true).data
	local ret = activityCommonKitchenRead.getClassTypeConfig(baseConfig)
	for classType, config in pairs(ret) do
		for __, v in ipairs(config) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.normalReward = serviceFunctions.tableFormat(v.normalReward, nil)
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.advanceReward = serviceFunctions.tableFormat(v.advanceReward, nil)
		end
	end
	return ret
end)[1] = "eidal_kitchen_recharge"
;(function()
	local baseConfig = require_data("eidal_kitchen_battlepass", true).data
	local ret = activityCommonKitchenRead.getClassTypeConfig(baseConfig)
	for classType, config in pairs(ret) do
		for __, v in ipairs(config) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.normalReward = serviceFunctions.tableFormat(v.normalReward, nil)
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.advanceReward = serviceFunctions.tableFormat(v.advanceReward, nil)
		end
	end
	return ret
end)[2] = true
activityCommonKitchenRead:defineValue("eidal_kitchen_recharge", function()
	local baseConfig = require_data("eidal_kitchen_battlepass", true).data
	local ret = activityCommonKitchenRead.getClassTypeConfig(baseConfig)
	for classType, config in pairs(ret) do
		for __, v in ipairs(config) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.normalReward = serviceFunctions.tableFormat(v.normalReward, nil)
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.advanceReward = serviceFunctions.tableFormat(v.advanceReward, nil)
		end
	end
	return ret
end)
function activityCommonKitchenRead.getRechargeCfg(activityID)
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001699 then
		return activityCommonKitchenRead.eidal_kitchen_recharge[1]
	end
end
return activityCommonKitchenRead
