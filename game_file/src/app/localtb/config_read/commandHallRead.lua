local commandHallRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "newcommandhalltask"
;(nil)[2] = true
commandHallRead:defineValue("commandhalltask", nil)
function commandHallRead.getTaskConfig(taskID)
	return commandHallRead.commandhalltask[taskID]
end
function commandHallRead.getTaskType(taskID)
	local config = commandHallRead.getTaskConfig(taskID)
	return config.type
end
function commandHallRead.getTaskQuality(taskID)
	local config = commandHallRead.getTaskConfig(taskID)
	return config.quality
end
function commandHallRead.getTaskKillReward(taskID)
	local config = commandHallRead.getTaskConfig(taskID)
	_UPVALUE3_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	;(nil)[3] = "probability"
	return serviceFunctions.tableFormat(config.advanceReward, nil)
end
function commandHallRead.getTaskVictoryReward(taskID)
	local config = commandHallRead.getTaskConfig(taskID)
	_UPVALUE3_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	;(nil)[3] = "probability"
	local reward1 = serviceFunctions.tableFormat(config.taskReward, nil)
	_UPVALUE3_ = "id"
	;("id")[1] = "id"
	;("id")[2] = "count"
	;("id")[3] = "probability"
	local reward2 = serviceFunctions.tableFormat(config.proceedReward, "id")
	for __, v in ipairs(reward2) do
		local isFind = false
		for __, w in ipairs(reward1) do
			if v.id == w.id then
				v.count = v.count + w.count
				isFind = true
				break
			end
		end
		if not isFind then
			table.insert(reward1, v)
		end
	end
	return reward1
end
function commandHallRead.getRecommendHero(taskID)
	local config = commandHallRead.getTaskConfig(taskID)
	return config.recommendHero
end
function commandHallRead.getRecommendArmy(taskID)
	local config = commandHallRead.getTaskConfig(taskID)
	return config.recommendArmy
end
function commandHallRead.getTaskRewardNpcShow(taskID)
	local config = commandHallRead.getTaskConfig(taskID)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	return serviceFunctions.tableFormat(config.rewardNpcShow, nil)
end
function commandHallRead.getTaskConsume(taskID)
	local config = commandHallRead.getTaskConfig(taskID)
	return config.consume
end
function commandHallRead.getTaskRelevanceTask(taskID)
	local config = commandHallRead.getTaskConfig(taskID)
	return config.relevanceTask
end
function commandHallRead.checkTaskRelevanceTask(taskID)
	local relevanceTask = commandHallRead.getTaskRelevanceTask(taskID)
	if relevanceTask and next(relevanceTask) then
		return true
	end
	return false
end
_UPVALUE1_ = nil
;(nil)[1] = "newcommandhallshow"
commandHallRead:defineValue("commandhallshow", nil)
function commandHallRead.getTaskShowConfig(taskType)
	return commandHallRead.commandhallshow[taskType]
end
function commandHallRead.getTaskIcon(taskType)
	local config = commandHallRead.getTaskShowConfig(taskType)
	return config.icon
end
function commandHallRead.getTaskName(taskID)
	local taskType = commandHallRead.getTaskType(taskID)
	local config = commandHallRead.getTaskShowConfig(taskType)
	if taskType == gCommandHallTaskType.REBEL_ARMY_GROUP_TASK then
		local taskOrder = commandHallRead.getTaskOrder(taskID)
		if taskOrder and 0 < taskOrder then
			local commandHallUtil = include("commandHallUtil")
			local groupStr = commandHallUtil.getArmyGroupIDStr(taskOrder)
			commandHallRead = nil
			;(nil).num = groupStr
			return i18n(config.name, nil)
		end
	end
	return i18n(config.name)
end
function commandHallRead.getTaskDes(taskType)
	local config = commandHallRead.getTaskShowConfig(taskType)
	return i18n(config.text)
