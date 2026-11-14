local _ENV, reqAllianceTaxRecordAgent
function reqAllianceTaxRecordAgent:initialize()
	self.data, _UPVALUE0_ = nil, nil
	self:initializeFlag()
	self:initializeReqDataFlag()
end
function reqAllianceTaxRecordAgent:release()
	self:resetFlag()
end
function reqAllianceTaxRecordAgent:destory()
	self:resetFlag()
end
function reqAllianceTaxRecordAgent:getMoreRecord(count)
	local currentFlag = self:resetFlag()
	local ret, recordList, newFlag = self:getRecord(currentFlag, count)
	if gErrDef.Err_None ~= ret then
		return ret
	end
	self:setFlag(newFlag)
	return ret, recordList
end
function reqAllianceTaxRecordAgent:getRecord(flag, count)
	local kid = player:getKingdomId()
	local ret, recordList, newFlag = allianceLib.getAllianceTaxRecordList(gKingdomID, aid, flag, count)
	return ret, recordList, newFlag
end
function reqAllianceTaxRecordAgent:resetFlag()
	self:initializeFlag()
end
function reqAllianceTaxRecordAgent:completeAllReqData()
	self.data.needReq = false
end
function reqAllianceTaxRecordAgent:needRequestData()
	return self.data.needReq
end
function reqAllianceTaxRecordAgent:initializeFlag()
	local defaultFlag
	self:setFlag(defaultFlag)
end
function reqAllianceTaxRecordAgent:setFlag(flag)
	self.data.flag = flag
end
function reqAllianceTaxRecordAgent:getFlag()
	return self.data.flag
end
function reqAllianceTaxRecordAgent:initializeReqDataFlag()
	self.data.needReq = true
end
function reqAllianceTaxRecordAgent:getAllianceTerritoryCtrl()
	return serviceFunctions.getModule("allianceTerritoryCtrl")
end
return reqAllianceTaxRecordAgent
