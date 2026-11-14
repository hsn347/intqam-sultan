local gametop = gModuleMgr.getObject("gametop")
local settingCtrl = gametop.playertop_:getModule("settingCtrl")
local instanceCacheMgr = include("instanceCacheMgr")
local instanceFactory = include("instanceFactory")
local mapSyncUtilClient = include("mapSyncUtilClient")
_ENV = "mapSyncUtilClient"
;("mapSyncUtilClient").tradeNode = "tradeNode_self"
;("mapSyncUtilClient").moveLineNode_Mini = "moveLineNode_Mini_self"
;("mapSyncUtilClient").moveLineNode = "moveLineNode_self"
;("mapSyncUtilClient").romanSoulNode = "romanSoulNode"
local ("mapSyncUtilClient").moveLineBgNode, troopName = "moveLineBgNode_self", "mapSyncUtilClient"
local addToCell_imp = function(cell, nodeName, node, isSelf)
	local name = nodeName
	if isSelf then
		name = troopName[nodeName] or nodeName .. "_self"
	end
	local moveNode = cell[name]
	if moveNode then
		moveNode:addChild(node)
	end
end
local troopAddToCell = function(cell, nodeName, moveTroop)
	local isSelf = moveTroop:isSelfTroop(cell.myPlayerID)
	addToCell_imp(cell, nodeName, moveTroop, isSelf)
end
local drawMoveLine = function(cell, delayTime, beginTilePoint, endTilePoint, lineID, userData, beginPoint, endPoint)
	local moveLine = instanceCacheMgr.getInstance("worldMapMoveLine")
	if moveLine then
		moveLine.isFromCache = true
		moveLine:initWithPoint(beginPoint, endPoint, true)
	else
		moveLine = include("worldMapMoveLine").new(beginPoint, endPoint)
		moveLine.isAddToCache = true
	end
	moveLine:setPosition(beginPoint)
	moveLine:setLineTilePoints(beginTilePoint, endTilePoint)
	moveLine:setMoveLineID(lineID)
	moveLine:setKingdomID(userData.kingdomID)
	moveLine:setWorldMapCell(cell)
	if userData.moveLineColor then
		moveLine:setMoveLineColor(userData.moveLineColor)
	end
	return moveLine
end
local addTroopsMini = function(cell, delayTime, beginTilePoint, endTilePoint, moveTimeData, moveLineID, matrixState, userData, beginPoint, endPoint)
	local troopsMatrix = include("troopsMini")
	local warMatrix = troopsMatrix.new()
	warMatrix:setPosition(beginPoint)
	warMatrix:setUserData(userData)
	warMatrix:setMoveTimeData(moveTimeData)
	warMatrix:initData(beginPoint, endPoint, beginTilePoint, endTilePoint, userData.toObjectType, userData.armyData, userData.toObjectID, nil, userData)
	warMatrix:setMoveLineID(moveLineID)
	troopAddToCell(cell, "moveLineNode_Mini", warMatrix)
	warMatrix:setEmojiID(userData.emoji)
	return warMatrix
end
local addOneTroopsMatrix = function(cell, delayTime, beginTilePoint, endTilePoint, moveTimeData, moveLineID, matrixState, userData, beginPoint, endPoint)
	local taskType = userData.commandHallTaskType
	if taskType then
		local commandHallUtil = include("commandHallUtil")
		if not commandHallUtil.checkTaskTypeNeedArmy(taskType) then
			userData.armyData = commandHallUtil.getTroopsMatrixArmyData()
		end
	end
	local troopsMatrix = include("troopsMatrix")
	local warMatrix = troopsMatrix.new()
	warMatrix:setPosition(beginPoint)
	warMatrix:setUserData(userData)
	warMatrix:setMoveTimeData(moveTimeData)
	troopAddToCell(cell, "moveLineNode", warMatrix)
	warMatrix:initData(beginPoint, endPoint, beginTilePoint, endTilePoint, userData.toObjectType, userData.armyData, userData.toObjectID, nil, userData)
	warMatrix:setMoveLineID(moveLineID)
	warMatrix:setEmojiID(userData.emoji)
	return warMatrix
end
local addHeroBackSolider = function(cell, delayTime, beginTilePoint, endTilePoint, moveTimeData, moveLineID, matrixState, userData, beginPoint, endPoint)
	local heroBackSolider = include("heroBackSolider").new()
	heroBackSolider:setPosition(beginPoint)
	heroBackSolider:setUserData(userData)
	heroBackSolider:initData(beginPoint, endPoint, beginTilePoint, endTilePoint, userData)
	heroBackSolider:setMoveLineID(moveLineID)
	troopAddToCell(cell, "moveLineNode", heroBackSolider)
	heroBackSolider:setMoveTimeData(moveTimeData)
	heroBackSolider:setEmojiID(userData.emoji)
	return heroBackSolider
