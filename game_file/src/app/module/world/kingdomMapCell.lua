local kingdomMapCell = class("kingdomMapCell")
local kingdomMapUtil = include("kingdomMapUtil")
local warBuildingOwnerMgr = include("warBuildingOwnerMgr")
local gametop = gModuleMgr.getObject("gametop")
local npcconfigData = include("npcconfig")
local kingdomQueueObjCell = include("kingdomQueueObjCell")
local localQueueRoot = include("localQueueRoot")
local mapQueueRoot = include("mapQueueRoot")
local mapObjRoot = include("mapObjRoot")
local gMapMoveLineServerType = _G.gMapMoveLineServerType
function kingdomMapCell:ctor(kid, uid)
	self.uid = uid
	self.kid = kid
	self:initData()
end
function kingdomMapCell:initData()
	self.inWarMarchSpeedUp, warBuildingOwnerMgr, self.addPieceIds, warBuildingOwnerMgr, self.viewPieceIDs, warBuildingOwnerMgr, self.mapWarStatus, warBuildingOwnerMgr, self.isSafe = nil, nil, nil, nil, nil, nil, nil, nil, false
	self.warBuildingOwnerMgr = warBuildingOwnerMgr.new()
	self.localQueueRoot = localQueueRoot.new(self)
	self.maxNpcLevel = 1
	self.localQueueMgr = self.localQueueRoot.localQueueMgr
	self.localMassQueueMgr = self.localQueueRoot.localMassQueueMgr
	self.localUserQueueMgr = self.localQueueRoot.localUserQueueMgr
	self.localPosQueueMgr = self.localQueueRoot.localPosQueueMgr
	self.localWarHallQueueMgr = self.localQueueRoot.localWarHallQueueMgr
	self.localWatchTowerQueueMgr = self.localQueueRoot.localWatchTowerQueueMgr
	self.mapQueueRoot = mapQueueRoot.new(self)
	self.mapQueueMgr = self.mapQueueRoot.mapQueueMgr
	self.mapPieceQueueMgr = self.mapQueueRoot.mapPieceQueueMgr
	self.mapPosQueueMgr = self.mapQueueRoot.mapPosQueueMgr
	self.mapObjRoot = mapObjRoot.new(self)
	self.mapObjMgr = self.mapObjRoot.mapObjMgr
	self.mapPieceObjMgr = self.mapObjRoot.mapPieceObjMgr
	self.mapNpcObjMgr = self.mapObjRoot.mapNpcObjMgr
	self.mapAllianceObjMgr = self.mapObjRoot.mapAllianceObjMgr
	self.allianceBuildData = include("allianceBuildData").new(self)
end
function kingdomMapCell:getAllQueueLiveArmy(filterQueueIds)
	local _ENV, liveArmyMap
	local myQueues = self.localUserQueueMgr:getFromUserQueueMap(self.uid)
	for _, queue in pairs(myQueues) do
		if not filterQueueIds or not filterQueueIds[queue:getId()] then
			local liveArmyList = queue:getFromLiveArmy()
			if liveArmyList then
				for _, army in pairs(liveArmyList) do
					liveArmyMap[army.id] = (liveArmyMap[army.id] or 0) + army.num
				end
			end
		end
	end
	return liveArmyMap
end
function kingdomMapCell:getAllQueueWoundedArmy(filterQueueIds)
	local _ENV, woundedArmyMap
	local myQueues = self.localUserQueueMgr:getFromUserQueueMap(self.uid)
	for _, queue in pairs(myQueues) do
		if not filterQueueIds or not filterQueueIds[queue:getId()] then
			local woundedArmyList = queue:getFromWoundedArmy()
			if woundedArmyList then
				for id, num in pairs(woundedArmyList) do
					woundedArmyMap[tonumber(id)] = (woundedArmyMap[tonumber(id)] or 0) + num
				end
			end
		end
	end
	return woundedArmyMap
end
function kingdomMapCell:hasWoundedQueueArmy()
	local woundedArmyMap = self:getAllQueueWoundedArmy()
	for _, num in pairs(woundedArmyMap) do
		if 0 < num then
			return true
		end
	end
	return false
end
function kingdomMapCell:hasMyQueueToMapObj(mapObjId, queueType, queueStatus)
	return self.localUserQueueMgr:hasFromUserQueue(self.uid, nil, queueType, queueStatus, mapObjId)
end
function kingdomMapCell:hasMyQueue2MapObj(mapObjId, moveLineType, queueStatus)
	return self.localUserQueueMgr:hasFromUserQueue(self.uid, moveLineType, nil, queueStatus, mapObjId)
end
function kingdomMapCell:hasMyWarQueue()
	local myQueues = self.localUserQueueMgr:getFromUserQueueMap(self.uid)
	for _, queue in pairs(myQueues) do
		if not (queue:getQueueType() ~= gMapMoveLineServerType.moveLineTypeAttackLord and queue:getQueueType() ~= gMapMoveLineServerType.moveLineTypeAttackResource and queue:getQueueType() ~= gMapMoveLineServerType.moveLineTypeAttackCamp and queue:getQueueType() ~= gMapMoveLineServerType.moveLineTypeScout and queue:getQueueType() ~= gMapMoveLineServerType.moveLineTypeMass and (queue:getQueueType() ~= gMapMoveLineServerType.moveLineTypeMassSlave or queue.isBoss)) or queue:getQueueType() == gMapMoveLineServerType.moveLineTypeAttackAllianceBuild or queue:getQueueType() == gMapMoveLineServerType.moveLineTypeMassAllianceBuild then
			return true
		end
	end
	return false
end
function kingdomMapCell:hasOccupyQueue(uid, isExpect)
	return self.localUserQueueMgr:hasFromUserQueue(uid, nil, gMapMoveLineServerType.moveLineTypeOccupy) or self.localUserQueueMgr:hasFromUserQueue(uid, nil, gMapMoveLineServerType.moveLineTypeOccupyMass) or not isExpect and (self.localUserQueueMgr:hasFromUserQueue(uid, nil, gMapMoveLineServerType.moveLineTypeATBuilding) or self.localUserQueueMgr:hasFromUserQueue(uid, nil, gMapMoveLineServerType.moveLineTypeMassATBuilding))
end
function kingdomMapCell:hasWarQueueToMe()
	local toMeQueueMap = self.localUserQueueMgr:getToUserQueueMap(self.uid)
	if toMeQueueMap then
		for _, queue in pairs(toMeQueueMap) do
			if queue:getQueueType() == gMapMoveLineServerType.moveLineTypeAttackLord or queue:getQueueType() == gMapMoveLineServerType.moveLineTypeScout or queue:getQueueType() == gMapMoveLineServerType.moveLineTypeMass then
				return true
			end
		end
	end
	return false
end
function kingdomMapCell:isOpenAllianceRomeActivity(...)
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local romeActivityCtrl = gametop.playertop_:getModule("romeActivityCtrl")
	if allianceMgr:isLeader() and romeActivityCtrl:isOpenAllianceRomeActivity() then
		return true
	end
end
function kingdomMapCell:reqArmyHelpList()
	local gMapMoveLineServerType, helpQueueDataList
	local helpQueueMap = self.localUserQueueMgr:getToUserQueueMap(self.uid, nil, gMapMoveLineServerType.moveLineTypeArmyHelp, gMapMoveLineStatusType.moveLineStatusTypeWorking)
	for _, helpQueue in pairs(helpQueueMap) do
		gMapMoveLineServerType = nil
		;(nil).data = helpQueue
		table.insert(helpQueueDataList, nil)
	end
	if next(helpQueueDataList) then
		gMapMoveLineServerType = helpQueueDataList
		helpQueueDataList.msg = "MESSAGE_REINFORCEMENTS_ADD"
		helpQueueDataList.data = helpQueueDataList
		SoraDSendMessage(helpQueueDataList, nil)
	end
