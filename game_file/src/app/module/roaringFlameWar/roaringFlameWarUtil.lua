local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local _ENV, roaringFlameWarUtil = "kingdomMapCtrl", "kingdomMapCtrl"
function roaringFlameWarUtil.quitBattlefield(...)
	if not worldMapDefine.isInRoaringFlame() then
		return
	end
	if roaringFlameWarCtrl:checkInState(ROARING_FLAME_WAR_STATE.BATTLE) then
		_ENV = nil
		;(nil).content = i18n("flames_dunes_text13")
		;(nil).cancel = true
		;(nil).confirmFunc = function()
			roaringFlameWarUtil.quitBattlefield2()
		end
		uiManager:show("MessageBox", nil)
	else
		roaringFlameWarUtil.quitBattlefield2()
	end
end
function roaringFlameWarUtil.quitBattlefield2(...)
	local armyCtrl = SoraDGetCtrl("armyCtrl")
	if armyCtrl:getCuringArmyCount() > 0 or 0 < armyCtrl:getTotalWoundedArmyCount() then
		SoraDShowMsgBox(i18n("flames_dunes_text216"), i18n("remains_btn_09"), nil, function(eventType)
			if eventType == MSGBOX_CALLBACK_YES then
				roaringFlameWarUtil.quitBattlefield3()
			end
		end)
		return
	end
	roaringFlameWarUtil.quitBattlefield3()
end
function roaringFlameWarUtil.quitBattlefield3(...)
	_ENV = nil
	;(nil).handler = function()
		roaringFlameWarCtrl:reqQuitBattlefield()
	end
	uiManager:show("RoaringFlame_Switcher", nil)
end
function roaringFlameWarUtil.checkIsCanTransfer(targetRect)
	local selfCamp = roaringFlameWarCtrl:getSelfCamp()
	local buildID = roaringFlameWarUtil.getSelfCampInitCity()
	local blactRect = roaringFlameWarRead.getBlackRect(buildID)
	if cc.rectIntersectsRect(targetRect, blactRect) then
		return false
	end
	local buildRect = roaringFlameWarRead.getBuildRect(buildID)
	if cc.rectIntersectsRect(targetRect, buildRect) then
		return true
	end
	local buildType = gWorldTypeServerDef.subTypeRoaringFlameWarFort
	local buildIDList = roaringFlameWarRead.getBuildIDListByType(buildType)
	for __, buildID in ipairs(buildIDList) do
		local owner = roaringFlameWarUtil.getSelfCampWarBuildingOwner(buildID)
		if owner then
			local blactRect = roaringFlameWarRead.getBlackRect(buildID)
			if cc.rectIntersectsRect(targetRect, blactRect) then
				return false
			end
			local buildRect = roaringFlameWarRead.getBuildRect(buildID)
			if cc.rectIntersectsRect(targetRect, buildRect) then
				return true
			end
		end
	end
	return false, worldMapLayInstanceTypeErrorDef.roaringFlameError
end
function roaringFlameWarUtil.getQueuesData(...)
	local kingdomMapCtrl, ret
	local queueRoot = kingdomMapCtrl:getQueueRootByWar()
	if not queueRoot:getAllWarHallQueue() then
		local kingdomMapCtrl, allianceWarListData = queueRoot:getAllWarHallQueue(), queueRoot:getAllWarHallQueue()
	end
	local kingdomMapCtrl, map = queueRoot, queueRoot
	for key, v in pairs(allianceWarListData) do
		local queues = v.queues
		local queue = queues[next(queues)]
		local to = queue.to
		local objId = to.objId
		if to.mapType == gMapObjTypeDef.roaringFlameWarBuilding and not map[objId] then
			local owner = roaringFlameWarUtil.getSelfCampWarBuildingOwner(objId, true)
			local newClassType = owner and gAllianceQueueClassType.pvp_def or gAllianceQueueClassType.pvp
			kingdomMapCtrl = nil
			;(nil).newClassType = newClassType
			;(nil).objId = objId
			;(nil).subMapType = to.subMapType
			;(nil).endTime = queue:getStatusEndTime()
			table.insert(ret, nil)
			map[objId] = true
		end
	end
	local selfCamp = roaringFlameWarCtrl:getSelfCamp()
	if not kingdomMapCtrl:getAllWarBuildingOwner(worldMapDefine.currentMapKindomID) then
		local kingdomMapCtrl, ownerMap = kingdomMapCtrl:getAllWarBuildingOwner(worldMapDefine.currentMapKindomID), kingdomMapCtrl:getAllWarBuildingOwner(worldMapDefine.currentMapKindomID)
	end
	for k, v in pairs(ownerMap) do
		local objId = tonumber(k)
		local curOccupy = v.camp
		local lastOccupy = v.lastFinishOccupyCampId
		if not map[objId] and curOccupy ~= selfCamp and lastOccupy == selfCamp and not v.isFirstOccupy then
			local subMapType = roaringFlameWarRead.getBuildSubType(objId)
			kingdomMapCtrl = nil
			;(nil).newClassType = gAllianceQueueClassType.pvp_def
			;(nil).objId = objId
			;(nil).subMapType = subMapType
			;(nil).endTime = v.finishOccupyTime
			table.insert(ret, nil)
			map[objId] = true
		end
	end
	return ret
end
function roaringFlameWarUtil.checkIsMineBuild(subType, objId)
	roaringFlameWarRead, subType = roaringFlameWarRead.getBuildSubType(objId), subType or roaringFlameWarRead.getBuildSubType(objId)
	roaringFlameWarRead.getBuildSubType(objId)[gWorldTypeServerDef.subTypeRoaringFlameWarMithrilMine] = true
	local roaringFlameWarRead.getBuildSubType(objId)[gWorldTypeServerDef.subTypeRoaringFlameWarGoldMine], mineBuildSubType = true, roaringFlameWarRead.getBuildSubType(objId)
	return mineBuildSubType[subType]