end
local addDetectionSolider = function(cell, delayTime, beginTilePoint, endTilePoint, moveTimeData, moveLineID, matrixState, userData, beginPoint, endPoint)
	local detectionSolider = include("detectionSolider").new()
	detectionSolider:setPosition(beginPoint)
	detectionSolider:setUserData(userData)
	detectionSolider:initData(beginPoint, endPoint, beginTilePoint, endTilePoint, userData.armyData)
	detectionSolider:setMoveLineID(moveLineID)
	troopAddToCell(cell, "moveLineNode", detectionSolider)
	detectionSolider:setMoveTimeData(moveTimeData)
	detectionSolider:setEmojiID(userData.emoji)
	return detectionSolider
end
local addCollectSolider = function(cell, delayTime, beginTilePoint, endTilePoint, moveTimeData, moveLineID, matrixState, userData, beginPoint, endPoint)
	local collectSolider = include("collectSolider").new()
	collectSolider:setPosition(beginPoint)
	collectSolider:setUserData(userData)
	collectSolider:setMoveTimeData(moveTimeData)
	collectSolider:initData(beginPoint, endPoint, beginTilePoint, endTilePoint, userData.armyData)
	collectSolider:setMoveLineID(moveLineID)
	troopAddToCell(cell, "tradeNode", collectSolider)
	collectSolider:setEmojiID(userData.emoji)
	return collectSolider
end
local addTradeSolider = function(cell, delayTime, beginTilePoint, endTilePoint, moveTimeData, moveLineID, matrixState, userData, beginPoint, endPoint)
	local tradeSolider = include("tradeSolider").new()
	tradeSolider:setPosition(beginPoint)
	tradeSolider:setUserData(userData)
	tradeSolider:initData(beginPoint, endPoint, beginTilePoint, endTilePoint, userData.armyData)
	tradeSolider:setMoveLineID(moveLineID)
	troopAddToCell(cell, "tradeNode", tradeSolider)
	tradeSolider:setMoveTimeData(moveTimeData)
	tradeSolider:setEmojiID(userData.emoji)
	return tradeSolider
end
local addRomanSoulSolider = function(cell, delayTime, beginTilePoint, endTilePoint, moveTimeData, moveLineID, matrixState, userData, beginPoint, endPoint)
	local romanSoulSolider = include("romanSoulSolider").new()
	romanSoulSolider:setPosition(beginPoint)
	cell.romanSoulNode:addChild(romanSoulSolider)
	romanSoulSolider:setUserData(userData)
	romanSoulSolider:initData(beginPoint, endPoint, beginTilePoint, endTilePoint, userData.armyData)
	romanSoulSolider:setMoveLineID(moveLineID)
	romanSoulSolider:setMoveTimeData(moveTimeData)
	return romanSoulSolider
end
local addNebulaDefenceSolider = function(cell, delayTime, beginTilePoint, endTilePoint, moveTimeData, moveLineID, matrixState, userData, beginPoint, endPoint)
	local nebulaDefenceSolider = include("nebulaDefenceSolider").new()
	nebulaDefenceSolider:setPosition(beginPoint)
	cell.romanSoulNode:addChild(nebulaDefenceSolider)
	nebulaDefenceSolider:setUserData(userData)
	nebulaDefenceSolider:initData(beginPoint, endPoint, beginTilePoint, endTilePoint, userData.armyData)
	nebulaDefenceSolider:setMoveLineID(moveLineID)
	nebulaDefenceSolider:setMoveTimeData(moveTimeData)
	return nebulaDefenceSolider
end
local addNebulaAllStarSpoil = function(cell, delayTime, beginTilePoint, endTilePoint, moveTimeData, moveLineID, matrixState, userData, beginPoint, endPoint)
	local nebulaAllStarSpoil = include("nebulaAllStarSpoil").new()
	nebulaAllStarSpoil:setPosition(beginPoint)
	cell.romanSoulNode:addChild(nebulaAllStarSpoil)
	nebulaAllStarSpoil:setUserData(userData)
	nebulaAllStarSpoil:initData(beginPoint, endPoint, beginTilePoint, endTilePoint, userData.armyData)
	nebulaAllStarSpoil:setMoveLineID(moveLineID)
	nebulaAllStarSpoil:setMoveTimeData(moveTimeData)
	return nebulaAllStarSpoil
