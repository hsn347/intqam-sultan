local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local starLampCeremonyCtrl = class("starLampCeremonyCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local constantRead = include("constantRead")
local starLampCeremonyRead = include("starLampCeremonyRead")
function starLampCeremonyCtrl:ctor(properties)
	starLampCeremonyCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.STAR_LAMP_CEREMONY_ACTIVITY
	self.itemID = constantRead.getConstValue("STARLIGHT_CEREMONY_ITEM", 859901)
	self:resetData()
end
function starLampCeremonyCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_STAR_LAMP_CEREMONY_MODULE, gCmd.REQ_STAR_LAMP_CEREMONY_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_STAR_LAMP_CEREMONY_MODULE, gCmd.REQ_STAR_LAMP_CEREMONY_RANK, handler(self, self.reqStarLampCeremonyRankRsp))
	msgCtrl.register(gCmd.CMD_STAR_LAMP_CEREMONY_MODULE, gCmd.REQ_STAR_LAMP_CEREMONY_FIRE, handler(self, self.reqStarLampCeremonyFireRsp))
	self:registerNotify()
end
function starLampCeremonyCtrl:initClientData(data)
	if data and data[tostring(self.activityID)] then
		self.msgData = data[tostring(self.activityID)]
	end
end
function starLampCeremonyCtrl:Logout()
	starLampCeremonyCtrl.super.Logout(self)
	self:resetData()
end
function starLampCeremonyCtrl:resetData()
	self.rankData, _UPVALUE0_, self.msgData, _UPVALUE0_ = nil, nil, nil, nil
end
function starLampCeremonyCtrl:registerNotify()
end
function starLampCeremonyCtrl:notifyHandler(event)
end
function starLampCeremonyCtrl:sendReqInitDataMsg()
	if clientEventMgr.judgeIsOpen(self.activityID) then
		_ENV = nil
		serverproxy:Request(gCmd.CMD_STAR_LAMP_CEREMONY_MODULE, gCmd.REQ_STAR_LAMP_CEREMONY_INIT, nil)
	end
end
function starLampCeremonyCtrl:reqStarLampCeremonyRank(iBegin, nCount)
	serverproxy = nil
	;(nil).iBegin = iBegin
	;(nil).nCount = nCount
	serverproxy:Request(gCmd.CMD_STAR_LAMP_CEREMONY_MODULE, gCmd.REQ_STAR_LAMP_CEREMONY_RANK, nil)
end
function starLampCeremonyCtrl:reqStarLampCeremonyFire(bUseAll)
	serverproxy = nil
	;(nil).bUseAll = bUseAll
	serverproxy:Request(gCmd.CMD_STAR_LAMP_CEREMONY_MODULE, gCmd.REQ_STAR_LAMP_CEREMONY_FIRE, nil)
end
function starLampCeremonyCtrl:reqInitRsp(content)
	dump(content, "starLampCeremonyCtrl:reqInit(content)", 10)
	if content.err == gErrDef.Err_None then
		self.msgData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_UPDATE_STAR_LAMP_CEREMONY"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function starLampCeremonyCtrl:reqStarLampCeremonyRankRsp(content)
	dump(content, "starLampCeremonyCtrl:reqStarLampCeremonyRankRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.rankData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_UPDATE_STAR_LAMP_CEREMONY_RANK"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function starLampCeremonyCtrl:reqStarLampCeremonyFireRsp(content)
	dump(content, "starLampCeremonyCtrl:reqStarLampCeremonyFireRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.msgData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_UPDATE_STAR_LAMP_CEREMONY"
		SoraDSendMessage(gErrDef.Err_None)
		SoraDMailGainItems(content.rspdata.reward, true)
	end
end
function starLampCeremonyCtrl:getReceiveStatusAndNum()
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local itemHave = backpackCtrl:getItemCount(self.itemID)
	if 1 <= itemHave then
		return true, -1
	end
end
function starLampCeremonyCtrl:getMySocre()
	return self.msgData.score or 0
end
function starLampCeremonyCtrl:getRankData()
	return self.rankData
end
return starLampCeremonyCtrl
