local heroTrialltCtrl = include("heroTrialltCtrl")
local htLogMgr.log_list, _ENV, _ENV, htLogMgr = nil, nil, "heroTrialltCtrl", "heroTrialltCtrl"
local isInit = false
function htLogMgr.init(logList, mapID)
	if isInit then
		printError("heroTrial log: repeat to init the htLogMgr!")
		return
	end
	if logList and next(logList) then
		for k, v in pairs(logList) do
			v.logID = k
			table.insert(htLogMgr.log_list, v)
		end
	end
	if next(htLogMgr.log_list) then
		table.sort(htLogMgr.log_list, function(l, r)
			return tonumber(l.logID) > tonumber(r.logID)
		end)
	end
	htLogMgr.mapID = mapID
end
function htLogMgr.logout()
	htLogMgr.log_list, htLogMgr = nil, nil
end
function htLogMgr.record(logData)
	table.insert(htLogMgr.log_list, 1, logData)
	htLogMgr.autoRemoveLog()
end
function htLogMgr.getLogList()
	return htLogMgr.log_list
end
function htLogMgr.getLogDetail(logID)
	if not logID then
		return
	end
	for i, v in ipairs(htLogMgr.log_list) do
		if v.logID == logID then
			return v
		end
	end
end
function htLogMgr.reset(mapID)
	htLogMgr.log_list, htLogMgr = nil, nil
	htLogMgr.mapID = mapID
end
function htLogMgr.getMapID()
	return htLogMgr.mapID
end
function htLogMgr.dump()
end
function htLogMgr.autoRemoveLog()
	if #htLogMgr.log_list > 20 then
		table.remove(htLogMgr.log_list)
	end
end
return htLogMgr
