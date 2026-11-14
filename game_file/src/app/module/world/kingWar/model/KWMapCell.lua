local KWMapCell = class("KWMapCell")
local gametop = gModuleMgr.getObject("gametop")
function KWMapCell:canChangeResRate()
	local ret = gErrDef.Err_None
	local curTime = serviceFunctions.systemTime()
	if curTime <= self.data.lastChangeDate then
		ret = gErrDef.Err_KW_CHANGE_TIME_ERROR
	end
	print("KWMapCell:canChangeResRate(resId)", ret)
	return ret
end
function KWMapCell:changeResRate(resId)
	print("KWMapCell:changeResRate(resId)", resId, self.data.lastChangeDate)
	local curTime = serviceFunctions.systemTime()
	self.data.lastChangeDate = curTime + gChangeResourceRateCD
	local cd = gChangeResourceRateCD
	local gametop = gModuleMgr.getObject("gametop")
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	local queue = queueCtrl:queryQueue(gQueueTypeDef.change_resource_rate, gChangeResourceRateQueueId)
	if not queue then
		_ENV = nil
		queueCtrl:addQueue(gQueueTypeDef.change_resource_rate, serviceFunctions.systemTime(), cd, cd, nil, gChangeResourceRateQueueId)
	else
		queueCtrl:restartLeftTime(gQueueTypeDef.change_resource_rate, cd, gChangeResourceRateQueueId)
	end
	return gErrDef.Err_None
end
local instance
function KWMapCell.sharedInstance()
	return instance
end
function KWMapCell:getDefaultData()
	_UPVALUE0_ = nil
	;(nil).lastChangeDate = 0
	return nil
end
function KWMapCell:ctor()
	self.data = self:getDefaultData()
end
function KWMapCell:cancelKing()
	self.data = self:getDefaultData()
end
function KWMapCell:becomeKing(data)
	self.data = data
	local cd = self.data.lastChangeDate - serviceFunctions.systemTime()
	if cd < 0 then
		cd = 0
	end
	local gametop = gModuleMgr.getObject("gametop")
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	local queue = queueCtrl:queryQueue(gQueueTypeDef.change_resource_rate, gChangeResourceRateQueueId)
	if not queue then
		_ENV = nil
		queueCtrl:addQueue(gQueueTypeDef.change_resource_rate, serviceFunctions.systemTime(), cd, cd, nil, gChangeResourceRateQueueId)
	else
		queueCtrl:restartLeftTime(gQueueTypeDef.change_resource_rate, cd, gChangeResourceRateQueueId)
	end
end
return KWMapCell