end
function roaringFlameWarUtil.checkIsGatewayBuild(subType, objId)
	roaringFlameWarRead, subType = roaringFlameWarRead.getBuildSubType(objId), subType or roaringFlameWarRead.getBuildSubType(objId)
	roaringFlameWarRead.getBuildSubType(objId)[gWorldTypeServerDef.subTypeRoaringFlameWarGateway] = true
	local roaringFlameWarRead.getBuildSubType(objId)[gWorldTypeServerDef.subTypeRoaringFlameWarGatewayCopy], mineBuildSubType = true, roaringFlameWarRead.getBuildSubType(objId)
	return mineBuildSubType[subType]
end
function roaringFlameWarUtil.checkShowProtect(subType)
	_ENV = nil
	;(nil)[gWorldTypeServerDef.subTypeRoaringFlameWarPhoenix] = true
	;(nil)[gWorldTypeServerDef.subTypeRoaringFlameWarMithrilMine] = true
	local (nil)[gWorldTypeServerDef.subTypeRoaringFlameWarGoldMine], config = true, nil
	return not config[subType]
end
function roaringFlameWarUtil.getProtectScale(subType)
	_ENV = nil
	;(nil)[gWorldTypeServerDef.subTypeRoaringFlameWarGateway] = 4
	;(nil)[gWorldTypeServerDef.subTypeRoaringFlameWarGatewayCopy] = 4
	;(nil)[gWorldTypeServerDef.subTypeRoaringFlameWarGate] = 2.5
	local (nil)[gWorldTypeServerDef.subTypeRoaringFlameWarPalace], config = 2.5, nil
	return config[subType] or 1
end
function roaringFlameWarUtil.getBuildMaxLv(...)
	local maxLv = 0
	_ENV = nil
	;(nil)[1] = gWorldTypeServerDef.subTypeRoaringFlameWarInitCity
	local (nil)[2], config = gWorldTypeServerDef.subTypeRoaringFlameWarWoods, nil
	for __, subType in ipairs(config) do
		local buildIDList = roaringFlameWarRead.getBuildIDListByType(subType)
		for __, buildId in ipairs(buildIDList) do
			local level = roaringFlameWarRead.getBuildLevel(buildId)
			if maxLv < level then
				maxLv = level
			end
		end
	end
	return maxLv
end
function roaringFlameWarUtil.getOccupyBuildMaxLv(...)
	local maxLv = 0
	_ENV = nil
	;(nil)[1] = gWorldTypeServerDef.subTypeRoaringFlameWarInitCity
	local (nil)[2], config = gWorldTypeServerDef.subTypeRoaringFlameWarWoods, nil
	for __, subType in ipairs(config) do
		local buildIDList = roaringFlameWarRead.getBuildIDListByType(subType)
		for __, buildId in ipairs(buildIDList) do
			local owner = roaringFlameWarUtil.getSelfCampWarBuildingOwner(buildId)
			if owner then
				local level = roaringFlameWarRead.getBuildLevel(buildId)
				if maxLv < level then
					maxLv = level
				end
			end
		end
	end
	return maxLv
end
function roaringFlameWarUtil.setMonsterRate(rate)
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:RoaringFlameWarMonster:rate~integer", rate, nil)
end
function roaringFlameWarUtil.getInitMonsterRate(...)
	if not roaringFlameWarUtil.getMonsterIsOpenRate() then
		return 1
	end
	return roaringFlameWarUtil.getMonsterRate()
end
function roaringFlameWarUtil.getMonsterRate()
	_ENV = nil
	;(nil).byUID = true
	local rate = SoraDConfigGet("Game:RoaringFlameWarMonster:rate~integer", nil) or 1
	_ENV = nil
	local rateList = roaringFlameWarRead.getConstValueArray("FLAMES_DUNES_COST_MAG", nil)
	local index = table.indexof(rateList, rate)
	if index then
		return rate
	else
		return 1
	end
end
function roaringFlameWarUtil.setMonsterIsOpenRate(isOpen)
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:RoaringFlameWarMonster:isOpenRate~bool", isOpen, nil)
end
function roaringFlameWarUtil.getMonsterIsOpenRate(...)
	_ENV = nil
	;(nil).byUID = true
	return SoraDConfigGet("Game:RoaringFlameWarMonster:isOpenRate~bool", nil)
