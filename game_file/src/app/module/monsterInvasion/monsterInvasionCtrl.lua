local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local monsterInvasionCtrl = class("monsterInvasionCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local constantRead = include("constantRead")
function monsterInvasionCtrl:ctor(properties)
	monsterInvasionCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.MONSTER_INVASION_ACTIVITY
	self.itemID = 860201
	self:resetData()
end
function monsterInvasionCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_MONSTER_INVASION_MODULE, gCmd.REQ_MONSTER_INVASION_DATA, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_MONSTER_INVASION_MODULE, gCmd.REQ_MONSTER_INVASION_RANK, handler(self, self.reqMonsterInvasionRankRsp))
	msgCtrl.register(gCmd.CMD_MONSTER_INVASION_MODULE, gCmd.REQ_MONSTER_INVASION_SUMMON_BOSS, handler(self, self.reqMonsterInvasionSumonRsp))
	self:registerNotify()
	self:sendInitMsg()
end
function monsterInvasionCtrl:initClientData(data)
	self.msgData = data
end
function monsterInvasionCtrl:Logout()
	monsterInvasionCtrl.super.Logout(self)
	self:resetData()
end
function monsterInvasionCtrl:resetData()
	self.msgData, _UPVALUE0_ = nil, nil
end
function monsterInvasionCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.MONSTER_INVASION, handler(self, self.notifyHandler))
end
function monsterInvasionCtrl:notifyHandler(event)
	dump(event.data, "monsterInvasionCtrl:notifyHandler", 10)
	for _, content in pairs(event.data) do
		local notifyType = content.notifyType
		local notifyData = content.notifyData
		if notifyType == "killBoss" then
			self:initClientData(notifyData)
			_ENV = self
			self.msg = "MESSAGE_MONSTER_INVASION_UPDATE"
			SoraDSendMessage(self)
		end
	end
end
function monsterInvasionCtrl:sendInitMsg()
	if clientEventMgr.judgeIsOpen(self.activityID) then
		_ENV = nil
		serverproxy:Request(gCmd.CMD_MONSTER_INVASION_MODULE, gCmd.REQ_MONSTER_INVASION_DATA, nil)
	end
end
function monsterInvasionCtrl:reqMonsterInvasionRank(iBegin, nCount)
	serverproxy = nil
	;(nil).iBegin = iBegin
	;(nil).nCount = nCount
	serverproxy:Request(gCmd.CMD_MONSTER_INVASION_MODULE, gCmd.REQ_MONSTER_INVASION_RANK, nil)
end
function monsterInvasionCtrl:reqMonsterInvasionSumon()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_MONSTER_INVASION_MODULE, gCmd.REQ_MONSTER_INVASION_SUMMON_BOSS, nil)
end
function monsterInvasionCtrl:reqInitRsp(content)
	dump(content, "monsterInvasionCtrl:reqInit(content)", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_MONSTER_INVASION_UPDATE"
		SoraDSendMessage(self)
	end
end
function monsterInvasionCtrl:reqMonsterInvasionRankRsp(content)
	dump(content, "monsterInvasionCtrl:reqMonsterInvasionRankRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_MONSTER_INVASION_RANK"
		self.rspdata = content.rspdata
		SoraDSendMessage(self)
	end
end
function monsterInvasionCtrl:reqMonsterInvasionSumonRsp(content)
	dump(content, "monsterInvasionCtrl:reqMonsterInvasionSumonRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_MONSTER_INVASION_UPDATE"
		SoraDSendMessage(self)
	end
end
function monsterInvasionCtrl:getReceiveStatusAndNum()
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local itemHave = backpackCtrl:getItemCount(self.itemID)
	if 1 <= itemHave then
		return true, -1
	end
	return false, 0
end
function monsterInvasionCtrl:getBossPosition()
	return self.msgData.bossX, self.msgData.bossY
end
function monsterInvasionCtrl:getBossCreateTime()
	return self.msgData.bossCreateTime or nil
end
function monsterInvasionCtrl:getMySocre()
	return self.msgData.score or 0
end
return monsterInvasionCtrl
