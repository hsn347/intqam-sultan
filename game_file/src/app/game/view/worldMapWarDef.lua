local _ENV, worldMapWarDef
local gametop = gModuleMgr.getObject("gametop")
local gKingdomClassType = _G.gKingdomClassType
local gPlayerBattleGround = _G.gPlayerBattleGround
local GAME_KINGDOM_ID_ASSIGN = _G.GAME_KINGDOM_ID_ASSIGN
_ENV = nil
_ENV, _ENV = nil, nil
;(nil).maxX = 1201
;(nil)[gKingdomClassType.normal], (nil).rang, (nil).maxY = nil, nil, 1201
_ENV, _ENV = nil, nil
;(nil).maxX = 150
;(nil)[gKingdomClassType.pyramid], (nil).rang, (nil).maxY = nil, nil, 150
_ENV, _ENV = nil, nil
;(nil).maxX = 300
;(nil)[gKingdomClassType.legendLord], (nil).rang, (nil).maxY = nil, nil, 300
_ENV, _ENV = nil, nil
;(nil).maxX = 70
;(nil)[gKingdomClassType.remains], (nil).rang, (nil).maxY = nil, nil, 70
_ENV, _ENV = nil, nil
;(nil).maxX = 20
;(nil)[gKingdomClassType.newTrial], (nil).rang, (nil).maxY = nil, nil, 20
_ENV, _ENV = nil, nil
;(nil).maxX = 1201
;(nil)[gKingdomClassType.radiance], (nil).rang, (nil).maxY = nil, nil, 1201
_ENV, _ENV = nil, nil
;(nil).maxX = 400
;(nil)[gKingdomClassType.atlantis], (nil).rang, (nil).maxY = nil, nil, 400
_ENV, _ENV = nil, nil
;(nil).maxX = 300
;(nil)[gKingdomClassType.nebula], (nil).rang, (nil).maxY = nil, nil, 300
_ENV, _ENV = nil, nil
;(nil).maxX = 300
;(nil)[gKingdomClassType.nebulaEmperor], (nil).rang, (nil).maxY = nil, nil, 300
_ENV, _ENV = nil, nil
;(nil).maxX = 300
;(nil)[gKingdomClassType.nebulaAllStar], (nil).rang, (nil).maxY = nil, nil, 300
_ENV, _ENV = nil, nil
;(nil).maxX = 500
;(nil)[gKingdomClassType.roaringFlame], (nil).rang, (nil).maxY = nil, nil, 500
_ENV, _ENV = nil, nil
;(nil).maxX = 40
;(nil)[gKingdomClassType.simulatedDrill], (nil).rang, (nil).maxY = nil, nil, 40
_ENV, _ENV = nil, nil
;(nil).maxX = 600
worldMapWarDef.MAPCONF, (nil)[gKingdomClassType.garden], (nil).rang, (nil).maxY = nil, nil, nil, 600
function worldMapWarDef.getMaxCoordinateByKid(kID)
	local mapClassType = worldMapWarDef.getKingdomMapClassByKingdomId(kID)
	return worldMapWarDef.getMaxCoordinateByType(mapClassType)
end
function worldMapWarDef.getMaxCoordinateByType(mapClassType)
	local maxCoordinate = 1200
	local maxX = worldMapWarDef.getMapRangMaxX(mapClassType)
	if maxX then
		maxCoordinate = maxX - 1
	end
	return maxCoordinate
end
function worldMapWarDef.getMapRangMaxX(mapClassType)
	local maxX = 1201
	local config = worldMapWarDef.MAPCONF[mapClassType]
	if config then
		maxX = config.rang.maxX
	end
	return maxX
end
function worldMapWarDef.getMapRangMaxY(mapClassType)
	local maxX = 1201
	local config = worldMapWarDef.MAPCONF[mapClassType]
	if config then
		maxX = config.rang.maxY
	end
	return maxX
end
function worldMapWarDef.getMapCenterPoint(kID)
	local max = worldMapDefine.getMaxCoordinateByKid(kID)
	return cc.p(math.ceil(max * 0.5), math.ceil(max * 0.5))
end
_ENV, worldMapWarDef.getKingdomMapClassByKingdomId = function(kID)
	kID = kID or worldMapDefine.currentMapKindomID or 0
	if kID <= GAME_KINGDOM_ID_ASSIGN.GAME.END then
		return gKingdomClassType.normal
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.LEGEND.END then
		return gKingdomClassType.legendLord
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.RUINS.END then
		return gKingdomClassType.remains
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.DEVIL_VALLEY.END then
		return gKingdomClassType.newTrial
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.PYRAMID.END then
		return gKingdomClassType.pyramid
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.RADIANCE.END then
		return gKingdomClassType.radiance
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.ATLANTIS.END then
		return gKingdomClassType.atlantis
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA.END then
		return gKingdomClassType.nebula
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA_EMPEROR.END then
		return gKingdomClassType.nebulaEmperor
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA_ALLSTAR.END then
		return gKingdomClassType.nebulaAllStar
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.END then
		return gKingdomClassType.roaringFlame
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.SIMULATED_DRILL.END then
		return gKingdomClassType.simulatedDrill
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.GARDEN.END then
		return gKingdomClassType.garden
	else
		return gKingdomClassType.normal
	end
end, function(kID)
	kID = kID or worldMapDefine.currentMapKindomID or 0
	if kID <= GAME_KINGDOM_ID_ASSIGN.GAME.END then
		return gKingdomClassType.normal
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.LEGEND.END then
		return gKingdomClassType.legendLord
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.RUINS.END then
		return gKingdomClassType.remains
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.DEVIL_VALLEY.END then
		return gKingdomClassType.newTrial
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.PYRAMID.END then
		return gKingdomClassType.pyramid
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.RADIANCE.END then
		return gKingdomClassType.radiance
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.ATLANTIS.END then
		return gKingdomClassType.atlantis
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA.END then
		return gKingdomClassType.nebula
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA_EMPEROR.END then
		return gKingdomClassType.nebulaEmperor
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA_ALLSTAR.END then
		return gKingdomClassType.nebulaAllStar
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.END then
		return gKingdomClassType.roaringFlame
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.SIMULATED_DRILL.END then
		return gKingdomClassType.simulatedDrill
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.GARDEN.END then
		return gKingdomClassType.garden
	else
		return gKingdomClassType.normal
	end
end
;(function(kID)
	kID = kID or worldMapDefine.currentMapKindomID or 0
	if kID <= GAME_KINGDOM_ID_ASSIGN.GAME.END then
		return gKingdomClassType.normal
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.LEGEND.END then
		return gKingdomClassType.legendLord
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.RUINS.END then
		return gKingdomClassType.remains
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.DEVIL_VALLEY.END then
		return gKingdomClassType.newTrial
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.PYRAMID.END then
		return gKingdomClassType.pyramid
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.RADIANCE.END then
		return gKingdomClassType.radiance
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.ATLANTIS.END then
		return gKingdomClassType.atlantis
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA.END then
		return gKingdomClassType.nebula
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA_EMPEROR.END then
		return gKingdomClassType.nebulaEmperor
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA_ALLSTAR.END then
		return gKingdomClassType.nebulaAllStar
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.END then
		return gKingdomClassType.roaringFlame
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.SIMULATED_DRILL.END then
		return gKingdomClassType.simulatedDrill
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.GARDEN.END then
		return gKingdomClassType.garden
	else
		return gKingdomClassType.normal
	end
end)[gKingdomClassType.remains] = gPlayerBattleGround.RUINS
;(function(kID)
	kID = kID or worldMapDefine.currentMapKindomID or 0
	if kID <= GAME_KINGDOM_ID_ASSIGN.GAME.END then
		return gKingdomClassType.normal
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.LEGEND.END then
		return gKingdomClassType.legendLord
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.RUINS.END then
		return gKingdomClassType.remains
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.DEVIL_VALLEY.END then
		return gKingdomClassType.newTrial
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.PYRAMID.END then
		return gKingdomClassType.pyramid
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.RADIANCE.END then
		return gKingdomClassType.radiance
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.ATLANTIS.END then
		return gKingdomClassType.atlantis
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA.END then
		return gKingdomClassType.nebula
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA_EMPEROR.END then
		return gKingdomClassType.nebulaEmperor
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA_ALLSTAR.END then
		return gKingdomClassType.nebulaAllStar
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.END then
		return gKingdomClassType.roaringFlame
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.SIMULATED_DRILL.END then
		return gKingdomClassType.simulatedDrill
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.GARDEN.END then
		return gKingdomClassType.garden
	else
		return gKingdomClassType.normal
	end
end)[gKingdomClassType.pyramid] = gPlayerBattleGround.PYRAMID
;(function(kID)
	kID = kID or worldMapDefine.currentMapKindomID or 0
	if kID <= GAME_KINGDOM_ID_ASSIGN.GAME.END then
		return gKingdomClassType.normal
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.LEGEND.END then
		return gKingdomClassType.legendLord
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.RUINS.END then
		return gKingdomClassType.remains
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.DEVIL_VALLEY.END then
		return gKingdomClassType.newTrial
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.PYRAMID.END then
		return gKingdomClassType.pyramid
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.RADIANCE.END then
		return gKingdomClassType.radiance
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.ATLANTIS.END then
		return gKingdomClassType.atlantis
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA.END then
		return gKingdomClassType.nebula
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA_EMPEROR.END then
		return gKingdomClassType.nebulaEmperor
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA_ALLSTAR.END then
		return gKingdomClassType.nebulaAllStar
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.END then
		return gKingdomClassType.roaringFlame
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.SIMULATED_DRILL.END then
		return gKingdomClassType.simulatedDrill
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.GARDEN.END then
		return gKingdomClassType.garden
	else
		return gKingdomClassType.normal
	end
end)[gKingdomClassType.newTrial] = gPlayerBattleGround.DEVIL_VALLEY
;(function(kID)
	kID = kID or worldMapDefine.currentMapKindomID or 0
	if kID <= GAME_KINGDOM_ID_ASSIGN.GAME.END then
		return gKingdomClassType.normal
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.LEGEND.END then
		return gKingdomClassType.legendLord
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.RUINS.END then
		return gKingdomClassType.remains
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.DEVIL_VALLEY.END then
		return gKingdomClassType.newTrial
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.PYRAMID.END then
		return gKingdomClassType.pyramid
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.RADIANCE.END then
		return gKingdomClassType.radiance
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.ATLANTIS.END then
		return gKingdomClassType.atlantis
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA.END then
		return gKingdomClassType.nebula
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA_EMPEROR.END then
		return gKingdomClassType.nebulaEmperor
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA_ALLSTAR.END then
		return gKingdomClassType.nebulaAllStar
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.END then
		return gKingdomClassType.roaringFlame
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.SIMULATED_DRILL.END then
		return gKingdomClassType.simulatedDrill
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.GARDEN.END then
		return gKingdomClassType.garden
	else
		return gKingdomClassType.normal
	end
end)[gKingdomClassType.radiance] = gPlayerBattleGround.RADIANCE
;(function(kID)
	kID = kID or worldMapDefine.currentMapKindomID or 0
	if kID <= GAME_KINGDOM_ID_ASSIGN.GAME.END then
		return gKingdomClassType.normal
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.LEGEND.END then
		return gKingdomClassType.legendLord
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.RUINS.END then
		return gKingdomClassType.remains
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.DEVIL_VALLEY.END then
		return gKingdomClassType.newTrial
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.PYRAMID.END then
		return gKingdomClassType.pyramid
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.RADIANCE.END then
		return gKingdomClassType.radiance
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.ATLANTIS.END then
		return gKingdomClassType.atlantis
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA.END then
		return gKingdomClassType.nebula
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA_EMPEROR.END then
		return gKingdomClassType.nebulaEmperor
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA_ALLSTAR.END then
		return gKingdomClassType.nebulaAllStar
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.END then
		return gKingdomClassType.roaringFlame
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.SIMULATED_DRILL.END then
		return gKingdomClassType.simulatedDrill
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.GARDEN.END then
		return gKingdomClassType.garden
	else
		return gKingdomClassType.normal
	end
end)[gKingdomClassType.atlantis] = gPlayerBattleGround.ATLANTIS
;(function(kID)
	kID = kID or worldMapDefine.currentMapKindomID or 0
	if kID <= GAME_KINGDOM_ID_ASSIGN.GAME.END then
		return gKingdomClassType.normal
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.LEGEND.END then
		return gKingdomClassType.legendLord
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.RUINS.END then
		return gKingdomClassType.remains
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.DEVIL_VALLEY.END then
		return gKingdomClassType.newTrial
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.PYRAMID.END then
		return gKingdomClassType.pyramid
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.RADIANCE.END then
		return gKingdomClassType.radiance
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.ATLANTIS.END then
		return gKingdomClassType.atlantis
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA.END then
		return gKingdomClassType.nebula
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA_EMPEROR.END then
		return gKingdomClassType.nebulaEmperor
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA_ALLSTAR.END then
		return gKingdomClassType.nebulaAllStar
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.END then
		return gKingdomClassType.roaringFlame
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.SIMULATED_DRILL.END then
		return gKingdomClassType.simulatedDrill
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.GARDEN.END then
		return gKingdomClassType.garden
	else
		return gKingdomClassType.normal
	end
end)[gKingdomClassType.nebula] = gPlayerBattleGround.NEBULA
;(function(kID)
	kID = kID or worldMapDefine.currentMapKindomID or 0
	if kID <= GAME_KINGDOM_ID_ASSIGN.GAME.END then
		return gKingdomClassType.normal
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.LEGEND.END then
		return gKingdomClassType.legendLord
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.RUINS.END then
		return gKingdomClassType.remains
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.DEVIL_VALLEY.END then
		return gKingdomClassType.newTrial
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.PYRAMID.END then
		return gKingdomClassType.pyramid
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.RADIANCE.END then
		return gKingdomClassType.radiance
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.ATLANTIS.END then
		return gKingdomClassType.atlantis
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA.END then
		return gKingdomClassType.nebula
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA_EMPEROR.END then
		return gKingdomClassType.nebulaEmperor
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA_ALLSTAR.END then
		return gKingdomClassType.nebulaAllStar
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.END then
		return gKingdomClassType.roaringFlame
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.SIMULATED_DRILL.END then
		return gKingdomClassType.simulatedDrill
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.GARDEN.END then
		return gKingdomClassType.garden
	else
		return gKingdomClassType.normal
	end
end)[gKingdomClassType.nebulaEmperor] = gPlayerBattleGround.NEBULA_EMPEROR
;(function(kID)
	kID = kID or worldMapDefine.currentMapKindomID or 0
	if kID <= GAME_KINGDOM_ID_ASSIGN.GAME.END then
		return gKingdomClassType.normal
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.LEGEND.END then
		return gKingdomClassType.legendLord
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.RUINS.END then
		return gKingdomClassType.remains
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.DEVIL_VALLEY.END then
		return gKingdomClassType.newTrial
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.PYRAMID.END then
		return gKingdomClassType.pyramid
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.RADIANCE.END then
		return gKingdomClassType.radiance
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.ATLANTIS.END then
		return gKingdomClassType.atlantis
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA.END then
		return gKingdomClassType.nebula
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA_EMPEROR.END then
		return gKingdomClassType.nebulaEmperor
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA_ALLSTAR.END then
		return gKingdomClassType.nebulaAllStar
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.END then
		return gKingdomClassType.roaringFlame
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.SIMULATED_DRILL.END then
		return gKingdomClassType.simulatedDrill
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.GARDEN.END then
		return gKingdomClassType.garden
	else
		return gKingdomClassType.normal
	end
end)[gKingdomClassType.nebulaAllStar] = gPlayerBattleGround.NEBULA_ALLSTAR
;(function(kID)
	kID = kID or worldMapDefine.currentMapKindomID or 0
	if kID <= GAME_KINGDOM_ID_ASSIGN.GAME.END then
		return gKingdomClassType.normal
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.LEGEND.END then
		return gKingdomClassType.legendLord
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.RUINS.END then
		return gKingdomClassType.remains
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.DEVIL_VALLEY.END then
		return gKingdomClassType.newTrial
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.PYRAMID.END then
		return gKingdomClassType.pyramid
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.RADIANCE.END then
		return gKingdomClassType.radiance
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.ATLANTIS.END then
		return gKingdomClassType.atlantis
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA.END then
		return gKingdomClassType.nebula
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA_EMPEROR.END then
		return gKingdomClassType.nebulaEmperor
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA_ALLSTAR.END then
		return gKingdomClassType.nebulaAllStar
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.END then
		return gKingdomClassType.roaringFlame
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.SIMULATED_DRILL.END then
		return gKingdomClassType.simulatedDrill
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.GARDEN.END then
		return gKingdomClassType.garden
	else
		return gKingdomClassType.normal
	end
end)[gKingdomClassType.roaringFlame] = gPlayerBattleGround.ROARING_FLAME
;(function(kID)
	kID = kID or worldMapDefine.currentMapKindomID or 0
	if kID <= GAME_KINGDOM_ID_ASSIGN.GAME.END then
		return gKingdomClassType.normal
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.LEGEND.END then
		return gKingdomClassType.legendLord
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.RUINS.END then
		return gKingdomClassType.remains
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.DEVIL_VALLEY.END then
		return gKingdomClassType.newTrial
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.PYRAMID.END then
		return gKingdomClassType.pyramid
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.RADIANCE.END then
		return gKingdomClassType.radiance
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.ATLANTIS.END then
		return gKingdomClassType.atlantis
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA.END then
		return gKingdomClassType.nebula
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA_EMPEROR.END then
		return gKingdomClassType.nebulaEmperor
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA_ALLSTAR.END then
		return gKingdomClassType.nebulaAllStar
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.END then
		return gKingdomClassType.roaringFlame
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.SIMULATED_DRILL.END then
		return gKingdomClassType.simulatedDrill
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.GARDEN.END then
		return gKingdomClassType.garden
	else
		return gKingdomClassType.normal
	end
end)[gKingdomClassType.simulatedDrill] = gPlayerBattleGround.SIMULATED_DRILL
local (function(kID)
	kID = kID or worldMapDefine.currentMapKindomID or 0
	if kID <= GAME_KINGDOM_ID_ASSIGN.GAME.END then
		return gKingdomClassType.normal
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.LEGEND.END then
		return gKingdomClassType.legendLord
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.RUINS.END then
		return gKingdomClassType.remains
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.DEVIL_VALLEY.END then
		return gKingdomClassType.newTrial
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.PYRAMID.END then
		return gKingdomClassType.pyramid
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.RADIANCE.END then
		return gKingdomClassType.radiance
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.ATLANTIS.END then
		return gKingdomClassType.atlantis
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA.END then
		return gKingdomClassType.nebula
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA_EMPEROR.END then
		return gKingdomClassType.nebulaEmperor
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA_ALLSTAR.END then
		return gKingdomClassType.nebulaAllStar
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.END then
		return gKingdomClassType.roaringFlame
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.SIMULATED_DRILL.END then
		return gKingdomClassType.simulatedDrill
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.GARDEN.END then
		return gKingdomClassType.garden
	else
		return gKingdomClassType.normal
	end
end)[gKingdomClassType.garden], warType_config = gPlayerBattleGround.GARDEN, function(kID)
	kID = kID or worldMapDefine.currentMapKindomID or 0
	if kID <= GAME_KINGDOM_ID_ASSIGN.GAME.END then
		return gKingdomClassType.normal
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.LEGEND.END then
		return gKingdomClassType.legendLord
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.RUINS.END then
		return gKingdomClassType.remains
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.DEVIL_VALLEY.END then
		return gKingdomClassType.newTrial
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.PYRAMID.END then
		return gKingdomClassType.pyramid
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.RADIANCE.END then
		return gKingdomClassType.radiance
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.ATLANTIS.END then
		return gKingdomClassType.atlantis
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA.END then
		return gKingdomClassType.nebula
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA_EMPEROR.END then
		return gKingdomClassType.nebulaEmperor
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.NEBULA_ALLSTAR.END then
		return gKingdomClassType.nebulaAllStar
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.ROARING_FLAME.END then
		return gKingdomClassType.roaringFlame
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.SIMULATED_DRILL.END then
		return gKingdomClassType.simulatedDrill
	elseif kID <= GAME_KINGDOM_ID_ASSIGN.GARDEN.END then
		return gKingdomClassType.garden
	else
		return gKingdomClassType.normal
	end
