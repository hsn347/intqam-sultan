local activity_9001734_Read = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "football_betting_achivement"
;(nil)[2] = true
activity_9001734_Read:defineValue("football_betting_achivement", nil)
_UPVALUE2_ = nil
;(nil)[1] = "football_betting_battlepass"
;(nil)[2] = true
activity_9001734_Read:defineValue("football_betting_battlepass", nil)
_UPVALUE2_ = nil
;(nil)[1] = "football_betting_bettitle"
;(nil)[2] = true
activity_9001734_Read:defineValue("football_betting_bettitle", nil)
_UPVALUE2_ = nil
;(nil)[1] = "football_betting_country"
;(nil)[2] = true
activity_9001734_Read:defineValue("football_betting_country", nil)
_UPVALUE2_ = nil
;(nil)[1] = "football_betting_odds"
;(nil)[2] = true
activity_9001734_Read:defineValue("football_betting_odds", nil)
_UPVALUE2_ = nil
;(nil)[1] = "football_betting_option"
;(nil)[2] = true
activity_9001734_Read:defineValue("football_betting_option", nil)
_UPVALUE2_ = nil
;(nil)[1] = "football_betting_prebet"
;(nil)[2] = true
activity_9001734_Read:defineValue("football_betting_prebet", nil)
_UPVALUE2_ = nil
;(nil)[1] = "football_betting_recharge"
;(nil)[2] = true
activity_9001734_Read:defineValue("football_betting_recharge", nil)
activity_9001734_Read:defineValue("battlepassByClass", function()
	local _ENV, ret
	for __, v in ipairs(activity_9001734_Read.football_betting_battlepass) do
		local classType = v.classType
		if not ret[classType] then
			ret[classType], _ENV = ret[classType], ret[classType]
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.normalReward = serviceFunctions.tableFormat(v.normalReward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.advanceReward = serviceFunctions.tableFormat(v.advanceReward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.premiumReward = serviceFunctions.tableFormat(v.premiumReward, nil)
		ret[classType][v.rewardID] = v
	end
	return ret
end)
function activity_9001734_Read.getBattlePassCfg()
	local classType = SoraDGetActivityClassType(gActivityTimeActivityID.GREEN_GRASS_PREDICT_ACTIVITY)
	return activity_9001734_Read.battlepassByClass[classType]
end
activity_9001734_Read:defineValue("achievementByClass", function()
	local byClass = activity_9001734_Read.getClassTypeConfig(activity_9001734_Read.football_betting_achivement, "classType")
	for __, list in pairs(byClass) do
		for __, v in ipairs(list) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.reward = serviceFunctions.tableFormat(v.reward, nil)
		end
	end
	return byClass
end)
function activity_9001734_Read.getAchievementCfg()
	local classType = SoraDGetActivityClassType(gActivityTimeActivityID.GREEN_GRASS_PREDICT_ACTIVITY)
	if not activity_9001734_Read.achievementByClass[classType] then
		_ENV = activity_9001734_Read.achievementByClass[classType]
	end
	return activity_9001734_Read.achievementByClass[classType]
end
function activity_9001734_Read.getAchievementCfgByUniqueId(uniqueID)
	for __, v in ipairs(activity_9001734_Read.getAchievementCfg()) do
		if v.uniqueID == uniqueID then
			return v
		end
	end
end
function activity_9001734_Read.getUniqueIDList()
	local _ENV, ret
	for __, v in ipairs(activity_9001734_Read.getAchievementCfg()) do
		table.insert(ret, v.uniqueID)
	end
	table.sort(ret)
	return ret
end
activity_9001734_Read:defineValue("countryById", function()
	return activity_9001734_Read.changeConfigKey(activity_9001734_Read.football_betting_country, "id")
end)
activity_9001734_Read:defineValue("oddsById", function()
	return activity_9001734_Read.changeConfigKey(activity_9001734_Read.football_betting_odds, "id")
end)
activity_9001734_Read:defineValue("optionById", function()
	return activity_9001734_Read.changeConfigKey(activity_9001734_Read.football_betting_option, "id")
end)
activity_9001734_Read:defineValue("bettitleById", function()
	return activity_9001734_Read.changeConfigKey(activity_9001734_Read.football_betting_bettitle, "id")
end)
function activity_9001734_Read.getCountryCfg(id)
	return activity_9001734_Read.countryById[id]
end
function activity_9001734_Read.getOddsCfg(id)
	return activity_9001734_Read.oddsById[id]
end
function activity_9001734_Read.getOptionCfg(id)
	return activity_9001734_Read.optionById[id]
end
function activity_9001734_Read.getBetTitleCfg(id)
	return activity_9001734_Read.bettitleById[id]
end
activity_9001734_Read:defineValue("prebetByTitleId", function()
	local _ENV, list
	local _ENV, byTitleId
	for _, v in ipairs(activity_9001734_Read.football_betting_prebet) do
		_ENV = nil
		;(nil).title = v.titleID
		_UPVALUE2_ = nil
		;(nil)[1] = "optionid"
		;(nil)[2] = "oddsid"
		local (nil).options, data = serviceFunctions.tableFormat(v.betOption, nil), nil
		byTitleId[v.titleID] = data
		table.insert(list, data)
	end
	_ENV = (for generator)
	ipairs(activity_9001734_Read.football_betting_prebet).list = list
	ipairs(activity_9001734_Read.football_betting_prebet).byTitleId = byTitleId
	return ipairs(activity_9001734_Read.football_betting_prebet)
end)
function activity_9001734_Read.getPrebetCfgList()
	if not activity_9001734_Read.prebetByTitleId.list then
		activity_9001734_Read = activity_9001734_Read.prebetByTitleId.list
	end
	return activity_9001734_Read.prebetByTitleId.list
end
function activity_9001734_Read.getPrebetCfg(titleID)
	return activity_9001734_Read.prebetByTitleId.byTitleId[titleID]
end
function activity_9001734_Read.getOptionOddsId(titleID, optionid)
	local cfg = activity_9001734_Read.getPrebetCfg(titleID)
	if not (cfg and cfg.options) or optionid == nil then
		return
	end
	for _, optionData in ipairs(cfg.options) do
		if tonumber(optionData.optionid) == tonumber(optionid) then
			return optionData.oddsid
		end
	end
end
function activity_9001734_Read.getChampionSelectCfg()
	if not activity_9001734_Read.getPrebetCfg(1) then
		activity_9001734_Read = activity_9001734_Read.getPrebetCfg(1)
	end
	return (activity_9001734_Read.getPrebetCfg(1))
end
activity_9001734_Read:defineValue("rechargeMeta", function()
	local _ENV, byRechargeID
	local _ENV, listByType
	local _ENV, seniorByRewardID
	for __, v in ipairs(activity_9001734_Read.football_betting_recharge) do
		byRechargeID[v.rechargeID] = v
		local t = v.rechargeType
		if not listByType[t] then
			listByType[t], _ENV = listByType[t], listByType[t]
		end
		table.insert(listByType[t], v)
		if t == 2 and v.extraData then
			seniorByRewardID[v.extraData] = v
		end
	end
	_ENV = (for generator)
	ipairs(activity_9001734_Read.football_betting_recharge).byRechargeID = byRechargeID
	ipairs(activity_9001734_Read.football_betting_recharge).listByType = listByType
	ipairs(activity_9001734_Read.football_betting_recharge).seniorByRewardID = seniorByRewardID
	return ipairs(activity_9001734_Read.football_betting_recharge)
end)
function activity_9001734_Read.getSeniorPassReward(rewardID)
	local cfg = activity_9001734_Read.rechargeMeta.seniorByRewardID[rewardID]
	if not cfg or not cfg.reward then
		activity_9001734_Read = cfg.reward
	end
	return cfg.reward
end
function activity_9001734_Read.getSeniorRechargeCfg()
	local list = activity_9001734_Read.rechargeMeta.listByType[2]
	return list and list[1]
end
function activity_9001734_Read.getSeniorPassRewardSummary()
	local _ENV, giftAward
	for __, v in ipairs(activity_9001734_Read.getRechargeCfgList(2)) do
		if not v.reward then
			_ENV = v.reward
		end
		for __, r in ipairs(v.reward) do
			giftAward[r.id] = (giftAward[r.id] or 0) + r.count
		end
	end
	local _ENV, ret = (for generator), ipairs(activity_9001734_Read.getRechargeCfgList(2))
	for id, count in pairs(giftAward) do
		_ENV = activity_9001734_Read.getRechargeCfgList(2)
		activity_9001734_Read.getRechargeCfgList(2).id = id
		activity_9001734_Read.getRechargeCfgList(2).count = count
		table.insert(ret, activity_9001734_Read.getRechargeCfgList(2))
	end
	return ret
end
function activity_9001734_Read.getRechargeCfg(rechargeType)
	local list = activity_9001734_Read.rechargeMeta.listByType[rechargeType]
	if rechargeType == 1 then
		return list[1]
	else
		return list
	end
end
function activity_9001734_Read.getRechargeCfgList(rechargeType)
	if not activity_9001734_Read.rechargeMeta.listByType[rechargeType] then
		activity_9001734_Read = activity_9001734_Read.rechargeMeta.listByType[rechargeType]
	end
	return activity_9001734_Read.rechargeMeta.listByType[rechargeType]
end
function activity_9001734_Read.getRechargeCfgByRechargeID(rechargeID)
	return activity_9001734_Read.rechargeMeta.byRechargeID[rechargeID]
end
function activity_9001734_Read.getDailyRechargeCfgList()
	if not activity_9001734_Read.getRechargeCfgList(3) then
		activity_9001734_Read = activity_9001734_Read.getRechargeCfgList(3)
	end
	return (activity_9001734_Read.getRechargeCfgList(3))
end
function activity_9001734_Read.getRechargeName(rechargeID)
	for rechargeType, cfg in ipairs(activity_9001734_Read.football_betting_recharge) do
		if cfg.rechargeID == rechargeID then
			return i18n(cfg.rechargeName)
		end
	end
end
function activity_9001734_Read.getBattlePassRow(rewardID)
	local map = activity_9001734_Read.getBattlePassCfg()
	return map and map[rewardID]
end
function activity_9001734_Read.getBattlePassMaxRewardID()
	local map = activity_9001734_Read.getBattlePassCfg()
	if not map then
		return 0
	end
	local maxId = 0
	for rid in pairs(map) do
		if rid > maxId then
			maxId = rid
		end
	end
	return maxId
end
return activity_9001734_Read
