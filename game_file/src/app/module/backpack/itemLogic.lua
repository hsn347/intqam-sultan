local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local itemConfig = include("itemConfig")
local gametop = gModuleMgr.getObject("gametop")
local itemDesRead = include("itemDesRead")
local resDesRead = include("resDesRead")
local msgNotice = include("msgNotice")
local _ENV, itemLogic = "msgNotice", "msgNotice"
function itemLogic.use(itemID, count, ...)
	if not itemID or count then
	end
end
function itemLogic.checkCountLimit(itemID, count)
	assert(itemID, "the itemID is nil!")
	assert(count, "the count is nil!")
	local limitCount = BAG_ONE_ITEM_MAX_COUNT
	if count > limitCount then
		return false, gErrDef.Err_ITEM_COUNT_IS_LIMIT
	else
		return true
	end
end
function itemLogic.checkUseLimit(itemID, count)
	assert(itemID, "the itemID is nil!")
	assert(count, "the count is nil!")
	local limitCount = backpackltCtrl:getUseMax(itemID)
	if count > limitCount then
		return false, gErrDef.Err_ITEM_USE_COUNT_IS_LIMIT
	else
		return true
	end
end
function itemLogic.calCellCount(itemID, count)
	local cellLimit = backpackltCtrl:getUnitMax(itemID)
	return math.ceil(count / cellLimit)
end
function itemLogic.checkCastleLevelCond(itemID, needTip)
	if not itemID then
		return
	end
	local level = backpackltCtrl:getCastleLevelCond(itemID) or 0
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local curLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
	if level > curLevel then
		if needTip then
			local isShowWarLv, cityLevel, limitDes = SoraDGetBuildWarLv(level)
			if isShowWarLv then
				backpackltCtrl = nil
				backpackltCtrl = nil
				;(nil).lv = limitDes
				;(nil).level = i18n("common_text_1948", nil)
				;(nil).itemID = itemDesRead.getName(itemID)
				SoraDShowMsgTip(i18n("notice_0122", nil), itemDesRead.getIcon(itemID, true))
			else
				backpackltCtrl = itemDesRead.getIcon(itemID, true)
				itemDesRead.getIcon(itemID, true).level = limitDes
				itemDesRead.getIcon(itemID, true).itemID = itemDesRead.getName(itemID)
				SoraDShowMsgTip(i18n("notice_0122", itemDesRead.getIcon(itemID, true)), itemDesRead.getIcon(itemID, true))
			end
		end
		return false, gErrDef.Err_CASTLE_LEVEL_IS_NOT_REACHED, level
	end
	return true
end
function itemLogic.checkLordLevelCond(itemID, needTip)
	if not itemID then
		return
	end
	local level = backpackltCtrl:getLordLevelCond(itemID)
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local lordInfo = lordInfoCtrl:getBaseInfo()
	local curLevel = lordInfo.leve
	if not (curLevel and level) or level > curLevel then
		if needTip then
			backpackltCtrl = nil
			;(nil).level = level
			;(nil).itemID = itemDesRead.getName(itemID)
			SoraDShowMsgTip(i18n("notice_0123", nil), itemDesRead.getIcon(itemID, true))
		end
		return false, gErrDef.Err_LORD_LEVEL_IS_NOT_REACHED, level
	end
	return true
end
function itemLogic.checkVIPLevelCond(itemID, needTip)
	if not itemID then
		return
	end
	if not backpackltCtrl:getUseCondition(itemID, gItemUseCondType.VIP) then
		local backpackltCtrl, limitTbl = backpackltCtrl:getUseCondition(itemID, gItemUseCondType.VIP), backpackltCtrl:getUseCondition(itemID, gItemUseCondType.VIP)
	end
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local vipTbl = lordInfoCtrl:getVip()
	if next(limitTbl) then
		limitTbl = limitTbl[1]
		if tonumber(vipTbl[1]) < limitTbl.lv then
			if needTip then
				backpackltCtrl = nil
				;(nil).lv = limitTbl.lv
				SoraDShowMsgTip(i18n("common_text_3972", nil))
			end
			return false, gErrDef.Err_PYRAMID_NOT_ENOUGH_VIP, limitTbl.lv
		end
		if limitTbl.needactive == 1 and not vipTbl[2] then
			if needTip then
				SoraDShowMsgTip(i18n("common_text_2824"))
			end
			return false, gErrDef.Err_VIP_NO_ACTIVATING, limitTbl.needactive
		end
	end
	return true
end
function itemLogic.checkUseCond(itemID, needTip)
	local ok, err = true
	ok, err = itemLogic.checkCastleLevelCond(itemID, needTip)
	if not ok then
		return ok, err
	end
	ok, err = itemLogic.checkLordLevelCond(itemID, needTip)
	if not ok then
		return ok, err
	end
	ok, err = itemLogic.checkVIPLevelCond(itemID, needTip)
	if not ok then
		return ok, err
	end
	ok, err = itemLogic.checkUseCondSpecial(itemID, needTip)
	return ok, err
end
function itemLogic.checkUseCondSpecial(itemID, needTip)
	local itemType = backpackltCtrl:getItemType(itemID)
	if itemLogic.itemSpicealFunMap[itemType] then
		return itemLogic.itemSpicealFunMap[itemType](itemID, needTip)
	end
	return true
end
function itemLogic.wargemBox(itemID, needTip)
	if not itemID then
		return
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local curLevel = cityCtrl:getBuildMaxLv(BUILDID.MIRACLE)
	local level = 30
	if curLevel < level then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4093"))
		end
		return false
	end
	return true
end
function itemLogic.remainsSpeedUP(itemID, needTip)
	if not itemID then
		return
	end
	if itemID == _G.ITEM_REMAINSWAR_SPEEDUP then
		return worldMapDefine.isInRemains()
	end
	return true
end
function itemLogic.crossWarForbid(itemID, needTip)
	if not itemID then
		return
	end
	if worldMapDefine.isInKingdomBattle() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4479"))
		end
		return false
	elseif worldMapDefine.isInWar() then
		if needTip then
			worldMapDefine.showWarTips()
		end
		return false
	end
	return true
end
function itemLogic.remainsWarForbid(itemID, needTip)
	if not itemID then
		return
	end
	if worldMapDefine.isInWarForbidItem(not needTip) then
		return false
	end
	return true
end
function itemLogic.recruitArmyForbid(itemID, needTip)
	if not itemID then
		return
	end
	local warName = ""
	local isPass = true
	local worldMapWarDef = include("worldMapWarDef")
	if worldMapWarDef.isInWarForbidSoldier(true) then
		warName = worldMapWarDef.getKingdomName()
		isPass = false
	end
	if not isPass then
		_ENV = nil
		;(nil).name = warName
		SoraDShowMsgTip(i18n("common_text_4559", nil))
	end
	return isPass
end
function itemLogic.kingWarForbid(itemID, needTip)
	if not itemID then
		return
	end
	if worldMapDefine.kingWarStatus == gKingdomWarStatusType.close then
		SoraDShowMsgTip(i18n("parliament_text_01"))
		return false
	end
	return true
end
function itemLogic.iceHuntingItemForbid(itemID, needTip)
	if not itemID then
		return
	end
	if worldMapDefine.isInKingdomBattle() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4479"))
		end
		return false
	elseif worldMapDefine.isInWar() then
		if needTip then
			worldMapDefine.showWarTips()
		end
		return false
	end
	return true
end
function itemLogic.recruitArmyBuildForbid(itemID, needTip)
	if worldMapDefine.isInWar() then
		SoraDShowMsgTip(i18n("common_text_4655"))
		return false
	end
	local buidID = backpackltCtrl:getResult(itemID)[1]
	if 1 <= SoraDGetBuildLv(buidID) then
		return true
	end
	local buildRead = include("buildDescribeRead")
	_ENV = i18n("common_text_4655")
	i18n("common_text_4655").build = buildRead.getName(buidID)
	SoraDShowMsgTip(i18n("common_text_4654", i18n("common_text_4655")))
	return false
end
_ENV, itemLogic.massacreForbid = function(itemID, needTip)
	if worldMapDefine.isInPyramid() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4706"))
		end
		return false
	end
	return true
end, function(itemID, needTip)
	if worldMapDefine.isInPyramid() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4706"))
		end
		return false
	end
	return true
end
;(function(itemID, needTip)
	if worldMapDefine.isInPyramid() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4706"))
		end
		return false
	end
	return true
end)[gItemType.WAR_GEM] = itemLogic.wargemBox
;(function(itemID, needTip)
	if worldMapDefine.isInPyramid() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4706"))
		end
		return false
	end
	return true
end)[gItemType.MARCH_SPEED_UP] = itemLogic.remainsSpeedUP
;(function(itemID, needTip)
	if worldMapDefine.isInPyramid() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4706"))
		end
		return false
	end
	return true
end)[gItemType.GOD_LANTERM] = itemLogic.remainsWarForbid
;(function(itemID, needTip)
	if worldMapDefine.isInPyramid() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4706"))
		end
		return false
	end
	return true
end)[gItemType.GAOYANG] = itemLogic.remainsWarForbid
;(function(itemID, needTip)
	if worldMapDefine.isInPyramid() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4706"))
		end
		return false
	end
	return true
end)[gItemType.SEA_MONSTER] = itemLogic.remainsWarForbid
;(function(itemID, needTip)
	if worldMapDefine.isInPyramid() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4706"))
		end
		return false
	end
	return true
end)[gItemType.PIGEON] = itemLogic.remainsWarForbid
;(function(itemID, needTip)
	if worldMapDefine.isInPyramid() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4706"))
		end
		return false
	end
	return true
end)[gItemType.RECRUIT_SOLDIERS] = itemLogic.recruitArmyForbid
;(function(itemID, needTip)
	if worldMapDefine.isInPyramid() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4706"))
		end
		return false
	end
	return true
end)[gItemType.GOLD_GIFT] = itemLogic.crossWarForbid
;(function(itemID, needTip)
	if worldMapDefine.isInPyramid() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4706"))
		end
		return false
	end
	return true
end)[gItemType.RECHARGE_GOLD_GIFT] = itemLogic.crossWarForbid
;(function(itemID, needTip)
	if worldMapDefine.isInPyramid() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4706"))
		end
		return false
	end
	return true
end)[gItemType.ICE_HUNTING_ITEM] = itemLogic.iceHuntingItemForbid
;(function(itemID, needTip)
	if worldMapDefine.isInPyramid() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4706"))
		end
		return false
	end
	return true
end)[gItemType.GOLDBAR] = itemLogic.kingWarForbid
;(function(itemID, needTip)
	if worldMapDefine.isInPyramid() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4706"))
		end
		return false
	end
	return true
end)[gItemType.RECRUIT_ARMY_ITEM] = itemLogic.recruitArmyForbid
;(function(itemID, needTip)
	if worldMapDefine.isInPyramid() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4706"))
		end
		return false
	end
	return true
end)[gItemType.SOLDIER_RECRUITMENT] = itemLogic.recruitArmyBuildForbid
_ENV, itemLogic.itemSpicealFunMap, (function(itemID, needTip)
	if worldMapDefine.isInPyramid() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4706"))
		end
		return false
	end
	return true
end)[gItemType.MASSACRE] = function(itemID, needTip)
	if worldMapDefine.isInPyramid() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4706"))
		end
		return false
	end
	return true
end, function(itemID, needTip)
	if worldMapDefine.isInPyramid() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4706"))
		end
		return false
	end
	return true
end, itemLogic.massacreForbid
;(function(itemID, needTip)
	if worldMapDefine.isInPyramid() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4706"))
		end
		return false
	end
	return true
end)[gBuffEffect.LURE_ENEMY] = gBuffEffect.CAMOUFLAGE
;(function(itemID, needTip)
	if worldMapDefine.isInPyramid() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4706"))
		end
		return false
	end
	return true
end)[gBuffEffect.CAMOUFLAGE] = gBuffEffect.LURE_ENEMY
;(function(itemID, needTip)
	if worldMapDefine.isInPyramid() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4706"))
		end
		return false
	end
	return true
end)[gBuffEffect.CASTLE_DRESS_UP] = gBuffEffect.HIGH_CASTLE_DRESS_UP
_ENV, itemLogic.mutualExclusionBuffMap, (function(itemID, needTip)
	if worldMapDefine.isInPyramid() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4706"))
		end
		return false
	end
	return true
end)[gBuffEffect.HIGH_CASTLE_DRESS_UP] = function(itemID, needTip)
	if worldMapDefine.isInPyramid() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4706"))
		end
		return false
	end
	return true
end, function(itemID, needTip)
	if worldMapDefine.isInPyramid() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4706"))
		end
		return false
	end
	return true
end, gBuffEffect.CASTLE_DRESS_UP
;(function(itemID, needTip)
	if worldMapDefine.isInPyramid() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4706"))
		end
		return false
	end
	return true
end)[gItemType.WOOD_OUTPUT_BOOST] = BUILDID.SAWMILL
;(function(itemID, needTip)
	if worldMapDefine.isInPyramid() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4706"))
		end
		return false
	end
	return true
end)[gItemType.FOOD_OUTPUT_BOOST] = BUILDID.FARM
;(function(itemID, needTip)
	if worldMapDefine.isInPyramid() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4706"))
		end
		return false
	end
	return true
end)[gItemType.IRON_OUTPUT_BOOST] = BUILDID.IRON_MINE
;(function(itemID, needTip)
	if worldMapDefine.isInPyramid() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4706"))
		end
		return false
	end
	return true
end)[gItemType.MITHRIL_OUTPUT_BOOST] = BUILDID.STEEL
itemLogic.buffToBuildID, (function(itemID, needTip)
	if worldMapDefine.isInPyramid() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4706"))
		end
		return false
	end
	return true
end)[gItemType.CRYSTAL_OUTPUT_BOOST] = function(itemID, needTip)
	if worldMapDefine.isInPyramid() then
		if needTip then
			SoraDShowMsgTip(i18n("common_text_4706"))
		end
		return false
	end
	return true
end, BUILDID.CRYSTAL_MINE
function itemLogic.petExp(itemID, itemCount, otherData)
	local petCtrl = gametop.playertop_:getModule("petCtrl")
	local petList = petCtrl:getPetList()
	if petList == nil or next(petList) == nil then
		SoraDShowMsgTip(i18n("common_text_2988"))
	else
		gametop = i18n("common_text_2988")
		i18n("common_text_2988").useItem = true
		uiManager:show("PetFguiView", i18n("common_text_2988"))
	end
	return true
end
function itemLogic.lordExp(itemID, itemCount, otherData)
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local baseInfo = lordInfoCtrl:getBaseInfo()
	local isReachFullExp = baseInfo.isReachFullExp
	local lordLocalData = include("lordLocalData")
	local curLv = lordInfoCtrl:getLevel()
	local levelMax = lordLocalData.getMaxLordLv()
	local isReachFullExp = isReachFullExp or curLv == levelMax
	if isReachFullExp then
		SoraDShowMsgTip(i18n("common_text_4490"))
		return true
	end
	return false
end
function itemLogic.useHuntPoint(itemID, itemCount, otherData)
	if worldMapDefine.isInWar() then
		SoraDShowMsgTip(i18n("common_text_3302"))
		return true
	elseif SoraDGetCastleLv() < ALLIANCE_HUNT_CASTLE_LV_MIN then
		_ENV = i18n("common_text_3302")
		i18n("common_text_3302").num = 4
		SoraDShowMsgTip(i18n("common_text_1795", i18n("common_text_3302")))
		return true
	else
		uiManager:show("allianceHuntExchangeView")
		return true
	end
	return true
end
function itemLogic.lordChangeHead(itemID, itemCount, otherData)
	uiManager:show("lordChangeHeadView")
	return true
end
function itemLogic.lordRename(itemID, itemCount, otherData)
	uiManager:show("lordRename")
	return true
end
function itemLogic.moveBuild(itemID, itemCount, otherData)
	if otherData and otherData.target then
		SoraDRemoveAllPrePanelFromManager(otherData.target, true)
	end
	_ENV = otherData.target
	otherData.target.msg = "MESSAGE_MAINCITYVIEW_ENTER_MOVE_MODE"
	SoraDGotoCityBuildMove(otherData.target)
	return true
end
function itemLogic.vipPoint(itemID, itemCount, otherData)
	local runUseFun = function(...)
		if otherData and otherData.needBuy then
			local shopCtrl = gametop.playertop_:getModule("shopCtrl")
			local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
			local shopItem = shopltCtrl:getShopItemByItemID(itemID)
			if shopItem then
				shopCtrl:reqBuyInItemShop(shopItem.shopItemID, itemCount, true)
			else
				SoraDShowMsgTip(i18n("notice_0170"))
			end
		else
			local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
			backpackCtrl:reqUseItem(itemID, itemCount)
		end
	end
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local tableBaseData = lordInfoCtrl:getVipDetails()
	return false
