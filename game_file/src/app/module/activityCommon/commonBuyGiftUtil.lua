local _ENV, commonBuyGiftUtil
local _ENV, rechargeCfgFuncMap
rechargeCfgFuncMap[gActivityTimeActivityID.NORMAL_ACTIVITY_9001699] = function(activityID)
	local activityCommonKitchenRead = include("activityCommonKitchenRead")
	return activityCommonKitchenRead.getRechargeCfg(activityID)
end
rechargeCfgFuncMap[gActivityTimeActivityID.NORMAL_ACTIVITY_9001704] = function(activityID)
	local activity_9001704_Read = include("activity_9001704_Read")
	return activity_9001704_Read.getRechargeCfg(activityID)
end
rechargeCfgFuncMap[gActivityTimeActivityID.ANGRY_SNOW_WOLF_KING_ACTIVITY] = function(activityID)
	local monsterpalaceltCtrl = gModuleMgr.sharedMgr("monsterpalaceltCtrl")
	return monsterpalaceltCtrl:getRechargeCfg(activityID)
end
rechargeCfgFuncMap[gActivityTimeActivityID.FLYING_CHESS_ACTIVITY] = function(activityID)
	local activity_9001731_Read = include("activity_9001731_Read")
	return activity_9001731_Read.getRechargeCfg(1)
end
rechargeCfgFuncMap[gActivityTimeActivityID.GREEN_GRASS_FLIP_ACTIVITY] = function(activityID)
	local activity_9001738_Read = include("activity_9001738_Read")
	return activity_9001738_Read.getAdvanceRechargeCfg()
end
rechargeCfgFuncMap[gActivityTimeActivityID.FOOTBALL_TREASURE_ACTIVITY] = function(activityID)
	local activity_9001733_Read = include("activity_9001733_Read")
	return activity_9001733_Read.getAdvanceRechargeCfg()
end
rechargeCfgFuncMap[gActivityTimeActivityID.NORMAL_ACTIVITY_9001732] = function(activityID, params)
	local activityCommonDecreeRead = include("activityCommonDecreeRead")
	local rewardType = params and params.rewardType
	return activityCommonDecreeRead.getRechargeCfg(activityID, rewardType)
end
rechargeCfgFuncMap[gActivityTimeActivityID.GREEN_GRASS_PREDICT_ACTIVITY] = function(activityID, params)
	local activity_9001734_Read = include("activity_9001734_Read")
	if params and params.rewardType == 3 then
		return activity_9001734_Read.getSeniorRechargeCfg()
	end
	return activity_9001734_Read.getRechargeCfg(1)
end
rechargeCfgFuncMap[gActivityTimeActivityID.FREE_KICK_MASTER_ACTIVITY] = function(activityID, params)
	local activity_9001735_Read = include("activity_9001735_Read")
	return activity_9001735_Read.getRechargeCfg(1)
end
rechargeCfgFuncMap[gActivityTimeActivityID.NORMAL_ACTIVITY_9001736] = function(activityID, params)
	local activity_9001736_Read = include("activity_9001736_Read")
	return activity_9001736_Read.getAdvanceRechargeCfg()
end
rechargeCfgFuncMap[gActivityTimeActivityID.FOOTBALL_TREASURE_ACTIVITY] = function(activityID, params)
	local activity_9001733_Read = include("activity_9001733_Read")
	return activity_9001733_Read.getAdvanceRechargeCfg()
end
rechargeCfgFuncMap[gActivityTimeActivityID.UNDERWATER_TREASURE_ACTIVITY] = function(activityID, params)
	local activity_9001746_Read = include("activity_9001746_Read")
	return activity_9001746_Read.getAdvanceRechargeCfg()
end
function commonBuyGiftUtil.getRechargeCfg(activityID, params)
	local func = rechargeCfgFuncMap[activityID]
	if func then
		return func(activityID, params)
	end
end
local _ENV, rechargeNameFuncMap = function(activityID, params)
	local func = rechargeCfgFuncMap[activityID]
	if func then
		return func(activityID, params)
	end
end, function(activityID, params)
	local func = rechargeCfgFuncMap[activityID]
	if func then
		return func(activityID, params)
	end
end
rechargeNameFuncMap[gActivityTimeActivityID.NORMAL_ACTIVITY_9001601] = function(rechargeID, activityID)
	local activity_9001601_Read = include("activity_9001601_Read")
	return activity_9001601_Read.getGiftNameByRechargeID(rechargeID)
end
rechargeNameFuncMap[gActivityTimeActivityID.NORMAL_ACTIVITY_9001624] = function(rechargeID, activityID)
	local activity_9001624_Read = include("activity_9001624_Read")
	return activity_9001624_Read.getRechargeName(gActivityTimeActivityID.NORMAL_ACTIVITY_9001624, rechargeID)
