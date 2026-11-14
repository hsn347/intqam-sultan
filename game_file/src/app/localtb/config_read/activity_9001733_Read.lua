local activity_9001733_Read = include("aAReadClass").new()
local itemDesRead = include("itemDesRead")
local jumpDesRead = include("jumpDesRead")
local FOOTBALL_TREASURE_ACTIVITY_ID = gActivityTimeActivityID.FOOTBALL_TREASURE_ACTIVITY
local buildCommonGetwayData = function(sourceId)
	sourceId = tonumber(sourceId) or 0
	if sourceId <= 0 then
		return nil
	end
	local cfg = jumpDesRead.getCfg(sourceId)
	if not cfg then
		return nil
	end
	_ENV = nil
	;(nil).sourceId = sourceId
	;(nil).title = i18n(cfg.des)
	;(nil).icon = cfg.icon or ""
	return nil
end
_UPVALUE2_ = nil
_UPVALUE1_ = nil
;(nil).keyMap, (nil)[1] = nil, "key"
;(nil)[1] = "worldcup_2026_constant"
;(nil)[2] = true
activity_9001733_Read:defineValue("constant", nil)
function activity_9001733_Read.getConstValue(key, defaultValue)
	local info = activity_9001733_Read.constant[key]
	if info and info.value then
		return info.value[1]
	end
	return defaultValue
end
function activity_9001733_Read.getArrayValue(key, defaultValue)
	local info = activity_9001733_Read.constant[key]
	if info and info.value then
		return info.value
	end
	return defaultValue
end
function activity_9001733_Read.getConstCostValue(key, defaultID, defaultCount)
	activity_9001733_Read = nil
	local value = activity_9001733_Read.getArrayValue(key, nil)
	activity_9001733_Read = key
	key.id = tonumber(value[1]) or defaultID or 0
	key.count = tonumber(value[2]) or defaultCount or 0
	return key
end
function activity_9001733_Read.createMainData(name)
	local _ENV, mainConfig
	local _ENV, mainList
	if not require_data("football_treasure_main", true, true).data then
		local _ENV, cfgList = require_data("football_treasure_main", true, true).data, require_data("football_treasure_main", true, true).data
	end
	for _, cfg in ipairs(cfgList) do
		mainConfig[cfg.factoryLv] = cfg
		table.insert(mainList, cfg)
	end
	table.sort(mainList, function(a, b)
		return (a.factoryLv or 0) < (b.factoryLv or 0)
	end)
	activity_9001733_Read.mainConfig = mainConfig
	activity_9001733_Read.mainList = mainList
	return activity_9001733_Read[name]
end
activity_9001733_Read:defineValue("mainConfig", activity_9001733_Read.createMainData)
activity_9001733_Read:defineValue("mainList", activity_9001733_Read.createMainData)
function activity_9001733_Read.createBattlePassData(name)
	local _ENV, battlePassConfig
	local _ENV, battlePassList
	if not require_data("football_treasure_battlepass", true, true).data then
		local _ENV, cfgList = require_data("football_treasure_battlepass", true, true).data, require_data("football_treasure_battlepass", true, true).data
	end
	for _, rawCfg in ipairs(cfgList) do
		local cfg = clone(rawCfg)
		local classType = tonumber(cfg.classType) or 1
		if not battlePassConfig[classType] then
			_ENV = battlePassConfig[classType]
		end
		battlePassConfig[classType] = battlePassConfig[classType]
		if not battlePassList[classType] then
			_ENV = battlePassList[classType]
		end
		battlePassList[classType] = battlePassList[classType]
		cfg.normalReward = activity_9001733_Read.formatRewardList(cfg.normalReward)
		cfg.advanceReward = activity_9001733_Read.formatRewardList(cfg.advanceReward)
		cfg.buffUp = tonumber(cfg.buffUp) or 0
		battlePassConfig[classType][cfg.rewardID] = cfg
		table.insert(battlePassList[classType], cfg)
	end
	for _, list in pairs(battlePassList) do
		table.sort(list, function(a, b)
			return (a.rewardID or 0) < (b.rewardID or 0)
		end)
	end
	activity_9001733_Read.battlePassConfig = battlePassConfig
	activity_9001733_Read.battlePassList = battlePassList
	return activity_9001733_Read[name]