end
function itemLogic.svipPoint(itemID, itemCount, otherData)
	local runUseFun = function(...)
		if otherData and otherData.needBuy then
			local shopCtrl = gametop.playertop_:getModule("shopCtrl")
			local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
			local shopItem = shopltCtrl:getShopItemByItemID(itemID)
			if shopItem then
				shopCtrl:reqBuyInItemShop(shopItem.shopItemID, itemCount, true)
			else
				SoraDShowMsgTip(i18n("notice_0170"))
			end
		else
			local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
			backpackCtrl:reqUseItem(itemID, itemCount)
		end
	end
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local tableBaseData = lordInfoCtrl:getVipDetails()
	local addValue = backpackltCtrl:getResult(itemID)[1].count * itemCount
	if addValue > tableBaseData.vipPointUpper - tableBaseData.vipPoint then
		SoraDShowMsgBox(i18n("common_text_1500"), i18n("common_text_204"), nil, function(eventType)
			if eventType == MSGBOX_CALLBACK_YES then
				runUseFun()
			end
		end)
		return true
	else
		return false
	end
end
function itemLogic.randomMoveCastle(itemID, itemCount, otherData)
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local allianceDesRead = include("allianceDesRead")
	local buffValue, leftTime = SoraDGetCtrl("remainsWarCtrl"):getRemainsWarPlayerBuffValue(gBuffEffect.RUINS_WAR_MOVE_CITY_LOCKED)
	if 0 < buffValue then
		gametop = nil
		;(nil).time = SoraDConvertSecondToString(leftTime)
		SoraDShowMsgTip(i18n("remains_text_361", nil))
		return true
	end
	local buffValue, leftTime = SoraDGetCtrl("atlantisWarCtrl"):getPlayerBuffValue(gBuffEffect.RUINS_WAR_MOVE_CITY_LOCKED)
	if 0 < buffValue then
		gametop = i18n("remains_text_361", nil)
		i18n("remains_text_361", nil).time = SoraDConvertSecondToString(leftTime)
		SoraDShowMsgTip(i18n("remains_text_361", i18n("remains_text_361", nil)))
		return true
	end
	if 0 < kingdomMapCtrl:isHasQueue() then
		SoraDShowMsgTip(i18n("notice_0033"), itemDesRead.getIcon(itemID, true), nil)
		return true
	elseif kingdomMapCtrl.kingdomMapCell:hasWarQueueToMe() then
		SoraDShowMsgTip(i18n("notice_0034"), itemDesRead.getIcon(itemID, true), nil)
		return true
	elseif kingdomMapCtrl.kingdomMapCell:isOpenAllianceRomeActivity() then
		SoraDShowMsgTip(i18n("common_text_1511"), itemDesRead.getIcon(itemID, true), nil)
		return true
	elseif allianceDesRead.getPlayerConquestWarMigration() then
		return true
	elseif worldMapDefine.isInRemains() then
		local remainsWarCtrl = gametop.playertop_:getModule("remainsWarCtrl")
		if remainsWarCtrl:isInClose() then
			SoraDShowMsgTip(i18n("remains_text_153"), itemDesRead.getIcon(itemID, true), nil)
			return true
		elseif remainsWarCtrl:isMoveCityCDEndTime() then
			SoraDShowMsgTip(i18n("remains_text_160"), itemDesRead.getIcon(itemID, true), nil)
			return true
		end
	elseif worldMapDefine.isInNewTrial() then
		SoraDShowMsgTip(i18n("devilvalley_tips_08"))
		return true
	elseif worldMapDefine.isInRadiance() then
		SoraDShowMsgTip(i18n("remains_text_362"))
		return true
	elseif worldMapDefine.isInNebulaAllStar() then
		local nebulaAllStarUtil = include("nebulaAllStarUtil")
		if nebulaAllStarUtil.checkForbitRandomMove() then
			return true
		end
	else
		local worldMapWarDef = include("worldMapWarDef")
		if worldMapWarDef.isInWarForbidMoveCastle() then
			return true
		end
		local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
		backpackCtrl:reqUseItem(itemID, itemCount)
		if SoraDCurrentSceneShowView("mainCityView") then
			gametop = "mainCityView"
			;("mainCityView").msg = "MESSAGE_MAINSCEN_ONSHOW"
			;("mainCityView").viewType = VIEW_TYPE_MAP
			SoraDSendMessage("mainCityView")
		end
		SoraDRemoveAllPanelFromManager()
		return true
	end
end
function itemLogic.pointToWish(itemID, itemCount, otherData)
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	if cityCtrl:getBuildCell(BUILDID.WISHING_WELL, 0) then
		return false
	else
		msgNotice.notice("notice_0167")
		return true
	end
end
function itemLogic.sendShining(itemID, itemCount, otherData)
	if worldMapDefine.isInWar() or worldMapDefine.isInKingdomBattle() then
		SoraDShowMsgTip(i18n("common_text_3302"))
	else
		local layer = uiManager:show("LordSelectView").view
		layer:initData(lordSearchType.ALLIANCE, 1, i18n("common_text_3644"))
		layer:setSearchType(lordSearchType.PIGEON)
		layer:setTitleText(i18n("common_text_3644"))
		layer:showOwnKingdom(true)
		layer:setHandle(function(tableUID)
			local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
			gametop, gametop = nil, nil
			;(nil).id = itemID
			;(nil).itemData, (nil).count = nil, backpackCtrl:getItemCount(itemID)
			;(nil).handle = function(target, data)
				backpackCtrl:reqUseItem(data.id, data.num, tableUID)
			end
			uiManager:show("newItemSingleUse", nil)
		end)
	end
	return true
end
function itemLogic.headItem(itemID, itemCount, otherData)
	local gametop = gModuleMgr.getObject("gametop")
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
	local result = backpackltCtrl:getResult(itemID)
	local headID = result[1]
	local lordHeadCtrl = SoraDGetCtrl("lordHeadCtrl")
	local isUnlock = lordHeadCtrl:getHeadIsUnlock(tostring(headID))
	local leftTime = isUnlock and isUnlock - serviceFunctions.systemTime() or 0
	local proxy = uiManager:getProxy("lordChangeHeadView")
	if proxy then
		backpackCtrl:reqUseItem(itemID, 1)
	elseif 0 < leftTime or isUnlock == 1 then
		_ENV = 1
		;(1).headID = headID
		;(1).itemID = itemID
		uiManager:show("lordChangeHeadView", 1)
	else
		backpackCtrl:reqUseItem(itemID, 1)
	end
	return true
end
function itemLogic.sendFlower(itemID, itemCount, otherData)
	local proxy = uiManager:getProxy("flowerSendView")
	if proxy then
		_ENV = "flowerSendView"
		;("flowerSendView").msg = "MESSAGE_LORDINFO_FLOWER_SEND"
		;("flowerSendView").itemID = itemID
		;("flowerSendView").itemCount = itemCount
		SoraDSendMessage("flowerSendView")
		return true
	end
	local layer = uiManager:show("LordSelectView").view
	layer:initData(lordSearchType.ALLIANCE, 1, i18n("common_text_2309"))
	layer:setSearchType(lordSearchType.PIGEON)
	layer:setTitleText(i18n("common_text_2309"))
	layer:setHandle(function(tableUID)
		local uid = tableUID[1]
		local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
		gametop, gametop = nil, nil
		;(nil).id = itemID
		;(nil).itemData, (nil).count = nil, backpackCtrl:getItemCount(itemID)
		;(nil).handle = function(target, data)
			local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
			local lordInfo = lordInfoCtrl:getLordInfo()
			local ownSame = lordInfo.flowerSysInfo.same
			if not ownSame then
				SoraDShowMsgTip(i18n("common_text_2413"))
				return
			end
			local flowerSysCtrl = gametop.playertop_:getModule("flowerSysCtrl")
			flowerSysCtrl:sendGift(uid, data.id, data.num)
		end
		uiManager:show("newItemSingleUse", nil)
	end)
	return true
end
function itemLogic.sendRose(itemID, itemCount, otherData)
	local proxy = uiManager:getProxy("flowerSendView")
	if proxy then
		_ENV = "flowerSendView"
		;("flowerSendView").msg = "MESSAGE_LORDINFO_FLOWER_SEND"
		;("flowerSendView").itemID = itemID
		;("flowerSendView").itemCount = itemCount
		SoraDSendMessage("flowerSendView")
		return true
	end
	local layer = uiManager:show("LordSelectView").view
	layer:initData(lordSearchType.ALLIANCE, 1, i18n("common_text_2309"))
	layer:setSearchType(gSearchStyle.LORD_ALL_WORLD)
	layer:setTitleText(i18n("common_text_2309"))
	layer:setHandle(function(tableUID)
		local uid = tableUID[1]
		local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
		gametop, gametop = nil, nil
		;(nil).id = itemID
		;(nil).itemData, (nil).count = nil, backpackCtrl:getItemCount(itemID)
		;(nil).handle = function(target, data)
			local flowerSysCtrl = gametop.playertop_:getModule("flowerSysCtrl")
			flowerSysCtrl:sendGift(uid, data.id, data.num)
		end
		uiManager:show("newItemSingleUse", nil)
	end)
	return true
end
function itemLogic.sendKabasa(itemID, itemCount, otherData)
	local viewCtrl
	local titleStr = ""
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.PAINTED_EGG_CRAZY_ACTIVITY) then
		titleStr = i18n("easterEgg_title_02")
		viewCtrl = SoraDGetCtrl("paintedEggCrazyCtrl")
	else
		SoraDShowMsgTip(i18n("common_text_2486"))
		return true
	end
	if SoraDGetCastleLv() < CASTLE_LV10_LIMITED then
		_ENV = i18n("common_text_2486")
		i18n("common_text_2486").num = CASTLE_LV10_LIMITED
		SoraDShowMsgTip(i18n("common_text_1795", i18n("common_text_2486")))
		return true
	end
	local layer = uiManager:show("LordSelectView").view
	layer:setSearchNeedLv(CASTLE_LV10_LIMITED)
	layer:initData(lordSearchType.ALLIANCE, 1, i18n("common_text_533"))
	layer:setSearchType(gSearchStyle.LORD_ALL_WORLD)
	layer:setTitleText(titleStr)
	layer:setHandle(function(tableUID)
		local uid = tableUID[1]
		local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
		gametop, gametop = nil, nil
		;(nil).id = itemID
		;(nil).itemData, (nil).count = nil, backpackCtrl:getItemCount(itemID)
		;(nil).handle = function(target, data)
			if viewCtrl then
				viewCtrl = nil
				;(nil).receiveUid = uid
				;(nil).count = data.num
				viewCtrl:sendReqGive(nil)
			end
		end
		;(nil).btnTitle = i18n("common_text_533")
		uiManager:show("newItemSingleUse", nil)
	end)
	return true
end
function itemLogic.sendSnowManItems(itemID, itemCount, otherData)
	local gametop = gModuleMgr.getObject("gametop")
	local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
	if conquestWarCtrl:isPlayerConquestWarMigration() then
		SoraDShowMsgTip(i18n("conquestwar_text_46"))
	else
		local useItem = function(...)
			local layer = SoraDCreatePanel("halloweenSendView")
			_ENV = nil
			;(nil).cityLevelLimit = 1
			layer:initData(itemID, nil)
			layer:show()
		end
		local publicRead = include("publicRead")
		local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
		local curCount = backpackCtrl:getItemCount(itemID)
		if curCount <= 1 then
			_ENV = i18n("conquestwar_text_46")
			i18n("conquestwar_text_46").item = publicRead.getName(itemID)
			SoraDShowMsgBox(i18n("common_text_3645", i18n("conquestwar_text_46")), i18n("common_text_204"), i18n("common_text_185"), function(eventType, target)
				if eventType == MSGBOX_CALLBACK_YES then
					useItem()
				end
			end)
		else
			useItem()
		end
	end
	return true
end
function itemLogic.sendWordCard(itemID, itemCount, otherData)
	local gametop = gModuleMgr.getObject("gametop")
	local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
	if conquestWarCtrl:isPlayerConquestWarMigration() then
		SoraDShowMsgTip(i18n("conquestwar_text_46"))
	else
		local useItem = function(...)
			local layer = SoraDCreatePanel("halloweenSendView")
			_ENV = nil
			;(nil).cityLevelLimit = CASTLE_LV13_LIMITED
			layer:initData(itemID, nil)
			layer:show()
		end
		local publicRead = include("publicRead")
		local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
		local curCount = backpackCtrl:getItemCount(itemID)
		if curCount <= 1 then
			_ENV = i18n("conquestwar_text_46")
			i18n("conquestwar_text_46").item = publicRead.getName(itemID)
			SoraDShowMsgBox(i18n("common_text_3645", i18n("conquestwar_text_46")), i18n("common_text_204"), i18n("common_text_185"), function(eventType, target)
				if eventType == MSGBOX_CALLBACK_YES then
					useItem()
				end
			end)
		else
			useItem()
		end
	end
	return true
end
function itemLogic.optionalGift(itemID, itemCount, otherData)
	_ENV = nil
	;(nil).itemID = itemID
	uiManager:show("CommonSelectResourceBox", nil)
	return true
end
function itemLogic.optionalRestricted(itemID, itemCount, otherData)
	local list, _, _ = backpackltCtrl:getRandomGiftShowItems(itemID)
	if next(list) then
		backpackltCtrl = nil
		;(nil).itemID = itemID
		uiManager:show("CommonSelectResourceBox", nil)
	else
		SoraDShowMsgTip(i18n("common_text_4676"))
	end
	return true
end
function itemLogic.activityJump(itemID, itemCount, otherData)
	local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
	local result = backpackltCtrl:getResult(itemID)
	local activityID = result[1]
	if not clientEventMgr.judgeIsOpen(activityID) then
		SoraDShowMsgTip(i18n("common_text_2486"))
	else
		SoraDRemoveAllPanelFromManager()
		clientEventMgr.singleClickEvent(activityID)
	end
	return true
end
function itemLogic.itemSendView(itemID, itemCount, otherData)
	_ENV = nil
	;(nil).itemID = itemID
	uiManager:show("ItemSendView", nil)
	return true
end
function itemLogic.activity9001687Gift(itemID, itemCount, otherData)
	_ENV = nil
	;(nil).goodId = itemID
	uiManager:show("Activity_9001687_Share", nil)
	return true
end
function itemLogic.keyOpenBox(itemID, itemCount, otherData)
	local itemUse = SoraDCreatePanel("solomonKeyView")
	itemUse:initData(itemID)
	itemUse:show()
	return true
end
function itemLogic.useATreasure(itemID, itemCount, otherData)
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	if not allianceMgr:hasJoinAlliance() then
		SoraDShowMsgTip(i18n("notice_0066"))
		return true
	end
	return false
end
function itemLogic.openDress(itemID, itemCount, otherData)
	local gotoUseDress = function(useItemID)
		local panel = SoraDSearchPanelFromManagerByName("bagView")
		if panel then
			SoraDRemoveAllPrePanelFromManager(panel)
		end
		local xOffset = display.size.width * 0.5
		xOffset = xOffset + 60
		local showCastleChangeView = function()
			local dressID = backpackltCtrl:getResult(itemID)
			backpackltCtrl = nil
			;(nil).dressID = dressID
			uiManager:show("castleChangeView", nil)
		end
		local currentScene = display.getRunningScene()
		local currentView = currentScene:currentSceneShowView()
		local scale = 0.4
		if currentView.__cname == "worldMapView" then
			local dressCtrl = gametop.playertop_:getModule("dressCtrl")
			local dressID = backpackltCtrl:getResult(itemID)
			_ENV = nil
			;(nil).isFromWorld = true
			;(nil).dressID = dressID
			uiManager:show("castleChangeView", nil)
		else
			showCastleChangeView()
			_ENV = backpackltCtrl:getResult(itemID)
			backpackltCtrl:getResult(itemID).msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
			backpackltCtrl:getResult(itemID).offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD
			backpackltCtrl:getResult(itemID).scale = scale
			backpackltCtrl:getResult(itemID).xOffset = xOffset
			backpackltCtrl:getResult(itemID).yOffset = display.rheight - 375
			backpackltCtrl:getResult(itemID).buildIndex = 1050
			backpackltCtrl:getResult(itemID).noOffsetDuration = true
			backpackltCtrl:getResult(itemID).noScaleDuration = true
			SoraDSendMessage((backpackltCtrl:getResult(itemID)))
		end
	end
	SoraDDelayCallOnce("onBagUseDress", function()
		gotoUseDress(itemID)
	end)
	return true
end
function itemLogic.addTrainCount(itemID, itemCount, otherData)
	local armyCtrl = gametop.playertop_:getModule("armyCtrl")
	local toolAddInfo = armyCtrl:getSingleAddInfo()
	if toolAddInfo and next(toolAddInfo) and toolAddInfo.itemCount > 0 and toolAddInfo.itemID ~= itemID then
		SoraDShowMsgTip(i18n("common_text_3544"))
		return true
	else
		return false
	end
