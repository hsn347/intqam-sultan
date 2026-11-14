local heroNewTrialRead = include("aAReadClass").new()
heroNewTrialRead:defineValue("taskList", function()
	local baseConfig = require_data("sss_hero_experience", true).data
	return heroNewTrialRead.getClassTypeConfig(baseConfig, "heroId")
end)
function heroNewTrialRead.getTaskList(heroId)
	if not heroNewTrialRead.taskList[heroId] then
		heroNewTrialRead = heroNewTrialRead.taskList[heroId]
	end
	return heroNewTrialRead.taskList[heroId]
end
function heroNewTrialRead.getTaskId(heroId, stage)
	local taskList = heroNewTrialRead.getTaskList(heroId)
	local cfg = taskList[stage]
	return cfg and cfg.taskId
end
function heroNewTrialRead.getStageMax(heroId)
	local taskList = heroNewTrialRead.getTaskList(heroId)
	return #taskList
end
function heroNewTrialRead.unlockTrial(heroId)
	return heroNewTrialRead.getStageMax(heroId) > 0
end
function _UPVALUE1_()
	local baseConfig = require_data("sss_hero_experience", true).data
	return heroNewTrialRead.getClassTypeConfig(baseConfig, "heroId")
end
;(function()
	local baseConfig = require_data("sss_hero_experience", true).data
	return heroNewTrialRead.getClassTypeConfig(baseConfig, "heroId")
end)[1] = "sss_hero_afk_group"
heroNewTrialRead:defineValue("sss_hero_afk_group", function()
	local baseConfig = require_data("sss_hero_experience", true).data
	return heroNewTrialRead.getClassTypeConfig(baseConfig, "heroId")
end)
function heroNewTrialRead.getRewardGroup()
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	local list = heroCtrl:getHeroSSS()
	local rewardGroup = 1
	for _, v in ipairs(heroNewTrialRead.sss_hero_afk_group) do
		if #list >= v.heroNum[1] and #list <= v.heroNum[2] then
			rewardGroup = v.rewardGroup
			break
		end
	end
	return rewardGroup
end
heroNewTrialRead:defineValue("displayedRewardConfig", function()
	local baseConfig = require_data("sss_hero_afk", true).data
	local config = heroNewTrialRead.getClassTypeConfig(baseConfig, "rewardGroup")
	local _ENV, ret = baseConfig, baseConfig
	for group, cfgs in pairs(config) do
		ret[group], _ENV = nil, nil
		for i = #cfgs, 1, -1 do
			local cfg = cfgs[i]
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local rewards = serviceFunctions.tableFormat(cfg.displayedReward, nil)
			table.insertto(ret[group], rewards)
		end
	end
	return ret
end)
function heroNewTrialRead.getDisplayedReward(heroId)
	local rewardGroup = heroNewTrialRead.getRewardGroup()
	return heroNewTrialRead.displayedRewardConfig[rewardGroup]
end
return heroNewTrialRead
