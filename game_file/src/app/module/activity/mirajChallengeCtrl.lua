local GameModule = include("GameModule")
local mirajChallengeCtrl = class("mirajChallengeCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function mirajChallengeCtrl:ctor(properties)
	mirajChallengeCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.MIRAJ_CHALLENGE_ACTIVITY
end
function mirajChallengeCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_MIRAJ_CHALLENGE_MODULE, gCmd.REQ_MIRAJ_CHALLENGE_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_MIRAJ_CHALLENGE_MODULE, gCmd.REQ_MIRAJ_CHALLENGE_PUT, handler(self, self.reqPutRsp))
	msgCtrl.register(gCmd.CMD_MIRAJ_CHALLENGE_MODULE, gCmd.REQ_MIRAJ_CHALLENGE_OPEN_BOX, handler(self, self.reqOpenBoxRsp))
	self:resetData()
	self:registerNotify()
	self:sendInit()
end
function mirajChallengeCtrl:resetData()
	self.data, _UPVALUE0_ = nil, nil
end
function mirajChallengeCtrl:Logout()
	self:resetData()
	mirajChallengeCtrl.super.Logout(self)
end
function mirajChallengeCtrl:initClientData(data)
