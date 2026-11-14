local GameModule = include("GameModule")
local heroWarCtrl = class("heroWarCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function heroWarCtrl:ctor(properties)
	heroWarCtrl.super.ctor(self, properties)
end
function heroWarCtrl:EnterGame()
	gametop = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	msgCtrl.register(gCmd.CMD_HERO_BATTLE_BOSS_MODULE, gCmd.REQ_HERO_BATTLE_BOSS_RANK, handler(self, self.reqRankRsp))
	msgCtrl.register(gCmd.CMD_HERO_BATTLE_BOSS_MODULE, gCmd.REQ_HERO_BATTLE_BOSS_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_HERO_BATTLE_BOSS_MODULE, gCmd.REQ_HERO_BATTLE_BOSS_RECEIVE, handler(self, self.reqReceiveRsp))
	self:registerNotify()
	self:resetData()
end
function heroWarCtrl:initClientData(data)
	if not data then
		return
	end
	dump(data, "heroWarCtrl:initClientData")
	self.killRewardData = data
end
function heroWarCtrl:resetData()
	_UPVALUE0_, self.rankInfo, _UPVALUE0_ = nil, nil, nil
	;(nil).receive1 = 0
	self.killRewardData, (nil).receive2 = nil, 0
end
function heroWarCtrl:Logout()
	self:resetData()
	heroWarCtrl.super.Logout(self)
end
function heroWarCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.HERO_BATTLE_BOSS, handler(self, self.notifyHandler))
end
function heroWarCtrl:notifyHandler(event)
	dump(event.data, "heroWarCtrl:notifyHandler event.data", 10)
	for _, content in pairs(event.data) do
		if content then
			self.killRewardData = content
			_ENV = nil
			;(nil).msg = "MESSAGE_SERVER_HEROWAR_INIT_BACK"
			SoraDSendMessage(nil)
		end
	end
end
function heroWarCtrl:sendReqRankMsg()
	serverproxy:Request(gCmd.CMD_HERO_BATTLE_BOSS_MODULE, gCmd.REQ_HERO_BATTLE_BOSS_RANK)
end
function heroWarCtrl:reqRankRsp(ret)
	if ret and ret.err == gErrDef.Err_None and ret.rspdata then
		self.rankInfo = ret.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_HEROWAR_REFRESH"
		SoraDSendMessage(gErrDef.Err_None)
	end
	_ENV = gErrDef.Err_None
	gErrDef.Err_None.msg = "MESSAGE_SERVER_HEROWAR_REFRESH"
	SoraDSendMessage(gErrDef.Err_None)
end
function heroWarCtrl:sendReqInitMsg()
	serverproxy:Request(gCmd.CMD_HERO_BATTLE_BOSS_MODULE, gCmd.REQ_HERO_BATTLE_BOSS_INIT)
end
function heroWarCtrl:reqInitRsp(ret)
	dump(ret, "heroWarCtrl:reqInitRsp", 10)
	if ret and ret.err == gErrDef.Err_None and ret.rspdata then
		self.killRewardData = ret.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_HEROWAR_INIT_BACK"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function heroWarCtrl:sendReqReceiveMsg()
	if self:checkCanReceive() then
		serverproxy:Request(gCmd.CMD_HERO_BATTLE_BOSS_MODULE, gCmd.REQ_HERO_BATTLE_BOSS_RECEIVE)
	end
end
function heroWarCtrl:reqReceiveRsp(ret)
	dump(ret, "heroWarCtrl:reqReceiveRsp", 10)
	if ret and ret.err == gErrDef.Err_None and ret.rspdata then
		if not ret.rspdata.reward then
			local _ENV, reward = ret.rspdata.reward, ret.rspdata.reward
		end
		_ENV = 10
		;(10).isArray = true
		SoraDOpenGiftView(reward, 10)
		self.killRewardData.receive1 = ret.rspdata.receive1 or 0
		self.killRewardData.receive2 = ret.rspdata.receive2 or 0
		_ENV = ret.rspdata.receive2 or 0
		;(ret.rspdata.receive2 or 0).msg = "MESSAGE_SERVER_HEROWAR_RECEIVE_BACK"
		SoraDSendMessage(ret.rspdata.receive2 or 0)
	end
end
function heroWarCtrl:getTopInfo()
	return self.rankInfo.topInfo
end
function heroWarCtrl:getselfInfo()
	return self.rankInfo.selfInfo
end
function heroWarCtrl:getKillRewardData(...)
	return self.killRewardData
end
function heroWarCtrl:checkCanReceive()
	local data = self:getKillRewardData()
	local receive = data.receive1 + data.receive2
	if receive <= 0 then
		SoraDShowMsgTip(i18n("arena_text_16"))
		return false
	end
	return true
end
return heroWarCtrl
