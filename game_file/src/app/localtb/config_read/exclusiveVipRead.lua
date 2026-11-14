local exclusiveVipRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_ENV = nil
	;(nil)[1] = "honourable_vip_integral"
	;(nil)[2] = true
	exclusiveVipRead:defineValue("hvi", nil)
	_ENV = nil
	;(nil)[1] = "honourable_vip_welfare"
	;(nil)[2] = true
	exclusiveVipRead:defineValue("hvw", nil)
	_ENV = nil
	;(nil)[1] = "honourable_week_recharge"
	;(nil)[2] = true
	exclusiveVipRead:defineValue("hwr", nil)
	exclusiveVipRead:defineValue("hwrConfig", function()
		local _ENV, ret
		for i, v in ipairs(exclusiveVipRead.hwr) do
			if v.areaGroup then
				if not ret[v.areaGroup] then
					_ENV = ret[v.areaGroup]
				end
				ret[v.areaGroup] = ret[v.areaGroup]
				table.insert(ret[v.areaGroup], v)
			end
		end
		return ret
	end)
	function _ENV()
		local _ENV, ret
		for i, v in ipairs(exclusiveVipRead.hwr) do
			if v.areaGroup then
				if not ret[v.areaGroup] then
					_ENV = ret[v.areaGroup]
				end
				ret[v.areaGroup] = ret[v.areaGroup]
				table.insert(ret[v.areaGroup], v)
			end
		end
		return ret
	end
	;(function()
		local _ENV, ret
		for i, v in ipairs(exclusiveVipRead.hwr) do
			if v.areaGroup then
				if not ret[v.areaGroup] then
					_ENV = ret[v.areaGroup]
				end
				ret[v.areaGroup] = ret[v.areaGroup]
				table.insert(ret[v.areaGroup], v)
			end
		end
		return ret
	end)[1] = "honourable_vip_privilege_get"
	;(function()
		local _ENV, ret
		for i, v in ipairs(exclusiveVipRead.hwr) do
			if v.areaGroup then
				if not ret[v.areaGroup] then
					_ENV = ret[v.areaGroup]
				end
				ret[v.areaGroup] = ret[v.areaGroup]
				table.insert(ret[v.areaGroup], v)
			end
		end
		return ret
	end)[2] = true
	exclusiveVipRead:defineValue("hvpg", function()
		local _ENV, ret
		for i, v in ipairs(exclusiveVipRead.hwr) do
			if v.areaGroup then
				if not ret[v.areaGroup] then
					_ENV = ret[v.areaGroup]
				end
				ret[v.areaGroup] = ret[v.areaGroup]
				table.insert(ret[v.areaGroup], v)
			end
		end
		return ret
	end)
	function _ENV()
		local _ENV, ret
		for i, v in ipairs(exclusiveVipRead.hwr) do
			if v.areaGroup then
				if not ret[v.areaGroup] then
					_ENV = ret[v.areaGroup]
				end
				ret[v.areaGroup] = ret[v.areaGroup]
				table.insert(ret[v.areaGroup], v)
			end
		end
		return ret
	end
	;(function()
		local _ENV, ret
		for i, v in ipairs(exclusiveVipRead.hwr) do
			if v.areaGroup then
				if not ret[v.areaGroup] then
					_ENV = ret[v.areaGroup]
				end
				ret[v.areaGroup] = ret[v.areaGroup]
				table.insert(ret[v.areaGroup], v)
			end
		end
		return ret
	end)[1] = "honourable_vip_privilege_unlock"
	;(function()
		local _ENV, ret
		for i, v in ipairs(exclusiveVipRead.hwr) do
			if v.areaGroup then
				if not ret[v.areaGroup] then
					_ENV = ret[v.areaGroup]
				end
				ret[v.areaGroup] = ret[v.areaGroup]
				table.insert(ret[v.areaGroup], v)
			end
		end
		return ret
	end)[2] = true
	exclusiveVipRead:defineValue("hvpu", function()
		local _ENV, ret
		for i, v in ipairs(exclusiveVipRead.hwr) do
			if v.areaGroup then
				if not ret[v.areaGroup] then
					_ENV = ret[v.areaGroup]
				end
				ret[v.areaGroup] = ret[v.areaGroup]
				table.insert(ret[v.areaGroup], v)
			end
		end
		return ret
	end)
	function _ENV()
		local _ENV, ret
		for i, v in ipairs(exclusiveVipRead.hwr) do
			if v.areaGroup then
				if not ret[v.areaGroup] then
					_ENV = ret[v.areaGroup]
				end
				ret[v.areaGroup] = ret[v.areaGroup]
				table.insert(ret[v.areaGroup], v)
			end
		end
		return ret
	end
	;(function()
		local _ENV, ret
		for i, v in ipairs(exclusiveVipRead.hwr) do
			if v.areaGroup then
				if not ret[v.areaGroup] then
					_ENV = ret[v.areaGroup]
				end
				ret[v.areaGroup] = ret[v.areaGroup]
				table.insert(ret[v.areaGroup], v)
			end
		end
		return ret
	end)[1] = "history_cumu_reward"
	;(function()
		local _ENV, ret
		for i, v in ipairs(exclusiveVipRead.hwr) do
			if v.areaGroup then
				if not ret[v.areaGroup] then
					_ENV = ret[v.areaGroup]
				end
				ret[v.areaGroup] = ret[v.areaGroup]
				table.insert(ret[v.areaGroup], v)
			end
		end
		return ret
	end)[2] = true
	exclusiveVipRead:defineValue("hcr", function()
		local _ENV, ret
		for i, v in ipairs(exclusiveVipRead.hwr) do
			if v.areaGroup then
				if not ret[v.areaGroup] then
					_ENV = ret[v.areaGroup]
				end
				ret[v.areaGroup] = ret[v.areaGroup]
				table.insert(ret[v.areaGroup], v)
			end
		end
		return ret
	end)
	function _ENV()
		local _ENV, ret
		for i, v in ipairs(exclusiveVipRead.hwr) do
			if v.areaGroup then
				if not ret[v.areaGroup] then
					_ENV = ret[v.areaGroup]
				end
				ret[v.areaGroup] = ret[v.areaGroup]
				table.insert(ret[v.areaGroup], v)
			end
		end
		return ret
	end
	;(function()
		local _ENV, ret
		for i, v in ipairs(exclusiveVipRead.hwr) do
			if v.areaGroup then
				if not ret[v.areaGroup] then
					_ENV = ret[v.areaGroup]
				end
				ret[v.areaGroup] = ret[v.areaGroup]
				table.insert(ret[v.areaGroup], v)
			end
		end
		return ret
	end)[1] = "honourable_privilege_recharge"
	;(function()
		local _ENV, ret
		for i, v in ipairs(exclusiveVipRead.hwr) do
			if v.areaGroup then
				if not ret[v.areaGroup] then
					_ENV = ret[v.areaGroup]
				end
				ret[v.areaGroup] = ret[v.areaGroup]
				table.insert(ret[v.areaGroup], v)
			end
		end
		return ret
	end)[2] = true
	exclusiveVipRead:defineValue("hpr", function()
		local _ENV, ret
		for i, v in ipairs(exclusiveVipRead.hwr) do
			if v.areaGroup then
				if not ret[v.areaGroup] then
					_ENV = ret[v.areaGroup]
				end
				ret[v.areaGroup] = ret[v.areaGroup]
				table.insert(ret[v.areaGroup], v)
			end
		end
		return ret
	end)
	function _ENV()
		local _ENV, ret
		for i, v in ipairs(exclusiveVipRead.hwr) do
			if v.areaGroup then
				if not ret[v.areaGroup] then
					_ENV = ret[v.areaGroup]
				end
				ret[v.areaGroup] = ret[v.areaGroup]
				table.insert(ret[v.areaGroup], v)
			end
		end
		return ret
	end
	;(function()
		local _ENV, ret
		for i, v in ipairs(exclusiveVipRead.hwr) do
			if v.areaGroup then
				if not ret[v.areaGroup] then
					_ENV = ret[v.areaGroup]
				end
				ret[v.areaGroup] = ret[v.areaGroup]
				table.insert(ret[v.areaGroup], v)
			end
		end
		return ret
	end)[1] = "honourable_anchor_award"
	;(function()
		local _ENV, ret
		for i, v in ipairs(exclusiveVipRead.hwr) do
			if v.areaGroup then
				if not ret[v.areaGroup] then
					_ENV = ret[v.areaGroup]
				end
				ret[v.areaGroup] = ret[v.areaGroup]
				table.insert(ret[v.areaGroup], v)
			end
		end
		return ret
	end)[2] = true
	exclusiveVipRead:defineValue("haa", function()
		local _ENV, ret
		for i, v in ipairs(exclusiveVipRead.hwr) do
			if v.areaGroup then
				if not ret[v.areaGroup] then
					_ENV = ret[v.areaGroup]
				end
				ret[v.areaGroup] = ret[v.areaGroup]
				table.insert(ret[v.areaGroup], v)
			end
		end
		return ret
	end)
	function _ENV()
		local _ENV, ret
		for i, v in ipairs(exclusiveVipRead.hwr) do
			if v.areaGroup then
				if not ret[v.areaGroup] then
					_ENV = ret[v.areaGroup]
				end
				ret[v.areaGroup] = ret[v.areaGroup]
				table.insert(ret[v.areaGroup], v)
			end
		end
		return ret
	end
	;(function()
		local _ENV, ret
		for i, v in ipairs(exclusiveVipRead.hwr) do
			if v.areaGroup then
				if not ret[v.areaGroup] then
					_ENV = ret[v.areaGroup]
				end
				ret[v.areaGroup] = ret[v.areaGroup]
				table.insert(ret[v.areaGroup], v)
			end
		end
		return ret
	end)[1] = "telephone"
	;(function()
		local _ENV, ret
		for i, v in ipairs(exclusiveVipRead.hwr) do
			if v.areaGroup then
				if not ret[v.areaGroup] then
					_ENV = ret[v.areaGroup]
				end
				ret[v.areaGroup] = ret[v.areaGroup]
				table.insert(ret[v.areaGroup], v)
			end
		end
		return ret
	end)[2] = true
	exclusiveVipRead:defineValue("telephone", function()
		local _ENV, ret
		for i, v in ipairs(exclusiveVipRead.hwr) do
			if v.areaGroup then
				if not ret[v.areaGroup] then
					_ENV = ret[v.areaGroup]
				end
				ret[v.areaGroup] = ret[v.areaGroup]
				table.insert(ret[v.areaGroup], v)
			end
		end
		return ret
	end)
