local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001625_Ctrl = class("activity_9001625_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001625_Ctrl:ctor(properties)
	activity_9001625_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.GATHERING_FEAST_2024
	self:resetData()
end
function activity_9001625_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_GATHERING_FEAST_2024_MODULE, gCmd.REQ_GATHERING_FEAST_2024_DATA, handler(self, self.reqDataRsp))
	msgCtrl.register(gCmd.CMD_GATHERING_FEAST_2024_MODULE, gCmd.REQ_GATHERING_FEAST_2024_PLACE_FEAST, handler(self, self.reqPlaceFeastRsp))
	self:registerNotify()
end
function activity_9001625_Ctrl:Logout()
	activity_9001625_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001625_Ctrl:resetData()
	_UPVALUE0_, _UPVALUE0_ = nil, nil
	;(nil).opencount = 0
	_UPVALUE0_, (nil).data, (nil).feasts, _UPVALUE0_, (nil).classtype = nil, nil, nil, nil, 1
	;(nil).score = 0
	self.initData, (nil).allianceData, (nil).feasts, _UPVALUE0_, (nil).scoreTime = nil, nil, nil, nil, 0
end
function activity_9001625_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.GATHERING_FEAST_2024, handler(self, self.notifyHandler))
end
function activity_9001625_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001625_Ctrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		self.initData.data = v
		_ENV = nil
		;(nil).msg = "MESSAGE_ACTIVITY_9001625_UPDATE"
		;(nil).subMsg = "feasts"
		SoraDSendMessage(nil)
	end
end
function activity_9001625_Ctrl:sendReqInitDataMsg(...)
	self:reqData()
end
function activity_9001625_Ctrl:reqData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_GATHERING_FEAST_2024_MODULE, gCmd.REQ_GATHERING_FEAST_2024_DATA, nil)
end
function activity_9001625_Ctrl:reqDataRsp(content)
	dump(content, "activity_9001625_Ctrl:reqDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001625_UPDATE"
		gErrDef.Err_None.subMsg = "init"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001625_Ctrl:reqPlaceFeast(feastId, x, y)
	serverproxy = nil
	;(nil).feastId = feastId
	;(nil).x = x
	;(nil).y = y
	serverproxy:Request(gCmd.CMD_GATHERING_FEAST_2024_MODULE, gCmd.REQ_GATHERING_FEAST_2024_PLACE_FEAST, nil)
end
function activity_9001625_Ctrl:reqPlaceFeastRsp(content)
	dump(content, "activity_9001625_Ctrl:reqPlaceFeastRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData.allianceData = content.rspdata
	elseif content.err == gErrDef.Err_GATHERING_FEAST_2024_PLACE_EXIST then
		SoraDShowMsgTip(i18n("tips_place_feast_num_limit"))
	elseif content.err == gErrDef.Err_GATHERING_FEAST_2024_PLACE_EXIST_OTHER then
		SoraDShowMsgTip(i18n("tips_place_feast_num_limit"))
	end
end
function activity_9001625_Ctrl:getAllianceData(...)
	if not self.initData.allianceData then
		_UPVALUE0_ = self.initData.allianceData
	end
	return self.initData.allianceData
end
function activity_9001625_Ctrl:getAllianceScore(...)
	local allianceData = self:getAllianceData()
	return allianceData.score or 0
end
function activity_9001625_Ctrl:getAllianceFeasts(...)
	local allianceData = self:getAllianceData()
	if not allianceData.feasts then
		_UPVALUE0_ = allianceData.feasts
	end
	return allianceData.feasts
end
function activity_9001625_Ctrl:getSelfData(...)
	if not self.initData.data then
		_UPVALUE0_ = self.initData.data
	end
	return self.initData.data
end
function activity_9001625_Ctrl:getSelfDataFeasts(feastId)
	local selfData = self:getSelfData()
	if not selfData.feasts then
		local _ENV, feasts = selfData.feasts, selfData.feasts
	end
	if feastId then
		return feasts[tostring(feastId)]
	end
end
function activity_9001625_Ctrl:getRemainTime(feast)
	if not feast then
		return 0
	end
	local lastTime = self:getFeastLastTime()
	local remainTime = feast.createTime + lastTime - serviceFunctions.systemTime()
	return remainTime
end
function activity_9001625_Ctrl:getFeastLastTime(...)
	local constantRead = include("constantRead")
	return constantRead.getConstValue("GATHERING_ACTIVITY_FEAST_DURATION", 12) * 3600
end
function activity_9001625_Ctrl:getFeastAwardTime(...)
	local constantRead = include("constantRead")
	return constantRead.getConstValue("GATHERING_ACTIVITY_FEAST_AWARD_TIME", 5) * 60
end
function activity_9001625_Ctrl:checkCanPlaceFeast(...)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDShowMsgTip(i18n("gathering_activity_text6"))
		return
	end
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local remainTime = activityShowCtrl:getRemainTime(self.activityID)
	local awardTime = self:getFeastAwardTime()
	if remainTime < awardTime then
		SoraDShowMsgTip(i18n("tips_place_ActivityTime_noEnough"))
		return
	end
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	if not allianceMgr:hasJoinAlliance() then
		SoraDShowMsgTip(i18n("tips_place_noUnion"))
		return
	end
	local allianceDesRead = include("allianceDesRead")
	if not allianceDesRead.checkRank(gAllianceRank.R4) then
		SoraDShowMsgTip(i18n("tips_place_feast_right_limit"))
		return
	end
	if worldMapDefine.inInCrossWar() then
		SoraDShowMsgTip(i18n("tips_feast_across_limit"))
		return
	end
	return true
end
return activity_9001625_Ctrl
