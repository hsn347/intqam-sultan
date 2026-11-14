local allianceTaxRecord = class("allianceTaxRecord")
function allianceTaxRecord:ctor()
	self.data, _UPVALUE0_ = nil, nil
end
function allianceTaxRecord:initialize(data)
	self:initializeReocrdData(data)
	self:initializeServerReqFlag()
end
function allianceTaxRecord:destroy()
	self:initializeReocrdData()
	self:initializeServerReqFlag()
end
function allianceTaxRecord:newRecord(data)
	local recordID = data.recordID
	self:insertRecord(recordID, data)
	self:removeRecordBeyondLimit(recordID)
	return gErrDef.Err_None
end
function allianceTaxRecord:getRecordList(recordID, count)
	if not self:hasRecordData() then
		return gErrDef.Err_ALLIANCE_TAX_NO_MORE_RECORD
	end
	local recordIDBegin = tonumber(recordID)
	if nil == recordIDBegin then
		recordIDBegin = tonumber(self:getNewestRecordID())
	else
		recordIDBegin = recordIDBegin - 1
	end
	local _ENV, ret = tonumber(self:getNewestRecordID()), tonumber(self:getNewestRecordID())
	local lastRecordID
	local more = true
	for i = 1, count do
		local rid = self:transferAutoIDToRecordID(recordIDBegin)
		local data = self:getRecord(rid)
		if data then
			table.insert(ret, data)
			lastRecordID = rid
			recordIDBegin = recordIDBegin - 1
		else
			break
		end
	end
	if more then
		local rid = self:transferAutoIDToRecordID(recordIDBegin)
		if not self:getRecord(rid) then
			more = false
		end
	end
	if 0 < #ret then
		return gErrDef.Err_None, ret, lastRecordID, more
	end
	return gErrDef.Err_ALLIANCE_TAX_NO_MORE_RECORD
end
function allianceTaxRecord:moreRecordLocalData(recordID)
	if nil == recordID then
		return self:hasRecordData()
	end
	local i = recordID - 1
	local rid = self:transferAutoIDToRecordID(i)
	local data = self:getRecord(rid)
	if data then
		return true
	end
	return false
end
function allianceTaxRecord:completeServerDataReq()
	self.data.moreServerData = false
end
function allianceTaxRecord:moreRecordServerData()
	return self.data.moreServerData
end
function allianceTaxRecord:initializeReocrdData(data)