end
rechargeNameFuncMap[gActivityTimeActivityID.CELEBRATE_CORBAN] = function(rechargeID, activityID)
	local activity_9001624_Read = include("activity_9001624_Read")
	return activity_9001624_Read.getRechargeName(gActivityTimeActivityID.CELEBRATE_CORBAN, rechargeID)
end
rechargeNameFuncMap[gActivityTimeActivityID.NORMAL_ACTIVITY_9001666] = function(rechargeID, activityID)
	local activity_9001666_Read = include("activity_9001666_Read")
	local rechargeCfg = activity_9001666_Read.getRechargeCfg(rechargeID)
	return rechargeCfg and i18n(rechargeCfg.rechargeName)
end
rechargeNameFuncMap[gActivityTimeActivityID.NORMAL_ACTIVITY_9001705] = function(rechargeID, activityID)
	local activity_9001705_Read = include("activity_9001705_Read")
	local rechargeCfg = activity_9001705_Read.getRechargeCfg(rechargeID)
	return rechargeCfg and i18n(rechargeCfg.rechargeName)
end
rechargeNameFuncMap[gActivityTimeActivityID.ANNIVERSARY_SHOP_2025] = function(rechargeID, activityID)
	local activity_9001713_Read = include("activity_9001713_Read")
	local rechargeCfg = activity_9001713_Read.getRechargeCfg(rechargeID)
	return rechargeCfg and i18n(rechargeCfg.rechargeName)
end
rechargeNameFuncMap[gActivityTimeActivityID.FANTASY_LAND] = function(rechargeID, activityID)
	local activity_9001717_Read = include("activity_9001717_Read")
	return activity_9001717_Read.getRechargeName(rechargeID)
end
rechargeNameFuncMap[gActivityTimeActivityID.NORMAL_ACTIVITY_9001628] = function(rechargeID, activityID)
	local activity_9001628_Read = include("activity_9001628_Read")
	return activity_9001628_Read:getRechargeName(rechargeID)
end
rechargeNameFuncMap[gActivityTimeActivityID.CRESCENT_TREASURE_ACTIVITY] = function(rechargeID, activityID)
	local activity_9001729_Read = include("activity_9001729_Read")
	return activity_9001729_Read:getRechargeName(rechargeID)
end
rechargeNameFuncMap[gActivityTimeActivityID.GREEN_GRASS_FLIP_ACTIVITY] = function(rechargeID, activityID)
	local activity_9001738_Read = include("activity_9001738_Read")
	local rechargeCfg = activity_9001738_Read.getRechargeCfgByID(rechargeID)
	return rechargeCfg and i18n(rechargeCfg.rechargeName)
end
rechargeNameFuncMap[gActivityTimeActivityID.FOOTBALL_TREASURE_ACTIVITY] = function(rechargeID, activityID)
	local activity_9001733_Read = include("activity_9001733_Read")
	return activity_9001733_Read.getRechargeName(rechargeID)
end
rechargeNameFuncMap[gActivityTimeActivityID.UNDERWATER_TREASURE_ACTIVITY] = function(rechargeID, activityID)
	local activity_9001746_Read = include("activity_9001746_Read")
	return activity_9001746_Read.getRechargeName(rechargeID)
end
rechargeNameFuncMap[gActivityTimeActivityID.NORMAL_ACTIVITY_9001732] = function(rechargeID, activityID)
	local activityCommonDecreeRead = include("activityCommonDecreeRead")
	return activityCommonDecreeRead.getRechargeName(activityID, rechargeID)
end
rechargeNameFuncMap[gActivityTimeActivityID.GREEN_GRASS_PREDICT_ACTIVITY] = function(rechargeID, activityID)
	local activity_9001734_Read = include("activity_9001734_Read")
	return activity_9001734_Read.getRechargeName(rechargeID)
end
rechargeNameFuncMap[gActivityTimeActivityID.FREE_KICK_MASTER_ACTIVITY] = function(rechargeID, activityID)
	local activity_9001735_Read = include("activity_9001735_Read")
	return activity_9001735_Read.getRechargeName(rechargeID)
end
function commonBuyGiftUtil.getRechargeName(activityID, rechargeID)
	local func = rechargeNameFuncMap[activityID]
	if func then
		return func(rechargeID, activityID)
	end
	local cfg = commonBuyGiftUtil.getRechargeCfg(activityID)
	if cfg then
		return i18n(cfg.rechargeName)
	end
end
function commonBuyGiftUtil.getRechargeNameByRid(rechargeID)
	for activityID, func in pairs(rechargeNameFuncMap) do
		if func(rechargeID, activityID) then
			return func(rechargeID, activityID)
		end
	end
end
local _ENV, battlePassRewardFuncMap = function(rechargeID)
	for activityID, func in pairs(rechargeNameFuncMap) do
		if func(rechargeID, activityID) then
			return func(rechargeID, activityID)
		end
	end
