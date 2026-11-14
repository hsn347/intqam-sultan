local gamemodulec = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local petExchangeCtrl = class("petExchangeCtrl", gamemodulec)
local pet_exchange_ltCtrl = gModuleMgr.sharedMgr("petExchangeltCtrl")
local timerList = gModuleMgr.getObject("timerList")
function petExchangeCtrl:ctor(properties)
	petExchangeCtrl.super.ctor(self, properties)
	self.queue, petExchangeCtrl = petExchangeCtrl.super.ctor, petExchangeCtrl.super.ctor
	self:resetData()
end
function petExchangeCtrl:Logout()
	petExchangeCtrl.super.Logout(self)
	self:resetData()
end
function petExchangeCtrl:resetData()
	self.userData, _UPVALUE0_ = nil, nil
end
local timercallback = function()
end
function petExchangeCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_PET_EXCHANGE_MODULE, gCmd.REQ_PET_EXCHAGNE_INIT, handler(self, self.initRsp))
	msgCtrl.register(gCmd.CMD_PET_EXCHANGE_MODULE, gCmd.REQ_PET_EXCHANGE_EAGLE, handler(self, self.exchangeEagleRsp))
	msgCtrl.register(gCmd.CMD_PET_EXCHANGE_MODULE, gCmd.REQ_PET_EXCHANGE_NORMAL, handler(self, self.exchangeNormalRsp))
	msgCtrl.register(gCmd.CMD_PET_EXCHANGE_MODULE, gCmd.REQ_PET_EXCHANGE_RECOVERY, handler(self, self.exchangePointRsp))
	msgCtrl.register(gCmd.CMD_PET_EXCHANGE_MODULE, gCmd.REQ_PET_EXCHANGE_EAGLE_QUICK, handler(self, self.quickExchangeEagleRsp))
end
function petExchangeCtrl:initRsp(content)
	local data = content.data
	local err = content.err
	if err == gErrDef.Err_None then
		self.userData = content.userData
	else
	end
end
function petExchangeCtrl:reqEnterData()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_PET_EXCHANGE_MODULE, gCmd.REQ_PET_EXCHAGNE_INIT, data)
end
function petExchangeCtrl:reqEagleExchange(exchangeType, count)
	local serverproxy, data
	data.exchangeType = exchangeType
	data.count = count
	serverproxy:Request(gCmd.CMD_PET_EXCHANGE_MODULE, gCmd.REQ_PET_EXCHANGE_EAGLE, data)
end
function petExchangeCtrl:reqExchangeNormal(index, count)
	local serverproxy, data
	data.index = index
	data.count = count
	serverproxy:Request(gCmd.CMD_PET_EXCHANGE_MODULE, gCmd.REQ_PET_EXCHANGE_NORMAL, data)
end
function petExchangeCtrl:reqExchangePoint(itemType, count)
	local serverproxy, data
	data.itemType = itemType
	data.count = count
	serverproxy:Request(gCmd.CMD_PET_EXCHANGE_MODULE, gCmd.REQ_PET_EXCHANGE_RECOVERY, data)
end
function petExchangeCtrl:reqQuickExchangeEagle()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_PET_EXCHANGE_MODULE, gCmd.REQ_PET_EXCHANGE_EAGLE_QUICK, data)
end
function petExchangeCtrl:getUserData()
	if self.userData then
		return self.userData
	else
		_UPVALUE0_ = self.userData
		return self.userData
	end
end
function petExchangeCtrl:showUserData()
end
function petExchangeCtrl:exchangeEagleRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		if self.userData then
			self.userData.eagleExchangePoint = content.eagleExchangePoint
			self.userData.eagleExchangeGold = content.eagleExchangeGold
			self.userData.point = content.point
		end
		if content.count then
			_ENV, _UPVALUE1_ = content.point, content.count
			content.point.id = PET_EXCHANGE_DEBRIS
			content.point.count = content.count
			local content.count[1], showInfo = content.point, content.count
			SoraDMailGainItems(showInfo, true)
		else
		end
	end
	_ENV = SoraDMailGainItems
	SoraDMailGainItems.msg = "MESSAGE_SERVER_PET_EXCHANGE_EAGLE_BACK"
	SoraDMailGainItems.err = err
	SoraDSendMessage(SoraDMailGainItems)
