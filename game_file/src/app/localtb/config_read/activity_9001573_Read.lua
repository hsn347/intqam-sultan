local activity_9001573_Read = include("aAReadClass").new()
_ENV = "aAReadClass"
;("aAReadClass").READY1 = 0
;("aAReadClass").BATTLE1 = 1
;("aAReadClass").READY2 = 2
;("aAReadClass").BATTLE2 = 3
;("aAReadClass").READY3 = 4
;("aAReadClass").BATTLE3 = 5
;("aAReadClass").READY4 = 6
;("aAReadClass").BATTLE4 = 7
_ENV, gNebulaDefenceWarStage, ("aAReadClass").OVER = "aAReadClass", "aAReadClass", 8
;("aAReadClass").BATTLE = 1
_ENV, gNebulaDefenceWarBuildStatusExtra, ("aAReadClass").READY = "aAReadClass", "aAReadClass", 2
;("aAReadClass").NORMAL = 1
gNebulaDefenceWarBuildStatus, ("aAReadClass").RUIN = "aAReadClass", 2
_UPVALUE2_ = nil
;(nil)[1] = "celestial_defense_map_mark"
;(nil)[2] = true
activity_9001573_Read:defineValue("celestial_defense_map_mark", nil)
_UPVALUE2_ = nil
;(nil)[1] = "celestial_defense_build"
;(nil)[2] = true
activity_9001573_Read:defineValue("celestial_defense_build", nil)
_UPVALUE2_ = nil
;(nil)[1] = "celestial_defense_reward"
;(nil)[2] = true
activity_9001573_Read:defineValue("celestial_defense_reward", nil)
_UPVALUE2_ = nil
;(nil)[1] = "celestial_defense_degree"
;(nil)[2] = true
activity_9001573_Read:defineValue("celestial_defense_degree", nil)
activity_9001573_Read:defineValue("builds", function()
	local _ENV, builds
	for _, v in ipairs(activity_9001573_Read.celestial_defense_build) do
		builds[v.buildID] = v
	end
	return builds
end)
activity_9001573_Read:defineValue("rewards", function()
	local _ENV, rewards
	for _, v in ipairs(activity_9001573_Read.celestial_defense_reward) do
		if not rewards[v.rewardType] then
			_ENV = rewards[v.rewardType]
		end
		rewards[v.rewardType] = rewards[v.rewardType]
		table.insert(rewards[v.rewardType], v)
		_UPVALUE2_ = v
		v[1] = "id"
		v[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, v)
		_UPVALUE2_ = v
		v[1] = "id"
		v[2] = "count"
		v.diffReward = serviceFunctions.tableFormat(v.diffReward, v)
	end
	return rewards
end)
function activity_9001573_Read.getMarkCfgs()
	return activity_9001573_Read.celestial_defense_map_mark
end
function activity_9001573_Read.getMarkNums()
	return #activity_9001573_Read.celestial_defense_map_mark
end
function activity_9001573_Read.getCampMarkIcon(index)
	local cfg = activity_9001573_Read.celestial_defense_map_mark[index]
	return cfg and cfg.markIcon
end
function activity_9001573_Read.getCampMarkName(index)
	local cfg = activity_9001573_Read.celestial_defense_map_mark[index]
	return cfg and i18n(cfg.markName) or ""
end
function activity_9001573_Read.getBuilds()
	return activity_9001573_Read.builds
end
function activity_9001573_Read.getBuild(buildID)
	return activity_9001573_Read.builds[tonumber(buildID)]
end
function activity_9001573_Read.getGateCfg()
	for _, v in pairs(activity_9001573_Read.builds) do
		if v.buildType == 3 then
			return v
		end
	end
end
function activity_9001573_Read.getBuildName(buildID)
	local cfg = activity_9001573_Read.builds[tonumber(buildID)]
	return cfg and i18n(cfg.buildName) or ""
end
function activity_9001573_Read.getBuildMailImg(buildID)
	local cfg = activity_9001573_Read.builds[tonumber(buildID)]
	return cfg and cfg.mailIcon or "qlzjt_full.png"
end
function activity_9001573_Read.getBuildImg(buildID)
	local cfg = activity_9001573_Read.builds[tonumber(buildID)]
	return cfg and cfg.buildPic or ""
end
function activity_9001573_Read.getBuildLodImg(buildID)
	local cfg = activity_9001573_Read.builds[tonumber(buildID)]
	return cfg and cfg.imageLod or nil
end
function activity_9001573_Read.getBuildLodIcon(buildID)
	local cfg = activity_9001573_Read.builds[tonumber(buildID)]
	return cfg and cfg.iconLod or nil
end
function activity_9001573_Read.getPowerRatio(lv)
	local cfg = activity_9001573_Read.celestial_defense_degree[lv]
	return cfg and cfg.powerRatio or 0
end
function activity_9001573_Read.getRewardRatio(lv)
	local cfg = activity_9001573_Read.celestial_defense_degree[lv]
	return cfg and cfg.rewardRatio or 0
end
function activity_9001573_Read.getRewardsByType(_type)
	return activity_9001573_Read.rewards[_type]
end
return activity_9001573_Read
