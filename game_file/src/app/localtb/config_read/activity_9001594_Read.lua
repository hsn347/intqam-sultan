local activity_9001594_Read = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "datepalm_tree_level"
;(nil)[2] = true
activity_9001594_Read:defineValue("datepalm_tree_level", nil)
function activity_9001594_Read.getAllLevelConfig()
	return activity_9001594_Read.datepalm_tree_level
end
function activity_9001594_Read.getLevelConfig(lv)
	local lvMax = activity_9001594_Read.getLevelMax()
	lv = math.min(lvMax, lv)
	return activity_9001594_Read.datepalm_tree_level[lv]
end
function activity_9001594_Read.getLevelMax()
	if not activity_9001594_Read.treeLevelMax then
		activity_9001594_Read.treeLevelMax = #activity_9001594_Read.datepalm_tree_level
	end
	return activity_9001594_Read.treeLevelMax
end
function activity_9001594_Read.getLevelByExp(exp)
	local curLv = 1
	for __, cfg in ipairs(activity_9001594_Read.datepalm_tree_level) do
		if exp >= cfg.exp then
			curLv = cfg.level
		else
			break
		end
	end
	return curLv
end
function activity_9001594_Read.getLevelConfigExp(lv)
	local cfg = activity_9001594_Read.getLevelConfig(lv)
	return cfg.exp
end
function activity_9001594_Read.getLevelConfigLiveshow(lv)
	local cfg = activity_9001594_Read.getLevelConfig(lv)
	return cfg.liveshow or "1"
end
function activity_9001594_Read.getTreeIcon(lv, reward)
	local liveshow = activity_9001594_Read.getLevelConfigLiveshow(lv)
	if reward then
		return string.format("activity_bg_9001594_%d2.png", tonumber(liveshow))
	else
		return string.format("activity_bg_9001594_%d1.png", tonumber(liveshow))
	end
end
function activity_9001594_Read.getItemID(...)
	for i, v in ipairs(activity_9001594_Read.getAllLevelConfig()) do
		local itemID = v.dailyitem and v.dailyitem[1]
		if itemID then
			return itemID
		end
	end
	return 868001
end
_UPVALUE2_ = nil
;(nil)[1] = "datepalm_gold_cost"
;(nil)[2] = true
activity_9001594_Read:defineValue("datepalm_gold_cost", nil)
function activity_9001594_Read.getGoldCostConfig(time)
	local cfg = activity_9001594_Read.datepalm_gold_cost
	return cfg[time] or cfg[#cfg]
end
function activity_9001594_Read.getCostGold(time)
	local cfg = activity_9001594_Read.getGoldCostConfig(time)
	return cfg.CostGold
end
_UPVALUE2_ = nil
;(nil)[1] = "datepalm_tree_rank"
;(nil)[2] = true
activity_9001594_Read:defineValue("datepalm_tree_rank", nil)
activity_9001594_Read:defineValue("treeRankConfig", function()
	return activity_9001594_Read.getClassTypeConfig(activity_9001594_Read.datepalm_tree_rank, "type")
end)
function activity_9001594_Read.getTreeRankConfig(...)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = activityShowCtrl:getParamClassType(gActivityTimeActivityID.PLANT_DATA_PALM_ACTIVITY)
	local treeRankConfig = activity_9001594_Read.treeRankConfig
	return treeRankConfig[classType] or treeRankConfig[1]
end
return activity_9001594_Read
