local warTreasureRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "war_things_power"
	;(nil)[2] = true
	warTreasureRead:defineValue("powerBuff", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "warthings_stage_reward"
	;(nil)[2] = true
	warTreasureRead:defineValue("reward", nil)
	warTreasureRead = nil
	;(nil)[1] = "war_things_client"
	warTreasureRead:defineValue("buildInfo", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "war_things_output"
	;(nil)[2] = true
	warTreasureRead:defineValue("outPut", nil)
end
function warTreasureRead.getRankAward(rankType)
	local _ENV, tmp
	for i, v in ipairs(warTreasureRead.reward) do
		if v.type == rankType then
			local _ENV, item = v.type, v.type
			item.index = v.index
			item.rank = v.needscore
			item.reward = v.reward
			table.insert(tmp, item)
		end
	end
	return tmp
end
function warTreasureRead.getIsMax(type, num)
	local lv = 0
	for i, v in ipairs(warTreasureRead.powerBuff) do
		if v.type == type and num >= v.donationnum[1] and num <= v.donationnum[2] then
			lv = v.donationlv
		end
	end
	for i, v in ipairs(warTreasureRead.powerBuff) do
		if lv < v.donationlv then
			return false
		end
	end
	return true
end
function warTreasureRead.getStageAwardByPoint(point)
	local _ENV, tmp
	for i, v in ipairs(warTreasureRead.reward) do
		if v.type == 1 and v.needscore[1] == point then
			return v.reward
		end
	end
	return tmp
end
function warTreasureRead.getPointByIndex(index)
	for i, v in ipairs(warTreasureRead.reward) do
		if v.type == 1 and v.index == index then
			return v.needscore[1]
		end
	end
	return index
end
function warTreasureRead.getBuffByTypeAndNum(type, num)
	for i, v in ipairs(warTreasureRead.powerBuff) do
		if v.type == type and num >= v.donationnum[1] and num <= v.donationnum[2] then
			return v.proportion, v.donationlv
		end
	end
end
function warTreasureRead.getNextBuffByLv(type, lv)
	for i, v in ipairs(warTreasureRead.powerBuff) do
		if v.type == type and v.donationlv == lv then
			return v.proportion, v.donationnum[1]
		end
	end
end
function warTreasureRead.getResourceName(classID)
	return i18n(warTreasureRead.buildInfo[classID].resName)
end
function warTreasureRead.getResourceLevel(classID)
	return warTreasureRead.buildInfo[classID].resLevel
end
function warTreasureRead.getCastleLevel(classID)
	return warTreasureRead.buildInfo[classID].castleLv
end
function warTreasureRead.getResourceType(classID)
	return warTreasureRead.buildInfo[classID].resType
end
function warTreasureRead.getResourceIcon(classID)
	return warTreasureRead.buildInfo[classID].iconImage
end
function warTreasureRead.getResourceImage(classID)
	return warTreasureRead.buildInfo[classID].resModel
end
function warTreasureRead.getResourceReward(classID)
	return warTreasureRead.outPut[classID].dropItems
end
init()
return warTreasureRead
