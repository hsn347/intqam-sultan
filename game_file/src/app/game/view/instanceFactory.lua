local _ENV, instanceFactory
local instanceCacheMgr = include("instanceCacheMgr")
local lodShow = include("instanceLodCfgShow")
local gMapObjTypeDef = _G.gMapObjTypeDef
local gWorldTypeServerDef = _G.gWorldTypeServerDef
local gMapNewTrialBuildType = _G.gMapNewTrialBuildType
local batchNode = worldMapDefine.GROU_ID
instanceFactory.batchNode = batchNode
local addWorldInstanceNormale = function(builder, config, worldMapCell, worldInstanceData)
	local worldInstance = builder:addMapInstance(config, worldMapCell, worldInstanceData)
	if worldInstance then
		worldInstance:initInstanceData(worldInstanceData.objData)
	end
	return worldInstance
end
local addWorldInstanceClass = function(builder, config, worldMapCell, worldInstanceData)
	local worldInstance = builder:addMapInstance(config, worldMapCell, worldInstanceData)
	if worldInstance then
		if gMapObjTypeDef.mapObjTypeChristmasTree == worldInstanceData.tileInstanceType or gMapObjTypeDef.mapTypeRamadanFeast == worldInstanceData.tileInstanceType then
			worldInstance:initInstanceData(worldInstanceData.class, worldInstanceData.objData)
			worldInstance:setTilePoint(worldInstanceData.tilePoint)
			worldInstance:setInstanceID(worldInstanceData.tileInstanceID)
		else
			worldInstance:initInstanceData(worldInstanceData.class, worldInstanceData.objData)
		end
	end
	return worldInstance
end
local addWorldInstanceObjID = function(builder, config, worldMapCell, worldInstanceData, instanceData)
	local worldInstance = builder:addMapInstance(config, worldMapCell, worldInstanceData)
	if worldInstance then
		worldInstance:initInstanceData(worldInstanceData.class, worldInstanceData.objData, instanceData.objId)
	end
	return worldInstance
end
local addWorldBuilding = function(builder, config, worldMapCell, worldInstanceData)
	local worldBuilding = builder:addMapInstance(config, worldMapCell, worldInstanceData)
	if worldBuilding then
		worldBuilding:initCityData(worldInstanceData.objData)
	end
	return worldBuilding
end
local addWorldMonster = function(builder, config, worldMapCell, worldInstanceData)
	local worldMonster = builder:addMapInstance(config, worldMapCell, worldInstanceData)
	if worldMonster then
		local faceType = worldInstanceData.objData.faceTo
		local showTilePoint = worldInstanceData.tilePoint
		local faceTilePoint
		if faceType == gMapNpcFaceTypeDef.monsterFaceType_LeftBottom then
			faceTilePoint = cc.p(showTilePoint.x, showTilePoint.y + 1)
		else
			faceTilePoint = cc.p(showTilePoint.x + 1, showTilePoint.y)
		end
		local beginPoint = worldMapCell:getPointWithTile(showTilePoint)
		local endPoint = worldMapCell:getPointWithTile(faceTilePoint)
		local _, imgNameAngle, isFlipX = worldMapFunction.getMonsterImgAngel(beginPoint, endPoint)
		worldMonster:initInstanceData(worldInstanceData.class, imgNameAngle, isFlipX, worldInstanceData.objData)
		if worldInstanceData.massRef and worldMonster.setMassRef then
			worldMonster:setMassRef(worldInstanceData.massRef)
		end
	end
	return worldMonster
