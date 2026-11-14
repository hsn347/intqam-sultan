local localPosQueueMgr = class("localPosQueueMgr")
function localPosQueueMgr:ctor(kingdomMapCell, queueRoot)
	self.xy_aid_qMap, _UPVALUE0_, self.xy_status_qMap, _UPVALUE0_, self.xyqMap, _UPVALUE0_, self.queueRoot = nil, nil, nil, nil, nil, nil, queueRoot
end
function localPosQueueMgr:addQueue(queue, teamId, notNotify)
	local x = queue:getMassToX() or queue:getToX()
	local y = queue:getMassToY() or queue:getToY()
	local orgPosAid
	if not notNotify then
		orgPosAid = self:getPosAid(x, y, queue)
	end
	local xy = serviceFunctions.getMapKey(x, y)
	if not self.xyqMap[xy] then
		self.xyqMap[xy], _ENV = y, y
	end
	self.xyqMap[xy][queue:getId()] = queue
	if not self.xy_status_qMap[xy] then
		self.xy_status_qMap[xy], _ENV = queue:getId(), queue:getId()
	end
	if not self.xy_status_qMap[xy][queue:getStatus()] then
		self.xy_status_qMap[xy][queue:getStatus()], _ENV = queue, queue
	end
	self.xy_status_qMap[xy][queue:getStatus()][queue:getId()] = queue
	if queue:getAid() then
		if not self.xy_aid_qMap[xy] then
			self.xy_aid_qMap[xy], _ENV = queue, queue
		end
		if not self.xy_aid_qMap[xy][queue:getAid()] then
			self.xy_aid_qMap[xy][queue:getAid()], _ENV = queue, queue
		end
		self.xy_aid_qMap[xy][queue:getAid()][queue:getId()] = queue
	end
	if not notNotify then
		self:notifyPosDefendQueueChanged(x, y, orgPosAid, queue, "MESSAGE_ALLIACNE_WAR_RALLY_ADD_NEW")
	end
end
function localPosQueueMgr:removeQueue(queue, teamId, notNotify)
	local x = queue:getMassToX() or queue:getToX()
	local y = queue:getMassToY() or queue:getToY()
	local orgPosAid
	if not notNotify then
		orgPosAid = self:getPosAid(x, y, queue)
	end
	local xy = serviceFunctions.getMapKey(x, y)
	if self.xyqMap[xy] then
		self.xyqMap[xy][queue:getId()] = nil
	end
	if self.xy_status_qMap[xy] then
		if self.xy_status_qMap[xy][queue:getStatus()] and self.xy_status_qMap[xy][queue:getStatus()][queue:getId()] then
			self.xy_status_qMap[xy][queue:getStatus()][queue:getId()] = nil
		else
			for _, queueMap in pairs(self.xy_status_qMap[xy]) do
				queueMap[queue:getId()] = nil
			end
		end
	end
	if queue:getAid() and self.xy_aid_qMap[xy] and self.xy_aid_qMap[xy][queue:getAid()] then
		self.xy_aid_qMap[xy][queue:getAid()][queue:getId()] = nil
	end
	if queue:getOrgAid() and self.xy_aid_qMap[xy] and self.xy_aid_qMap[xy][queue:getOrgAid()] then
		self.xy_aid_qMap[xy][queue:getOrgAid()][queue:getId()] = nil
	end
	if not notNotify then
		self:notifyPosDefendQueueChanged(x, y, orgPosAid, queue, "MESSAGE_ALLIACNE_WAR_RALLY_DELETE_NEW")
	end
end
function localPosQueueMgr:updateQueue(queue)
	local x = queue:getMassToX() or queue:getToX()
	local y = queue:getMassToY() or queue:getToY()
	local xy = serviceFunctions.getMapKey(x, y)
	if self.xyqMap[xy] and self.xyqMap[xy][queue:getId()] then
		local orgPosAid = self:getPosAid(x, y, queue)
		self:removeQueue(queue, true)
		self:addQueue(queue, true)
		self:notifyPosDefendQueueChanged(x, y, orgPosAid, queue, "MESSAGE_ALLIACNE_WAR_RALLY_MASS_UPDATE_NEW")
	end
end
function localPosQueueMgr:hasQueueToPos(x, y, fromAid, queueStatus)
	local xy = serviceFunctions.getMapKey(x, y)
	if fromAid and queueStatus then
		if self.xy_aid_qMap[xy] and self.xy_aid_qMap[xy][fromAid] then
			for queueId, queue in pairs(self.xy_aid_qMap[xy][fromAid]) do
				if queue:getStatus() == queueStatus then
					return true
				end
			end
		end
	elseif fromAid then
		return self.xy_aid_qMap[xy] and self.xy_aid_qMap[xy][fromAid] and next(self.xy_aid_qMap[xy][fromAid])
	elseif queueStatus then
		return self.xy_status_qMap[xy] and self.xy_status_qMap[xy][fromAid] and next(self.xy_status_qMap[xy][fromAid])
	else
		return self.xyqMap[xy] and next(self.xyqMap[xy])
	end
	return false
end
function localPosQueueMgr:getToPosQueueMapByAidOrStatus(x, y, fromAid, queueStatus)
