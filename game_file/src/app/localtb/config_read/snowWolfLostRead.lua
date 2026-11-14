local snowWolfLostRead = include("aAReadClass").new()
function snowWolfLostRead.init()
	snowWolfLostRead:defineValue("snowWolfTaskTimeConfig", function()
		local cfgTask = require_once("app." .. LocalTblPath .. ".config_server.snowwolf_lost_config")
		snowWolfLostRead.snowWolfTaskTimeConfig, _ENV = "app." .. LocalTblPath .. ".config_server.snowwolf_lost_config", "app." .. LocalTblPath .. ".config_server.snowwolf_lost_config"
		for _, v in ipairs(cfgTask) do
			snowWolfLostRead.snowWolfTaskTimeConfig[v.questId] = v.time
		end
		return snowWolfLostRead.snowWolfTaskTimeConfig
	end)
	snowWolfLostRead:defineValue("iceDragonTaskTimeConfig", function()
		local cfgTask = require_once("app." .. LocalTblPath .. ".config_server.icedragon_lost_config")
		snowWolfLostRead.iceDragonTaskTimeConfig, _ENV = "app." .. LocalTblPath .. ".config_server.icedragon_lost_config", "app." .. LocalTblPath .. ".config_server.icedragon_lost_config"
		for _, v in ipairs(cfgTask) do
			snowWolfLostRead.iceDragonTaskTimeConfig[v.questId] = v.time
		end
		return snowWolfLostRead.iceDragonTaskTimeConfig
	end)
	snowWolfLostRead:defineValue("legendOfPegasusTaskTimeConfig", function()
		local cfgTask = require_once("app." .. LocalTblPath .. ".config_server.legend_of_pegasus")
		snowWolfLostRead.legendOfPegasusTaskTimeConfig, _ENV = "app." .. LocalTblPath .. ".config_server.legend_of_pegasus", "app." .. LocalTblPath .. ".config_server.legend_of_pegasus"
		for _, v in ipairs(cfgTask) do
			snowWolfLostRead.legendOfPegasusTaskTimeConfig[v.questId] = v.time
		end
		return snowWolfLostRead.legendOfPegasusTaskTimeConfig
	end)
	snowWolfLostRead:defineValue("activity9001602TimeConfig", function()
		local cfgTask = require_once("app." .. LocalTblPath .. ".config_server.firedragon_of_anger")
		snowWolfLostRead.activity9001602TimeConfig, _ENV = "app." .. LocalTblPath .. ".config_server.firedragon_of_anger", "app." .. LocalTblPath .. ".config_server.firedragon_of_anger"
		for _, v in ipairs(cfgTask) do
			snowWolfLostRead.activity9001602TimeConfig[v.questId] = v.time
		end
		return snowWolfLostRead.activity9001602TimeConfig
	end)
	snowWolfLostRead:defineValue("activity9001696TimeConfig", function()
		local cfgTask = require_once("app." .. LocalTblPath .. ".config_server.firedragon_of_anger_2025")
		snowWolfLostRead.activity9001696TimeConfig, _ENV = "app." .. LocalTblPath .. ".config_server.firedragon_of_anger_2025", "app." .. LocalTblPath .. ".config_server.firedragon_of_anger_2025"
		for _, v in ipairs(cfgTask) do
			snowWolfLostRead.activity9001696TimeConfig[v.questId] = v.time
		end
		return snowWolfLostRead.activity9001696TimeConfig
	end)
	snowWolfLostRead:defineValue("summonReward", function()
		snowWolfLostRead.summonReward, snowWolfLostRead = nil, nil
		local cfgs = require_once("app." .. LocalTblPath .. ".config_server.world_boss_summon_reward")
		for _, v in pairs(cfgs) do
			if not snowWolfLostRead.summonReward[v.bossID] then
				snowWolfLostRead.summonReward[v.bossID], snowWolfLostRead = nil, nil
			end
			snowWolfLostRead.summonReward[v.bossID][v.level] = v
		end
		return snowWolfLostRead.summonReward
	end)
end
function snowWolfLostRead.getTaskTimeByQuestId(questId)
	return snowWolfLostRead.snowWolfTaskTimeConfig[questId]
end
function snowWolfLostRead.getLegendOfPegasusTaskTimeByQuestId(questId)
	return snowWolfLostRead.legendOfPegasusTaskTimeConfig[questId]
end
function snowWolfLostRead.getActivityTaskTimeByQuestId(questId, activityID)
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001602 then
		return snowWolfLostRead.activity9001602TimeConfig[questId]
	elseif activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001696 then
		return snowWolfLostRead.activity9001696TimeConfig[questId]
	end
end
function snowWolfLostRead.getIceDragonTaskTimeByQuestId(questId)
	return snowWolfLostRead.iceDragonTaskTimeConfig[questId]
end
function snowWolfLostRead.getWorldBossSummonReward(bossID, level)
	return snowWolfLostRead.summonReward[bossID][level]
end
snowWolfLostRead.init()
return snowWolfLostRead
