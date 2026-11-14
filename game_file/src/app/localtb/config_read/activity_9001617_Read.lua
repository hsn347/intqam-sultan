local activity_9001617_Read = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "holy_treasury_reward"
;(nil)[2] = true
activity_9001617_Read:defineValue("holy_treasury_reward", nil)
activity_9001617_Read:defineValue("rewardShowList", function()
	local _ENV, rewardIDMap
	for __, cfg in ipairs(activity_9001617_Read.holy_treasury_reward) do
		_UPVALUE3_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		;(nil)[3] = "weight"
		local rewards = serviceFunctions.tableFormat(cfg.reward, nil)
		for __, v in ipairs(rewards) do
			rewardIDMap[v.id] = true
		end
	end
	local rewardIDList = table.keys(rewardIDMap)
	table.sort(rewardIDList, function(a, b)
		return a < b
	end)
	local _ENV, ret = table.sort, table.sort
	for __, itemID in ipairs(rewardIDList) do
		_ENV = "count"
		;("count").id = itemID
		table.insert(ret, "count")
	end
	return ret
end)
function activity_9001617_Read.getRewardShowList()
	return activity_9001617_Read.rewardShowList
end
return activity_9001617_Read
