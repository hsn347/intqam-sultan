local snowmanCelebrationltCtrl = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "snowmanactivitybox"
;(nil)[2] = true
snowmanCelebrationltCtrl:defineValue("boxInfo", nil)
_UPVALUE2_ = nil
;(nil)[1] = "snowmanactivityget"
;(nil)[2] = true
snowmanCelebrationltCtrl:defineValue("getInfo", nil)
_UPVALUE2_ = nil
;(nil)[1] = "snowmanactivityrank"
;(nil)[2] = true
snowmanCelebrationltCtrl:defineValue("rankInfo", nil)
_UPVALUE2_ = snowmanCelebrationltCtrl.defineValue
snowmanCelebrationltCtrl.defineValue[1] = 1641
local snowmanCelebrationltCtrl.defineValue[2], scoreIds = 1647, snowmanCelebrationltCtrl.defineValue
function snowmanCelebrationltCtrl.getScoreId()
	local snowmanCelebrationCtrl = SoraDGetCtrl("snowmanCelebrationCtrl")
	local skin = snowmanCelebrationCtrl:getSkin()
	return scoreIds[skin]
end
function snowmanCelebrationltCtrl.getBoxInfo()
	local snowmanCelebrationCtrl = SoraDGetCtrl("snowmanCelebrationCtrl")
	local skin = snowmanCelebrationCtrl:getSkin()
	local _ENV, tmpBoxInfo = snowmanCelebrationCtrl, snowmanCelebrationCtrl
	for key, value in pairs(snowmanCelebrationltCtrl.boxInfo) do
		if value.skin == skin then
			table.insert(tmpBoxInfo, value)
		end
	end
	table.sort(tmpBoxInfo, function(a, b)
		return a.index < b.index
	end)
	return tmpBoxInfo
end
function snowmanCelebrationltCtrl.getGetInfo()
	local snowmanCelebrationCtrl = SoraDGetCtrl("snowmanCelebrationCtrl")
	local skin = snowmanCelebrationCtrl:getSkin()
	local _ENV, tmpGetInfo = snowmanCelebrationCtrl, snowmanCelebrationCtrl
	for key, value in pairs(snowmanCelebrationltCtrl.getInfo) do
		if value.skin == skin then
			table.insert(tmpGetInfo, value)
		end
	end
	table.sort(tmpGetInfo, function(a, b)
		return a.index < b.index
	end)
	return tmpGetInfo
end
function snowmanCelebrationltCtrl.getRankInfos()
	local snowmanCelebrationCtrl = SoraDGetCtrl("snowmanCelebrationCtrl")
	local skin = snowmanCelebrationCtrl:getSkin()
	local _ENV, tmpRankInfo = snowmanCelebrationCtrl, snowmanCelebrationCtrl
	for key, value in pairs(snowmanCelebrationltCtrl.rankInfo) do
		if value.skin == skin then
			table.insert(tmpRankInfo, value)
		end
	end
	table.sort(tmpRankInfo, function(a, b)
		return a.Index < b.Index
	end)
	return tmpRankInfo
end
function snowmanCelebrationltCtrl.getReawrdCfg()
	return snowmanCelebrationltCtrl.levelReward
end
function snowmanCelebrationltCtrl.getRewardFront2ByIndex(index)
	if index == -1 then
		return nil
	end
	index = index or 101
	if snowmanCelebrationltCtrl.getRankInfos() and table.nums(snowmanCelebrationltCtrl.getRankInfos()) > 0 then
		if snowmanCelebrationltCtrl.getRankInfo(index) then
			_UPVALUE2_ = index
			index[1] = "id"
			index[2] = "count"
			snowmanCelebrationltCtrl.rankReward = serviceFunctions.tableFormat(snowmanCelebrationltCtrl.getRankInfo(index), index)
			local snowmanCelebrationltCtrl, data = serviceFunctions.tableFormat(snowmanCelebrationltCtrl.getRankInfo(index), index), serviceFunctions.tableFormat(snowmanCelebrationltCtrl.getRankInfo(index), index)
			for i = 1, 2 do
				if snowmanCelebrationltCtrl.rankReward[i] then
					table.insert(data, snowmanCelebrationltCtrl.rankReward[i])
				end
			end
			return data
		else
			return nil
		end
	end
	return nil
end
function snowmanCelebrationltCtrl.getGetItemIDByIndex(index)
	return snowmanCelebrationltCtrl.getGetInfo()[index].GetItem[1]
end
function snowmanCelebrationltCtrl.getGetItemCountByIndex(index)
	return snowmanCelebrationltCtrl.getGetInfo()[index].GetItem[2]
end
function snowmanCelebrationltCtrl.getNeedIDByIndex(index)
	return snowmanCelebrationltCtrl.getGetInfo()[index].NeedItem[1]
end
function snowmanCelebrationltCtrl.getNeedCountByIndex(index)
	return snowmanCelebrationltCtrl.getGetInfo()[index].NeedItem[2]
end
function snowmanCelebrationltCtrl.getNeedIntegral()
	return snowmanCelebrationltCtrl.getBoxInfo()[1].NeedIntegral
end
function snowmanCelebrationltCtrl.getGetIntegralByIndex(index)
	return snowmanCelebrationltCtrl.getGetInfo()[index].GetIntegral
end
function snowmanCelebrationltCtrl.getGetIDByIndex(index)
	return snowmanCelebrationltCtrl.getGetInfo()[index].GetItem[1]
end
function snowmanCelebrationltCtrl.getNeedMinMultipleByIndex(index)
	local data = snowmanCelebrationltCtrl.getGetInfo()[index].IntegralMultiples
	return data[1]
end
function snowmanCelebrationltCtrl.getNeedMaxMultipleByIndex(index)
	local data = snowmanCelebrationltCtrl.getGetInfo()[index].IntegralMultiples
	return data[table.nums(data) - 1]
end
function snowmanCelebrationltCtrl.getBoxRewardItem()
	return snowmanCelebrationltCtrl.getBoxInfo()[1].BoxItem
end
function snowmanCelebrationltCtrl.getBoxRewardMaxTimes()
	return snowmanCelebrationltCtrl.getBoxInfo()[1].BoxMax
end
function snowmanCelebrationltCtrl.getMaxGetTimesByIndex(index)
	return snowmanCelebrationltCtrl.getGetInfo()[index].SingleMax
end
function snowmanCelebrationltCtrl.getRankReward()
	local snowmanCelebrationltCtrl, data
	local rankInfo = snowmanCelebrationltCtrl.getRankInfos()
	for i, v in pairs(rankInfo) do
		for j = v.RankNum[1], v.RankNum[2] do
			data[j] = i
		end
	end
	return data
end
function snowmanCelebrationltCtrl.getRankInfo(rank)
	if not snowmanCelebrationltCtrl.rankRewards then
		snowmanCelebrationltCtrl.rankRewards = snowmanCelebrationltCtrl.getRankReward()
	end
	return snowmanCelebrationltCtrl.getRankInfos()[snowmanCelebrationltCtrl.rankRewards[rank]].RankItem
end
return snowmanCelebrationltCtrl
