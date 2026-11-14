local shiftingstarsRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "passing_of_night"
;(nil)[2] = true
shiftingstarsRead:defineValue("passing_of_night", nil)
_UPVALUE2_ = nil
;(nil)[1] = "nyactivity_info"
;(nil)[2] = true
shiftingstarsRead:defineValue("nyactivity_info", nil)
function shiftingstarsRead.getActDescByID(eid)
	for i, v in ipairs(shiftingstarsRead.passing_of_night) do
		if v.activityID == eid then
			return v.activityDesc
		end
	end
	return nil
end
function shiftingstarsRead.getActDescByIDEX(eid)
	for i, v in ipairs(shiftingstarsRead.nyactivity_info) do
		if v.activityID == eid then
			return v.activityDesc
		end
	end
	return nil
end
function shiftingstarsRead.getActIndexByID(eid)
	for i, v in ipairs(shiftingstarsRead.passing_of_night) do
		if v.activityID == eid then
			return i
		end
	end
	return 0
end
function shiftingstarsRead.getActBgByID(eid)
	for i, v in ipairs(shiftingstarsRead.passing_of_night) do
		if v.activityID == eid then
			return v.activity_bg
		end
	end
	return ""
end
function shiftingstarsRead.getActBgByIDEX(eid)
	for i, v in ipairs(shiftingstarsRead.nyactivity_info) do
		if v.activityID == eid then
			return v.activity_bg
		end
	end
	return ""
end
function shiftingstarsRead.getActRewardByIDClasstype(eid, classType)
	for i, v in ipairs(shiftingstarsRead.passing_of_night) do
		if v.activityID == eid and v.classType == classType then
			return v.awardShow
		end
	end
	_ENV = (for generator)
	return ipairs(shiftingstarsRead.passing_of_night)
end
function shiftingstarsRead.getActRewardByIDClasstypeEX(eid, classType)
	for i, v in ipairs(shiftingstarsRead.nyactivity_info) do
		if v.activityID == eid and v.classType == classType then
			return v.awardShow
		end
	end
	_ENV = (for generator)
	return ipairs(shiftingstarsRead.nyactivity_info)
end
function shiftingstarsRead.haveActOpenOrNot()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local actConfig = activityShowCtrl:getParamByID(gActivityTimeActivityID.SHIFTING_STARS_ACTIVITY).showConfig
	for i, v in ipairs(actConfig) do
		if clientEventMgr.judgeIsOpen(v.activityID) then
			return true
		end
	end
	return false
end
function shiftingstarsRead.getActsNewFlag()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local actConfig = activityShowCtrl:getParamByID(gActivityTimeActivityID.SHIFTING_STARS_ACTIVITY).showConfig
	for i, v in ipairs(actConfig) do
		if shiftingstarsRead.getNewInfo(v.activityID) then
			return true
		end
	end
	return false
end
function shiftingstarsRead.getNewInfo(eid)
	if clientEventMgr.judgeIsOpen(eid) and clientEventMgr.getNewInfo(eid).isNew then
		return true
	end
	return false
end
return shiftingstarsRead