end
function kingdomMapCell:isLockByOtherPlayer(x, y, mapObjType)
	local toPosQueueMap = self.mapPosQueueMgr:getToPosQueueMap(x, y)
	if toPosQueueMap then
		for _, queueData in pairs(toPosQueueMap) do
			if mapObjType == gMapObjTypeDef.mapObjTypeResource then
				if queueData.uid ~= self.uid then
					return true
				end
			else
				return true
			end
		end
	end
	return false
end
function kingdomMapCell:isLockByDigTreasure(x, y)
	local toPosQueueMap = self.localPosQueueMgr:getToPosQueueMap(x, y)
	if toPosQueueMap then
		for _, queue in pairs(toPosQueueMap) do
			if queue:getToMapType() == gMapObjTypeDef.mapObjTypeTreasure or queue:getToMapType() == gMapObjTypeDef.mapTypePlain then
				return true
			end
		end
	end
	return false
end
function kingdomMapCell:noticeScoutRecordChanged2UI(mapCellId, uid, x, y, hasScoutRecord)
	if uid then
		_UPVALUE0_ = nil
		_UPVALUE0_, (nil).id = nil, mapCellId
		;(nil).user, (nil).hasScoutRecord = nil, hasScoutRecord
		local mapObjData
		self:onUpdateMapObjLocal(mapObjData)
	end
end
function kingdomMapCell:onJoinAlliance(aid)
	self:resetMapAllQueueColor(aid)
end
function kingdomMapCell:onQuitAlliance(aid)
	self:resetMapAllQueueColor(0)
end
function kingdomMapCell:resetMapAllQueueColor(selfAid)
	local allMapQueue = self.mapQueueMgr:getAllQueue()
	if allMapQueue then
		if not selfAid then
			local allianceMgr = gametop.playertop_:getModule("allianceMgr")
			selfAid = allianceMgr:getOwnTeamID()
		end
		for _, queueData in pairs(allMapQueue) do
			if self:setMoveLineColor(queueData, selfAid) then
				self:notifyQueueColorChanged(queueData.id, queueData.moveLineColor)
			end
		end
	end
end
function kingdomMapCell:resetBuildQueueColorByQueue(localQueue)
	if localQueue then
		local queue = self.mapQueueMgr:getQueue(localQueue:getId())
		if queue and self:setMoveLineColor(queue) then
			self:notifyQueueColorChanged(queue.id, queue.moveLineColor)
		end
	end
end
function kingdomMapCell:getMoveLineData(queueId)
	return self.mapQueueMgr:getQueue(queueId)
end
function kingdomMapCell:getMapInstanceData(instanceID)
	return self.mapObjMgr:getMapObj(instanceID)
end
function kingdomMapCell:getAllMapObj()
	return self.mapObjMgr:getAllMapObj()
end
function kingdomMapCell:getVersion(kid)
	return self.allianceBuildData:getVersion(kid)
end
function kingdomMapCell:getAllBuildByKid(kid)
	return self.allianceBuildData:getAllBuildByKid(kid)
end
function kingdomMapCell:onAddAllianceBuild(data, msg)
	local kid = msg.kid
	local aid = msg.aid
	local colorId = msg.colorId
	self.allianceBuildData:addMapObjArray(data, kid, aid, colorId)
end
function kingdomMapCell:onRemoeeAllianceBuild(kid)
	self.allianceBuildData:resetAllBuildByKid(kid)
end
function kingdomMapCell:onAddAllianceBuildEnd(data, msg)
	local kid = msg.kid
	local ver = msg.ver
	local version = self.allianceBuildData:getVersion(kid)
	local change = version ~= ver
	if change then
		self.allianceBuildData:setVersion(kid, ver)
		self:sendAllianceBuildData(kid)
	end
end
function kingdomMapCell:sendAllianceBuildData(kid)
	local data = self.allianceBuildData:getAllBuildByKid(kid)
	_ENV = kid
	kid.msg = "MESSAGE_SERVER_WORLD_MAP_ALLIANCE_BUILD"
	kid.kid = kid
	kid.dataEnd = true
	kid.data = data
	SoraDSendMessage(kid)
end
function kingdomMapCell:onAllianceSelfAdd(data, msg)
	local kid = msg.kid
	if not self:getVersion(kid) then
		return
	end
	local aid = msg.aid
	local colorId = msg.colorId
	self.allianceBuildData:addMapObj(data, kid, aid, colorId)
	self:onAllianceBuildMsg(data, msg, worldMapLeagueManorUpdateType.leagueManorInstanceAdd)
end
function kingdomMapCell:onAllianceSelfUpdate(data, msg)
	local kid = msg.kid
	if not self:getVersion(kid) then
		return
	end
	local aid = msg.aid
	self.allianceBuildData:addMapObj(data, kid, aid)
	self:onAllianceBuildMsg(data, msg, worldMapLeagueManorUpdateType.leagueManorInstanceActiviy)
end
function kingdomMapCell:onAllianceSelfRemove(data, msg)
	local kid = msg.kid
	if not self:getVersion(kid) then
		return
	end
	local oldData = self.allianceBuildData:getMapObj(kid, data)
	if oldData then
		self:onAllianceBuildMsg(oldData, msg, worldMapLeagueManorUpdateType.leagueManorInstanceRemove)
	end
	self.allianceBuildData:removeMapObj(data, kid)
end
function kingdomMapCell:onAddStrongHold(data, msg)
	local kid = msg.kid
	self.allianceBuildData:addStrongHoldArray(data, kid)
end
function kingdomMapCell:onUpdateStrongHold(data, msg)
	local kid = msg.kid
	if not self:getVersion(kid) then
		return
	end
	local oldData = self.allianceBuildData:getMapObj(kid, data)
	if oldData then
		self:onAllianceBuildMsg(oldData, msg, worldMapLeagueManorUpdateType.leagueManorInstanceRemove)
	end
	self.allianceBuildData:updateStrongHold(data, kid)
	self:onAllianceBuildMsg(data, msg, worldMapLeagueManorUpdateType.leagueManorInstanceAdd)
end
function kingdomMapCell:onAllianceBuildMsg(data, msg, updateType)
	local kid = msg.kid
	local ver = msg.ver
	local version = self.allianceBuildData:getVersion(kid)
	local change = version ~= ver
	if change then
		self.allianceBuildData:setVersion(kid, ver)
	end
	_ENV = self.allianceBuildData
	self.allianceBuildData.msg = "MESSAGE_SERVER_WORLD_MAP_ALLIANCE_BUILD_SELF"
	self.allianceBuildData.kid = kid
	self.allianceBuildData.data = data
	self.allianceBuildData.updateType = updateType
	SoraDSendMessage(self.allianceBuildData)
end
function kingdomMapCell:onUpdateAllianceVersion(data, msg)
	local kid = msg.kid
	local ver = msg.ver
	local version = self.allianceBuildData:getVersion(kid)
	if version ~= ver then
		self.allianceBuildData:resetAllBuildByKid(kid)
	end
