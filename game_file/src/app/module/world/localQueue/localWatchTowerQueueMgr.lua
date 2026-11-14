local localWatchTowerQueueMgr = class("localWatchTowerQueueMgr")
local gametop = gModuleMgr.getObject("gametop")
function localWatchTowerQueueMgr:ctor(kingdomMapCell, queueRoot)
	self.kingdomMapCell = kingdomMapCell
	self.uid = kingdomMapCell.uid
	self.watchTowerRomanQueueMap, _ENV, self.watchTowerQueueMap, _ENV, self.queueRoot = kingdomMapCell.uid, kingdomMapCell.uid, kingdomMapCell.uid, kingdomMapCell.uid, queueRoot
	_ENV = nil
	;(nil).byUID = true
	self.recordIgnoreQ = SoraDConfigGet("Game:watchTowerView:ignoreList~table", nil)
	self.attackQueue = 0
	self.friendQueue = 0
	self.redFrmQueue = 0
	self.romanQueue = 0
	self._ignoreRomanSoul = false
end
local decrease2zero = function(num)
	return math.max(num - 1, 0)
end
function localWatchTowerQueueMgr:allianceWarFilter(queueObj, selfAid)
	return self.queueRoot:getWarHallQueueFilter(queueObj, selfAid)
end
function localWatchTowerQueueMgr:addQueue(queueObj, selfAid)
	local thisQueue, otherQueueMap = self:getNeedAddOccupyQueues(queueObj)
	if otherQueueMap then
		for _, otherQueue in pairs(otherQueueMap) do
			if queueObj:getId() ~= otherQueue:getId() and (not otherQueue:isFromUser(self.uid) or not otherQueue:isMainQueueFun()) then
				self:addWatchTowerQueue(otherQueue, selfAid)
			end
		end
	end
	if thisQueue then
		self:addWatchTowerQueue(thisQueue, selfAid)
	end
end
function localWatchTowerQueueMgr:addWatchTowerQueue(queueObj, selfAid)
	if queueObj:isMainQueueFun() then
		if queueObj:getStatus() <= gMapMoveLineStatusType.moveLineStatusTypeMoving then
			local indexID = queueObj:getId()
			if self:isRoman(queueObj) then
				if not self.watchTowerRomanQueueMap[indexID] then
					self.watchTowerRomanQueueMap[indexID] = queueObj
					self.romanQueue = self.romanQueue + 1
					_ENV = self
					self.msg = "MESSAGE_SERVER_WATCHSOULTOWER_ADDINFO"
					self.data = queueObj
					self.indexID = indexID
					SoraDSendMessage(self)
				end
			elseif not self.watchTowerQueueMap[indexID] then
				selfAid = selfAid or self:getSelfAid()
				if not queueObj:isFromAlliance(selfAid) and (queueObj:getQueueType() == gMapMoveLineServerType.moveLineTypeResourceHelp or queueObj:getQueueType() == gMapMoveLineServerType.moveLineTypeArmyHelp) then
				elseif queueObj:isFromAlliance(selfAid) and queueObj:getQueueType() == gMapMoveLineServerType.moveLineTypeScout then
				elseif queueObj:getFromMapType() == gMapObjTypeDef.mapTypeMine and queueObj:getQueueType() == gMapMoveLineServerType.moveLineTypeResourceHelp then
				else
					self.watchTowerQueueMap[indexID] = queueObj
					if queueObj:isFromAlliance(selfAid) then
						queueObj:ignoreRedFrm()
						self.friendQueue = self.friendQueue + 1
					else
						self.attackQueue = self.attackQueue + 1
						if queueObj:getQueueType() == gMapMoveLineServerType.moveLineTypeScout then
							queueObj:ignoreRedFrm()
						elseif self:allianceWarFilter(queueObj, selfAid) then
							queueObj:ignoreRedFrm()
							queueObj.isFilter = true
						elseif self.recordIgnoreQ[tostring(indexID)] then
							queueObj:ignoreRedFrm()
						else
							self.redFrmQueue = self.redFrmQueue + 1
						end
					end
					_ENV = queueObj
					queueObj.msg = "MESSAGE_SERVER_WATCHTOWER_ADDINFO"
					queueObj.data = queueObj
					queueObj.indexID = indexID
					SoraDSendMessage(queueObj)
				end
			end
		end
	else
		local indexID = queueObj:getMainId()
		if indexID and self.watchTowerQueueMap[indexID] then
			_ENV = queueObj
			queueObj.msg = "MESSAGE_SERVER_WATCHTOWER_EDITINFO"
			queueObj.data = self.watchTowerQueueMap[indexID]
			queueObj.indexID = indexID
			SoraDSendMessage(queueObj)
		end
	end