end
init()
function exclusiveVipRead:getRechargeGiftInfo(historyRecharge)
	local _ENV, giftList
	local isReach = false
	local castleLv, castleStarLv, sumJinnLv
	for i, v in ipairs(exclusiveVipRead.hpr) do
		local exaltedPrivilegeCtrl = SoraDGetCtrl("exaltedPrivilegeCtrl")
		local alreadyBuyTimes = exaltedPrivilegeCtrl:getPackageBoughtNums(v.rechargeID)
		if historyRecharge >= v.condition and alreadyBuyTimes < v.extraData then
			local lvLimitData = v.lv
			if lvLimitData and next(lvLimitData) then
				local lvType = lvLimitData[1]
				local minLv = lvLimitData[2]
				local maxLv = lvLimitData[3]
				if lvType == 1 then
					castleLv = castleLv or SoraDGetCastleLv()
					if minLv <= castleLv and maxLv >= castleLv then
						table.insert(giftList, v)
					end
				elseif lvType == 2 then
					castleStarLv = castleStarLv or SoraDGetBuildStarLv()
					if minLv <= castleStarLv and maxLv >= castleStarLv then
						table.insert(giftList, v)
					end
				elseif lvType == 3 then
					sumJinnLv = sumJinnLv or SoraDGetCtrl("magicLampCtrl"):getSumJinnLevel()
					if minLv <= sumJinnLv and maxLv >= sumJinnLv then
						table.insert(giftList, v)
					end
				end
			elseif lvLimitData and next(lvLimitData) == nil then
				table.insert(giftList, v)
			end
		end
		if historyRecharge >= v.condition then
			isReach = true
		end
	end
	return giftList, isReach