end
function roaringFlameWarUtil:initBuild()
	self.fields.Com_build:setPosition(cc.p(0, 0))
	if self.cityWall then
		self.cityWall:setVisible(false)
	end
	if roaringFlameWarUtil.checkIsGatewayBuild(self.subType) then
		if not self.cityWall then
			local cityWall = display.newSpriteNoChild("#CityWall_b_05.png")
			cityWall:addTo(self)
			cityWall:setVisible(false)
			self.cityWall = cityWall
		end
		_ENV = cityWall
		display.newSpriteNoChild("#CityWall_b_05.png")[131] = true
		display.newSpriteNoChild("#CityWall_b_05.png")[164] = true
		display.newSpriteNoChild("#CityWall_b_05.png")[227] = true
		local display.newSpriteNoChild("#CityWall_b_05.png")[230], wall05config = true, display.newSpriteNoChild("#CityWall_b_05.png")
		if wall05config[self.objId] then
			self.cityWall:setVisible(true)
			self.cityWall:setSpriteFrame("CityWall_b_05.png")
		end
		_ENV = self.cityWall.setSpriteFrame
		self.cityWall.setSpriteFrame[142] = true
		self.cityWall.setSpriteFrame[153] = true
		self.cityWall.setSpriteFrame[226] = true
		self.cityWall.setSpriteFrame[228] = true
		local self.cityWall.setSpriteFrame[229], wall06config = true, self.cityWall.setSpriteFrame
		if wall06config[self.objId] then
			self.cityWall:setVisible(true)
			self.cityWall:setSpriteFrame("CityWall_b_06.png")
		end
		local pos = cc.p(0, 0)
		local pos2 = cc.p(0, 0)
		local offsety = -64.0
		if roaringFlameWarUtil.checkBuildNeedFlipX(self.objId) then
			self.fields.Com_build:setIcon("CityWall_b_11.png")
			pos = cc.p(-62, -212 - offsety)
			pos2 = cc.p(pos.x + 380, pos.y + 171 + offsety * 2)
		else
			self.fields.Com_build:setIcon("CityWall_b_10.png")
			pos = cc.p(26, -237 - offsety)
			pos2 = cc.p(pos.x - 378, pos.y + 230 + offsety * 2)
		end
		self.fields.Com_build:setPosition(pos)
		self.cityWall:setPosition(pos2)
	elseif self.subType == gWorldTypeServerDef.subTypeRoaringFlameWarGate then
		if not self.cityWall then
			local cityWall = display.newSpriteNoChild("#CityWall_b_05.png")
			cityWall:addTo(self)
			cityWall:setVisible(false)
			self.cityWall = cityWall
		end
		_ENV = cityWall
		display.newSpriteNoChild("#CityWall_b_05.png")[21] = true
		local display.newSpriteNoChild("#CityWall_b_05.png")[130], wall05config = true, display.newSpriteNoChild("#CityWall_b_05.png")
		if wall05config[self.objId] then
			self.cityWall:setVisible(true)
			self.cityWall:setSpriteFrame("CityWall_b_05.png")
		end
		_ENV = self.cityWall.setSpriteFrame
		self.cityWall.setSpriteFrame[10] = true
		self.cityWall.setSpriteFrame[32] = true
		self.cityWall.setSpriteFrame[43] = true
		self.cityWall.setSpriteFrame[53] = true
		self.cityWall.setSpriteFrame[132] = true
		self.cityWall.setSpriteFrame[143] = true
		local self.cityWall.setSpriteFrame[154], wall06config = true, self.cityWall.setSpriteFrame
		if wall06config[self.objId] then
			self.cityWall:setVisible(true)
			self.cityWall:setSpriteFrame("CityWall_b_06.png")
		end
		local pos = cc.p(0, 0)
		local pos2 = cc.p(0, 0)
		local offsety = -64.0
		if roaringFlameWarUtil.checkBuildNeedFlipX(self.objId) then
			self.fields.Com_build:setIcon("CityWall_b_02.png")
			pos = cc.p(0, -186 - offsety)
			pos2 = cc.p(pos.x + 318, pos.y + 145 + offsety * 2)
		else
			self.fields.Com_build:setIcon("CityWall_b_01.png")
			pos = cc.p(0, -186 - offsety)
			pos2 = cc.p(pos.x - 352, pos.y + 179 + offsety * 2)
		end
		if self.objId == 132 then
			pos2.x = pos2.x + 30
			pos2.y = pos2.y - 98
		end
		self.fields.Com_build:setPosition(pos)
		self.cityWall:setPosition(pos2)
	elseif self.subType == gWorldTypeServerDef.subTypeRoaringFlameWarPalace then
		self.fields.Com_build:setPosition(cc.p(0, -74))
	end
end
function roaringFlameWarUtil.checkBuildNeedFlipX(objId)
	local subType = roaringFlameWarRead.getBuildSubType(objId)
	if roaringFlameWarUtil.checkIsGatewayBuild(subType) then
		roaringFlameWarRead = roaringFlameWarUtil.checkIsGatewayBuild(subType)
		roaringFlameWarUtil.checkIsGatewayBuild(subType)[120] = true
		roaringFlameWarUtil.checkIsGatewayBuild(subType)[142] = true
		roaringFlameWarUtil.checkIsGatewayBuild(subType)[153] = true
		roaringFlameWarUtil.checkIsGatewayBuild(subType)[226] = true
		roaringFlameWarUtil.checkIsGatewayBuild(subType)[228] = true
		local roaringFlameWarUtil.checkIsGatewayBuild(subType)[229], build11config = true, roaringFlameWarUtil.checkIsGatewayBuild(subType)
		if build11config[objId] then
			return true
		end
	elseif subType == gWorldTypeServerDef.subTypeRoaringFlameWarGate then
		roaringFlameWarRead = gWorldTypeServerDef.subTypeRoaringFlameWarGate
		gWorldTypeServerDef.subTypeRoaringFlameWarGate[10] = true
		gWorldTypeServerDef.subTypeRoaringFlameWarGate[20] = true
		gWorldTypeServerDef.subTypeRoaringFlameWarGate[22] = true
		gWorldTypeServerDef.subTypeRoaringFlameWarGate[32] = true
		gWorldTypeServerDef.subTypeRoaringFlameWarGate[33] = true
		gWorldTypeServerDef.subTypeRoaringFlameWarGate[43] = true
		gWorldTypeServerDef.subTypeRoaringFlameWarGate[44] = true
		gWorldTypeServerDef.subTypeRoaringFlameWarGate[53] = true
		gWorldTypeServerDef.subTypeRoaringFlameWarGate[55] = true
		gWorldTypeServerDef.subTypeRoaringFlameWarGate[119] = true
		gWorldTypeServerDef.subTypeRoaringFlameWarGate[121] = true
		gWorldTypeServerDef.subTypeRoaringFlameWarGate[143] = true
		local gWorldTypeServerDef.subTypeRoaringFlameWarGate[154], build02config = true, gWorldTypeServerDef.subTypeRoaringFlameWarGate
		if build02config[objId] then
			return true
		end
	end
	return false
