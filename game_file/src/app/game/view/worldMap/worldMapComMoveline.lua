local worldMapComMoveline = class("worldMapComMoveline", include("worldMapCom"))
local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local mapSyncUtil = include("mapSyncUtil")
local mapSyncUtilClient = include("mapSyncUtilClient")
local allianceWarSettingCtrl = include("allianceWarSettingCtrl")
local worldMapUtil = include("worldMapUtil")
local movelineFactory = include("movelineFactory")
local Z_ORDER_CELL = worldMapDefine.Z_ORDER_CELL
local GROU_ID = worldMapDefine.GROU_ID
function worldMapComMoveline:ctor()
	worldMapComMoveline.super.ctor(self, "worldMapComMoveline")
end
local initSingleCell = function(cell)
	local moveNode = display.newNode()
	cell:addChild(moveNode, Z_ORDER_CELL.moveLine)
	moveNode:setGroupID(GROU_ID.group_moveline)
	moveNode:setGroupAuto(true)
	moveNode:setName("moveNode")
	_UPVALUE9_ = moveNode.setName
	moveNode.setName[1] = "moveLineBgNode"
	moveNode.setName[2] = "moveLineBgNode_self"
	moveNode.setName[3] = "romanSoulNode"
	moveNode.setName[4] = "tradeNode"
	moveNode.setName[5] = "tradeNode_self"
	moveNode.setName[6] = "moveLineNode_Mini"
	moveNode.setName[7] = "moveLineNode_Mini_self"
	moveNode.setName[8] = "moveLineNode"
	local moveNode.setName[9], moveLine = "moveLineNode_self", moveNode.setName
	for _, v in ipairs(moveLine) do
		local node = display.newNode()
		moveNode:addChild(node)
		node:setName(v)
		cell[v] = node
	end
end
local updateMatrix = function(cell, isShowSelfOnly)
	_UPVALUE5_ = nil
	;(nil)[1] = "moveLineBgNode"
	;(nil)[2] = "romanSoulNode"
	;(nil)[3] = "tradeNode"
	;(nil)[4] = "moveLineNode_Mini"
	local (nil)[5], moveTroop = "moveLineNode", nil
	for _, v in ipairs(moveTroop) do
		local moveNode = cell[v]
		if moveNode then
			moveNode:setVisible(not isShowSelfOnly)
		end
	end
end
local updateMoveLine = function(cell, hide)
	local moveNode = cell.moveLineBgNode_self
	if moveNode then
		moveNode:setVisible(not hide)
	end
end
function worldMapComMoveline:updateViewCell(fun, ...)
	for _, mapViewCell in ipairs(self.target_.mapViewCellArray) do
		fun(mapViewCell, ...)
	end
end
function worldMapComMoveline:init()
	worldMapComMoveline.super.init(self)
	self.mapClassType = self.target_.mapClassType
	self.revertScale = 1
	self.isHideMoveLine = false
	self.isShowSelfOnly = false
	self.lod = 1
	self.lodCheck = 1
	self:updateViewCell(initSingleCell)
end
function worldMapComMoveline:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_REMOVE_MOVELINE", handler(self, self.removeMoveLine))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_MOVELINE_ADD", handler(self, self.serverMessage_AddMoveLines))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_MOVELINE_REMOVE", handler(self, self.serverMessage_RemoveMoveLines))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_MOVELINE_MODIFY", handler(self, self.serverMessage_ModifyMoveLine))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_MOVELINE_ALL_HIDE", handler(self, self.serverMessage_HideAllMoveLine))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_MOVELINE_OUT_IN", handler(self, self.serverMessage_OutInCityMoveLine))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_MOVELINE_ALL_SHOW", handler(self, self.serverMessage_ShowAllMoveLine))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_REFRESH", handler(self, self.serverMessage_ShowAllMoveLine))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_WAR_SETTING_MOVELINE", handler(self, self.serverMessage_ShowAllMoveLine))
	SoraDAddMessage(self, "MESSAGE_WORLD_MAP_TOGGLE_TROOP_PRIORITY", handler(self, self.toggleClickPriority))
	local worldMapEvent = include("worldMapEvent")
	self:addEventListener(worldMapEvent.EVENT_UPDATE_INFO, handler(self, self.updateInfo))
	self:addEventListener(worldMapEvent.EVENT_UPDATE_PIECE, handler(self, self.setViewPieceIds))
	self:addEventListener(worldMapEvent.EVENT_SCROLL_LOD_CHANGE, handler(self, self.updateLodChange))
	self:addEventListener(worldMapEvent.EVENT_SCROLL_ZOOM, handler(self, self.updateScaleZoom))
	self:addEventListener(worldMapEvent.EVENT_CELL_SWAP, handler(self, self.updateCellSwap))