end
function worldMapWarDef.getPlayerBattleGround()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass() or gKingdomClassType.normal
	if warType_config[mapClassType] then
		return warType_config[mapClassType]
	elseif mapClassType == gKingdomClassType.legendLord then
		local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
		local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.LEGEND_LORD)
		local param2 = activityShowCtrl:getParamByID(gActivityTimeActivityID.KING_STAR_BATTLE)
		local curState = param and param.curState or ACTIVITY_STATE.NONE
		local curState2 = param2 and param2.curState or ACTIVITY_STATE.NONE
		if curState == ACTIVITY_STATE.ACTIVE or curState == ACTIVITY_STATE.SETTLE or curState2 == ACTIVITY_STATE.ACTIVE or curState2 == ACTIVITY_STATE.SETTLE then
			return gPlayerBattleGround.LEGEND_LORD_GROUND
		else
			return gPlayerBattleGround.LEGEND_HEGEMON_GROUND
		end
	else
		local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
		if lordInfoCtrl:getSourceKid() == 0 then
			return gPlayerBattleGround.CUR_KINGDOM
		else
			return gPlayerBattleGround.CONQUEST_WAR_ENEMY_KINGDOM
		end
	end
	return gPlayerBattleGround.CUR_KINGDOM
end
function worldMapWarDef.getIsInCurBattleGround(battleGround, curBattleGround)
	if battleGround == 0 then
		return true
	end
	curBattleGround = curBattleGround or worldMapWarDef.getPlayerBattleGround()
	if curBattleGround == battleGround then
		return true
	end
	if battleGround == gPlayerBattleGround.CONQUEST_WAR and (curBattleGround == gPlayerBattleGround.CUR_KINGDOM or curBattleGround == gPlayerBattleGround.CONQUEST_WAR_ENEMY_KINGDOM) then
		local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
		local isOpenning = conquestWarCtrl:isConquestWarOpenning()
		return isOpenning
	end
end
worldMapWarDef.getPlayerBattleGround = SoraDCacheByFrame(worldMapWarDef.getPlayerBattleGround)
function worldMapWarDef.getKingdomNameByKid(kID)
	local mapClassType = worldMapWarDef.getKingdomMapClassByKingdomId(kID)
	return worldMapWarDef.getKingdomNameByClassType(mapClassType, kID)
end
function worldMapWarDef.getKingdomNameByClassType(mapClassType, kID)
	if worldMapDefine.isKingStarMapId(kID) then
		return i18n("kingstarbattle_text_20")
	end
	_ENV = i18n
	i18n[gKingdomClassType.pyramid] = i18n("common_text_2517")
	i18n[gKingdomClassType.legendLord] = i18n("common_text_4244")
	i18n[gKingdomClassType.remains] = i18n("activityname_23")
	i18n[gKingdomClassType.radiance] = i18n("brightWar_text_21")
	i18n[gKingdomClassType.atlantis] = i18n("activity_name_9001366")
	i18n[gKingdomClassType.newTrial] = i18n("devilvalley_text_01")
	i18n[gKingdomClassType.nebula] = i18n("nebula_war_text_0135")
	i18n[gKingdomClassType.nebulaEmperor] = i18n("nebulaemperor_text_72")
	i18n[gKingdomClassType.nebulaAllStar] = i18n("NebulaAllstar_239")
	i18n[gKingdomClassType.roaringFlame] = i18n("flames_dunes_text1")
	i18n[gKingdomClassType.simulatedDrill] = i18n("simulated_drill_title_01")
	local i18n[gKingdomClassType.garden], warType_config = i18n("garden_text_01"), i18n
	return warType_config[mapClassType]
end
_ENV, worldMapWarDef.getKingdomName = function(isSelfKingdom)
	local worldMapDefine = include("worldMapDefine")
	local kID
	if not worldMapDefine.currentMapKindomID or isSelfKingdom then
		local gametop = gModuleMgr.getObject("gametop")
		kID = gametop.playertop_:getMapID()
	else
		kID = worldMapDefine.currentMapKindomID
	end
	local name = worldMapWarDef.getKingdomNameByKid(kID)
	if not name then
		local gametop = gModuleMgr.getObject("gametop")
		local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
		name = KWKingdomCtrl:getKingdomName(isSelfKingdom)
	end
	return name
end, function(isSelfKingdom)
	local worldMapDefine = include("worldMapDefine")
	local kID
	if not worldMapDefine.currentMapKindomID or isSelfKingdom then
		local gametop = gModuleMgr.getObject("gametop")
		kID = gametop.playertop_:getMapID()
	else
		kID = worldMapDefine.currentMapKindomID
	end
	local name = worldMapWarDef.getKingdomNameByKid(kID)
	if not name then
		local gametop = gModuleMgr.getObject("gametop")
		local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
		name = KWKingdomCtrl:getKingdomName(isSelfKingdom)
	end
	return name
end
;(function(isSelfKingdom)
	local worldMapDefine = include("worldMapDefine")
	local kID
	if not worldMapDefine.currentMapKindomID or isSelfKingdom then
		local gametop = gModuleMgr.getObject("gametop")
		kID = gametop.playertop_:getMapID()
	else
		kID = worldMapDefine.currentMapKindomID
	end
	local name = worldMapWarDef.getKingdomNameByKid(kID)
	if not name then
		local gametop = gModuleMgr.getObject("gametop")
		local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
		name = KWKingdomCtrl:getKingdomName(isSelfKingdom)
	end
	return name
end)[gKingdomClassType.pyramid] = "common_text_3140"
;(function(isSelfKingdom)
	local worldMapDefine = include("worldMapDefine")
	local kID
	if not worldMapDefine.currentMapKindomID or isSelfKingdom then
		local gametop = gModuleMgr.getObject("gametop")
		kID = gametop.playertop_:getMapID()
	else
		kID = worldMapDefine.currentMapKindomID
	end
	local name = worldMapWarDef.getKingdomNameByKid(kID)
	if not name then
		local gametop = gModuleMgr.getObject("gametop")
		local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
		name = KWKingdomCtrl:getKingdomName(isSelfKingdom)
	end
	return name
end)[gKingdomClassType.legendLord] = "common_text_4233"
;(function(isSelfKingdom)
	local worldMapDefine = include("worldMapDefine")
	local kID
	if not worldMapDefine.currentMapKindomID or isSelfKingdom then
		local gametop = gModuleMgr.getObject("gametop")
		kID = gametop.playertop_:getMapID()
	else
		kID = worldMapDefine.currentMapKindomID
	end
	local name = worldMapWarDef.getKingdomNameByKid(kID)
	if not name then
		local gametop = gModuleMgr.getObject("gametop")
		local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
		name = KWKingdomCtrl:getKingdomName(isSelfKingdom)
	end
	return name
end)[gKingdomClassType.remains] = "remains_text_67"
;(function(isSelfKingdom)
	local worldMapDefine = include("worldMapDefine")
	local kID
	if not worldMapDefine.currentMapKindomID or isSelfKingdom then
		local gametop = gModuleMgr.getObject("gametop")
		kID = gametop.playertop_:getMapID()
	else
		kID = worldMapDefine.currentMapKindomID
	end
	local name = worldMapWarDef.getKingdomNameByKid(kID)
	if not name then
		local gametop = gModuleMgr.getObject("gametop")
		local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
		name = KWKingdomCtrl:getKingdomName(isSelfKingdom)
	end
	return name
end)[gKingdomClassType.radiance] = "brightWar_text_37"
;(function(isSelfKingdom)
	local worldMapDefine = include("worldMapDefine")
	local kID
	if not worldMapDefine.currentMapKindomID or isSelfKingdom then
		local gametop = gModuleMgr.getObject("gametop")
		kID = gametop.playertop_:getMapID()
	else
		kID = worldMapDefine.currentMapKindomID
	end
	local name = worldMapWarDef.getKingdomNameByKid(kID)
	if not name then
		local gametop = gModuleMgr.getObject("gametop")
		local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
		name = KWKingdomCtrl:getKingdomName(isSelfKingdom)
	end
	return name
end)[gKingdomClassType.atlantis] = "atlantiswar_text_0058"
;(function(isSelfKingdom)
	local worldMapDefine = include("worldMapDefine")
	local kID
	if not worldMapDefine.currentMapKindomID or isSelfKingdom then
		local gametop = gModuleMgr.getObject("gametop")
		kID = gametop.playertop_:getMapID()
	else
		kID = worldMapDefine.currentMapKindomID
	end
	local name = worldMapWarDef.getKingdomNameByKid(kID)
	if not name then
		local gametop = gModuleMgr.getObject("gametop")
		local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
		name = KWKingdomCtrl:getKingdomName(isSelfKingdom)
	end
	return name
end)[gKingdomClassType.nebulaEmperor] = "nebulaemperor_text_69"
;(function(isSelfKingdom)
	local worldMapDefine = include("worldMapDefine")
	local kID
	if not worldMapDefine.currentMapKindomID or isSelfKingdom then
		local gametop = gModuleMgr.getObject("gametop")
		kID = gametop.playertop_:getMapID()
	else
		kID = worldMapDefine.currentMapKindomID
	end
	local name = worldMapWarDef.getKingdomNameByKid(kID)
	if not name then
		local gametop = gModuleMgr.getObject("gametop")
		local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
		name = KWKingdomCtrl:getKingdomName(isSelfKingdom)
	end
	return name
end)[gKingdomClassType.nebulaAllStar] = "NebulaAllstar_240"
local (function(isSelfKingdom)
	local worldMapDefine = include("worldMapDefine")
	local kID
	if not worldMapDefine.currentMapKindomID or isSelfKingdom then
		local gametop = gModuleMgr.getObject("gametop")
		kID = gametop.playertop_:getMapID()
	else
		kID = worldMapDefine.currentMapKindomID
	end
	local name = worldMapWarDef.getKingdomNameByKid(kID)
	if not name then
		local gametop = gModuleMgr.getObject("gametop")
		local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
		name = KWKingdomCtrl:getKingdomName(isSelfKingdom)
	end
	return name
end)[gKingdomClassType.roaringFlame], warType_config = "flames_dunes_text262", function(isSelfKingdom)
	local worldMapDefine = include("worldMapDefine")
	local kID
	if not worldMapDefine.currentMapKindomID or isSelfKingdom then
		local gametop = gModuleMgr.getObject("gametop")
		kID = gametop.playertop_:getMapID()
	else
		kID = worldMapDefine.currentMapKindomID
	end
	local name = worldMapWarDef.getKingdomNameByKid(kID)
	if not name then
		local gametop = gModuleMgr.getObject("gametop")
		local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
		name = KWKingdomCtrl:getKingdomName(isSelfKingdom)
	end
	return name
end
_ENV, worldMapWarDef.getKingdomClassTips = function(mapClassType, kingdomID)
	if mapClassType == gKingdomClassType.nebula then
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		_ENV = "nebulaActivityCtrl"
		;("nebulaActivityCtrl").num = nebulaActivityCtrl:getCurRound()
		;("nebulaActivityCtrl")[1] = "nebula_war_text_0086"
		return "nebulaActivityCtrl"
	end
	local worldMapDefine = include("worldMapDefine")
	dump(worldMapDefine.currentMapKindomID, "=== worldMapDefine.currentMapKindomID")
	if mapClassType == gKingdomClassType.legendLord and worldMapDefine.isKingStarMapId(kingdomID) then
		return "kingstarbattle_text_35"
	end
	local tips = warType_config[mapClassType]
	if tips then
		return tips
	end
	local kingdomName = worldMapWarDef.getKingdomNameByClassType(mapClassType, kingdomID)
	gKingdomClassType = nil
	;(nil).name = kingdomName
	return i18n("common_text_4931", nil)
end, function(mapClassType, kingdomID)
	if mapClassType == gKingdomClassType.nebula then
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		_ENV = "nebulaActivityCtrl"
		;("nebulaActivityCtrl").num = nebulaActivityCtrl:getCurRound()
		;("nebulaActivityCtrl")[1] = "nebula_war_text_0086"
		return "nebulaActivityCtrl"
	end
	local worldMapDefine = include("worldMapDefine")
	dump(worldMapDefine.currentMapKindomID, "=== worldMapDefine.currentMapKindomID")
	if mapClassType == gKingdomClassType.legendLord and worldMapDefine.isKingStarMapId(kingdomID) then
		return "kingstarbattle_text_35"
	end
	local tips = warType_config[mapClassType]
	if tips then
		return tips
	end
	local kingdomName = worldMapWarDef.getKingdomNameByClassType(mapClassType, kingdomID)
	gKingdomClassType = nil
	;(nil).name = kingdomName
	return i18n("common_text_4931", nil)
