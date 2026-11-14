local _ENV, instanceLodCfgShow
local worldLodDef = worldMapDefine.worldLodDef
local LOD2 = worldLodDef.LOD2
local LOD3 = worldLodDef.LOD3
local LOD4 = worldLodDef.LOD4
local LOD5 = worldLodDef.LOD5
local LOD6 = worldLodDef.LOD6
function instanceLodCfgShow.lessLOD2(lod)
	return lod <= LOD2
end
function instanceLodCfgShow.lessLOD3(lod)
	return lod <= LOD3
end
function instanceLodCfgShow.lessLOD4(lod)
	return lod <= LOD4
end
function instanceLodCfgShow.lessLOD5(lod)
	return lod <= LOD5
end
function instanceLodCfgShow.lessLOD6(lod)
	return lod <= LOD6
end
function instanceLodCfgShow.alwaysShow(lod)
	return true
end
local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local checkIsSelf = function(playerID)
	playerID = playerID or 0
	local selfPlayerID = gametop.playertop_:getPlayerID()
	return selfPlayerID == playerID
end
local checkIsSelfLegend = function(leagueID)
	leagueID = leagueID or 0
	local selfLeagueID = allianceMgr:getOwnTeamID()
	return selfLeagueID == leagueID
end
function instanceLodCfgShow.lessLOD3OrSelf(lod, data)
	if lod <= LOD3 then
		return true
	end
	local playerID = data.playerID or 0
	return checkIsSelf(playerID)
end
function instanceLodCfgShow.lessLOD2OrSelf(lod, data)
	if lod <= LOD2 then
		return true
	end
	local playerID = data.playerID or 0
	return checkIsSelf(playerID)
end
function instanceLodCfgShow.allianceBuild(lod, data, worldInstanceData)
	local classID = worldInstanceData.class
	if classID == gMapAllianceBuildType.subTypeAlliancePalace or classID == gMapAllianceBuildType.subTypeAlliancePriPalace then
		return lod <= LOD4
	elseif classID == gMapAllianceBuildType.subTypeAllianceFlag then
		if lod <= LOD2 then
			return true
		end
		return checkIsSelfLegend(data.leagueID)
	elseif classID == gMapAllianceBuildType.subTypeAllianceAltar then
		if lod <= LOD2 then
			return true
		end
		if lod <= LOD3 then
			return checkIsSelfLegend(data.leagueID)
		end
	end
end
function instanceLodCfgShow.lessLOD3OrSelfLegend(lod, data)
	if lod <= LOD3 then
		return true
	end
	if worldMapDefine.isInAtlantis() then
		return true
	end
	if checkIsSelfLegend(data.leagueID) then
		return true
	end
	local playerID = data.playerID or 0
	return checkIsSelf(playerID)
end
function instanceLodCfgShow.bossShow(lod)
	return lod <= LOD4
end
function instanceLodCfgShow.npcShow(lod)
	return lod <= LOD2
end
function instanceLodCfgShow.monsterShow(lod, objData, instanceData)
	if instanceData and instanceData.objId and worldMapDefine.checkIsWastelandMonster(instanceData.objId) then
		return false
	end
	return instanceLodCfgShow.npcShow(lod, objData, instanceData)
end
_ENV, instanceLodCfgShow.roaringFlameWarShow = function(lod, objData, instanceData)
	if lod <= LOD3 then
		return true
	end
	local subType = instanceData.subMapType
	local roaringFlameWarUtil = include("roaringFlameWarUtil")
	if roaringFlameWarUtil.checkIsMineBuild(subType) then
		return false
	end
	return true
end, function(lod, objData, instanceData)
	if lod <= LOD3 then
		return true
	end
	local subType = instanceData.subMapType
	local roaringFlameWarUtil = include("roaringFlameWarUtil")
	if roaringFlameWarUtil.checkIsMineBuild(subType) then
		return false
	end
	return true
