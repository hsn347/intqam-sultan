local gametop = gModuleMgr.getObject("gametop")
local activity_9001565_Ctrl = include("activity_9001565_Ctrl")
local activity_9001683_Ctrl = class("activity_9001683_Ctrl", activity_9001565_Ctrl)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local warOrderRead = include("warOrderRead")
function activity_9001683_Ctrl:ctor(properties)
	activity_9001683_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY
	self.unlockLv = 0
	self:resetData()
end
function activity_9001683_Ctrl:EnterGame()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_INIT", handler(self, self.reqActivityInitDataRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_MAGIC_LAMP_HATCH_ORDER_RECEIVE, handler(self, self.reqWarOrderReceiveRsp))
	self:registerNotify()
end
function activity_9001683_Ctrl:reqWarOrderReceive()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_MAGIC_LAMP_HATCH_ORDER_RECEIVE, nil)
end
function activity_9001683_Ctrl:checkActivityCondition(...)
	local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
	if magicLampCtrl:getJinnLv(gJinnType.JINN_ONE) < 350 then
		return false
	else
		return true
	end
end
function activity_9001683_Ctrl:getRewardState(type, lv)
	local maxLv = table.nums(warOrderRead.getLvAwardList(self.activityID, self:getGroupIndex()))
	if lv <= self:getRewardLevel(type) then
		return gBtnTargetStatusDef.GOT
	elseif self:isRewardUnlock(type) and lv <= self:getLevel() then
		return gBtnTargetStatusDef.GET
	end
	return gBtnTargetStatusDef.GO
end
return activity_9001683_Ctrl
