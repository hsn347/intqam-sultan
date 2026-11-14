local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001606_Ctrl = class("activity_9001606_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
_ENV = "msgCtrl"
;("msgCtrl").SYSTEM = 1
local _ENV, ("msgCtrl").INVITE, mergeServerType = nil, 2, "msgCtrl"
;(nil).NONE = 0
;(nil).INVITED = 1
_ENV, gMergeServerInvitState, (nil).AGREED = nil, nil, 2
;(nil).CLOSE = 0
;(nil).PREVIEW = gActivityTimeActivityID.NORMAL_ACTIVITY_9001605
activity_9001606_Ctrl.activityState, (nil).SHOWING = nil, gActivityTimeActivityID.NORMAL_ACTIVITY_9001606
function activity_9001606_Ctrl:ctor(properties)
	activity_9001606_Ctrl.super.ctor(self, properties)
	self.activityID1 = gActivityTimeActivityID.NORMAL_ACTIVITY_9001605
	self.data, activity_9001606_Ctrl, self.activityID2 = gActivityTimeActivityID.NORMAL_ACTIVITY_9001606, gActivityTimeActivityID.NORMAL_ACTIVITY_9001606, gActivityTimeActivityID.NORMAL_ACTIVITY_9001606
end
function activity_9001606_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_MERGE_SERVER_MODULE, gCmd.REQ_MERGE_SERVER_INIT, handler(self, self.reqDataRsp))
	msgCtrl.register(gCmd.CMD_MERGE_SERVER_MODULE, gCmd.REQ_MERGE_SERVER_INVITE, handler(self, self.reqInviteRsp))
	msgCtrl.register(gCmd.CMD_MERGE_SERVER_MODULE, gCmd.REQ_MERGE_SERVER_AGREE, handler(self, self.reqAgreeRsp))
	msgCtrl.register(gCmd.CMD_MERGE_SERVER_MODULE, gCmd.REQ_MERGE_SERVER_CANCEL, handler(self, self.reqCancelRsp))
	msgCtrl.register(gCmd.CMD_MERGE_SERVER_MODULE, gCmd.REQ_MERGE_SERVER_UNBIND, handler(self, self.reqUnbindRsp))
	msgCtrl.register(gCmd.CMD_MERGE_SERVER_MODULE, gCmd.REQ_MERGE_SERVER_CAN_INVITE_INFO, handler(self, self.reqCanInviteRsp))
	msgCtrl.register(gCmd.CMD_MERGE_SERVER_MODULE, gCmd.REQ_MERGE_SERVER_BIND_INFO, handler(self, self.reqBindInfoRsp))
	msgCtrl.register(gCmd.CMD_MERGE_SERVER_MODULE, gCmd.REQ_MERGE_SERVER_SHOW, handler(self, self.reqShowRsp))
	self:registerNotify()
end
function activity_9001606_Ctrl:initClientData(data)
	dump(data, "==activity_9001606_Ctrl:initClientData==", 10)
	if not data then
		if self:getIsActivityOpen() then
			self:sendReqInitDataMsg()
		end
		return
	end
	if next(self.data) == nil and data ~= nil then
		self:initTeamInfo(self.myTeamInfo)
	end
	self.data = data
end
function activity_9001606_Ctrl:getIsGotData()
	return next(self.data) ~= nil
end
function activity_9001606_Ctrl:initTeamInfo(teamInfo)
