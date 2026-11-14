local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001617_Ctrl = class("activity_9001617_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001617_Ctrl:ctor(properties)
	activity_9001617_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.HONOR_BACK_LOTTERY
end
function activity_9001617_Ctrl:reqLotteryDraw(times)
	local activityCommonDrawCtrl = SoraDGetCtrl("activityCommonDrawCtrl")
	activityCommonDrawCtrl:reqDrawOne(self.activityID, times)
end
function activity_9001617_Ctrl:getReceiveStatusAndNum(...)
	local activityCommonDrawCtrl = SoraDGetCtrl("activityCommonDrawCtrl")
	return activityCommonDrawCtrl:getReceiveStatusAndNum(self.activityID)
end
function activity_9001617_Ctrl:getItemID(...)
	local activityCommonDrawCtrl = SoraDGetCtrl("activityCommonDrawCtrl")
	return activityCommonDrawCtrl:getItemID(self.activityID)
end
return activity_9001617_Ctrl
