local GameModule = include("GameModule")
local activityShowCtrl = class("activityShowCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local timerList = gModuleMgr.getObject("timerList")
local msgCtrl = include("msgCtrl")
local ACTIVITYSHOWQUEUE = "activityShowQueue_"
function activityShowCtrl:ctor(properties)
	activityShowCtrl.super.ctor(self, properties)
	activityShowCtrl, self.activity_order = require("app." .. LocalTblPath .. ".config_server.activityorder"), require("app." .. LocalTblPath .. ".config_server.activityorder")
	activityShowCtrl = LocalTblPath
	LocalTblPath[gActivityTimeActivityID.LEGEND_HEGEMON_1] = true
	LocalTblPath[gActivityTimeActivityID.LEGEND_HEGEMON_2] = true
	LocalTblPath[gActivityTimeActivityID.LEGEND_HEGEMON_3] = true
	LocalTblPath[gActivityTimeActivityID.LEGEND_HEGEMON_4] = true
	LocalTblPath[gActivityTimeActivityID.LEGEND_HEGEMON_5] = true
	require("app." .. LocalTblPath .. ".config_server.activityorder")[gActivityCenterUIEnum.LEGEND_HEGEMON], LocalTblPath[gActivityTimeActivityID.LEGEND_HEGEMON_6] = LocalTblPath, true
	activityShowCtrl = LocalTblPath
	LocalTblPath[gActivityTimeActivityID.SURPRISED_DROP_ACTIVITY_0] = true
	LocalTblPath[gActivityTimeActivityID.SURPRISED_DROP_ACTIVITY_1] = true
	LocalTblPath[gActivityTimeActivityID.SURPRISED_DROP_ACTIVITY_2] = true
	LocalTblPath[gActivityTimeActivityID.SURPRISED_DROP_ACTIVITY_3] = true
	LocalTblPath[gActivityTimeActivityID.SURPRISED_DROP_2_ACTIVITY_0] = true
	LocalTblPath[gActivityTimeActivityID.SURPRISED_DROP_2_ACTIVITY_1] = true
	LocalTblPath[gActivityTimeActivityID.SURPRISED_DROP_2_ACTIVITY_2] = true
	require("app." .. LocalTblPath .. ".config_server.activityorder")[gActivityCenterUIEnum.SURPRISED_DROP], LocalTblPath[gActivityTimeActivityID.SURPRISED_DROP_2_ACTIVITY_3] = LocalTblPath, true
	activityShowCtrl = LocalTblPath
	LocalTblPath[gActivityTimeActivityID.SURPRISED_DROP_3_ACTIVITY_0] = true
	LocalTblPath[gActivityTimeActivityID.SURPRISED_DROP_3_ACTIVITY_1] = true
	LocalTblPath[gActivityTimeActivityID.SURPRISED_DROP_3_ACTIVITY_2] = true
	require("app." .. LocalTblPath .. ".config_server.activityorder")[gActivityCenterUIEnum.SNOW_DROP], LocalTblPath[gActivityTimeActivityID.SURPRISED_DROP_3_ACTIVITY_3] = LocalTblPath, true
	activityShowCtrl = LocalTblPath
	LocalTblPath[gActivityTimeActivityID.CRAZY_DROP_ACTIVITY_0] = true
	LocalTblPath[gActivityTimeActivityID.CRAZY_DROP_ACTIVITY_1] = true
	LocalTblPath[gActivityTimeActivityID.CRAZY_DROP_ACTIVITY_2] = true
	require("app." .. LocalTblPath .. ".config_server.activityorder")[gActivityCenterUIEnum.CRAZY_DROP], LocalTblPath[gActivityTimeActivityID.CRAZY_DROP_ACTIVITY_3] = LocalTblPath, true
	activityShowCtrl = LocalTblPath
	LocalTblPath[gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_1] = true
	LocalTblPath[gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_2] = true
	LocalTblPath[gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_3] = true
	LocalTblPath[gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_4] = true
	LocalTblPath[gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_5] = true
	LocalTblPath[gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_6] = true
	LocalTblPath[gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_7] = true
	require("app." .. LocalTblPath .. ".config_server.activityorder")[gActivityCenterUIEnum.GREAT_CHALLENGE], LocalTblPath[gActivityTimeActivityID.GREAT_CHALLENGE_ACTIVITY_8] = LocalTblPath, true
	require("app." .. LocalTblPath .. ".config_server.activityorder")[gActivityCenterUIEnum.FIVE_ANNIVERSARY], activityShowCtrl = LocalTblPath, LocalTblPath
	activityShowCtrl = LocalTblPath
	LocalTblPath[gActivityTimeActivityID.SULTAN_BACK_MAIN_ACTIVITY] = true
	LocalTblPath[gActivityTimeActivityID.SULTAN_BACK_LOGIN_ACTIVITY] = true
	LocalTblPath[gActivityTimeActivityID.SULTAN_WAR_QUEST_ACTIVITY] = true
	LocalTblPath[gActivityTimeActivityID.SULTAN_BACK_RETURN_ACTIVITY] = true
	LocalTblPath[gActivityTimeActivityID.SULTAN_BACK_LUXURYGIFT_ACTIVITY] = true
	LocalTblPath[gActivityTimeActivityID.SULTAN_BACK_REBATE_ACTIVITY] = true
	require("app." .. LocalTblPath .. ".config_server.activityorder")[gActivityCenterUIEnum.SULTAN_BACK], LocalTblPath[gActivityTimeActivityID.SULTAN_BACK_FRIEND_COMEBACK] = LocalTblPath, true
	activityShowCtrl = LocalTblPath
	LocalTblPath[gActivityTimeActivityID.BATTLEFIELD_TRAINING] = true
	LocalTblPath[gActivityTimeActivityID.PREFERENTIAL_SHOP_ACTIVITY] = true
	LocalTblPath[gActivityTimeActivityID.ARMY_TRANSFER_ACTIVTY] = true
	require("app." .. LocalTblPath .. ".config_server.activityorder")[gActivityCenterUIEnum.ARMYEXCHANGE_ACTIVITY], LocalTblPath[gActivityTimeActivityID.GEM_EXCHANGE_ACTIVITY] = LocalTblPath, true
	activityShowCtrl = LocalTblPath
	LocalTblPath[gActivityTimeActivityID.NEW_START_EFFECT_ACTIVITY] = true
	LocalTblPath[gActivityTimeActivityID.NEW_START_REWARD_ACTIVITY] = true
	LocalTblPath[gActivityTimeActivityID.WEALTH_ACTIVITY] = true
	LocalTblPath[gActivityTimeActivityID.ROAD_TO_REVIVE_ACTIVITY] = true
	LocalTblPath[gActivityTimeActivityID.VICIOUS_PET_ACTIVITY] = true
	LocalTblPath[gActivityTimeActivityID.SUDAN_RISING_ACTIVITY] = true
	self.activityGroup, require("app." .. LocalTblPath .. ".config_server.activityorder")[gActivityCenterUIEnum.NEWSERVERBACK_ACTIVITY], LocalTblPath[gActivityTimeActivityID.BACK_TO_TOP_ACTIVITY] = require("app." .. LocalTblPath .. ".config_server.activityorder"), LocalTblPath, true
	self.surprisedDropList = self.activityGroup[gActivityCenterUIEnum.SURPRISED_DROP]
	self.snowDropList = self.activityGroup[gActivityCenterUIEnum.SNOW_DROP]
	self.crazyDrop = self.activityGroup[gActivityCenterUIEnum.CRAZY_DROP]
	self.hegemonGroupID = self.activityGroup[gActivityCenterUIEnum.LEGEND_HEGEMON]
end
function activityShowCtrl:initLocalData()
	self.activity_order = require("app." .. LocalTblPath .. ".config_server.activityorder")
end
function activityShowCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_RANKINGS_MODULE, gCmd.REQ_CRAZY_DROP_RANK_LIST, handler(self, self.sendReqRankListRsp))
	msgCtrl.register(gCmd.CMD_SPEND_GOLD_REBATE_MODULE, gCmd.REQ_SPEND_GOLD_REBATE_INFO, handler(self, self.spendGoldRebateInfoRsp))
	msgCtrl.register(gCmd.CMD_RECHARGE_FEEDBACK_MODULE, gCmd.REQ_RECHARGE_FEEDBACK_INFO, handler(self, self.rechargeFeedBackRsp))
	msgCtrl.register(gCmd.CMD_ACTIVITY_CENTER_UI_MODULE, gCmd.REQ_ACTIVITY_ORDER_LIST_DATA, handler(self, self.reqActivityOrderRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_GLORIOUS_CONTEST_DATA, handler(self, self.reqStarCMPDataRsp))
	msgCtrl.register(gCmd.CMD_ACTIVITY_DROP, gCmd.REQ_GET_CURDAY_DROP_DATA, handler(self, self.reqCurdayDropDataRsp))
	self:resetData()
	self:reqActivityOrder()
end
function activityShowCtrl:resetData()
	self.activityShowData, _UPVALUE0_, self.queue, _UPVALUE0_, self.handle_notify = nil, nil, nil, nil, nil
	self.activityIDArray = nil
	self.starCMPData, _UPVALUE0_, self.rankInfoData, _UPVALUE0_, self.handle_order_notify = nil, nil, nil, nil, nil
end
function activityShowCtrl:Logout()
	self:resetData()
	activityShowCtrl.super.Logout(self)
end
function activityShowCtrl:createQueueNormal(activityID, queuetype, value)
	if value.doStage and value.stagetimes then
		return self:createQueueNormal_Stage(activityID, queuetype, value)
	else
		return self:createQueueNormal_default(activityID, queuetype, value)
	end
end
function activityShowCtrl:createQueueNormal_default(activityID, queuetype, value)
	local lefttime = value.endtime - serviceFunctions.systemTime()
	if value.state == gActivityState.PREPARE then
		lefttime = value.begintime - serviceFunctions.systemTime()
	end
	if lefttime <= 0 then
		lefttime = 0
	end
	local _ENV, queue = value.begintime, value.begintime
	queue.qtype = queuetype
	queue.starttime = value.begintime
	queue.totaltime = value.endtime - value.begintime
	return queue, lefttime
end
_ENV, activityShowCtrl.createQueueNormal_Stage = function(self, activityID, queuetype, value)
	print("activityShowCtrl:createQueueNormal_Stage", activityID, queuetype, value)
	dump(value, "createQueueNormal_Stage value", 10)
	local begintime = value.begintime
	local endtime = value.endtime
	local lefttime
	if value.state == gActivityState.PREPARE then
		lefttime = value.begintime - serviceFunctions.systemTime()
	else
		local doStage = value.doStage
		begintime = value.begintime
		if 0 < doStage and value.stagetimes[doStage] then
			begintime = value.stagetimes[doStage]
		end
		endtime = value.endtime
		if doStage + 1 <= #value.stagetimes then
			endtime = value.stagetimes[doStage + 1]
		end
		lefttime = endtime - serviceFunctions.systemTime()
	end
	if lefttime <= 0 then
		lefttime = 0
	end
	local _ENV, queue = value.doStage, value.doStage
	queue.qtype = queuetype
	queue.starttime = begintime
	queue.totaltime = endtime - begintime
	queue.totalEndtime = value.endtime
	queue.totalBegintime = value.begintime
	return queue, lefttime
end, function(self, activityID, queuetype, value)
	print("activityShowCtrl:createQueueNormal_Stage", activityID, queuetype, value)
	dump(value, "createQueueNormal_Stage value", 10)
	local begintime = value.begintime
	local endtime = value.endtime
	local lefttime
	if value.state == gActivityState.PREPARE then
		lefttime = value.begintime - serviceFunctions.systemTime()
	else
		local doStage = value.doStage
		begintime = value.begintime
		if 0 < doStage and value.stagetimes[doStage] then
			begintime = value.stagetimes[doStage]
		end
		endtime = value.endtime
		if doStage + 1 <= #value.stagetimes then
			endtime = value.stagetimes[doStage + 1]
		end
		lefttime = endtime - serviceFunctions.systemTime()
	end
	if lefttime <= 0 then
		lefttime = 0
	end
	local _ENV, queue = value.doStage, value.doStage
	queue.qtype = queuetype
	queue.starttime = begintime
	queue.totaltime = endtime - begintime
	queue.totalEndtime = value.endtime
	queue.totalBegintime = value.begintime
	return queue, lefttime
end
;(function(self, activityID, queuetype, value)
	print("activityShowCtrl:createQueueNormal_Stage", activityID, queuetype, value)
	dump(value, "createQueueNormal_Stage value", 10)
	local begintime = value.begintime
	local endtime = value.endtime
	local lefttime
	if value.state == gActivityState.PREPARE then
		lefttime = value.begintime - serviceFunctions.systemTime()
	else
		local doStage = value.doStage
		begintime = value.begintime
		if 0 < doStage and value.stagetimes[doStage] then
			begintime = value.stagetimes[doStage]
		end
		endtime = value.endtime
		if doStage + 1 <= #value.stagetimes then
			endtime = value.stagetimes[doStage + 1]
		end
		lefttime = endtime - serviceFunctions.systemTime()
	end
	if lefttime <= 0 then
		lefttime = 0
	end
	local _ENV, queue = value.doStage, value.doStage
	queue.qtype = queuetype
	queue.starttime = begintime
	queue.totaltime = endtime - begintime
	queue.totalEndtime = value.endtime
	queue.totalBegintime = value.begintime
	return queue, lefttime
end)[gActivityTimeActivityID.LEGEND_LORD] = true
;(function(self, activityID, queuetype, value)
	print("activityShowCtrl:createQueueNormal_Stage", activityID, queuetype, value)
	dump(value, "createQueueNormal_Stage value", 10)
	local begintime = value.begintime
	local endtime = value.endtime
	local lefttime
	if value.state == gActivityState.PREPARE then
		lefttime = value.begintime - serviceFunctions.systemTime()
	else
		local doStage = value.doStage
		begintime = value.begintime
		if 0 < doStage and value.stagetimes[doStage] then
			begintime = value.stagetimes[doStage]
		end
		endtime = value.endtime
		if doStage + 1 <= #value.stagetimes then
			endtime = value.stagetimes[doStage + 1]
		end
		lefttime = endtime - serviceFunctions.systemTime()
	end
	if lefttime <= 0 then
		lefttime = 0
	end
	local _ENV, queue = value.doStage, value.doStage
	queue.qtype = queuetype
	queue.starttime = begintime
	queue.totaltime = endtime - begintime
	queue.totalEndtime = value.endtime
	queue.totalBegintime = value.begintime
	return queue, lefttime
end)[gActivityTimeActivityID.KING_STAR_BATTLE] = true
;(function(self, activityID, queuetype, value)
	print("activityShowCtrl:createQueueNormal_Stage", activityID, queuetype, value)
	dump(value, "createQueueNormal_Stage value", 10)
	local begintime = value.begintime
	local endtime = value.endtime
	local lefttime
	if value.state == gActivityState.PREPARE then
		lefttime = value.begintime - serviceFunctions.systemTime()
	else
		local doStage = value.doStage
		begintime = value.begintime
		if 0 < doStage and value.stagetimes[doStage] then
			begintime = value.stagetimes[doStage]
		end
		endtime = value.endtime
		if doStage + 1 <= #value.stagetimes then
			endtime = value.stagetimes[doStage + 1]
		end
		lefttime = endtime - serviceFunctions.systemTime()
	end
	if lefttime <= 0 then
		lefttime = 0
	end
	local _ENV, queue = value.doStage, value.doStage
	queue.qtype = queuetype
	queue.starttime = begintime
	queue.totaltime = endtime - begintime
	queue.totalEndtime = value.endtime
	queue.totalBegintime = value.begintime
	return queue, lefttime
end)[gActivityTimeActivityID.LEGEND_HEGEMON_1] = true
;(function(self, activityID, queuetype, value)
	print("activityShowCtrl:createQueueNormal_Stage", activityID, queuetype, value)
	dump(value, "createQueueNormal_Stage value", 10)
	local begintime = value.begintime
	local endtime = value.endtime
	local lefttime
	if value.state == gActivityState.PREPARE then
		lefttime = value.begintime - serviceFunctions.systemTime()
	else
		local doStage = value.doStage
		begintime = value.begintime
		if 0 < doStage and value.stagetimes[doStage] then
			begintime = value.stagetimes[doStage]
		end
		endtime = value.endtime
		if doStage + 1 <= #value.stagetimes then
			endtime = value.stagetimes[doStage + 1]
		end
		lefttime = endtime - serviceFunctions.systemTime()
	end
	if lefttime <= 0 then
		lefttime = 0
	end
	local _ENV, queue = value.doStage, value.doStage
	queue.qtype = queuetype
	queue.starttime = begintime
	queue.totaltime = endtime - begintime
	queue.totalEndtime = value.endtime
	queue.totalBegintime = value.begintime
	return queue, lefttime
end)[gActivityTimeActivityID.LEGEND_HEGEMON_2] = true
;(function(self, activityID, queuetype, value)
	print("activityShowCtrl:createQueueNormal_Stage", activityID, queuetype, value)
	dump(value, "createQueueNormal_Stage value", 10)
	local begintime = value.begintime
	local endtime = value.endtime
	local lefttime
	if value.state == gActivityState.PREPARE then
		lefttime = value.begintime - serviceFunctions.systemTime()
	else
		local doStage = value.doStage
		begintime = value.begintime
		if 0 < doStage and value.stagetimes[doStage] then
			begintime = value.stagetimes[doStage]
		end
		endtime = value.endtime
		if doStage + 1 <= #value.stagetimes then
			endtime = value.stagetimes[doStage + 1]
		end
		lefttime = endtime - serviceFunctions.systemTime()
	end
	if lefttime <= 0 then
		lefttime = 0
	end
	local _ENV, queue = value.doStage, value.doStage
	queue.qtype = queuetype
	queue.starttime = begintime
	queue.totaltime = endtime - begintime
	queue.totalEndtime = value.endtime
	queue.totalBegintime = value.begintime
	return queue, lefttime
end)[gActivityTimeActivityID.LEGEND_HEGEMON_3] = true
;(function(self, activityID, queuetype, value)
	print("activityShowCtrl:createQueueNormal_Stage", activityID, queuetype, value)
	dump(value, "createQueueNormal_Stage value", 10)
	local begintime = value.begintime
	local endtime = value.endtime
	local lefttime
	if value.state == gActivityState.PREPARE then
		lefttime = value.begintime - serviceFunctions.systemTime()
	else
		local doStage = value.doStage
		begintime = value.begintime
		if 0 < doStage and value.stagetimes[doStage] then
			begintime = value.stagetimes[doStage]
		end
		endtime = value.endtime
		if doStage + 1 <= #value.stagetimes then
			endtime = value.stagetimes[doStage + 1]
		end
		lefttime = endtime - serviceFunctions.systemTime()
	end
	if lefttime <= 0 then
		lefttime = 0
	end
	local _ENV, queue = value.doStage, value.doStage
	queue.qtype = queuetype
	queue.starttime = begintime
	queue.totaltime = endtime - begintime
	queue.totalEndtime = value.endtime
	queue.totalBegintime = value.begintime
	return queue, lefttime
end)[gActivityTimeActivityID.LEGEND_HEGEMON_4] = true
;(function(self, activityID, queuetype, value)
	print("activityShowCtrl:createQueueNormal_Stage", activityID, queuetype, value)
	dump(value, "createQueueNormal_Stage value", 10)
	local begintime = value.begintime
	local endtime = value.endtime
	local lefttime
	if value.state == gActivityState.PREPARE then
		lefttime = value.begintime - serviceFunctions.systemTime()
	else
		local doStage = value.doStage
		begintime = value.begintime
		if 0 < doStage and value.stagetimes[doStage] then
			begintime = value.stagetimes[doStage]
		end
		endtime = value.endtime
		if doStage + 1 <= #value.stagetimes then
			endtime = value.stagetimes[doStage + 1]
		end
		lefttime = endtime - serviceFunctions.systemTime()
	end
	if lefttime <= 0 then
		lefttime = 0
	end
	local _ENV, queue = value.doStage, value.doStage
	queue.qtype = queuetype
	queue.starttime = begintime
	queue.totaltime = endtime - begintime
	queue.totalEndtime = value.endtime
	queue.totalBegintime = value.begintime
	return queue, lefttime
end)[gActivityTimeActivityID.LEGEND_HEGEMON_5] = true
;(function(self, activityID, queuetype, value)
	print("activityShowCtrl:createQueueNormal_Stage", activityID, queuetype, value)
	dump(value, "createQueueNormal_Stage value", 10)
	local begintime = value.begintime
	local endtime = value.endtime
	local lefttime
	if value.state == gActivityState.PREPARE then
		lefttime = value.begintime - serviceFunctions.systemTime()
	else
		local doStage = value.doStage
		begintime = value.begintime
		if 0 < doStage and value.stagetimes[doStage] then
			begintime = value.stagetimes[doStage]
		end
		endtime = value.endtime
		if doStage + 1 <= #value.stagetimes then
			endtime = value.stagetimes[doStage + 1]
		end
		lefttime = endtime - serviceFunctions.systemTime()
	end
	if lefttime <= 0 then
		lefttime = 0
	end
	local _ENV, queue = value.doStage, value.doStage
	queue.qtype = queuetype
	queue.starttime = begintime
	queue.totaltime = endtime - begintime
	queue.totalEndtime = value.endtime
	queue.totalBegintime = value.begintime
	return queue, lefttime
end)[gActivityTimeActivityID.LEGEND_HEGEMON_6] = true
local (function(self, activityID, queuetype, value)
	print("activityShowCtrl:createQueueNormal_Stage", activityID, queuetype, value)
	dump(value, "createQueueNormal_Stage value", 10)
	local begintime = value.begintime
	local endtime = value.endtime
	local lefttime
	if value.state == gActivityState.PREPARE then
		lefttime = value.begintime - serviceFunctions.systemTime()
	else
		local doStage = value.doStage
		begintime = value.begintime
		if 0 < doStage and value.stagetimes[doStage] then
			begintime = value.stagetimes[doStage]
		end
		endtime = value.endtime
		if doStage + 1 <= #value.stagetimes then
			endtime = value.stagetimes[doStage + 1]
		end
		lefttime = endtime - serviceFunctions.systemTime()
	end
	if lefttime <= 0 then
		lefttime = 0
	end
	local _ENV, queue = value.doStage, value.doStage
	queue.qtype = queuetype
	queue.starttime = begintime
	queue.totaltime = endtime - begintime
	queue.totalEndtime = value.endtime
	queue.totalBegintime = value.begintime
	return queue, lefttime
end)[gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY], legendGroupID = true, function(self, activityID, queuetype, value)
	print("activityShowCtrl:createQueueNormal_Stage", activityID, queuetype, value)
	dump(value, "createQueueNormal_Stage value", 10)
	local begintime = value.begintime
	local endtime = value.endtime
	local lefttime
	if value.state == gActivityState.PREPARE then
		lefttime = value.begintime - serviceFunctions.systemTime()
	else
		local doStage = value.doStage
		begintime = value.begintime
		if 0 < doStage and value.stagetimes[doStage] then
			begintime = value.stagetimes[doStage]
		end
		endtime = value.endtime
		if doStage + 1 <= #value.stagetimes then
			endtime = value.stagetimes[doStage + 1]
		end
		lefttime = endtime - serviceFunctions.systemTime()
	end
	if lefttime <= 0 then
		lefttime = 0
	end
	local _ENV, queue = value.doStage, value.doStage
	queue.qtype = queuetype
	queue.starttime = begintime
	queue.totaltime = endtime - begintime
	queue.totalEndtime = value.endtime
	queue.totalBegintime = value.begintime
	return queue, lefttime
end
function activityShowCtrl:createQueueWithParam(activityID, queuetype, value)
	local isInLegendGroup = false
	if legendGroupID[activityID] then
		isInLegendGroup = true
	end
	if isInLegendGroup then
		print("createQueueWithParam_Legend------")
		return self:createQueueWithParam_Legend(activityID, queuetype, value)
	else
		print("Warning---------@activityShowCtrl:createQueueWithParam@ 没有特殊处理-------activityID = ", activityID)
		return self:createQueueNormal(activityID, queuetype, value)
	end
end
_ENV, activityShowCtrl.createQueueWithParam_Legend = function(self, activityID, queuetype, value)
	local param = value.param
	if param.isJoin and self.hegemonGroupID[activityID] then
		local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
		hegemonCtrl:setJoinActivity(activityID)
	end
	local curState = param.curState
	local gametop, queue = hegemonCtrl.setJoinActivity, hegemonCtrl.setJoinActivity
	queue.qtype = queuetype
	queue.starttime = value.begintime
	queue.totaltime = value.endtime - value.begintime
	local lefttime = value.endtime - serviceFunctions.systemTime()
	if curState == ACTIVITY_STATE.NONE then
		lefttime = param.timeConfig.prepareTime - serviceFunctions.systemTime()
		queue.starttime = serviceFunctions.systemTime()
		queue.totaltime = lefttime
		value.state = gActivityState.CLOSE
	elseif curState == ACTIVITY_STATE.PREPARE then
		lefttime = param.timeConfig.activeTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.prepareTime
		queue.totaltime = param.timeConfig.activeTime - param.timeConfig.prepareTime
		value.state = gActivityState.PREPARE
	elseif curState == ACTIVITY_STATE.ACTIVE then
		lefttime = param.timeConfig.settleTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.activeTime
		queue.totaltime = param.timeConfig.settleTime - param.timeConfig.activeTime
		value.state = gActivityState.OPEN
	elseif curState == ACTIVITY_STATE.SETTLE then
		lefttime = param.timeConfig.finishTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.settleTime
		queue.totaltime = param.timeConfig.finishTime - param.timeConfig.settleTime
		value.state = gActivityState.OPEN
	end
	if lefttime <= 0 then
		lefttime = 0
	end
	return queue, lefttime
end, function(self, activityID, queuetype, value)
	local param = value.param
	if param.isJoin and self.hegemonGroupID[activityID] then
		local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
		hegemonCtrl:setJoinActivity(activityID)
	end
	local curState = param.curState
	local gametop, queue = hegemonCtrl.setJoinActivity, hegemonCtrl.setJoinActivity
	queue.qtype = queuetype
	queue.starttime = value.begintime
	queue.totaltime = value.endtime - value.begintime
	local lefttime = value.endtime - serviceFunctions.systemTime()
	if curState == ACTIVITY_STATE.NONE then
		lefttime = param.timeConfig.prepareTime - serviceFunctions.systemTime()
		queue.starttime = serviceFunctions.systemTime()
		queue.totaltime = lefttime
		value.state = gActivityState.CLOSE
	elseif curState == ACTIVITY_STATE.PREPARE then
		lefttime = param.timeConfig.activeTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.prepareTime
		queue.totaltime = param.timeConfig.activeTime - param.timeConfig.prepareTime
		value.state = gActivityState.PREPARE
	elseif curState == ACTIVITY_STATE.ACTIVE then
		lefttime = param.timeConfig.settleTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.activeTime
		queue.totaltime = param.timeConfig.settleTime - param.timeConfig.activeTime
		value.state = gActivityState.OPEN
	elseif curState == ACTIVITY_STATE.SETTLE then
		lefttime = param.timeConfig.finishTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.settleTime
		queue.totaltime = param.timeConfig.finishTime - param.timeConfig.settleTime
		value.state = gActivityState.OPEN
	end
	if lefttime <= 0 then
		lefttime = 0
	end
	return queue, lefttime
end
;(function(self, activityID, queuetype, value)
	local param = value.param
	if param.isJoin and self.hegemonGroupID[activityID] then
		local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
		hegemonCtrl:setJoinActivity(activityID)
	end
	local curState = param.curState
	local gametop, queue = hegemonCtrl.setJoinActivity, hegemonCtrl.setJoinActivity
	queue.qtype = queuetype
	queue.starttime = value.begintime
	queue.totaltime = value.endtime - value.begintime
	local lefttime = value.endtime - serviceFunctions.systemTime()
	if curState == ACTIVITY_STATE.NONE then
		lefttime = param.timeConfig.prepareTime - serviceFunctions.systemTime()
		queue.starttime = serviceFunctions.systemTime()
		queue.totaltime = lefttime
		value.state = gActivityState.CLOSE
	elseif curState == ACTIVITY_STATE.PREPARE then
		lefttime = param.timeConfig.activeTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.prepareTime
		queue.totaltime = param.timeConfig.activeTime - param.timeConfig.prepareTime
		value.state = gActivityState.PREPARE
	elseif curState == ACTIVITY_STATE.ACTIVE then
		lefttime = param.timeConfig.settleTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.activeTime
		queue.totaltime = param.timeConfig.settleTime - param.timeConfig.activeTime
		value.state = gActivityState.OPEN
	elseif curState == ACTIVITY_STATE.SETTLE then
		lefttime = param.timeConfig.finishTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.settleTime
		queue.totaltime = param.timeConfig.finishTime - param.timeConfig.settleTime
		value.state = gActivityState.OPEN
	end
	if lefttime <= 0 then
		lefttime = 0
	end
	return queue, lefttime
end)[gActivityTimeActivityID.LEGEND_LORD] = true
;(function(self, activityID, queuetype, value)
	local param = value.param
	if param.isJoin and self.hegemonGroupID[activityID] then
		local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
		hegemonCtrl:setJoinActivity(activityID)
	end
	local curState = param.curState
	local gametop, queue = hegemonCtrl.setJoinActivity, hegemonCtrl.setJoinActivity
	queue.qtype = queuetype
	queue.starttime = value.begintime
	queue.totaltime = value.endtime - value.begintime
	local lefttime = value.endtime - serviceFunctions.systemTime()
	if curState == ACTIVITY_STATE.NONE then
		lefttime = param.timeConfig.prepareTime - serviceFunctions.systemTime()
		queue.starttime = serviceFunctions.systemTime()
		queue.totaltime = lefttime
		value.state = gActivityState.CLOSE
	elseif curState == ACTIVITY_STATE.PREPARE then
		lefttime = param.timeConfig.activeTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.prepareTime
		queue.totaltime = param.timeConfig.activeTime - param.timeConfig.prepareTime
		value.state = gActivityState.PREPARE
	elseif curState == ACTIVITY_STATE.ACTIVE then
		lefttime = param.timeConfig.settleTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.activeTime
		queue.totaltime = param.timeConfig.settleTime - param.timeConfig.activeTime
		value.state = gActivityState.OPEN
	elseif curState == ACTIVITY_STATE.SETTLE then
		lefttime = param.timeConfig.finishTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.settleTime
		queue.totaltime = param.timeConfig.finishTime - param.timeConfig.settleTime
		value.state = gActivityState.OPEN
	end
	if lefttime <= 0 then
		lefttime = 0
	end
	return queue, lefttime
end)[gActivityTimeActivityID.KING_STAR_BATTLE] = true
;(function(self, activityID, queuetype, value)
	local param = value.param
	if param.isJoin and self.hegemonGroupID[activityID] then
		local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
		hegemonCtrl:setJoinActivity(activityID)
	end
	local curState = param.curState
	local gametop, queue = hegemonCtrl.setJoinActivity, hegemonCtrl.setJoinActivity
	queue.qtype = queuetype
	queue.starttime = value.begintime
	queue.totaltime = value.endtime - value.begintime
	local lefttime = value.endtime - serviceFunctions.systemTime()
	if curState == ACTIVITY_STATE.NONE then
		lefttime = param.timeConfig.prepareTime - serviceFunctions.systemTime()
		queue.starttime = serviceFunctions.systemTime()
		queue.totaltime = lefttime
		value.state = gActivityState.CLOSE
	elseif curState == ACTIVITY_STATE.PREPARE then
		lefttime = param.timeConfig.activeTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.prepareTime
		queue.totaltime = param.timeConfig.activeTime - param.timeConfig.prepareTime
		value.state = gActivityState.PREPARE
	elseif curState == ACTIVITY_STATE.ACTIVE then
		lefttime = param.timeConfig.settleTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.activeTime
		queue.totaltime = param.timeConfig.settleTime - param.timeConfig.activeTime
		value.state = gActivityState.OPEN
	elseif curState == ACTIVITY_STATE.SETTLE then
		lefttime = param.timeConfig.finishTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.settleTime
		queue.totaltime = param.timeConfig.finishTime - param.timeConfig.settleTime
		value.state = gActivityState.OPEN
	end
	if lefttime <= 0 then
		lefttime = 0
	end
	return queue, lefttime
end)[gActivityTimeActivityID.LEGEND_HEGEMON_1] = true
;(function(self, activityID, queuetype, value)
	local param = value.param
	if param.isJoin and self.hegemonGroupID[activityID] then
		local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
		hegemonCtrl:setJoinActivity(activityID)
	end
	local curState = param.curState
	local gametop, queue = hegemonCtrl.setJoinActivity, hegemonCtrl.setJoinActivity
	queue.qtype = queuetype
	queue.starttime = value.begintime
	queue.totaltime = value.endtime - value.begintime
	local lefttime = value.endtime - serviceFunctions.systemTime()
	if curState == ACTIVITY_STATE.NONE then
		lefttime = param.timeConfig.prepareTime - serviceFunctions.systemTime()
		queue.starttime = serviceFunctions.systemTime()
		queue.totaltime = lefttime
		value.state = gActivityState.CLOSE
	elseif curState == ACTIVITY_STATE.PREPARE then
		lefttime = param.timeConfig.activeTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.prepareTime
		queue.totaltime = param.timeConfig.activeTime - param.timeConfig.prepareTime
		value.state = gActivityState.PREPARE
	elseif curState == ACTIVITY_STATE.ACTIVE then
		lefttime = param.timeConfig.settleTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.activeTime
		queue.totaltime = param.timeConfig.settleTime - param.timeConfig.activeTime
		value.state = gActivityState.OPEN
	elseif curState == ACTIVITY_STATE.SETTLE then
		lefttime = param.timeConfig.finishTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.settleTime
		queue.totaltime = param.timeConfig.finishTime - param.timeConfig.settleTime
		value.state = gActivityState.OPEN
	end
	if lefttime <= 0 then
		lefttime = 0
	end
	return queue, lefttime
end)[gActivityTimeActivityID.LEGEND_HEGEMON_2] = true
;(function(self, activityID, queuetype, value)
	local param = value.param
	if param.isJoin and self.hegemonGroupID[activityID] then
		local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
		hegemonCtrl:setJoinActivity(activityID)
	end
	local curState = param.curState
	local gametop, queue = hegemonCtrl.setJoinActivity, hegemonCtrl.setJoinActivity
	queue.qtype = queuetype
	queue.starttime = value.begintime
	queue.totaltime = value.endtime - value.begintime
	local lefttime = value.endtime - serviceFunctions.systemTime()
	if curState == ACTIVITY_STATE.NONE then
		lefttime = param.timeConfig.prepareTime - serviceFunctions.systemTime()
		queue.starttime = serviceFunctions.systemTime()
		queue.totaltime = lefttime
		value.state = gActivityState.CLOSE
	elseif curState == ACTIVITY_STATE.PREPARE then
		lefttime = param.timeConfig.activeTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.prepareTime
		queue.totaltime = param.timeConfig.activeTime - param.timeConfig.prepareTime
		value.state = gActivityState.PREPARE
	elseif curState == ACTIVITY_STATE.ACTIVE then
		lefttime = param.timeConfig.settleTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.activeTime
		queue.totaltime = param.timeConfig.settleTime - param.timeConfig.activeTime
		value.state = gActivityState.OPEN
	elseif curState == ACTIVITY_STATE.SETTLE then
		lefttime = param.timeConfig.finishTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.settleTime
		queue.totaltime = param.timeConfig.finishTime - param.timeConfig.settleTime
		value.state = gActivityState.OPEN
	end
	if lefttime <= 0 then
		lefttime = 0
	end
	return queue, lefttime
end)[gActivityTimeActivityID.LEGEND_HEGEMON_3] = true
;(function(self, activityID, queuetype, value)
	local param = value.param
	if param.isJoin and self.hegemonGroupID[activityID] then
		local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
		hegemonCtrl:setJoinActivity(activityID)
	end
	local curState = param.curState
	local gametop, queue = hegemonCtrl.setJoinActivity, hegemonCtrl.setJoinActivity
	queue.qtype = queuetype
	queue.starttime = value.begintime
	queue.totaltime = value.endtime - value.begintime
	local lefttime = value.endtime - serviceFunctions.systemTime()
	if curState == ACTIVITY_STATE.NONE then
		lefttime = param.timeConfig.prepareTime - serviceFunctions.systemTime()
		queue.starttime = serviceFunctions.systemTime()
		queue.totaltime = lefttime
		value.state = gActivityState.CLOSE
	elseif curState == ACTIVITY_STATE.PREPARE then
		lefttime = param.timeConfig.activeTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.prepareTime
		queue.totaltime = param.timeConfig.activeTime - param.timeConfig.prepareTime
		value.state = gActivityState.PREPARE
	elseif curState == ACTIVITY_STATE.ACTIVE then
		lefttime = param.timeConfig.settleTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.activeTime
		queue.totaltime = param.timeConfig.settleTime - param.timeConfig.activeTime
		value.state = gActivityState.OPEN
	elseif curState == ACTIVITY_STATE.SETTLE then
		lefttime = param.timeConfig.finishTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.settleTime
		queue.totaltime = param.timeConfig.finishTime - param.timeConfig.settleTime
		value.state = gActivityState.OPEN
	end
	if lefttime <= 0 then
		lefttime = 0
	end
	return queue, lefttime
end)[gActivityTimeActivityID.LEGEND_HEGEMON_4] = true
;(function(self, activityID, queuetype, value)
	local param = value.param
	if param.isJoin and self.hegemonGroupID[activityID] then
		local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
		hegemonCtrl:setJoinActivity(activityID)
	end
	local curState = param.curState
	local gametop, queue = hegemonCtrl.setJoinActivity, hegemonCtrl.setJoinActivity
	queue.qtype = queuetype
	queue.starttime = value.begintime
	queue.totaltime = value.endtime - value.begintime
	local lefttime = value.endtime - serviceFunctions.systemTime()
	if curState == ACTIVITY_STATE.NONE then
		lefttime = param.timeConfig.prepareTime - serviceFunctions.systemTime()
		queue.starttime = serviceFunctions.systemTime()
		queue.totaltime = lefttime
		value.state = gActivityState.CLOSE
	elseif curState == ACTIVITY_STATE.PREPARE then
		lefttime = param.timeConfig.activeTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.prepareTime
		queue.totaltime = param.timeConfig.activeTime - param.timeConfig.prepareTime
		value.state = gActivityState.PREPARE
	elseif curState == ACTIVITY_STATE.ACTIVE then
		lefttime = param.timeConfig.settleTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.activeTime
		queue.totaltime = param.timeConfig.settleTime - param.timeConfig.activeTime
		value.state = gActivityState.OPEN
	elseif curState == ACTIVITY_STATE.SETTLE then
		lefttime = param.timeConfig.finishTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.settleTime
		queue.totaltime = param.timeConfig.finishTime - param.timeConfig.settleTime
		value.state = gActivityState.OPEN
	end
	if lefttime <= 0 then
		lefttime = 0
	end
	return queue, lefttime
end)[gActivityTimeActivityID.LEGEND_HEGEMON_5] = true
;(function(self, activityID, queuetype, value)
	local param = value.param
	if param.isJoin and self.hegemonGroupID[activityID] then
		local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
		hegemonCtrl:setJoinActivity(activityID)
	end
	local curState = param.curState
	local gametop, queue = hegemonCtrl.setJoinActivity, hegemonCtrl.setJoinActivity
	queue.qtype = queuetype
	queue.starttime = value.begintime
	queue.totaltime = value.endtime - value.begintime
	local lefttime = value.endtime - serviceFunctions.systemTime()
	if curState == ACTIVITY_STATE.NONE then
		lefttime = param.timeConfig.prepareTime - serviceFunctions.systemTime()
		queue.starttime = serviceFunctions.systemTime()
		queue.totaltime = lefttime
		value.state = gActivityState.CLOSE
	elseif curState == ACTIVITY_STATE.PREPARE then
		lefttime = param.timeConfig.activeTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.prepareTime
		queue.totaltime = param.timeConfig.activeTime - param.timeConfig.prepareTime
		value.state = gActivityState.PREPARE
	elseif curState == ACTIVITY_STATE.ACTIVE then
		lefttime = param.timeConfig.settleTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.activeTime
		queue.totaltime = param.timeConfig.settleTime - param.timeConfig.activeTime
		value.state = gActivityState.OPEN
	elseif curState == ACTIVITY_STATE.SETTLE then
		lefttime = param.timeConfig.finishTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.settleTime
		queue.totaltime = param.timeConfig.finishTime - param.timeConfig.settleTime
		value.state = gActivityState.OPEN
	end
	if lefttime <= 0 then
		lefttime = 0
	end
	return queue, lefttime
end)[gActivityTimeActivityID.LEGEND_HEGEMON_6] = true
local (function(self, activityID, queuetype, value)
	local param = value.param
	if param.isJoin and self.hegemonGroupID[activityID] then
		local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
		hegemonCtrl:setJoinActivity(activityID)
	end
	local curState = param.curState
	local gametop, queue = hegemonCtrl.setJoinActivity, hegemonCtrl.setJoinActivity
	queue.qtype = queuetype
	queue.starttime = value.begintime
	queue.totaltime = value.endtime - value.begintime
	local lefttime = value.endtime - serviceFunctions.systemTime()
	if curState == ACTIVITY_STATE.NONE then
		lefttime = param.timeConfig.prepareTime - serviceFunctions.systemTime()
		queue.starttime = serviceFunctions.systemTime()
		queue.totaltime = lefttime
		value.state = gActivityState.CLOSE
	elseif curState == ACTIVITY_STATE.PREPARE then
		lefttime = param.timeConfig.activeTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.prepareTime
		queue.totaltime = param.timeConfig.activeTime - param.timeConfig.prepareTime
		value.state = gActivityState.PREPARE
	elseif curState == ACTIVITY_STATE.ACTIVE then
		lefttime = param.timeConfig.settleTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.activeTime
		queue.totaltime = param.timeConfig.settleTime - param.timeConfig.activeTime
		value.state = gActivityState.OPEN
	elseif curState == ACTIVITY_STATE.SETTLE then
		lefttime = param.timeConfig.finishTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.settleTime
		queue.totaltime = param.timeConfig.finishTime - param.timeConfig.settleTime
		value.state = gActivityState.OPEN
	end
	if lefttime <= 0 then
		lefttime = 0
	end
	return queue, lefttime
end)[gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY], filterMap = true, function(self, activityID, queuetype, value)
	local param = value.param
	if param.isJoin and self.hegemonGroupID[activityID] then
		local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
		hegemonCtrl:setJoinActivity(activityID)
	end
	local curState = param.curState
	local gametop, queue = hegemonCtrl.setJoinActivity, hegemonCtrl.setJoinActivity
	queue.qtype = queuetype
	queue.starttime = value.begintime
	queue.totaltime = value.endtime - value.begintime
	local lefttime = value.endtime - serviceFunctions.systemTime()
	if curState == ACTIVITY_STATE.NONE then
		lefttime = param.timeConfig.prepareTime - serviceFunctions.systemTime()
		queue.starttime = serviceFunctions.systemTime()
		queue.totaltime = lefttime
		value.state = gActivityState.CLOSE
	elseif curState == ACTIVITY_STATE.PREPARE then
		lefttime = param.timeConfig.activeTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.prepareTime
		queue.totaltime = param.timeConfig.activeTime - param.timeConfig.prepareTime
		value.state = gActivityState.PREPARE
	elseif curState == ACTIVITY_STATE.ACTIVE then
		lefttime = param.timeConfig.settleTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.activeTime
		queue.totaltime = param.timeConfig.settleTime - param.timeConfig.activeTime
		value.state = gActivityState.OPEN
	elseif curState == ACTIVITY_STATE.SETTLE then
		lefttime = param.timeConfig.finishTime - serviceFunctions.systemTime()
		queue.starttime = param.timeConfig.settleTime
		queue.totaltime = param.timeConfig.finishTime - param.timeConfig.settleTime
		value.state = gActivityState.OPEN
	end
	if lefttime <= 0 then
		lefttime = 0
	end
	return queue, lefttime
end
function activityShowCtrl:addQueue(activityID, value)
	activityID = tonumber(activityID)
	local isFilter = false
	if filterMap[activityID] then
		isFilter = true
	end
	local queuetype = ACTIVITYSHOWQUEUE .. tostring(activityID)
	local curqueue = self.queue[queuetype]
	if curqueue then
		timerList:cancelTimer(curqueue.timerNode)
		self.queue[queuetype] = nil
	end
	if value.state == gActivityState.CLOSE then
		return
	end
	local dispatchQueueEvent = function()
		queuetype = nil
		;(nil).name = queuetype
		local (nil).data, event = value, nil
		self:dispatchEvent(event)
	end
	local queue, lefttime
	if not isFilter then
		queue, lefttime = self:createQueueNormal(activityID, queuetype, value)
	else
		queue, lefttime = self:createQueueWithParam(activityID, queuetype, value)
	end
	print("queue", queue, "leftTime = ", lefttime)
	local ok, node = timerList:createTimer(lefttime, timerHandler(dispatchQueueEvent))
	if ok then
		queue.timerNode = node
		self.queue[queuetype] = queue
	end
end
function activityShowCtrl:getShowDataByID(activityID)
	local activityID = tostring(activityID)
	return self.activityShowData[activityID]
end
function activityShowCtrl:initClientData(data)
	dump(data, "activityShowCtrl:initClientData======", 10)
	if not data then
		return
	end
	self:registerNotify()
	for activityID, value in pairs(data) do
		self:addData(activityID, value)
		self:addQueue(activityID, value)
	end
	local activityBuffCtrl = gametop.playertop_:getModule("activityBuffCtrl")
	activityBuffCtrl:initClientData()
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.COMMUNITY_CENTER) then
		local h5ActivityCtrl = gametop.playertop_:getModule("h5ActivityCtrl")
		h5ActivityCtrl:reqInit()
	end
