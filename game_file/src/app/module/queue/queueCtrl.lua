local gamemodulec = include("GameModule")
local queueCtrl = class("queueCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local timerList = gModuleMgr.getObject("timerList")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
function queueCtrl:ctor(properties)
	queueCtrl.super.ctor(self, properties)
	self:resetData()
end
function queueCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_QUEUE_MODULE, gCmd.REQ_INIT_QUEUEDATA, handler(self, self.initQueueDataRsp))
	msgCtrl.register(gCmd.CMD_QUEUE_MODULE, gCmd.REQ_SPEED_UP_QUEUE, handler(self, self.speedUpQueueRsp))
	msgCtrl.register(gCmd.CMD_QUEUE_MODULE, gCmd.REQ_CANCEL_QUEUE, handler(self, self.cancelQueueRsp))
end
function queueCtrl:Logout()
	queueCtrl.super.Logout(self)
	self:resetData()
end
function queueCtrl:resetData()
	self.queues, _UPVALUE0_, self.handle_notify = nil, nil, nil
end
function queueCtrl:initQueueDataReq(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_QUEUE_MODULE, gCmd.REQ_INIT_QUEUEDATA, nil, ...)
end
function queueCtrl:speedUpQueueReq(qtype, mode, items, subtype, ...)
	_ENV = nil
	;(nil).qtype = tostring(qtype)
	;(nil).mode = tostring(mode)
	;(nil).items = items
	local (nil).decreaseTime, data = tostring(0), nil
	serverproxy:Request(gCmd.CMD_QUEUE_MODULE, gCmd.REQ_SPEED_UP_QUEUE, data, ...)
end
function queueCtrl:cancelQueueReq(qtype, subtype, ...)
	_ENV = nil
	local (nil).qtype, data = tostring(qtype), nil
	serverproxy:Request(gCmd.CMD_QUEUE_MODULE, gCmd.REQ_CANCEL_QUEUE, data, ...)
end
function queueCtrl:initQueueDataRsp(content)
	local queuedata = content.data
	for k, v in pairs(queuedata) do
		if v then
			self:addQueueByServerData(v)
		end
	end
	self:registerNotify()
end
function queueCtrl:speedUpQueueRsp(content)
	local err = content.err
	dump(content, "queueCtrl:speedUpQueueRsp(content)===", 10)
	if err == gErrDef.Err_None then
		local qtype = content.data.qtype
		local queue = self:queryQueue(qtype)
		local spedmode = content.data.mode
		if queue then
			if spedmode == tostring(SPEEDUP_TYPE.GOLD) or spedmode == tostring(SPEEDUP_TYPE.FREE) then
				queue.data.speedUpComplete = spedmode
				timerList:dispatchRightNow(queue.timerNode)
				self:removeQueue(qtype)
			elseif spedmode == tostring(SPEEDUP_TYPE.TOOLS) then
				local decreaseTime = tonumber(content.data.decreaseTime)
				local lefttime = queue.timerNode.timer:getRemainTime()
				if decreaseTime >= lefttime then
					queue.data.speedUpComplete = spedmode
				end
				self:updateLeftTime(qtype, -decreaseTime)
			end
		end
		_ENV = queue.timerNode.timer:getRemainTime()
		queue.timerNode.timer:getRemainTime().msg = "MESSAGE_ITEM_SPEED_UP_BACK"
		queue.timerNode.timer:getRemainTime().qtype = tonumber(qtype)
		SoraDSendMessage((queue.timerNode.timer:getRemainTime()))
	end
end
function queueCtrl:cancelQueueRsp(content)
	local err = content.err
	local data = content.data
	print("queueCtrl:cancelQueueRsp err=" .. err)
	if err == gErrDef.Err_None then
		local qtype = data.qtype
		local queue = self:queryQueue(qtype)
		if queue then
			local data = queue.data
			_ENV, data.optype = tostring(QUEUE_OPERATE_TYPE.CANCLE), tostring(QUEUE_OPERATE_TYPE.CANCLE)
			tostring(QUEUE_OPERATE_TYPE.CANCLE).name = qtype
			local tostring(QUEUE_OPERATE_TYPE.CANCLE).data, event = data, tostring(QUEUE_OPERATE_TYPE.CANCLE)
			self:removeQueue(qtype)
			self:dispatchEvent(event)
		end
	end
