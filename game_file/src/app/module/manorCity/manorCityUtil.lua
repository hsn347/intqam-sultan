local gametop = gModuleMgr.getObject("gametop")
local manorCityRead = include("manorCityRead")
local buffDesRead = include("buffDesRead")
local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
local manorFarmRead = include("manorFarmRead")
local manorTechRead = include("manorTechRead")
local gardenMapData = include("gardenMapData")
local mapSyncUtilClient = include("mapSyncUtilClient")
local _ENV, manorCityUtil = "mapSyncUtilClient", "mapSyncUtilClient"
function manorCityUtil.checkIsCanTransfer(_targetRect)
	local targetRect = _targetRect
	if not _targetRect.width then
		targetRect = cc.rect(_targetRect.x, _targetRect.y, 0, 0)
	end
	local serverPos = mapSyncUtilClient.clientTOServerPos(targetRect)
	local mapKey = serviceFunctions.getMapKey(serverPos.x, serverPos.y)
	if gardenMapData[mapKey] then
		return false
	end
	local tilePos = cc.p(targetRect.x, targetRect.y)
	local isCanTransfer, transferPos = manorCityUtil.adaptToTransferPos(tilePos)
	if isCanTransfer then
		return true
	else
		return false, true
	end
end
function manorCityUtil.adaptToTransferPos(tilePos)
	local isInVipArea, vipAreaIdx = manorCityRead.getIsInVipArea(tilePos)
	if not isInVipArea then
		return true, tilePos
	end
	local vipAreaCfg = manorCityRead.getVipAreaConfig(vipAreaIdx)
	local _tilePos = cc.p(tilePos.x - vipAreaCfg.beginX, tilePos.y - vipAreaCfg.beginY)
	local isInVillas, villasIdx = manorCityRead.getIsInVillas(_tilePos)
	if not isInVillas then
		return false
	end
	local villasPos = manorCityRead.getVillasPos(villasIdx)
	return true, cc.p(vipAreaCfg.beginX + villasPos.x, vipAreaCfg.beginY + villasPos.y)
end
function manorCityUtil.getTransferItemID(tilePos)
	local isInVipArea, vipAreaIdx = manorCityRead.getIsInVipArea(tilePos)
	if not isInVipArea then
		manorCityRead = nil
		;(nil).id = CONST_VALUE.GARDEN_AREA1_ITEM_ID or 236401
		local (nil).count, costItem = 1, nil
		return costItem
	end
	local vipAreaCfg = manorCityRead.getVipAreaConfig(vipAreaIdx)
	local _tilePos = cc.p(tilePos.x - vipAreaCfg.beginX, tilePos.y - vipAreaCfg.beginY)
	local isInVillas, villasIdx = manorCityRead.getIsInVillas(_tilePos)
	if not isInVillas then
		manorCityRead = vipAreaCfg.beginY
		vipAreaCfg.beginY.id = CONST_VALUE.GARDEN_AREA2_ITEM_ID or 236101
		local vipAreaCfg.beginY.count, costItem = 1, vipAreaCfg.beginY
		return costItem
	end
	local costItem = manorCityRead.getVillasCostItem(villasIdx)
	return costItem
end
function manorCityUtil.gotoGardenCity(params)
	if worldMapDefine.inInCrossWar() and not worldMapDefine.isInGarden() then
		SoraDShowMsgTip(i18n("common_text_4479"))
		return
	end
	if not worldMapDefine.isGardenKingdomID() then
		manorCityCtrl:saveViewTypeAndTargetPos()
	end
	uiManager:show("ManorCityView", params)
end
function manorCityUtil.gotoGardenWar(targetPos, needRemind)
	if not manorCityUtil.checkServerUnlock() then
		SoraDShowMsgTip(i18n("common_text_3249"))
		return false
	end
	if worldMapDefine.inInCrossWar() and not worldMapDefine.isInGarden() then
		SoraDShowMsgTip(i18n("common_text_4479"))
		return false
	end
	local isSelected = targetPos and true or false
	if manorCityCtrl:getIsUnLock() then
		if worldMapDefine.isInGarden() then
			SoraDGotoWorldMapPoint(targetPos, isSelected)
			SoraDRemoveAllPanelFromManager()
		else
			manorCityUtil.gotoGardenWar2(needRemind, function()
				manorCityCtrl:reqInWarMap(targetPos)
			end)
		end
	else
		local kid = GAME_KINGDOM_ID_ASSIGN.GARDEN.START
		if not targetPos then
			local worldMapWarDef = include("worldMapWarDef")
			targetPos = worldMapWarDef.getMapCenterPoint(kid)
		end
		if worldMapDefine.isGardenKingdomID() then
			SoraDGotoWorldMapPoint(targetPos, isSelected, kid, nil, nil, false)
			SoraDRemoveAllPanelFromManager()
		else
			manorCityUtil.gotoGardenWar2(needRemind, function()
				manorCityCtrl:saveViewTypeAndTargetPos(targetPos)
				SoraDGotoWorldMapPoint(targetPos, isSelected, kid, nil, nil, true)
				SoraDRemoveAllPanelFromManager()
			end)
		end
	end