end
;(function(mapClassType, kingdomID)
	if mapClassType == gKingdomClassType.nebula then
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		_ENV = "nebulaActivityCtrl"
		;("nebulaActivityCtrl").num = nebulaActivityCtrl:getCurRound()
		;("nebulaActivityCtrl")[1] = "nebula_war_text_0086"
		return "nebulaActivityCtrl"
	end
	local worldMapDefine = include("worldMapDefine")
	dump(worldMapDefine.currentMapKindomID, "=== worldMapDefine.currentMapKindomID")
	if mapClassType == gKingdomClassType.legendLord and worldMapDefine.isKingStarMapId(kingdomID) then
		return "kingstarbattle_text_35"
	end
	local tips = warType_config[mapClassType]
	if tips then
		return tips
	end
	local kingdomName = worldMapWarDef.getKingdomNameByClassType(mapClassType, kingdomID)
	gKingdomClassType = nil
	;(nil).name = kingdomName
	return i18n("common_text_4931", nil)
end)[gKingdomClassType.pyramid] = "favorites_war_pyramid_title"
;(function(mapClassType, kingdomID)
	if mapClassType == gKingdomClassType.nebula then
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		_ENV = "nebulaActivityCtrl"
		;("nebulaActivityCtrl").num = nebulaActivityCtrl:getCurRound()
		;("nebulaActivityCtrl")[1] = "nebula_war_text_0086"
		return "nebulaActivityCtrl"
	end
	local worldMapDefine = include("worldMapDefine")
	dump(worldMapDefine.currentMapKindomID, "=== worldMapDefine.currentMapKindomID")
	if mapClassType == gKingdomClassType.legendLord and worldMapDefine.isKingStarMapId(kingdomID) then
		return "kingstarbattle_text_35"
	end
	local tips = warType_config[mapClassType]
	if tips then
		return tips
	end
	local kingdomName = worldMapWarDef.getKingdomNameByClassType(mapClassType, kingdomID)
	gKingdomClassType = nil
	;(nil).name = kingdomName
	return i18n("common_text_4931", nil)
end)[gKingdomClassType.remains] = "favorites_war_traces_title"
;(function(mapClassType, kingdomID)
	if mapClassType == gKingdomClassType.nebula then
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		_ENV = "nebulaActivityCtrl"
		;("nebulaActivityCtrl").num = nebulaActivityCtrl:getCurRound()
		;("nebulaActivityCtrl")[1] = "nebula_war_text_0086"
		return "nebulaActivityCtrl"
	end
	local worldMapDefine = include("worldMapDefine")
	dump(worldMapDefine.currentMapKindomID, "=== worldMapDefine.currentMapKindomID")
	if mapClassType == gKingdomClassType.legendLord and worldMapDefine.isKingStarMapId(kingdomID) then
		return "kingstarbattle_text_35"
	end
	local tips = warType_config[mapClassType]
	if tips then
		return tips
	end
	local kingdomName = worldMapWarDef.getKingdomNameByClassType(mapClassType, kingdomID)
	gKingdomClassType = nil
	;(nil).name = kingdomName
	return i18n("common_text_4931", nil)
end)[gKingdomClassType.radiance] = "favorites_war_light_title"
;(function(mapClassType, kingdomID)
	if mapClassType == gKingdomClassType.nebula then
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		_ENV = "nebulaActivityCtrl"
		;("nebulaActivityCtrl").num = nebulaActivityCtrl:getCurRound()
		;("nebulaActivityCtrl")[1] = "nebula_war_text_0086"
		return "nebulaActivityCtrl"
	end
	local worldMapDefine = include("worldMapDefine")
	dump(worldMapDefine.currentMapKindomID, "=== worldMapDefine.currentMapKindomID")
	if mapClassType == gKingdomClassType.legendLord and worldMapDefine.isKingStarMapId(kingdomID) then
		return "kingstarbattle_text_35"
	end
	local tips = warType_config[mapClassType]
	if tips then
		return tips
	end
	local kingdomName = worldMapWarDef.getKingdomNameByClassType(mapClassType, kingdomID)
	gKingdomClassType = nil
	;(nil).name = kingdomName
	return i18n("common_text_4931", nil)
end)[gKingdomClassType.legendLord] = "favorites_war_world_title"
;(function(mapClassType, kingdomID)
	if mapClassType == gKingdomClassType.nebula then
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		_ENV = "nebulaActivityCtrl"
		;("nebulaActivityCtrl").num = nebulaActivityCtrl:getCurRound()
		;("nebulaActivityCtrl")[1] = "nebula_war_text_0086"
		return "nebulaActivityCtrl"
	end
	local worldMapDefine = include("worldMapDefine")
	dump(worldMapDefine.currentMapKindomID, "=== worldMapDefine.currentMapKindomID")
	if mapClassType == gKingdomClassType.legendLord and worldMapDefine.isKingStarMapId(kingdomID) then
		return "kingstarbattle_text_35"
	end
	local tips = warType_config[mapClassType]
	if tips then
		return tips
	end
	local kingdomName = worldMapWarDef.getKingdomNameByClassType(mapClassType, kingdomID)
	gKingdomClassType = nil
	;(nil).name = kingdomName
	return i18n("common_text_4931", nil)
end)[gKingdomClassType.atlantis] = "atlantiswar_text_0229"
;(function(mapClassType, kingdomID)
	if mapClassType == gKingdomClassType.nebula then
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		_ENV = "nebulaActivityCtrl"
		;("nebulaActivityCtrl").num = nebulaActivityCtrl:getCurRound()
		;("nebulaActivityCtrl")[1] = "nebula_war_text_0086"
		return "nebulaActivityCtrl"
	end
	local worldMapDefine = include("worldMapDefine")
	dump(worldMapDefine.currentMapKindomID, "=== worldMapDefine.currentMapKindomID")
	if mapClassType == gKingdomClassType.legendLord and worldMapDefine.isKingStarMapId(kingdomID) then
		return "kingstarbattle_text_35"
	end
	local tips = warType_config[mapClassType]
	if tips then
		return tips
	end
	local kingdomName = worldMapWarDef.getKingdomNameByClassType(mapClassType, kingdomID)
	gKingdomClassType = nil
	;(nil).name = kingdomName
	return i18n("common_text_4931", nil)
end)[gKingdomClassType.nebula] = "nebula_war_text_0237"
;(function(mapClassType, kingdomID)
	if mapClassType == gKingdomClassType.nebula then
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		_ENV = "nebulaActivityCtrl"
		;("nebulaActivityCtrl").num = nebulaActivityCtrl:getCurRound()
		;("nebulaActivityCtrl")[1] = "nebula_war_text_0086"
		return "nebulaActivityCtrl"
	end
	local worldMapDefine = include("worldMapDefine")
	dump(worldMapDefine.currentMapKindomID, "=== worldMapDefine.currentMapKindomID")
	if mapClassType == gKingdomClassType.legendLord and worldMapDefine.isKingStarMapId(kingdomID) then
		return "kingstarbattle_text_35"
	end
	local tips = warType_config[mapClassType]
	if tips then
		return tips
	end
	local kingdomName = worldMapWarDef.getKingdomNameByClassType(mapClassType, kingdomID)
	gKingdomClassType = nil
	;(nil).name = kingdomName
	return i18n("common_text_4931", nil)
end)[gKingdomClassType.nebulaEmperor] = "nebulaemperor_text_205"
;(function(mapClassType, kingdomID)
	if mapClassType == gKingdomClassType.nebula then
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		_ENV = "nebulaActivityCtrl"
		;("nebulaActivityCtrl").num = nebulaActivityCtrl:getCurRound()
		;("nebulaActivityCtrl")[1] = "nebula_war_text_0086"
		return "nebulaActivityCtrl"
	end
	local worldMapDefine = include("worldMapDefine")
	dump(worldMapDefine.currentMapKindomID, "=== worldMapDefine.currentMapKindomID")
	if mapClassType == gKingdomClassType.legendLord and worldMapDefine.isKingStarMapId(kingdomID) then
		return "kingstarbattle_text_35"
	end
	local tips = warType_config[mapClassType]
	if tips then
		return tips
	end
	local kingdomName = worldMapWarDef.getKingdomNameByClassType(mapClassType, kingdomID)
	gKingdomClassType = nil
	;(nil).name = kingdomName
	return i18n("common_text_4931", nil)
end)[gKingdomClassType.nebulaAllStar] = "NebulaAllstar_241"
local (function(mapClassType, kingdomID)
	if mapClassType == gKingdomClassType.nebula then
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		_ENV = "nebulaActivityCtrl"
		;("nebulaActivityCtrl").num = nebulaActivityCtrl:getCurRound()
		;("nebulaActivityCtrl")[1] = "nebula_war_text_0086"
		return "nebulaActivityCtrl"
	end
	local worldMapDefine = include("worldMapDefine")
	dump(worldMapDefine.currentMapKindomID, "=== worldMapDefine.currentMapKindomID")
	if mapClassType == gKingdomClassType.legendLord and worldMapDefine.isKingStarMapId(kingdomID) then
		return "kingstarbattle_text_35"
	end
	local tips = warType_config[mapClassType]
	if tips then
		return tips
	end
	local kingdomName = worldMapWarDef.getKingdomNameByClassType(mapClassType, kingdomID)
	gKingdomClassType = nil
	;(nil).name = kingdomName
	return i18n("common_text_4931", nil)
end)[gKingdomClassType.roaringFlame], warType_config = "flames_dunes_text263", function(mapClassType, kingdomID)
	if mapClassType == gKingdomClassType.nebula then
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		_ENV = "nebulaActivityCtrl"
		;("nebulaActivityCtrl").num = nebulaActivityCtrl:getCurRound()
		;("nebulaActivityCtrl")[1] = "nebula_war_text_0086"
		return "nebulaActivityCtrl"
	end
	local worldMapDefine = include("worldMapDefine")
	dump(worldMapDefine.currentMapKindomID, "=== worldMapDefine.currentMapKindomID")
	if mapClassType == gKingdomClassType.legendLord and worldMapDefine.isKingStarMapId(kingdomID) then
		return "kingstarbattle_text_35"
	end
	local tips = warType_config[mapClassType]
	if tips then
		return tips
	end
	local kingdomName = worldMapWarDef.getKingdomNameByClassType(mapClassType, kingdomID)
	gKingdomClassType = nil
	;(nil).name = kingdomName
	return i18n("common_text_4931", nil)
end
_ENV, worldMapWarDef.getFavoriteTitle = function(mapClassType)
	mapClassType = mapClassType or SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	local title = warType_config[mapClassType]
	if title then
		return title
	end
	local kingdomName = worldMapWarDef.getKingdomNameByClassType(mapClassType)
	if kingdomName then
		_ENV = nil
		;(nil).name = kingdomName
		return i18n("common_text_4932", nil)
	end
end, function(mapClassType)
	mapClassType = mapClassType or SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	local title = warType_config[mapClassType]
	if title then
		return title
	end
	local kingdomName = worldMapWarDef.getKingdomNameByClassType(mapClassType)
	if kingdomName then
		_ENV = nil
		;(nil).name = kingdomName
		return i18n("common_text_4932", nil)
	end
end
;(function(mapClassType)
	mapClassType = mapClassType or SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	local title = warType_config[mapClassType]
	if title then
		return title
	end
	local kingdomName = worldMapWarDef.getKingdomNameByClassType(mapClassType)
	if kingdomName then
		_ENV = nil
		;(nil).name = kingdomName
		return i18n("common_text_4932", nil)
	end
end)[gKingdomClassType.newTrial] = "icon_position_devil.png"
;(function(mapClassType)
	mapClassType = mapClassType or SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	local title = warType_config[mapClassType]
	if title then
		return title
	end
	local kingdomName = worldMapWarDef.getKingdomNameByClassType(mapClassType)
	if kingdomName then
		_ENV = nil
		;(nil).name = kingdomName
		return i18n("common_text_4932", nil)
	end
end)[gKingdomClassType.pyramid] = "icon_position_pyramid.png"
;(function(mapClassType)
	mapClassType = mapClassType or SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	local title = warType_config[mapClassType]
	if title then
		return title
	end
	local kingdomName = worldMapWarDef.getKingdomNameByClassType(mapClassType)
	if kingdomName then
		_ENV = nil
		;(nil).name = kingdomName
		return i18n("common_text_4932", nil)
	end
end)[gKingdomClassType.legendLord] = "icon_position_hegemon.png"
;(function(mapClassType)
	mapClassType = mapClassType or SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	local title = warType_config[mapClassType]
	if title then
		return title
	end
	local kingdomName = worldMapWarDef.getKingdomNameByClassType(mapClassType)
	if kingdomName then
		_ENV = nil
		;(nil).name = kingdomName
		return i18n("common_text_4932", nil)
	end
end)[gKingdomClassType.remains] = "icon_position_ruins.png"
;(function(mapClassType)
	mapClassType = mapClassType or SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	local title = warType_config[mapClassType]
	if title then
		return title
	end
	local kingdomName = worldMapWarDef.getKingdomNameByClassType(mapClassType)
	if kingdomName then
		_ENV = nil
		;(nil).name = kingdomName
		return i18n("common_text_4932", nil)
	end
end)[gKingdomClassType.atlantis] = "icon_position_alliance.png"
;(function(mapClassType)
	mapClassType = mapClassType or SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	local title = warType_config[mapClassType]
	if title then
		return title
	end
	local kingdomName = worldMapWarDef.getKingdomNameByClassType(mapClassType)
	if kingdomName then
		_ENV = nil
		;(nil).name = kingdomName
		return i18n("common_text_4932", nil)
	end
end)[gKingdomClassType.nebula] = "icon_position_nebula.png"
;(function(mapClassType)
	mapClassType = mapClassType or SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	local title = warType_config[mapClassType]
	if title then
		return title
	end
	local kingdomName = worldMapWarDef.getKingdomNameByClassType(mapClassType)
	if kingdomName then
		_ENV = nil
		;(nil).name = kingdomName
		return i18n("common_text_4932", nil)
	end
end)[gKingdomClassType.nebulaEmperor] = "icon_position_nebulaemperor.png"
;(function(mapClassType)
	mapClassType = mapClassType or SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	local title = warType_config[mapClassType]
	if title then
		return title
	end
	local kingdomName = worldMapWarDef.getKingdomNameByClassType(mapClassType)
	if kingdomName then
		_ENV = nil
		;(nil).name = kingdomName
		return i18n("common_text_4932", nil)
	end
end)[gKingdomClassType.nebulaAllStar] = "icon_position_nebulaemperor.png"
;(function(mapClassType)
	mapClassType = mapClassType or SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	local title = warType_config[mapClassType]
	if title then
		return title
	end
	local kingdomName = worldMapWarDef.getKingdomNameByClassType(mapClassType)
	if kingdomName then
		_ENV = nil
		;(nil).name = kingdomName
		return i18n("common_text_4932", nil)
	end
end)[gKingdomClassType.roaringFlame] = "icon_position_alliance.png"
local (function(mapClassType)
	mapClassType = mapClassType or SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	local title = warType_config[mapClassType]
	if title then
		return title
	end
	local kingdomName = worldMapWarDef.getKingdomNameByClassType(mapClassType)
	if kingdomName then
		_ENV = nil
		;(nil).name = kingdomName
		return i18n("common_text_4932", nil)
	end
end)[gKingdomClassType.simulatedDrill], warType_config = "icon_position_alliance.png", function(mapClassType)
	mapClassType = mapClassType or SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	local title = warType_config[mapClassType]
	if title then
		return title
	end
	local kingdomName = worldMapWarDef.getKingdomNameByClassType(mapClassType)
	if kingdomName then
		_ENV = nil
		;(nil).name = kingdomName
		return i18n("common_text_4932", nil)
	end
end
_ENV, worldMapWarDef.getPosFrameByKid = function(kID)
	local mapClassType = worldMapWarDef.getKingdomMapClassByKingdomId(kID)
	return warType_config[mapClassType]
end, function(kID)
	local mapClassType = worldMapWarDef.getKingdomMapClassByKingdomId(kID)
	return warType_config[mapClassType]
end
;(function(kID)
	local mapClassType = worldMapWarDef.getKingdomMapClassByKingdomId(kID)
	return warType_config[mapClassType]
end)[gKingdomClassType.remains] = "common_text_047"
;(function(kID)
	local mapClassType = worldMapWarDef.getKingdomMapClassByKingdomId(kID)
	return warType_config[mapClassType]
end)[gKingdomClassType.legendLord] = "free_team_text_41"
;(function(kID)
	local mapClassType = worldMapWarDef.getKingdomMapClassByKingdomId(kID)
	return warType_config[mapClassType]
end)[gKingdomClassType.atlantis] = "atlantiswar_text_0139"
;(function(kID)
	local mapClassType = worldMapWarDef.getKingdomMapClassByKingdomId(kID)
	return warType_config[mapClassType]
end)[gKingdomClassType.nebula] = "nebula_war_text_0025"
;(function(kID)
	local mapClassType = worldMapWarDef.getKingdomMapClassByKingdomId(kID)
	return warType_config[mapClassType]
end)[gKingdomClassType.nebulaEmperor] = "pyramid_btn_34"
;(function(kID)
	local mapClassType = worldMapWarDef.getKingdomMapClassByKingdomId(kID)
	return warType_config[mapClassType]
end)[gKingdomClassType.nebulaAllStar] = "pyramid_btn_34"
;(function(kID)
	local mapClassType = worldMapWarDef.getKingdomMapClassByKingdomId(kID)
	return warType_config[mapClassType]
end)[gKingdomClassType.roaringFlame] = "flames_dunes_text76"
local (function(kID)
	local mapClassType = worldMapWarDef.getKingdomMapClassByKingdomId(kID)
	return warType_config[mapClassType]
end)[gKingdomClassType.simulatedDrill], warType_config = "buildDes_name_122", function(kID)
	local mapClassType = worldMapWarDef.getKingdomMapClassByKingdomId(kID)
	return warType_config[mapClassType]
end
function worldMapWarDef.getBtnAllianceTitle()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	return warType_config[mapClassType] and i18n(warType_config[mapClassType]) or i18n("common_text_069")
end
function worldMapWarDef.onClickBtnAlliance(...)
	if worldMapDefine.isInRemains() then
		uiManager:show("AllianceWarView")
	elseif worldMapDefine.isInLegendLord() then
		local legendTeamUtil = include("legendTeamUtil")
		legendTeamUtil.openTeamWar(worldMapDefine.currentMapKindomID)
	elseif worldMapDefine.isInAtlantis() then
		SoraDCreatePanel("atlantisWarTeamView"):show()
	elseif worldMapDefine.isInNebula() then
		_ENV = nil
		;(nil).enterWarView = true
		uiManager:show("NebulaWarTeam", nil)
	elseif worldMapDefine.isInNebulaEmperor() then
		local nebulaEmperorUtil = include("nebulaEmperorUtil")
		nebulaEmperorUtil.openTeamView()
	elseif worldMapDefine.isInNebulaAllStar() then
		local nebulaAllStarUtil = include("nebulaAllStarUtil")
		local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
		if nebulaAllStarCtrl:getMyTeamInfo():getIsSuperTeam() then
			nebulaAllStarUtil.openTeamView()
		else
			nebulaAllStarUtil.openBackupTeamView()
		end
	elseif worldMapDefine.isInRoaringFlame() then
		uiManager:show("AllianceWarView")
	elseif worldMapDefine.isInSimulatedDrill() then
		uiManager:show("AllianceWarView")
	else
		local allianceMgr = SoraDGetCtrl("allianceMgr")
		if allianceMgr:hasJoinAlliance() then
			if GLOBAL_GAME_ALLIANCE_MODE then
				uiManager:show("allianceMainView")
			else
				SoraDCreatePanel("allianceMainView"):show()
			end
		else
			uiManager:show("AllianceJoinView")
		end
	end
end
local getWarTips = function(mapClassType, activity)
	if mapClassType == gKingdomClassType.remains then
		if activity then
			return (i18n("remains_text_181"))
		else
			return (i18n("remains_text_154"))
		end
	elseif mapClassType == gKingdomClassType.radiance then
		if activity then
			local warName = i18n("brightWar_text_21")
			gKingdomClassType = nil
			;(nil).activity = warName
			return (i18n("AncienTreasure_text_76", nil))
		else
			return (i18n("brightWar_text_140"))
		end
	elseif mapClassType == gKingdomClassType.newTrial then
		if activity then
			return (i18n("devilvalley_text_49"))
		else
			return (i18n("devilvalley_text_50"))
		end
	elseif mapClassType == gKingdomClassType.legendLord then
		if worldMapDefine.isKingStarMapId(worldMapDefine.currentMapKindomID) then
			if activity then
				return (i18n("kingstarbattle_text_70"))
			else
				return (i18n("kingstarbattle_text_70"))
			end
		end
		if activity then
			return (i18n("free_team_text_65"))
		else
			return (i18n("free_team_text_65"))
		end
	elseif mapClassType == gKingdomClassType.pyramid then
		if activity then
			return (i18n("common_text_3302"))
		else
			return (i18n("common_text_3302"))
		end
	elseif mapClassType == gKingdomClassType.atlantis or mapClassType == gKingdomClassType.nebula or mapClassType == gKingdomClassType.nebulaEmperor or mapClassType == gKingdomClassType.nebulaAllStar or mapClassType == gKingdomClassType.roaringFlame or mapClassType == gKingdomClassType.simulatedDrill then
		return i18n("atlantiswar_text_0254")
	end
end
local showWarTips = function(mapClassType, activity)
	local str = getWarTips(mapClassType, activity)
	if str then
		SoraDShowMsgTip(str)
	end
