local windTowerRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	windTowerRead:defineValue("taskTimeConfig", function()
		windTowerRead.taskTimeConfig, windTowerRead = nil, nil
		local cfgTask = require_once("app." .. _G.LocalTblPath .. ".config_server.windtower_action_config")
		for _, v in ipairs(cfgTask) do
			windTowerRead.taskTimeConfig[v.questId] = v.time
		end
		return windTowerRead.taskTimeConfig
	end)
end
function windTowerRead.getTaskTimeByQuestId(questId)
	init()
	return windTowerRead.taskTimeConfig[questId] or 0
end
return windTowerRead
