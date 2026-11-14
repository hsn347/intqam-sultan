local pyramidBuildingRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	pyramidBuildingRead = nil
	;(nil)[1] = "pyramidmapbuilding"
	pyramidBuildingRead:defineValue("pyramidBuildIDInfo", nil)
	_ENV = nil
	;(nil)[1] = "alliancewarbuilding"
	;(nil)[2] = true
	pyramidBuildingRead:defineValue("allianceWarBuilding", nil)
	pyramidBuildingRead:defineValue("tablePyramidBuildingInfo", function()
		local _ENV, builingInfo
		for k, v in pairs(pyramidBuildingRead.pyramidBuildIDInfo) do
			local ctype = pyramidBuildingRead.getType(k)
			if not builingInfo[ctype] then
				builingInfo[ctype] = v
			end
		end
		pyramidBuildingRead.tablePyramidBuildingInfo = builingInfo
		return pyramidBuildingRead.tablePyramidBuildingInfo
	end)
end
function pyramidBuildingRead.getType(buildID)
	buildID = tonumber(buildID)
	return pyramidBuildingRead.allianceWarBuilding[buildID].type
end
function pyramidBuildingRead.getName(buildTypeID, buildID)
	if buildID and pyramidBuildingRead.pyramidBuildIDInfo[tonumber(buildID)] then
		return i18n(pyramidBuildingRead.pyramidBuildIDInfo[tonumber(buildID)].name)
	else
		buildTypeID = tonumber(buildTypeID)
		return pyramidBuildingRead.tablePyramidBuildingInfo[buildTypeID] and i18n(pyramidBuildingRead.tablePyramidBuildingInfo[buildTypeID].name) or "undefine"
	end
end
function pyramidBuildingRead.getDes(buildTypeID)
	buildTypeID = tonumber(buildTypeID)
	return i18n(pyramidBuildingRead.tablePyramidBuildingInfo[buildTypeID].describe)
end
function pyramidBuildingRead.getIcon(buildTypeID)
	buildTypeID = tonumber(buildTypeID)
	return pyramidBuildingRead.tablePyramidBuildingInfo[buildTypeID].icon
end
function pyramidBuildingRead.getIconLod(buildTypeID)
	buildTypeID = tonumber(buildTypeID)
	if not pyramidBuildingRead.tablePyramidBuildingInfo[buildTypeID] then
		local _ENV, cfg = pyramidBuildingRead.tablePyramidBuildingInfo[buildTypeID], pyramidBuildingRead.tablePyramidBuildingInfo[buildTypeID]
	end
	return cfg.iconLod
end
function pyramidBuildingRead.getImage(buildTypeID)
	buildTypeID = tonumber(buildTypeID)
	return pyramidBuildingRead.tablePyramidBuildingInfo[buildTypeID].image
end
function pyramidBuildingRead.getWarCampName(campType)
	if campType == gAllianceWarCampType.red then
		return i18n("common_text_3220")
	end
	return i18n("common_text_3221")
end
function pyramidBuildingRead.getBuildConfigS(buildID)
	if not pyramidBuildingRead.allianceWarBuilding[buildID] then
		pyramidBuildingRead = pyramidBuildingRead.allianceWarBuilding[buildID]
	end
	return pyramidBuildingRead.allianceWarBuilding[buildID]
end
function pyramidBuildingRead.getBuildSize(buildID)
	local cfg = pyramidBuildingRead.getBuildConfigS(buildID)
	return cfg.size or 0
end
function pyramidBuildingRead.getActionParam(buildID)
	local cfg = pyramidBuildingRead.getBuildConfigS(buildID)
	return cfg.actionParam or 0
end
function pyramidBuildingRead.getOccupyTime(buildID)
	local cfg = pyramidBuildingRead.getBuildConfigS(buildID)
	return cfg.occupyTime or 0
end
function pyramidBuildingRead.getContinueCaptainPoints(buildID)
	local cfg = pyramidBuildingRead.getBuildConfigS(buildID)
	return cfg.continueCaptainPoints or 0
end
function pyramidBuildingRead.getBuildPos(buildID)
	local cfg = pyramidBuildingRead.getBuildConfigS(buildID)
	return cc.p(cfg.x, cfg.y) or cc.p(0, 0)
end
pyramidBuildingRead:defineValue("buildIDList", function()
	local _ENV, ret
	for _, v in pairs(pyramidBuildingRead.allianceWarBuilding) do
		if not ret[v.type] then
			_ENV = ret[v.type]
		end
		ret[v.type] = ret[v.type]
		table.insert(ret[v.type], v.id)
	end
	return ret
end)
function pyramidBuildingRead.getBuildIDListByType(buildType)
	if not pyramidBuildingRead.buildIDList[buildType] then
		pyramidBuildingRead = pyramidBuildingRead.buildIDList[buildType]
	end
	return pyramidBuildingRead.buildIDList[buildType]
end
init()
return pyramidBuildingRead