end
function kingdomMapCell:resetBuildQueueColor(x, y, selfAid, targetAid)
	local posQueues = self.mapPosQueueMgr:getToPosQueueMap(x, y)
	if posQueues then
		if not selfAid then
			local allianceMgr = gametop.playertop_:getModule("allianceMgr")
			selfAid = allianceMgr:getOwnTeamID()
		end
		for _, queueData in pairs(posQueues) do
			if self:setMoveLineColor(queueData, selfAid, targetAid) then
				self:notifyQueueColorChanged(queueData.id, queueData.moveLineColor)
			end
		end
	end
end
function kingdomMapCell:getMoveLineColor(queueData, selfAid, targetAid)
	if self.uid == queueData.playerID then
		return gMapMoveLineColor.moveLineColorGreen
	else
		if not selfAid then
			local allianceMgr = gametop.playertop_:getModule("allianceMgr")
			selfAid = allianceMgr:getOwnTeamID()
		end
		if serviceFunctions.isSameButNotNil(selfAid, queueData.alliance) then
			return gMapMoveLineColor.moveLineColorBlue
		else
			if worldMapDefine.isInNebulaEmperor() then
				return gMapMoveLineColor.moveLineColorRed
			end
			if queueData.queueType == gMapMoveLineServerType.moveLineTypeOccupy or queueData.queueType == gMapMoveLineServerType.moveLineTypeOccupyMass or queueData.queueType == gMapMoveLineServerType.moveLineTypeATBuilding or queueData.queueType == gMapMoveLineServerType.moveLineTypeMassATBuilding then
				if not targetAid then
					targetAid = queueData.toAlliance
					if not targetAid then
						local workingQueue = self.localPosQueueMgr:getOneWorkingMainQueue(queueData.to.x, queueData.to.y)
						targetAid = workingQueue and workingQueue:getAid()
					end
				end
				if serviceFunctions.isSameButNotNil(selfAid, targetAid) and selfAid ~= queueData.alliance then
					return gMapMoveLineColor.moveLineColorRed
				end
			elseif queueData.queueType == gMapMoveLineServerType.npcOccupyNebulaDefenceWar then
				return gMapMoveLineColor.moveLineColorRed
			elseif (serviceFunctions.isSameButNotNil(selfAid, queueData.toAlliance) or self.uid == queueData.targetUid) and queueData.isPlayerWarQueue then
				return gMapMoveLineColor.moveLineColorRed
			end
			local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
			if queueData.alliance and queueData.alliance > 0 then
				local allianceRelationType = allianceRelationCtrl:getRelationTypeWith(queueData.alliance)
				if allianceRelationType == gMapAllianceRelationType.ALLY then
					return gMapMoveLineColor.moveLineColorAzure
				elseif allianceRelationType == gMapAllianceRelationType.FRIENDLY then
					return gMapMoveLineColor.moveLineColorYellow
				end
			end
		end
	end
	return gMapMoveLineColor.moveLineColorWhite
end
function kingdomMapCell:setMoveLineColor(queueData, selfAid, targetAid)
	local orgColor = queueData.moveLineColor
	if not queueData.isWLCQueue then
		queueData.moveLineColor = self:getMoveLineColor(queueData, selfAid, targetAid)
	end
	return queueData.moveLineColor ~= orgColor
end
function kingdomMapCell:notifyQueueColorChanged(queueId, queueColor)
	local _ENV, msgData
	msgData.updateData, _ENV, msgData.id = nil, nil, queueId
	msgData.updateData.moveLineColor = queueColor
	_ENV = nil
	_UPVALUE1_, (nil).msg = nil, "MESSAGE_SERVER_WORLD_MAP_MOVELINE_MODIFY"
	;(nil).data, (nil)[1] = nil, msgData
	SoraDSendMessage(nil)
