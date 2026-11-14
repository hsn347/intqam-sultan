local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activityCommonDrawCtrl = class("activityCommonDrawCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activityCommonDrawCtrl:ctor(properties)
	activityCommonDrawCtrl.super.ctor(self, properties)
	self:resetData()
end
function activityCommonDrawCtrl:EnterGame()
	local newLotteryRead = include("newLotteryRead")
	_ENV = "newLotteryRead"
	_ENV = nil
	;(nil).itemID = nil
	;(nil).module = gCmd.CMD_PHOENIX_ARRIVAL_MODULE
	;(nil).init = gCmd.REQ_PHOENIX_ARRIVAL_DATA
	;(nil).draw1 = gCmd.REQ_CORBAN_MARKET_BUY_GIFT
	self.cmdConfig, ("newLotteryRead")[gActivityTimeActivityID.PHOENIX_ARRIVAL], (nil).draw2 = "newLotteryRead", nil, nil
	local constantRead = include("constantRead")
	_UPVALUE2_ = gCmd.REQ_CORBAN_MARKET_BUY_GIFT
	gCmd.REQ_CORBAN_MARKET_BUY_GIFT[1] = 869501
	gCmd.REQ_CORBAN_MARKET_BUY_GIFT[2] = 1
	local itemArray = constantRead.getConstValueArray("PHOENIX_ARRIVAL_DONATE_ITEM", gCmd.REQ_CORBAN_MARKET_BUY_GIFT)
	_ENV = 869501
	;(869501).itemID = itemArray[1]
	;(869501).itemCost = itemArray[2]
	;(869501).module = gCmd.CMD_PHOENIX_ARRIVAL_MODULE
	;(869501).init = gCmd.REQ_PHOENIX_ARRIVAL_DATA
	;(869501).draw1 = gCmd.REQ_CORBAN_MARKET_BUY_GIFT
	self.cmdConfig[gActivityTimeActivityID.PHOENIX_ARRIVAL], (869501).draw2 = 869501, nil
	local roaringFlameWarRead = include("roaringFlameWarRead")
	_UPVALUE2_ = gCmd.REQ_CORBAN_MARKET_BUY_GIFT
	gCmd.REQ_CORBAN_MARKET_BUY_GIFT[1] = 869301
	gCmd.REQ_CORBAN_MARKET_BUY_GIFT[2] = 10
	local itemArray = roaringFlameWarRead.getConstValueArray("FLAMES_DUNES_TURNTABLE_ITEM", gCmd.REQ_CORBAN_MARKET_BUY_GIFT)
	_ENV = 869301
	;(869301).itemID = itemArray[1]
	;(869301).itemCost = itemArray[2]
	;(869301).module = gCmd.CMD_ROARING_FLAME_WAR_MODULE
	;(869301).draw1 = gCmd.REQ_ROARING_FLAME_WAR_TURN_LOTTERY
	self.cmdConfig[gActivityTimeActivityID.ROARING_FLAME_WAR_ACTIVITY], (869301).stage = 869301, gCmd.REQ_ROARING_FLAME_WAR_TURN_STAGE
	local activityCommonDrawRead = include("activityCommonDrawRead")
	local drawCost = activityCommonDrawRead.activity_9001718_getDrawCost()
	_ENV = nil
	;(nil).itemID = drawCost[1]
	;(nil).itemCost = drawCost[2]
	;(nil).module = gCmd.CMD_LAMP_WISH_MODULE
	;(nil).init = gCmd.REQ_LAMP_WISH_INIT
	;(nil).draw1 = gCmd.REQ_LAMP_WISH_LOTTERY
	self.cmdConfig[gActivityTimeActivityID.LAMP_WISH_ACTIVITY], (nil).stage = nil, gCmd.REQ_LAMP_WISH_STAGE_REWARD
	for activityID, cmdCfg in pairs(self.cmdConfig) do
		if cmdCfg.init then
			msgCtrl.register(cmdCfg.module, cmdCfg.init, handler(self, self.reqInitRsp))
		end
		if cmdCfg.draw1 then
			msgCtrl.register(cmdCfg.module, cmdCfg.draw1, handler(self, self.reqDrawOneRsp))
		end
		if cmdCfg.draw2 then
			msgCtrl.register(cmdCfg.module, cmdCfg.draw2, handler(self, self.reqDrawTenRsp))
		end
		if cmdCfg.stage then
			msgCtrl.register(cmdCfg.module, cmdCfg.stage, handler(self, self.reqStageRewardRsp))
		end
		if cmdCfg.needItemEvent then
			local backpackCtrl = SoraDGetCtrl("backpackCtrl")
			backpackCtrl:addItemChangeEvent(cmdCfg.itemID, handler(self, self["notifyItemCount_" .. activityID]))
		end
	end
end
function activityCommonDrawCtrl:Logout()
	activityCommonDrawCtrl.super.Logout(self)
	self:resetData()
end
function activityCommonDrawCtrl:resetData()
	_ENV = nil
	_ENV = nil
	;(nil)[gActivityTimeActivityID.PHOENIX_ARRIVAL], (nil).allianceScore = nil, 0
	_ENV = nil
	;(nil).round = 0
	;(nil).totalTimes = 0
	self.activityData, (nil)[gActivityTimeActivityID.LAMP_WISH_ACTIVITY], (nil).stageReward, _ENV, (nil).curTimes = nil, nil, nil, nil, 0
end
function activityCommonDrawCtrl:initClientData(activityID, data)
	if not data then
		return
	end
	_ENV = nil
	;(nil).activityID = activityID
	;(nil).data = data
	dump(nil, "activityCommonDrawCtrl:initClientData", 10)
	self:updateActivityData(activityID, data)
end
function activityCommonDrawCtrl:notifyItemCount_9001617(...)
	print("==activityCommonDrawCtrl:notifyItemCount_9001617==", ...)
	_ENV = "==activityCommonDrawCtrl:notifyItemCount_9001617=="
	;("==activityCommonDrawCtrl:notifyItemCount_9001617==").msg = "MESSAGE_ACTIVITY_9001617_UPDATE"
	;("==activityCommonDrawCtrl:notifyItemCount_9001617==").key = "itemCount"
	SoraDSendMessage("==activityCommonDrawCtrl:notifyItemCount_9001617==")
end
function activityCommonDrawCtrl:sendReqInitDataMsg(activityID)
	self:reqInit(activityID)
end
function activityCommonDrawCtrl:reqInit(activityID)
	local cmdCfg = self.cmdConfig[activityID]
	serverproxy, serverproxy = nil, nil
	;(nil).activityID = activityID
	serverproxy:Request(cmdCfg.module, cmdCfg.init, nil, nil)
end
function activityCommonDrawCtrl:reqInitRsp(content)
	dump(content, "activityCommonDrawCtrl:reqInitRsp(content)", 10)
	local activityID = content.clientData.activityID
	if content.err ~= gErrDef.Err_None then
		return
	end
	self.activityData[activityID] = content.rspdata
	if activityID == gActivityTimeActivityID.LOTTERY_ACTIVITY_9001588 then
		_ENV = content.rspdata
		content.rspdata.msg = "MESSAGE_ACTIVITY_9001588_UPDATE"
		SoraDSendMessage(content.rspdata)
	elseif activityID == gActivityTimeActivityID.LOTTERY_ACTIVITY_9001563 then
		_ENV = content.rspdata
		content.rspdata.msg = "MESSAGE_ACTIVITY_9001563_UPDATE"
		SoraDSendMessage(content.rspdata)
	elseif activityID == gActivityTimeActivityID.LOTTERY_ACTIVITY_9001564 then
		_ENV = content.rspdata
		content.rspdata.msg = "MESSAGE_ACTIVITY_9001564_UPDATE"
		SoraDSendMessage(content.rspdata)
	elseif activityID == gActivityTimeActivityID.LOTTERY_ACTIVITY_9001546 then
		_ENV = content.rspdata
		content.rspdata.msg = "MESSAGE_UPDATE_LOTTERY_9001546"
		SoraDSendMessage(content.rspdata)
		_ENV = content.rspdata
		content.rspdata.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspdata.eventID = activityID
		SoraDSendMessage(content.rspdata)
	elseif activityID == gActivityTimeActivityID.LOTTERY_ACTIVITY_9001545 then
		_ENV = content.rspdata
		content.rspdata.msg = "MESSAGE_ACTIVITY_9001545_UPDATE"
		SoraDSendMessage(content.rspdata)
	elseif activityID == gActivityTimeActivityID.LOTTERY_ACTIVITY_9001544 then
		_ENV = content.rspdata
		content.rspdata.msg = "MESSAGE_ACTIVITY_9001544_UPDATE"
		content.rspdata.subMsg = "init"
		SoraDSendMessage(content.rspdata)
	else
		_ENV = content.rspdata
		content.rspdata.msg = "MESSAGE_ACTIVITY_COMMON_DRAW_UPDATE"
		content.rspdata.activityID = activityID
		content.rspdata.subMsg = "init"
		SoraDSendMessage(content.rspdata)
	end
end
function activityCommonDrawCtrl:reqDrawOne(activityID, times)
	local cmdCfg = self.cmdConfig[activityID]
	serverproxy = nil
	serverproxy, (nil).times = nil, times
	;(nil).activityID = activityID
	serverproxy:Request(cmdCfg.module, cmdCfg.draw1, nil, nil)
end
function activityCommonDrawCtrl:reqDrawOneRsp(content)
	dump(content, "activityCommonDrawCtrl:reqDrawOneRsp(content)", 10)
	local activityID = content.clientData.activityID
	if content.err ~= gErrDef.Err_None then
		return
	end
	local rspdata = content.rspdata
	self.activityData[activityID] = rspdata.initData
	if activityID == gActivityTimeActivityID.LOTTERY_ACTIVITY_9001588 then
		_ENV = rspdata.initData
		rspdata.initData.msg = "MESSAGE_ACTIVITY_9001588_UPDATE"
		rspdata.initData.ids = rspdata.ids
		rspdata.initData.rewardDetail = rspdata.rewardDetail
		SoraDSendMessage(rspdata.initData)
	elseif activityID == gActivityTimeActivityID.LOTTERY_ACTIVITY_9001563 then
		if not rspdata.rewards then
			local _ENV, rewards = rspdata.rewards, rspdata.rewards
		end
		_ENV = rspdata.rewardDetail
		rspdata.rewardDetail.msg = "MESSAGE_ACTIVITY_9001563_UPDATE"
		rspdata.rewardDetail.rewards = rewards
		SoraDSendMessage(rspdata.rewardDetail)
	elseif activityID == gActivityTimeActivityID.LOTTERY_ACTIVITY_9001564 then
		_ENV = SoraDSendMessage
		SoraDSendMessage.msg = "MESSAGE_ACTIVITY_9001564_UPDATE"
		SoraDSendMessage.ids = rspdata.ids
		SoraDSendMessage.rewardDetail = rspdata.rewardDetail
		SoraDSendMessage(SoraDSendMessage)
	elseif activityID == gActivityTimeActivityID.LOTTERY_ACTIVITY_9001546 then
		_ENV = SoraDSendMessage
		SoraDSendMessage.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		SoraDSendMessage.eventID = activityID
		SoraDSendMessage(SoraDSendMessage)
		_ENV = SoraDSendMessage
		SoraDSendMessage.msg = "MESSAGE_UPDATE_LOTTERY_9001546"
		SoraDSendMessage(SoraDSendMessage)
		_ENV = SoraDSendMessage
		SoraDSendMessage.msg = "MESSAGE_UPDATE_LOTTERY_9001546_REWARD"
		SoraDSendMessage.rewards = rspdata.rewards
		SoraDSendMessage(SoraDSendMessage)
	elseif activityID == gActivityTimeActivityID.LOTTERY_ACTIVITY_9001545 then
		_ENV = nil
		;(nil).reward = rspdata.rewards
		uiManager:show("DesertMiningGetReward", nil)
		_ENV = uiManager
		uiManager.msg = "MESSAGE_ACTIVITY_9001545_UPDATE"
		SoraDSendMessage(uiManager)
	elseif activityID == gActivityTimeActivityID.LOTTERY_ACTIVITY_9001544 then
		_ENV = uiManager
		uiManager.msg = "MESSAGE_ACTIVITY_9001544_UPDATE"
		uiManager.subMsg = "lottery"
		uiManager.position = rspdata.lotteryIndex
		uiManager.reward = rspdata.rewards
		SoraDSendMessage(uiManager)
	elseif activityID == gActivityTimeActivityID.ROARING_FLAME_WAR_ACTIVITY then
		SoraDGetCtrl("roaringFlameWarCtrl"):setTurntableData(rspdata.turntable)
		_ENV = SoraDGetCtrl("roaringFlameWarCtrl")
		SoraDGetCtrl("roaringFlameWarCtrl").msg = "MESSAGE_ROARINGFLAMEWAR_TURNTABLE"
		SoraDGetCtrl("roaringFlameWarCtrl").key = "lottery"
		SoraDGetCtrl("roaringFlameWarCtrl").rspdata = rspdata
		SoraDSendMessage((SoraDGetCtrl("roaringFlameWarCtrl")))
	elseif activityID == gActivityTimeActivityID.LAMP_WISH_ACTIVITY then
		if not rspdata.rewardsDetail then
			local _ENV, rewards = rspdata.rewardsDetail, rspdata.rewardsDetail
		end
		_ENV = rspdata.turntable
		rspdata.turntable.msg = "MESSAGE_ACTIVITY_9001718_UPDATE"
		rspdata.turntable.rewards = rewards
		SoraDSendMessage(rspdata.turntable)
	else
		self.activityData[activityID] = rspdata
		local reward = rspdata.reward or rspdata.rewards
		if reward then
			SoraDMailGainItems(reward, true)
		end
		_ENV = reward
		reward.msg = "MESSAGE_ACTIVITY_COMMON_DRAW_UPDATE"
		reward.activityID = activityID
		reward.subMsg = "drawOne"
		SoraDSendMessage(reward)
	end
end
function activityCommonDrawCtrl:reqDrawTen(activityID, signDay)
	local cmdCfg = self.cmdConfig[activityID]
	serverproxy = nil
	serverproxy, (nil).signDay = nil, signDay
	;(nil).activityID = activityID
	serverproxy:Request(cmdCfg.module, cmdCfg.draw2, nil, nil)
end
function activityCommonDrawCtrl:reqDrawTenRsp(content)
	dump(content, "activityCommonDrawCtrl:reqDrawTenRsp(content)", 10)
	local activityID = content.clientData.activityID
	if content.err == gErrDef.Err_None then
		self.activityData[activityID] = content.rspdata
	end
	_ENV = content.rspdata
	content.rspdata.msg = "MESSAGE_ACTIVITY_COMMON_DRAW_UPDATE"
	content.rspdata.activityID = activityID
	content.rspdata.subMsg = "drawTen"
	SoraDSendMessage(content.rspdata)
end
function activityCommonDrawCtrl:reqStageReward(activityID, stageID)
	local cmdCfg = self.cmdConfig[activityID]
	serverproxy = nil
	;(nil).stageID = stageID
	serverproxy, (nil).stageIndex = nil, stageID
	;(nil).activityID = activityID
	serverproxy:Request(cmdCfg.module, cmdCfg.stage, nil, nil)
end
function activityCommonDrawCtrl:reqStageRewardRsp(content)
	dump(content, "activityCommonDrawCtrl:reqStageRewardRsp(content)", 10)
	local activityID = content.clientData.activityID
	if content.err ~= gErrDef.Err_None then
		return
	end
	local rspdata = content.rspdata
	self.activityData[activityID] = rspdata.initData
	if rspdata.rewards then
		SoraDMailGainItems(rspdata.rewards, true)
	end
	if activityID == gActivityTimeActivityID.LOTTERY_ACTIVITY_9001545 then
		_ENV = rspdata.rewards
		rspdata.rewards.msg = "MESSAGE_ACTIVITY_9001545_UPDATE"
		SoraDSendMessage(rspdata.rewards)
	elseif activityID == gActivityTimeActivityID.LOTTERY_ACTIVITY_9001544 then
		SoraDShowMsgTip(i18n("Outstanding_text_07"))
		_ENV = i18n("Outstanding_text_07")
		i18n("Outstanding_text_07").msg = "MESSAGE_ACTIVITY_9001544_UPDATE"
		SoraDSendMessage(i18n("Outstanding_text_07"))
	elseif activityID == gActivityTimeActivityID.LAMP_WISH_ACTIVITY then
		_ENV = i18n("Outstanding_text_07")
		i18n("Outstanding_text_07").msg = "MESSAGE_ACTIVITY_9001718_UPDATE"
		SoraDSendMessage(i18n("Outstanding_text_07"))
	else
		_ENV = i18n("Outstanding_text_07")
		i18n("Outstanding_text_07").msg = "MESSAGE_ACTIVITY_COMMON_DRAW_UPDATE"
		i18n("Outstanding_text_07").activityID = activityID
		i18n("Outstanding_text_07").subMsg = "stageReward"
		SoraDSendMessage(i18n("Outstanding_text_07"))
	end
end
function activityCommonDrawCtrl:getActivityData(activityID)
	if not self.activityData[activityID] then
		_UPVALUE0_ = self.activityData[activityID]
	end
	return self.activityData[activityID]
end
function activityCommonDrawCtrl:getIsFree(activityID)
	local activityData = self:getActivityData(activityID)
	return activityData.isFree == 1
end
function activityCommonDrawCtrl:getReceiveStatusAndNum(activityID)
	if activityID == gActivityTimeActivityID.LOTTERY_ACTIVITY_9001588 or activityID == gActivityTimeActivityID.LOTTERY_ACTIVITY_9001564 then
		if clientEventMgr.judgeIsOpen(activityID) then
			local backpackCtrl = SoraDGetCtrl("backpackCtrl")
			local itemID = self:getItemID(activityID)
			if backpackCtrl:getItemCount(itemID) > 0 then
				return true, -1
			end
		end
	elseif activityID == gActivityTimeActivityID.LOTTERY_ACTIVITY_9001546 then
		local backpackCtrl = SoraDGetCtrl("backpackCtrl")
		local itemID = self:getItemID(activityID)
		local num = backpackCtrl:getItemCount(itemID)
		return 0 < num or self:getIsFree(activityID), -1
	elseif activityID == gActivityTimeActivityID.LAMP_WISH_ACTIVITY then
		local backpackCtrl = SoraDGetCtrl("backpackCtrl")
		local itemID = self:getItemID(activityID)
		local itemCount = backpackCtrl:getItemCount(itemID)
		local itemCost = self:getItemCost(activityID)
		local count = math.floor(itemCount / itemCost)
		return 0 < count, -1
	else
		local backpackCtrl = SoraDGetCtrl("backpackCtrl")
		local itemID = self:getItemID(activityID)
		local itemCount = backpackCtrl:getItemCount(itemID)
		local itemCost = self:getItemCost(activityID)
		local count = math.floor(itemCount / itemCost)
		return 0 < count, count
	end
	return false, 0
end
function activityCommonDrawCtrl:getItemID(activityID)
	local cfg = self.cmdConfig[activityID]
	return cfg.itemID
end
function activityCommonDrawCtrl:getItemCost(activityID)
	local cfg = self.cmdConfig[activityID]
	return cfg.itemCost or 1
end
return activityCommonDrawCtrl