end
function worldMapComMoveline:serverMessage_ShowAllMoveLine()
	self.updateShowMoveLineDataArray, kingdomMapCtrl = nil, nil
	kingdomMapCtrl:refreshShowHideMoveLine()
	self:removeAllMoveLines(false)
	self.target_.preCenterPoint = nil
	self.target_:updateCenterAreaTiles()
end
function worldMapComMoveline:serverMessage_OutInCityMoveLine(target, data)
	local outInType = data.outInType
	if outInType == worldMapDefine.moveLineOutInCityType_Out then
		SoraDPlaySound("worldmap", 4)
	elseif outInType == worldMapDefine.moveLineOutInCityType_In then
		SoraDPlaySound("worldmap", 4)
	end
end
function worldMapComMoveline:removeMoveLine(target, data)
	local moveLineID = data.moveLineID
	local delayTime = data.delayTime or 0
	local moveLine = self.currentShowMoveLineArray[moveLineID]
	if moveLine then
		self.updateRemoveMoveLineArray[moveLine] = delayTime
	end
end
function worldMapComMoveline:removeAllMoveLines(haveSelf)
	if haveSelf == nil then
		haveSelf = true
	end
	for _, v in pairs(self.currentShowMoveLineArray) do
		if not haveSelf then
			local moveLine = v
			local troopInstance = moveLine:getTroopInstance()
			if not troopInstance:isSelfTroop(self.myPlayerID) then
				self.updateRemoveMoveLineArray[v] = 0
			end
		else
			self.updateRemoveMoveLineArray[v] = 0
		end
	end
end
function worldMapComMoveline:serverMessage_HideAllMoveLine()
	if worldMapDefine.isInNebula() then
		for _, v in pairs(self.currentShowMoveLineArray) do
			local moveLine = v
			local troopInstance = moveLine:getTroopInstance()
			if not troopInstance:isSelfTroop(self.myPlayerID) and not troopInstance:checkIsOfficialTeam() then
				self.updateRemoveMoveLineArray[v] = 0
			end
		end
	else
		self:removeAllMoveLines(false)
	end
end
function worldMapComMoveline:serverMessage_AddMoveLines(target, data)
	local moveLienDataArray = data.data
	for _, v in pairs(moveLienDataArray) do
		local key = v.id
		if key then
			local moveLine = self.currentShowMoveLineArray[key]
			if not moveLine or moveLine:getMoveLineID() ~= key then
				v.delayTime_client = worldMapUtil.getDelayTime(v)
				self.updateShowMoveLineDataArray[v.id] = v
			end
		end
	end
end
function worldMapComMoveline:serverMessage_RemoveMoveLines(target, data)
	for _, v in pairs(data.data) do
		if v.id then
			local moveLine = self.currentShowMoveLineArray[v.id]
			if moveLine then
				local delayTime = worldMapUtil.getDelayTime(v)
				local troopInstance = moveLine:getTroopInstance()
				if troopInstance and not tolua.isnull(troopInstance) then
					troopInstance:setMatrixState(gMapMoveLineStatusType.moveLineStatusTypeFinished, delayTime)
				else
					self.updateRemoveMoveLineArray[moveLine] = delayTime
				end
			elseif self.updateShowMoveLineDataArray[v.id] then
				self.updateShowMoveLineDataArray[v.id] = nil
			end
		end
	end