end
function itemLogic.exchange(itemID, itemCount, otherData)
	if itemID == FRIEND_GOLD then
		local panel = SoraDCreatePanel("callbackStore")
		panel:initView()
		panel:show()
	else
		local panel = SoraDCreatePanel("exchangeAwardView")
		panel:initData(itemID)
		panel:show()
	end
	return true
end
function itemLogic.buffItemUse(itemID, itemCount, otherData)
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	local buffID = backpackltCtrl:getResult(itemID)
	local buffEffect = buffltCtrl:getEffectType(buffID)
	local haveBuff = buffCtrl:queryCityBuff(buffEffect)
	local effect, effectType = buffltCtrl:getEffect(buffID)
	local buffUse = function(itemID)
		SoraDShowMsgBox(i18n("common_text_562"), i18n("common_text_204"), nil, function(type)
			if type == MSGBOX_CALLBACK_YES then
				if otherData and otherData.needBuy then
					local shopCtrl = gametop.playertop_:getModule("shopCtrl")
					local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
					local shopItem = shopltCtrl:getShopItemByItemID(itemID)
					if shopItem then
						shopCtrl:reqBuyInItemShop(shopItem.shopItemID, itemCount, true)
					else
						SoraDShowMsgTip(i18n("notice_0170"))
					end
				else
					local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
					backpackCtrl:reqUseItem(itemID, itemCount)
				end
			end
		end)
	end
	if haveBuff then
		if not backpackltCtrl:checkBuffStackingItem(itemID) then
			buffUse(itemID)
			return true
		elseif haveBuff:getProperty("id") ~= buffID and (haveBuff:getProperty("effectType") ~= buffEffect or haveBuff:getProperty("effect") ~= effect) then
			buffUse(itemID)
			return true
		else
			return false
		end
	else
		return false
	end
end
function itemLogic.salvation(itemID, itemCount, otherData)
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local isOpen, buff = buffCtrl:isBuffOpen(4501)
	if isOpen then
		SoraDShowMsgTip(i18n("common_text_3168"))
		return true
	else
		return itemLogic.buffItemUse(itemID, itemCount, otherData)
	end
end
function itemLogic.peaceShield(itemID, itemCount, otherData)
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local worldMapWarDef = include("worldMapWarDef")
	if worldMapWarDef.isInWarForbidUsePeaceShield() then
		return true
	elseif kingdomMapCtrl:hasMyWarQueue() or kingdomMapCtrl:hasMyOccupyQueue(true) then
		SoraDShowMsgTip(i18n("common_text_799"))
		return true
	else
		return itemLogic.buffItemUse(itemID, itemCount, otherData)
	end
end
function itemLogic.mutualExclusionBuff(itemID, itemCount, otherData)
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	local cityEffectInfoRead = include("cityEffectInfoRead")
	local buffID = backpackltCtrl:getResult(itemID)
	local buffEffect = buffltCtrl:getEffectType(buffID)
	local mutualExclusionBuffID = itemLogic.mutualExclusionBuffMap[buffEffect]
	local haveBuff = buffCtrl:queryCityBuff(mutualExclusionBuffID)
	if haveBuff then
		local buffName = cityEffectInfoRead.getName(mutualExclusionBuffID)
		gametop = nil
		;(nil).frontBuff = buffName
		;(nil).afterBuff = buffName
		SoraDShowMsgBox(i18n("common_text_561", nil), i18n("common_text_204"), nil, function(type)
			if type == MSGBOX_CALLBACK_YES then
				if otherData and otherData.needBuy then
					local shopCtrl = gametop.playertop_:getModule("shopCtrl")
					local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
					local shopItem = shopltCtrl:getShopItemByItemID(itemID)
					if shopItem then
						shopCtrl:reqBuyInItemShop(shopItem.shopItemID, itemCount, true)
					else
						SoraDShowMsgTip(i18n("notice_0170"))
					end
				else
					local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
					backpackCtrl:reqUseItem(itemID, itemCount)
				end
			end
		end)
		return true
	else
		return itemLogic.buffItemUse(itemID, itemCount, otherData)
	end
end
function itemLogic.halloweenBuff(itemID, itemCount, otherData)
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	local buffID = backpackltCtrl:getResult(itemID)
	local buffEffect = buffltCtrl:getEffectType(buffID)
	local haveBuff = buffCtrl:queryHalloweenBuff(buffEffect)
	if haveBuff then
		SoraDShowMsgBox(i18n("common_text_562"), i18n("common_text_204"), nil, function(type)
			if type == MSGBOX_CALLBACK_YES then
				if otherData and otherData.needBuy then
					local shopCtrl = gametop.playertop_:getModule("shopCtrl")
					local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
					local shopItem = shopltCtrl:getShopItemByItemID(itemID)
					if shopItem then
						shopCtrl:reqBuyInItemShop(shopItem.shopItemID, itemCount, true)
					else
						SoraDShowMsgTip(i18n("notice_0170"))
					end
				else
					local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
					backpackCtrl:reqUseItem(itemID, itemCount)
				end
			end
		end)
		return true
	else
		return false
	end
end
function itemLogic.heroGift(itemID, itemCount, otherData)
	SoraDShowMsgTip(i18n("presell_notice_01"))
	return true
end
function itemLogic.pigeon(itemID, itemCount, otherData)
	_ENV = nil
	;(nil).itemID = itemID
	uiManager:show("mailGivePresent", nil)
	return true
end
function itemLogic.useTreasureMap(itemID, itemCount, otherData)
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	local sourceKid = lordInfoCtrl:getLordInfo().base.sourceKid
	if 0 < sourceKid or worldMapDefine.isInWar() or worldMapDefine.isInKingdomBattle() then
		SoraDShowMsgTip(i18n("common_text_3302"))
	else
		local layer = SoraDCreatePanel("treasureMapView")
		layer:setItemCount(itemID)
		layer:show()
	end
	return true
end
function itemLogic.useTreasureCryStal(itemID, itemCount, otherData)
	if worldMapDefine.isInWar() or worldMapDefine.isInKingdomBattle() then
		SoraDShowMsgTip(i18n("common_text_3302"))
	else
		local layer = SoraDCreatePanel("treasureCrystalView")
		layer:setItemData(itemID, otherData)
		layer:show()
	end
	return true
end
function itemLogic.useTreasurePandoraBox(itemID, itemCount, otherData)
	dump(otherData, "otherData", 10)
	local layer = SoraDCreatePanel("pandoraBoxChooseView")
	layer:setItemData(itemID, otherData)
	layer:show()
	return true
end
function itemLogic.useTreasureMapFragment(itemID, itemCount, otherData)
	dump(otherData, "otherData", 10)
	local layer = SoraDCreatePanel("treasureMapPreView")
	layer:initData(2, itemID, otherData)
	layer:show()
	return true
end
function itemLogic.useRedTreasureMap(itemID, itemCount, otherData)
	dump(otherData, "otherData", 10)
	if worldMapDefine.isInWar() or worldMapDefine.isInKingdomBattle() then
		SoraDShowMsgTip(i18n("common_text_3302"))
	else
		local layer = SoraDCreatePanel("treasureMapTask")
		layer:initData(itemID, otherData)
		layer:show()
	end
	return true
end
function itemLogic.useFireWork(itemID, itemCount, otherData)
	local propCtrl = gametop.playertop_:getModule("propCtrl")
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local effectID = propCtrl:getCurrentEffectID()
	gametop = propCtrl
	propCtrl.overlay = 1
	local _UPVALUE2_, gametop, propCtrl.cover, fireTypeDef = nil, nil, 2, propCtrl
	_UPVALUE2_, (nil)[804001], (nil)[1] = nil, nil, 9004502
	_UPVALUE2_, (nil)[804001], (nil)[2] = nil, nil, 300
	_UPVALUE2_, (nil)[804101], (nil)[1] = nil, nil, 9004503
	_UPVALUE2_, (nil)[804101], (nil)[2] = nil, nil, 300
	_UPVALUE2_, (nil)[708001], (nil)[1] = nil, nil, 9004505
	_UPVALUE2_, (nil)[708001], (nil)[2] = nil, nil, 120
	;(nil)[826701], (nil)[1] = nil, 9004506
	;(nil)[826701], (nil)[2] = nil, 300
	local itemID2EffectID
	local fireType
	if effectID and itemID2EffectID[itemID] then
		if effectID == itemID2EffectID[itemID][1] then
			fireType = fireTypeDef.overlay
		else
			fireType = fireTypeDef.cover
		end
	end
	if not fireType then
		backpackCtrl:reqUseItem(itemID, itemCount)
		local panel = SoraDSearchPanelFromManagerByName("bagView")
		if panel then
			SoraDRemoveAllPrePanelFromManager(panel)
		end
		SoraDGotoWorldMapPoint()
	elseif fireType == fireTypeDef.overlay then
		gametop = itemCount
		itemCount.sec = itemID2EffectID[itemID][2] * itemCount
		SoraDShowMsgBox(i18n("common_text_2887", itemCount), i18n("common_text_204"), i18n("common_text_185"), function(type, target)
			if MSGBOX_CALLBACK_YES == type then
				backpackCtrl:reqUseItem(itemID, itemCount)
				local panel = SoraDSearchPanelFromManagerByName("bagView")
				if panel then
					SoraDRemoveAllPrePanelFromManager(panel)
				end
				SoraDGotoWorldMapPoint()
			end
		end)
	elseif fireType == fireTypeDef.cover then
		SoraDShowMsgBox(i18n("common_text_2888"), i18n("common_text_204"), i18n("common_text_185"), function(type, target)
			if MSGBOX_CALLBACK_YES == type then
				backpackCtrl:reqUseItem(itemID, itemCount)
				local panel = SoraDSearchPanelFromManagerByName("bagView")
				if panel then
					SoraDRemoveAllPrePanelFromManager(panel)
				end
				SoraDGotoWorldMapPoint()
			end
		end)
	end
	return true
end
function itemLogic.useGoldGift(itemID, itemCount, otherData)
	_ENV = nil
	;(nil).itemID = itemID
	uiManager:show("SendRedPacketView", nil)
	return true
end
function itemLogic.useDropBox(itemID, itemCount, otherData)
	if worldMapDefine.inInCrossWar() then
		SoraDShowMsgTip(i18n("common_text_4479"))
	else
		local layer = SoraDCreatePanel("dropBoxSendGiftView")
		layer:show()
	end
	return true
end
function itemLogic.useRechargeGoldGift(itemID, itemCount, otherData)
	local layer = SoraDCreatePanel("sendRedPacketRechargeView")
	layer:show()
	return true
end
function itemLogic.repairWall(itemID, itemCount, otherData)
	local wallsCtrl = gametop.playertop_:getModule("wallsCtrl")
	if wallsCtrl:isDamage() then
		return false
	else
		SoraDShowMsgTip(i18n("notice_0181"), itemDesRead.getIcon(itemID, true))
		return true
	end
end
function itemLogic.resAdd(itemID, itemCount, otherData)
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local itemData = backpackltCtrl:getResult(itemID)
	for i, v in ipairs(itemData) do
		local leftDayMaxRes = cityCtrl:getLeftDayMaxRes(v.id)
		local leftTotalMaxRes = cityCtrl:getLeftTotalMaxRes(v.id)
		local addcount = v.count * itemCount
		local notice = ""
		local ret = false
		if leftTotalMaxRes < addcount then
			local max = cityCtrl:getResMaxTotal()
			if v.id == gIDDef.GOLD then
				max = gConstValue.MAX_GOLD_COUNT
			end
			gametop = nil
			;(nil).res = resDesRead.getName(v.id)
			;(nil).count = SoraDConvertNumberWithUnit(max)
			notice = i18n("common_text_1888", nil)
			ret = true
		end
		if ret then
			SoraDShowMsgBox(notice, IsArClient and i18n("common_text_204") or i18n("common_text_4118_ros"), not IsArClient and i18n("common_text_4119_ros") or nil, function(callType)
				if callType == MSGBOX_CALLBACK_YES then
					if otherData and otherData.needBuy then
						local shopCtrl = gametop.playertop_:getModule("shopCtrl")
						local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
						local shopItemList = shopltCtrl:getShopItemByItemID(itemID)
						if shopItemList then
							shopCtrl:reqBuyInItemShop(shopItemList.shopItemID, itemCount, true)
						else
							SoraDShowMsgTip(i18n("notice_0170"))
						end
					else
						local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
						backpackCtrl:reqUseItem(itemID, itemCount)
					end
				end
			end)
			return true
		end
	end
	return false
end
function itemLogic.itemCompoundView(itemID, itemCount, otherData)
	_ENV = nil
	;(nil).itemID = itemID
	uiManager:show("itemCompoundView", nil)
	return true
end
function itemLogic.itemActivationView(itemID, itemCount, otherData)
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	local sourceKid = lordInfoCtrl:getLordInfo().base.sourceKid
	if (itemID == 827401 or itemID == 827501) and (0 < sourceKid or worldMapDefine.isInRemains() or worldMapDefine.isInNewTrial() or worldMapDefine.isInPyramid()) then
		SoraDShowMsgTip(i18n("common_text_3302"))
		return
	end
	_ENV = i18n("common_text_3302")
	i18n("common_text_3302").itemID = itemID
	uiManager:show("itemActivationView", i18n("common_text_3302"))
	return true
end
function itemLogic.itemHalloweenView(itemID, itemCount, otherData)
	local layer = SoraDCreatePanel("halloweenSendView")
	layer:initData(itemID)
	layer:show()
	return true
end
function itemLogic.itemValentineView(itemID, itemCount, otherData)
	local layer = SoraDCreatePanel("halloweenSendView")
	layer:initData(itemID)
	layer:show()
	return true
end
function itemLogic.useWarTreasure(itemID, itemCount, otherData)
	local panel = SoraDCreatePanel("warTreasureCheerView")
	panel:initData(itemID)
	panel:show()
	return true
end
function itemLogic.resOutputBoost(itemID, itemCount, otherData, itemType)
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	local buildDescribeRead = include("buildDescribeRead")
	local buildLogic = include("buildLogic")
	local bid = itemLogic.buffToBuildID[itemType]
	local bName = buildDescribeRead.getName(bid)
	local buffID = backpackltCtrl:getResult(itemID)
	local buffEffect = buffltCtrl:getEffectType(buffID)
	local bCellList = cityCtrl:getBuildCellList(bid)
	if #bCellList <= 0 then
		gametop = nil
		;(nil).resName = bName
		SoraDShowMsgTip(i18n("common_text_816", nil))
	else
		local maxCell, maxIndex
		local maxLv = 1
		for i, v in ipairs(bCellList) do
			if maxLv <= tonumber(v.info.lv) and tonumber(v.info.state) == BUILD_STATE.NORMAL and buffCtrl:getResourceBoostBuff(buffEffect, bid, tonumber(v.info.iid)) == nil then
				maxIndex = i
				maxLv = tonumber(v.info.lv)
			end
		end
		if maxIndex then
			maxCell = bCellList[maxIndex]
			local warLv = buildLogic.transformBuildLvToWarLv(maxCell.info.lv)
			local buildName = ""
			if warLv >= CASTLE_MIN_WARLV then
				gametop = i18n("common_text_816", nil)
				i18n("common_text_816", nil).build = bName
				i18n("common_text_816", nil).lv = warLv
				buildName = i18n("common_text_1957", i18n("common_text_816", nil))
			else
				gametop = i18n("common_text_816", nil)
				i18n("common_text_816", nil).name = bName
				i18n("common_text_816", nil).lv = math.min(CASTLE_MAXLV_NOWAR, maxCell.info.lv)
				buildName = i18n("common_text_334", i18n("common_text_816", nil))
			end
			gametop = math.min(CASTLE_MAXLV_NOWAR, maxCell.info.lv)
			math.min(CASTLE_MAXLV_NOWAR, maxCell.info.lv).build = buildName
			SoraDShowMsgBox(i18n("common_text_817", (math.min(CASTLE_MAXLV_NOWAR, maxCell.info.lv))), i18n("common_text_204"), nil, function(type)
				if type == MSGBOX_CALLBACK_YES then
					cityCtrl:speedUpResReq(bid, tonumber(maxCell.info.iid), BUILD_EXCHANGE_MODE.TOOLS, itemID)
				end
			end)
		else
			gametop = i18n("common_text_817", (math.min(CASTLE_MAXLV_NOWAR, maxCell.info.lv)))
			i18n("common_text_817", (math.min(CASTLE_MAXLV_NOWAR, maxCell.info.lv))).resName = bName
			SoraDShowMsgTip(i18n("common_text_816", (i18n("common_text_817", (math.min(CASTLE_MAXLV_NOWAR, maxCell.info.lv))))))
		end
	end
	return true
