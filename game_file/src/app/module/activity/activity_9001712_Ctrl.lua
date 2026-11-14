local activity_9001712_Read = include("activity_9001712_Read")
local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001712_Ctrl = class("activity_9001712_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001712_Ctrl:ctor(properties)
	activity_9001712_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.CELEBRATION_SIGN_ACTIVITY
	self:resetData()
end
function activity_9001712_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_CELEBRATION_SING_MODULE, gCmd.REQ_CELEBRATION_SING_INIT, handler(self, self.reqInitDataRsp))
	msgCtrl.register(gCmd.CMD_CELEBRATION_SING_MODULE, gCmd.REQ_CELEBRATION_SING_REWARD, handler(self, self.reqRewardRsp))
	msgCtrl.register(gCmd.CMD_CELEBRATION_SING_MODULE, gCmd.REQ_CELEBRATION_SING_STAGE_REWARD, handler(self, self.reqStageRewardRsp))
	msgCtrl.register(gCmd.CMD_CELEBRATION_SING_MODULE, gCmd.REQ_CELEBRATION_SING_BUY_TIMES, handler(self, self.reqBuyTimesRsp))
	self:registerNotify()
	self:reqInitData()
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.newDay))
end
function activity_9001712_Ctrl:Logout()
	activity_9001712_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001712_Ctrl:resetData()
	_UPVALUE0_ = nil
	;(nil).round = 0
	;(nil).totalTimes = 0
	self.initData, (nil).stageReward, _UPVALUE0_, (nil).signReward, _UPVALUE0_, (nil).buyNum = nil, nil, nil, nil, nil, 0
end
function activity_9001712_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.CELEBRATION_SIGN, handler(self, self.notifyHandler))
end
function activity_9001712_Ctrl:notifyHandler(event)