end
function exclusiveVipRead:checkMoreRechargeGift(historyRecharge)
	for i, v in ipairs(exclusiveVipRead.hpr) do
		if historyRecharge < v.condition then
			return true
		end
	end
	return false
end
function exclusiveVipRead:getReachRechargeInfo(gold)
	local rechargeInfo, rechargeNextInfo
	local index = 0
	for i, v in ipairs(exclusiveVipRead.hcr) do
		if gold >= v.charge_amount then
			rechargeInfo = v
			index = i + 1
		end
	end
	if index == 0 then
		index = 1
	end
	if exclusiveVipRead.hcr[index] then
		rechargeNextInfo = exclusiveVipRead.hcr[index]
	end
	return rechargeInfo, rechargeNextInfo
end
function exclusiveVipRead:getPrivilegeList(score)
	local curScore = 0
	local _ENV, curList
	for k, v in pairs(exclusiveVipRead.hvpg) do
		if score >= v.grade and curScore < v.grade then
			curScore = v.grade
			curList = v.privilegeID
		end
	end
	return serviceFunctions.table_copy_table(curList), curScore
end
function exclusiveVipRead:getNextLevelPrivilegeInfo(score)
	local nextLevelInfo
	local isMax = false
	local nextIndex = 0
	for i, v in ipairs(exclusiveVipRead.hvpu) do
		if score >= v.grade then
			nextIndex = i + 1
		end
	end
	if nextIndex == 0 then
		nextIndex = 1
	end
	if exclusiveVipRead.hvpu[nextIndex] then
		nextLevelInfo = exclusiveVipRead.hvpu[nextIndex]
	else
		nextLevelInfo = exclusiveVipRead.hvpu[nextIndex - 1]
		isMax = true
	end
	return nextLevelInfo, isMax