end
function roaringFlameWarUtil.getDirBuildImage(objId)
	local subType = roaringFlameWarRead.getBuildSubType(objId)
	if roaringFlameWarUtil.checkIsGatewayBuild(subType) then
		if roaringFlameWarUtil.checkBuildNeedFlipX(objId) then
			return "CityWall_b_11.png"
		else
			return "CityWall_b_10.png"
		end
	elseif subType == gWorldTypeServerDef.subTypeRoaringFlameWarGate then
		if roaringFlameWarUtil.checkBuildNeedFlipX(objId) then
			return "CityWall_b_02.png"
		else
			return "CityWall_b_01.png"
		end
	else
		return roaringFlameWarRead.getBuildImage(subType)
	end
end
function roaringFlameWarUtil.searchRoaringFlameWarBuild(subType, noMsgTip)
	local roaringFlameWarUtil, ret
	local isMineBuild = roaringFlameWarUtil.checkIsMineBuild(subType)
	local ownerMap = roaringFlameWarUtil.getAllSelfCampWarBuildingOwner()
	for k, v in pairs(ownerMap) do
		local buildId1 = tonumber(k)
		local subType1 = roaringFlameWarRead.getBuildSubType(buildId1)
		if subType1 == subType then
			table.insert(ret, buildId1)
		elseif isMineBuild and subType1 == gWorldTypeServerDef.subTypeRoaringFlameWarMine then
			local binding = roaringFlameWarRead.getBuildBinding(buildId1)
			for __, buildId2 in ipairs(binding) do
				local subType2 = roaringFlameWarRead.getBuildSubType(buildId2)
				if subType2 == subType then
					table.insert(ret, buildId2)
				end
			end
		end
	end
	local maxLv, maxBuildId = 0, 0
	for __, buildId in ipairs(ret) do
		local level = roaringFlameWarRead.getBuildLevel(buildId)
		if maxLv < level then
			maxLv = level
			maxBuildId = buildId
		end
	end
	if maxBuildId ~= 0 then
		local pos = roaringFlameWarRead.getBuildCoord(maxBuildId)
		SoraDGotoWorldMapPoint(pos, true)
		return maxBuildId
	elseif not noMsgTip then
		roaringFlameWarUtil = roaringFlameWarRead.getBuildCoord(maxBuildId)
		roaringFlameWarRead.getBuildCoord(maxBuildId)[gWorldTypeServerDef.subTypeRoaringFlameWarPhoenix] = i18n("flames_dunes_text272")
		roaringFlameWarRead.getBuildCoord(maxBuildId)[gWorldTypeServerDef.subTypeRoaringFlameWarGoldMine] = i18n("flames_dunes_text265")
		local roaringFlameWarRead.getBuildCoord(maxBuildId)[gWorldTypeServerDef.subTypeRoaringFlameWarMithrilMine], config = i18n("flames_dunes_text266"), roaringFlameWarRead.getBuildCoord(maxBuildId)
		local msgTip = config[subType] or i18n("common_text_4551")
		SoraDShowMsgTip(msgTip)
	end
end
function roaringFlameWarUtil.checkPermission(permission, showTips)
	local rank = roaringFlameWarCtrl:getPlayerMemberClass()
	if not roaringFlameWarRead.checkPermission(permission, rank) then
		if showTips then
			SoraDShowMsgTip(i18n("Celestial_defense_text_010"))
		end
		return false
	else
		return true
	end
end
function roaringFlameWarUtil.getAllSelfCampWarBuildingOwner(...)
	local selfCamp = roaringFlameWarCtrl:getSelfCamp()
	local roaringFlameWarCtrl, retMap = roaringFlameWarCtrl, roaringFlameWarCtrl
	if not kingdomMapCtrl:getAllWarBuildingOwner(worldMapDefine.currentMapKindomID) then
		local roaringFlameWarCtrl, ownerMap = kingdomMapCtrl:getAllWarBuildingOwner(worldMapDefine.currentMapKindomID), kingdomMapCtrl:getAllWarBuildingOwner(worldMapDefine.currentMapKindomID)
	end
	for k, v in pairs(ownerMap) do
		if v.camp == selfCamp then
			retMap[k] = v
		end
	end
	return retMap
end
function roaringFlameWarUtil.getSelfCampWarBuildingOwner(objId, ignoreOccupy)
	local subType = roaringFlameWarRead.getBuildSubType(objId)
	if subType == gWorldTypeServerDef.subTypeRoaringFlameWarGatewayCopy then
		objId = roaringFlameWarRead.getGatewayCopy2gateway(objId)
	end
	local owner = kingdomMapCtrl:getWarBuildingOwner(worldMapDefine.currentMapKindomID, objId)
	if owner and owner.camp == roaringFlameWarCtrl:getSelfCamp() then
		if not ignoreOccupy and not owner.finishOccupy then
			return
		end
		return owner
	end
end
function roaringFlameWarUtil.getPalaceOwner(...)
	local buildID = roaringFlameWarUtil.getPalaceBuildID()
	local owner = kingdomMapCtrl:getWarBuildingOwner(worldMapDefine.currentMapKindomID, buildID)
	if owner and not owner.finishOccupy then
		return owner
	end
end
function roaringFlameWarUtil.getWarStateRemainTime()
	local startTime = roaringFlameWarCtrl:getStateBeginTime(ROARING_FLAME_WAR_STATE.BATTLE)
	local timeConfig = roaringFlameWarRead.getTimeConfig(2)
	local curTime = serviceFunctions.systemTime()
	for k, v in ipairs(timeConfig) do
		local nextWarTime = startTime + v.offset_time
		local nextIdleTime = nextWarTime + v.duration
		if curTime < nextIdleTime then
			return nextIdleTime - curTime
		end
	end
	return 0
