local GameModule = include("GameModule")
local kingCompetitionCtrl = class("kingCompetitionCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local kingCompetitionltCtrl = include("kingCompetitionltCtrl")
function kingCompetitionCtrl:ctor(properties)
	kingCompetitionCtrl.super.ctor(self, properties)
end
function kingCompetitionCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_NEWSERVER_RANKMATCH_MODULE, gCmd.REQ_NEWSERERV_RANKMATCH_GET_REWARD, handler(self, self.onRspGetReward))
end
function kingCompetitionCtrl:Logout()
	kingCompetitionCtrl.super.Logout(self)
end
function kingCompetitionCtrl:initClientData(data)
