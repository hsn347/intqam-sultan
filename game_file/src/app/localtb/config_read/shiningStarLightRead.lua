local shiningStarLightRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "star_splendor_task"
	;(nil)[2] = true
	shiningStarLightRead:defineValue("questList", nil)
	local createData = function(name)
		shiningStarLightRead.lightAward, shiningStarLightRead, shiningStarLightRead.finalAward, shiningStarLightRead = nil, nil, nil, nil
		local rewardList = require_once("app." .. LocalTblPath .. ".config_server.star_splendor_light")
		for i, v in ipairs(rewardList) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.award = serviceFunctions.tableFormat(v.award, nil)
			if v.type == 2 then
				table.insert(shiningStarLightRead.finalAward, v)
			elseif v.type == 1 then
				table.insert(shiningStarLightRead.lightAward, v)
			end
		end
		if name == "finalAward" then
			return shiningStarLightRead.finalAward
		elseif name == "lightAward" then
			return shiningStarLightRead.lightAward
		end
	end
	shiningStarLightRead:defineValue("finalAward", createData)
	shiningStarLightRead:defineValue("lightAward", createData)
end
init()
function shiningStarLightRead.getQuestList(lv)
	for i, v in ipairs(shiningStarLightRead.questList) do
		if lv >= v.LV[1] and lv <= v.LV[2] then
			return v.taskId
		end
	end
	_ENV = (for generator)
	return ipairs(shiningStarLightRead.questList)
end
function shiningStarLightRead.getFinalReward(lv)
	for i, v in ipairs(shiningStarLightRead.finalAward) do
		if lv >= v.LV[1] and lv <= v.LV[2] then
			return v.award
		end
	end
	_ENV = (for generator)
	return ipairs(shiningStarLightRead.finalAward)
end
function shiningStarLightRead.getLightAward(lv, index)
	for i, v in ipairs(shiningStarLightRead.lightAward) do
		if lv >= v.LV[1] and lv <= v.LV[2] and v.order == index then
			return v
		end
	end
	_ENV = (for generator)
	return ipairs(shiningStarLightRead.lightAward)
end
return shiningStarLightRead
