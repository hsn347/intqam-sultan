local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local iceDragonLostCtrl = class("iceDragonLostCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function iceDragonLostCtrl:ctor(properties)
	iceDragonLostCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.ICE_DRAGON_LOST
	self:resetData()
end
function iceDragonLostCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_ICE_DRAGON_LOST_MODULE, gCmd.REQ_ICE_DRAGON_LOST_INIT, handler(self, self.reqIceDragonLostInitRsp))
	msgCtrl.register(gCmd.CMD_ICE_DRAGON_LOST_MODULE, gCmd.REQ_ICE_DRAGON_LOST_SURVEY, handler(self, self.reqIceDragonLostSurveyRsp))
	msgCtrl.register(gCmd.CMD_ICE_DRAGON_LOST_MODULE, gCmd.REQ_ICE_DRAGON_LOST_GIVE_UP, handler(self, self.reqIceDragonLostGiveUpRsp))
	msgCtrl.register(gCmd.CMD_ICE_DRAGON_LOST_MODULE, gCmd.REQ_ICE_DRAGON_LOST_RECIEVE_QUEST, handler(self, self.reqIceDragonLostRecieveQuestRsp))
	msgCtrl.register(gCmd.CMD_ICE_DRAGON_LOST_MODULE, gCmd.REQ_ICE_DRAGON_LOST_RECIEVE_REWARD, handler(self, self.reqIceDragonLostRecieveRewardRsp))
	msgCtrl.register(gCmd.CMD_ICE_DRAGON_LOST_MODULE, gCmd.REQ_ICE_DRAGON_LOST_SEARCH, handler(self, self.reqIceDragonLostSearchRsp))
	msgCtrl.register(gCmd.CMD_ICE_DRAGON_LOST_MODULE, gCmd.REQ_ICE_DRAGON_LOST_SUMMON_BOSS, handler(self, self.reqIceDragonLostSummonBossRsp))
	msgCtrl.register(gCmd.CMD_ICE_DRAGON_LOST_MODULE, gCmd.REQ_ICE_DRAGON_LOST_CLEAR_NEW_NUM, handler(self, self.reqIceDragonLostClearNewNumRsp))
	self:registerNotify()
	self:reqIceDragonLostInit()
end
function iceDragonLostCtrl:Logout()
	iceDragonLostCtrl.super.Logout(self)
	self:resetData()
end
function iceDragonLostCtrl:resetData()
	self.questPool, _UPVALUE0_, self.questData, _UPVALUE0_, self.runningQuest, _UPVALUE0_, self.surveyedBuild, _UPVALUE0_, self.finshQuestNum = nil, nil, nil, nil, nil, nil, nil, nil, 0
	self.newSurveyNum = 0
	self.surveyedNum = 0
end
function iceDragonLostCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.ICE_DRAGON_LOST, handler(self, self.notifyHandler))
end
function iceDragonLostCtrl:notifyHandler(event)
	dump(event.data, "iceDragonLostCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		self.questData = v.data.questData
		self.finshQuestNum = v.data.finshQuestNum or 0
		if not v.data.surveyedBuild then
			_ENV = v.data.surveyedBuild
		end
		self.surveyedBuild = v.data.surveyedBuild
		if not v.data.runningQuest then
			_ENV = v.data.runningQuest
		end
		self.runningQuest = v.data.runningQuest
		self.newSurveyNum = v.data.newSurveyNum or 0
		_ENV = nil
		;(nil).msg = "MESSAGE_ICEDRAGON_LOST_REFRESH"
		SoraDSendMessage(nil)
		_ENV = nil
		;(nil).msg = "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK"
		;(nil).activityID = self.activityID
		SoraDSendMessage(nil)
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		;(nil).eventID = self.activityID
		SoraDSendMessage(nil)
		if v.type == "surveySuccess" then
			SoraDShowMsgTip(i18n("snowWolfLost_004"))
		end
	end
end
function iceDragonLostCtrl:reqIceDragonLostInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ICE_DRAGON_LOST_MODULE, gCmd.REQ_ICE_DRAGON_LOST_INIT, nil)
end
function iceDragonLostCtrl:reqIceDragonLostSurvey(data)
	serverproxy:Request(gCmd.CMD_ICE_DRAGON_LOST_MODULE, gCmd.REQ_ICE_DRAGON_LOST_SURVEY, data)
end
function iceDragonLostCtrl:reqIceDragonLostGiveUp(data)
