local gametop = gModuleMgr.getObject("gametop")
local activity_9001624_Ctrl = include("activity_9001624_Ctrl")
local activity_9001637_Ctrl = class("activity_9001637_Ctrl", activity_9001624_Ctrl)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001637_Ctrl:ctor(properties)
	activity_9001637_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.CELEBRATE_CORBAN
end
function activity_9001637_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_CELEBRATE_CORBAN_MODULE, gCmd.REQ_CELEBRATE_CORBAN_INIT, handler(self, self.reqInitDataRsp))
	msgCtrl.register(gCmd.CMD_CELEBRATE_CORBAN_MODULE, gCmd.REQ_CELEBRATE_CORBAN_QUEST_REWARD, handler(self, self.reqRewardRsp))
	msgCtrl.register(gCmd.CMD_CELEBRATE_CORBAN_MODULE, gCmd.REQ_CELEBRATE_CORBAN_STAGE_REWARD, handler(self, self.reqStageRewardRsp))
	msgCtrl.register(gCmd.CMD_CELEBRATE_CORBAN_MODULE, gCmd.REQ_CELEBRATE_CORBAN_BUY_GIFT, handler(self, self.reqBuyGiftRsp))
	self:registerNotify()
end
function activity_9001637_Ctrl:resetData()
	;(nil).advanceReward, _UPVALUE0_, _UPVALUE0_ = nil, nil, nil
	;(nil).normalReward, _UPVALUE0_, (nil).isAdvanceRewardUnlock = nil, nil, false
	;(nil).questData, _UPVALUE0_, (nil).point = nil, nil, 0
	self.initData, (nil).round = nil, 1
	self.data = self.initData
	self.questComponent = nil
end
function activity_9001637_Ctrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.CELEBRATE_CORBAN, handler(self, self.notifyHandler))
end
function activity_9001637_Ctrl:updateClientData(data)