end
function commandHallRead.getTaskNpcName(taskType)
	local config = commandHallRead.getTaskShowConfig(taskType)
	return i18n(config.npcName)
end
function commandHallRead.getTaskNpcText(taskType)
	local config = commandHallRead.getTaskShowConfig(taskType)
	return i18n(config.npcText)
end
function commandHallRead.getTaskNpcPicture(taskType)
	local config = commandHallRead.getTaskShowConfig(taskType)
	return config.npcPicture
end
function commandHallRead.getTaskNpcButtonText(taskType)
	local config = commandHallRead.getTaskShowConfig(taskType)
	return i18n(config.button)
end
_ENV, commandHallRead.getTaskNpcResource = function(taskType)
	local config = commandHallRead.getTaskShowConfig(taskType)
	return config.resource
end, function(taskType)
	local config = commandHallRead.getTaskShowConfig(taskType)
	return config.resource
end
;(function(taskType)
	local config = commandHallRead.getTaskShowConfig(taskType)
	return config.resource
end)[1] = cc.c3b(68, 15, 0)
;(function(taskType)
	local config = commandHallRead.getTaskShowConfig(taskType)
	return config.resource
end)[2] = cc.c3b(0, 110, 0)
;(function(taskType)
	local config = commandHallRead.getTaskShowConfig(taskType)
	return config.resource
end)[3] = cc.c3b(58, 139, 190)
;(function(taskType)
	local config = commandHallRead.getTaskShowConfig(taskType)
	return config.resource
end)[4] = cc.c3b(182, 43, 246)
local (function(taskType)
	local config = commandHallRead.getTaskShowConfig(taskType)
	return config.resource
end)[5], quality2shallowColor = cc.c3b(210, 75, 1), function(taskType)
	local config = commandHallRead.getTaskShowConfig(taskType)
	return config.resource
end
_ENV, commandHallRead.getQualityShallowColor = function(quality)
	return quality2shallowColor[quality]
end, function(quality)
	return quality2shallowColor[quality]
end
;(function(quality)
	return quality2shallowColor[quality]
end)[1] = cc.c3b(215, 195, 155)
;(function(quality)
	return quality2shallowColor[quality]
end)[2] = cc.c3b(76, 230, 26)
;(function(quality)
	return quality2shallowColor[quality]
end)[3] = cc.c3b(62, 170, 238)
;(function(quality)
	return quality2shallowColor[quality]
end)[4] = cc.c3b(182, 43, 246)
local (function(quality)
	return quality2shallowColor[quality]
end)[5], quality2deepColor = cc.c3b(210, 75, 1), function(quality)
	return quality2shallowColor[quality]
end
_ENV, commandHallRead.getQualityDeepColor = function(quality)
	return quality2deepColor[quality]
end, function(quality)
	return quality2deepColor[quality]
end
;(function(quality)
	return quality2deepColor[quality]
end)[1] = "common_text_680"
;(function(quality)
	return quality2deepColor[quality]
end)[2] = "commandhall_text_44"
;(function(quality)
	return quality2deepColor[quality]
end)[3] = "commandhall_text_45"
;(function(quality)
	return quality2deepColor[quality]
end)[4] = "commandhall_text_46"
local (function(quality)
	return quality2deepColor[quality]
end)[5], quality2name = "commandhall_text_47", function(quality)
	return quality2deepColor[quality]
end
function commandHallRead.getQualityName(quality)
	if quality2name[quality] then
		return i18n(quality2name[quality])
	else
		return ""
	end
end
function commandHallRead.getQualityBgImage(quality)
	return string.format("img_commandhall_sign_%02d.png", quality)
end
function commandHallRead.getQualityFlagImage(quality)
	return string.format("img_commandhall_flag_%02d.png", quality)
