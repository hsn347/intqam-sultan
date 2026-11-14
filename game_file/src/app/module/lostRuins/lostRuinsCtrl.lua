local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local lostRuinsCtrl = class("lostRuinsCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function lostRuinsCtrl:ctor(properties)
	lostRuinsCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.LOST_RUINS_ACTIVITY
	self:resetData()
end
function lostRuinsCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_LOST_RUINS_MODULE, gCmd.REQ_LOST_RUINS_INIT, handler(self, self.reqLostRuinsInitRsp))
	msgCtrl.register(gCmd.CMD_LOST_RUINS_MODULE, gCmd.REQ_LOST_RUINS_SURVEY, handler(self, self.reqLostRuinsSurveyRsp))
	msgCtrl.register(gCmd.CMD_LOST_RUINS_MODULE, gCmd.REQ_LOST_RUINS_GIVE_UP, handler(self, self.reqLostRuinsGiveUpRsp))
	msgCtrl.register(gCmd.CMD_LOST_RUINS_MODULE, gCmd.REQ_LOST_RUINS_RECIEVE_QUEST, handler(self, self.reqLostRuinsRecieveQuestRsp))
	msgCtrl.register(gCmd.CMD_LOST_RUINS_MODULE, gCmd.REQ_LOST_RUINS_RECIEVE_REWARD, handler(self, self.reqLostRuinsRecieveRewardRsp))
	msgCtrl.register(gCmd.CMD_LOST_RUINS_MODULE, gCmd.REQ_LOST_RUINS_SEARCH, handler(self, self.reqLostRuinsSearchRsp))
	msgCtrl.register(gCmd.CMD_LOST_RUINS_MODULE, gCmd.REQ_LOST_RUINS_SUMMON_BOSS, handler(self, self.reqLostRuinsSummonBossRsp))
	msgCtrl.register(gCmd.CMD_LOST_RUINS_MODULE, gCmd.REQ_LOST_RUINS_CLEAR_NEW_NUM, handler(self, self.reqLostRuinsClearNewNumRsp))
	self:registerNotify()
	self:reqLostRuinsInit()
end
function lostRuinsCtrl:Logout()
	lostRuinsCtrl.super.Logout(self)
	self:resetData()
end
function lostRuinsCtrl:resetData()
	self.questData, _UPVALUE0_, self.runningQuest, _UPVALUE0_, self.surveyedRuins, _UPVALUE0_, self.finshQuestNum = nil, nil, nil, nil, nil, nil, 0
	self.newSurveyNum = 0
	self.surveyedNum = 0
end
function lostRuinsCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.LOST_RUINS, handler(self, self.notifyHandler))
end
function lostRuinsCtrl:notifyHandler(event)
	dump(event.data, "lostRuinsCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		self.questData = v.data.questData
		self.finshQuestNum = v.data.finshQuestNum or 0
		if not v.data.surveyedRuins then
			_ENV = v.data.surveyedRuins
		end
		self.surveyedRuins = v.data.surveyedRuins
		if not v.data.runningQuest then
			_ENV = v.data.runningQuest
		end
		self.runningQuest = v.data.runningQuest
		self.newSurveyNum = v.data.newSurveyNum or 0
		_ENV = nil
		;(nil).msg = "MESSAGE_LOST_RUINS_REFRESH"
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
			SoraDShowMsgTip(i18n("lost_ruins_text_28"))
		end
	end
end
function lostRuinsCtrl:reqLostRuinsInit()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_LOST_RUINS_MODULE, gCmd.REQ_LOST_RUINS_INIT, nil)
end
function lostRuinsCtrl:reqLostRuinsSurvey(data)
	serverproxy:Request(gCmd.CMD_LOST_RUINS_MODULE, gCmd.REQ_LOST_RUINS_SURVEY, data)
end
function lostRuinsCtrl:reqLostRuinsGiveUp(data)
