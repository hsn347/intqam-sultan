local watchTowerData = class("watchTowerData")
local NODE_FILER_HEIGHT = 65
local NODE_QUEUE_HEIGHT = 170
function watchTowerData:ctor(view, newClassType, scrollH)
	self.view = view
	self.newClassType = newClassType
	self.scrollH = scrollH
	self:clean()
end
function watchTowerData:clean()
	NODE_QUEUE_HEIGHT, _UPVALUE2_, self.queueFilter, NODE_QUEUE_HEIGHT, self.queue, NODE_QUEUE_HEIGHT, self.queueIndex, NODE_QUEUE_HEIGHT = nil, nil, nil, nil, nil, nil, nil, nil
	;(nil).queue = self.queue
	;(nil).singleH = NODE_QUEUE_HEIGHT
	NODE_QUEUE_HEIGHT, (nil).offsetY = NODE_QUEUE_HEIGHT, 0
	NODE_QUEUE_HEIGHT.queue = self.queueFilter
	NODE_QUEUE_HEIGHT.singleH = NODE_QUEUE_HEIGHT
	NODE_QUEUE_HEIGHT.offsetY = NODE_FILER_HEIGHT
	self.tableQueue, (nil)[1] = nil, nil
	self.tableQueue, (nil)[2] = nil, NODE_QUEUE_HEIGHT
	self:resetCache()
end
function watchTowerData:resetCache()
	if self.tableData then
		self.maxHeight = nil
		self.queueFilterHeight = 0
		self.tableData = nil
	end
end
function watchTowerData:isHasQueue()
	for _, data in ipairs(self.tableQueue) do
		local num = #data.queue
		if 0 < num then
			return true
		end
	end
	return false
end
function watchTowerData:isHasFiler()
	return #self.queueFilter > 0
end
function watchTowerData:getScrollMaxHeight()
	if self.maxHeight then
		return self.maxHeight, self.queueFilterHeight or 0
	end
	local queueHeight = #self.queue * NODE_QUEUE_HEIGHT
	local queueFilterHeight = #self.queueFilter * NODE_QUEUE_HEIGHT
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
function watchTowerData:lazyGenTableData()
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
function watchTowerData:getTableData()
	if not self.tableData then
		self:lazyGenTableData()
	end
	return self.tableData
end
function watchTowerData:getQueuePosByID(eventID)
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
function watchTowerData:checkIgnore()
	local tableData = self:getTableData()
	for _, queueCell in ipairs(tableData) do
		local queueData = queueCell.queue
		for _, v in ipairs(queueData) do
			if not v.data:isRedFrmIgnore() then
				return true
			end
		end
	end
	return false
end
function watchTowerData:ignoreAll()
	local tableData = self:getTableData()
	for _, queueCell in ipairs(tableData) do
		local queueData = queueCell.queue
		for _, v in ipairs(queueData) do
			v.data:ignoreRedFrm()
		end
	end
end
function watchTowerData:ignoreQueue(qid)
	local tableData = self:getTableData()
	for _, queueCell in ipairs(tableData) do
		local queueData = queueCell.queue
		for _, v in ipairs(queueData) do
			if v.data:getId() == qid then
				v.data:ignoreRedFrm()
				break
			end
		end
	end
end
function watchTowerData:noIgnoreQueue(qid)
	local tableData = self:getTableData()
	for _, queueCell in ipairs(tableData) do
		local queueData = queueCell.queue
		for _, v in ipairs(queueData) do
			if v.data:getId() == qid then
				v.data:noIgnoreRedFrm()
				break
			end
		end
	end
end
function watchTowerData:getQueueIndexByPos(pos, begin)
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
function watchTowerData:getQueueByType(isFilter)
	isFilter = isFilter or false
	if isFilter then
		return self.queueFilter
	end
	return self.queue
end
function watchTowerData:dataLinkAdd_index(indexID, indexData)
	local isFilter = indexData.isFilter or false
	local queue = self:getQueueByType(isFilter)
	table.insert(queue, indexData)
	_ENV = queue
	queue.queue = queue
	queue.index = #queue
	self.queueIndex[indexID], queue.indexID = queue, indexID
end
function watchTowerData:dataLinkAdd_imp(indexID, data)
	local isFilter = data.isFilter or false
	local queue = self:getQueueByType(isFilter)
	_ENV = self
	self.data = data:getFilterDataByWatchTower()
	self.isFilter = isFilter
	local self.indexID, queueData = indexID, self
	table.insert(queue, queueData)
	_ENV = queue
	queue.queue = queue
	queue.index = #queue
	self.queueIndex[indexID], queue.indexID = queue, indexID
	return queueData
end
function watchTowerData:dataLinkAdd(indexID, data, noRefresh)
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
function watchTowerData:dataLinkDelete_imp(indexID, dataIndex)
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
function watchTowerData:dataLinkDelete(indexID, data)
	local dataIndex = self.queueIndex[indexID]
	local queueData = self:dataLinkDelete_imp(indexID, dataIndex)
	self:resetCache()
	self.view:refreshByData(self.newClassType, queueData, true)
end
function watchTowerData:dataLinkUpdate(indexID, data, noRefresh)
	local dataIndex = self.queueIndex[indexID]
	if dataIndex then
		local queue = dataIndex.queue
		local index = dataIndex.index
		local warMainData = queue[index]
		if warMainData then
			warMainData.data = data:getFilterDataByWatchTower()
			local oldFiler = warMainData.isFilter
			if not oldFiler ~= not data.isFilter then
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
	end
end
return watchTowerData