end
function kingdomMapCell:noticeMsg(msg)
	if msg.wordMsgType == gWorldMsgType.moveCity then
		self:onMoveCity(msg)
	elseif msg.wordMsgType == gWorldMsgType.protectStatus then
		self:onProtectStatus(msg)
	elseif msg.wordMsgType == gWorldMsgType.errorCode then
		self:onErrorCodeNotice(msg.data.errorCode, msg.data.queueToId, msg.data.errParms)
	elseif msg.wordMsgType == gWorldMsgType.moveCity2OtherKingdom then
		self:onMoveCity2OtherKingdom(msg)
	elseif msg.wordMsgType == gWorldMsgType.maxNpcLevel then
		self:setMaxNpcLevel(msg.data.maxNpcLevel)
	elseif msg.wordMsgType == gWorldMsgType.maxMapNpcLevel then
		self:setMaxMapNpcLevel(msg.data.maxMapNpcLevel)
	elseif msg.wordMsgType == gWorldMsgType.updateQueueRobEscort then
		self:noticeRobEscort(msg)
	elseif msg.wordMsgType == gWorldMsgType.kingWarRankAndPackEndTime then
		self:setKingWarRankAndPackEndTime(msg.data.kingWarRank, msg.data.kingWarPackEndTime)
	elseif msg.wordMsgType == gWorldMsgType.bossRewardsStatus then
		local data = msg.data
		data.canGetBossKillRewards = msg.data.canKill
		data.canGetBossAttackRewards = msg.data.canAttack
		self:setBossRewardsStatus(data, msg.data.bossTypeRewardLimit)
	elseif msg.wordMsgType == gWorldMsgType.forceRandomMoveCity4AllianceWar then
		SoraDShowMsgBox(i18n("common_text_797"), i18n("common_text_054"), nil, nil)
	elseif msg.wordMsgType == gWorldMsgType.forceRandomMoveCity4LegendLordWarInBlackLand then
		print("forceRandomMoveCity4LegendLordWarInBlackLand")
		SoraDShowMsgBox(i18n("legendaryking_text_20"), i18n("common_text_054"), nil, nil)
	elseif msg.wordMsgType == gWorldMsgType.forceMoveCityToCamp4RuinsWar then
	elseif msg.wordMsgType == gWorldMsgType.forbitWarTimeUpdate then
		self:updateForbitWarTime(msg.data)
	elseif msg.wordMsgType == gWorldMsgType.forbidMapObjWarTimeUpdate then
		self:updateForbidMapObjWarTime(msg.data)
	elseif msg.wordMsgType == gWorldMsgType.protect3MinEndStatus then
		if not worldMapDefine.isInNewTrial() then
			SoraDShowMsgTip(i18n("common_text_3477"))
		end
	elseif msg.wordMsgType == gWorldMsgType.kingdomBuff then
		self:setInWarStateData(msg.data)
	elseif msg.wordMsgType == gWorldMsgType.mapFogUnlock then
		dump(msg, "==kingdomMapCell:noticeMsg==", 10)
		local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
		kingdomMapCtrl:setNormalFogData(msg.data)
		_ENV = kingdomMapCtrl
		kingdomMapCtrl.msg = "MESSAGE_WORLDMAP_UNLOCK_NORMAL_FOG"
		SoraDSendMessage(kingdomMapCtrl)
	elseif msg.wordMsgType == gWorldMsgType.changeMapId then
		dump(msg, "changeMapId", 10)
		local mapID = msg.data.mapId
		local teamID = msg.data.teamId
		local mapClassType = worldMapDefine.getKingdomMapClassByKingdomId(mapID)
		local curMapClassType = self:getKingdomClass()
		local updateLocalData = function()
			SoraDFabricLog("noticeMsg setMapID" .. mapID)
			gametop.playertop_:setMapID(mapID)
			self.kid = gametop.playertop_:getMapID()
			local allianceMgr = gametop.playertop_:getModule("allianceMgr")
			allianceMgr:setOwnTeamID(teamID)
			local cityCtrl = gametop.playertop_:getModule("cityCtrl")
			local point = cityCtrl:getCurCityPos()
			local data = msg.data
			local pos = cc.p(data.x and data.x - 1 or point.x, data.y and data.y - 1 or point.y)
			cityCtrl:updateCityPos(pos)
			self:setKingdomClass(mapClassType)
		end
		if mapClassType ~= gKingdomClassType.normal then
			updateLocalData()
			if mapClassType == gKingdomClassType.garden then
				local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
				local point = manorCityCtrl:getTargetPos()
				_ENV = i18n("common_text_3477")
				i18n("common_text_3477").kingdomClass = mapClassType
				_G.SoraDQuickLogin(i18n("common_text_3477"))
			else
				_ENV = manorCityCtrl:getTargetPos()
				manorCityCtrl:getTargetPos().kingdomClass = mapClassType
				_G.SoraDQuickLogin((manorCityCtrl:getTargetPos()))
			end
		elseif mapClassType == gKingdomClassType.normal then
			if curMapClassType == gKingdomClassType.newTrial then
				updateLocalData()
				local devilValleyCtrl = gametop.playertop_:getModule("devilValleyCtrl")
				if not devilValleyCtrl:isNewTrialEnd() then
					_G.SoraDQuickLogin()
				end
			elseif curMapClassType == gKingdomClassType.remains then
				updateLocalData()
				local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
				if not remainsTeamCtrl:isRemainsWarEnd() then
					_G.SoraDQuickLogin()
				end
			elseif curMapClassType == gKingdomClassType.pyramid then
				updateLocalData()
				local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
				if not pyramidWarCtrl:isPyramidEnd() then
					_G.SoraDQuickLogin()
				end
			elseif curMapClassType == gKingdomClassType.radiance then
				updateLocalData()
				local radianceActivityCtrl = gametop.playertop_:getModule("radianceActivityCtrl")
				if not radianceActivityCtrl:isRadianceWarEnd() then
					_G.SoraDQuickLogin()
				end
			elseif curMapClassType == gKingdomClassType.legendLord then
				updateLocalData()
				_G.SoraDQuickLogin()
			elseif curMapClassType == gKingdomClassType.atlantis then
				updateLocalData()
				_G.SoraDQuickLogin()
				local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
				if atlantisActivityCtrl:getSeasonEndData() then
					SoraDDelayCallOnce("ATLANTIS_SHOW_SEASON_END", function()
						atlantisActivityCtrl:showSeasonEnd()
					end, 0.3)
				end
				if msg.data.type == ATLANTIS_WAR_MOVECITY_TYPE.MEMBER_CLASS_0 then
					SoraDDelayCallOnce("ATLANTIS_MEMBER_CLASS_0_QUIT", function()
						SoraDShowMsgBox(i18n("atlantiswar_text_0357"))
					end, 0.3)
				end
			elseif curMapClassType == gKingdomClassType.nebula then
				updateLocalData()
				local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
				if not nebulaActivityCtrl:isNebulaWarEnd() then
					_G.SoraDQuickLogin()
				end
			elseif curMapClassType == gKingdomClassType.nebulaEmperor then
				updateLocalData()
				_G.SoraDQuickLogin()
			elseif curMapClassType == gKingdomClassType.nebulaAllStar then
				updateLocalData()
				local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
				if not nebulaAllStarCtrl:isNebulaAllStarEnd() then
					_G.SoraDQuickLogin()
				end
			elseif curMapClassType == gKingdomClassType.roaringFlame then
				updateLocalData()
				_ENV = _G.SoraDQuickLogin
				_G.SoraDQuickLogin.isRoaringFlame = true
				_G.SoraDQuickLogin(_G.SoraDQuickLogin)
			elseif curMapClassType == gKingdomClassType.simulatedDrill then
				updateLocalData()
				local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
				if not kingdomMapCtrl:getIsBattleEnd(curMapClassType) then
					_G.SoraDQuickLogin()
				end
			elseif curMapClassType == gKingdomClassType.garden then
				updateLocalData()
				local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
				local viewType = manorCityCtrl:getViewType()
				local point = manorCityCtrl:getTargetPos()
				_ENV = 0.3
				;(0.3).viewType = viewType
				_G.SoraDQuickLogin(0.3, point)
			else
				gametop:Logout()
				SoraDShowLoginView(VIEW_TYPE_MAP, mapClassType)
			end
		end
	end
end
function kingdomMapCell:setWarBuildingOwnerMap(kid, warBuildingOwnerMap)
	self.warBuildingOwnerMgr:setWarBuildingOwnerMap(kid, warBuildingOwnerMap)
end
function kingdomMapCell:getWarBuildingOwner(kid, buildId)
	return self.warBuildingOwnerMgr:getOwner(kid, buildId)
end
function kingdomMapCell:getAllWarBuildingOwner(kid)
	return self.warBuildingOwnerMgr:getAllOwner(kid)
end
function kingdomMapCell:addScoutRecord(mapObjData)
	if mapObjData and mapObjData.type == gMapObjTypeDef.mapObjTypePlayer and mapObjData.user and mapObjData.user.playerID ~= self.uid then
		local scoutRecordCtrl = gametop.playertop_:getModule("scoutRecordCtrl")
		if scoutRecordCtrl:getScoutRecord(mapObjData.user.playerID, mapObjData.user.playerName, mapObjData.x, mapObjData.y, mapObjData.kid) then
			mapObjData.user.hasScoutRecord = true
		else
			mapObjData.user.hasScoutRecord = false
		end
	end
end
function kingdomMapCell:delScoutRecord(mapObjData)
	if mapObjData and mapObjData.type == gMapObjTypeDef.mapObjTypePlayer and mapObjData.user then
		local scoutRecordCtrl = gametop.playertop_:getModule("scoutRecordCtrl")
		scoutRecordCtrl:delScoutRecord(mapObjData.user.playerID)
	end
end
function kingdomMapCell:onAllianceRelationChanged(aid)
	if aid then
		local mapObjMap = self.mapAllianceObjMgr:getAllianceObjMap(aid)
		if mapObjMap then
			local instanceFactory = include("instanceFactory")
			for _, mapObjData in pairs(mapObjMap) do
				local instanceType = mapObjData.type
				local dataKey = instanceFactory.getInstanceDataKey(instanceType)
				if dataKey then
					local objData = mapObjData[dataKey]
					if not objData then
						objData, _ENV = nil, nil
						mapObjData[dataKey] = objData
					end
					objData.isRelationChanged = true
				end
			end
			_ENV = pairs(mapObjMap)
			pairs(mapObjMap).msg = "MESSAGE_SERVER_WORLD_MAP_INSTANCE_MODIFY"
			pairs(mapObjMap).data = mapObjMap
			SoraDSendMessage(pairs(mapObjMap))
		end
	end
end
function kingdomMapCell:noticeRobEscort(msg)
	local _ENV, data
	for _, v in pairs(msg.data) do
		table.insert(data, v)
	end
	_ENV = pairs(msg.data)
	pairs(msg.data).msg = "MESSAGE_SERVER_WORLD_MAP_MOVELINE_MODIFY"
	pairs(msg.data).data = data
	SoraDSendMessage(pairs(msg.data))
end
function kingdomMapCell:onPlaceOccupyAllianceChange(msg, isLLW)
	if isLLW then
	elseif msg.data.owner and msg.data.owner.teamId and msg.data.owner.teamId > 0 then
		msg.data.owner.kid = msg.data.kid
		self.warBuildingOwnerMgr:setOwner(msg.data.kid, msg.data.placeId, msg.data.owner)
	else
		self.warBuildingOwnerMgr:removeOwner(msg.data.kid, msg.data.placeId)
	end
