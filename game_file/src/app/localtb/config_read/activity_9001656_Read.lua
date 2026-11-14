local activity_9001656_Read = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "battlepass_reward"
;(nil)[2] = true
activity_9001656_Read:defineValue("battlepass_reward", nil)
_UPVALUE2_ = nil
;(nil)[1] = "battlepass_recharge"
;(nil)[2] = true
activity_9001656_Read:defineValue("battlepass_recharge", nil)
local createData = function(name)
	local _ENV, ret
	local cfg = require_data(name, true, true).data
	for k, v in ipairs(cfg) do
		if not ret[v.buildType] then
			ret[v.buildType], _ENV = nil, nil
		end
		_ENV = nil
		;(nil).CastleLv = v.buildLv
		;(nil).PrivilegeEffect = v.privilegeEffect
		;(nil).EffectIcon = v.effectIcon
		ret[v.buildType][v.rewardType], (nil).BUFFneedLV = nil, v.BUFFneedLV
	end
	return ret
end
activity_9001656_Read:defineValue("battlepass_buff", createData)
function activity_9001656_Read.getBuffInfo(activityID, buildType, index)
	local config = activity_9001656_Read.battlepass_buff
	if config[buildType] then
		return config[buildType][index]
	end
	return nil
end
function activity_9001656_Read.getBuffNeedLv()
	for k, v in pairs(activity_9001656_Read.battlepass_buff) do
		dump(v[1], "v[1]")
		return v[1].BUFFneedLV
	end
	return 0
end
function activity_9001656_Read.getRechargeCfg()
	return activity_9001656_Read.battlepass_recharge[1]
end
function activity_9001656_Read.getRewardList()
	return activity_9001656_Read.battlepass_reward
end
function activity_9001656_Read.getLevelReward(lv)
	local maxLv = #activity_9001656_Read.battlepass_reward
	if lv >= maxLv then
		lv = maxLv
	end
	return activity_9001656_Read.battlepass_reward[lv]
end
function activity_9001656_Read.getMaxLevel()
	return #activity_9001656_Read.battlepass_reward
end
function activity_9001656_Read.getRewardDataSize()
	local _ENV, data
	local count = 0
	for i, v in ipairs(activity_9001656_Read.battlepass_reward) do
		count = count + 1
	end
	return count
end
function activity_9001656_Read.getLvByExp(exp)
	local list = activity_9001656_Read.battlepass_reward
	local lv = 0
	local lvExp = 0
	local expNext = 0
	for index, value in ipairs(list) do
		expNext = expNext + value.exp
		if exp < expNext then
			break
		end
		lv = value.lv
		lvExp = expNext
	end
	exp = exp - lvExp
	if lv >= #list then
		local lastExp = list[#list].exp
		local lvAdd = math.floor(exp / lastExp)
		local leftExp = exp % lastExp
		return lv + lvAdd, leftExp, lastExp
	else
		return lv, exp, expNext - lvExp
	end
end
function activity_9001656_Read.getAdvanceRewardItem()
	local _ENV, reward
	for i, v in ipairs(activity_9001656_Read.battlepass_reward) do
		if v.advanceReward[1] and not reward[tostring(v.advanceReward[1])] then
			reward[tostring(v.advanceReward[1])] = 0
		end
		if v.advanceReward[3] and not reward[tostring(v.advanceReward[3])] then
			reward[tostring(v.advanceReward[3])] = 0
		end
	end
	for i, v in ipairs(activity_9001656_Read.battlepass_reward) do
		if v.advanceReward[1] then
			reward[tostring(v.advanceReward[1])] = reward[tostring(v.advanceReward[1])] + v.advanceReward[2]
		end
		if v.advanceReward[3] then
			reward[tostring(v.advanceReward[3])] = reward[tostring(v.advanceReward[3])] + v.advanceReward[4]
		end
	end
	local index = 1
	local _ENV, result = ipairs(activity_9001656_Read.battlepass_reward)
	for i, v in pairs(reward) do
		result[index] = i
		index = index + 1
		result[index] = v
		index = index + 1
	end
	return result
end
function activity_9001656_Read.CheckLastLevel()
	local size = table.nums(activity_9001656_Read.battlepass_reward)
	if 1 <= size then
		return true, size
	end
	return false
end
function activity_9001656_Read.getLevelRewardSize()
	return activity_9001656_Read.getNormalRewardSize() + activity_9001656_Read.getExtraRewardSize()
end
function activity_9001656_Read.getNormalRewardSize(index)
	if activity_9001656_Read.battlepass_reward[index] then
		return table.nums(activity_9001656_Read.battlepass_reward[index].normalReward) / 2
	else
		return 0
	end
end
function activity_9001656_Read.getExtraRewardSize(index)
	if activity_9001656_Read.battlepass_reward[index] then
		return table.nums(activity_9001656_Read.battlepass_reward[index].advanceReward) / 2
	else
		return 0
	end
end
function activity_9001656_Read.getShowRewad(index)
	local list = activity_9001656_Read.battlepass_reward
	local cfg, cfg1
	for i = #list, 1, -1 do
		cfg = list[i]
		cfg1 = cfg1 or cfg
		if index > cfg.lv then
			break
		end
		cfg1 = cfg
	end
	print("==1====", index, cfg1.lv)
	return cfg1
end
function activity_9001656_Read.isBuffEffect(activityID, buffType, index)
	if not clientEventMgr.judgeIsOpen(activityID) then
		return false
	end
	if 0 < index then
		local effectInfo = activity_9001656_Read.getBuffInfo(activityID, buffType, index)
		if effectInfo then
			local warOrderCtrl = SoraDGetCtrl("warOrderCtrl")
			local lv = warOrderCtrl:getNowLvByBuffType(buffType)
			if lv >= effectInfo.CastleLv[1] and lv <= effectInfo.CastleLv[2] then
				return true
			end
		end
	end
	return false
end
function activity_9001656_Read.getBuffVale(activityID, effectType, index)
	if not clientEventMgr.judgeIsOpen(activityID) then
		return 0
	end
	local value = 0
	for _, buffType in pairs(BUILD_ENUM) do
		for i = 1, 2 do
			if i <= index and activity_9001656_Read.isBuffEffect(activityID, buffType, index) then
				local effectInfo = activity_9001656_Read.getBuffInfo(activityID, buffType, i)
				if not effectInfo or not effectInfo.PrivilegeEffect then
					local _ENV, privilegeEffect = effectInfo.PrivilegeEffect, effectInfo.PrivilegeEffect
				end
				local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
				for _, v in ipairs(privilegeEffect) do
					if buffltCtrl:getEffectType(v) == effectType then
						local effect, _ = buffltCtrl:getEffect(v)
						value = value + effect
						print("==activity_9001656_Read:getBuffVale==", effect, effectType, value, i, buffType, v)
						break
					end
				end
			end
		end
	end
	return value
end
return activity_9001656_Read
