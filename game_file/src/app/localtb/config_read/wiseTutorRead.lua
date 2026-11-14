local wiseTutorRead = include("aAReadClass").new()
function wiseTutorRead.init()
	_UPVALUE2_ = nil
	;(nil)[1] = "battletowerseffect"
	;(nil)[2] = true
	wiseTutorRead:defineValue("battletowereffect", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "battletowers"
	;(nil)[2] = true
	wiseTutorRead:defineValue("battletowers", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "battletowersquest"
	;(nil)[2] = true
	wiseTutorRead:defineValue("battleTowersQuest", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "battletowerslv"
	;(nil)[2] = true
	wiseTutorRead:defineValue("battleTowersLv", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "battletowersrecharge"
	;(nil)[2] = true
	wiseTutorRead:defineValue("battleTowersRecharge", nil)
end
function wiseTutorRead.getBuffList()
	return wiseTutorRead.battletowereffect
end
function wiseTutorRead.getAllAwardByIndex(index)
	if not index or not wiseTutorRead.battletowers[index] then
		wiseTutorRead, wiseTutorRead = nil, wiseTutorRead.battletowers[index]
		return wiseTutorRead.battletowers[index], nil
	end
	return wiseTutorRead.battletowers[index].AllReward1, wiseTutorRead.battletowers[index].AllReward2
end
function wiseTutorRead.getTaskListByIndex(index)
	if not index then
		wiseTutorRead = nil
		return nil
	end
	local wiseTutorRead, taskList
	if not wiseTutorRead.battletowers[index] or not wiseTutorRead.battletowers[index].QeustGroup then
		local wiseTutorRead, qeustGroup = wiseTutorRead.battletowers[index].QeustGroup, wiseTutorRead.battletowers[index].QeustGroup
	end
	dump(qeustGroup, "qeustGroup")
	for i, v in ipairs(qeustGroup) do
		local qeustGroup = wiseTutorRead.battleTowersQuest[v]
		local taskSet = qeustGroup.QuestId
		local fogShow = qeustGroup.FogShow
		for i, taskID in ipairs(taskSet) do
			if not (not (0 < fogShow) or SoraDGetCtrl("wiseTutorCtrl"):isTaskShow(fogShow)) then
				break
			end
			if not SoraDGetCtrl("wiseTutorCtrl"):isTaskClaimed(taskID) then
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
function wiseTutorRead.getLvRewardList(index)
	if not index then
		wiseTutorRead = nil
		return nil
	end
	if not wiseTutorRead.battletowers[index] or not wiseTutorRead.battletowers[index].LvGroup then
		wiseTutorRead = wiseTutorRead.battletowers[index].LvGroup
	end
	return wiseTutorRead.battletowers[index].LvGroup
end
function wiseTutorRead.getUnlockItem(index)
	if not index then
		wiseTutorRead = nil
		return nil
	end
	return wiseTutorRead.battletowers[index] and wiseTutorRead.battletowers[index].UnlockItem
end
function wiseTutorRead.getRewardInfoByIndex(index)
	if not wiseTutorRead.battleTowersLv[index] then
		wiseTutorRead = wiseTutorRead.battleTowersLv[index]
	end
	return wiseTutorRead.battleTowersLv[index]
end
function wiseTutorRead.getNextExp(level, index)
	for _, lvIndex in ipairs(wiseTutorRead.getLvRewardList(index)) do
		if not wiseTutorRead.getRewardInfoByIndex(lvIndex) then
			local _ENV, info = wiseTutorRead.getRewardInfoByIndex(lvIndex), wiseTutorRead.getRewardInfoByIndex(lvIndex)
		end
		if info.Lv == level + 1 then
			return info.NeedExp
		end
	end
	return 0
end
function wiseTutorRead.getMaxExpLv(index)
	local maxLv = 0
	for _, lvIndex in ipairs(wiseTutorRead.getLvRewardList(index)) do
		if not wiseTutorRead.getRewardInfoByIndex(lvIndex) then
			local _ENV, info = wiseTutorRead.getRewardInfoByIndex(lvIndex), wiseTutorRead.getRewardInfoByIndex(lvIndex)
		end
		if maxLv < info.Lv then
			maxLv = info.Lv
		end
	end
	return maxLv
end
function wiseTutorRead.getMaxEffectCastleLv()
	return wiseTutorRead.battletowereffect[#wiseTutorRead.battletowereffect].CastleLv
end
function wiseTutorRead.getGiftAwardInfo(index)
	local UnlockGift = wiseTutorRead.battletowers[index] and wiseTutorRead.battletowers[index].UnlockGift
	if UnlockGift then
		for i, v in ipairs(wiseTutorRead.battleTowersRecharge) do
			if v.RechargeID == tonumber(UnlockGift) then
				return v
			end
		end
	else
		wiseTutorRead = ipairs(wiseTutorRead.battleTowersRecharge)
		return ipairs(wiseTutorRead.battleTowersRecharge)
	end
end
function wiseTutorRead.getNowEffectInfo(lv)
	for i, v in ipairs(wiseTutorRead.battletowereffect) do
		if lv <= v.CastleLv then
			return v
		end
	end
	return wiseTutorRead.battletowereffect[#wiseTutorRead.battletowereffect]
end
wiseTutorRead.init()
return wiseTutorRead
