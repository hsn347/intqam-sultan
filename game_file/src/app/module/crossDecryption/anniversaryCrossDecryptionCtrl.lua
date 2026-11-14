local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local crossDecryptionCtrl = include("crossDecryptionCtrl")
local anniversaryCrossDecryptionCtrl = class("anniversaryCrossDecryptionCtrl", crossDecryptionCtrl)
function anniversaryCrossDecryptionCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_ANNIVERSARY_UNCOVER_MODULE, gCmd.REQ_ANNIVERSARY_UNCOVER_COMMIT, handler(self, self.missionCommitRsp))
	msgCtrl.register(gCmd.CMD_ANNIVERSARY_UNCOVER_MODULE, gCmd.REQ_ANNIVERSARY_UNCOVER_GETREWARD, handler(self, self.getRewardRsp))
end
function anniversaryCrossDecryptionCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.ANNIVERSARY_UNCOVER, handler(self, self.notifyUpdate))
end
function anniversaryCrossDecryptionCtrl:reqGetReward(_data)
	local data = _data
	serverproxy:Request(gCmd.CMD_ANNIVERSARY_UNCOVER_MODULE, gCmd.REQ_ANNIVERSARY_UNCOVER_GETREWARD, data)
end
function anniversaryCrossDecryptionCtrl:reqCommitTask(_data)
	local data = _data
	serverproxy:Request(gCmd.CMD_ANNIVERSARY_UNCOVER_MODULE, gCmd.REQ_ANNIVERSARY_UNCOVER_COMMIT, data)
end
return anniversaryCrossDecryptionCtrl