end
activity_9001733_Read:defineValue("battlePassConfig", activity_9001733_Read.createBattlePassData)
activity_9001733_Read:defineValue("battlePassList", activity_9001733_Read.createBattlePassData)
function activity_9001733_Read.createRechargeData(name)
	local _ENV, rechargeConfig
	local _ENV, rechargeIDConfig
	if not require_data("football_treasure_recharge", true, true).data then
		local _ENV, cfgList = require_data("football_treasure_recharge", true, true).data, require_data("football_treasure_recharge", true, true).data
	end
	for _, rawCfg in ipairs(cfgList) do
		local cfg = clone(rawCfg)
		cfg.discount = activity_9001733_Read.formatDiscountList(cfg.discount)
		rechargeIDConfig[cfg.rechargeID] = cfg
		table.insert(rechargeConfig, cfg)
	end
	table.sort(rechargeConfig, function(a, b)
		return (a.index or 0) < (b.index or 0)
	end)
	activity_9001733_Read.rechargeConfig = rechargeConfig
	activity_9001733_Read.rechargeIDConfig = rechargeIDConfig
	return activity_9001733_Read[name]
end
activity_9001733_Read:defineValue("rechargeConfig", activity_9001733_Read.createRechargeData)
activity_9001733_Read:defineValue("rechargeIDConfig", activity_9001733_Read.createRechargeData)
function activity_9001733_Read.createTaskData()
	local _ENV, taskConfig
	if not require_data("football_treasure_task", true, true).data then
		local _ENV, cfgList = require_data("football_treasure_task", true, true).data, require_data("football_treasure_task", true, true).data
	end
	for _, cfg in ipairs(cfgList) do
		taskConfig[tonumber(cfg.classType) or 1] = cfg
	end
	return taskConfig
end
activity_9001733_Read:defineValue("taskConfig", activity_9001733_Read.createTaskData)
function activity_9001733_Read.createShootData(name)
	local _ENV, shootConfig
	local _ENV, shootPoolConfig
	local _ENV, shootRoundList
	local _ENV, shootRoundMap
	if not require_data("football_treasure_shoot", true, true).data then
		local _ENV, cfgList = require_data("football_treasure_shoot", true, true).data, require_data("football_treasure_shoot", true, true).data
	end
	for _, rawCfg in ipairs(cfgList) do
		local cfg = clone(rawCfg)
		local classType = tonumber(cfg.classType) or 1
		local turnMin = tonumber(type(cfg.turn) == "table" and cfg.turn[1] or cfg.turn) or 0
		local turnMax = tonumber(type(cfg.turn) == "table" and cfg.turn[2] or cfg.turn) or turnMin
		if turnMin > turnMax then
			turnMin, turnMax = turnMax, turnMin
		end
		local rewardPool = tonumber(cfg.rewardPool) or 0
		if not shootConfig[classType] then
			_ENV = shootConfig[classType]
		end
		shootConfig[classType] = shootConfig[classType]
		if not shootPoolConfig[classType] then
			_ENV = shootPoolConfig[classType]
		end
		shootPoolConfig[classType] = shootPoolConfig[classType]
		if not shootRoundList[classType] then
			_ENV = shootRoundList[classType]
		end
		shootRoundList[classType] = shootRoundList[classType]
		if not shootRoundMap[classType] then
			_ENV = shootRoundMap[classType]
		end
		shootRoundMap[classType] = shootRoundMap[classType]
		cfg.rewardBox = activity_9001733_Read.formatRewardList(cfg.rewardBox)
		cfg.normalReward = activity_9001733_Read.formatShootRewardList(cfg.normalReward)
		_UPVALUE2_, cfg.normalNum = tonumber(cfg.normalNum) or 0, tonumber(cfg.normalNum) or 0
		cfg.turn, (tonumber(cfg.normalNum) or 0)[1] = tonumber(cfg.normalNum) or 0, turnMin
		cfg.turn, (tonumber(cfg.normalNum) or 0)[2] = tonumber(cfg.normalNum) or 0, turnMax
		cfg.turnMin = turnMin
		cfg.turnMax = turnMax
		local roundKey = string.format("%s_%s", turnMin, turnMax)
		if not shootRoundMap[classType][roundKey] then
			_ENV = turnMin
			turnMin.turn = cfg.turn
			turnMin.turnMin = turnMin
			shootRoundMap[classType][roundKey], turnMin.list, _ENV, turnMin.turnMax = turnMin, cfg.turn, cfg.turn, turnMax
			table.insert(shootRoundList[classType], shootRoundMap[classType][roundKey])
		end
		table.insert(shootRoundMap[classType][roundKey].list, cfg)
		for turn = turnMin, turnMax do
			if not shootConfig[classType][turn] then
				_ENV = shootConfig[classType][turn]
			end
			shootConfig[classType][turn] = shootConfig[classType][turn]
			if not shootPoolConfig[classType][turn] then
				_ENV = shootPoolConfig[classType][turn]
			end
			shootPoolConfig[classType][turn] = shootPoolConfig[classType][turn]
			table.insert(shootConfig[classType][turn], cfg)
			shootPoolConfig[classType][turn][rewardPool] = cfg
		end
	end
	for _, turnMap in pairs(shootConfig) do
		for _, list in pairs(turnMap) do
			table.sort(list, function(a, b)
				return (a.rewardPool or 0) < (b.rewardPool or 0)
			end)
		end
	end
	for _, roundList in pairs(shootRoundList) do
		table.sort(roundList, function(a, b)
			if (a.turnMin or 0) == (b.turnMin or 0) then
				return (a.turnMax or 0) < (b.turnMax or 0)
			end
			return (a.turnMin or 0) < (b.turnMin or 0)
		end)
		for _, roundInfo in ipairs(roundList) do
			table.sort(roundInfo.list, function(a, b)
				return (a.rewardPool or 0) < (b.rewardPool or 0)
			end)
		end
	end
	activity_9001733_Read.shootConfig = shootConfig
	activity_9001733_Read.shootPoolConfig = shootPoolConfig
	activity_9001733_Read.shootRoundList = shootRoundList
	return activity_9001733_Read[name]