end
function manorCityUtil.gotoGardenWar2(needRemind, handle)
	if not needRemind then
		handle()
		return
	end
	local dailyRemindManager = include("dailyRemindManager")
	local remindType = dailyRemindManager.REMIND_TYPE.gardenWarEnter
	if not dailyRemindManager.checkNeedRemind(remindType) then
		handle()
		return
	end
	_ENV = nil
	;(nil).content = i18n("garden_text_44")
	;(nil).cancel = true
	;(nil).confirmFunc = function()
		handle()
	end
	;(nil).remindString = i18n("coffeeCraftsman_text_27")
	;(nil).remindFunc = function(value)
		if value then
			dailyRemindManager.addRemindToManager(remindType)
		end
	end
	uiManager:show("MessageBox", nil)
end
function manorCityUtil.gotoWorldMapPoint(targetPos, fromClassType, toClassType)
	print("==manorCityUtil.gotoWorldMapPoint==", targetPos, fromClassType, toClassType)
	if toClassType == gKingdomClassType.normal then
		manorCityUtil.outGardenWar(targetPos)
		return
	end
	if fromClassType == gKingdomClassType.normal then
		manorCityUtil.gotoGardenWar(targetPos, false)
		return
	end
end
function manorCityUtil.outGardenWar(targetPos)
	if worldMapDefine.isInGarden() then
		manorCityCtrl:reqOutWarMap(targetPos)
	else
		manorCityCtrl:resetViewTypeAndTargetPos(targetPos)
		local preViewType = manorCityCtrl:getViewType()
		if preViewType == VIEW_TYPE_MAP then
			SoraDGotoWorldMapPoint(nil, nil, nil, nil, nil, true)
		else
			local curViewType = G_MAINSCENE_CURRENT_VIEW_TYPE
			if curViewType == VIEW_TYPE_MAP then
				_ENV = nil
				;(nil).msg = "MESSAGE_MAINSCEN_ONSHOW"
				;(nil).viewType = preViewType
				SoraDSendMessage(nil)
			end
		end
	end
end
function manorCityUtil.checkServerUnlock()
	if not commonCheck.GARDEN then
		return false
	end
	local selfKid = gametop.playertop_:getKingdomID()
	local valueArray = CONST_ARRAY.GARDEN_UNLOCK_SERVER
	for i = 1, #valueArray, 2 do
		local beginKid = valueArray[i]
		local endKid = valueArray[i + 1]
		if selfKid >= beginKid and selfKid <= endKid then
			return true
		end
	end
	return false
end
function manorCityUtil.checkClientUnlock()
	local unlockLv = CONST_VALUE.GARDEN_UNLOCK_ANILA_LAMP_LEVEL or 0
	local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
	local jinnLv = magicLampCtrl:getJinnLv(gJinnType.JINN_TWO)
	if unlockLv > jinnLv then
		return false
	end
	local unlockTime = CONST_VALUE.GARDEN_UNLOCK_TIME_STAMP or 0
	if unlockTime > serviceFunctions.systemTime() then
		return false
	end
	return true
end
function manorCityUtil.checkFuncUnlock(funcKey, showMsg)
	local valueArray = CONST_ARRAY[funcKey]
	if #valueArray <= 0 then
		return true
	end
	local unlockBid, unlockBlv = valueArray[1], valueArray[2]
	local buildLv = manorCityCtrl:getBuildLvByBid(unlockBid)
	if unlockBlv <= buildLv then
		return true
	else
		if showMsg then
			local buildName = manorCityRead.getBuildName(unlockBid)
			_ENV = nil
			;(nil).buildName = buildName
			;(nil).lv = unlockBlv
			SoraDShowMsgTip(i18n("garden_text_38", nil))
		end
		return false
	end
end
function manorCityUtil.checkSeedExchangeUnlock(showMsg)
	return manorCityUtil.checkFuncUnlock("GARDEN_UNLOCK_SEED_EXCHANGE", showMsg)
end
function manorCityUtil.checkSeedMergeUnlock(showMsg)
	return manorCityUtil.checkFuncUnlock("GARDEN_UNLOCK_SEED_MERGE", showMsg)
end
function manorCityUtil.checkSeedCultivationUnlock(showMsg)
	return manorCityUtil.checkFuncUnlock("GARDEN_UNLOCK_SEED_CULTIVATION", showMsg)
