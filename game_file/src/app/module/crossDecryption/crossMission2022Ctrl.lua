local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local crossDecryptionCtrl = include("crossDecryptionCtrl")
local crossMission2022Ctrl = class("crossMission2022Ctrl", crossDecryptionCtrl)
function crossMission2022Ctrl:ctor(...)
	crossMission2022Ctrl.super.ctor(self, ...)
	self.activityID = gActivityTimeActivityID.CROSS_MISSION_2022_ACTIVITY
end
function crossMission2022Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_CROSS_MISSION_2022_MODULE, gCmd.REQ_CROSS_MISSION_2022_COMMIT, handler(self, self.missionCommitRsp))
	msgCtrl.register(gCmd.CMD_CROSS_MISSION_2022_MODULE, gCmd.REQ_CROSS_MISSION_2022_GETREWARD, handler(self, self.getRewardRsp))
end
function crossMission2022Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.CROSS_MISSION_2022, handler(self, self.notifyUpdate))
end
function crossMission2022Ctrl:reqGetReward(_data)
	local data = _data
	serverproxy:Request(gCmd.CMD_CROSS_MISSION_2022_MODULE, gCmd.REQ_CROSS_MISSION_2022_GETREWARD, data)
end
function crossMission2022Ctrl:reqCommitTask(_data)
	local data = _data
	serverproxy:Request(gCmd.CMD_CROSS_MISSION_2022_MODULE, gCmd.REQ_CROSS_MISSION_2022_COMMIT, data)
end
return crossMission2022Ctrl
