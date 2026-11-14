local activity_9001738_Read = include("aAReadClass").new()
local GREEN_GRASS_FLIP_ACTIVITY_ID = gActivityTimeActivityID.GREEN_GRASS_FLIP_ACTIVITY
_UPVALUE2_, _ENV = nil, nil
_UPVALUE2_, (nil).level, (nil)[1] = nil, nil, "memery_flip_level"
_UPVALUE2_, (nil).level, (nil)[2] = nil, nil, "memory_flip_level"
_UPVALUE2_, (nil).card, (nil)[1] = nil, nil, "memery_flip_card"
_UPVALUE2_, (nil).card, (nil)[2] = nil, nil, "memory_flip_card"
_UPVALUE2_, (nil).item, (nil)[1] = nil, nil, "memery_flip_item"
_UPVALUE2_, (nil).item, (nil)[2] = nil, nil, "memory_flip_item"
_UPVALUE2_, (nil).rank, (nil)[1] = nil, nil, "memery_flip_rank"
_UPVALUE2_, (nil).rank, (nil)[2] = nil, nil, "memory_flip_rank"
_UPVALUE2_, (nil).battlePass, (nil)[1] = nil, nil, "memery_flip_battlepass"
_UPVALUE2_, (nil).battlePass, (nil)[2] = nil, nil, "memory_flip_battlepass"
;(nil).recharge, (nil)[1] = nil, "memery_flip_recharge"
;(nil).recharge, (nil)[2] = nil, "memory_flip_recharge"
local SERVER_CONFIG_NAMES
local _ENV, missingConfigNotice
local loadServerConfig = function(configNameList)
	for _, configName in ipairs(configNameList) do
		local ok, config = pcall(function()
			local module = require_data(configName, true, true)
			return module and module.data or nil
		end)
		if ok and type(config) == "table" then
			return config
		end
	end
	local noticeKey = table.concat(configNameList, "/")
	if not missingConfigNotice[noticeKey] then
		missingConfigNotice[noticeKey] = true
		print("activity_9001738_Read missing config:", noticeKey)
	end
	_ENV = print
	return print
end
local formatRewardList = function(rewardList)
	if type(rewardList) ~= "table" then
		_ENV = type(rewardList)
		return (type(rewardList))
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	return serviceFunctions.tableFormat(rewardList, nil)
end
local formatLevelSize = function(levelDesign)
	_ENV = nil
	;(nil).row = tonumber(levelDesign and levelDesign[2]) or 0
	;(nil).col = tonumber(levelDesign and levelDesign[1]) or 0
	return nil
end
local formatRankRange = function(rankList)
	_ENV = nil
	;(nil).min = tonumber(rankList and rankList[1]) or 0
	;(nil).max = tonumber(rankList and rankList[2]) or 0
	return nil
end
local getClassConfig = function(config, classType)
	if type(config) ~= "table" then
		_ENV = type(config)
		return (type(config))
	end
	classType = classType or activity_9001738_Read.getClassType()
	if not config[classType] and not config[1] and not config[next(config)] then
		_ENV = config[next(config)]
	end
	return config[next(config)]
end
local createLevelData = function(name)
	local _ENV, levelConfig
	local _ENV, levelList
	for _, cfg in ipairs(loadServerConfig(SERVER_CONFIG_NAMES.level)) do
		local classType = cfg.classType or 1
		if not levelConfig[classType] then
			_ENV = levelConfig[classType]
		end
		levelConfig[classType] = levelConfig[classType]
		if not levelList[classType] then
			_ENV = levelList[classType]
		end
		levelList[classType] = levelList[classType]
		cfg.levelSize = formatLevelSize(cfg.levelDesign)
		cfg.reward = formatRewardList(cfg.reward)
		levelConfig[classType][cfg.levelID] = cfg
		table.insert(levelList[classType], cfg)
	end
	for _, cfgList in pairs(levelList) do
		table.sort(cfgList, function(a, b)
			return (a.levelID or 0) < (b.levelID or 0)
		end)
	end
	activity_9001738_Read.levelConfig = levelConfig
	activity_9001738_Read.levelList = levelList
	return activity_9001738_Read[name]
end
activity_9001738_Read:defineValue("levelConfig", createLevelData)
activity_9001738_Read:defineValue("levelList", createLevelData)
local createCardData = function(name)
	local _ENV, cardConfig
	local _ENV, cardList
	for _, cfg in ipairs(loadServerConfig(SERVER_CONFIG_NAMES.card)) do
		cardConfig[cfg.cardID] = cfg
		table.insert(cardList, cfg)
	end
	table.sort(cardList, function(a, b)
		return (a.index or 0) < (b.index or 0)
	end)
	activity_9001738_Read.cardConfig = cardConfig
	activity_9001738_Read.cardList = cardList
	return activity_9001738_Read[name]
