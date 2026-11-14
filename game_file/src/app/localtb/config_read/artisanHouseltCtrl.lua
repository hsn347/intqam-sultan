local artisanHouseltCtrl = include("aAReadClass").new()
function artisanHouseltCtrl.init()
	_UPVALUE2_ = nil
	;(nil)[1] = "artisanhouseeffect"
	;(nil)[2] = true
	artisanHouseltCtrl:defineValue("artisanhouseeffect", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "artisanhouse"
	;(nil)[2] = true
	artisanHouseltCtrl:defineValue("artisanhouse", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "artisanhousequest"
	;(nil)[2] = true
	artisanHouseltCtrl:defineValue("artisanhousequest", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "artisanhouselv"
	;(nil)[2] = true
	artisanHouseltCtrl:defineValue("artisanhouselv", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "artisanhouserecharge"
	;(nil)[2] = true
	artisanHouseltCtrl:defineValue("artisanhouserecharge", nil)
end
function artisanHouseltCtrl.getBuffList()
	return artisanHouseltCtrl.artisanhouseeffect
end
function artisanHouseltCtrl.getBuffListEx()
	local artisanHouseCtrl = SoraDGetCtrl("artisanHouseCtrl")
	local limitMinLevel = artisanHouseCtrl:getLimitMinLevel()
	local _ENV, ret = artisanHouseCtrl, artisanHouseCtrl
	for i, v in ipairs(artisanHouseltCtrl.artisanhouseeffect) do
		if limitMinLevel <= v.CastleLv then
			table.insert(ret, v)
		end
	end
	return ret
end
function artisanHouseltCtrl.getAllAwardByIndex(index)
	if not index or not artisanHouseltCtrl.artisanhouse[index] then
		artisanHouseltCtrl, artisanHouseltCtrl = nil, artisanHouseltCtrl.artisanhouse[index]
		return artisanHouseltCtrl.artisanhouse[index], nil
	end
	return artisanHouseltCtrl.artisanhouse[index].AllReward1, artisanHouseltCtrl.artisanhouse[index].AllReward2
end
function artisanHouseltCtrl.getTaskListByIndex(index)
	if not index then
		artisanHouseltCtrl = nil
		return nil
	end
	local artisanHouseltCtrl, taskList
	if not artisanHouseltCtrl.artisanhouse[index] or not artisanHouseltCtrl.artisanhouse[index].QeustGroup then
		local artisanHouseltCtrl, qeustGroup = artisanHouseltCtrl.artisanhouse[index].QeustGroup, artisanHouseltCtrl.artisanhouse[index].QeustGroup
	end
	dump(qeustGroup, "qeustGroup")
	for i, v in ipairs(qeustGroup) do
		local qeustGroup = artisanHouseltCtrl.artisanhousequest[v]
		local taskSet = qeustGroup.QuestId
		local fogShow = qeustGroup.FogShow
		for i, taskID in ipairs(taskSet) do
			if not (not (0 < fogShow) or SoraDGetCtrl("artisanHouseCtrl"):isTaskShow(fogShow)) then
				break
			end
			if not SoraDGetCtrl("artisanHouseCtrl"):isTaskClaimed(taskID) then
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
function artisanHouseltCtrl.getLvRewardList(index)
	if not index then
		artisanHouseltCtrl = nil
		return nil
	end
	if not artisanHouseltCtrl.artisanhouse[index] or not artisanHouseltCtrl.artisanhouse[index].LvGroup then
		artisanHouseltCtrl = artisanHouseltCtrl.artisanhouse[index].LvGroup
	end
	return artisanHouseltCtrl.artisanhouse[index].LvGroup
end
function artisanHouseltCtrl.getUnlockItem(index)
	if not index then
		artisanHouseltCtrl = nil
		return nil
	end
	return artisanHouseltCtrl.artisanhouse[index] and artisanHouseltCtrl.artisanhouse[index].UnlockItem
end
function artisanHouseltCtrl.getRewardInfoByIndex(index)
	if not artisanHouseltCtrl.artisanhouselv[index] then
		artisanHouseltCtrl = artisanHouseltCtrl.artisanhouselv[index]
	end
	return artisanHouseltCtrl.artisanhouselv[index]
end
function artisanHouseltCtrl.getNextExp(level, index)
	for _, lvIndex in ipairs(artisanHouseltCtrl.getLvRewardList(index)) do
		if not artisanHouseltCtrl.getRewardInfoByIndex(lvIndex) then
			local _ENV, info = artisanHouseltCtrl.getRewardInfoByIndex(lvIndex), artisanHouseltCtrl.getRewardInfoByIndex(lvIndex)
		end
		if info.Lv == level + 1 then
			return info.NeedExp
		end
	end
	return 0
end
function artisanHouseltCtrl.getMaxExpLv(index)
	local maxLv = 0
	for _, lvIndex in ipairs(artisanHouseltCtrl.getLvRewardList(index)) do
		if not artisanHouseltCtrl.getRewardInfoByIndex(lvIndex) then
			local _ENV, info = artisanHouseltCtrl.getRewardInfoByIndex(lvIndex), artisanHouseltCtrl.getRewardInfoByIndex(lvIndex)
		end
		if maxLv < info.Lv then
			maxLv = info.Lv
		end
	end
	return maxLv
end
function artisanHouseltCtrl.getMaxEffectCastleLv()
	return artisanHouseltCtrl.artisanhouseeffect[#artisanHouseltCtrl.artisanhouseeffect].CastleLv
end
function artisanHouseltCtrl.getGiftAwardInfo(index)
	local UnlockGift = artisanHouseltCtrl.artisanhouse[index] and artisanHouseltCtrl.artisanhouse[index].UnlockGift
	if UnlockGift then
		for i, v in ipairs(artisanHouseltCtrl.artisanhouserecharge) do
			if v.RechargeID == tonumber(UnlockGift) then
				return v
			end
		end
	else
		artisanHouseltCtrl = ipairs(artisanHouseltCtrl.artisanhouserecharge)
		return ipairs(artisanHouseltCtrl.artisanhouserecharge)
	end
end
function artisanHouseltCtrl.getGiftId()
	return artisanHouseltCtrl.artisanhouserecharge[1].RechargeID
end
function artisanHouseltCtrl.getNowEffectInfo(lv)
	for i, v in ipairs(artisanHouseltCtrl.artisanhouseeffect) do
		if lv <= v.CastleLv then
			return v
		end
	end
	return artisanHouseltCtrl.artisanhouseeffect[#artisanHouseltCtrl.artisanhouseeffect]
end
artisanHouseltCtrl.init()
return artisanHouseltCtrl
