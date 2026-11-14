local luckyWretchRead = include("aAReadClass").new()
function luckyWretchRead.init()
	luckyWretchRead:defineValue("Lucky_twist_egg", function()
		local config = require_once("app." .. LocalTblPath .. ".config_server.lucky_twist_egg")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.lucky_twist_egg", "app." .. LocalTblPath .. ".config_server.lucky_twist_egg"
		for i, v in ipairs(config) do
			if not ret[v.classType] then
				ret[v.classType], _ENV = nil, nil
			end
			table.insert(ret[v.classType], v)
		end
		return ret
	end)
	luckyWretchRead:defineValue("Lucky_twist_egg_accumulation", function()
		local config = require_once("app." .. LocalTblPath .. ".config_server.lucky_twist_egg_accumulation")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.lucky_twist_egg_accumulation", "app." .. LocalTblPath .. ".config_server.lucky_twist_egg_accumulation"
		for i, v in ipairs(config) do
			if not ret[v.classType] then
				ret[v.classType], _ENV = nil, nil
			end
			_ENV = nil
			;(nil).donateScore = v.integral
			;(nil).stageReward = v.reward
			;(nil).stage = v.stage
			table.insert(ret[v.classType], nil)
		end
		return ret
	end)
end
function luckyWretchRead.getStageConfig(classType)
	return luckyWretchRead.Lucky_twist_egg_accumulation[tonumber(classType)]
end
function luckyWretchRead.getPreawardConfig(classType)
	return luckyWretchRead.Lucky_twist_egg[tonumber(classType)]
end
luckyWretchRead.init()
return luckyWretchRead
