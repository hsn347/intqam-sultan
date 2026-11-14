local beastCanyonRead = include("aAReadClass").new()
function beastCanyonRead.init()
	_UPVALUE2_ = nil
	;(nil)[1] = "divinebeastcanyon_boss"
	;(nil)[2] = true
	beastCanyonRead:defineValue("divinebeastcanyon_boss", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "divinebeastcanyon_num"
	;(nil)[2] = true
	beastCanyonRead:defineValue("divinebeastcanyon_num", nil)
	beastCanyonRead:defineValue("divinebeastcanyon_reward", function()
		local _ENV, new
		local config = require_once("app." .. LocalTblPath .. ".config_server.divinebeastcanyon_reward")
		for i, v in ipairs(config) do
			if not new[v.type] then
				new[v.type], _ENV = nil, nil
			end
			_ENV = nil
			;(nil).num = v.num
			;(nil).reward = v.reward
			table.insert(new[v.type], nil)
		end
		return new
	end)
	function _UPVALUE2_()
		local _ENV, new
		local config = require_once("app." .. LocalTblPath .. ".config_server.divinebeastcanyon_reward")
		for i, v in ipairs(config) do
			if not new[v.type] then
				new[v.type], _ENV = nil, nil
			end
			_ENV = nil
			;(nil).num = v.num
			;(nil).reward = v.reward
			table.insert(new[v.type], nil)
		end
		return new
	end
	;(function()
		local _ENV, new
		local config = require_once("app." .. LocalTblPath .. ".config_server.divinebeastcanyon_reward")
		for i, v in ipairs(config) do
			if not new[v.type] then
				new[v.type], _ENV = nil, nil
			end
			_ENV = nil
			;(nil).num = v.num
			;(nil).reward = v.reward
			table.insert(new[v.type], nil)
		end
		return new
	end)[1] = "divinebeastcanyon_accrual"
	;(function()
		local _ENV, new
		local config = require_once("app." .. LocalTblPath .. ".config_server.divinebeastcanyon_reward")
		for i, v in ipairs(config) do
			if not new[v.type] then
				new[v.type], _ENV = nil, nil
			end
			_ENV = nil
			;(nil).num = v.num
			;(nil).reward = v.reward
			table.insert(new[v.type], nil)
		end
		return new
	end)[2] = true
	beastCanyonRead:defineValue("divinebeastcanyon_accrual", function()
		local _ENV, new
		local config = require_once("app." .. LocalTblPath .. ".config_server.divinebeastcanyon_reward")
		for i, v in ipairs(config) do
			if not new[v.type] then
				new[v.type], _ENV = nil, nil
			end
			_ENV = nil
			;(nil).num = v.num
			;(nil).reward = v.reward
			table.insert(new[v.type], nil)
		end
		return new
	end)
	function _ENV()
		local _ENV, new
		local config = require_once("app." .. LocalTblPath .. ".config_server.divinebeastcanyon_reward")
		for i, v in ipairs(config) do
			if not new[v.type] then
				new[v.type], _ENV = nil, nil
			end
			_ENV = nil
			;(nil).num = v.num
			;(nil).reward = v.reward
			table.insert(new[v.type], nil)
		end
		return new
	end
	;(function()
		local _ENV, new
		local config = require_once("app." .. LocalTblPath .. ".config_server.divinebeastcanyon_reward")
		for i, v in ipairs(config) do
			if not new[v.type] then
				new[v.type], _ENV = nil, nil
			end
			_ENV = nil
			;(nil).num = v.num
			;(nil).reward = v.reward
			table.insert(new[v.type], nil)
		end
		return new
	end)[1] = "divinebeastcanyon_des"
	beastCanyonRead:defineValue("divinebeastcanyon_des", function()
		local _ENV, new
		local config = require_once("app." .. LocalTblPath .. ".config_server.divinebeastcanyon_reward")
		for i, v in ipairs(config) do
			if not new[v.type] then
				new[v.type], _ENV = nil, nil
			end
			_ENV = nil
			;(nil).num = v.num
			;(nil).reward = v.reward
			table.insert(new[v.type], nil)
		end
		return new
	end)
	function _UPVALUE2_()
		local _ENV, new
		local config = require_once("app." .. LocalTblPath .. ".config_server.divinebeastcanyon_reward")
		for i, v in ipairs(config) do
			if not new[v.type] then
				new[v.type], _ENV = nil, nil
			end
			_ENV = nil
			;(nil).num = v.num
			;(nil).reward = v.reward
			table.insert(new[v.type], nil)
		end
		return new
	end
	;(function()
		local _ENV, new
		local config = require_once("app." .. LocalTblPath .. ".config_server.divinebeastcanyon_reward")
		for i, v in ipairs(config) do
			if not new[v.type] then
				new[v.type], _ENV = nil, nil
			end
			_ENV = nil
			;(nil).num = v.num
			;(nil).reward = v.reward
			table.insert(new[v.type], nil)
		end
		return new
	end)[1] = "elitebeastcanyon_boss"
	;(function()
		local _ENV, new
		local config = require_once("app." .. LocalTblPath .. ".config_server.divinebeastcanyon_reward")
		for i, v in ipairs(config) do
			if not new[v.type] then
				new[v.type], _ENV = nil, nil
			end
			_ENV = nil
			;(nil).num = v.num
			;(nil).reward = v.reward
			table.insert(new[v.type], nil)
		end
		return new
	end)[2] = true
	beastCanyonRead:defineValue("elitebeastcanyon_boss", function()
		local _ENV, new
		local config = require_once("app." .. LocalTblPath .. ".config_server.divinebeastcanyon_reward")
		for i, v in ipairs(config) do
			if not new[v.type] then
				new[v.type], _ENV = nil, nil
			end
			_ENV = nil
			;(nil).num = v.num
			;(nil).reward = v.reward
			table.insert(new[v.type], nil)
		end
		return new
	end)
	function _UPVALUE2_()
		local _ENV, new
		local config = require_once("app." .. LocalTblPath .. ".config_server.divinebeastcanyon_reward")
		for i, v in ipairs(config) do
			if not new[v.type] then
				new[v.type], _ENV = nil, nil
			end
			_ENV = nil
			;(nil).num = v.num
			;(nil).reward = v.reward
			table.insert(new[v.type], nil)
		end
		return new
	end
	;(function()
		local _ENV, new
		local config = require_once("app." .. LocalTblPath .. ".config_server.divinebeastcanyon_reward")
		for i, v in ipairs(config) do
			if not new[v.type] then
				new[v.type], _ENV = nil, nil
			end
			_ENV = nil
			;(nil).num = v.num
			;(nil).reward = v.reward
			table.insert(new[v.type], nil)
		end
		return new
	end)[1] = "elitebeastcanyon_num"
	;(function()
		local _ENV, new
		local config = require_once("app." .. LocalTblPath .. ".config_server.divinebeastcanyon_reward")
		for i, v in ipairs(config) do
			if not new[v.type] then
				new[v.type], _ENV = nil, nil
			end
			_ENV = nil
			;(nil).num = v.num
			;(nil).reward = v.reward
			table.insert(new[v.type], nil)
		end
		return new
	end)[2] = true
	beastCanyonRead:defineValue("elitebeastcanyon_num", function()
		local _ENV, new
		local config = require_once("app." .. LocalTblPath .. ".config_server.divinebeastcanyon_reward")
		for i, v in ipairs(config) do
			if not new[v.type] then
				new[v.type], _ENV = nil, nil
			end
			_ENV = nil
			;(nil).num = v.num
			;(nil).reward = v.reward
			table.insert(new[v.type], nil)
		end
		return new
	end)
	beastCanyonRead:defineValue("elitebeastcanyon_reward", function()
		local baseConfig = require_data("elitebeastcanyon_reward", true, true).data
		return beastCanyonRead.getClassTypeConfig(baseConfig, "type")
	end)
	function _UPVALUE2_()
		local baseConfig = require_data("elitebeastcanyon_reward", true, true).data
		return beastCanyonRead.getClassTypeConfig(baseConfig, "type")
	end
	;(function()
		local baseConfig = require_data("elitebeastcanyon_reward", true, true).data
		return beastCanyonRead.getClassTypeConfig(baseConfig, "type")
	end)[1] = "elitebeastcanyon_accrual"
	;(function()
		local baseConfig = require_data("elitebeastcanyon_reward", true, true).data
		return beastCanyonRead.getClassTypeConfig(baseConfig, "type")
	end)[2] = true
	beastCanyonRead:defineValue("elitebeastcanyon_accrual", function()
		local baseConfig = require_data("elitebeastcanyon_reward", true, true).data
		return beastCanyonRead.getClassTypeConfig(baseConfig, "type")
	end)
end
function beastCanyonRead.getBossConfig(activityID)
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001650 then
		return beastCanyonRead.elitebeastcanyon_boss
	else
		return beastCanyonRead.divinebeastcanyon_boss
	end
end
function beastCanyonRead.getBossConfigByBossType(activityID, bossType)
	for i, v in ipairs(beastCanyonRead.getBossConfig(activityID)) do
		if v.type == bossType then
			return v
		end
	end
end
function beastCanyonRead.getCostNumAndItemID(activityID, beginNum, num)
	local config = beastCanyonRead.divinebeastcanyon_num
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001650 then
		config = beastCanyonRead.elitebeastcanyon_num
	end
	local count = 0
	local itemID = 0
	for i, v in ipairs(config) do
		if 0 < num and (v.num[2] and beginNum >= v.num[1] and beginNum <= v.num[2] or v.num[1] == beginNum) then
			local _num = math.min(num, v.num[2] and v.num[2] - beginNum + 1 or 1)
			count = count + _num * v.item[2]
			itemID = v.item[1]
			num = num - _num
			if num <= 0 then
				break
			end
			beginNum = _num + beginNum
		end
	end
	return itemID, count
end
function beastCanyonRead.getTaskList(activityID)
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001650 then
		return beastCanyonRead.elitebeastcanyon_accrual
	else
		return beastCanyonRead.divinebeastcanyon_accrual
	end
end
function beastCanyonRead.getTaskDes(activityID, taskType)
	return beastCanyonRead.divinebeastcanyon_des[taskType].reward
end
function beastCanyonRead.getBoxNumAndNextNum(activityID, bossType, damage)
	local config = beastCanyonRead.getBossReward(activityID, bossType)
	local count = 0
	local nexNum = 0
	for i, v in ipairs(config) do
		if damage < v.num then
			nexNum = v.num
			break
		end
		count = count + v.reward[2]
		if i == #config then
			nexNum = v.num
		end
	end
	return count, nexNum
end
function beastCanyonRead.getBossReward(activityID, bossType)
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001650 then
		return beastCanyonRead.elitebeastcanyon_reward[bossType]
	else
		return beastCanyonRead.divinebeastcanyon_reward[bossType]
	end
end
beastCanyonRead.init()
return beastCanyonRead
