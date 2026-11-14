local armyltCtrl = include("armyltCtrl")
local _ENV, kingdomQueueObjCell = "armyltCtrl", "armyltCtrl"
kingdomQueueObjCell.__index = kingdomQueueObjCell
function kingdomQueueObjCell.new(data)
	if not data then
		data, _ENV = nil, nil
	end
	setmetatable(data, kingdomQueueObjCell)
	return data
end
function kingdomQueueObjCell:getData()
	return self
end
function kingdomQueueObjCell:getId()
	return self.id
end
function kingdomQueueObjCell:getOrgId()
	return self.orgQueueId
end
function kingdomQueueObjCell:getQueueType()
	return self.queueType or self.type
end
function kingdomQueueObjCell:getMoveLineType()
	return self.moveLineType
end
function kingdomQueueObjCell:isOccupyQueue()
	return self:isOccupySingleQueue() or self:isOccupyMassQueue()
end
function kingdomQueueObjCell:isOccupySingleQueue()
	return self.queueType == gMapMoveLineServerType.moveLineTypeOccupy or self.queueType == gMapMoveLineServerType.moveLineTypeATBuilding
end
function kingdomQueueObjCell:isOccupyMassQueue()
	return self.queueType == gMapMoveLineServerType.moveLineTypeOccupyMass or self.queueType == gMapMoveLineServerType.moveLineTypeMassATBuilding
end
function kingdomQueueObjCell:getStatus()
	return self.status
end
function kingdomQueueObjCell:isMassing()
	return self.status == gMapMoveLineStatusType.moveLineStatusTypeRally
end
function kingdomQueueObjCell:isWorking()
	return self.status == gMapMoveLineStatusType.moveLineStatusTypeWorking
end
function kingdomQueueObjCell:isMoving()
	return self.status == gMapMoveLineStatusType.moveLineStatusTypeMoving
end
function kingdomQueueObjCell:isFinish()
	return self.status == gMapMoveLineStatusType.moveLineStatusTypeFinished
end
function kingdomQueueObjCell:getMapID()
	return self.mapId
end
function kingdomQueueObjCell:getMassSlaveForbidArmyClass()
	if not self.data or not self.data.massSlaveForbidArmyClass then
		_UPVALUE0_ = self.data.massSlaveForbidArmyClass
	end
	return self.data.massSlaveForbidArmyClass
end
function kingdomQueueObjCell:getMassSlaveArmyMinNum()
	return self.data and self.data.massSlaveArmyMinNum
end
function kingdomQueueObjCell:getMassSlaveArmyMaxNum()
	return self.data and self.data.massSlaveArmyMaxNum
end
function kingdomQueueObjCell:getIsForbidSpeed()
	return self.data and self.data.isForbidSpeed or false
end
function kingdomQueueObjCell:getMassSlaveArmyMinLv()
	return self.data and self.data.massSlaveArmyMinLv or 1
end
function kingdomQueueObjCell:getStatusStartTime()
	return self.statusStartTime
end
function kingdomQueueObjCell:getStatusEndTime()
	return self.statusEndTime
end
function kingdomQueueObjCell:getStatusTotalTime()
	if self.statusEndTime and self.statusStartTime then
		return self.statusEndTime - self.statusStartTime
	end
end
function kingdomQueueObjCell:getStatusRemainTime()
	if self.statusEndTime then
		local curTime = serviceFunctions.systemTime()
		local remainTime = self.statusEndTime - math.max(curTime, self.statusStartTime)
		if remainTime < 0 then
			remainTime = 0
		end
		return remainTime
	end
end
function kingdomQueueObjCell:isMassMainQueue()
	if self:isMainQueueFun() and self.moveLineType == gMapMoveLineType.moveLineTypeMass then
		return true
	end
	return false
end
function kingdomQueueObjCell:isShowSpeedSetting()
	if self:isMainQueueFun() and self.moveLineType == gMapMoveLineType.moveLineTypeMass and self.queueType ~= _G.gMapMoveLineServerType.moveLineTypeReturn then
		return true
	end
	return false
