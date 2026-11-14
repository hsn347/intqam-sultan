local ramadanWorldExplorerRead = include("aAReadClass").new()
function ramadanWorldExplorerRead.init()
	ramadanWorldExplorerRead:defineValue("taskDescribe", function(name)
		local config = require_once("app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config", "app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config"
		for _, v in ipairs(config) do
			ret[v.Type] = v.questkey
		end
		return ret
	end)
	function _UPVALUE2_(name)
		local config = require_once("app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config", "app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config"
		for _, v in ipairs(config) do
			ret[v.Type] = v.questkey
		end
		return ret
	end
	;(function(name)
		local config = require_once("app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config", "app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config"
		for _, v in ipairs(config) do
			ret[v.Type] = v.questkey
		end
		return ret
	end)[1] = "ramadan_worldexplorer_quest"
	;(function(name)
		local config = require_once("app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config", "app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config"
		for _, v in ipairs(config) do
			ret[v.Type] = v.questkey
		end
		return ret
	end)[2] = true
	ramadanWorldExplorerRead:defineValue("taskConfig", function(name)
		local config = require_once("app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config", "app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config"
		for _, v in ipairs(config) do
			ret[v.Type] = v.questkey
		end
		return ret
	end)
	function _UPVALUE2_(name)
		local config = require_once("app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config", "app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config"
		for _, v in ipairs(config) do
			ret[v.Type] = v.questkey
		end
		return ret
	end
	;(function(name)
		local config = require_once("app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config", "app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config"
		for _, v in ipairs(config) do
			ret[v.Type] = v.questkey
		end
		return ret
	end)[1] = "ramadan_worldexplorer_plan"
	;(function(name)
		local config = require_once("app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config", "app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config"
		for _, v in ipairs(config) do
			ret[v.Type] = v.questkey
		end
		return ret
	end)[2] = true
	ramadanWorldExplorerRead:defineValue("processReward", function(name)
		local config = require_once("app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config", "app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config"
		for _, v in ipairs(config) do
			ret[v.Type] = v.questkey
		end
		return ret
	end)
	function _UPVALUE2_(name)
		local config = require_once("app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config", "app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config"
		for _, v in ipairs(config) do
			ret[v.Type] = v.questkey
		end
		return ret
	end
	;(function(name)
		local config = require_once("app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config", "app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config"
		for _, v in ipairs(config) do
			ret[v.Type] = v.questkey
		end
		return ret
	end)[1] = "ramadan_worldexplorer_answer"
	;(function(name)
		local config = require_once("app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config", "app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config"
		for _, v in ipairs(config) do
			ret[v.Type] = v.questkey
		end
		return ret
	end)[2] = true
	ramadanWorldExplorerRead:defineValue("answerConfig", function(name)
		local config = require_once("app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config", "app." .. LocalTblPath .. ".config_client.ramadan_worldexplorer_config"
		for _, v in ipairs(config) do
			ret[v.Type] = v.questkey
		end
		return ret
	end)
end
function ramadanWorldExplorerRead.getAnswerConfig()
	return ramadanWorldExplorerRead.answerConfig
end
function ramadanWorldExplorerRead.getTaskDescribeByType(taskType)
	return ramadanWorldExplorerRead.taskDescribe[taskType]
end
function ramadanWorldExplorerRead.getTaskRewardByTaskID(taskID)
	return ramadanWorldExplorerRead.taskConfig[taskID].reward
end
function ramadanWorldExplorerRead.getProcessReward()
	return ramadanWorldExplorerRead.processReward
end
function ramadanWorldExplorerRead.getMaxProgress()
	return ramadanWorldExplorerRead.processReward[#ramadanWorldExplorerRead.processReward].plan
end
function ramadanWorldExplorerRead.getProgressInfoByIndex(index)
	return ramadanWorldExplorerRead.processReward[index]
end
ramadanWorldExplorerRead.init()
return ramadanWorldExplorerRead
