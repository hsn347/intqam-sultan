local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local kingdomGraceRead = include("kingdomGraceRead")
local kingdomGraceCtrl = class("kingdomGraceCtrl", GameModule)
function kingdomGraceCtrl:ctor(properties)
	kingdomGraceCtrl.super.ctor(self, properties)
end
function kingdomGraceCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_KINGDOM_FAVOR_ACTIVITY_MODULE, gCmd.REQ_KINGDOM_FAVOR_ACTIVITY_DATA, handler(self, self.sendReqRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_FAVOR_ACTIVITY_MODULE, gCmd.REQ_KINGDOM_FAVOR_ACTIVITY_EXCHANGE, handler(self, self.sendReqRsp))
	self:resetData()
	self:registerNotify()
end
function kingdomGraceCtrl:Logout()
	self:resetData()
	kingdomGraceCtrl.super.Logout(self)
end
function kingdomGraceCtrl:initClientData(content)
	dump(content, "==kingdomGraceCtrl:initClientData==", 20)
	if not content then
		return
	end
	self.activityData = content
end
function kingdomGraceCtrl:resetData()
	self.activityData, _UPVALUE0_ = nil, nil
end
function kingdomGraceCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.KINGDOM_FAVOR_ACTIVITY, handler(self, self.notifyCallback))
end
function kingdomGraceCtrl:notifyCallback(event)
	dump(event, "==kingdomGraceCtrl:notifyCallback==", 20)
	if event and event.data and type(event.data) == "table" then
		for _, content in ipairs(event.data) do
			self.activityData.score = content.data.score
			_ENV = content.data.score
			content.data.score.msg = "MESSAGE_KINGDOMGRACES_REFRESH"
			SoraDSendMessage(content.data.score)
			_ENV = content.data.score
			content.data.score.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
			content.data.score.eventID = gActivityTimeActivityID.KINGDOM_FAVOR
			SoraDSendMessage(content.data.score)
		end
	end
end
function kingdomGraceCtrl:sendReqRsp(content)
	dump(content, "==kingdomGraceCtrl:sendReqInfoRsp==", 20)
	if content.err == gErrDef.Err_None then
		self.activityData.dayScore = content.rspdata.dayScore
		self.activityData.exchangeCount = content.rspdata.exchangeCount
		self.activityData.kingdomExchangeLeftCount = content.rspdata.kingdomExchangeLeftCount
		self.activityData.score = content.rspdata.score
		self.activityData.group = content.rspdata.group or self.activityData.group
		self.activityData.scoreTime = content.rspdata.scoreTime or self.activityData.scoreTime
		self.activityData.opencount = content.rspdata.opencount or self.activityData.opencount
		local reward = content.rspdata and content.rspdata.reward
		_ENV = "==kingdomGraceCtrl:sendReqInfoRsp=="
		;("==kingdomGraceCtrl:sendReqInfoRsp==").msg = "MESSAGE_KINGDOMGRACES_REFRESH"
		;("==kingdomGraceCtrl:sendReqInfoRsp==").reward = reward
		SoraDSendMessage("==kingdomGraceCtrl:sendReqInfoRsp==")
		_ENV = "==kingdomGraceCtrl:sendReqInfoRsp=="
		;("==kingdomGraceCtrl:sendReqInfoRsp==").msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		;("==kingdomGraceCtrl:sendReqInfoRsp==").eventID = gActivityTimeActivityID.KINGDOM_FAVOR
		SoraDSendMessage("==kingdomGraceCtrl:sendReqInfoRsp==")
	end
end
function kingdomGraceCtrl:sendInitMsg()
	serverproxy:Request(gCmd.CMD_KINGDOM_FAVOR_ACTIVITY_MODULE, gCmd.REQ_KINGDOM_FAVOR_ACTIVITY_DATA)
end
function kingdomGraceCtrl:sendExcahngeMsg(data)
	serverproxy:Request(gCmd.CMD_KINGDOM_FAVOR_ACTIVITY_MODULE, gCmd.REQ_KINGDOM_FAVOR_ACTIVITY_EXCHANGE, data)
end
function kingdomGraceCtrl:getScore()
	return self.activityData.score or 0
end
function kingdomGraceCtrl:getTotalGetScore()
	return self.activityData.dayScore or 0
end
function kingdomGraceCtrl:getExchangeCount()
	return self.activityData.exchangeCount or 0
end
function kingdomGraceCtrl:getKingdomExchangeLeftCount()
	return self.activityData.kingdomExchangeLeftCount or 0
end
function kingdomGraceCtrl:getCanExchangeCount()
	local score = self:getScore()
	local exchangePoint = kingdomGraceRead.getExchangeConfig(self:getGroup(), "exchange") or 1
	if gConstValue.IS_DEBUG_SERVER then
		exchangePoint = math.ceil(exchangePoint / 10)
	end
	local count = math.floor(score / exchangePoint)
	if count > self:getKingdomExchangeLeftCount() then
		return self:getKingdomExchangeLeftCount()
	else
		return count
	end
end
function kingdomGraceCtrl:getGroup()
	print("···", self.activityData.group)
	return self.activityData.group or 1
end
function kingdomGraceCtrl:getReceiveStatusAndNum(activityID)
	local redNum = self:getCanExchangeCount()
	return 0 < redNum, redNum
end
return kingdomGraceCtrl
