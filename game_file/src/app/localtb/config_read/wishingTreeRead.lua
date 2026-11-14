local wishingTreeRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	wishingTreeRead:defineValue("TaskConfig", "app." .. LocalTblPath .. ".config_server.wishing_tree_confing")
	wishingTreeRead:defineValue("RechargeConfig", "app." .. LocalTblPath .. ".config_server.wishing_tree_recharge")
end
init()
function wishingTreeRead.getTaskInfo(group)
	local _ENV, tb
	local _index = 1
	for k, v in ipairs(wishingTreeRead.TaskConfig) do
		if v.group == group then
			v.index = _index
			table.insert(tb, v)
			_index = _index + 1
		end
	end
	return tb
end
function wishingTreeRead.getStageCoin(group, stage, isPrivilege)
	local info
	stage = 7 < stage and 7 or stage
	local cfg = wishingTreeRead.getTaskInfo(group)
	for k, v in pairs(cfg) do
		if v.stage == stage then
			if isPrivilege then
				return v.priCoin
			else
				return v.coin
			end
		end
	end
	return 0
end
function wishingTreeRead.getStageTargetNum(group, stage)
	stage = 7 < stage and 7 or stage
	local cfg = wishingTreeRead.getTaskInfo(group)
	for k, v in pairs(cfg) do
		if v.stage == stage then
			return v.num
		end
	end
	return 0
end
function wishingTreeRead.getRechargeInfo()
	return wishingTreeRead.RechargeConfig[13670]
end
function wishingTreeRead.getNowStage(group, consumeGold)
	local cfg = wishingTreeRead.getTaskInfo(group)
	local wishingTreeRead, packetInfo = group, cfg or group
	local nums = table.nums(packetInfo)
	for k, v in ipairs(packetInfo) do
		if consumeGold < v.num then
			return packetInfo[k - 1] and packetInfo[k - 1].stage or 0
		end
	end
	return packetInfo[nums] and packetInfo[nums].stage
end
return wishingTreeRead
