local luckyFalconRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "luckyfalcon_extra_reward"
	;(nil)[2] = true
	luckyFalconRead:defineValue("lfer", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "luckyfalcon_reward_pool"
	;(nil)[2] = true
	luckyFalconRead:defineValue("lfrp", nil)
	luckyFalconRead = nil
	;(nil)[1] = "luckyfalcon_recharge_view"
	luckyFalconRead:defineValue("lfrv", nil)
	luckyFalconRead = nil
	;(nil)[1] = "luckyfalcon_hero_view"
	luckyFalconRead:defineValue("lfhv", nil)
end
init()
function luckyFalconRead.getPackgeInfo()
	local _ENV, packageInfo
	for i, v in ipairs(luckyFalconRead.lfrv) do
		table.insert(packageInfo, v)
	end
	return packageInfo
end
function luckyFalconRead.getHeroNameList(classType)
	local name
	for i, v in pairs(luckyFalconRead.lfhv) do
		if v.group == classType then
			name = v.name
			break
		end
	end
	return name
end
function luckyFalconRead.getHeroList(classType)
	local _ENV, heroList
	for i, v in pairs(luckyFalconRead.lfhv) do
		if v.group == classType then
			heroList = v.heroView
			break
		end
	end
	return heroList
end
function luckyFalconRead.getHeroImage(classType)
	local img = "icon_xyly_04.png"
	for i, v in pairs(luckyFalconRead.lfhv) do
		if v.group == classType then
			img = v.show
			break
		end
	end
	return img
end
function luckyFalconRead.getIconImage(classType)
	local img = "icon_xyly_07.png"
	for i, v in pairs(luckyFalconRead.lfhv) do
		if v.group == classType then
			img = v.icon
			break
		end
	end
	return img
end
function luckyFalconRead.getRewardInfo(classType)
	local _ENV, rewardInfo
	for i, v in ipairs(luckyFalconRead.lfer) do
		if classType == v.group then
			table.insert(rewardInfo, v)
		end
	end
	return rewardInfo
end
function luckyFalconRead.getRewardStageTimes(classType)
	local _ENV, stageList
	for i, v in ipairs(luckyFalconRead.lfer) do
		if classType == v.group then
			table.insert(stageList, v.lotteryTime)
		end
	end
	table.sort(stageList)
	return stageList
end
function luckyFalconRead.getExtraRewardInfo(classType, stage)
	local _ENV, extraReward
	for i, v in ipairs(luckyFalconRead.lfer) do
		if classType == v.group and stage == v.lotteryStage then
			extraReward = v.extraReward
		end
	end
	_UPVALUE2_ = ipairs(luckyFalconRead.lfer)
	ipairs(luckyFalconRead.lfer)[1] = "id"
	ipairs(luckyFalconRead.lfer)[2] = "count"
	extraReward = serviceFunctions.tableFormat(extraReward, ipairs(luckyFalconRead.lfer))
	return extraReward
end
function luckyFalconRead.getAllPoolRewardInfo(classType)
	local _ENV, poolReward
	for i, v in ipairs(luckyFalconRead.lfrp) do
		if classType == v.group then
			for j, m in ipairs(v.poolReward) do
				table.insert(poolReward, m)
			end
		end
	end
	_UPVALUE2_ = ipairs(luckyFalconRead.lfrp)
	ipairs(luckyFalconRead.lfrp)[1] = "id"
	ipairs(luckyFalconRead.lfrp)[2] = "count"
	poolReward = serviceFunctions.tableFormat(poolReward, ipairs(luckyFalconRead.lfrp))
	return poolReward
end
function luckyFalconRead.getPoolRewardOnShow(classType)
	local _ENV, showReward
	for i, v in ipairs(luckyFalconRead.lfrp) do
		if classType == v.group and v.show == 1 then
			for j, m in ipairs(v.poolReward) do
				table.insert(showReward, m)
			end
		end
	end
	_UPVALUE2_ = ipairs(luckyFalconRead.lfrp)
	ipairs(luckyFalconRead.lfrp)[1] = "id"
	ipairs(luckyFalconRead.lfrp)[2] = "count"
	showReward = serviceFunctions.tableFormat(showReward, ipairs(luckyFalconRead.lfrp))
	return showReward
end
return luckyFalconRead
