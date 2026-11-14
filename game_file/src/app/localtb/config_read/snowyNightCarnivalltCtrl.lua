local snowyNightCarnivalltCtrl = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "snowy_night_score"
;(nil)[2] = true
snowyNightCarnivalltCtrl:defineValue("getScore", nil)
_UPVALUE2_ = nil
;(nil)[1] = "snowy_night_reward"
;(nil)[2] = true
snowyNightCarnivalltCtrl:defineValue("levelReward", nil)
function snowyNightCarnivalltCtrl.getReawrdCfg()
	return snowyNightCarnivalltCtrl.levelReward
end
function snowyNightCarnivalltCtrl.setRewardConfigState()
	for i, v in ipairs(snowyNightCarnivalltCtrl.levelReward) do
	end
	_ENV = (for generator)
	return ipairs(snowyNightCarnivalltCtrl.levelReward)
end
snowyNightCarnivalltCtrl.levelRewardWithState = snowyNightCarnivalltCtrl.setRewardConfigState()
function snowyNightCarnivalltCtrl.getRewardConfigByLevel(level)
	for i, v in ipairs(snowyNightCarnivalltCtrl.levelReward) do
		if v.lv == tonumber(level) then
			return v
		end
	end
	_ENV = (for generator)
	return ipairs(snowyNightCarnivalltCtrl.levelReward)
end
function snowyNightCarnivalltCtrl.getRewardScoreByLevel(level)
	for i, v in ipairs(snowyNightCarnivalltCtrl.levelReward) do
		if v.lv == tonumber(level) then
			return v.score
		end
	end
	return 0
end
function snowyNightCarnivalltCtrl.getLastLevel()
	local flag, size = snowyNightCarnivalltCtrl.CheckLastLevel()
	if flag then
		return snowyNightCarnivalltCtrl.levelReward[size].lv
	end
	return 0
end
function snowyNightCarnivalltCtrl.CheckLastLevel()
	local size = table.nums(snowyNightCarnivalltCtrl.levelReward)
	if 1 <= size then
		return true, size
	end
	return false
end
function snowyNightCarnivalltCtrl.getRewardConfigSize()
	if snowyNightCarnivalltCtrl.levelReward then
		return table.nums(snowyNightCarnivalltCtrl.levelReward)
	else
		return 0
	end
end
function snowyNightCarnivalltCtrl.getLevelRewardSize()
	return snowyNightCarnivalltCtrl.getNormalRewardSize() + snowyNightCarnivalltCtrl.getExtraRewardSize()
end
function snowyNightCarnivalltCtrl.getNormalRewardSize()
	if snowyNightCarnivalltCtrl.getRewardConfigSize() > 0 then
		return table.nums(snowyNightCarnivalltCtrl.levelReward[1].normalreward) / 2
	else
		return 0
	end
end
function snowyNightCarnivalltCtrl.getExtraRewardSize()
	if snowyNightCarnivalltCtrl.getRewardConfigSize() > 0 then
		return table.nums(snowyNightCarnivalltCtrl.levelReward[1].specialreward) / 2
	else
		return 0
	end
end
return snowyNightCarnivalltCtrl