end
function worldMapWarDef.showWarTips(activity)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	showWarTips(mapClassType, activity)
end
function worldMapWarDef.getWarTips(activity)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	return getWarTips(mapClassType, activity)
end
local isInWarForbid_imp = function(warType, noshowTips, activity)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	local ret = warType and warType[mapClassType] or false
	if ret and not noshowTips then
		showWarTips(mapClassType, activity)
	end
	return ret
end
_ENV = nil
;(nil)[gKingdomClassType.remains] = true
;(nil)[gKingdomClassType.radiance] = true
;(nil)[gKingdomClassType.newTrial] = true
;(nil)[gKingdomClassType.atlantis] = true
;(nil)[gKingdomClassType.nebula] = true
;(nil)[gKingdomClassType.nebulaEmperor] = true
;(nil)[gKingdomClassType.nebulaAllStar] = true
;(nil)[gKingdomClassType.roaringFlame] = true
local (nil)[gKingdomClassType.simulatedDrill], warType_forbid = true, nil
_ENV, worldMapWarDef.isInWarForbid = function(noshowTips, activity)
	return isInWarForbid_imp(warType_forbid, noshowTips, activity)
end, function(noshowTips, activity)
	return isInWarForbid_imp(warType_forbid, noshowTips, activity)
end
;(function(noshowTips, activity)
	return isInWarForbid_imp(warType_forbid, noshowTips, activity)
end)[gKingdomClassType.remains] = true
;(function(noshowTips, activity)
	return isInWarForbid_imp(warType_forbid, noshowTips, activity)
end)[gKingdomClassType.radiance] = true
;(function(noshowTips, activity)
	return isInWarForbid_imp(warType_forbid, noshowTips, activity)
end)[gKingdomClassType.atlantis] = true
;(function(noshowTips, activity)
	return isInWarForbid_imp(warType_forbid, noshowTips, activity)
end)[gKingdomClassType.nebula] = true
;(function(noshowTips, activity)
	return isInWarForbid_imp(warType_forbid, noshowTips, activity)
end)[gKingdomClassType.nebulaAllStar] = true
;(function(noshowTips, activity)
	return isInWarForbid_imp(warType_forbid, noshowTips, activity)
end)[gKingdomClassType.roaringFlame] = true
local (function(noshowTips, activity)
	return isInWarForbid_imp(warType_forbid, noshowTips, activity)
end)[gKingdomClassType.simulatedDrill], warType_forbidSolider = true, function(noshowTips, activity)
	return isInWarForbid_imp(warType_forbid, noshowTips, activity)
end
_ENV, worldMapWarDef.isInWarForbidSoldier = function(noshowTips, activity)
	return isInWarForbid_imp(warType_forbidSolider, noshowTips, activity)
end, function(noshowTips, activity)
	return isInWarForbid_imp(warType_forbidSolider, noshowTips, activity)
end
local (function(noshowTips, activity)
	return isInWarForbid_imp(warType_forbidSolider, noshowTips, activity)
end)[gKingdomClassType.radiance], warType_forbidSpeed = true, function(noshowTips, activity)
	return isInWarForbid_imp(warType_forbidSolider, noshowTips, activity)
end
_ENV, worldMapWarDef.isInWarForbidSpeed = function(queue, noshowTips, activity)
	if worldMapDefine.isInRadiance() then
		local radianceWarUtil = include("radianceWarUtil")
		if not radianceWarUtil.isRelease() then
			return false
		end
		return radianceWarUtil.isInWarForbidSpeed(queue, noshowTips, activity)
	end
	if worldMapDefine.isInNebula() then
		local nebulaWarUtil = include("nebulaWarUtil")
		return nebulaWarUtil.isInWarForbidSpeed(queue, noshowTips)
	end
	return isInWarForbid_imp(warType_forbidSpeed, noshowTips, activity)
end, function(queue, noshowTips, activity)
	if worldMapDefine.isInRadiance() then
		local radianceWarUtil = include("radianceWarUtil")
		if not radianceWarUtil.isRelease() then
			return false
		end
		return radianceWarUtil.isInWarForbidSpeed(queue, noshowTips, activity)
	end
	if worldMapDefine.isInNebula() then
		local nebulaWarUtil = include("nebulaWarUtil")
		return nebulaWarUtil.isInWarForbidSpeed(queue, noshowTips)
	end
	return isInWarForbid_imp(warType_forbidSpeed, noshowTips, activity)
end
;(function(queue, noshowTips, activity)
	if worldMapDefine.isInRadiance() then
		local radianceWarUtil = include("radianceWarUtil")
		if not radianceWarUtil.isRelease() then
			return false
		end
		return radianceWarUtil.isInWarForbidSpeed(queue, noshowTips, activity)
	end
	if worldMapDefine.isInNebula() then
		local nebulaWarUtil = include("nebulaWarUtil")
		return nebulaWarUtil.isInWarForbidSpeed(queue, noshowTips)
	end
	return isInWarForbid_imp(warType_forbidSpeed, noshowTips, activity)
end)[gKingdomClassType.remains] = true
;(function(queue, noshowTips, activity)
	if worldMapDefine.isInRadiance() then
		local radianceWarUtil = include("radianceWarUtil")
		if not radianceWarUtil.isRelease() then
			return false
		end
		return radianceWarUtil.isInWarForbidSpeed(queue, noshowTips, activity)
	end
	if worldMapDefine.isInNebula() then
		local nebulaWarUtil = include("nebulaWarUtil")
		return nebulaWarUtil.isInWarForbidSpeed(queue, noshowTips)
	end
	return isInWarForbid_imp(warType_forbidSpeed, noshowTips, activity)
end)[gKingdomClassType.legendLord] = true
;(function(queue, noshowTips, activity)
	if worldMapDefine.isInRadiance() then
		local radianceWarUtil = include("radianceWarUtil")
		if not radianceWarUtil.isRelease() then
			return false
		end
		return radianceWarUtil.isInWarForbidSpeed(queue, noshowTips, activity)
	end
	if worldMapDefine.isInNebula() then
		local nebulaWarUtil = include("nebulaWarUtil")
		return nebulaWarUtil.isInWarForbidSpeed(queue, noshowTips)
	end
	return isInWarForbid_imp(warType_forbidSpeed, noshowTips, activity)
end)[gKingdomClassType.radiance] = true
;(function(queue, noshowTips, activity)
	if worldMapDefine.isInRadiance() then
		local radianceWarUtil = include("radianceWarUtil")
		if not radianceWarUtil.isRelease() then
			return false
		end
		return radianceWarUtil.isInWarForbidSpeed(queue, noshowTips, activity)
	end
	if worldMapDefine.isInNebula() then
		local nebulaWarUtil = include("nebulaWarUtil")
		return nebulaWarUtil.isInWarForbidSpeed(queue, noshowTips)
	end
	return isInWarForbid_imp(warType_forbidSpeed, noshowTips, activity)
end)[gKingdomClassType.atlantis] = true
;(function(queue, noshowTips, activity)
	if worldMapDefine.isInRadiance() then
		local radianceWarUtil = include("radianceWarUtil")
		if not radianceWarUtil.isRelease() then
			return false
		end
		return radianceWarUtil.isInWarForbidSpeed(queue, noshowTips, activity)
	end
	if worldMapDefine.isInNebula() then
		local nebulaWarUtil = include("nebulaWarUtil")
		return nebulaWarUtil.isInWarForbidSpeed(queue, noshowTips)
	end
	return isInWarForbid_imp(warType_forbidSpeed, noshowTips, activity)
end)[gKingdomClassType.nebulaAllStar] = true
;(function(queue, noshowTips, activity)
	if worldMapDefine.isInRadiance() then
		local radianceWarUtil = include("radianceWarUtil")
		if not radianceWarUtil.isRelease() then
			return false
		end
		return radianceWarUtil.isInWarForbidSpeed(queue, noshowTips, activity)
	end
	if worldMapDefine.isInNebula() then
		local nebulaWarUtil = include("nebulaWarUtil")
		return nebulaWarUtil.isInWarForbidSpeed(queue, noshowTips)
	end
	return isInWarForbid_imp(warType_forbidSpeed, noshowTips, activity)
end)[gKingdomClassType.roaringFlame] = true
local (function(queue, noshowTips, activity)
	if worldMapDefine.isInRadiance() then
		local radianceWarUtil = include("radianceWarUtil")
		if not radianceWarUtil.isRelease() then
			return false
		end
		return radianceWarUtil.isInWarForbidSpeed(queue, noshowTips, activity)
	end
	if worldMapDefine.isInNebula() then
		local nebulaWarUtil = include("nebulaWarUtil")
		return nebulaWarUtil.isInWarForbidSpeed(queue, noshowTips)
	end
	return isInWarForbid_imp(warType_forbidSpeed, noshowTips, activity)
end)[gKingdomClassType.simulatedDrill], warType_forbidItem = true, function(queue, noshowTips, activity)
	if worldMapDefine.isInRadiance() then
		local radianceWarUtil = include("radianceWarUtil")
		if not radianceWarUtil.isRelease() then
			return false
		end
		return radianceWarUtil.isInWarForbidSpeed(queue, noshowTips, activity)
	end
	if worldMapDefine.isInNebula() then
		local nebulaWarUtil = include("nebulaWarUtil")
		return nebulaWarUtil.isInWarForbidSpeed(queue, noshowTips)
	end
	return isInWarForbid_imp(warType_forbidSpeed, noshowTips, activity)
end
_ENV, worldMapWarDef.isInWarForbidItem = function(noshowTips, activity)
	return isInWarForbid_imp(warType_forbidItem, noshowTips, activity)
end, function(noshowTips, activity)
	return isInWarForbid_imp(warType_forbidItem, noshowTips, activity)
end
;(function(noshowTips, activity)
	return isInWarForbid_imp(warType_forbidItem, noshowTips, activity)
end)[gKingdomClassType.remains] = true
;(function(noshowTips, activity)
	return isInWarForbid_imp(warType_forbidItem, noshowTips, activity)
end)[gKingdomClassType.pyramid] = true
;(function(noshowTips, activity)
	return isInWarForbid_imp(warType_forbidItem, noshowTips, activity)
end)[gKingdomClassType.radiance] = true
;(function(noshowTips, activity)
	return isInWarForbid_imp(warType_forbidItem, noshowTips, activity)
end)[gKingdomClassType.atlantis] = true
;(function(noshowTips, activity)
	return isInWarForbid_imp(warType_forbidItem, noshowTips, activity)
end)[gKingdomClassType.nebula] = true
;(function(noshowTips, activity)
	return isInWarForbid_imp(warType_forbidItem, noshowTips, activity)
end)[gKingdomClassType.nebulaEmperor] = true
;(function(noshowTips, activity)
	return isInWarForbid_imp(warType_forbidItem, noshowTips, activity)
end)[gKingdomClassType.nebulaAllStar] = true
;(function(noshowTips, activity)
	return isInWarForbid_imp(warType_forbidItem, noshowTips, activity)
end)[gKingdomClassType.roaringFlame] = true
local (function(noshowTips, activity)
	return isInWarForbid_imp(warType_forbidItem, noshowTips, activity)
end)[gKingdomClassType.simulatedDrill], warType_forbidAllianceRelation = true, function(noshowTips, activity)
	return isInWarForbid_imp(warType_forbidItem, noshowTips, activity)
end
_ENV, worldMapWarDef.isInWarForbidAllianceRelation = function(mapClassType)
	return warType_forbidAllianceRelation[mapClassType]
end, function(mapClassType)
	return warType_forbidAllianceRelation[mapClassType]
end
;(function(mapClassType)
	return warType_forbidAllianceRelation[mapClassType]
end)[gKingdomClassType.pyramid] = true
;(function(mapClassType)
	return warType_forbidAllianceRelation[mapClassType]
end)[gKingdomClassType.newTrial] = true
local (function(mapClassType)
	return warType_forbidAllianceRelation[mapClassType]
end)[gKingdomClassType.roaringFlame], warType_config = true, function(mapClassType)
	return warType_forbidAllianceRelation[mapClassType]
end
function worldMapWarDef.isInTeamChannel()
	if worldMapWarDef.isInTeamStatus() then
		return true
	end
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if warType_config[mapClassType] then
		return true
	end
	return false
end
_ENV, worldMapWarDef.isInTeamWarForbid = function()
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	local teamId = allianceMgr:getRealTeamID()
	return teamId and teamId ~= 0
end, function()
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	local teamId = allianceMgr:getRealTeamID()
	return teamId and teamId ~= 0
end
;(function()
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	local teamId = allianceMgr:getRealTeamID()
	return teamId and teamId ~= 0
end)[gKingdomClassType.legendLord] = true
;(function()
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	local teamId = allianceMgr:getRealTeamID()
	return teamId and teamId ~= 0
end)[gKingdomClassType.remains] = true
;(function()
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	local teamId = allianceMgr:getRealTeamID()
	return teamId and teamId ~= 0
end)[gKingdomClassType.atlantis] = true
;(function()
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	local teamId = allianceMgr:getRealTeamID()
	return teamId and teamId ~= 0
end)[gKingdomClassType.nebula] = true
;(function()
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	local teamId = allianceMgr:getRealTeamID()
	return teamId and teamId ~= 0
end)[gKingdomClassType.nebulaEmperor] = true
local (function()
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	local teamId = allianceMgr:getRealTeamID()
	return teamId and teamId ~= 0
end)[gKingdomClassType.nebulaAllStar], warType_config = true, function()
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	local teamId = allianceMgr:getRealTeamID()
	return teamId and teamId ~= 0
end
_ENV, worldMapWarDef.isInTeamStatus = function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if warType_config[mapClassType] then
		return true
	end
	return false
end, function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if warType_config[mapClassType] then
		return true
	end
	return false
end
local (function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if warType_config[mapClassType] then
		return true
	end
	return false
end)[gKingdomClassType.roaringFlame], warType_config = true, function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if warType_config[mapClassType] then
		return true
	end
	return false
end
_ENV, worldMapWarDef.isInWarForbidSoldierHelp = function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	return not warType_config[mapClassType]
end, function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	return not warType_config[mapClassType]
end
;(function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	return not warType_config[mapClassType]
end)[gKingdomClassType.legendLord] = true
;(function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	return not warType_config[mapClassType]
end)[gKingdomClassType.remains] = true
;(function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	return not warType_config[mapClassType]
end)[gKingdomClassType.nebula] = true
;(function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	return not warType_config[mapClassType]
end)[gKingdomClassType.nebulaEmperor] = true
;(function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	return not warType_config[mapClassType]
end)[gKingdomClassType.nebulaAllStar] = true
local (function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	return not warType_config[mapClassType]
end)[gKingdomClassType.roaringFlame], warType_config = true, function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	return not warType_config[mapClassType]
end
_ENV, worldMapWarDef.isInWarForbidResourceHelp = function(mapClassType)
	mapClassType = mapClassType or SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	return not warType_config[mapClassType]
end, function(mapClassType)
	mapClassType = mapClassType or SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	return not warType_config[mapClassType]
end
;(function(mapClassType)
	mapClassType = mapClassType or SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	return not warType_config[mapClassType]
end)[gKingdomClassType.pyramid] = true
;(function(mapClassType)
	mapClassType = mapClassType or SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	return not warType_config[mapClassType]
end)[gKingdomClassType.remains] = true
;(function(mapClassType)
	mapClassType = mapClassType or SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	return not warType_config[mapClassType]
end)[gKingdomClassType.radiance] = true
;(function(mapClassType)
	mapClassType = mapClassType or SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	return not warType_config[mapClassType]
end)[gKingdomClassType.atlantis] = true
;(function(mapClassType)
	mapClassType = mapClassType or SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	return not warType_config[mapClassType]
end)[gKingdomClassType.nebula] = true
;(function(mapClassType)
	mapClassType = mapClassType or SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	return not warType_config[mapClassType]
end)[gKingdomClassType.nebulaEmperor] = true
;(function(mapClassType)
	mapClassType = mapClassType or SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	return not warType_config[mapClassType]
end)[gKingdomClassType.nebulaAllStar] = true
;(function(mapClassType)
	mapClassType = mapClassType or SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	return not warType_config[mapClassType]
end)[gKingdomClassType.roaringFlame] = true
local (function(mapClassType)
	mapClassType = mapClassType or SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	return not warType_config[mapClassType]
end)[gKingdomClassType.simulatedDrill], warType_config = true, function(mapClassType)
	mapClassType = mapClassType or SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	return not warType_config[mapClassType]
end
_ENV, worldMapWarDef.isInWarForbidBookMark = function(mapClassType)
	return warType_config[mapClassType]
end, function(mapClassType)
	return warType_config[mapClassType]
end
;(function(mapClassType)
	return warType_config[mapClassType]
end)[gKingdomClassType.remains] = true
;(function(mapClassType)
	return warType_config[mapClassType]
end)[gKingdomClassType.newTrial] = true
local (function(mapClassType)
	return warType_config[mapClassType]
end)[gKingdomClassType.radiance], warType_config = true, function(mapClassType)
	return warType_config[mapClassType]
end
_ENV, worldMapWarDef.isInWarForbidBonePoing = function(mapClassType)
	return warType_config[mapClassType]
end, function(mapClassType)
	return warType_config[mapClassType]
end
;(function(mapClassType)
	return warType_config[mapClassType]
end)[gKingdomClassType.pyramid] = true
;(function(mapClassType)
	return warType_config[mapClassType]
end)[gKingdomClassType.legendLord] = true
;(function(mapClassType)
	return warType_config[mapClassType]
end)[gKingdomClassType.remains] = true
;(function(mapClassType)
	return warType_config[mapClassType]
end)[gKingdomClassType.radiance] = true
;(function(mapClassType)
	return warType_config[mapClassType]
end)[gKingdomClassType.atlantis] = true
;(function(mapClassType)
	return warType_config[mapClassType]
end)[gKingdomClassType.nebula] = true
;(function(mapClassType)
	return warType_config[mapClassType]
end)[gKingdomClassType.nebulaEmperor] = true
;(function(mapClassType)
	return warType_config[mapClassType]
end)[gKingdomClassType.nebulaAllStar] = true
;(function(mapClassType)
	return warType_config[mapClassType]
end)[gKingdomClassType.roaringFlame] = true
local (function(mapClassType)
	return warType_config[mapClassType]
end)[gKingdomClassType.simulatedDrill], warType_config = true, function(mapClassType)
	return warType_config[mapClassType]
