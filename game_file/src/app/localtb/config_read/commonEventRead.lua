local commonEventRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	commonEventRead = nil
	;(nil)[1] = "activity_show_data"
	commonEventRead:defineValue("eventList", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "activityorder"
	;(nil)[2] = true
	commonEventRead:defineValue("eventRangeOrderList", nil)
end
init()
function commonEventRead.getInfoByEID(eid)
	local info = commonEventRead.eventList[eid]
	if info then
		return info
	else
		return nil
	end
end
function commonEventRead.getActivityShowByID(eid)
	local info = commonEventRead.eventList[eid]
	if info then
		return info.show == 1
	end
end
function commonEventRead.getActivityShowByRand()
	local began = 9000000
	local index = SoraDGetRandNum(1, began, began + table.nums(commonEventRead.eventList) - 1)[1]
	if commonEventRead.eventList[index] then
		local _, ret = SoraDIsFileExistByFileName(commonEventRead.eventList[index].image)
		return ret and commonEventRead.eventList[index].image or "bg_activity_03.png"
	else
		return commonEventRead.getActivityShowByRand()
	end
end
return commonEventRead
