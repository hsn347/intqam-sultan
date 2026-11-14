local GameModule = include("GameModule")
local rocketRushCtrl = class("rocketRushCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function rocketRushCtrl:ctor(properties)
	rocketRushCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.ROCKET_RUSH
end
function rocketRushCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_ROCKET_RUSH_MODULE, gCmd.REQ_ROCKET_RUSH_DATA, handler(self, self.reqDataRsp))
	msgCtrl.register(gCmd.CMD_ROCKET_RUSH_MODULE, gCmd.REQ_ROCKET_RUSH_DONATE, handler(self, self.reqDonateRsp))
	msgCtrl.register(gCmd.CMD_ROCKET_RUSH_MODULE, gCmd.REQ_ROCKET_RUSH_REWARD, handler(self, self.reqRewardRsp))
	msgCtrl.register(gCmd.CMD_ROCKET_RUSH_MODULE, gCmd.REQ_ROCKET_RUSH_RANK, handler(self, self.reqRankRsp))
	self:resetData()
	self:registerNotify()
end
function rocketRushCtrl:resetData()
	self.gotRewards, _UPVALUE0_, self.score, _UPVALUE0_, self.classtype = nil, nil, nil, nil, 1
	self.allianceScore = 0
end
function rocketRushCtrl:initClientData(data)
	if not data then
		return
	end
	self.classtype = data.classtype or 1
	if not data.score then
		_UPVALUE0_ = data.score
	end
	self.gotRewards, _UPVALUE0_, self.score = data.score, data.score, data.score
	self.allianceScore = data.allianceScore or 0
end
function rocketRushCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.ROCKET_RUSH, handler(self, self.notifyHandler))
end
function rocketRushCtrl:notifyHandler(content)
	dump(content, "rocketRushCtrl:notifyHandler=====", 10)
	local notifydata = content.data
	for _, notifyMsg in ipairs(notifydata) do
		self.classtype = notifyMsg.data.classtype
		self.score = notifyMsg.data.score
		self.gotRewards = notifyMsg.data.gotRewards
		self.allianceScore = notifyMsg.allianceScore
	end
	_ENV = ipairs(notifydata)
	ipairs(notifydata).msg = "MESSAGE_ROCKETRUSH_UI_REFRESH"
	SoraDSendMessage(ipairs(notifydata))
	_ENV = ipairs(notifydata)
	ipairs(notifydata).msg = "MESSAGE_ACTIVITY_MODULE_UPDATE_VIEW"
	ipairs(notifydata).eventID = self.activityID
	SoraDSendMessage(ipairs(notifydata))
	_ENV = ipairs(notifydata)
	ipairs(notifydata).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	ipairs(notifydata).eventID = self.activityID
	SoraDSendMessage(ipairs(notifydata))
end
function rocketRushCtrl:sendData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ROCKET_RUSH_MODULE, gCmd.REQ_ROCKET_RUSH_DATA, nil)
end
function rocketRushCtrl:sendDonate(donateType, count)
	serverproxy = nil
	;(nil).donateType = donateType
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_ROCKET_RUSH_MODULE, gCmd.REQ_ROCKET_RUSH_DONATE, nil)
end
function rocketRushCtrl:sendReward(level)
	serverproxy = nil
	;(nil).level = level
	serverproxy:Request(gCmd.CMD_ROCKET_RUSH_MODULE, gCmd.REQ_ROCKET_RUSH_REWARD, nil)
end
function rocketRushCtrl:sendRank(iBegin, nCount)
	serverproxy = nil
	;(nil).iBegin = iBegin or 1
	;(nil).nCount = nCount or 105
	serverproxy:Request(gCmd.CMD_ROCKET_RUSH_MODULE, gCmd.REQ_ROCKET_RUSH_RANK, nil)
end
function rocketRushCtrl:reqDataRsp(content)
	dump(content, "==rocketRushCtrl:reqDataRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata.data
		self.classtype = data.classtype or 1
		if not data.score then
			_ENV = data.score
		end
		self.score = data.score
		self.gotRewards = data.gotRewards
		self.allianceScore = content.rspdata.allianceScore or 0
	end
	_ENV = content.rspdata.allianceScore or 0
	;(content.rspdata.allianceScore or 0).msg = "MESSAGE_ROCKETRUSH_UI_REFRESH"
	SoraDSendMessage(content.rspdata.allianceScore or 0)
end
function rocketRushCtrl:reqDonateRsp(content)
	dump(content, "==rocketRushCtrl:reqDonateRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata.data
		self.classtype = data.classtype or 1
		if not data.score then
			_ENV = data.score
		end
		self.score = data.score
		self.gotRewards = data.gotRewards
		self.allianceScore = content.rspdata.allianceScore or 0
		local reward = content.rspdata.reward
		if reward and next(reward) then
			SoraDMailGainItems(reward, true)
		end
	end
	_ENV = content.rspdata.reward
	content.rspdata.reward.msg = "MESSAGE_ROCKETRUSH_UI_REFRESH"
	content.rspdata.reward.isDonate = true
	content.rspdata.reward.err = content.err
	SoraDSendMessage(content.rspdata.reward)
end
function rocketRushCtrl:reqRewardRsp(content)
	dump(content, "==rocketRushCtrl:reqRewardRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata.data
		self.classtype = data.classtype or 1
		if not data.score then
			_ENV = data.score
		end
		self.score = data.score
		self.gotRewards = data.gotRewards
		local reward = content.rspdata.reward
		if reward and next(reward) then
			SoraDMailGainItems(reward, true)
		end
	end
	_ENV = content.rspdata.reward
	content.rspdata.reward.msg = "MESSAGE_ROCKETRUSH_UI_REFRESH"
	SoraDSendMessage(content.rspdata.reward)
end
function rocketRushCtrl:reqRankRsp(content)
	dump(content, "==rocketRushCtrl:reqRankRsp==", 20)
	_ENV = content
	content.msg = "MESSAGE_ROCKETRUSH_UI_RANK"
	content.myInfo = content.rspdata.myInfo
	content.rank = content.rspdata.rank
	SoraDSendMessage(content)
end
function rocketRushCtrl:getReceiveStatusAndNum()
	return self:getMayGetCount() > 0, -1
end
function rocketRushCtrl:getClassType()
	return self.classtype
end
function rocketRushCtrl:getAllianceScore()
	return self.allianceScore
end
function rocketRushCtrl:getMayGetCount()
	local count = 0
	for k, v in ipairs(self.gotRewards) do
		if not v then
			count = count + 1
		end
	end
	return count
end
function rocketRushCtrl:getHasRewardCount()
	local count = 0
	for k, v in ipairs(self.gotRewards) do
		if v then
			count = count + 1
		end
	end
	return count
end
function rocketRushCtrl:getCurRewardLevel()
	local level = 0
	for k, v in ipairs(self.gotRewards) do
		if not v then
			level = k
			break
		end
	end
	if level == 0 then
		level = math.max(#self.gotRewards + 1, 1)
	end
	return level
end
function rocketRushCtrl:getCurAllianceScore()
	local aid = SoraDGetCtrl("allianceMgr"):getOwnAid()
	return aid and self.score[tostring(aid)] or 0
end
return rocketRushCtrl
