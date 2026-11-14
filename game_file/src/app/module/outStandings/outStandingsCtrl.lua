local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local outStandingsCtrl = class("outStandingsCtrl", GameModule)
local outStandingsRead = include("outStandingsRead")
function outStandingsCtrl:ctor(properties)
	outStandingsCtrl.super.ctor(self, properties)
end
function outStandingsCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_OUTSTANDING_MODULE, gCmd.REQ_OUTSTANDING_INIT, handler(self, self.sendReqInfoRsp))
	msgCtrl.register(gCmd.CMD_OUTSTANDING_MODULE, gCmd.REG_OUTSTANDING_GET_REWARD, handler(self, self.sendReqRewardsRsp))
	self:resetData()
	self:registerNotify()
end
function outStandingsCtrl:Logout()
	self:resetData()
	outStandingsCtrl.super.Logout(self)
end
function outStandingsCtrl:initClientData(content)
	dump(content, "==outStandingsCtrl:initClientData==", 20)
	if not content then
		return
	end
	self.basicType = content.param.userdata.basicType
	self.rankingType = content.param.userdata.rankRewardType
	self.floorType = content.param.userdata.rankFloorType
	self.kingomList = content.param.kids
end
function outStandingsCtrl:initCompleteData(content)
	dump(content, "==outStandingsCtrl:initCompleteData==", 20)
	if not content then
		return
	end
	self.powerData = content
	self.receivedReward = self.powerData.receivedReward
	self.comPleteData = content.complete
	self.receivedReward = content.receivedReward
end
function outStandingsCtrl:resetData()
	self.powerData = nil
	self.receivedReward = nil
	self.comPleteData = nil
	self.rankingData = nil
	self.myRankingData = nil
	self.basicType = nil
	self.floorType = nil
	self.rankingType = nil
	self.kingomList = nil
end
function outStandingsCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.NOTIFY_OUTSTANDING, handler(self, self.notifyCallback))
end
function outStandingsCtrl:sendInitMsg()
	serverproxy:Request(gCmd.CMD_OUTSTANDING_MODULE, gCmd.REQ_OUTSTANDING_INIT)
end
function outStandingsCtrl:sendReqRewards(classType, index)
	serverproxy = nil
	;(nil).classType = classType
	local (nil).index, data = index, nil
	serverproxy:Request(gCmd.CMD_OUTSTANDING_MODULE, gCmd.REG_OUTSTANDING_GET_REWARD, data)
end
function outStandingsCtrl:notifyCallback(event)
	if event and event.data and type(event.data) == "table" then
		dump(event.data, "==outStandingsCtrl:notifyCallback==", 20)
		for _, content in ipairs(event.data) do
			self.powerData = content.rspdata
			self.receivedReward = self.powerData.receivedReward
			self.rankingData = content.rsprank
			self.myRankingData = content.selfrank
			self.comPleteData = content.rspdata.complete
		end
		_ENV = ipairs(event.data)
		ipairs(event.data).msg = "MESSAGE_OUTSTANDINGS_REFRESH_BACK"
		SoraDSendMessage(ipairs(event.data))
		_ENV = ipairs(event.data)
		ipairs(event.data).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		ipairs(event.data).eventID = gActivityTimeActivityID.OUTS_STANDINGS
		SoraDSendMessage(ipairs(event.data))
	end
end
function outStandingsCtrl:sendReqInfoRsp(ret)
	dump(ret, "outStandingsCtrl:sendReqInfoRsp", 10)
	if ret and ret.rspdata and ret.err == gErrDef.Err_None then
		self.powerData = ret.rspdata
		self.receivedReward = self.powerData.receivedReward
		self.rankingData = ret.rsprank
		self.myRankingData = ret.selfrank
		self.comPleteData = ret.rspdata.complete
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.OUTS_STANDINGS)
		self.kingomList = param.kids
		_ENV = gActivityTimeActivityID.OUTS_STANDINGS
		gActivityTimeActivityID.OUTS_STANDINGS.msg = "MESSAGE_OUTSTANDINGS_INIT_BACK"
		SoraDSendMessage(gActivityTimeActivityID.OUTS_STANDINGS)
	end
end
function outStandingsCtrl:sendReqRewardsRsp(ret)
	dump(ret, "outStandingsCtrl:sendReqRewardsRsp", 10)
	if ret and ret.rspdata and ret.err == gErrDef.Err_None then
		self.powerData = ret.rspdata
		self.receivedReward = self.powerData.receivedReward
		self.comPleteData = ret.rspdata.complete
		SoraDMailGainItems(ret.rspreward, true)
		_ENV = ret.rspreward
		ret.rspreward.msg = "MESSAGE_OUTSTANDINGS_RECEIVI_REWARD_BACK"
		SoraDSendMessage(ret.rspreward)
		_ENV = ret.rspreward
		ret.rspreward.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		ret.rspreward.eventID = gActivityTimeActivityID.OUTS_STANDINGS
		SoraDSendMessage(ret.rspreward)
	end
end
function outStandingsCtrl:getReceiveStatusAndNum()
	if SoraDGetCastleLv() < CASTLE_LV6_LIMITED then
		return false, 0, 0
	end
	local ret = false
	local retNum = 0
	local basicTag = 1
	local maxClassType = outStandingsRead.getMaxClassType()
	for i = 1, maxClassType do
		local ValueList = outStandingsRead.getBasicScoreByType(i, self:getBasicType())
		for j = 1, #ValueList do
			local curPower = self:getPowerByType(i)
			local isReceive = self:judgeReceiveRewardsByIndex(basicTag + outStandingsRead.getTypeCount(self:getBasicType()))
			if curPower >= ValueList[j] and not isReceive then
				ret = true
				retNum = retNum + 1
			end
			basicTag = basicTag + 1
		end
	end
	return ret, -1, retNum
end
function outStandingsCtrl:getPowerByType(powerType)
	local power = 0
	if powerType == 1 then
		power = tonumber(self.powerData.curTotalPower)
	elseif powerType == 2 then
		power = tonumber(self.powerData.curBuildPower)
	elseif powerType == 3 then
		power = tonumber(self.powerData.curTechPower)
	end
	return power == nil and 0 or power
end
function outStandingsCtrl:getRankingInfo()
	if not self.rankingData then
		_UPVALUE0_ = self.rankingData
	end
	return self.rankingData
end
function outStandingsCtrl:getMyRankingInfo()
	if not self.myRankingData then
		_UPVALUE0_ = self.myRankingData
	end
	return self.myRankingData
end
function outStandingsCtrl:getBasicType()
	return self.basicType or 1
end
function outStandingsCtrl:getFloorType()
	return self.floorType or 1
end
function outStandingsCtrl:getRankingType()
	return self.rankingType or 1
end
function outStandingsCtrl:getKingdomList()
	if not self.kingomList then
		_UPVALUE0_ = self.kingomList
	end
	return self.kingomList
end
function outStandingsCtrl:judgeReceiveRewardsByIndex(index)
	local isReceive = false
	if not self.receivedReward then
		return isReceive
	end
	if self.receivedReward[tostring(index)] then
		isReceive = true
	end
	return isReceive
end
return outStandingsCtrl