end
function manorCityUtil.checkFuncUnlockVisit(funcKey, showMsg)
	local valueArray = CONST_ARRAY[funcKey]
	if #valueArray <= 0 then
		return true
	end
	local unlockBid, unlockBlv = valueArray[1], valueArray[2]
	local buildLv = 0
	if not manorCityCtrl.visitMapData then
		_ENV = manorCityCtrl.visitMapData
	end
	for __, mapObj in pairs(manorCityCtrl.visitMapData) do
		if mapObj.id == unlockBid then
			buildLv = math.max(buildLv, mapObj.lv)
		end
	end
	if unlockBlv <= buildLv then
		return true
	else
		if showMsg then
			local buildName = manorCityRead.getBuildName(unlockBid)
			_ENV = nil
			;(nil).buildName = buildName
			;(nil).lv = unlockBlv
			SoraDShowMsgTip(i18n("garden_text_38", nil))
		end
		return false
	end
end
function manorCityUtil.getQueueShowName(queueType)
	local queue = queueCtrl:queryQueue(queueType)
	if queue then
		dump(queue, "manorCityUtil.getQueueName")
		if queueType == gQueueTypeDef.garden_build_upgrade then
			local bid = queue.data.bid
			local buildName = manorCityRead.getBuildName(bid)
			return buildName
		elseif queueType == gQueueTypeDef.garden_technology then
			local technologyCtrl = SoraDGetCtrl("technologyCtrl")
			local queueData = technologyCtrl:studyingTechnology(queueType)
			local tid = tonumber(queueData.technologyID)
			local techName = manorTechRead.getName(tid)
			return techName
		end
	end
end
function manorCityUtil.getDressBuffLvMap(dressID)
	local manorCityRead, map
	local maxLv = manorCityRead.getDressMaxLv(dressID)
	for lv = 1, maxLv do
		local buff = manorCityRead.getDressBuff(dressID, lv)
		for i, v in ipairs(buff) do
			if not map[v.id] then
				manorCityRead = nil
				;(nil).lv = lv
				map[v.id], (nil).value = nil, v.value
			end
		end
	end
	return map
end
function manorCityUtil.getDressUpgradeInfo(dressID, dressLv)
	local manorCityRead, tableData
	local maxLv = manorCityRead.getDressMaxLv(dressID)
	local nextLv = math.min(maxLv, dressLv + 1)
	manorCityRead = maxLv
	maxLv.title = i18n("common_text_748")
	maxLv.value = dressLv
	local maxLv.nextValue, data = nextLv, maxLv
	table.insert(tableData, data)
	local power1 = manorCityRead.getDressPower(dressID, dressLv)
	local power2 = manorCityRead.getDressPower(dressID, nextLv)
	manorCityRead = dressID
	dressID.title = i18n("common_text_090")
	dressID.value = power1
	local dressID.nextValue, data = power2, dressID
	table.insert(tableData, data)
	local buffLvMap = manorCityUtil.getDressBuffLvMap(dressID)
	local maxLv = manorCityRead.getDressMaxLv(dressID)
	local maxBuff = manorCityRead.getDressBuff(dressID, maxLv)
	local buffList1 = manorCityRead.getDressBuff(dressID, dressLv)
	local buffList2 = manorCityRead.getDressBuff(dressID, nextLv)
	for i, v in ipairs(maxBuff) do
		local buffId = v.id
		manorCityRead = nil
		local (nil).title, data = buffDesRead.getTitleBase(buffId), nil
		if not buffList1[i] then
			manorCityRead = buffList1[i]
			local buffList1[i].value, buff1 = 0, buffList1[i]
		end
		if not buffList2[i] then
			manorCityRead = buffList2[i]
			local buffList2[i].value, buff2 = 0, buffList2[i]
		end
		local buffValue = buff1.value
		local nextValue = buff2.value
		data.value = buffDesRead.getTitleValueWithValue(buffId, buffValue)
		data.nextValue = buffDesRead.getTitleValueWithValue(buffId, nextValue)
		local unlockLv = buffLvMap[buffId].lv
		if nextLv == unlockLv then
			data.isNew = true
		elseif nextLv < unlockLv then
			data.isLock = true
			data.unlockLv = unlockLv
			buffValue = buffLvMap[buffId].value
			data.value = buffDesRead.getTitleValueWithValue(buffId, buffValue)
		end
		table.insert(tableData, data)
	end
	return tableData
