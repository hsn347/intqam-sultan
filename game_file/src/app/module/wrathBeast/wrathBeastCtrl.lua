local GameModule = include("GameModule")
local wrathBeastCtrl = class("wrathBeastCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function wrathBeastCtrl:ctor(properties)
	wrathBeastCtrl.super.ctor(self, properties)
end
function wrathBeastCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_WRATH_BEAST_MODULE, gCmd.REQ_WRATH_BEAST_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_WRATH_BEAST_MODULE, gCmd.REQ_WRATH_BEAST_BUY_ATK_TIMES, handler(self, self.reqBuyAtkTimesRsp))
	msgCtrl.register(gCmd.CMD_WRATH_BEAST_MODULE, gCmd.REQ_WRATH_BEAST_RANK, handler(self, self.reqRankRsp))
	msgCtrl.register(gCmd.CMD_WRATH_BEAST_MODULE, gCmd.REQ_WRATH_BEAST_RECORD_LOG, handler(self, self.reqRecordLogRsp))
	msgCtrl.register(gCmd.CMD_WRATH_BEAST_MODULE, gCmd.REG_WRATH_BEAST_GET_REWARD, handler(self, self.reqGetRewardRsp))
	self:resetData()
	self:registerNotify()
end
function wrathBeastCtrl:resetData()
	_UPVALUE0_ = nil
	;(nil).godBeastGem = 0
	;(nil).buyTimes = 0
	;(nil).atkTimes = 0
	;(nil).noCritTimes = 0
	;(nil).records, _UPVALUE0_, (nil).selfRank, _UPVALUE0_, (nil).ranks, _UPVALUE0_, (nil).receivedReward, _UPVALUE0_, (nil).totalDamage = nil, nil, nil, nil, nil, nil, nil, nil, 0
	self.activityData, (nil).turnIndex = nil, 1
end
function wrathBeastCtrl:Logout()
	self:resetData()
	wrathBeastCtrl.super.Logout(self)
end
function wrathBeastCtrl:initClientData(data)
	if data then
		self:setActivityData(data)
	end
end
function wrathBeastCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.WRATH_BEAST, handler(self, self.notifyHandler))
end
function wrathBeastCtrl:notifyHandler(content)
	local notifydata = content.data
	for _, notifyMsg in ipairs(notifydata) do
		self:setActivityData(notifyMsg.rspdata)
	end
	_ENV = ipairs(notifydata)
	ipairs(notifydata).msg = "MESSAGE_WRATH_BEAST_REFRESH"
	ipairs(notifydata).name = "notify"
	SoraDSendMessage(ipairs(notifydata))
end
function wrathBeastCtrl:setActivityData(activityData)
	if not activityData then
		return
	end
	for k, v in pairs(self.activityData) do
		if activityData[k] then
			self.activityData[k] = activityData[k]
		end
		if k == "ranks" then
			for i, v in ipairs(self.activityData[k]) do
				v.rank = i
			end
		end
	end
end
function wrathBeastCtrl:sendReqInitMsg()
	serverproxy:Request(gCmd.CMD_WRATH_BEAST_MODULE, gCmd.REQ_WRATH_BEAST_INIT)
end
function wrathBeastCtrl:sendReqBuyAtkTimesMsg(buyTimes)
	serverproxy = nil
	;(nil).buyTimes = buyTimes
	serverproxy:Request(gCmd.CMD_WRATH_BEAST_MODULE, gCmd.REQ_WRATH_BEAST_BUY_ATK_TIMES, nil)
end
function wrathBeastCtrl:sendReqRankMsg()
	serverproxy:Request(gCmd.CMD_WRATH_BEAST_MODULE, gCmd.REQ_WRATH_BEAST_RANK)
end
function wrathBeastCtrl:sendReqRecordLogMsg()
	serverproxy:Request(gCmd.CMD_WRATH_BEAST_MODULE, gCmd.REQ_WRATH_BEAST_RECORD_LOG)
end
function wrathBeastCtrl:sendReqGetRewardMsg(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_WRATH_BEAST_MODULE, gCmd.REG_WRATH_BEAST_GET_REWARD, nil)
end
function wrathBeastCtrl:reqInitRsp(content)
	if content.err == gErrDef.Err_None then
		self:setActivityData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_WRATH_BEAST_REFRESH"
		self.name = "init"
		SoraDSendMessage(self)
	end
end
function wrathBeastCtrl:reqBuyAtkTimesRsp(content)
	if content.err == gErrDef.Err_None then
		self:setActivityData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_WRATH_BEAST_REFRESH"
		self.name = "buyAttack"
		SoraDSendMessage(self)
	end
end
function wrathBeastCtrl:reqRankRsp(content)
	if content.err == gErrDef.Err_None then
		self:setActivityData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_WRATH_BEAST_REFRESH"
		self.name = "rank"
		SoraDSendMessage(self)
	end
end
function wrathBeastCtrl:reqRecordLogRsp(content)
	if content.err == gErrDef.Err_None then
		_ENV = nil
		;(nil).records = content.rspdata
		self:setActivityData(nil)
		_ENV = self
		self.msg = "MESSAGE_WRATH_BEAST_REFRESH"
		self.name = "record"
		SoraDSendMessage(self)
	end