end
function roaringFlameWarUtil.getPeaceStateRemainTime()
	local startTime = roaringFlameWarCtrl:getStateBeginTime(ROARING_FLAME_WAR_STATE.BATTLE)
	local timeConfig = roaringFlameWarRead.getTimeConfig(2)
	local curTime = serviceFunctions.systemTime()
	for k, v in ipairs(timeConfig) do
		local nextWarTime = startTime + v.offset_time
		if curTime < nextWarTime then
			return nextWarTime - curTime
		end
	end
	return 0
end
function roaringFlameWarUtil.isInWarState()
	local startTime = roaringFlameWarCtrl:getStateBeginTime(ROARING_FLAME_WAR_STATE.BATTLE)
	local timeConfig = roaringFlameWarRead.getTimeConfig(2)
	local curTime = serviceFunctions.systemTime()
	local isInWar = false
	local leftTime = 0
	for k, v in ipairs(timeConfig) do
		local nextWarTime = startTime + v.offset_time
		local nextIdleTime = nextWarTime + v.duration
		if curTime <= nextWarTime then
			isInWar = false
			leftTime = nextWarTime - curTime
			break
		end
		if curTime <= nextIdleTime and curTime >= nextWarTime then
			isInWar = true
			leftTime = nextIdleTime - curTime
			break
		end
	end
	return isInWar, leftTime
end
function roaringFlameWarUtil.getInWarStage(...)
	local startTime = roaringFlameWarCtrl:getStateBeginTime(ROARING_FLAME_WAR_STATE.BATTLE)
	local timeConfig = roaringFlameWarRead.getTimeConfig(2)
	local curTime = serviceFunctions.systemTime()
	local curStage = #timeConfig
	for __, v in ipairs(timeConfig) do
		local nextWarTime = startTime + v.offset_time
		local nextIdleTime = nextWarTime + v.duration
		if curTime <= nextIdleTime then
			curStage = v.stage
			break
		end
	end
	return curStage
end
function roaringFlameWarUtil.getWarStateDuration(...)
	local curStage = roaringFlameWarUtil.getInWarStage()
	return roaringFlameWarRead.getWarStateDuration(curStage)
end
function roaringFlameWarUtil.getOccupyLimit(...)
	local limit = roaringFlameWarRead.getConstValue("FLAMES_DUNES_BASE_CITY", 10)
	local extraLimit = roaringFlameWarUtil.getExtraOccupyLimit()
	return limit + extraLimit
end
function roaringFlameWarUtil.getExtraOccupyLimit()
	local ret = 0
	local startTime = roaringFlameWarCtrl:getStateBeginTime(ROARING_FLAME_WAR_STATE.BATTLE)
	local curTime = serviceFunctions.systemTime()
	local maxEndTime = 0
	local timeConfig = roaringFlameWarRead.getDuneHistoryCfg()
	for sTaskId, v in pairs(timeConfig) do
		if curTime >= startTime + v.end_time and maxEndTime < v.end_time then
			maxEndTime = v.end_time
			ret = v.city_num
		end
	end
	return ret
end
function roaringFlameWarUtil.parseChatContentText(content)
	local chatDesRead = include("chatDesRead")
	local result = i18n("common_text_4425")
	local kingdomMsgType = content.kingdomMsgType
	local cfg = chatDesRead.getChatNoticeCfg(kingdomMsgType)
	if not cfg then
		return result
	end
	if not content.values then
		local _ENV, values = content.values, content.values
	end
	if kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_start then
		return i18n(cfg.des, values)
	elseif kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_stop then
		return i18n(cfg.des, values)
	elseif kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_occupy_success then
		local params = roaringFlameWarUtil.getChatSysTextParams(values)
		return i18n(cfg.des, params)
	elseif kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_defence_faild then
		local params = roaringFlameWarUtil.getChatSysTextParams(values)
		params.camp = roaringFlameWarRead.getCampName(values.campId)
		return i18n(cfg.des, params)
	elseif kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_occupy_initCity then
		local _ENV, buildId = i18n, values.buildId or values.build
		i18n.camp = roaringFlameWarRead.getCampName(values.campId)
		local i18n.city, params = roaringFlameWarRead.getBuildNameByBuildId(buildId), i18n
		return i18n(cfg.des, params)
	elseif kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_owner_change then
		local params = roaringFlameWarUtil.getChatSysTextParams(values)
		params.camp1 = roaringFlameWarRead.getCampName(values.newCampId)
		params.camp2 = roaringFlameWarRead.getCampName(values.oldCampId)
		return i18n(cfg.des, params)
	elseif kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_occupy_palace then
		local _ENV, buildId = i18n, values.buildId or values.build
		i18n.camp = roaringFlameWarRead.getCampName(values.campId)
		local i18n.city, params = roaringFlameWarRead.getBuildNameByBuildId(buildId), i18n
		return i18n(cfg.des, params)
	elseif kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_create_cave then
		local pos = include("mapSyncUtilClient").serverTOClientPos(cc.p(values.x, values.y))
		_ENV = cc.p(values.x, values.y)
		cc.p(values.x, values.y).name = values.name
		_ENV = cc.p(values.x, values.y)
		cc.p(values.x, values.y).x = pos.x
		cc.p(values.x, values.y).y = pos.y
		cc.p(values.x, values.y).xy = i18n("%{x}:%{y}", cc.p(values.x, values.y))
		return i18n(cfg.des, cc.p(values.x, values.y))
	elseif kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_cave_explore_finish then
		local pos = include("mapSyncUtilClient").serverTOClientPos(cc.p(values.x, values.y))
		_ENV = cc.p(values.x, values.y)
		cc.p(values.x, values.y).name = values.name
		_ENV = cc.p(values.x, values.y)
		cc.p(values.x, values.y).x = pos.x
		cc.p(values.x, values.y).y = pos.y
		cc.p(values.x, values.y).xy = i18n("%{x}:%{y}", cc.p(values.x, values.y))
		return i18n(cfg.des, cc.p(values.x, values.y))
	elseif kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_notice then
		_ENV = cfg.des
		cfg.des.text = values.content
		return i18n(cfg.des, cfg.des)
	elseif kingdomMsgType == gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_decree_gift then
		_ENV = cfg.des
		cfg.des.num = values.decreeGiftUserNum
		return i18n(cfg.des, cfg.des)
	end
	return i18n(cfg.des, values)