end
function kingdomQueueObjCell:getMainQueue()
	if self:isMainQueueFun() or not self:isWorking() then
		return self
	end
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local mainQueue = kingdomMapCtrl.kingdomMapCell:getMassMainQueue(self:getMainId())
	local testQueue = mainQueue
	if mainQueue == nil then
		testQueue = self
	end
	return testQueue
end
function kingdomQueueObjCell:needCheckCanUseSpeedQueue(testQueue)
	local gametop = gModuleMgr.getObject("gametop")
	return not testQueue:isFromUser(gametop.playertop_:getPlayerID()) and testQueue.moveLineType == gMapMoveLineType.moveLineTypeMass and testQueue.queueType ~= _G.gMapMoveLineServerType.moveLineTypeReturn
end
function kingdomQueueObjCell:isCanUseSpeedInQueue()
	local testQueue = self:getMainQueue()
	if not self:needCheckCanUseSpeedQueue(testQueue) then
		return true
	end
	if testQueue.isForbidSpeed then
		return false
	end
	return true
end
function kingdomQueueObjCell:isCanUseSpeedInAtlantis(...)
	if not worldMapDefine.isInAtlantis() then
		return true
	end
	local testQueue = self:getMainQueue()
	if not self:needCheckCanUseSpeedQueue(testQueue) then
		return true
	end
	local atlantisWarUtil = include("atlantisWarUtil")
	if not atlantisWarUtil.checkCanUseSpeedInQueue() then
		return false
	end
	return true
end
function kingdomQueueObjCell:getOrgStatusTotalTime()
	if self:getStatus() == gMapMoveLineStatusType.moveLineStatusTypeMoving then
		if not self.orgTotalStatusTime then
			self.orgTotalStatusTime = self:getTotalMoveTime()
		end
	elseif (self:getStatus() == gMapMoveLineStatusType.moveLineStatusTypeRally or self:getStatus() == gMapMoveLineStatusType.moveLineStatusTypeWorking) and (self:isMainQueueFun() or not self.orgTotalStatusTime) then
		self.orgTotalStatusTime = self:getStatusTotalTime()
	end
	return self.orgTotalStatusTime or 0
end
function kingdomQueueObjCell:getTotalMoveTime()
	local totalMoveTime = 0
	if self.moveTimeSpan then
		for _, timeSpan in ipairs(self.moveTimeSpan) do
			totalMoveTime = totalMoveTime + timeSpan.time
		end
	end
	return totalMoveTime
end
function kingdomQueueObjCell:getCreateTime()
	return self.createTime or 0
end
function kingdomQueueObjCell:getMoveTimeSpan()
	return self.moveTimeSpan
end
function kingdomQueueObjCell:isTargetBuilding()
	return self.isBuilding
end
function kingdomQueueObjCell:getFrom()
	return self.from
end
function kingdomQueueObjCell:getFromId()
	return self.from.id
end
function kingdomQueueObjCell:getFromX()
	return self.from.x
end
function kingdomQueueObjCell:getFromY()
	return self.from.y
end
function kingdomQueueObjCell:getFromMapObjId()
	return self.from.mapObjId or self.from.id
end
function kingdomQueueObjCell:getFromMapType()
	return self.from.mapType
end
function kingdomQueueObjCell:getFromSubMapType()
	return self.from.subMapType
end
function kingdomQueueObjCell:getFromUid()
	return self.from.uid
end
function kingdomQueueObjCell:getFromAid()
	return self.from.aid
end
function kingdomQueueObjCell:getFromTeamId()
	return self.teamId or self.from.teamId
end
function kingdomQueueObjCell:getTo()
	return self.to
end
function kingdomQueueObjCell:getToId()
	return self.to.id
end
function kingdomQueueObjCell:getToObjId()
	return self.to.objId
end
function kingdomQueueObjCell:getToX()
	return self.to.x