end
function activityShowCtrl:addData(activityID, data)
	if not self.activityShowData then
		_ENV = self.activityShowData
	end
	self.activityShowData = self.activityShowData
	if activityID then
		self.activityShowData[tostring(activityID)] = data
	end
end
function activityShowCtrl:initClientActivityOrderData(data)
	if data then
		if data.orderData then
			for k1, v1 in pairs(data.orderData) do
				if self.activity_order[v1.id] then
					self.activity_order[v1.id].prepareorder = v1.prepareorder
					self.activity_order[v1.id].beginorde = v1.beginorde
				end
			end
		end
		if data.labelSort then
			self.label_sort, _ENV = data.labelSort, data.labelSort
			for k1, v1 in pairs(data.labelSort) do
				self.label_sort[tonumber(v1.category)] = tonumber(v1.sort)
			end
		end
	end
end
function activityShowCtrl:reqActivityOrder()
	serverproxy:Request(gCmd.CMD_ACTIVITY_CENTER_UI_MODULE, gCmd.REQ_ACTIVITY_ORDER_LIST_DATA)
end
function activityShowCtrl:reqActivityOrderRsp(data)
	if data and data.err and data.err == gErrDef.Err_None and data.rspdata and data.rspdata.orderData and type(data.rspdata.orderData) == "table" then
		for k, v in pairs(data.rspdata.orderData) do
			if self.activity_order[v.id] then
				self.activity_order[v.id].prepareorder = v.prepareorder
				self.activity_order[v.id].beginorde = v.beginorde
			end
		end
	end
