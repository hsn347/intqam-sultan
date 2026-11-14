local scoutRecordDataMgr = class("scoutRecordDataMgr")
function scoutRecordDataMgr:ctor()
	self.recordMap, _UPVALUE0_ = nil, nil
end
function scoutRecordDataMgr:setRecordMap(recordMap)
	if type(recordMap) == "table" then
		self.recordMap = recordMap
	end
end
function scoutRecordDataMgr:findRecord(uid)
	return self.recordMap[tostring(uid)]
end
function scoutRecordDataMgr:addRecord(uid, record)
	self.recordMap[tostring(uid)] = record
end
function scoutRecordDataMgr:delRecord(uid, mailId)
	local record = self.recordMap[tostring(uid)]
	if record and (not mailId or mailId == record.mailId) then
		self.recordMap[tostring(uid)] = nil
		return record
	end
end
return scoutRecordDataMgr
