local lordLocalData = include("aAReadClass").new()
function lordLocalData.init()
	_UPVALUE1_ = nil
	;(nil)[1] = "lordPowerInfoDes"
	lordLocalData:defineValue("powerInfo", nil)
	lordLocalData:defineValue("rankData", lordLocalData.initRankData)
	lordLocalData:defineValue("skillData", lordLocalData.initSkillData)
	lordLocalData:defineValue("headData", lordLocalData.initHeadData)
	lordLocalData:defineValue("skillCascade", lordLocalData.initSkillCascade)
	lordLocalData:defineValue("skillType", lordLocalData.initSkillType)
	lordLocalData:defineValue("bindAward", lordLocalData.initBindAward)
end
function lordLocalData.initRankData()
	lordLocalData.rankData, lordLocalData = nil, nil
	local rank = include("rank")
	for k, v in pairs(rank) do
		lordLocalData.rankData[v.Level] = v
	end
	return lordLocalData.rankData
end
function lordLocalData.getLordRankLevData()
	return lordLocalData.rankData
end
function lordLocalData.getRealMaxLordLevel()
	local maxLevel = 0
	for key, value in pairs(lordLocalData.rankData) do
		if maxLevel < value.Level then
			maxLevel = value.Level
		end
	end
	return maxLevel
end
function lordLocalData.initSkillData()
	lordLocalData.skillData, lordLocalData = nil, nil
	local skill = include("skill")
	for k, v in pairs(skill) do
		lordLocalData.skillData[v.skillID] = v
	end
	return lordLocalData.skillData
end
function lordLocalData.initBindAward()
	lordLocalData.bindAward, lordLocalData = nil, nil
	local bind_award = include("binding_reward")
	for k, v in ipairs(bind_award) do
		lordLocalData.bindAward[k] = v
	end
	return lordLocalData.bindAward
end
function lordLocalData.initHeadData()
	lordLocalData.headData, lordLocalData = nil, nil
	local head = include("head")
	for id, var in pairs(head) do
		lordLocalData.headData[tostring(id)] = var
	end
	return lordLocalData.headData
end
function lordLocalData.getLordPowerTableByKey(key)
	return lordLocalData.powerInfo[key]
end
function lordLocalData.isExclusiveConditionReach()
	local isTotalReach = false
	local exaltedPrivilegeCtrl = SoraDGetCtrl("exaltedPrivilegeCtrl")
	local premiumStoreCtrl = SoraDGetCtrl("premiumStoreCtrl")
	local exclusiveVipRead = include("exclusiveVipRead")
	local totalScore = exaltedPrivilegeCtrl:getTotalScores()
	local curPrivilegeList, curSore = exclusiveVipRead:getPrivilegeList(totalScore)
	local welfareInfo = exaltedPrivilegeCtrl:getWelfareInfo()
	local totalRecharge = premiumStoreCtrl:getDollor()
	local historyInfo, nextHistoryInfo = exclusiveVipRead:getReachRechargeInfo(totalRecharge)
	local needWeekGold = exclusiveVipRead:getWeeklyRechargeNeedGold()
	local weekTotalRecharge = exaltedPrivilegeCtrl:getWeekRechargeGold()
	local weekNeedHistoryRechargeGold = exclusiveVipRead:getweeklyHistoryRechargeNeedGold()
	local packageList, isPackageExit = exclusiveVipRead:getRechargeGiftInfo(totalRecharge)
	local isHistoryReach = false
	local isWeekReach = false
	if not historyInfo then
		if totalRecharge >= nextHistoryInfo.charge_amount then
			isHistoryReach = true
		end
	elseif totalRecharge >= historyInfo.charge_amount then
		isHistoryReach = true
	end
	if totalRecharge >= weekNeedHistoryRechargeGold then
		isWeekReach = true
	end
	if table.nums(curPrivilegeList) > 0 or table.nums(welfareInfo) > 0 or isPackageExit or isHistoryReach or isWeekReach then
		isTotalReach = true
	end
	return isTotalReach
end
function lordLocalData.getHeadList()
	local _ENV, headList
	for k, v in pairs(lordLocalData.headData) do
		if v.privilege == 0 or v.privilege == 2 then
			table.insert(headList, k)
		elseif v.privilege == 1 and lordLocalData.isExclusiveConditionReach() then
			table.insert(headList, k)
		end
	end
	table.sort(headList, function(l, r)
		return l < r
	end)
	return headList
end
function lordLocalData.getBindAward()
	return lordLocalData.bindAward
end
function lordLocalData.getPrefix(str, startIndex, endIndex)
	startIndex = startIndex or 0
	endIndex = endIndex or string.utf8len(str)
	return string.sub(str, startIndex, endIndex)
end
function lordLocalData.initSkillCascade()
	lordLocalData.skillCascade, lordLocalData = nil, nil
	local skill = include("skill")
	for key, var in ipairs(skill) do
		if var.skillPrepose1 ~= 0 or var.skillPrepose2 ~= 0 or var.skillPrepose3 ~= 0 then
			local lordLocalData, tempTab = var.skillPrepose3, var.skillPrepose3
			local prefix = lordLocalData.getPrefix(tostring(var.skillID), 0, 5)
			if var.skillPrepose1 ~= 0 then
				table.insert(tempTab, lordLocalData.getPrefix(tostring(var.skillPrepose1), 0, 5))
			end
			if var.skillPrepose2 ~= 0 then
				table.insert(tempTab, lordLocalData.getPrefix(tostring(var.skillPrepose2), 0, 5))
			end
			if var.skillPrepose3 ~= 0 then
				table.insert(tempTab, lordLocalData.getPrefix(tostring(var.skillPrepose3), 0, 5))
			end
			lordLocalData.skillCascade[prefix] = tempTab
		end
	end
	return lordLocalData.skillCascade