end
activity_9001738_Read:defineValue("cardConfig", createCardData)
activity_9001738_Read:defineValue("cardList", createCardData)
local createItemData = function(name)
	local _ENV, itemTypeConfig
	local _ENV, itemIDConfig
	local _ENV, itemList
	for _, cfg in ipairs(loadServerConfig(SERVER_CONFIG_NAMES.item)) do
		itemTypeConfig[cfg.itemType] = cfg
		itemIDConfig[cfg.itemID] = cfg
		table.insert(itemList, cfg)
	end
	table.sort(itemList, function(a, b)
		return (a.index or 0) < (b.index or 0)
	end)
	activity_9001738_Read.itemTypeConfig = itemTypeConfig
	activity_9001738_Read.itemIDConfig = itemIDConfig
	activity_9001738_Read.itemList = itemList
	return activity_9001738_Read[name]
end
activity_9001738_Read:defineValue("itemTypeConfig", createItemData)
activity_9001738_Read:defineValue("itemIDConfig", createItemData)
activity_9001738_Read:defineValue("itemList", createItemData)
activity_9001738_Read:defineValue("rankConfig", function()
	local _ENV, rankConfig
	for _, cfg in ipairs(loadServerConfig(SERVER_CONFIG_NAMES.rank)) do
		local classType = cfg.classType or 1
		if not rankConfig[classType] then
			_ENV = rankConfig[classType]
		end
		rankConfig[classType] = rankConfig[classType]
		cfg.rankRange = formatRankRange(cfg.rank)
		cfg.reward = formatRewardList(cfg.reward)
		table.insert(rankConfig[classType], cfg)
	end
	for _, cfgList in pairs(rankConfig) do
		table.sort(cfgList, function(a, b)
			local rankA = a.rankRange or formatRankRange(a.rank)
			local rankB = b.rankRange or formatRankRange(b.rank)
			if rankA.min == rankB.min then
				return (a.index or 0) < (b.index or 0)
			end
			return rankA.min < rankB.min
		end)
	end
	return rankConfig
end)
local createBattlePassData = function(name)
	local _ENV, battlePassConfig
	local _ENV, battlePassList
	for _, cfg in ipairs(loadServerConfig(SERVER_CONFIG_NAMES.battlePass)) do
		local classType = cfg.classType or 1
		if not battlePassConfig[classType] then
			_ENV = battlePassConfig[classType]
		end
		battlePassConfig[classType] = battlePassConfig[classType]
		if not battlePassList[classType] then
			_ENV = battlePassList[classType]
		end
		battlePassList[classType] = battlePassList[classType]
		cfg.normalReward = formatRewardList(cfg.normalReward)
		cfg.advanceReward = formatRewardList(cfg.advanceReward)
		battlePassConfig[classType][cfg.rewardID] = cfg
		table.insert(battlePassList[classType], cfg)
	end
	for _, cfgList in pairs(battlePassList) do
		table.sort(cfgList, function(a, b)
			return (a.rewardID or 0) < (b.rewardID or 0)
		end)
	end
	activity_9001738_Read.battlePassConfig = battlePassConfig
	activity_9001738_Read.battlePassList = battlePassList
	return activity_9001738_Read[name]
end
activity_9001738_Read:defineValue("battlePassConfig", createBattlePassData)
activity_9001738_Read:defineValue("battlePassList", createBattlePassData)
local createRechargeData = function(name)
	local _ENV, rechargeConfig
	local _ENV, rechargeIDConfig
	for _, cfg in ipairs(loadServerConfig(SERVER_CONFIG_NAMES.recharge)) do
		if not cfg.discount then
			_ENV = cfg.discount
		end
		SERVER_CONFIG_NAMES = loadServerConfig(SERVER_CONFIG_NAMES.recharge)
		loadServerConfig(SERVER_CONFIG_NAMES.recharge)[1] = "val"
		loadServerConfig(SERVER_CONFIG_NAMES.recharge)[2] = "rate"
		cfg.discount = serviceFunctions.tableFormat(cfg.discount, loadServerConfig(SERVER_CONFIG_NAMES.recharge))
		cfg.reward = formatRewardList(cfg.reward)
		rechargeIDConfig[cfg.rechargeID] = cfg
		table.insert(rechargeConfig, cfg)
	end
	table.sort(rechargeConfig, function(a, b)
		return (a.index or 0) < (b.index or 0)
	end)
	activity_9001738_Read.rechargeConfig = rechargeConfig
	activity_9001738_Read.rechargeIDConfig = rechargeIDConfig
	return activity_9001738_Read[name]
end
activity_9001738_Read:defineValue("rechargeConfig", createRechargeData)
activity_9001738_Read:defineValue("rechargeIDConfig", createRechargeData)
function activity_9001738_Read.getClassType(activityID)
	return SoraDGetActivityClassType(activityID or GREEN_GRASS_FLIP_ACTIVITY_ID)
end
function activity_9001738_Read.getLevelList(classType)
	return getClassConfig(activity_9001738_Read.levelList, classType)
end
function activity_9001738_Read.getLevelCfg(levelID, classType)
	return getClassConfig(activity_9001738_Read.levelConfig, classType)[levelID]