end
function roaringFlameWarUtil.getChatSysTextParams(values)
	local buildId = values.buildId
	local buildName = roaringFlameWarRead.getBuildNameByBuildId(buildId)
	local buildLv = roaringFlameWarRead.getBuildLevel(buildId)
	local pos = roaringFlameWarRead.getBuildCoord(buildId)
	roaringFlameWarRead = buildId
	roaringFlameWarRead = nil
	;(nil).lv = buildLv
	buildId.lv = i18n("common_text_100", nil)
	buildId.city = buildName
	roaringFlameWarRead = nil
	;(nil).x = pos.x
	;(nil).y = pos.y
	local buildId.xy, params = i18n("common_text_2155", nil), buildId
	return params
end
function roaringFlameWarUtil.parseChatSysText(content)
	dump(content, "==roaringFlameWarUtil.parseChatSysText==")
	local values = content.values
	local msgType = content.flameChatMsgType
	_ENV = "==roaringFlameWarUtil.parseChatSysText=="
	;("==roaringFlameWarUtil.parseChatSysText==")[gRoaringFlameChatMsgType.warStart] = gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_start
	;("==roaringFlameWarUtil.parseChatSysText==")[gRoaringFlameChatMsgType.warStop] = gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_stop
	;("==roaringFlameWarUtil.parseChatSysText==")[gRoaringFlameChatMsgType.occupy_success] = gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_occupy_success
	;("==roaringFlameWarUtil.parseChatSysText==")[gRoaringFlameChatMsgType.defence_faild] = gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_defence_faild
	;("==roaringFlameWarUtil.parseChatSysText==")[gRoaringFlameChatMsgType.occupy_initCity] = gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_occupy_initCity
	;("==roaringFlameWarUtil.parseChatSysText==")[gRoaringFlameChatMsgType.owner_change] = gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_owner_change
	;("==roaringFlameWarUtil.parseChatSysText==")[gRoaringFlameChatMsgType.occupy_palace] = gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_occupy_palace
	;("==roaringFlameWarUtil.parseChatSysText==")[gRoaringFlameChatMsgType.create_cave] = gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_create_cave
	;("==roaringFlameWarUtil.parseChatSysText==")[gRoaringFlameChatMsgType.cave_explore_finish] = gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_cave_explore_finish
	;("==roaringFlameWarUtil.parseChatSysText==")[gRoaringFlameChatMsgType.new_notice] = gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_notice
	local ("==roaringFlameWarUtil.parseChatSysText==")[gRoaringFlameChatMsgType.camp_decree_gift_user_num], chatType2kingdomMsgType = gSystemNoticeKingdomMsgTypeDef.roaring_flame_war_decree_gift, "==roaringFlameWarUtil.parseChatSysText=="
	local kingdomMsgType = chatType2kingdomMsgType[msgType]
	if kingdomMsgType then
		_ENV = nil
		;(nil).kingdomMsgType = kingdomMsgType
		;(nil).values = values
		local ret = roaringFlameWarUtil.parseChatContentText(nil)
		return ret
	end
	if msgType == gRoaringFlameChatMsgType.createChatChannel then
		local campName = roaringFlameWarRead.getCampName(values.camp)
		_ENV = nil
		;(nil).name = campName
		return i18n("flames_dunes_push2", nil)
	elseif msgType == gRoaringFlameChatMsgType.warOpen then
		return i18n("flames_dunes_push5")
	elseif msgType == gRoaringFlameChatMsgType.warEnd then
		return i18n("flames_dunes_push7")
	elseif msgType == gRoaringFlameChatMsgType.camp_occupy_palace then
		local _ENV, buildId = "flames_dunes_push7", values.buildId or values.build
		local ("flames_dunes_push7").city, params = roaringFlameWarRead.getBuildNameByBuildId(buildId), "flames_dunes_push7"
		return i18n("flames_dunes_push14", params)
	elseif msgType == gRoaringFlameChatMsgType.manager_appointed then
		_ENV = i18n
		i18n.name = values.nickName
		i18n.name1 = values.disNickName
		return i18n("flames_dunes_push19", i18n)
	elseif msgType == gRoaringFlameChatMsgType.decree_gift_user_num then
		_ENV = i18n
		i18n.camp = roaringFlameWarRead.getCampName(values.campId)
		i18n.num = values.decreeGiftUserNum
		return i18n("flames_dunes_push15", i18n)
	end
	return i18n("common_text_4425")
end
function roaringFlameWarUtil.getCollQueueMax(...)
	local ret = 1
	local buffValue = roaringFlameWarCtrl:getDecreeBuffValue(gBuffEffect.MARCH_TROOP_TOTAL_BOOST)
	ret = ret + buffValue
	return ret
end
function roaringFlameWarUtil.checkCollQueueCount(...)
	local queueMax = roaringFlameWarUtil.getCollQueueMax()
	local resMap = roaringFlameWarCtrl:getResMap()
	local queueCount = table.nums(resMap)
	return queueMax > queueCount
end
function roaringFlameWarUtil.getCollSpeed(objId)
	local baseSpeed = roaringFlameWarRead.getCollectSpeed(objId)
	local plus = roaringFlameWarUtil.getCollSpeedPlus()
	return baseSpeed * (1 + plus)
end
function roaringFlameWarUtil.getCollSpeedPlus(...)
	local ret = 0
	local buffValue = roaringFlameWarCtrl:getDecreeBuffValue(gBuffEffect.GATHER_SPEED_BOOST)
	ret = ret + buffValue / 1000
	return ret
