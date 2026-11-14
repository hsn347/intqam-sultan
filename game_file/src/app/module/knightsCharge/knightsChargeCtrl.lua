local gamemodulec = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local ltBase = include("ltBase")
local knightsChargeCtrl = class("knightsChargeCtrl", gamemodulec)
knightsChargeCtrl.localClass, _ENV = "knightsChargeCtrl", "knightsChargeCtrl"
knightsChargeCtrl.localClass.rides_box_reward = require_data("rides_box_reward", true)
knightsChargeCtrl.localClass.rides_score_reward = require_data("rides_score_reward", true)
function knightsChargeCtrl.localClass.getBoxData(index)
	if index then
		return knightsChargeCtrl.localClass.rides_box_reward.data[index]
	else
		return knightsChargeCtrl.localClass.rides_box_reward.data
	end
end
function knightsChargeCtrl.localClass.getPriceData(class)
	local _ENV, ret
	for i, v in ipairs(knightsChargeCtrl.localClass.rides_score_reward.data) do
		if v.stageType == class then
			table.insert(ret, v)
		end
	end
	return ret
end
function knightsChargeCtrl:reqReward(num)
	_ENV = nil
	;(nil).cmd = gCmd.CMD_KNIGHTS_CHARGE_MODULE
	_ENV, (nil).subcmd = gCmd.REQ_KNIGHTS_GET_REWARD, gCmd.REQ_KNIGHTS_GET_REWARD
	;(nil).data, gCmd.REQ_KNIGHTS_GET_REWARD.index = gCmd.REQ_KNIGHTS_GET_REWARD, num
	local msg
	serverproxy:SendMsg(msg)
end
function knightsChargeCtrl:reqPersonalRankinfo()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_KNIGHTS_CHARGE_MODULE
	;(nil).data, _ENV, (nil).subcmd = gCmd.REQ_KNIGHTS_PERSONAL_RANKINFO, gCmd.REQ_KNIGHTS_PERSONAL_RANKINFO, gCmd.REQ_KNIGHTS_PERSONAL_RANKINFO
	local msg
	serverproxy:SendMsg(msg)
end
function knightsChargeCtrl:reqAllianceRankinfo()
	_ENV = nil
	;(nil).cmd = gCmd.CMD_KNIGHTS_CHARGE_MODULE
	;(nil).data, _ENV, (nil).subcmd = gCmd.REQ_KNIGHTS_ALLIANCE_RANKINFO, gCmd.REQ_KNIGHTS_ALLIANCE_RANKINFO, gCmd.REQ_KNIGHTS_ALLIANCE_RANKINFO
	local msg
	serverproxy:SendMsg(msg)
end
function knightsChargeCtrl:rewardRsp(content)
	dump(content, "knightsChargeCtrl:rewardRsp", 10)
	if content.err == gErrDef.Err_None then
		local rewardInfo = content.rspdata.rewardInfo
		local _ENV, transList = gErrDef.Err_None, gErrDef.Err_None
		for i, v in ipairs(rewardInfo) do
			if transList[tostring(v.id)] then
				transList[tostring(v.id)] = transList[tostring(v.id)] + v.count
			else
				transList[tostring(v.id)] = v.count
			end
		end
		SoraDMailGainItems(transList)
		self.knightsChargeData.rewardFlag = content.rspdata.rewardFlag
		_ENV = content.rspdata.rewardFlag
		content.rspdata.rewardFlag.msg = "MESSAGE_SERVER_KNIGHTSCHARGE_REWARD"
		SoraDSendMessage(content.rspdata.rewardFlag)
		_ENV = content.rspdata.rewardFlag
		content.rspdata.rewardFlag.msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		content.rspdata.rewardFlag.eventID = gActivityTimeActivityID.KNIGHTS_CHARGE
		SoraDSendMessage(content.rspdata.rewardFlag)
	else
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_KNIGHTSCHARGE_ERRBACK"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function knightsChargeCtrl:personalRankinfoRsp(content)
	dump(content, "knightsChargeCtrl:personalRankinfoRsp", 10)
	if content.err == gErrDef.Err_None then
		local rankList = content.rspdata.rankData
		local myRank = content.rspdata.myRank
		_ENV = 10
		;(10).msg = "MESSAGE_SERVER_KNIGHTSCHARGE_PERSONALRANK"
		;(10).rankList = rankList
		;(10).myRank = myRank
		SoraDSendMessage(10)
	else
		_ENV = content.rspdata.myRank
		content.rspdata.myRank.msg = "MESSAGE_SERVER_KNIGHTSCHARGE_ERRBACK"
		SoraDSendMessage(content.rspdata.myRank)
	end
