local _ENV, crossDecryptionRead.tableTaskReward, _ENV, crossDecryptionRead.tableTaskInfo, _ENV, _ENV, crossDecryptionRead
;(nil).LOGIN_DAY = 50
;(nil).ATTACK_MONSTER_TIMES = 5
;(nil).USE_TROOP_SPEED = 48
;(nil).TRAIN_SOLDIER = 33
;(nil).COLLECT_WOOD_OUT = 46
;(nil).USE_SPEED = 49
;(nil).MONSTERPALACE = 39
;(nil).ESCORT_TIMES = 37
;(nil).DISCOUNT_STORE = 24
;(nil).WISH_RESOURCE = 23
;(nil).ALLIANCE_HELP = 18
;(nil).ALLIANCE_DONATE = 21
;(nil).USE_GOLD = 29
;(nil).COLLECT_WOOD_INNER = 47
;(nil).TRAIN_ARMY_INFANTRY = 12
;(nil).TRAIN_ARMY_ARCHER = 13
;(nil).TRAIN_ARMY_CAVALRY = 14
;(nil).COLLECT_RESOURCE = 51
local (nil).ALLIANCE_STORE_HOUSE, gCrossConditionType = 43, nil
function crossDecryptionRead.init(activityID)
	if gActivityTimeActivityID.NEW_CROSS_MISSION == activityID then
		crossDecryptionRead.taskDes = require("app." .. _G.LocalTblPath .. ".config_client.festival_puzzle_task_des")
		crossDecryptionRead.taskInfo = require("app." .. _G.LocalTblPath .. ".config_server.festival_puzzle_task")
		crossDecryptionRead.taskReward = require("app." .. _G.LocalTblPath .. ".config_server.festival_puzzle_reward")
	elseif gActivityTimeActivityID.CROSS_MISSION == activityID then
		crossDecryptionRead.taskDes = require("app." .. _G.LocalTblPath .. ".config_client.anniversaryuncover_task_des")
		crossDecryptionRead.taskInfo = require("app." .. _G.LocalTblPath .. ".config_server.anniversaryuncover_task")
		crossDecryptionRead.taskReward = require("app." .. _G.LocalTblPath .. ".config_server.anniversaryuncover_reward")
	end
	for k, v in ipairs(crossDecryptionRead.taskInfo) do
		local _ENV, temp
		temp = clone(v)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		temp.Taskreward = serviceFunctions.tableFormat(v.Taskreward, nil)
		table.insert(crossDecryptionRead.tableTaskInfo, temp)
	end
	for k, v in ipairs(crossDecryptionRead.taskReward) do
		local _ENV, temp = clone(v), clone(v)
		temp = clone(v)
		_UPVALUE2_ = temp
		temp[1] = "id"
		temp[2] = "count"
		temp.Reward = serviceFunctions.tableFormat(v.Reward, temp)
		table.insert(crossDecryptionRead.tableTaskReward, temp)
	end
end
function crossDecryptionRead.getTaskDesByID(taskID)
	if crossDecryptionRead.taskDes[taskID] then
		return crossDecryptionRead.taskDes[taskID]
	end
end
function crossDecryptionRead.getTaskInfoByID(taskID)
	local _ENV, temp
	for k, v in ipairs(crossDecryptionRead.tableTaskInfo) do
		if v.Tasktype == taskID then
			return v
		end
	end
end
function crossDecryptionRead.getGuildID(taskID)
	if crossDecryptionRead.taskDes[taskID] then
		return crossDecryptionRead.taskDes[taskID].Guideid
	end
end
function crossDecryptionRead.getRewardByLine(line, activitytypeID)
	for k, v in ipairs(crossDecryptionRead.tableTaskReward) do
		if v.boxIndex == line and v.Activitytype == activitytypeID then
			return v
		end
	end
end
function crossDecryptionRead.getBigReward(activitytypeID)
	local _ENV, temp
	for k, v in ipairs(crossDecryptionRead.tableTaskReward) do
		if v.Rewardtype == 2 and v.Activitytype == activitytypeID then
			return v.Reward
		end
	end
