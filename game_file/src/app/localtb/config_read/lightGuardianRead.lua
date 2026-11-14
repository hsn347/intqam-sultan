local lightGuardianRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "radiance_guardian_stagerewards"
	;(nil)[2] = true
	lightGuardianRead:defineValue("stageReward", nil)
	_ENV = nil
	;(nil)[1] = "radiance_guardian_rankreward"
	;(nil)[2] = true
	lightGuardianRead:defineValue("rankReward", nil)
	local createData = function(name)
		lightGuardianRead.typeScore_3, lightGuardianRead, lightGuardianRead.typeScore_2, lightGuardianRead, lightGuardianRead.typeScore_1, lightGuardianRead = nil, nil, nil, nil, nil, nil
		local scoreList = require_once("app." .. LocalTblPath .. ".config_server.radiance_guardian_scoreconf")
		for i, v in ipairs(scoreList) do
			if v.type == 1 then
				table.insert(lightGuardianRead.typeScore_1, v)
			elseif v.type == 3 then
				table.insert(lightGuardianRead.typeScore_3, v)
			elseif v.type == 4 then
				table.insert(lightGuardianRead.typeScore_2, 3, v)
			else
				table.insert(lightGuardianRead.typeScore_2, 1, v)
				table.insert(lightGuardianRead.typeScore_2, 2, v)
			end
		end
		if name == "typeScore_1" then
			return lightGuardianRead.typeScore_1
		elseif name == "typeScore_2" then
			return lightGuardianRead.typeScore_2
		elseif name == "typeScore_3" then
			return lightGuardianRead.typeScore_3
		end
	end
	lightGuardianRead:defineValue("typeScore_1", createData)
	lightGuardianRead:defineValue("typeScore_2", createData)
	lightGuardianRead:defineValue("typeScore_3", createData)
end
init()
function lightGuardianRead.getRankReward()
	if not lightGuardianRead.rankReward then
		lightGuardianRead = lightGuardianRead.rankReward
	end
	return lightGuardianRead.rankReward
end
function lightGuardianRead.getFirstRankReward()
	if not lightGuardianRead.rankReward[1].reward then
		lightGuardianRead = lightGuardianRead.rankReward[1].reward
	end
	return lightGuardianRead.rankReward[1].reward
end
function lightGuardianRead.getStageReward()
	return lightGuardianRead.stageReward
end
function lightGuardianRead.getTypeScore_1()
	if not lightGuardianRead.typeScore_1 then
		lightGuardianRead = lightGuardianRead.typeScore_1
	end
	return lightGuardianRead.typeScore_1
end
function lightGuardianRead.getTypeScore_2()
	if not lightGuardianRead.typeScore_2 then
		lightGuardianRead = lightGuardianRead.typeScore_2
	end
	return lightGuardianRead.typeScore_2
end
function lightGuardianRead.getTypeScore_3()
	return lightGuardianRead.typeScore_3[1]
end
function lightGuardianRead.getStageRewardByIndex(index)
	for i, v in ipairs(lightGuardianRead.stageReward) do
		if v.id == index then
			return v.reward
		end
	end
	_ENV = (for generator)
	return ipairs(lightGuardianRead.stageReward)
end
return lightGuardianRead
