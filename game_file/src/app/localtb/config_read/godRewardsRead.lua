local godRewardsRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "graft_task_config"
	;(nil)[2] = true
	godRewardsRead:defineValue("taskConfig", nil)
	godRewardsRead = nil
	;(nil)[1] = "graft_task_describe"
	godRewardsRead:defineValue("taskDescribe", nil)
	godRewardsRead = nil
	;(nil)[1] = "graft_item_show"
	godRewardsRead:defineValue("itemShow", nil)
end
init()
function godRewardsRead.getTaskConfigByIndex(qeustID)
	for i, v in ipairs(godRewardsRead.taskConfig) do
		if v.qeustID == tonumber(qeustID) then
			return v
		end
	end
end
function godRewardsRead.getTaskDescribeByIndex(qeustID)
	for i, v in ipairs(godRewardsRead.taskDescribe) do
		if v.qeustID == tonumber(qeustID) then
			return v
		end
	end
end
function godRewardsRead.getItemIDByIndex(index)
	return godRewardsRead.itemShow[index].item
end
function godRewardsRead.getItemInfo(id)
	for i, v in ipairs(godRewardsRead.itemShow) do
		if v.item == id then
			return v
		end
	end
end
function godRewardsRead.getAwardByTaskID(taskID)
	for i, v in ipairs(godRewardsRead.taskConfig) do
		if v.qeustID == taskID then
			return v.extraReward, v.count
		end
	end
end
function godRewardsRead.getGiftIDTbl()
	local godRewardsRead, tmp
	local tblInfo = godRewardsRead.taskConfig[1].relation
	dump(tblInfo, "relation", 10)
	for i = 1, 5, 2 do
		tmp[tblInfo[i]] = tblInfo[i + 1]
	end
	return tmp
end
function godRewardsRead.getGiftID(itemID)
	local tblInfo = godRewardsRead.taskConfig[1].relation
	for i, v in ipairs(tblInfo) do
		if v == itemID then
			return tblInfo[i + 1]
		end
	end
end
function godRewardsRead.getItemIDByGift(giftID)
	local tblInfo = godRewardsRead.taskConfig[1].relation
	local normalID = tblInfo[1]
	local upID = normalID
	for i, v in ipairs(tblInfo) do
		if v == giftID then
			upID = tblInfo[i - 1]
		end
	end
	return normalID, upID
end
return godRewardsRead