end, function(rechargeID)
	for activityID, func in pairs(rechargeNameFuncMap) do
		if func(rechargeID, activityID) then
			return func(rechargeID, activityID)
		end
	end
end
battlePassRewardFuncMap[gActivityTimeActivityID.NORMAL_ACTIVITY_9001699] = function(activityID)
	local activityCommonKitchenRead = include("activityCommonKitchenRead")
	return activityCommonKitchenRead.getBattlePassConfig(activityID)
end
battlePassRewardFuncMap[gActivityTimeActivityID.NORMAL_ACTIVITY_9001704] = function(activityID)
	local activity_9001704_Read = include("activity_9001704_Read")
	return activity_9001704_Read.getConfig_battlepass(activityID)
end
battlePassRewardFuncMap[gActivityTimeActivityID.ANGRY_SNOW_WOLF_KING_ACTIVITY] = function(activityID)
	local monsterpalaceltCtrl = gModuleMgr.sharedMgr("monsterpalaceltCtrl")
	return monsterpalaceltCtrl:getRewardList(activityID)
end
battlePassRewardFuncMap[gActivityTimeActivityID.FLYING_CHESS_ACTIVITY] = function(activityID)
	local activity_9001731_Read = include("activity_9001731_Read")
	return activity_9001731_Read.getBattlePassCfg(activityID)
end
battlePassRewardFuncMap[gActivityTimeActivityID.GREEN_GRASS_FLIP_ACTIVITY] = function(activityID)
	local activity_9001738_Read = include("activity_9001738_Read")
	return activity_9001738_Read.getBattlePassCfg(activity_9001738_Read.getClassType(activityID))
end
battlePassRewardFuncMap[gActivityTimeActivityID.FOOTBALL_TREASURE_ACTIVITY] = function(activityID)
	local activity_9001733_Read = include("activity_9001733_Read")
	return activity_9001733_Read.getBattlePassCfg(activity_9001733_Read.getClassType(activityID))
end
battlePassRewardFuncMap[gActivityTimeActivityID.UNDERWATER_TREASURE_ACTIVITY] = function(activityID)
	local activity_9001746_Read = include("activity_9001746_Read")
	return activity_9001746_Read.getBattlePassCfg(activity_9001746_Read.getClassType(activityID))
end
battlePassRewardFuncMap[gActivityTimeActivityID.NORMAL_ACTIVITY_9001732] = function(activityID)
	local activityCommonDecreeRead = include("activityCommonDecreeRead")
	return activityCommonDecreeRead.getRewardConfig(activityID)
end
battlePassRewardFuncMap[gActivityTimeActivityID.GREEN_GRASS_PREDICT_ACTIVITY] = function(activityID)
	local activity_9001734_Read = include("activity_9001734_Read")
	return activity_9001734_Read.getBattlePassCfg(activityID)
end
battlePassRewardFuncMap[gActivityTimeActivityID.FREE_KICK_MASTER_ACTIVITY] = function(activityID)
	local activity_9001735_Read = include("activity_9001735_Read")
	return activity_9001735_Read.getBattlePassCfg(activityID)
end
battlePassRewardFuncMap[gActivityTimeActivityID.NORMAL_ACTIVITY_9001736] = function(activityID)
	local activity_9001736_Read = include("activity_9001736_Read")
	return activity_9001736_Read.getBattlePassCfg(activityID)
end
function commonBuyGiftUtil.getBattlePassConfig(activityID)
	local func = battlePassRewardFuncMap[activityID]
	if func then
		return func(activityID)
	end
end
function commonBuyGiftUtil.getBattlePassRewardList(activityID, rewardType)
	rewardType = rewardType or 2
	local commonBuyGiftUtil, giftAward
	if not commonBuyGiftUtil.getBattlePassConfig(activityID) then
		local commonBuyGiftUtil, rewardConfig = commonBuyGiftUtil.getBattlePassConfig(activityID), commonBuyGiftUtil.getBattlePassConfig(activityID)
	end
	for i, v in ipairs(rewardConfig) do
		local commonBuyGiftUtil, rewards
		if rewardType == 1 then
			rewards = v.normalReward
		elseif rewardType == 2 then
			rewards = v.advanceReward
		elseif rewardType == 3 then
			rewards = v.seniorReward or v.premiumReward
		end
		for i2, v2 in ipairs(rewards) do
			giftAward[v2.id] = giftAward[v2.id] or 0
			giftAward[v2.id] = giftAward[v2.id] + v2.count
		end
	end
	local commonBuyGiftUtil, ret = (for generator), ipairs(rewardConfig)
	for k, v in pairs(giftAward) do
		commonBuyGiftUtil = ipairs(rewards)
		ipairs(rewards).id = k
		ipairs(rewards).count = v
		table.insert(ret, ipairs(rewards))
	end
	return ret
end
return commonBuyGiftUtil