end
local worldLodDef = worldMapDefine.worldLodDef
local LOD_LAYER = lodShow.LOD_LAYER
local LOD_LAYER_NPC = LOD_LAYER.LOD_LAYER_NPC
local LOD_LAYER_MONSTER = LOD_LAYER.LOD_LAYER_MONSTER
local LOD_LAYER_BOSS = LOD_LAYER.LOD_LAYER_BOSS
local LOD_LAYER_CASTLE = LOD_LAYER.LOD_LAYER_CASTLE
_ENV, instanceFactory.LOD_LAYER = nil, LOD_LAYER
_ENV = nil
;(nil).holdInstace = 2
;(nil).fromKey = "user"
;(nil).delayTime = true
_ENV, (nil).lodShowFun = lodShow.lessLOD3OrSelfLegend, lodShow.lessLOD3OrSelfLegend
_ENV = nil
;(nil).class = "worldMapBuilding"
;(nil).batchNode = batchNode.castleBatchNode
;(nil).createFun = addWorldBuilding
lodShow.lessLOD3OrSelfLegend[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapBuildingLod2"
lodShow.lessLOD3OrSelfLegend[worldLodDef.LOD2], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapBuildingLod"
;(nil).lodLayerFun = lodShow.selfLayerLod3
lodShow.lessLOD3OrSelfLegend[worldLodDef.LOD3], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapBuildingLod"
;(nil).lodLayerFun = lodShow.selfLayerLod4
;(nil)[gMapObjTypeDef.mapObjTypePlayer], (nil).lod, lodShow.lessLOD3OrSelfLegend[worldLodDef.LOD4], (nil).cache = nil, lodShow.lessLOD3OrSelfLegend, nil, true
_ENV = nil
;(nil).holdInstace = 3
_ENV, (nil).fromKey = lodShow.lessLOD3OrSelfLegend, "data"
_ENV = nil
;(nil).class = "worldMapLegendLord"
;(nil).batchNode = batchNode.palaceBatchNode
;(nil).createFun = addWorldInstanceObjID
;(nil)[gMapObjTypeDef.mapObjTypeLegendLord], (nil).lod, lodShow.lessLOD3OrSelfLegend[worldLodDef.LOD1], (nil).cache = nil, lodShow.lessLOD3OrSelfLegend, nil, true
_ENV = nil
;(nil).holdInstace = 3
_ENV, (nil).fromKey = lodShow.lessLOD3OrSelfLegend, "data"
_ENV = nil
;(nil).class = "worldMapRemainsWar"
;(nil).batchNode = batchNode.palaceBatchNode
;(nil).createFun = addWorldInstanceObjID
;(nil)[gMapObjTypeDef.mapObjTypeRemainsWar], (nil).lod, lodShow.lessLOD3OrSelfLegend[worldLodDef.LOD1], (nil).cache = nil, lodShow.lessLOD3OrSelfLegend, nil, true
_ENV = nil
;(nil).holdInstace = 3
;(nil).fromKey = "castle"
_ENV, (nil).lodShowFun = lodShow.alwaysShow, lodShow.alwaysShow
_ENV = nil
;(nil).class = "worldMapCastle"
;(nil).batchNode = batchNode.palaceBatchNode
;(nil).createFun = addWorldInstanceNormale
lodShow.alwaysShow[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapIconLodCastle"
;(nil).lodLayer = LOD_LAYER_CASTLE
;(nil)[gMapObjTypeDef.mapObjTypeCastale], (nil).lod, lodShow.alwaysShow[worldLodDef.LOD2], (nil).cache = nil, lodShow.alwaysShow, nil, true
_ENV = nil
;(nil).holdInstace = 2
;(nil).fromKey = "battery"
_ENV, (nil).lodShowFun = lodShow.lessLOD3, lodShow.lessLOD3
_ENV = nil
;(nil).class = "worldMapBattery"
;(nil).batchNode = batchNode.batteryBatchNode
;(nil).createFun = addWorldInstanceObjID
lodShow.lessLOD3[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapIconLodBattery"
;(nil).lodLayer = LOD_LAYER_CASTLE
;(nil)[gMapObjTypeDef.mapObjTypeBattery], (nil).lod, lodShow.lessLOD3[worldLodDef.LOD2], (nil).cache = nil, lodShow.lessLOD3, nil, true
_ENV = nil
;(nil).holdInstace = 2
;(nil).fromKey = "fortress"
_ENV, (nil).lodShowFun = lodShow.lessLOD3, lodShow.lessLOD3
_ENV = nil
;(nil).class = "worldMapFortress"
;(nil).batchNode = batchNode.buildingBatchNode
;(nil).createFun = addWorldInstanceNormale
lodShow.lessLOD3[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapIconLodBattery"
;(nil).lodLayer = LOD_LAYER_CASTLE
;(nil)[gMapObjTypeDef.mapObjTypeFortress], (nil).lod, lodShow.lessLOD3[worldLodDef.LOD2], (nil).cache = nil, lodShow.lessLOD3, nil, true
_ENV = nil
;(nil).holdInstace = 1
;(nil).fromKey = "resource"
_ENV, (nil).lodShowFun = lodShow.lessLOD3OrSelf, lodShow.lessLOD3OrSelf
_ENV = nil
;(nil).class = "worldMapResource"
;(nil).batchNode = batchNode.buildingBatchNode
;(nil).createFun = addWorldInstanceClass
lodShow.lessLOD3OrSelf[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapResourceLod2"
lodShow.lessLOD3OrSelf[worldLodDef.LOD2], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapResourceLod"
;(nil)[gMapObjTypeDef.mapObjTypeResource], (nil).lod, lodShow.lessLOD3OrSelf[worldLodDef.LOD3], (nil).cache = nil, lodShow.lessLOD3OrSelf, nil, true
_ENV = nil
;(nil).holdInstace = 1
;(nil).fromKey = "camp"
;(nil).delayTime = true
_ENV, (nil).lodShowFun = lodShow.lessLOD2OrSelf, lodShow.lessLOD2OrSelf
_ENV = nil
;(nil).class = "worldMapCampsite"
;(nil).batchNode = batchNode.buildingBatchNode
;(nil).createFun = addWorldInstanceNormale
lodShow.lessLOD2OrSelf[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapIconLodCampsite"
;(nil)[gMapObjTypeDef.mapObjTypeCampsite], (nil).lod, lodShow.lessLOD2OrSelf[worldLodDef.LOD2], (nil).cache = nil, lodShow.lessLOD2OrSelf, nil, true
_ENV = nil
;(nil).holdInstace = 1
;(nil).fromKey = "npc"
;(nil).delayTime = true
;(nil).isHurtDie = true
_ENV, (nil).lodShowFun = lodShow.monsterShow, lodShow.monsterShow
_ENV = nil
;(nil).class = "worldMapMonster"
;(nil).batchNode = batchNode.monsterBatchNode
;(nil).createFun = addWorldMonster
lodShow.monsterShow[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapMonsterLod"
;(nil).lodLayer = LOD_LAYER_MONSTER
;(nil)[gMapObjTypeDef.mapObjTypeNpc], (nil).lod, lodShow.monsterShow[worldLodDef.LOD2], (nil).cache = nil, lodShow.monsterShow, nil, true
_ENV = nil
;(nil).holdInstace = 1
;(nil).fromKey = "npc"
;(nil).delayTime = true
;(nil).isHurtDie = true
_ENV, (nil).lodShowFun = lodShow.monsterShow, lodShow.monsterShow
_ENV = nil
;(nil).class = "worldMapMonsterNebula"
;(nil).batchNode = batchNode.monsterNebulaBatchNode
;(nil).createFun = addWorldMonster
lodShow.monsterShow[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapMonsterLod"
;(nil).lodLayer = LOD_LAYER_MONSTER
;(nil)[gMapObjTypeDef.nebulaNpc], (nil).lod, lodShow.monsterShow[worldLodDef.LOD2], (nil).cache = nil, lodShow.monsterShow, nil, true
_ENV = nil
;(nil).holdInstace = 1
;(nil).fromKey = "npc"
;(nil).delayTime = true
;(nil).isHurtDie = true
_ENV, (nil).lodShowFun = lodShow.npcShow, lodShow.npcShow
_ENV = nil
;(nil).class = "worldMapMonsterSnowMan"
;(nil).batchNode = batchNode.monsterBatchNode
;(nil).createFun = addWorldMonster
lodShow.npcShow[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapMonsterLod"
;(nil).lodLayer = LOD_LAYER_MONSTER
;(nil)[gMapObjTypeDef.mapTypeHuntFair], (nil).lod, lodShow.npcShow[worldLodDef.LOD2], (nil).cache = nil, lodShow.npcShow, nil, true
_ENV = nil
;(nil).holdInstace = 1
;(nil).fromKey = "npc"
;(nil).delayTime = true
;(nil).isHurtDie = true
_ENV, (nil).lodShowFun = lodShow.npcShow, lodShow.npcShow
_ENV = nil
;(nil).class = "worldMapMonsterSemluk"
;(nil).batchNode = batchNode.monsterSemlukBatchNode
;(nil).createFun = addWorldMonster
lodShow.npcShow[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapMonsterLod"
;(nil).lodLayer = LOD_LAYER_MONSTER
;(nil)[gMapObjTypeDef.mapTypeSemluk], (nil).lod, lodShow.npcShow[worldLodDef.LOD2], (nil).cache = nil, lodShow.npcShow, nil, true
_ENV = nil
;(nil).holdInstace = 1
;(nil).fromKey = "monsterFiesta"
;(nil).lodShowFun = lodShow.npcShow
_ENV, (nil).isHurtDie = lodShow.npcShow, true
_ENV = nil
;(nil).class = "worldMapMonsterFiesta"
;(nil).batchNode = batchNode.monsterFiestaBatchNode
;(nil).createFun = addWorldMonster
lodShow.npcShow[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapMonsterLod"
;(nil).lodLayer = LOD_LAYER_MONSTER
;(nil)[gMapObjTypeDef.mapTypeMonsterFiesta], (nil).lod, lodShow.npcShow[worldLodDef.LOD2], (nil).cache = nil, lodShow.npcShow, nil, true
_ENV = nil
;(nil).holdInstace = 2
;(nil).fromKey = "boss"
;(nil).delayTime = true
;(nil).isHurtDie = true
_ENV, (nil).lodShowFun = lodShow.bossShow, lodShow.bossShow
_ENV = nil
_ENV, (nil).class = batchNode.monsterFiestaBatchNode, "worldMapBoss"
;(nil).classTable, batchNode.monsterFiestaBatchNode[gBossType.windTowerBoss] = batchNode.monsterFiestaBatchNode, "worldMapBossWindTower"
;(nil).batchNode = batchNode.bossBatchNode
;(nil).createFun = addWorldMonster
lodShow.bossShow[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapIconLodBoss"
;(nil).lodLayer = LOD_LAYER_BOSS
;(nil)[gMapObjTypeDef.mapObjTypeBoss], (nil).lod, lodShow.bossShow[worldLodDef.LOD2], (nil).cache = nil, lodShow.bossShow, nil, true
_ENV = nil
;(nil).holdInstace = 2
;(nil).fromKey = "boss"
;(nil).delayTime = true
;(nil).isHurtDie = true
_ENV, (nil).lodShowFun = lodShow.bossShow, lodShow.bossShow
_ENV = nil
;(nil).class = "worldMapBoss"
;(nil).batchNode = batchNode.bossBatchNode
;(nil).createFun = addWorldMonster
lodShow.bossShow[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapIconLodBoss"
;(nil).lodLayer = LOD_LAYER_BOSS
;(nil)[gMapObjTypeDef.mapTypeHeroBattleBoss1], (nil).lod, lodShow.bossShow[worldLodDef.LOD2], (nil).cache = nil, lodShow.bossShow, nil, true
_ENV = nil
;(nil).holdInstace = 2
;(nil).fromKey = "boss"
;(nil).delayTime = true
;(nil).isHurtDie = true
_ENV, (nil).lodShowFun = lodShow.bossShow, lodShow.bossShow
_ENV = nil
;(nil).class = "worldMapBoss"
;(nil).batchNode = batchNode.bossBatchNode
;(nil).createFun = addWorldMonster
lodShow.bossShow[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapIconLodBoss"
;(nil).lodLayer = LOD_LAYER_BOSS
;(nil)[gMapObjTypeDef.mapTypeHeroBattleBoss2], (nil).lod, lodShow.bossShow[worldLodDef.LOD2], (nil).cache = nil, lodShow.bossShow, nil, true
_ENV = nil
;(nil).holdInstace = 2
;(nil).fromKey = "superRes"
_ENV, (nil).lodShowFun = lodShow.alwaysShow, lodShow.alwaysShow
_ENV = nil
;(nil).class = "worldMapAllianceResource"
;(nil).batchNode = batchNode.buildingBatchNode
;(nil).createFun = addWorldInstanceClass
lodShow.alwaysShow[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapIconLodAlliance"
;(nil)[gMapObjTypeDef.mapObjTypeSuperResource], (nil).lod, lodShow.alwaysShow[worldLodDef.LOD2], (nil).cache = nil, lodShow.alwaysShow, nil, true
_ENV = nil
;(nil).holdInstace = 2
;(nil).fromKey = "relics"
_ENV, (nil).lodShowFun = lodShow.lessLOD3, lodShow.lessLOD3
_ENV = nil
;(nil).class = "worldMapRemains"
;(nil).batchNode = batchNode.buildingBatchNode
;(nil).createFun = addWorldInstanceNormale
lodShow.lessLOD3[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapIconLodInstance"
;(nil)[gMapObjTypeDef.mapObjTypeRelics], (nil).lod, lodShow.lessLOD3[worldLodDef.LOD2], (nil).cache = nil, lodShow.lessLOD3, nil, true
_ENV = nil
;(nil).holdInstace = 1
;(nil).fromKey = "treasure"
_ENV, (nil).delayTime = lodShow.lessLOD3, true
_ENV = nil
;(nil).class = "worldMapTreasure"
;(nil).batchNode = batchNode.buildingBatchNode
;(nil).createFun = addWorldInstanceNormale
;(nil)[gMapObjTypeDef.mapObjTypeTreasure], (nil).lod, lodShow.lessLOD3[worldLodDef.LOD1], (nil).cache = nil, lodShow.lessLOD3, nil, false
_ENV = nil
;(nil).holdInstace = 1
_ENV, (nil).fromKey = lodShow.lessLOD3, "chest"
_ENV = nil
;(nil).class = "worldMapChest"
;(nil).batchNode = batchNode.buildingBatchNode
;(nil).createFun = addWorldInstanceClass
;(nil)[gMapObjTypeDef.mapObjTypeChest], (nil).lod, lodShow.lessLOD3[worldLodDef.LOD1], (nil).cache = nil, lodShow.lessLOD3, nil, true
_ENV = nil
_ENV, (nil).holdInstace = lodShow.lessLOD3, 2
lodShow.lessLOD3[gMapBattlefieldSiteTypeDef.subMapObjTypeBigPyramid] = 3
lodShow.lessLOD3[gMapBattlefieldSiteTypeDef.subMapTypeAWArmory] = 1
;(nil).holdInstaceTable, lodShow.lessLOD3[gMapBattlefieldSiteTypeDef.subTypeAWTemple] = lodShow.lessLOD3, 3
;(nil).fromKey = "battlefieldSite"
_ENV, (nil).lodShowFun = lodShow.alwaysShow, lodShow.alwaysShow
_ENV = nil
;(nil).class = "worldMapBattlefieldSite"
;(nil).batchNode = batchNode.pyramidBatchNode
;(nil).createFun = addWorldInstanceObjID
lodShow.alwaysShow[worldLodDef.LOD1], (nil).cache = nil, false
_ENV = nil
;(nil).class = "worldMapBattlefieldSiteLod"
;(nil).lodLayer = LOD_LAYER.LOD_LAYER_NEBULA
lodShow.alwaysShow[worldLodDef.LOD2], (nil).cache = nil, false
_ENV = nil
;(nil).class = "worldMapBattlefieldSiteLod4"
;(nil).lodLayer = LOD_LAYER.LOD_LAYER_NEBULA_4
;(nil)[gMapObjTypeDef.mapObjTypeBattlefieldSite], (nil).lod, lodShow.alwaysShow[worldLodDef.LOD4], (nil).cache = nil, lodShow.alwaysShow, nil, false
_ENV = nil
;(nil).holdInstace = 2
;(nil).fromKey = "escort"
_ENV, (nil).lodShowFun = lodShow.lessLOD3, lodShow.lessLOD3
_ENV = nil
;(nil).class = "worldMapEscort"
;(nil).batchNode = batchNode.buildingBatchNode
;(nil).createFun = addWorldInstanceNormale
lodShow.lessLOD3[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapIconLodInstance"
;(nil).lodLayer = LOD_LAYER_NPC
;(nil)[gMapObjTypeDef.mapObjTypeEscort], (nil).lod, lodShow.lessLOD3[worldLodDef.LOD2], (nil).cache = nil, lodShow.lessLOD3, nil, true
_ENV = nil
_ENV, (nil).holdInstace = lodShow.lessLOD3, 2
;(nil).holdInstaceTable, lodShow.lessLOD3[gMapAllianceBuildType.subTypeAllianceFlag] = lodShow.lessLOD3, 1
;(nil).fromKey = "build"
;(nil).delayTime = true
_ENV, (nil).lodShowFun = lodShow.allianceBuild, lodShow.allianceBuild
_ENV = nil
;(nil).class = "worldMapAllianceBuild"
;(nil).batchNode = batchNode.buildingBatchNode
;(nil).createFun = addWorldInstanceClass
lodShow.allianceBuild[worldLodDef.LOD1], (nil).cache = nil, false
_ENV = nil
;(nil).class = "worldMapAllianceBuildLod"
;(nil).lodLayer = LOD_LAYER.LOD_LAYER_ALLIANCERES
;(nil)[gMapObjTypeDef.mapObjTypeAllianceBuild], (nil).lod, lodShow.allianceBuild[worldLodDef.LOD2], (nil).cache = nil, lodShow.allianceBuild, nil, true
_ENV = nil
_ENV, (nil).holdInstace = lodShow.allianceBuild, 2
;(nil).holdInstaceTable, lodShow.allianceBuild[gMapAllianceBuildType.subTypeAllianceFlag] = lodShow.allianceBuild, 1
;(nil).fromKey = "data"
;(nil).delayTime = true
_ENV, (nil).lodShowFun = lodShow.lessLOD5, lodShow.lessLOD5
_ENV = nil
;(nil).class = "worldMapMineBuild"
;(nil).batchNode = batchNode.buildingBatchNode
;(nil).createFun = addWorldInstanceClass
lodShow.lessLOD5[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapIconLodMine"
;(nil).lodLayer = LOD_LAYER.LOD_LAYER_ALLIANCERES
;(nil)[gMapObjTypeDef.mapTypeMine], (nil).lod, lodShow.lessLOD5[worldLodDef.LOD2], (nil).cache = nil, lodShow.lessLOD5, nil, true
_ENV = nil
_ENV, (nil).holdInstace = lodShow.lessLOD5, 2
;(nil).holdInstaceTable, lodShow.lessLOD5[gMapAllianceBuildType.subTypeAllianceFlag] = lodShow.lessLOD5, 1
;(nil).fromKey = "data"
;(nil).delayTime = true
_ENV, (nil).lodShowFun = lodShow.lessLOD5, lodShow.lessLOD5
_ENV = nil
;(nil).class = "worldMapStronghold"
;(nil).batchNode = batchNode.buildingBatchNode
;(nil).createFun = addWorldInstanceClass
lodShow.lessLOD5[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapIconLodStrong"
;(nil).lodLayer = LOD_LAYER.LOD_LAYER_ALLIANCESTRONG
;(nil)[gMapObjTypeDef.stronghold], (nil).lod, lodShow.lessLOD5[worldLodDef.LOD2], (nil).cache = nil, lodShow.lessLOD5, nil, true
_ENV = nil
;(nil).holdInstace = 2
;(nil).fromKey = "build"
_ENV, (nil).lodShowFun = lodShow.lessLOD3, lodShow.lessLOD3
_ENV = nil
;(nil).class = "worldMapKingdomLvTower"
;(nil).batchNode = batchNode.buildingBatchNode
;(nil).createFun = addWorldInstanceNormale
lodShow.lessLOD3[worldLodDef.LOD1], (nil).cache = nil, false
_ENV = nil
;(nil).class = "worldMapIconLodBattery"
;(nil).lodLayer = LOD_LAYER_CASTLE
;(nil)[gMapObjTypeDef.mapObjTypeKingdomLevelBuild], (nil).lod, lodShow.lessLOD3[worldLodDef.LOD2], (nil).cache = nil, lodShow.lessLOD3, nil, true
_ENV = nil
;(nil).holdInstace = 2
;(nil).fromKey = "build"
_ENV, (nil).lodShowFun = lodShow.lessLOD3, lodShow.lessLOD3
_ENV = nil
;(nil).class = "worldMapPyramidGloryBuild"
;(nil).batchNode = batchNode.buildingBatchNode
;(nil).createFun = addWorldInstanceNormale
lodShow.lessLOD3[worldLodDef.LOD1], (nil).cache = nil, false
_ENV = nil
;(nil).class = "worldMapIconLodBattery"
;(nil).lodLayer = LOD_LAYER_CASTLE
;(nil)[gMapObjTypeDef.mapTypePyramidGloryBuild], (nil).lod, lodShow.lessLOD3[worldLodDef.LOD2], (nil).cache = nil, lodShow.lessLOD3, nil, true
_ENV = nil
;(nil).holdInstace = 2
_ENV, (nil).fromKey = lodShow.lessLOD3, "data"
_ENV, (nil).holdInstaceTable, lodShow.lessLOD3[gMapNewTrialBuildType.subMapTypeDVWCastle] = lodShow.lessLOD3, lodShow.lessLOD3, 5
_ENV, _ENV = batchNode.buildingBatchNode
batchNode.buildingBatchNode[gMapNewTrialBuildType.subMapTypeDVWCastle] = "worldMapNewTrialCity"
;(nil).classTable, batchNode.buildingBatchNode[gMapNewTrialBuildType.subMapTypeDVWBattery] = batchNode.buildingBatchNode, "worldMapTrialBattery"
;(nil).batchNode = batchNode.buildingBatchNode
;(nil).createFun = addWorldInstanceNormale
;(nil)[gMapObjTypeDef.mapObjNewTrialCity], (nil).lod, lodShow.lessLOD3[worldLodDef.LOD1], (nil).cache = nil, lodShow.lessLOD3, nil, false
_ENV = nil
;(nil).holdInstace = 1
_ENV, (nil).fromKey = lodShow.lessLOD3, "tree"
_ENV = nil
;(nil).class = "worldMapTreasureBowl"
;(nil).batchNode = batchNode.buildingBatchNode
;(nil).createFun = addWorldInstanceClass
;(nil)[gMapObjTypeDef.mapObjTypeChristmasTree], (nil).lod, lodShow.lessLOD3[worldLodDef.LOD1], (nil).cache = nil, lodShow.lessLOD3, nil, true
_ENV = nil
;(nil).holdInstace = 2
;(nil).fromKey = "wrathBeast"
;(nil).delayTime = true
;(nil).isHurtDie = true
_ENV, (nil).lodShowFun = lodShow.lessLOD6, lodShow.lessLOD6
_ENV = nil
;(nil).class = "worldMapWrathBeast"
;(nil).batchNode = batchNode.wrathBeastBatchNode
;(nil).createFun = addWorldMonster
lodShow.lessLOD6[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapIconLodBoss"
;(nil).lodLayer = LOD_LAYER_NPC
;(nil)[gMapObjTypeDef.mapTypeWrathBeast], (nil).lod, lodShow.lessLOD6[worldLodDef.LOD2], (nil).cache = nil, lodShow.lessLOD6, nil, true
_ENV = nil
;(nil).holdInstace = 1
;(nil).fromKey = "feastData"
_ENV, (nil).delayTime = lodShow.lessLOD6, true
_ENV = nil
;(nil).class = "worldMapFeast"
;(nil).batchNode = batchNode.feastBatchNode
;(nil).createFun = addWorldInstanceClass
;(nil)[gMapObjTypeDef.mapTypeRamadanFeast], (nil).lod, lodShow.lessLOD6[worldLodDef.LOD1], (nil).cache = nil, lodShow.lessLOD6, nil, true
_ENV = nil
;(nil).holdInstace = 2
_ENV, (nil).lodShowFun = lodShow.lessLOD5, lodShow.lessLOD5
_ENV = nil
;(nil).class = "worldMapProtal"
;(nil).batchNode = batchNode.buildingBatchNode
;(nil).createFun = addWorldInstanceObjID
lodShow.lessLOD5[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapIconLodInstance"
;(nil).lodLayer = LOD_LAYER.LOD_LAYER_ALLIANCESTRONG
;(nil)[gMapObjTypeDef.mapTypeEndlessTrialsPortal], (nil).lod, lodShow.lessLOD5[worldLodDef.LOD2], (nil).cache = nil, lodShow.lessLOD5, nil, true
_ENV = nil
;(nil).holdInstace = 2
_ENV, (nil).fromKey = lodShow.lessLOD5, "data"
_ENV = nil
;(nil).class = "worldMapAncientTreasure"
;(nil).batchNode = batchNode.buildingBatchNode
;(nil).createFun = addWorldInstanceNormale
;(nil)[gMapObjTypeDef.mapTypeATBuilding], (nil).lod, lodShow.lessLOD5[worldLodDef.LOD1], (nil).cache = nil, lodShow.lessLOD5, nil, false
_ENV = nil
;(nil).holdInstace = 2
;(nil).fromKey = "boss"
;(nil).delayTime = true
;(nil).isHurtDie = true
_ENV, (nil).lodShowFun = lodShow.bossShow, lodShow.bossShow
_ENV = nil
;(nil).class = "worldMapBoss"
;(nil).batchNode = batchNode.bossBatchNode
;(nil).createFun = addWorldMonster
lodShow.bossShow[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapIconLodBoss"
;(nil).lodLayer = LOD_LAYER_BOSS
;(nil)[gMapObjTypeDef.mapTypeWerewolf], (nil).lod, lodShow.bossShow[worldLodDef.LOD2], (nil).cache = nil, lodShow.bossShow, nil, true
_ENV = nil
;(nil).holdInstace = 2
;(nil).fromKey = "boss"
;(nil).delayTime = true
_ENV, (nil).lodShowFun = lodShow.bossShow, lodShow.bossShow
_ENV = nil
;(nil).class = "worldMapBoss"
;(nil).batchNode = batchNode.bossBatchNode
;(nil).createFun = addWorldMonster
lodShow.bossShow[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapIconLodBoss"
;(nil).lodLayer = LOD_LAYER_BOSS
;(nil)[gMapObjTypeDef.danateMeterialBoss], (nil).lod, lodShow.bossShow[worldLodDef.LOD2], (nil).cache = nil, lodShow.bossShow, nil, true
_ENV = nil
;(nil).holdInstace = 2
;(nil).fromKey = "data"
_ENV, (nil).delayTime = lodShow.bossShow, true
_ENV = nil
;(nil).class = "worldMapRedTreasureMap"
;(nil).batchNode = batchNode.buildingBatchNode
;(nil).createFun = addWorldInstanceClass
;(nil)[gMapObjTypeDef.mapTypeFireTreasure], (nil).lod, lodShow.bossShow[worldLodDef.LOD1], (nil).cache = nil, lodShow.bossShow, nil, true
_ENV = nil
;(nil).holdInstace = 1
;(nil).fromKey = "data"
_ENV, (nil).delayTime = lodShow.bossShow, true
_ENV = nil
;(nil).class = "worldMapDrumAndVuln"
;(nil).batchNode = batchNode.buildingBatchNode
;(nil).createFun = addWorldInstanceClass
;(nil)[gMapObjTypeDef.mapTypeWarTreasure], (nil).lod, lodShow.bossShow[worldLodDef.LOD1], (nil).cache = nil, lodShow.bossShow, nil, true
_ENV = nil
;(nil).holdInstace = 1
_ENV, (nil).fromKey = lodShow.bossShow, "data"
_ENV = nil
;(nil).class = "worldMapRadianceWarResource"
;(nil).batchNode = batchNode.buildRadiance
;(nil).createFun = addWorldInstanceClass
;(nil)[gMapObjTypeDef.mapTypeRadianceWarResource], (nil).lod, lodShow.bossShow[worldLodDef.LOD1], (nil).cache = nil, lodShow.bossShow, nil, true
_ENV = nil
;(nil).holdInstace = 5
_ENV, (nil).fromKey = lodShow.bossShow, "data"
_ENV = nil
;(nil).class = "worldMapRadianceWarPalace"
;(nil).batchNode = batchNode.buildRadiance
;(nil).createFun = addWorldInstanceObjID
;(nil)[gMapObjTypeDef.mapTypeRadianceWarPalace], (nil).lod, lodShow.bossShow[worldLodDef.LOD1], (nil).cache = nil, lodShow.bossShow, nil, true
_ENV = nil
;(nil).holdInstace = 1
_ENV, (nil).fromKey = lodShow.bossShow, "data"
_ENV = nil
;(nil).class = "worldMapRadianceWarGate"
;(nil).batchNode = batchNode.buildRadiance
;(nil).createFun = addWorldInstanceObjID
;(nil)[gMapObjTypeDef.mapTypeRadianceWarGate], (nil).lod, lodShow.bossShow[worldLodDef.LOD1], (nil).cache = nil, lodShow.bossShow, nil, true
_ENV = nil
;(nil).holdInstace = 1
_ENV, (nil).fromKey = lodShow.bossShow, "data"
_ENV = nil
;(nil).class = "worldMapRadianceWarBeacon"
;(nil).batchNode = batchNode.buildRadiance
;(nil).createFun = addWorldInstanceObjID
;(nil)[gMapObjTypeDef.mapTypeRadianceWarBeacon], (nil).lod, lodShow.bossShow[worldLodDef.LOD1], (nil).cache = nil, lodShow.bossShow, nil, true
_ENV = nil
;(nil).holdInstace = 1
;(nil).fromKey = "npc"
_ENV, (nil).delayTime = lodShow.bossShow, true
_ENV = nil
;(nil).class = "worldMapLostRuins"
;(nil).batchNode = batchNode.buildingBatchNode
;(nil).createFun = addWorldInstanceClass
;(nil)[gMapObjTypeDef.mapTypeLostRuins], (nil).lod, lodShow.bossShow[worldLodDef.LOD1], (nil).cache = nil, lodShow.bossShow, nil, true
_ENV = nil
_ENV, (nil).holdInstace = lodShow.bossShow, 2
lodShow.bossShow[gWorldTypeServerDef.subMapTypeAtlantisWarPalace] = 3
;(nil).holdInstaceTable, lodShow.bossShow[gWorldTypeServerDef.subMapTypeAtlantisWarFort] = lodShow.bossShow, 3
;(nil).fromKey = "data"
_ENV, (nil).lodShowFun = lodShow.alwaysShow, lodShow.alwaysShow
_ENV = nil
;(nil).class = "worldMapAtlantisWar"
;(nil).batchNode = batchNode.buildRadiance
;(nil).createFun = addWorldInstanceObjID
lodShow.alwaysShow[worldLodDef.LOD1], (nil).cache = nil, false
_ENV = nil
;(nil).class = "worldMapAtlantisWarLod"
;(nil).lodLayer = LOD_LAYER.LOD_LAYER_NEBULA
lodShow.alwaysShow[worldLodDef.LOD2], (nil).cache = nil, false
_ENV = nil
;(nil).class = "worldMapAtlantisWarLod4"
;(nil).lodLayer = LOD_LAYER.LOD_LAYER_NEBULA_4
;(nil)[gMapObjTypeDef.mapTypeAtlantisWarBuilding], (nil).lod, lodShow.alwaysShow[worldLodDef.LOD4], (nil).cache = nil, lodShow.alwaysShow, nil, false
_ENV = nil
;(nil).holdInstace = 2
;(nil).fromKey = "boss"
;(nil).delayTime = true
;(nil).isHurtDie = true
_ENV, (nil).lodShowFun = lodShow.bossShow, lodShow.bossShow
_ENV = nil
;(nil).class = "worldMapBossAtlantis"
;(nil).batchNode = batchNode.bossBatchNode
;(nil).createFun = addWorldMonster
lodShow.bossShow[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapBossAtlantisLod"
;(nil).lodLayer = LOD_LAYER.LOD_LAYER_NEBULA
lodShow.bossShow[worldLodDef.LOD2], (nil).cache = nil, false
_ENV = nil
;(nil).class = "worldMapBossAtlantisLod4"
;(nil).lodLayer = LOD_LAYER.LOD_LAYER_NEBULA_4
;(nil)[gMapObjTypeDef.mapTypeAtlantisWarBoss], (nil).lod, lodShow.bossShow[worldLodDef.LOD4], (nil).cache = nil, lodShow.bossShow, nil, false
_ENV = nil
;(nil).holdInstace = 2
;(nil).fromKey = "boss"
;(nil).delayTime = true
;(nil).isHurtDie = true
_ENV, (nil).lodShowFun = lodShow.bossShow, lodShow.bossShow
_ENV = nil
;(nil).class = "worldMapBoss"
;(nil).batchNode = batchNode.bossBatchNode
;(nil).createFun = addWorldMonster
lodShow.bossShow[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapIconLodBoss"
;(nil).lodLayer = LOD_LAYER_BOSS
;(nil)[gMapObjTypeDef.wastelandBoss], (nil).lod, lodShow.bossShow[worldLodDef.LOD2], (nil).cache = nil, lodShow.bossShow, nil, true
_ENV = nil
;(nil).holdInstace = 1
;(nil).fromKey = "npc"
_ENV, (nil).delayTime = lodShow.bossShow, true
_ENV = nil
;(nil).class = "worldMapSnowWolfLost"
;(nil).batchNode = batchNode.buildingBatchNode
;(nil).createFun = addWorldInstanceClass
;(nil)[gMapObjTypeDef.mapTypeSnowWolfLost], (nil).lod, lodShow.bossShow[worldLodDef.LOD1], (nil).cache = nil, lodShow.bossShow, nil, true
_ENV = nil
;(nil).holdInstace = 2
;(nil).fromKey = "npc"
_ENV, (nil).delayTime = lodShow.bossShow, true
_ENV = nil
;(nil).class = "worldMapLegendOfPegasus"
;(nil).batchNode = batchNode.buildingBatchNode
;(nil).createFun = addWorldInstanceClass
;(nil)[gMapObjTypeDef.legendOfPegasusBuild], (nil).lod, lodShow.bossShow[worldLodDef.LOD1], (nil).cache = nil, lodShow.bossShow, nil, true
_ENV = nil
;(nil).holdInstace = 2
;(nil).fromKey = "npc"
_ENV, (nil).delayTime = lodShow.bossShow, true
_ENV = nil
;(nil).class = "worldMapBuildActivity9001602"
;(nil).batchNode = batchNode.buildingBatchNode
;(nil).createFun = addWorldInstanceClass
;(nil)[gMapObjTypeDef.firedragonOfAngerBuild], (nil).lod, lodShow.bossShow[worldLodDef.LOD1], (nil).cache = nil, lodShow.bossShow, nil, true
_ENV = nil
;(nil).holdInstace = 2
;(nil).fromKey = "npc"
_ENV, (nil).delayTime = lodShow.bossShow, true
_ENV = nil
;(nil).class = "worldMapBuildActivity9001696"
;(nil).batchNode = batchNode.buildingBatchNode
;(nil).createFun = addWorldInstanceClass
;(nil)[gMapObjTypeDef.firedragonOfAnger2025Build], (nil).lod, lodShow.bossShow[worldLodDef.LOD1], (nil).cache = nil, lodShow.bossShow, nil, true
_ENV = nil
;(nil).holdInstace = 1
;(nil).fromKey = "npc"
_ENV, (nil).delayTime = lodShow.bossShow, true
_ENV = nil
;(nil).class = "worldMapStarTreasure"
;(nil).batchNode = batchNode.buildingBatchNode
;(nil).createFun = addWorldInstanceClass
;(nil)[gMapObjTypeDef.starTreasure], (nil).lod, lodShow.bossShow[worldLodDef.LOD1], (nil).cache = nil, lodShow.bossShow, nil, true
_ENV = nil
_ENV, (nil).holdInstace = lodShow.bossShow, 4
lodShow.bossShow[gWorldTypeServerDef.subTypeNebulaWarBigMine] = 2
;(nil).holdInstaceTable, lodShow.bossShow[gWorldTypeServerDef.subTypeNebulaWarSmallMine] = lodShow.bossShow, 2
;(nil).fromKey = "data"
_ENV, (nil).lodShowFun = lodShow.alwaysShow, lodShow.alwaysShow
_ENV = nil
;(nil).class = "worldMapNebulaWar"
;(nil).batchNode = batchNode.buildRadiance
;(nil).createFun = addWorldInstanceObjID
lodShow.alwaysShow[worldLodDef.LOD1], (nil).cache = nil, false
_ENV = nil
;(nil).class = "worldMapNebulaWarLod"
;(nil).lodLayer = LOD_LAYER.LOD_LAYER_NEBULA
lodShow.alwaysShow[worldLodDef.LOD2], (nil).cache = nil, false
_ENV = nil
;(nil).class = "worldMapNebulaWarLod"
;(nil).lodLayer = LOD_LAYER.LOD_LAYER_NEBULA_4
;(nil)[gMapObjTypeDef.nebulaWarBuilding], (nil).lod, lodShow.alwaysShow[worldLodDef.LOD4], (nil).cache = nil, lodShow.alwaysShow, nil, false
_ENV = nil
;(nil).holdInstace = 2
;(nil).fromKey = "boss"
;(nil).delayTime = true
;(nil).isHurtDie = true
_ENV, (nil).lodShowFun = lodShow.bossShow, lodShow.bossShow
_ENV = nil
;(nil).class = "worldMapBoss"
;(nil).batchNode = batchNode.bossBatchNode
;(nil).createFun = addWorldMonster
lodShow.bossShow[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapIconLodBoss"
;(nil).lodLayer = LOD_LAYER_BOSS
;(nil)[gMapObjTypeDef.fireDragon1], (nil).lod, lodShow.bossShow[worldLodDef.LOD2], (nil).cache = nil, lodShow.bossShow, nil, true
_ENV = nil
;(nil).holdInstace = 2
;(nil).fromKey = "boss"
;(nil).delayTime = true
;(nil).isHurtDie = true
_ENV, (nil).lodShowFun = lodShow.bossShow, lodShow.bossShow
_ENV = nil
;(nil).class = "worldMapBoss"
;(nil).batchNode = batchNode.bossBatchNode
;(nil).createFun = addWorldMonster
lodShow.bossShow[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapIconLodBoss"
;(nil).lodLayer = LOD_LAYER_BOSS
;(nil)[gMapObjTypeDef.fireDragon2], (nil).lod, lodShow.bossShow[worldLodDef.LOD2], (nil).cache = nil, lodShow.bossShow, nil, true
_ENV = nil
;(nil).holdInstace = 2
;(nil).fromKey = "desertMeteorite"
_ENV, (nil).lodShowFun = lodShow.lessLOD3, lodShow.lessLOD3
_ENV = nil
;(nil).class = "worldMapDesertMeteorite"
;(nil).batchNode = batchNode.buildingBatchNode
;(nil).createFun = addWorldInstanceNormale
lodShow.lessLOD3[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapIconLodInstance"
;(nil)[gMapObjTypeDef.desertMeteorite], (nil).lod, lodShow.lessLOD3[worldLodDef.LOD2], (nil).cache = nil, lodShow.lessLOD3, nil, true
_ENV = nil
;(nil).holdInstace = 2
;(nil).fromKey = "boss"
;(nil).delayTime = true
;(nil).isHurtDie = true
_ENV, (nil).lodShowFun = lodShow.bossShow, lodShow.bossShow
_ENV = nil
;(nil).class = "worldMapBoss"
;(nil).batchNode = batchNode.bossBatchNode
;(nil).createFun = addWorldMonster
lodShow.bossShow[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapIconLodBoss"
;(nil).lodLayer = LOD_LAYER_BOSS
;(nil)[gMapObjTypeDef.sweetMeatRobber], (nil).lod, lodShow.bossShow[worldLodDef.LOD2], (nil).cache = nil, lodShow.bossShow, nil, true
_ENV = nil
_ENV, (nil).holdInstace = lodShow.bossShow, 2
lodShow.bossShow[gWorldTypeServerDef.subTypeNebulaEmperorWarPalace] = 4
lodShow.bossShow[gWorldTypeServerDef.subTypeNebulaEmperorWarTower] = 2
;(nil).holdInstaceTable, lodShow.bossShow[gWorldTypeServerDef.subTypeNebulaEmperorWarCamp] = lodShow.bossShow, 3
;(nil).fromKey = "data"
_ENV, (nil).lodShowFun = lodShow.alwaysShow, lodShow.alwaysShow
_ENV = nil
;(nil).class = "worldMapNebulaEmperor"
;(nil).batchNode = batchNode.buildRadiance
;(nil).createFun = addWorldInstanceObjID
lodShow.alwaysShow[worldLodDef.LOD1], (nil).cache = nil, false
_ENV = nil
;(nil).class = "worldMapNebulaEmperorLod"
;(nil).lodLayer = LOD_LAYER.LOD_LAYER_NEBULA
lodShow.alwaysShow[worldLodDef.LOD2], (nil).cache = nil, false
_ENV = nil
;(nil).class = "worldMapNebulaEmperorLod"
;(nil).lodLayer = LOD_LAYER.LOD_LAYER_NEBULA_4
;(nil)[gMapObjTypeDef.nebulaEmperorWarBuilding], (nil).lod, lodShow.alwaysShow[worldLodDef.LOD4], (nil).cache = nil, lodShow.alwaysShow, nil, false
_ENV = nil
;(nil).holdInstace = 2
;(nil).fromKey = "data"
_ENV, (nil).lodShowFun = lodShow.alwaysShow, lodShow.alwaysShow
_ENV = nil
;(nil).class = "worldMapNebulaAllStar"
;(nil).batchNode = batchNode.buildRadiance
;(nil).createFun = addWorldInstanceObjID
lodShow.alwaysShow[worldLodDef.LOD1], (nil).cache = nil, false
_ENV = nil
;(nil).class = "worldMapNebulaAllStarLod"
;(nil).lodLayer = LOD_LAYER.LOD_LAYER_NEBULA
lodShow.alwaysShow[worldLodDef.LOD2], (nil).cache = nil, false
_ENV = nil
;(nil).class = "worldMapNebulaAllStarLod"
;(nil).lodLayer = LOD_LAYER.LOD_LAYER_NEBULA_4
;(nil)[gMapObjTypeDef.nebulaAllStarWarBuilding], (nil).lod, lodShow.alwaysShow[worldLodDef.LOD4], (nil).cache = nil, lodShow.alwaysShow, nil, false
_ENV = nil
_ENV, (nil).holdInstace = lodShow.alwaysShow, 2
lodShow.alwaysShow[gWorldTypeServerDef.subTypeNebulaDefenceWarWall] = 2
lodShow.alwaysShow[gWorldTypeServerDef.subTypeNebulaDefenceWarTower] = 1
;(nil).holdInstaceTable, lodShow.alwaysShow[gWorldTypeServerDef.subTypeNebulaDefenceWarGateway] = lodShow.alwaysShow, 2
;(nil).fromKey = "data"
;(nil).delayTime = true
_ENV, (nil).lodShowFun = lodShow.lessLOD6, lodShow.lessLOD6
_ENV = nil
;(nil).class = "worldMapNebulaDefence"
;(nil).batchNode = batchNode.buildingBatchNode
;(nil).createFun = addWorldInstanceClass
lodShow.lessLOD6[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapNebulaDefenceLod"
;(nil).lodLayer = LOD_LAYER.LOD_LAYER_ALLIANCESTRONG
lodShow.lessLOD6[worldLodDef.LOD2], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapNebulaDefenceLod"
;(nil).lodLayer = LOD_LAYER.LOD_LAYER_ALLIANCESTRONG
;(nil)[gMapObjTypeDef.nebulaDefenceWarBuilding], (nil).lod, lodShow.lessLOD6[worldLodDef.LOD4], (nil).cache = nil, lodShow.lessLOD6, nil, true
_ENV = nil
;(nil).holdInstace = 1
_ENV, (nil).fromKey = lodShow.lessLOD6, "extraData"
_ENV = nil
;(nil).class = "worldMapRamadanSylyut"
;(nil).batchNode = batchNode.buildRadiance
;(nil).createFun = addWorldInstanceObjID
;(nil)[gMapObjTypeDef.ramadanSylyut], (nil).lod, lodShow.lessLOD6[worldLodDef.LOD1], (nil).cache = nil, lodShow.lessLOD6, nil, true
_ENV = nil
;(nil).holdInstace = gMapObjSize[gMapObjTypeDef.feast2024] or 2
;(nil).fromKey = "data"
_ENV, (nil).delayTime = gMapObjSize[gMapObjTypeDef.feast2024] or 2, true
_ENV = nil
;(nil).class = "worldMapFeast2024"
;(nil).batchNode = batchNode.feastBatchNode
;(nil).createFun = addWorldInstanceClass
;(nil)[gMapObjTypeDef.feast2024], (nil).lod, (gMapObjSize[gMapObjTypeDef.feast2024] or 2)[worldLodDef.LOD1], (nil).cache = nil, gMapObjSize[gMapObjTypeDef.feast2024] or 2, nil, true
_ENV = nil
;(nil).holdInstace = 1
_ENV, (nil).fromKey = gMapObjSize[gMapObjTypeDef.feast2024] or 2, "extraData"
_ENV = nil
;(nil).class = "worldMapEidCelebration"
;(nil).batchNode = batchNode.buildRadiance
;(nil).createFun = addWorldInstanceObjID
;(nil)[gMapObjTypeDef.eidCelebration], (nil).lod, (gMapObjSize[gMapObjTypeDef.feast2024] or 2)[worldLodDef.LOD1], (nil).cache = nil, gMapObjSize[gMapObjTypeDef.feast2024] or 2, nil, true
_ENV = nil
;(nil).holdInstace = 2
_ENV, (nil).fromKey = gMapObjSize[gMapObjTypeDef.feast2024] or 2, "data"
_ENV = nil
;(nil).class = "worldMapFantasyLandParty"
;(nil).batchNode = batchNode.buildRadiance
;(nil).createFun = addWorldInstanceObjID
;(nil)[gMapObjTypeDef.fantasyLandParty], (nil).lod, (gMapObjSize[gMapObjTypeDef.feast2024] or 2)[worldLodDef.LOD1], (nil).cache = nil, gMapObjSize[gMapObjTypeDef.feast2024] or 2, nil, true
_ENV = nil
;(nil).holdInstace = 1
_ENV, (nil).fromKey = gMapObjSize[gMapObjTypeDef.feast2024] or 2, "data"
_ENV = nil
;(nil).class = "worldMapFantasyLandGift"
;(nil).batchNode = batchNode.buildRadiance
;(nil).createFun = addWorldInstanceObjID
;(nil)[gMapObjTypeDef.fantasyLandGift], (nil).lod, (gMapObjSize[gMapObjTypeDef.feast2024] or 2)[worldLodDef.LOD1], (nil).cache = nil, gMapObjSize[gMapObjTypeDef.feast2024] or 2, nil, true
_ENV = nil
;(nil).holdInstace = 2
;(nil).fromKey = "data"
_ENV, (nil).lodShowFun = lodShow.roaringFlameWarShow, lodShow.roaringFlameWarShow
_ENV = nil
;(nil).class = "worldMapRoaringFlameWar"
;(nil).batchNode = batchNode.buildRadiance
;(nil).createFun = addWorldInstanceObjID
lodShow.roaringFlameWarShow[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapRoaringFlameWarLod"
;(nil).lodLayer = LOD_LAYER.LOD_LAYER_NEBULA
lodShow.roaringFlameWarShow[worldLodDef.LOD2], (nil).cache = nil, false
_ENV = nil
;(nil).class = "worldMapRoaringFlameWarLod4"
;(nil).lodLayer = LOD_LAYER.LOD_LAYER_NEBULA_4
;(nil)[gMapObjTypeDef.roaringFlameWarBuilding], (nil).lod, lodShow.roaringFlameWarShow[worldLodDef.LOD4], (nil).cache = nil, lodShow.roaringFlameWarShow, nil, false
_ENV = nil
;(nil).holdInstace = 1
_ENV, (nil).fromKey = lodShow.roaringFlameWarShow, "data"
_ENV = nil
;(nil).class = "worldMapRoaringFlameBox"
;(nil).batchNode = batchNode.buildRadiance
;(nil).createFun = addWorldInstanceObjID
;(nil)[gMapObjTypeDef.roaringFlameWarBox], (nil).lod, lodShow.roaringFlameWarShow[worldLodDef.LOD1], (nil).cache = nil, lodShow.roaringFlameWarShow, nil, true
_ENV = nil
;(nil).holdInstace = 1
;(nil).fromKey = "npc"
;(nil).delayTime = true
;(nil).isHurtDie = true
_ENV, (nil).lodShowFun = lodShow.monsterShow, lodShow.monsterShow
_ENV = nil
;(nil).class = "worldMapMonster"
;(nil).batchNode = batchNode.monsterBatchNode
;(nil).createFun = addWorldMonster
lodShow.monsterShow[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapMonsterLod"
;(nil).lodLayer = LOD_LAYER_MONSTER
;(nil)[gMapObjTypeDef.roaringFlameWarNpc], (nil).lod, lodShow.monsterShow[worldLodDef.LOD2], (nil).cache = nil, lodShow.monsterShow, nil, true
_ENV = nil
;(nil).holdInstace = 1
_ENV, (nil).fromKey = lodShow.monsterShow, "data"
_ENV = nil
;(nil).class = "worldMapRoaringFlameCave"
;(nil).batchNode = batchNode.buildRadiance
;(nil).createFun = addWorldInstanceObjID
;(nil)[gMapObjTypeDef.roaringFlameWarCave], (nil).lod, lodShow.monsterShow[worldLodDef.LOD1], (nil).cache = nil, lodShow.monsterShow, nil, true
_ENV = nil
;(nil).holdInstace = 1
_ENV, (nil).fromKey = lodShow.monsterShow, "data"
_ENV = nil
;(nil).class = "worldMapDailySaluteBuild"
;(nil).batchNode = batchNode.buildRadiance
;(nil).createFun = addWorldInstanceObjID
;(nil)[gMapObjTypeDef.dailySaluteBuild], (nil).lod, lodShow.monsterShow[worldLodDef.LOD1], (nil).cache = nil, lodShow.monsterShow, nil, true
_ENV = nil
;(nil).holdInstace = 1
_ENV, (nil).fromKey = lodShow.monsterShow, "data"
_ENV = nil
;(nil).class = "worldMapDailySaluteBribe"
;(nil).batchNode = batchNode.buildRadiance
;(nil).createFun = addWorldInstanceObjID
;(nil)[gMapObjTypeDef.dailySaluteBribe], (nil).lod, lodShow.monsterShow[worldLodDef.LOD1], (nil).cache = nil, lodShow.monsterShow, nil, true
_ENV = nil
;(nil).holdInstace = 2
;(nil).fromKey = "data"
_ENV, (nil).lodShowFun = lodShow.alwaysShow, lodShow.alwaysShow
_ENV = nil
;(nil).class = "worldMapSimulatedDrillWar"
;(nil).createFun = addWorldInstanceObjID
lodShow.alwaysShow[worldLodDef.LOD1], (nil).cache = nil, false
_ENV = nil
;(nil).class = "worldMapSimulatedDrillWarLod"
;(nil).lodLayer = LOD_LAYER.LOD_LAYER_NEBULA
;(nil)[gMapObjTypeDef.simulatedDrillWarBuilding], (nil).lod, lodShow.alwaysShow[worldLodDef.LOD2], (nil).cache = nil, lodShow.alwaysShow, nil, false
_ENV = nil
;(nil).holdInstace = 2
;(nil).fromKey = "boss"
;(nil).delayTime = true
_ENV, (nil).lodShowFun = lodShow.bossShow, lodShow.bossShow
_ENV = nil
;(nil).class = "worldMapCaptureMonkey"
;(nil).batchNode = batchNode.bossBatchNode
;(nil).createFun = addWorldMonster
lodShow.bossShow[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapIconLodBoss"
;(nil).lodLayer = LOD_LAYER_BOSS
;(nil)[gMapObjTypeDef.captureMonkey], (nil).lod, lodShow.bossShow[worldLodDef.LOD2], (nil).cache = nil, lodShow.bossShow, nil, true
_ENV = nil
;(nil).holdInstace = 1
;(nil).fromKey = "npc"
;(nil).delayTime = true
;(nil).isHurtDie = true
_ENV, (nil).lodShowFun = lodShow.monsterShow, lodShow.monsterShow
_ENV = nil
;(nil).class = "worldMapMonster"
;(nil).batchNode = batchNode.monsterBatchNode
;(nil).createFun = addWorldMonster
lodShow.monsterShow[worldLodDef.LOD1], (nil).cache = nil, true
_ENV = nil
;(nil).class = "worldMapMonsterLod"
;(nil).lodLayer = LOD_LAYER_MONSTER
;(nil)[gMapObjTypeDef.footballMonster], (nil).lod, lodShow.monsterShow[worldLodDef.LOD2], (nil).cache = nil, lodShow.monsterShow, nil, true
local worldInstanceConnfig
function instanceFactory.getConfigByType(tileInstanceType)
	return worldInstanceConnfig[tileInstanceType]
end
function instanceFactory.getConfigByInstance(instanceData)
	local instanceType = instanceData.type
	return worldInstanceConnfig[instanceType]
end
function instanceFactory.getInstanceDataKey(tileInstanceType)
	local config = worldInstanceConnfig[tileInstanceType]
	if config then
		return config.fromKey
	end
end
function instanceFactory.isInstanceHurtDie(tileInstanceType)
	local config = worldInstanceConnfig[tileInstanceType]
	if config then
		return config.isHurtDie
	end
end
function instanceFactory.getHoldInstaceByType(tileInstanceType, class, subMapType)
	if tileInstanceType == gMapObjTypeDef.nebulaAllStarWarBuilding then
		local nebulaAllStarUtil = include("nebulaAllStarUtil")
		return nebulaAllStarUtil.getHoldInstaceByType(class, subMapType)
	elseif tileInstanceType == gMapObjTypeDef.roaringFlameWarBuilding then
		local roaringFlameWarRead = include("roaringFlameWarRead")
		return roaringFlameWarRead.getHoldInstaceByType(class, subMapType)
	end
	local holdInstace = 1
	local config = worldInstanceConnfig[tileInstanceType]
	if config then
		holdInstace = config.holdInstace
		if config.holdInstaceTable then
			if config.holdInstaceTable[class] then
				holdInstace = config.holdInstaceTable[class]
			elseif config.holdInstaceTable[subMapType] then
				holdInstace = config.holdInstaceTable[subMapType]
			end
		end
	end
	return holdInstace
end
function instanceFactory.isInstanceDelayTime(tileInstanceType)
	if worldInstanceConnfig[tileInstanceType] then
		return worldInstanceConnfig[tileInstanceType].delayTime
	end
end
function instanceFactory.getInstanceByType(class, cache)
	local worldInstance
	if class then
		if cache then
			worldInstance = instanceCacheMgr.getInstance(class)
			if worldInstance then
				return worldInstance, true
			end
		end
		worldInstance = include(class).new()
		worldInstance:setClassType(class)
		worldInstance:setName(class)
	end
	return worldInstance
end
local getWorldMapInstanceData_imp = function(worldMapCell, instanceData, config)
	local _ENV, kingdomID = nil, instanceData.kid or worldMapCell.kingdomID
	;(nil).tileInstanceType = instanceData.type
	;(nil).tilePoint = cc.p(instanceData.x, instanceData.y)
	;(nil).tileInstanceID = instanceData.id
	;(nil).tileInstanceKingdomID = kingdomID
	if not instanceData.ref then
		_ENV = instanceData.ref
	end
	local (nil).massRef, worldInstanceData = instanceData.ref, nil
	if config.fromKey then
		if not instanceData[config.fromKey] then
			_ENV = instanceData[config.fromKey]
		end
		worldInstanceData.objData = instanceData[config.fromKey]
	end
	if instanceData.class then
		worldInstanceData.class = instanceData.class
	end
	if instanceData.subMapType then
		worldInstanceData.subMapType = instanceData.subMapType
	end
	if instanceData.objId and worldInstanceData.objData then
		worldInstanceData.objData.objId = instanceData.objId
	end
	if instanceData.settingId and worldInstanceData.objData then
		worldInstanceData.objData.settingId = instanceData.settingId
	end
	return worldInstanceData
end
local getWorldMapInstanceData = function(worldMapCell, instanceData, config)
	local worldInstanceData = instanceData._worldInsttanceData
	if not worldInstanceData then
		worldInstanceData = getWorldMapInstanceData_imp(worldMapCell, instanceData, config)
		instanceData._worldInsttanceData = worldInstanceData
	end
	return worldInstanceData
end
instanceFactory.getWorldMapInstanceData = getWorldMapInstanceData
function instanceFactory.createMapInstance(builder, worldMapCell, instanceData)
	local instanceType = instanceData.type
	local worldInstance
	local config = worldInstanceConnfig[instanceType]
	if config then
		local worldInstanceData = instanceData._worldInsttanceData
		if not worldInstanceData then
			worldInstanceData = getWorldMapInstanceData_imp(worldMapCell, instanceData, config)
			instanceData._worldInsttanceData = worldInstanceData
		end
		worldInstance = builder:createMapInstanceConfig(worldMapCell, instanceData, worldInstanceData, config)
	else
		print("instanceFactory.createMapInstance failed instanceType:", instanceType)
	end
	return worldInstance
end
function instanceFactory.getTilesArrayByInstace(tilePoint, holdInstace)
	local _ENV, tilesArray
	for i = 0, holdInstace - 1 do
		for j = 0, holdInstace - 1 do
			local poskey = tilePoint.x + i .. "," .. tilePoint.y + j
			table.insert(tilesArray, poskey)
		end
	end
	return tilesArray
end
return instanceFactory
