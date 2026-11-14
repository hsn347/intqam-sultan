local radiantDecreeRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "gloriousdecreeffect"
;(nil)[2] = true
radiantDecreeRead:defineValue("gloriousdecreeffect", nil)
_UPVALUE2_ = nil
;(nil)[1] = "bravestatueeffect"
;(nil)[2] = true
radiantDecreeRead:defineValue("bravestatueeffect", nil)
_UPVALUE2_ = nil
;(nil)[1] = "gloriousdecree"
;(nil)[2] = true
radiantDecreeRead:defineValue("gloriousdecree", nil)
_UPVALUE2_ = nil
;(nil)[1] = "gloriousdecreequest"
;(nil)[2] = true
radiantDecreeRead:defineValue("gloriousdecreequest", nil)
_UPVALUE2_ = nil
;(nil)[1] = "gloriousdecreelv"
;(nil)[2] = true
radiantDecreeRead:defineValue("gloriousdecreelv", nil)
_UPVALUE2_ = nil
;(nil)[1] = "gloriousdecreerecharge"
;(nil)[2] = true
radiantDecreeRead:defineValue("gloriousdecreerecharge", nil)
_UPVALUE2_ = nil
;(nil)[1] = "bravestatuerecharge"
;(nil)[2] = true
radiantDecreeRead:defineValue("bravestatuerecharge", nil)
function radiantDecreeRead.getBuffList(canUnlockStatue)
	if canUnlockStatue then
		return radiantDecreeRead.bravestatueeffect
	else
		return radiantDecreeRead.gloriousdecreeffect
	end
end
function radiantDecreeRead.getAllAwardByIndex(index)
	return radiantDecreeRead.gloriousdecree[index].AllReward1, radiantDecreeRead.gloriousdecree[index].AllReward2
end
function radiantDecreeRead.getTaskListByIndex(index)
	if not index then
		radiantDecreeRead = nil
		return nil
	end
	local radiantDecreeRead, taskList
	if not radiantDecreeRead.gloriousdecree[index] or not radiantDecreeRead.gloriousdecree[index].QeustGroup then
		local radiantDecreeRead, qeustGroup = radiantDecreeRead.gloriousdecree[index].QeustGroup, radiantDecreeRead.gloriousdecree[index].QeustGroup
	end
	for i, v in ipairs(qeustGroup) do
		local qeustGroup = radiantDecreeRead.gloriousdecreequest[v]
		local taskSet = qeustGroup.QuestId
		local fogShow = qeustGroup.FogShow
		for i, taskID in ipairs(taskSet) do
			if not (not (0 < fogShow) or SoraDGetCtrl("radiantDecreeCtrl"):isTaskShow(fogShow)) then
				break
			end
			if not SoraDGetCtrl("radiantDecreeCtrl"):isTaskClaimed(taskID) then
				table.insert(taskList, taskID)
				break
			elseif i == #taskSet then
				table.insert(taskList, taskID)
				break
			end
		end
	end
	return taskList
end
function radiantDecreeRead.getLvRewardList(index)
	if not index then
		radiantDecreeRead = nil
		return nil
	end
	if not radiantDecreeRead.gloriousdecree[index] or not radiantDecreeRead.gloriousdecree[index].LvGroup then
		radiantDecreeRead = radiantDecreeRead.gloriousdecree[index].LvGroup
	end
	return radiantDecreeRead.gloriousdecree[index].LvGroup
end
function radiantDecreeRead.getUnlockItem(index)
	if not index then
		radiantDecreeRead = nil
		return nil
	end
	return radiantDecreeRead.gloriousdecree[index] and radiantDecreeRead.gloriousdecree[index].UnlockItem
end
function radiantDecreeRead.getRewardInfoByIndex(index)
	if not radiantDecreeRead.gloriousdecreelv[index] then
		radiantDecreeRead = radiantDecreeRead.gloriousdecreelv[index]
	end
	return radiantDecreeRead.gloriousdecreelv[index]
end
function radiantDecreeRead.getBuffLimitLv(index)
	return radiantDecreeRead.gloriousdecree[index] and radiantDecreeRead.gloriousdecree[index].BuffLv or 0
end
function radiantDecreeRead.getNextExp(level, index)
	for _, lvIndex in ipairs(radiantDecreeRead.getLvRewardList(index)) do
		if not radiantDecreeRead.getRewardInfoByIndex(lvIndex) then
			local _ENV, info = radiantDecreeRead.getRewardInfoByIndex(lvIndex), radiantDecreeRead.getRewardInfoByIndex(lvIndex)
		end
		if info.Lv == level + 1 then
			return info.NeedExp
		end
	end
	return 0
end
function radiantDecreeRead.getMaxExpLvIndex(level, index)
	for _, lvIndex in ipairs(radiantDecreeRead.getLvRewardList(index)) do
		if not radiantDecreeRead.getRewardInfoByIndex(lvIndex) then
			local _ENV, info = radiantDecreeRead.getRewardInfoByIndex(lvIndex), radiantDecreeRead.getRewardInfoByIndex(lvIndex)
		end
		if info.Lv == level then
			return info.Index
		end
	end
	return 0