end
_ENV, itemLogic.godlanterm = function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end, function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.CHANGE_ICON] = itemLogic.lordChangeHead
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.CHANGE_NAME] = itemLogic.lordRename
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.MOVE_BUILDING] = itemLogic.moveBuild
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.RANDOM_MOVE_CITY] = itemLogic.randomMoveCastle
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.GUIDE] = itemLogic.pointToWish
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.PIGEON] = itemLogic.pigeon
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.TREASUREMAP] = itemLogic.useTreasureMap
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.GOLD_GIFT] = itemLogic.useGoldGift
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.DROP_BOX] = itemLogic.useDropBox
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.RECHARGE_GOLD_GIFT] = itemLogic.useRechargeGoldGift
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.GOLD] = itemLogic.resAdd
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.WOOD] = itemLogic.resAdd
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.FOOD] = itemLogic.resAdd
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.IRON] = itemLogic.resAdd
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.MITHRIL] = itemLogic.resAdd
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.SAFE_WOOD] = itemLogic.resAdd
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.SAFE_FOOD] = itemLogic.resAdd
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.SAFE_IRON] = itemLogic.resAdd
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.SAFE_SECRET] = itemLogic.resAdd
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.SAFE_CRYSTAL] = itemLogic.resAdd
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.CRYSTAL] = itemLogic.resAdd
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.SAFE_WOOD] = itemLogic.resAdd
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.SAFE_FOOD] = itemLogic.resAdd
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.SAFE_IRON] = itemLogic.resAdd
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.SAFE_SECRET] = itemLogic.resAdd
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.SAFE_CRYSTAL] = itemLogic.resAdd
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.FLOWER] = itemLogic.sendFlower
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.SHINING_CASTLE] = itemLogic.sendShining
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.ROSE] = itemLogic.sendRose
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.FIREWORK] = itemLogic.useFireWork
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.FIREWORK_2020] = itemLogic.useFireWork
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.PET_EXP] = itemLogic.petExp
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.LORD_EXP] = itemLogic.lordExp
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.MADELE_KABASHA] = itemLogic.sendKabasa
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.SINGLE_TRAIN_ADD_COUNT] = itemLogic.addTrainCount
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.ALLIANCE_HUNT_POINT] = itemLogic.useHuntPoint
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.WAR_TREASURE_DRUM] = itemLogic.useWarTreasure
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.WAR_TREASURE_VULN] = itemLogic.useWarTreasure
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.ANTI_SCOUT] = itemLogic.buffItemUse
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.GATHER_SPEED_BOOST] = itemLogic.buffItemUse
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.MARCH_LIMIT_BOOST] = itemLogic.buffItemUse
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.TROOP_ATTACK_BOOST] = itemLogic.buffItemUse
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.TROOP_DEFENSE_BOOST] = itemLogic.buffItemUse
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.FOOD_CONSUME_REDUCE] = itemLogic.buffItemUse
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.HP_BONUS] = itemLogic.buffItemUse
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.MASSACRE] = itemLogic.buffItemUse
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.SALVATION] = itemLogic.salvation
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.PEACE_SHIELD] = itemLogic.peaceShield
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.CAMOUFLAGE] = itemLogic.mutualExclusionBuff
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.LURE_ENEMY] = itemLogic.mutualExclusionBuff
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.VIP_POINT] = itemLogic.vipPoint
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.S_VIP_POINT] = itemLogic.svipPoint
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.WOOD_OUTPUT_BOOST] = itemLogic.resOutputBoost
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.FOOD_OUTPUT_BOOST] = itemLogic.resOutputBoost
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.IRON_OUTPUT_BOOST] = itemLogic.resOutputBoost
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.MITHRIL_OUTPUT_BOOST] = itemLogic.resOutputBoost
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.CRYSTAL_OUTPUT_BOOST] = itemLogic.resOutputBoost
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.GOD_LANTERM] = itemLogic.godlanterm
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.GAOYANG] = itemLogic.godlanterm
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.SEA_MONSTER] = itemLogic.godlanterm
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.CHRISTMAS_TREE] = itemLogic.godlanterm
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.ICE_HUNTING_ITEM] = itemLogic.godlanterm
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.HALLOWEEN] = itemLogic.halloweenBuff
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.ACTIVITY_ITEM] = itemLogic.buffItemUse
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.TREASURE_CRYSTAL] = itemLogic.useTreasureCryStal
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.PANDORABOX] = itemLogic.useTreasurePandoraBox
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.TREASURE_MAP_FRAGMENT] = itemLogic.useTreasureMapFragment
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.TREASURE_MAP] = itemLogic.useRedTreasureMap
_ENV, itemLogic.itemFunMap, (function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemType.HEAD_ITEM] = function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end, function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end, itemLogic.headItem
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemEffectDef.MERGE_FRAGMENG] = itemLogic.itemCompoundView
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemEffectDef.CHEST] = itemLogic.itemActivationView
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemEffectDef.ANIMATION] = itemLogic.itemHalloweenView
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemEffectDef.LOVE_HEART] = itemLogic.itemValentineView
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemEffectDef.SEND_WORDS_CARD] = itemLogic.sendWordCard
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemEffectDef.EXCHANGE] = itemLogic.exchange
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemEffectDef.OPTIONAL] = itemLogic.optionalGift
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemEffectDef.OPTIONAL_EXTRA] = itemLogic.optionalGift
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemEffectDef.OPTIONAL_HERO] = itemLogic.optionalGift
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemEffectDef.KEY_OPEN] = itemLogic.keyOpenBox
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemEffectDef.SOLOMON_KEY] = itemLogic.keyOpenBox
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemEffectDef.DRESS] = itemLogic.openDress
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemEffectDef.ANCIENT_TREASURE] = itemLogic.useATreasure
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemEffectDef.SEND_SNOW_MAN_ITEMS] = itemLogic.sendSnowManItems
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemEffectDef.RESTRICTED_OPTIONAL] = itemLogic.optionalRestricted
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemEffectDef.ACTIVITY_JUMP] = itemLogic.activityJump
;(function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemEffectDef.GIVE_ITEM_NEW] = itemLogic.itemSendView
itemLogic.itemEffectFunMap, (function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end)[gItemEffectDef.ACTIVITY_9001687_GIFT] = function(itemID, itemCount, otherData, itemType)
	local panel = SoraDSearchPanelFromManagerByName("bagView")
	if panel then
		panel:removeFromParent()
	end
	local _ENV, layInstanceData = panel.removeFromParent, panel.removeFromParent
	layInstanceData.itemID = itemID
	if gItemType.GAOYANG == itemType then
		layInstanceData.bossid = gBossType.manuPlaceSheep
	elseif gItemType.CHRISTMAS_TREE == itemType then
		layInstanceData.bossid = gBossType.christmasTree1
	elseif gItemType.SEA_MONSTER == itemType then
		local result = backpackltCtrl:getResult(itemID)
		layInstanceData.bossid = result[1]
	elseif gItemType.ICE_HUNTING_ITEM == itemType then
		layInstanceData.bossid = gBossType.huntFairBoss
	else
		layInstanceData.bossid = gBossType.manuPlaceBoss
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local pos = cityCtrl:getCurCityPos()
	local selfKindomID = gametop.playertop_:getMapID()
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		if selfKindomID == worldMapDefine.currentMapKindomID and currentView.__cname == "worldMapView" then
			pos = currentView:getDisplayCenterTilePoint()
		else
			math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
			local offsetX = math.random(2, 3)
			local offsetY = math.random(2, 3)
			local needFlipX = math.random(1, 2) == 1 and 1 or -1
			local needFlipY = math.random(1, 2) == 1 and 1 or -1
			pos.x = pos.x + offsetX * needFlipX
			pos.y = pos.y + offsetY * needFlipY
			print("pos", offsetX, offsetY, needFlipX, needFlipY, pos.x, pos.y)
			if pos.x < 0 then
				pos.x = 0
			elseif pos.x >= gMapMaxCoordinate then
				pos.x = gMapMaxCoordinate - 3
			end
			if pos.y < 0 then
				pos.y = 0
			elseif pos.y >= gMapMaxCoordinate then
				pos.y = gMapMaxCoordinate - 3
			end
		end
	end
	SoraDGotoWorldMapPoint(pos, false, selfKindomID, worldMapLayInstanceTypeDef.layInstanceBoss, layInstanceData)
	return true
end, itemLogic.activity9001687Gift
function itemLogic.checkItemSpecial(itemID, itemCount, otherData)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	print("itemID,itemType,itemEffect===", itemID, itemType, itemEffect)
	if itemLogic.itemFunMap[itemType] then
		print("根据物品类型使用")
		return itemLogic.itemFunMap[itemType](itemID, itemCount, otherData, itemType)
	end
	if itemLogic.itemEffectFunMap[itemEffect] then
		print("根据物品效果类型使用")
		return itemLogic.itemEffectFunMap[itemEffect](itemID, itemCount, otherData)
	end
	return false
end
function itemLogic.checkResUseLowCastle(itemID, count)
	local isPass = true
	local changeToMyMap = function(list)
		local _ENV, data
		for k, v in ipairs(list) do
			data[v.id] = v.count
		end
		return data
	end
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local curLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
	if IsArClient then
		local itemType = backpackltCtrl:getItemType(itemID)
		if curLevel < CASTLE_LV3_LIMITED and (itemType == gItemType.WOOD or itemType == gItemType.FOOD) then
			local result = backpackltCtrl:getResult(itemID)
			local myResult = changeToMyMap(result)
			local foodNum = cityCtrl:getResCount(gIDDef.FOOD)
			local woodNum = cityCtrl:getResCount(gIDDef.WOOD)
			if myResult[gIDDef.FOOD] and foodNum + myResult[gIDDef.FOOD] * count > RES_MAX_IN_LOWCASTLE or myResult[gIDDef.WOOD] and woodNum + myResult[gIDDef.WOOD] * count > RES_MAX_IN_LOWCASTLE then
				isPass = false
			end
		end
	else
		local resultType = backpackltCtrl:getResultType(itemID)
		if curLevel < CASTLE_LV3_LIMITED and (resultType == gItemType.WOOD or resultType == gItemType.FOOD or resultType == gItemType.SAFE_WOOD or resultType == gItemType.SAFE_FOOD) then
			local result = backpackltCtrl:getResult(itemID)
			local myResult = changeToMyMap(result)
			local foodNum = cityCtrl:getResCount(gIDDef.FOOD)
			local woodNum = cityCtrl:getResCount(gIDDef.WOOD)
			if myResult[gIDDef.FOOD] and foodNum + myResult[gIDDef.FOOD] * count > RES_MAX_IN_LOWCASTLE or myResult[gIDDef.WOOD] and woodNum + myResult[gIDDef.WOOD] * count > RES_MAX_IN_LOWCASTLE then
				isPass = false
			end
			if myResult[gIDDef.FOOD_SAFE] and foodNum + myResult[gIDDef.FOOD_SAFE] * count > RES_MAX_IN_LOWCASTLE or myResult[gIDDef.WOOD_SAFE] and woodNum + myResult[gIDDef.WOOD_SAFE] * count > RES_MAX_IN_LOWCASTLE then
				isPass = false
			end
		end
	end
	return isPass
end
function itemLogic.getHTMedalCount(itemID, itemCount, otherData)
	local htPointMgr = include("htPointMgr")
	local heroTrialltCtrl = include("heroTrialltCtrl")
	return math.min(itemCount, backpackltCtrl:getUseMax(itemID), heroTrialltCtrl.getLimitPoint() - htPointMgr.getPoint())
end
function itemLogic.getLordExpCount(itemID, itemCount, otherData)
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local needExp = lordInfoCtrl:getExpPointToMaxLV()
	local result = backpackltCtrl:getResult(itemID)
	local singleNum = result[1].count
	return math.min(itemCount, backpackltCtrl:getUseMax(itemID), math.ceil(needExp / singleNum))
end
function itemLogic.getVIPPointCount(itemID, itemCount, otherData)
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local needPoint = lordInfoCtrl:getVIPPointToMaxLV()
	local result = backpackltCtrl:getResult(itemID)
	local singleNum = result[1].count
	local toNum = math.ceil(needPoint / singleNum)
	if needPoint <= 0 then
		toNum = backpackltCtrl:getUseMax(itemID)
	end
	return math.min(itemCount, backpackltCtrl:getUseMax(itemID), toNum)
end
_ENV, itemLogic.getSVIPPointCount = function(itemID, itemCount, otherData)
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local needPoint = lordInfoCtrl:getVIPPointToMaxLV(true)
	local result = backpackltCtrl:getResult(itemID)
	local singleNum = result[1].count
	local toNum = math.ceil(needPoint / singleNum)
	if needPoint <= 0 then
		toNum = backpackltCtrl:getUseMax(itemID)
	end
	return math.min(itemCount, backpackltCtrl:getUseMax(itemID), toNum)
end, function(itemID, itemCount, otherData)
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local needPoint = lordInfoCtrl:getVIPPointToMaxLV(true)
	local result = backpackltCtrl:getResult(itemID)
	local singleNum = result[1].count
	local toNum = math.ceil(needPoint / singleNum)
	if needPoint <= 0 then
		toNum = backpackltCtrl:getUseMax(itemID)
	end
	return math.min(itemCount, backpackltCtrl:getUseMax(itemID), toNum)
end
;(function(itemID, itemCount, otherData)
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local needPoint = lordInfoCtrl:getVIPPointToMaxLV(true)
	local result = backpackltCtrl:getResult(itemID)
	local singleNum = result[1].count
	local toNum = math.ceil(needPoint / singleNum)
	if needPoint <= 0 then
		toNum = backpackltCtrl:getUseMax(itemID)
	end
	return math.min(itemCount, backpackltCtrl:getUseMax(itemID), toNum)
end)[gItemType.HT_MEDAL] = itemLogic.getHTMedalCount
;(function(itemID, itemCount, otherData)
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local needPoint = lordInfoCtrl:getVIPPointToMaxLV(true)
	local result = backpackltCtrl:getResult(itemID)
	local singleNum = result[1].count
	local toNum = math.ceil(needPoint / singleNum)
	if needPoint <= 0 then
		toNum = backpackltCtrl:getUseMax(itemID)
	end
	return math.min(itemCount, backpackltCtrl:getUseMax(itemID), toNum)
end)[gItemType.LORD_EXP] = itemLogic.getLordExpCount
;(function(itemID, itemCount, otherData)
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local needPoint = lordInfoCtrl:getVIPPointToMaxLV(true)
	local result = backpackltCtrl:getResult(itemID)
	local singleNum = result[1].count
	local toNum = math.ceil(needPoint / singleNum)
	if needPoint <= 0 then
		toNum = backpackltCtrl:getUseMax(itemID)
	end
	return math.min(itemCount, backpackltCtrl:getUseMax(itemID), toNum)
end)[gItemType.VIP_POINT] = itemLogic.getVIPPointCount
itemLogic.itemUseCount, (function(itemID, itemCount, otherData)
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local needPoint = lordInfoCtrl:getVIPPointToMaxLV(true)
	local result = backpackltCtrl:getResult(itemID)
	local singleNum = result[1].count
	local toNum = math.ceil(needPoint / singleNum)
	if needPoint <= 0 then
		toNum = backpackltCtrl:getUseMax(itemID)
	end
	return math.min(itemCount, backpackltCtrl:getUseMax(itemID), toNum)
end)[gItemType.S_VIP_POINT] = function(itemID, itemCount, otherData)
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local needPoint = lordInfoCtrl:getVIPPointToMaxLV(true)
	local result = backpackltCtrl:getResult(itemID)
	local singleNum = result[1].count
	local toNum = math.ceil(needPoint / singleNum)
	if needPoint <= 0 then
		toNum = backpackltCtrl:getUseMax(itemID)
	end
	return math.min(itemCount, backpackltCtrl:getUseMax(itemID), toNum)
end, itemLogic.getSVIPPointCount
_ENV, itemLogic.getItemUseCount = function(itemID, itemCount, otherData)
	local itemType = backpackltCtrl:getItemType(itemID)
	if itemLogic.itemUseCount[itemType] then
		return itemLogic.itemUseCount[itemType](itemID, itemCount, otherData)
	end
	return math.min(itemCount, backpackltCtrl:getUseMax(itemID))
end, function(itemID, itemCount, otherData)
	local itemType = backpackltCtrl:getItemType(itemID)
	if itemLogic.itemUseCount[itemType] then
		return itemLogic.itemUseCount[itemType](itemID, itemCount, otherData)
	end
	return math.min(itemCount, backpackltCtrl:getUseMax(itemID))
