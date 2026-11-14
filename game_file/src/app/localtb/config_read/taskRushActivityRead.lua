local taskRushActivityRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "task_rush_activity_bonus"
;(nil)[2] = true
taskRushActivityRead:defineValue("bonus", nil)
_UPVALUE2_ = nil
;(nil)[1] = "task_rush_activity_schedule"
;(nil)[2] = true
taskRushActivityRead:defineValue("schedule", nil)
_UPVALUE1_ = nil
;(nil)[1] = "task_rush_group_name"
taskRushActivityRead:defineValue("groupname", nil)
function taskRushActivityRead.getGroupName(id)
	return i18n(taskRushActivityRead.groupname[id].group_name)
end
function taskRushActivityRead.getExtraBonus(activityID)
	local activityID = activityID or gActivityTimeActivityID.COMMON_NDAYS_TASKRUSH_ACTIITY
	local classType = SoraDGetActivityClassType(activityID)
	for k, v in ipairs(taskRushActivityRead.bonus) do
		if v.activity_id == activityID and v.classType == classType then
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			return serviceFunctions.tableFormat(v.bonus_id, nil)
		end
	end
end
function taskRushActivityRead.getExtraBonusDays(activityID)
	local activityID = activityID or gActivityTimeActivityID.COMMON_NDAYS_TASKRUSH_ACTIITY
	local classType = SoraDGetActivityClassType(activityID)
	for k, v in ipairs(taskRushActivityRead.bonus) do
		if v.activity_id == activityID and v.classType == classType then
			return v.effective_days
		end
	end
end
function taskRushActivityRead.getGroupID(day, activityID)
	local activityID = activityID or gActivityTimeActivityID.COMMON_NDAYS_TASKRUSH_ACTIITY
	local classType = SoraDGetActivityClassType(activityID)
	local _ENV, ret = activityID, activityID
	for k, v in ipairs(taskRushActivityRead.schedule) do
		if v.day == day and v.activity_id == activityID and v.classType == classType then
			table.insert(ret, v.group_id)
		end
	end
	table.sort(ret, function(a, b)
		return a < b
	end)
	return ret
end
function taskRushActivityRead.getQuestByDay(day, activityID)
	local activityID = activityID or gActivityTimeActivityID.COMMON_NDAYS_TASKRUSH_ACTIITY
	local classType = SoraDGetActivityClassType(activityID)
	local _ENV, questList = activityID, activityID
	for k, v in ipairs(taskRushActivityRead.schedule) do
		if v.day == day and v.activity_id == activityID and v.classType == classType then
			for ki, vi in ipairs(v.quest_id) do
				table.insert(questList, vi)
			end
		end
	end
	return questList
end
function taskRushActivityRead.getQuest(day, groupID, activityID)
	local activityID = activityID or gActivityTimeActivityID.COMMON_NDAYS_TASKRUSH_ACTIITY
	local classType = SoraDGetActivityClassType(activityID)
	for k, v in ipairs(taskRushActivityRead.schedule) do
		if v.day == day and v.group_id == groupID and v.activity_id == activityID and v.classType == classType then
			return v.quest_id
		end
	end
end
function taskRushActivityRead.getTotalQuestNum(activityID)
	local activityID = activityID or gActivityTimeActivityID.COMMON_NDAYS_TASKRUSH_ACTIITY
	local classType = SoraDGetActivityClassType(activityID)
	local num = 0
	for k, v in ipairs(taskRushActivityRead.schedule) do
		if v.activity_id == activityID and v.classType == classType then
			num = num + #v.quest_id
		end
	end
	return num
end
function taskRushActivityRead.getActivityQuestMaxDay(activityID)
	local activityID = activityID or gActivityTimeActivityID.COMMON_NDAYS_TASKRUSH_ACTIITY
	local classType = SoraDGetActivityClassType(activityID)
	local days = 0
	for k, v in ipairs(taskRushActivityRead.schedule) do
		if days < v.day and v.activity_id == activityID and v.classType == classType then
			days = v.day
		end
	end
	return days
end
function taskRushActivityRead.getActivityQuestEffectTime(activityId)
	local activityQuestMaxDay = taskRushActivityRead.getActivityQuestMaxDay(activityId)
	local effectiveDays = taskRushActivityRead.getExtraBonusDays() or 0
	local activityQuestEffctTime = activityQuestMaxDay * 86400 + effectiveDays * 86400
	return activityQuestEffctTime
end
return taskRushActivityRead
