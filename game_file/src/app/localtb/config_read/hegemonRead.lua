local hegemonRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	hegemonRead = nil
	;(nil)[1] = "hegemon_buff_des"
	hegemonRead:defineValue("buffDesTable", nil)
	_ENV = nil
	;(nil)[1] = "hegemon_buff"
	;(nil)[2] = true
	hegemonRead:defineValue("officialTable", nil)
	hegemonRead = nil
	;(nil)[1] = "hegemon_shop_point_config"
	hegemonRead:defineValue("pointCfg", nil)
	hegemonRead:defineValue("tbActivityCfg", function()
		_UPVALUE0_, _UPVALUE0_ = nil, nil
		;(nil).icon = "icon_science_leader.png"
		_UPVALUE0_, (nil)[9001085], (nil).name = nil, nil, "hegemon_buildname_01"
		;(nil).icon = "icon_science_leader.png"
		_UPVALUE0_, (nil)[9001086], (nil).name = nil, nil, "hegemon_buildname_02"
		;(nil).icon = "icon_science_leader.png"
		_UPVALUE0_, (nil)[9001087], (nil).name = nil, nil, "hegemon_buildname_03"
		;(nil).icon = "icon_science_leader.png"
		_UPVALUE0_, (nil)[9001088], (nil).name = nil, nil, "hegemon_buildname_04"
		;(nil).icon = "icon_science_leader.png"
		_UPVALUE0_, (nil)[9001089], (nil).name = nil, nil, "hegemon_buildname_05"
		;(nil).icon = "icon_science_leader.png"
		;(nil)[9001090], (nil).name = nil, "hegemon_buildname_06"
		return nil
	end)
	hegemonRead:defineValue("tbActivityToBuild", function()
		_UPVALUE0_ = nil
		;(nil)[9001074] = 501
		;(nil)[9001085] = 601
		;(nil)[9001086] = 602
		;(nil)[9001087] = 603
		;(nil)[9001088] = 604
		;(nil)[9001089] = 605
		;(nil)[9001090] = 606
		return nil
	end)
	hegemonRead:defineValue("tbBuildToActivity", function()
		_UPVALUE0_ = nil
		;(nil)[501] = 9001074
		;(nil)[601] = 9001085
		;(nil)[602] = 9001086
		;(nil)[603] = 9001087
		;(nil)[604] = 9001088
		;(nil)[605] = 9001089
		;(nil)[606] = 9001090
		return nil
	end)
	local createData = function(name)
		hegemonRead.mapOfficialTable, hegemonRead, hegemonRead.personalOfficial, hegemonRead = nil, nil, nil, nil
		for i, v in ipairs(hegemonRead.officialTable) do
			if v.Digitype ~= 1 then
				table.insert(hegemonRead.personalOfficial, v)
			end
			hegemonRead.mapOfficialTable[v.Digitype] = v
		end
		if name == "personalOfficial" then
			return hegemonRead.personalOfficial
		elseif name == "mapOfficialTable" then
			return hegemonRead.mapOfficialTable
		end
	end
	hegemonRead:defineValue("personalOfficial", createData)
	hegemonRead:defineValue("mapOfficialTable", createData)
	hegemonRead:defineValue("giftPackage", function()
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.hegemom_kingpackage")
		for i, v in ipairs(cfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.items = serviceFunctions.tableFormat(v.items, nil)
		end
		return cfg
	end)
	hegemonRead:defineValue("warRewards", function()
		local _ENV, ret
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.hegemon_rewards")
		for _, v in pairs(cfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local reward = serviceFunctions.tableFormat(v.Items, nil)
			if not ret[tostring(v.Rankstyle)] then
				ret[tostring(v.Rankstyle)], _ENV = v.Rankstyle, v.Rankstyle
			end
			if not ret[tostring(v.Rankstyle)][tostring(v.Type)] then
				ret[tostring(v.Rankstyle)][tostring(v.Type)], _ENV = v.Type, v.Type
			end
			ret[tostring(v.Rankstyle)][tostring(v.Type)] = reward
		end
		hegemonRead.warRewards = ret
		return ret
	end)
	function hegemonRead()
		local _ENV, ret
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.hegemon_rewards")
		for _, v in pairs(cfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local reward = serviceFunctions.tableFormat(v.Items, nil)
			if not ret[tostring(v.Rankstyle)] then
				ret[tostring(v.Rankstyle)], _ENV = v.Rankstyle, v.Rankstyle
			end
			if not ret[tostring(v.Rankstyle)][tostring(v.Type)] then
				ret[tostring(v.Rankstyle)][tostring(v.Type)], _ENV = v.Type, v.Type
			end
			ret[tostring(v.Rankstyle)][tostring(v.Type)] = reward
		end
		hegemonRead.warRewards = ret
		return ret
	end
	;(function()
		local _ENV, ret
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.hegemon_rewards")
		for _, v in pairs(cfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local reward = serviceFunctions.tableFormat(v.Items, nil)
			if not ret[tostring(v.Rankstyle)] then
				ret[tostring(v.Rankstyle)], _ENV = v.Rankstyle, v.Rankstyle
			end
			if not ret[tostring(v.Rankstyle)][tostring(v.Type)] then
				ret[tostring(v.Rankstyle)][tostring(v.Type)], _ENV = v.Type, v.Type
			end
			ret[tostring(v.Rankstyle)][tostring(v.Type)] = reward
		end
		hegemonRead.warRewards = ret
		return ret
	end)[1] = "hegemon_building_config"
	hegemonRead:defineValue("tableHegemonBuildingInfo", function()
		local _ENV, ret
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.hegemon_rewards")
		for _, v in pairs(cfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local reward = serviceFunctions.tableFormat(v.Items, nil)
			if not ret[tostring(v.Rankstyle)] then
				ret[tostring(v.Rankstyle)], _ENV = v.Rankstyle, v.Rankstyle
			end
			if not ret[tostring(v.Rankstyle)][tostring(v.Type)] then
				ret[tostring(v.Rankstyle)][tostring(v.Type)], _ENV = v.Type, v.Type
			end
			ret[tostring(v.Rankstyle)][tostring(v.Type)] = reward
		end
		hegemonRead.warRewards = ret
		return ret
	end)
end
init()
function hegemonRead.getActivityIcon(activityID)
	local cfg = hegemonRead.tbActivityCfg[activityID]
	if cfg then
		return cfg.icon
	end
	return "icon_science_leader.png"
end
function hegemonRead.getActivityName(activityID)
	local cfg = hegemonRead.tbActivityCfg[activityID]
	if cfg then
		return cfg.name
	end
	return "NA"
end
function hegemonRead.getBuffsById(id)
	local info = hegemonRead.mapOfficialTable[id]
	if info then
		return info.Buff
	end
end
function hegemonRead.getAllBuffList()
	local _ENV, officialList
	for _, v in pairs(hegemonRead.officialTable) do
		officialList[v.Digitype] = v.Buff
	end
	return officialList
end
function hegemonRead.getOfficialInfo(id)
	local info = hegemonRead.mapOfficialTable[id]
	if info then
		return info
	end
end
function hegemonRead.getAllPersonalOfficial()
	return hegemonRead.personalOfficial
end
function hegemonRead.getOfficialName(id)
	local info = hegemonRead.mapOfficialTable[id]
	if info then
		return i18n(info.Name)
	end
end
function hegemonRead.getOfficialType(id)
	local info = hegemonRead.mapOfficialTable[id]
	if info then
		return info.btype
	end
end
function hegemonRead.getOfficialIcon(id)
	local info = hegemonRead.mapOfficialTable[id]
	if info then
		return info.Image
	end
end
function hegemonRead.getBufferName(bufferId)
	local buffItem = hegemonRead.buffDesTable[bufferId]
	if buffItem then
		return i18n(buffItem.buffDes), buffItem.type
	end
end
function hegemonRead.getBufferInfo(bufferId)
	local buffItem = hegemonRead.buffDesTable[bufferId]
	return buffItem
end
function hegemonRead.getBuffDesTbById(id)
	local buffs = hegemonRead.getBuffsById(id)
	local hegemonRead, desTb = id, id
	for _, v in ipairs(buffs) do
		local bufDes = hegemonRead.getBufferName(v)
		table.insert(desTb, bufDes)
	end
	return desTb
end
function hegemonRead.getPackageList(bid)
	return hegemonRead.giftPackage
end
function hegemonRead.getPackageName(id)
	for i, v in ipairs(hegemonRead.giftPackage) do
		if v.rewardsType == id then
			return i18n(v.name)
		end
	end
end
function hegemonRead.getPackage(id)
	for i, v in ipairs(hegemonRead.giftPackage) do
		if v.rewardsType == id then
			return v
		end
	end
end
function hegemonRead.getPackageReward(id)
	for i, v in ipairs(hegemonRead.giftPackage) do
		if v.rewardsType == id then
			return v.items
		end
	end
end
function hegemonRead.getPackageRewardRank(id)
	for i, v in ipairs(hegemonRead.giftPackage) do
		if v.rewardsType == id then
			return v.rank
		end
	end
end
function hegemonRead.updateLegendReward(rewardInfo)
	if rewardInfo then
		hegemonRead.warRewards = rewardInfo
	end
end
function hegemonRead.getFirstKillReward(occupySecs)
	local condition = occupySecs or LLW_OCCUPY_FIRST_KILL_TIME
	return hegemonRead.warRewards["1"][tostring(condition)]
end
function hegemonRead.getWarRankReward(rank)
	return hegemonRead.warRewards["2"][tostring(rank)]
end
function hegemonRead.getWarRankMax(...)
	local cfg = hegemonRead.warRewards["2"]
	local hegemonRead, keys
	for k, __ in pairs(cfg) do
		table.insert(keys, tonumber(k))
	end
	table.sort(keys)
	return keys[#keys] or 0
end
function hegemonRead.getWarParticipationReward()
	return hegemonRead.warRewards["3"]["1"]
end
function hegemonRead.isLegendLordBuilding(buildTypeID)
	return buildTypeID == gLegendBuildID
end
function hegemonRead.getName(buildTypeID)
	buildTypeID = tonumber(buildTypeID)
	if hegemonRead.isLegendLordBuilding(buildTypeID) then
		return worldMapDefine.currentMapKindomID == worldMapDefine.LEGENDLORD_KINGDOM_ID and i18n("common_text_4207") or i18n("kingstarbattle_text_64")
	end
	return i18n(hegemonRead.tableHegemonBuildingInfo[buildTypeID].name)
end
function hegemonRead.getNameBySubMaptype(subMapType)
	local legendLordWarltCtrl = include("legendLordWarltCtrl")
	local bid = legendLordWarltCtrl.getBidByType(subMapType)
	if bid then
		return hegemonRead.getName(bid)
	else
		return worldMapDefine.currentMapKindomID == worldMapDefine.LEGENDLORD_KINGDOM_ID and i18n("common_text_4242") or i18n("kingstarbattle_text_64")
	end
end
function hegemonRead.getIcon(buildTypeID)
	buildTypeID = tonumber(buildTypeID)
	if hegemonRead.isLegendLordBuilding(buildTypeID) then
		return "icon_world_legendaryking.png"
	end
	return hegemonRead.tableHegemonBuildingInfo[buildTypeID].icon
end
function hegemonRead.getImage(buildTypeID)
	buildTypeID = tonumber(buildTypeID)
	if hegemonRead.isLegendLordBuilding(buildTypeID) then
		local legendKingRead = include("legendKingRead")
		return legendKingRead.getImage(buildTypeID, worldMapDefine.currentMapKindomID) or "LegendaryKing_palace.png"
	end
	return hegemonRead.tableHegemonBuildingInfo[buildTypeID].image
end
function hegemonRead.getActivityIdByBuildID(buildTypeID)
	buildTypeID = tonumber(buildTypeID)
	return hegemonRead.tbBuildToActivity[buildTypeID]
end
function hegemonRead.getBuildIdByActivityID(activityID)
	activityID = tonumber(activityID)
	return hegemonRead.tbActivityToBuild[activityID]
end
function hegemonRead.getBuildCoordinate(bid)
	local legendLordWarltCtrl = include("legendLordWarltCtrl")
	local buildInfo = legendLordWarltCtrl.getLegendLordWarBuildingById(bid)
	_ENV = bid
	bid.x = buildInfo.x
	bid.y = buildInfo.y
	return bid
end
function hegemonRead.getBuildCoordinateByType(subMapType)
	local legendLordWarltCtrl = include("legendLordWarltCtrl")
	local bid = legendLordWarltCtrl.getBidByType(subMapType)
	if bid then
		return hegemonRead.getBuildCoordinate(bid)
	else
		_ENV = hegemonRead.getBuildCoordinate
		hegemonRead.getBuildCoordinate.x = 150
		hegemonRead.getBuildCoordinate.y = 150
		return hegemonRead.getBuildCoordinate
	end
end
function hegemonRead.judgeIsGood(officialId)
	local info = hegemonRead.mapOfficialTable[officialId]
	if info then
		return info.btype == 1
	end
	return false
end
function hegemonRead.getPointCfg()
	return hegemonRead.pointCfg
end
return hegemonRead
