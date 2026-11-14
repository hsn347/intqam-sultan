local GameModule = include("GameModule")
local msgCtrl = include("msgCtrl")
local heroTaskCtrl = class("heroTaskCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
function heroTaskCtrl:ctor(properties)
	heroTaskCtrl.super.ctor(self, properties)
end
function heroTaskCtrl:Logout()
	heroTaskCtrl.super.Logout(self)
	self:resetData()
end
function heroTaskCtrl:resetData()
	self.tasks, _UPVALUE0_ = nil, nil
end
function heroTaskCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_HERO_TASK_MODULE, gCmd.REQ_HERO_TASK_DATA, handler(self, self.dataRsp))
	msgCtrl.register(gCmd.CMD_HERO_TASK_MODULE, gCmd.REQ_HERO_TASK_START, handler(self, self.starRsp))
	msgCtrl.register(gCmd.CMD_HERO_TASK_MODULE, gCmd.REQ_HERO_TASK_STOP, handler(self, self.stopRsp))
	self:sendReqInitDataMsg()
	self:registerNotify()
end
function heroTaskCtrl:initClientData(data)
	dump(data, "heroTaskCtrl:initClientData===", 10)
end
function heroTaskCtrl:registerNotify(...)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.HERO_TASK, handler(self, self.noitfyDataRsp))
end
function heroTaskCtrl:noitfyDataRsp(content)
	dump(content, "heroTaskCtrl:noitfyDataRsp", 10)
	for i, notifyMsg in ipairs(content.data) do
		self.tasks = notifyMsg.tasks
	end
	_ENV = ipairs(content.data)
	ipairs(content.data).msg = "MESSAGE_SERVER_HERO_TASK_UPDATE"
	SoraDSendMessage(ipairs(content.data))
end
function heroTaskCtrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_HERO_TASK_MODULE, gCmd.REQ_HERO_TASK_DATA, nil)
end
function heroTaskCtrl:reqStarTask(taskId, heros)
	serverproxy = nil
	;(nil).taskId = taskId
	;(nil).heros = heros
	serverproxy:Request(gCmd.CMD_HERO_TASK_MODULE, gCmd.REQ_HERO_TASK_START, nil)
end
function heroTaskCtrl:reqStopTask(taskId)
	serverproxy = nil
	;(nil).taskId = taskId
	serverproxy:Request(gCmd.CMD_HERO_TASK_MODULE, gCmd.REQ_HERO_TASK_STOP, nil)
end
function heroTaskCtrl:dataRsp(content)
	dump(content, "heroTaskCtrl:dataRsp", 5)
	if gErrDef.Err_None == content.err then
		self.tasks = content.rspdata.tasks
	end
	_ENV = content.err
	content.err.msg = "MESSAGE_SERVER_HERO_TASK_UPDATE"
	SoraDSendMessage(content.err)
end
function heroTaskCtrl:starRsp(content)
	dump(content, "heroTaskCtrl:starRsp", 5)
	if gErrDef.Err_None == content.err then
		self.tasks = content.rspdata.tasks
	end
	_ENV = content.err
	content.err.msg = "MESSAGE_SERVER_HERO_TASK_UPDATE"
	SoraDSendMessage(content.err)
end
function heroTaskCtrl:stopRsp(content)
	dump(content, "heroTaskCtrl:stopRsp", 5)
	if gErrDef.Err_None == content.err then
		self.tasks = content.rspdata.tasks
	end
	_ENV = content.err
	content.err.msg = "MESSAGE_SERVER_HERO_TASK_UPDATE"
	SoraDSendMessage(content.err)
end
function heroTaskCtrl:getIngTaskList()
	local _ENV, list
	for k, v in ipairs(self.tasks) do
		if v.state == gHeroTaskState.START then
			table.insert(list, v)
		end
	end
	return list
end
function heroTaskCtrl:getTaskList()
	return self.tasks
end
function heroTaskCtrl:isHeroInTask(heroID)
	for k, v in ipairs(self.tasks) do
		if v.state == gHeroTaskState.START then
			if not v.heros then
				_ENV = v.heros
			end
			if SoraDisInList(heroID, v.heros) then
				return true
			end
		end
	end
	return false
end
return heroTaskCtrl