end
function manorCityUtil.getBuildUpgradeInfo(buildID, buildLv)
	local manorCityRead, tableData
	local maxLv = manorCityRead.getBuildMaxLv(buildID)
	local nextLv = math.min(maxLv, buildLv + 1)
	local power1 = manorCityRead.getBuildPower(buildID, buildLv)
	local power2 = manorCityRead.getBuildPower(buildID, nextLv)
	manorCityRead = buildID
	buildID.title = i18n("common_text_090")
	buildID.value = power1
	local buildID.nextValue, data = power2, buildID
	table.insert(tableData, data)
	local buffList1 = manorCityRead.getBuildBuff(buildID, buildLv)
	local buffList2 = manorCityRead.getBuildBuff(buildID, nextLv)
	for i, v in ipairs(buffList2) do
		local buffId = v.id
		manorCityRead = nil
		local (nil).title, data = buffDesRead.getTitleBase(buffId), nil
		if not buffList1[i] then
			manorCityRead = buffList1[i]
			local buffList1[i].value, buff1 = 0, buffList1[i]
		end
		if not buffList2[i] then
			manorCityRead = buffList2[i]
			local buffList2[i].value, buff2 = 0, buffList2[i]
		end
		local buffValue = buff1.value
		local nextValue = buff2.value
		data.value = buffDesRead.getTitleValueWithValue(buffId, buffValue)
		data.nextValue = buffDesRead.getTitleValueWithValue(buffId, nextValue)
		table.insert(tableData, data)
	end
	return tableData
end
function manorCityUtil.isCanUpgrade(buildID, buildLv)
	local nextLv = buildLv + 1
	local maxLv = manorCityRead.getBuildMaxLv(buildID)
	if nextLv > maxLv then
		return false
	end
	local errprecond = true
	local manorCityRead, retPreCond
	local preCond = manorCityRead.getBuildPreCond(buildID, nextLv)
	for i, v in ipairs(preCond) do
		local _bid = v.bid
		local _blv = v.blv
		local _curLv = manorCityCtrl:getBuildLvByBid(_bid)
		local _isreach = true
		if _blv > _curLv then
			_isreach = false
			errprecond = false
		end
		manorCityRead = nil
		;(nil).bid = _bid
		;(nil).blv = _blv
		;(nil).curLv = _curLv
		;(nil).isreach = _isreach
		table.insert(retPreCond, nil)
	end
	local manorCityRead, retCostItems = (for generator), ipairs(preCond)
	local costItem = manorCityRead.getBuildCostItem(buildID, nextLv)
	for i, v in ipairs(costItem) do
		local _toolid = v.id
		local _toolcount = v.count
		local _curcount = backpackCtrl:getItemCount(_toolid)
		local _isreach = true
		if _toolcount > _curcount then
			_isreach = false
		end
		manorCityRead = nil
		;(nil).toolid = _toolid
		;(nil).toolcount = _toolcount
		;(nil).curcount = _curcount
		;(nil).isreach = _isreach
		table.insert(retCostItems, nil)
	end
	local manorCityRead, retCostRes = (for generator), ipairs(costItem)
	local costRes = manorCityRead.getBuildCostRes(buildID, nextLv)
	for i, v in ipairs(costRes) do
		local _resid = v.id
		local _rescount = v.count
		local _curcount = cityCtrl:getResCount(_resid) or 0
		local _isreach = true
		if _rescount > _curcount then
			_isreach = false
		end
		manorCityRead = nil
		;(nil).resid = _resid
		;(nil).rescount = _rescount
		;(nil).curcount = _curcount
		;(nil).isreach = _isreach
		table.insert(retCostRes, nil)
	end
	local manorCityRead, buildQueueList = (for generator), ipairs(costRes)
	local freequeue = queueCtrl:queryQueue(gQueueTypeDef.garden_build_upgrade)
	if freequeue then
		table.insert(buildQueueList, freequeue)
	end
	local costtime = manorCityUtil.getUpgradeTime(buildID, nextLv)
	local timeToGold = serviceFunctions.timeConvertToGold(costtime)
	local resToGold = 0
	for k, v in pairs(retCostRes) do
		if v.rescount > v.curcount then
			local _rescount = v.rescount
			local needBuyRes = math.max(_rescount - v.curcount, 0)
			resToGold = resToGold + serviceFunctions.resConvertToGold(v.resid, needBuyRes)
		end
	end
	local immediatelyGold = resToGold + timeToGold
	manorCityRead = pairs(retCostRes)
	pairs(retCostRes)._buildQueueList = buildQueueList
	pairs(retCostRes)._retPreCond = retPreCond
	pairs(retCostRes)._retCostRes = retCostRes
	pairs(retCostRes)._retCostItems = retCostItems
	pairs(retCostRes)._costtime = costtime
	pairs(retCostRes)._resToGold = resToGold
	local pairs(retCostRes)._immediatelyGold, retdata = immediatelyGold, pairs(retCostRes)
	return errprecond, retdata
end
function manorCityUtil.getUpgradeTime(buildID, buildLv)
	local basetime = manorCityRead.getBuildCostTime(buildID, buildLv)
	return basetime
end
function manorCityUtil.getBuildInfo(buildID, buildLv)
	local manorCityRead, tableData
	local buffList = manorCityRead.getBuildBuff(buildID, buildLv)
	for i, v in ipairs(buffList) do
		local buffId = v.id
		local buffValue = v.value
		manorCityRead = nil
		;(nil).title = buffDesRead.getTitleBase(buffId)
		local (nil).value, data = buffDesRead.getTitleValueWithValue(buffId, buffValue), nil
		table.insert(tableData, data)
	end
	return tableData
