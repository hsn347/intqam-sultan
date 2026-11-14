local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local caveExploreCtrl = class("caveExploreCtrl", gamemodulec)
local annivColossusRead = include("annivColossusRead")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local caveExploreRead = include("caveExploreRead")
function caveExploreCtrl:ctor(properties)
	caveExploreCtrl.super.ctor(self, properties)
	self.itemID = 841701
	self:resetData()
end
function caveExploreCtrl:EnterGame()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_INIT", handler(self, self.activityInitRsp))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_CAVE_EXPLORE_LOTTERY, handler(self, self.reqCaveExloreRsp))
end
function caveExploreCtrl:getReceiveStatusAndNum()
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local itemNum = backpackCtrl:getItemCount(self.itemID)
	if 0 < itemNum or not self.isFreed then
		return true, -1
	end
	return false, -1
end
function caveExploreCtrl:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CAVE_EXPLORE_ACTIVITY) then
		self:resetData()
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.eventID = gActivityTimeActivityID.CAVE_EXPLORE_ACTIVITY
		SoraDSendMessage(self)
	end
end
function caveExploreCtrl:initClientData(data)
	if not data then
		return
	end
	self.isFreed = data.isFree == 1
end
function caveExploreCtrl:Logout()
	caveExploreCtrl.super.Logout(self)
	self:resetData()
end
function caveExploreCtrl:resetData()
	self.isFreed = false
end
function caveExploreCtrl:activityInitRsp(target, data)
	if data.activityID == gActivityTimeActivityID.CAVE_EXPLORE_ACTIVITY then
		self:initClientData(data.initData)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.eventID = gActivityTimeActivityID.CAVE_EXPLORE_ACTIVITY
		SoraDSendMessage(self)
	end
end
function caveExploreCtrl:reqInit(...)
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	activityTaskComponentCtrl:sendReqInit()
end
function caveExploreCtrl:reqCaveExlore(isTen)
	serverproxy = nil
	;(nil).isTen = isTen
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_CAVE_EXPLORE_LOTTERY, nil)
end
function caveExploreCtrl:reqCaveExloreRsp(content)
	dump(content, "caveExploreCtrl:reqCaveExlore(content)", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata)
		_ENV = self
		self.msg = "MESSAGE_CAVE_EXPLORE"
		self.rewards = content.rspdata.rewards
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.eventID = gActivityTimeActivityID.CAVE_EXPLORE_ACTIVITY
		SoraDSendMessage(self)
	end
end
function caveExploreCtrl:getGroupID()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local activityData = activityShowCtrl:getActivityData(gActivityTimeActivityID.CAVE_EXPLORE_ACTIVITY)
	if activityData and activityData.param and activityData.param.classtype then
		return activityData.param.classtype
	end
	return 1
end
function caveExploreCtrl:getRewards()
	local groupID = self:getGroupID()
	return caveExploreRead:getRewards(groupID)
end
function caveExploreCtrl:getIsFree()
	return not self.isFreed
end
return caveExploreCtrl