end
function localWatchTowerQueueMgr:removeQueue(queueObj, selfAid)
	self:removeWatchTowerQueue(queueObj, selfAid)
	local queueMap = self:getNeedRemoveOccupyQueues(queueObj)
	if queueMap then
		for _, _queueObj in pairs(queueMap) do
			if queueObj:getId() ~= _queueObj:getId() then
				self:removeWatchTowerQueue(_queueObj, selfAid)
			end
		end
	end
end
function localWatchTowerQueueMgr:removeWatchTowerQueue(queueObj, selfAid)
	if queueObj:isMainQueueFun() then
		local indexID = queueObj:getId()
		if self:isRoman(queueObj) then
			if self.watchTowerRomanQueueMap[indexID] then
				self.watchTowerRomanQueueMap[indexID] = nil
				self.romanQueue = decrease2zero(self.romanQueue)
				decrease2zero = self.romanQueue
				self.romanQueue.msg = "MESSAGE_SERVER_WATCHSOULTOWER_REMOVEINFO"
				self.romanQueue.indexID = indexID
				SoraDSendMessage(self.romanQueue)
			end
		elseif self.watchTowerQueueMap[indexID] then
			self.watchTowerQueueMap[indexID] = nil
			selfAid = selfAid or self:getSelfAid()
			if (queueObj:isFromAlliance(selfAid) or queueObj:isOrgFromAlliance(selfAid)) and queueObj:getQueueType() ~= gMapMoveLineServerType.moveLineTypeScout then
				self.friendQueue = decrease2zero(self.friendQueue)
			else
				self.attackQueue = decrease2zero(self.attackQueue)
				if queueObj:getQueueType() ~= gMapMoveLineServerType.moveLineTypeScout and not queueObj:isRedFrmIgnore() then
					self.redFrmQueue = decrease2zero(self.redFrmQueue)
				end
			end
			decrease2zero = self.redFrmQueue
			self.redFrmQueue.msg = "MESSAGE_SERVER_WATCHTOWER_REMOVEINFO"
			self.redFrmQueue.indexID = indexID
			self.redFrmQueue.classType = queueObj.classType
			SoraDSendMessage(self.redFrmQueue)
		end
	else
		local indexID = queueObj:getMainId()
		if indexID and self.watchTowerQueueMap[indexID] then
			decrease2zero = self.redFrmQueue
			self.redFrmQueue.msg = "MESSAGE_SERVER_WATCHTOWER_EDITINFO"
			self.redFrmQueue.data = self.watchTowerQueueMap[indexID]
			self.redFrmQueue.indexID = indexID
			SoraDSendMessage(self.redFrmQueue)
		end
	end
end
function localWatchTowerQueueMgr:updateQueue(queueObj, orgQueueStatus)
	self:updateWatchTowerQueue(queueObj)
	local thisQueue, otherQueueMap = self:getNeedAddOccupyQueues(queueObj)
	if otherQueueMap then
		for _, otherQueue in pairs(otherQueueMap) do
			if queueObj:getId() ~= otherQueue:getId() and (not otherQueue:isFromUser(self.uid) or not otherQueue:isMainQueueFun()) then
				self:addWatchTowerQueue(otherQueue)
			end
		end
	end
	if thisQueue then
		self:addWatchTowerQueue(thisQueue)
	end
