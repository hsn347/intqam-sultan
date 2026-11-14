local allianceTaxWarehouse = class("allianceTaxWarehouse")
function allianceTaxWarehouse:ctor()
	self.data, _UPVALUE0_ = nil, nil
end
function allianceTaxWarehouse:initialize(data)
	local aid = data.aid
	self:initializeAID(aid)
	local resData = data.resData
	self:initializeResData(resData)
end
function allianceTaxWarehouse:destroy()
	self:destroyAID()
	self:destroyResData()
end
function allianceTaxWarehouse:increaseRes(resID, addCount)
	local currentResCount = self:getResCount(resID)
	local limit = include("allianceTaxltCtrl"):getTaxResourceLimit(resID)
	if currentResCount >= limit then
		return gErrDef.Err_ALLIANCE_TAX_RESOURCE_LIMIT
	end
	local resTotal = currentResCount + addCount
	self:setResCount(resID, resTotal)
	return gErrDef.Err_None
end
function allianceTaxWarehouse:decreaseRes(resID, rmCount)
	local currentResCount = self:getResCount(resID)
	if rmCount > currentResCount then
		return gErrDef.Err_ILLEGAL_PARAMS
	end
	local remainResCount = currentResCount - rmCount
	if remainResCount < 0 then
		remainResCount = 0
	end
	self:setResCount(resID, remainResCount)
	return gErrDef.Err_None
end
function allianceTaxWarehouse:getResCount(resID, count)
	local resIDStr = tostring(resID)
	return self.data.resData[resIDStr] or 0
end
function allianceTaxWarehouse:getResData()
	return self.data.resData
end
function allianceTaxWarehouse:initializeAID(aid)
	self.data.aid = aid
end
function allianceTaxWarehouse:destroyAID()
	self.data.aid = nil
end
function allianceTaxWarehouse:getAID()
	return self.data.aid
end
function allianceTaxWarehouse:initializeResData(data)
