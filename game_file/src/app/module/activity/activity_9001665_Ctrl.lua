local activity_9001665_Read = include("activity_9001665_Read")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001665_Ctrl = class("activity_9001665_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001665_Ctrl:ctor(properties)
	activity_9001665_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001665
	self:resetData()
end
function activity_9001665_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_FISHING_MASTER_MODULE, gCmd.REQ_FISHING_MASTER_DATA, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_FISHING_MASTER_MODULE, gCmd.REQ_FISHING_MASTER_CATCH, handler(self, self.reqPlayRsp))
	msgCtrl.register(gCmd.CMD_FISHING_MASTER_MODULE, gCmd.REQ_FISHING_MASTER_STAGE_REWARD, handler(self, self.reqReceiveRsp))
	msgCtrl.register(gCmd.CMD_FISHING_MASTER_MODULE, gCmd.REQ_FISHING_MASTER_RANK, handler(self, self.reqRankRsp))
	msgCtrl.register(gCmd.CMD_FISHING_MASTER_MODULE, gCmd.REQ_FISHING_MASTER_FISH_REWARD, handler(self, self.reqFishRewardRsp))
end
function activity_9001665_Ctrl:Logout()
	activity_9001665_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001665_Ctrl:resetData()
	self.msgData, _UPVALUE0_ = nil, nil
end
function activity_9001665_Ctrl:initClientData(data)
	self.msgData = data
end
function activity_9001665_Ctrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_FISHING_MASTER_MODULE, gCmd.REQ_FISHING_MASTER_DATA, nil)
end
function activity_9001665_Ctrl:reqInitRsp(content)
	dump(content, "activity_9001665_Ctrl:reqInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.msgData = content.rspdata
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001665_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function activity_9001665_Ctrl:reqPlay(difficultType, time, score, extraData)