end
function localWatchTowerQueueMgr:updateWatchTowerQueue(queueObj)
	if queueObj:isMainQueueFun() then
		if queueObj:getStatus() <= gMapMoveLineStatusType.moveLineStatusTypeMoving then
			local indexID = queueObj:getId()
			local selfAid = self:getSelfAid()
			if self.watchTowerQueueMap[indexID] then
				local old_queueObj = self.watchTowerQueueMap[indexID]
				if old_queueObj:isRedFrmIgnore() then
					queueObj:ignoreRedFrm()
				end
				queueObj.isFilter = old_queueObj.isFilter
				if queueObj:getQueueType() == gMapMoveLineServerType.moveLineTypeScout and (not (not queueObj:isFromAlliance(selfAid) or queueObj:isOrgFromAlliance(selfAid)) or not queueObj:isFromAlliance(selfAid) and queueObj:isOrgFromAlliance(selfAid)) then
					self:removeWatchTowerQueue(queueObj)
					self:addWatchTowerQueue(queueObj, selfAid)
					return
				end
				if queueObj:isOrgFromAlliance(selfAid) and not queueObj:hasFromAlliance() then
					self:removeQueue(queueObj)
				else
					self.watchTowerQueueMap[indexID] = queueObj
					_ENV = self
					self.msg = "MESSAGE_SERVER_WATCHTOWER_EDITINFO"
					self.data = queueObj
					self.indexID = indexID
					SoraDSendMessage(self)
				end
			elseif self:isRoman(queueObj) then
				if self.watchTowerRomanQueueMap[indexID] then
					self.watchTowerRomanQueueMap[indexID] = queueObj
					_ENV = self
					self.msg = "MESSAGE_SERVER_WATCHSOULTOWER_EDITINFO"
					self.data = queueObj
					self.indexID = indexID
					SoraDSendMessage(self)
				end
			elseif queueObj:isFromAlliance(selfAid) and not queueObj:hasOrgFromAlliance() then
				self:addQueue(queueObj, selfAid)
			end
		else
			self:removeQueue(queueObj)
		end
	else
		local indexID = queueObj:getMainId()
		if indexID and self.watchTowerQueueMap[indexID] then
			_ENV = queueObj
			queueObj.msg = "MESSAGE_SERVER_WATCHTOWER_EDITINFO"
			queueObj.data = self.watchTowerQueueMap[indexID]
			queueObj.indexID = indexID
			SoraDSendMessage(queueObj)
		end
	end
end
function localWatchTowerQueueMgr:getNeedAddOccupyQueues(queue)
	if queue:isFromUser(self.uid) then
		if queue:getStatus() ~= gMapMoveLineStatusType.moveLineStatusTypeWorking then
			return
		end
	elseif queue:isToUser(self.uid) then
		return queue
	end
	if queue:isOccupyQueue() or queue:getQueueType() == gMapMoveLineServerType.moveLineTypeGuardAllianceBuild or queue:getQueueType() == gMapMoveLineServerType.moveLineTypeAttackAllianceBuild or queue:getQueueType() == gMapMoveLineServerType.moveLineTypeMassAllianceBuild or queue:getQueueType() == gMapMoveLineServerType.moveLineTypeScout then
		if queue:isMainQueueFun() then
			if queue:getQueueType() ~= gMapMoveLineServerType.moveLineTypeAttackAllianceBuild and queue:getQueueType() ~= gMapMoveLineServerType.moveLineTypeMassAllianceBuild and queue:getQueueType() ~= gMapMoveLineServerType.moveLineTypeScout and queue:isFromUser(self.uid) and queue:getStatus() == gMapMoveLineStatusType.moveLineStatusTypeWorking then
				return nil, self.queueRoot.localPosQueueMgr:getToPosQueueMap(queue:getToX(), queue:getToY())
			end
			if self.queueRoot.localUserQueueMgr:hasFromUserQueue(self.uid, nil, nil, gMapMoveLineStatusType.moveLineStatusTypeWorking, queue:getToId()) then
				return queue
			end
		else
			return queue
		end
	end
end
function localWatchTowerQueueMgr:getNeedRemoveOccupyQueues(queue)
	if (queue:isOccupySingleQueue() or queue:getQueueType() == gMapMoveLineServerType.moveLineTypeGuardAllianceBuild) and queue:isMainQueueFun() and queue:isFromUser(self.uid) and not self.queueRoot.localUserQueueMgr:hasFromUserQueue(self.uid, nil, nil, gMapMoveLineStatusType.moveLineStatusTypeWorking, queue:getToId()) then
		return self.queueRoot.localPosQueueMgr:getToPosQueueMap(queue:getToX(), queue:getToY())
	end
end
function localWatchTowerQueueMgr:refreshAllianceSetting(...)
	local selfAid = self:getSelfAid()
	for _, queueObj in pairs(self.watchTowerQueueMap) do
		if not queueObj:isFromAlliance(selfAid) and queueObj:getQueueType() ~= gMapMoveLineServerType.moveLineTypeScout then
			if self:allianceWarFilter(queueObj, selfAid) then
				queueObj.isFilter = true
				if not queueObj:isRedFrmIgnore() then
					queueObj:ignoreRedFrm()
					self:decreaseCount("frm")
				end
			else
				queueObj.isFilter = false
				if queueObj:isRedFrmIgnore() then
					queueObj:noIgnoreRedFrm()
					self:addCount("frm")
				end
			end
		end
	end
