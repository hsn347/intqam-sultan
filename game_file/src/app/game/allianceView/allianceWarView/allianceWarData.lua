local queueTimeUtil = include("queueTimeUtil")
local allianceWarData = class("allianceWarData")
local NODE_FILER_HEIGHT = 50
local NODE_QUEUE_HEIGHT = 240
local NODE_QUEUE_MASS_HEIGHT = 390
function allianceWarData:ctor(view, newClassType, scrollH)
	self.view = view
	self.newClassType = newClassType
	self.scrollH = scrollH
	self:clean()
end
function allianceWarData:clean()
	NODE_QUEUE_MASS_HEIGHT, _UPVALUE4_, self.queueMassFilter, NODE_QUEUE_MASS_HEIGHT, self.queueFilter, NODE_QUEUE_MASS_HEIGHT, self.queueMass, NODE_QUEUE_MASS_HEIGHT, self.queue, NODE_QUEUE_MASS_HEIGHT, self.queueIndex, NODE_QUEUE_MASS_HEIGHT = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	;(nil).queue = self.queueMass
	;(nil).singleH = NODE_QUEUE_MASS_HEIGHT
	NODE_QUEUE_MASS_HEIGHT, (nil).offsetY = NODE_QUEUE_MASS_HEIGHT, 0
	NODE_QUEUE_MASS_HEIGHT.queue = self.queue
	NODE_QUEUE_MASS_HEIGHT.singleH = NODE_QUEUE_HEIGHT
	NODE_QUEUE_MASS_HEIGHT, NODE_QUEUE_MASS_HEIGHT.offsetY = NODE_QUEUE_HEIGHT, 0
	NODE_QUEUE_HEIGHT.queue = self.queueMassFilter
	NODE_QUEUE_HEIGHT.singleH = NODE_QUEUE_MASS_HEIGHT
	NODE_QUEUE_MASS_HEIGHT, NODE_QUEUE_HEIGHT.offsetY = NODE_FILER_HEIGHT, NODE_FILER_HEIGHT
	NODE_FILER_HEIGHT.queue = self.queueFilter
	NODE_FILER_HEIGHT.singleH = NODE_QUEUE_HEIGHT
	NODE_FILER_HEIGHT.offsetY = NODE_FILER_HEIGHT
	self.tableQueue, (nil)[1] = nil, nil
	self.tableQueue, (nil)[2] = nil, NODE_QUEUE_MASS_HEIGHT
	self.tableQueue, (nil)[3] = nil, NODE_QUEUE_HEIGHT
	self.tableQueue, (nil)[4] = nil, NODE_FILER_HEIGHT
	self:resetCache()
end
function allianceWarData:resetCache()
	if self.tableData then
		self.maxHeight = nil
		self.queueFilterHeight = 0
		self.tableData = nil
	end
end
function allianceWarData:isHasQueue()
	for _, data in ipairs(self.tableQueue) do
		local num = #data.queue
		if 0 < num then
			return true
		end
	end
	return false
end
function allianceWarData:isHasFiler()
	return #self.queueFilter > 0 or 0 < #self.queueMassFilter
end
function allianceWarData:getScrollMaxHeight()
	local queueHeight = #self.queue * NODE_QUEUE_HEIGHT + #self.queueMass * NODE_QUEUE_MASS_HEIGHT
	local queueFilterHeight = #self.queueFilter * NODE_QUEUE_HEIGHT + #self.queueMassFilter * NODE_QUEUE_MASS_HEIGHT
	if 0 < queueFilterHeight then
		queueFilterHeight = queueFilterHeight + NODE_FILER_HEIGHT
	end
	local maxHeight = queueHeight + queueFilterHeight
	maxHeight = math.max(maxHeight, self.scrollH)
	if 0 < queueFilterHeight then
		queueFilterHeight = maxHeight - queueHeight
	end
	self.maxHeight = maxHeight
	self.queueFilterHeight = queueFilterHeight
	return maxHeight, queueFilterHeight
end
function allianceWarData:lazyGenTableData()
	if self.tableData then
		return self.tableData
	end
	local _ENV, tableData = self.tableData, self.tableData
	local index = 0
	local maxHeight = self:getScrollMaxHeight()
	local height = maxHeight
	local isOffset = false
	for _, data in ipairs(self.tableQueue) do
		local num = #data.queue
		if 0 < num then
			local offsetY = isOffset and 0 or data.offsetY
			if 0 < offsetY then
				isOffset = true
			end
			local endIndex = index + num - 1
			local beginHeight = height - offsetY
			local endHeight = beginHeight - num * data.singleH
			_ENV = nil
			;(nil).queue = data.queue
			;(nil).beginIndex = index
			;(nil).endIndex = endIndex
			;(nil).beginHeight = beginHeight
			;(nil).endHeight = endHeight
			;(nil).singleH = data.singleH
			table.insert(tableData, nil)
			index = index + num
			height = endHeight
		end
	end
	self.tableData = tableData
end
function allianceWarData:getTableData()
	if not self.tableData then
		self:lazyGenTableData()
	end
	return self.tableData
end
function allianceWarData:getQueuePosByID(eventID)
	local dataIndex = self.queueIndex[eventID]
	if dataIndex then
		local queue = dataIndex.queue
		local index = dataIndex.index
		local tableData = self:getTableData()
		for _, queueCell in ipairs(tableData) do
			if queueCell.queue == queue then
				local posY = queueCell.beginHeight - (index - 1) * queueCell.singleH
				return posY
			end
		end
	end
