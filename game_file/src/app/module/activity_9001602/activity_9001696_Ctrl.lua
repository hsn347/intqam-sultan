local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001696_Ctrl = class("activity_9001696_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001696_Ctrl:ctor(properties)
	activity_9001696_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001696
	self:resetData()
end
function activity_9001696_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_FIREDRAGON_OF_ANGER_2025_MODULE, gCmd.REQ_FIREDRAGON_OF_ANGER_2025_INIT, handler(self, self.reqLegendOfPegasusInitRsp))
	msgCtrl.register(gCmd.CMD_FIREDRAGON_OF_ANGER_2025_MODULE, gCmd.REQ_FIREDRAGON_OF_ANGER_2025_SURVEY, handler(self, self.reqLegendOfPegasusSurveyRsp))
	msgCtrl.register(gCmd.CMD_FIREDRAGON_OF_ANGER_2025_MODULE, gCmd.REQ_FIREDRAGON_OF_ANGER_2025_GIVE_UP, handler(self, self.reqLegendOfPegasusGiveUpRsp))
	msgCtrl.register(gCmd.CMD_FIREDRAGON_OF_ANGER_2025_MODULE, gCmd.REQ_FIREDRAGON_OF_ANGER_2025_RECIEVE_QUEST, handler(self, self.reqLegendOfPegasusRecieveQuestRsp))
	msgCtrl.register(gCmd.CMD_FIREDRAGON_OF_ANGER_2025_MODULE, gCmd.REQ_FIREDRAGON_OF_ANGER_2025_RECIEVE_REWARD, handler(self, self.reqLegendOfPegasusRecieveRewardRsp))
	msgCtrl.register(gCmd.CMD_FIREDRAGON_OF_ANGER_2025_MODULE, gCmd.REQ_FIREDRAGON_OF_ANGER_2025_SEARCH, handler(self, self.reqLegendOfPegasusSearchRsp))
	msgCtrl.register(gCmd.CMD_FIREDRAGON_OF_ANGER_2025_MODULE, gCmd.REQ_FIREDRAGON_OF_ANGER_2025_SUMMON_BOSS, handler(self, self.reqLegendOfPegasusSummonBossRsp))
	msgCtrl.register(gCmd.CMD_FIREDRAGON_OF_ANGER_2025_MODULE, gCmd.REQ_FIREDRAGON_OF_ANGER_2025_CLEAR_NEW_NUM, handler(self, self.reqLegendOfPegasusClearNewNumRsp))
	self:registerNotify()
	self:reqLegendOfPegasusInit()
end
function activity_9001696_Ctrl:Logout()
	activity_9001696_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001696_Ctrl:resetData()
	self.questData, _UPVALUE0_, self.runningQuest, _UPVALUE0_, self.surveyedBuild, _UPVALUE0_, self.finshQuestNum = nil, nil, nil, nil, nil, nil, 0
	self.newSurveyNum = 0
	self.surveyedNum = 0
	self.sumPoints = 0
end
function activity_9001696_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.FIREDRAGON_OF_ANGER_2025, handler(self, self.notifyHandler))
end
function activity_9001696_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001696_Ctrl:notifyHandler", 10)
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
		;(nil).msg = "MESSAGE_FIREDRAGON_OF_ANGER_REFRESH"
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
function activity_9001696_Ctrl:reqLegendOfPegasusInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_FIREDRAGON_OF_ANGER_2025_MODULE, gCmd.REQ_FIREDRAGON_OF_ANGER_2025_INIT, nil)
end
function activity_9001696_Ctrl:reqLegendOfPegasusSurvey(data)
	serverproxy:Request(gCmd.CMD_FIREDRAGON_OF_ANGER_2025_MODULE, gCmd.REQ_FIREDRAGON_OF_ANGER_2025_SURVEY, data)
end
function activity_9001696_Ctrl:reqLegendOfPegasusGiveUp(data)
