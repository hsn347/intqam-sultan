local activityltCtrl = include("aAReadClass").new()
function activityltCtrl.init()
	activityltCtrl:defineValue("activity_event_list", function()
		local activity_event_list = require_once("app." .. LocalTblPath .. ".config_server.activity_event_list")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.activity_event_list", "app." .. LocalTblPath .. ".config_server.activity_event_list"
		for k, v in pairs(activity_event_list) do
			list[v.eventID] = v
		end
		return list
	end)
	function _UPVALUE2_()
		local activity_event_list = require_once("app." .. LocalTblPath .. ".config_server.activity_event_list")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.activity_event_list", "app." .. LocalTblPath .. ".config_server.activity_event_list"
		for k, v in pairs(activity_event_list) do
			list[v.eventID] = v
		end
		return list
	end
	;(function()
		local activity_event_list = require_once("app." .. LocalTblPath .. ".config_server.activity_event_list")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.activity_event_list", "app." .. LocalTblPath .. ".config_server.activity_event_list"
		for k, v in pairs(activity_event_list) do
			list[v.eventID] = v
		end
		return list
	end)[1] = "activity_point_reward"
	;(function()
		local activity_event_list = require_once("app." .. LocalTblPath .. ".config_server.activity_event_list")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.activity_event_list", "app." .. LocalTblPath .. ".config_server.activity_event_list"
		for k, v in pairs(activity_event_list) do
			list[v.eventID] = v
		end
		return list
	end)[2] = true
	activityltCtrl:defineValue("activity_point_reward", function()
		local activity_event_list = require_once("app." .. LocalTblPath .. ".config_server.activity_event_list")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.activity_event_list", "app." .. LocalTblPath .. ".config_server.activity_event_list"
		for k, v in pairs(activity_event_list) do
			list[v.eventID] = v
		end
		return list
	end)
	function _UPVALUE2_()
		local activity_event_list = require_once("app." .. LocalTblPath .. ".config_server.activity_event_list")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.activity_event_list", "app." .. LocalTblPath .. ".config_server.activity_event_list"
		for k, v in pairs(activity_event_list) do
			list[v.eventID] = v
		end
		return list
	end
	;(function()
		local activity_event_list = require_once("app." .. LocalTblPath .. ".config_server.activity_event_list")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.activity_event_list", "app." .. LocalTblPath .. ".config_server.activity_event_list"
		for k, v in pairs(activity_event_list) do
			list[v.eventID] = v
		end
		return list
	end)[1] = "activity_total_reward"
	;(function()
		local activity_event_list = require_once("app." .. LocalTblPath .. ".config_server.activity_event_list")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.activity_event_list", "app." .. LocalTblPath .. ".config_server.activity_event_list"
		for k, v in pairs(activity_event_list) do
			list[v.eventID] = v
		end
		return list
	end)[2] = true
	activityltCtrl:defineValue("activity_total_reward", function()
		local activity_event_list = require_once("app." .. LocalTblPath .. ".config_server.activity_event_list")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.activity_event_list", "app." .. LocalTblPath .. ".config_server.activity_event_list"
		for k, v in pairs(activity_event_list) do
			list[v.eventID] = v
		end
		return list
	end)
	function _UPVALUE2_()
		local activity_event_list = require_once("app." .. LocalTblPath .. ".config_server.activity_event_list")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.activity_event_list", "app." .. LocalTblPath .. ".config_server.activity_event_list"
		for k, v in pairs(activity_event_list) do
			list[v.eventID] = v
		end
		return list
	end
	;(function()
		local activity_event_list = require_once("app." .. LocalTblPath .. ".config_server.activity_event_list")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.activity_event_list", "app." .. LocalTblPath .. ".config_server.activity_event_list"
		for k, v in pairs(activity_event_list) do
			list[v.eventID] = v
		end
		return list
	end)[1] = "activity_stage_reward"
	;(function()
		local activity_event_list = require_once("app." .. LocalTblPath .. ".config_server.activity_event_list")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.activity_event_list", "app." .. LocalTblPath .. ".config_server.activity_event_list"
		for k, v in pairs(activity_event_list) do
			list[v.eventID] = v
		end
		return list
	end)[2] = true
	activityltCtrl:defineValue("activity_stage_reward", function()
		local activity_event_list = require_once("app." .. LocalTblPath .. ".config_server.activity_event_list")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.activity_event_list", "app." .. LocalTblPath .. ".config_server.activity_event_list"
		for k, v in pairs(activity_event_list) do
			list[v.eventID] = v
		end
		return list
	end)
	function _UPVALUE2_()
		local activity_event_list = require_once("app." .. LocalTblPath .. ".config_server.activity_event_list")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.activity_event_list", "app." .. LocalTblPath .. ".config_server.activity_event_list"
		for k, v in pairs(activity_event_list) do
			list[v.eventID] = v
		end
		return list
	end
	;(function()
		local activity_event_list = require_once("app." .. LocalTblPath .. ".config_server.activity_event_list")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.activity_event_list", "app." .. LocalTblPath .. ".config_server.activity_event_list"
		for k, v in pairs(activity_event_list) do
			list[v.eventID] = v
		end
		return list
	end)[1] = "activity_drop_rank"
	;(function()
		local activity_event_list = require_once("app." .. LocalTblPath .. ".config_server.activity_event_list")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.activity_event_list", "app." .. LocalTblPath .. ".config_server.activity_event_list"
		for k, v in pairs(activity_event_list) do
			list[v.eventID] = v
		end
		return list
	end)[2] = true
	activityltCtrl:defineValue("activity_drop_reward", function()
		local activity_event_list = require_once("app." .. LocalTblPath .. ".config_server.activity_event_list")
		local _ENV, list = "app." .. LocalTblPath .. ".config_server.activity_event_list", "app." .. LocalTblPath .. ".config_server.activity_event_list"
		for k, v in pairs(activity_event_list) do
			list[v.eventID] = v
		end
		return list
	end)