end
function petExchangeCtrl:getCurrentPoint()
	if self.userData then
		return self.userData.point
	else
		return 0
	end
end
function petExchangeCtrl:getEagleExchangeTime(exchangeType)
	if self.userData then
		if exchangeType == gPetExchangeEagleType.POINT then
			return self.userData.eagleExchangePoint
		elseif exchangeType == gPetExchangeEagleType.GOLD then
			return self.userData.eagleExchangeGold
		else
			return 999999
		end
	else
		return 9999999
	end
end
function petExchangeCtrl:getEagleExchangeCost(exchangeType, times)
	times = times or 1
	if times == 0 then
		times = 1
	end
	local curTimes = self:getEagleExchangeTime(exchangeType)
	local totalcost = 0
	for i = 1, times do
		curTimes = curTimes + 1
		totalcost = totalcost + pet_exchange_ltCtrl:queryEagleExchangeCost(exchangeType, curTimes)
	end
	print("getEagleExchangeCost", times, totalcost)
	return totalcost
end
function petExchangeCtrl:getEagleMaxExchangeNum(exchangeType)
	local num = 0
	local totalcost = 0
	local petCtrl = gametop.playertop_:getModule("petCtrl")
	local petid = 1253
	local isUnlock = petCtrl:petIsAleadyUnlock(petid)
	if isUnlock then
		return num, totalcost
	end
	local canUnlock, tableUnlockData = petCtrl:petIsCanUnlock(petid)
	local count = 0
	if not canUnlock and tableUnlockData.debris.curDebrisCount < tableUnlockData.debris.needDebriscount then
		count = tableUnlockData.debris.needDebriscount - tableUnlockData.debris.curDebrisCount
	end
	local times = self:getEagleExchangeTime(exchangeType)
	local userPoint = self:getUserData().point or 0
	for i = 1, count do
		num = num + 1
		times = times + 1
		local curCost = pet_exchange_ltCtrl:queryEagleExchangeCost(exchangeType, times)
		totalcost = totalcost + curCost
		if exchangeType == gPetExchangeEagleType.POINT and userPoint < totalcost then
			num = num - 1
			totalcost = totalcost - curCost
			break
		end
	end
	return num, totalcost
end
function petExchangeCtrl:getNormalMaxExchangeNum(index)
	local userPoint = self:getUserData().point or 0
	local cost = 9999999
	local hasRet, iteminfo = pet_exchange_ltCtrl:queryItemExchange(index)
	if hasRet then
		cost = iteminfo.Point
	end
	return math.floor(userPoint / cost)
end
function petExchangeCtrl:isCanExchangEagle()
	local petCtrl = gametop.playertop_:getModule("petCtrl")
	local petid = 1253
	local isUnlock = petCtrl:petIsAleadyUnlock(petid)
	if isUnlock then
		return false
	end
	local canUnlock, tableUnlockData = petCtrl:petIsCanUnlock(petid)
	if canUnlock then
		return false, tableUnlockData, true
	end
	local retFlag = true
	if tableUnlockData.castlelv and not tableUnlockData.castlelv.isreach then
		retFlag = false
	end
	if tableUnlockData.lordlv and not tableUnlockData.lordlv.isreach then
		retFlag = false
	end
	if tableUnlockData.kill and not tableUnlockData.kill.isreach then
		retFlag = false
	end
	local debrisFlag = false
	if tableUnlockData.debris and tableUnlockData.debris.isreach then
		debrisFlag = true
	end
	print("isCanExchangEagle@@@", retFlag)
	return retFlag, tableUnlockData, debrisFlag