end
;(function(itemID, itemCount, otherData)
	local itemType = backpackltCtrl:getItemType(itemID)
	if itemLogic.itemUseCount[itemType] then
		return itemLogic.itemUseCount[itemType](itemID, itemCount, otherData)
	end
	return math.min(itemCount, backpackltCtrl:getUseMax(itemID))
end)[gItemType.PIGEON] = true
_ENV, itemLogic.itemTypeBeforeFunMap, (function(itemID, itemCount, otherData)
	local itemType = backpackltCtrl:getItemType(itemID)
	if itemLogic.itemUseCount[itemType] then
		return itemLogic.itemUseCount[itemType](itemID, itemCount, otherData)
	end
	return math.min(itemCount, backpackltCtrl:getUseMax(itemID))
end)[gItemType.PET_EXP] = function(itemID, itemCount, otherData)
	local itemType = backpackltCtrl:getItemType(itemID)
	if itemLogic.itemUseCount[itemType] then
		return itemLogic.itemUseCount[itemType](itemID, itemCount, otherData)
	end
	return math.min(itemCount, backpackltCtrl:getUseMax(itemID))
end, function(itemID, itemCount, otherData)
	local itemType = backpackltCtrl:getItemType(itemID)
	if itemLogic.itemUseCount[itemType] then
		return itemLogic.itemUseCount[itemType](itemID, itemCount, otherData)
	end
	return math.min(itemCount, backpackltCtrl:getUseMax(itemID))
end, true
;(function(itemID, itemCount, otherData)
	local itemType = backpackltCtrl:getItemType(itemID)
	if itemLogic.itemUseCount[itemType] then
		return itemLogic.itemUseCount[itemType](itemID, itemCount, otherData)
	end
	return math.min(itemCount, backpackltCtrl:getUseMax(itemID))
end)[gItemEffectDef.MERGE_FRAGMENG] = true
;(function(itemID, itemCount, otherData)
	local itemType = backpackltCtrl:getItemType(itemID)
	if itemLogic.itemUseCount[itemType] then
		return itemLogic.itemUseCount[itemType](itemID, itemCount, otherData)
	end
	return math.min(itemCount, backpackltCtrl:getUseMax(itemID))
end)[gItemEffectDef.CHEST] = true
;(function(itemID, itemCount, otherData)
	local itemType = backpackltCtrl:getItemType(itemID)
	if itemLogic.itemUseCount[itemType] then
		return itemLogic.itemUseCount[itemType](itemID, itemCount, otherData)
	end
	return math.min(itemCount, backpackltCtrl:getUseMax(itemID))
end)[gItemEffectDef.ANIMATION] = true
;(function(itemID, itemCount, otherData)
	local itemType = backpackltCtrl:getItemType(itemID)
	if itemLogic.itemUseCount[itemType] then
		return itemLogic.itemUseCount[itemType](itemID, itemCount, otherData)
	end
	return math.min(itemCount, backpackltCtrl:getUseMax(itemID))
end)[gItemEffectDef.LOVE_HEART] = true
;(function(itemID, itemCount, otherData)
	local itemType = backpackltCtrl:getItemType(itemID)
	if itemLogic.itemUseCount[itemType] then
		return itemLogic.itemUseCount[itemType](itemID, itemCount, otherData)
	end
	return math.min(itemCount, backpackltCtrl:getUseMax(itemID))
end)[gItemEffectDef.SEND_FLOWER] = true
;(function(itemID, itemCount, otherData)
	local itemType = backpackltCtrl:getItemType(itemID)
	if itemLogic.itemUseCount[itemType] then
		return itemLogic.itemUseCount[itemType](itemID, itemCount, otherData)
	end
	return math.min(itemCount, backpackltCtrl:getUseMax(itemID))
end)[gItemEffectDef.SEND_ROSE] = true
;(function(itemID, itemCount, otherData)
	local itemType = backpackltCtrl:getItemType(itemID)
	if itemLogic.itemUseCount[itemType] then
		return itemLogic.itemUseCount[itemType](itemID, itemCount, otherData)
	end
	return math.min(itemCount, backpackltCtrl:getUseMax(itemID))
end)[gItemEffectDef.SEND_KABASA] = true
itemLogic.itemEffectBeforeFunMap, (function(itemID, itemCount, otherData)
	local itemType = backpackltCtrl:getItemType(itemID)
	if itemLogic.itemUseCount[itemType] then
		return itemLogic.itemUseCount[itemType](itemID, itemCount, otherData)
	end
	return math.min(itemCount, backpackltCtrl:getUseMax(itemID))
end)[gItemEffectDef.SEND_WORDS_CARD] = function(itemID, itemCount, otherData)
	local itemType = backpackltCtrl:getItemType(itemID)
	if itemLogic.itemUseCount[itemType] then
		return itemLogic.itemUseCount[itemType](itemID, itemCount, otherData)
	end
	return math.min(itemCount, backpackltCtrl:getUseMax(itemID))
