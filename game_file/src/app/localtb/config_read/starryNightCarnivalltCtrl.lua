local starryNightCarnivalltCtrl = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "startlit_night_score"
;(nil)[2] = true
starryNightCarnivalltCtrl:defineValue("startlit_night_score", nil)
_UPVALUE2_ = nil
;(nil)[1] = "startlit_night_reward"
;(nil)[2] = true
starryNightCarnivalltCtrl:defineValue("startlit_night_reward", nil)
_UPVALUE2_ = nil
;(nil)[1] = "startlit_night_recharge"
;(nil)[2] = true
starryNightCarnivalltCtrl:defineValue("startlit_night_recharge", nil)
_UPVALUE2_ = nil
;(nil)[1] = "circulate_reward"
;(nil)[2] = true
starryNightCarnivalltCtrl:defineValue("circulate_reward", nil)
function starryNightCarnivalltCtrl.getRechargeCfg(isEx2)
	return starryNightCarnivalltCtrl.startlit_night_recharge[isEx2 and 2 or 1]
end
function starryNightCarnivalltCtrl.getPointRewardDataByClassType(classType)
	local _ENV, data
	local index = 1
	for i, v in ipairs(starryNightCarnivalltCtrl.startlit_night_reward) do
		if v.group == classType then
			data[index] = v
			index = index + 1
		elseif classType < v.group then
			break
		end
	end
	for i, v in ipairs(starryNightCarnivalltCtrl.circulate_reward) do
		if v.group == classType then
			_ENV = v.group
			v.group.lv = index + 1
			v.group.group = v.group
			v.group.score = v.exp
			v.group.normalReward = v.normalReward
			v.group.advanceReward = v.juniorReward
			local v.group.seniorReward, finalData = v.seniorReward, v.group
			data[index] = finalData
			break
		end
	end
	return data
end
function starryNightCarnivalltCtrl.getRewardDataSize(classType)
	local _ENV, data
	local count = 0
	for i, v in ipairs(starryNightCarnivalltCtrl.startlit_night_reward) do
		if v.group == classType then
			count = count + 1
		elseif classType < v.group then
			return count
		end
	end
	return count
end
function starryNightCarnivalltCtrl.getAdvanceRewardItem(classType)
	local _ENV, reward
	dump(classType, "fsfjksjflsjfljdk")
	for i, v in ipairs(starryNightCarnivalltCtrl.startlit_night_reward) do
		if v.group == classType then
			if v.advanceReward[1] and not reward[tostring(v.advanceReward[1])] then
				reward[tostring(v.advanceReward[1])] = 0
			end
			if v.advanceReward[3] and not reward[tostring(v.advanceReward[3])] then
				reward[tostring(v.advanceReward[3])] = 0
			end
		end
	end
	for i, v in ipairs(starryNightCarnivalltCtrl.startlit_night_reward) do
		if v.group == classType then
			if v.advanceReward[1] then
				reward[tostring(v.advanceReward[1])] = reward[tostring(v.advanceReward[1])] + v.advanceReward[2]
			end
			if v.advanceReward[3] then
				reward[tostring(v.advanceReward[3])] = reward[tostring(v.advanceReward[3])] + v.advanceReward[4]
			end
		end
	end
	local index = 1
	local _ENV, result = ipairs(starryNightCarnivalltCtrl.startlit_night_reward)
	for i, v in pairs(reward) do
		result[index] = i
		index = index + 1
		result[index] = v
		index = index + 1
	end
	return result
end
function starryNightCarnivalltCtrl.getSeniorRewardItem(classType)
	local _ENV, reward
	for i, v in ipairs(starryNightCarnivalltCtrl.startlit_night_reward) do
		if v.group == classType then
			if v.seniorReward[1] and not reward[tostring(v.seniorReward[1])] then
				reward[tostring(v.seniorReward[1])] = 0
			end
			if v.seniorReward[3] and not reward[tostring(v.seniorReward[3])] then
				reward[tostring(v.seniorReward[3])] = 0
			end
		end
	end
	for i, v in ipairs(starryNightCarnivalltCtrl.startlit_night_reward) do
		if v.group == classType then
			if v.seniorReward[1] then
				reward[tostring(v.seniorReward[1])] = reward[tostring(v.seniorReward[1])] + v.seniorReward[2]
			end
			if v.seniorReward[3] then
				reward[tostring(v.seniorReward[3])] = reward[tostring(v.seniorReward[3])] + v.seniorReward[4]
			end
		end
	end
	local index = 1
	local _ENV, result = ipairs(starryNightCarnivalltCtrl.startlit_night_reward)
	for i, v in pairs(reward) do
		result[index] = i
		index = index + 1
		result[index] = v
		index = index + 1
	end
	return result
end
function starryNightCarnivalltCtrl.getLastLevel()
	return starryNightCarnivalltCtrl.rewardCfgSize
end
function starryNightCarnivalltCtrl.CheckLastLevel()
	local size = table.nums(starryNightCarnivalltCtrl.startlit_night_reward)
	if 1 <= size then
		return true, size
	end
	return false
end
function starryNightCarnivalltCtrl.getLevelRewardSize()
	return starryNightCarnivalltCtrl.getNormalRewardSize() + starryNightCarnivalltCtrl.getExtraRewardSize()
end
function starryNightCarnivalltCtrl.getNormalRewardSize(index)
	if starryNightCarnivalltCtrl.startlit_night_reward[index] then
		return table.nums(starryNightCarnivalltCtrl.startlit_night_reward[index].normalReward) / 2
	else
		return 0
	end
end
function starryNightCarnivalltCtrl.getExtraRewardSize(index)
	if starryNightCarnivalltCtrl.startlit_night_reward[index] then
		return table.nums(starryNightCarnivalltCtrl.startlit_night_reward[index].advanceReward) / 2
	else
		return 0
	end
end
function starryNightCarnivalltCtrl.getExtra2RewardSize(index)
	if starryNightCarnivalltCtrl.startlit_night_reward[index] then
		return table.nums(starryNightCarnivalltCtrl.startlit_night_reward[index].seniorReward) / 2
	else
		return 0
	end
end
return starryNightCarnivalltCtrl
