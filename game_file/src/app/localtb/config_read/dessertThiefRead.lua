local dessertThiefRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "dessertthief"
;(nil)[2] = true
dessertThiefRead:defineValue("dessertthief", nil)
dessertThiefRead:defineValue("reward", function()
	dessertThiefRead.reward, dessertThiefRead = nil, nil
	for i, v in ipairs(dessertThiefRead.dessertthief) do
		if not dessertThiefRead.reward[v.classType] then
			dessertThiefRead = dessertThiefRead.reward[v.classType]
		end
		dessertThiefRead.reward[v.classType] = dessertThiefRead.reward[v.classType]
		table.insert(dessertThiefRead.reward[v.classType], v)
	end
	return dessertThiefRead.reward
end)
function dessertThiefRead.getCfgs()
	return dessertThiefRead.reward[dessertThiefRead.getGroup()]
end
function dessertThiefRead.getWorldBossReward(lv)
	local cfgs = dessertThiefRead.reward[dessertThiefRead.getGroup()]
	for i, v in ipairs(cfgs) do
		if v.Lv == lv then
			local dessertThiefRead, reward = v.Lv, v.Lv
			for i2, v2 in ipairs(v.rewards) do
				if i2 % 2 == 1 then
					table.insert(reward, v2)
				end
			end
			return reward
		end
	end
	return nil
end
function dessertThiefRead.getWorldBossMaxLv(bossType)
	local worldbossdate = include("worldbossdate")
	local maxLv = 0
	for k, v in ipairs(worldbossdate) do
		if v.bossType == bossType and maxLv < v.level then
			maxLv = v.level
		end
	end
	return maxLv
end
function dessertThiefRead.getWorldBossCfg(bossType, lv)
	local worldbossdate = include("worldbossdate")
	for k, v in ipairs(worldbossdate) do
		if v.bossType == bossType and lv == v.level then
			return v
		end
	end
	return nil
end
function dessertThiefRead.getGroup()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.SWEET_MEAT_ROBBER_ACTIVITY)
	local _classtype = param.classtype and param.classtype or 1
	return _classtype
end
return dessertThiefRead