end
function manorCityUtil.getMainBuildLvLimit()
	local maxLv = manorCityRead.getBuildMaxLv(MANOR_BUILD_ID.MAIN)
	local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
	local lvLimit = nebulaMileStoneCtrl:getPlusByUnlockTypeEx(gNebulaMileStoneUnlockType.UNLOCK_GARDEN_BUILD_LV_3101) or 0
	if 0 < lvLimit then
		return math.min(maxLv, lvLimit)
	end
	return maxLv
end
function manorCityUtil.getMainBuildCurrentLv()
	local maxLv = manorCityRead.getBuildMaxLv(MANOR_BUILD_ID.MAIN)
	local curLv = manorCityCtrl:getBuildLvByBid(MANOR_BUILD_ID.MAIN) or 0
	return math.min(maxLv, curLv)
end
function manorCityUtil.checkBuildPreCondWithinLimit(buildID, buildLv, cache)
	local preCond = manorCityRead.getBuildPreCond(buildID, buildLv)
	for _, v in ipairs(preCond) do
		local preBuildID = v.bid
		local preBuildLv = v.blv
		if preBuildID and preBuildLv and 0 < preBuildLv then
			local preLimitLv = preBuildID == MANOR_BUILD_ID.MAIN and manorCityUtil.getMainBuildLvLimit() or manorCityUtil.getBuildLvLimit(preBuildID, cache)
			if preBuildLv > preLimitLv then
				return false
			end
		end
	end
	return true
end
function manorCityUtil.getBuildLvLimit(buildID, cache)
	if not buildID then
		return 0
	end
	local maxLv = manorCityRead.getBuildMaxLv(buildID)
	if buildID == MANOR_BUILD_ID.MAIN then
		return manorCityUtil.getMainBuildLvLimit()
	end
	if not cache then
		cache, manorCityRead = manorCityUtil.getMainBuildLvLimit, manorCityUtil.getMainBuildLvLimit
	end
	if cache[buildID] then
		return cache[buildID]
	end
	local limitLv = 0
	for buildLv = 1, maxLv do
		if manorCityUtil.checkBuildPreCondWithinLimit(buildID, buildLv, cache) then
			limitLv = buildLv
		else
			break
		end
	end
	cache[buildID] = math.max(1, limitLv)
	return cache[buildID]
end
function manorCityUtil.getBuildMoreInfo(buildID)
	local _ENV, tableData
	local _ENV, tableTitle
	manorCityRead = nil
	;(nil)[1] = i18n("common_text_748")
	;(nil)[2] = "string"
	table.insert(tableTitle, nil)
	local maxLv = manorCityUtil.getBuildLvLimit(buildID)
	local maxBuff = manorCityRead.getBuildBuff(buildID, maxLv)
	for i, v in ipairs(maxBuff) do
		local buffTitle = buffDesRead.getTitleBase(v.id)
		manorCityRead = nil
		;(nil)[1] = buffTitle
		;(nil)[2] = "string"
		table.insert(tableTitle, nil)
	end
	manorCityRead = ipairs(maxBuff)
	ipairs(maxBuff)[1] = i18n("common_text_090")
	ipairs(maxBuff)[2] = "string"
	table.insert(tableTitle, ipairs(maxBuff))
	table.insert(tableData, tableTitle)
	local initLv = 1
	for curLv = initLv, maxLv do
		local _ENV, tableValue = buffDesRead.getTitleBase(v.id), buffDesRead.getTitleBase(v.id)
		manorCityRead = nil
		;(nil)[1] = curLv
		;(nil)[2] = "number"
		table.insert(tableValue, nil)
		local buffList = manorCityRead.getBuildBuff(buildID, curLv)
		for i, v in ipairs(maxBuff) do
			if not buffList[i] then
				local _ENV, _buff = buffList[i], buffList[i]
			end
			local _value = _buff.value or 0
			local buffValue = buffDesRead.getTitleValueWithValue(v.id, _value)
			manorCityRead = nil
			;(nil)[1] = buffValue
			;(nil)[2] = "number"
			table.insert(tableValue, nil)
		end
		local power = manorCityRead.getBuildPower(buildID, curLv)
		manorCityRead = "number"
		;("number")[1] = string.formatnumberthousands(power)
		;("number")[2] = "number"
		table.insert(tableValue, "number")
		table.insert(tableData, tableValue)
	end
	return tableData
end
function manorCityUtil.checkBuildUnlock(buildID, buildCount)
	local buildUnlock = manorCityRead.getBuildUnlock(buildID)
	local unlock = buildUnlock[buildCount]
	if unlock then
		local _bid = unlock.bid
		local _blv = unlock.blv
		if _blv > manorCityCtrl:getBuildLvByBid(_bid) then
			return false, unlock
		end
	end
	return true
