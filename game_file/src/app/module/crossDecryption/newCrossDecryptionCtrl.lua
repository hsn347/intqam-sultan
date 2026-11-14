local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local crossDecryptionCtrl = include("crossDecryptionCtrl")
local newCrossDecryptionCtrl = class("newCrossDecryptionCtrl", crossDecryptionCtrl)
function newCrossDecryptionCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_NEW_CROSS_MISSION_MODULE, gCmd.REQ_NEW_CROSS_MISSION_COMMIT, handler(self, self.missionCommitRsp))
	msgCtrl.register(gCmd.CMD_NEW_CROSS_MISSION_MODULE, gCmd.REQ_NEW_CROSS_MISSION_GETREWARD, handler(self, self.getRewardRsp))
end
function newCrossDecryptionCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.NEW_CROSS_MISSION, handler(self, self.notifyUpdate))
end
function newCrossDecryptionCtrl:reqGetReward(_data)
	local data = _data
	serverproxy:Request(gCmd.CMD_NEW_CROSS_MISSION_MODULE, gCmd.REQ_NEW_CROSS_MISSION_GETREWARD, data)
end
function newCrossDecryptionCtrl:reqCommitTask(_data)
	local data = _data
	serverproxy:Request(gCmd.CMD_NEW_CROSS_MISSION_MODULE, gCmd.REQ_NEW_CROSS_MISSION_COMMIT, data)
end
return newCrossDecryptionCtrl