end
function kingdomMapCell:setWarBuildingOwner(kid, buildId, owner)
	self.warBuildingOwnerMgr:setOwner(kid, buildId, owner)
end
function kingdomMapCell:onPlaceOwnerInfoChange(msg)
	dump(msg, "onPlaceOwnerInfoChange", 5)
	self.warBuildingOwnerMgr:setOwner(msg.data.kid, msg.data.placeId, msg.data.owner, msg.data.classType)
end
function kingdomMapCell:onPlaceCaptainChange(msg)
	local orgOwner = self.warBuildingOwnerMgr:getOwner(msg.data.kid, msg.data.placeId)
	self.warBuildingOwnerMgr:setOwner(msg.data.kid, msg.data.placeId, msg.data.owner)
	if not orgOwner or not orgOwner.isIn then
		local x, y = self:getPlacePosById(msg.data.placeId)
		self:resetBuildQueueColor(x, y, nil, msg.data.owner and msg.data.owner.isIn and msg.data.owner.aid or 0)
	end
end
function kingdomMapCell:onMoveCity2OtherKingdom(msg)
	local showViewType = VIEW_TYPE_MAP
	if worldMapDefine.currentMapKindomID and self.kid ~= worldMapDefine.currentMapKindomID then
		SoraDConfigSet("Game:LoginView:setKingdomID~integer", worldMapDefine.currentMapKindomID)
	end
	if msg.data.moveCityType and msg.data.moveCityType == CHANGE_KINGDOM_MOVECITY_TYPE.MIGRATE then
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:KOHMigrate:PopSuccess~bool", true, nil)
		showViewType = VIEW_TYPE_CITY
	end
	gametop:Logout()
	local kingdomClass = msg.data.targetKingdomClass
	if kingdomClass then
		SoraDShowLoginView(showViewType, kingdomClass)
	else
		SoraDShowLoginView(showViewType)
	end
end
function kingdomMapCell:onOutMap()
	self.mapQueueRoot:clear()
	self.mapObjRoot:clear()
end
function kingdomMapCell:onMoveCity(msg)
	local retData = msg.data
	if retData and retData.x and retData.y then
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		cityCtrl:updateCityPos(retData)
		dump(retData, "kingdomMapCell:onMoveCity=", 10)
		gametop = retData
		retData.msg = "MESSAGE_SERVER_WORLD_MAP_UPDATE_SELF_POINT"
		retData.data = retData
		SoraDSendMessage(retData)
		gametop = retData
		retData.msg = "MESSAGE_SERVER_WORLD_MAP_TRANSFER_TO_SELFKINDOM"
		retData.mapId = retData.mapId
		SoraDSendMessage(retData)
		if self:getKingdomClass() == gKingdomClassType.radiance then
			for _, mapObjData in pairs(self.mapObjMgr:getMapObjByType(gMapObjTypeDef.mapTypeRadianceWarBeacon)) do
				self:onUpdateMapObj(mapObjData)
			end
		end
	end
end
function kingdomMapCell:onProtectStatus(msg)
	local retData = msg.data
	if retData then
		self.isSafe = retData.isSafe
	end
end
function kingdomMapCell:onErrorCodeNotice(errorCode, queueToId, errParms)
	local msgNotice = include("msgNotice")
	local noticeId = msgNotice.getTipCode(errorCode)
	noticeId = noticeId or "notice_0026"
	_ENV = nil
	;(nil).queueToId = queueToId
	;(nil).errParms = errParms
	msgNotice.notice(noticeId, nil)
end
function kingdomMapCell:setIsSafe(isSafe)
	self.isSafe = isSafe
end
function kingdomMapCell:reqIsSafe()
	return self.isSafe
end
function kingdomMapCell:setMaxNpcLevel(maxNpcLevel)
	self.preMaxNpcLevel = self.maxNpcLevel or maxNpcLevel
	self.maxNpcLevel = maxNpcLevel or 1
	for _, mapObjData in pairs(self.mapNpcObjMgr:getAllNpc()) do
		mapObjData.npc.maxCanKillLevel = self.maxNpcLevel + 1
		mapObjData.npc.isCanKill = npcconfigData[mapObjData.class].npcLevel <= self.maxNpcLevel + 1
		self:onUpdateMapObjLocal(mapObjData)
	end
	if self.preMaxNpcLevel ~= self.maxNpcLevel then
		_ENV = pairs(self.mapNpcObjMgr:getAllNpc())
		pairs(self.mapNpcObjMgr:getAllNpc()).byUID = true
		local result = SoraDConfigGet("Game:worldMapView:monsterLVRange~string", pairs(self.mapNpcObjMgr:getAllNpc()))
		local tbl = SoraDStringsSplit(result, ",")
		local maxLevel = self:getMaxCanKillLevel()
		tbl[1] = math.max(1, math.min(_G.checknumber(tbl[1]), maxLevel))
		tbl[2] = math.max(1, math.min(_G.checknumber(tbl[2]) + 1, maxLevel))
		_ENV = "%d,%d"
		;("%d,%d").byUID = true
		SoraDConfigSet("Game:worldMapView:monsterLVRange~string", string.format("%d,%d", tbl[1], tbl[2]), "%d,%d")
	end
end
function kingdomMapCell:setInWarStateData(inWarStateData)
	self.inWarMarchSpeedUp = inWarStateData
	_ENV = nil
	;(nil).msg = "MESSAGE_WAR_STATE_REFRESH_BACK"
	SoraDSendMessage(nil)
end
function kingdomMapCell:getInWarStateData()
	return self.inWarMarchSpeedUp
end
function kingdomMapCell:getInwarStateTime()
	if not IsArClient and self:getInWarStateData().endTime and self:getInWarStateData().endTime - serviceFunctions.systemTime() > 0 and self:getInWarStateData().beginTime and serviceFunctions.systemTime() - self:getInWarStateData().beginTime >= -1 then
		return self:getInWarStateData().endTime - serviceFunctions.systemTime()
	end
	return 0
end
function kingdomMapCell:getInWarStateSpeed()
	if not IsArClient and self:getInWarStateData().speed and self:getInWarStateData().speed > 0 and 0 < self:getInWarStateData().endTime - serviceFunctions.systemTime() then
		return self:getInWarStateData().speed
	end
	return 0
end
function kingdomMapCell:setMaxMapNpcLevel(maxMapNpcLevel)
	self.maxMapNpcLevel = maxMapNpcLevel
