local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local allianceEscortCtrl = class("allianceEscortCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function allianceEscortCtrl:ctor(properties)
	allianceEscortCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.ALLIANCE_ESCORT_ACTIVITY
	self:resetEscortData()
end
function allianceEscortCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_ALLIANDE_ESCORT_MODULE, gCmd.CMD_ALLIANDE_ESCORT_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_ALLIANDE_ESCORT_MODULE, gCmd.CMD_ALLIANDE_ESCORT_PREPARE, handler(self, self.reqPrepareRsp))
	msgCtrl.register(gCmd.CMD_ALLIANDE_ESCORT_MODULE, gCmd.CMD_ALLIANDE_SIGN_UP, handler(self, self.reqSignUpRsp))
	msgCtrl.register(gCmd.CMD_ALLIANDE_ESCORT_MODULE, gCmd.CMD_ALLIANDE_ESCORT_BATTLE_RECORD, handler(self, self.reqBattleRecordRsp))
	local allianceNotifyHandle = gametop.playertop_:getModule("allianceNotifyHandle")
	allianceNotifyHandle:addEventListener(gEventName.event_alliance_join_alliance_success, handler(self, self.allianceStateChange))
	allianceNotifyHandle:addEventListener(gEventName.event_alliance_agree_application_success, handler(self, self.allianceStateChange))
	allianceNotifyHandle:addEventListener(gEventName.event_alliance_agree_invitation_success, handler(self, self.allianceStateChange))
	allianceNotifyHandle:addEventListener(gEventName.event_alliance_quit_alliance_success, handler(self, self.allianceStateChange))
	allianceNotifyHandle:addEventListener(gEventName.event_alliance_expel_member_success, handler(self, self.allianceStateChange))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.newDay))
	self:reqInit()
end
function allianceEscortCtrl:Logout()
	allianceEscortCtrl.super.Logout(self)
	self:resetEscortData()
end
function allianceEscortCtrl:resetEscortData()
	self.signUpData, _UPVALUE0_, self.escortData, _UPVALUE0_ = nil, nil, nil, nil
	self.redPointType = 0
end
function allianceEscortCtrl:resetData()
	self.escortData, _UPVALUE0_ = nil, nil
	self:checkEscortRecordRed()
end
function allianceEscortCtrl:notifyEscortData(notifydata, notifyType)
	dump(notifydata, "==allianceEscortCtrl:notifyEscortData==")
	if not notifydata then
		notifydata, _ENV = dump, dump
	end
	notifydata.escortBattleRecord = self.escortData.escortBattleRecord
	self.escortData = notifydata
	_ENV = notifydata
	notifydata.msg = "MESSAGE_ALLIANCEESCORT_UPDATE"
	SoraDSendMessage(notifydata)
	if notifyType == "stateChange" then
		self:sendRefreshRedPointMessage()
	end
end
function allianceEscortCtrl:allianceStateChange(...)
	if clientEventMgr.judgeIsOpen(self.activityID) then
		self:reqInit()
	end
end
function allianceEscortCtrl:newDay(...)
	if clientEventMgr.judgeIsOpen(self.activityID) and self.redPointType == 0 then
		self:sendRefreshRedPointMessage()
	end
end
function allianceEscortCtrl:reqInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ALLIANDE_ESCORT_MODULE, gCmd.CMD_ALLIANDE_ESCORT_INIT, nil)
end
function allianceEscortCtrl:reqPrepare(difficulty)
	serverproxy = nil
	;(nil).difficulty = difficulty
	serverproxy:Request(gCmd.CMD_ALLIANDE_ESCORT_MODULE, gCmd.CMD_ALLIANDE_ESCORT_PREPARE, nil)
end
function allianceEscortCtrl:reqSignUp(heroList, armsInfo, divineBeastInfo)
	local selfUid = gametop.playertop_:getPlayerID()
	local hasSignUp = self.escortData.signUpUserList and self.escortData.signUpUserList[tostring(selfUid)]
	gametop = nil
	;(nil).heroList = heroList
	;(nil).armsInfo = armsInfo
	gametop, (nil).divineBeastInfo = nil, divineBeastInfo
	;(nil).hasSignUp = hasSignUp
	serverproxy:Request(gCmd.CMD_ALLIANDE_ESCORT_MODULE, gCmd.CMD_ALLIANDE_SIGN_UP, nil, nil)
end
function allianceEscortCtrl:reqBattleRecord()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ALLIANDE_ESCORT_MODULE, gCmd.CMD_ALLIANDE_ESCORT_BATTLE_RECORD, nil)
end
function allianceEscortCtrl:sendReqInitDataMsg(...)
	self:reqInit(...)
