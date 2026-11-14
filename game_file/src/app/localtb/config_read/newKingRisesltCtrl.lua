local ltBase = include("ltBase")
local newKingRisesltCtrl = class("newKingRisesltCtrl", ltBase, include("aAReadClass").new())
function newKingRisesltCtrl:ctor()
	newKingRisesltCtrl.super.ctor(self)
	newKingRisesltCtrl:init()
end
function newKingRisesltCtrl:init()
	_UPVALUE2_ = nil
	;(nil)[1] = "king_road_info_config"
	;(nil)[2] = true
	self:defineValue("taskdata", nil)
	_UPVALUE1_ = nil
	;(nil)[1] = "king_road_info_view"
	self:defineValue("taskDes", nil)
	_UPVALUE1_ = nil
	;(nil)[1] = "king_road_type_view"
	self:defineValue("taskTypeDes", nil)
end
function newKingRisesltCtrl:getTaskData()
	if not self.taskdata then
		_UPVALUE0_ = self.taskdata
	end
	return self.taskdata
end
function newKingRisesltCtrl:queryTaskData(tasktypeid)
	if self.taskdata then
		for k, v in pairs(self.taskdata) do
			if v.taskID == tasktypeid then
				return v
			end
		end
	end
	return nil
end
function newKingRisesltCtrl:getTotalTaskNum()
	local totalnum = 0
	if self.taskdata and type(self.taskdata) == "table" then
		totalnum = table.nums(self.taskdata)
	end
	return totalnum
end
function newKingRisesltCtrl:getTaskDes(taskId)
	local taskDesItem = self.taskDes[taskId]
	if taskDesItem then
		return i18n(taskDesItem.taskDes)
	end
end
function newKingRisesltCtrl:getTaskTypeDes(setId)
	local taskDesItem = self.taskTypeDes[setId]
	if taskDesItem then
		return i18n(taskDesItem.taskDes)
	end