end
function kingdomMapCell:fillPlaceStatusData(mapObjData)
	if mapObjData.type == gMapObjTypeDef.mapObjTypeCastale or mapObjData.type == gMapObjTypeDef.mapObjTypeBattery or mapObjData.type == gMapObjTypeDef.mapObjTypeFortress then
		local data
		if mapObjData.type == gMapObjTypeDef.mapObjTypeCastale then
			data = mapObjData.castle
		elseif mapObjData.type == gMapObjTypeDef.mapObjTypeBattery then
			data = mapObjData.battery
		elseif mapObjData.type == gMapObjTypeDef.mapObjTypeFortress then
			data = mapObjData.fortress
		end
		if worldMapDefine.kingWarStatus == gKingdomWarStatusType.close or worldMapDefine.kingWarStatus == gKingdomWarStatusType.rule then
			data.isSafe = true
		else
			data.isSafe = false
		end
		data.isSelfIn = self:hasMyQueueToMapObj(mapObjData.id, nil, gMapMoveLineStatusType.moveLineStatusTypeWorking)
		data.kingStatus = worldMapDefine.kingdomStatus
		local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
		local isInConquestWar = conquestWarCtrl.conquestWarState == gConquestWarState.OPENING
		if isInConquestWar and mapObjData.type ~= gMapObjTypeDef.mapObjTypeCastale and mapObjData.type ~= gMapObjTypeDef.mapObjTypeBattery then
			data.isSafe = true
			data.warStatus = gKingdomWarStatusType.close
			data.warStatusTime = 0
		end
	elseif mapObjData.type == gMapObjTypeDef.mapObjTypeBattlefieldSite and mapObjData.objId and 0 < mapObjData.objId then
		local allianceWarltCtrl = include("allianceWarltCtrl")
		local allianceBuilding = allianceWarltCtrl.getAllianceWarBuildingById(mapObjData.objId)
		if allianceBuilding and mapObjData[allianceBuilding.dataName] then
			local data = mapObjData[allianceBuilding.dataName]
			data.isSafe = data.warStatus == gKingdomWarStatusType.inWar
			if data.leagueID and 0 < data.leagueID and data.warStatus == gKingdomWarStatusType.inWar then
				data.finishOccupyTime = data.warStartTime + data.occupyTime + data.troopTime
				data.finishOccupy = data.finishOccupy
				data.allianceWarCamp = data.campType
			end
		end
	end
	local commandHallCtrl = SoraDGetCtrl("commandHallCtrl")
	commandHallCtrl:checkMapObjPoint(mapObjData)
end
function kingdomMapCell:isShowWarStatusTime()
	local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
	local isInConquestWar = conquestWarCtrl.conquestWarState == gConquestWarState.OPENING
	if isInConquestWar and worldMapDefine.kingWarStatus == gKingdomWarStatusType.inWar then
		local castleOwner = self.warBuildingOwnerMgr:getOwner(self.kid, gPlaceId)
		if not (castleOwner and castleOwner.hostKid and castleOwner.hostKid > 0) or castleOwner.hostKid == self.kid then
			return false
		end
	end
	return true
end
function kingdomMapCell:getWarStatusTime()
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	local coolQueue = queueCtrl:queryQueue(gQueueTypeDef.world_resource_cool, gWorldResourceCoolQueueId)
	if coolQueue then
		return coolQueue.timerNode.timer:getRemainTime()
	else
		return 0
	end
end
function kingdomMapCell:onKingWarStatusChange(isInit, resetCaptainShow)
	if not isInit and self:getKingdomClass() == gKingdomClassType.normal and worldMapDefine.kingWarStatus and worldMapDefine.kingWarStatus ~= gKingdomWarStatusType.inWar then
		self.warBuildingOwnerMgr:removeAllOwner(self.kid)
	end
end
function kingdomMapCell:onAllianceWarStatusChange(kid, isInit)
	if not isInit and worldMapDefine.isPyramidKingdomID(kid) then
		local allianceWarCtrl = gametop.playertop_:getModule("allianceWarCtrl")
		local warData = allianceWarCtrl:getWarData(kid)
		if warData and warData.warStatus and warData.warStatus ~= gKingdomWarStatusType.inWar then
			self.warBuildingOwnerMgr:removeAllOwner(kid)
		end
	end
end
function kingdomMapCell:getPlaceIdByXY(x, y)
	if worldMapDefine.isPyramidKingdomID() then
		local allianceWarltCtrl = include("allianceWarltCtrl")
		local allianceBuilding = allianceWarltCtrl.getAllianceWarBuildingByPos(x, y)
		if allianceBuilding then
			return allianceBuilding.id
		end
	elseif worldMapDefine.isLegendLordKingdomID() then
		local legendLordWarltCtrl = include("legendLordWarltCtrl")
		local legendLordBuilding = legendLordWarltCtrl.getLegendLordWarBuildingByPos(x, y, worldMapDefine.currentMapKindomID)
		if legendLordBuilding then
			return legendLordBuilding.id
		end
	else
		for placeId, setting in pairs(gPlaceSetting) do
			if setting.x == x and setting.y == y then
				return placeId
			end
		end
	end
end
function kingdomMapCell:getPlacePosById(placeId)
	local allianceWarltCtrl = include("allianceWarltCtrl")
	local allianceBuilding = allianceWarltCtrl.getAllianceWarBuildingById(placeId)
	if allianceBuilding then
		return allianceBuilding.x, allianceBuilding.y
	end
	local legendLordWarltCtrl = include("legendLordWarltCtrl")
	local legendLordBuilding = legendLordWarltCtrl.getLegendLordWarBuildingById(placeId, worldMapDefine.currentMapKindomID)
	if legendLordBuilding then
		return legendLordBuilding.x, legendLordBuilding.y
	end
	local remainsWarltCtrl = include("remainsWarltCtrl")
	local remainsWarBuilding = remainsWarltCtrl.getRemainsWarBuildingById(placeId)
	if remainsWarBuilding then
		return remainsWarBuilding.x, remainsWarBuilding.y
	end
	local devilValleyltCtrl = include("devilValleyltCtrl")
	local devilValleyWarBuilding = devilValleyltCtrl.getWarBuildingById(placeId)
	if devilValleyWarBuilding then
		return devilValleyWarBuilding.x, devilValleyWarBuilding.y
	end
	local kingWarBuilding = gPlaceSetting[placeId]
	if kingWarBuilding then
		return kingWarBuilding.x, kingWarBuilding.y
	end
end
function kingdomMapCell:getPlaceOwnerInfo(kid, placeId)
	kid = kid or worldMapDefine.currentMapKindomID
	local _ENV, ret = worldMapDefine, worldMapDefine
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local selfAid = allianceMgr:getOwnTeamID()
	local owner = self.warBuildingOwnerMgr:getOwner(kid, placeId)
	if owner then
		ret = clone(owner)
		if selfAid == owner.aid then
			ret.maxNum = owner.maxNum
			if ret.maxNum then
				ret.curNum = 0
				local x, y = self:getPlacePosById(placeId)
				local defendQueueMap = self.localPosQueueMgr:getToPosQueueMap(x, y, selfAid, nil, gMapMoveLineStatusType.moveLineStatusTypeWorking)
				for _, queue in pairs(defendQueueMap) do
					if queue:isMainQueueFun() then
						ret.curNum = ret.curNum + (queue.totalNum or queue:getTotalNum() or 0)
					end
				end
			end
		end
		if worldMapDefine.isPyramidKingdomID(kid) then
			local allianceWarCtrl = gametop.playertop_:getModule("allianceWarCtrl")
			local warData = allianceWarCtrl:getWarData(kid)
			if warData and warData.warStatus == gKingdomWarStatusType.inWar then
				local allianceWarltCtrl = include("allianceWarltCtrl")
				local allianceBuilding = allianceWarltCtrl.getAllianceWarBuildingById(placeId)
				if allianceBuilding and owner.aid then
					ret.finishOccupyTime = warData.warStartTime + owner.occupyTime + owner.troopTime
					ret.finishOccupy = owner.finishOccupy
					ret.allianceWarCamp = owner.campType
				end
			end
		end
	end
	return ret
end
function kingdomMapCell:setOtherKingdomInfo(kid, info)
	if info then
		if info.kingdom and info.kingdom.kingdomName then
			info.kingdom.kingdomName = serviceFunctions.getKingdomFormatName(info.kingdom.kingdomName, kid)
		end
		info.warStatusStartTime = serviceFunctions.systemTime()
		self.mapWarStatus[kid] = info
	end