end
;(function(lod, objData, instanceData)
	if lod <= LOD3 then
		return true
	end
	local subType = instanceData.subMapType
	local roaringFlameWarUtil = include("roaringFlameWarUtil")
	if roaringFlameWarUtil.checkIsMineBuild(subType) then
		return false
	end
	return true
end).LOD_LAYER_NORMAL = 1
;(function(lod, objData, instanceData)
	if lod <= LOD3 then
		return true
	end
	local subType = instanceData.subMapType
	local roaringFlameWarUtil = include("roaringFlameWarUtil")
	if roaringFlameWarUtil.checkIsMineBuild(subType) then
		return false
	end
	return true
end).LOD_LAYER_NPC = 2
;(function(lod, objData, instanceData)
	if lod <= LOD3 then
		return true
	end
	local subType = instanceData.subMapType
	local roaringFlameWarUtil = include("roaringFlameWarUtil")
	if roaringFlameWarUtil.checkIsMineBuild(subType) then
		return false
	end
	return true
end).LOD_LAYER_ALLIANCE = 3
;(function(lod, objData, instanceData)
	if lod <= LOD3 then
		return true
	end
	local subType = instanceData.subMapType
	local roaringFlameWarUtil = include("roaringFlameWarUtil")
	if roaringFlameWarUtil.checkIsMineBuild(subType) then
		return false
	end
	return true
end).LOD_LAYER_SELF = 4
;(function(lod, objData, instanceData)
	if lod <= LOD3 then
		return true
	end
	local subType = instanceData.subMapType
	local roaringFlameWarUtil = include("roaringFlameWarUtil")
	if roaringFlameWarUtil.checkIsMineBuild(subType) then
		return false
	end
	return true
end).LOD_LAYER_CASTLE = 5
;(function(lod, objData, instanceData)
	if lod <= LOD3 then
		return true
	end
	local subType = instanceData.subMapType
	local roaringFlameWarUtil = include("roaringFlameWarUtil")
	if roaringFlameWarUtil.checkIsMineBuild(subType) then
		return false
	end
	return true
end).LOD_LAYER_ALLIANCERES = 6
;(function(lod, objData, instanceData)
	if lod <= LOD3 then
		return true
	end
	local subType = instanceData.subMapType
	local roaringFlameWarUtil = include("roaringFlameWarUtil")
	if roaringFlameWarUtil.checkIsMineBuild(subType) then
		return false
	end
	return true
end).LOD_LAYER_ALLIANCESTRONG = 7
;(function(lod, objData, instanceData)
	if lod <= LOD3 then
		return true
	end
	local subType = instanceData.subMapType
	local roaringFlameWarUtil = include("roaringFlameWarUtil")
	if roaringFlameWarUtil.checkIsMineBuild(subType) then
		return false
	end
	return true
end).LOD_LAYER_MONSTER = 8
;(function(lod, objData, instanceData)
	if lod <= LOD3 then
		return true
	end
	local subType = instanceData.subMapType
	local roaringFlameWarUtil = include("roaringFlameWarUtil")
	if roaringFlameWarUtil.checkIsMineBuild(subType) then
		return false
	end
	return true
end).LOD_LAYER_BOSS = 9
;(function(lod, objData, instanceData)
	if lod <= LOD3 then
		return true
	end
	local subType = instanceData.subMapType
	local roaringFlameWarUtil = include("roaringFlameWarUtil")
	if roaringFlameWarUtil.checkIsMineBuild(subType) then
		return false
	end
	return true
end).LOD_LAYER_NEBULA = 10
local (function(lod, objData, instanceData)
	if lod <= LOD3 then
		return true
	end
	local subType = instanceData.subMapType
	local roaringFlameWarUtil = include("roaringFlameWarUtil")
	if roaringFlameWarUtil.checkIsMineBuild(subType) then
		return false
	end
	return true
end).LOD_LAYER_NEBULA_4, LOD_LAYER = 11, function(lod, objData, instanceData)
	if lod <= LOD3 then
		return true
	end
	local subType = instanceData.subMapType
	local roaringFlameWarUtil = include("roaringFlameWarUtil")
	if roaringFlameWarUtil.checkIsMineBuild(subType) then
		return false
	end
	return true
end
instanceLodCfgShow.LOD_LAYER = LOD_LAYER
local LOD_LAYER_NORMAL = LOD_LAYER.LOD_LAYER_NORMAL
local LOD_LAYER_SELF = LOD_LAYER.LOD_LAYER_SELF
local LOD_LAYER_ALLIANCE = LOD_LAYER.LOD_LAYER_ALLIANCE
function instanceLodCfgShow.selfLayerLod3(lod, data)
	if not data or not data.user then
		local checkIsSelf, user = data.user, data.user
	end
	local playerID = user.playerID or 0
	if checkIsSelf(playerID) then
		return LOD_LAYER_SELF
	end
	return LOD_LAYER_NORMAL
end
function instanceLodCfgShow.selfLayerLod4(lod, data)
	if not data or not data.user then
		local checkIsSelf, user = data.user, data.user
	end
	local playerID = user.playerID or 0
	if checkIsSelf(playerID) then
		return LOD_LAYER_SELF
	end
	return LOD_LAYER_ALLIANCE
end
return instanceLodCfgShow
