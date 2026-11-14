local sultansBackRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "friend_return_login_reward"
	;(nil)[2] = true
	sultansBackRead:defineValue("loginReward", nil)
	_ENV = nil
	;(nil)[1] = "friend_return_login_cunsum"
	;(nil)[2] = true
	sultansBackRead:defineValue("loginCunsum", nil)
	_ENV = nil
	;(nil)[1] = "friend_return_battle_reward"
	;(nil)[2] = true
	sultansBackRead:defineValue("battleTaskConfig", nil)
	_ENV = nil
	;(nil)[1] = "friend_return_common_task"
	;(nil)[2] = true
	sultansBackRead:defineValue("kingTask", nil)
	_ENV = nil
	;(nil)[1] = "friend_back"
	;(nil)[2] = true
	sultansBackRead:defineValue("friendBack", nil)
	sultansBackRead.back_first_charge = require_data("back_first_charge", true).data
	_ENV = nil
	;(nil)[1] = "welcome_back"
	;(nil)[2] = true
	sultansBackRead:defineValue("welcomeBack", nil)
	_ENV = nil
	;(nil)[1] = "friend_back_task"
	;(nil)[2] = true
	sultansBackRead:defineValue("friendBackTask", nil)
	sultansBackRead:defineValue("battleTaskDetail", function()
		sultansBackRead.battleTaskDetail, sultansBackRead = nil, nil
		local cfgTask = require_once("app." .. LocalTblPath .. ".config_server.friend_return_battle_task")
		for _qeustID, v in ipairs(cfgTask) do
			sultansBackRead = nil
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			;(nil).reward = serviceFunctions.tableFormat(v.reward, nil)
			;(nil).taskDes = v.des
			;(nil).aim = v.aim
			;(nil).guideId = v.guideId
			sultansBackRead.battleTaskDetail[v.qeustID], (nil).isAct = nil, v.isAct
		end
		return sultansBackRead.battleTaskDetail
	end)
end
function sultansBackRead.getWelBackReward()
	return sultansBackRead.welcomeBack[1].login_reward
end
function sultansBackRead.getWelBackBuff()
	return sultansBackRead.welcomeBack[1].effecttype
end
function sultansBackRead.getWelBackBuffIcon(effecttype)
	local index = 1
	for k, v in ipairs(sultansBackRead.getWelBackBuff()) do
		if v == effecttype then
			index = k
			break
		end
	end
	return sultansBackRead.welcomeBack[1].buffIcon[index]
end
function sultansBackRead.getFriendBackReward()
	local rewards = sultansBackRead.friendBack[1].login_reward
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	return serviceFunctions.tableFormat(rewards, nil)
end
function sultansBackRead.getLoginReward()
	return sultansBackRead.loginReward
end
function sultansBackRead.getLoginRewardByDay(day)
	return sultansBackRead.loginReward[day]
end
function sultansBackRead.getLoginCunsum()
	return sultansBackRead.loginCunsum
end
function sultansBackRead.getLoginCunsumByIndex(index)
	if not sultansBackRead.loginCunsum[index] then
		sultansBackRead = sultansBackRead.loginCunsum[index]
	end
	return sultansBackRead.loginCunsum[index]
end
function sultansBackRead.getActivityTaskByType(activityID, taskType)
	if activityID == gActivityTimeActivityID.SULTAN_BACK_RETURN_ACTIVITY then
		return sultansBackRead.kingTask[taskType].task
	elseif activityID == gActivityTimeActivityID.SULTAN_WAR_QUEST_ACTIVITY then
		return sultansBackRead.battleTaskConfig[taskType].task
	end
end
function sultansBackRead.getBattleTaskConfig()
	return sultansBackRead.battleTaskConfig
end
function sultansBackRead.getCallFriendTaskConfig()
	return sultansBackRead.friendBackTask
end
function sultansBackRead.getBattleTaskConfigByIndex(index)
	return sultansBackRead.battleTaskConfig[index]
end
function sultansBackRead.getQuestConfig(activityID)
	if activityID == gActivityTimeActivityID.SULTAN_BACK_RETURN_ACTIVITY then
		local eventQuestRead = include("eventQuestRead")
		return eventQuestRead.questconfig
	elseif activityID == gActivityTimeActivityID.SULTAN_WAR_QUEST_ACTIVITY then
		return sultansBackRead.battleTaskDetail
	end
end
function sultansBackRead.isNeedShowGo(taskID)
	print("eventQuestRead.isNeedShowGo  =", taskID)
	local cfgItem = sultansBackRead.battleTaskDetail[tonumber(taskID)]
	print("cfgItem, ", cfgItem, "taskID", taskID)
	if cfgItem and cfgItem.isAct == 1 then
		return true
	else
		return false
	end
end
function sultansBackRead.getBackFirstRechargeAmount(...)
	return sultansBackRead.back_first_charge[1].amount
end
function sultansBackRead.getBackFirstRechargeRewards(...)
	local rewards = sultansBackRead.back_first_charge[1].reward
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	return serviceFunctions.tableFormat(rewards, nil)
end
local sultansBackRebateRechargeCfg
local lazyInitRechargeCfg = function()
	if not sultansBackRebateRechargeCfg then
		local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.back_recharge")
		local sultansBackRebateRechargeCfg, award = "app." .. _G.LocalTblPath .. ".config_server.back_recharge", "app." .. _G.LocalTblPath .. ".config_server.back_recharge"
		for _, v in ipairs(cfg) do
			local sultansBackRebateRechargeCfg, awardItem
			awardItem.round = v.Index
			awardItem.score = v.amount
			awardItem.buff = v.buff_id
			if not v.reward then
				sultansBackRebateRechargeCfg = v.reward
			end
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local reward = serviceFunctions.tableFormat(v.reward, nil)
			if 1 < #reward then
				awardItem.special = reward[1]
				table.remove(reward, 1)
				awardItem.reward = reward
			else
				awardItem.reward, sultansBackRebateRechargeCfg = table.remove, table.remove
			end
			award[#award + 1] = awardItem
		end
		award = {}
	end
end
function sultansBackRead.getBackRechargeCfg(round)
	lazyInitRechargeCfg()
	if round then
		if not sultansBackRebateRechargeCfg[round] then
			lazyInitRechargeCfg = sultansBackRebateRechargeCfg[round]
		end
		return sultansBackRebateRechargeCfg[round]
	end
	return sultansBackRebateRechargeCfg
end
init()
return sultansBackRead