end
function activityShowCtrl:initClientHolidayData(data)
	if not data then
		return
	end
	self.holidayIDary = data
end
function activityShowCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.ACTIVITY_SHOW_CHANGE_TIME, handler(self, self.notifyActivityShow))
	self.handle_order_notify = notifyCtrl:register(gNotifyID.ACTIVITY_ORDER_SORT, handler(self, self.notifyOrderUpdate))
	print("gNotifyID.RECHARGE_FEEDBACK", gNotifyID.RECHARGE_FEEDBACK)
	notifyCtrl:register(gNotifyID.RECHARGE_FEEDBACK, handler(self, self.notifyRechargeFeedBack))
end
function activityShowCtrl:getActivityOrder()
	return self.activity_order
end
function activityShowCtrl:getActivityClassifyByID(activityID)
	return self.activity_order[activityID] and self.activity_order[activityID].classify or 4
end
function activityShowCtrl:getActivityBeginOrder(activityID)
	if not self.activity_order[activityID] then
		local _UPVALUE0_, cfg = self.activity_order[activityID], self.activity_order[activityID]
	end
	return cfg and cfg.beginorde or 0
end
function activityShowCtrl:getLabelSort()
	return self.label_sort
end
function activityShowCtrl:notifyOrderUpdate(event)
	for _, content in pairs(event.data) do
		if content then
			if content.orderData then
				for k1, v1 in pairs(content.orderData) do
					if self.activity_order[v1.id] then
						self.activity_order[v1.id].prepareorder = v1.prepareorder
						self.activity_order[v1.id].beginorde = v1.beginorde
					end
				end
			end
			if content.labelSort then
				self.label_sort, _ENV = content.labelSort, content.labelSort
				for k1, v1 in pairs(content.labelSort) do
					self.label_sort[tonumber(v1.category)] = tonumber(v1.sort)
				end
			end
		end
	end