end
activityltCtrl.init()
function activityltCtrl.getPointReward(activityID, serverLv)
	local _ENV, ret
	for k, v in pairs(activityltCtrl.activity_point_reward) do
		if activityID == v.activityID and serverLv >= v.serverLv[1] and serverLv <= v.serverLv[2] then
			ret[v.pointID] = v
		end
	end
	return ret
end
function activityltCtrl.getEventIDList(activityID, serverLv)
	local _ENV, ret
	for k, v in pairs(activityltCtrl.activity_event_list) do
		if activityID == v.activityID and serverLv >= v.serverLv[1] and serverLv <= v.serverLv[2] then
			table.insert(ret, v.eventID)
		end
	end
	table.sort(ret)
	return ret
end
function activityltCtrl.getEventPoint(eventID)
	local ret = 0
	local eventinfo = activityltCtrl.activity_event_list[eventID]
	if eventinfo then
		ret = eventinfo.rewardPoint
	end
	return ret
end
function activityltCtrl.getEventText(eventID)
	local ret = 0
	local eventinfo = activityltCtrl.activity_event_list[eventID]
	if eventinfo then
		ret = eventinfo.eventTxtID
	end
	return ret
end
function activityltCtrl.getEventCondition(eventID)
	local ret = 0
	local eventinfo = activityltCtrl.activity_event_list[eventID]
	if eventinfo then
		ret = eventinfo.condition[1]
	end
	return ret
end
function activityltCtrl.getTotalRankReward(serverLv)
	local _ENV, totalRankList
	for i, v in ipairs(activityltCtrl.activity_total_reward) do
		if serverLv >= v.serverLv[1] and serverLv <= v.serverLv[2] then
			table.insert(totalRankList, v)
		end
	end
	return totalRankList
end
function activityltCtrl.getStageReward(activityID, serverLv)
	local _ENV, ret
	for k, v in ipairs(activityltCtrl.activity_stage_reward) do
		if serverLv >= v.serverLv[1] and serverLv <= v.serverLv[2] then
			local activityIDList = v.activityID
			for _k, _v in pairs(activityIDList) do
				if _v == activityID then
					table.insert(ret, v)
				end
			end
		end
	end
	return ret
end
function activityltCtrl.getStageRankReward(stageReward, rank)
	return stageReward
end
function activityltCtrl.getDropRankReward()
	return activityltCtrl.activity_drop_reward
end
return activityltCtrl
