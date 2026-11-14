local footballChampionRead = include("aAReadClass").new()
function footballChampionRead.init()
	local createData = function(name)
		footballChampionRead.config_A, footballChampionRead, footballChampionRead.config_D, footballChampionRead = nil, nil, nil, nil
		local tableItemData = require_once("app." .. LocalTblPath .. ".config_server.champion_prediction")
		for i, v in ipairs(tableItemData) do
			if v.type == 1 then
				table.insert(footballChampionRead.config_D, v)
			else
				table.insert(footballChampionRead.config_A, v)
			end
		end
		return footballChampionRead[name]
	end
	footballChampionRead:defineValue("config_D", createData)
	footballChampionRead:defineValue("config_A", createData)
	_UPVALUE2_ = createData
	createData[1] = "country_enumeration"
	createData[2] = true
	footballChampionRead:defineValue("country_enumeration", createData)
	_UPVALUE2_ = createData
	createData[1] = "champion_prediction"
	createData[2] = true
	footballChampionRead:defineValue("champion_prediction", createData)
end
function footballChampionRead.getDayQuestions()
	return footballChampionRead.config_D
end
function footballChampionRead.getGameQuestions()
	return footballChampionRead.config_A
end
function footballChampionRead.getAnswerConfig(index)
	return footballChampionRead.country_enumeration[index]
end
function footballChampionRead.getConfigByIndex(index)
	return footballChampionRead.champion_prediction[index]
end
function footballChampionRead.getAwardByType(type)
	if type == 1 then
		return footballChampionRead.config_D[1].right_reward, footballChampionRead.config_D[1].mistake_reward
	else
		return footballChampionRead.config_A[1].right_reward, footballChampionRead.config_A[1].mistake_reward
	end
end
footballChampionRead.init()
return footballChampionRead
