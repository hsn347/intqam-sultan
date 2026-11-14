local nebulaTreasureRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "star_treasure_quest"
;(nil)[2] = true
nebulaTreasureRead:defineValue("quest", nil)
_UPVALUE2_ = nil
;(nil)[1] = "star_treasure_rate"
;(nil)[2] = true
nebulaTreasureRead:defineValue("rate", nil)
nebulaTreasureRead:defineValue("questCfgs", function()
	nebulaTreasureRead.questCfgs, nebulaTreasureRead = nil, nil
	for k, v in pairs(nebulaTreasureRead.quest) do
		nebulaTreasureRead.questCfgs[v.questID] = v
	end
	return nebulaTreasureRead.questCfgs
end)
function nebulaTreasureRead.getRateCfg()
	local group = nebulaTreasureRead.getGroup()
	local nebulaTreasureRead, tmpTable
	for k, v in ipairs(nebulaTreasureRead.rate) do
		if v.group == group then
			table.insert(tmpTable, v)
		end
	end
	return tmpTable
end
function nebulaTreasureRead.getQuestCfg(taskID)
	return nebulaTreasureRead.questCfgs[tonumber(taskID)]
end
function nebulaTreasureRead.getIcon(taskID)
	return nebulaTreasureRead.questCfgs[tonumber(taskID)].icon
end
function nebulaTreasureRead.getName(taskID)
	return nebulaTreasureRead.questCfgs[tonumber(taskID)].questName
end
function nebulaTreasureRead.getTitle(taskID)
	return nebulaTreasureRead.questCfgs[tonumber(taskID)].questTitle
end
function nebulaTreasureRead.getRewad(taskID)
	return nebulaTreasureRead.questCfgs[tonumber(taskID)].reward
end
function nebulaTreasureRead.getQuestType(taskID)
	return nebulaTreasureRead.questCfgs[tonumber(taskID)].questType
end
function nebulaTreasureRead.getGroup()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.NEBULA_TREASURE_ACTIVITY)
	local _classtype = param.classtype and param.classtype or 1
	return _classtype
end
return nebulaTreasureRead