end
function exclusiveVipRead:getVipScoreList()
	return exclusiveVipRead.hvi
end
function exclusiveVipRead:getVipScore(scoreType, value)
	local curAmount = 0
	local retScore = 0
	for k, v in pairs(exclusiveVipRead.hvi) do
		if v.type == scoreType and value > v.amount and curAmount < v.amount then
			curAmount = v.amount
			retScore = v.grade
		end
	end
	return retScore
end
function exclusiveVipRead:getPrivilegeInfo(privilegeID)
	local curTable
	for i, v in ipairs(exclusiveVipRead.hvpu) do
		if privilegeID == v.privilegeID then
			curTable = v
		end
	end
	return curTable
end
function exclusiveVipRead:getPrivilegeValue(privilegeType, score)
	local curList = self:getPrivilegeList(score)
	local retValue = 0
	local _ENV, valueList = score, score
	for k, v in pairs(curList) do
		local privilegeInfo = self:getPrivilegeInfo(v)
		if privilegeInfo then
			local curType = privilegeInfo.type
			local curValue = privilegeInfo.value
			if curType == gExaltedPrivilegeType.EMOJI_STAMP then
			elseif type(curValue) == "table" and table.nums(curValue) == 1 then
				curValue = curValue[1]
			end
			if privilegeType == curType then
				if privilegeType == gExaltedPrivilegeType.CONTACT_NUM_LIMIT or privilegeType == gExaltedPrivilegeType.ARMY_COMPILE_LIMIT or privilegeType == gExaltedPrivilegeType.WAR_GEM_SET or privilegeType == gExaltedPrivilegeType.EQUIPMENT_SET or privilegeType == gExaltedPrivilegeType.HONOUR_PIIVILEGE or privilegeType == gExaltedPrivilegeType.LORD_SKILL_SET then
					if type(curValue) == "number" and retValue < curValue then
						retValue = curValue
					elseif type(curValue) == "table" then
						local max = curValue[1]
						for ki, vi in ipairs(curValue) do
							if vi > max then
								max = vi
							end
						end
						curValue = max
					end
					valueList[tostring(curValue)] = v
				elseif privilegeType == gExaltedPrivilegeType.EMOJI_STAMP then
					retValue = curValue[1]
					if type(curValue) == "table" then
						for k3, v3 in pairs(curValue) do
							valueList[tostring(v3)] = privilegeInfo.privilegeID
						end
					end
				else
					if curValue > retValue then
						retValue = curValue
					end
					valueList[tostring(curValue)] = v
				end
			end
		end
	end
	return retValue, valueList
