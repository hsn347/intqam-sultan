local anniversaryRead = include("aAReadClass").new()
function anniversaryRead.init()
	_UPVALUE2_ = nil
	;(nil)[1] = "cruise_arabia"
	;(nil)[2] = true
	anniversaryRead:defineValue("cruise_arabia", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "ramadan_pilgrimage"
	;(nil)[2] = true
	anniversaryRead:defineValue("ramadan_pilgrimage", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "ramadan_pilgrimage_2025"
	;(nil)[2] = true
	anniversaryRead:defineValue("ramadan_pilgrimage_2025", nil)
	_UPVALUE1_ = nil
	;(nil)[1] = "ramadan_pilgrimage_piont"
	anniversaryRead:defineValue("ramadan_pilgrimage_piont", nil)
	_UPVALUE1_ = nil
	;(nil)[1] = "ramadan_pilgrimage_piont_2025"
	anniversaryRead:defineValue("ramadan_pilgrimage_piont_2025", nil)
end
function anniversaryRead.getActDescByID(eid)
	for i, v in ipairs(anniversaryRead.cruise_arabia) do
		if v.activityID == eid then
			return v.activityDesc
		end
	end
	return nil
end
function anniversaryRead.getActIndexByID(eid)
	for i, v in ipairs(anniversaryRead.cruise_arabia) do
		if v.activityID == eid then
			return i
		end
	end
	return 0
end
function anniversaryRead.getActBgByID(eid)
	for i, v in ipairs(anniversaryRead.cruise_arabia) do
		if v.activityID == eid then
			return v.activity_bg
		end
	end
	return ""
end
function anniversaryRead.getActRewardByIDClasstype(eid, classType)
	for i, v in ipairs(anniversaryRead.cruise_arabia) do
		if v.activityID == eid and v.classType == classType then
			return v.awardShow
		end
	end
	_ENV = (for generator)
	return ipairs(anniversaryRead.cruise_arabia)
end
function anniversaryRead.getActNameByIDEX(eid, activityID)
	local tb = anniversaryRead.ramadan_pilgrimage
	if activityID == gActivityTimeActivityID.CALENDAR_9001690_ACTIVITY then
		tb = anniversaryRead.ramadan_pilgrimage_2025
	end
	for i, v in ipairs(tb) do
		if v.activityID == eid then
			return v.activityName
		end
	end
	return nil
end
function anniversaryRead.getActDescByIDEX(eid, activityID)
	local tb = anniversaryRead.ramadan_pilgrimage
	if activityID == gActivityTimeActivityID.CALENDAR_9001690_ACTIVITY then
		tb = anniversaryRead.ramadan_pilgrimage_2025
	end
	for i, v in ipairs(tb) do
		if v.activityID == eid then
			return v.activityDesc
		end
	end
	return nil
end
function anniversaryRead.getActCfgEX(showplace, classType, rType, activityID)
	local tb = anniversaryRead.ramadan_pilgrimage
	if activityID == gActivityTimeActivityID.CALENDAR_9001690_ACTIVITY then
		tb = anniversaryRead.ramadan_pilgrimage_2025
	end
	for i, v in ipairs(tb) do
		if v.showplace == showplace and v.classType == classType and v.RamadanType == rType then
			return v
		end
	end
end
function anniversaryRead.getOpenActCfgEX(rType, activityID)
	local anniversaryRead, cfg
	local tb = anniversaryRead.ramadan_pilgrimage
	if activityID == gActivityTimeActivityID.CALENDAR_9001690_ACTIVITY then
		tb = anniversaryRead.ramadan_pilgrimage_2025
	end
	local classType = activityID and SoraDGetActivityClassType(activityID) or 1
	for i, v in ipairs(tb) do
		if v.classType == classType and v.RamadanType == rType then
			table.insert(cfg, v.activityID)
		end
	end
	return cfg
end
function anniversaryRead.getActHoleCfgEX(week, classType, activityID)
	local anniversaryRead, ret
	local tb = anniversaryRead.ramadan_pilgrimage
	if activityID == gActivityTimeActivityID.CALENDAR_9001690_ACTIVITY then
		tb = anniversaryRead.ramadan_pilgrimage_2025
	end
	for i, v in ipairs(tb) do
		if v.showplace - 3 == week and v.classType == classType and v.RamadanType == 1 then
			table.insert(ret, v.activityID)
		end
	end
	return ret
end
function anniversaryRead.getActIndexByIDEX(eid, activityID)
	local tb = anniversaryRead.ramadan_pilgrimage
	if activityID == gActivityTimeActivityID.CALENDAR_9001690_ACTIVITY then
		tb = anniversaryRead.ramadan_pilgrimage_2025
	end
	for i, v in ipairs(tb) do
		if v.activityID == eid then
			return i
		end
	end
	return 0
end
function anniversaryRead.getActBgByIDEX(eid, activityID)
	local tb = anniversaryRead.ramadan_pilgrimage
	if activityID == gActivityTimeActivityID.CALENDAR_9001690_ACTIVITY then
		tb = anniversaryRead.ramadan_pilgrimage_2025
	end
	for i, v in ipairs(tb) do
		if v.activityID == eid then
			return v.activity_bg
		end
	end
	return ""
end
function anniversaryRead.getActRewardByIDClasstypeEX(eid, classType, activityID)
	local tb = anniversaryRead.ramadan_pilgrimage
	if activityID == gActivityTimeActivityID.CALENDAR_9001690_ACTIVITY then
		tb = anniversaryRead.ramadan_pilgrimage_2025
	end
	for i, v in ipairs(tb) do
		if v.activityID == eid and v.classType == classType then
			return v.awardShow
		end
	end
	anniversaryRead = (for generator)
	return ipairs(tb)
end
function anniversaryRead.haveActOpenOrNot()
	return false
end
function anniversaryRead.getActsNewFlag()
	return false
end
function anniversaryRead.haveActOpenOrNotEX()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local actConfig = activityShowCtrl:getParamByID(gActivityTimeActivityID.CALENDAR_9001593_ACTIVITY).showConfig
	for i, v in ipairs(actConfig) do
		if clientEventMgr.judgeIsOpen(v.activityID) then
			return true
		end
	end
	return false
end
function anniversaryRead.getActsNewFlagEX()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local actConfig = activityShowCtrl:getParamByID(gActivityTimeActivityID.CALENDAR_9001593_ACTIVITY).showConfig
	for i, v in ipairs(actConfig) do
		if anniversaryRead.getNewInfo(v.activityID) then
			return true
		end
	end
	return false
end
function anniversaryRead.getNewInfo(eid)
	if clientEventMgr.judgeIsOpen(eid) and clientEventMgr.getNewInfo(eid).isNew then
		return true
	end
	return false
end
function anniversaryRead.getPlaceIcon(rType, place, activityID)
	local tb = anniversaryRead.ramadan_pilgrimage_piont
	if activityID == gActivityTimeActivityID.CALENDAR_9001690_ACTIVITY then
		tb = anniversaryRead.ramadan_pilgrimage_piont_2025
	end
	for k, v in ipairs(tb) do
		if v.RamadanType == rType and v.showplace == place then
			return v.showicon
		end
	end
end
anniversaryRead.init()
return anniversaryRead