end
function allianceWarData:getQueueIndexByID(eventID)
	local dataIndex = self.queueIndex[eventID]
	if dataIndex then
		local queue = dataIndex.queue
		local index = dataIndex.index
		return index
	end
end
function allianceWarData:getQueueIndexByPos(pos, begin)
	local tableData = self:getTableData()
	local index = 0
	for _, queueCell in ipairs(tableData) do
		if pos <= queueCell.beginHeight and pos > queueCell.endHeight then
			if begin then
				index = queueCell.beginIndex + math.floor((queueCell.beginHeight - pos) / queueCell.singleH)
				break
			end
			index = queueCell.beginIndex + math.floor((queueCell.beginHeight - pos - 1) / queueCell.singleH)
			break
		elseif pos <= queueCell.endHeight then
			index = queueCell.endIndex
		end
	end
	return index
end
function allianceWarData:getQueueByType(isMass, isFilter)
	isFilter = isFilter or false
	isMass = isMass or false
	if isMass then
		if isFilter then
			return self.queueMassFilter
		else
			return self.queueMass
		end
	end
	if isFilter then
		return self.queueFilter
	end
	return self.queue
end
function allianceWarData:dataLinkAdd_index(indexID, indexData)
	local isFilter = indexData.isFilter or false
	local isMass = indexData.isMass or false
	local queue = self:getQueueByType(isMass, isFilter)
	table.insert(queue, indexData)
	_ENV = queue
	queue.queue = queue
	queue.index = #queue
	self.queueIndex[indexID], queue.indexID = queue, indexID
end
function allianceWarData:dataLinkAdd_imp(indexID, data)
	local isFilter = data.isFilter or false
	local isMass = data.isMass or false
	local queue = self:getQueueByType(isMass, isFilter)
	_ENV = self
	self.data = data.queues
	self.isFilter = isFilter
	self.isMass = isMass
	local self.indexID, queueData = indexID, self
	local findIndex = #queue + 1
	if self.newClassType == gAllianceQueueClassType.pve then
		local localQueueData = queueData.data[next(queueData.data)]
		local statusEndTime = localQueueData.statusEndTime
		local initMoveTime = localQueueData.initMoveTime
		for i, v in ipairs(queue) do
			local _localQueueData = v.data[next(v.data)]
			local _statusEndTime = _localQueueData.statusEndTime
			local _initMoveTime = _localQueueData.initMoveTime
			if statusEndTime ~= nil and _statusEndTime ~= nil and (statusEndTime < _statusEndTime or statusEndTime == _statusEndTime and initMoveTime ~= nil and _initMoveTime ~= nil and initMoveTime <= _initMoveTime) then
				findIndex = i
				break
			end
		end
	end
	table.insert(queue, findIndex, queueData)
	_ENV = queue
	queue.queue = queue
	queue.index = findIndex
	self.queueIndex[indexID], queue.indexID = queue, indexID
	for i = findIndex + 1, #queue do
		local queueIndexID = queue[i].indexID
		local fixIndex = self.queueIndex[queueIndexID]
		if fixIndex then
			fixIndex.index = fixIndex.index + 1
		end
	end
	return queueData
end
function allianceWarData:dataLinkAdd(indexID, data, noRefresh)
	if self.queueIndex[indexID] == nil then
		local queueData = self:dataLinkAdd_imp(indexID, data)
		self:resetCache()
		if not noRefresh then
			self.view:refreshByData(self.newClassType, queueData)
		end
	else
		self:dataLinkUpdate(indexID, data, noRefresh)
	end
end
function allianceWarData:dataLinkDelete_imp(indexID, dataIndex)
	if dataIndex then
		local queue = dataIndex.queue
		local index = dataIndex.index
		local data = queue[index]
		self.queueIndex[indexID] = nil
		if data then
			table.remove(queue, index)
			for i = index, #queue do
				local queueIndexID = queue[i].indexID
				local fixIndex = self.queueIndex[queueIndexID]
				if fixIndex then
					fixIndex.index = fixIndex.index - 1
				end
			end
		end
		return data
	end
end
function allianceWarData:dataLinkDelete(indexID, data)
	local dataIndex = self.queueIndex[indexID]
	local queueData = self:dataLinkDelete_imp(indexID, dataIndex)
	self:resetCache()
	self.view:refreshByData(self.newClassType, queueData, true)
end
function allianceWarData:dataLinkUpdate(indexID, data, noRefresh)
	local dataIndex = self.queueIndex[indexID]
	if dataIndex then
		if data.newClassType ~= self.newClassType then
			self:dataLinkDelete(indexID, data)
			return
		end
		local queue = dataIndex.queue
		local index = dataIndex.index
		local warMainData = queue[index]
		if warMainData then
			warMainData.data = data.queues
			local oldFiler = warMainData.isFilter
			if oldFiler ~= data.isFilter then
				self:dataLinkDelete_imp(indexID, dataIndex)
				warMainData.isFilter = data.isFilter
				self:dataLinkAdd_index(indexID, warMainData)
				self:resetCache()
				if not noRefresh then
					self.view:refreshByData(self.newClassType, warMainData, true)
				end
			elseif not noRefresh then
				self.view:refreshSinggleByData(self.newClassType, warMainData)
			end
		end
	elseif data.newClassType == self.newClassType then
		self:dataLinkAdd(indexID, data, noRefresh)
	end
end
function allianceWarData:updateQueueScrollH(scrollH)
	self.scrollH = scrollH
end
return allianceWarData