end
function localWatchTowerQueueMgr:judgeCouldWarning(queueObj)
	local selfAid = self:getSelfAid()
	if not queueObj:isFromAlliance(selfAid) and not queueObj:checkIsWLCQueue() and queueObj:getQueueType() ~= gMapMoveLineServerType.moveLineTypeScout then
		return true
	end
end
function localWatchTowerQueueMgr:getWatchTowerLightInfo(...)
	return self.attackQueue, self.friendQueue, self.redFrmQueue, self.romanQueue
end
function localWatchTowerQueueMgr:decreaseCount(var)
	if "red" == var then
		self.attackQueue = decrease2zero(self.attackQueue)
	elseif "blue" == var then
		self.friendQueue = decrease2zero(self.friendQueue)
	elseif "frm" == var then
		self.redFrmQueue = decrease2zero(self.redFrmQueue)
		if self.redFrmQueue <= 0 then
			self:cleanRecordQ()
		end
	elseif "roman" == var then
		self.romanQueue = decrease2zero(self.romanQueue)
	end
end
function localWatchTowerQueueMgr:addCount(var)
	if "red" == var then
		self.attackQueue = self.attackQueue + 1
	elseif "blue" == var then
		self.friendQueue = self.friendQueue + 1
	elseif "frm" == var then
		self.redFrmQueue = self.redFrmQueue + 1
	elseif "roman" == var then
		self.romanQueue = self.romanQueue + 1
	end
end
function localWatchTowerQueueMgr:controlRecordQ(id, method)
	if "add" == method then
		self.recordIgnoreQ[tostring(id)] = true
	elseif "sub" == method then
		self.recordIgnoreQ[tostring(id)] = nil
	end
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:watchTowerView:ignoreList~table", self.recordIgnoreQ, nil)
end
function localWatchTowerQueueMgr:addRecordQ()
	for _, v in pairs(self.watchTowerQueueMap) do
		local id = v:getId()
		self.recordIgnoreQ[tostring(id)] = true
	end
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:watchTowerView:ignoreList~table", self.recordIgnoreQ, nil)
end
function localWatchTowerQueueMgr:cleanRecordQ(...)
	_ENV, _ENV = nil, nil
	;(nil).byUID = true
	SoraDConfigSet("Game:watchTowerView:ignoreList~table", nil, nil)
end
function localWatchTowerQueueMgr:cleanRedFrm(...)
	for _, v in pairs(self.watchTowerQueueMap) do
		v:ignoreRedFrm()
	end
	self.redFrmQueue = 0
end
function localWatchTowerQueueMgr:isIgnoreRomanSoul()
	return self._ignoreRomanSoul
end
function localWatchTowerQueueMgr:ignoreRomanSoul()
	self._ignoreRomanSoul = true
end
function localWatchTowerQueueMgr:getWatchTowerData(indexID)
	return self.watchTowerQueueMap[indexID]
end
function localWatchTowerQueueMgr:getAllWatchTowerQueue()
	return self.watchTowerQueueMap
end
function localWatchTowerQueueMgr:getRomanWatchTowerQueue()
	return self.watchTowerRomanQueueMap
end
function localWatchTowerQueueMgr:clear()
	self.watchTowerRomanQueueMap, _ENV, self.watchTowerQueueMap, _ENV = nil, nil, nil, nil
	self.attackQueue = 0
	self.friendQueue = 0
	self.redFrmQueue = 0
	self.romanQueue = 0
	self._ignoreRomanSoul = false
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_WATCHTOWER_REFRESHALL"
	SoraDSendMessage(nil)
end
function localWatchTowerQueueMgr:isRoman(queueObj)
	local classType = queueObj:getAllianceQueueClassType()
	local armyFromType = queueObj.armyFromType
	return (classType == gAllianceQueueClassType.pve or classType == gAllianceQueueClassType.pve_moving) and armyFromType == gArmyFromType.rome
end
function localWatchTowerQueueMgr:getSelfAid()
	return self.queueRoot:getOwnTeamID()
end
function localWatchTowerQueueMgr:dump()
	local _ENV, queueIds
	for queueId, _ in pairs(self.watchTowerQueueMap) do
		table.insert(queueIds, queueId)
	end
	print("localWatchTowerQueueMgr:dump", table.concat(queueIds, ","))
end
return localWatchTowerQueueMgr
