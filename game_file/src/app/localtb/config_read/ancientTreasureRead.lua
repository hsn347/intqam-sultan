local ancientTreasureRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	ancientTreasureRead = nil
	;(nil)[1] = "ancient_treasure_show"
	ancientTreasureRead:defineValue("treasureshow", nil)
	ancientTreasureRead = nil
	;(nil)[1] = "ancient_treasure_reward_config"
	ancientTreasureRead:defineValue("treasurereward", nil)
	ancientTreasureRead = nil
	;(nil)[1] = "ancient_treasure_build_config"
	ancientTreasureRead:defineValue("treasurebuild", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "ancient_treasure_task"
	;(nil)[2] = true
	ancientTreasureRead:defineValue("treasuretask", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "ancient_treasure_building"
	;(nil)[2] = true
	ancientTreasureRead:defineValue("treasurebuilding", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "ancient_treasure_stage"
	;(nil)[2] = true
	ancientTreasureRead:defineValue("treasurestage", nil)
end
init()
function ancientTreasureRead.getSvrBuildInfo(buildType)
	return ancientTreasureRead.treasurebuilding[buildType]
end
function ancientTreasureRead.getBuildInfo(buildType)
	local _ENV, info
	for k, v in pairs(ancientTreasureRead.treasurebuild) do
		if v.buildID == buildType then
			info = v
			break
		end
	end
	return info
end
function ancientTreasureRead.getAllTask()
	return ancientTreasureRead.treasuretask
end
function ancientTreasureRead.getBoxInfoByIndex(index)
	return ancientTreasureRead.treasureshow[index]
end
function ancientTreasureRead.getStageBoxInfoByIndex(index)
	return ancientTreasureRead.treasurereward[index]
end
function ancientTreasureRead.getMinBoxByOpenCount(count)
	local index = 0
	for k, v in ipairs(ancientTreasureRead.treasurereward) do
		if count < v.miningNum then
			index = k
			break
		end
	end
	return index
end
function ancientTreasureRead.getPercentByOpenCount(count)
	local percent = 0
	local mixCount = ancientTreasureRead.treasurereward[1].miningNum
	local maxCount = ancientTreasureRead.treasurereward[#ancientTreasureRead.treasurereward].miningNum
	if count < mixCount then
		percent = 0
	elseif count >= maxCount then
		percent = 100
	else
		local preCount = 0
		local preKey = 0
		for k, v in ipairs(ancientTreasureRead.treasurereward) do
			if count > v.miningNum then
				preCount = v.miningNum
				preKey = k
				break
			end
		end
		local nextCount = ancientTreasureRead.treasurereward[preKey + 1].miningNum
		local off = #ancientTreasureRead.treasurereward - 1
		percent = (count - preCount) / off * 100 / (nextCount - preCount) + (preKey - 1) * 100 / off
	end
	return percent
end
function ancientTreasureRead.getWolfBeginTime()
	return ancientTreasureRead.treasurestage[3].beginHour
end
return ancientTreasureRead