end
function worldMapComMoveline:serverMessage_ModifyMoveLine(target, data)
	for _, v in pairs(data.data) do
		local moveLineData = v
		local delayTime = worldMapUtil.getDelayTime(moveLineData)
		local moveLineID = moveLineData.id
		local moveLineState = moveLineData.status
		local moveLineColor
		local moveLine = self.currentShowMoveLineArray[moveLineID]
		local moveTimeData, isAttacked, isBuff, leagueID, isRecall, effectId, armyData, emoji
		if moveLineData.updateData then
			local curTime = serviceFunctions.systemTime()
			_ENV = nil
			;(nil).moveTimeSpan = moveLineData.updateData.moveTimeSpan
			moveTimeData, (nil).currentMoveTime = nil, curTime - (moveLineData.statusStartTime or curTime)
			if moveTimeData.currentMoveTime == 0 and moveTimeData.moveTimeSpan then
				for _, t in pairs(moveTimeData.moveTimeSpan) do
					if t.isPast then
						moveTimeData.currentMoveTime = moveTimeData.currentMoveTime + t.time
					end
				end
			end
			if moveLineData.updateData.moveLineColor then
				moveLineColor = moveLineData.updateData.moveLineColor
			elseif moveLineData.updateData.leagueID then
				local queueData = kingdomMapCtrl.kingdomMapCell.mapQueueMgr:getQueue(moveLineID)
				if queueData then
					kingdomMapCtrl.kingdomMapCell:setMoveLineColor(queueData)
					moveLineColor = queueData.moveLineColor
				end
			end
			effectId = moveLineData.updateData.effectId
			armyData = moveLineData.updateData.army
			isAttacked = moveLineData.updateData.isAttacked
			if moveLineData.updateData.buff ~= nil then
				if moveLineData.updateData.buff ~= 0 then
					isBuff = true
				else
					isBuff = false
				end
			else
				isBuff = nil
			end
			leagueID = moveLineData.updateData.leagueID
			isRecall = moveLineData.updateData.isRecall
			emoji = moveLineData.updateData.emoji
		end
		if moveLine then
			local troopInstance = moveLine:getTroopInstance()
			if troopInstance then
				if moveTimeData then
					troopInstance:setMoveTimeData(moveTimeData)
				end
				if moveLineState then
					troopInstance:setMatrixState(moveLineState, delayTime, true)
				end
				if moveLineColor then
					troopInstance:setMoveLineColor(moveLineColor)
				end
				if effectId ~= nil and troopInstance.setMedalEffect then
					troopInstance:setMedalEffect(effectId)
				end
				if isAttacked ~= nil and troopInstance.setIsAttacked then
					troopInstance:setIsAttacked(isAttacked)
				end
				if isBuff ~= nil and troopInstance.setIsBuff then
					troopInstance:setIsBuff(isBuff)
				end
				if leagueID ~= nil then
					troopInstance.leagueID = leagueID
				end
				if isRecall ~= nil then
					troopInstance.isRecall = isRecall
				end
				if armyData then
					troopInstance:setArmyData(armyData)
				end
				if emoji then
					troopInstance:setEmojiID(emoji)
				end
			end
		end
	end
end
function worldMapComMoveline:updateCellSwap()
	self:cleanData()
end
function worldMapComMoveline:cleanData()
	for _, v in pairs(self.currentShowMoveLineArray) do
		local moveLine = v
		if moveLine and moveLine.deleteMoveLine then
			moveLine:deleteMoveLine(0)
		end
	end
	for moveLine, _ in pairs(self.waitingDeleteMoveLine) do
		moveLine:setDeleteCallback(nil)
		moveLine:deleteMoveLine(0)
	end
	self.waitingDeleteMoveLine, _ENV, self.updateMoveModel, _ENV, self.updateRemoveMoveLineArray, _ENV, self.updateDeleteMoveLineDataArrary, _ENV, self.updateShowMoveLineDataArray, _ENV, self.currentShowMoveLineArray, _ENV = pairs(self.waitingDeleteMoveLine)