end
function kingdomMapCell:getOtherKingdomInfo(kid)
	if not self.mapWarStatus[kid] then
		_UPVALUE0_ = self.mapWarStatus[kid]
	end
	return self.mapWarStatus[kid]
end
function kingdomMapCell:getHallWarCount(isWar)
	local queueRoot = self:getQueueRootByWar(isWar, true)
	if queueRoot then
		return queueRoot:getWarHallAllCount()
	end
	return 0
end
function kingdomMapCell:onAddWhiteList(aid)
	self.localWarHallQueueMgr:onAddWhiteList(aid)
	_ENV = self.localWarHallQueueMgr
	self.localWarHallQueueMgr.msg = "MESSAGE_GREEN_POINT_UPDATE"
	self.localWarHallQueueMgr.type = GREEN_POINT_NOTICE_TYPE.ALLIANCE_WAR
	SoraDSendMessage(self.localWarHallQueueMgr)
end
function kingdomMapCell:onDelWhiteList(aid)
	self.localWarHallQueueMgr:onDelWhiteList(aid)
	_ENV = self.localWarHallQueueMgr
	self.localWarHallQueueMgr.msg = "MESSAGE_GREEN_POINT_UPDATE"
	self.localWarHallQueueMgr.type = GREEN_POINT_NOTICE_TYPE.ALLIANCE_WAR
	SoraDSendMessage(self.localWarHallQueueMgr)
end
function kingdomMapCell:onAddBlackList(aid)
	self.localWarHallQueueMgr:onAddBlackList(aid)
end
function kingdomMapCell:onDelBlackList(aid)
	self.localWarHallQueueMgr:onDelBlackList(aid)
end
function kingdomMapCell:onDismissAlliance()
	self.localWarHallQueueMgr:onDismissAlliance()
end
function kingdomMapCell:getMaxCanKillLevel()
	local ret = self.maxNpcLevel + 1
	if ret > gMaxNpcLevel then
		ret = gMaxNpcLevel
	end
	if self.maxMapNpcLevel and self.maxMapNpcLevel > 0 and ret > self.maxMapNpcLevel then
		ret = self.maxMapNpcLevel
	end
	return ret
end
function kingdomMapCell:onSuperResQueue(queue)
	if queue:getQueueType() == gMapMoveLineServerType.moveLineTypeSuperResource and queue:isFromUser(self.uid) then
		local allianceBuild = gametop.playertop_:getModule("allianceBuild")
		local mapSuperRes = allianceBuild:getResPointInfo()
		if mapSuperRes and next(mapSuperRes) then
			for _, superRes in pairs(mapSuperRes) do
				self:onSuperResBuildTimeChange(superRes.bid, superRes.iid, superRes.startTime, superRes.finishTime)
			end
		end
	end
end
function kingdomMapCell:onSuperResBuildTimeChange(bid, iid, superBuildStartTime, superBuildFinishTime)
	if iid and superBuildFinishTime and superBuildStartTime < superBuildFinishTime then
		local myQueues = self.localUserQueueMgr:getFromUserQueueMap(self.uid, gMapMoveLineType.moveLineTypeSuperRes, nil, gMapMoveLineStatusType.moveLineStatusTypeWorking, iid)
		for _, queue in pairs(myQueues) do
			if queue.purposeType == 1 then
				queue.statusStartTime = superBuildStartTime
				queue.statusEndTime = superBuildFinishTime
				queue.isBuilding = true
				local eventState = gMapEventStateDef.mapEventStateModify
				_ENV = nil
				;(nil).msg = "MESSAGE_SERVER_WORLD_MAP_EVENT_LSIT_INFO_NEW"
				;(nil).eventState = eventState
				;(nil).data = queue
				SoraDSendMessage(nil, nil)
				_ENV = nil
				;(nil).msg = "MESSAGE_UI_PANDECT_MARCH"
				SoraDSendMessage(nil)
			end
		end
	end
end
function kingdomMapCell:onSuperResQueueChange(data)
	if data.players then
		for _, player in ipairs(data.players) do
			if player.uid == self.uid and data.mapObj.status == gMapObjStateTypeDef.gMapObjStateTypeFree then
				local _ENV, superRes = data.mapObj.status, data.mapObj.status
				superRes.status = data.mapObj.status
				superRes.level = data.mapObj.level
				superRes.leagueID = data.mapObj.objId
				superRes.leagueName = data.mapObj.leagueName
				superRes.leagueFlag = data.mapObj.leagueFlag
				_ENV, superRes.isSelfIn = data.isAdd, data.isAdd
				data.isAdd.id = data.mapObj.id
				data.isAdd.x = data.mapObj.x - 1
				data.isAdd.y = data.mapObj.y - 1
				data.isAdd.type = data.mapObj.type or data.mapObj.mapType
				local data.isAdd.superRes, mapObjData = superRes, data.isAdd
				self:onUpdateMapObjLocal(mapObjData)
			end
			if data.isAdd then
				_ENV = data.isAdd
				data.isAdd.msg = "MESSAGE_ALLIANCE_BUILD_INFOLIST_ADD"
				data.isAdd.data = player
				SoraDSendMessage(data.isAdd)
			else
				_ENV = data.isAdd
				data.isAdd.msg = "MESSAGE_ALLIANCE_BUILD_INFOLIST_DEL"
				data.isAdd.data = player.queueId
				SoraDSendMessage(data.isAdd)
			end
		end
		self:onSuperResBuildTimeChange(data.mapObj.objId, data.mapObj.id, data.mapObj.buildStartTime, data.mapObj.buildEndTime)
	end
end
function kingdomMapCell:setBossRewardsStatus(bossTypeRewardLimit, limitType)
	dump(bossTypeRewardLimit, "==setBossRewardsStatus==")
	if limitType then
		self._bossTypeRewardLimit[tostring(limitType)] = bossTypeRewardLimit
	else
		self._bossTypeRewardLimit = bossTypeRewardLimit
	end
end
function kingdomMapCell:setKingWarRankAndPackEndTime(kingWarRank, kingWarPackEndTime)
	self.kingWarRank = kingWarRank
	self.kingWarPackEndTime = kingWarPackEndTime
	if self.kingWarPackEndTime and tonumber(self.kingWarPackEndTime) > 0 and tonumber(self.kingWarPackEndTime) > serviceFunctions.systemTime() then
		local leftTime = self.kingWarPackEndTime - serviceFunctions.systemTime()
		local queueCtrl = gametop.playertop_:getModule("queueCtrl")
		local queue = queueCtrl:queryQueue(gQueueTypeDef.king_war_rank_pack, gKingWarRankPackQueueId)
		if not queue then
			_ENV = nil
			queueCtrl:addQueue(gQueueTypeDef.king_war_rank_pack, serviceFunctions.systemTime(), leftTime, leftTime, nil, gKingWarRankPackQueueId)
		else
			queueCtrl:restartLeftTime(gQueueTypeDef.king_war_rank_pack, leftTime, gKingWarRankPackQueueId)
		end
	else
		local queueCtrl = gametop.playertop_:getModule("queueCtrl")
		local queue = queueCtrl:queryQueue(gQueueTypeDef.king_war_rank_pack, gKingWarRankPackQueueId)
		if queue then
			queueCtrl:removeQueue(gQueueTypeDef.king_war_rank_pack, gKingWarRankPackQueueId)
		end
		self.kingWarRank = nil
		self.kingWarPackEndTime = nil
	end
	_ENV = queueCtrl:queryQueue(gQueueTypeDef.king_war_rank_pack, gKingWarRankPackQueueId)
	queueCtrl:queryQueue(gQueueTypeDef.king_war_rank_pack, gKingWarRankPackQueueId).msg = "MESSAGE_SERVER_KINGDOMWAR_KINGDOMALLIANCE_GIFT"
	SoraDSendMessage((queueCtrl:queryQueue(gQueueTypeDef.king_war_rank_pack, gKingWarRankPackQueueId)))