end
function newKingRisesltCtrl:initConditionFunc()
	if self.isConditionFuncInited then
		return
	end
	local condFuncLoginDay = function(taskdata)
		return nil
	end
	local condFuncBuiling = function(taskdata)
		local condition = taskdata.conditiontarget
		_ENV = nil
		;(nil).condition = condition
		local (nil).questType, ret = gNewPLayerTaskType.BUILD_UPGRADE, nil
		ret.bid = condition[1]
		ret.lv = condition[2]
		return ret
	end
	local condFuncUpgrading = function(taskdata)
		local condition = taskdata.conditiontarget
		_ENV = nil
		;(nil).condition = condition
		local (nil).questType, ret = gNewPLayerTaskType.BUILD_UPGRADE, nil
		ret.bid = condition[1] or BUILDID.CHARIOT_PLANT
		ret.lv = taskdata.conditionnum or 1
		return ret
	end
	local condFuncMonsterLv = function(taskdata)
		local condition = taskdata.conditiontarget
		_ENV = nil
		;(nil).condition = condition
		local (nil).questType, ret = gNewPLayerTaskType.KILL_MONSTER, nil
		ret.lv = condition[1]
		return ret
	end
	local condFuncMonsterTime = function(taskdata)
		local condition = taskdata.conditiontarget
		_ENV = nil
		;(nil).condition = condition
		local (nil).questType, ret = gNewPLayerTaskType.KILL_MONSTER, nil
		ret.lv = condition[1]
		return ret
	end
	local condFuncTrainSoldier = function(taskdata)
		local condition = taskdata.conditiontarget
		_ENV = nil
		;(nil).condition = condition
		local (nil).questType, ret = gNewPLayerTaskType.TRAIN_SOLDIERS, nil
		ret.bid = condition[1] or BUILDID.CHARIOT_PLANT
		ret.lv = condition[2]
		if ret.bid < 100 then
			ret.bid = BUILDID.CHARIOT_PLANT
			ret.lv = condition[1]
		end
		ret.count = taskdata.conditionnum
		return ret
	end
	local condFuncAllianceHelp = function(taskdata)
		local condition = taskdata.conditiontarget
		_ENV = nil
		;(nil).condition = condition
		local (nil).questType, ret = gNewPLayerTaskType.HELP_PLAYER, nil
		return ret
	end
	local condFuncCityResource = function(taskdata)
		local condition = taskdata.conditiontarget
		_ENV = nil
		;(nil).condition = condition
		local (nil).questType, ret = gNewPLayerTaskType.HARVEST_RESOURCE, nil
		return ret
	end
	local condFuncResearchTimes = function(taskdata)
		local condition = taskdata.conditiontarget
		_ENV = nil
		;(nil).condition = condition
		local (nil).questType, ret = gNewPLayerTaskType.RESEARCH_TECHNOLOGY, nil
		ret.technologyId = condition[1]
		return ret
	end
	local condFuncPetAmount = function(taskdata)
		local condition = taskdata.conditiontarget
		_ENV = nil
		;(nil).condition = condition
		local (nil).questType, ret = gNewPLayerTaskType.UNLOCK_PET, nil
		return ret
	end
	local condFuncPetFeedTimes = function(taskdata)
		local condition = taskdata.conditiontarget
		_ENV = nil
		;(nil).condition = condition
		local (nil).questType, ret = gNewPLayerTaskType.UNLOCK_PET, nil
		return ret
	end
	local condFuncPetLevel = function(taskdata)
		local condition = taskdata.conditiontarget
		_ENV = nil
		;(nil).condition = condition
		local (nil).questType, ret = gNewPLayerTaskType.UNLOCK_PET, nil
		return ret
	end
	local condFuncDiscountStore = function(taskdata)
		local condition = taskdata.conditiontarget
		_ENV = nil
		;(nil).condition = condition
		local (nil).questType, ret = gNewPLayerTaskType.MYSTICAL_STORE, nil
		return ret
	end
	local condFuncWishResourc = function(taskdata)
		local condition = taskdata.conditiontarget
		_ENV = nil
		;(nil).condition = condition
		local (nil).questType, ret = gNewPLayerTaskType.MAKE_A_WISH, nil
		return ret
	end
	local condFuncCollectResource = function(taskdata)
		local condition = taskdata.conditiontarget
		_ENV = nil
		;(nil).condition = condition
		local (nil).questType, ret = gNewPLayerTaskType.HARVEST_RESOURCE, nil
		return ret
	end
	local condFuncFighting = function(taskdata)
		local condition = taskdata.conditiontarget
		_ENV = nil
		;(nil).condition = condition
		local (nil).questType, ret = gNewPLayerTaskType.POWRE, nil
		ret.power = condition[1]
		return ret
	end
	local condFuncHeroTrial = function(taskdata)
		local condition = taskdata.conditiontarget
		_ENV = nil
		;(nil).condition = condition
		local (nil).questType, ret = gNewPLayerTaskType.HERO_TRIAL, nil
		ret.heroTrialCount = condition[1]
		return ret
	end
	local condFuncAllianceDonate = function(taskdata)
		local condition = taskdata.conditiontarget
		_ENV = nil
		;(nil).condition = condition
		local (nil).questType, ret = gNewPLayerTaskType.ALLIANCE_DONATE_POINT, nil
		ret.donateHistoryPoint = condition[1]
		return ret
	end
	local condFuncExertTireDness = function(taskdata)
		return nil
	end
	local condFuncWinSiegeBattle = function(taskdata)
		return nil
	end
	local condFuncUseSpeedUp = function(taskdata)
		return nil
	end
	local condFuncTrainUplevSoldier = function(taskdata)
		local condition = taskdata.conditiontarget
		_ENV = nil
		;(nil).condition = condition
		local (nil).questType, ret = gNewPLayerTaskType.TRAIN_SOLDIERS, nil
		ret.bid = BUILDID.CHARIOT_PLANT
		ret.lv = condition[1]
		ret.count = taskdata.conditionnum
		return ret
	end
	local condFuncPyramid = function(taskdata)
		local condition = taskdata.conditiontarget
		_ENV = nil
		;(nil).condition = condition
		local (nil).questType, ret = gNewPLayerTaskType.PYRAMID, nil
		return ret
	end
	local condFuncEscortTimes = function(taskdata)
		local condition = taskdata.conditiontarget
		_ENV = nil
		;(nil).condition = condition
		local (nil).questType, ret = gNewPLayerTaskType.ESCORT, nil
		return ret
	end
	local condFuncEscortPlunder = function(taskdata)
		local condition = taskdata.conditiontarget
		_ENV = nil
		;(nil).condition = condition
		local (nil).questType, ret = gNewPLayerTaskType.ESCORT, nil
		return ret
	end
	local condFuncMonsterPalaceKill = function(taskdata)
		local condition = taskdata.conditiontarget
		_ENV = nil
		;(nil).condition = condition
		local (nil).questType, ret = gNewPLayerTaskType.ESCORT, nil
		return ret
	end
	local condFuncUpgradeResource = function(taskdata)
		local condition = taskdata.conditiontarget
		_ENV = nil
		;(nil).condition = condition
		local (nil).questType, ret = gNewPLayerTaskType.BUILD_UPGRADE, nil
		ret.bid = condition[1] or BUILDID.FARM
		ret.lv = taskdata.conditionnum or 1
		return ret
	end
	_ENV = nil
	;(nil)[gKingRisesConditionTypeDef.LOGIN_DAY] = condFuncLoginDay
	;(nil)[gKingRisesConditionTypeDef.BUILD_BUILDDING] = condFuncBuiling
	;(nil)[gKingRisesConditionTypeDef.BUILD_UPGRADE] = condFuncUpgrading
	;(nil)[gKingRisesConditionTypeDef.ATTACK_MONSTER_LEV] = condFuncMonsterLv
	;(nil)[gKingRisesConditionTypeDef.ATTACK_MONSTER_TIMES] = condFuncMonsterTime
	;(nil)[gKingRisesConditionTypeDef.TRAIN_SOLDIER] = condFuncTrainSoldier
	;(nil)[gKingRisesConditionTypeDef.ALLIANCE_HELP] = condFuncAllianceHelp
	;(nil)[gKingRisesConditionTypeDef.RESEARCH_TIMES] = condFuncResearchTimes
	;(nil)[gKingRisesConditionTypeDef.PET_AMOUNT] = condFuncPetAmount
	;(nil)[gKingRisesConditionTypeDef.PET_FEED_TIMES] = condFuncPetFeedTimes
	;(nil)[gKingRisesConditionTypeDef.PET_LEVEL] = condFuncPetLevel
	;(nil)[gKingRisesConditionTypeDef.DISCOUNT_STORE] = condFuncDiscountStore
	;(nil)[gKingRisesConditionTypeDef.WISH_RESOURCE] = condFuncWishResourc
	;(nil)[gKingRisesConditionTypeDef.HERO_TRIAL] = condFuncHeroTrial
	;(nil)[gKingRisesConditionTypeDef.ALLIANCE_DONATE] = condFuncAllianceDonate
	;(nil)[gKingRisesConditionTypeDef.EXERT_TIREDNESS] = condFuncExertTireDness
	;(nil)[gKingRisesConditionTypeDef.WIN_SIEGE_BATTLE] = condFuncWinSiegeBattle
	;(nil)[gKingRisesConditionTypeDef.TRAIN_UPLEV_SOLDIER] = condFuncTrainUplevSoldier
	;(nil)[gKingRisesConditionTypeDef.PYRAMID] = condFuncPyramid
	;(nil)[gKingRisesConditionTypeDef.ESCORT_TIMES] = condFuncEscortTimes
	;(nil)[gKingRisesConditionTypeDef.ESCORT_PLUNDER] = condFuncEscortPlunder
	;(nil)[gKingRisesConditionTypeDef.MONSTERPALACE_KILL] = condFuncMonsterPalaceKill
	self.conditionFunc, (nil)[gKingRisesConditionTypeDef.BUILD_UPGRADE_RESOURCE] = nil, condFuncUpgradeResource
	self.isConditionFuncInited = true
end
function newKingRisesltCtrl:getTaskCondition(tasktypeid)
	local taskdata = self:queryTaskData(tasktypeid)
	if not taskdata then
		return
	end
	if not self.conditionFunc then
		self:initConditionFunc()
	end
	if self.conditionFunc[taskdata.conditiontype] then
		return self.conditionFunc[taskdata.conditiontype](taskdata)
	end
end
return newKingRisesltCtrl