end
function worldMapWarDef.getPlayerBattleGroundMigration()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	return warType_config[mapClassType]
end
_ENV, worldMapWarDef.getTableMassTime = function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	local armyDesRead = include("armyDesRead")
	return armyDesRead.getTableMassTime(mapClassType)
end, function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	local armyDesRead = include("armyDesRead")
	return armyDesRead.getTableMassTime(mapClassType)
end
;(function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	local armyDesRead = include("armyDesRead")
	return armyDesRead.getTableMassTime(mapClassType)
end)[gQueueTypeDef.hostpital_queue] = true
;(function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	local armyDesRead = include("armyDesRead")
	return armyDesRead.getTableMassTime(mapClassType)
end)[gQueueTypeDef.legend_war_hostpital_queue] = true
;(function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	local armyDesRead = include("armyDesRead")
	return armyDesRead.getTableMassTime(mapClassType)
end)[gQueueTypeDef.radiance_war_hostpital_queue] = true
;(function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	local armyDesRead = include("armyDesRead")
	return armyDesRead.getTableMassTime(mapClassType)
end)[gQueueTypeDef.atlantis_war_hostpital_queue] = true
;(function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	local armyDesRead = include("armyDesRead")
	return armyDesRead.getTableMassTime(mapClassType)
end)[gQueueTypeDef.nebula_war_hostpital_queue] = true
;(function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	local armyDesRead = include("armyDesRead")
	return armyDesRead.getTableMassTime(mapClassType)
end)[gQueueTypeDef.flame_war_hostpital_queue] = true
local (function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	local armyDesRead = include("armyDesRead")
	return armyDesRead.getTableMassTime(mapClassType)
end)[gQueueTypeDef.simulated_drill_war_hostpital_queue], hospitalQueues = true, function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	local armyDesRead = include("armyDesRead")
	return armyDesRead.getTableMassTime(mapClassType)
end
function worldMapWarDef.isHospitalQueue(queuetype)
	return hospitalQueues[queuetype]
end
_ENV, worldMapWarDef.getHospitalQueues = function()
	return hospitalQueues
end, function()
	return hospitalQueues
end
;(function()
	return hospitalQueues
end)[gKingdomClassType.normal] = gQueueTypeDef.hostpital_queue
;(function()
	return hospitalQueues
end)[gKingdomClassType.legendLord] = gQueueTypeDef.legend_war_hostpital_queue
;(function()
	return hospitalQueues
end)[gKingdomClassType.radiance] = gQueueTypeDef.radiance_war_hostpital_queue
;(function()
	return hospitalQueues
end)[gKingdomClassType.atlantis] = gQueueTypeDef.atlantis_war_hostpital_queue
;(function()
	return hospitalQueues
end)[gKingdomClassType.nebula] = gQueueTypeDef.nebula_war_hostpital_queue
;(function()
	return hospitalQueues
end)[gKingdomClassType.roaringFlame] = gQueueTypeDef.flame_war_hostpital_queue
local (function()
	return hospitalQueues
end)[gKingdomClassType.simulatedDrill], warType2queueType = gQueueTypeDef.simulated_drill_war_hostpital_queue, function()
	return hospitalQueues
end
_ENV, worldMapWarDef.getHostpitalQueueType = function(mapClassType)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	mapClassType = mapClassType or kingdomMapCtrl:getKingdomClass()
	return warType2queueType[mapClassType] or warType2queueType[gKingdomClassType.normal]
end, function(mapClassType)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	mapClassType = mapClassType or kingdomMapCtrl:getKingdomClass()
	return warType2queueType[mapClassType] or warType2queueType[gKingdomClassType.normal]
end
;(function(mapClassType)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	mapClassType = mapClassType or kingdomMapCtrl:getKingdomClass()
	return warType2queueType[mapClassType] or warType2queueType[gKingdomClassType.normal]
end)[gQueueTypeDef.hostpital_queue] = gAbbrSpeedUpType.CURE
;(function(mapClassType)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	mapClassType = mapClassType or kingdomMapCtrl:getKingdomClass()
	return warType2queueType[mapClassType] or warType2queueType[gKingdomClassType.normal]
end)[gQueueTypeDef.legend_war_hostpital_queue] = gAbbrSpeedUpType.LEGEND_LORD
;(function(mapClassType)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	mapClassType = mapClassType or kingdomMapCtrl:getKingdomClass()
	return warType2queueType[mapClassType] or warType2queueType[gKingdomClassType.normal]
end)[gQueueTypeDef.radiance_war_hostpital_queue] = gAbbrSpeedUpType.CURE_WAR
;(function(mapClassType)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	mapClassType = mapClassType or kingdomMapCtrl:getKingdomClass()
	return warType2queueType[mapClassType] or warType2queueType[gKingdomClassType.normal]
end)[gQueueTypeDef.atlantis_war_hostpital_queue] = gAbbrSpeedUpType.ATLANTIS_WAR_CURE
;(function(mapClassType)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	mapClassType = mapClassType or kingdomMapCtrl:getKingdomClass()
	return warType2queueType[mapClassType] or warType2queueType[gKingdomClassType.normal]
end)[gQueueTypeDef.nebula_war_hostpital_queue] = gAbbrSpeedUpType.NEBULA_WAR_CURE
local (function(mapClassType)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	mapClassType = mapClassType or kingdomMapCtrl:getKingdomClass()
	return warType2queueType[mapClassType] or warType2queueType[gKingdomClassType.normal]
end)[gQueueTypeDef.flame_war_hostpital_queue], queueType2itemType = gAbbrSpeedUpType.FLAME_WAR_CURE, function(mapClassType)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	mapClassType = mapClassType or kingdomMapCtrl:getKingdomClass()
	return warType2queueType[mapClassType] or warType2queueType[gKingdomClassType.normal]
end
function worldMapWarDef.getItemTypeByQueueType(queueType)
	if not queueType2itemType[queueType] then
		_ENV = queueType2itemType[queueType]
		queueType2itemType[queueType][1] = gAbbrSpeedUpType.CURE
	end
	return queueType2itemType[queueType]
end
_ENV, worldMapWarDef.getWarQueueTypeConfig = function()
	return queueType2itemType
end, function()
	return queueType2itemType
end
;(function()
	return queueType2itemType
end)[gAbbrSpeedUpType.ATLANTIS_WAR_CURE] = true
;(function()
	return queueType2itemType
end)[gAbbrSpeedUpType.NEBULA_WAR_CURE] = true
;(function()
	return queueType2itemType
end)[gAbbrSpeedUpType.FLAME_WAR_CURE] = true
local (function()
	return queueType2itemType
end)[gAbbrSpeedUpType.LEGEND_LORD], queueType2itemTypeExtra = true, function()
	return queueType2itemType
end
_ENV, worldMapWarDef.getItemTypeByQueueTypeExtra = function(queueType)
	return queueType2itemTypeExtra[queueType] or false
end, function(queueType)
	return queueType2itemTypeExtra[queueType] or false
end
_ENV = nil
;(nil).subcmd = gCmd.REQ_CURE_WOUNDED_ARMY
;(nil).totalArmyKey = "totalArmy"
;(function(queueType)
	return queueType2itemTypeExtra[queueType] or false
end)[gKingdomClassType.normal], (nil).woundedArmyKey = nil, "woundedArmy"
_ENV = nil
;(nil).subcmd = gCmd.REQ_CURE_LEGEND_WAR_WOUNDED_ARMY
;(nil).totalArmyKey = "totalArmy"
;(function(queueType)
	return queueType2itemTypeExtra[queueType] or false
end)[gKingdomClassType.legendLord], (nil).woundedArmyKey = nil, "legendWarWoundedArmy"
_ENV = nil
;(nil).subcmd = gCmd.REQ_CURE_RADIANCE_WAR_WOUNDED_ARMY
;(nil).totalArmyKey = "radianceWarArmy"
;(function(queueType)
	return queueType2itemTypeExtra[queueType] or false
end)[gKingdomClassType.radiance], (nil).woundedArmyKey = nil, "radianceWarWoundedArmy"
_ENV = nil
;(nil).subcmd = gCmd.REQ_CURE_ATLANTIS_WAR_WOUNDED_ARMY
;(nil).totalArmyKey = "atlantisWarArmy"
;(function(queueType)
	return queueType2itemTypeExtra[queueType] or false
end)[gKingdomClassType.atlantis], (nil).woundedArmyKey = nil, "atlantisWarWoundedArmy"
_ENV = nil
;(nil).subcmd = gCmd.REQ_CURE_NEBULA_WAR_WOUNDED_ARMY
;(nil).totalArmyKey = "nebulaWarArmy"
;(function(queueType)
	return queueType2itemTypeExtra[queueType] or false
end)[gKingdomClassType.nebula], (nil).woundedArmyKey = nil, "nebulaWarWoundedArmy"
_ENV = nil
;(nil).subcmd = gCmd.REQ_CURE_FLAME_WAR_WOUNDED_ARMY
;(nil).totalArmyKey = "flameWarArmy"
;(function(queueType)
	return queueType2itemTypeExtra[queueType] or false
end)[gKingdomClassType.roaringFlame], (nil).woundedArmyKey = nil, "flameWarWoundedArmy"
_ENV = nil
;(nil).subcmd = gCmd.REQ_CURE_SIMULATED_DRILL_WAR_WOUNDED_ARMY
;(nil).totalArmyKey = "simulatedDrillWarArmy"
;(function(queueType)
	return queueType2itemTypeExtra[queueType] or false
end)[gKingdomClassType.simulatedDrill], (nil).woundedArmyKey = nil, "simulatedDrillWarWoundedArmy"
local function warType2armyConfig(queueType)
	return queueType2itemTypeExtra[queueType] or false
end
function worldMapWarDef.getWarArmyConfig()
	return warType2armyConfig
end
_ENV, worldMapWarDef.getArmyConfigByWarType = function(warType)
	return warType2armyConfig[warType] or warType2armyConfig[gKingdomClassType.normal]
end, function(warType)
	return warType2armyConfig[warType] or warType2armyConfig[gKingdomClassType.normal]
end
;(function(warType)
	return warType2armyConfig[warType] or warType2armyConfig[gKingdomClassType.normal]
end)[gKingdomClassType.legendLord] = "legendaryking_text_95"
local (function(warType)
	return warType2armyConfig[warType] or warType2armyConfig[gKingdomClassType.normal]
end)[gKingdomClassType.roaringFlame], warType_config = "flames_dunes_text154", function(warType)
	return warType2armyConfig[warType] or warType2armyConfig[gKingdomClassType.normal]
end
function worldMapWarDef.getHostpitalViewTitle(warType)
	if not warType then
		return
	end
	local titleKey = warType_config[warType]
	if titleKey then
		return i18n(titleKey)
	end
end
_ENV, worldMapWarDef.getAllianceMarkHelp = function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if mapClassType == gKingdomClassType.nebulaAllStar then
		return i18n("NebulaAllstar_394")
	elseif mapClassType == gKingdomClassType.roaringFlame then
		return i18n("flames_dunes_text156")
	elseif worldMapWarDef.isInTeamStatus() then
		return i18n("nebula_war_text_0195")
	else
		return i18n("alliance_mapmark_text_015")
	end
end, function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if mapClassType == gKingdomClassType.nebulaAllStar then
		return i18n("NebulaAllstar_394")
	elseif mapClassType == gKingdomClassType.roaringFlame then
		return i18n("flames_dunes_text156")
	elseif worldMapWarDef.isInTeamStatus() then
		return i18n("nebula_war_text_0195")
	else
		return i18n("alliance_mapmark_text_015")
	end
end
;(function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if mapClassType == gKingdomClassType.nebulaAllStar then
		return i18n("NebulaAllstar_394")
	elseif mapClassType == gKingdomClassType.roaringFlame then
		return i18n("flames_dunes_text156")
	elseif worldMapWarDef.isInTeamStatus() then
		return i18n("nebula_war_text_0195")
	else
		return i18n("alliance_mapmark_text_015")
	end
end)[gKingdomClassType.normal] = "alliance_store_returns_description_5"
;(function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if mapClassType == gKingdomClassType.nebulaAllStar then
		return i18n("NebulaAllstar_394")
	elseif mapClassType == gKingdomClassType.roaringFlame then
		return i18n("flames_dunes_text156")
	elseif worldMapWarDef.isInTeamStatus() then
		return i18n("nebula_war_text_0195")
	else
		return i18n("alliance_mapmark_text_015")
	end
end)[gKingdomClassType.pyramid] = "alliance_mapmark_text_009"
;(function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if mapClassType == gKingdomClassType.nebulaAllStar then
		return i18n("NebulaAllstar_394")
	elseif mapClassType == gKingdomClassType.roaringFlame then
		return i18n("flames_dunes_text156")
	elseif worldMapWarDef.isInTeamStatus() then
		return i18n("nebula_war_text_0195")
	else
		return i18n("alliance_mapmark_text_015")
	end
end)[gKingdomClassType.legendLord] = "alliance_mapmark_text_008"
;(function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if mapClassType == gKingdomClassType.nebulaAllStar then
		return i18n("NebulaAllstar_394")
	elseif mapClassType == gKingdomClassType.roaringFlame then
		return i18n("flames_dunes_text156")
	elseif worldMapWarDef.isInTeamStatus() then
		return i18n("nebula_war_text_0195")
	else
		return i18n("alliance_mapmark_text_015")
	end
end)[gKingdomClassType.remains] = "alliance_mapmark_text_008"
;(function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if mapClassType == gKingdomClassType.nebulaAllStar then
		return i18n("NebulaAllstar_394")
	elseif mapClassType == gKingdomClassType.roaringFlame then
		return i18n("flames_dunes_text156")
	elseif worldMapWarDef.isInTeamStatus() then
		return i18n("nebula_war_text_0195")
	else
		return i18n("alliance_mapmark_text_015")
	end
end)[gKingdomClassType.radiance] = "alliance_store_returns_description_5"
;(function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if mapClassType == gKingdomClassType.nebulaAllStar then
		return i18n("NebulaAllstar_394")
	elseif mapClassType == gKingdomClassType.roaringFlame then
		return i18n("flames_dunes_text156")
	elseif worldMapWarDef.isInTeamStatus() then
		return i18n("nebula_war_text_0195")
	else
		return i18n("alliance_mapmark_text_015")
	end
end)[gKingdomClassType.atlantis] = "alliance_mapmark_text_010"
;(function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if mapClassType == gKingdomClassType.nebulaAllStar then
		return i18n("NebulaAllstar_394")
	elseif mapClassType == gKingdomClassType.roaringFlame then
		return i18n("flames_dunes_text156")
	elseif worldMapWarDef.isInTeamStatus() then
		return i18n("nebula_war_text_0195")
	else
		return i18n("alliance_mapmark_text_015")
	end
end)[gKingdomClassType.nebula] = "alliance_mapmark_text_008"
;(function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if mapClassType == gKingdomClassType.nebulaAllStar then
		return i18n("NebulaAllstar_394")
	elseif mapClassType == gKingdomClassType.roaringFlame then
		return i18n("flames_dunes_text156")
	elseif worldMapWarDef.isInTeamStatus() then
		return i18n("nebula_war_text_0195")
	else
		return i18n("alliance_mapmark_text_015")
	end
end)[gKingdomClassType.nebulaAllStar] = "NebulaAllstar_242"
local (function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if mapClassType == gKingdomClassType.nebulaAllStar then
		return i18n("NebulaAllstar_394")
	elseif mapClassType == gKingdomClassType.roaringFlame then
		return i18n("flames_dunes_text156")
	elseif worldMapWarDef.isInTeamStatus() then
		return i18n("nebula_war_text_0195")
	else
		return i18n("alliance_mapmark_text_015")
	end
end)[gKingdomClassType.roaringFlame], warType_config = "Celestial_defense_text_010", function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if mapClassType == gKingdomClassType.nebulaAllStar then
		return i18n("NebulaAllstar_394")
	elseif mapClassType == gKingdomClassType.roaringFlame then
		return i18n("flames_dunes_text156")
	elseif worldMapWarDef.isInTeamStatus() then
		return i18n("nebula_war_text_0195")
	else
		return i18n("alliance_mapmark_text_015")
	end
end
function worldMapWarDef.isInWarForbidAllianceMark()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if warType_config[mapClassType] then
		return true
	end
end
function worldMapWarDef.showAllianceMarkRankMsgTip()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	local msgTip = warType_config[mapClassType] or warType_config[gKingdomClassType.normal]
	SoraDShowMsgTip(i18n(msgTip))
end
function worldMapWarDef.checkAllianceMarkRank(showMsgTip)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	local isRankEnough = true
	if mapClassType == gKingdomClassType.normal or mapClassType == gKingdomClassType.pyramid or mapClassType == gKingdomClassType.radiance then
		local allianceDesRead = include("allianceDesRead")
		if not allianceDesRead.checkRank(gAllianceRank.R4) then
			isRankEnough = false
		end
	elseif mapClassType == gKingdomClassType.legendLord then
		local teamCtrl = include("legendTeamUtil").getCurTeamCtrl(worldMapDefine.currentMapKindomID)
		if teamCtrl.isTeamCommander then
			if not teamCtrl:isTeamLeader() and not teamCtrl:isTeamCommander() then
				isRankEnough = false
			end
		elseif not teamCtrl:isTeamLeader() then
			isRankEnough = false
		end
	elseif mapClassType == gKingdomClassType.remains then
	elseif mapClassType == gKingdomClassType.atlantis then
		local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
		if atlantisWarCtrl:getSelfMemberClass() < gAtlantisRankType.Manager then
			isRankEnough = false
		end
	elseif mapClassType == gKingdomClassType.nebula then
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		local myTeamInfo = nebulaActivityCtrl:getMyTeamInfo()
		if not myTeamInfo:isTeamLeader() then
			isRankEnough = false
		end
	elseif mapClassType == gKingdomClassType.nebulaAllStar then
		local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
		local myTeamInfo = nebulaAllStarCtrl:getMyTeamInfo()
		if not myTeamInfo:isTeamLeader() and not myTeamInfo:isTeamCommander() then
			isRankEnough = false
		end
	elseif mapClassType == gKingdomClassType.roaringFlame then
		local roaringFlameWarUtil = include("roaringFlameWarUtil")
		if not roaringFlameWarUtil.checkPermission(ROARING_FLAME_WAR_PERMISSION.MAP_MARK) then
			isRankEnough = false
		end
	end
	if not isRankEnough and showMsgTip then
		worldMapWarDef.showAllianceMarkRankMsgTip()
	end
	return isRankEnough