end
function kingdomMapCell:getKingWarRank()
	print("getKingWarRank", self.kingWarRank, self.kingWarPackEndTime)
	return self.kingWarRank
end
function kingdomMapCell:getKingWarPackLeftTime()
	print("getKingWarPackLeftTime", self.kingWarRank, self.kingWarPackEndTime)
	if self.kingWarPackEndTime and self.kingWarPackEndTime > 0 then
		return self.kingWarPackEndTime - serviceFunctions.systemTime()
	end
end
function kingdomMapCell:canGetBossAttackRewards(limitType)
	local info = self._bossTypeRewardLimit[tostring(limitType)]
	if info then
		return info.canGetBossAttackRewards
	end
	return true
end
function kingdomMapCell:canGetBossKillRewards(limitType)
	local info = self._bossTypeRewardLimit[tostring(limitType)]
	if info then
		return info.canGetBossKillRewards
	end
	return true
end
function kingdomMapCell:getBossRewardLeftTimes(limitType)
	local info = self._bossTypeRewardLimit[tostring(limitType)]
	if info and info.maxKillNum then
		return info
	end
	return -1
end
function kingdomMapCell:getSuperResCollInfo(id, x, y)
	gMapMoveLineServerType = nil
	;(nil).speed = 0
	local (nil).num, ret = 0, nil
	local queues = self.localPosQueueMgr:getToPosQueueMap(x, y, nil, gMapMoveLineServerType.moveLineTypeSuperResource, gMapMoveLineStatusType.moveLineStatusTypeWorking)
	for _, queue in pairs(queues) do
		if queue:getToId() == id then
			local collStartTime = queue.statusStartTime
			local collTimeSpan = queue.data.coller and queue.data.coller.collTimeSpan
			local curTime = serviceFunctions.systemTime()
			if collTimeSpan then
				local speed, num = 0, 0
				local totalCollTime = 0
				for i = 1, #collTimeSpan do
					local timeSpanItem = collTimeSpan[i]
					if collStartTime + totalCollTime + timeSpanItem.time == curTime then
						num = num + timeSpanItem.speed * timeSpanItem.time / gHourSeconds
						break
					elseif curTime > collStartTime + totalCollTime + timeSpanItem.time then
						num = num + timeSpanItem.speed * timeSpanItem.time / gHourSeconds
					elseif curTime < collStartTime + totalCollTime + timeSpanItem.time then
						local itemCollTime = curTime - (collStartTime + totalCollTime)
						if itemCollTime < 0 then
							itemCollTime = 0
						end
						num = num + timeSpanItem.speed * itemCollTime / gHourSeconds
						speed = timeSpanItem.speed
						break
					end
					totalCollTime = totalCollTime + timeSpanItem.time
				end
				num = math.floor(num)
				ret.speed = speed
				ret.num = num
			end
			break
		end
	end
	return ret
end
function kingdomMapCell:setKingdomClass(kingdomClass)
	local worldMapWarDef = include("worldMapWarDef")
	gMapMaxCoordinate = worldMapWarDef.getMaxCoordinateByType(kingdomClass)
	_ENV = kingdomClass
	kingdomClass.msg = "MESSAGE_MAP_ID_CHANGE"
	SoraDSendMessage(kingdomClass)
end
function kingdomMapCell:updateForbitWarTime(forbitWarTimeData)
	self:setForbitWarTime(forbitWarTimeData)
end
function kingdomMapCell:getForbitWarTime()
	return self.forbitWarTimeData
end
function kingdomMapCell:setForbitWarTime(data)
	if not self.forbitWarTimeData then
		_ENV = self.forbitWarTimeData
	end
	self.forbitWarTimeData = self.forbitWarTimeData
	if type(data) == "table" and next(data) then
		self.forbitWarTimeData.beginTime = data.beginTime
		self.forbitWarTimeData.endTime = data.endTime
	end
	_ENV = data.endTime
	data.endTime.msg = "MESSAGE_SERVER_WORLD_MAP_FORBID_WAR"
	SoraDSendMessage(data.endTime)
end
function kingdomMapCell:updateForbidMapObjWarTime(forbidMapObjWarTimeData)
	self:setForbidMapObjWarTime(forbidMapObjWarTimeData)
end
function kingdomMapCell:getForbidMapObjWarTime(instanceType)
	return self.forbidMapObjWarTimeData and self.forbidMapObjWarTimeData[tostring(instanceType)] or nil
end
function kingdomMapCell:setForbidMapObjWarTime(data)
	dump(data, "setForbidMapObjWarTime")
	self.forbidMapObjWarTimeData = data
	_ENV = data
	data.msg = "MESSAGE_SERVER_WORLD_MAP_FORBID_MAP_OBJ_WAR"
	SoraDSendMessage(data)
end
function kingdomMapCell:getKingdomClass()
	local mapID = gametop.playertop_:getMapID()
	return worldMapDefine.getKingdomMapClassByKingdomId(mapID)
end
function kingdomMapCell:setViewPieceIds(viewPieceIDs)
	self.viewPieceIDs, _ENV = nil, nil
	for kingdomId, v in pairs(viewPieceIDs) do
		if v then
			for _, id in pairs(v) do
				local strkey = kingdomId .. "-" .. tostring(id)
				self.viewPieceIDs[strkey] = true
			end
		end
	end
end
function kingdomMapCell:setAddPieceIds(addPieceIds)
	self.addPieceIds, _ENV = nil, nil
	for kingdomId, v in pairs(addPieceIds) do
		for _, id in pairs(v) do
			local strkey = kingdomId .. "-" .. tostring(id)
			self.addPieceIds[strkey] = true
		end
	end
end
function kingdomMapCell:isReceivedDataEnd()
	local dataEnd = not next(self.addPieceIds)
	return dataEnd
end
function kingdomMapCell:delPieceIds(delPieceIds, currViewPieceIds)
	if delPieceIds then
		local _ENV, delQueueMap
		for kingdomId, pieceIds in pairs(delPieceIds) do
			for _, pieceId in pairs(pieceIds) do
				local kid = tonumber(kingdomId)
				local pid = tonumber(pieceId)
				local mapObjDataMap = self.mapPieceObjMgr:getPiece(kid, pid)
				if mapObjDataMap then
					for _, mapObjData in pairs(mapObjDataMap) do
						self.mapObjRoot:removeMapObj(mapObjData, kid, pid)
					end
					self.mapPieceObjMgr:removePiece(kid, pid)
				end
				local queueDataMap = self.mapPieceQueueMgr:getPieceQueues(kid, pid)
				if queueDataMap then
					for queueId, queueData in pairs(queueDataMap) do
						delQueueMap[queueId] = queueData
					end
				end
			end
		end
		for _, queueData in pairs(delQueueMap) do
			if not self.mapPieceQueueMgr:isQueueCrossView(queueData, currViewPieceIds) then
				self.mapQueueRoot:removeQueue(queueData)
			end
		end
	end
end
function kingdomMapCell:splitMapObjId(mapObj)
	kingdomMapUtil.splitMapObjId(mapObj)
end
function kingdomMapCell:onAddMapObjs(pieceId, pieceData, msg)