end
function kingdomQueueObjCell:getToY()
	return self.to.y
end
function kingdomQueueObjCell:getToMapObjId()
	return self.to.mapObjId or self.to.id
end
function kingdomQueueObjCell:getToMapType()
	return self.to.mapType
end
function kingdomQueueObjCell:getToSubMapType()
	return self.to.subMapType
end
function kingdomQueueObjCell:getToUid()
	return self.to.uid or self.targetUid
end
function kingdomQueueObjCell:getToAid()
	return self.to.aid or self.toAlliance
end
function kingdomQueueObjCell:getToTeamId()
	return self.data.toTeamId or self.data.to.teamId
end
function kingdomQueueObjCell:isMainQueueFun()
	return self.isMainQueue
end
function kingdomQueueObjCell:getMainId()
	local mainId = self:getMassId()
	if not mainId or mainId == 0 then
		mainId = self:getOrgMassId()
	end
	return mainId or 0
end
function kingdomQueueObjCell:getMassId()
	if self.isMainQueue then
		return self.id
	else
		return self.data and self.data.massId
	end
end
function kingdomQueueObjCell:getOrgMassId()
	return self.data and self.data.orgMassId
end
function kingdomQueueObjCell:getMassToX()
	return self.data and self.data.massToX
end
function kingdomQueueObjCell:getMassToY()
	return self.data and self.data.massToY
end
function kingdomQueueObjCell:getMassTime()
	return self.data and self.data.massTime
end
function kingdomQueueObjCell:getMaxMassNum()
	return self.data and self.data.maxMassNum or 0
end
function kingdomQueueObjCell:getMassNum()
	return self.data and self.data.massNum or 0
end
function kingdomQueueObjCell:getMaxHelpNum()
	return self.data and self.data.maxHelpNum or 0
end
function kingdomQueueObjCell:getUid()
	return self.uid or self.from.uid
end
function kingdomQueueObjCell:getTargetUid()
	return self.targetUid or self.to.uid
end
function kingdomQueueObjCell:getAid()
	return self.alliance or self.from.aid
end
function kingdomQueueObjCell:getTeamId()
	return self.teamId or self.from.teamId
end
function kingdomQueueObjCell:getOrgAid()
	return self.orgAlliance
end
function kingdomQueueObjCell:getFromArmy()
	if not self.from.army then
		_UPVALUE0_ = self.from.army
	end
	return self.from.army
end
function kingdomQueueObjCell:getFromHero()
	if not self.from.heroInfo then
		_UPVALUE0_ = self.from.heroInfo
	end
	return self.from.heroInfo
end
function kingdomQueueObjCell:getFromArtifact()
	if not self.from.armsInfo then
		_UPVALUE0_ = self.from.armsInfo
	end
	return self.from.armsInfo
end
function kingdomQueueObjCell:getFromLoseArmy()
	if not self.from.loseArmy then
		_UPVALUE0_ = self.from.loseArmy
	end
	return self.from.loseArmy
end
function kingdomQueueObjCell:getFromWoundedArmy()
	if not self.from.woundArmy then
		_UPVALUE0_ = self.from.woundArmy
	end
	return self.from.woundArmy
end
function kingdomQueueObjCell:getFromDivineBeastInfo()
	if not self.from.divineBeastInfo then
		_UPVALUE0_ = self.from.divineBeastInfo
	end
	return self.from.divineBeastInfo
end
function kingdomQueueObjCell:getFromLiveArmy()
	local _ENV, ret
	if self.from.army then
		for _, v in ipairs(self.from.army) do
			if v.num > 0 then
				table.insert(ret, v)
			end
		end
	end
	return ret
end
function kingdomQueueObjCell:getTotalNum()
	local ret = 0
	if self.from.army then
		for _, v in ipairs(self.from.army) do
			ret = ret + v.num
		end
	end
	return ret