end
function manorCityUtil.getBuildUnlockNum(buildID)
	local maxCount = manorCityRead.getBuildMaxNum(buildID)
	for i = 1, maxCount do
		if not manorCityUtil.checkBuildUnlock(buildID, i) then
			return i - 1
		end
	end
	return maxCount
end
function manorCityUtil.getBuildIsNew(buildId)
	local buildType = manorCityRead.getBuildType(buildId)
	if buildType == MANOR_BUILD_TYPE.BUILD then
		local hasCount = manorCityCtrl:getBuildCountByBid(buildId)
		local unlockNum = manorCityUtil.getBuildUnlockNum(buildId)
		if hasCount >= unlockNum then
			return false
		end
	elseif buildType == MANOR_BUILD_TYPE.SCENERY then
		return false
	end
	manorCityRead = false
	;(false).byUID = true
	if not SoraDConfigGet("Game:manorCityCtrl:newConfig~table", false) then
		local manorCityRead, newConfig = SoraDConfigGet("Game:manorCityCtrl:newConfig~table", false), SoraDConfigGet("Game:manorCityCtrl:newConfig~table", false)
	end
	return newConfig[tostring(buildId)] ~= false
end
function manorCityUtil.setBuildIsNew(buildId, isNew)
	local buildType = manorCityRead.getBuildType(buildId)
	if buildType == MANOR_BUILD_TYPE.SCENERY then
		return
	end
	manorCityRead = nil
	;(nil).byUID = true
	if not SoraDConfigGet("Game:manorCityCtrl:newConfig~table", nil) then
		local manorCityRead, newConfig = SoraDConfigGet("Game:manorCityCtrl:newConfig~table", nil), SoraDConfigGet("Game:manorCityCtrl:newConfig~table", nil)
	end
	if newConfig[tostring(buildId)] == isNew then
		return
	end
	newConfig[tostring(buildId)] = isNew
	manorCityRead = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:manorCityCtrl:newConfig~table", newConfig, nil)
end
function manorCityUtil.resetGardenNewConfig()
	_ENV, _ENV = nil, nil
	;(nil).byUID = true
	SoraDConfigSet("Game:manorCityCtrl:newConfig~table", nil, nil)
end
function manorCityUtil.getBuildListIsNew()
	for buildType = 1, MANOR_BUILD_TYPE.COLLECTION do
		if manorCityUtil.getBuildTypeListIsNew(buildType) then
			return true
		end
	end
	return false
end
function manorCityUtil.getBuildTypeListIsNew(buildType)
	local _ENV, buildIDList
	if buildType == MANOR_BUILD_TYPE.COLLECTION then
		buildIDList = manorCityCtrl:getOwnedDressIDList()
	elseif buildType == MANOR_BUILD_TYPE.SCENERY then
		return false
	else
		buildIDList = manorCityRead.getBuildIDListByType(buildType)
	end
	for _, buildId in ipairs(buildIDList) do
		if manorCityUtil.getBuildIsNew(buildId) then
			return true
		end
	end
	return false
end
function manorCityUtil.getFarmStatus(data)
	if type(data) == "table" then
		local plantData = data.extra.plant
		if not plantData or serviceFunctions.isNilOrZero(plantData.seedId) then
			return 1
		elseif serviceFunctions.systemTime() >= plantData.fruitTime then
			return 2
		else
			return 0
		end
	elseif type(data) == "number" then
		local iid = data
		local mapObj = manorCityCtrl:getMapObjByBid(MANOR_BUILD_ID.FARM, iid)
		if mapObj then
			local plantData = mapObj.extra.plant
			if not plantData or serviceFunctions.isNilOrZero(plantData.seedId) then
				return 1
			elseif serviceFunctions.systemTime() >= plantData.fruitTime then
				return 2
			else
				return 0
			end
		end
	end
	return -1
end
function manorCityUtil.previewFarmProduceNumAndTime(farmiid, seedId)
	local seedData = manorFarmRead.getSeedInfo(seedId)
	if not seedData then
		return 0
	end
	local mapObj = manorCityCtrl:getMapObjByBid(MANOR_BUILD_ID.FARM, farmiid)
	if not mapObj then
		return 0
	end
	local baseNum = seedData.fruitNum
	local baseTime = seedData.time
	local farmType = mapObj.extra.type
	local seedType = seedData.seedType
	local relation = manorFarmRead.getTypeMatch(farmType, seedType)
	if not manorCityCtrl:getFarmResonance(farmiid) then
		manorFarmRead = manorCityCtrl:getFarmResonance(farmiid)
	end
	local resonanceBuff = manorCityCtrl:getFarmResonance(farmiid).bonus or 0
	local resultNum = math.floor(baseNum * relation.production / 1000 * (1 + resonanceBuff / 1000 + manorCityCtrl:getBuffVale(gBuffEffect.GARDEN_FARMLAND_OUTPUT_BOOST) / 1000))
	local resultTime = baseTime
	return math.max(resultNum, 1), resultTime