end
function wrathBeastCtrl:reqGetRewardRsp(content)
	if content.err == gErrDef.Err_None then
		self:setActivityData(content.rspdata)
		SoraDMailGainItems(content.rspreward, true)
		_ENV = content.rspreward
		content.rspreward.msg = "MESSAGE_WRATH_BEAST_REFRESH"
		content.rspreward.name = "reward"
		SoraDSendMessage(content.rspreward)
		_ENV = content.rspreward
		content.rspreward.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		content.rspreward.eventID = gActivityTimeActivityID.WRATH_BEAST_ACTIVITY
		SoraDSendMessage(content.rspreward)
	end
end
function wrathBeastCtrl:getActivityData(key)
	if key then
		return self.activityData[key]
	else
		return self.activityData
	end
end
function wrathBeastCtrl:initConfig(...)
	if not self.wbtdrData then
		self.wbtdrData = require_data("wrath_beast_total_damage_reward", true).data
		self.rrData = require_data("wrath_beast_rank_reward", true).data
		self.lrData = require_data("wrath_beast_lucky_reward", true).data
		self.killerData = require_data("wrath_beast_killer", true).data
		self.beastData = require_data("wrath_beast_data", true).data
		local atkData = require_data("wrath_beast_atk_times", true).data
		local _ENV, ret = "wrath_beast_atk_times", "wrath_beast_atk_times"
		for __, v in ipairs(atkData) do
			if v.buyNum[1] ~= 0 then
				for j = v.buyNum[1], v.buyNum[2] do
					ret[j] = v.cost
				end
			end
		end
		self.atkData = ret
		self.freeAttackNum = atkData[1].attackNum
	end
end
function wrathBeastCtrl:getBoxRewardConfig(index)
	self:initConfig()
	if index then
		return self.wbtdrData[index]
	else
		return self.wbtdrData
	end
end
function wrathBeastCtrl:getRankRewardConfig(...)
	self:initConfig()
	return self.rrData
end
function wrathBeastCtrl:getLuckyRewardConfig(...)
	self:initConfig()
	return self.lrData
end
function wrathBeastCtrl:getKillerConfig(...)
	self:initConfig()
	return self.killerData
end
function wrathBeastCtrl:getKillerArmyType()
	local index = self:getActivityData("turnIndex")
	local killerData = self:getKillerConfig()
	return killerData[index] and killerData[index].armyType
end
function wrathBeastCtrl:getWrathBeastConfig(...)
	self:initConfig()
	return self.beastData
end
function wrathBeastCtrl:getWrathBeastData(bossType)
	bossType = bossType or 1
	local beastData = self:getWrathBeastConfig()
	return beastData[bossType] or beastData[1]
end
function wrathBeastCtrl:getAtkTimesConfig(...)
	self:initConfig()
	return self.atkData
end
function wrathBeastCtrl:getLeftBuyTimes(...)
	local atkConfig = self:getAtkTimesConfig()
	local buyTimes = self:getActivityData("buyTimes")
	local leftTimes = #atkConfig - buyTimes
	return leftTimes
end
_ENV, wrathBeastCtrl.getFreeAtkTimes = function(self, ...)
	self:initConfig()
	return self.freeAttackNum
end, function(self, ...)
	self:initConfig()
	return self.freeAttackNum
end
;(function(self, ...)
	self:initConfig()
	return self.freeAttackNum
end).FATAL_BLOW = 1
;(function(self, ...)
	self:initConfig()
	return self.freeAttackNum
end).END_BLOW = 2
;(function(self, ...)
	self:initConfig()
	return self.freeAttackNum
end).LUCKY_BLOW = 3
;(function(self, ...)
	self:initConfig()
	return self.freeAttackNum
end).LUCKY_TURNS_BLOW = 4
gWBeastRecordType, (function(self, ...)
	self:initConfig()
	return self.freeAttackNum
end).CRIT = function(self, ...)
	self:initConfig()
	return self.freeAttackNum
end, 5
function wrathBeastCtrl:getAtkTypeStr(atkType)
	_ENV = nil
	;(nil)[gWBeastRecordType.FATAL_BLOW] = "god_beast_text_19"
	;(nil)[gWBeastRecordType.END_BLOW] = "god_beast_text_20"
	;(nil)[gWBeastRecordType.LUCKY_BLOW] = "god_beast_text_21"
	local (nil)[gWBeastRecordType.LUCKY_TURNS_BLOW], atkType2Str = "god_beast_text_22", nil
	return i18n(atkType2Str[atkType] or "")
end
function wrathBeastCtrl:getReceiveStatusAndNum(activityID)
	local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
	local ret1, redNum = activityExchangeMallCtrl:getReceiveStatusAndNum(activityID)
	local ret2, canReceiveBox = self:getCanReceiveBoxNum(activityID)
	return ret1 or ret2, -1
end
function wrathBeastCtrl:getCanReceiveBoxNum(activityID)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	if not activityShowCtrl:isActivityOpen(activityID) then
		return false, 0
	end
	local cur = self:getActivityData("totalDamage")
	local receivedReward = self:getActivityData("receivedReward")
	local boxData = self:getBoxRewardConfig()
	local canReceiveBoxNum = 0
	for i, v in ipairs(boxData) do
		if cur >= v.num and not receivedReward[tostring(i)] then
			canReceiveBoxNum = canReceiveBoxNum + 1
		end
	end
	return 0 < canReceiveBoxNum, canReceiveBoxNum
end
return wrathBeastCtrl