end
function lordLocalData.initSkillType()
	lordLocalData.skillType, (nil).auxiliary, lordLocalData, (nil).develop, lordLocalData, (nil).battle, lordLocalData, lordLocalData = nil, nil, nil, nil, nil, nil, nil, nil
	local skill = include("skill")
	for k, v in ipairs(skill) do
		local prefix = lordLocalData.getPrefix(tostring(v.skillID), 0, 5)
		if v.skillType == 1 then
			if lordLocalData.skillType.battle[prefix] == nil then
				lordLocalData = 0
				;(0).skillID = prefix
				;(0).isOpened = false
				;(0).currentLevel = 0
				;(0).maxLevel = v.skillMaxLv
				lordLocalData.skillType.battle[prefix], (0).isAcitve = 0, v.isAcitve == 1 and true or false
			end
		elseif v.skillType == 2 then
			if lordLocalData.skillType.develop[prefix] == nil then
				lordLocalData = 0
				;(0).skillID = prefix
				;(0).isOpened = false
				;(0).currentLevel = 0
				;(0).maxLevel = v.skillMaxLv
				lordLocalData.skillType.develop[prefix], (0).isAcitve = 0, v.isAcitve == 1 and true or false
			end
		elseif v.skillType == 3 and lordLocalData.skillType.auxiliary[prefix] == nil then
			lordLocalData = 0
			;(0).skillID = prefix
			;(0).isOpened = false
			;(0).currentLevel = 0
			;(0).maxLevel = v.skillMaxLv
			lordLocalData.skillType.auxiliary[prefix], (0).isAcitve = 0, v.isAcitve == 1 and true or false
		end
	end
	return lordLocalData.skillType
end
function lordLocalData.getItemConfig(imageID)
	imageID = tostring(imageID)
	return lordLocalData.headData[imageID].item
end
function lordLocalData.getPortrait(imageID, fromMemory)
	imageID = tostring(imageID)
	if fromMemory then
		return "#" .. lordLocalData.headData[imageID].bust
	end
	return lordLocalData.headData[imageID].bust
end
function lordLocalData.getImageData(imageID)
	imageID = tostring(imageID)
	return lordLocalData.headData[imageID]
end
function lordLocalData.getHead(imageID, fromMemory)
	if nil == imageID then
		imageID = "head_m_001.png"
		if fromMemory then
			imageID = "#" .. imageID
		end
		return imageID
	end
	imageID = tostring(imageID)
	if fromMemory then
		return "#" .. lordLocalData.headData[imageID].head
	end
	return lordLocalData.headData[imageID] and lordLocalData.headData[imageID].head or "head_m_001.png"
end
function lordLocalData.getBust(imageID, fromMemory)
	if imageID ~= nil then
		imageID = tostring(imageID)
		if fromMemory then
			return "#" .. lordLocalData.headData[imageID].middle_head
		end
		return lordLocalData.headData[imageID] and lordLocalData.headData[imageID].middle_head or lordLocalData.headData["1401"].middle_head
	else
		return lordLocalData.headData["1401"].middle_head
	end
end
function lordLocalData.__localGetMaxLordLev()
	print("lordLocalData.__localGetMaxLordLev, 这个接口已经废弃，直接使用lordInfoCtrl:getMaxLordLev()", debug.traceback())
	local kingdomLevelDataModuleAPI = include("kingdomLevelDataModuleAPI")
	local curServerLev = kingdomLevelDataModuleAPI:getKingdomLevel() or 0
	local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
	local maxLev = MAX_LORD_LV_NOLIMIT
	if lordLocalData.rankData then
		local i = 1
		for i = MAX_LORD_LV_NOLIMIT, #lordLocalData.rankData do
			if lordLocalData.rankData[i] and curServerLev >= lordLocalData.rankData[i].kingdomLv and maxLev < lordLocalData.rankData[i].Level then
				maxLev = lordLocalData.rankData[i].Level
			end
		end
	end
	local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
	local retType = nebulaActivityCtrl:getKingdomRegionType()
	if retType == NEBULA_REGION_TYPE.SEPARATIST_REGIME then
		local constantRead = include("constantRead")
		_UPVALUE3_ = lordLocalData.rankData[i]
		lordLocalData.rankData[i][1] = 1733097600
		lordLocalData.rankData[i][2] = 95
		lordLocalData.rankData[i][3] = 80
		local arrValue = constantRead.getConstValueArray("NEW_AREA_LORD_MAXLV", lordLocalData.rankData[i])
		local time = arrValue[1]
		local newMaxLv = arrValue[2]
		local oldMaxLv = arrValue[3]
		local curTime = serviceFunctions.systemTime()
		if time <= curTime then
			maxLev = math.min(maxLev, newMaxLv)
		else
			maxLev = math.min(maxLev, oldMaxLv)
		end
	else
		maxLev = math.min(maxLev, MAX_LORD_LV_LIMIT)
	end
	maxLev = nebulaMileStoneCtrl:getPlusByUnlockType(gNebulaMileStoneUnlockType.LORD_LEVEL_MAX, maxLev)
	return maxLev
end
function lordLocalData.getMaxLordLev()
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	return lordInfoCtrl:getMaxLordLev()
end
function lordLocalData.getMaxLordLv()
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	return lordInfoCtrl:getMaxLordLev()
end
lordLocalData.init()
return lordLocalData