end
function kingdomQueueObjCell:getTotalFc()
	local ret = 0
	if self.from.army then
		for _, v in ipairs(self.from.army) do
			local power = armyltCtrl.armyAttr(tonumber(v.id), ARMY_ATTR.POWER)
			ret = ret + v.num * power
		end
	end
	return ret
end
function kingdomQueueObjCell:hasFromUser()
	return self.uid and self.uid > 0 or self.from.uid and 0 < self.from.uid
end
function kingdomQueueObjCell:isFromUser(uid)
	return uid and (self.uid == uid or self.from.uid == uid)
end
function kingdomQueueObjCell:hasToUser()
	return self.targetUid and self.targetUid > 0 or self.to.uid and tolua.type(self.to.uid) == "number" and 0 < self.to.uid
end
function kingdomQueueObjCell:isToUser(uid)
	return uid and (self.targetUid == uid or self.to.uid == uid)
end
function kingdomQueueObjCell:hasFromAlliance()
	return self.alliance and self.alliance > 0
end
function kingdomQueueObjCell:isFromAlliance(aid)
	return aid and 0 < aid and self.alliance == aid
end
function kingdomQueueObjCell:hasToAlliance()
	return self.toAlliance and self.toAlliance > 0
end
function kingdomQueueObjCell:isToAlliance(aid)
	return aid and 0 < aid and self.toAlliance == aid
end
function kingdomQueueObjCell:hasOrgFromAlliance()
	return self.orgAlliance and self.orgAlliance > 0
end
function kingdomQueueObjCell:isOrgFromAlliance(aid)
	return aid and 0 < aid and self.orgAlliance == aid
end
function kingdomQueueObjCell:hasFromTeam()
	return self.teamId and self.teamId > 0
end
function kingdomQueueObjCell:isFromTeam(teamId)
	return teamId and 0 < teamId and self.teamId == teamId
end
function kingdomQueueObjCell:hasToTeam()
	return self.toTeamId and self.toTeamId > 0
end
function kingdomQueueObjCell:isToTeam(teamId)
	return teamId and 0 < teamId and self.toTeamId == teamId
end
function kingdomQueueObjCell:hasOrgFromTeam()
	return self.orgTeamId and self.orgTeamId > 0
end
function kingdomQueueObjCell:isOrgFromTeam(teamId)
	return teamId and 0 < teamId and self.orgTeamId == teamId
end
function kingdomQueueObjCell:isRedFrmIgnore(...)
	return self._isRedFrmIgnore
end
function kingdomQueueObjCell:ignoreRedFrm(...)
	self._isRedFrmIgnore = true
end
function kingdomQueueObjCell:noIgnoreRedFrm(...)
	self._isRedFrmIgnore = false
end
function kingdomQueueObjCell:checkIsWLCQueue(...)
	return self.isWLCQueue
end
function kingdomQueueObjCell:isWarHallQueue()
	return self:isOccupyQueue() or self.queueType == gMapMoveLineServerType.moveLineTypeAttackLord or self.queueType == gMapMoveLineServerType.moveLineTypeAttackResource or self.queueType == gMapMoveLineServerType.moveLineTypeAttackCamp or self.queueType == gMapMoveLineServerType.moveLineTypeAttackTreasure or self.queueType == gMapMoveLineServerType.moveLineTypeMass or self.queueType == gMapMoveLineServerType.moveLineTypeMassSlave or self.queueType == gMapMoveLineServerType.moveLineTypeMassBoss or self.queueType == gMapMoveLineServerType.moveLineTypeAttackAllianceBuild or self.queueType == gMapMoveLineServerType.moveLineTypeMassAllianceBuild or self.queueType == gMapMoveLineServerType.moveLineTypeNpcAttack or self.queueType == gMapMoveLineServerType.moveLineTypeMassABeast or self.queueType == gMapMoveLineServerType.moveLineTypeMassWBeast or self.queueType == gMapMoveLineServerType.moveLineTypeAtkTorchMine or self.queueType == gMapMoveLineServerType.moveLineTypeAttackWarTreasure or self.queueType == gMapMoveLineServerType.moveLineTypeMassAtlantisBoss or self.queueType == gMapMoveLineServerType.massNebulaDefenceWarBuild or self.queueType == gMapMoveLineServerType.massBossShield or self.queueType == gMapMoveLineServerType.massNebulaDefenceWarBuild