end
function manorCityUtil.canReceiveFarmFruit(farmiid)
	local mapObj = manorCityCtrl:getMapObjByBid(MANOR_BUILD_ID.FARM, farmiid)
	if mapObj then
		if not mapObj.extra.plant then
			return false
		end
		return serviceFunctions.systemTime() >= mapObj.extra.plant.fruitTime
	end
	return false
end
function manorCityUtil.checkSeedCultivateUnlock(queue)
	local unlockData = manorFarmRead.getSeedCultivateUnlock(queue)
	if not unlockData then
		return false
	end
	local buildLv = manorCityCtrl:getBuildLvByBid(unlockData.seedBuildLv[1]) or 0
	if buildLv == 0 or buildLv >= unlockData.seedBuildLv[2] then
		return true
	else
		return false
	end
end
function manorCityUtil.getSeedCultivateStatus(queue)
	if not queue then
		return -1
	end
	local unlock = manorCityUtil.checkSeedCultivateUnlock(queue)
	if unlock then
		local data = manorCityCtrl:getSeedCultivateData(queue)
		if not data then
			return 1
		elseif data.input and data.input[1] then
			if serviceFunctions.systemTime() > data.outputTime then
				return 3
			else
				return 2
			end
		else
			return 1
		end
	else
		return 0
	end
end
function manorCityUtil.getFruitCultivateStatus(queue)
	if not queue then
		return -1
	end
	local unlock = manorCityCtrl:checkFruitCultivateUnlock(queue)
	if unlock then
		local data = manorCityCtrl:getFruitCultivateData(queue)
		if not data then
			return 1
		elseif data.fruitId then
			local canGet = manorCityUtil.previewFruitCultivateCount(queue)
			if 0 < canGet then
				return 2
			else
				return 2
			end
		else
			return 1
		end
	else
		return 0
	end
end
function manorCityUtil.previewFruitCultivateCount(qid)
	local queue = manorCityCtrl:getFruitCultivateData(qid)
	if queue and queue.fruitId then
		local fruitCfg = manorFarmRead.getSeedInfoByFruitID(queue.fruitId)
		local pastTime = serviceFunctions.systemTime() - queue.t
		local n = math.floor(pastTime / fruitCfg.cultitaveTime)
		return n
	else
		return 0
	end
end
function manorCityUtil.getFarmNumInType(type)
	local farmObjs = manorCityCtrl:getBuildListBybid(MANOR_BUILD_ID.FARM)
	local result = 0
	for k, v in pairs(farmObjs) do
		if v.extra.type == type then
			result = result + 1
		end
	end
	return result
end
function manorCityUtil.getFarmTypesInNum(num, maxNum)
	local farmObjs = manorCityCtrl:getBuildListBybid(MANOR_BUILD_ID.FARM)
	local manorCityCtrl, typeMap = manorCityCtrl, manorCityCtrl
	for k, v in pairs(farmObjs) do
		if not typeMap[v.extra.type] then
			typeMap[v.extra.type] = 0
		end
		typeMap[v.extra.type] = typeMap[v.extra.type] + 1
	end
	local manorCityCtrl, result = (for generator), pairs(farmObjs)
	for k, v in pairs(typeMap) do
		if num <= v and (not maxNum or maxNum > v) then
			table.insert(result, k)
		end
	end
	table.sort(result)
	return result
end
function manorCityUtil.getResonanceUnlock(lv)
	local farmObjs = manorCityCtrl:getBuildListBybid(MANOR_BUILD_ID.FARM)
	local manorCityCtrl, typeMap = manorCityCtrl, manorCityCtrl
	for k, v in pairs(farmObjs) do
		if not typeMap[v.extra.type] then
			typeMap[v.extra.type] = 0
		end
		typeMap[v.extra.type] = typeMap[v.extra.type] + 1
	end
	local resonance = manorFarmRead.getResonance(lv)
	for k, num in pairs(typeMap) do
		if num >= resonance.farmlandNum then
			return true
		end
	end
	return false
end
function manorCityUtil.getMaxFarmNum()
	local farmObjs = manorCityCtrl:getBuildListBybid(MANOR_BUILD_ID.FARM)
	local manorCityCtrl, typeMap = manorCityCtrl, manorCityCtrl
	for k, v in pairs(farmObjs) do
		if not typeMap[v.extra.type] then
			typeMap[v.extra.type] = 0
		end
		typeMap[v.extra.type] = typeMap[v.extra.type] + 1
	end
	local result = 0
	for k, num in pairs(typeMap) do
		if num > result then
			result = num
		end
	end
	return result
