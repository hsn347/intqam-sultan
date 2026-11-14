local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001661_Ctrl = class("activity_9001661_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001661_Ctrl:ctor(properties)
	activity_9001661_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.BUBBLE_GRANGE_ACTIVITY
	local activity_9001661_Read = include("activity_9001661_Read")
	self.itemID = activity_9001661_Read.getItemID()
	self:resetData()
end
function activity_9001661_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_BUBBLE_GRANGE_MODULE, gCmd.REQ_BUBBLE_GRANGE_INIT, handler(self, self.reqBubbleGrangeInitRsp))
	msgCtrl.register(gCmd.CMD_BUBBLE_GRANGE_MODULE, gCmd.REQ_BUBBLE_GRANGE_CLEAN, handler(self, self.reqBubbleGrangeCleanRsp))
	msgCtrl.register(gCmd.CMD_BUBBLE_GRANGE_MODULE, gCmd.REQ_BUBBLE_GRANGE_CARE, handler(self, self.reqBubbleGrangeCareRsp))
	msgCtrl.register(gCmd.CMD_BUBBLE_GRANGE_MODULE, gCmd.REQ_BUBBLE_GRANGE_MEMBERS, handler(self, self.reqBubbleGrangeMembersRsp))
	msgCtrl.register(gCmd.CMD_BUBBLE_GRANGE_MODULE, gCmd.REQ_BUBBLE_GRANGE_ASSIST, handler(self, self.reqBubbleGrangeAssistRsp))
	msgCtrl.register(gCmd.CMD_BUBBLE_GRANGE_MODULE, gCmd.REQ_BUBBLE_GRANGE_REWARD, handler(self, self.reqBubbleGrangeRewardRsp))
	msgCtrl.register(gCmd.CMD_BUBBLE_GRANGE_MODULE, gCmd.REQ_BUBBLE_GRANGE_RANK, handler(self, self.reqBubbleGrangeRankRsp))
	msgCtrl.register(gCmd.CMD_BUBBLE_GRANGE_MODULE, gCmd.REQ_BUBBLE_GRANGE_RECORD, handler(self, self.reqBubbleGrangeRecordRsp))
	msgCtrl.register(gCmd.CMD_BUBBLE_GRANGE_MODULE, gCmd.REQ_BUBBLE_GRANGE_GROUTH, handler(self, self.reqBubbleGrangeGrouthRsp))
	msgCtrl.register(gCmd.CMD_BUBBLE_GRANGE_MODULE, gCmd.REQ_BUBBLE_GRANGE_ENTER, handler(self, self.reqBubbleGrangeEnterRsp))
	msgCtrl.register(gCmd.CMD_BUBBLE_GRANGE_MODULE, gCmd.REQ_BUBBLE_GRANGE_TABLE, handler(self, self.reqBubbleGrangeTableRsp))
	self:registerNotify()
end
function activity_9001661_Ctrl:Logout()
	activity_9001661_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001661_Ctrl:resetData()
	self.records, _UPVALUE0_, self.initData, _UPVALUE0_ = nil, nil, nil, nil
end
function activity_9001661_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.BUBBLE_GRANGE, handler(self, self.notifyHandler))
end
function activity_9001661_Ctrl:notifyHandler(event)
