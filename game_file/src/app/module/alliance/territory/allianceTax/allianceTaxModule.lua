local allianceBuildingltCtrl = include("allianceBuildingltCtrl")
local allianceTaxRecord = include("allianceTaxRecord")
local allianceTaxWarehouse = include("allianceTaxWarehouse")
local allianceTaxltCtrl = include("allianceTaxltCtrl")
local allianceTaxModule = class("allianceTaxModule")
function allianceTaxModule:ctor()
	self.data, _UPVALUE0_ = nil, nil
end
function allianceTaxModule:initialize(data)
	local _UPVALUE0_, initializeData = nil, data or nil
	local recordData = initializeData.recordData
	self:initializeTaxRecord(recordData)
	local warehouseData = initializeData.warehouseData
	self:initializeWarehouse(warehouseData)
	local taxPer = data.taxPer
	self:setTaxPer(taxPer)
end
function allianceTaxModule:destroy()
	self:destroyTaxRecord()
	self:destroyWarehouse()
end
function allianceTaxModule:levyTaxes(taxInfo)
	local resInfo = taxInfo.res
	if "table" ~= type(resInfo) then
		return
	end
	local resID = resInfo.id
	local resCount = resInfo.num
	self:getTaxWarehouseModule():increaseRes(resID, resCount)
	self:getTaxRecordModule():newRecord(taxInfo)
	return gErrDef.Err_None
end
function allianceTaxModule:getRecordList(flag, count)
	return self:getTaxRecordModule():getRecordList(flag, count)
end
function allianceTaxModule:completeServerDataReq()
	self:getTaxRecordModule():completeServerDataReq()
end
function allianceTaxModule:getTaxWarehouseData()
	local showResArray = allianceTaxltCtrl:getWarehouseShowResArray()
	local resData = self:getTaxWarehouseModule():getResData()
	local allianceTaxltCtrl, ret = self:getTaxWarehouseModule(), self:getTaxWarehouseModule()
	for i, resID in ipairs(showResArray) do
		local allocateMin = allianceTaxltCtrl:getAllocateTaxResourceMin(resID)
		allianceTaxltCtrl = allianceTaxltCtrl
		allianceTaxltCtrl.resID = resID
		allianceTaxltCtrl.count = 0
		ret[resID], allianceTaxltCtrl.allocateMin = allianceTaxltCtrl, allocateMin
		if resData[tostring(resID)] then
			ret[resID].count = resData[tostring(resID)]
		end
	end
	return ret
end
function allianceTaxModule:setTaxWarehouseData(resData)
	self:getTaxWarehouseModule():initializeResData(resData)
end
function allianceTaxModule:allocateTaxes(resID)
	local resCount = self:getTaxWarehouseModule():getResCount(resID)
	self:getTaxWarehouseModule():decreaseRes(resID, resCount)
end
function allianceTaxModule:getTaxPer()
	local allianceScience = gModuleMgr.getObject("gametop").playertop_:getModule("allianceScience")
	local per = allianceScience:getScienceAddValue(gAScienceType.TERRITORY_TAX)
	if per then
		local taxPer = self.data.taxPer or 0
		taxPer = taxPer + per * 1000
		return taxPer
	end
	return self.data.taxPer
end
function allianceTaxModule:initializeTaxRecord(aid)
	self.data.taxRecord = allianceTaxRecord.new()
	self.data.taxRecord:initialize(aid)
end
function allianceTaxModule:destroyTaxRecord()
	self.data.taxRecord:destroy()
	self.data.taxRecord = nil
end
function allianceTaxModule:getTaxRecordModule()
	return self.data.taxRecord
end
function allianceTaxModule:initializeWarehouse(aid)
	self.data.warehouse = allianceTaxWarehouse.new()
	self.data.warehouse:initialize(aid)
end
function allianceTaxModule:destroyWarehouse()
	self.data.warehouse:destroy()
	self.data.warehouse = nil
end
function allianceTaxModule:getTaxWarehouseModule()
	return self.data.warehouse
end
function allianceTaxModule:setTaxPer(taxPer)
	self.data.taxPer = taxPer
end
return allianceTaxModule
