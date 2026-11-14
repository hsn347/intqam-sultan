local gamemodulec = include("GameModule")
local resurrectionCtrl = class("resurrectionCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local timerList = gModuleMgr.getObject("timerList")
function resurrectionCtrl:ctor(properties)
	resurrectionCtrl.super.ctor(self, properties)
	self:resetData()
end
function resurrectionCtrl:resetData()
	_ENV = nil
	;(nil).resurrectionArmy, _ENV, (nil).deadSource, _ENV, (nil).deadArmy, _ENV, (nil).index = nil, nil, nil, nil, nil, nil, 0
	;(nil).state = gResurrectionActivityState.CLOSE
	;(nil).basecount = 0
	;(nil).starttime = 0
	;(nil).needitem, _ENV, (nil).endtime = gResurrectionActivityState.CLOSE, gResurrectionActivityState.CLOSE, 0
	self.queue, _ENV, self.resurrectiondata, (nil).rate = nil, nil, nil, 0
end
function resurrectionCtrl:EnterGame()
	self:addEventListener(tostring(gResurrectionActivityState.OPEN), handler(self, self.openTimeQueueCallBack))
	msgCtrl.register(gCmd.CMD_RESURRECTION_MODULE, gCmd.REQ_RESURRECTON, handler(self, self.resurrectionRsp))
	msgCtrl.register(gCmd.CMD_RESURRECTION_MODULE, gCmd.REQ_GET_RESURRECTION_DATA, handler(self, self.getResurrectionDataRsp))
	msgCtrl.register(gCmd.CMD_RESURRECTION_MODULE, gCmd.REQ_QUICK_RESURRECTON, handler(self, self.quickResurrectionRsp))
end
function resurrectionCtrl:Logout()
	resurrectionCtrl.super.Logout(self)
	self:resetData()
end
function resurrectionCtrl:addQueue(queuetype, starttime, totaltime, lefttime, data)
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
function resurrectionCtrl:removeQueue(queuetype)
	local queuetype = tostring(queuetype)
	local queue = self:queryQueue(queuetype)
	if queue then
		timerList:cancelTimer(queue.timerNode)
		self.queue[queuetype] = nil
	end
end
function resurrectionCtrl:queryQueue(queuetype)
	return self.queue[tostring(queuetype)]
end
function resurrectionCtrl:openTimeQueueCallBack(event)
	self:getResurrectionData()
end
function resurrectionCtrl:initClientData(data)
	self:setClientData(data)
	self:registerNotify()
end
function resurrectionCtrl:setClientData(data)
	self.resurrectiondata.index = data.index
	self.resurrectiondata.deadArmy = data.deadArmy
	self.resurrectiondata.deadSource = data.deadSource
	self.resurrectiondata.resurrectionArmy = data.resurrectionArmy
	self.resurrectiondata.state = data.state
	self.resurrectiondata.basecount = data.basecount or 0
	if self.resurrectiondata.state == gResurrectionActivityState.OPEN then
		self.resurrectiondata.needitem = data.needitem
		self.resurrectiondata.rate = data.rate
		local starttime = data.starttime
		local totaltime = data.totaltime
		local curtime = serviceFunctions.systemTime()
		local lasttime = curtime - starttime
		local lefttime = totaltime - lasttime
		if lefttime < 0 then
			lefttime = 0
		end
		self:addQueue(self.resurrectiondata.state, starttime, totaltime, lefttime)
	end
end
function resurrectionCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_city_notify = notifyCtrl:register(gNotifyID.RESURRECTION, handler(self, self.updateData))
end
function resurrectionCtrl:updateData(event)
	local data = event.data
	for k, v in pairs(data) do
		self:setClientData(v)
	end
end
function resurrectionCtrl:getOpenLefttime()
	local lefttime = 0
	if self:getResurrectionState() == gResurrectionActivityState.OPEN then
		local queue = self:queryQueue(gResurrectionActivityState.OPEN)
		if queue and queue.timerNode then
			lefttime = queue.timerNode.timer:getRemainTime()
		end
	end
	return lefttime
end
function resurrectionCtrl:getResurrectionState()
	return self.resurrectiondata.state
end
function resurrectionCtrl:getResurrectionNeedItem()
	return self.resurrectiondata.needitem
end
function resurrectionCtrl:getResurrectionRate()
	return self.resurrectiondata.rate
end
function resurrectionCtrl:getDeadArmy()
	return self.resurrectiondata.deadArmy
end
function resurrectionCtrl:getResurrectionArmy()
	return self.resurrectiondata.resurrectionArmy
end
function resurrectionCtrl:getResurrectionHistory()
	local _ENV, ret
	local _ENV, data
	for k, v in pairs(self:getDeadArmy()) do
		_ENV = self:getDeadArmy()
		self:getDeadArmy().id = tonumber(k)
		self:getDeadArmy().dead = v
		self:getDeadArmy().wait = 0
		table.insert(ret, self:getDeadArmy())
		data[k] = #ret
	end
	for k, v in pairs(self:getResurrectionArmy()) do
		if data[k] then
			ret[data[k]].wait = v
		else
			_ENV = self:getResurrectionArmy()
			self:getResurrectionArmy().id = tonumber(k)
			self:getResurrectionArmy().dead = 0
			self:getResurrectionArmy().wait = v
			table.insert(ret, self:getResurrectionArmy())
		end
	end
	return ret
end
function resurrectionCtrl:getDeadArmySource()
	return self.resurrectiondata.deadSource
end
function resurrectionCtrl:getResurrectionArmyCount()
	local ret = 0
	for k, v in pairs(self:getResurrectionArmy()) do
		ret = ret + v
	end
	return ret
end
function resurrectionCtrl:getTotalArmy()
	local ret = 0
	for k, v in pairs(self:getDeadArmy()) do
		ret = ret + v
	end
	for k, v in pairs(self:getResurrectionArmy()) do
		ret = ret + v
	end
	return ret
end
function resurrectionCtrl:getUnResurrectionArmyCount()
	local ret = 0
	for k, v in pairs(self.resurrectiondata.deadArmy) do
		ret = ret + v
	end
	return ret
end
function resurrectionCtrl:getNextResurrectionArmyCount()
	local resurrectionCount = math.ceil(self.resurrectiondata.rate * self:getTotalArmy())
	return resurrectionCount
end
function resurrectionCtrl:getResurrectionArmyBaseCount()
	return self.resurrectiondata.basecount
end
function resurrectionCtrl:getQuickResurrectionInfo()
	local resurrectionltCtrl = include("resurrectionltCtrl")
	local curIndex = self.resurrectiondata.index
	local unResurrectionCount = self:getUnResurrectionArmyCount()
	local totalDeadCount = self:getTotalArmy()
	local retIndex = resurrectionltCtrl.getFinalResurrectionIndex(curIndex, unResurrectionCount, totalDeadCount, self.resurrectiondata.basecount)
	local isQuick = false
	local needGood = 0
	local rate = 0
	local basecount = 0
	local resurrectionCount = 0
	if curIndex < retIndex then
		isQuick = true
		for i = curIndex + 1, retIndex do
			local needitem = resurrectionltCtrl.getNeedItem(i)
			needGood = needGood + needitem[1].count
			rate = rate + resurrectionltCtrl.getResurgenceRate(i)
			basecount = basecount + self:getResurrectionArmyBaseCount()
		end
		resurrectionCount = math.ceil(rate * totalDeadCount) + basecount
		if unResurrectionCount < resurrectionCount then
			resurrectionCount = unResurrectionCount
		end
	end
	_ENV = math.ceil(rate * totalDeadCount)
	math.ceil(rate * totalDeadCount).ok = isQuick
	math.ceil(rate * totalDeadCount).needGood = needGood
	math.ceil(rate * totalDeadCount).rate = rate
	math.ceil(rate * totalDeadCount).basecount = basecount
	math.ceil(rate * totalDeadCount).retIndex = retIndex
	local math.ceil(rate * totalDeadCount).resurrectionCount, ret = resurrectionCount, math.ceil(rate * totalDeadCount)
	return ret
end
function resurrectionCtrl:reqResurrection(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_RESURRECTION_MODULE, gCmd.REQ_RESURRECTON, nil, ...)
end
function resurrectionCtrl:resurrectionRsp(content)
	local err = content.err
	print("resurrectionCtrl:resurrectionRsp err", err)
	if err == gErrDef.Err_None then
		local retdata = content.data.retdata
		local newdata = retdata.newdata
		local _ENV, ret = err, err
		self:setClientData(newdata)
		for k, v in pairs(retdata.resurrection) do
			_ENV = nil
			;(nil).id = tonumber(k)
			;(nil).num = v
			table.insert(ret, nil)
		end
		_ENV = pairs(retdata.resurrection)
		pairs(retdata.resurrection).msg = "MESSAGE_RESURGENCE_ARMY"
		pairs(retdata.resurrection).err = err
		pairs(retdata.resurrection).redata = ret
		SoraDSendMessage(pairs(retdata.resurrection))
	else
		_ENV = retdata.newdata
		retdata.newdata.msg = "MESSAGE_RESURGENCE_ARMY"
		retdata.newdata.err = err
		SoraDSendMessage(retdata.newdata)
	end
end
function resurrectionCtrl:getResurrectionData(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_RESURRECTION_MODULE, gCmd.REQ_GET_RESURRECTION_DATA, nil, ...)
end
function resurrectionCtrl:getResurrectionDataRsp(content)
	local err = content.err
	print("resurrectionCtrl:resurrectionRsp err", err)
	if err == gErrDef.Err_None then
		local retdata = content.data.retdata
		self:setClientData(retdata)
		_ENV = self
		self.msg = "MESSAGE_RESURGENCE_TREE_STATE_CHANGE"
		SoraDSendMessage(self)
	else
	end
end
function resurrectionCtrl:reqQuickResurrection(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_RESURRECTION_MODULE, gCmd.REQ_QUICK_RESURRECTON, nil, ...)
end
function resurrectionCtrl:quickResurrectionRsp(content)
	local err = content.err
	print("resurrectionCtrl:quickResurrectionRsp err", err)
	if err == gErrDef.Err_None then
		local retdata = content.data.retdata
		local newdata = retdata.newdata
		local _ENV, ret = err, err
		self:setClientData(newdata)
		for k, v in pairs(retdata.resurrection) do
			_ENV = nil
			;(nil).id = tonumber(k)
			;(nil).num = v
			table.insert(ret, nil)
		end
		_ENV = pairs(retdata.resurrection)
		pairs(retdata.resurrection).msg = "MESSAGE_RESURGENCE_ARMY"
		pairs(retdata.resurrection).err = err
		pairs(retdata.resurrection).redata = ret
		SoraDSendMessage(pairs(retdata.resurrection))
	else
		_ENV = retdata.newdata
		retdata.newdata.msg = "MESSAGE_RESURGENCE_ARMY"
		retdata.newdata.err = err
		SoraDSendMessage(retdata.newdata)
	end
end
function resurrectionCtrl:getDeadArmyCount(armyType)
	local armyCount = 0
	if "table" == type(self.resurrectiondata.deadArmy) then
		local armyltCtrl = include("armyltCtrl")
		for _armyid, _armycount in pairs(self.resurrectiondata.deadArmy) do
			local armyid = tonumber(_armyid)
			if armyid and armyltCtrl.getSoldierType(armyid) == armyType then
				armyCount = armyCount + tonumber(_armycount)
			end
		end
	end
	return armyCount
end
return resurrectionCtrl