end
local addCommandHallSolider = function(...)
	local commandHallSolider = addOneTroopsMatrix(...)
	commandHallSolider.__cname = "commandHallSolider"
	local commandHallCtrl = SoraDGetCtrl("commandHallCtrl")
	local commandHallUtil = include("commandHallUtil")
	if commandHallSolider:getMatrixState() == gMapMoveLineStatusType.moveLineStatusTypeMoving then
		local taskNode = commandHallUtil.createTaskNode()
		taskNode:addTo(commandHallSolider, 1)
		taskNode:setPosition(cc.p(0, 100))
		local task = commandHallCtrl:getArmyGroupTaskData()
		taskNode:setTaskID(task.taskID)
	end
	return commandHallSolider
end
local addGetChestSolider = function(cell, delayTime, beginTilePoint, endTilePoint, moveTimeData, moveLineID, matrixState, userData, beginPoint, endPoint)
	local getChestSolider = include("getChestSolider").new()
	getChestSolider:setPosition(beginPoint)
	getChestSolider:setUserData(userData)
	getChestSolider:initData(beginPoint, endPoint, beginTilePoint, endTilePoint, userData.armyData)
	getChestSolider:setMoveLineID(moveLineID)
	troopAddToCell(cell, "moveLineNode", getChestSolider)
	getChestSolider:setMoveTimeData(moveTimeData)
	getChestSolider:setEmojiID(userData.emoji)
	return getChestSolider
end
local addEPyramidScortSolider = function(cell, delayTime, beginTilePoint, endTilePoint, moveTimeData, moveLineID, matrixState, userData, beginPoint, endPoint)
	local escortSolider = include("escortSolider").new()
	escortSolider:setPosition(beginPoint)
	escortSolider:setUserData(userData)
	escortSolider:initData(beginPoint, endPoint, beginTilePoint, endTilePoint, userData.armyData, userData.cartLv)
	escortSolider:setMoveLineID(moveLineID)
	troopAddToCell(cell, "tradeNode", escortSolider)
	escortSolider:setMoveTimeData(moveTimeData)
	local escortDesRead = include("escortDesRead")
	if userData.cartLv ~= nil and userData.cartLv ~= 0 then
		print("等级   userData.cartLv")
		escortSolider:addEffectByQuality(escortDesRead.getCarQuality(userData.cartLv))
	else
		print("默认 1")
		escortSolider:addEffectByQuality(escortDesRead.getCarQuality(1))
	end
	if userData.buff ~= nil and userData.buff ~= 0 then
		escortSolider:setIsBuff(true)
	else
		escortSolider:setIsBuff(false)
	end
	return escortSolider
end
local addEscortSolider = function(cell, delayTime, beginTilePoint, endTilePoint, moveTimeData, moveLineID, matrixState, userData, beginPoint, endPoint)
	local escortSolider = include("escortSolider").new()
	escortSolider:setPosition(beginPoint)
	escortSolider:setUserData(userData)
	escortSolider:initData(beginPoint, endPoint, beginTilePoint, endTilePoint, userData.armyData, userData.cartLv)
	escortSolider:setMoveLineID(moveLineID)
	troopAddToCell(cell, "tradeNode", escortSolider)
	escortSolider:setMoveTimeData(moveTimeData)
	escortSolider:setEmojiID(userData.emoji)
	escortSolider:setAssistorInfo(userData.assistorInfo)
	escortSolider:setAssistBattlePlus(userData.assistBattlePlus)
	escortSolider:setAssistArmy(userData.assistArmy)
	local escortDesRead = include("escortDesRead")
	if userData.cartLv ~= nil and userData.cartLv ~= 0 then
		print("等级   userData.cartLv")
		escortSolider:addEffectByQuality(escortDesRead.getCarQuality(userData.cartLv))
	else
		print("默认 1")
		escortSolider:addEffectByQuality(escortDesRead.getCarQuality(1))
	end
	if userData.buff ~= nil and userData.buff ~= 0 then
		escortSolider:setIsBuff(true)
	else
		escortSolider:setIsBuff(false)
	end
	return escortSolider