end
function roaringFlameWarUtil.sendMessageUpdateLegaueManor(objId, owner)
	local subType = roaringFlameWarRead.getBuildSubType(objId)
	if not roaringFlameWarRead.checkShowRolygonSubType(subType) then
		return
	end
	local campMax = roaringFlameWarRead.getCampCount()
	for camp = 1, campMax do
		roaringFlameWarUtil.sendMessageRemoveLegaueManor(objId, camp)
	end
	local buildRect = roaringFlameWarRead.getBuildRect(objId)
	local buildSize = roaringFlameWarRead.getBuildSize(objId)
	local radioW = math.ceil((buildRect.width + 1 - buildSize) / 2)
	local radioH = math.ceil((buildRect.height + 1 - buildSize) / 2)
	local radioSize = cc.size(radioW, radioH)
	local tilePoint = roaringFlameWarRead.getBuildCoord(objId)
	roaringFlameWarRead = objId
	objId.msg = "MESSAGE_WORLD_MAP_UPDATE_LEAGUEMANOR_INSTANCE"
	objId.updateType = worldMapLeagueManorUpdateType.leagueManorInstanceAdd
	objId.instanceID = tostring(objId)
	objId.tilePoint = tilePoint
	objId.size = buildSize
	objId.radioSize = radioSize
	local objId.activityStatus, params = true, objId
	local camp = campMax + 1
	if owner then
		camp = owner.camp
	end
	params.leagueID = camp
	params.colorId = camp
	params.sn = camp
	SoraDSendMessage(params)
end
function roaringFlameWarUtil.sendMessageRemoveLegaueManor(objId, camp)
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_UPDATE_LEAGUEMANOR_INSTANCE"
	;(nil).activityStatus = true
	;(nil).updateType = worldMapLeagueManorUpdateType.leagueManorInstanceRemove
	;(nil).instanceID = tostring(objId)
	;(nil).leagueID = camp
	SoraDSendMessage(nil)
end
function roaringFlameWarUtil.createBuildEffect(subType, effectType)
	if subType == gWorldTypeServerDef.subTypeRoaringFlameWarPhoenix then
		if effectType == 1 then
			local mv_bsncx = fgui.UIPackage:createObject("RoaringFlameWorldMap", "MovieClip_bsncx_fy")
			mv_bsncx:setAnchorPoint(0.5, 0.5)
			mv_bsncx:setAllFrameName("bsncx_fy_%02d.png", 1)
			return mv_bsncx
		elseif effectType == 2 then
			local mv_fhgw = fgui.UIPackage:createObject("RoaringFlameWorldMap", "MovieClip_fhgw_dj")
			mv_fhgw:setAnchorPoint(0.5, 0.5)
			mv_fhgw:setAllFrameName("fhgw_dj_ws_%02d.png", 1)
			return mv_fhgw
		elseif effectType == 3 then
			local mv_bsnjz = fgui.UIPackage:createObject("RoaringFlameWorldMap", "MovieClip_bsncx_jz")
			mv_bsnjz:setAnchorPoint(0.5, 0.5)
			mv_bsnjz:setAllFrameName("bsncx_jz_%02d.png", 1)
			return mv_bsnjz
		end
	elseif roaringFlameWarUtil.checkIsGatewayBuild(subType) then
		local mv_fire = fgui.UIPackage:createObject("RoaringFlameWorldMap", "MovieClip_CityWall_b_fx")
		mv_fire:setAnchorPoint(0.5, 0.5)
		mv_fire:setAllFrameName("CityWall_b_fx_%02d.png", 1)
		return mv_fire
	elseif subType == gWorldTypeServerDef.subTypeRoaringFlameWarPalace then
		local mv_build9 = fgui.UIPackage:createObject("RoaringFlameWorldMap", "MovieClip_build_9")
		mv_build9:setAnchorPoint(0.5, 0.5)
		mv_build9:setAllFrameName("flames_dunes_build_9_%02d.png", 1)
		mv_build9:setScale(1.25)
		return mv_build9
	end
end
function roaringFlameWarUtil.parseBuildLog(content)
	local selfCamp = content.selfCamp or roaringFlameWarCtrl:getSelfCamp()
	local data = content.data
	local objId = data.bId
	roaringFlameWarCtrl = nil
	;(nil).buildId = objId
	local params = roaringFlameWarUtil.getChatSysTextParams(nil)
	roaringFlameWarCtrl = nil
	;(nil).u = true
	params.xy = SoraDWrapHtmlTagByStyle(params.xy, nil)
	local logType = data.type
	if logType == 1 then
		local camp = data.cId
		if selfCamp == camp then
			return i18n("flames_dunes_text98", params)
		else
			local campName = roaringFlameWarRead.getCampName(camp)
			local htmlColor = roaringFlameWarRead.getCampHtmlColor(camp)
			roaringFlameWarCtrl = nil
			;(nil).color = htmlColor
			local campStr = SoraDWrapHtmlTagByStyle(campName, nil)
			params.camp = campStr
			return i18n("flames_dunes_text100", params)
		end
	elseif logType == 2 then
		params.name = data.name
		return i18n("flames_dunes_text237", params)
	end
	return ""
