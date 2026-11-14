local activity_9001661_Read = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "farm_level"
;(nil)[2] = true
activity_9001661_Read:defineValue("farm_level", nil)
function activity_9001661_Read.getAllLevelConfig()
	return activity_9001661_Read.farm_level
end
function activity_9001661_Read.getLevelConfig(lv)
	local lvMax = activity_9001661_Read.getLevelMax()
	lv = math.min(lvMax, lv)
	return activity_9001661_Read.farm_level[lv]
end
function activity_9001661_Read.getLevelMax()
	if not activity_9001661_Read.treeLevelMax then
		activity_9001661_Read.treeLevelMax = #activity_9001661_Read.farm_level
	end
	return activity_9001661_Read.treeLevelMax
end
function activity_9001661_Read.getLevelByExp(exp)
	local curLv = 1
	for __, cfg in ipairs(activity_9001661_Read.farm_level) do
		if exp >= cfg.exp then
			curLv = cfg.level
		else
			break
		end
	end
	return curLv
end
function activity_9001661_Read.getLevelConfigExp(lv)
	local cfg = activity_9001661_Read.getLevelConfig(lv)
	return cfg.exp
end
function activity_9001661_Read.getLevelConfigLiveshow(lv)
	local cfg = activity_9001661_Read.getLevelConfig(lv)
	return cfg.liveshow or 1
end
function activity_9001661_Read.getFarmIcon(lv)
	local liveshow = activity_9001661_Read.getLevelConfigLiveshow(lv)
	return string.format("activity_bg_9001661_%.2d.png", tonumber(liveshow))
end
function activity_9001661_Read.getFarmSmallIcon(lv)
	local liveshow = activity_9001661_Read.getLevelConfigLiveshow(lv)
	return string.format("farm_ model%d.png", tonumber(liveshow))
end
function activity_9001661_Read.getItemID(...)
	for i, v in ipairs(activity_9001661_Read.getAllLevelConfig()) do
		local itemID = v.dailyitem and v.dailyitem[1]
		if itemID then
			return itemID
		end
	end
	return 870401
end
_UPVALUE2_ = nil
;(nil)[1] = "farm_gold_cost"
;(nil)[2] = true
activity_9001661_Read:defineValue("farm_gold_cost", nil)
function activity_9001661_Read.getGoldCostConfig(time)
	local cfg = activity_9001661_Read.farm_gold_cost
	return cfg[time] or cfg[#cfg]
end
function activity_9001661_Read.getCostGold(time)
	local cfg = activity_9001661_Read.getGoldCostConfig(time)
	return cfg.CostGold
end
_UPVALUE2_ = nil
;(nil)[1] = "farm_rank"
;(nil)[2] = true
activity_9001661_Read:defineValue("farm_rank", nil)
activity_9001661_Read:defineValue("farmRankConfig", function()
	return activity_9001661_Read.getClassTypeConfig(activity_9001661_Read.farm_rank, "type")
end)
function activity_9001661_Read.getFarmRankConfig(...)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = activityShowCtrl:getParamClassType(gActivityTimeActivityID.BUBBLE_GRANGE_ACTIVITY)
	local farmRankConfig = activity_9001661_Read.farmRankConfig
	return farmRankConfig[classType] or farmRankConfig[1]
end
return activity_9001661_Read