end
function worldMapComMoveline:resetData()
	self.waitingDeleteMoveLine, gametop, self.viewPiecePosList, gametop, self.updateMoveModel, gametop, self.updateRemoveMoveLineArray, gametop, self.updateDeleteMoveLineDataArrary, gametop, self.updateShowMoveLineDataArray, gametop, self.currentShowMoveLineArray, gametop = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	self.myKindomID = gametop.playertop_:getMapID()
	self.myPlayerID = gametop.playertop_:getPlayerID()
end
function worldMapComMoveline:updateInfo(event)
	self:updateDeleteMoveLine()
	local isMoved = event.isMoved
	if not isMoved then
		self:updateShowMoveLine()
	end
	self:checkVisibleMoveLine()
end
function worldMapComMoveline:updateShowMoveLine()
	local index, value = next(self.updateShowMoveLineDataArray)
	if index and value then
		local showMoveLineData = value
		self.updateShowMoveLineDataArray[value.id] = nil
		self:createMapMoveLine(showMoveLineData)
	end
end
function worldMapComMoveline:createMapMoveLine(moveLineData)
	local lineID = moveLineData.id
	local moveLine = self.currentShowMoveLineArray[lineID]
	if moveLine then
		return
	end
	if allianceWarSettingCtrl:checkIsFilerMoveLine(moveLineData) then
		return
	end
	local kingdomID = moveLineData.kingdomId or self.myKindomID
	local mapViewCell = self.target_:getWorldMapCell(kingdomID)
	if not mapViewCell then
		return
	end
	moveLine = movelineFactory.createMapMoveLine(mapViewCell, moveLineData, self.viewPiecePosList, self.isLod, self.mapClassType, self.lodCheck)
	if not moveLine then
		return
	end
	moveLine:doScaleZoom(self.revertScale)
	allianceWarSettingCtrl, self.currentShowMoveLineArray[lineID] = self.currentShowMoveLineArray, moveLine
	self.currentShowMoveLineArray.moveLine = moveLine
	local self.currentShowMoveLineArray.delayTime, deleteMoveLineData = 0, self.currentShowMoveLineArray
	table.insert(self.updateDeleteMoveLineDataArrary, 1, deleteMoveLineData)
	return moveLine
end
function worldMapComMoveline:checkVisibleMoveLine()
	local countNum = 0
	for _, v in pairs(self.currentShowMoveLineArray) do
		local troopInstance = v:getTroopInstance()
		if troopInstance and not tolua.isnull(troopInstance) and troopInstance:isVisible() then
			troopInstance:updateCheckVisible()
		end
		countNum = countNum + 1
	end
	if G_IS_UNITY and not worldMapDefine.moveLineAutoHideOption.isSwitchShow then
		local limitNum = worldMapDefine.moveLineAutoHideOption.getLimitLineNum()
		if countNum >= limitNum then
			_ENV = pairs(self.currentShowMoveLineArray)
			pairs(self.currentShowMoveLineArray).msg = "MESSAGE_MOVELINE_SWITCH_UPDATE"
			pairs(self.currentShowMoveLineArray).isShow = true
			SoraDSendMessage(pairs(self.currentShowMoveLineArray))
		end
	end
end
function worldMapComMoveline:updateDeleteMoveLine(dt)
	if #self.updateDeleteMoveLineDataArrary > 0 then
		local deleteData = table.remove(self.updateDeleteMoveLineDataArrary, 1)
		if self:updateDeleteMoveLine_imp(deleteData) then
			table.insert(self.updateDeleteMoveLineDataArrary, deleteData)
		end
	end
	if next(self.updateRemoveMoveLineArray) then
		local moveLine, delayTime = next(self.updateRemoveMoveLineArray)
		if moveLine then
			self.updateRemoveMoveLineArray[moveLine] = nil
			self:updateDeleteMoveLine_one(moveLine, delayTime, true)
		end
	end
	if 0 < #self.updateMoveModel then
		local moveLine = table.remove(self.updateMoveModel, 1)
		self:updateMoveModel_one(moveLine)
	end
end
function worldMapComMoveline:updateMoveModel_one(moveLine)
	if not moveLine then
		return
	end
	if not moveLine.__cname then
		return
	end
	local worldMapCell = moveLine:getWorldMapCell()
	if not worldMapCell then
		return
	end
	local troopInstance = moveLine:getTroopInstance()
	if tolua.isnull(troopInstance) then
		return
	end
	troopInstance:updateModelState(self.revertScale)