end
function petExchangeCtrl:getQuickExchangeCost()
	local petCtrl = gametop.playertop_:getModule("petCtrl")
	local petid = 1253
	local isUnlock = petCtrl:petIsAleadyUnlock(petid)
	if isUnlock then
		return 0
	end
	local canUnlock, tableUnlockData = petCtrl:petIsCanUnlock(petid)
	local count = 0
	if not canUnlock and tableUnlockData.debris.curDebrisCount < tableUnlockData.debris.needDebriscount then
		count = tableUnlockData.debris.needDebriscount - tableUnlockData.debris.curDebrisCount
	end
	local times = self:getEagleExchangeTime(gPetExchangeEagleType.GOLD)
	local totalcost = 0
	for i = 1, count do
		times = times + 1
		totalcost = totalcost + pet_exchange_ltCtrl:queryEagleExchangeCost(gPetExchangeEagleType.GOLD, times)
	end
	print("petExchangeCtrl:getQuickExchangeCost()", totalcost, count, times)
	local discountCost = math.floor(totalcost * PET_EXCHANGE_DISCOUNT / 1000)
	return totalcost, discountCost
end
function petExchangeCtrl:exchangeNormalRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		local point = content.point
		if self.userData then
			self.userData.point = point
		end
		if content.reward then
			SoraDMailGainItems(content.reward, true)
		end
	else
	end
	_ENV = SoraDMailGainItems
	SoraDMailGainItems.msg = "MESSAGE_SERVER_PET_NORMAL_EXCHANGE_BACK"
	SoraDMailGainItems.err = err
	SoraDSendMessage(SoraDMailGainItems)
end
function petExchangeCtrl:exchangePointRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		local point = content.point
		if self.userData then
			self.userData.point = point
		end
	else
	end
	_ENV = self.userData
	self.userData.msg = "MESSAGE_SERVER_PET_RECLAIM_BACK"
	self.userData.err = err
	SoraDSendMessage(self.userData)
end
function petExchangeCtrl:quickExchangeEagleRsp(content)
	local err = content.err
	if err == gErrDef.Err_None then
		if self.userData then
			self.userData.perfectBuy = content.perfectBuy
		end
		if content.count then
			_ENV, _UPVALUE1_ = content.perfectBuy, content.count
			content.perfectBuy.id = PET_EXCHANGE_DEBRIS
			content.perfectBuy.count = content.count
			local content.count[1], showInfo = content.perfectBuy, content.count
			SoraDMailGainItems(showInfo, true)
		end
		_ENV = SoraDMailGainItems
		SoraDMailGainItems.msg = "MESSAGE_SERVER_PET_UPDATE_EXCHANGE_AREA"
		SoraDSendMessage(SoraDMailGainItems)
	else
	end
	_ENV = SoraDMailGainItems
	SoraDMailGainItems.msg = "MESSAGE_SERVER_PET_ONKEY_BACK"
	SoraDMailGainItems.err = err
	SoraDSendMessage(SoraDMailGainItems)
end
function petExchangeCtrl:initClientData(retdata)
	if not retdata then
		retdata, _UPVALUE0_ = nil, nil
	end
	self.userData = retdata.userData
	self:registerNotify()
end
function petExchangeCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.PET_EXCHANGE, handler(self, self.notifyUpdate))
end
function petExchangeCtrl:addQueue(queuetype, starttime, totaltime, lefttime, data)
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
function petExchangeCtrl:removeQueue(queuetype)
	local queuetype = tostring(queuetype)
	local queue = self:queryQueue(queuetype)
	if queue then
		timerList:cancelTimer(queue.timerNode)
		self.queue[queuetype] = nil
	end
end
function petExchangeCtrl:queryQueue(queuetype)
	local ret = self.queue[tostring(queuetype)]
	if ret then
		return ret
	end
end
function petExchangeCtrl:notifyUpdate(event)
	local notifydata = event.data
	local bUpdateUserData = false
	for k, data in pairs(notifydata) do
		if data.userData then
			self.userData = data.userData
			bUpdateUserData = true
		end
	end
	if bUpdateUserData then
		_ENV = pairs(notifydata)
		pairs(notifydata).msg = "MESSAGE_SERVER_PET_UPDATE_EXCHANGE_AREA"
		SoraDSendMessage(pairs(notifydata))
	end
end
function petExchangeCtrl:getPerfectButCount()
	if self.userData then
		return self.userData.perfectBuy
	else
		return 0
	end
end
return petExchangeCtrl
