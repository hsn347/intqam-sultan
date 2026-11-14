local friendsCallbackRead = include("aAReadClass").new()
_ENV = "aAReadClass"
;("aAReadClass").invitor = 1
local ("aAReadClass").returnor, friendsCallbackType = 2, "aAReadClass"
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "return_gift"
	;(nil)[2] = true
	friendsCallbackRead:defineValue("tableReturnGift", nil)
	_ENV = nil
	;(nil)[1] = "return_num_reward"
	;(nil)[2] = true
	friendsCallbackRead:defineValue("tableCallbackTaskGift", nil)
	_ENV = nil
	;(nil)[1] = "return_login_config"
	;(nil)[2] = true
	friendsCallbackRead:defineValue("tableLoginGift", nil)
	_ENV = nil
	;(nil)[1] = "return_task_config"
	;(nil)[2] = true
	friendsCallbackRead:defineValue("tableTaskGift", nil)
	_ENV = nil
	;(nil)[1] = "return_shop"
	;(nil)[2] = true
	friendsCallbackRead:defineValue("tableReturnShop", nil)
	_ENV = nil
	;(nil)[1] = "return_exchange"
	;(nil)[2] = true
	friendsCallbackRead:defineValue("tableReturnExchange", nil)
	_ENV = nil
	;(nil)[1] = "return_recharge_config"
	;(nil)[2] = true
	friendsCallbackRead:defineValue("tableReturnRecharge", nil)
	_ENV = nil
	;(nil)[1] = "return_backgift"
	;(nil)[2] = true
	friendsCallbackRead:defineValue("returnBackGift", nil)
	_ENV = nil
	;(nil)[1] = "return_cat_exp"
	;(nil)[2] = true
	friendsCallbackRead:defineValue("returnCatExp", nil)
	_ENV = nil
	;(nil)[1] = "return_cat_reward"
	;(nil)[2] = true
	friendsCallbackRead:defineValue("returnCatReward", nil)
	friendsCallbackRead:defineValue("callbackTaskGiftConfig", function()
		friendsCallbackRead.callbackTaskGiftConfig, friendsCallbackRead = nil, nil
		for k, v in ipairs(friendsCallbackRead.tableCallbackTaskGift) do
			local friendsCallbackRead, tempTable
			tempTable.taskID = v.taskID
			tempTable.Type = v.Type
			tempTable.Quest = v.Quest
			tempTable.name = v.name
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			tempTable.Reward = serviceFunctions.tableFormat(v.Reward, nil)
			table.insert(friendsCallbackRead.callbackTaskGiftConfig, tempTable)
		end
		return friendsCallbackRead.callbackTaskGiftConfig
	end)
	friendsCallbackRead:defineValue("returnShopConfig", function()
		friendsCallbackRead.returnShopConfig, friendsCallbackRead = nil, nil
		for k, v in ipairs(friendsCallbackRead.tableReturnExchange) do
			local friendsCallbackRead, friendsCallbackRead, tempTable
			;(nil).id = v.changeID[1]
			tempTable.changeID, (nil).count = nil, v.changeID[2]
			tempTable.shopItemID = v.shopItemID
			friendsCallbackRead, tempTable.limitNum = v.limitNum, v.limitNum
			v.limitNum.id = v.itemID[1]
			tempTable.itemID, v.limitNum.count = v.limitNum, v.itemID[2]
			table.insert(friendsCallbackRead.returnShopConfig, tempTable)
		end
		return friendsCallbackRead.returnShopConfig
	end)
	friendsCallbackRead:defineValue("honorShopConfig", function()
		friendsCallbackRead.honorShopConfig, friendsCallbackRead = nil, nil
		for k, v in ipairs(friendsCallbackRead.tableReturnShop) do
			local tempTable = v
			friendsCallbackRead = nil
			;(nil).id = v.itemID[1]
			tempTable.itemID, (nil).count = nil, v.itemID[2]
			table.insert(friendsCallbackRead.honorShopConfig, tempTable)
		end
		return friendsCallbackRead.honorShopConfig
	end)
	friendsCallbackRead:defineValue("honorGiftsConfig", function()
		friendsCallbackRead.honorGiftsConfig, friendsCallbackRead = nil, nil
		for k, v in pairs(friendsCallbackRead.tableReturnRecharge) do
			local tempTable = v
			tempTable.giftID = k
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			tempTable.gift = serviceFunctions.tableFormat(v.gift, nil)
			table.insert(friendsCallbackRead.honorGiftsConfig, tempTable)
		end
		return friendsCallbackRead.honorGiftsConfig
	end)
	friendsCallbackRead:defineValue("honorBackTaskCommonConfig", function()
		friendsCallbackRead.honorBackTaskCommonConfig, friendsCallbackRead = nil, nil
		for k, v in ipairs(friendsCallbackRead.tableTaskGift) do
			local tempTable = v
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			tempTable.Reward = serviceFunctions.tableFormat(v.Reward, nil)
			table.insert(friendsCallbackRead.honorBackTaskCommonConfig, tempTable)
		end
		return friendsCallbackRead.honorBackTaskCommonConfig
	end)
	friendsCallbackRead:defineValue("honorBackTaskTypeConfig", function()
		friendsCallbackRead.honorBackTaskTypeConfig, friendsCallbackRead = nil, nil
		for k, v in ipairs(friendsCallbackRead.honorBackTaskCommonConfig) do
			if not friendsCallbackRead.honorBackTaskTypeConfig[v.Type] then
				friendsCallbackRead = friendsCallbackRead.honorBackTaskTypeConfig[v.Type]
			end
			friendsCallbackRead.honorBackTaskTypeConfig[v.Type] = friendsCallbackRead.honorBackTaskTypeConfig[v.Type]
			table.insert(friendsCallbackRead.honorBackTaskTypeConfig[v.Type], v)
		end
		return friendsCallbackRead.honorBackTaskTypeConfig
	end)
	friendsCallbackRead:defineValue("honorBackTaskLoginConfig", function()
		friendsCallbackRead.honorBackTaskLoginConfig, friendsCallbackRead = nil, nil
		for i, v in ipairs(friendsCallbackRead.tableLoginGift) do
			local tempTable = v
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			tempTable.Reward = serviceFunctions.tableFormat(v.Reward, nil)
			table.insert(friendsCallbackRead.honorBackTaskLoginConfig, tempTable)
		end
		return friendsCallbackRead.honorBackTaskLoginConfig
	end)
	friendsCallbackRead:defineValue("returnGiftConfig", function()
		friendsCallbackRead.returnGiftConfig, friendsCallbackRead = nil, nil
		for k, v in ipairs(friendsCallbackRead.tableReturnGift) do
			if not friendsCallbackRead.returnGiftConfig[v.Type] then
				friendsCallbackRead = friendsCallbackRead.returnGiftConfig[v.Type]
			end
			friendsCallbackRead.returnGiftConfig[v.Type] = friendsCallbackRead.returnGiftConfig[v.Type]
			local tempTable = v
			if v.Type == friendsCallbackType.returnor or v.Type == friendsCallbackType.invitor then
				friendsCallbackType = v.Type
				v.Type[1] = "id"
				v.Type[2] = "count"
				tempTable.Gift = serviceFunctions.tableFormat(v.Gift, v.Type)
			end
			table.insert(friendsCallbackRead.returnGiftConfig[v.Type], tempTable)
		end
		return friendsCallbackRead.returnGiftConfig
	end)
	friendsCallbackRead:defineValue("returnBackGiftConfig", function()
		friendsCallbackRead.returnBackGiftConfig, friendsCallbackRead = nil, nil
		for i, v in ipairs(friendsCallbackRead.returnBackGift) do
			_UPVALUE3_ = nil
			;(nil)[1] = "Reward01"
			;(nil)[2] = "Reward02"
			;(nil)[3] = "Reward03"
			for m, n in ipairs(nil) do
				_UPVALUE2_ = nil
				;(nil)[1] = "id"
				;(nil)[2] = "count"
				local tempTable = serviceFunctions.tableFormat(v[n], nil)
				table.insert(friendsCallbackRead.returnBackGiftConfig, tempTable)
			end
		end
		return friendsCallbackRead.returnBackGiftConfig
	end)
	friendsCallbackRead:defineValue("returnCatExpConfig", function()
		friendsCallbackRead.returnCatExpConfig, friendsCallbackRead = nil, nil
		for i, v in ipairs(friendsCallbackRead.returnCatExp) do
			local tempTable = v
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			tempTable.lowReward = serviceFunctions.tableFormat(v.lowReward, nil)
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			tempTable.highReward = serviceFunctions.tableFormat(v.highReward, nil)
			tempTable.type = 1
			table.insert(friendsCallbackRead.returnCatExpConfig, tempTable)
		end
		return friendsCallbackRead.returnCatExpConfig
	end)
	friendsCallbackRead:defineValue("returnCatRewardConfig", function()
		friendsCallbackRead.returnCatRewardConfig, friendsCallbackRead = nil, nil
		for i, v in ipairs(friendsCallbackRead.returnCatReward) do
			local tempTable = v
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			tempTable.uplvReward = serviceFunctions.tableFormat(v.uplvReward, nil)
			_UPVALUE3_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			;(nil)[3] = "weight"
			tempTable.lowWalkReward = serviceFunctions.tableFormat(v.lowWalkReward, nil)
			_UPVALUE3_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			;(nil)[3] = "weight"
			tempTable.highWalkReward = serviceFunctions.tableFormat(v.highWalkReward, nil)
			table.insert(friendsCallbackRead.returnCatRewardConfig, tempTable)
			local friendsCallbackRead, tempTable = table.insert, table.insert
			tempTable.type = 2
			tempTable.lv = #friendsCallbackRead.returnCatExpConfig
			tempTable.exp = v.exp
			tempTable.uplvReward = v.uplvReward
			table.insert(friendsCallbackRead.returnCatExpConfig, tempTable)
		end
		return friendsCallbackRead.returnCatRewardConfig
	end)
	friendsCallbackRead:defineValue("conditionFunc", function()
		_ENV = nil
		;(nil)[gCallbackConditionType.CASTLE_UPGRADE] = gNewPLayerTaskType.BUILD_UPGRADE
		;(nil)[gCallbackConditionType.ATTACK_MONSTER_TIMES] = gNewPLayerTaskType.QUICK_TO_WORLD
		;(nil)[gCallbackConditionType.TRAIN_SOLDIER] = gNewPLayerTaskType.TRAIN_SOLDIERS
		;(nil)[gCallbackConditionType.WISH_RESOURCE] = gNewPLayerTaskType.MAKE_A_WISH
		;(nil)[gCallbackConditionType.USE_SPEED_UP] = nil
		;(nil)[gCallbackConditionType.COLLECT_RESOURCE_TIMES] = gNewPLayerTaskType.QUICK_TO_WORLD
		;(nil)[gCallbackConditionType.ALLIANCE_HELP] = gNewPLayerTaskType.JOIN_ALLIANCE
		;(nil)[gCallbackConditionType.EPIC_WAR_EXPLORE_POINT] = gNewPLayerTaskType.EPIC_WAR_VERIFY
		;(nil)[gCallbackConditionType.OPEN_ALLIANCE_TREASURE] = gNewPLayerTaskType.ALLIANCE_STORE_HOUSE
		;(nil)[gCallbackConditionType.DISCOUNT_STORE] = gNewPLayerTaskType.MYSTICAL_STORE
		;(nil)[gCallbackConditionType.ESCORT_TIMES] = gNewPLayerTaskType.ESCORT_WORLD
		;(nil)[gCallbackConditionType.USE_GOLD] = nil
		;(nil)[gCallbackConditionType.LOGIN_DAY] = nil
		;(nil)[gCallbackConditionType.CALL_BACK_NUM] = nil
		return nil
	end)
