local wiseTutorRead = include("wiseTutorRead")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001604_Ctrl = class("activity_9001604_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
_ENV = "msgCtrl"
;("msgCtrl").NORMAL = 0
;("msgCtrl").REFRESH = 1
activity_9001604_Ctrl.RAMADAN_MOBILIZE_TASK_STATE, ("msgCtrl").ACCEPT = "msgCtrl", 2
function activity_9001604_Ctrl:ctor(properties)
	activity_9001604_Ctrl.super.ctor(self, properties)
	self:resetData()
	self.activityID = gActivityTimeActivityID.FESTIVAL_ACTIVITY_9001604
	local constantRead = include("constantRead")
	self.questLimit = constantRead.getConstValue("RAMADAN_MOBILIZE_TASK_LIMIT", 8)
end
function activity_9001604_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_RAMADAN_MOBILIZE_MODULE, gCmd.REQ_RAMADAN_MOBILIZE_DATA, handler(self, self.reqInitDataRsp))
	msgCtrl.register(gCmd.CMD_RAMADAN_MOBILIZE_MODULE, gCmd.REQ_RAMADAN_MOBILIZE_REFRESH_TASK, handler(self, self.reqRefreshRsp))
	msgCtrl.register(gCmd.CMD_RAMADAN_MOBILIZE_MODULE, gCmd.REQ_RAMADAN_MOBILIZE_ACCEPT_TASK, handler(self, self.reqAcceptRsp))
	msgCtrl.register(gCmd.CMD_RAMADAN_MOBILIZE_MODULE, gCmd.REQ_RAMADAN_MOBILIZE_COMMIT_TASK, handler(self, self.reqCommitRsp))
	msgCtrl.register(gCmd.CMD_RAMADAN_MOBILIZE_MODULE, gCmd.REQ_RAMADAN_MOBILIZE_ABORT_TASK, handler(self, self.reqAbortRsp))
	msgCtrl.register(gCmd.CMD_RAMADAN_MOBILIZE_MODULE, gCmd.REQ_RAMADAN_MOBILIZE_ALLIANCE_RANK, handler(self, self.reqAllianceRankRsp))
	msgCtrl.register(gCmd.CMD_RAMADAN_MOBILIZE_MODULE, gCmd.REQ_RAMADAN_MOBILIZE_MEMBER_RANK, handler(self, self.reqMemberRankRsp))
	self:registerNotify()
end
function activity_9001604_Ctrl:Logout()
	activity_9001604_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001604_Ctrl:resetData()
	self.allianceData, _UPVALUE0_, self.selfData, _UPVALUE0_ = nil, nil, nil, nil
	self.allianceData.tasks, _UPVALUE0_ = nil, nil
	self.questComponent = nil
end
function activity_9001604_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.RAMADAN_MOBILIZE, handler(self, self.notifyHandler))
end
function activity_9001604_Ctrl:notifyHandler(event)
	dump(event.data, "activity_9001604_Ctrl:notifyHandler", 10)
	for _, content in pairs(event.data) do
		if content.data then
			self:updateSelfData(content.data)
		elseif content.taskIdx then
			local taskIdx = content.taskIdx
			self.allianceData.tasks[taskIdx] = content.task
			_ENV = content.task
			content.task.msg = "MESSAGE_ACTIVITY_9001604_UPDATE"
			SoraDSendMessage(content.task)
		end
	end
end
function activity_9001604_Ctrl:initClientData(data)
	dump(data, "activity_9001604_Ctrl:initClientData")
	self:updateSelfData(data, true)
end
function activity_9001604_Ctrl:updateSelfData(data, isInit)
