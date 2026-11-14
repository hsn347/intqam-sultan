local newKingTrailRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	newKingTrailRead = nil
	;(nil)[1] = "new_king_trial_config"
	newKingTrailRead:defineValue("config", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "new_king_trial_stage_reward"
	;(nil)[2] = true
	newKingTrailRead:defineValue("stageReward", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "new_king_trial_stage_rank"
	;(nil)[2] = true
	newKingTrailRead:defineValue("statgeRank", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "new_king_trial_total_rank"
	;(nil)[2] = true
	newKingTrailRead:defineValue("totalRank", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "new_king_trial_stage"
	;(nil)[2] = true
	newKingTrailRead:defineValue("stageTime", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "new_king_trial_event"
	;(nil)[2] = true
	newKingTrailRead:defineValue("stageEvent", nil)
end
init()
function newKingTrailRead.getStageRewardByType(type)
	local _ENV, tmp
	for i, v in ipairs(newKingTrailRead.stageReward) do
		if v.type == type then
			table.insert(tmp, v)
		end
	end
	return tmp
end
function newKingTrailRead.getRankReward(type)
	local _ENV, tmp
	for i, v in ipairs(newKingTrailRead.statgeRank) do
		if v.type == type then
			table.insert(tmp, v)
		end
	end
	if next(tmp) == nil then
		return newKingTrailRead.totalRank
	else
		return tmp
	end
end
function newKingTrailRead.getStageConfig()
	return newKingTrailRead.config
end
function newKingTrailRead.getStageTime(index)
	return newKingTrailRead.stageTime[index].duration
end
_UPVALUE6_, newKingTrailRead.getTotalStageTime = function(num)
	local totalTime = 0
	for i = 1, num do
		totalTime = totalTime + newKingTrailRead.stageTime[i].duration
	end
	return totalTime
end, function(num)
	local totalTime = 0
	for i = 1, num do
		totalTime = totalTime + newKingTrailRead.stageTime[i].duration
	end
	return totalTime
end
;(function(num)
	local totalTime = 0
	for i = 1, num do
		totalTime = totalTime + newKingTrailRead.stageTime[i].duration
	end
	return totalTime
end)[1] = "limitactivities_eventdes_08"
;(function(num)
	local totalTime = 0
	for i = 1, num do
		totalTime = totalTime + newKingTrailRead.stageTime[i].duration
	end
	return totalTime
end)[2] = "limitactivities_eventdes_09"
;(function(num)
	local totalTime = 0
	for i = 1, num do
		totalTime = totalTime + newKingTrailRead.stageTime[i].duration
	end
	return totalTime
end)[3] = "king_tri_text_10"
;(function(num)
	local totalTime = 0
	for i = 1, num do
		totalTime = totalTime + newKingTrailRead.stageTime[i].duration
	end
	return totalTime
end)[4] = "king_tri_text_11"
;(function(num)
	local totalTime = 0
	for i = 1, num do
		totalTime = totalTime + newKingTrailRead.stageTime[i].duration
	end
	return totalTime
end)[5] = "limitactivities_eventdes_12"
local (function(num)
	local totalTime = 0
	for i = 1, num do
		totalTime = totalTime + newKingTrailRead.stageTime[i].duration
	end
	return totalTime
end)[6], strDes = "king_tri_text_24", function(num)
	local totalTime = 0
	for i = 1, num do
		totalTime = totalTime + newKingTrailRead.stageTime[i].duration
	end
	return totalTime
end
function newKingTrailRead.getStrList(type)
	local eventType
	for i, v in ipairs(newKingTrailRead.stageReward) do
		if v.type == type then
			eventType = v.event
			break
		end
	end
	local _ENV, strList = (for generator), ipairs(newKingTrailRead.stageReward)
	for i, v in ipairs(eventType) do
		local k = newKingTrailRead.stageEvent[v]
		arg2 = k.param[2] or 1
		arg1 = k.param[1]
		local publicRead = include("publicRead")
		if k.event == 4 then
			arg1 = publicRead.getName(arg1)
		end
		_ENV = nil
		;(nil).count = arg2
		;(nil).level = arg1
		;(nil).point = string.formatnumberthousands(k.score)
		local str = i18n(strDes[k.event], nil)
		if k.event == 6 and arg1 == 13 then
			_ENV = string.formatnumberthousands(k.score)
			string.formatnumberthousands(k.score).count = arg2
			string.formatnumberthousands(k.score).point = string.formatnumberthousands(k.score)
			str = i18n("Soldiers_armor_text_85", (string.formatnumberthousands(k.score)))
		end
		table.insert(strList, str)
	end
	return strList
end
return newKingTrailRead