end
init()
function friendsCallbackRead.getInvitorGiftByLevel(level)
	local tableInvitorGift = friendsCallbackRead.returnGiftConfig[friendsCallbackType.returnor]
	for k, v in ipairs(tableInvitorGift) do
		if level >= v.CastleLv[1] and level <= v.CastleLv[2] then
			return v.Gift
		end
	end
end
function friendsCallbackRead.getCallbackInviteGift(...)
	return friendsCallbackRead.returnGiftConfig[friendsCallbackType.invitor]
end
function friendsCallbackRead.queryTaskData(taskID)
	if friendsCallbackRead.tableTaskGift then
		for k, v in pairs(friendsCallbackRead.tableTaskGift) do
			if v.taskID == taskID then
				return v
			end
		end
	end
	return nil
end
function friendsCallbackRead.getTaskCondition(typeID)
	;(nil).condition, friendsCallbackRead, friendsCallbackRead = nil, nil, nil
	local (nil).questType, ret = friendsCallbackRead.conditionFunc[typeID], nil
	if typeID == gCallbackConditionType.CASTLE_UPGRADE then
		gCallbackConditionType.CASTLE_UPGRADE.condition, friendsCallbackRead, friendsCallbackRead = nil, nil, gCallbackConditionType.CASTLE_UPGRADE
		gCallbackConditionType.CASTLE_UPGRADE.questType = friendsCallbackRead.conditionFunc[typeID]
		gCallbackConditionType.CASTLE_UPGRADE.lv = SoraDGetCastleLv()
		ret, gCallbackConditionType.CASTLE_UPGRADE.bid = gCallbackConditionType.CASTLE_UPGRADE, BUILDID.CASTLE
	elseif typeID == gCallbackConditionType.TRAIN_SOLDIER then
		gCallbackConditionType.TRAIN_SOLDIER.condition, friendsCallbackRead, friendsCallbackRead = BUILDID.CASTLE, BUILDID.CASTLE, gCallbackConditionType.TRAIN_SOLDIER
		gCallbackConditionType.TRAIN_SOLDIER.questType = friendsCallbackRead.conditionFunc[typeID]
		ret, gCallbackConditionType.TRAIN_SOLDIER.bid = gCallbackConditionType.TRAIN_SOLDIER, BUILDID.CHARIOT_PLANT
	end
	return ret
end
function friendsCallbackRead.getTaskTypeConfig(taskType)
	if not friendsCallbackRead.honorBackTaskTypeConfig[taskType] then
		friendsCallbackRead = friendsCallbackRead.honorBackTaskTypeConfig[taskType]
	end
	return friendsCallbackRead.honorBackTaskTypeConfig[taskType]
end
function friendsCallbackRead.getReturnCatExpConfig(...)
	return friendsCallbackRead.returnCatExpConfig
end
function friendsCallbackRead.getReturnCatRewardConfig(...)
	return friendsCallbackRead.returnCatRewardConfig[1]
end
function friendsCallbackRead.getLvNeedExp(lv)
	local config = friendsCallbackRead.returnCatExpConfig[lv]
	if config then
		return config.exp
	else
		return friendsCallbackRead.returnCatRewardConfig[1].exp
	end
end
return friendsCallbackRead