end
activity_9001733_Read:defineValue("shootConfig", activity_9001733_Read.createShootData)
activity_9001733_Read:defineValue("shootPoolConfig", activity_9001733_Read.createShootData)
activity_9001733_Read:defineValue("shootRoundList", activity_9001733_Read.createShootData)
function activity_9001733_Read.getClassType(activityID)
	return SoraDGetActivityClassType(activityID or FOOTBALL_TREASURE_ACTIVITY_ID)
end
function activity_9001733_Read.getFactoryCfg(factoryLv)
	return activity_9001733_Read.mainConfig[tonumber(factoryLv) or 0]
end
function activity_9001733_Read.getFactoryList()
	if not activity_9001733_Read.mainList then
		activity_9001733_Read = activity_9001733_Read.mainList
	end
	return activity_9001733_Read.mainList
end
function activity_9001733_Read.getBaseFactoryEfficiency()
	local cfg = activity_9001733_Read.getFactoryCfg(1)
	return cfg and cfg.efficiency or 0
end
function activity_9001733_Read.getBattlePassSpeedRate(classType, battlePassLv)
	return math.floor((1 + activity_9001733_Read.getBattlePassBuff(classType, battlePassLv)) * 100)
end
function activity_9001733_Read.getMaxFactoryLv()
	local list = activity_9001733_Read.getFactoryList()
	local cfg = list[#list]
	return cfg and cfg.factoryLv or 0
end
function activity_9001733_Read.getBattlePassCfg(classType)
	return activity_9001733_Read.getClassConfig(activity_9001733_Read.battlePassList, classType)
end
function activity_9001733_Read.getBattlePassRewardCfg(rewardID, classType)
	return activity_9001733_Read.getClassConfig(activity_9001733_Read.battlePassConfig, classType)[tonumber(rewardID) or 0]
end
function activity_9001733_Read.getMaxBattlePassRewardID(classType)
	local list = activity_9001733_Read.getBattlePassCfg(classType)
	local cfg = list[#list]
	return cfg and cfg.rewardID or 0
end
function activity_9001733_Read.getBattlePassBuff(classType, battlePassLv)
	battlePassLv = tonumber(battlePassLv) or 0
	local buff = 0
	for _, cfg in ipairs(activity_9001733_Read.getBattlePassCfg(classType)) do
		if battlePassLv < (cfg.rewardID or 0) then
			break
		end
		buff = tonumber(cfg.buffUp) or 0
	end
	return buff / 10000
end
function activity_9001733_Read.getBattlePassBuffRewardData(cfg)
	local buffIcon = cfg.bufficon
	local buffTip = i18n(cfg.buffDes)
	_ENV = cfg.buffDes
	cfg.buffDes.isCustomReward = true
	cfg.buffDes.icon = buffIcon
	cfg.buffDes.customName = ""
	cfg.buffDes.customTip = buffTip
	return cfg.buffDes
end
function activity_9001733_Read.getBattlePassExpNeed()
	return tonumber(activity_9001733_Read.getConstValue("FOOTBALL_TREASURE_BATTLEPASS_EXP_NEED", 0)) or 0
end
function activity_9001733_Read.getRechargeList()
	if not activity_9001733_Read.rechargeConfig then
		activity_9001733_Read = activity_9001733_Read.rechargeConfig
	end
	return activity_9001733_Read.rechargeConfig
end
function activity_9001733_Read.getRechargeCfgByID(rechargeID)
	return activity_9001733_Read.rechargeIDConfig[tonumber(rechargeID) or 0]
end
function activity_9001733_Read.getAdvanceRechargeCfg()
	for _, cfg in ipairs(activity_9001733_Read.getRechargeList()) do
		if cfg.rechargeType == 1 then
			return cfg
		end
	end
	return nil
end
function activity_9001733_Read.getDailyRechargeCfgList()
	local _ENV, ret
	for _, cfg in ipairs(activity_9001733_Read.getRechargeList()) do
		if cfg.rechargeType == 2 then
			table.insert(ret, cfg)
		end
	end
	return ret
end
function activity_9001733_Read.getRechargeName(rechargeID)
	local cfg = activity_9001733_Read.getRechargeCfgByID(rechargeID)
	return cfg and i18n(cfg.rechargeName) or rechargeID
end
function activity_9001733_Read.getGetwayList(itemID)
	itemID = tonumber(itemID) or 0
	local _ENV, ret = tonumber(itemID), tonumber(itemID)
	if not itemDesRead.getOutput(itemID) then
		_ENV = itemDesRead.getOutput(itemID)
	end
	for _, sourceId in ipairs((itemDesRead.getOutput(itemID))) do
		local data = buildCommonGetwayData(sourceId)
		if data then
			table.insert(ret, data)
		end
	end
	return ret
end
function activity_9001733_Read.getTaskCfg(classType)
	return activity_9001733_Read.getClassConfig(activity_9001733_Read.taskConfig, classType)
end
function activity_9001733_Read.getTaskQuestIDList(classType)
	local cfg = activity_9001733_Read.getTaskCfg(classType)
	if not cfg or not cfg.questId then
		activity_9001733_Read = cfg.questId
	end
	return cfg.questId
end
function activity_9001733_Read.getShootCfg(turn, rewardPool, classType)
	classType = tonumber(classType) or activity_9001733_Read.getClassType()
	turn = tonumber(turn) or 0
	rewardPool = tonumber(rewardPool) or 0
	if not activity_9001733_Read.shootPoolConfig[classType] then
		local _ENV, classMap = activity_9001733_Read.shootPoolConfig[classType], activity_9001733_Read.shootPoolConfig[classType]
	end
	if not classMap[turn] then
		local _ENV, turnMap = classMap[turn], classMap[turn]
	end
	return turnMap[rewardPool]
end
function activity_9001733_Read.getShootList(turn, classType)
	classType = tonumber(classType) or activity_9001733_Read.getClassType()
	turn = tonumber(turn) or 0
	if not activity_9001733_Read.shootConfig[classType] then
		local _ENV, classMap = activity_9001733_Read.shootConfig[classType], activity_9001733_Read.shootConfig[classType]
	end
	if not classMap[turn] then
		_ENV = classMap[turn]
	end
	return classMap[turn]
end
function activity_9001733_Read.getShootTurnInfo(turn, classType)
	classType = tonumber(classType) or activity_9001733_Read.getClassType()
	turn = tonumber(turn) or 0
	if not activity_9001733_Read.shootRoundList[classType] then
		local _ENV, roundList = activity_9001733_Read.shootRoundList[classType], activity_9001733_Read.shootRoundList[classType]
	end
	for _, roundInfo in ipairs(roundList) do
		if turn >= (roundInfo.turnMin or 0) and turn <= (roundInfo.turnMax or 0) then
			return roundInfo
		end
	end
	return roundList[1]
end
function activity_9001733_Read.getNextShootTurnInfo(turn, classType)
	classType = tonumber(classType) or activity_9001733_Read.getClassType()
	if not activity_9001733_Read.shootRoundList[classType] then
		local _ENV, roundList = activity_9001733_Read.shootRoundList[classType], activity_9001733_Read.shootRoundList[classType]
	end
	local currentInfo = activity_9001733_Read.getShootTurnInfo(turn, classType)
	if not currentInfo then
		return roundList[1]
	end
	for _, roundInfo in ipairs(roundList) do
		if (roundInfo.turnMin or 0) > (currentInfo.turnMax or 0) then
			return roundInfo
		end
	end
	return currentInfo
end
function activity_9001733_Read.getMaxShootTurn(classType)
	classType = tonumber(classType) or activity_9001733_Read.getClassType()
	local maxTurn = 0
	if not activity_9001733_Read.shootConfig[classType] then
		_ENV = activity_9001733_Read.shootConfig[classType]
	end
	for turn in pairs(activity_9001733_Read.shootConfig[classType]) do
		maxTurn = math.max(maxTurn, tonumber(turn) or 0)
	end
	return maxTurn
end
function activity_9001733_Read.getShootCost()
	return activity_9001733_Read.getConstCostValue("FOOTBALL_TREASURE_SHOOT_COST", 882001, 1)
end
function activity_9001733_Read.getRemakeItemCost()
	return activity_9001733_Read.getConstCostValue("FOOTBALL_TREASURE_REMAKE_ITEM_COST", 882101, 1)
end
function activity_9001733_Read.getDailyFreeRemakeTimes()
	return tonumber(activity_9001733_Read.getConstValue("FOOTBALL_TREASURE_DAILY_FREE_REMAKE", 0)) or 0
end
function activity_9001733_Read.getMaxMakeTime()
	return tonumber(activity_9001733_Read.getConstValue("FOOTBALL_TREASURE_MAX_MAKE_TIME", 0)) or 0
end
function activity_9001733_Read.getSuperRewardTurn()
	return tonumber(activity_9001733_Read.getConstValue("FOOTBALL_TREASURE_SUPER_REWARD_TURN", 0)) or 0
end
function activity_9001733_Read.getRemakeExp(isFree)
	_UPVALUE2_ = nil
	;(nil)[1] = 0
	;(nil)[2] = 0
	local value = activity_9001733_Read.getArrayValue("FOOTBALL_TREASURE_REMAKE_EXP", nil)
	return tonumber(isFree and value[1] or value[2]) or 0
end
function activity_9001733_Read.formatRewardList(rewardList)
	if not rewardList then
		rewardList, _ENV = nil, nil
	end
	if type(rewardList[1]) == "table" then
		return rewardList
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	return serviceFunctions.tableFormat(rewardList, nil)
end
function activity_9001733_Read.formatDiscountList(discountList)
	if not discountList then
		discountList, _ENV = nil, nil
	end
	if type(discountList[1]) == "table" then
		return discountList
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "val"
	;(nil)[2] = "rate"
	return serviceFunctions.tableFormat(discountList, nil)
end
function activity_9001733_Read.formatShootRewardList(rewardList)
	if not rewardList then
		rewardList, _ENV = nil, nil
	end
	if type(rewardList[1]) == "table" then
		return rewardList
	end
	_UPVALUE3_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	;(nil)[3] = "rate"
	return serviceFunctions.tableFormat(rewardList, nil)
end
function activity_9001733_Read.getClassConfig(config, classType)
	if not config then
		config, _ENV = nil, nil
	end
	classType = tonumber(classType) or activity_9001733_Read.getClassType()
	if not config[classType] and not config[1] and not config[next(config)] then
		_ENV = config[next(config)]
	end
	return config[next(config)]
end
return activity_9001733_Read