end
function activityShowCtrl:notifyActivityShow(event)
	for _, content in pairs(event.data) do
		dump(content, "activityShowCtrl:notifyActivityShow", 30)
		local _ENV, activityIDData = dump, dump
		if content then
			local _ENV, flags = content, content
			for activityID, value in pairs(content) do
				value.state = tonumber(value.state)
				self.activityShowData[tostring(activityID)] = value
				self:addQueue(tonumber(activityID), value)
				table.insert(activityIDData, tonumber(activityID))
				for k, v in pairs(self.activityGroup) do
					if not flags[k] and v[tonumber(activityID)] then
						table.insert(activityIDData, k)
						flags[k] = true
					end
				end
			end
			for activityID, value in pairs(content) do
				_ENV, activityID = tonumber(activityID), tonumber(activityID)
				tonumber(activityID)[gActivityTimeActivityID.PYRAMIDACTIVITY] = function()
					if value.state == gActivityState.OPEN or value.state == gActivityState.CLOSE then
						value = gActivityState.CLOSE
						gActivityState.CLOSE.msg = "MESSAGE_MAINCITYVIEW_UPDATE_LeisureCenter_VIEW"
						SoraDSendMessage(gActivityState.CLOSE)
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.GLORIOUS_STAR_LAMP_ACTIVITY] = function()
					if value.state == gActivityState.OPEN then
						local shiningStarLightCtrl = SoraDGetCtrl("shiningStarLightCtrl")
						shiningStarLightCtrl:reqGloriousStarLampInit()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.LUCKY_RECHARGE_TASK_ACTIVIYT] = function()
					if value.state == gActivityState.CLOSE or value.state == gActivityState.OPEN then
						value = gActivityState.OPEN
						gActivityState.OPEN.msg = "MESSAGE_LUCKY_RECHARGE_REFRESH"
						SoraDSendMessage(gActivityState.OPEN)
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.GOLD_PACKAGE] = function()
					if value.state == gActivityState.CLOSE or value.state == gActivityState.OPEN then
						value = gActivityState.OPEN
						gActivityState.OPEN.msg = "MESSAGE_GOLD_PACKAGE_STATE"
						SoraDSendMessage(gActivityState.OPEN)
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.COST_GOLD_FOR_GIFT] = function()
					if value.state == gActivityState.OPEN then
						local costGoldForGiftCtrl = gametop.playertop_:getModule("costGoldForGiftCtrl")
						costGoldForGiftCtrl:setCostGoldInfo(value)
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.UNCHARTED_HELP] = function()
					if value.state == gActivityState.OPEN then
						dump(value, "description")
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.SINBAD_TREASURE] = function()
					if value.state == gActivityState.OPEN then
						dump(value, "description9001349")
						local sinbadTreasureCtrl = SoraDGetCtrl("sinbadTreasureCtrl")
						local activityData = sinbadTreasureCtrl:getActivityData()
						if activityData.activityStage then
							activityData.activityStage = value.doStage
						end
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.SERVER_EXP_DOUBLE_ACTIVITY] = function()
					if value.state == gActivityState.OPEN or value.state == gActivityState.CLOSE then
						value = gActivityState.CLOSE
						gActivityState.CLOSE.msg = "MESSAGE_SERVER_WORLDKINGDOM_LV_OPEN_CHANGE"
						SoraDSendMessage(gActivityState.CLOSE)
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.FRIEND_HONORBACK] = function()
					if value.state == gActivityState.OPEN then
						SoraDConfigSet("Game:honorBackView:redPointStatus~bool", true)
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.EXPEDITON] = function()
					if value.state == gActivityState.OPEN or value.state == gActivityState.CLOSE then
						local expeditionCtrl = gametop.playertop_:getModule("expeditionCtrl")
						expeditionCtrl:resetData()
						value = expeditionCtrl
						expeditionCtrl.msg = "MESSAGE_SERVER_EXPEDITON_UPDATE"
						SoraDSendMessage(expeditionCtrl)
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.LOGIN_GIFT] = function()
					if value.state == gActivityState.OPEN or value.state == gActivityState.CLOSE then
						local loginGiftCtrl = gametop.playertop_:getModule("loginGiftCtrl")
						loginGiftCtrl:resetData()
						value = loginGiftCtrl
						loginGiftCtrl.msg = "MESSAGE_SERVER_LOGINGIFT_UPDATE"
						SoraDSendMessage(loginGiftCtrl)
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.PSD_RED_PACKAGE_ACTIVITY] = function()
					local redEnvelopeCtrl = gametop.playertop_:getModule("redEnvelopeCtrl")
					redEnvelopeCtrl:resetData()
				end
				tonumber(activityID)[gActivityTimeActivityID.STAR_RHAPSODY] = function()
					if value.state == gActivityState.CLOSE then
						local starRhapsodyCtrl = gametop.playertop_:getModule("starRhapsodyCtrl")
						starRhapsodyCtrl:resetData()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.RAMADAN_RHAPSODY] = function()
					if value.state == gActivityState.CLOSE then
						local activity_9001619_Ctrl = gametop.playertop_:getModule("activity_9001619_Ctrl")
						activity_9001619_Ctrl:resetData()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.EID_CELEBRATION_ACTIVITY] = function()
					if value.state == gActivityState.CLOSE then
						local activity_9001643_Ctrl = gametop.playertop_:getModule("activity_9001643_Ctrl")
						activity_9001643_Ctrl:resetData()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.GOVERNING_COUNTRY_ACTIVITY] = function()
					if value.state == gActivityState.CLOSE then
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.EQUIP_ACTIVITY] = function()
					if value.state == gActivityState.CLOSE then
						local weaponSprctrumCtrl = gametop.playertop_:getModule("weaponSprctrumCtrl")
						weaponSprctrumCtrl:resetData()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY] = function()
					if value.state == gActivityState.CLOSE then
						local lightShiningCtrl = gametop.playertop_:getModule("lightShiningCtrl")
						lightShiningCtrl:resetData()
					else
						local lightShiningCtrl = gametop.playertop_:getModule("lightShiningCtrl")
						value = nil
						;(nil).buffList = value.param.buffList
						lightShiningCtrl:setActivityData(nil)
					end
					value = lightShiningCtrl.setActivityData
					lightShiningCtrl.setActivityData.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
					lightShiningCtrl.setActivityData.eventID = gActivityTimeActivityID.GLORIOUS_SHINE_ACTIVITY
					SoraDSendMessage(lightShiningCtrl.setActivityData)
				end
				tonumber(activityID)[gActivityTimeActivityID.HERO_FESTIVAL] = function()
					if value.state == gActivityState.CLOSE then
						local heroFestivalCtrl = gametop.playertop_:getModule("heroFestivalCtrl")
						heroFestivalCtrl:resetData()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.KING_STAR_BATTLE] = function(activityID)
					local kingStarTeamCtrl = SoraDGetCtrl("kingStarTeamCtrl")
					kingStarTeamCtrl:updateMyTeam()
					local landOfSoulCtrl = SoraDGetCtrl("landOfSoulCtrl")
					landOfSoulCtrl:reqDeadArmyList(activityID)
				end
				tonumber(activityID)[gActivityTimeActivityID.LEGEND_LORD_9001646] = function(activityID)
					local kingStarTeamCtrl = SoraDGetCtrl("kingStarTeamCtrl")
					kingStarTeamCtrl:updateMyTeam()
					local landOfSoulCtrl = SoraDGetCtrl("landOfSoulCtrl")
					landOfSoulCtrl:reqDeadArmyList(activityID)
				end
				tonumber(activityID)[gActivityTimeActivityID.LEGEND_LORD_9001647] = function(activityID)
					local kingStarTeamCtrl = SoraDGetCtrl("kingStarTeamCtrl")
					kingStarTeamCtrl:updateMyTeam()
					local landOfSoulCtrl = SoraDGetCtrl("landOfSoulCtrl")
					landOfSoulCtrl:reqDeadArmyList(activityID)
				end
				tonumber(activityID)[gActivityTimeActivityID.ANCIENT_REEL_ACTIVITY] = function()
					if value.state == gActivityState.CLOSE then
						local ancientReelCtrl = gametop.playertop_:getModule("ancientReelCtrl")
						ancientReelCtrl:resetData()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.RADIANCE_GUARDIAN_ACTIVITY] = function()
					local lightGuardianCtrl = SoraDGetCtrl("lightGuardianCtrl")
					if value.state == gActivityState.CLOSE then
						lightGuardianCtrl:resetData()
					elseif value.state == gActivityState.OPEN then
						lightGuardianCtrl:reqRadianceGuardianInitData()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.NEBULA_EQUIPMENT_ACTIVITY] = function()
					local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
					if value.state == gActivityState.OPEN then
						equipmentCtrl:resetNebulaExchangeInfo()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.CAPTURE_MONKEY_ACTIVITY] = function()
					local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
					if value.state == gActivityState.OPEN then
						activityTaskComponentCtrl:sendReqInit()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.EXOTIC_PAVILION_ACTIVITY] = function()
					local exoticPavilionCtrl = SoraDGetCtrl("exoticPavilionCtrl")
					if value.state == gActivityState.CLOSE then
						exoticPavilionCtrl:resetData()
					elseif value.state == gActivityState.OPEN then
						exoticPavilionCtrl:reqEPData()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.SIGN_REWARD_9001576_ACTIVITY] = function()
					local activity_9001576_Ctrl = SoraDGetCtrl("activity_9001576_Ctrl")
					if value.state == gActivityState.CLOSE then
						activity_9001576_Ctrl:resetData()
					elseif value.state == gActivityState.OPEN then
						activity_9001576_Ctrl:sendInitMsg()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.WISH_TREE_ACTIVITY] = function()
					_ENV = nil
					;(nil).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
					;(nil).eventID = gActivityTimeActivityID.WISH_TREE_ACTIVITY
					SoraDSendMessage(nil)
				end
				tonumber(activityID)[gActivityTimeActivityID.SUMMER_PRAY_ACTIVITY] = function()
					SoraDConfigSet("Game:GameSettingView:summerPrayFingerPop~bool", false)
				end
				tonumber(activityID)[gActivityTimeActivityID.RAIDERS_LOST_ARK] = function()
					if value.state == gActivityState.PREPARE then
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.RECHARGE_NEW_USER] = function()
					if value.state == gActivityState.CLOSE then
					elseif value.state == gActivityState.OPEN then
						SoraDGetCtrl("newFeedbackWeekCtrl"):registerNotify()
						SoraDGetCtrl("newFeedbackWeekCtrl"):reqInitData()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.MAGICAL_DOMINO] = function()
					if value.state == gActivityState.OPEN then
						SoraDGetCtrl("petCarnivalCtrl"):reqInitData()
					elseif value.state == gActivityState.CLOSE then
						SoraDGetCtrl("petCarnivalCtrl"):resetData()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.BUBBLE_REWARD_ACTIVITY] = function()
					if value.state == gActivityState.OPEN then
						SoraDGetCtrl("bubbleActivityCtrl"):reqBubbleRewardInit()
					elseif value.state == gActivityState.CLOSE then
						SoraDGetCtrl("bubbleActivityCtrl"):resetData()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.SULTAN_BACK_WELCOME_ACTIVITY] = function()
					_ENV = nil
					;(nil).msg = "MESSAGE_SULTANSBACK_WELCOME_REFRESH"
					;(nil).eventID = gActivityTimeActivityID.SULTAN_BACK_WELCOME_ACTIVITY
					SoraDSendMessage(nil)
				end
				tonumber(activityID)[gActivityTimeActivityID.EXTREMELY_SKILLFUIL] = function()
					_ENV = nil
					;(nil).msg = "MESSAGE_EXTREMELY_SKILLFUL_REFRESH"
					;(nil).eventID = gActivityTimeActivityID.EXTREMELY_SKILLFUIL
					SoraDSendMessage(nil)
				end
				tonumber(activityID)[gActivityTimeActivityID.TRAIN_POWER_ACTIVITY] = function()
					if value.state == gActivityState.OPEN then
						value = gActivityState.OPEN
						gActivityState.OPEN.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
						gActivityState.OPEN.eventID = gActivityTimeActivityID.TRAIN_POWER_ACTIVITY
						SoraDSendMessage(gActivityState.OPEN)
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.LOST_RUINS_ACTIVITY] = function()
					if value.state == gActivityState.OPEN then
						SoraDGetCtrl("lostRuinsCtrl"):reqLostRuinsInit()
					elseif value.state == gActivityState.CLOSE then
						SoraDGetCtrl("lostRuinsCtrl"):resetData()
						value = SoraDGetCtrl("lostRuinsCtrl")
						SoraDGetCtrl("lostRuinsCtrl").msg = "MESSAGE_LOST_RUINS_REFRESH"
						SoraDSendMessage((SoraDGetCtrl("lostRuinsCtrl")))
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.SULTAN_EX_RECAHRGE_PRESENT] = function()
					if value.state == gActivityState.OPEN then
						SoraDGetCtrl("rechargePresentCtrl"):getRechargePresentGiftReq(activityID)
					elseif value.state == gActivityState.CLOSE then
						SoraDGetCtrl("rechargePresentCtrl"):resetData()
						value = SoraDGetCtrl("rechargePresentCtrl")
						SoraDGetCtrl("rechargePresentCtrl").msg = "MESSAGE_RECHARGE_PRESENT_REFRESH"
						SoraDSendMessage((SoraDGetCtrl("rechargePresentCtrl")))
					end
					value = SoraDGetCtrl("rechargePresentCtrl")
					SoraDGetCtrl("rechargePresentCtrl").msg = "MESSAGE_RECHARGE_PRESENT_REFRESH_ACTIVE"
					SoraDSendMessage((SoraDGetCtrl("rechargePresentCtrl")))
				end
				tonumber(activityID)[gActivityTimeActivityID.PREDOWNLOAD_REWARD_ACTIVITY] = function()
					if value.state == gActivityState.CLOSE then
						SoraDGetCtrl("preDownloadCtrl"):autoStopPreDownload()
						SoraDGetCtrl("preDownloadCtrl"):resetData()
					end
					value = SoraDGetCtrl("preDownloadCtrl")
					SoraDGetCtrl("preDownloadCtrl").msg = "MESSAGE_PRE_DOWNLOAD_REFRESH_DOWNLOAD"
					SoraDSendMessage((SoraDGetCtrl("preDownloadCtrl")))
					value = SoraDGetCtrl("preDownloadCtrl")
					SoraDGetCtrl("preDownloadCtrl").msg = "MESSAGE_PRE_DOWNLOAD_REFRESH"
					SoraDSendMessage((SoraDGetCtrl("preDownloadCtrl")))
					value = SoraDGetCtrl("preDownloadCtrl")
					SoraDGetCtrl("preDownloadCtrl").msg = "MESSAGE_RECHARGE_PRESENT_REFRESH_ACTIVE"
					SoraDSendMessage((SoraDGetCtrl("preDownloadCtrl")))
				end
				tonumber(activityID)[gActivityTimeActivityID.PLAN_THOROUGH_ACTIVITY] = function()
					if value.state == gActivityState.OPEN or value.state == gActivityState.PREPARE then
						SoraDGetCtrl("planThoroughCtrl"):initClientData(value)
					elseif value.state == gActivityState.CLOSE then
						SoraDGetCtrl("planThoroughCtrl"):initClientData(value)
						value = SoraDGetCtrl("planThoroughCtrl")
						SoraDGetCtrl("planThoroughCtrl").msg = "MESSAGE_PLANTHOROUGH_CLOSE"
						SoraDSendMessage((SoraDGetCtrl("planThoroughCtrl")))
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.KOH_MIGRATE] = function()
					if value.state == gActivityState.CLOSE then
						SoraDGetCtrl("kohMigrateCtrl"):resetData()
					end
					value = SoraDGetCtrl("kohMigrateCtrl")
					SoraDGetCtrl("kohMigrateCtrl").msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
					SoraDGetCtrl("kohMigrateCtrl").eventID = gActivityTimeActivityID.KOH_MIGRATE
					SoraDSendMessage((SoraDGetCtrl("kohMigrateCtrl")))
				end
				tonumber(activityID)[gActivityTimeActivityID.ATLANTIS_PRIVILEGE_ACTIVITY] = function()
					if value.state == gActivityState.OPEN then
						SoraDGetCtrl("atlantisPrivilegeCtrl"):reqAtlantisPrivilegeInit()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.CAVALRY_RISE_ACTIVITY] = function()
					if value.state == gActivityState.CLOSE then
						SoraDGetCtrl("cavalryRiseCtrl"):resetData()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.COFFEE_CRAFTSMAN_ACTIVITY] = function()
					print("咖啡匠人活动状态变化：", activityID, value.state)
					if value.state == gActivityState.OPEN then
						SoraDGetCtrl("coffeeCraftsmanCtrl"):reqInit()
					elseif value.state == gActivityState.CLOSE then
						SoraDGetCtrl("coffeeCraftsmanCtrl"):closeActivity()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.IRON_BLOOD_ACTIVITY] = function()
					self.activityShowData[tostring(activityID)].state = value.state
				end
				tonumber(activityID)[gActivityTimeActivityID.DEVELOP_ARMAMENT_ACTIVITY] = function()
					if value.state == gActivityState.CLOSE then
						SoraDGetCtrl("newActivityCtrl"):clearDevelopData()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.ROCKET_RUSH] = function()
					if value.state == gActivityState.OPEN then
						SoraDGetCtrl("rocketRushCtrl"):resetData()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.LOTTERY_ACTIVITY_9001545] = function()
					if value.state == gActivityState.CLOSE then
						local happyEggCtrl = SoraDGetCtrl("happyEggCtrl")
						value = nil
						happyEggCtrl:saveChoosList(nil)
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.LOTTERY_ACTIVITY_9001545] = function()
					if value.state == gActivityState.CLOSE then
						local happyEggCtrl = SoraDGetCtrl("happyEggCtrl")
						value = nil
						happyEggCtrl:saveChoosList(nil)
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.LOTTERY_ACTIVITY_9001545] = function()
					if value.state == gActivityState.CLOSE then
						local happyEggCtrl = SoraDGetCtrl("happyEggCtrl")
						value = nil
						happyEggCtrl:saveChoosList(nil)
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.ANCIENT_TREASURE_ACTIVITY] = function()
					if value.state == gActivityState.OPEN then
						SoraDGetCtrl("ancientTreasureCtrl"):resetData()
						value = SoraDGetCtrl("ancientTreasureCtrl")
						SoraDGetCtrl("ancientTreasureCtrl").msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
						SoraDGetCtrl("ancientTreasureCtrl").eventID = activityID
						SoraDSendMessage((SoraDGetCtrl("ancientTreasureCtrl")))
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.ENDLESS_TRIALS_ACTIVITY] = function()
					if value.state == gActivityState.OPEN then
						local endlessTrialsCtrl = SoraDGetCtrl("endlessTrialsCtrl")
						endlessTrialsCtrl:resetData()
						endlessTrialsCtrl:initConfig()
						endlessTrialsCtrl:reqBossInfo()
						value = endlessTrialsCtrl.reqBossInfo
						endlessTrialsCtrl.reqBossInfo.maxAttackNum = value.maxAttackNum
						local endlessTrialsCtrl.reqBossInfo.maxKillNum, data = value.maxKillNum, endlessTrialsCtrl.reqBossInfo
						endlessTrialsCtrl:setLeftTimes(data)
						value = endlessTrialsCtrl
						endlessTrialsCtrl.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
						endlessTrialsCtrl.eventID = activityID
						SoraDSendMessage(endlessTrialsCtrl)
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.DESERT_TREASURE_ACTIVITY] = function()
					local desertTreasureCtrl = SoraDGetCtrl("desertTreasureCtrl")
					if value.state == gActivityState.CLOSE then
						desertTreasureCtrl:resetData()
					elseif value.state == gActivityState.OPEN then
						desertTreasureCtrl:sendInitMsg()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001654] = function()
					local activity_9001654_Ctrl = SoraDGetCtrl("activity_9001654_Ctrl")
					if value.state == gActivityState.CLOSE then
						activity_9001654_Ctrl:resetData()
					elseif value.state == gActivityState.OPEN then
						activity_9001654_Ctrl:sendInitMsg()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.SNOWWOLF_LOST_ACTIVITY] = function()
					if value.state == gActivityState.OPEN then
						SoraDGetCtrl("snowWolfLostCtrl"):reqSnowWolfLostInit()
					elseif value.state == gActivityState.CLOSE then
						SoraDGetCtrl("snowWolfLostCtrl"):resetData()
						value = SoraDGetCtrl("snowWolfLostCtrl")
						SoraDGetCtrl("snowWolfLostCtrl").msg = "MESSAGE_SNOWWOLF_LOST_REFRESH"
						SoraDSendMessage((SoraDGetCtrl("snowWolfLostCtrl")))
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.RUNE_EXCHANGE_MALL] = function()
					_ENV = nil
					;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_SPECIALTIME_REFRESH"
					;(nil).activityID = gActivityTimeActivityID.RUNE_EXCHANGE_MALL
					SoraDSendMessage(nil)
				end
				tonumber(activityID)[gActivityTimeActivityID.EXCHANGE_MALL_GODPOWER] = function()
					_ENV = nil
					;(nil).msg = "MESSAGE_SERVER_EVENTCENTER_SPECIALTIME_REFRESH"
					;(nil).activityID = gActivityTimeActivityID.EXCHANGE_MALL_GODPOWER
					SoraDSendMessage(nil)
				end
				tonumber(activityID)[gActivityTimeActivityID.LEGEND_OF_PEGASUS_ACTIVITY] = function()
					if value.state == gActivityState.OPEN then
						SoraDGetCtrl("legendOfPegasusCtrl"):reqLegendOfPegasusInit()
					elseif value.state == gActivityState.CLOSE then
						SoraDGetCtrl("legendOfPegasusCtrl"):resetData()
						value = SoraDGetCtrl("legendOfPegasusCtrl")
						SoraDGetCtrl("legendOfPegasusCtrl").msg = "MESSAGE_LEGEND_OF_PEGASUS_REFRESH"
						SoraDSendMessage((SoraDGetCtrl("legendOfPegasusCtrl")))
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001602] = function()
					if value.state == gActivityState.OPEN then
						SoraDGetCtrl("activity_9001602_Ctrl"):reqLegendOfPegasusInit()
					elseif value.state == gActivityState.CLOSE then
						SoraDGetCtrl("activity_9001602_Ctrl"):resetData()
						value = SoraDGetCtrl("activity_9001602_Ctrl")
						SoraDGetCtrl("activity_9001602_Ctrl").msg = "MESSAGE_FIREDRAGON_OF_ANGER_REFRESH"
						SoraDSendMessage((SoraDGetCtrl("activity_9001602_Ctrl")))
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001696] = function()
					if value.state == gActivityState.OPEN then
						SoraDGetCtrl("activity_9001696_Ctrl"):reqLegendOfPegasusInit()
					elseif value.state == gActivityState.CLOSE then
						SoraDGetCtrl("activity_9001696_Ctrl"):resetData()
						value = SoraDGetCtrl("activity_9001696_Ctrl")
						SoraDGetCtrl("activity_9001696_Ctrl").msg = "MESSAGE_FIREDRAGON_OF_ANGER_REFRESH"
						SoraDSendMessage((SoraDGetCtrl("activity_9001696_Ctrl")))
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.RAMADAN_ACCUMULATE_RECHARGE] = function()
					if value.state == gActivityState.CLOSE then
						SoraDGetCtrl("ramadanAccuRechargeCtrl"):resetData()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.GOLD_SOUK_ACTIVITY] = function()
					if value.state == gActivityState.CLOSE then
						SoraDGetCtrl("goldSoukCtrl"):resetData()
					elseif value.state == gActivityState.OPEN then
						SoraDGetCtrl("goldSoukCtrl"):sendInit()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.LOUDLY_DRESSED_ACTIVITY] = function()
					if value.state == gActivityState.CLOSE then
						SoraDGetCtrl("loudlyDressedCtrl"):resetData()
					elseif value.state == gActivityState.OPEN then
						SoraDGetCtrl("loudlyDressedCtrl"):sendInit()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.NEBULA_PRIVILEGE] = function()
					if value.state == gActivityState.CLOSE then
						SoraDGetCtrl("nebulaPrivilegeCtrl"):resetData()
						local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
						value = nil
						lordInfoCtrl:setNebulaLordTitle(nil)
					elseif value.state == gActivityState.OPEN then
						SoraDGetCtrl("nebulaPrivilegeCtrl"):sendInit()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.NEBULA_TREASURE_ACTIVITY] = function()
					if value.state == gActivityState.CLOSE then
						SoraDGetCtrl("nebulaTreasureCtrl"):resetData()
					elseif value.state == gActivityState.OPEN then
						SoraDGetCtrl("nebulaTreasureCtrl"):sendInit()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.NEBULA_REGION_ACTIVITY] = function()
					if value.state == gActivityState.CLOSE then
						SoraDGetCtrl("nebulaActivityCtrl"):resetData()
						local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
						nebulaMileStoneCtrl:sendDataMsg()
					elseif value.state == gActivityState.OPEN or value.state == gActivityState.PREPARE then
						SoraDGetCtrl("nebulaActivityCtrl"):sendReqInitDataMsg()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.NEBULA_KING_ACTIVITY] = function()
					if value.state == gActivityState.CLOSE then
						SoraDGetCtrl("nebulaKingCtrl"):onActivityClose()
					elseif value.state == gActivityState.PREPARE then
						SoraDGetCtrl("nebulaKingCtrl"):onActivityPrepare()
					elseif value.state == gActivityState.OPEN then
						SoraDGetCtrl("nebulaKingCtrl"):onActivityOpen()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.NEBULA_COMPETITION_ACTIVITY] = function()
					if value.state == gActivityState.CLOSE then
						SoraDGetCtrl("nebulaCompetitionCtrl"):onActivityClose()
					elseif value.state == gActivityState.PREPARE then
						SoraDGetCtrl("nebulaCompetitionCtrl"):onActivityPrepare()
					elseif value.state == gActivityState.OPEN then
						SoraDGetCtrl("nebulaCompetitionCtrl"):onActivityOpen()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.CALENDAR_9001575_ACTIVITY] = function()
					if value.state == gActivityState.OPEN then
						value = nil
						;(nil).pType = uiDequeTypeTab.ACITIVITY_9001575
						cityBuildFunction:checkActivity9001575(nil)
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.FESTIVAL_ACTIVITY_9001577] = function()
					if value.state == gActivityState.CLOSE then
						SoraDGetCtrl("activity_9001577_Ctrl"):onActivityClose()
					elseif value.state == gActivityState.PREPARE then
						SoraDGetCtrl("activity_9001577_Ctrl"):onActivityPrepare()
					elseif value.state == gActivityState.OPEN then
						SoraDGetCtrl("activity_9001577_Ctrl"):onActivityOpen()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.NEBULA_SIGN_ACTIVITY] = function()
					if value.state == gActivityState.CLOSE then
						SoraDGetCtrl("nebulaRegionSignCtrl"):resetData()
					elseif value.state == gActivityState.OPEN and SoraDGetCastleLv() >= CASTLE_LV110_LIMITED then
						SoraDGetCtrl("nebulaRegionSignCtrl"):sendReqInitDataMsg()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.NEBULA_WONDERLAND_ACTIVITY] = function()
					if value.state == gActivityState.CLOSE then
						SoraDGetCtrl("nebulaWonderlandCtrl"):resetData()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.MAGIC_LAMP_SKILL_SHELTER_ACTIVITY] = function()
					if value.state == gActivityState.CLOSE then
						SoraDGetCtrl("magicLampSkillShelterCtrl"):resetData()
					elseif value.state == gActivityState.OPEN then
						SoraDGetCtrl("magicLampSkillShelterCtrl"):sendInit()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.DICTATORSHIPS_ACTIVITY] = function(activityID)
					if value.state == gActivityState.OPEN then
						SoraDGetCtrl("activity_9001486_Ctrl"):reqData(activityID)
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.NEW_DICTATORSHIPS_ACTIVITY] = function(activityID)
					if value.state == gActivityState.OPEN then
						SoraDGetCtrl("activity_9001486_Ctrl"):reqData(activityID)
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY] = function()
					local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
					if value.state == gActivityState.CLOSE then
						nebulaEmperorCtrl:resetData()
					else
						nebulaEmperorCtrl:sendReqInitDataMsg()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.FESTIVAL_ACTIVITY_9001604] = function()
					local activity_9001604_Ctrl = SoraDGetCtrl("activity_9001604_Ctrl")
					if value.state == gActivityState.CLOSE then
						activity_9001604_Ctrl:resetData()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001573] = function()
					local activity_9001573_Ctrl = SoraDGetCtrl("activity_9001573_Ctrl")
					if value.state == gActivityState.CLOSE then
						activity_9001573_Ctrl:resetData()
					elseif value.state == gActivityState.OPEN then
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001605] = function()
					local activity_9001606_Ctrl = SoraDGetCtrl("activity_9001606_Ctrl")
					if value.state == gActivityState.CLOSE and self:getStateByID(gActivityTimeActivityID.NORMAL_ACTIVITY_9001606) == gActivityState.CLOSE then
						activity_9001606_Ctrl:resetData()
					elseif value.state == gActivityState.OPEN then
						activity_9001606_Ctrl:sendReqInitDataMsg()
					else
						_ENV = activity_9001606_Ctrl
						activity_9001606_Ctrl.msg = "MESSAGE_ACTIVITY_9001606_UPDATE"
						SoraDSendMessage(activity_9001606_Ctrl)
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001606] = function()
					local activity_9001606_Ctrl = SoraDGetCtrl("activity_9001606_Ctrl")
					if value.state == gActivityState.CLOSE and self:getStateByID(gActivityTimeActivityID.NORMAL_ACTIVITY_9001605) == gActivityState.CLOSE then
						activity_9001606_Ctrl:resetData()
					elseif value.state == gActivityState.OPEN then
						activity_9001606_Ctrl:sendReqInitDataMsg()
					else
						_ENV = activity_9001606_Ctrl
						activity_9001606_Ctrl.msg = "MESSAGE_ACTIVITY_9001606_UPDATE"
						SoraDSendMessage(activity_9001606_Ctrl)
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.MAGIC_DRAW_ACTIVITY] = function()
					local magicLampSkillLotteryCtrl = SoraDGetCtrl("magicLampSkillLotteryCtrl")
					if value.state == gActivityState.CLOSE then
						magicLampSkillLotteryCtrl:sendInitMsg()
					else
						if value.state == gActivityState.OPEN then
							magicLampSkillLotteryCtrl:sendInitMsg()
						else
						end
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001695] = function()
					local taskRushActivityCtrl = SoraDGetCtrl("taskRushActivityCtrl")
					if value.state == gActivityState.CLOSE then
						taskRushActivityCtrl:resetData()
					elseif value.state == gActivityState.OPEN then
						taskRushActivityCtrl:reqInit()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.COMMON_NDAYS_TASKRUSH_ACTIITY] = function()
					local taskRushActivityCtrl = SoraDGetCtrl("taskRushActivityCtrl")
					if value.state == gActivityState.CLOSE then
						taskRushActivityCtrl:resetData()
					elseif value.state == gActivityState.OPEN then
						taskRushActivityCtrl:reqInit()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.ANNIVERSARY_SHOP_2025] = function()
					local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
					if value.state == gActivityState.OPEN then
						activityTaskComponentCtrl:sendReqInit()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.CRESCENT_TREASURE_ACTIVITY] = function()
					if value.state == gActivityState.CLOSE then
						SoraDGetCtrl("activity_9001729_Ctrl"):resetData()
					elseif value.state == gActivityState.OPEN then
						SoraDGetCtrl("activity_9001729_Ctrl"):sendReqInitDataMsg()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.FLYING_CHESS_ACTIVITY] = function()
					if value.state == gActivityState.CLOSE then
						SoraDGetCtrl("activity_9001731_Ctrl"):resetData()
					elseif value.state == gActivityState.OPEN then
						SoraDGetCtrl("activity_9001731_Ctrl"):sendReqInitDataMsg()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.GREEN_GRASS_FLIP_ACTIVITY] = function()
					if value.state == gActivityState.CLOSE then
						SoraDGetCtrl("activity_9001738_Ctrl"):resetData()
					elseif value.state == gActivityState.OPEN then
						SoraDGetCtrl("activity_9001738_Ctrl"):sendReqInitDataMsg()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.FOOTBALL_TREASURE_ACTIVITY] = function()
					if value.state == gActivityState.CLOSE then
						SoraDGetCtrl("activity_9001733_Ctrl"):resetData()
					elseif value.state == gActivityState.OPEN then
						SoraDGetCtrl("activity_9001733_Ctrl"):sendReqInitDataMsg()
					end
				end
				tonumber(activityID)[gActivityTimeActivityID.UNDERWATER_TREASURE_ACTIVITY] = function()
					if value.state == gActivityState.CLOSE then
						SoraDGetCtrl("activity_9001746_Ctrl"):resetData()
					elseif value.state == gActivityState.OPEN then
						SoraDGetCtrl("activity_9001746_Ctrl"):sendReqInitDataMsg()
					end
				end
				local tonumber(activityID)[gActivityTimeActivityID.FOOTBALL_MONSTER_ACTIVITY], actMapFunc = function()
					if value.state == gActivityState.CLOSE then
						SoraDGetCtrl("activity_9001737_Ctrl"):resetData()
					elseif value.state == gActivityState.OPEN then
						SoraDGetCtrl("activity_9001737_Ctrl"):sendReqInitDataMsg()
					end
				end, tonumber(activityID)
				if actMapFunc[activityID] then
					actMapFunc[activityID](activityID)
				elseif activityID == gActivityTimeActivityID.LEGEND_LORD or self.hegemonGroupID[activityID] then
					local legendTeamCtrl = gametop.playertop_:getModule("legendTeamCtrl")
					legendTeamCtrl:updateMyTeam()
					local landOfSoulCtrl = gametop.playertop_:getModule("landOfSoulCtrl")
					landOfSoulCtrl:reqDeadArmyList(activityID)
				else
					local PlayerTopModule = include("PlayerTopModule")
					if not PlayerTopModule.resetActivityData then
						local _ENV, resetActivityData = PlayerTopModule.resetActivityData, PlayerTopModule.resetActivityData
					end
					if not PlayerTopModule.onlyResetActivityData then
						local _ENV, onlyResetActivityData = PlayerTopModule.onlyResetActivityData, PlayerTopModule.onlyResetActivityData
					end
					if resetActivityData[activityID] then
						local info = resetActivityData[activityID]
						local ctrl = SoraDGetCtrl(info.name)
						if value.state == gActivityState.OPEN then
							if ctrl.resetData then
								ctrl:resetData(activityID)
							end
							local activityTimeRead = include("activityTimeRead")
							if ctrl.sendReqInitDataMsg and clientEventMgr.checkCastleLvByActivityID(activityID) and activityTimeRead.checkActivityShowLevel(activityID) then
								ctrl:sendReqInitDataMsg(activityID)
							end
						elseif value.state == gActivityState.CLOSE and ctrl.resetData then
							ctrl:resetData(activityID)
						end
					elseif onlyResetActivityData[activityID] then
						local info = onlyResetActivityData[activityID]
						local ctrl = SoraDGetCtrl(info.name)
						if value.state == gActivityState.CLOSE and ctrl.resetData then
							ctrl:resetData(activityID)
						end
					end
				end
				if activityID == gActivityTimeActivityID.NEBULA_SURPRISED_DROP_STORE then
					table.insert(activityIDData, gActivityTimeActivityID.NEBULA_SURPRISED_DROP)
				end
				local activityBuffCtrl = gametop.playertop_:getModule("activityBuffCtrl")
				if value.state == gActivityState.OPEN then
					activityBuffCtrl:actOpenListener(activityID)
				elseif value.state == gActivityState.CLOSE then
					activityBuffCtrl:actCloseListener(activityID)
					SoraDGetCtrl("activityTaskComponentCtrl"):resetActivityData(activityID)
				end
				for i, v in ipairs(exchangeMallActivityID) do
					if v == activityID and (value.state == gActivityState.CLOSE or value.state == gActivityState.OPEN) then
						_ENV = gActivityState.OPEN
						gActivityState.OPEN.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
						gActivityState.OPEN.activityID = gActivityTimeActivityID.EXCHANGE_MALL
						SoraDSendMessage(gActivityState.OPEN)
						break
					end
				end
			end
		end
		dump(activityIDData, "消息刷新======")
		_ENV = activityIDData
		activityIDData.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		activityIDData.activityID = activityIDData
		SoraDSendMessage(activityIDData)
	end