end
_ENV = nil
;(nil)[gMapMoveLineMatrixType.moveLineMatrixTypeTroop] = addOneTroopsMatrix
;(nil)[gMapMoveLineMatrixType.moveLineMatrixTypeDetection] = addDetectionSolider
;(nil)[gMapMoveLineMatrixType.moveLineMatrixTypeCollection] = addCollectSolider
;(nil)[gMapMoveLineMatrixType.moveLineMatrixTypeTrade] = addTradeSolider
;(nil)[gMapMoveLineMatrixType.moveLineMatrixTypeRomanSoul] = addRomanSoulSolider
;(nil)[gMapMoveLineMatrixType.moveLineMatrixTypeChest] = addGetChestSolider
;(nil)[gMapMoveLineMatrixType.moveLineMatrixTypeEscort] = addEscortSolider
;(nil)[gMapMoveLineMatrixType.moveLineMatrixTypeHeroBack] = addHeroBackSolider
;(nil)[gMapMoveLineMatrixType.moveLineMatrixTypeNewTrial] = addOneTroopsMatrix
;(nil)[gMapMoveLineMatrixType.moveLineMatrixTypeCommandHall] = addCommandHallSolider
;(nil)[gMapMoveLineMatrixType.moveLineMatrixTypeNebulaDefence] = addNebulaDefenceSolider
;(nil)[gMapMoveLineMatrixType.moveLineMatrixTypeNebulaAllStarSpoil] = addNebulaAllStarSpoil
local (nil)[gMapMoveLineMatrixType.moveLineMatrixTypeAllianceWarSupply], moveline_createFunction = addEPyramidScortSolider, nil
local createLine = function(isLod, createFun, cell, delayTime, beginTilePoint, endTilePoint, moveTimeData, moveLineID, matrixState, userData)
	local beginPoint = cell:getPointWithTile(beginTilePoint)
	local endPoint = cell:getPointWithTile(endTilePoint)
	local troops = createFun(cell, delayTime, beginTilePoint, endTilePoint, moveTimeData, moveLineID, matrixState, userData, beginPoint, endPoint)
	local moveLine = drawMoveLine(cell, delayTime, beginTilePoint, endTilePoint, moveLineID, userData, beginPoint, endPoint)
	local isSelf = troops:isSelfTroop(cell.myPlayerID)
	addToCell_imp(cell, "moveLineBgNode", moveLine, isSelf)
	if moveLine.isFromCache then
		moveLine:release()
	end
	troops:switchMoveLineModel(isLod, true)
	troops:setMoveLine(moveLine)
	troops:setMatrixState(matrixState)
	if userData.moveLineColor then
		troops:setMoveLineColor(userData.moveLineColor)
	end
	moveLine:setTroopInstance(troops, isLod)
	moveLine:showMoveline(delayTime)
	return moveLine
end
local getUserData = function(cell, moveLineData)
	local fromData = moveLineData.from
	local toData = moveLineData.to
	_ENV = nil
	;(nil).fromObjectType = fromData.type
	;(nil).toObjectType = toData.type
	;(nil).playerID = moveLineData.playerID
	;(nil).isMainQueue = moveLineData.isMainQueue
	;(nil).isRecall = moveLineData.isRecall
	;(nil).isLegendLord = moveLineData.isLegendLord
	;(nil).isLegendLordForSep = moveLineData.isLegendLordForSep
	;(nil).hasJoin = moveLineData.hasJoin
	;(nil).leagueID = moveLineData.leagueID
	;(nil).moveLineType = moveLineData.moveLineType
	;(nil).moveLineColor = moveLineData.moveLineColor
	;(nil).moveLineModel = moveLineData.moveLineModel
	;(nil).armyData = fromData.army
	;(nil).effectId = moveLineData.effectId
	;(nil).assistBattlePlus = moveLineData.assistBattlePlus
	;(nil).assistorInfo = moveLineData.assistorInfo
	;(nil).cartLv = moveLineData.cartLv
	;(nil).buff = moveLineData.buff
	;(nil).assistArmy = fromData.assistArmy
	;(nil).toObjectID = toData.subMapType
	;(nil).marchArmyEffectId = moveLineData.marchArmyEffectId
	;(nil).kingdomID = moveLineData.kingdomId or cell.kingdomID
	;(nil).isDuelMode = moveLineData.isDuelMode or false
	;(nil).emoji = moveLineData.emoji
	;(nil).isNOClick = moveLineData.isNOClick
	;(nil).captureHeroAsAttacker = moveLineData.captureHeroAsAttacker or false
	;(nil).matrixState = moveLineData.status
	;(nil).orgQueueId = moveLineData.orgQueueId
	;(nil).commandHallTaskType = moveLineData.commandHallTaskType
	local (nil).isBackFailQueue, userData = moveLineData.moveLineType == gMapMoveLineType.moveLineTypeReturn and (moveLineData.isFailAttack or moveLineData.isFailDefend), nil
	if userData.isDuelMode and cell.myPlayerID ~= userData.playerID then
		userData.moveLineColor = gMapMoveLineColor.moveLineColorPurple
	end
	return userData