end
function roaringFlameWarUtil.getBuildConnectConfig(...)
	if roaringFlameWarUtil.buildConnectConfig then
		return roaringFlameWarUtil.buildConnectConfig
	end
	local roaringFlameWarUtil, cityLine3Map = roaringFlameWarUtil.buildConnectConfig, roaringFlameWarUtil.buildConnectConfig
	local fromObjId, fromPos, toPos, fromSubType, toSubType, key1, key2, lineType, isGatewayLine
	for i, v in ipairs(roaringFlameWarRead.get_flames_dunes_city()) do
		fromObjId = v.id
		fromSubType = roaringFlameWarRead.getBuildSubType(fromObjId)
		if fromSubType and not roaringFlameWarUtil.checkIsMineBuild(fromSubType) then
			fromPos = roaringFlameWarRead.getBuildCenterPos(fromObjId)
			for __, toObjId in ipairs(v.binding) do
				toSubType = toObjId ~= 0 and roaringFlameWarRead.getBuildSubType(toObjId)
				key1 = toObjId .. "," .. fromObjId
				key2 = fromObjId .. "," .. toObjId
				if toSubType and not roaringFlameWarUtil.checkIsMineBuild(toSubType) and not cityLine3Map[key1] and not cityLine3Map[key2] then
					toPos = roaringFlameWarRead.getBuildCenterPos(toObjId)
					isGatewayLine = roaringFlameWarUtil.checkIsGatewayBuild(fromSubType) and roaringFlameWarUtil.checkIsGatewayBuild(toSubType)
					if isGatewayLine then
						lineType = 3
					else
						lineType = 2
					end
					roaringFlameWarUtil = roaringFlameWarUtil.checkIsGatewayBuild(toSubType)
					roaringFlameWarUtil.checkIsGatewayBuild(toSubType).fromObjId = fromObjId
					roaringFlameWarUtil.checkIsGatewayBuild(toSubType).toObjId = toObjId
					roaringFlameWarUtil.checkIsGatewayBuild(toSubType).fromPos = fromPos
					roaringFlameWarUtil.checkIsGatewayBuild(toSubType).toPos = toPos
					roaringFlameWarUtil.checkIsGatewayBuild(toSubType).isGatewayLine = isGatewayLine
					local roaringFlameWarUtil.checkIsGatewayBuild(toSubType).lineType, cityLine3 = lineType, roaringFlameWarUtil.checkIsGatewayBuild(toSubType)
					cityLine3Map[key1] = cityLine3
				end
			end
		end
	end
	roaringFlameWarUtil.buildConnectConfig = cityLine3Map
	return cityLine3Map
end
function roaringFlameWarUtil.getSelfCampInitCity()
	local subType = gWorldTypeServerDef.subTypeRoaringFlameWarInitCity
	local buildList = roaringFlameWarUtil.getSelfCampBuildList(subType)
	return buildList[1]
end
function roaringFlameWarUtil.getSelfCampBuildList(subType)
	local selfCamp = roaringFlameWarCtrl:getSelfCamp()
	local buildIDList = roaringFlameWarRead.getBuildIDListByType(subType)
	local roaringFlameWarCtrl, ret = subType, subType
	for __, buildID in ipairs(buildIDList) do
		local buildCamp = roaringFlameWarRead.getBuildCamp(buildID)
		if buildCamp == selfCamp then
			table.insert(ret, buildID)
		end
	end
	return ret
end
function roaringFlameWarUtil.getGuideBuildID(subType)
	if subType == gWorldTypeServerDef.subTypeRoaringFlameWarInitCity then
		return roaringFlameWarUtil.getSelfCampInitCity()
	elseif subType == gWorldTypeServerDef.subTypeRoaringFlameWarPalace then
		local buildIDList = roaringFlameWarRead.getBuildIDListByType(subType)
		return buildIDList[1]
	end
end
function roaringFlameWarUtil.checkBuildOpenTime(objId)
	local startTime = roaringFlameWarCtrl:getStateBeginTime(ROARING_FLAME_WAR_STATE.BATTLE)
	local curTime = serviceFunctions.systemTime()
	local openTime = roaringFlameWarRead.getBuildOpenTime(objId)
	if curTime < startTime + openTime then
		return false
	else
		return true
	end
end
function roaringFlameWarUtil.getPalaceBuildID(...)
	local buildIDList = roaringFlameWarRead.getBuildIDListByType(gWorldTypeServerDef.subTypeRoaringFlameWarPalace)
	return buildIDList[1]
end
function roaringFlameWarUtil.getFinishOccupyRemainTime(objId)
	local owner = roaringFlameWarUtil.getSelfCampWarBuildingOwner(objId, true)
	if not owner or not owner.isIn then
		return
	end
	if not owner.finishOccupyTime or not owner.beginOccupyTime then
		return
	end
	if not owner.finishOccupy then
		local remain = owner.finishOccupyTime - serviceFunctions.systemTime()
		local totalTime = owner.finishOccupyTime - owner.beginOccupyTime
		return remain, totalTime
	end
end
function roaringFlameWarUtil:showNodeEffectUnlock()
	local nodeEffect_unlock = SoraDGetChildByName(self, "nodeEffect_unlock")
	if nodeEffect_unlock then
		return
	end
	local nodeEffect = SoraDCreatAnimation("nodeEffect_unlock")
	nodeEffect:setPosition(cc.p(0, 0))
	nodeEffect:addTo(self, 1)
	nodeEffect:setName("nodeEffect_unlock")
	local Particle_1 = SoraDGetChildByName(nodeEffect, "Particle_1")
	Particle_1:setVisible(false)
	_UPVALUE3_ = cc.p(0, 0)
	cc.p(0, 0)[1] = cca.delay(0.5)
	cc.p(0, 0)[2] = cca.callFunc(function()
		Particle_1:setVisible(true)
		Particle_1:resume()
	end)
	cc.p(0, 0)[3] = cca.delay(1.0)
	cc.p(0, 0)[4] = cca.callFunc(function()
		nodeEffect:removeFromParent()
	end)
	cc.p(0, 0)[5] = cca.callFunc(function()
		nodeEffect:removeFromParent()
	end)
	nodeEffect:runAction(cca.repeatForever(cca.seq(cc.p(0, 0))))
	return nodeEffect
end
return roaringFlameWarUtil
