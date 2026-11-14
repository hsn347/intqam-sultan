local activityCommonRankRead = include("aAReadClass").new()
_UPVALUE2_ = nil
_UPVALUE1_ = nil
_UPVALUE2_, _ENV, (nil).keyList, (nil)[1] = "classType", nil, nil, "classType"
;(nil).tableFormat, (nil).reward, ("classType")[1] = nil, "classType", "id"
;(nil).tableFormat, (nil).reward, ("classType")[2] = nil, "classType", "count"
;(nil)[1] = "seed_footballmatch_reward"
;(nil)[2] = true
activityCommonRankRead:defineValue("seed_footballmatch_reward", nil)
function activityCommonRankRead.getRankRewardConfig(activityID)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = activityShowCtrl:getParamClassType(activityID)
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001736 then
		if not activityCommonRankRead.seed_footballmatch_reward[classType] then
			_ENV = activityCommonRankRead.seed_footballmatch_reward[classType]
		end
		return activityCommonRankRead.seed_footballmatch_reward[classType]
	end
	_ENV = activityCommonRankRead.seed_footballmatch_reward[classType]
	return activityCommonRankRead.seed_footballmatch_reward[classType]
end
function activityCommonRankRead.getRankViewConfig(activityID)
	_ENV = nil
	_ENV = nil
	;(nil).pkgName = "Activity_9001736"
	;(nil).Com_rankTitle = "ui://Activity_9001736/Com_rankTitle"
	;(nil)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001736], (nil).Com_rankSingle = nil, "ui://Activity_9001736/Com_rankSingle"
	local config
	return config[activityID]
end
function activityCommonRankRead.getRankMax(activityID)
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001736 then
		local rankRewardConfig = activityCommonRankRead.getRankRewardConfig(activityID)
		local cfg = rankRewardConfig[#rankRewardConfig]
		local rank = cfg.rank
		return rank[2]
	end
	return 200
end
return activityCommonRankRead
