local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local snowWolfLostCtrl = class("snowWolfLostCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function snowWolfLostCtrl:ctor(properties)
	snowWolfLostCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.SNOWWOLF_LOST_ACTIVITY
	self:resetData()
end
function snowWolfLostCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_SNOWWOLF_LOST_MODULE, gCmd.REQ_SNOWWOLF_LOST_INIT, handler(self, self.reqSnowWolfLostInitRsp))
	msgCtrl.register(gCmd.CMD_SNOWWOLF_LOST_MODULE, gCmd.REQ_SNOWWOLF_LOST_SURVEY, handler(self, self.reqSnowWolfLostSurveyRsp))
	msgCtrl.register(gCmd.CMD_SNOWWOLF_LOST_MODULE, gCmd.REQ_SNOWWOLF_LOST_GIVE_UP, handler(self, self.reqSnowWolfLostGiveUpRsp))
	msgCtrl.register(gCmd.CMD_SNOWWOLF_LOST_MODULE, gCmd.REQ_SNOWWOLF_LOST_RECIEVE_QUEST, handler(self, self.reqSnowWolfLostRecieveQuestRsp))
	msgCtrl.register(gCmd.CMD_SNOWWOLF_LOST_MODULE, gCmd.REQ_SNOWWOLF_LOST_RECIEVE_REWARD, handler(self, self.reqSnowWolfLostRecieveRewardRsp))
	msgCtrl.register(gCmd.CMD_SNOWWOLF_LOST_MODULE, gCmd.REQ_SNOWWOLF_LOST_SEARCH, handler(self, self.reqSnowWolfLostSearchRsp))
	msgCtrl.register(gCmd.CMD_SNOWWOLF_LOST_MODULE, gCmd.REQ_SNOWWOLF_LOST_SUMMON_BOSS, handler(self, self.reqSnowWolfLostSummonBossRsp))
	msgCtrl.register(gCmd.CMD_SNOWWOLF_LOST_MODULE, gCmd.REQ_SNOWWOLF_LOST_CLEAR_NEW_NUM, handler(self, self.reqSnowWolfLostClearNewNumRsp))
	self:registerNotify()
	self:reqSnowWolfLostInit()
end
function snowWolfLostCtrl:Logout()
	snowWolfLostCtrl.super.Logout(self)
	self:resetData()
end
function snowWolfLostCtrl:resetData()
	self.questData, _UPVALUE0_, self.runningQuest, _UPVALUE0_, self.surveyedBuild, _UPVALUE0_, self.finshQuestNum = nil, nil, nil, nil, nil, nil, 0
	self.newSurveyNum = 0
	self.surveyedNum = 0
end
function snowWolfLostCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.SNOWWOLF_LOST, handler(self, self.notifyHandler))
end
function snowWolfLostCtrl:notifyHandler(event)
	dump(event.data, "snowWolfLostCtrl:notifyHandler", 10)
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
		;(nil).msg = "MESSAGE_SNOWWOLF_LOST_REFRESH"
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
			SoraDShowMsgTip(i18n("snowWolfLost_023"))
		end
	end
end
function snowWolfLostCtrl:reqSnowWolfLostInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_SNOWWOLF_LOST_MODULE, gCmd.REQ_SNOWWOLF_LOST_INIT, nil)
end
function snowWolfLostCtrl:reqSnowWolfLostSurvey(data)
	serverproxy:Request(gCmd.CMD_SNOWWOLF_LOST_MODULE, gCmd.REQ_SNOWWOLF_LOST_SURVEY, data)
end
function snowWolfLostCtrl:reqSnowWolfLostGiveUp(data)
