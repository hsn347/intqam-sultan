local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001642_Ctrl = class("activity_9001642_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001642_Ctrl:ctor(properties)
	activity_9001642_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.PHOENIX_CHALLENGE
	self:resetData()
end
function activity_9001642_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_PHOENIX_CHALLENGE_MODULE, gCmd.REQ_PHOENIX_CHALLENGE_DATA, handler(self, self.reqDataRsp))
	msgCtrl.register(gCmd.CMD_PHOENIX_CHALLENGE_MODULE, gCmd.REQ_PHOENIX_CHALLENGE_SUMMON, handler(self, self.reqSummonRsp))
	msgCtrl.register(gCmd.CMD_PHOENIX_CHALLENGE_MODULE, gCmd.REQ_PHOENIX_CHALLENGE_ALLIANCE_RANK, handler(self, self.reqAllianceRankRsp))
	msgCtrl.register(gCmd.CMD_PHOENIX_CHALLENGE_MODULE, gCmd.REQ_PHOENIX_CHALLENGE_PLAYER_RANK, handler(self, self.reqPlayerRankRsp))
	self:registerNotify()
end
function activity_9001642_Ctrl:Logout()
	activity_9001642_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001642_Ctrl:resetData()
	self.allianceData, _UPVALUE0_, self.data, _UPVALUE0_ = nil, nil, nil, nil
	self.phoenixType = 1
end
function activity_9001642_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.PHOENIX_CHALLENGE, handler(self, self.notifyHandler))
end
function activity_9001642_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001642_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		if v.data then
			self.data = v.data
		end
		if v.allianceData then
			self.allianceData = v.allianceData
		end
		if v.disappear then
			self.allianceData.phoenix = nil
		end
	end
	_ENV = ipairs(event.data)
	ipairs(event.data).msg = "MESSAGE_ACTIVITY_9001642_UPDATE"
	SoraDSendMessage(ipairs(event.data))
end
function activity_9001642_Ctrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_PHOENIX_CHALLENGE_MODULE, gCmd.REQ_PHOENIX_CHALLENGE_DATA, nil)
end
function activity_9001642_Ctrl:sendSummonMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_PHOENIX_CHALLENGE_MODULE, gCmd.REQ_PHOENIX_CHALLENGE_SUMMON, nil)
end
function activity_9001642_Ctrl:sendReqAllianceRankMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_PHOENIX_CHALLENGE_MODULE, gCmd.REQ_PHOENIX_CHALLENGE_ALLIANCE_RANK, nil)
end
function activity_9001642_Ctrl:sendReqPlayerRankMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_PHOENIX_CHALLENGE_MODULE, gCmd.REQ_PHOENIX_CHALLENGE_PLAYER_RANK, nil)
end
function activity_9001642_Ctrl:reqDataRsp(content)
	dump(content, "activity_9001642_Ctrl:reqDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.data = content.rspdata.data
		if not content.rspdata.allianceData then
			_ENV = content.rspdata.allianceData
		end
		self.allianceData = content.rspdata.allianceData
		self.phoenixType = content.rspdata.phoenixType or 1
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001642_UPDATE"
	SoraDSendMessage(gErrDef.Err_None)
end
function activity_9001642_Ctrl:reqSummonRsp(content)
	dump(content, "activity_9001642_Ctrl:reqSummonRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.allianceData.lastPhoenixTime = content.rspdata.lastPhoenixTime
		self.allianceData.phoenix = content.rspdata.phoenix
		local mapObj = self:getPhoenixObj()
		if next(mapObj) then
			SoraDShowMsgTip(i18n("heroicSouls_text_10"))
			SoraDGotoWorldMapPoint(cc.p(mapObj.x, mapObj.y), true)
			SoraDRemoveAllPanelFromManager()
		end
	elseif content.err == gErrDef.Err_PHOENIX_CHALLENGE_ALREADY_SUMMON then
		SoraDShowMsgTip(i18n("Phonex_Challenge_text_10"))
		if content.rspdata.lastPhoenixTime then
			self.allianceData.lastPhoenixTime = content.rspdata.lastPhoenixTime
		end
		if content.rspdata.phoenix then
			self.allianceData.phoenix = content.rspdata.phoenix
		end
	end
	_ENV = content.rspdata.phoenix
	content.rspdata.phoenix.msg = "MESSAGE_ACTIVITY_9001642_UPDATE"
	SoraDSendMessage(content.rspdata.phoenix)
end
function activity_9001642_Ctrl:reqAllianceRankRsp(content)
	dump(content, "activity_9001642_Ctrl:reqAllianceRankRsp(content)", 10)
	local _ENV, rankList = dump, dump
	local myInfo
	if content.err == gErrDef.Err_None then
		rankList = content.rspdata.rankList
		myInfo = content.rspdata.myInfo
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001642_RANK"
	gErrDef.Err_None.rankList = rankList
	gErrDef.Err_None.myInfo = myInfo
	SoraDSendMessage(gErrDef.Err_None)
end
function activity_9001642_Ctrl:reqPlayerRankRsp(content)
	dump(content, "activity_9001642_Ctrl:reqPlayerRankRsp(content)", 10)
	local _ENV, rankList = dump, dump
	local myInfo
	if content.err == gErrDef.Err_None then
		rankList = content.rspdata.rankList
		myInfo = content.rspdata.myInfo
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001642_RANK"
	gErrDef.Err_None.rankList = rankList
	gErrDef.Err_None.myInfo = myInfo
	SoraDSendMessage(gErrDef.Err_None)
end
function activity_9001642_Ctrl:getReceiveStatusAndNum()
	local status = self:getPhoenixStatus()
	return status == 2, -1
end
function activity_9001642_Ctrl:getPhoenixType()
	return self.phoenixType
end
function activity_9001642_Ctrl:getPhoenixStatus()
	local status = 1
	if self.allianceData and self.allianceData.phoenix and serviceFunctions.isSameDay(self.allianceData.lastPhoenixTime) then
		if self:getPhoenixLeftTime() > 0 then
			status = 2
		else
			status = 3
		end
	end
	return status
end
function activity_9001642_Ctrl:getPhoenixLeftTime()
	local removeAfterSec = worldMapDefine.getWorldBossRemoveAfterSec(gBossType.phoenixChallengeBoss, 1)
	return math.max(0, self.allianceData.lastPhoenixTime + removeAfterSec - serviceFunctions.systemTime())
end
function activity_9001642_Ctrl:getPhoenixObj()
	local kingdomMapUtil = include("kingdomMapUtil")
	local _ENV, mapObj = "kingdomMapUtil", "kingdomMapUtil"
	if self.allianceData.phoenix then
		mapObj.x, mapObj.y, mapObj.type, mapObj.subMapType, mapObj.objId = kingdomMapUtil.gSplitId(self.allianceData.phoenix)
	end
	return mapObj
end
function activity_9001642_Ctrl:getAllianceScore()
	return self.allianceData.score or 0
end
function activity_9001642_Ctrl:getChallengeTimes()
	if self.allianceData and self.allianceData.phoenix and serviceFunctions.isSameDay(self.allianceData.lastPhoenixTime) then
		return 0
	end
	return 1
end
function activity_9001642_Ctrl:getRecords()
	if not self.data.records then
		_UPVALUE0_ = self.data.records
	end
	return self.data.records
end
return activity_9001642_Ctrl
