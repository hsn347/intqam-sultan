local gamemodulec = include("GameModule")
local lifeWaterCtrl = class("lifeWaterCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local timerList = gModuleMgr.getObject("timerList")
function lifeWaterCtrl:ctor(properties)
	lifeWaterCtrl.super.ctor(self, properties)
	self:resetData()
end
function lifeWaterCtrl:resetData()
	_ENV = nil
	;(nil).resurrectionArmy, _ENV, (nil).deadSource, _ENV, (nil).deadArmy, _ENV, (nil).index = nil, nil, nil, nil, nil, nil, 0
	;(nil).state = gLifeWaterActivityState.CLOSE
	;(nil).basecount = 0
	;(nil).starttime = 0
	;(nil).needitem, _ENV, (nil).endtime = gLifeWaterActivityState.CLOSE, gLifeWaterActivityState.CLOSE, 0
	;(nil).rate = 0
	self.queue, _ENV, self.resurrectiondata, (nil).hospitalSwitch = nil, nil, nil, false
end
function lifeWaterCtrl:EnterGame()
	self:addEventListener(tostring(gLifeWaterActivityState.OPEN), handler(self, self.openTimeQueueCallBack))
	msgCtrl.register(gCmd.CMD_LIFE_WATER_MODULE, gCmd.REQ_REVIVE, handler(self, self.resurrectionRsp))
	msgCtrl.register(gCmd.CMD_LIFE_WATER_MODULE, gCmd.REQ_GET_REVIVE_DATA, handler(self, self.getResurrectionDataRsp))
	msgCtrl.register(gCmd.CMD_LIFE_WATER_MODULE, gCmd.REQ_QUICK_REVIVE, handler(self, self.quickResurrectionRsp))
	msgCtrl.register(gCmd.CMD_LIFE_WATER_MODULE, gCmd.REQ_KW_HOSPITAL_SWITCH, handler(self, self.kwHospitalSwitchRsp))
end
function lifeWaterCtrl:Logout()
	lifeWaterCtrl.super.Logout(self)
	self:resetData()
end
function lifeWaterCtrl:addQueue(queuetype, starttime, totaltime, lefttime, data)
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
function lifeWaterCtrl:removeQueue(queuetype)
	local queuetype = tostring(queuetype)
	local queue = self:queryQueue(queuetype)
	if queue then
		timerList:cancelTimer(queue.timerNode)
		self.queue[queuetype] = nil
	end
end
function lifeWaterCtrl:queryQueue(queuetype)
	return self.queue[tostring(queuetype)]
end
function lifeWaterCtrl:openTimeQueueCallBack(event)
	self:getResurrectionData()
end
function lifeWaterCtrl:initClientData(data)
	self:setClientData(data)
	self:registerNotify()
end
function lifeWaterCtrl:setClientData(data)
	dump(data, "lifeWaterCtrl:initClientData", 10)
	self.resurrectiondata.index = data.index
	self.resurrectiondata.deadArmy = data.deadArmy
	if not data.deadSource then
		_ENV = data.deadSource
	end
	self.resurrectiondata.deadSource = data.deadSource
	self.resurrectiondata.resurrectionArmy = data.resurrectionArmy
	self.resurrectiondata.state = data.state
	self.resurrectiondata.basecount = data.basecount or 0
	self.resurrectiondata.hospitalSwitch = data.hospitalSwitch or false
	if self.resurrectiondata.state == gLifeWaterActivityState.OPEN then
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
function lifeWaterCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_city_notify = notifyCtrl:register(gNotifyID.LIFE_WATER, handler(self, self.updateData))
end
function lifeWaterCtrl:updateData(event)
	local data = event.data
	for k, v in pairs(data) do
		self:setClientData(v)
	end
	_ENV = pairs(data)
	pairs(data).msg = "MESSAGE_MAINCITYVIEW_UPDATE_RESURRECTION_HALL_VIEW"
	SoraDSendMessage(pairs(data))
end
function lifeWaterCtrl:getOpenLefttime()
	local lefttime = 0
	if self:getResurrectionState() == gLifeWaterActivityState.OPEN then
		local queue = self:queryQueue(gLifeWaterActivityState.OPEN)
		if queue and queue.timerNode then
			lefttime = queue.timerNode.timer:getRemainTime()
		end
	end
	return lefttime
end
function lifeWaterCtrl:getResurrectionState()
	return self.resurrectiondata.state
end
function lifeWaterCtrl:getResurrectionNeedItem()
	return self.resurrectiondata.needitem
end
function lifeWaterCtrl:getResurrectionRate()
	return self.resurrectiondata.rate
end
function lifeWaterCtrl:getDeadArmy()
	return self.resurrectiondata.deadArmy
end
function lifeWaterCtrl:getResurrectionArmy()
	return self.resurrectiondata.resurrectionArmy
end
function lifeWaterCtrl:getResurrectionHistory()
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
function lifeWaterCtrl:getDeadArmySource()
	return self.resurrectiondata.deadSource
end
function lifeWaterCtrl:getResurrectionArmyCount()
	local ret = 0
	for k, v in pairs(self:getResurrectionArmy()) do
		ret = ret + v
	end
	return ret
end
function lifeWaterCtrl:getTotalArmy()
	local ret = 0
	for k, v in pairs(self:getDeadArmy()) do
		ret = ret + v
	end
	for k, v in pairs(self:getResurrectionArmy()) do
		ret = ret + v
	end
	return ret
end
function lifeWaterCtrl:getUnResurrectionArmyCount()
	local ret = 0
	for k, v in pairs(self.resurrectiondata.deadArmy) do
		ret = ret + v
	end
	return ret
end
function lifeWaterCtrl:getNextResurrectionArmyCount()
	local resurrectionCount = math.ceil(self.resurrectiondata.rate * self:getTotalArmy())
	return resurrectionCount
end
function lifeWaterCtrl:getResurrectionArmyBaseCount()
	return self.resurrectiondata.basecount
end
function lifeWaterCtrl:getQuickResurrectionInfo()
	local lifeWaterltCtrl = include("lifeWaterltCtrl")
	local curIndex = self.resurrectiondata.index
	local unResurrectionCount = self:getUnResurrectionArmyCount()
	local totalDeadCount = self:getTotalArmy()
	local baseVal = self:getResurrectionArmyBaseCount()
	local retIndex = lifeWaterltCtrl.getFinalResurrectionIndex(curIndex, unResurrectionCount, totalDeadCount, baseVal)
	local isQuick = false
	local needGood = 0
	local rate = 0
	local basecount = 0
	local resurrectionCount = 0
	if curIndex < retIndex then
		isQuick = true
		for i = curIndex + 1, retIndex do
			local needitem = lifeWaterltCtrl.getNeedItem(i)
			needGood = needGood + needitem[1].count
			rate = rate + lifeWaterltCtrl.getResurgenceRate(i)
			basecount = basecount + baseVal
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
function lifeWaterCtrl:reqResurrection(...)
	SoraDShowLoading()
	_ENV = nil
	serverproxy:Request(gCmd.CMD_LIFE_WATER_MODULE, gCmd.REQ_REVIVE, nil, ...)
end
function lifeWaterCtrl:resurrectionRsp(content)
	SoraDCloseLoading()
	local err = content.err
	print("lifeWaterCtrl:resurrectionRsp err", err)
	if err == gErrDef.Err_None then
		local retdata = content.data.retdata
		local newdata = retdata.newdata
		self:setClientData(newdata)
		local _ENV, ret = self.setClientData, self.setClientData
		for k, v in pairs(retdata.resurrection) do
			_ENV = nil
			;(nil).id = tonumber(k)
			;(nil).num = v
			table.insert(ret, nil)
		end
		_ENV = pairs(retdata.resurrection)
		pairs(retdata.resurrection).msg = "MESSAGE_SPRINGS_RESURGENCE_ARMY"
		pairs(retdata.resurrection).err = err
		pairs(retdata.resurrection).redata = ret
		SoraDSendMessage(pairs(retdata.resurrection))
	else
		_ENV = retdata.newdata
		retdata.newdata.msg = "MESSAGE_SPRINGS_RESURGENCE_ARMY"
		retdata.newdata.err = err
		SoraDSendMessage(retdata.newdata)
	end
end
function lifeWaterCtrl:getResurrectionData(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_LIFE_WATER_MODULE, gCmd.REQ_GET_REVIVE_DATA, nil, ...)
end
function lifeWaterCtrl:getResurrectionDataRsp(content)
	local err = content.err
	print("lifeWaterCtrl:resurrectionRsp err", err)
	if err == gErrDef.Err_None then
		local retdata = content.data.retdata
		self:setClientData(retdata)
		_ENV = self
		self.msg = "MESSAGE_SPRINGS_RESURGENCE_STATE_CHANGE"
		SoraDSendMessage(self)
	end
end
function lifeWaterCtrl:reqQuickResurrection(...)
	SoraDShowLoading()
	_ENV = nil
	serverproxy:Request(gCmd.CMD_LIFE_WATER_MODULE, gCmd.REQ_QUICK_REVIVE, nil, ...)
end
function lifeWaterCtrl:reqKWHospitalSwitch(switch)
	serverproxy = nil
	;(nil).switch = switch
	serverproxy:Request(gCmd.CMD_LIFE_WATER_MODULE, gCmd.REQ_KW_HOSPITAL_SWITCH, nil)
end
function lifeWaterCtrl:quickResurrectionRsp(content)
	SoraDCloseLoading()
	local err = content.err
	print("lifeWaterCtrl:quickResurrectionRsp err", err)
	if err == gErrDef.Err_None then
		local retdata = content.data.retdata
		local newdata = retdata.newdata
		self:setClientData(newdata)
		local _ENV, ret = self.setClientData, self.setClientData
		for k, v in pairs(retdata.resurrection) do
			_ENV = nil
			;(nil).id = tonumber(k)
			;(nil).num = v
			table.insert(ret, nil)
		end
		_ENV = pairs(retdata.resurrection)
		pairs(retdata.resurrection).msg = "MESSAGE_SPRINGS_RESURGENCE_ARMY"
		pairs(retdata.resurrection).err = err
		pairs(retdata.resurrection).redata = ret
		SoraDSendMessage(pairs(retdata.resurrection))
	else
		_ENV = retdata.newdata
		retdata.newdata.msg = "MESSAGE_SPRINGS_RESURGENCE_ARMY"
		retdata.newdata.err = err
		SoraDSendMessage(retdata.newdata)
	end
end
function lifeWaterCtrl:kwHospitalSwitchRsp(content)
	dump(content, "lifeWaterCtrl:kwHospitalSwitchRsp==")
	if content.err == gErrDef.Err_None then
		self.resurrectiondata.hospitalSwitch = content.rspdata.hospitalSwitch
	end
end
function lifeWaterCtrl:getDeadArmyCount(armyType)
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
function lifeWaterCtrl:getDeadArmyLevelCount()
	local _ENV, armyLevelCount
	if "table" == type(self.resurrectiondata.deadArmy) then
		local armyltCtrl = include("armyltCtrl")
		for armyid, armycount in pairs(self.resurrectiondata.deadArmy) do
			local armyLv = serviceFunctions.getArmyViewLev(tonumber(armyid))
			armyLevelCount[armyLv] = (armyLevelCount[armyLv] or 0) + armycount
		end
	end
	return armyLevelCount
end
function lifeWaterCtrl:getValueArmy()
	local ret = false
	local _ENV, info
	local constantRead = include("constantRead")
	local armyLevelCount = self:getDeadArmyLevelCount()
	local lvCount110 = armyLevelCount[110] or 0
	local lvCount115 = armyLevelCount[115] or 0
	local limit1 = constantRead.getConstValue("LEGEND_LORD_WOUND_LIMIT1", 200000)
	if lvCount110 >= limit1 or lvCount115 >= limit1 then
		ret = true
	end
	_ENV = nil
	;(nil).armyType = 1
	;(nil).count = lvCount110 + lvCount115
	;(nil).limit = limit1
	table.insert(info, nil)
	local lvCount120 = armyLevelCount[120] or 0
	local lvCount125 = armyLevelCount[125] or 0
	local limit2 = constantRead.getConstValue("LEGEND_LORD_WOUND_LIMIT2", 200000)
	if lvCount120 >= limit2 or lvCount125 >= limit2 then
		ret = true
	end
	_ENV = nil
	;(nil).armyType = 2
	;(nil).count = lvCount120 + lvCount125
	;(nil).limit = limit2
	table.insert(info, nil)
	local lvCount130 = armyLevelCount[130] or 0
	local lvCount135 = armyLevelCount[135] or 0
	local limit3 = constantRead.getConstValue("LEGEND_LORD_WOUND_LIMIT3", 200000)
	if lvCount130 >= limit3 or lvCount135 >= limit3 then
		ret = true
	end
	_ENV = nil
	;(nil).armyType = 3
	;(nil).count = lvCount130 + lvCount135
	;(nil).limit = limit3
	table.insert(info, nil)
	return ret, info
end
function lifeWaterCtrl:getHospitalSwitch()
	return self.resurrectiondata.hospitalSwitch
end
return lifeWaterCtrl
