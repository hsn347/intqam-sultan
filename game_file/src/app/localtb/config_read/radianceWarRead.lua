local radianceWarRead = include("aAReadClass").new()
local LocalTblPath = _G.LocalTblPath
function radianceWarRead:init()
	radianceWarRead:defineValue("protectTimeCfg", function()
		local config = require_data("radiance_protect_time_config", true, true).data
		local _ENV, ret = "radiance_protect_time_config", "radiance_protect_time_config"
		for k, v in ipairs(config) do
			if not ret[v.mapType] then
				ret[v.mapType], _ENV = nil, nil
			end
			ret[v.mapType][v.lv] = v
		end
		return ret
	end)
	function _ENV()
		local config = require_data("radiance_protect_time_config", true, true).data
		local _ENV, ret = "radiance_protect_time_config", "radiance_protect_time_config"
		for k, v in ipairs(config) do
			if not ret[v.mapType] then
				ret[v.mapType], _ENV = nil, nil
			end
			ret[v.mapType][v.lv] = v
		end
		return ret
	end
	;(function()
		local config = require_data("radiance_protect_time_config", true, true).data
		local _ENV, ret = "radiance_protect_time_config", "radiance_protect_time_config"
		for k, v in ipairs(config) do
			if not ret[v.mapType] then
				ret[v.mapType], _ENV = nil, nil
			end
			ret[v.mapType][v.lv] = v
		end
		return ret
	end)[1] = "bright_war_minimap"
	radianceWarRead:defineValue("miniCfg", function()
		local config = require_data("radiance_protect_time_config", true, true).data
		local _ENV, ret = "radiance_protect_time_config", "radiance_protect_time_config"
		for k, v in ipairs(config) do
			if not ret[v.mapType] then
				ret[v.mapType], _ENV = nil, nil
			end
			ret[v.mapType][v.lv] = v
		end
		return ret
	end)
	function _UPVALUE2_()
		local config = require_data("radiance_protect_time_config", true, true).data
		local _ENV, ret = "radiance_protect_time_config", "radiance_protect_time_config"
		for k, v in ipairs(config) do
			if not ret[v.mapType] then
				ret[v.mapType], _ENV = nil, nil
			end
			ret[v.mapType][v.lv] = v
		end
		return ret
	end
	;(function()
		local config = require_data("radiance_protect_time_config", true, true).data
		local _ENV, ret = "radiance_protect_time_config", "radiance_protect_time_config"
		for k, v in ipairs(config) do
			if not ret[v.mapType] then
				ret[v.mapType], _ENV = nil, nil
			end
			ret[v.mapType][v.lv] = v
		end
		return ret
	end)[1] = "radiance_task_config"
	;(function()
		local config = require_data("radiance_protect_time_config", true, true).data
		local _ENV, ret = "radiance_protect_time_config", "radiance_protect_time_config"
		for k, v in ipairs(config) do
			if not ret[v.mapType] then
				ret[v.mapType], _ENV = nil, nil
			end
			ret[v.mapType][v.lv] = v
		end
		return ret
	end)[2] = true
	radianceWarRead:defineValue("taskConfig", function()
		local config = require_data("radiance_protect_time_config", true, true).data
		local _ENV, ret = "radiance_protect_time_config", "radiance_protect_time_config"
		for k, v in ipairs(config) do
			if not ret[v.mapType] then
				ret[v.mapType], _ENV = nil, nil
			end
			ret[v.mapType][v.lv] = v
		end
		return ret
	end)
	function _ENV()
		local config = require_data("radiance_protect_time_config", true, true).data
		local _ENV, ret = "radiance_protect_time_config", "radiance_protect_time_config"
		for k, v in ipairs(config) do
			if not ret[v.mapType] then
				ret[v.mapType], _ENV = nil, nil
			end
			ret[v.mapType][v.lv] = v
		end
		return ret
	end
	;(function()
		local config = require_data("radiance_protect_time_config", true, true).data
		local _ENV, ret = "radiance_protect_time_config", "radiance_protect_time_config"
		for k, v in ipairs(config) do
			if not ret[v.mapType] then
				ret[v.mapType], _ENV = nil, nil
			end
			ret[v.mapType][v.lv] = v
		end
		return ret
	end)[1] = "radiance_resource_config"
	radianceWarRead:defineValue("resCfg", function()
		local config = require_data("radiance_protect_time_config", true, true).data
		local _ENV, ret = "radiance_protect_time_config", "radiance_protect_time_config"
		for k, v in ipairs(config) do
			if not ret[v.mapType] then
				ret[v.mapType], _ENV = nil, nil
			end
			ret[v.mapType][v.lv] = v
		end
		return ret
	end)
	function _UPVALUE2_()
		local config = require_data("radiance_protect_time_config", true, true).data
		local _ENV, ret = "radiance_protect_time_config", "radiance_protect_time_config"
		for k, v in ipairs(config) do
			if not ret[v.mapType] then
				ret[v.mapType], _ENV = nil, nil
			end
			ret[v.mapType][v.lv] = v
		end
		return ret
	end
	;(function()
		local config = require_data("radiance_protect_time_config", true, true).data
		local _ENV, ret = "radiance_protect_time_config", "radiance_protect_time_config"
		for k, v in ipairs(config) do
			if not ret[v.mapType] then
				ret[v.mapType], _ENV = nil, nil
			end
			ret[v.mapType][v.lv] = v
		end
		return ret
	end)[1] = "radiance_resource"
	;(function()
		local config = require_data("radiance_protect_time_config", true, true).data
		local _ENV, ret = "radiance_protect_time_config", "radiance_protect_time_config"
		for k, v in ipairs(config) do
			if not ret[v.mapType] then
				ret[v.mapType], _ENV = nil, nil
			end
			ret[v.mapType][v.lv] = v
		end
		return ret
	end)[2] = true
	radianceWarRead:defineValue("resServerCfg", function()
		local config = require_data("radiance_protect_time_config", true, true).data
		local _ENV, ret = "radiance_protect_time_config", "radiance_protect_time_config"
		for k, v in ipairs(config) do
			if not ret[v.mapType] then
				ret[v.mapType], _ENV = nil, nil
			end
			ret[v.mapType][v.lv] = v
		end
		return ret
	end)
	function _UPVALUE2_()
		local config = require_data("radiance_protect_time_config", true, true).data
		local _ENV, ret = "radiance_protect_time_config", "radiance_protect_time_config"
		for k, v in ipairs(config) do
			if not ret[v.mapType] then
				ret[v.mapType], _ENV = nil, nil
			end
			ret[v.mapType][v.lv] = v
		end
		return ret
	end
	;(function()
		local config = require_data("radiance_protect_time_config", true, true).data
		local _ENV, ret = "radiance_protect_time_config", "radiance_protect_time_config"
		for k, v in ipairs(config) do
			if not ret[v.mapType] then
				ret[v.mapType], _ENV = nil, nil
			end
			ret[v.mapType][v.lv] = v
		end
		return ret
	end)[1] = "radiance_npc_config"
	;(function()
		local config = require_data("radiance_protect_time_config", true, true).data
		local _ENV, ret = "radiance_protect_time_config", "radiance_protect_time_config"
		for k, v in ipairs(config) do
			if not ret[v.mapType] then
				ret[v.mapType], _ENV = nil, nil
			end
			ret[v.mapType][v.lv] = v
		end
		return ret
	end)[2] = true
	radianceWarRead:defineValue("npcServerCfg", function()
		local config = require_data("radiance_protect_time_config", true, true).data
		local _ENV, ret = "radiance_protect_time_config", "radiance_protect_time_config"
		for k, v in ipairs(config) do
			if not ret[v.mapType] then
				ret[v.mapType], _ENV = nil, nil
			end
			ret[v.mapType][v.lv] = v
		end
		return ret
	end)
	function _UPVALUE2_()
		local config = require_data("radiance_protect_time_config", true, true).data
		local _ENV, ret = "radiance_protect_time_config", "radiance_protect_time_config"
		for k, v in ipairs(config) do
			if not ret[v.mapType] then
				ret[v.mapType], _ENV = nil, nil
			end
			ret[v.mapType][v.lv] = v
		end
		return ret
	end
	;(function()
		local config = require_data("radiance_protect_time_config", true, true).data
		local _ENV, ret = "radiance_protect_time_config", "radiance_protect_time_config"
		for k, v in ipairs(config) do
			if not ret[v.mapType] then
				ret[v.mapType], _ENV = nil, nil
			end
			ret[v.mapType][v.lv] = v
		end
		return ret
	end)[1] = "radiance_resource"
	;(function()
		local config = require_data("radiance_protect_time_config", true, true).data
		local _ENV, ret = "radiance_protect_time_config", "radiance_protect_time_config"
		for k, v in ipairs(config) do
			if not ret[v.mapType] then
				ret[v.mapType], _ENV = nil, nil
			end
			ret[v.mapType][v.lv] = v
		end
		return ret
	end)[2] = true
	radianceWarRead:defineValue("resValueCfg", function()
		local config = require_data("radiance_protect_time_config", true, true).data
		local _ENV, ret = "radiance_protect_time_config", "radiance_protect_time_config"
		for k, v in ipairs(config) do
			if not ret[v.mapType] then
				ret[v.mapType], _ENV = nil, nil
			end
			ret[v.mapType][v.lv] = v
		end
		return ret
	end)
	function _UPVALUE2_()
		local config = require_data("radiance_protect_time_config", true, true).data
		local _ENV, ret = "radiance_protect_time_config", "radiance_protect_time_config"
		for k, v in ipairs(config) do
			if not ret[v.mapType] then
				ret[v.mapType], _ENV = nil, nil
			end
			ret[v.mapType][v.lv] = v
		end
		return ret
	end
	;(function()
		local config = require_data("radiance_protect_time_config", true, true).data
		local _ENV, ret = "radiance_protect_time_config", "radiance_protect_time_config"
		for k, v in ipairs(config) do
			if not ret[v.mapType] then
				ret[v.mapType], _ENV = nil, nil
			end
			ret[v.mapType][v.lv] = v
		end
		return ret
	end)[1] = "radiance_hospital_config"
	;(function()
		local config = require_data("radiance_protect_time_config", true, true).data
		local _ENV, ret = "radiance_protect_time_config", "radiance_protect_time_config"
		for k, v in ipairs(config) do
			if not ret[v.mapType] then
				ret[v.mapType], _ENV = nil, nil
			end
			ret[v.mapType][v.lv] = v
		end
		return ret
	end)[2] = true
	radianceWarRead:defineValue("armyCureTime", function()
		local config = require_data("radiance_protect_time_config", true, true).data
		local _ENV, ret = "radiance_protect_time_config", "radiance_protect_time_config"
		for k, v in ipairs(config) do
			if not ret[v.mapType] then
				ret[v.mapType], _ENV = nil, nil
			end
			ret[v.mapType][v.lv] = v
		end
		return ret
	end)
	function _ENV()
		local config = require_data("radiance_protect_time_config", true, true).data
		local _ENV, ret = "radiance_protect_time_config", "radiance_protect_time_config"
		for k, v in ipairs(config) do
			if not ret[v.mapType] then
				ret[v.mapType], _ENV = nil, nil
			end
			ret[v.mapType][v.lv] = v
		end
		return ret
	end
	;(function()
		local config = require_data("radiance_protect_time_config", true, true).data
		local _ENV, ret = "radiance_protect_time_config", "radiance_protect_time_config"
		for k, v in ipairs(config) do
			if not ret[v.mapType] then
				ret[v.mapType], _ENV = nil, nil
			end
			ret[v.mapType][v.lv] = v
		end
		return ret
	end)[1] = "bright_war_building"
	radianceWarRead:defineValue("bright_war_building", function()
		local config = require_data("radiance_protect_time_config", true, true).data
		local _ENV, ret = "radiance_protect_time_config", "radiance_protect_time_config"
		for k, v in ipairs(config) do
			if not ret[v.mapType] then
				ret[v.mapType], _ENV = nil, nil
			end
			ret[v.mapType][v.lv] = v
		end
		return ret
	end)
	radianceWarRead:defineValue("buildGateCfg", function()
		_ENV, _ENV = nil, nil
		;(nil).image = "Map_build_radiance_gate_01.png"
		;(nil).x = -18.26
		;(nil).y = -4.68
		;(nil).nodeName = "Node_rb"
		;(nil).gatePos = cc.p(15, -25)
		_ENV, (nil)[1], (nil).nodeScale = nil, nil, 1.2
		;(nil).image = "Map_build_radiance_gate_02.png"
		;(nil).x = -22.35
		;(nil).y = -16.08
		;(nil).nodeName = "Node_rb"
		;(nil).gatePos = cc.p(25, -35)
		_ENV, (nil)[2], (nil).nodeScale = nil, nil, 1.2
		;(nil).image = "Map_build_radiance_gate_03.png"
		;(nil).x = 69.65
		;(nil).y = -13.08
		;(nil).nodeName = "Node_lb"
		;(nil).gatePos = cc.p(-5, -30)
		_ENV, (nil)[3], (nil).nodeScale = nil, nil, 1.2
		;(nil).image = "Map_build_radiance_gate_04.png"
		;(nil).x = 49.49
		;(nil).y = 12.32
		;(nil).nodeName = "Node_lb"
		;(nil).gatePos = cc.p(0, -20)
		;(nil)[4], (nil).nodeScale = nil, 1.2
		return nil
	end)
	radianceWarRead:defineValue("tableWarBuildingInfo", function()
		_ENV = nil
		_ENV = nil
		;(nil).name = "brightWar_build_10"
		;(nil).icon = "radiance_smallmap_castle.png"
		;(nil).image = "Map_build_radiance_palace.png"
		;(nil)[gMapObjTypeDef.mapTypeRadianceWarPalace], (nil).mailIcon = nil, "icon_mail_Radiant_Palace.png"
		_ENV = nil
		;(nil).name = "brightWar_build_07"
		;(nil).icon = "radiance_smallmap_screening.png"
		;(nil).image = "Map_build_radiance_gate_01.png"
		;(nil)[gMapObjTypeDef.mapTypeRadianceWarGate], (nil).mailIcon = nil, "icon_mail_Outpost.png"
		_ENV = nil
		;(nil).name = "brightWar_build_09"
		;(nil).icon = "radiance_smallmap_beacon.png"
		;(nil).image = "Map_build_radiance_beacon.png"
		_ENV, (nil)[gMapObjTypeDef.mapTypeRadianceWarBeacon], (nil).mailIcon = gMapObjTypeDef.mapTypeRadianceWarBeacon, nil, "icon_mail_Beacon_Tower.png"
		gMapObjTypeDef.mapTypeRadianceWarBeacon.name = "brightWar_build_08"
		gMapObjTypeDef.mapTypeRadianceWarBeacon.icon = "radiance_smallmap_rampart.png"
		;(nil)[999], gMapObjTypeDef.mapTypeRadianceWarBeacon.image = gMapObjTypeDef.mapTypeRadianceWarBeacon, "ruins_palace.png"
		return nil
	end)
	radianceWarRead:defineValue("questList", function()
		radianceWarRead.questList, radianceWarRead = nil, nil
		local radianceWarRead, dailyTask
		local radianceWarRead, seasonTask
		for _, v in ipairs(radianceWarRead.taskConfig) do
			if v.taskType == 1 then
				table.insert(dailyTask, v.taskID)
			else
				table.insert(seasonTask, v.taskID)
			end
		end
		table.insert(radianceWarRead.questList, dailyTask)
		table.insert(radianceWarRead.questList, seasonTask)
		return radianceWarRead.questList
	end)
	local createData = function(name)
		radianceWarRead.AllRewardList, radianceWarRead, radianceWarRead.PersonTimeRewardList, radianceWarRead, radianceWarRead.APRewardList, radianceWarRead, radianceWarRead.ACRewardList, radianceWarRead, radianceWarRead.PersonRewardList, radianceWarRead, radianceWarRead.winnerRewardList, radianceWarRead, radianceWarRead.rewardCfg = require_data("radiance_reward", true, true).data, require_data("radiance_reward", true, true).data, require_data("radiance_reward", true, true).data, require_data("radiance_reward", true, true).data, require_data("radiance_reward", true, true).data, require_data("radiance_reward", true, true).data, require_data("radiance_reward", true, true).data, require_data("radiance_reward", true, true).data, require_data("radiance_reward", true, true).data, require_data("radiance_reward", true, true).data, require_data("radiance_reward", true, true).data, require_data("radiance_reward", true, true).data, require_data("radiance_reward", true, true).data
		radianceWarRead.AllRewardList[7], radianceWarRead = "radiance_reward", "radiance_reward"
		radianceWarRead.AllRewardList[8], radianceWarRead = "radiance_reward", "radiance_reward"
		for i, v in ipairs(radianceWarRead.rewardCfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.reward = serviceFunctions.tableFormat(v.reward, nil)
			if v.type == 1 then
				v.title = "brightWar_title_03"
				v.describe = "brightWar_text_110"
				table.insert(radianceWarRead.winnerRewardList, v)
			elseif v.type == 5 then
				v.title = "brightWar_text_90"
				v.describe = "brightWar_text_111"
				table.insert(radianceWarRead.winnerRewardList, v)
			else
				if v.rank[1] == v.rank[2] then
					_ENV = v.rank[1]
					v.rank[1].num = v.rank[1]
					v.title, v.rank[1][1] = v.rank[1], "common_text_617"
				else
					_ENV = v.rank[1]
					v.rank[1].num = v.rank[1] .. " - " .. v.rank[2]
					v.title, v.rank[1][1] = v.rank[1], "common_text_617"
				end
				if v.type == 2 then
					table.insert(radianceWarRead.PersonRewardList, v)
				elseif v.type == 3 then
					table.insert(radianceWarRead.ACRewardList, v)
				elseif v.type == 4 then
					table.insert(radianceWarRead.APRewardList, v)
				elseif v.type == 6 then
					table.insert(radianceWarRead.PersonTimeRewardList, v)
				elseif v.type == 7 then
					table.insert(radianceWarRead.AllRewardList[7], v)
				elseif v.type == 8 then
					table.insert(radianceWarRead.AllRewardList[8], v)
				end
			end
		end
		return radianceWarRead[name]
	end
	radianceWarRead:defineValue("rewardCfg", createData)
	radianceWarRead:defineValue("winnerRewardList", createData)
	radianceWarRead:defineValue("PersonRewardList", createData)
	radianceWarRead:defineValue("ACRewardList", createData)
	radianceWarRead:defineValue("APRewardList", createData)
	radianceWarRead:defineValue("PersonTimeRewardList", createData)
	radianceWarRead:defineValue("AllRewardList", createData)
	local currentTime = os.time()
	local currentDate = os.date("*t", currentTime)
	currentDate.isdst = false
	local time_zero = os.time(os.date("!*t", currentTime)) - os.time(currentDate)
	local createData2 = function(name)
		local transTime = function(dateStr, timeStr)
			local date = serviceFunctions.split(dateStr, ":")
			local time = serviceFunctions.split(timeStr, ":")
			if 3 <= #date and 2 <= #time then
				_ENV = #time
				;(#time).year = tonumber(date[1])
				;(#time).month = tonumber(date[2])
				;(#time).day = tonumber(date[3])
				;(#time).hour = tonumber(time[1] or 0)
				local (#time).min, timeTable = tonumber(time[2] or 0), #time
				local beginTime = os.time(timeTable)
				beginTime = beginTime - time_zero
				return beginTime
			end
		end
		radianceWarRead.radiance_activity_opendate_config, _ENV, radianceWarRead.radiance_build_opendate_config, _ENV = nil, nil, nil, nil
		local openDate = _G.require_data("radiance_build_opendate_config", true).data
		for _, v in ipairs(openDate) do
			local _ENV, openDateData
			if v.mapType == 1 then
				local open = transTime(v.openDate, v.openTime)
				openDateData.open = open
				openDateData.close = open + v.openSec
				table.insert(radianceWarRead.radiance_activity_opendate_config, openDateData)
			else
				openDateData.mapType = v.mapType
				openDateData.lv = v.lv
				openDateData.openDate = transTime(v.openDate, v.openTime)
				table.insert(radianceWarRead.radiance_build_opendate_config, openDateData)
			end
		end
		table.sort(radianceWarRead.radiance_activity_opendate_config, function(a, b)
			return a.open < b.open
		end)
		if name == "radiance_build_opendate_config" then
			return radianceWarRead.radiance_build_opendate_config
		elseif name == "radiance_activity_opendate_config" then
			return radianceWarRead.radiance_activity_opendate_config
		end
	end
	radianceWarRead:defineValue("radiance_build_opendate_config", createData2)
	radianceWarRead:defineValue("radiance_activity_opendate_config", createData2)
end
function radianceWarRead.getBuildName(buildTypeID, objId)
	buildTypeID = tonumber(buildTypeID)
	local nameKey
	if objId and buildTypeID == gMapObjTypeDef.mapTypeRadianceWarGate then
		local buildCfg = radianceWarRead.bright_war_building[objId]
		if buildCfg then
			nameKey = buildCfg.name
		end
	end
	nameKey = nameKey or radianceWarRead.tableWarBuildingInfo[buildTypeID].name
	local name = i18n(nameKey)
	if objId and buildTypeID ~= gMapObjTypeDef.mapTypeRadianceWarPalace then
		local lv = radianceWarRead.getBuildLv(objId)
		_ENV = nil
		;(nil).lv = lv
		;(nil).name = name
		name = i18n("common_text_134", nil)
	end
	return name
end
function radianceWarRead.getBuildIcon(buildTypeID)
	buildTypeID = tonumber(buildTypeID)
	return radianceWarRead.tableWarBuildingInfo[buildTypeID].icon
end
function radianceWarRead.getBuildImage(buildTypeID, objId)
	buildTypeID = tonumber(buildTypeID)
	if objId then
		local buildCfg = radianceWarRead.getBuildGateConfig(objId)
		if buildCfg and buildCfg.image then
			return buildCfg.image
		end
	end
	return radianceWarRead.tableWarBuildingInfo[buildTypeID].image
end
function radianceWarRead.getMailIcon(buildTypeID, objId)
	buildTypeID = tonumber(buildTypeID)
	local buildInfo = radianceWarRead.tableWarBuildingInfo[buildTypeID]
	if buildInfo and buildInfo.mailIcon then
		return buildInfo.mailIcon
	end
	return radianceWarRead.getResourceMailIcon(objId)
end
function radianceWarRead.getBuildPos(objId)
	local buildCfg = radianceWarRead.getBuildGateConfig(objId)
	if buildCfg then
		return buildCfg.x or 0, buildCfg.y or 0
	end
	return 0, 0
end
function radianceWarRead.getBuildGateConfig(objId)
	local cfg = radianceWarRead.bright_war_building[objId]
	if cfg and cfg.image then
		if not radianceWarRead.buildGateCfg[cfg.image] then
			radianceWarRead = radianceWarRead.buildGateCfg[cfg.image]
		end
		return radianceWarRead.buildGateCfg[cfg.image]
	end
end
function radianceWarRead.getBuildGateNodeName(objId)
	local buildCfg = radianceWarRead.getBuildGateConfig(objId)
	return buildCfg and buildCfg.nodeName
end
function radianceWarRead.getBuildGatePos(objId)
	local buildCfg = radianceWarRead.getBuildGateConfig(objId)
	return buildCfg and buildCfg.gatePos or cc.p(0, 0), buildCfg and buildCfg.nodeScale or 1.0
end
function radianceWarRead.getTaskTypeByTaskID(taskID)
	for _, v in ipairs(radianceWarRead.taskConfig) do
		if v.taskID == taskID then
			return v.taskType
		end
	end
end
function radianceWarRead.getResourceOutputID(resID)
	local resourceData = radianceWarRead.resValueCfg[resID] or radianceWarRead.resValueCfg[125001]
	return resourceData.outputId
end
function radianceWarRead.getResourceBuff(resType)
	for k, v in pairs(radianceWarRead.resCfg) do
		if v.resType == resType then
			return v.buff
		end
	end
end
function radianceWarRead.getResourceType(resID)
	local resourceData = radianceWarRead.resCfg[resID] or radianceWarRead.resCfg[125001]
	return resourceData.resType
end
function radianceWarRead.getResourceImageName(resID)
	local resourceData = radianceWarRead.resCfg[resID] or radianceWarRead.resCfg[125001]
	return resourceData.resModel
end
function radianceWarRead.getResourceIconName(resID)
	local resourceData = radianceWarRead.resCfg[resID] or radianceWarRead.resCfg[125001]
	return resourceData.iconImage
end
function radianceWarRead.getResourceName(resID, needLv)
	local resourceData = radianceWarRead.resCfg[resID] or radianceWarRead.resCfg[125001]
	local resourceName = i18n(resourceData.resName)
	if needLv then
		local lv = resourceData.resLevel
		radianceWarRead = nil
		;(nil).lv = lv
		;(nil).name = resourceName
		resourceName = i18n("common_text_134", nil)
	end
	return resourceName
end
function radianceWarRead.getResourceMailIcon(resID)
	local resourceData = radianceWarRead.resCfg[resID] or radianceWarRead.resCfg[125001]
	return resourceData.mailIcon
end
function radianceWarRead.getResourceImageNameByType(resType)
	for k, v in pairs(radianceWarRead.resCfg) do
		if v.resType == resType then
			return v.resModel
		end
	end
end
function radianceWarRead.getResourceSmallImageNameByType(resType)
	for k, v in pairs(radianceWarRead.resCfg) do
		if v.resType == resType then
			return v.smalliconImage
		end
	end
end
function radianceWarRead.getResourceNameByType(resType)
	for k, v in pairs(radianceWarRead.resCfg) do
		if v.resType == resType then
			return i18n(v.resName)
		end
	end
end
function radianceWarRead.getResourceOutputIDByType(resType)
	for k, v in pairs(radianceWarRead.resValueCfg) do
		if v.resType == resType then
			return v.outputId
		end
	end
end
function radianceWarRead.getResourceTpyeID(resID)
	local resourceData = radianceWarRead.resCfg[resID] or radianceWarRead.resCfg[125001]
	return resourceData.resType
end
function radianceWarRead.getResourceLevel(resID)
	local resourceData = radianceWarRead.resCfg[resID] or radianceWarRead.resCfg[125001]
	return resourceData.resLevel
end
function radianceWarRead.getResourceTpyePos(resID)
	local resourceData = radianceWarRead.resCfg[resID] or radianceWarRead.resCfg[125001]
	return resourceData.x or 0, resourceData.y or 0
end
function radianceWarRead.getResourceSpeed(resID)
	local resourceData = radianceWarRead.resServerCfg[resID] or radianceWarRead.resServerCfg[125001]
	return resourceData.outputSpeed
end
function radianceWarRead.getQuestList(taskType)
	if not radianceWarRead.questList[taskType] then
		radianceWarRead = radianceWarRead.questList[taskType]
	end
	return radianceWarRead.questList[taskType]
end
function radianceWarRead.getBuildMiniInfo(objectId)
	return radianceWarRead.miniCfg[objectId]
end
local Ground_5_1 = 101000
local Ground_5 = 103000
local Ground_11 = 110000
local Ground_17 = 115000
function radianceWarRead.getBuildLv(objectId)
	if objectId then
		if objectId < Ground_5_1 then
			local cfg = radianceWarRead.bright_war_building[objectId]
			if cfg and cfg.lv then
				return cfg.lv
			end
			return 1
		elseif objectId < Ground_5 then
			return 1
		elseif objectId < Ground_11 then
			return 3
		elseif objectId < Ground_17 then
			return 2
		end
	end
	return 1
end
function radianceWarRead.getBuildRange(objectId)
	if objectId < Ground_5_1 then
		local cfg = radianceWarRead.bright_war_building[objectId]
		if cfg then
			if cfg.range and cfg.range > 0 then
				return cfg.range
			end
			if cfg.faceTo == 2 then
				return 0, 1
			else
				return 1, 0
			end
		end
		return 1
	elseif objectId < Ground_11 then
		return 2
	elseif objectId < Ground_17 then
		return 5
	else
		return 8
	end
end
function radianceWarRead.getResourceNumLimit(resType)
	local gametop = gModuleMgr.getObject("gametop")
	local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
	local constantRead = include("constantRead")
	local maxNum = 0
	if resType == gWorldTypeServerDef.subMapTypeRadianceWarResMedalWorkshop then
		maxNum = constantRead.getConstValue("RADIANCE_MAX__MEDAL_WORKSHOP_NUM", 0)
		maxNum = maxNum + (technologyCtrl:getTechnologyPower(gTechnologyType.RADIANCE_WAR_BADGE_BUILD_NUM_ADD) or 0)
	elseif resType == gWorldTypeServerDef.subMapTypeRadianceWarResAdvMedalWorkshop then
		maxNum = constantRead.getConstValue("RADIANCE_MAX__ADV_MEDAL_WORKSHOP_NUM", 0)
		maxNum = maxNum + (technologyCtrl:getTechnologyPower(gTechnologyType.RADIANCE_WAR_COLLECT_SUPER_WAR_BADGE_NUM_ADD) or 0)
	elseif resType == gWorldTypeServerDef.subMapTypeRadianceWarResRadiantQuarry then
		maxNum = constantRead.getConstValue("RADIANCE_MAX_RADIANT_QUARRY_NUM", 0)
	elseif resType == gWorldTypeServerDef.subMapTypeRadianceWarResAstralRuins then
		maxNum = constantRead.getConstValue("RADIANCE_MAX__ASTRAL_RUINS_NUM", 0)
		maxNum = maxNum + (technologyCtrl:getTechnologyPower(gTechnologyType.RADIANCE_WAR_COLLECT_STAR_STONE_NUM_ADD) or 0)
	elseif resType == gWorldTypeServerDef.subMapTypeRadianceWarResAmberMine then
		local attributeSystem = include("attributeSystem")
		maxNum = constantRead.getConstValue("RADIANCE_MAX__AMBER_MINE_NUM", 0)
		_ENV, maxNum = technologyCtrl:getTechnologyPower(gTechnologyType.RADIANCE_WAR_COLLECT_AMBER_OR_STONE_BUILD_NUM_ADD) or 0, maxNum + (technologyCtrl:getTechnologyPower(gTechnologyType.RADIANCE_WAR_COLLECT_AMBER_OR_STONE_BUILD_NUM_ADD) or 0)
		;(technologyCtrl:getTechnologyPower(gTechnologyType.RADIANCE_WAR_COLLECT_AMBER_OR_STONE_BUILD_NUM_ADD) or 0).mapObjType = gWorldTypeServerDef.mapTypeRadianceWarResource
		local (technologyCtrl:getTechnologyPower(gTechnologyType.RADIANCE_WAR_COLLECT_AMBER_OR_STONE_BUILD_NUM_ADD) or 0).subMapObjType, attrFilter = gWorldTypeServerDef.subMapTypeRadianceWarResAmberMine, technologyCtrl:getTechnologyPower(gTechnologyType.RADIANCE_WAR_COLLECT_AMBER_OR_STONE_BUILD_NUM_ADD) or 0
		local attrValue = attributeSystem.query(gAttributeEnum.PROMOTE_BUILD_OCCUPY_NUM, attrFilter, gAttributeSourceEnum.EQUIPMENT)
		maxNum = maxNum + attrValue
	elseif resType == gWorldTypeServerDef.subMapTypeRadianceWarResAstralMine then
		maxNum = constantRead.getConstValue("RADIANCE_MAX__ASTRAL_MINE_NUM", 0)
		maxNum = maxNum + (technologyCtrl:getTechnologyPower(gTechnologyType.RADIANCE_WAR_COLLECT_AMBER_OR_STONE_BUILD_NUM_ADD) or 0)
	end
	return maxNum
end
function radianceWarRead.getBuildArmyNum(mapType, subType, lv)
	local army = radianceWarRead.getBuildArmy(mapType, subType, lv)
	local num = 0
	for i, v in ipairs(army) do
		num = num + v.num
	end
	return num
end
function radianceWarRead.getBuildArmy(mapType, subType, lv)
	local _ENV, army
	for _, v in ipairs(radianceWarRead.npcServerCfg) do
		if v.mapType == mapType and v.subMapType == subType and v.lv == lv then
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "num"
			army, _ENV = serviceFunctions.tableFormat(v.CastleArmyType, nil), serviceFunctions.tableFormat(v.CastleArmyType, nil)
			army = serviceFunctions.tableFormat(v.CastleArmyType, nil) or nil
			break
		end
	end
	return army
end
function radianceWarRead.getBuildPerATKHP(mapType, subType, lv)
	for _, v in ipairs(radianceWarRead.npcServerCfg) do
		if v.mapType == mapType and v.subMapType == subType and v.lv == lv then
			return v.PerATKHP or 1
		end
	end
	return 1
end
function radianceWarRead.getBuildHp(mapType, subType, lv)
	for _, v in ipairs(radianceWarRead.npcServerCfg) do
		if v.mapType == mapType and v.subMapType == subType and v.lv == lv then
			return v.HP or 1
		end
	end
	return 1
end
function radianceWarRead.getBuildHpByObjectId(objectId)
	local cfg = radianceWarRead.bright_war_building[objectId]
	if cfg and cfg.lv then
		return radianceWarRead.getBuildHp(cfg.mapType, 1, cfg.lv)
	end
	return 1
end
function radianceWarRead.getBuildOpenTime(mapType, lv)
	for _, v in ipairs(radianceWarRead.radiance_build_opendate_config) do
		if v.mapType == mapType and v.lv == lv then
			return v.openDate
		end
	end
end
function radianceWarRead.getActiveTimeCfg(curTime)
	curTime = curTime or serviceFunctions.systemTime()
	local last
	for _, v in ipairs(radianceWarRead.radiance_activity_opendate_config) do
		last = v
		if curTime < v.close then
			break
		end
	end
	return last
end
function radianceWarRead.getActiveTimeCfgOpen(curTime)
	curTime = curTime or serviceFunctions.systemTime()
	local last = radianceWarRead.radiance_activity_opendate_config[#radianceWarRead.radiance_activity_opendate_config]
	for i = #radianceWarRead.radiance_activity_opendate_config, 1, -1 do
		local v = radianceWarRead.radiance_activity_opendate_config[i]
		if curTime >= v.close then
			break
		end
		last = v
	end
	return last
end
function radianceWarRead.getRewardList(type)
	if type == 1 then
		return radianceWarRead.winnerRewardList
	elseif type == 2 then
		return radianceWarRead.PersonRewardList
	elseif type == 3 then
		return radianceWarRead.ACRewardList
	elseif type == 4 then
		return radianceWarRead.APRewardList
	elseif type == 6 then
		return radianceWarRead.PersonTimeRewardList
	elseif type == 7 then
		return radianceWarRead.AllRewardList[7]
	elseif type == 8 then
		return radianceWarRead.AllRewardList[8]
	end
end
function radianceWarRead.getBuildingList()
	return radianceWarRead.bright_war_building
end
function radianceWarRead.getRadianceWarArmyCureTime(armyLv)
	local cfg = radianceWarRead.armyCureTime[armyLv]
	if cfg and cfg.CureTime then
		return cfg.CureTime / 1000
	end
	return 0
end
function radianceWarRead.getRadianceRuleConfig()
	local _ENV, reTbl
	for i, v in ipairs(radianceWarRead.armyCureTime) do
		if v.ArmyLv > 8 then
			table.insert(reTbl, v)
		end
	end
	return reTbl
end
function radianceWarRead.getProtectTime(mapType, lv)
	return radianceWarRead.protectTimeCfg[mapType][lv].protectTime
end
function radianceWarRead.getCaptureTime(mapType, lv)
	return radianceWarRead.protectTimeCfg[mapType][lv].captureTime
end
function radianceWarRead.getGiveupTime(mapType, lv)
	return radianceWarRead.protectTimeCfg[mapType][lv].giveupTime
end
radianceWarRead:init()
return radianceWarRead
