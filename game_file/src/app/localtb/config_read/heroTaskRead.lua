local heroTaskRead = include("aAReadClass").new()
heroTaskRead:defineValue("hero_task_config", function()
	local _ENV, ret
	local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.hero_task_config")
	for _, v in ipairs(cfg) do
		ret[v.taskID] = v
	end
	return ret
end)
function heroTaskRead.getTaskConfig(taskID)
	return heroTaskRead.hero_task_config[taskID]
end
function heroTaskRead.getRewardIncrease(taskID, heros)
	local cfg = heroTaskRead.getTaskConfig(taskID)
	local increaseCount = 0
	local heroTaskRead, effectTb
	_UPVALUE3_ = nil
	;(nil)[1] = "type"
	;(nil)[2] = "enum"
	;(nil)[3] = "val"
	local taskNeed = serviceFunctions.tableFormat(cfg.taskNeed, nil)
	local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
	for k, v in ipairs(taskNeed) do
		if v.type == 1 then
			local heroTypeCount = 0
			for _, heroID in ipairs(heros) do
				local heroType = heroltCtrl.getHeroType(heroID)
				if heroType == v.enum then
					heroTypeCount = heroTypeCount + 1
				end
			end
			if heroTypeCount >= v.val then
				increaseCount = increaseCount + 1
				effectTb[k] = true
			end
		elseif v.type == 2 then
			local heroDirectionPlus = 0
			for _, heroID in ipairs(heros) do
				local attrTb = heroltCtrl:getHeroAppointAttr(heroID)
				heroDirectionPlus = heroDirectionPlus + (attrTb[v.enum] or 0)
			end
			if heroDirectionPlus >= v.val then
				increaseCount = increaseCount + 1
				effectTb[k] = true
			end
		end
	end
	return cfg.rewardIncrease * increaseCount / 100, effectTb
end
return heroTaskRead