end
function worldMapWarDef.checkCanMass(param)
	if not param then
		param, _ENV = nil, nil
	end
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if mapClassType == gKingdomClassType.nebula then
		return true
	elseif mapClassType == gKingdomClassType.nebulaEmperor then
		local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
		local myTeamInfo = nebulaEmperorCtrl:getMyTeamInfo()
		if myTeamInfo:isTeamLeader() or myTeamInfo:isTeamCommander() or myTeamInfo:isTeamAssembler() then
			return true
		end
	elseif mapClassType == gKingdomClassType.nebulaAllStar then
		local subType = param.subType
		if subType == gWorldTypeServerDef.subTypeNebulaAllStarWarPalace then
			local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
			local myTeamInfo = nebulaAllStarCtrl:getMyTeamInfo()
			if myTeamInfo:isTeamLeader() or myTeamInfo:isTeamCommander() then
				return true
			end
		else
			return true
		end
	end
	local noMsgTip = param.noMsgTip
	if not noMsgTip then
		worldMapWarDef.showMassErrMsgTip()
	end
	return false
end
_ENV, worldMapWarDef.checkCanJoinMass = function(data)
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
	if lordInfoCtrl:getIsTraitor() and conquestWarCtrl:isConquestWarOpenningAndNotInWar() then
		SoraDShowMsgTip(i18n("worldwar_text_01"))
		return
	end
	local remainsWarUtil = include("remainsWarUtil")
	if remainsWarUtil.isForbitWarByInBorn() then
		SoraDShowMsgTip(i18n("remains_text_142"))
		return
	end
	if worldMapDefine.isInAtlantis() then
		local atlantisWarUtil = include("atlantisWarUtil")
		if not atlantisWarUtil.checkCanJoinMass(data.massData, true) then
			return
		end
	end
	if worldMapDefine.isInNebulaEmperor() then
		local nebulaEmperorUtil = include("nebulaEmperorUtil")
		if nebulaEmperorUtil.isForbitWarByInBorn() then
			SoraDShowMsgTip(i18n("nebulaemperor_text_220"))
			return
		end
	end
	if worldMapDefine.isInNebulaAllStar() then
		local nebulaAllStarUtil = include("nebulaAllStarUtil")
		local ok, errTip = nebulaAllStarUtil.checkSelfCityPos()
		if not ok then
			return SoraDShowMsgTip(errTip)
		end
	end
	return true
end, function(data)
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
	if lordInfoCtrl:getIsTraitor() and conquestWarCtrl:isConquestWarOpenningAndNotInWar() then
		SoraDShowMsgTip(i18n("worldwar_text_01"))
		return
	end
	local remainsWarUtil = include("remainsWarUtil")
	if remainsWarUtil.isForbitWarByInBorn() then
		SoraDShowMsgTip(i18n("remains_text_142"))
		return
	end
	if worldMapDefine.isInAtlantis() then
		local atlantisWarUtil = include("atlantisWarUtil")
		if not atlantisWarUtil.checkCanJoinMass(data.massData, true) then
			return
		end
	end
	if worldMapDefine.isInNebulaEmperor() then
		local nebulaEmperorUtil = include("nebulaEmperorUtil")
		if nebulaEmperorUtil.isForbitWarByInBorn() then
			SoraDShowMsgTip(i18n("nebulaemperor_text_220"))
			return
		end
	end
	if worldMapDefine.isInNebulaAllStar() then
		local nebulaAllStarUtil = include("nebulaAllStarUtil")
		local ok, errTip = nebulaAllStarUtil.checkSelfCityPos()
		if not ok then
			return SoraDShowMsgTip(errTip)
		end
	end
	return true
end
;(function(data)
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
	if lordInfoCtrl:getIsTraitor() and conquestWarCtrl:isConquestWarOpenningAndNotInWar() then
		SoraDShowMsgTip(i18n("worldwar_text_01"))
		return
	end
	local remainsWarUtil = include("remainsWarUtil")
	if remainsWarUtil.isForbitWarByInBorn() then
		SoraDShowMsgTip(i18n("remains_text_142"))
		return
	end
	if worldMapDefine.isInAtlantis() then
		local atlantisWarUtil = include("atlantisWarUtil")
		if not atlantisWarUtil.checkCanJoinMass(data.massData, true) then
			return
		end
	end
	if worldMapDefine.isInNebulaEmperor() then
		local nebulaEmperorUtil = include("nebulaEmperorUtil")
		if nebulaEmperorUtil.isForbitWarByInBorn() then
			SoraDShowMsgTip(i18n("nebulaemperor_text_220"))
			return
		end
	end
	if worldMapDefine.isInNebulaAllStar() then
		local nebulaAllStarUtil = include("nebulaAllStarUtil")
		local ok, errTip = nebulaAllStarUtil.checkSelfCityPos()
		if not ok then
			return SoraDShowMsgTip(errTip)
		end
	end
	return true
end)[gKingdomClassType.nebula] = "nebula_war_text_0473"
;(function(data)
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
	if lordInfoCtrl:getIsTraitor() and conquestWarCtrl:isConquestWarOpenningAndNotInWar() then
		SoraDShowMsgTip(i18n("worldwar_text_01"))
		return
	end
	local remainsWarUtil = include("remainsWarUtil")
	if remainsWarUtil.isForbitWarByInBorn() then
		SoraDShowMsgTip(i18n("remains_text_142"))
		return
	end
	if worldMapDefine.isInAtlantis() then
		local atlantisWarUtil = include("atlantisWarUtil")
		if not atlantisWarUtil.checkCanJoinMass(data.massData, true) then
			return
		end
	end
	if worldMapDefine.isInNebulaEmperor() then
		local nebulaEmperorUtil = include("nebulaEmperorUtil")
		if nebulaEmperorUtil.isForbitWarByInBorn() then
			SoraDShowMsgTip(i18n("nebulaemperor_text_220"))
			return
		end
	end
	if worldMapDefine.isInNebulaAllStar() then
		local nebulaAllStarUtil = include("nebulaAllStarUtil")
		local ok, errTip = nebulaAllStarUtil.checkSelfCityPos()
		if not ok then
			return SoraDShowMsgTip(errTip)
		end
	end
	return true
end)[gKingdomClassType.nebulaEmperor] = "nebulaemperor_text_223"
local (function(data)
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
	if lordInfoCtrl:getIsTraitor() and conquestWarCtrl:isConquestWarOpenningAndNotInWar() then
		SoraDShowMsgTip(i18n("worldwar_text_01"))
		return
	end
	local remainsWarUtil = include("remainsWarUtil")
	if remainsWarUtil.isForbitWarByInBorn() then
		SoraDShowMsgTip(i18n("remains_text_142"))
		return
	end
	if worldMapDefine.isInAtlantis() then
		local atlantisWarUtil = include("atlantisWarUtil")
		if not atlantisWarUtil.checkCanJoinMass(data.massData, true) then
			return
		end
	end
	if worldMapDefine.isInNebulaEmperor() then
		local nebulaEmperorUtil = include("nebulaEmperorUtil")
		if nebulaEmperorUtil.isForbitWarByInBorn() then
			SoraDShowMsgTip(i18n("nebulaemperor_text_220"))
			return
		end
	end
	if worldMapDefine.isInNebulaAllStar() then
		local nebulaAllStarUtil = include("nebulaAllStarUtil")
		local ok, errTip = nebulaAllStarUtil.checkSelfCityPos()
		if not ok then
			return SoraDShowMsgTip(errTip)
		end
	end
	return true
end)[gKingdomClassType.nebulaAllStar], warType_config = "NebulaAllstar_407", function(data)
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
	if lordInfoCtrl:getIsTraitor() and conquestWarCtrl:isConquestWarOpenningAndNotInWar() then
		SoraDShowMsgTip(i18n("worldwar_text_01"))
		return
	end
	local remainsWarUtil = include("remainsWarUtil")
	if remainsWarUtil.isForbitWarByInBorn() then
		SoraDShowMsgTip(i18n("remains_text_142"))
		return
	end
	if worldMapDefine.isInAtlantis() then
		local atlantisWarUtil = include("atlantisWarUtil")
		if not atlantisWarUtil.checkCanJoinMass(data.massData, true) then
			return
		end
	end
	if worldMapDefine.isInNebulaEmperor() then
		local nebulaEmperorUtil = include("nebulaEmperorUtil")
		if nebulaEmperorUtil.isForbitWarByInBorn() then
			SoraDShowMsgTip(i18n("nebulaemperor_text_220"))
			return
		end
	end
	if worldMapDefine.isInNebulaAllStar() then
		local nebulaAllStarUtil = include("nebulaAllStarUtil")
		local ok, errTip = nebulaAllStarUtil.checkSelfCityPos()
		if not ok then
			return SoraDShowMsgTip(errTip)
		end
	end
	return true
end
_ENV, worldMapWarDef.showMassErrMsgTip = function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if warType_config[mapClassType] then
		SoraDShowMsgTip(i18n(warType_config[mapClassType]))
	end
end, function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if warType_config[mapClassType] then
		SoraDShowMsgTip(i18n(warType_config[mapClassType]))
	end
end
local (function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if warType_config[mapClassType] then
		SoraDShowMsgTip(i18n(warType_config[mapClassType]))
	end
end)[gKingdomClassType.nebula], warType_config = "nebula_war_text_0323", function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if warType_config[mapClassType] then
		SoraDShowMsgTip(i18n(warType_config[mapClassType]))
	end
end
_ENV, worldMapWarDef.isInWarForbidCampMark = function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if warType_config[mapClassType] then
		return true
	end
end, function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if warType_config[mapClassType] then
		return true
	end
end
;(function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if warType_config[mapClassType] then
		return true
	end
end)[gKingdomClassType.legendLord] = true
;(function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if warType_config[mapClassType] then
		return true
	end
end)[gKingdomClassType.radiance] = true
;(function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if warType_config[mapClassType] then
		return true
	end
end)[gKingdomClassType.atlantis] = true
;(function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if warType_config[mapClassType] then
		return true
	end
end)[gKingdomClassType.nebula] = true
;(function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if warType_config[mapClassType] then
		return true
	end
end)[gKingdomClassType.nebulaEmperor] = true
;(function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if warType_config[mapClassType] then
		return true
	end
end)[gKingdomClassType.nebulaAllStar] = true
;(function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if warType_config[mapClassType] then
		return true
	end
end)[gKingdomClassType.roaringFlame] = true
local (function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if warType_config[mapClassType] then
		return true
	end
end)[gKingdomClassType.simulatedDrill], warType_config = true, function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if warType_config[mapClassType] then
		return true
	end
end
_ENV, worldMapWarDef.initArmyWarType = function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if warType_config[mapClassType] then
		local armyCtrl = SoraDGetCtrl("armyCtrl")
		armyCtrl:setWarType(mapClassType)
	end
end, function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if warType_config[mapClassType] then
		local armyCtrl = SoraDGetCtrl("armyCtrl")
		armyCtrl:setWarType(mapClassType)
	end
end
;(function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if warType_config[mapClassType] then
		local armyCtrl = SoraDGetCtrl("armyCtrl")
		armyCtrl:setWarType(mapClassType)
	end
end)[gKingdomClassType.radiance] = true
;(function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if warType_config[mapClassType] then
		local armyCtrl = SoraDGetCtrl("armyCtrl")
		armyCtrl:setWarType(mapClassType)
	end
end)[gKingdomClassType.nebula] = true
;(function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if warType_config[mapClassType] then
		local armyCtrl = SoraDGetCtrl("armyCtrl")
		armyCtrl:setWarType(mapClassType)
	end
end)[gKingdomClassType.nebulaEmperor] = true
;(function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if warType_config[mapClassType] then
		local armyCtrl = SoraDGetCtrl("armyCtrl")
		armyCtrl:setWarType(mapClassType)
	end
end)[gKingdomClassType.nebulaAllStar] = true
local (function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if warType_config[mapClassType] then
		local armyCtrl = SoraDGetCtrl("armyCtrl")
		armyCtrl:setWarType(mapClassType)
	end
end)[gKingdomClassType.simulatedDrill], warType_config = true, function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if warType_config[mapClassType] then
		local armyCtrl = SoraDGetCtrl("armyCtrl")
		armyCtrl:setWarType(mapClassType)
	end