end
function activityShowCtrl:getCommunityInfo(activityID)
	local _ENV, data
	if not clientEventMgr.judgeIsOpen(activityID) then
		return data
	end
	if not self.activityShowData then
		_ENV = self.activityShowData
	end
	self.activityShowData = self.activityShowData
	data = self.activityShowData[tostring(activityID)]
	return data
end
function activityShowCtrl:getGiftBagsInfo(activityID)
	if not clientEventMgr.judgeIsOpen(activityID) then
		return 1000
	end
	if not self.activityShowData then
		_ENV = self.activityShowData
	end
	self.activityShowData = self.activityShowData
	local data = self.activityShowData[tostring(activityID)]
	local _ENV, tmpTbl = tostring(activityID), tostring(activityID)
	for k, v in pairs(data.param) do
		tmpTbl[tonumber(k)] = v
	end
	table.sort(tmpTbl, function(l, r)
		return l.time < r.time
	end)
	for k, v in ipairs(tmpTbl) do
		if tonumber(v.time) > tonumber(serviceFunctions.systemTime()) then
			return v.time
		end
	end
	return false
end
function activityShowCtrl:getClassType(id)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SUPER_COMMANDER) then
		return 1000
	end
	if not self.activityShowData then
		_ENV = self.activityShowData
	end
	self.activityShowData = self.activityShowData
	local value = self.activityShowData[tostring(id)]
	if value then
		return value.classType or 1000
	end
	return 1000
