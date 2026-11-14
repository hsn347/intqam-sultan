local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001720_Ctrl = class("activity_9001720_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001720_Ctrl:ctor(properties)
	activity_9001720_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.LIONPARADISE_ACTIVITY_9001720
	local activity_9001720_Read = include("activity_9001720_Read")
	self.itemID = activity_9001720_Read.getItemID()
	self:resetData()
end
function activity_9001720_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_LION_PARADISE_MODULE, gCmd.REQ_LION_PARADISE_INIT, handler(self, self.reqInitDataRsp))
	msgCtrl.register(gCmd.CMD_LION_PARADISE_MODULE, gCmd.REQ_LION_PARADISE_CLEAN, handler(self, self.reqCleanRsp))
	msgCtrl.register(gCmd.CMD_LION_PARADISE_MODULE, gCmd.REQ_LION_PARADISE_CARE, handler(self, self.reqCareRsp))
	msgCtrl.register(gCmd.CMD_LION_PARADISE_MODULE, gCmd.REQ_LION_PARADISE_MEMBERS, handler(self, self.reqMembersRsp))
	msgCtrl.register(gCmd.CMD_LION_PARADISE_MODULE, gCmd.REQ_LION_PARADISE_ASSIST, handler(self, self.reqAssistRsp))
	msgCtrl.register(gCmd.CMD_LION_PARADISE_MODULE, gCmd.REQ_LION_PARADISE_REWARD, handler(self, self.reqRewardRsp))
	msgCtrl.register(gCmd.CMD_LION_PARADISE_MODULE, gCmd.REQ_LION_PARADISE_RANK, handler(self, self.reqRankRsp))
	msgCtrl.register(gCmd.CMD_LION_PARADISE_MODULE, gCmd.REQ_LION_PARADISE_RECORD, handler(self, self.reqRecordRsp))
	msgCtrl.register(gCmd.CMD_LION_PARADISE_MODULE, gCmd.REQ_LION_PARADISE_GROUTH, handler(self, self.reqGrouthRsp))
	self:registerNotify()
	self:reqInitData()
end
function activity_9001720_Ctrl:Logout()
	activity_9001720_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001720_Ctrl:resetData()
	self.records, _UPVALUE0_, self.initData, _UPVALUE0_ = nil, nil, nil, nil
end
function activity_9001720_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.LION_PARADISE, handler(self, self.notifyHandler))
end
function activity_9001720_Ctrl:notifyHandler(event)
