local lostRuinsRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	lostRuinsRead:defineValue("taskTimeConfig", function()
		lostRuinsRead.taskTimeConfig, lostRuinsRead = nil, nil
		local cfgTask = require_once("app." .. LocalTblPath .. ".config_server.lost_ruins_config")
		for _, v in ipairs(cfgTask) do
			lostRuinsRead.taskTimeConfig[v.questId] = v.time
		end
		return lostRuinsRead.taskTimeConfig
	end)
end
init()
function lostRuinsRead.getTaskTimeByQuestId(questId)
	return lostRuinsRead.taskTimeConfig[questId]
end
return lostRuinsRead
