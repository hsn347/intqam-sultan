local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local legendOfPegasusCtrl = class("legendOfPegasusCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function legendOfPegasusCtrl:ctor(properties)
	legendOfPegasusCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.LEGEND_OF_PEGASUS_ACTIVITY
	self:resetData()
end
function legendOfPegasusCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_LEGEND_OF_PEGASUS_MODULE, gCmd.REQ_LEGEND_OF_PEGASUS_INIT, handler(self, self.reqLegendOfPegasusInitRsp))
	msgCtrl.register(gCmd.CMD_LEGEND_OF_PEGASUS_MODULE, gCmd.REQ_LEGEND_OF_PEGASUS_SURVEY, handler(self, self.reqLegendOfPegasusSurveyRsp))
	msgCtrl.register(gCmd.CMD_LEGEND_OF_PEGASUS_MODULE, gCmd.REQ_LEGEND_OF_PEGASUS_GIVE_UP, handler(self, self.reqLegendOfPegasusGiveUpRsp))
	msgCtrl.register(gCmd.CMD_LEGEND_OF_PEGASUS_MODULE, gCmd.REQ_LEGEND_OF_PEGASUS_RECIEVE_QUEST, handler(self, self.reqLegendOfPegasusRecieveQuestRsp))
	msgCtrl.register(gCmd.CMD_LEGEND_OF_PEGASUS_MODULE, gCmd.REQ_LEGEND_OF_PEGASUS_RECIEVE_REWARD, handler(self, self.reqLegendOfPegasusRecieveRewardRsp))
	msgCtrl.register(gCmd.CMD_LEGEND_OF_PEGASUS_MODULE, gCmd.REQ_LEGEND_OF_PEGASUS_SEARCH, handler(self, self.reqLegendOfPegasusSearchRsp))
	msgCtrl.register(gCmd.CMD_LEGEND_OF_PEGASUS_MODULE, gCmd.REQ_LEGEND_OF_PEGASUS_SUMMON_BOSS, handler(self, self.reqLegendOfPegasusSummonBossRsp))
	msgCtrl.register(gCmd.CMD_LEGEND_OF_PEGASUS_MODULE, gCmd.REQ_LEGEND_OF_PEGASUS_CLEAR_NEW_NUM, handler(self, self.reqLegendOfPegasusClearNewNumRsp))
	self:registerNotify()
	self:reqLegendOfPegasusInit()
end
function legendOfPegasusCtrl:Logout()
	legendOfPegasusCtrl.super.Logout(self)
	self:resetData()
end
function legendOfPegasusCtrl:resetData()
	self.questData, _UPVALUE0_, self.runningQuest, _UPVALUE0_, self.surveyedBuild, _UPVALUE0_, self.finshQuestNum = nil, nil, nil, nil, nil, nil, 0
	self.newSurveyNum = 0
	self.surveyedNum = 0
	self.sumPoints = 0
end
function legendOfPegasusCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.LEGEND_OF_PEGASUS, handler(self, self.notifyHandler))
end
function legendOfPegasusCtrl:notifyHandler(event)
	dump(event.data, "legendOfPegasusCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		self.questData = v.data.questData
		self.finshQuestNum = v.data.finshQuestNum or 0
		if not v.data.surveyedBuild then
			_ENV = v.data.surveyedBuild
		end
		self.surveyedBuild = v.data.surveyedBuild
		self.surveyedNum = v.data.surveyedNum or 0
		if not v.data.runningQuest then
			_ENV = v.data.runningQuest
		end
		self.runningQuest = v.data.runningQuest
		self.newSurveyNum = v.data.newSurveyNum or 0
		self.sumPoints = v.data.sumPoints or 0
		_ENV = nil
		;(nil).msg = "MESSAGE_LEGEND_OF_PEGASUS_REFRESH"
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
function legendOfPegasusCtrl:reqLegendOfPegasusInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_LEGEND_OF_PEGASUS_MODULE, gCmd.REQ_LEGEND_OF_PEGASUS_INIT, nil)
end
function legendOfPegasusCtrl:reqLegendOfPegasusSurvey(data)
	serverproxy:Request(gCmd.CMD_LEGEND_OF_PEGASUS_MODULE, gCmd.REQ_LEGEND_OF_PEGASUS_SURVEY, data)
end
function legendOfPegasusCtrl:reqLegendOfPegasusGiveUp(data)
