local newFeedbackWeekRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "recharge_new_user"
	;(nil)[2] = true
	newFeedbackWeekRead:defineValue("config", nil)
	local createData = function(name)
		newFeedbackWeekRead.bigReward, newFeedbackWeekRead, newFeedbackWeekRead.TasConfig, newFeedbackWeekRead = nil, nil, nil, nil
		newFeedbackWeekRead.maxQuota = 0
		newFeedbackWeekRead, newFeedbackWeekRead.bigRewardId = nil, 0
		;(nil).noClaim = 1
		;(nil).noReach = 2
		local (nil).claimed, giftStatus = 3, nil
		newFeedbackWeekRead.maxQuota = 0
		for k, v in ipairs(newFeedbackWeekRead.config) do
			if v.amount > newFeedbackWeekRead.maxQuota then
				newFeedbackWeekRead.maxQuota = v.amount
			end
			if v.final_reward == 0 then
				local newFeedbackWeekRead, tempTable = v.final_reward, v.final_reward
				tempTable.taskID = v.Index
				tempTable.amount = v.amount
				tempTable.profit = v.profit or 100
				_UPVALUE2_ = nil
				;(nil)[1] = "id"
				;(nil)[2] = "count"
				tempTable.Reward = serviceFunctions.tableFormat(v.reward, nil)
				tempTable.status = giftStatus.noReach
				table.insert(newFeedbackWeekRead.TasConfig, tempTable)
			elseif v.final_reward == 1 then
				newFeedbackWeekRead.bigRewardId = v.Index
				local newFeedbackWeekRead, tempTable = v.Index, v.Index
				newFeedbackWeekRead.bigReward.taskID = v.Index
				newFeedbackWeekRead.bigReward.amount = v.amount
				_UPVALUE2_ = "id"
				;("id")[1] = "id"
				;("id")[2] = "count"
				newFeedbackWeekRead.bigReward.Reward = serviceFunctions.tableFormat(v.reward, "id")
				newFeedbackWeekRead.bigReward.status = giftStatus.noReach
			end
		end
		if name == "TasConfig" then
			return newFeedbackWeekRead.TasConfig
		elseif name == "bigReward" then
			return newFeedbackWeekRead.bigReward
		elseif name == "maxQuota" then
			return newFeedbackWeekRead.maxQuota
		elseif name == "bigRewardId" then
			return newFeedbackWeekRead.bigRewardId
		end
	end
	newFeedbackWeekRead:defineValue("TasConfig", createData)
	newFeedbackWeekRead:defineValue("bigReward", createData)
	newFeedbackWeekRead:defineValue("maxQuota", createData)
	newFeedbackWeekRead:defineValue("bigRewardId", createData)
end
init()
function newFeedbackWeekRead.getTaskConfig()
	return newFeedbackWeekRead.TasConfig
end
function newFeedbackWeekRead.getBiggestQuota()
	return newFeedbackWeekRead.maxQuota
end
function newFeedbackWeekRead.getBigRewardId()
	return newFeedbackWeekRead.bigRewardId
end
function newFeedbackWeekRead.getBigReward()
	return newFeedbackWeekRead.bigReward.Reward
end
function newFeedbackWeekRead.getAmountById(id)
	for k, v in ipairs(newFeedbackWeekRead.TasConfig) do
		if v.taskID == id then
			return v.amount
		end
	end
end
function newFeedbackWeekRead.getRewardById(id)
	for k, v in ipairs(newFeedbackWeekRead.TasConfig) do
		if v.taskID == id then
			return v.Reward
		end
	end
end
return newFeedbackWeekRead