end
function worldMapComMoveline:removeFromDeleteCheckArray(moveLine)
	if not moveLine then
		return
	end
	for i = #self.updateDeleteMoveLineDataArrary, 1, -1 do
		local deleteData = self.updateDeleteMoveLineDataArrary[i]
		if deleteData and deleteData.moveLine == moveLine then
			table.remove(self.updateDeleteMoveLineDataArrary, i)
		end
	end
	for i = #self.updateMoveModel, 1, -1 do
		if self.updateMoveModel[i] == moveLine then
			table.remove(self.updateMoveModel, i)
		end
	end
end
function worldMapComMoveline:deleteMoveLineFunction(moveLine, delayTime)
	local moveLineID = moveLine:getMoveLineID()
	if moveLineID then
		self.currentShowMoveLineArray[moveLineID] = nil
	end
	self.updateRemoveMoveLineArray[moveLine] = nil
	self:removeFromDeleteCheckArray(moveLine)
	moveLine:deleteMoveLine(delayTime)
	if 0 < delayTime then
		self.waitingDeleteMoveLine[moveLine] = true
		moveLine:setDeleteCallback(function()
			self.waitingDeleteMoveLine[moveLine] = nil
		end)
	end
end
function worldMapComMoveline:updateDeleteMoveLine_imp(deleteData)
	local moveLine = deleteData.moveLine
	local delayTime = deleteData.delayTime
	return self:updateDeleteMoveLine_one(moveLine, delayTime, false)
end
function worldMapComMoveline:updateDeleteMoveLine_one(moveLine, delayTime, goRemove)
	if moveLine then
		if not moveLine.__cname then
			return
		end
		local worldMapCell = moveLine:getWorldMapCell()
		if not worldMapCell then
			return
		end
		local moveLineID = moveLine:getMoveLineID()
		if moveLineID and self.currentShowMoveLineArray[moveLineID] ~= moveLine then
			return
		end
		if worldMapCell.kingdomID ~= moveLine:getKingdomID() or worldMapCell ~= self.target_.currentInMapViewCell then
			goRemove = true
		end
		if goRemove then
			self:deleteMoveLineFunction(moveLine, delayTime)
		else
			local point1 = moveLine:getShowTilePointBegin()
			local point2 = moveLine:getShowTilePointEnd()
			local isLineOutRect = mapSyncUtilClient.isLineOutRect(self.viewPiecePosList, point1, point2, self.mapClassType, self.lodCheck)
			if isLineOutRect then
				self:deleteMoveLineFunction(moveLine, delayTime)
			else
				return true
			end
		end
	end
end
function worldMapComMoveline:createMoveLineByLocalQueue(queueID, queueData)
	local queues = kingdomMapCtrl.kingdomMapCell:createMapQueueDataByID(queueID)
	if queues and queues:isWorking() then
		return
	end
	queues = queues or queueData
	if queues then
		local moveLine = self:createMapMoveLine(queues)
		if moveLine then
			local troopInstance = moveLine:getTroopInstance()
			if troopInstance then
				troopInstance:setVisible(true)
				self.target_.preClockTime = nil
				return true
			end
		end
	end
end
function worldMapComMoveline:setViewPieceIds(event)
	local viewPieceIDs = event.viewPieceIDs
	local _ENV, viewPiecePosList
	self.lodCheck = event.lod
	for _, v in pairs(viewPieceIDs) do
		if v then
			for _, id in pairs(v) do
				local posx, posy = mapSyncUtil:getPiecePosFromPieceId(id)
				_UPVALUE2_ = nil
				;(nil)[1] = posx
				;(nil)[2] = posy
				table.insert(viewPiecePosList, nil)
			end
		end
	end
	self.viewPiecePosList = viewPiecePosList