end
function worldMapWarDef.openHeroTrainListView(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if warType_config[mapClassType] then
		SoraDShowMsgTip(i18n("common_text_3302"))
	else
		local cityCtrl = SoraDGetCtrl("cityCtrl")
		local buildCell = cityCtrl:getBuildCell(BUILDID.HERO_TRAIN_GROUND, 0)
		if buildCell then
			uiManager:show("HeroTrainList")
		else
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			_ENV = i18n("common_text_3302")
			i18n("common_text_3302").bid = BUILDID.HERO_TRAIN_GROUND
			i18n("common_text_3302").lv = 1
			mildGuideManager:starToUpgrade(i18n("common_text_3302"))
		end
	end
end
function worldMapWarDef.getAllianceBattlePeopleAdd(...)
	local alliance_sci_add = 0
	if worldMapDefine.isInRemains() then
		alliance_sci_add = _G.RUINS_BUFF.ARMY_PEOPLE_COUNT
	elseif worldMapWarDef.checkFullAllianceScience() then
		alliance_sci_add = _G.LEGEND_WAR_BUFF.ARMY_PEOPLE_COUNT
	else
		local allianceScience = SoraDGetCtrl("allianceScience")
		alliance_sci_add = allianceScience:getScienceAddValue(gAScienceType.ALLIANCE_ARMY_PEOPLE_COUNT)
	end
	return alliance_sci_add or 0
end
function worldMapWarDef.getHallOfWarArmyCount()
	local alliance_sci_add = 0
	if worldMapDefine.isInRemains() then
		alliance_sci_add = _G.RUINS_BUFF.HALLOF_WAR_CAPACITY
	elseif worldMapWarDef.checkFullAllianceScience() then
		alliance_sci_add = _G.LEGEND_WAR_BUFF.HALLOF_WAR_CAPACITY
	else
		local allianceScience = SoraDGetCtrl("allianceScience")
		alliance_sci_add = allianceScience:getScienceAddValue(gAScienceType.HALLOFWAR_ARMY_COUNT)
	end
	return alliance_sci_add or 0
end
_ENV, worldMapWarDef.getEmbassyReinforcements = function(...)
	local alliance_sci_add = 0
	if worldMapDefine.isInRemains() then
		alliance_sci_add = _G.RUINS_BUFF.EMBASSY_REINFORCEMENTS
	elseif worldMapWarDef.checkFullAllianceScience() then
		alliance_sci_add = _G.LEGEND_WAR_BUFF.EMBASSY_REINFORCEMENTS
	else
		local allianceScience = SoraDGetCtrl("allianceScience")
		alliance_sci_add = allianceScience:getScienceAddValue(gAScienceType.REINFORCEMENTS_MAX_COUNT)
	end
	return alliance_sci_add or 0
end, function(...)
	local alliance_sci_add = 0
	if worldMapDefine.isInRemains() then
		alliance_sci_add = _G.RUINS_BUFF.EMBASSY_REINFORCEMENTS
	elseif worldMapWarDef.checkFullAllianceScience() then
		alliance_sci_add = _G.LEGEND_WAR_BUFF.EMBASSY_REINFORCEMENTS
	else
		local allianceScience = SoraDGetCtrl("allianceScience")
		alliance_sci_add = allianceScience:getScienceAddValue(gAScienceType.REINFORCEMENTS_MAX_COUNT)
	end
	return alliance_sci_add or 0
end
;(function(...)
	local alliance_sci_add = 0
	if worldMapDefine.isInRemains() then
		alliance_sci_add = _G.RUINS_BUFF.EMBASSY_REINFORCEMENTS
	elseif worldMapWarDef.checkFullAllianceScience() then
		alliance_sci_add = _G.LEGEND_WAR_BUFF.EMBASSY_REINFORCEMENTS
	else
		local allianceScience = SoraDGetCtrl("allianceScience")
		alliance_sci_add = allianceScience:getScienceAddValue(gAScienceType.REINFORCEMENTS_MAX_COUNT)
	end
	return alliance_sci_add or 0
end)[gKingdomClassType.remains] = true
;(function(...)
	local alliance_sci_add = 0
	if worldMapDefine.isInRemains() then
		alliance_sci_add = _G.RUINS_BUFF.EMBASSY_REINFORCEMENTS
	elseif worldMapWarDef.checkFullAllianceScience() then
		alliance_sci_add = _G.LEGEND_WAR_BUFF.EMBASSY_REINFORCEMENTS
	else
		local allianceScience = SoraDGetCtrl("allianceScience")
		alliance_sci_add = allianceScience:getScienceAddValue(gAScienceType.REINFORCEMENTS_MAX_COUNT)
	end
	return alliance_sci_add or 0
end)[gKingdomClassType.legendLord] = true
;(function(...)
	local alliance_sci_add = 0
	if worldMapDefine.isInRemains() then
		alliance_sci_add = _G.RUINS_BUFF.EMBASSY_REINFORCEMENTS
	elseif worldMapWarDef.checkFullAllianceScience() then
		alliance_sci_add = _G.LEGEND_WAR_BUFF.EMBASSY_REINFORCEMENTS
	else
		local allianceScience = SoraDGetCtrl("allianceScience")
		alliance_sci_add = allianceScience:getScienceAddValue(gAScienceType.REINFORCEMENTS_MAX_COUNT)
	end
	return alliance_sci_add or 0
end)[gKingdomClassType.atlantis] = true
;(function(...)
	local alliance_sci_add = 0
	if worldMapDefine.isInRemains() then
		alliance_sci_add = _G.RUINS_BUFF.EMBASSY_REINFORCEMENTS
	elseif worldMapWarDef.checkFullAllianceScience() then
		alliance_sci_add = _G.LEGEND_WAR_BUFF.EMBASSY_REINFORCEMENTS
	else
		local allianceScience = SoraDGetCtrl("allianceScience")
		alliance_sci_add = allianceScience:getScienceAddValue(gAScienceType.REINFORCEMENTS_MAX_COUNT)
	end
	return alliance_sci_add or 0
end)[gKingdomClassType.nebula] = true
;(function(...)
	local alliance_sci_add = 0
	if worldMapDefine.isInRemains() then
		alliance_sci_add = _G.RUINS_BUFF.EMBASSY_REINFORCEMENTS
	elseif worldMapWarDef.checkFullAllianceScience() then
		alliance_sci_add = _G.LEGEND_WAR_BUFF.EMBASSY_REINFORCEMENTS
	else
		local allianceScience = SoraDGetCtrl("allianceScience")
		alliance_sci_add = allianceScience:getScienceAddValue(gAScienceType.REINFORCEMENTS_MAX_COUNT)
	end
	return alliance_sci_add or 0
end)[gKingdomClassType.nebulaEmperor] = true
;(function(...)
	local alliance_sci_add = 0
	if worldMapDefine.isInRemains() then
		alliance_sci_add = _G.RUINS_BUFF.EMBASSY_REINFORCEMENTS
	elseif worldMapWarDef.checkFullAllianceScience() then
		alliance_sci_add = _G.LEGEND_WAR_BUFF.EMBASSY_REINFORCEMENTS
	else
		local allianceScience = SoraDGetCtrl("allianceScience")
		alliance_sci_add = allianceScience:getScienceAddValue(gAScienceType.REINFORCEMENTS_MAX_COUNT)
	end
	return alliance_sci_add or 0
end)[gKingdomClassType.nebulaAllStar] = true
;(function(...)
	local alliance_sci_add = 0
	if worldMapDefine.isInRemains() then
		alliance_sci_add = _G.RUINS_BUFF.EMBASSY_REINFORCEMENTS
	elseif worldMapWarDef.checkFullAllianceScience() then
		alliance_sci_add = _G.LEGEND_WAR_BUFF.EMBASSY_REINFORCEMENTS
	else
		local allianceScience = SoraDGetCtrl("allianceScience")
		alliance_sci_add = allianceScience:getScienceAddValue(gAScienceType.REINFORCEMENTS_MAX_COUNT)
	end
	return alliance_sci_add or 0
end)[gKingdomClassType.roaringFlame] = true
local (function(...)
	local alliance_sci_add = 0
	if worldMapDefine.isInRemains() then
		alliance_sci_add = _G.RUINS_BUFF.EMBASSY_REINFORCEMENTS
	elseif worldMapWarDef.checkFullAllianceScience() then
		alliance_sci_add = _G.LEGEND_WAR_BUFF.EMBASSY_REINFORCEMENTS
	else
		local allianceScience = SoraDGetCtrl("allianceScience")
		alliance_sci_add = allianceScience:getScienceAddValue(gAScienceType.REINFORCEMENTS_MAX_COUNT)
	end
	return alliance_sci_add or 0
end)[gKingdomClassType.simulatedDrill], warType_config = true, function(...)
	local alliance_sci_add = 0
	if worldMapDefine.isInRemains() then
		alliance_sci_add = _G.RUINS_BUFF.EMBASSY_REINFORCEMENTS
	elseif worldMapWarDef.checkFullAllianceScience() then
		alliance_sci_add = _G.LEGEND_WAR_BUFF.EMBASSY_REINFORCEMENTS
	else
		local allianceScience = SoraDGetCtrl("allianceScience")
		alliance_sci_add = allianceScience:getScienceAddValue(gAScienceType.REINFORCEMENTS_MAX_COUNT)
	end
	return alliance_sci_add or 0
end
_ENV, worldMapWarDef.checkFullAllianceScience = function(...)
	local mapClassType = SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	return warType_config[mapClassType]
end, function(...)
	local mapClassType = SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	return warType_config[mapClassType]
end
;(function(...)
	local mapClassType = SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	return warType_config[mapClassType]
end)[gKingdomClassType.legendLord] = true
;(function(...)
	local mapClassType = SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	return warType_config[mapClassType]
end)[gKingdomClassType.radiance] = true
;(function(...)
	local mapClassType = SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	return warType_config[mapClassType]
end)[gKingdomClassType.atlantis] = true
;(function(...)
	local mapClassType = SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	return warType_config[mapClassType]
end)[gKingdomClassType.nebula] = true
;(function(...)
	local mapClassType = SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	return warType_config[mapClassType]
end)[gKingdomClassType.nebulaEmperor] = true
;(function(...)
	local mapClassType = SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	return warType_config[mapClassType]
end)[gKingdomClassType.nebulaAllStar] = true
;(function(...)
	local mapClassType = SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	return warType_config[mapClassType]
end)[gKingdomClassType.roaringFlame] = true
local (function(...)
	local mapClassType = SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	return warType_config[mapClassType]
end)[gKingdomClassType.simulatedDrill], warType_config = true, function(...)
	local mapClassType = SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	return warType_config[mapClassType]
end
_ENV, worldMapWarDef.showWarViewActivityTag = function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	return not warType_config[mapClassType]
end, function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	return not warType_config[mapClassType]
end
;(function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	return not warType_config[mapClassType]
end)[gKingdomClassType.pyramid] = "worldMapPyramidLodUI"
;(function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	return not warType_config[mapClassType]
end)[gKingdomClassType.nebula] = "worldMapNebulaLodUI"
;(function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	return not warType_config[mapClassType]
end)[gKingdomClassType.atlantis] = "worldMapAtlantisLodUI"
;(function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	return not warType_config[mapClassType]
end)[gKingdomClassType.nebulaEmperor] = "worldMapNebulaEmperorLodUI"
;(function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	return not warType_config[mapClassType]
end)[gKingdomClassType.nebulaAllStar] = "worldMapNebulaAllStarLodUI"
;(function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	return not warType_config[mapClassType]
end)[gKingdomClassType.roaringFlame] = "worldMapRoaringFlameLodUI"
;(function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	return not warType_config[mapClassType]
end)[gKingdomClassType.simulatedDrill] = "worldMapSimulatedDrillLodUI"
local (function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	return not warType_config[mapClassType]
end)[gKingdomClassType.garden], warType_config = "worldMapSimulatedDrillLodUI", function(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	return not warType_config[mapClassType]
end
_ENV, worldMapWarDef.getWarLodUIName = function(...)
	local mapClassType = worldMapDefine.getKingdomMapClassByKingdomId()
	return warType_config[mapClassType] or "worldMapNormalLodUI"
end, function(...)
	local mapClassType = worldMapDefine.getKingdomMapClassByKingdomId()
	return warType_config[mapClassType] or "worldMapNormalLodUI"
end
;(function(...)
	local mapClassType = worldMapDefine.getKingdomMapClassByKingdomId()
	return warType_config[mapClassType] or "worldMapNormalLodUI"
end)[gKingdomClassType.nebulaEmperor] = "lod_nebulaEmperor_map.png"
;(function(...)
	local mapClassType = worldMapDefine.getKingdomMapClassByKingdomId()
	return warType_config[mapClassType] or "worldMapNormalLodUI"
end)[gKingdomClassType.nebulaAllStar] = "lod_nebulaAllStar_map.png"
;(function(...)
	local mapClassType = worldMapDefine.getKingdomMapClassByKingdomId()
	return warType_config[mapClassType] or "worldMapNormalLodUI"
end)[gKingdomClassType.roaringFlame] = "lod_roaringFlame_map.png"
;(function(...)
	local mapClassType = worldMapDefine.getKingdomMapClassByKingdomId()
	return warType_config[mapClassType] or "worldMapNormalLodUI"
end)[gKingdomClassType.simulatedDrill] = "lod_simulatedDrill_map.png"
local (function(...)
	local mapClassType = worldMapDefine.getKingdomMapClassByKingdomId()
	return warType_config[mapClassType] or "worldMapNormalLodUI"
end)[gKingdomClassType.garden], warType_config = "lod_garden_map.png", function(...)
	local mapClassType = worldMapDefine.getKingdomMapClassByKingdomId()
	return warType_config[mapClassType] or "worldMapNormalLodUI"
end
function worldMapWarDef.getWarLodMapName(...)
	local mapClassType = worldMapDefine.getKingdomMapClassByKingdomId()
	return warType_config[mapClassType]
end
function worldMapWarDef.getAllianceWarViewTitle(...)
	if worldMapDefine.isInNebulaEmperor() or worldMapDefine.isInNebulaAllStar() then
		return i18n("nebulaemperor_text_50"), i18n("nebulaemperor_text_206")
	elseif worldMapDefine.isInRoaringFlame() then
		return i18n("flames_dunes_text76"), i18n("flames_dunes_text239")
	elseif worldMapDefine.isInTeamStatus() then
		return i18n("free_team_text_47"), i18n("free_team_text_71")
	elseif worldMapDefine.isInSimulatedDrill() then
		local kingdomName = worldMapWarDef.getKingdomNameByClassType(gKingdomClassType.simulatedDrill)
		return kingdomName, i18n("flames_dunes_text239")
	else
		return i18n("common_text_047"), i18n("common_text_305")
	end
end
function worldMapWarDef.getSpeedUpBattleExclusive(...)
	_UPVALUE7_ = nil
	;(nil)[1] = _G.ITEM_BATTLEEXCLUSIVE_SPEEDUP
	;(nil)[2] = _G.ITEM_ATLANTISWAR_SPEEDUP
	;(nil)[3] = _G.ITEM_NEBULA_EMPEROR_SPEEDUP
	;(nil)[4] = _G.NEBULA_ALLSTAR_WAR_SPEEDUP_ITEM_ID
	;(nil)[5] = _G.ITEM_ROARING_FLAME_SPEEDUP
	;(nil)[6] = _G.ITEM_ROARING_FLAME_FREE_SPEEDUP
	local (nil)[7], battleExclusive = _G.SIMULATED_DRILL_WAR_SPEEDUP_ITEM_ID, nil
	return battleExclusive
end
function worldMapWarDef.buySpeedUpItem(itemID)
	if ITEM_BATTLEEXCLUSIVE_SPEEDUP == itemID then
		if worldMapDefine.isKingStarMapId(worldMapDefine.currentMapKindomID) then
			SoraDCreatePanelByFixName("kingStarShopView"):show()
		else
			SoraDCreatePanel("legendaryShopView"):show()
		end
		return true
	elseif ITEM_ATLANTISWAR_SPEEDUP == itemID then
		local atlantisWarUtil = include("atlantisWarUtil")
		atlantisWarUtil.openExchangeShop()
		return true
	elseif ITEM_NEBULA_EMPEROR_SPEEDUP == itemID then
		local nebulaEmperorUtil = include("nebulaEmperorUtil")
		nebulaEmperorUtil.openGiftView()
		return true
	elseif NEBULA_ALLSTAR_WAR_SPEEDUP_ITEM_ID == itemID then
		local nebulaAllStarUtil = include("nebulaAllStarUtil")
		nebulaAllStarUtil.openGiftView()
		return true
	end
	_ENV = nebulaAllStarUtil
	include("nebulaAllStarUtil")[ITEM_ROARING_FLAME_SPEEDUP] = true
	local include("nebulaAllStarUtil")[ITEM_ROARING_FLAME_FREE_SPEEDUP], config = true, include("nebulaAllStarUtil")
	if config[itemID] then
		_ENV = nil
		;(nil).itemID = itemID
		uiManager:show("CommonSourceGuide", nil)
		return true
	end
	return false
end
function worldMapWarDef.checkBattleSpeedUpItem(itemID)
	if itemID == ITEM_BATTLEEXCLUSIVE_SPEEDUP then
		return worldMapDefine.isInLegendLord()
	end
	if itemID == ITEM_ATLANTISWAR_SPEEDUP then
		local atlantisWarUtil = include("atlantisWarUtil")
		return worldMapDefine.isInAtlantis() and not atlantisWarUtil.isNewMap()
	end
	if itemID == ITEM_NEBULA_EMPEROR_SPEEDUP then
		local nebulaEmperorUtil = include("nebulaEmperorUtil")
		return worldMapDefine.isInNebulaEmperor() and not nebulaEmperorUtil.isWarTest()
	end
	if itemID == NEBULA_ALLSTAR_WAR_SPEEDUP_ITEM_ID then
		return worldMapDefine.isInNebulaAllStar()
	end
	if itemID == SIMULATED_DRILL_WAR_SPEEDUP_ITEM_ID then
		return worldMapDefine.isInSimulatedDrill()
	end
	_ENV = worldMapDefine.isInSimulatedDrill
	worldMapDefine.isInSimulatedDrill[ITEM_ROARING_FLAME_SPEEDUP] = true
	local worldMapDefine.isInSimulatedDrill[ITEM_ROARING_FLAME_FREE_SPEEDUP], config = true, worldMapDefine.isInSimulatedDrill
	if config[itemID] then
		if worldMapDefine.isInRoaringFlame() then
			return true
		end
		local atlantisWarUtil = include("atlantisWarUtil")
		if atlantisWarUtil.isNewMap() then
			return worldMapDefine.isInAtlantis()
		end
	end
end
function worldMapWarDef.createSpeedUpBattleExcluseive(itemID)
	if worldMapWarDef.checkBattleSpeedUpItem(itemID) then
		local backpackCtrl = SoraDGetCtrl("backpackCtrl")
		local itemCount = backpackCtrl:getItemCount(itemID)
		worldMapWarDef = backpackCtrl
		backpackCtrl.iid = itemID
		backpackCtrl.count = itemCount
		local backpackCtrl.isbattleExclusive, ret = true, backpackCtrl
		if itemID == SIMULATED_DRILL_WAR_SPEEDUP_ITEM_ID then
			ret.isUseOnly = true
		end
		return ret
	end
end
function worldMapWarDef.getPackageName(officialType, gitfID, mapid)
	if officialType == gShowOfficialType.KING then
		local kingPacksRead = include("kingPacksRead")
		local giftInfo = kingPacksRead.getItem(gitfID)
		return i18n(giftInfo.name or "common_text_1189")
	elseif officialType == gShowOfficialType.LEGEND then
		local legendKingRead = include("legendKingRead")
		return legendKingRead.getPackageName(gitfID)
	elseif officialType == gShowOfficialType.KINGSTAR then
		local legendKingRead = include("legendKingRead")
		return legendKingRead.getPackageName(gitfID, mapid)
	elseif officialType == gShowOfficialType.HEGEMON then
		local hegemonRead = include("hegemonRead")
		return hegemonRead.getPackageName(gitfID)
	elseif officialType == gShowOfficialType.ATLANTIS then
		local atlantisActivityRead = include("atlantisActivityRead")
		return atlantisActivityRead.getPackageName(gitfID)
	elseif officialType == gShowOfficialType.NEBULA then
		local nebulaPrivilegelRead = include("nebulaPrivilegelRead")
		return nebulaPrivilegelRead.getPackageName(gitfID)
	elseif officialType == gShowOfficialType.NEBULA_EMPEROR then
		local nebulaEmperorRead = include("nebulaEmperorRead")
		return nebulaEmperorRead.getPackageName(gitfID)
	end
end
function worldMapWarDef.getWarCrystalID(warType)
	gKingdomClassType = nil
	;(nil)[gKingdomClassType.normal] = gIDDef.METEOR_CRYSTAL
	;(nil)[gKingdomClassType.legendLord] = gIDDef.LEGEND_CRYSTAL
	local (nil)[gKingdomClassType.nebulaEmperor], warType_config = gIDDef.NEBULA_CRYSTAL, nil
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = warType or kingdomMapCtrl:getKingdomClass()
	return warType_config[mapClassType]
end
function worldMapWarDef.checkIsWarCrystalID(itemID)
	_ENV = nil
	;(nil)[gIDDef.METEOR_CRYSTAL] = true
	;(nil)[gIDDef.LEGEND_CRYSTAL] = true
	local (nil)[gIDDef.NEBULA_CRYSTAL], config = true, nil
	return config[itemID] or false
end
function worldMapWarDef.checkCanUseMeteorCrystal(...)
	local constantRead = include("constantRead")
	if worldMapDefine.isInNebulaEmperor() then
		return not constantRead.checkNebulaEmperorMeteorCrystal()
	end
	return true
end
_ENV, worldMapWarDef.showMeteorCrystalTip = "showMeteorCrystalTip", function(...)
	if worldMapDefine.isInNebulaEmperor() then
		SoraDShowMsgBox(i18n("nebulaemperor_text_244"), i18n("common_text_477"), i18n("common_text_185"), function(eventType)
			if eventType == MSGBOX_CALLBACK_YES then
				local nebulaEmperorUtil = include("nebulaEmperorUtil")
				nebulaEmperorUtil.openGiftView()
			end
		end)
	end
end
;("showMeteorCrystalTip")[gKingdomClassType.legendLord] = true
;("showMeteorCrystalTip")[gKingdomClassType.remains] = true
;("showMeteorCrystalTip")[gKingdomClassType.radiance] = true
;("showMeteorCrystalTip")[gKingdomClassType.atlantis] = true
;("showMeteorCrystalTip")[gKingdomClassType.nebula] = true
;("showMeteorCrystalTip")[gKingdomClassType.nebulaEmperor] = true
;("showMeteorCrystalTip")[gKingdomClassType.nebulaAllStar] = true
;("showMeteorCrystalTip")[gKingdomClassType.roaringFlame] = true
local ("showMeteorCrystalTip")[gKingdomClassType.simulatedDrill], warType_config = true, "showMeteorCrystalTip"
function worldMapWarDef.isInWarForbidMarket()
	return isInWarForbid_imp(warType_config, true)
end
function worldMapWarDef.openHospitalView(...)
	local queueCtrl = SoraDGetCtrl("queueCtrl")
	if queueCtrl:queryQueue(gQueueTypeDef.hostpital_queue) then
		SoraDShowMsgTip(i18n("common_text_768"))
	else
		uiManager:show("HospitalView"):setLV()
	end
end
function worldMapWarDef.clickHospitalView(mapClassType)
	local armyCtrl = SoraDGetCtrl("armyCtrl")
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local queueCtrl = SoraDGetCtrl("queueCtrl")
	mapClassType = mapClassType or gKingdomClassType.normal
	local queueType = worldMapWarDef.getHostpitalQueueType(mapClassType)
	if armyCtrl:getCuringArmyCount(queueType) > 0 then
		local itemType = worldMapWarDef.getItemTypeByQueueType(queueType)
		local speedUpItemList = backpackCtrl:getSpeedUpItemList(itemType)
		if 0 < #speedUpItemList then
			SoraDShowSpeedUpByItemBox(queueType)
		else
			local queue = queueCtrl:queryQueue(queueType)
			SoraDShowSpeedUpBox(queue)
		end
	else
		uiManager:show("HospitalView"):setLV(nil, mapClassType)
	end
end
function worldMapWarDef.getNameColor(data)
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	local selfPlayerID = gametop.playertop_:getPlayerID() or 0
	local selfLeagueID = allianceMgr:getOwnTeamID()
	local playerID = data.playerID
	local leagueID = data.leagueID
	if worldMapDefine.isInNebula() then
		return worldMapWarDef.getNameColorInNebula(data)
	elseif worldMapDefine.isInNebulaAllStar(true) then
		local nebulaAllStarRead = include("nebulaAllStarRead")
		return nebulaAllStarRead.getCampColorRGB(data.camp)
	end
	if playerID == selfPlayerID then
		return worldMapDefine.getSelfManorLineColor()
	end
	if worldMapDefine.isInRoaringFlame() then
		local roaringFlameWarRead = include("roaringFlameWarRead")
		return roaringFlameWarRead.getCampColor(data.camp)
	elseif worldMapDefine.isInSimulatedDrill() then
		local simulatedDrillUtil = include("simulatedDrillUtil")
		return simulatedDrillUtil.getPlayerNameColor(data.camp)
	end
	if leagueID and 0 < leagueID and leagueID == selfLeagueID then
		return worldMapDefine.getLeagueManorLineColor(true)
	elseif worldMapDefine.isInNebulaEmperor() then
		return worldMapDefine.getLeagueManorLineColor(nil, gMapAllianceRelationType.ENEMY)
	else
		local allianceRelationCtrl = SoraDGetCtrl("allianceRelationCtrl")
		local allianceRelationType = allianceRelationCtrl:getRelationTypeWith(leagueID)
		return worldMapDefine.getLeagueManorLineColor(nil, allianceRelationType)
	end
end
function worldMapWarDef.getNameColorInNebula(data)
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	local selfPlayerID = gametop.playertop_:getPlayerID() or 0
	local selfLeagueID = allianceMgr:getOwnTeamID()
	local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
	local selfCamp = nebulaActivityCtrl:getSelfCamp()
	local playerID = data.playerID
	local leagueID = data.leagueID
	local camp = data.camp
	local nameColor
	if playerID == selfPlayerID then
		nameColor = cc.c3b(76, 230, 26)
	elseif leagueID == selfLeagueID then
		nameColor = cc.c3b(0, 185, 255)
	elseif camp == selfCamp then
		nameColor = cc.c3b(255, 242, 197)
	else
		nameColor = cc.c3b(224, 43, 43)
	end
	return nameColor
end
local gMapMoveLineColor = _G.gMapMoveLineColor
function worldMapWarDef.getCastleImageColor(data)
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	local selfPlayerID = gametop.playertop_:getPlayerID() or 0
	local selfLeagueID = allianceMgr:getOwnTeamID()
	local selfKid = gametop.playertop_:getKingdomID()
	local playerID = data.playerID
	local leagueID = data.leagueID
	local kingdomId = data.kingdomId
	local leagueRank = data.leagueRank
	if playerID == selfPlayerID then
		return gMapMoveLineColor.moveLineColorGreen
	end
	if worldMapDefine.isInRoaringFlame() then
		return gMapMoveLineColor.moveLineColorBlue
	end
	if worldMapDefine.isInAtlantis() then
		if kingdomId == selfKid then
			return gMapMoveLineColor.moveLineColorBlue
		else
			return gMapMoveLineColor.moveLineColorRed
		end
	end
	if worldMapDefine.isInNebulaEmperor() then
		if leagueID == selfLeagueID then
			return gMapMoveLineColor.moveLineColorBlue
		else
			return gMapMoveLineColor.moveLineColorRed
		end
	end
	if leagueID == selfLeagueID then
		if worldMapDefine.isInNebula() then
			return gMapMoveLineColor.moveLineColorBlue
		end
		if leagueRank and leagueRank == gAllianceRank.R5 then
			return gMapMoveLineColor.moveLineColorPurple
		else
			return gMapMoveLineColor.moveLineColorBlue
		end
	end
	local allianceRelationCtrl = SoraDGetCtrl("allianceRelationCtrl")
	local allianceRelationType = allianceRelationCtrl:getRelationTypeWith(leagueID)
	if allianceRelationType == gMapAllianceRelationType.ALLY then
		return gMapMoveLineColor.moveLineColorAzure
	elseif allianceRelationType == gMapAllianceRelationType.FRIENDLY then
		return gMapMoveLineColor.moveLineColorYellow
	elseif allianceRelationType == gMapAllianceRelationType.ENEMY then
		return gMapMoveLineColor.moveLineColorRed
	else
		return gMapMoveLineColor.moveLineColorWhite
	end
	return gMapMoveLineColor.moveLineColorWhite
end
function worldMapWarDef.getCastleImage(data)
	local imageColor = worldMapWarDef.getCastleImageColor(data)
	worldMapWarDef = data
	_UPVALUE2_ = nil
	data[gMapMoveLineColor.moveLineColorWhite], (nil)[1] = nil, "lod_playerBaseBuildGray.png"
	data[gMapMoveLineColor.moveLineColorWhite], (nil)[2] = nil, "lod_base_gary.png"
	_UPVALUE2_ = nil
	data[gMapMoveLineColor.moveLineColorGreen], (nil)[1] = nil, "lod_playerBaseBuildGreen.png"
	data[gMapMoveLineColor.moveLineColorGreen], (nil)[2] = nil, "lod_base_green.png"
	_UPVALUE2_ = nil
	data[gMapMoveLineColor.moveLineColorRed], (nil)[1] = nil, "lod_playerBaseBuildRed.png"
	data[gMapMoveLineColor.moveLineColorRed], (nil)[2] = nil, "lod_base_red.png"
	_UPVALUE2_ = nil
	data[gMapMoveLineColor.moveLineColorPurple], (nil)[1] = nil, "lod_playerBaseBuildPurple.png"
	data[gMapMoveLineColor.moveLineColorPurple], (nil)[2] = nil, "lod_base_purple.png"
	_UPVALUE2_ = nil
	data[gMapMoveLineColor.moveLineColorBlue], (nil)[1] = nil, "lod_playerBaseBuildBlue.png"
	data[gMapMoveLineColor.moveLineColorBlue], (nil)[2] = nil, "lod_base_blue.png"
	_UPVALUE2_ = nil
	data[gMapMoveLineColor.moveLineColorYellow], (nil)[1] = nil, "lod_playerBaseBuildYellow.png"
	data[gMapMoveLineColor.moveLineColorYellow], (nil)[2] = nil, "lod_base_yellow.png"
	_UPVALUE2_ = nil
	data[gMapMoveLineColor.moveLineColorAzure], (nil)[1] = nil, "lod_playerBaseBuildAzure.png"
	data[gMapMoveLineColor.moveLineColorAzure], (nil)[2] = nil, "lod_base_Azure.png"
	local config = data
	local cfg = config[imageColor]
	return cfg[1], cfg[2]
end
function worldMapWarDef.checkIsInWarFog(tilePos)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if mapClassType == gKingdomClassType.nebulaEmperor then
		local nebulaEmperorUtil = include("nebulaEmperorUtil")
		return nebulaEmperorUtil.checkIsInWarFog(tilePos)
	end
	return false
end
function worldMapWarDef.isMonsterCanKill(...)
	return worldMapDefine.isInRemains() or worldMapDefine.isInNebula() or worldMapDefine.isInRoaringFlame()
end
function worldMapWarDef.getMainUIBottomPosY(...)
	local offset = 20
	local fitHeight = 1136
	local fitWidth = fitHeight / display.height * 640
	local fitScale = fitHeight <= display.height and 1 or 640 / fitWidth
	local posy = -240 + offset
	if worldMapDefine.isInLegendLord() then
		posy = -420 + offset
	elseif worldMapDefine.isInRemains() then
		posy = (-180 + offset) * fitScale - 400
	elseif worldMapDefine.isInRadiance() then
		posy = (-180 + offset) * fitScale - 400
	elseif worldMapDefine.isInAtlantis() then
		local worldMap = SoraDCurrentSceneShowView("worldMapView")
		if worldMap and worldMap.getBottomQuestBtnsOffsetY then
			posy = -worldMap:getBottomQuestBtnsOffsetY() + offset - 225
		else
			posy = (-180 + offset) * fitScale - 400
		end
	elseif worldMapDefine.isInNebula() then
		posy = -400 + offset
	elseif worldMapDefine.isInNebulaEmperor() then
		posy = -470 + offset
	elseif worldMapDefine.isInNebulaAllStar(true) then
		local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
		local myTeamInfo = nebulaAllStarCtrl:getMyTeamInfo()
		if myTeamInfo:getIsSuperTeam() then
			posy = offset - 530 - 83
		elseif myTeamInfo:getIsBackupTeam() then
			posy = offset - 530
		else
			posy = offset - 480
		end
	elseif worldMapDefine.isInRoaringFlame() then
		posy = -470 + offset
	elseif worldMapDefine.isInPyramid() then
		posy = -320 + offset
	elseif worldMapDefine.isInSimulatedDrill() then
		posy = -420 + offset
	end
	return posy
end
function worldMapWarDef.isInMapClassType(mapClassType)
	return SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass() == mapClassType
end
function worldMapWarDef.isMapClassTypeKingdomID(kID, mapClassType)
	local _mapClassType = worldMapWarDef.getKingdomMapClassByKingdomId(kID)
	return _mapClassType == mapClassType
end
_ENV, worldMapWarDef.checkIsCanTransfer = "checkIsCanTransfer", function(mapClassType, showTilePoint)
	local selfManorRect = cc.rect(showTilePoint.x, showTilePoint.y, 0, 0)
	if mapClassType == gKingdomClassType.nebula then
		local nebulaWarUtil = include("nebulaWarUtil")
		return nebulaWarUtil.checkIsCanTransfer(selfManorRect)
	elseif mapClassType == gKingdomClassType.nebulaEmperor then
		local nebulaEmperorUtil = include("nebulaEmperorUtil")
		return nebulaEmperorUtil.checkIsCanTransfer(selfManorRect)
	elseif mapClassType == gKingdomClassType.nebulaAllStar then
		local nebulaAllStarUtil = include("nebulaAllStarUtil")
		return nebulaAllStarUtil.checkIsCanTransfer(selfManorRect)
	elseif mapClassType == gKingdomClassType.roaringFlame then
		local roaringFlameWarUtil = include("roaringFlameWarUtil")
		return roaringFlameWarUtil.checkIsCanTransfer(selfManorRect)
	elseif mapClassType == gKingdomClassType.simulatedDrill then
		local simulatedDrillUtil = include("simulatedDrillUtil")
		return simulatedDrillUtil.checkIsCanTransfer(selfManorRect)
	elseif mapClassType == gKingdomClassType.garden then
		local manorCityUtil = include("manorCityUtil")
		return manorCityUtil.checkIsCanTransfer(selfManorRect)
	else
		return true
	end
end
;("checkIsCanTransfer")[gKingdomClassType.atlantis] = true
;("checkIsCanTransfer")[gKingdomClassType.nebula] = true
;("checkIsCanTransfer")[gKingdomClassType.roaringFlame] = true
local ("checkIsCanTransfer")[gKingdomClassType.simulatedDrill], warType_config = true, "checkIsCanTransfer"
_ENV, worldMapWarDef.showWorldMapViewColorLayer = "showWorldMapViewColorLayer", function(...)
	local mapClassType = worldMapWarDef.getKingdomMapClassByKingdomId()
	return warType_config[mapClassType]
end
;("showWorldMapViewColorLayer")[gKingdomClassType.newTrial] = true
;("showWorldMapViewColorLayer")[gKingdomClassType.roaringFlame] = true
local ("showWorldMapViewColorLayer")[gKingdomClassType.garden], warType_config = true, "showWorldMapViewColorLayer"
_ENV, worldMapWarDef.isInWarForbidShowSafe = "isInWarForbidShowSafe", function()
	local mapClassType = SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	return warType_config[mapClassType]
end
;("isInWarForbidShowSafe")[gKingdomClassType.remains] = "remains_text_89"
;("isInWarForbidShowSafe")[gKingdomClassType.newTrial] = "devilvalley_tips_08"
;("isInWarForbidShowSafe")[gKingdomClassType.nebulaAllStar] = "NebulaAllstar_263"
;("isInWarForbidShowSafe")[gKingdomClassType.roaringFlame] = "flames_dunes_text302"
local ("isInWarForbidShowSafe")[gKingdomClassType.simulatedDrill], warType_config = true, "isInWarForbidShowSafe"
_ENV, worldMapWarDef.isInWarForbidUsePeaceShield = "isInWarForbidUsePeaceShield", function()
	local mapClassType = SoraDGetCtrl("kingdomMapCtrl"):getKingdomClass()
	local tipKey = warType_config[mapClassType]
	if tipKey then
		if type(tipKey) == "string" then
			SoraDShowMsgTip(i18n(tipKey))
		else
			local kingdomName = worldMapWarDef.getKingdomNameByClassType(mapClassType)
			_ENV = i18n(tipKey)
			i18n(tipKey).name = kingdomName
			SoraDShowMsgTip(i18n("common_text_4930", i18n(tipKey)))
		end
		return true
	end
	return false
end
;("isInWarForbidUsePeaceShield")[gActivityTimeActivityID.ITEM_REBATE_ACTIVITY1] = gActivityTimeActivityID.LEGEND_LORD
;("isInWarForbidUsePeaceShield")[gActivityTimeActivityID.ITEM_REBATE_ACTIVITY2] = gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY
;("isInWarForbidUsePeaceShield")[gActivityTimeActivityID.ITEM_REBATE_ACTIVITY3] = gActivityTimeActivityID.NEBULA_REGION_ACTIVITY
;("isInWarForbidUsePeaceShield")[gActivityTimeActivityID.ITEM_REBATE_ACTIVITY4] = gActivityTimeActivityID.KING_STAR_BATTLE
;("isInWarForbidUsePeaceShield")[gActivityTimeActivityID.ITEM_REBATE_ACTIVITY5] = gActivityTimeActivityID.KINGDOM_BATTLE
;("isInWarForbidUsePeaceShield")[gActivityTimeActivityID.ITEM_REBATE_ACTIVITY7] = gActivityTimeActivityID.ATLANTIS_WAR_ACTIVITY
local ("isInWarForbidUsePeaceShield")[gActivityTimeActivityID.ITEM_REBATE_ACTIVITY8], itemRebate2warActivityID = gActivityTimeActivityID.ROARING_FLAME_WAR_ACTIVITY, "isInWarForbidUsePeaceShield"
function worldMapWarDef.getItemRebateActivityIDMap()
	return itemRebate2warActivityID
end
function worldMapWarDef.getItemRebateWarActivityID(activityId)
	return itemRebate2warActivityID[activityId]
end
_ENV, worldMapWarDef.getItemRebateActivityIDInWar = "getItemRebateActivityIDInWar", function(...)
	if worldMapDefine.isInLegendLord() then
		local mapid = gametop.playertop_:getMapID()
		if not worldMapDefine.isKingStarMapId(mapid) then
			return gActivityTimeActivityID.ITEM_REBATE_ACTIVITY1
		else
			return gActivityTimeActivityID.ITEM_REBATE_ACTIVITY4
		end
	elseif worldMapDefine.isInNebulaEmperor() then
		return gActivityTimeActivityID.ITEM_REBATE_ACTIVITY2
	elseif worldMapDefine.isInNebula() then
		return gActivityTimeActivityID.ITEM_REBATE_ACTIVITY3
	elseif worldMapDefine.isInAtlantis() then
		return gActivityTimeActivityID.ITEM_REBATE_ACTIVITY7
	elseif worldMapDefine.isInRoaringFlame() then
		return gActivityTimeActivityID.ITEM_REBATE_ACTIVITY8
	end
	local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
	if conquestWarCtrl:isConquestWarOpenningAndNotInWar() then
		return gActivityTimeActivityID.ITEM_REBATE_ACTIVITY5
	end
end
;("getItemRebateActivityIDInWar")[gKingdomClassType.roaringFlame] = true
;("getItemRebateActivityIDInWar")[gKingdomClassType.simulatedDrill] = true
local ("getItemRebateActivityIDInWar")[gKingdomClassType.garden], warType_config = true, "getItemRebateActivityIDInWar"
_ENV, worldMapWarDef.isInWarShowZhanLing = "isInWarShowZhanLing", function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	return not warType_config[mapClassType]
end
local ("isInWarShowZhanLing")[gKingdomClassType.simulatedDrill], warType_config = true, "isInWarShowZhanLing"
_ENV, worldMapWarDef.isInWarShowQianCheng = "isInWarShowQianCheng", function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	return not warType_config[mapClassType]
end
local ("isInWarShowQianCheng")[gKingdomClassType.simulatedDrill], warType_config = true, "isInWarShowQianCheng"
_ENV, worldMapWarDef.isInWarForbidShowAllianceChat = "isInWarForbidShowAllianceChat", function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	return warType_config[mapClassType]
end
;("isInWarForbidShowAllianceChat")[gKingdomClassType.simulatedDrill] = true
local ("isInWarForbidShowAllianceChat")[gKingdomClassType.garden], warType_config = true, "isInWarForbidShowAllianceChat"
_ENV, worldMapWarDef.isInWarForbidMoveCastle = "isInWarForbidMoveCastle", function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	if warType_config[mapClassType] then
		SoraDShowMsgTip(i18n("remains_text_362"))
		return true
	end
end
local ("isInWarForbidMoveCastle")[gKingdomClassType.garden], warType_config = true, "isInWarForbidMoveCastle"
_ENV, worldMapWarDef.isInWarForbidShowWarLvEffect = "isInWarForbidShowWarLvEffect", function()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	return warType_config[mapClassType]
end
local ("isInWarForbidShowWarLvEffect")[gKingdomClassType.garden], warType_config = true, "isInWarForbidShowWarLvEffect"
function worldMapWarDef.isInWarForbidShowSign()
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	return warType_config[mapClassType]
end
return worldMapWarDef
