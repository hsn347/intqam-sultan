local htMapMgr = include("htMapMgr")
local _ENV, htLikeMgr = "htMapMgr", "htMapMgr"
local isInit = false
function htLikeMgr.init()
	if isInit then
		printError("heroTrial log: repeat ot init the htLikeMgr!")
		return
	end
	htLikeMgr.like_list, isInit = printError, printError
end
function htLikeMgr.logout()
	htLikeMgr.like_list, htLikeMgr = nil, nil
end
function htLikeMgr.like(mapID, uid)
	if not htMapMgr.whetherMapUnlock(mapID) then
		return gErrDef.Err_HT_MAP_NOT_UNLOCK
	end
	if htLikeMgr.whetherMapLikedToday(mapID) then
		return gErrDef.Err_HT_REPEAT_TO_LIKE
	end
	htLikeMgr.recordLike(mapID)
	return gErrDef.Err_None
end
function htLikeMgr.whetherMapLikedToday(mapID)
	local time = htLikeMgr.like_list[mapID]
	if not time then
		return false
	end
	if not serviceFunctions.isSameDay(time) then
		return true, false
	end
	return true, true
end
function htLikeMgr.recordLike(mapID, time)
	if not htLikeMgr.like_list[mapID] then
		htLikeMgr.like_list[mapID] = time or serviceFunctions.systemTime()
		return true
	end
	return false
end
function htLikeMgr.dump()
	for mapID, time in pairs(htLikeMgr.like_list) do
	end
end
return htLikeMgr