end
function kingdomQueueObjCell:getAllianceQueueClassType(teamId)
	if self:checkIsWLCQueue() then
		self.classType = gAllianceQueueClassType.pvp
		return self.classType
	end
	self.classType = gAllianceQueueClassType.pvp
	if self.queueType == gMapMoveLineServerType.moveLineTypeNpcAttack or self.queueType == gMapMoveLineServerType.moveLineTypeMassBoss or self.queueType == gMapMoveLineServerType.moveLineTypeMassABeast or self.queueType == gMapMoveLineServerType.moveLineTypeMassWBeast or self.queueType == gMapMoveLineServerType.massBossShield or self.queueType == gMapMoveLineServerType.massNebulaDefenceWarBuild then
		if self:getStatus() == gMapMoveLineStatusType.moveLineStatusTypeMoving then
			self.classType = gAllianceQueueClassType.pve_moving
		else
			self.classType = gAllianceQueueClassType.pve
		end
	else
		if not teamId then
			local gametop = gModuleMgr.getObject("gametop")
			local allianceMgr = gametop.playertop_:getModule("allianceMgr")
			teamId = allianceMgr:getOwnTeamID()
		end
		if self:getAid() ~= teamId then
			self.classType = gAllianceQueueClassType.pvp_def
		end
	end
	return self.classType
end
function kingdomQueueObjCell:getFilterDataByWatchTower()
	local watchTowerFilter = gModuleMgr.sharedMgr("watchTowerFilter")
	local filterQueueData = clone(self)
	watchTowerFilter:filter(filterQueueData)
	return kingdomQueueObjCell.new(filterQueueData)
end
function kingdomQueueObjCell:getEventType()
	if self.eventType then
		return self.eventType
	end
	local eventType = gMapEventTypeDef.mapEventTypeTroopInstance
	local moveLineType = self:getMoveLineType()
	if moveLineType == gMapMoveLineType.moveLineTypecapture or moveLineType == gMapMoveLineType.moveLineTypeRelicsExplore or moveLineType == gMapMoveLineType.moveLineTypeDesertMeteorite or moveLineType == gMapMoveLineType.moveLineTypeArmyHelp or moveLineType == gMapMoveLineType.moveLineTypeMass or moveLineType == gMapMoveLineType.moveLineTypeSuperRes or moveLineType == gMapMoveLineType.moveLineTypeEscortHelp then
		local status = self:getStatus()
		if status == gMapMoveLineStatusType.moveLineStatusTypeRally or status == gMapMoveLineStatusType.moveLineStatusTypeWorking then
			eventType = gMapEventTypeDef.mapEventTypeMapInstance
		end
	end
	return eventType
end
function kingdomQueueObjCell:isTargetCapture()
	local mapType = self.to.mapType
	local mapObjUtil = include("mapObjUtil")
	return mapObjUtil.isCapture(mapType)
end
function kingdomQueueObjCell:isHeroReturnFun()
	return self.queueType == gMapMoveLineServerType.moveLineTypeReturn and self.isHeroReturn