end
function exclusiveVipRead.getHWRConfig(...)
	local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
	local regionType, regionId = nebulaActivityCtrl:getKingdomRegionType()
	local areaGroup = 1
	if regionType == NEBULA_REGION_TYPE.HEGEMONY_REGION then
		areaGroup = 1
	else
		areaGroup = 2
	end
	if not exclusiveVipRead.hwrConfig[areaGroup] then
		_ENV = exclusiveVipRead.hwrConfig[areaGroup]
	end
	return exclusiveVipRead.hwrConfig[areaGroup]
end
function exclusiveVipRead:getWeekRechargeReward(totalRecharge)
	local exclusiveVipRead, cfg
	local index = 3
	local hwrConfig = exclusiveVipRead.getHWRConfig()
	for k, v in ipairs(hwrConfig) do
		if totalRecharge < v.historyprice and 0 < index then
			table.insert(cfg, v)
			index = index - 1
		end
	end
	return cfg
end
function exclusiveVipRead:getWeekRechargeRewardCfg(totalRecharge)
	local exclusiveVipRead, ret
	local hwrConfig = exclusiveVipRead.getHWRConfig()
	local idx = 0
	for k, v in ipairs(hwrConfig) do
		if totalRecharge < v.historyprice then
			idx = k
			break
		end
	end
	if 0 < idx then
		idx = math.max(4, idx)
		print("idx=====", idx)
		for i = idx - 3, idx - 1 do
			table.insert(ret, hwrConfig[i])
		end
	else
		for i = #hwrConfig - 2, #hwrConfig do
			table.insert(ret, hwrConfig[i])
		end
	end
	return ret
end
function exclusiveVipRead:getWeeklyRechargeNeedGold()
	local curWeelyPrice = 0
	for k, v in ipairs(exclusiveVipRead.getHWRConfig()) do
		curWeelyPrice = v.weekprice
		break
	end
	return curWeelyPrice
end
function exclusiveVipRead:getweeklyHistoryRechargeNeedGold()
	local curHistoryPrice = 0
	for k, v in ipairs(exclusiveVipRead.getHWRConfig()) do
		curHistoryPrice = v.historyprice
		break
	end
	return curHistoryPrice
end
function exclusiveVipRead:checkHasNewPrivilege(oldGrade, newGrade)
	local oldList, oldScore = self:getPrivilegeList(oldGrade)
	local newList, newScore = self:getPrivilegeList(newGrade)
	if oldScore < newScore then
		local _ENV, ret = newGrade, newGrade
		for k, v in pairs(newList) do
			ret[tostring(v)] = v
		end
		for k, v in pairs(oldList) do
			ret[tostring(v)] = nil
		end
		return true, ret
	else
		_ENV = true
		return false, true
	end
end
function exclusiveVipRead:getPrivilegeReward(privilegeType)
	for i, v in ipairs(exclusiveVipRead.hvw) do
		if privilegeType == v.type then
			return v.rewards
		end
	end
end
function exclusiveVipRead:getAnchorAward(privilegeID)
	for k, v in pairs(exclusiveVipRead.haa) do
		if v.privilegeID == privilegeID then
			return v.award
		end
	end
end
function exclusiveVipRead:getTelAreaList()
	return exclusiveVipRead.telephone
end
return exclusiveVipRead
