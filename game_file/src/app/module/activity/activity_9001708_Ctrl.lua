local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001708_Ctrl = class("activity_9001708_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local activity_9001708_Read = include("activity_9001708_Read")
function activity_9001708_Ctrl:ctor(properties)
	activity_9001708_Ctrl.super.ctor(self, properties)
	self:resetData()
	self.activityID = gActivityTimeActivityID.KOH_MIGRATE_HELP_9001708
	self.buff_rid = 19933
end
function activity_9001708_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_KOH_MIGRATE_HELP_MODULE, gCmd.REQ_KOH_MIGRATE_HELP_DATA, handler(self, self.reqDataRsp))
	msgCtrl.register(gCmd.CMD_KOH_MIGRATE_HELP_MODULE, gCmd.REQ_KOH_MIGRATE_HELP_TASK_REWARD, handler(self, self.reqTaskRewardRsp))
	self:registerNotify()
end
function activity_9001708_Ctrl:Logout()
	activity_9001708_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001708_Ctrl:resetData()
	_UPVALUE0_ = nil
	;(nil).isOpen = false
	;(nil).beginTime = nil
	self.initData, (nil).recharge, _UPVALUE0_, (nil).questData, _UPVALUE0_, (nil).endTime = nil, nil, nil, nil, nil, nil
end
function activity_9001708_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.KOH_MIGRATE_HELP, handler(self, self.notifyHandler))
end
function activity_9001708_Ctrl:notifyHandler(event)