end
function kingdomQueueObjCell:fillClientLocalQueueData(kid, teamId)
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	teamId = teamId or allianceMgr:getOwnTeamID()
	kid = kid or gametop.playertop_:getMapID()
	self.from.x = self.from.x - gPointClientPointPlus
	self.from.y = self.from.y - gPointClientPointPlus
	self.to.x = self.to.x - gPointClientPointPlus
	self.to.y = self.to.y - gPointClientPointPlus
	if self.data and self.data.massToX and self.data.massToY then
		self.data.massToX = self.data.massToX - gPointClientPointPlus
		self.data.massToY = self.data.massToY - gPointClientPointPlus
	end
	if self.teamId and self.teamId ~= self.alliance then
		self.alliance = self.teamId
		self.aid = self.teamId
		self.leagueID = self.teamId
		self.from.aid = self.teamId
	end
	if self.toTeamId and self.toTeamId ~= self.toAlliance then
		self.toAlliance = self.toTeamId
		self.to.aid = self.toTeamId
	end
	self.mainId = self:getMainId()
	self.totalNum = self:getTotalNum()
	self.from.totalCount = self.totalNum
	self.from.objType = self:getFromMapType()
	self.from.mapObjId = self:getFromMapObjId()
	self.to.objType = self:getToMapType()
	self.to.mapObjId = self:getToMapObjId()
	self.to.isKing = self.to.official and tonumber(self.to.official) == gKingOfficialType.king
	self.to.bossType = self.to.objId
	self.maxMassNum = self:getMaxMassNum()
	self.massNum = self:getMassNum()
	self.maxHelpNum = self:getMaxHelpNum()
	self.massTime = self:getMassTime()
	self.playerName = self:getFrom().name
	self.kingdomId = kid
	self.classType = self:getAllianceQueueClassType(teamId)
	if self.queueType == gMapMoveLineServerType.moveLineTypeReturn then
		self.moveLineModel = gMapMoveLineModel.moveLineModelGoBack
	else
		self.moveLineModel = gMapMoveLineModel.moveLineModelGoOut
	end
	return self
end
function kingdomQueueObjCell.sFillClientMapQueueData(queueData)
	if queueData.teamId and queueData.teamId ~= queueData.alliance then
		queueData.alliance = queueData.teamId
		queueData.aid = queueData.teamId
		queueData.leagueID = queueData.teamId
		queueData.from.aid = queueData.teamId
	end
	if queueData.toTeamId and queueData.toTeamId ~= queueData.toAlliance then
		queueData.toAlliance = queueData.toTeamId
		queueData.to.aid = queueData.toTeamId
	end
	return queueData
end
function kingdomQueueObjCell:getAllFromLiveArmy4Rok()
	local mainArmy = self:getFromLiveArmy()
	if not self.from.slaveArmy then
		if self.from.escortArmy then
			_ENV = self.from.escortArmy
			self.from.escortArmy[self:getTargetUid()] = self.from.escortArmy
			return self.from.escortArmy
		else
			_ENV = self.from.escortArmy
			self.from.escortArmy[self:getUid()] = mainArmy
			return self.from.escortArmy
		end
	else
		_ENV = self.from.escortArmy
		local self.from.escortArmy[self:getUid()], ret = mainArmy, self.from.escortArmy
		for uid, arrArmy in pairs(self.from.slaveArmy) do
			ret[tonumber(uid)] = arrArmy
		end
		return ret
	end
end
function kingdomQueueObjCell:getFromTotalAmryCount()
	local mainID = self:getId()
	local slaveQueue = SoraDGetCtrl("kingdomMapCtrl").kingdomMapCell.localMassQueueMgr:getSlaveQueueMap(mainID)
	_UPVALUE1_ = SoraDGetCtrl("kingdomMapCtrl").kingdomMapCell.localMassQueueMgr
	local SoraDGetCtrl("kingdomMapCtrl").kingdomMapCell.localMassQueueMgr[1], queueDatas = self, SoraDGetCtrl("kingdomMapCtrl").kingdomMapCell.localMassQueueMgr
	for k, v in pairs(slaveQueue) do
		table.insert(queueDatas, v:getFilterDataByWatchTower())
	end
	local totalArmyNum = 0
	for i, v in ipairs(queueDatas) do
		local _data = v:getFrom()
		if _data then
			totalArmyNum = totalArmyNum + (_data.totalCount or 0)
		end
	end
	return totalArmyNum
end
return kingdomQueueObjCell
