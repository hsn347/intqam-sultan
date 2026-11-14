local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local allianceDinnerCtrl = class("allianceDinnerCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local constantRead = include("constantRead")
local allianceDinnerRead = include("allianceDinnerRead")
function allianceDinnerCtrl:ctor(properties)
	allianceDinnerCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.ALLIANCE_DINNER_ACTIVITY
	self:resetData()
end
function allianceDinnerCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_ALLIANCE_DINNER_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_ALLIANCE_DINNER_RANK, handler(self, self.reqAllianceDinnerRankRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_ALLIANCE_DINNER_DONATE, handler(self, self.reqAllianceDinnerDonateRsp))
	self:registerNotify()
end
function allianceDinnerCtrl:initClientData(data)
	if data and data[tostring(self.activityID)] then
		self.msgData = data[tostring(self.activityID)]
	end
end
function allianceDinnerCtrl:Logout()
	allianceDinnerCtrl.super.Logout(self)
	self:resetData()
end
function allianceDinnerCtrl:resetData()
	self.msgData, _UPVALUE0_ = nil, nil
end
function allianceDinnerCtrl:registerNotify()
end
function allianceDinnerCtrl:notifyHandler(event)
end
function allianceDinnerCtrl:sendReqInitDataMsg()
	if clientEventMgr.judgeIsOpen(self.activityID) then
		_ENV = nil
		serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_ALLIANCE_DINNER_INIT, nil)
	end
end
function allianceDinnerCtrl:reqAllianceDinnerRank(nType, iBegin, nCount)
	serverproxy = nil
	;(nil).nType = nType
	;(nil).iBegin = iBegin
	;(nil).nCount = nCount
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_ALLIANCE_DINNER_RANK, nil)
end
function allianceDinnerCtrl:reqreqAllianceDinnerDonate(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_ALLIANCE_DINNER_DONATE, nil)
end
function allianceDinnerCtrl:reqInitRsp(content)
	dump(content, "allianceDinnerCtrl:reqInit(content)", 10)
	if content.err == gErrDef.Err_None then
		self.msgData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ALLIANCE_DINNER_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function allianceDinnerCtrl:reqAllianceDinnerRankRsp(content)
	dump(content, "allianceDinnerCtrl:reqAllianceDinnerRankRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ALLIANCE_DINNER_RANK"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function allianceDinnerCtrl:reqAllianceDinnerDonateRsp(content)
	dump(content, "allianceDinnerCtrl:reqAllianceDinnerDonateRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.msgData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ALLIANCE_DINNER_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
		SoraDShowMsgTip(i18n("Alliance_dinner_06"))
	else
		SoraDShowMsgTip(i18n("Alliance_dinner_07"))
	end
end
function allianceDinnerCtrl:getReceiveStatusAndNum()
	if SoraDGetCastleLv() < CASTLE_LV6_LIMITED then
		return false, -1
	end
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	if not allianceMgr:hasJoinAlliance(true) then
		return false, -1
	end
	local dinnerCfgs = self:getDinnerCfgs()
	for i, v in ipairs(dinnerCfgs) do
		local backpackCtrl = SoraDGetCtrl("backpackCtrl")
		local itemHave = backpackCtrl:getItemCount(v.dishNeed[1].id)
		if 1 <= itemHave then
			return true, -1
		end
		local itemHave = backpackCtrl:getItemCount(v.dishNeed[2].id)
		if 1 <= itemHave then
			return true, -1
		end
	end
	local show, num = false, 0
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	show, num = activityTaskComponentCtrl:getReceiveStatusAndNum(self.activityID)
	if 0 < num then
		show = true
	end
	return show, -1
end
function allianceDinnerCtrl:getMySocre()
	return self.msgData.selfInfo and self.msgData.selfInfo.point or 0
end
function allianceDinnerCtrl:getDinnerData(dinnerIndex)
	if not self.msgData.info or not self.msgData.info[tostring(dinnerIndex)] then
		_ENV = self.msgData.info[tostring(dinnerIndex)]
		self.msgData.info[tostring(dinnerIndex)].mergeCount = 0
		return self.msgData.info[tostring(dinnerIndex)]
	end
	return self.msgData.info[tostring(dinnerIndex)]
end
function allianceDinnerCtrl:getDinnerCfgs()
	local classType = self:getClassType()
	local dinnerCfgs = allianceDinnerRead.getDinnerCfg(classType)
	return dinnerCfgs
end
function allianceDinnerCtrl:getDinnerCfg(dinnerIndex)
	local classType = self:getClassType()
	local dinnerCfgs = allianceDinnerRead.getDinnerCfg(classType)
	return dinnerCfgs[dinnerIndex]
end
function allianceDinnerCtrl:getDinnerShowCfg()
