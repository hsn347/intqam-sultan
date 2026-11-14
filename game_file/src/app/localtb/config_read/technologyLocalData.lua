local technologyLocalData = include("aAReadClass").new()
_ENV = "aAReadClass"
;("aAReadClass")[1] = "resource"
;("aAReadClass")[2] = "cityDevelop"
;("aAReadClass")[3] = "anchor"
;("aAReadClass")[4] = "military"
;("aAReadClass")[5] = "special"
;("aAReadClass")[6] = "soldier"
;("aAReadClass")[7] = "leader"
;("aAReadClass")[8] = "hero"
;("aAReadClass")[11] = "wartechnology"
;("aAReadClass")[12] = "warbattle"
;("aAReadClass")[13] = "warmilitary"
;("aAReadClass")[14] = "warcommand"
;("aAReadClass")[15] = "warlight"
;("aAReadClass")[16] = "advancedmilitary"
;("aAReadClass")[17] = "process"
;("aAReadClass")[18] = "nebula"
local ("aAReadClass")[19], typeName = "manor", "aAReadClass"
local isInited = false
local init = function()
	if isInited then
		return
	end
	technologyLocalData.init()
end
function technologyLocalData.init()
	typeName = nil
	;(nil)[1] = "technology"
	;(nil)[2] = true
	technologyLocalData:defineValue("technology", nil)
	technologyLocalData:defineValue("technologyData", function()
		technologyLocalData.technologyData, technologyLocalData = nil, nil
		for _, var in ipairs(technologyLocalData.technology) do
			technologyLocalData.technologyData[tostring(var.technologyID)] = var
		end
		return technologyLocalData.technologyData
	end)
	technologyLocalData:defineValue("technologyTypeData", function()
		technologyLocalData.technologyTypeData, (nil).manor, technologyLocalData, (nil).nebula, technologyLocalData, (nil).process, technologyLocalData, (nil).advancedmilitary, technologyLocalData, (nil).warlight, technologyLocalData, (nil).warcommand, technologyLocalData, (nil).warmilitary, technologyLocalData, (nil).warbattle, technologyLocalData, (nil).wartechnology, technologyLocalData, (nil).hero, technologyLocalData, (nil).leader, technologyLocalData, (nil).soldier, technologyLocalData, (nil).special, technologyLocalData, (nil).military, technologyLocalData, (nil).anchor, technologyLocalData, (nil).cityDevelop, technologyLocalData, (nil).resource, technologyLocalData, technologyLocalData = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
		local technologyTypeData = technologyLocalData.technologyTypeData
		for _, var in ipairs(technologyLocalData.technology) do
			local prefix = technologyLocalData.getPrefix(tostring(var.technologyID))
			local tType = var.technologyType
			local tName = typeName[tType]
			if tName and technologyTypeData[tName][prefix] == nil then
				technologyLocalData = tostring(var.technologyID)
				tostring(var.technologyID).technologyID = prefix
				tostring(var.technologyID).isOpened = false
				tostring(var.technologyID).currentLevel = 0
				technologyTypeData[tName][prefix], tostring(var.technologyID).maxLevel = tostring(var.technologyID)
			end
		end
		return technologyTypeData
	end)
	technologyLocalData:defineValue("technologyCascadeData", function()
		technologyLocalData.technologyCascadeData, technologyLocalData = nil, nil
		for _, var in ipairs(technologyLocalData.technology) do
			if var.technologyPrepose and var.technologyLevel == 1 then
				_UPVALUE2_ = nil
				;(nil)[1] = "technologyPreposeID"
				;(nil)[2] = "technologyPreposeLevel"
				local prePose = serviceFunctions.tableFormat(var.technologyPrepose, nil)
				local technologyLocalData, tempTab = var.technologyPrepose, var.technologyPrepose
				local prefix = technologyLocalData.getPrefix(tostring(var.technologyID))
				for k, v in pairs(prePose) do
					if v.technologyPreposeID > 0 and v.technologyPreposeLevel > 0 then
						table.insert(tempTab, technologyLocalData.getPrefix(tostring(v.technologyPreposeID)))
					end
				end
				technologyLocalData.technologyCascadeData[prefix] = tempTab
			end
		end
		return technologyLocalData.technologyCascadeData
	end)
	technologyLocalData:defineValue("technologyRelationData", function()
		technologyLocalData.technologyRelationData, technologyLocalData = nil, nil
		local relationTechnology = technologyLocalData.technologyCascadeData
		local technologyRelationData = technologyLocalData.technologyRelationData
		for k, var in pairs(relationTechnology) do
			if type(var) == "table" then
				for _, v in ipairs(var) do
					local tempTab = technologyRelationData[v]
					if tempTab == nil then
						tempTab, technologyLocalData = nil, nil
						technologyRelationData[v] = tempTab
					end
					tempTab[#tempTab + 1] = k
				end
			end
		end
		return technologyLocalData.technologyRelationData
	end)
	technologyLocalData:defineValue("processData", function()
		technologyLocalData.processData, technologyLocalData = nil, nil
		local technology = require("app." .. LocalTblPath .. ".config_client.technology_rank_show")
		local constantRead = include("constantRead")
		for quality, var in ipairs(technology) do
			for _, technologyID in ipairs(var.technologyID) do
				if not technologyLocalData.processData[quality] then
					technologyLocalData.processData[quality], technologyLocalData = nil, nil
				end
				if not technologyLocalData.processData[quality].technologyID then
					technologyLocalData.processData[quality].technologyID, technologyLocalData = nil, nil
				end
				table.insert(technologyLocalData.processData[quality].technologyID, technologyID)
				technologyLocalData.processData[quality].lvLimit = var.lv
			end
			if not (commonCheck.WARFRAME and commonCheck.BRAVESTATUS and var.warframeTecID) or not IsArClient and serviceFunctions.systemTime() < constantRead.getConstValue("SOLDIERS_ARMOR_LIMIT_TIME_ROS") then
			else
				for _, technologyID in ipairs(var.warframeTecID) do
					if not technologyLocalData.processData[quality] then
						technologyLocalData.processData[quality], technologyLocalData = var.lv, var.lv
					end
					if not technologyLocalData.processData[quality].technologyID then
						technologyLocalData.processData[quality].technologyID, technologyLocalData = var.lv, var.lv
					end
					table.insert(technologyLocalData.processData[quality].technologyID, technologyID)
				end
				technologyLocalData.processData[quality].lvLimit = var.lv
			end
		end
		return technologyLocalData.processData
	end)
	technologyLocalData:defineValue("nebulashow", function()
		local nebulaShowData = require_once("app." .. LocalTblPath .. ".config_client.technology_nebula_show")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_client.technology_nebula_show", "app." .. LocalTblPath .. ".config_client.technology_nebula_show"
		for _, var in ipairs(nebulaShowData) do
			local _ENV, levelTechs
			for i = 1, 4 do
				levelTechs[i] = tonumber(var.technologyID[i * 2])
			end
			_ENV = (for index)
			;(1).bid = var.lv[1]
			local (1).lv, levelLimits = var.lv[2], 1
			local _ENV, preTechs = var.lv[2], var.lv[2]
			for i = 1, 4 do
				preTechs[i] = tonumber(var.technologyPrepose[i * 2])
			end
			var.technologyID = levelTechs
			var.lv = levelLimits
			var.technologyPrepose = preTechs
			local classType = var.type
			if not ret[classType] then
				_ENV = ret[classType]
			end
			ret[classType] = ret[classType]
			if not ret[classType][var.season] then
				_ENV = ret[classType][var.season]
			end
			ret[classType][var.season] = ret[classType][var.season]
			table.insert(ret[classType][var.season], var)
		end
		return ret
	end)
	function typeName()
		local nebulaShowData = require_once("app." .. LocalTblPath .. ".config_client.technology_nebula_show")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_client.technology_nebula_show", "app." .. LocalTblPath .. ".config_client.technology_nebula_show"
		for _, var in ipairs(nebulaShowData) do
			local _ENV, levelTechs
			for i = 1, 4 do
				levelTechs[i] = tonumber(var.technologyID[i * 2])
			end
			_ENV = (for index)
			;(1).bid = var.lv[1]
			local (1).lv, levelLimits = var.lv[2], 1
			local _ENV, preTechs = var.lv[2], var.lv[2]
			for i = 1, 4 do
				preTechs[i] = tonumber(var.technologyPrepose[i * 2])
			end
			var.technologyID = levelTechs
			var.lv = levelLimits
			var.technologyPrepose = preTechs
			local classType = var.type
			if not ret[classType] then
				_ENV = ret[classType]
			end
			ret[classType] = ret[classType]
			if not ret[classType][var.season] then
				_ENV = ret[classType][var.season]
			end
			ret[classType][var.season] = ret[classType][var.season]
			table.insert(ret[classType][var.season], var)
		end
		return ret
	end
	;(function()
		local nebulaShowData = require_once("app." .. LocalTblPath .. ".config_client.technology_nebula_show")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_client.technology_nebula_show", "app." .. LocalTblPath .. ".config_client.technology_nebula_show"
		for _, var in ipairs(nebulaShowData) do
			local _ENV, levelTechs
			for i = 1, 4 do
				levelTechs[i] = tonumber(var.technologyID[i * 2])
			end
			_ENV = (for index)
			;(1).bid = var.lv[1]
			local (1).lv, levelLimits = var.lv[2], 1
			local _ENV, preTechs = var.lv[2], var.lv[2]
			for i = 1, 4 do
				preTechs[i] = tonumber(var.technologyPrepose[i * 2])
			end
			var.technologyID = levelTechs
			var.lv = levelLimits
			var.technologyPrepose = preTechs
			local classType = var.type
			if not ret[classType] then
				_ENV = ret[classType]
			end
			ret[classType] = ret[classType]
			if not ret[classType][var.season] then
				_ENV = ret[classType][var.season]
			end
			ret[classType][var.season] = ret[classType][var.season]
			table.insert(ret[classType][var.season], var)
		end
		return ret
	end)[1] = "technology_nebula_daily"
	;(function()
		local nebulaShowData = require_once("app." .. LocalTblPath .. ".config_client.technology_nebula_show")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_client.technology_nebula_show", "app." .. LocalTblPath .. ".config_client.technology_nebula_show"
		for _, var in ipairs(nebulaShowData) do
			local _ENV, levelTechs
			for i = 1, 4 do
				levelTechs[i] = tonumber(var.technologyID[i * 2])
			end
			_ENV = (for index)
			;(1).bid = var.lv[1]
			local (1).lv, levelLimits = var.lv[2], 1
			local _ENV, preTechs = var.lv[2], var.lv[2]
			for i = 1, 4 do
				preTechs[i] = tonumber(var.technologyPrepose[i * 2])
			end
			var.technologyID = levelTechs
			var.lv = levelLimits
			var.technologyPrepose = preTechs
			local classType = var.type
			if not ret[classType] then
				_ENV = ret[classType]
			end
			ret[classType] = ret[classType]
			if not ret[classType][var.season] then
				_ENV = ret[classType][var.season]
			end
			ret[classType][var.season] = ret[classType][var.season]
			table.insert(ret[classType][var.season], var)
		end
		return ret
	end)[2] = true
	technologyLocalData:defineValue("nebulareward", function()
		local nebulaShowData = require_once("app." .. LocalTblPath .. ".config_client.technology_nebula_show")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_client.technology_nebula_show", "app." .. LocalTblPath .. ".config_client.technology_nebula_show"
		for _, var in ipairs(nebulaShowData) do
			local _ENV, levelTechs
			for i = 1, 4 do
				levelTechs[i] = tonumber(var.technologyID[i * 2])
			end
			_ENV = (for index)
			;(1).bid = var.lv[1]
			local (1).lv, levelLimits = var.lv[2], 1
			local _ENV, preTechs = var.lv[2], var.lv[2]
			for i = 1, 4 do
				preTechs[i] = tonumber(var.technologyPrepose[i * 2])
			end
			var.technologyID = levelTechs
			var.lv = levelLimits
			var.technologyPrepose = preTechs
			local classType = var.type
			if not ret[classType] then
				_ENV = ret[classType]
			end
			ret[classType] = ret[classType]
			if not ret[classType][var.season] then
				_ENV = ret[classType][var.season]
			end
			ret[classType][var.season] = ret[classType][var.season]
			table.insert(ret[classType][var.season], var)
		end
		return ret
	end)
end
function technologyLocalData.getTypeNameByID(technologyID)
	local var = technologyLocalData.technologyData[tostring(technologyID) .. "01"]
	if var then
		local tType = var.technologyType
		return typeName[tType]
	end
end
function technologyLocalData.getPrefix(str)
	return string.sub(str, 1, -3)
end
function technologyLocalData.getNebulaShow()
	local nebulaWarUtil = include("nebulaWarUtil")
	local group = nebulaWarUtil.getRegionGroup()
	local curNebulaShow = technologyLocalData.nebulashow[group][1]
	return curNebulaShow
end
function technologyLocalData.getNebulaTechUnlockLv(tid)
	tid = tonumber(tid)
	local nebulashow = technologyLocalData.getNebulaShow()
	for i, v in ipairs(nebulashow) do
		for k, v2 in pairs(v.technologyID) do
			if v2 == tid then
				return v.lv.lv
			end
		end
	end
	return 0
end
function technologyLocalData.getNebulaTechShowPreTech(tid)
	tid = tonumber(tid)
	local nebulashow = technologyLocalData.getNebulaShow()
	for i, v in ipairs(nebulashow) do
		for k, v2 in pairs(v.technologyID) do
			if v2 == tid then
				return v.technologyPrepose[k]
			end
		end
	end
end
function technologyLocalData.getNebulaTechReward(tType, lv)
	for k, v in pairs(technologyLocalData.nebulareward) do
		if v.type == tType and v.lv == lv then
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			return serviceFunctions.tableFormat(v.reward, nil)
		end
	end
	_ENV = (for generator)
	return pairs(technologyLocalData.nebulareward)
end
init()
return technologyLocalData
