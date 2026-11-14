local GameModule = include("GameModule")
local newFeedbackWeekCtrl = class("newFeedbackWeekCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local newFeedbackWeekRead = include("newFeedbackWeekRead")
_ENV = "newFeedbackWeekRead"
;("newFeedbackWeekRead").noClaim = 1
;("newFeedbackWeekRead").noReach = 2
local ("newFeedbackWeekRead").claimed, giftStatus = 3, "newFeedbackWeekRead"
function newFeedbackWeekCtrl:ctor(properties)
	newFeedbackWeekCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.RECHARGE_NEW_USER
	self:resetData()
end
function newFeedbackWeekCtrl:Logout()
	self:endTime()
	newFeedbackWeekCtrl.super.Logout(self)
end
function newFeedbackWeekCtrl:resetData()
	self.localTaskConfig, _UPVALUE0_ = nil, nil
	self.Refresh = false
	self.Reset = false
	self.receivesData, _UPVALUE0_, self.totalPrice = nil, nil, 0
	self.nextResetTime = 0
	self.lastrestTime = 0
	self.isBoxClicked = false
end
function newFeedbackWeekCtrl:EnterGame()
	self:initLocalData()
	msgCtrl.register(gCmd.CMD_NEW_KING_RECHARGE_MODULE, gCmd.NEW_KING_RECHARGE_INIT, handler(self, self.getInitData))
	msgCtrl.register(gCmd.CMD_NEW_KING_RECHARGE_MODULE, gCmd.NEW_KING_RECHARGE_CLAIM_REWARD, handler(self, self.getClaimReward))
end
function newFeedbackWeekCtrl:beginTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self:updateTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function newFeedbackWeekCtrl:updateTime()
	_ENV = nil
	;(nil).byUID = true
	local tab = SoraDConfigGet("Game:newFeedbackWeekView:isRefresh~table", nil)
	if (serviceFunctions.systemTime() - tab[1]) % 86400 > 0 and serviceFunctions.systemTime() ~= self.lastrestTime and tab[1] ~= self:getLatestPoint() and tab[1] ~= 0 then
		self.Refresh = true
		_ENV = self:getLatestPoint()
		self:getLatestPoint().msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self:getLatestPoint().eventID = self.activityID
		SoraDSendMessage((self:getLatestPoint()))
	end
	if 86400 < serviceFunctions.systemTime() - self.lastrestTime and tab[1] == 0 then
		self.Refresh = true
		_ENV = self.lastrestTime
		self.lastrestTime.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.lastrestTime.eventID = self.activityID
		SoraDSendMessage(self.lastrestTime)
	end
	if self.lastrestTime ~= tab[2] and tab[2] ~= 0 then
		self.Reset = true
		_ENV = tab[2]
		tab[2].msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		tab[2].eventID = self.activityID
		SoraDSendMessage(tab[2])
	end
	if (serviceFunctions.systemTime() - self.lastrestTime) % 86400 == 0 and serviceFunctions.systemTime() ~= self.lastrestTime then
		self.Refresh = true
		_ENV = self.lastrestTime
		self.lastrestTime.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.lastrestTime.eventID = self.activityID
		SoraDSendMessage(self.lastrestTime)
	end
	if serviceFunctions.systemTime() == self.nextResetTime then
		self.Reset = true
		self.lastrestTime = self.nextResetTime
		self.nextResetTime = self.nextResetTime + 604800
		_ENV = self.nextResetTime
		self.nextResetTime.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.nextResetTime.eventID = self.activityID
		SoraDSendMessage(self.nextResetTime)
	end
end
function newFeedbackWeekCtrl:endTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
end
function newFeedbackWeekCtrl:initLocalData()
	self.localTaskConfig = newFeedbackWeekRead.getTaskConfig()
end
function newFeedbackWeekCtrl:getTaskData()
	return self.localTaskConfig
end
function newFeedbackWeekCtrl:getTotalPrice()
	return self.totalPrice
end
function newFeedbackWeekCtrl:getNextResetTime()
	return self.nextResetTime
end
function newFeedbackWeekCtrl:getReceiveStatusAndNum()
	local bAward = false
	local num = 0
	for k, v in ipairs(self.localTaskConfig) do
		if v.status == giftStatus.noClaim then
			num = num + 1
		end
	end
	if self:getBigRewardStatus() == giftStatus.noClaim then
		num = num + 1
	end
	bAward = 0 < num and true or false
	if self.Refresh then
		bAward = true
		num = num + 1
		_ENV = ipairs(self.localTaskConfig)
		ipairs(self.localTaskConfig).byUID = true
		local tab = SoraDConfigGet("Game:newFeedbackWeekView:isRefresh~table", ipairs(self.localTaskConfig))
		tab[1] = self:getLatestPoint()
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:newFeedbackWeekView:isRefresh~table", tab, nil)
	end
	if self.Reset then
		_ENV = "Game:newFeedbackWeekView:isRefresh~table"
		;("Game:newFeedbackWeekView:isRefresh~table").byUID = true
		local tab = SoraDConfigGet("Game:newFeedbackWeekView:isRefresh~table", "Game:newFeedbackWeekView:isRefresh~table")
		tab[2] = self.lastrestTime
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:newFeedbackWeekView:isRefresh~table", tab, nil)
		bAward = true
		num = 1
	end
	return bAward, num
end
function newFeedbackWeekCtrl:getLatestPoint()
	return serviceFunctions.systemTime() - (serviceFunctions.systemTime() - self.lastrestTime) % 86400
end
function newFeedbackWeekCtrl:initClientData(data)
	if clientEventMgr.judgeIsOpen(self.activityID) then
		self:reqInitData()
		self:registerNotify()
	end
end
function newFeedbackWeekCtrl:isReciveById(id)
	for k, v in pairs(self.receivesData) do
		if tonumber(k) == id then
			return true
		end
	end
	return false
end
function newFeedbackWeekCtrl:getBigRewardStatus()
	if self:isReciveById(newFeedbackWeekRead.getBigRewardId()) then
		return giftStatus.claimed
	end
	if self.totalPrice < newFeedbackWeekRead.getBiggestQuota() then
		return giftStatus.noReach
	elseif self.totalPrice >= newFeedbackWeekRead.getBiggestQuota() then
		return giftStatus.noClaim
	end
end
function newFeedbackWeekCtrl:changeStatus()
	for k, v in ipairs(self.localTaskConfig) do
		self.localTaskConfig[k].status = giftStatus.noReach
		if v.amount <= self.totalPrice then
			self.localTaskConfig[k].status = giftStatus.noClaim
			if self:isReciveById(v.taskID) then
				self.localTaskConfig[k].status = giftStatus.claimed
			end
		end
	end
	table.sort(self.localTaskConfig, function(a, b)
		if a.status ~= b.status then
			return a.status < b.status
		end
		return a.taskID < b.taskID
	end)
end
function newFeedbackWeekCtrl:resetRed()
	local oldRefresh = self.Refresh
	local oldReset = self.Reset
	self.Refresh = false
	self.Reset = false
	if oldRefresh or oldReset then
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		;(nil).eventID = self.activityID
		SoraDSendMessage(nil)
	end
end
function newFeedbackWeekCtrl:boxClicked()
	self.isBoxClicked = true
end
function newFeedbackWeekCtrl:getIsBoxClicked()
	return self.isBoxClicked
end
function newFeedbackWeekCtrl:reqInitData()
	serverproxy:Request(gCmd.CMD_NEW_KING_RECHARGE_MODULE, gCmd.NEW_KING_RECHARGE_INIT)
end
function newFeedbackWeekCtrl:reqClaimReward(taskID)
	serverproxy = nil
	local (nil).index, data = taskID, nil
	serverproxy:Request(gCmd.CMD_NEW_KING_RECHARGE_MODULE, gCmd.NEW_KING_RECHARGE_CLAIM_REWARD, data)
end
function newFeedbackWeekCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.NEW_KING_RECHARGE, handler(self, self.notifyHandler))
end
function newFeedbackWeekCtrl:notifyHandler(event)
	local notifydata = event.data
	for k, v in ipairs(notifydata) do
		if v.price and v.price > 0 then
			self.totalPrice = v.price
		end
		if v.receive then
			self.receivesData = v.receive
		end
	end
	self:changeStatus()
	_ENV = self
	self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	self.eventID = self.activityID
	SoraDSendMessage(self)
	_ENV = self
	self.msg = "MESSAGE_NEW_KING_RECHARGE_CHANGE"
	SoraDSendMessage(self)