end
function manorCityUtil.getMaxFarmHandbookBuffReqNum()
	local result = 0
	local handbookBuffs = manorFarmRead.getAllHandBookBuff()
	for k, buffData in pairs(handbookBuffs) do
		if result < buffData.fruitNum then
			result = result + 1
		end
	end
	return result
end
function manorCityUtil.checkAttendedBanquet(mapObj)
	if mapObj.id ~= MANOR_BUILD_ID.BANQUET then
		return false
	else
		local myPlayerId = SoraDGetPlayerID()
		if not mapObj.extra.getedUidMap then
			_ENV = mapObj.extra.getedUidMap
		end
		for k, v in pairs(mapObj.extra.getedUidMap) do
			if tonumber(k) == myPlayerId then
				return true
			end
		end
		return false
	end
end
function manorCityUtil.checkReachBanquetMax()
	if CONST_VALUE.GARDEN_BANQUET_REWARD_LIMIT > manorCityCtrl:getPartyRewardTimes() then
		return false
	end
	return true
end
function manorCityUtil.splitRealId(str)
	local params = string.split(str, "_")
	local x = tonumber(params[1])
	local y = tonumber(params[2])
	local id = tonumber(params[3])
	local iid = tonumber(params[4])
	return x, y, id, iid
end
function manorCityUtil.spliceRealId(x, y, id, iid)
	return string.format("%d_%d_%d_%d", x, y, id, iid)
end
function manorCityUtil.createMapData(map)
	local manorCityUtil, mapData
	local needBid, needLv = manorCityUtil.getLayoutUnlockCond()
	for k, __ in pairs(map) do
		local x, y, id, iid = manorCityUtil.splitRealId(k)
		manorCityUtil = nil
		;(nil).realId = k
		;(nil).x = x
		;(nil).y = y
		;(nil).id = id
		;(nil).iid = iid
		;(nil).extra, manorCityUtil, (nil).lv = needLv or 0, needLv or 0, needLv or 0
		local mapObj
		mapData[k] = mapObj
	end
	return mapData
end
function manorCityUtil.createMapObj(x, y, id)
	local iid = 0
	local realId = manorCityUtil.spliceRealId(x, y, id, iid)
	manorCityUtil = x
	x.realId = realId
	x.x = x
	x.y = y
	x.id = id
	x.iid = iid
	x.extra, manorCityUtil, x.lv = y, y, 0
	local mapObj = x
	local needBid, needLv = manorCityUtil.getLayoutUnlockCond()
	if needLv then
		mapObj.lv = needLv
	end
	return mapObj
end
function manorCityUtil.getLayoutNumLimit()
	return CONST_VALUE.GARDEN_LAYOUT_NUM_LIMIT
end
function manorCityUtil.getLayoutUnlockCond()
	local array = CONST_ARRAY.GARDEN_UNLOCK_SHARE_LAYOUT
	local needBid, needLv = array[1], array[2]
	return needBid, needLv
end
function manorCityUtil.getCurLayoutMap()
	local gardenMap = manorCityCtrl:getGardenMapData()
	return manorCityUtil.gardenMap2LayoutMap(gardenMap)
end
function manorCityUtil.gardenMap2LayoutMap(gardenMap)
	local _ENV, layoutMap
	for k, v in pairs(gardenMap) do
		local x, y, id, iid = manorCityUtil.splitRealId(k)
		local buildType = manorCityRead.getBuildType(id)
		local isShow = true
		if buildType == MANOR_BUILD_TYPE.BUILD and not manorCityRead.getIsShow(id) then
			isShow = false
		end
		if isShow then
			layoutMap[k] = 1
		end
	end
	return layoutMap
end
function manorCityUtil.isLayoutComplete(map)
	if type(map) ~= "table" then
		print("manorCityUtil.isLayoutComplete map is not a table")
		return false
	end
	local _ENV, buildNum = false, false
	for realId, v in pairs(map) do
		local x, y, bid, iid = manorCityUtil.splitRealId(realId)
		local buildType = manorCityRead.getBuildType(bid)
		if buildType == MANOR_BUILD_TYPE.BUILD then
			buildNum[bid] = (buildNum[bid] or 0) + 1
		end
	end
	local unlockBuildNum = manorCityCtrl:getUnlockBuildNum()
	for bid, count in pairs(buildNum) do
		local unlockNum = unlockBuildNum[bid] or 0
		if count ~= unlockNum then
			print("manorCityUtil.isLayoutComplete unlockNum", bid, count, unlockNum)
			return false
		end
	end
	for bid, unlockNum in pairs(unlockBuildNum) do
		local count = buildNum[bid] or 0
		if count ~= unlockNum then
			print("manorCityUtil.isLayoutComplete count", bid, count, unlockNum)
			return false
		end
	end
	return true
end
return manorCityUtil
