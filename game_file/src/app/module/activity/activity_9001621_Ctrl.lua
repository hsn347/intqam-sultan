local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001621_Ctrl = class("activity_9001621_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local activity_9001621_Read = include("activity_9001621_Read")
function activity_9001621_Ctrl:ctor(properties)
	activity_9001621_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.HONOR_BACK_ARMY_SUBSIDY
	self:resetData()
end
function activity_9001621_Ctrl:EnterGame()
	print("==activity_9001621_Ctrl:EnterGame==")
	msgCtrl.register(gCmd.CMD_HONOR_BACK_ARMY_SUBSIDY_MODULE, gCmd.REQ_HONOR_BACK_ARMY_SUBSIDY_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_HONOR_BACK_ARMY_SUBSIDY_MODULE, gCmd.REQ_HONOR_BACK_ARMY_SUBSIDY_TRAIN, handler(self, self.reqTrainArmyRsp))
	msgCtrl.register(gCmd.CMD_HONOR_BACK_ARMY_SUBSIDY_MODULE, gCmd.REQ_HONOR_BACK_ARMY_SUBSIDY_GET, handler(self, self.reqGetArmyRsp))
	self:registerNotify()
end
function activity_9001621_Ctrl:Logout()
	activity_9001621_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001621_Ctrl:resetData()
	self.msgData, _UPVALUE0_ = nil, nil
end
function activity_9001621_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.HONOR_BACK_ARMY_SUBSIDY, handler(self, self.notifyHandler))
end
function activity_9001621_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001604_Ctrl:notifyHandler", 10)
	for _, content in pairs(event.data) do
		self.msgData = content
		_ENV = nil
		;(nil).msg = "MESSAGE_ACTIVITY_9001621_UPDATE"
		SoraDSendMessage(nil)
	end
end
function activity_9001621_Ctrl:sendReqInitDataMsg()
	print("activity_9001621_Ctrl:sendReqInitDataMsg")
	_ENV = nil
	serverproxy:Request(gCmd.CMD_HONOR_BACK_ARMY_SUBSIDY_MODULE, gCmd.REQ_HONOR_BACK_ARMY_SUBSIDY_INIT, nil)
end
function activity_9001621_Ctrl:reqInitRsp(content)
	dump(content, "activity_9001621_Ctrl:reqInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.msgData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001621_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001608_UPDATE_RED"
		gErrDef.Err_None.activityID = self.activityID
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001621_Ctrl:reqTrainArmy(bid)
	serverproxy = nil
	;(nil).bid = bid
	serverproxy:Request(gCmd.CMD_HONOR_BACK_ARMY_SUBSIDY_MODULE, gCmd.REQ_HONOR_BACK_ARMY_SUBSIDY_TRAIN, nil)
end
function activity_9001621_Ctrl:reqTrainArmyRsp(content)
	dump(content, "activity_9001621_Ctrl:reqTrainArmyRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.msgData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001621_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001608_UPDATE_RED"
		gErrDef.Err_None.activityID = self.activityID
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001621_Ctrl:reqGetArmy()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_HONOR_BACK_ARMY_SUBSIDY_MODULE, gCmd.REQ_HONOR_BACK_ARMY_SUBSIDY_GET, nil)
end
function activity_9001621_Ctrl:reqGetArmyRsp(content)
	dump(content, "activity_9001621_Ctrl:reqGetArmyRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.msgData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001621_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
		SoraDShowMsgTip(i18n("Army_subtidy_text_04"))
		_ENV = i18n("Army_subtidy_text_04")
		i18n("Army_subtidy_text_04").msg = "MESSAGE_ACTIVITY_9001608_UPDATE_RED"
		i18n("Army_subtidy_text_04").activityID = self.activityID
		SoraDSendMessage(i18n("Army_subtidy_text_04"))
	end
end
function activity_9001621_Ctrl:getBackDay()
	if self.msgData.loginDays == nil then
		return 0
	end
	return self.msgData.loginDays
end
function activity_9001621_Ctrl:getBuildArmyData()
	if not self.msgData.buildArmy then
		_UPVALUE0_ = self.msgData.buildArmy
	end
	return self.msgData.buildArmy
end
function activity_9001621_Ctrl:getTrainLastTime()
	if self.msgData.trainBeginTime and self.msgData.trainBeginTime ~= 0 then
		return self.msgData.trainBeginTime + self.msgData.trainNeedTime - serviceFunctions.systemTime()
	else
		return 0
	end
end
function activity_9001621_Ctrl:getTrainTimes()
	return self.msgData.trainTimes or 0
end
function activity_9001621_Ctrl:getTrainArmyId()
	return self.msgData.trainArmyId or 0
end
function activity_9001621_Ctrl:getReceiveStatusAndNum()
	local trainTimes = self:getTrainTimes()
	local tranLastTime = self:getTrainLastTime()
	local armyCfg = activity_9001621_Read.getArmyCfg(self:getBackDay())
	if tranLastTime <= 0 and armyCfg and 0 < #armyCfg.trainNum - trainTimes then
		return true
	end
	local trainArmyId = self:getTrainArmyId()
	if tranLastTime <= 0 and trainArmyId ~= 0 then
		return true
	end
	return false
end
return activity_9001621_Ctrl