end
function activity_9001738_Read.getLevelReward(levelID, classType)
	local cfg = activity_9001738_Read.getLevelCfg(levelID, classType)
	if not cfg or not cfg.reward then
		activity_9001738_Read = cfg.reward
	end
	return cfg.reward
end
function activity_9001738_Read.getLevelSize(levelID, classType)
	local cfg = activity_9001738_Read.getLevelCfg(levelID, classType)
	if not cfg or not cfg.levelSize then
		activity_9001738_Read = cfg.levelSize
		cfg.levelSize.row = 0
		cfg.levelSize.col = 0
	end
	return cfg.levelSize
end
function activity_9001738_Read.getPrevLevelID(levelID, classType)
	levelID = tonumber(levelID) or 0
	local prevLevelID = 0
	for _, cfg in ipairs(activity_9001738_Read.getLevelList(classType)) do
		if (cfg.levelID or 0) == levelID then
			return prevLevelID
		end
		prevLevelID = cfg.levelID or prevLevelID
	end
	return math.max(levelID - 1, 0)
end
function activity_9001738_Read.getMaxLevelID(classType)
	local cfgList = activity_9001738_Read.getLevelList(classType)
	local lastCfg = cfgList[#cfgList]
	return lastCfg and lastCfg.levelID or 0
end
function activity_9001738_Read.getCardList()
	if not activity_9001738_Read.cardList then
		activity_9001738_Read = activity_9001738_Read.cardList
	end
	return activity_9001738_Read.cardList
end
function activity_9001738_Read.getCardCfg(cardID)
	return activity_9001738_Read.cardConfig[cardID]
end
function activity_9001738_Read.getCardPic(cardID)
	local cfg = activity_9001738_Read.getCardCfg(cardID)
	return cfg and cfg.cardpic or nil
end
function activity_9001738_Read.getItemList()
	if not activity_9001738_Read.itemList then
		activity_9001738_Read = activity_9001738_Read.itemList
	end
	return activity_9001738_Read.itemList
end
function activity_9001738_Read.getItemCfgByType(itemType)
	return activity_9001738_Read.itemTypeConfig[itemType]
end
function activity_9001738_Read.getItemCfgByID(itemID)
	return activity_9001738_Read.itemIDConfig[itemID]
end
function activity_9001738_Read.getRankCfg(classType)
	return getClassConfig(activity_9001738_Read.rankConfig, classType)
end
function activity_9001738_Read.getRankRewardCfg(rank, classType)
	for _, cfg in ipairs(activity_9001738_Read.getRankCfg(classType)) do
		local rankRange = cfg.rankRange or formatRankRange(cfg.rank)
		if rank >= rankRange.min and rank <= rankRange.max then
			return cfg
		end
	end
	return nil
end
function activity_9001738_Read.getBattlePassCfg(classType)
	return getClassConfig(activity_9001738_Read.battlePassList, classType)
end
function activity_9001738_Read.getBattlePassRewardCfg(rewardID, classType)
	return getClassConfig(activity_9001738_Read.battlePassConfig, classType)[rewardID]
end
function activity_9001738_Read.getMaxBattlePassRewardID(classType)
	local cfgList = activity_9001738_Read.getBattlePassCfg(classType)
	local lastCfg = cfgList[#cfgList]
	return lastCfg and lastCfg.rewardID or 0
end
function activity_9001738_Read.getAdvanceRewards(classType)
	local _ENV, rewards
	for _, cfg in ipairs(activity_9001738_Read.getBattlePassCfg(classType)) do
		if not cfg.advanceReward then
			_ENV = cfg.advanceReward
		end
		for _, reward in ipairs(cfg.advanceReward) do
			table.insert(rewards, reward)
		end
	end
	return SoraDMergeRewards(rewards)
end
function activity_9001738_Read.getRechargeList()
	if not activity_9001738_Read.rechargeConfig then
		activity_9001738_Read = activity_9001738_Read.rechargeConfig
	end
	return activity_9001738_Read.rechargeConfig
end
function activity_9001738_Read.getRechargeCfgByID(rechargeID)
	return activity_9001738_Read.rechargeIDConfig[rechargeID]
end
function activity_9001738_Read.getAdvanceRechargeCfg()
	for _, cfg in ipairs(activity_9001738_Read.getRechargeList()) do
		if cfg.rechargeType == 1 then
			return cfg
		end
	end
	return nil
end
function activity_9001738_Read.getDailyRechargeCfgList()
	local _ENV, ret
	for _, cfg in ipairs(activity_9001738_Read.getRechargeList()) do
		if cfg.rechargeType == 2 then
			table.insert(ret, cfg)
		end
	end
	return ret
end
function activity_9001738_Read.getRechargeName(rechargeID)
	local cfg = activity_9001738_Read.getRechargeCfgByID(rechargeID)
	return cfg and i18n(cfg.rechargeName) or rechargeID
end
return activity_9001738_Read