end
function knightsChargeCtrl:allianceRankinfoRsp(content)
	dump(content, "knightsChargeCtrl:allianceRankinfoRsp", 10)
	if content.err == gErrDef.Err_None then
		local rankList = content.rspdata.rankData
		local myRank = content.rspdata.myRank
		_ENV = 10
		;(10).msg = "MESSAGE_SERVER_KNIGHTSCHARGE_ALLIANCERANK"
		;(10).rankList = rankList
		;(10).myRank = myRank
		SoraDSendMessage(10)
	else
		_ENV = content.rspdata.myRank
		content.rspdata.myRank.msg = "MESSAGE_SERVER_KNIGHTSCHARGE_ERRBACK"
		SoraDSendMessage(content.rspdata.myRank)
	end
end
function knightsChargeCtrl:notifyDataRsp(event)
	if event.data then
		for _, content in pairs(event.data) do
			local revcDataType = content.type
			local revcData = content.data
			if revcDataType == "refreshData" then
				self.knightsChargeData = revcData
			elseif revcDataType == "refreshKillNum" then
				self.knightsChargeData.killNum = revcData.killNum
			end
			_ENV = revcData.killNum
			revcData.killNum.msg = "MESSAGE_SERVER_KNIGHTSCHARGE_ALLREFRESH"
			SoraDSendMessage(revcData.killNum)
		end
	end
end
function knightsChargeCtrl:getKnightsChargeData(...)
	return self.knightsChargeData
end
function knightsChargeCtrl:isAnyBoxCanReceive(...)
	local cur = self.knightsChargeData.killNum
	local boxData = knightsChargeCtrl.localClass.getBoxData()
	local ret = 0
	for i, v in ipairs(boxData) do
		if cur >= v.num and not self.knightsChargeData.rewardFlag[tostring(v.num)] then
			ret = ret + 1
		end
	end
	return 0 < ret, ret
end
function knightsChargeCtrl:ctor(properties)
	knightsChargeCtrl.super.ctor(self, properties)
	self:resetData()
end
function knightsChargeCtrl:resetData()
	self.knightsChargeData, _UPVALUE0_ = nil, nil
end
function knightsChargeCtrl:initClientData(data)
	if nil == data then
		return
	end
	dump(data, "knightsChargeCtrl:initClientData", 10)
	self.knightsChargeData = data
	self:registerNotify()
end
function knightsChargeCtrl:EnterGame()
	knightsChargeCtrl.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_KNIGHTS_CHARGE_MODULE, gCmd.REQ_KNIGHTS_GET_REWARD, handler(self, self.rewardRsp))
	msgCtrl.register(gCmd.CMD_KNIGHTS_CHARGE_MODULE, gCmd.REQ_KNIGHTS_PERSONAL_RANKINFO, handler(self, self.personalRankinfoRsp))
	msgCtrl.register(gCmd.CMD_KNIGHTS_CHARGE_MODULE, gCmd.REQ_KNIGHTS_ALLIANCE_RANKINFO, handler(self, self.allianceRankinfoRsp))
end
function knightsChargeCtrl:getReceiveStatusAndNum(...)
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.KNIGHTS_CHARGE) and self:isAnyBoxCanReceive() then
		return true, -1
	else
		return false, 0
	end
end
function knightsChargeCtrl:registerNotify(...)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.KNIGHTS_CHARGE, handler(self, self.notifyDataRsp))
end
function knightsChargeCtrl:Logout()
	knightsChargeCtrl.super.Logout(self)
	self:resetData()
end
return knightsChargeCtrl
