local mapQueueRoot = class("mapQueueRoot")
_UPVALUE3_ = "mapQueueRoot"
;("mapQueueRoot")[1] = "mapQueueMgr"
;("mapQueueRoot")[2] = "mapPieceQueueMgr"
local ("mapQueueRoot")[3], tableMgr = "mapPosQueueMgr", "mapQueueRoot"
function mapQueueRoot:ctor(kingdomMapCell)
	self.objMgrTable, _ENV = nil, nil
	for _, v in ipairs(tableMgr) do
		local queueMgrClass = include(v)
		local queueMgr = queueMgrClass.new(kingdomMapCell, self)
		if queueMgr then
			table.insert(self.objMgrTable, queueMgr)
			self[v] = queueMgr
		end
	end
end
function mapQueueRoot:addQueue(queueData)
	for _, v in ipairs(self.objMgrTable) do
		v:addQueue(queueData)
	end
end
function mapQueueRoot:removeQueue(queueData)
	for _, v in ipairs(self.objMgrTable) do
		v:removeQueue(queueData)
	end
end
function mapQueueRoot:updateQueue(queueData)
	for _, v in ipairs(self.objMgrTable) do
		v:updateQueue(queueData)
	end
end
function mapQueueRoot:clear()
	for _, v in ipairs(self.objMgrTable) do
		v:clear()
	end
end
function mapQueueRoot:dump()
	for _, v in ipairs(self.objMgrTable) do
		if v.dump then
			v:dump()
		end
	end
end
return mapQueueRoot