end
local getMoveTimeData = function(moveLineData)
	local curTime = serviceFunctions.systemTime()
	_ENV = nil
	;(nil).moveTimeSpan = moveLineData.moveTimeSpan
	local (nil).currentMoveTime, moveTimeData = curTime - (moveLineData.statusStartTime or curTime), nil
	if moveTimeData.currentMoveTime == 0 and moveTimeData.moveTimeSpan then
		for _, v in pairs(moveTimeData.moveTimeSpan) do
			if v.isPast then
				moveTimeData.currentMoveTime = moveTimeData.currentMoveTime + v.time
			end
		end
	end
	return moveTimeData
end
local createMapMoveLineImp = function(cell, moveLineData, isSelfMoveLine, beginTilePoint, endTilePoint, isLod)
	local fromData = moveLineData.from
	local toData = moveLineData.to
	local beginTilePointData = beginTilePoint
	local endTilePointData = endTilePoint
	do
		local fromObjType = fromData.type or fromData.objType
		local fromHoldInstance = instanceFactory.getHoldInstaceByType(fromObjType, fromData.objId, fromData.subMapType)
		local fromHalf = (fromHoldInstance - 1) * 0.5
		beginTilePoint = cc.p(beginTilePoint.x + fromHalf, beginTilePoint.y + fromHalf)
	end
	do
		local toObjectType = toData.type or toData.objType
		local toHoldInstance = instanceFactory.getHoldInstaceByType(toObjectType, toData.objId, toData.subMapType)
		local toHalf = (toHoldInstance - 1) * 0.5
		endTilePoint = cc.p(endTilePoint.x + toHalf, endTilePoint.y + toHalf)
	end
	local userData = getUserData(cell, moveLineData)
	if moveLineData.matrixType == gMapMoveLineMatrixType.moveLineMatrixTypeAllianceWarSupply then
		userData.hasJoin = true
		userData.cartLv = 5
		userData.camp = moveLineData.toTeamId
		userData.statusEndTime = moveLineData.statusEndTime
		userData.moveLineColor = moveLineData.toTeamId == gAllianceWarCampType.blue and gMapMoveLineColor.moveLineColorBlue or gMapMoveLineColor.moveLineColorRed
	end
	local createFun
	if not isSelfMoveLine and (settingCtrl:getQueueShowSolider() ~= 1 or not not worldMapDefine.moveLineAutoHideOption.isMoveLineHideArmy) and moveLineData.matrixType ~= gMapMoveLineMatrixType.moveLineMatrixTypeEscort and moveLineData.matrixType ~= gMapMoveLineMatrixType.moveLineMatrixTypeAllianceWarSupply then
		createFun = addTroopsMini
	else
		createFun = moveline_createFunction[moveLineData.matrixType]
	end
	local moveLine
	if createFun then
		local moveTimeData = getMoveTimeData(moveLineData)
		local delayTime = moveLineData.delayTime_client or 0
		moveLine = createLine(isLod, createFun, cell, delayTime, beginTilePoint, endTilePoint, moveTimeData, moveLineData.id, moveLineData.status, userData)
		if moveLine then
			moveLine:setShowTilePoint(beginTilePointData, endTilePointData)
		end
	end
	return moveLine
end
local createMapMoveLine = function(cell, moveLineData, piecePosList, isLod, kingdomClass, lod)
	local fromData = moveLineData.from
	local toData = moveLineData.to
	local beginTilePoint = cc.p(tonumber(fromData.x), tonumber(fromData.y))
	local endTilePoint = cc.p(tonumber(toData.x), tonumber(toData.y))
	local isSelfMoveLine = cell.myPlayerID == moveLineData.playerID or moveLineData.hasJoin or moveLineData.client_queue
	if not isSelfMoveLine then
		local isLineOutRect = mapSyncUtilClient.isLineOutRect(piecePosList, beginTilePoint, endTilePoint, kingdomClass, lod)
		if isLineOutRect then
			return
		end
	end
	return createMapMoveLineImp(cell, moveLineData, isSelfMoveLine, beginTilePoint, endTilePoint, isLod)
end
local _ENV, movelineFactory
movelineFactory.createMapMoveLine = createMapMoveLine
return movelineFactory