end, true
_ENV, itemLogic.checkItemSpecialBeforeUse = function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end, function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end
;(function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end)[gItemType.PIGEON] = true
;(function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end)[gItemType.GOD_LANTERM] = true
;(function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end)[gItemType.GAOYANG] = true
;(function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end)[gItemType.CHRISTMAS_TREE] = true
;(function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end)[gItemType.PET_EXP] = true
;(function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end)[gItemType.SEA_MONSTER] = true
;(function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end)[gItemType.ICE_HUNTING_ITEM] = true
;(function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end)[gItemType.TREASURE_CRYSTAL] = true
;(function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end)[gItemType.PANDORABOX] = true
;(function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end)[gItemType.TREASURE_MAP_FRAGMENT] = true
;(function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end)[gItemType.TREASURE_MAP] = true
;(function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end)[gItemType.WAR_TREASURE_DRUM] = true
_ENV, itemLogic.itemTypeSkinFunMap, (function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end)[gItemType.WAR_TREASURE_VULN] = function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end, function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end, true
;(function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end)[gItemEffectDef.MERGE_FRAGMENG] = true
;(function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end)[gItemEffectDef.CHEST] = true
;(function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end)[gItemEffectDef.ANIMATION] = true
;(function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end)[gItemEffectDef.LOVE_HEART] = true
;(function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end)[gItemEffectDef.SEND_WORDS_CARD] = true
;(function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end)[gItemEffectDef.EXCHANGE] = true
;(function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end)[gItemEffectDef.OPTIONAL] = true
;(function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end)[gItemEffectDef.OPTIONAL_EXTRA] = true
;(function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end)[gItemEffectDef.OPTIONAL_HERO] = true
;(function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end)[gItemEffectDef.KEY_OPEN] = true
;(function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end)[gItemEffectDef.DRESS] = true
;(function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end)[gItemEffectDef.SEND_SNOW_MAN_ITEMS] = true
;(function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end)[gItemEffectDef.RESTRICTED_OPTIONAL] = true
;(function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end)[gItemEffectDef.ACTIVITY_JUMP] = true
itemLogic.itemEffectSkinFunMap, (function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end)[gItemEffectDef.GIVE_ITEM_NEW] = function(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if itemLogic.itemTypeBeforeFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBeforeFunMap[itemType]
	end
	if itemLogic.itemEffectBeforeFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBeforeFunMap[itemEffect]
	end
	return false
end, true
function itemLogic.isItemSkinMakeSure(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	print("itemType", itemType)
	print("itemEffect", itemEffect)
	if itemLogic.itemTypeSkinFunMap[itemType] ~= nil then
		return itemLogic.itemTypeSkinFunMap[itemType]
	end
	if itemLogic.itemEffectSkinFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectSkinFunMap[itemEffect]
	end
	return false
end
function itemLogic.mergeFragmengTip(itemID, otherData)
	local artifactRuneRead = include("artifactRuneRead")
	if artifactRuneRead.isartifactRune(itemID) then
		_ENV = nil
		;(nil).mname = artifactRuneRead.getRuneName(itemID)
		;(nil).num = otherData.count
		SoraDShowMsgTip(i18n("common_text_1893", nil), artifactRuneRead.getRuneIcon(itemID))
	else
		_ENV = artifactRuneRead.getRuneIcon(itemID)
		artifactRuneRead.getRuneIcon(itemID).mname = itemDesRead.getName(itemID)
		artifactRuneRead.getRuneIcon(itemID).num = otherData.count
		SoraDShowMsgTip(i18n("common_text_1893", artifactRuneRead.getRuneIcon(itemID)), itemDesRead.getIcon(itemID, true))
	end
	return true
end
function itemLogic.pigeonTip(itemID, otherData)
	if otherData.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_MAIL_GIVE_PRESENT_SUCCESS"
		gErrDef.Err_None.isSuccess = true
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = nil
		;(nil).item = itemDesRead.getName(itemID)
		;(nil).count = otherData.count
		SoraDShowMsgTip(i18n("common_text_2825", nil), itemDesRead.getIcon(itemID, true))
	else
		_ENV = i18n("common_text_2825", nil)
		i18n("common_text_2825", nil).msg = "MESSAGE_SERVER_MAIL_GIVE_PRESENT_SUCCESS"
		i18n("common_text_2825", nil).isSuccess = false
		SoraDSendMessage((i18n("common_text_2825", nil)))
		if itemID == 511701 then
			if otherData.err == gErrDef.Err_PROP_CARRIER_PIGEON_COUNT_LIMIT then
				local canReceiveNum = otherData.data.extra.canReceiveNum
				if 0 < canReceiveNum then
					_ENV = itemDesRead.getIcon(itemID, true)
					itemDesRead.getIcon(itemID, true).num = canReceiveNum
					SoraDShowMsgTip(i18n("pigeon_text_02", itemDesRead.getIcon(itemID, true)))
				else
					SoraDShowMsgTip(i18n("pigeon_text_01"))
				end
			end
		elseif itemID == 501901 then
			if otherData.err == gErrDef.Err_PROP_CARRIER_PIGEON_COUNT_LIMIT then
				local canReceiveNum = otherData.data.extra.canReceiveNum
				if 0 < canReceiveNum then
					_ENV = i18n("pigeon_text_01")
					i18n("pigeon_text_01").num = canReceiveNum
					SoraDShowMsgTip(i18n("common_text_4857", i18n("pigeon_text_01")))
				else
					SoraDShowMsgTip(i18n("common_text_4856"))
				end
			end
		else
			msgNotice.notice("common_text_1381")
		end
	end
	return true
end
function itemLogic.clowBoxTip(itemID, otherData)
	if otherData.err == gErrDef.Err_None then
		local panel = SoraDCreatePanel("clowBoxView")
		panel:initData(otherData.data.result.itemList)
		panel:show()
	end
	return true
end
function itemLogic.recruitSoldiersTip(itemID, otherData)
	if otherData.err == gErrDef.Err_None then
		local _ENV, list = otherData.err, otherData.err
		for _, item in ipairs(otherData.data.result) do
			list[item.id] = item.count
		end
		_ENV = ipairs(otherData.data.result)
		ipairs(otherData.data.result).itemType = gItemType.RECRUIT_SOLDIERS
		SoraDOpenGiftView(list, ipairs(otherData.data.result))
	end
	return true
end
function itemLogic.HTMedalTip(itemID, otherData)
	if otherData.err == gErrDef.Err_None and otherData.count then
		_ENV = nil
		;(nil).count = otherData.count
		SoraDShowMsgTip(i18n("common_text_1886", nil), itemDesRead.getIcon(itemID, true))
	end
	return true
end
function itemLogic.goldGiftTip(itemID, otherData)
	if otherData.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ITEM_USE_SUCCESS_RED_PACKET"
		gErrDef.Err_None.isSuccess = true
		SoraDSendMessage(gErrDef.Err_None)
		local msgNotice = include("msgNotice")
		_ENV = nil
		;(nil).itemID = itemID
		msgNotice.notice("notice_0053", nil)
	end
	return true
end
function itemLogic.dropBoxTip(itemID, otherData)
	if otherData.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_ITEM_USE_SUCCESS_RED_PACKET"
		gErrDef.Err_None.isSuccess = true
		SoraDSendMessage(gErrDef.Err_None)
		local msgNotice = include("msgNotice")
		msgNotice.notice(i18n("treasureChest_text_13"))
	end
	return true
end
function itemLogic.halloweenJoke(itemID, otherData)
	if otherData.err == gErrDef.Err_None then
		local panel = SoraDCreatePanel("halloweenView")
		panel:initData(otherData.data.result)
		panel:show()
	end
	return true
end
function itemLogic.dressUpdate(itemID, otherData)
	msgNotice = nil
	;(nil).itemID = itemID
	msgNotice.notice("notice_0053", nil)
end
function itemLogic.halloweenActionTip(itemID, otherData)
	if otherData.err == gErrDef.Err_None then
		local panel = SoraDCreatePanel("halloweenActionView")
		panel:initData(true)
		panel:show()
		if otherData.count > 1 then
			_ENV = nil
			;(nil).item = itemDesRead.getName(itemID)
			SoraDShowMsgTip(i18n("common_text_2236", nil), itemDesRead.getIcon(itemID, true))
		else
			_ENV = itemDesRead.getIcon(itemID, true)
			itemDesRead.getIcon(itemID, true).item = itemDesRead.getName(itemID)
			itemDesRead.getIcon(itemID, true).name = otherData.data.result.receiverName
			SoraDShowMsgTip(i18n("common_text_2235", itemDesRead.getIcon(itemID, true)), itemDesRead.getIcon(itemID, true))
		end
	end
	return true
end
function itemLogic.itemValentineTip(itemID, otherData)
	if otherData.err == gErrDef.Err_None then
		local mailCtrl = gametop.playertop_:getModule("mailCtrl")
		local tableUID = otherData.data.result.uids
		local failNickNames = otherData.data.result.failNickNames
		local failCount = #otherData.data.result.failUids
		local isKing = SoraDIsSelfKing()
		local strContent = ""
		local itemType = backpackltCtrl:getItemType(itemID)
		if 0 < failCount then
			local name = ""
			for i, v in ipairs(failNickNames) do
				name = name .. v .. " "
			end
			_ENV = name
			name.name = name
			SoraDShowMsgTip(i18n("common_text_2294") .. "\n" .. i18n("common_text_2620", name), itemDesRead.getIcon(itemID, true))
		else
			SoraDShowMsgTip(i18n("common_text_2293"), itemDesRead.getIcon(itemID, true))
			if itemType == gItemType.LOVE_HEART then
				strContent = i18n("common_text_2607")
			elseif itemType == gItemType.RAINBOW_CASTLE then
				strContent = i18n("common_text_3700")
			elseif itemType == gItemType.SHINING_CASTLE then
				strContent = i18n("snowwolf_text_02")
			end
			_ENV = i18n("snowwolf_text_02")
			i18n("snowwolf_text_02").contentType = gChatMailContentType.content_text
			i18n("snowwolf_text_02").content = strContent
			local i18n("snowwolf_text_02").isKing, mailContent = isKing, i18n("snowwolf_text_02")
			mailCtrl:sendMultipleChatMail(tableUID, mailContent)
		end
	end
	return true
end
function itemLogic.itemWordCardTip(itemID, otherData)
	if otherData.err == gErrDef.Err_None then
		if otherData.data then
			local result = otherData.data.result
			if result and result.uids and table.nums(result.uids) <= 0 then
				SoraDShowMsgTip(i18n("common_text_3685"))
				return true
			end
		end
		SoraDShowMsgTip(i18n("common_text_2293"), itemDesRead.getIcon(itemID, true))
	end
	return true
end
function itemLogic.effectSnowManTips(itemID, otherData)
	dump(otherData, "otherData=====")
	if otherData.err == gErrDef.Err_None then
		local effectId = otherData.data.result.effectId
		SoraDGotoWorldMapPoint()
		SoraDRemoveAllPanelFromManager()
		if effectId then
			local count = otherData.data.count
			_ENV = nil
			;(nil).time = 300 * count
			SoraDShowMsgTip(i18n("BBQ_text_05", nil))
		else
			SoraDShowMsgTip(i18n("BBQ_text_06"))
		end
	end
	return true
end
_ENV, itemLogic.ancientItemTips = function(itemID, otherData)
	if otherData.err == gErrDef.Err_None then
		local resultType = backpackltCtrl:getResultType(itemID)
		if resultType == gItemEffectDef.ANCIENT_TREASURE then
			local result = otherData.data.result
			local panel = SoraDCreatePanel("ancientSecretMapView")
			panel:initData(result)
			panel:show()
		else
			local atCtrl = SoraDGetCtrl("ancientTreasureCtrl")
			local result = otherData.data.result
			local buildInfo = atCtrl:getBuildInfo(result.buildID)
			if buildInfo ~= nil then
				local ancientTreasureRead = include("ancientTreasureRead")
				local svrInfo = ancientTreasureRead.getSvrBuildInfo(buildInfo.buildType)
				if buildInfo.torchCount == svrInfo.torch and buildInfo.spadeCount == svrInfo.spade and atCtrl:isSelfJoinTreasure(result.buildID) then
					SoraDShowMsgTip(i18n("AncienTreasure_text_77"))
				elseif itemID == 821701 and buildInfo.torchCount >= svrInfo.torch then
					SoraDShowMsgTip(i18n("AncienTreasure_text_40"))
				elseif itemID == 821801 and buildInfo.spadeCount >= svrInfo.spade then
					SoraDShowMsgTip(i18n("AncienTreasure_text_41"))
				else
					SoraDShowMsgTip(i18n("AncienTreasure_text_72"))
				end
			end
		end
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_PROP_LIMIT then
		SoraDShowMsgTip(i18n("AncienTreasure_text_75"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_STAGE_NOT_OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_ACTIVITY_NOT_OPEN then
		SoraDShowMsgTip(i18n("king_tri_text_02"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_NOT_HAVE_AID then
		SoraDShowMsgTip(i18n("common_text_826"))
	end
	_ENV = i18n("common_text_826")
	i18n("common_text_826").msg = "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE"
	SoraDSendMessage(i18n("common_text_826"))
	return true
end, function(itemID, otherData)
	if otherData.err == gErrDef.Err_None then
		local resultType = backpackltCtrl:getResultType(itemID)
		if resultType == gItemEffectDef.ANCIENT_TREASURE then
			local result = otherData.data.result
			local panel = SoraDCreatePanel("ancientSecretMapView")
			panel:initData(result)
			panel:show()
		else
			local atCtrl = SoraDGetCtrl("ancientTreasureCtrl")
			local result = otherData.data.result
			local buildInfo = atCtrl:getBuildInfo(result.buildID)
			if buildInfo ~= nil then
				local ancientTreasureRead = include("ancientTreasureRead")
				local svrInfo = ancientTreasureRead.getSvrBuildInfo(buildInfo.buildType)
				if buildInfo.torchCount == svrInfo.torch and buildInfo.spadeCount == svrInfo.spade and atCtrl:isSelfJoinTreasure(result.buildID) then
					SoraDShowMsgTip(i18n("AncienTreasure_text_77"))
				elseif itemID == 821701 and buildInfo.torchCount >= svrInfo.torch then
					SoraDShowMsgTip(i18n("AncienTreasure_text_40"))
				elseif itemID == 821801 and buildInfo.spadeCount >= svrInfo.spade then
					SoraDShowMsgTip(i18n("AncienTreasure_text_41"))
				else
					SoraDShowMsgTip(i18n("AncienTreasure_text_72"))
				end
			end
		end
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_PROP_LIMIT then
		SoraDShowMsgTip(i18n("AncienTreasure_text_75"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_STAGE_NOT_OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_ACTIVITY_NOT_OPEN then
		SoraDShowMsgTip(i18n("king_tri_text_02"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_NOT_HAVE_AID then
		SoraDShowMsgTip(i18n("common_text_826"))
	end
	_ENV = i18n("common_text_826")
	i18n("common_text_826").msg = "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE"
	SoraDSendMessage(i18n("common_text_826"))
	return true
end
;(function(itemID, otherData)
	if otherData.err == gErrDef.Err_None then
		local resultType = backpackltCtrl:getResultType(itemID)
		if resultType == gItemEffectDef.ANCIENT_TREASURE then
			local result = otherData.data.result
			local panel = SoraDCreatePanel("ancientSecretMapView")
			panel:initData(result)
			panel:show()
		else
			local atCtrl = SoraDGetCtrl("ancientTreasureCtrl")
			local result = otherData.data.result
			local buildInfo = atCtrl:getBuildInfo(result.buildID)
			if buildInfo ~= nil then
				local ancientTreasureRead = include("ancientTreasureRead")
				local svrInfo = ancientTreasureRead.getSvrBuildInfo(buildInfo.buildType)
				if buildInfo.torchCount == svrInfo.torch and buildInfo.spadeCount == svrInfo.spade and atCtrl:isSelfJoinTreasure(result.buildID) then
					SoraDShowMsgTip(i18n("AncienTreasure_text_77"))
				elseif itemID == 821701 and buildInfo.torchCount >= svrInfo.torch then
					SoraDShowMsgTip(i18n("AncienTreasure_text_40"))
				elseif itemID == 821801 and buildInfo.spadeCount >= svrInfo.spade then
					SoraDShowMsgTip(i18n("AncienTreasure_text_41"))
				else
					SoraDShowMsgTip(i18n("AncienTreasure_text_72"))
				end
			end
		end
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_PROP_LIMIT then
		SoraDShowMsgTip(i18n("AncienTreasure_text_75"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_STAGE_NOT_OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_ACTIVITY_NOT_OPEN then
		SoraDShowMsgTip(i18n("king_tri_text_02"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_NOT_HAVE_AID then
		SoraDShowMsgTip(i18n("common_text_826"))
	end
	_ENV = i18n("common_text_826")
	i18n("common_text_826").msg = "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE"
	SoraDSendMessage(i18n("common_text_826"))
	return true
end)[gItemType.GOLD_GIFT] = itemLogic.goldGiftTip
;(function(itemID, otherData)
	if otherData.err == gErrDef.Err_None then
		local resultType = backpackltCtrl:getResultType(itemID)
		if resultType == gItemEffectDef.ANCIENT_TREASURE then
			local result = otherData.data.result
			local panel = SoraDCreatePanel("ancientSecretMapView")
			panel:initData(result)
			panel:show()
		else
			local atCtrl = SoraDGetCtrl("ancientTreasureCtrl")
			local result = otherData.data.result
			local buildInfo = atCtrl:getBuildInfo(result.buildID)
			if buildInfo ~= nil then
				local ancientTreasureRead = include("ancientTreasureRead")
				local svrInfo = ancientTreasureRead.getSvrBuildInfo(buildInfo.buildType)
				if buildInfo.torchCount == svrInfo.torch and buildInfo.spadeCount == svrInfo.spade and atCtrl:isSelfJoinTreasure(result.buildID) then
					SoraDShowMsgTip(i18n("AncienTreasure_text_77"))
				elseif itemID == 821701 and buildInfo.torchCount >= svrInfo.torch then
					SoraDShowMsgTip(i18n("AncienTreasure_text_40"))
				elseif itemID == 821801 and buildInfo.spadeCount >= svrInfo.spade then
					SoraDShowMsgTip(i18n("AncienTreasure_text_41"))
				else
					SoraDShowMsgTip(i18n("AncienTreasure_text_72"))
				end
			end
		end
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_PROP_LIMIT then
		SoraDShowMsgTip(i18n("AncienTreasure_text_75"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_STAGE_NOT_OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_ACTIVITY_NOT_OPEN then
		SoraDShowMsgTip(i18n("king_tri_text_02"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_NOT_HAVE_AID then
		SoraDShowMsgTip(i18n("common_text_826"))
	end
	_ENV = i18n("common_text_826")
	i18n("common_text_826").msg = "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE"
	SoraDSendMessage(i18n("common_text_826"))
	return true
end)[gItemType.DROP_BOX] = itemLogic.dropBoxTip
;(function(itemID, otherData)
	if otherData.err == gErrDef.Err_None then
		local resultType = backpackltCtrl:getResultType(itemID)
		if resultType == gItemEffectDef.ANCIENT_TREASURE then
			local result = otherData.data.result
			local panel = SoraDCreatePanel("ancientSecretMapView")
			panel:initData(result)
			panel:show()
		else
			local atCtrl = SoraDGetCtrl("ancientTreasureCtrl")
			local result = otherData.data.result
			local buildInfo = atCtrl:getBuildInfo(result.buildID)
			if buildInfo ~= nil then
				local ancientTreasureRead = include("ancientTreasureRead")
				local svrInfo = ancientTreasureRead.getSvrBuildInfo(buildInfo.buildType)
				if buildInfo.torchCount == svrInfo.torch and buildInfo.spadeCount == svrInfo.spade and atCtrl:isSelfJoinTreasure(result.buildID) then
					SoraDShowMsgTip(i18n("AncienTreasure_text_77"))
				elseif itemID == 821701 and buildInfo.torchCount >= svrInfo.torch then
					SoraDShowMsgTip(i18n("AncienTreasure_text_40"))
				elseif itemID == 821801 and buildInfo.spadeCount >= svrInfo.spade then
					SoraDShowMsgTip(i18n("AncienTreasure_text_41"))
				else
					SoraDShowMsgTip(i18n("AncienTreasure_text_72"))
				end
			end
		end
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_PROP_LIMIT then
		SoraDShowMsgTip(i18n("AncienTreasure_text_75"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_STAGE_NOT_OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_ACTIVITY_NOT_OPEN then
		SoraDShowMsgTip(i18n("king_tri_text_02"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_NOT_HAVE_AID then
		SoraDShowMsgTip(i18n("common_text_826"))
	end
	_ENV = i18n("common_text_826")
	i18n("common_text_826").msg = "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE"
	SoraDSendMessage(i18n("common_text_826"))
	return true
end)[gItemType.HT_MEDAL] = itemLogic.HTMedalTip
;(function(itemID, otherData)
	if otherData.err == gErrDef.Err_None then
		local resultType = backpackltCtrl:getResultType(itemID)
		if resultType == gItemEffectDef.ANCIENT_TREASURE then
			local result = otherData.data.result
			local panel = SoraDCreatePanel("ancientSecretMapView")
			panel:initData(result)
			panel:show()
		else
			local atCtrl = SoraDGetCtrl("ancientTreasureCtrl")
			local result = otherData.data.result
			local buildInfo = atCtrl:getBuildInfo(result.buildID)
			if buildInfo ~= nil then
				local ancientTreasureRead = include("ancientTreasureRead")
				local svrInfo = ancientTreasureRead.getSvrBuildInfo(buildInfo.buildType)
				if buildInfo.torchCount == svrInfo.torch and buildInfo.spadeCount == svrInfo.spade and atCtrl:isSelfJoinTreasure(result.buildID) then
					SoraDShowMsgTip(i18n("AncienTreasure_text_77"))
				elseif itemID == 821701 and buildInfo.torchCount >= svrInfo.torch then
					SoraDShowMsgTip(i18n("AncienTreasure_text_40"))
				elseif itemID == 821801 and buildInfo.spadeCount >= svrInfo.spade then
					SoraDShowMsgTip(i18n("AncienTreasure_text_41"))
				else
					SoraDShowMsgTip(i18n("AncienTreasure_text_72"))
				end
			end
		end
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_PROP_LIMIT then
		SoraDShowMsgTip(i18n("AncienTreasure_text_75"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_STAGE_NOT_OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_ACTIVITY_NOT_OPEN then
		SoraDShowMsgTip(i18n("king_tri_text_02"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_NOT_HAVE_AID then
		SoraDShowMsgTip(i18n("common_text_826"))
	end
	_ENV = i18n("common_text_826")
	i18n("common_text_826").msg = "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE"
	SoraDSendMessage(i18n("common_text_826"))
	return true
end)[gItemType.PIGEON] = itemLogic.pigeonTip
;(function(itemID, otherData)
	if otherData.err == gErrDef.Err_None then
		local resultType = backpackltCtrl:getResultType(itemID)
		if resultType == gItemEffectDef.ANCIENT_TREASURE then
			local result = otherData.data.result
			local panel = SoraDCreatePanel("ancientSecretMapView")
			panel:initData(result)
			panel:show()
		else
			local atCtrl = SoraDGetCtrl("ancientTreasureCtrl")
			local result = otherData.data.result
			local buildInfo = atCtrl:getBuildInfo(result.buildID)
			if buildInfo ~= nil then
				local ancientTreasureRead = include("ancientTreasureRead")
				local svrInfo = ancientTreasureRead.getSvrBuildInfo(buildInfo.buildType)
				if buildInfo.torchCount == svrInfo.torch and buildInfo.spadeCount == svrInfo.spade and atCtrl:isSelfJoinTreasure(result.buildID) then
					SoraDShowMsgTip(i18n("AncienTreasure_text_77"))
				elseif itemID == 821701 and buildInfo.torchCount >= svrInfo.torch then
					SoraDShowMsgTip(i18n("AncienTreasure_text_40"))
				elseif itemID == 821801 and buildInfo.spadeCount >= svrInfo.spade then
					SoraDShowMsgTip(i18n("AncienTreasure_text_41"))
				else
					SoraDShowMsgTip(i18n("AncienTreasure_text_72"))
				end
			end
		end
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_PROP_LIMIT then
		SoraDShowMsgTip(i18n("AncienTreasure_text_75"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_STAGE_NOT_OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_ACTIVITY_NOT_OPEN then
		SoraDShowMsgTip(i18n("king_tri_text_02"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_NOT_HAVE_AID then
		SoraDShowMsgTip(i18n("common_text_826"))
	end
	_ENV = i18n("common_text_826")
	i18n("common_text_826").msg = "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE"
	SoraDSendMessage(i18n("common_text_826"))
	return true
end)[gItemType.RECRUIT_SOLDIERS] = itemLogic.recruitSoldiersTip
_ENV, itemLogic.itemTypeBackTipFunMap, (function(itemID, otherData)
	if otherData.err == gErrDef.Err_None then
		local resultType = backpackltCtrl:getResultType(itemID)
		if resultType == gItemEffectDef.ANCIENT_TREASURE then
			local result = otherData.data.result
			local panel = SoraDCreatePanel("ancientSecretMapView")
			panel:initData(result)
			panel:show()
		else
			local atCtrl = SoraDGetCtrl("ancientTreasureCtrl")
			local result = otherData.data.result
			local buildInfo = atCtrl:getBuildInfo(result.buildID)
			if buildInfo ~= nil then
				local ancientTreasureRead = include("ancientTreasureRead")
				local svrInfo = ancientTreasureRead.getSvrBuildInfo(buildInfo.buildType)
				if buildInfo.torchCount == svrInfo.torch and buildInfo.spadeCount == svrInfo.spade and atCtrl:isSelfJoinTreasure(result.buildID) then
					SoraDShowMsgTip(i18n("AncienTreasure_text_77"))
				elseif itemID == 821701 and buildInfo.torchCount >= svrInfo.torch then
					SoraDShowMsgTip(i18n("AncienTreasure_text_40"))
				elseif itemID == 821801 and buildInfo.spadeCount >= svrInfo.spade then
					SoraDShowMsgTip(i18n("AncienTreasure_text_41"))
				else
					SoraDShowMsgTip(i18n("AncienTreasure_text_72"))
				end
			end
		end
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_PROP_LIMIT then
		SoraDShowMsgTip(i18n("AncienTreasure_text_75"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_STAGE_NOT_OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_ACTIVITY_NOT_OPEN then
		SoraDShowMsgTip(i18n("king_tri_text_02"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_NOT_HAVE_AID then
		SoraDShowMsgTip(i18n("common_text_826"))
	end
	_ENV = i18n("common_text_826")
	i18n("common_text_826").msg = "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE"
	SoraDSendMessage(i18n("common_text_826"))
	return true
end)[gItemType.CLOWN_BOX] = function(itemID, otherData)
	if otherData.err == gErrDef.Err_None then
		local resultType = backpackltCtrl:getResultType(itemID)
		if resultType == gItemEffectDef.ANCIENT_TREASURE then
			local result = otherData.data.result
			local panel = SoraDCreatePanel("ancientSecretMapView")
			panel:initData(result)
			panel:show()
		else
			local atCtrl = SoraDGetCtrl("ancientTreasureCtrl")
			local result = otherData.data.result
			local buildInfo = atCtrl:getBuildInfo(result.buildID)
			if buildInfo ~= nil then
				local ancientTreasureRead = include("ancientTreasureRead")
				local svrInfo = ancientTreasureRead.getSvrBuildInfo(buildInfo.buildType)
				if buildInfo.torchCount == svrInfo.torch and buildInfo.spadeCount == svrInfo.spade and atCtrl:isSelfJoinTreasure(result.buildID) then
					SoraDShowMsgTip(i18n("AncienTreasure_text_77"))
				elseif itemID == 821701 and buildInfo.torchCount >= svrInfo.torch then
					SoraDShowMsgTip(i18n("AncienTreasure_text_40"))
				elseif itemID == 821801 and buildInfo.spadeCount >= svrInfo.spade then
					SoraDShowMsgTip(i18n("AncienTreasure_text_41"))
				else
					SoraDShowMsgTip(i18n("AncienTreasure_text_72"))
				end
			end
		end
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_PROP_LIMIT then
		SoraDShowMsgTip(i18n("AncienTreasure_text_75"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_STAGE_NOT_OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_ACTIVITY_NOT_OPEN then
		SoraDShowMsgTip(i18n("king_tri_text_02"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_NOT_HAVE_AID then
		SoraDShowMsgTip(i18n("common_text_826"))
	end
	_ENV = i18n("common_text_826")
	i18n("common_text_826").msg = "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE"
	SoraDSendMessage(i18n("common_text_826"))
	return true
end, function(itemID, otherData)
	if otherData.err == gErrDef.Err_None then
		local resultType = backpackltCtrl:getResultType(itemID)
		if resultType == gItemEffectDef.ANCIENT_TREASURE then
			local result = otherData.data.result
			local panel = SoraDCreatePanel("ancientSecretMapView")
			panel:initData(result)
			panel:show()
		else
			local atCtrl = SoraDGetCtrl("ancientTreasureCtrl")
			local result = otherData.data.result
			local buildInfo = atCtrl:getBuildInfo(result.buildID)
			if buildInfo ~= nil then
				local ancientTreasureRead = include("ancientTreasureRead")
				local svrInfo = ancientTreasureRead.getSvrBuildInfo(buildInfo.buildType)
				if buildInfo.torchCount == svrInfo.torch and buildInfo.spadeCount == svrInfo.spade and atCtrl:isSelfJoinTreasure(result.buildID) then
					SoraDShowMsgTip(i18n("AncienTreasure_text_77"))
				elseif itemID == 821701 and buildInfo.torchCount >= svrInfo.torch then
					SoraDShowMsgTip(i18n("AncienTreasure_text_40"))
				elseif itemID == 821801 and buildInfo.spadeCount >= svrInfo.spade then
					SoraDShowMsgTip(i18n("AncienTreasure_text_41"))
				else
					SoraDShowMsgTip(i18n("AncienTreasure_text_72"))
				end
			end
		end
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_PROP_LIMIT then
		SoraDShowMsgTip(i18n("AncienTreasure_text_75"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_STAGE_NOT_OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_ACTIVITY_NOT_OPEN then
		SoraDShowMsgTip(i18n("king_tri_text_02"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_NOT_HAVE_AID then
		SoraDShowMsgTip(i18n("common_text_826"))
	end
	_ENV = i18n("common_text_826")
	i18n("common_text_826").msg = "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE"
	SoraDSendMessage(i18n("common_text_826"))
	return true
end, itemLogic.clowBoxTip
;(function(itemID, otherData)
	if otherData.err == gErrDef.Err_None then
		local resultType = backpackltCtrl:getResultType(itemID)
		if resultType == gItemEffectDef.ANCIENT_TREASURE then
			local result = otherData.data.result
			local panel = SoraDCreatePanel("ancientSecretMapView")
			panel:initData(result)
			panel:show()
		else
			local atCtrl = SoraDGetCtrl("ancientTreasureCtrl")
			local result = otherData.data.result
			local buildInfo = atCtrl:getBuildInfo(result.buildID)
			if buildInfo ~= nil then
				local ancientTreasureRead = include("ancientTreasureRead")
				local svrInfo = ancientTreasureRead.getSvrBuildInfo(buildInfo.buildType)
				if buildInfo.torchCount == svrInfo.torch and buildInfo.spadeCount == svrInfo.spade and atCtrl:isSelfJoinTreasure(result.buildID) then
					SoraDShowMsgTip(i18n("AncienTreasure_text_77"))
				elseif itemID == 821701 and buildInfo.torchCount >= svrInfo.torch then
					SoraDShowMsgTip(i18n("AncienTreasure_text_40"))
				elseif itemID == 821801 and buildInfo.spadeCount >= svrInfo.spade then
					SoraDShowMsgTip(i18n("AncienTreasure_text_41"))
				else
					SoraDShowMsgTip(i18n("AncienTreasure_text_72"))
				end
			end
		end
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_PROP_LIMIT then
		SoraDShowMsgTip(i18n("AncienTreasure_text_75"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_STAGE_NOT_OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_ACTIVITY_NOT_OPEN then
		SoraDShowMsgTip(i18n("king_tri_text_02"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_NOT_HAVE_AID then
		SoraDShowMsgTip(i18n("common_text_826"))
	end
	_ENV = i18n("common_text_826")
	i18n("common_text_826").msg = "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE"
	SoraDSendMessage(i18n("common_text_826"))
	return true
end)[gItemEffectDef.MERGE_FRAGMENG] = itemLogic.mergeFragmengTip
;(function(itemID, otherData)
	if otherData.err == gErrDef.Err_None then
		local resultType = backpackltCtrl:getResultType(itemID)
		if resultType == gItemEffectDef.ANCIENT_TREASURE then
			local result = otherData.data.result
			local panel = SoraDCreatePanel("ancientSecretMapView")
			panel:initData(result)
			panel:show()
		else
			local atCtrl = SoraDGetCtrl("ancientTreasureCtrl")
			local result = otherData.data.result
			local buildInfo = atCtrl:getBuildInfo(result.buildID)
			if buildInfo ~= nil then
				local ancientTreasureRead = include("ancientTreasureRead")
				local svrInfo = ancientTreasureRead.getSvrBuildInfo(buildInfo.buildType)
				if buildInfo.torchCount == svrInfo.torch and buildInfo.spadeCount == svrInfo.spade and atCtrl:isSelfJoinTreasure(result.buildID) then
					SoraDShowMsgTip(i18n("AncienTreasure_text_77"))
				elseif itemID == 821701 and buildInfo.torchCount >= svrInfo.torch then
					SoraDShowMsgTip(i18n("AncienTreasure_text_40"))
				elseif itemID == 821801 and buildInfo.spadeCount >= svrInfo.spade then
					SoraDShowMsgTip(i18n("AncienTreasure_text_41"))
				else
					SoraDShowMsgTip(i18n("AncienTreasure_text_72"))
				end
			end
		end
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_PROP_LIMIT then
		SoraDShowMsgTip(i18n("AncienTreasure_text_75"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_STAGE_NOT_OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_ACTIVITY_NOT_OPEN then
		SoraDShowMsgTip(i18n("king_tri_text_02"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_NOT_HAVE_AID then
		SoraDShowMsgTip(i18n("common_text_826"))
	end
	_ENV = i18n("common_text_826")
	i18n("common_text_826").msg = "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE"
	SoraDSendMessage(i18n("common_text_826"))
	return true
end)[gItemEffectDef.JOKE] = itemLogic.halloweenJoke
;(function(itemID, otherData)
	if otherData.err == gErrDef.Err_None then
		local resultType = backpackltCtrl:getResultType(itemID)
		if resultType == gItemEffectDef.ANCIENT_TREASURE then
			local result = otherData.data.result
			local panel = SoraDCreatePanel("ancientSecretMapView")
			panel:initData(result)
			panel:show()
		else
			local atCtrl = SoraDGetCtrl("ancientTreasureCtrl")
			local result = otherData.data.result
			local buildInfo = atCtrl:getBuildInfo(result.buildID)
			if buildInfo ~= nil then
				local ancientTreasureRead = include("ancientTreasureRead")
				local svrInfo = ancientTreasureRead.getSvrBuildInfo(buildInfo.buildType)
				if buildInfo.torchCount == svrInfo.torch and buildInfo.spadeCount == svrInfo.spade and atCtrl:isSelfJoinTreasure(result.buildID) then
					SoraDShowMsgTip(i18n("AncienTreasure_text_77"))
				elseif itemID == 821701 and buildInfo.torchCount >= svrInfo.torch then
					SoraDShowMsgTip(i18n("AncienTreasure_text_40"))
				elseif itemID == 821801 and buildInfo.spadeCount >= svrInfo.spade then
					SoraDShowMsgTip(i18n("AncienTreasure_text_41"))
				else
					SoraDShowMsgTip(i18n("AncienTreasure_text_72"))
				end
			end
		end
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_PROP_LIMIT then
		SoraDShowMsgTip(i18n("AncienTreasure_text_75"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_STAGE_NOT_OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_ACTIVITY_NOT_OPEN then
		SoraDShowMsgTip(i18n("king_tri_text_02"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_NOT_HAVE_AID then
		SoraDShowMsgTip(i18n("common_text_826"))
	end
	_ENV = i18n("common_text_826")
	i18n("common_text_826").msg = "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE"
	SoraDSendMessage(i18n("common_text_826"))
	return true
end)[gItemEffectDef.DRESS] = itemLogic.dressUpdate
;(function(itemID, otherData)
	if otherData.err == gErrDef.Err_None then
		local resultType = backpackltCtrl:getResultType(itemID)
		if resultType == gItemEffectDef.ANCIENT_TREASURE then
			local result = otherData.data.result
			local panel = SoraDCreatePanel("ancientSecretMapView")
			panel:initData(result)
			panel:show()
		else
			local atCtrl = SoraDGetCtrl("ancientTreasureCtrl")
			local result = otherData.data.result
			local buildInfo = atCtrl:getBuildInfo(result.buildID)
			if buildInfo ~= nil then
				local ancientTreasureRead = include("ancientTreasureRead")
				local svrInfo = ancientTreasureRead.getSvrBuildInfo(buildInfo.buildType)
				if buildInfo.torchCount == svrInfo.torch and buildInfo.spadeCount == svrInfo.spade and atCtrl:isSelfJoinTreasure(result.buildID) then
					SoraDShowMsgTip(i18n("AncienTreasure_text_77"))
				elseif itemID == 821701 and buildInfo.torchCount >= svrInfo.torch then
					SoraDShowMsgTip(i18n("AncienTreasure_text_40"))
				elseif itemID == 821801 and buildInfo.spadeCount >= svrInfo.spade then
					SoraDShowMsgTip(i18n("AncienTreasure_text_41"))
				else
					SoraDShowMsgTip(i18n("AncienTreasure_text_72"))
				end
			end
		end
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_PROP_LIMIT then
		SoraDShowMsgTip(i18n("AncienTreasure_text_75"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_STAGE_NOT_OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_ACTIVITY_NOT_OPEN then
		SoraDShowMsgTip(i18n("king_tri_text_02"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_NOT_HAVE_AID then
		SoraDShowMsgTip(i18n("common_text_826"))
	end
	_ENV = i18n("common_text_826")
	i18n("common_text_826").msg = "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE"
	SoraDSendMessage(i18n("common_text_826"))
	return true
end)[gItemEffectDef.ANIMATION] = itemLogic.halloweenActionTip
;(function(itemID, otherData)
	if otherData.err == gErrDef.Err_None then
		local resultType = backpackltCtrl:getResultType(itemID)
		if resultType == gItemEffectDef.ANCIENT_TREASURE then
			local result = otherData.data.result
			local panel = SoraDCreatePanel("ancientSecretMapView")
			panel:initData(result)
			panel:show()
		else
			local atCtrl = SoraDGetCtrl("ancientTreasureCtrl")
			local result = otherData.data.result
			local buildInfo = atCtrl:getBuildInfo(result.buildID)
			if buildInfo ~= nil then
				local ancientTreasureRead = include("ancientTreasureRead")
				local svrInfo = ancientTreasureRead.getSvrBuildInfo(buildInfo.buildType)
				if buildInfo.torchCount == svrInfo.torch and buildInfo.spadeCount == svrInfo.spade and atCtrl:isSelfJoinTreasure(result.buildID) then
					SoraDShowMsgTip(i18n("AncienTreasure_text_77"))
				elseif itemID == 821701 and buildInfo.torchCount >= svrInfo.torch then
					SoraDShowMsgTip(i18n("AncienTreasure_text_40"))
				elseif itemID == 821801 and buildInfo.spadeCount >= svrInfo.spade then
					SoraDShowMsgTip(i18n("AncienTreasure_text_41"))
				else
					SoraDShowMsgTip(i18n("AncienTreasure_text_72"))
				end
			end
		end
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_PROP_LIMIT then
		SoraDShowMsgTip(i18n("AncienTreasure_text_75"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_STAGE_NOT_OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_ACTIVITY_NOT_OPEN then
		SoraDShowMsgTip(i18n("king_tri_text_02"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_NOT_HAVE_AID then
		SoraDShowMsgTip(i18n("common_text_826"))
	end
	_ENV = i18n("common_text_826")
	i18n("common_text_826").msg = "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE"
	SoraDSendMessage(i18n("common_text_826"))
	return true
end)[gItemEffectDef.LOVE_HEART] = itemLogic.itemValentineTip
;(function(itemID, otherData)
	if otherData.err == gErrDef.Err_None then
		local resultType = backpackltCtrl:getResultType(itemID)
		if resultType == gItemEffectDef.ANCIENT_TREASURE then
			local result = otherData.data.result
			local panel = SoraDCreatePanel("ancientSecretMapView")
			panel:initData(result)
			panel:show()
		else
			local atCtrl = SoraDGetCtrl("ancientTreasureCtrl")
			local result = otherData.data.result
			local buildInfo = atCtrl:getBuildInfo(result.buildID)
			if buildInfo ~= nil then
				local ancientTreasureRead = include("ancientTreasureRead")
				local svrInfo = ancientTreasureRead.getSvrBuildInfo(buildInfo.buildType)
				if buildInfo.torchCount == svrInfo.torch and buildInfo.spadeCount == svrInfo.spade and atCtrl:isSelfJoinTreasure(result.buildID) then
					SoraDShowMsgTip(i18n("AncienTreasure_text_77"))
				elseif itemID == 821701 and buildInfo.torchCount >= svrInfo.torch then
					SoraDShowMsgTip(i18n("AncienTreasure_text_40"))
				elseif itemID == 821801 and buildInfo.spadeCount >= svrInfo.spade then
					SoraDShowMsgTip(i18n("AncienTreasure_text_41"))
				else
					SoraDShowMsgTip(i18n("AncienTreasure_text_72"))
				end
			end
		end
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_PROP_LIMIT then
		SoraDShowMsgTip(i18n("AncienTreasure_text_75"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_STAGE_NOT_OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_ACTIVITY_NOT_OPEN then
		SoraDShowMsgTip(i18n("king_tri_text_02"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_NOT_HAVE_AID then
		SoraDShowMsgTip(i18n("common_text_826"))
	end
	_ENV = i18n("common_text_826")
	i18n("common_text_826").msg = "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE"
	SoraDSendMessage(i18n("common_text_826"))
	return true
end)[gItemEffectDef.SEND_WORDS_CARD] = itemLogic.itemWordCardTip
;(function(itemID, otherData)
	if otherData.err == gErrDef.Err_None then
		local resultType = backpackltCtrl:getResultType(itemID)
		if resultType == gItemEffectDef.ANCIENT_TREASURE then
			local result = otherData.data.result
			local panel = SoraDCreatePanel("ancientSecretMapView")
			panel:initData(result)
			panel:show()
		else
			local atCtrl = SoraDGetCtrl("ancientTreasureCtrl")
			local result = otherData.data.result
			local buildInfo = atCtrl:getBuildInfo(result.buildID)
			if buildInfo ~= nil then
				local ancientTreasureRead = include("ancientTreasureRead")
				local svrInfo = ancientTreasureRead.getSvrBuildInfo(buildInfo.buildType)
				if buildInfo.torchCount == svrInfo.torch and buildInfo.spadeCount == svrInfo.spade and atCtrl:isSelfJoinTreasure(result.buildID) then
					SoraDShowMsgTip(i18n("AncienTreasure_text_77"))
				elseif itemID == 821701 and buildInfo.torchCount >= svrInfo.torch then
					SoraDShowMsgTip(i18n("AncienTreasure_text_40"))
				elseif itemID == 821801 and buildInfo.spadeCount >= svrInfo.spade then
					SoraDShowMsgTip(i18n("AncienTreasure_text_41"))
				else
					SoraDShowMsgTip(i18n("AncienTreasure_text_72"))
				end
			end
		end
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_PROP_LIMIT then
		SoraDShowMsgTip(i18n("AncienTreasure_text_75"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_STAGE_NOT_OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_ACTIVITY_NOT_OPEN then
		SoraDShowMsgTip(i18n("king_tri_text_02"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_NOT_HAVE_AID then
		SoraDShowMsgTip(i18n("common_text_826"))
	end
	_ENV = i18n("common_text_826")
	i18n("common_text_826").msg = "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE"
	SoraDSendMessage(i18n("common_text_826"))
	return true
end)[gItemEffectDef.EXCHANGE] = itemLogic.exchange
;(function(itemID, otherData)
	if otherData.err == gErrDef.Err_None then
		local resultType = backpackltCtrl:getResultType(itemID)
		if resultType == gItemEffectDef.ANCIENT_TREASURE then
			local result = otherData.data.result
			local panel = SoraDCreatePanel("ancientSecretMapView")
			panel:initData(result)
			panel:show()
		else
			local atCtrl = SoraDGetCtrl("ancientTreasureCtrl")
			local result = otherData.data.result
			local buildInfo = atCtrl:getBuildInfo(result.buildID)
			if buildInfo ~= nil then
				local ancientTreasureRead = include("ancientTreasureRead")
				local svrInfo = ancientTreasureRead.getSvrBuildInfo(buildInfo.buildType)
				if buildInfo.torchCount == svrInfo.torch and buildInfo.spadeCount == svrInfo.spade and atCtrl:isSelfJoinTreasure(result.buildID) then
					SoraDShowMsgTip(i18n("AncienTreasure_text_77"))
				elseif itemID == 821701 and buildInfo.torchCount >= svrInfo.torch then
					SoraDShowMsgTip(i18n("AncienTreasure_text_40"))
				elseif itemID == 821801 and buildInfo.spadeCount >= svrInfo.spade then
					SoraDShowMsgTip(i18n("AncienTreasure_text_41"))
				else
					SoraDShowMsgTip(i18n("AncienTreasure_text_72"))
				end
			end
		end
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_PROP_LIMIT then
		SoraDShowMsgTip(i18n("AncienTreasure_text_75"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_STAGE_NOT_OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_ACTIVITY_NOT_OPEN then
		SoraDShowMsgTip(i18n("king_tri_text_02"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_NOT_HAVE_AID then
		SoraDShowMsgTip(i18n("common_text_826"))
	end
	_ENV = i18n("common_text_826")
	i18n("common_text_826").msg = "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE"
	SoraDSendMessage(i18n("common_text_826"))
	return true
end)[gItemEffectDef.ANCIENT_FIRE] = itemLogic.ancientItemTips
;(function(itemID, otherData)
	if otherData.err == gErrDef.Err_None then
		local resultType = backpackltCtrl:getResultType(itemID)
		if resultType == gItemEffectDef.ANCIENT_TREASURE then
			local result = otherData.data.result
			local panel = SoraDCreatePanel("ancientSecretMapView")
			panel:initData(result)
			panel:show()
		else
			local atCtrl = SoraDGetCtrl("ancientTreasureCtrl")
			local result = otherData.data.result
			local buildInfo = atCtrl:getBuildInfo(result.buildID)
			if buildInfo ~= nil then
				local ancientTreasureRead = include("ancientTreasureRead")
				local svrInfo = ancientTreasureRead.getSvrBuildInfo(buildInfo.buildType)
				if buildInfo.torchCount == svrInfo.torch and buildInfo.spadeCount == svrInfo.spade and atCtrl:isSelfJoinTreasure(result.buildID) then
					SoraDShowMsgTip(i18n("AncienTreasure_text_77"))
				elseif itemID == 821701 and buildInfo.torchCount >= svrInfo.torch then
					SoraDShowMsgTip(i18n("AncienTreasure_text_40"))
				elseif itemID == 821801 and buildInfo.spadeCount >= svrInfo.spade then
					SoraDShowMsgTip(i18n("AncienTreasure_text_41"))
				else
					SoraDShowMsgTip(i18n("AncienTreasure_text_72"))
				end
			end
		end
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_PROP_LIMIT then
		SoraDShowMsgTip(i18n("AncienTreasure_text_75"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_STAGE_NOT_OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_ACTIVITY_NOT_OPEN then
		SoraDShowMsgTip(i18n("king_tri_text_02"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_NOT_HAVE_AID then
		SoraDShowMsgTip(i18n("common_text_826"))
	end
	_ENV = i18n("common_text_826")
	i18n("common_text_826").msg = "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE"
	SoraDSendMessage(i18n("common_text_826"))
	return true
end)[gItemEffectDef.ANCIENT_SHOVEL] = itemLogic.ancientItemTips
;(function(itemID, otherData)
	if otherData.err == gErrDef.Err_None then
		local resultType = backpackltCtrl:getResultType(itemID)
		if resultType == gItemEffectDef.ANCIENT_TREASURE then
			local result = otherData.data.result
			local panel = SoraDCreatePanel("ancientSecretMapView")
			panel:initData(result)
			panel:show()
		else
			local atCtrl = SoraDGetCtrl("ancientTreasureCtrl")
			local result = otherData.data.result
			local buildInfo = atCtrl:getBuildInfo(result.buildID)
			if buildInfo ~= nil then
				local ancientTreasureRead = include("ancientTreasureRead")
				local svrInfo = ancientTreasureRead.getSvrBuildInfo(buildInfo.buildType)
				if buildInfo.torchCount == svrInfo.torch and buildInfo.spadeCount == svrInfo.spade and atCtrl:isSelfJoinTreasure(result.buildID) then
					SoraDShowMsgTip(i18n("AncienTreasure_text_77"))
				elseif itemID == 821701 and buildInfo.torchCount >= svrInfo.torch then
					SoraDShowMsgTip(i18n("AncienTreasure_text_40"))
				elseif itemID == 821801 and buildInfo.spadeCount >= svrInfo.spade then
					SoraDShowMsgTip(i18n("AncienTreasure_text_41"))
				else
					SoraDShowMsgTip(i18n("AncienTreasure_text_72"))
				end
			end
		end
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_PROP_LIMIT then
		SoraDShowMsgTip(i18n("AncienTreasure_text_75"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_STAGE_NOT_OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_ACTIVITY_NOT_OPEN then
		SoraDShowMsgTip(i18n("king_tri_text_02"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_NOT_HAVE_AID then
		SoraDShowMsgTip(i18n("common_text_826"))
	end
	_ENV = i18n("common_text_826")
	i18n("common_text_826").msg = "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE"
	SoraDSendMessage(i18n("common_text_826"))
	return true
end)[gItemEffectDef.ANCIENT_TREASURE] = itemLogic.ancientItemTips
itemLogic.itemEffectBackTipFunMap, (function(itemID, otherData)
	if otherData.err == gErrDef.Err_None then
		local resultType = backpackltCtrl:getResultType(itemID)
		if resultType == gItemEffectDef.ANCIENT_TREASURE then
			local result = otherData.data.result
			local panel = SoraDCreatePanel("ancientSecretMapView")
			panel:initData(result)
			panel:show()
		else
			local atCtrl = SoraDGetCtrl("ancientTreasureCtrl")
			local result = otherData.data.result
			local buildInfo = atCtrl:getBuildInfo(result.buildID)
			if buildInfo ~= nil then
				local ancientTreasureRead = include("ancientTreasureRead")
				local svrInfo = ancientTreasureRead.getSvrBuildInfo(buildInfo.buildType)
				if buildInfo.torchCount == svrInfo.torch and buildInfo.spadeCount == svrInfo.spade and atCtrl:isSelfJoinTreasure(result.buildID) then
					SoraDShowMsgTip(i18n("AncienTreasure_text_77"))
				elseif itemID == 821701 and buildInfo.torchCount >= svrInfo.torch then
					SoraDShowMsgTip(i18n("AncienTreasure_text_40"))
				elseif itemID == 821801 and buildInfo.spadeCount >= svrInfo.spade then
					SoraDShowMsgTip(i18n("AncienTreasure_text_41"))
				else
					SoraDShowMsgTip(i18n("AncienTreasure_text_72"))
				end
			end
		end
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_PROP_LIMIT then
		SoraDShowMsgTip(i18n("AncienTreasure_text_75"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_STAGE_NOT_OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_ACTIVITY_NOT_OPEN then
		SoraDShowMsgTip(i18n("king_tri_text_02"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_NOT_HAVE_AID then
		SoraDShowMsgTip(i18n("common_text_826"))
	end
	_ENV = i18n("common_text_826")
	i18n("common_text_826").msg = "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE"
	SoraDSendMessage(i18n("common_text_826"))
	return true
end)[gItemEffectDef.SNOWMAN] = function(itemID, otherData)
	if otherData.err == gErrDef.Err_None then
		local resultType = backpackltCtrl:getResultType(itemID)
		if resultType == gItemEffectDef.ANCIENT_TREASURE then
			local result = otherData.data.result
			local panel = SoraDCreatePanel("ancientSecretMapView")
			panel:initData(result)
			panel:show()
		else
			local atCtrl = SoraDGetCtrl("ancientTreasureCtrl")
			local result = otherData.data.result
			local buildInfo = atCtrl:getBuildInfo(result.buildID)
			if buildInfo ~= nil then
				local ancientTreasureRead = include("ancientTreasureRead")
				local svrInfo = ancientTreasureRead.getSvrBuildInfo(buildInfo.buildType)
				if buildInfo.torchCount == svrInfo.torch and buildInfo.spadeCount == svrInfo.spade and atCtrl:isSelfJoinTreasure(result.buildID) then
					SoraDShowMsgTip(i18n("AncienTreasure_text_77"))
				elseif itemID == 821701 and buildInfo.torchCount >= svrInfo.torch then
					SoraDShowMsgTip(i18n("AncienTreasure_text_40"))
				elseif itemID == 821801 and buildInfo.spadeCount >= svrInfo.spade then
					SoraDShowMsgTip(i18n("AncienTreasure_text_41"))
				else
					SoraDShowMsgTip(i18n("AncienTreasure_text_72"))
				end
			end
		end
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_PROP_LIMIT then
		SoraDShowMsgTip(i18n("AncienTreasure_text_75"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_STAGE_NOT_OPEN then
		SoraDShowMsgTip(i18n("common_text_2486"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_ACTIVITY_NOT_OPEN then
		SoraDShowMsgTip(i18n("king_tri_text_02"))
	elseif otherData.err == gErrDef.Err_ANCIENT_TREASURE_NOT_HAVE_AID then
		SoraDShowMsgTip(i18n("common_text_826"))
	end
	_ENV = i18n("common_text_826")
	i18n("common_text_826").msg = "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE"
	SoraDSendMessage(i18n("common_text_826"))
	return true
end, itemLogic.effectSnowManTips
function itemLogic.checkItemSpecialBackTip(itemID, otherData)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	if otherData.from == "mergeItem" then
		return itemLogic.mergeFragmengTip(itemID, otherData)
	end
	if itemLogic.itemTypeBackTipFunMap[itemType] ~= nil then
		return itemLogic.itemTypeBackTipFunMap[itemType](itemID, otherData)
	end
	if itemLogic.itemEffectBackTipFunMap[itemEffect] ~= nil then
		return itemLogic.itemEffectBackTipFunMap[itemEffect](itemID, otherData)
	end
	return false
end
_ENV, itemLogic.peaceShieldTip = function(itemID)
	local heroJailCtrl = gametop.playertop_:getModule("heroJailCtrl")
	if heroJailCtrl:isAnyoneInMyJail() then
		return i18n("prison_text_21")
	else
		return false
	end
end, function(itemID)
	local heroJailCtrl = gametop.playertop_:getModule("heroJailCtrl")
	if heroJailCtrl:isAnyoneInMyJail() then
		return i18n("prison_text_21")
	else
		return false
	end
end
itemLogic.itemEffectTipFunMap, _ENV, itemLogic.itemTypeTipFunMap, (function(itemID)
	local heroJailCtrl = gametop.playertop_:getModule("heroJailCtrl")
	if heroJailCtrl:isAnyoneInMyJail() then
		return i18n("prison_text_21")
	else
		return false
	end
end)[gItemType.PEACE_SHIELD] = function(itemID)
	local heroJailCtrl = gametop.playertop_:getModule("heroJailCtrl")
	if heroJailCtrl:isAnyoneInMyJail() then
		return i18n("prison_text_21")
	else
		return false
	end
end, function(itemID)
	local heroJailCtrl = gametop.playertop_:getModule("heroJailCtrl")
	if heroJailCtrl:isAnyoneInMyJail() then
		return i18n("prison_text_21")
	else
		return false
	end
end, function(itemID)
	local heroJailCtrl = gametop.playertop_:getModule("heroJailCtrl")
	if heroJailCtrl:isAnyoneInMyJail() then
		return i18n("prison_text_21")
	else
		return false
	end
end, itemLogic.peaceShieldTip
function itemLogic.checkItemSpecialTip(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local itemEffect = backpackltCtrl:getResultType(itemID)
	local src
	local ret = true
	if itemLogic.itemTypeTipFunMap[itemType] ~= nil then
		src = itemLogic.itemTypeTipFunMap[itemType](itemID)
	elseif itemLogic.itemEffectTipFunMap[itemEffect] ~= nil then
		src = itemLogic.itemEffectTipFunMap[itemEffect](itemID)
	end
	if not src then
		backpackltCtrl = nil
		;(nil).name = include("publicRead").getName(itemID)
		src = i18n("common_text_315", nil)
		ret = false
	end
	return ret, src
end
function itemLogic.checkItemNoTip(itemID, otherData)
	local itemType = backpackltCtrl:getItemType(itemID)
	if itemType == gItemType.TREASURE_CRYSTAL or itemType == gItemType.PANDORABOX then
		backpackltCtrl = nil
		;(nil).target = self
		;(nil).dataFromItem = otherData
		itemLogic.checkItemSpecial(itemID, 1, nil)
		return false
	else
		return true
	end
end
function itemLogic.useItemsLine(itemID, itemCount, otherData)
	local itemUseOne = function(eventType, target)
		if eventType == MSGBOX_CALLBACK_YES then
			_ENV = nil
			;(nil).target = target
			;(nil).dataFromItem = otherData
			if not itemLogic.checkItemSpecial(itemID, 1, nil) then
				local gametop = gModuleMgr.getObject("gametop")
				local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
				backpackCtrl:reqUseItem(itemID, 1)
			end
		end
	end
	local resultType = backpackltCtrl:getResultType(itemID)
	if itemLogic.checkUseCond(itemID, true) then
		if itemLogic.isItemSkinMakeSure(itemID) then
			itemUseOne(MSGBOX_CALLBACK_YES)
		elseif not itemLogic.checkItemSpecialBeforeUse(itemID) and backpackltCtrl:getUseMax(itemID) > 1 and itemCount ~= nil and 1 < itemCount then
			_ENV, _ENV = nil, nil
			;(nil).id = itemID
			;(nil).itemData, (nil).count = nil, itemCount
			;(nil).needResList = otherData and otherData.needResList
			uiManager:show("newItemSingleUse", nil)
		elseif backpackltCtrl:checkBuffStackingItem(itemID) then
			local buffCtrl = SoraDGetCtrl("buffCtrl")
			local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
			local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
			local buffID = backpackltCtrl:getResult(itemID)
			local buffEffect = buffltCtrl:getEffectType(buffID)
			local haveBuff = buffCtrl:queryCityBuff(buffEffect)
			local second = buffltCtrl:getTime(buffID)
			local effect, effectType = buffltCtrl:getEffect(buffID)
			local constantRead = include("constantRead")
			local buffStackingTime = constantRead.getConstValue("BUFF_STACKING_TIME", 86400)
			if haveBuff and (haveBuff:getProperty("id") == buffID or haveBuff:getProperty("effectType") == buffEffect and haveBuff:getProperty("effect") == effect) and buffStackingTime < haveBuff:getRemainTime() + second then
				_ENV = nil
				_ENV = nil
				;(nil).time = SoraDConvertSecondToStringHour(buffStackingTime)
				;(nil).content = i18n("common_text_4912", nil)
				;(nil).confirmString = i18n("common_text_204")
				;(nil).cancelString = i18n("common_text_185")
				;(nil).confirmFunc = function()
					local gametop = gModuleMgr.getObject("gametop")
					local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
					backpackCtrl:reqUseItem(itemID, 1)
				end
				uiManager:show("MessageBox", nil)
			else
				local ret, src = itemLogic.checkItemSpecialTip(itemID)
				SoraDShowMsgBox(src, i18n("common_text_204"), nil, itemUseOne)
			end
		else
			local ret, src = itemLogic.checkItemSpecialTip(itemID)
			SoraDShowMsgBox(src, i18n("common_text_204"), nil, itemUseOne)
		end
	end
end
function itemLogic.getSpecailItemInvalidTime(itemID)
	local itemType = backpackltCtrl:getItemType(itemID)
	local resultType = backpackltCtrl:getResultType(itemID)
	if resultType == gItemEffectDef.ANCIENT_FIRE or resultType == gItemEffectDef.ANCIENT_TREASURE or resultType == gItemEffectDef.ANCIENT_SHOVEL then
		local timer = clientEventMgr.getEventTimer(gActivityTimeActivityID.ANCIENT_TREASURE_ACTIVITY)
		if timer then
			return timer.timerNode.timer:getFinishTime()
		end
	elseif itemType == gItemType.WAR_TREASURE_DRUM or itemType == gItemType.WAR_TREASURE_VULN then
		local timer = clientEventMgr.getEventTimer(gActivityTimeActivityID.WAR_TREASURE_ACTIVITY)
		if timer then
			return timer.timerNode.timer:getFinishTime()
		end
	elseif itemType == gItemType.WISETUTOR_UNLOCK then
		local timer = clientEventMgr.getEventTimer(gActivityTimeActivityID.WISE_TUTOR_ACTIVITY)
		if timer then
			return timer.timerNode.timer:getFinishTime()
		end
	elseif itemType == gItemType.ARTISAN_UNLOCK then
		local timer = clientEventMgr.getEventTimer(gActivityTimeActivityID.ARTISAN_HOUSE_ACTIVITY)
		if timer then
			return timer.timerNode.timer:getFinishTime()
		end
	end
	return false
end
return itemLogic