end
function crossDecryptionRead.getTaskCondition(typeID)
	gCrossConditionType = nil
	;(nil)[gCrossConditionType.LOGIN_DAY] = nil
	;(nil)[gCrossConditionType.ATTACK_MONSTER_TIMES] = gNewPLayerTaskType.KILL_MONSTER
	;(nil)[gCrossConditionType.USE_TROOP_SPEED] = nil
	;(nil)[gCrossConditionType.TRAIN_SOLDIER] = gNewPLayerTaskType.TRAIN_SOLDIERS
	;(nil)[gCrossConditionType.COLLECT_WOOD_OUT] = gNewPLayerTaskType.QUICK_TO_WORLD
	;(nil)[gCrossConditionType.USE_SPEED] = nil
	;(nil)[gCrossConditionType.MONSTERPALACE] = gNewPLayerTaskType.COMMON_ACTIVITY_CENTER
	;(nil)[gCrossConditionType.ESCORT_TIMES] = gNewPLayerTaskType.ESCORT_WORLD
	;(nil)[gCrossConditionType.DISCOUNT_STORE] = gNewPLayerTaskType.MYSTICAL_STORE
	;(nil)[gCrossConditionType.WISH_RESOURCE] = gNewPLayerTaskType.MAKE_A_WISH
	;(nil)[gCrossConditionType.ALLIANCE_HELP] = gNewPLayerTaskType.ALLIANCE_HELP
	;(nil)[gCrossConditionType.ALLIANCE_DONATE] = gNewPLayerTaskType.ALLIANCE_DONATE
	;(nil)[gCrossConditionType.USE_GOLD] = nil
	;(nil)[gCrossConditionType.COLLECT_WOOD_INNER] = gNewPLayerTaskType.HARVEST_FARM
	;(nil)[gCrossConditionType.TRAIN_ARMY_INFANTRY] = gEverydayTaskType.TRAIN_ARMY_INFANTRY
	;(nil)[gCrossConditionType.TRAIN_ARMY_ARCHER] = gEverydayTaskType.TRAIN_ARMY_ARCHER
	;(nil)[gCrossConditionType.TRAIN_ARMY_CAVALRY] = gEverydayTaskType.TRAIN_ARMY_CAVALRY
	;(nil)[gCrossConditionType.COLLECT_RESOURCE] = gNewPLayerTaskType.COLLECT_RESOURCE
	local gCrossConditionType, (nil)[gCrossConditionType.ALLIANCE_STORE_HOUSE], conditionFunc = gCrossConditionType.ALLIANCE_STORE_HOUSE, gNewPLayerTaskType.ALLIANCE_STORE_HOUSE, nil
	gCrossConditionType.ALLIANCE_STORE_HOUSE[gCrossConditionType.TRAIN_ARMY_INFANTRY] = BUILDID.CHARIOT_PLANT
	gCrossConditionType.ALLIANCE_STORE_HOUSE[gCrossConditionType.TRAIN_ARMY_ARCHER] = BUILDID.RANGE
	local gCrossConditionType.TRAIN_ARMY_CAVALRY.condition, gCrossConditionType, gCrossConditionType, gCrossConditionType.ALLIANCE_STORE_HOUSE[gCrossConditionType.TRAIN_ARMY_CAVALRY], tpyebid = BUILDID.STABLES, BUILDID.STABLES, gCrossConditionType.TRAIN_ARMY_CAVALRY, BUILDID.STABLES, gCrossConditionType.ALLIANCE_STORE_HOUSE
	gCrossConditionType.TRAIN_ARMY_CAVALRY.questType = conditionFunc[typeID]
	local gCrossConditionType.TRAIN_ARMY_CAVALRY.taskType, ret = "gNewPLayerTaskType", gCrossConditionType.TRAIN_ARMY_CAVALRY
	if typeID == gCrossConditionType.TRAIN_SOLDIER then
		gCrossConditionType.TRAIN_SOLDIER.condition, gCrossConditionType, gCrossConditionType = nil, nil, gCrossConditionType.TRAIN_SOLDIER
		gCrossConditionType.TRAIN_SOLDIER.questType = conditionFunc[typeID]
		gCrossConditionType.TRAIN_SOLDIER.bid = BUILDID.CHARIOT_PLANT
		ret, gCrossConditionType.TRAIN_SOLDIER.taskType = gCrossConditionType.TRAIN_SOLDIER, "gNewPLayerTaskType"
	end
	if typeID == gCrossConditionType.TRAIN_ARMY_INFANTRY or typeID == gCrossConditionType.TRAIN_ARMY_ARCHER or typeID == gCrossConditionType.TRAIN_ARMY_CAVALRY then
		gCrossConditionType.TRAIN_ARMY_CAVALRY.condition, gCrossConditionType, gCrossConditionType = BUILDID.CHARIOT_PLANT, BUILDID.CHARIOT_PLANT, gCrossConditionType.TRAIN_ARMY_CAVALRY
		gCrossConditionType.TRAIN_ARMY_CAVALRY.questType = conditionFunc[typeID]
		gCrossConditionType.TRAIN_ARMY_CAVALRY.bid = tpyebid[typeID]
		ret, gCrossConditionType.TRAIN_ARMY_CAVALRY.taskType = gCrossConditionType.TRAIN_ARMY_CAVALRY, "gEverydayTaskType"
	end
	return ret
end
return crossDecryptionRead
