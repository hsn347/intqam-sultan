local activity_9001720_Read = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "lion_park_level"
;(nil)[2] = true
activity_9001720_Read:defineValue("lion_park_level", nil)
function activity_9001720_Read.getAllLevelConfig()
	return activity_9001720_Read.lion_park_level
end
function activity_9001720_Read.getLevelConfig(lv)
	local lvMax = activity_9001720_Read.getLevelMax()
	lv = math.min(lvMax, lv)
	return activity_9001720_Read.lion_park_level[lv]
end
function activity_9001720_Read.getLevelMax()
	if not activity_9001720_Read.lionLevelMax then
		activity_9001720_Read.lionLevelMax = #activity_9001720_Read.lion_park_level
	end
	return activity_9001720_Read.lionLevelMax
end
function activity_9001720_Read.getLevelByExp(exp)
	local curLv = 1
	for __, cfg in ipairs(activity_9001720_Read.lion_park_level) do
		if exp >= cfg.exp then
			curLv = cfg.level
		else
			break
		end
	end
	return curLv
end
function activity_9001720_Read.getLevelConfigExp(lv)
	local cfg = activity_9001720_Read.getLevelConfig(lv)
	return cfg.exp
end
function activity_9001720_Read.getLevelConfigLiveshow(lv)
	local cfg = activity_9001720_Read.getLevelConfig(lv)
	return cfg.liveshow or "1"
end
function activity_9001720_Read.getTreeIcon(lv, reward)
	local liveshow = activity_9001720_Read.getLevelConfigLiveshow(lv)
	if reward then
		return string.format("9001720_sz_0%d.usm", tonumber(liveshow))
	else
		return "9001720_sz_01.usm"
	end
end
function activity_9001720_Read.getItemID(...)
	for i, v in ipairs(activity_9001720_Read.getAllLevelConfig()) do
		local itemID = v.dailyitem and v.dailyitem[1]
		if itemID then
			return itemID
		end
	end
	return 877901
end
_UPVALUE2_ = nil
;(nil)[1] = "lion_park_gold_cost"
;(nil)[2] = true
activity_9001720_Read:defineValue("lion_park_gold_cost", nil)
function activity_9001720_Read.getGoldCostConfig(time)
	local cfg = activity_9001720_Read.lion_park_gold_cost
	return cfg[time] or cfg[#cfg]
end
function activity_9001720_Read.getCostGold(time)
	local cfg = activity_9001720_Read.getGoldCostConfig(time)
	return cfg.CostGold
end
_UPVALUE2_ = nil
;(nil)[1] = "lion_park_rank"
;(nil)[2] = true
activity_9001720_Read:defineValue("lion_park_rank", nil)
activity_9001720_Read:defineValue("lionRankConfig", function()
	return activity_9001720_Read.getClassTypeConfig(activity_9001720_Read.lion_park_rank, "type")
end)
function activity_9001720_Read.getLionRankConfig(...)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = activityShowCtrl:getParamClassType(gActivityTimeActivityID.LIONPARADISE_ACTIVITY_9001720)
	local lionRankConfig = activity_9001720_Read.lionRankConfig
	return lionRankConfig[classType] or lionRankConfig[1]
end
return activity_9001720_Read
