local kingCompetitionltCtrl = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "competition_stage_target"
	;(nil)[2] = true
	kingCompetitionltCtrl:defineValue("targetStatu", nil)
	kingCompetitionltCtrl:defineValue("rankReward", function()
		local CRRD = require_once("app." .. LocalTblPath .. ".config_server.competition_rank_reward")
		kingCompetitionltCtrl.rankReward, _ENV = "app." .. LocalTblPath .. ".config_server.competition_rank_reward", "app." .. LocalTblPath .. ".config_server.competition_rank_reward"
		local baseData = CRRD
		for k, v in ipairs(baseData) do
			if not kingCompetitionltCtrl.rankReward[v.type] then
				kingCompetitionltCtrl.rankReward[v.type], _ENV = nil, nil
			end
			table.insert(kingCompetitionltCtrl.rankReward[v.type], v)
		end
		for _, v in pairs(kingCompetitionltCtrl.rankReward) do
			table.sort(v, function(a, b)
				return a.index < b.index
			end)
		end
		return kingCompetitionltCtrl.rankReward
	end)
end
init()
function kingCompetitionltCtrl:getRankInfo(type)
	return self.rankReward[type]
end
function kingCompetitionltCtrl:getTargetNum(index)
	local count = 0
	for i, v in ipairs(kingCompetitionltCtrl.targetStatu) do
		if v.type == index then
			count = count + 1
		end
		if 0 < count and v.type ~= index then
			break
		end
	end
	return count
end
function kingCompetitionltCtrl:getTaskInfo(index)
	return kingCompetitionltCtrl.targetStatu[index]
end
function kingCompetitionltCtrl:getRewardByTaskID(index)
	return kingCompetitionltCtrl.targetStatu[index].rewards
end
return kingCompetitionltCtrl
