local NewServerReturnltCtrl = include("aAReadClass").new()
function NewServerReturnltCtrl.init()
	_UPVALUE2_ = nil
	;(nil)[1] = "newstart_reward"
	;(nil)[2] = true
	NewServerReturnltCtrl:defineValue("newstart_reward", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "rise_of_sudan"
	;(nil)[2] = true
	NewServerReturnltCtrl:defineValue("rise_of_sudan", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "newstart_inherit"
	;(nil)[2] = true
	NewServerReturnltCtrl:defineValue("newstart_inherit", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "inherit_task"
	;(nil)[2] = true
	NewServerReturnltCtrl:defineValue("inherit_task", nil)
	NewServerReturnltCtrl:defineValue("road_to_revival", function(name)
		local road_to_revival = require_once("app." .. LocalTblPath .. ".config_server.road_to_revival")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.road_to_revival", "app." .. LocalTblPath .. ".config_server.road_to_revival"
		for _, v in ipairs(road_to_revival) do
			if not ret[v.week] then
				ret[v.week], _ENV = nil, nil
			end
			_ENV = nil
			;(nil).questDes = v.questDes
			;(nil).questId = v.questId
			table.insert(ret[v.week], nil)
		end
		return ret
	end)
end
function NewServerReturnltCtrl.getNewServerReward()
	return NewServerReturnltCtrl.newstart_reward[1]
end
function NewServerReturnltCtrl.getRiseOfSultanTaskList(castleLv)
	for i, v in ipairs(NewServerReturnltCtrl.rise_of_sudan) do
		if castleLv >= v.castleLv[1] and castleLv <= v.castleLv[2] then
			return v.questId
		end
	end
	_ENV = (for generator)
	return ipairs(NewServerReturnltCtrl.rise_of_sudan)
end
function NewServerReturnltCtrl.getRiseOfSultanTaskListByIndex(index)
	return NewServerReturnltCtrl.rise_of_sudan[index].questId
end
function NewServerReturnltCtrl.getRevivalRoadTaskList(week)
	return NewServerReturnltCtrl.road_to_revival[week] or NewServerReturnltCtrl.road_to_revival[#NewServerReturnltCtrl.road_to_revival]
end
function NewServerReturnltCtrl.getInheritWealthTaskByStage(stage, type)
	for i, v in ipairs(NewServerReturnltCtrl.inherit_task) do
		if stage == v.inheritGears and type == v.type then
			return v.questId
		end
	end
	_ENV = (for generator)
	return ipairs(NewServerReturnltCtrl.inherit_task)
end
function NewServerReturnltCtrl.getInheritWealthRewardGrossByStage(stage)
	if stage < 1 then
		return 0
	end
	print("fskdfkskdflkd " .. stage)
	dump(NewServerReturnltCtrl.newstart_inherit[stage], "fjksdfjsklfjlsjfldjfl")
	return NewServerReturnltCtrl.newstart_inherit[stage].rewardGross[1] or 0
end
NewServerReturnltCtrl.init()
return NewServerReturnltCtrl
