local gamemodulec = include("GameModule")
local groupBuyCtrl = class("groupBuyCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local timerList = gModuleMgr.getObject("timerList")
function groupBuyCtrl:ctor(properties)
	groupBuyCtrl.super.ctor(self, properties)
	self:resetData()
end
function groupBuyCtrl:resetData()
	self.curPeople = 0
	self.goodID = 0
	self.goodCount = 0
	self.originalPrice = 0
	self.stall, _ENV, self.curPrice = nil, nil, 0
	self.queue, _ENV, self.curRoundState = gGroupBuyActivityState.CLOSE, gGroupBuyActivityState.CLOSE, gGroupBuyActivityState.CLOSE
	self.totalRound = 0
	self.curRound = 0
	self.nextGoodID = 0
	self.nextGoodCount = 0
	self.isBuy = false
end
function groupBuyCtrl:EnterGame()
	self:addEventListener(tostring(gGroupBuyActivityState.CLOSE), handler(self, self.activityCloseCallback))
	self:addEventListener(tostring(gGroupBuyActivityState.OPEN), handler(self, self.activityRunningCallback))
	msgCtrl.register(gCmd.CMD_GROUPBUY_MODULE, gCmd.REQ_GROUPBUY_INIT, handler(self, self.initActivityInfoRsp))
	msgCtrl.register(gCmd.CMD_GROUPBUY_MODULE, gCmd.REQ_GROUPBUY_BUY, handler(self, self.buyGoodRsp))
	self:registerNotify()
end
function groupBuyCtrl:Logout()
	groupBuyCtrl.super.Logout(self)
	self:resetData()
end
function groupBuyCtrl:activityCloseCallback(event)
	self:reqActivityInfo()
end
function groupBuyCtrl:activityRunningCallback(event)
	self:reqActivityInfo()
end
function groupBuyCtrl:addQueue(queuetype, starttime, totaltime, lefttime, data)
	local queuetype = tostring(queuetype)
	local curqueue = self:queryQueue(queuetype)
	if curqueue then
		self:removeQueue(queuetype)
	end
	local dispatchQueueEvent = function()
		queuetype = nil
		;(nil).name = queuetype
		local (nil).data, event = data, nil
		self:dispatchEvent(event)
		self.queue[queuetype] = nil
	end
	local _ENV, queue = self, self
	queue.qtype = queuetype
	queue.starttime = starttime
	queue.totaltime = totaltime
	local ok, node = timerList:createTimer(lefttime, timerHandler(dispatchQueueEvent))
	if ok then
		queue.timerNode = node
		self.queue[queuetype] = queue
	end
end
function groupBuyCtrl:removeQueue(queuetype)
	local queuetype = tostring(queuetype)
	local queue = self:queryQueue(queuetype)
	if queue then
		timerList:cancelTimer(queue.timerNode)
		self.queue[queuetype] = nil
	end
end
function groupBuyCtrl:queryQueue(queuetype)
	local ret = self.queue[tostring(queuetype)]
	if ret then
		return ret
	end
end
function groupBuyCtrl:isFinallyRound()
	if self.curRound > 0 and self.curRound == self.totalRound then
		return true
	else
		return false
	end
end
function groupBuyCtrl:reqActivityInfo(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_GROUPBUY_MODULE, gCmd.REQ_GROUPBUY_INIT, nil, ...)
end
function groupBuyCtrl:buyGood(goodid, ...)
	serverproxy = nil
	;(nil).goodid = goodid
	serverproxy:Request(gCmd.CMD_GROUPBUY_MODULE, gCmd.REQ_GROUPBUY_BUY, nil, ...)
end
function groupBuyCtrl:initActivityInfoRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		local retdata = content.data.retdata
		self:setGroupBuyData(retdata)
		self.isBuy = retdata.isBuy
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENTCENTER_GROUPBUY_REFRESH"
		SoraDSendMessage(self)
	else
		print("groupBuyCtrl:initActivityInfoRsp err=", err)
	end
end
function groupBuyCtrl:buyGoodRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		local data = content.data.retdata
		self:setGroupBuyData(data)
		self.isBuy = data.isBuy
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENTCENTER_GROUPBUY_REFRESH"
		self.redata = data
		SoraDSendMessage(self)
	else
		_ENV = SoraDSendMessage
		SoraDSendMessage.msg = "MESSAGE_SERVER_EVENTCENTER_GROUPBUY_REFRESH"
		SoraDSendMessage(SoraDSendMessage)
		print("groupBuyCtrl:buyGoodRsp err=", err)
	end
end
function groupBuyCtrl:setGroupBuyData(data)
	self.curPeople = data.curPeople
	self.goodID = data.goodID
	self.goodCount = data.goodCount
	self.originalPrice = data.originalPrice
	self.curPrice = data.curPrice
	self.stall = data.stall
	self.curRoundState = data.curRoundState
	self.nextGoodID = data.nextGoodID
	self.nextGoodCount = data.nextGoodCount
	self.totalRound = data.totalRound
	self.curRound = data.curRound
	local queue = data.queue[tostring(self.curRoundState)]
	if queue then
		local starttime = queue.starttime
		local totaltime = queue.totaltime
		local nowtime = serviceFunctions.systemTime()
		local lasttime = nowtime - starttime
		local lefttime = totaltime - lasttime
		if lefttime <= 0 then
			lefttime = 0
		end
		self:addQueue(tostring(self.curRoundState), starttime, totaltime, lefttime)
	end
end
function groupBuyCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.GROUPBUY, handler(self, self.updateActivityData))
end
function groupBuyCtrl:updateActivityData(event)
	local data = event.data
	for k, v in pairs(data) do
		self:setGroupBuyData(v)
	end
	_ENV = pairs(data)
	pairs(data).msg = "MESSAGE_SERVER_EVENTCENTER_GROUPBUY_REFRESH"
	SoraDSendMessage(pairs(data))
end
return groupBuyCtrl