end
function queueCtrl:addQueue(queuetype, starttime, totaltime, lefttime, data, subtype)
	local queuetype = tostring(queuetype)
	local issuccess = false
	if not (self.queues[queuetype] and subtype) or not self.queues[queuetype][subtype] then
		issuccess = true
		local dispatchQueueEvent = function()
			if subtype then
				if not self.queues[queuetype] or self.queues[queuetype][subtype] then
				end
				subtype = self.queues[queuetype][subtype]
				self.queues[queuetype][subtype].name = queuetype
				self.queues[queuetype][subtype].data = data
				local self.queues[queuetype][subtype].subtype, event = subtype, self.queues[queuetype][subtype]
				self:dispatchEvent(event)
			else
				subtype, self.queues[queuetype] = self.queues, nil
				self.queues.name = queuetype
				local self.queues.data, event = data, self.queues
				self:dispatchEvent(event)
			end
		end
		local _ENV, queue
		queue.qtype = queuetype
		queue.starttime = starttime
		queue.totaltime = totaltime
		queue.lefttime = lefttime
		queue.data = data
		local ok, node = timerList:createTimer(lefttime, timerHandler(dispatchQueueEvent))
		if ok then
			queue.timerNode = node
			if subtype then
				subtype = tostring(subtype)
				if not self.queues[queuetype] then
					self.queues[queuetype], _ENV = subtype, subtype
				end
				self.queues[queuetype][subtype] = queue
			else
				self.queues[queuetype] = queue
			end
		end
	end
	return issuccess
end
function queueCtrl:removeQueue(queuetype, subtype)
	local queuetype = tostring(queuetype)
	local issuccess = false
	local queue = self:queryQueue(queuetype, subtype)
	if queue then
		issuccess = true
		timerList:cancelTimer(queue.timerNode)
		if subtype then
			subtype = tostring(subtype)
			self.queues[queuetype][subtype] = nil
		else
			self.queues[queuetype] = nil
		end
	end
	return issuccess
end
function queueCtrl:queryQueue(queuetype, subtype, isMass)
	local queuetype = tostring(queuetype)
	local ret = self.queues[queuetype]
	if not subtype or isMass then
	elseif ret and subtype then
		return ret[subtype]
	end
	return ret
end
function queueCtrl:getQueues(queuetype, subtype, isMass)
	local queuetype = tostring(queuetype)
	local ret = self.queues[queuetype]
	if not subtype or isMass then
	elseif ret and subtype then
		return ret[subtype]
	end
	return ret
end
function queueCtrl:setQueueHasReqHelp(queuetype)
	local ret = false
	local queue = self:queryQueue(queuetype)
	if queue and queue.data and queue.data.ishelp then
		queue.data.ishelp = 1
	end
	return ret
end
function queueCtrl:updateLeftTime(queuetype, time, subtype)
	local queue = self:queryQueue(queuetype, subtype)
	if queue then
		local timerList = gModuleMgr.getObject("timerList")
		if time < 0 then
			timerList:decreaseTime(queue.timerNode, -time)
		else
			timerList:increaseTime(queue.timerNode, time)
		end
	end
end
function queueCtrl:restartLeftTime(queuetype, time, subtype, totaltime, status)
	local queue = self:queryQueue(queuetype, subtype)
	if queue then
		local timerList = gModuleMgr.getObject("timerList")
		timerList:restartTimer(queue.timerNode, time)
		if totaltime then
			queue.totaltime = totaltime
		end
		if status then
			queue.timerNode.status = status
		end
	end
end
function queueCtrl:modifyTime(queuetype, time, subtype, totaltime, status)
	local queue = self:queryQueue(queuetype, subtype)
	if queue then
		queue.totaltime = totaltime
		queue.timerNode.status = status
		local timerList = gModuleMgr.getObject("timerList")
		timerList:modifyTime(queue.timerNode, time)
	end