end
function worldMapComMoveline:getMoveLineShow(data)
	local moveLineID = data.moveLineID
	local moveLine = self.currentShowMoveLineArray[moveLineID]
	if not moveLine then
		if self.target_.getCommandHallMoveLine then
			local moveLine = self.target_:getCommandHallMoveLine(moveLineID)
			if moveLine then
				return moveLine
			end
		end
		if self.target_.getSpecialMoveLine then
			local moveLine = self.target_:getSpecialMoveLine(moveLineID)
			if moveLine then
				return moveLine
			end
		end
		if self:createMoveLineByLocalQueue(moveLineID, data.queueData) then
			moveLine = self.currentShowMoveLineArray[moveLineID]
			if not moveLine then
				SoraDShowMsgTip(i18n("common_text_2494"))
				return
			end
		else
			SoraDShowMsgTip(i18n("common_text_2494"))
			return
		end
	end
	return moveLine
end
function worldMapComMoveline:checkClickMoveLine(pos)
	local _checkClickMoveLine = function(moveLine, pos)
		local troopInstance = moveLine:getTroopInstance()
		if troopInstance:isVisible() and troopInstance:checkClickMoveLine(pos) then
			return true
		end
	end
	for _, v in pairs(self.currentShowMoveLineArray) do
		if _checkClickMoveLine(v, pos) then
			return true
		end
	end
	if self.target_.getCommandHallMoveLine then
		local moveLine = self.target_:getCommandHallMoveLine()
		if moveLine and _checkClickMoveLine(moveLine, pos) then
			return true
		end
	end
	return false
end
function worldMapComMoveline:toggleClickPriority()
	for _, v in pairs(self.currentShowMoveLineArray) do
		local moveLine = v
		local troopInstance = moveLine:getTroopInstance()
		if troopInstance then
			troopInstance:toggleClickPriority()
		end
	end
	return false
end
function worldMapComMoveline:delUnshowMoveLine()
	local _ENV, showMoveLineArray
	for _, v in pairs(self.updateDeleteMoveLineDataArrary) do
		if self:updateDeleteMoveLine_imp(v) then
			table.insert(showMoveLineArray, v)
		end
	end
	self.updateDeleteMoveLineDataArrary = showMoveLineArray
	for moveLine, delayTime in pairs(self.updateRemoveMoveLineArray) do
		self:updateDeleteMoveLine_one(moveLine, delayTime, true)
	end
	self.updateRemoveMoveLineArray, _ENV = pairs(self.updateRemoveMoveLineArray)
end
local LOD2 = worldMapDefine.worldLodDef.LOD2
local LOD6 = worldMapDefine.worldLodDef.LOD6
local LOD3 = worldMapDefine.worldLodDef.LOD3
function worldMapComMoveline:updateLodChange(event)
	self.lod = event.lod
	local isShowSelfOnly = self.lod >= LOD3
	if self.isShowSelfOnly ~= isShowSelfOnly then
		self.isShowSelfOnly = isShowSelfOnly
		self:updateViewCell(updateMatrix, isShowSelfOnly)
		if self.isShowSelfOnly then
			self:removeAllMoveLines(false)
		end
	end
	local isLod = self.lod >= LOD2
	if self.isLod ~= isLod then
		self.isLod = isLod
		for _, v in pairs(self.currentShowMoveLineArray) do
			if v:doLodChange(self.isLod) then
				table.insert(self.updateMoveModel, v)
			end
		end
	end
	local isHideMoveLine = self.lod >= LOD6
	if self.isHideMoveLine ~= isHideMoveLine then
		self.isHideMoveLine = isHideMoveLine
		self:updateViewCell(updateMoveLine, isHideMoveLine)
	end
	self.updateShowMoveLineDataArray, LOD3 = self.updateViewCell, self.updateViewCell
end
function worldMapComMoveline:updateScaleZoom(event)
	if not self.isLod then
		return
	end
	local scale = event.revertScale
	self.revertScale = scale
	for _, v in pairs(self.currentShowMoveLineArray) do
		v:doScaleZoom(scale)
	end
end
function worldMapComMoveline:exportMethods()
	_UPVALUE3_ = nil
	;(nil)[1] = "checkClickMoveLine"
	;(nil)[2] = "delUnshowMoveLine"
	;(nil)[3] = "getMoveLineShow"
	self:exportMethods_(nil)
	return self.target_
end
return worldMapComMoveline
