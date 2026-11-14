local ramadanRankRewardRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	ramadanRankRewardRead:defineValue("rewardAry", function()
		local rankReward = require_once("app." .. LocalTblPath .. ".config_server.acyivity_rank_reward")
		ramadanRankRewardRead.rewardAry, _ENV = "app." .. LocalTblPath .. ".config_server.acyivity_rank_reward", "app." .. LocalTblPath .. ".config_server.acyivity_rank_reward"
		for i, item in pairs(rankReward) do
			for j, id in pairs(item.activityID) do
				if not ramadanRankRewardRead.rewardAry[tostring(id)] then
					_ENV = ramadanRankRewardRead.rewardAry[tostring(id)]
				end
				ramadanRankRewardRead.rewardAry[tostring(id)] = ramadanRankRewardRead.rewardAry[tostring(id)]
				local beginRank = item.rank[1]
				local endRank = item.rank[2] or beginRank
				for i = beginRank, endRank do
					ramadanRankRewardRead.rewardAry[tostring(id)][i] = item.reward
				end
			end
		end
		return ramadanRankRewardRead.rewardAry
	end)
end
init()
function ramadanRankRewardRead.getReward(activityID, rank)
	local items = ramadanRankRewardRead.rewardAry[tostring(activityID)][rank]
	if items then
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		return serviceFunctions.tableFormat(items, nil)
	end
	ramadanRankRewardRead = serviceFunctions.tableFormat
	return serviceFunctions.tableFormat
end
return ramadanRankRewardRead