end
function radiantDecreeRead.getMaxExpLv(index)
	local maxLv = 0
	for _, lvIndex in ipairs(radiantDecreeRead.getLvRewardList(index)) do
		if not radiantDecreeRead.getRewardInfoByIndex(lvIndex) then
			local _ENV, info = radiantDecreeRead.getRewardInfoByIndex(lvIndex), radiantDecreeRead.getRewardInfoByIndex(lvIndex)
		end
		if maxLv < info.Lv then
			maxLv = info.Lv
		end
	end
	return maxLv
end
function radiantDecreeRead.getMaxEffectCastleLv()
	return radiantDecreeRead.gloriousdecreeffect[#radiantDecreeRead.gloriousdecreeffect].CastleLv
end
function radiantDecreeRead.getGiftAwardInfo(index, isStatue)
	if isStatue then
		return radiantDecreeRead.bravestatuerecharge[index]
	else
		return radiantDecreeRead.gloriousdecreerecharge[index]
	end
end
function radiantDecreeRead.getGiftInfoByRid(rid)
	for i, v in ipairs(radiantDecreeRead.bravestatuerecharge) do
		if v.RechargeID == rid then
			return v
		end
	end
	for i, v in ipairs(radiantDecreeRead.gloriousdecreerecharge) do
		if v.RechargeID == rid then
			return v
		end
	end
	_ENV = (for generator)
	return ipairs(radiantDecreeRead.gloriousdecreerecharge)
end
function radiantDecreeRead.getGiftIndex(openLv, isStatue)
	if isStatue then
		for i, v in ipairs(radiantDecreeRead.bravestatuerecharge) do
			if openLv >= v.BraveLv[1] and openLv <= v.BraveLv[2] then
				return i
			end
		end
		return #radiantDecreeRead.bravestatuerecharge
	else
		for i, v in ipairs(radiantDecreeRead.gloriousdecreerecharge) do
			if openLv >= v.CastleLv[1] and openLv <= v.CastleLv[2] then
				return i
			end
		end
		return #radiantDecreeRead.gloriousdecreerecharge
	end
end
function radiantDecreeRead.getGiftId(index)
	return radiantDecreeRead.gloriousdecreerecharge[index].RechargeID
end
function radiantDecreeRead.getNowEffectInfo()
	local radiantDecreeCtrl = SoraDGetCtrl("radiantDecreeCtrl")
	local castleLevel = radiantDecreeCtrl:getActivityData().castleLevel or 0
	local effectInfo
	for i, v in ipairs(radiantDecreeRead.gloriousdecreeffect) do
		if castleLevel <= v.CastleLv then
			return v
		end
	end
	if effectInfo == nil then
		effectInfo = radiantDecreeRead.gloriousdecreeffect[#radiantDecreeRead.gloriousdecreeffect]
	end
	return effectInfo
end
function radiantDecreeRead.getNowStatueEffectInfo()
	local radiantDecreeCtrl = SoraDGetCtrl("radiantDecreeCtrl")
	local statueLevel = radiantDecreeCtrl:getActivityData().statueLevel
	local effectInfo
	for i, v in ipairs(radiantDecreeRead.bravestatueeffect) do
		if statueLevel <= v.BraveLv then
			return v
		end
	end
	if effectInfo == nil then
		effectInfo = radiantDecreeRead.bravestatueeffect[#radiantDecreeRead.bravestatueeffect]
	end
	return effectInfo
end
function radiantDecreeRead.getLastNowEffectInfo()
	return radiantDecreeRead.gloriousdecreeffect[#radiantDecreeRead.gloriousdecreeffect]
end
function radiantDecreeRead.getLastNowStatueEffectInfo()
	return radiantDecreeRead.bravestatueeffect[#radiantDecreeRead.bravestatueeffect]
end
function radiantDecreeRead.getNowEffectIndex()
	local radiantDecreeCtrl = SoraDGetCtrl("radiantDecreeCtrl")
	local castleLevel = radiantDecreeCtrl:getActivityData().castleLevel
	local effectInfo
	for i, v in ipairs(radiantDecreeRead.gloriousdecreeffect) do
		if castleLevel <= v.CastleLv then
			return i
		end
	end
	return #radiantDecreeRead.gloriousdecreeffect
end
function radiantDecreeRead.getNowStatueEffectIndex()
	local radiantDecreeCtrl = SoraDGetCtrl("radiantDecreeCtrl")
	local statueLevel = radiantDecreeCtrl:getActivityData().statueLevel
	local effectInfo
	for i, v in ipairs(radiantDecreeRead.bravestatueeffect) do
		if statueLevel <= v.BraveLv then
			return i
		end
	end
	return #radiantDecreeRead.bravestatueeffect
end
function radiantDecreeRead.getMaxEffectLevel(isStatue)
	if isStatue then
		return radiantDecreeRead.bravestatueeffect[#radiantDecreeRead.bravestatueeffect].BraveLv
	else
		return radiantDecreeRead.gloriousdecreeffect[#radiantDecreeRead.gloriousdecreeffect].CastleLv
	end
end
function radiantDecreeRead.getMaxEffectInfo(isStatue)
	if isStatue then
		return radiantDecreeRead.bravestatueeffect[#radiantDecreeRead.bravestatueeffect]
	else
		return radiantDecreeRead.gloriousdecreeffect[#radiantDecreeRead.gloriousdecreeffect]
	end
end
return radiantDecreeRead