end
function queueCtrl:isNeedReqHelp(queuetype)
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	if not allianceMgr:getAlliance() then
		return false
	end
	if self:isWarHospitalQueue(queuetype) then
		return false
	end
	if queuetype == gQueueTypeDef.nebula_palace_technology then
		return false
	end
	local ret = false
	local queue = self:queryQueue(queuetype)
	if queue and queue.data and queue.data.ishelp and queue.data.ishelp == 0 then
		ret = true
	end
	return ret
end
function queueCtrl:isHospitalQueue(queuetype)
	local worldMapWarDef = include("worldMapWarDef")
	return worldMapWarDef.isHospitalQueue(queuetype)
end
function queueCtrl:isWarHospitalQueue(queuetype)
	return queuetype ~= gQueueTypeDef.hostpital_queue and self:isHospitalQueue(queuetype)
end
function queueCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.QUEUE, handler(self, self.updatequeue))
end
function queueCtrl:updatequeue(event)
	dump(event, "==queueCtrl:updatequeue==", 10)
	for k, v in pairs(event.data) do
		local data = v.dispatchQueueEvent
		if data then
			local notifyType = data.notifyType
			if notifyType == "merge" then
				self:notify_merge(data)
			else
				local queuetype = tonumber(data.name)
				local queue = self:queryQueue(queuetype)
				if queue and queuetype ~= gQueueTypeDef.free_build_queue and queuetype ~= gQueueTypeDef.charge_build_queue and queuetype ~= gQueueTypeDef.stuff_workshop and queuetype ~= gQueueTypeDef.endless_treasure_queue and queuetype ~= gQueueTypeDef.physical_recovery then
					local _uniqueid1 = data.data and data.data._uniqueid
					local _uniqueid2 = queue.data and queue.data._uniqueid
					if _uniqueid1 == _uniqueid2 then
						self:removeQueue(queuetype)
						self:dispatchEvent(data)
					else
						print("==queueCtrl:updatequeue==", queuetype, _uniqueid1, _uniqueid2)
					end
				end
			end
		end
	end
end
function queueCtrl:notify_merge(data)
	if not data.deleteList then
		local _ENV, deleteList = data.deleteList, data.deleteList
	end
	for __, queuetype in ipairs(deleteList) do
		local queue = self:queryQueue(queuetype)
		if queue then
			self:removeQueue(queuetype)
			queue.data.optype = QUEUE_OPERATE_TYPE.MERGE_REMOVE
			_ENV = queuetype
			queuetype.name = queuetype
			queuetype.data = queue.data
			self:dispatchEvent(queuetype)
			_ENV = self
			self.msg = "MESSAGE_QUEUE_MERGE_NOTIFY"
			self.qtype = queuetype
			SoraDSendMessage(self)
		end
	end
	local queuetype = tonumber(data.name)
	local queueData = data.data
	if queueData then
		self:addQueueByServerData(queueData)
		local eventData = clone(queueData.data)
		eventData.optype = QUEUE_OPERATE_TYPE.MERGE_ADD
		_ENV = self:queryQueue(queuetype)
		self:queryQueue(queuetype).name = queuetype
		self:queryQueue(queuetype).data = eventData
		self:dispatchEvent((self:queryQueue(queuetype)))
	end
	_ENV = self.dispatchEvent
	self.dispatchEvent.msg = "MESSAGE_QUEUE_MERGE_NOTIFY"
	self.dispatchEvent.qtype = queuetype
	SoraDSendMessage(self.dispatchEvent)
	_ENV = self.dispatchEvent
	self.dispatchEvent.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
	SoraDSendMessage(self.dispatchEvent)
end
function queueCtrl:initClientData(data)
	for k, v in pairs(data) do
		if v then
			self:addQueueByServerData(v)
		end
	end
	self:registerNotify()
end
function queueCtrl:addQueueByServerData(data)
	local v = data
	local starttime = v.starttime
	local totaltime = v.totaltime
	local ottime = v.ottime
	local nowtime = serviceFunctions.systemTime()
	local lasttime = nowtime - starttime
	local lefttime = totaltime - lasttime
	if lefttime <= 0 then
		lefttime = 0
	end
	self:addQueue(v.qtype, starttime, totaltime, lefttime, v.data)
	local queue = self:queryQueue(v.qtype)
	if queue then
		queue.ottime = v.ottime
	end
end
return queueCtrl