end
function allianceEscortCtrl:reqInitRsp(content)
	dump(content, "allianceEscortCtrl:reqInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local rspdata = content.rspdata
		if not rspdata.allianceEscortData then
			_ENV = rspdata.allianceEscortData
		end
		_ENV, self.escortData = rspdata.allianceEscortData, rspdata.allianceEscortData
		if not rspdata.heroList then
			_ENV = rspdata.heroList
		end
		rspdata.allianceEscortData.heroList = rspdata.heroList
		if not rspdata.armsInfo then
			_ENV = rspdata.armsInfo
		end
		rspdata.allianceEscortData.armsList = rspdata.armsInfo
		if not rspdata.divineBeastInfo then
			_ENV = rspdata.divineBeastInfo
		end
		self.signUpData, rspdata.allianceEscortData.divineBeastList = rspdata.allianceEscortData, rspdata.divineBeastInfo
		_ENV = rspdata.divineBeastInfo
		rspdata.divineBeastInfo.msg = "MESSAGE_ALLIANCEESCORT_UPDATE"
		SoraDSendMessage(rspdata.divineBeastInfo)
	end
end
function allianceEscortCtrl:reqPrepareRsp(content)
	dump(content, "allianceEscortCtrl:reqPrepareRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("treasureEscort_text52"))
	else
		SoraDShowMsgTip(i18n("notice_0026"))
	end
end
function allianceEscortCtrl:reqSignUpRsp(content)
	dump(content, "allianceEscortCtrl:reqSignUpRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		if content.clientData and content.clientData.hasSignUp then
			SoraDShowMsgTip(i18n("treasureEscort_text54"))
		else
			SoraDShowMsgTip(i18n("treasureEscort_text53"))
			if self.redPointType == 1 then
				self:sendRefreshRedPointMessage()
			end
		end
		_ENV = self.sendRefreshRedPointMessage
		if not content.data.heroList then
			_ENV = content.data.heroList
		end
		self.sendRefreshRedPointMessage.heroList = content.data.heroList
		if not content.data.armsInfo then
			_ENV = content.data.armsInfo
		end
		self.sendRefreshRedPointMessage.armsList = content.data.armsInfo
		if not content.data.divineBeastInfo then
			_ENV = content.data.divineBeastInfo
		end
		self.signUpData, self.sendRefreshRedPointMessage.divineBeastList = self.sendRefreshRedPointMessage, content.data.divineBeastInfo
	else
		SoraDShowMsgTip(i18n("notice_0026"))
	end
end
function allianceEscortCtrl:reqBattleRecordRsp(content)
	dump(content, "allianceEscortCtrl:reqBattleRecordRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.escortData.escortBattleRecord = content.rspdata
	end
end
function allianceEscortCtrl:getEscortData(...)
	if not self.escortData then
		_UPVALUE0_ = self.escortData
	end
	return self.escortData
end
function allianceEscortCtrl:getSignUpData(...)
	if not self.signUpData then
		_UPVALUE0_ = self.signUpData
	end
	return self.signUpData
end
_UPVALUE6_, allianceEscortCtrl.getEscortTimes = function(self, ...)
	if not SoraDGetCtrl("allianceMgr"):hasJoinAlliance() then
		return 0
	end
	local escortData = self:getEscortData()
	if not next(escortData) then
		return 0
	end
	if escortData.escortTimesResetTime ~= 0 and not serviceFunctions.isSameDay(escortData.escortTimesResetTime) then
		escortData.escortTimes = 0
	end
	local constantRead = include("constantRead")
	local value = constantRead.getConstValue("TreasureEscort_Proceed_Num", 1)
	return math.max(0, value - escortData.escortTimes)
end, function(self, ...)
	if not SoraDGetCtrl("allianceMgr"):hasJoinAlliance() then
		return 0
	end
	local escortData = self:getEscortData()
	if not next(escortData) then
		return 0
	end
	if escortData.escortTimesResetTime ~= 0 and not serviceFunctions.isSameDay(escortData.escortTimesResetTime) then
		escortData.escortTimes = 0
	end
	local constantRead = include("constantRead")
	local value = constantRead.getConstValue("TreasureEscort_Proceed_Num", 1)
	return math.max(0, value - escortData.escortTimes)
end
;(function(self, ...)
	if not SoraDGetCtrl("allianceMgr"):hasJoinAlliance() then
		return 0
	end
	local escortData = self:getEscortData()
	if not next(escortData) then
		return 0
	end
	if escortData.escortTimesResetTime ~= 0 and not serviceFunctions.isSameDay(escortData.escortTimesResetTime) then
		escortData.escortTimes = 0
	end
	local constantRead = include("constantRead")
	local value = constantRead.getConstValue("TreasureEscort_Proceed_Num", 1)
	return math.max(0, value - escortData.escortTimes)
end)[1] = "treasureEscort_text45"
;(function(self, ...)
	if not SoraDGetCtrl("allianceMgr"):hasJoinAlliance() then
		return 0
	end
	local escortData = self:getEscortData()
	if not next(escortData) then
		return 0
	end
	if escortData.escortTimesResetTime ~= 0 and not serviceFunctions.isSameDay(escortData.escortTimesResetTime) then
		escortData.escortTimes = 0
	end
	local constantRead = include("constantRead")
	local value = constantRead.getConstValue("TreasureEscort_Proceed_Num", 1)
	return math.max(0, value - escortData.escortTimes)
end)[2] = "devilvalley_btn_04"
;(function(self, ...)
	if not SoraDGetCtrl("allianceMgr"):hasJoinAlliance() then
		return 0
	end
	local escortData = self:getEscortData()
	if not next(escortData) then
		return 0
	end
	if escortData.escortTimesResetTime ~= 0 and not serviceFunctions.isSameDay(escortData.escortTimesResetTime) then
		escortData.escortTimes = 0
	end
	local constantRead = include("constantRead")
	local value = constantRead.getConstValue("TreasureEscort_Proceed_Num", 1)
	return math.max(0, value - escortData.escortTimes)
end)[3] = "common_text_2697"
;(function(self, ...)
	if not SoraDGetCtrl("allianceMgr"):hasJoinAlliance() then
		return 0
	end
	local escortData = self:getEscortData()
	if not next(escortData) then
		return 0
	end
	if escortData.escortTimesResetTime ~= 0 and not serviceFunctions.isSameDay(escortData.escortTimesResetTime) then
		escortData.escortTimes = 0
	end
	local constantRead = include("constantRead")
	local value = constantRead.getConstValue("TreasureEscort_Proceed_Num", 1)
	return math.max(0, value - escortData.escortTimes)
end)[4] = "devilvalley_btn_06"
;(function(self, ...)
	if not SoraDGetCtrl("allianceMgr"):hasJoinAlliance() then
		return 0
	end
	local escortData = self:getEscortData()
	if not next(escortData) then
		return 0
	end
	if escortData.escortTimesResetTime ~= 0 and not serviceFunctions.isSameDay(escortData.escortTimesResetTime) then
		escortData.escortTimes = 0
	end
	local constantRead = include("constantRead")
	local value = constantRead.getConstValue("TreasureEscort_Proceed_Num", 1)
	return math.max(0, value - escortData.escortTimes)
end)[5] = "devilvalley_btn_07"
local (function(self, ...)
	if not SoraDGetCtrl("allianceMgr"):hasJoinAlliance() then
		return 0
	end
	local escortData = self:getEscortData()
	if not next(escortData) then
		return 0
	end
	if escortData.escortTimesResetTime ~= 0 and not serviceFunctions.isSameDay(escortData.escortTimesResetTime) then
		escortData.escortTimes = 0
	end
	local constantRead = include("constantRead")
	local value = constantRead.getConstValue("TreasureEscort_Proceed_Num", 1)
	return math.max(0, value - escortData.escortTimes)
end)[6], config = "devilvalley_btn_08", function(self, ...)
	if not SoraDGetCtrl("allianceMgr"):hasJoinAlliance() then
		return 0
	end
	local escortData = self:getEscortData()
	if not next(escortData) then
		return 0
	end
	if escortData.escortTimesResetTime ~= 0 and not serviceFunctions.isSameDay(escortData.escortTimesResetTime) then
		escortData.escortTimes = 0
	end
	local constantRead = include("constantRead")
	local value = constantRead.getConstValue("TreasureEscort_Proceed_Num", 1)
	return math.max(0, value - escortData.escortTimes)
end
function allianceEscortCtrl:getDifficultyName(difficulty)
	return config[difficulty] and i18n(config[difficulty]) or ""
end
function allianceEscortCtrl:getDifficultyCount(...)
	return #config
end
function allianceEscortCtrl:getWarPlaceName(warPlace)
	_UPVALUE7_ = nil
	;(nil)[1] = "buildDes_name_202"
	;(nil)[2] = "alliance_stronghold_text_061"
	;(nil)[3] = "buildDes_name_201"
	;(nil)[4] = "alliance_stronghold_text_060"
	;(nil)[5] = "buildDes_name_203"
	;(nil)[6] = "alliance_stronghold_text_062"
	local (nil)[7], config = "treasureEscort_text48", nil
	config[0] = "alliance_stronghold_text_100"
	return config[warPlace] and i18n(config[warPlace]) or ""
end
function allianceEscortCtrl:getEscortReward(difficulty, rtype)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local grade = activityShowCtrl:getParamClassType(self.activityID)
	local treasureescortrankreward = require_data("treasureescortrankreward", true).data
	for i, v in ipairs(treasureescortrankreward) do
		if grade == v.grade and difficulty == v.difficulty and rtype == v.type then
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			return serviceFunctions.tableFormat(v.reward, nil)
		end
	end
end
function allianceEscortCtrl:getEscortRewardList()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local grade = activityShowCtrl:getParamClassType(self.activityID)
	local treasureescortrankreward = require_data("treasureescortrankreward", true).data
	local _ENV, ret = "treasureescortrankreward", "treasureescortrankreward"
	for i, v in ipairs(treasureescortrankreward) do
		local rtype = v.type
		if not ret[rtype] then
			_ENV = ret[rtype]
		end
		ret[rtype] = ret[rtype]
		if grade == v.grade then
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			ret[rtype][v.difficulty] = serviceFunctions.tableFormat(v.reward, nil)
		end
	end
	return ret
end
function allianceEscortCtrl:getNpcId(difficulty, warPlace)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local grade = activityShowCtrl:getParamClassType(self.activityID)
	local treasureescortdifficulty = require_data("treasureescortdifficulty", true).data
	for i, v in ipairs(treasureescortdifficulty) do
		if grade == v.grade and difficulty == v.difficulty and warPlace == v.warPlace then
			return v.parameter[1]
		end
	end
	return 3143
end
function allianceEscortCtrl:getReceiveStatusAndNum(...)
	self.redPointType = 0
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	if not allianceMgr:hasJoinAlliance() then
		return false, 0
	end
	if self.escortData.state == gAllianceEscortState.PREPARE then
		local selfUid = gametop.playertop_:getPlayerID()
		if not self.escortData.signUpUserList[tostring(selfUid)] then
			self.redPointType = 1
			return true, -1
		end
	end
	_ENV = selfUid
	gametop.playertop_:getPlayerID()[gAllianceEscortState.NONE] = true
	local gametop.playertop_:getPlayerID()[gAllianceEscortState.FINISH], config = true, gametop.playertop_:getPlayerID()
	if config[self.escortData.state] and 0 < self:getEscortTimes() then
		local allianceDesRead = include("allianceDesRead")
		if allianceDesRead.checkRank(gAllianceRank.R4) then
			self.redPointType = 2
			return true, -1
		end
	end
	if self:checkEscortRecordRed() then
		self.redPointType = 3
		return true, -1
	end
	return false, 0
end
function allianceEscortCtrl:checkOpenTime(...)
	local curTime = serviceFunctions.systemTime()
	local zeroHourUTC = serviceFunctions.getTodayZeroHourUTC()
	local constantRead = include("constantRead")
	local openTime = constantRead.getConstValue("TreasureEscort_Start_Time", 0)
	if curTime > zeroHourUTC + openTime then
		SoraDShowMsgTip(i18n("treasureEscort_text50"))
		return
	end
	return true
end
function allianceEscortCtrl:checkEscortRecordRed(...)
	local count = 0
	local dailyRemindManager = include("dailyRemindManager")
	local rType = dailyRemindManager.REMIND_TYPE.allianceEscortRecord
	if dailyRemindManager.checkNeedRemindOnce(rType, self.activityID) then
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:allianceEscortRecord:count~integer", 0, nil)
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local openCount = activityShowCtrl:getOpenCount(self.activityID)
		dailyRemindManager.addRemindToManager(rType, openCount)
	else
		_ENV = dailyRemindManager.addRemindToManager
		dailyRemindManager.addRemindToManager.byUID = true
		count = SoraDConfigGet("Game:allianceEscortRecord:count~integer", dailyRemindManager.addRemindToManager) or 0
	end
	if not self.escortData.escortRecord then
		local _ENV, escortRecord = self.escortData.escortRecord, self.escortData.escortRecord
	end
	return count < #escortRecord
end
function allianceEscortCtrl:sendRefreshRedPointMessage(...)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	;(nil).eventID = self.activityID
	SoraDSendMessage(nil)
end
return allianceEscortCtrl
