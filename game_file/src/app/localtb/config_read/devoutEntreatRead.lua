local devoutEntreatRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "begging_reward_config"
	;(nil)[2] = true
	devoutEntreatRead:defineValue("begReward", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "begging_spend_config"
	;(nil)[2] = true
	devoutEntreatRead:defineValue("brgSpend", nil)
end
init()
function devoutEntreatRead.getGroupNum(classtype, groupType)
	local nums = 0
	for i, v in ipairs(devoutEntreatRead.begReward) do
		if v.group == groupType and classtype == v.classtype then
			nums = nums + 1
		end
	end
	return nums
end
function devoutEntreatRead.getGroupByPosition(position)
	if 0 < position and position < 3 then
		return 3
	elseif 2 < position and position < 6 then
		return 2
	elseif 5 < position and position < 9 then
		return 1
	end
end
function devoutEntreatRead.getGroupInfo(classtype, groupType)
	local _ENV, tmpTbl
	for i, v in ipairs(devoutEntreatRead.begReward) do
		if v.group == groupType and classtype == v.classtype then
			table.insert(tmpTbl, v)
		end
	end
	return tmpTbl
end
function devoutEntreatRead.getItemInfo(index)
	for i, v in ipairs(devoutEntreatRead.begReward) do
		if v.index == index then
			_ENV = v.index
			v.index.id = v.item[1]
			local v.index.count, temp = v.item[2], v.index
			return temp
		end
	end
	return nil
end
function devoutEntreatRead.getCostItemId()
	if not devoutEntreatRead.brgSpend[1] or not devoutEntreatRead.brgSpend[1].cost then
		local devoutEntreatRead, cost = devoutEntreatRead.brgSpend[1].cost, devoutEntreatRead.brgSpend[1].cost
	end
	return cost[1]
end
return devoutEntreatRead