end
function newFeedbackWeekCtrl:getInitData(content)
	if content.err == gErrDef.Err_None then
		self.totalPrice = content.rspdata.price
		self.receivesData = content.rspdata.receives
		self.lastrestTime = content.rspdata.resetTime
		self.nextResetTime = content.rspdata.resetTime + 604800
		self:changeStatus()
		self:beginTime()
		_ENV = self
		self.msg = "MESSAGE_NEW_KING_RECHARGE_INIT"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.eventID = self.activityID
		SoraDSendMessage(self)
	elseif content.err == gErrDef.Err_NEW_RECHARGE_NOT_OPEN then
		_ENV = gErrDef.Err_NEW_RECHARGE_NOT_OPEN
		gErrDef.Err_NEW_RECHARGE_NOT_OPEN.msg = "MESSAGE_NEW_KING_RECHARGE_ERR"
		SoraDSendMessage(gErrDef.Err_NEW_RECHARGE_NOT_OPEN)
	end
end
function newFeedbackWeekCtrl:getClaimReward(data)
	if data.err == gErrDef.Err_None then
		local rewarddata = data.rspdata.reward
		self:reqInitData()
		_ENV = self
		self.msg = "MESSAGE_NEW_KING_RECHARGE_CLAIM_REWARD"
		self.data = rewarddata
		SoraDSendMessage(self)
	end
end
return newFeedbackWeekCtrl
