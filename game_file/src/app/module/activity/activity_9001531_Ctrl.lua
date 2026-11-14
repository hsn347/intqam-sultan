local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001531_Ctrl = class("activity_9001531_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local activity_9001531_Read = include("activity_9001531_Read")
function activity_9001531_Ctrl:ctor(properties)
	activity_9001531_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.BRIGHT_FIREWORKS_ACTIVITY
	self:resetData()
end
function activity_9001531_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_BRIGHT_FIREWORKS_USE_ITEM, handler(self, self.reqUseItemRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_BRIGHT_FIREWORKS_EXCHANGE, handler(self, self.reqExchangeRsp))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_INIT", handler(self, self.activityInitRsp))
end
function activity_9001531_Ctrl:Logout()
	activity_9001531_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001531_Ctrl:resetData()
	_UPVALUE0_ = nil
	;(nil).cycleID = 1
	self.initData, (nil).point = nil, 0
end
function activity_9001531_Ctrl:initClientData(userActivityModule)
	if not userActivityModule then
		return
	end
	local activityData = userActivityModule[tostring(self.activityID)]
	if activityData and next(activityData) then
		self.initData = activityData
		dump(self.initData, "==activity_9001531_Ctrl:initClientData==", 10)
	end
end
function activity_9001531_Ctrl:activityInitRsp(target, event)
	if event.activityID == self.activityID then
		dump(event, "==activity_9001531_Ctrl:activityInitRsp==")
		self.initData = event.initData
	end
end
function activity_9001531_Ctrl:sendReqInitDataMsg()
	local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
	activityTaskComponentCtrl:sendReqInit()
end
function activity_9001531_Ctrl:reqUseItem(itemID, itemCount)
	serverproxy = nil
	;(nil).itemID = itemID
	;(nil).itemCount = itemCount
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_BRIGHT_FIREWORKS_USE_ITEM, nil)
end
function activity_9001531_Ctrl:reqUseItemRsp(content)
	dump(content, "activity_9001531_Ctrl:reqUseItemRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData.point = content.rspdata.point
		local rewards = content.rspdata.extra.rewards
		local itemID = content.data.itemID
		_ENV = nil
		;(nil).rewards = rewards
		;(nil).itemID = itemID
		uiManager:show("Activity_9001531_Reward2", nil)
		_ENV = uiManager
		uiManager.msg = "MESSAGE_ACTIVITY_9001531_UPDATE"
		uiManager.key = "updateUseItem"
		SoraDSendMessage(uiManager)
	end
end
function activity_9001531_Ctrl:reqExchange()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_BRIGHT_FIREWORKS_EXCHANGE, nil)
end
function activity_9001531_Ctrl:reqExchangeRsp(content)
	dump(content, "activity_9001531_Ctrl:reqExchangeRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData.cycleID = content.rspdata.cycleID
		self.initData.point = content.rspdata.point
		local rewards = content.rspdata.extra.rewards
		if rewards and next(rewards) then
			local rewardID = rewards[1].id
			_ENV = nil
			;(nil).itemID = rewardID
			uiManager:show("Activity_9001531_Reward1", nil)
		end
		_ENV = uiManager.show
		uiManager.show.msg = "MESSAGE_ACTIVITY_9001531_UPDATE"
		uiManager.show.key = "updateExchange"
		SoraDSendMessage(uiManager.show)
	end
end
function activity_9001531_Ctrl:getActivityID(...)
	return self.activityID
end
function activity_9001531_Ctrl:getCurStage(...)
	return self.initData.cycleID
end
function activity_9001531_Ctrl:getCurScore(...)
	return self.initData.point
end
function activity_9001531_Ctrl:getReceiveStatusAndNum(activityID)
	if self:checkUseItem() then
		return true, -1
	end
	if self:checkCanExchange() then
		return true, -1
	end
	return false
end
function activity_9001531_Ctrl:checkUseItem(...)
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local itemList = activity_9001531_Read.getUseItemList()
	for i, itemID in ipairs(itemList) do
		if backpackCtrl:getItemCount(itemID) > 0 then
			return i
		end
	end
end
function activity_9001531_Ctrl:checkCanExchange(...)
	local curStage = self:getCurStage()
	local curScore = self:getCurScore()
	local targetScore = activity_9001531_Read.getPointsByStage(curStage)
	if curScore >= targetScore then
		return true, -1
	end
end
function activity_9001531_Ctrl:getUseCount(itemID, itemCount)
	local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	itemCount = itemCount or backpackCtrl:getItemCount(itemID)
	local useMax = backpackltCtrl:getUseMax(itemID)
	local useCount = math.min(useMax, itemCount)
	return useCount
end
return activity_9001531_Ctrl
