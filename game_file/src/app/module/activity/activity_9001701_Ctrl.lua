local gametop = gModuleMgr.getObject("gametop")
local activity_9001565_Ctrl = include("activity_9001565_Ctrl")
local activity_9001701_Ctrl = class("activity_9001701_Ctrl", activity_9001565_Ctrl)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local warOrderRead = include("warOrderRead")
function activity_9001701_Ctrl:ctor(properties)
	activity_9001701_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001701
	self.unlockLv = 0
	self:resetData()
end
function activity_9001701_Ctrl:EnterGame()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_INIT", handler(self, self.reqActivityInitDataRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_TWO_MAGIC_LAMP_ORDER_RECEIVE, handler(self, self.reqWarOrderReceiveRsp))
	self:registerNotify()
end
function activity_9001701_Ctrl:reqWarOrderReceive()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_TWO_MAGIC_LAMP_ORDER_RECEIVE, nil)
end
function activity_9001701_Ctrl:checkActivityCondition(...)
	local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
	if magicLampCtrl:getIsJinnUnlock(gJinnType.JINN_TWO) then
		return true
	else
		return false
	end
end
function activity_9001701_Ctrl:getRewardState(type, lv)
	local maxLv = table.nums(warOrderRead.getLvAwardList(self.activityID, self:getGroupIndex()))
	if lv <= self:getRewardLevel(type) then
		return gBtnTargetStatusDef.GOT
	elseif self:isRewardUnlock(type) and lv <= self:getLevel() then
		return gBtnTargetStatusDef.GET
	end
	return gBtnTargetStatusDef.GO
end
function activity_9001701_Ctrl:getGroupId()
	return self.initData.groupId or 1
end
return activity_9001701_Ctrl