end
_UPVALUE2_ = nil
;(nil)[1] = "newcommandhalllv"
;(nil)[2] = true
commandHallRead:defineValue("commandhalllv", nil)
function commandHallRead.getCommandLvConfig(lv)
	for _, value in pairs(commandHallRead.commandhalllv) do
		if lv >= value.lv[1] and lv <= value.lv[2] then
			return value
		end
	end
	return commandHallRead.commandhalllv[#commandHallRead.commandhalllv]
end
function commandHallRead.getCommandLvDamageRadio(lv)
	local config = commandHallRead.getCommandLvConfig(lv)
	_UPVALUE2_ = nil
	;(nil)[1] = "valueType"
	;(nil)[2] = "value"
	return serviceFunctions.tableFormat(config.damageRadio, nil)[1]
end
function commandHallRead.getCommandLvRewardRadio(lv)
	local config = commandHallRead.getCommandLvConfig(lv)
	return config.rewardRadio
end
function commandHallRead.getCommandLvMax(...)
	return 99999
end
function commandHallRead.getCommandLvIcon(lv)
	local config = commandHallRead.getCommandLvConfig(lv)
	return config.icon
end
function commandHallRead.getCommandLvIconLv(lv)
	local icon = commandHallRead.getCommandLvIcon(lv)
	return tonumber(string.sub(icon, -6, -5))
end
function commandHallRead.getCommandLvQualityPro(lv)
	local config = commandHallRead.getCommandLvConfig(lv)
	return config.qualityPro
end
function commandHallRead.getCommandLvReward(lv)
	local config = commandHallRead.getCommandLvConfig(lv)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	return serviceFunctions.tableFormat(config.reward, nil)
end
function commandHallRead.getCommandLvNeedExp(lv)
	local config = commandHallRead.getCommandLvConfig(lv)
	return config.needExp
end
_UPVALUE2_ = nil
;(nil)[1] = "commandhallpower"
;(nil)[2] = true
commandHallRead:defineValue("commandhallpower", nil)
function commandHallRead.getPowerLvConfig(lv)
	return commandHallRead.commandhallpower[lv]
end
function commandHallRead.getPowerLvMax(...)
	return #commandHallRead.commandhallpower
end
function commandHallRead.getPowerLvIcon(lv)
	local config = commandHallRead.getPowerLvConfig(lv)
	return config.icon
end
function commandHallRead.getPowerLvIconLv(lv)
	local icon = commandHallRead.getPowerLvIcon(lv)
	return tonumber(string.sub(icon, -6, -5))
end
function commandHallRead.getPowerLvReward(lv)
	local config = commandHallRead.getPowerLvConfig(lv)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	return serviceFunctions.tableFormat(config.reward, nil)
end
function commandHallRead.getPowerLvTriggerTask(lv)
	local config = commandHallRead.getPowerLvConfig(lv)
	return config.triggerTask
end
function commandHallRead.getPowerLvNeedTask(lv)
	local config = commandHallRead.getPowerLvConfig(lv)
	return config.needTask
end
_UPVALUE2_ = nil
;(nil)[1] = "newcommandhalldialogue"
;(nil)[2] = false
commandHallRead:defineValue("commandhalldialogue", nil)
commandHallRead:defineValue("dialogueConfig", function()
	local commandhalldialogue = require_data("newcommandhalldialogue").data
	local _ENV, ret = "newcommandhalldialogue", "newcommandhalldialogue"
	for i, v in ipairs(commandhalldialogue) do
		if not ret[v.group] then
			_ENV = ret[v.group]
		end
		ret[v.group] = ret[v.group]
		table.insert(ret[v.group], v)
	end
	return ret
end)
function commandHallRead.getTaskDialogueConfig(groupID)
	return commandHallRead.dialogueConfig[groupID]
end
function _UPVALUE2_()
	local commandhalldialogue = require_data("newcommandhalldialogue").data
	local _ENV, ret = "newcommandhalldialogue", "newcommandhalldialogue"
	for i, v in ipairs(commandhalldialogue) do
		if not ret[v.group] then
			_ENV = ret[v.group]
		end
		ret[v.group] = ret[v.group]
		table.insert(ret[v.group], v)
	end
	return ret
end
;(function()
	local commandhalldialogue = require_data("newcommandhalldialogue").data
	local _ENV, ret = "newcommandhalldialogue", "newcommandhalldialogue"
	for i, v in ipairs(commandhalldialogue) do
		if not ret[v.group] then
			_ENV = ret[v.group]
		end
		ret[v.group] = ret[v.group]
		table.insert(ret[v.group], v)
	end
	return ret
end)[1] = "rabellegionconfig"
;(function()
	local commandhalldialogue = require_data("newcommandhalldialogue").data
	local _ENV, ret = "newcommandhalldialogue", "newcommandhalldialogue"
	for i, v in ipairs(commandhalldialogue) do
		if not ret[v.group] then
			_ENV = ret[v.group]
		end
		ret[v.group] = ret[v.group]
		table.insert(ret[v.group], v)
	end
	return ret
end)[2] = true
commandHallRead:defineValue("rabellegionconfig", function()
	local commandhalldialogue = require_data("newcommandhalldialogue").data
	local _ENV, ret = "newcommandhalldialogue", "newcommandhalldialogue"
	for i, v in ipairs(commandhalldialogue) do
		if not ret[v.group] then
			_ENV = ret[v.group]
		end
		ret[v.group] = ret[v.group]
		table.insert(ret[v.group], v)
	end
	return ret
end)
commandHallRead:defineValue("rabellegionMap", function()
	local _ENV, ret
	for i, v in ipairs(commandHallRead.rabellegionconfig) do
		ret[v.taskID] = v
	end
	commandHallRead.rabellegionMap = ret
	return ret
end)
function commandHallRead.getRabellegionConfig(taskID)
	return commandHallRead.rabellegionMap[taskID]
end
function commandHallRead.getTaskDamage(taskID, taskType)
	local cfg = commandHallRead.getRabellegionConfig(taskID)
	local taskDamage = serviceFunctions.tableFormatToMap(cfg.taskDamage)
	return taskDamage[taskType] or 0
end
function commandHallRead.getTaskOrder(taskID)
	local cfg = commandHallRead.getRabellegionConfig(taskID)
	return cfg.index
end
function commandHallRead.checkTaskIsCirculate(taskID)
	local cfg = commandHallRead.getRabellegionConfig(taskID)
	return cfg.isCirculate == 1
end
function commandHallRead.getRabellegionConfigByOrder(order)
	return commandHallRead.rabellegionconfig[order] or commandHallRead.rabellegionconfig[#commandHallRead.rabellegionconfig]
end
function commandHallRead.getCommandLvMaxNum(order)
	local cfg = commandHallRead.getRabellegionConfigByOrder(order)
	return cfg.maxNum
end
function commandHallRead.getTaskIDByOrder(order)
	local cfg = commandHallRead.getRabellegionConfigByOrder(order)
	return cfg.taskID
end
function commandHallRead.isCommandLvRandom(order)
	local cfg = commandHallRead.getRabellegionConfigByOrder(order)
	return cfg.random == 1
end
function commandHallRead.getFixedTask(order)
	local cfg = commandHallRead.getRabellegionConfigByOrder(order)
	return cfg.fixedTask
end
commandHallRead:defineValue("rabellegionRewards", function()
	local _ENV, ret
	for i, v in ipairs(commandHallRead.rabellegionconfig) do
		local taskID = v.taskID
		local killReward = commandHallRead.getTaskKillReward(taskID)
		local victoryReward = commandHallRead.getTaskVictoryReward(taskID)
		_ENV = nil
		;(nil).index = i
		;(nil).killReward = killReward
		;(nil).victoryReward = victoryReward
		;(nil).isCirculate = v.isCirculate == 1
		table.insert(ret, nil)
	end
	commandHallRead.rabellegionRewards = ret
	return ret
end)
function commandHallRead.getRabellegionRewards(...)
	return commandHallRead.rabellegionRewards
end
return commandHallRead