end
function activityShowCtrl:getEpicCommandMultiple()
	local multiple = 1
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.EPIC_WAR_EXP_MULTIPLE) then
		return multiple
	end
	if not self.activityShowData then
		_ENV = self.activityShowData
	end
	self.activityShowData = self.activityShowData
	local value = self.activityShowData[tostring(gActivityTimeActivityID.EPIC_WAR_EXP_MULTIPLE)]
	if value and value.param then
		multiple = value.param.multiple or 1
	end
	return multiple
end
function activityShowCtrl:isActivityOpen(id)
	return self:getStateByID(id) == gActivityState.OPEN
end
function activityShowCtrl:getStateByID(id)
	local activityID = tonumber(id)
	if activityID == gActivityTimeActivityID.EXCHANGE_MALL then
		return gActivityState.OPEN
	end
	if tonumber(id) == gActivityCenterUIEnum.SURPRISED_DROP then
		return self:getSurprisedDropState()
	end
	if tonumber(id) == gActivityCenterUIEnum.SNOW_DROP then
		return self:getSnowDropState()
	end
	if tonumber(id) == gActivityCenterUIEnum.CRAZY_DROP then
		return self:getCrazyDropState()
	end
	if tonumber(id) == gActivityTimeActivityID.WISE_TUTOR_ACTIVITY then
		local state, _ = SoraDGetCtrl("wiseTutorCtrl"):getStateInfo()
		return state
	end
	if self.activityGroup[tonumber(id)] then
		return self:getStateByIDList(self.activityGroup[tonumber(id)])
	end
	if not self.activityShowData then
		_ENV = self.activityShowData
	end
	self.activityShowData = self.activityShowData
	local value = self.activityShowData[tostring(id)]
	if value then
		return value.state
	end
	return gActivityState.CLOSE
end
function activityShowCtrl:getStateByIDList(idList)
	local state = gActivityState.CLOSE
	for id, v in pairs(idList) do
		if gActivityState.CLOSE ~= self:getStateByID(id) then
			state = self:getStateByID(id)
			if state == gActivityState.OPEN then
				return state
			end
		end
	end
	return gActivityState.CLOSE
end
function activityShowCtrl:getDoStageByID(id)
	local value = self:getActivityData(id)
	return value.doStage or 0
end
function activityShowCtrl:getParamByID(id)
	if not self.activityShowData then
		_ENV = self.activityShowData
	end
	self.activityShowData = self.activityShowData
	local value = self.activityShowData[tostring(id)]
	if value then
		if not value.param then
			_ENV = value.param
		end
		return value.param
	end
	_ENV = value.param
	return value.param
end
function activityShowCtrl:getParamClassType(id)
	local param = self:getParamByID(id)
	return param and param.classtype or 1
end
function activityShowCtrl:getParamCurState(id)
	local param = self:getParamByID(id)
	return param and param.curState
end
function activityShowCtrl:getActivityData(id)
