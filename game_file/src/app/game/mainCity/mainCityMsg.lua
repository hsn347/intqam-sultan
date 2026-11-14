local buildLogic = include("buildLogic")
local buildRead = include("buildDescribeRead")
local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local cityBuildFunction = include("cityBuildFunction")
local cityltCtrl = include("cityltCtrl")
local maincityDesRead = include("maincityDesRead")
local cityBuildConstDef = include("cityBuildConstDef")
local cityBuildCreator = include("cityBuildCreator")
local cityBuildViewDef = include("cityBuildViewDef")
local cityBuildHorseFlag = include("cityBuildHorseFlag")
local wallsCtrl = gametop.playertop_:getModule("wallsCtrl")
local timeRewardCtrl = gametop.playertop_:getModule("timeRewardCtrl")
local loginRewardCtrl = gametop.playertop_:getModule("loginRewardCtrl")
local kingdomWeatherCtrl = gametop.playertop_:getModule("kingdomWeatherCtrl")
local activityCtrl = gametop.playertop_:getModule("activityCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local buffCtrl = gametop.playertop_:getModule("buffCtrl")
local cityHorseCtrl = gametop.playertop_:getModule("cityHorseCtrl")
local cityBuildSpritePool = include("cityBuildSpritePool")
local cityBuildMgr = include("cityBuildMgr")
local dressltCtrl = include("dressltCtrl")
local activityCenterUICtrl = SoraDGetCtrl("activityCenterUICtrl")
local funUnlockRead = include("funUnlockRead")
local effectMainCityView = include("effectMainCityView")
local mainCityCreate = include("mainCityCreate")
local _ENV, mainCityMsg = "mainCityCreate", "mainCityCreate"
function mainCityMsg.registerMessage(mainCity)
	local self = mainCity
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_OFFSET_BUILD", handler(self, self.setOffsetContainerWithSelectBuild))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP", handler(self, self.setOffsetContainerWithBuildTip))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_BUILD_BTNENABLE", handler(self, self.seBuildBtnEnable))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_CREATE_BUILD", handler(self, self.createBuild))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_REMOVE_BUILD", handler(self, self.removeBuild))
	SoraDAddMessage(self, "MESSAGE_BUILD_UPGRADE", handler(self, self.upgradeBuild))
	SoraDAddMessage(self, "MESSAGE_BUILD_WORKING", handler(self, self.workBuild))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP", handler(self, self.addBuildTopTip))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP", handler(self, self.removeBuildTopTip))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_ADD_BUILD_ANIM_WORKER", handler(self, self.addAnimWorker))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_ANIM_WORKER", handler(self, self.removeAnimWorker))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_ADD_BUILD_WORK_DONE_EFFECT", handler(self, self.addBuildWorkDoneEffect))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_WORK_DONE_EFFECT", handler(self, self.removeBuildWorkDoneEffect))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_ADD_BUILD_COOLING_PANEL", handler(self, self.addBuildCoolingPanel))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_BUILDSTAR_COOLING_PANEL", handler(self, mainCityMsg.msgUpdateBuildStarCoolingPanel))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_BUILDSTAR_SECOND_QUEUE_COOLING_PANEL", handler(self, mainCityMsg.msgUpdateBuildStarSecondCoolingPanel))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_STATUEBRAVE_COOLING_PANEL", handler(self, mainCityMsg.msgUpdateBuildStatueBraveCoolingPanel))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_MAGIC_LAMP_COOLING_PANEL", handler(self, mainCityMsg.msgUpdateBuildMagicLampCoolingPanel))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_ENDLESSTREASURE_COOLING_PANEL", handler(self, mainCityMsg.msgUpdateEndlessTreasureCoolingPanel))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_COOLING_PANEL", handler(self, self.removeBuildCoolingPanel))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_REMOVE_STATUEBRAVE_COOLING_PANEL", handler(self, mainCityMsg.removeStarBraveStatueCoolingPanel))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_ADD_BUILD_ANIM_BOOST", handler(self, self.addBuildAnimBoost))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_ANIM_BOOST", handler(self, self.removeBuildAnimBoost))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP", handler(self, self.removeBuildTip))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP_HAND", handler(self, self.setOffsetContainerWithBuildTipHand))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP_HAND", handler(self, self.addBuildTopTipHand))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP_HAND", handler(self, self.removeBuildTopTipHand))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_ADD_TROOP_SOLIDER", handler(self, self.addTroopSolider))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_REMOVE_TROOP_SOLIDER", handler(self, self.removeTroopSolider))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_ENTER_MOVE_MODE", handler(self, self.enterMoveMode))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_LEAVE_MOVE_MODE", handler(self, self.leaveMoveMode))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_ADD_HARVEST_FLOATING", handler(self, self.addHarvestFloating))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_BUILD_QUEQUE_CALLBACK", handler(self, self.buildQueueCallback))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_DEMOLISH_BUILD", handler(self, self.demolishBuild))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_CANCEL_DEMOLISH_BUILD", handler(self, self.cancelDemolishBuild))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_CANCEL_UPGRADE_BUILD", handler(self, self.cancelUpgradeBuild))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_EXCHANGE_BUILD", handler(self, self.exchangeBuild))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_ADD_BUILD_PREVIEW", handler(self, self.addBuildPreview))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_PREVIEW", handler(self, self.removeBuildPreview))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_SHOW_HARVEST_ARMY_RESULT", handler(self, self.showHarvestArmyResult))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_BUILD_BTN_EVENT", handler(self, self.buildBtnEvent))
	SoraDAddMessage(self, "MESSAGE_SERVER_MAINCITYVIEW_ARMY_QUEUE_CALLBACK", handler(self, self.armyQueueCallback))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_SOLDIER_MATRIXS", handler(self, self.updateSoldierMatrixs))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UNLOCK_AREA", handler(self, self.msgUnLockArea))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_LOCK_AREA", handler(self, self.msgUpdateLockArea))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_ALLIANCE_HELP_LIST", handler(self, self.msgUpdateAllianceHelpList))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_SAVE_MAIN_CITY_POS", handler(self, self.msgSaveMainCityPos))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_ADD_MATOU_TIP", handler(self, self.addMatouTip))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_ADD_BUILD_EFFECT", handler(self, self.msgAddBuildEffect))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_EFFECT", handler(self, self.msgRemoveBuildEffect))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_ADD_BUILD_EFFECT_UPGRADE", handler(self, self.msgAddBuildEffectUpgrade))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_DELETE_MATOU_TIP", handler(self, self.removeMatouTip))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_WALL_VIEW", handler(self, self.msgUpdateWallView))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_WALL_EFFECT", handler(self, self.msgUpdateWallEffect))
	SoraDAddMessage(self, "MESSAGE_TIME_RECEIVEREWARD_SUCCESS", handler(self, self.msgReceiveOnlineBack))
	SoraDAddMessage(self, "MESSAGE_TIME_RECEIVEREWARD_CANRECEIVE", handler(self, self.initMatouData))
	SoraDAddMessage(self, "MESSAGE_CANCLE_TECHNOLOGY", handler(self, self.sMsgCancelTechnology))
	SoraDAddMessage(self, "MESSAGE_DAILYLOGIN_NOTIFY_DAILYREWARD", handler(self, self.initWithHuoChuangData))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_GO_TO_BUILD", handler(self, self.gotoBuild))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_MOVE_CAMERA_TO", handler(self, self.msgMoveCameraTo))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_ADD_BUILD_TIP_BOX", handler(self, self.msgAddBuildTipBox))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_HIDE_BUILD_TIP_BOX", handler(self, self.msgHideBuildTipBox))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_BUILD_TIP_BOX", handler(self, self.msgUpdateBuildTipBox))
	SoraDAddMessage(self, "MESSAGE_SERVER_UPDATE_IDLE_GUIDE", handler(self, self.updateIdlePop))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_LORD_SKILL_EFFECT", handler(self, self.showLordSkillEffect))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_WEATHER_NOTIFY_MSG", handler(self, self.weatherEffect))
	SoraDAddMessage(self, "MESSAEG_MANCITYYVIEW_SHOW_TURRET_LOCK", handler(self, self.msgShowTurretLock))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_HDIE_TURRET_LOCK", handler(self, self.msgHideTurretLock))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_SHOW_BUILD_LOCK", handler(self, self.msgShowBuildLock))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_HIDE_BUILD_LOCK", handler(self, self.msgHideBuildLock))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_SHOW_COMMUNITYCENTER_MSG", handler(self, self.msgShowCommunityCenterMsg))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_HIDE_COMMUNITYCENTER_MSG", handler(self, self.msgHideCommunityCenterMsg))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_FIRST_FIGHT_END", handler(self, self.msgFirstFightEnd))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_CLEAN_FIRST_FIGHT", handler(self, self.msgCleanFirstFight))
	SoraDAddMessage(self, "MESSAGE_MAINCITYGUIDE_ALLEND", handler(self, self.msgCleanMainCityGuide))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_GUARD_SOLDIER_BOX", handler(self, self.msgUpdateGuardSoldierBox))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_RESET_CONTENT_VIEW", handler(self, self.msgResetContentView))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_MERCHANT_VIEW", handler(self, self.msgUpdateMerchantView))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_NEW_COLLECTITEMS", handler(self, self.msgNewCollectItems))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_CELEBRATEGIFT_REFRESH", handler(self, self.initCelebrateGift))
	SoraDAddMessage(self, "MESSAGE_CASTLE_SKIN_CHANGE", handler(self, self.refreshCastleSkin))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_TOGGLE_DARK", handler(self, self.msgToggleDark))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_COMMUNITY_VIEW", handler(self, self.msgUpdateCommunityView))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_NIGHT_CFG", handler(self, self.msgUpdateNightCfg))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_BRAVESTATUE_VIEW", handler(self, self.msgUpdateBraveStatueView))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_NEBULA_PALACE", handler(self, self.msgUpdateBuildVisible))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.addHarvestEffect))
	SoraDAddMessage(self, "MESSAGE_MAINCITY_UPDATE_HARVEST_EFFECT", handler(self, self.addHarvestEffect))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_AUTO_COLLECT_RES", handler(self, self.msgAutoCollectRes))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_SHAKE_CONTROL", handler(self, self.msgNotifyShakeControl))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_SHOW_BULLETINBOARD_MSG", handler(self, self.msgShowBulletInBoardMsg))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_HIDE_BULLETINBOARD_MSG", handler(self, self.msgHideBulletInBoardMsg))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_JUMP", handler(self, self.msgJump))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_SHOW_TOP_TIP_ACTIVITY", handler(self, self.msgShowTopTipActivity))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_HIDE_TOP_TIP_ACTIVITY", handler(self, self.msgHideTopTipActivity))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_BOAT_TIP", handler(self, self.addBuildTopTipHuochuang))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_PET_SHOW", handler(self, self.msgUpdatePetShow))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_PET_TIP_BOX", handler(self, self.msgUpdatePetTipBox))
	SoraDAddMessage(self, "MESSAGE_MAGICLAMP_TOPTIP_UPDATE", handler(self, self.msgUpdateMagicLampTipBox))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_PYRAMID_BATTLE_MSG", handler(self, self.msgUpdatePyramidBattle))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_MOVETO_BUILDBYBID", handler(self, self.msgOpenBuildByBid))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_CHANGE_IMG_QUALITY", handler(self, self.msgChangeQuality))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_LOGINFINSH", handler(self, self.msgLoginFinish))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_LUA_WILL_OPEN", handler(self, self.msgwillOpen))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_ADD_NPC_TOP_TIP", handler(self, self.msgAddNpcTopTip))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_REMOVE_NPC_TOP_TIP", handler(self, self.msgRemoveNpcTopTip))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_HERO_APPOINT_TIP", handler(self, self.msgHeroAppointTopTip))
	SoraDAddMessage(self, "MESSAGE_MAINCITY_LION_MSG", handler(self, self.msgUpdateLion))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_ADD_CASTLE_GIFT_TOP_TIP", handler(self, self.msgAddCastleGiftTopTip))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_REMOVE_CASTLE_GIFT_TOP_TIP", handler(self, self.msgRemoveCastleGiftTopTip))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_ADD_ENDLESSTREASURE_TOP_TIP", handler(self, self.msgUpdateEndlessTreasureTopTip))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_REMOVE_ENDLESSTREASURE_TOP_TIP", handler(self, self.msgRemoveEndlessTreasureTopTip))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_ADD_WAREHOUSE_GIFT_TOP_TIP", handler(self, self.msgUpdateAllianceTreasureTopTip))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_REMOVE_WAREHOUSE_GIFT_TOP_TIP", handler(self, self.msgRemoveAllianceTreasureTopTip))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_ADD_EPICWAR_TOP_TIP", handler(self, self.msgUpdateEpicWarTopTip))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_REMOVE_EPICWAR_TOP_TIP", handler(self, self.msgRemoveEpicWarTopTip))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_ADD_PROMOTE_TOP_TIP", handler(self, self.msgUpdateArmyPromoteTopTip))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_REMOVE_PROMOTE_TOP_TIP", handler(self, self.msgRemoveArmyPromoteTopTip))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_ADD_DRILL_ARENA_TOP_TIP", handler(self, self.msgAddArenaTopTip))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_REMOVE_DRILL_ARENA_TOP_TIP", handler(self, self.msgRemoveArenaTopTip))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_ADD_SHELTER_TOP_TIP", handler(self, self.msgAddShelterTopTip))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_REMOVE_SHELTER_TOP_TIP", handler(self, self.msgRemoveShelterTopTip))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_FLAG_COOLING_PANEL", handler(self, self.msgUpdateFlagCoolingPanel))
	SoraDAddMessage(self, "MESSAGE_MAINCITY_VIEW_REMOVE_HARVEST_EFFECT", handler(self, self.msgRemoveHarvestEffect))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_HORSE_FLAG_UPDATE", handler(self, self.msgUpdateHorseFlag))
	SoraDAddMessage(self, "MESSAGE_FILE_DOWNLOAD_SUCCESS_BY_KEY", handler(self, self.msgMainCityDownloadSuccess))
	SoraDAddMessage(self, "MESSAGE_MAINCITY_PLAY_SOUND", handler(self, self.msgPlaySound))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_COLLECT_BATCH_RES", handler(self, self.msgCollectBatchRes))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_KIPCHAKS", handler(self, self.msgKipchaksUpdate))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_CURRENT_SHOWVIEW_HIDED", handler(self, self.msgCurrentShowViewHided))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_SHOW_COMMANDHALL_NPC", handler(self, mainCityMsg.msgShowCommandHallNpc))
	SoraDAddMessage(self, "MESSAGE_COMMANDHALL_INITDATA_UPDATE", handler(self, mainCityMsg.msgShowCommandHallBox))
	SoraDAddMessage(self, "MESSAGE_COMMANDHALL_COMMITTASK_UPDATE", handler(self, mainCityMsg.msgShowCommandHallBox))
	if IsArClient then
	else
		SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_MASTERY_COOLING_PANEL", handler(self, self.msgUpdateMasteryCoolingPanel))
		SoraDAddMessage(self, "MESSAGE_UPDATE_MASTERY_TOP_TIP", handler(self, self.msgUpdateMasteryTopTip))
	end
	SoraDAddMessage(self, "MESSAGE_BUILD_UPGRADE_MSG_BACK", handler(self, mainCityMsg.msgBuildUpgradeMsgBack))
	SoraDAddMessage(self, "MESSAGE_SETTING_QUALITY_CHANGE", handler(self, mainCityMsg.msgSettingQualityChange))
	fguiHelper.registMouseEvent(self.viewScrollView)
end
function mainCityMsg.msgNotifyShakeControl(mainCity, target, data)
	local self = mainCity
	if SoraDConfigGet("Game:GameOptionsView:shake~bool") then
		self:enableShack()
		print("开启摇一摇")
	else
		self:disableShack()
		print("关闭摇一摇")
	end
end
function mainCityMsg.msgReceiveOnlineBack(mainCity, target, data)
	local self = mainCity
	if data and data.err == gErrDef.Err_None then
		local gametop = gModuleMgr.getObject("gametop")
		local guideCtrl = gametop.playertop_:getModule("guideCtrl")
		guideCtrl:updateGuideModule(gGuideModule.ONLINE_REWARD)
		local panel = SoraDCreatePanel("animationGainItem")
		local reward = data.data.reward
		_ENV = nil
		;(nil).itemID = self.rewardOnline[1]
		;(nil).itemCount = self.rewardOnline[2]
		panel:initData(nil)
		panel:show()
		mainCityCreate.initMatouData(self)
	end
end
function mainCityMsg.addBuildWorkDoneEffect(mainCity, target, data)
	local self = mainCity
	local buildIndex = data.buildIndex
	if nil == buildIndex then
		return
	end
	local buildBtnName = "build_" .. buildIndex
	local buildBtn = self:getBufferNodeByName(buildBtnName)
	if nil == buildBtn then
		return
	end
	local x, y = buildBtn:getPosition()
	local buildWorkDoneEffect = include("cityBuildWorkDoneEffect")
	local buildWorkDoneEffectNode = buildWorkDoneEffect.new(getCCSPath("cityBuildWorkDoneEffect"))
	local buildWorkDoneEffectNodeName = "build_workDoneEffect_" .. buildIndex
	buildWorkDoneEffectNode:setName(buildWorkDoneEffectNodeName)
	buildWorkDoneEffectNode:setPosition(cc.p(x, y))
	buildWorkDoneEffectNode:addTo(self.containerView, 199)
	self:addToBufferNodeArrayByName(buildWorkDoneEffectNodeName, buildWorkDoneEffectNode)
end
function mainCityMsg.removeBuildWorkDoneEffect(mainCity, target, data)
	local self = mainCity
	local buildIndex = data.buildIndex
	if nil == buildIndex then
		return
	end
	local buildWorkDoneEffectNodeName = "build_workDoneEffect_" .. buildIndex
	local buildWorkDoneEffectNode = self:getBufferNodeByName(buildWorkDoneEffectNodeName)
	if nil == buildWorkDoneEffectNode then
		return
	end
	self:delBufferNodeByName(buildWorkDoneEffectNodeName)
	buildWorkDoneEffectNode:hideAnimation()
end
function mainCityMsg.msgUpdateFlagCoolingPanel(mainCity, target, data)
	local self = mainCity
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	local queue = queueCtrl:queryQueue(gQueueTypeDef.prompt_army)
	local buildIndex = data.buildIndex or cityBuildConstDef.OtherBuildDef.TroopFlag
	local tipNodeName = "build_coolingTip_" .. buildIndex
	if queue then
		gametop = buildIndex
		gametop, buildIndex.index = nil, buildIndex
		;(nil).armyid = queue.data.toArmyID
		buildIndex.data, (nil).armycount = nil, queue.data.count
		local coolingData = buildIndex
		gametop = nil
		;(nil).opType = "add"
		;(nil).coolingData = coolingData
		;(nil).buildIndex = buildIndex
		mainCityMsg.updateBuildCoolingPanel(mainCity, tipNodeName, nil)
	else
		gametop = tipNodeName
		tipNodeName.opType = "remove"
		tipNodeName.buildIndex = buildIndex
		mainCityMsg.updateBuildCoolingPanel(mainCity, tipNodeName, tipNodeName)
	end
end
function mainCityMsg.msgUpdateMasteryCoolingPanel(mainCity, target, data)
	local self = mainCity
	local queueCtrl = SoraDGetCtrl("queueCtrl")
	local queue = queueCtrl:queryQueue(gQueueTypeDef.build_mastery)
	local buildIndex = data.buildIndex or cityBuildConstDef.fixedBuildDef.Mastery
	local tipNodeName = "build_coolingTip_" .. buildIndex
	if queue then
		_ENV = buildIndex
		buildIndex.index = buildIndex
		_ENV, buildIndex.buildEntity = data.buildEntity, data.buildEntity
		data.buildEntity.bid = queue.data.bid
		buildIndex.data, data.buildEntity.lev = data.buildEntity, queue.data.curLev + 1
		local coolingData = buildIndex
		_ENV = nil
		;(nil).opType = "add"
		;(nil).coolingData = coolingData
		;(nil).buildIndex = buildIndex
		mainCityMsg.updateBuildCoolingPanel(mainCity, tipNodeName, nil)
	else
		_ENV = tipNodeName
		tipNodeName.opType = "remove"
		tipNodeName.buildIndex = buildIndex
		mainCityMsg.updateBuildCoolingPanel(mainCity, tipNodeName, tipNodeName)
	end
end
function mainCityMsg.msgUpdateBuildStarCoolingPanel(mainCity, target, data)
	local self = mainCity
	local buildIndex = data.buildIndex
	local buildEntity = data.buildEntity
	if nil == buildIndex then
		return
	end
	local tipNodeName = "buildStar_coolingTip_" .. buildIndex
	if buildEntity and buildEntity:getBuildStarQueue() then
		_ENV = buildEntity:getBuildStarQueue()
		buildEntity:getBuildStarQueue().index = buildIndex
		buildEntity:getBuildStarQueue().buildEntity = buildEntity
		local buildEntity:getBuildStarQueue().coolingType, coolingData = BUILD_COOLING_TYPE.BUILD_STAR, buildEntity:getBuildStarQueue()
		_ENV = nil
		;(nil).opType = "add"
		;(nil).coolingData = coolingData
		;(nil).buildIndex = buildIndex
		mainCityMsg.updateBuildCoolingPanel(mainCity, tipNodeName, nil)
	else
		_ENV = tipNodeName
		tipNodeName.opType = "remove"
		tipNodeName.buildIndex = buildIndex
		mainCityMsg.updateBuildCoolingPanel(mainCity, tipNodeName, tipNodeName)
	end
end
function mainCityMsg.msgUpdateBuildStarSecondCoolingPanel(mainCity, target, data)
	local self = mainCity
	local buildIndex = data.buildIndex
	local buildEntity = data.buildEntity
	if nil == buildIndex then
		return
	end
	local tipNodeName = "buildStar_coolingTip_" .. buildIndex
	if buildEntity and buildEntity:getBuildStarSecondQueue() then
		_ENV = buildEntity:getBuildStarSecondQueue()
		buildEntity:getBuildStarSecondQueue().index = buildIndex
		buildEntity:getBuildStarSecondQueue().buildEntity = buildEntity
		local buildEntity:getBuildStarSecondQueue().coolingType, coolingData = BUILD_COOLING_TYPE.BUILD_STAR_SECOND, buildEntity:getBuildStarSecondQueue()
		_ENV = nil
		;(nil).opType = "add"
		;(nil).coolingData = coolingData
		;(nil).buildIndex = buildIndex
		mainCityMsg.updateBuildCoolingPanel(mainCity, tipNodeName, nil)
	else
		_ENV = tipNodeName
		tipNodeName.opType = "remove"
		tipNodeName.buildIndex = buildIndex
		mainCityMsg.updateBuildCoolingPanel(mainCity, tipNodeName, tipNodeName)
	end
end
function mainCityMsg.msgUpdateBuildStatueBraveCoolingPanel(mainCity, target, data)
	local self = mainCity
	local buildIndex = data.buildIndex
	local buildEntity = data.buildEntity
	if nil == buildIndex then
		return
	end
	local tipNodeName = "buildStar_coolingTip_" .. buildIndex
	if buildEntity and buildEntity:getBuildStatueBraveQueue() then
		_ENV = buildEntity:getBuildStatueBraveQueue()
		buildEntity:getBuildStatueBraveQueue().index = buildIndex
		buildEntity:getBuildStatueBraveQueue().buildEntity = buildEntity
		local buildEntity:getBuildStatueBraveQueue().coolingType, coolingData = BUILD_COOLING_TYPE.BUILD_STATUE_BRAVE, buildEntity:getBuildStatueBraveQueue()
		_ENV = nil
		;(nil).opType = "add"
		;(nil).coolingData = coolingData
		;(nil).buildIndex = buildIndex
		mainCityMsg.updateBuildCoolingPanel(mainCity, tipNodeName, nil)
	else
		_ENV = tipNodeName
		tipNodeName.opType = "remove"
		tipNodeName.buildIndex = buildIndex
		mainCityMsg.updateBuildCoolingPanel(mainCity, tipNodeName, tipNodeName)
	end
end
function mainCityMsg.msgUpdateBuildMagicLampCoolingPanel(mainCity, target, data)
	local self = mainCity
	local buildIndex = data.buildIndex
	local buildEntity = data.buildEntity
	if nil == buildIndex or buildEntity == nil then
		return
	end
	local breakQueue, classQueue, strengthQueue, hatchUpQueue = buildEntity:getCoolingQueue()
	local checkBreakQueue = function()
		local tipNodeName = "magicLamp_break_coolingTip_" .. buildIndex
		if breakQueue ~= nil then
			buildIndex = breakQueue
			breakQueue.index = buildIndex
			breakQueue.buildEntity = buildEntity
			local breakQueue.coolingType, coolingData = BUILD_COOLING_TYPE.MAGIC_LAMP_BREAK, breakQueue
			buildIndex = nil
			;(nil).opType = "add"
			;(nil).coolingData = coolingData
			;(nil).buildIndex = buildIndex
			mainCityMsg.updateBuildCoolingPanel(mainCity, tipNodeName, nil)
		else
			buildIndex = tipNodeName
			tipNodeName.opType = "remove"
			tipNodeName.buildIndex = buildIndex
			mainCityMsg.updateBuildCoolingPanel(mainCity, tipNodeName, tipNodeName)
		end
	end
	local checkElseQueue = function()
		local tipNodeName = "magicLamp_strength_coolingTip_" .. buildIndex
		if classQueue ~= nil then
			buildIndex = classQueue
			classQueue.index = buildIndex
			classQueue.buildEntity = buildEntity
			local classQueue.coolingType, coolingData = BUILD_COOLING_TYPE.MAGIC_LAMP_CLASS, classQueue
			buildIndex = nil
			;(nil).opType = "add"
			;(nil).coolingData = coolingData
			;(nil).buildIndex = buildIndex
			mainCityMsg.updateBuildCoolingPanel(mainCity, tipNodeName, nil)
		end
		if strengthQueue ~= nil then
			buildIndex = strengthQueue
			strengthQueue.index = buildIndex
			strengthQueue.buildEntity = buildEntity
			local strengthQueue.coolingType, coolingData = BUILD_COOLING_TYPE.MAGIC_LAMP_STRENGTH, strengthQueue
			buildIndex = nil
			;(nil).opType = "add"
			;(nil).coolingData = coolingData
			;(nil).buildIndex = buildIndex
			mainCityMsg.updateBuildCoolingPanel(mainCity, tipNodeName, nil)
		end
		if hatchUpQueue ~= nil then
			buildIndex = hatchUpQueue
			hatchUpQueue.index = buildIndex
			hatchUpQueue.buildEntity = buildEntity
			local hatchUpQueue.coolingType, coolingData = BUILD_COOLING_TYPE.MAGIC_LAMP_HATCH_UPGRADE, hatchUpQueue
			buildIndex = nil
			;(nil).opType = "add"
			;(nil).coolingData = coolingData
			;(nil).buildIndex = buildIndex
			mainCityMsg.updateBuildCoolingPanel(mainCity, tipNodeName, nil)
		end
		if strengthQueue == nil and classQueue == nil and hatchUpQueue == nil then
			buildIndex = tipNodeName
			tipNodeName.opType = "remove"
			tipNodeName.buildIndex = buildIndex
			mainCityMsg.updateBuildCoolingPanel(mainCity, tipNodeName, tipNodeName)
		end
	end
	checkElseQueue()
	checkBreakQueue()
end
function mainCityMsg.msgUpdateEndlessTreasureCoolingPanel(mainCity, target, data)
	local self = mainCity
	local buildIndex = data.buildIndex
	local buildEntity = data.buildEntity
	if nil == buildIndex then
		return
	end
	local tipNodeName = "endlessTreasure_coolingTip_" .. buildIndex
	local queueCtrl = SoraDGetCtrl("queueCtrl")
	local queue = queueCtrl:queryQueue(gQueueTypeDef.endless_treasure_queue)
	if buildEntity and queue and queue.timerNode.timer:getRemainTime() > 0 then
		_ENV = queue.timerNode.timer:getRemainTime()
		queue.timerNode.timer:getRemainTime().index = buildIndex
		queue.timerNode.timer:getRemainTime().buildEntity = buildEntity
		local queue.timerNode.timer:getRemainTime().coolingType, coolingData = BUILD_COOLING_TYPE.DIG_TREASURE, queue.timerNode.timer:getRemainTime()
		_ENV = nil
		;(nil).opType = "add"
		;(nil).coolingData = coolingData
		;(nil).buildIndex = buildIndex
		mainCityMsg.updateBuildCoolingPanel(mainCity, tipNodeName, nil)
	else
		_ENV = tipNodeName
		tipNodeName.opType = "remove"
		tipNodeName.buildIndex = buildIndex
		mainCityMsg.updateBuildCoolingPanel(mainCity, tipNodeName, tipNodeName)
	end
end
function mainCityMsg.updateBuildCoolingPanel(mainCity, tipNodeName, otherData)
	local self = mainCity
	if otherData.opType == "add" then
		local tipNode = self:getBufferNodeByName(tipNodeName)
		if tipNode then
			return
		end
		local buildCoolingTip = include("cityBuildCoolingTip")
		tipNode = buildCoolingTip.new(getCCSPath("cityCoolingTip"))
		tipNode:setName(tipNodeName)
		tipNode:addTo(self.containerView, 1050)
		self:addToBufferNodeArrayByName(tipNodeName, tipNode)
		tipNode:setVisible(true)
		tipNode:initData(otherData.coolingData)
		tipNode:beginCooling()
	else
		local tipNode = self:getBufferNodeByName(tipNodeName)
		self:delBufferNodeByName(tipNodeName)
		if tipNode then
			tipNode:removeFromParent()
		end
	end
	mainCityMsg.updateCoolingPanelPos(self, otherData.buildIndex)
end
function mainCityMsg.getCoolingPanelPos(mainCity, buildIndex)
	local self = mainCity
	local x, y = 0, 0
	local buildBtnName = "build_" .. buildIndex
	local buildBtn = self:getBufferNodeByName(buildBtnName)
	if tonumber(buildIndex) == cityBuildConstDef.OtherBuildDef.TroopFlag then
		buildBtn = self.buttonMilitaryInfo
	end
	if nil == buildBtn then
		return x, y
	end
	x, y = buildBtn:getPosition()
	if tonumber(buildIndex) == cityBuildConstDef.fixedBuildDef.Mastery then
		y = y - 90
	elseif tonumber(buildIndex) == cityBuildConstDef.OtherBuildDef.TroopFlag then
		y = y - 120
	else
		y = y - 60
	end
	local buildCell = cityCtrl:getBuildCellByIndex(buildIndex)
	if buildCell ~= nil then
		local bid = tonumber(buildCell.info.bid)
		if bid == BUILDID.WALLS then
			y = y - 80
		elseif bid == BUILDID.TURRET then
			y = y - 80
		elseif bid == BUILDID.CRYSTAL_MINE then
			y = y + 60
		elseif bid == BUILDID.HERO_TRAIN_GROUND then
			y = y - 40
		elseif bid == BUILDID.STAR_BRAVE_STATUE then
			y = y - 70
		end
	end
	return x, y
end
function mainCityMsg.updateCoolingPanelPos(mainCity, buildIndex)
	local self = mainCity
	local x, y = mainCityMsg.getCoolingPanelPos(mainCity, buildIndex)
	local tipName1 = "build_coolingTip_" .. buildIndex
	local tipNode1 = self:getBufferNodeByName(tipName1)
	local tipName2 = "buildStar_coolingTip_" .. buildIndex
	local tipNode2 = self:getBufferNodeByName(tipName2)
	_UPVALUE3_ = self
	self[1] = "build_coolingTip_" .. buildIndex
	self[2] = "buildStar_coolingTip_" .. buildIndex
	local self[3], config = "teach_coolingTip_" .. buildIndex, self
	for _, tipName in ipairs(config) do
		local tipNode = self:getBufferNodeByName(tipName)
		if tipNode then
			tipNode:setPosition(x, y)
			y = y - 66
		end
	end
	local tipName3 = "endlessTreasure_coolingTip_" .. buildIndex
	local tipNode3 = self:getBufferNodeByName(tipName3)
	if not tipNode1 or not tipNode2 then
		if tipNode3 then
			tipNode3:setVisible(true)
			tipNode3:setPosition(x, y)
			y = y - 66
		end
	elseif tipNode3 then
		tipNode3:setVisible(false)
	end
	local tipName4 = "magicLamp_break_coolingTip_" .. buildIndex
	local tipNode4 = self:getBufferNodeByName(tipName4)
	local tipName5 = "magicLamp_strength_coolingTip_" .. buildIndex
	local tipNode5 = self:getBufferNodeByName(tipName5)
	if tipNode4 and tipNode5 then
		local queue1 = tipNode4:getQueue()
		local queue2 = tipNode5:getQueue()
		if queue1.starttime < queue2.starttime then
			tipNode4:setPosition(x, y)
			y = y - 66
			tipNode5:setPosition(x, y)
			y = y - 66
		else
			tipNode5:setPosition(x, y)
			y = y - 66
			tipNode4:setPosition(x, y)
			y = y - 66
		end
	else
		if tipNode5 then
			tipNode5:setPosition(x, y)
			y = y - 66
		end
		if tipNode4 then
			tipNode4:setPosition(x, y)
			y = y - 66
		end
	end
end
function mainCityMsg.addBuildCoolingPanel(mainCity, target, data)
	local self = mainCity
	local buildIndex = data.buildIndex
	local buildEntity = data.buildEntity
	if nil == buildIndex then
		return
	end
	local mainCityMsg, tipNodeName = buildIndex, data.tipNodeName or "build_coolingTip_" .. buildIndex
	buildIndex.index = buildIndex
	buildIndex.buildEntity = buildEntity
	local buildIndex.coolingType, coolingData = data.coolingType, buildIndex
	mainCityMsg = nil
	;(nil).opType = "add"
	;(nil).coolingData = coolingData
	;(nil).buildIndex = buildIndex
	mainCityMsg.updateBuildCoolingPanel(mainCity, tipNodeName, nil)
	if SoraDIsGameGuide() == nil then
		local guideCtrl = gametop.playertop_:getModule("guideCtrl")
		if guideCtrl:isGuideNotCompleted(gGuideModule.BUILD_SPEED_UP) then
			local lv = SoraDGetCastleLv()
			if lv >= CASTLE_LV3_LIMITED and lv <= CASTLE_LV4_LIMITED and buildIndex == 1050 then
				local queue = buildEntity:getQueue()
				local bid = buildEntity:getBuildBid()
				local remainTime = queue.timerNode.timer:getRemainTime()
				local freeSpeedUpTime = buildLogic.getFreeSpeedUpTime(lv)
				if remainTime > freeSpeedUpTime then
					local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
					if backpackCtrl:getItemCount(501101) > 0 then
						guideCtrl:updateGuideModule(gGuideModule.BUILD_SPEED_UP)
					end
				end
			elseif lv > CASTLE_LV5_LIMITED then
				guideCtrl:CompleteGuideStep()
			end
		end
	end
end
function mainCityMsg.removeBuildCoolingPanel(mainCity, target, data)
	local self = mainCity
	local buildIndex = data.buildIndex
	local isCancel = data.isCancel
	local isReconnect = data.isReconnect
	local queueType = data.queueType
	if nil == buildIndex then
		return
	end
	local tipNodeName = data.tipNodeName or "build_coolingTip_" .. buildIndex
	local buildCoolingTipNode = self:getBufferNodeByName(tipNodeName)
	if nil == buildCoolingTipNode then
		if isReconnect then
			return
		end
		local buildBtnName = "build_" .. buildIndex
		local buildBtn = self:getBufferNodeByName(buildBtnName)
		if buildBtn == nil then
			return
		end
		local buildEntity = buildBtn:getChildByName("buildName")
		if buildEntity == nil then
			return
		end
		local bid = buildEntity:getBuildBid()
		local iid = buildEntity:getIid()
		if buildEntity.fsm_:getState() == "working" then
			if bid == BUILDID.HOSTPITAL then
				buildEntity:setBlockState("idle")
			else
				buildEntity:setBlockState("harvesting")
			end
			buildEntity:changeState()
		elseif buildEntity.fsm_:getState() == "building" then
			buildEntity:setBlockState("idle")
			buildEntity:changeState()
		end
		if buildEntity:getIsCanHarvestTrain() then
			buildEntity:setBlockState("harvesting")
			buildEntity:changeState()
			buildEntity:setIsWaitTraining(false)
		end
		buildEntity:updateLv()
		if bid == BUILDID.WISHING_WELL then
			_ENV = buildEntity
			buildEntity.msg = "MESSAGE_MAINCITYVIEW_UPDATE_WISHINGWELL_VIEW"
			SoraDSendMessage(buildEntity)
		end
		if bid == BUILDID.EMBASSY then
			_ENV = buildEntity
			buildEntity.msg = "MESSAGE_MAINCITYVIEW_UPDATE_ALLIANCE_HELP_LIST"
			SoraDSendMessage(buildEntity)
		end
		if bid == BUILDID.MARKET then
			_ENV = buildEntity
			buildEntity.msg = "MESSAGE_MARKET_UPDATE_GUIDE"
			SoraDSendMessage(buildEntity)
		end
		if bid == BUILDID.DRILL_GROUDS then
			_ENV = buildEntity
			buildEntity.msg = "MESSAGE_SERVER_ARENA_BUILDGUIDE"
			SoraDSendMessage(buildEntity)
		end
		return
	else
		if not isReconnect then
			local buildEntity = self:getBuildByIndex(buildIndex)
			if buildEntity then
				buildEntity:setIsCancel(isCancel)
				buildEntity:setCostRes(data.costres)
				local bid = buildEntity:getBuildBid()
				if (bid == BUILDID.COLLEGE or bid == BUILDID.MIRACLE or bid == BUILDID.STAR_BRAVE_STATUE) and buildEntity.fsm_:getState() == "working" and not buildEntity:getIsCancel() then
					local isTobag = bid == BUILDID.STAR_BRAVE_STATUE and (not queueType or queueType ~= gQueueTypeDef.craft_study)
					self:trainArmyFinishEffect(cc.p(buildCoolingTipNode:getPositionX(), buildCoolingTipNode:getPositionY()), true, isTobag)
				end
			end
		end
		if not isReconnect then
			buildCoolingTipNode:endCooling()
		end
		_ENV = self.trainArmyFinishEffect
		self.trainArmyFinishEffect.opType = "remove"
		self.trainArmyFinishEffect.buildIndex = buildIndex
		mainCityMsg.updateBuildCoolingPanel(mainCity, tipNodeName, self.trainArmyFinishEffect)
		local buildEntity = self:getBuildByIndex(buildIndex)
		if buildEntity then
			local bid = buildEntity:getBuildBid()
			if bid == BUILDID.MARKET then
				_ENV = self.trainArmyFinishEffect
				self.trainArmyFinishEffect.msg = "MESSAGE_MAINCITYVIEW_UPDATE_MARKET_VIEW"
				SoraDSendMessage(self.trainArmyFinishEffect)
			end
			if bid == BUILDID.DRILL_GROUDS then
				_ENV = self.trainArmyFinishEffect
				self.trainArmyFinishEffect.msg = "MESSAGE_MAINCITYVIEW_UPDATE_DRILL_VIEW"
				SoraDSendMessage(self.trainArmyFinishEffect)
			end
		end
	end
end
function mainCityMsg.removeStarBraveStatueCoolingPanel(mainCity, target, data)
	local self = mainCity
	local buildIndex = data.buildIndex
	local isReconnect = data.isReconnect
	if nil == buildIndex then
		return
	end
	local tipNodeName = "buildStar_coolingTip_" .. buildIndex
	local buildCoolingTipNode = self:getBufferNodeByName(tipNodeName)
	if buildCoolingTipNode then
		mainCityMsg = nil
		;(nil).opType = "remove"
		;(nil).buildIndex = buildIndex
		mainCityMsg.updateBuildCoolingPanel(mainCity, tipNodeName, nil)
	end
end
function mainCityMsg.addBuildTopTipHand(mainCity, target, data)
	local self = mainCity
	local buildIndex = data.buildIndex
	local fixedBuildIndex = data.fixedBuildIndex
	if nil == buildIndex and fixedBuildIndex == nil then
		return
	end
	local buildBtn
	local xOffset = 40
	local yOffset = 110
	if buildIndex ~= nil then
		if buildIndex == cityBuildConstDef.OtherBuildDef.ActivityCenter then
			buildBtn = self:getBufferNodeByName("Button_Activity")
		elseif buildIndex == cityBuildConstDef.OtherBuildDef.Gangkou then
			buildBtn = self.buttonMaTou
			yOffset = 60
		elseif buildIndex == cityBuildConstDef.OtherBuildDef.Merchant then
			buildBtn = self.buttonMerchante
			xOffset = 100
		else
			local buildBtnName = "build_" .. buildIndex
			buildBtn = self:getBufferNodeByName(buildBtnName)
		end
	elseif fixedBuildIndex ~= nil then
		if fixedBuildIndex == cityBuildConstDef.fixedBuildDef.LeisureCenter then
			buildBtn = self.buttonLeisureCenter
		elseif fixedBuildIndex == cityBuildConstDef.fixedBuildDef.HuoChuang then
			buildBtn = self.buttonHuoChuang
		elseif fixedBuildIndex == cityBuildConstDef.buildIndexDef.index_PetCenter then
			buildBtn = self.buttonPetCenter
		elseif fixedBuildIndex == cityBuildConstDef.buildIndexDef.index_EpicBattle then
			buildBtn = self.buttonEpicBattle
		else
			buildBtn = self:getBufferNodeByName("build_" .. fixedBuildIndex)
		end
	end
	if nil == buildBtn then
		return
	end
	local buildTopTipHandNodeName = "build_topTipHand_" .. "single"
	local buildTopTipHandNode = self.containerView:getChildByName(buildTopTipHandNodeName)
	if buildTopTipHandNode then
		buildTopTipHandNode:removeFromParent()
	end
	local x, y = buildBtn:getPosition()
	local buildTopTipHandNode = SoraDFingerAction(true, false, 5)
	buildTopTipHandNode:setName(buildTopTipHandNodeName)
	buildTopTipHandNode:setPosition(cc.p(x + xOffset - 40, y + yOffset - 100))
	buildTopTipHandNode:addTo(self.containerView, 1400)
end
function mainCityMsg.removeBuildTopTipHand(mainCity, target, data)
	local self = mainCity
	local buildTopTipHandName = "build_topTipHand_" .. "single"
	local buildTopTipHandNode = self.containerView:getChildByName(buildTopTipHandName)
	if buildTopTipHandNode then
		buildTopTipHandNode:removeFromParent()
	end
end
function mainCityMsg.createBuild(mainCity, target, data)
	local self = mainCity
	local buildID = data.buildID
	local buildCfgID = data.buildCfgID
	self:addBuild(buildID, buildCfgID)
	effectMainCityView.addHarvestEffect(self)
end
function mainCityMsg.removeBuild(mainCity, target, data)
	local self = mainCity
	local buildIndex = data.index
	local buildBtnName = "build_" .. buildIndex
	local buildButton = self:getBufferNodeByName(buildBtnName)
	if nil == buildButton then
		return
	end
	local buildType = SoraDGetBuildTypeByIndex(buildIndex)
	if buildType == 1 then
		self:addBuildTile(buildButton)
	else
		local buildTile = self:getBufferNodeByName("Build_Tile_" .. buildIndex)
		if buildTile then
			buildTile:setVisible(true)
		end
	end
	if buildButton then
		local buildContentNode = SoraDGetChildByName(buildButton, "buildName")
		if nil ~= buildContentNode then
			_ENV = "buildName"
			;("buildName").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
			;("buildName").buildIndex = buildIndex
			SoraDSendMessage("buildName")
			_ENV = "buildName"
			;("buildName").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_ANIM_WORKER"
			;("buildName").buildIndex = buildIndex
			SoraDSendMessage("buildName")
			_ENV = "buildName"
			;("buildName").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_ANIM_BOOST"
			;("buildName").buildIndex = buildIndex
			SoraDSendMessage("buildName")
			_ENV = "buildName"
			;("buildName").msg = "MESSAGE_MAINCITY_VIEW_REMOVE_HARVEST_EFFECT"
			;("buildName").buildIndex = buildIndex
			SoraDSendMessage("buildName")
			buildContentNode:removeNodeRelyOn()
			buildContentNode:recycleNode()
			buildButton:removeChildByName("buildName")
			effectMainCityView.addHarvestEffect(self)
		end
	end
	effectMainCityView.updateNightScene(self)
end
function mainCityMsg.upgradeBuild(mainCity, target, data)
	local self = mainCity
	local buildID = data.index
	local buildCfgID = data.bid
	if buildID == nil or buildCfgID == nil then
		return
	end
	if self.currentSelectBuild then
		_ENV = nil
		;(nil).buildIndex = buildID
		self:removeBuildTip(nil, nil)
	end
	local buildButton = self:getBufferNodeByName("build_" .. buildID)
	if buildButton ~= nil then
		local buildNode = SoraDGetChildByName(buildButton, "buildName")
		if buildNode then
			buildNode:setBlockState("building")
			buildNode:changeState()
		end
	end
	if BUILDID.CASTLE == buildCfgID then
		mainCityCreate.initMatouData(self)
		_ENV = self
		self.msg = "MESSAGE_LORDINFO_BIND_AWARD"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_CASTLE_LEVELUP"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_ADD_CASTLE_GIFT_TOP_TIP"
		SoraDSendMessage(self)
		if SoraDGetCastleLv() >= CASTLE_LV3_LIMITED and not SoraDCurrentTopPanelFromManager() then
			local guideCtrl = SoraDGetCtrl("guideCtrl")
			if not guideCtrl:updateGuideModule(gGuideModule.OVERVIEW) then
				print("触发总览引导")
			end
		end
	end
	if buildCfgID == BUILDID.DEPOT then
		local gametop = gModuleMgr.getObject("gametop")
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local depotBcell = cityCtrl:getBuildCell(BUILDID.DEPOT, 0)
		if tonumber(depotBcell.info.lv) == DEPOT_LV_ALLIANCE_TRRASURE then
			_ENV = DEPOT_LV_ALLIANCE_TRRASURE
			DEPOT_LV_ALLIANCE_TRRASURE.msg = "MESSAGE_ALLIANCE_TREASURE_PANDECT_REFRESH"
			SoraDSendMessage(DEPOT_LV_ALLIANCE_TRRASURE)
		end
	end
	_ENV = gametop.playertop_:getModule("cityCtrl")
	gametop.playertop_:getModule("cityCtrl").msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
	gametop.playertop_:getModule("cityCtrl").eventID = gActivityTimeActivityID.ORIENT_PRINCE_GIFT
	SoraDSendMessage((gametop.playertop_:getModule("cityCtrl")))
end
function mainCityMsg.setOffsetContainerWithBuildTip(mainCity, target, data)
	local self = mainCity
	if data.offsetType == MAINCITYVIEW_OFFSET_TYPE_BUILD_TIP then
		if self.currentSelectBuild == nil then
			return
		end
		self:doBuildOffset(self.currentSelectBuild)
	elseif data.offsetType == MAINCITYVIEW_OFFSET_TYPE_RECOVER_TIP then
		self.viewScrollView:setContentOffset(self.preContainerOffsetTip, true)
	end
end
function mainCityMsg.seBuildBtnEnable(mainCity, target, data)
	local self = mainCity
	self:stopActionByTag(cityBuildConstDef.ActionTag.Tag_delayBuildBtnEnable)
	self.isBuildBtnEnable = data.isBuildBtnEnable
	if data.delay then
		_ENV = nil
		;(nil)[1] = cca.delay(data.delay)
		;(nil)[2] = cca.callFunc(function()
			self.isBuildBtnEnable = true
		end)
		;(nil)[3] = cca.callFunc(function()
			self.isBuildBtnEnable = true
		end)
		self:runAction(cca.seq(nil))
	end
end
function mainCityMsg.setOffsetContainerWithBuildTipHand(mainCity, target, data)
	local self = mainCity
	local offsetType = data.offsetType
	local bid = data.bid
	local iid = data.iid
	local isLockArea = data.isLockArea
	local isRecover = data.isRecover
	local buildIndex = data.buildIndex
	local delay = data.delay
	local fixedBuildIndex = data.fixedBuildIndex
	if isRecover then
		self.isNeedRecover = false
		if self.preZoomScale then
			self:setZoomScale(self.preZoomScale, false)
		end
	end
	self:stopScrollContainer()
	self:stopActionByTag(cityBuildConstDef.ActionTag.Tag_delayUpdateMainCityPos)
	if buildIndex ~= nil then
		local targetButton
		if buildIndex == cityBuildConstDef.OtherBuildDef.ActivityCenter then
			targetButton = self.buttonActivity
		elseif buildIndex == cityBuildConstDef.OtherBuildDef.Gangkou then
			targetButton = self.buttonMaTou
		elseif buildIndex == cityBuildConstDef.OtherBuildDef.Merchant then
			targetButton = self.buttonMerchante
		else
			targetButton = self:getBufferNodeByName("build_" .. buildIndex)
		end
		local offset = self:getContainerOffsetWhenCenterTarget(targetButton, true)
		local currentOffset = self.viewScrollView:getContentOffset()
		local duration = delay or self:getAnimDuration(currentOffset, offset, 3000)
		self:disableMoveForDuration(duration)
		self.viewScrollView:setContentOffsetInDuration(offset, duration)
		cityBuildConstDef = self.viewScrollView
		self.viewScrollView.msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP_HAND"
		self.viewScrollView.buildIndex = buildIndex
		SoraDSendMessage(self.viewScrollView)
		return
	end
	if fixedBuildIndex ~= nil then
		local targetButton
		if fixedBuildIndex == cityBuildConstDef.fixedBuildDef.LeisureCenter then
			targetButton = self.buttonLeisureCenter
		elseif fixedBuildIndex == cityBuildConstDef.fixedBuildDef.HuoChuang then
			targetButton = self.buttonHuoChuang
		elseif fixedBuildIndex == cityBuildConstDef.buildIndexDef.index_PetCenter then
			targetButton = self.buttonPetCenter
		elseif fixedBuildIndex == cityBuildConstDef.buildIndexDef.index_EpicBattle then
			targetButton = self.buttonEpicBattle
		else
			targetButton = self:getBufferNodeByName("build_" .. fixedBuildIndex)
		end
		local offset = self:getContainerOffsetWhenCenterTarget(targetButton, true)
		local currentOffset = self.viewScrollView:getContentOffset()
		local duration = delay or self:getAnimDuration(currentOffset, offset, 3000)
		self:disableMoveForDuration(duration)
		self.viewScrollView:setContentOffsetInDuration(offset, duration)
		cityBuildConstDef = self.viewScrollView
		self.viewScrollView.msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP_HAND"
		self.viewScrollView.fixedBuildIndex = fixedBuildIndex
		SoraDSendMessage(self.viewScrollView)
		return
	end
	if isLockArea then
		self:gotoLockArea(delay)
		return
	end
	local gotomax = false
	if iid == nil then
		gotomax = true
	end
	if offsetType == nil then
		return
	end
	if offsetType == MAINCITYVIEW_OFFSET_TYPE_BUILD_TIP_HAND then
		local buildLogic = include("buildLogic")
		local buildRead = include("buildDescribeRead")
		local gametop = gModuleMgr.getObject("gametop")
		if buildLogic == nil or buildRead == nil or gametop == nil then
			return
		end
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local buildCell
		if gotomax == true then
			local maxLv, maxLvIid = cityCtrl:getBuildMaxLv(bid)
			buildCell = cityCtrl:getBuildCell(bid, maxLvIid)
		else
			buildCell = cityCtrl:getBuildCell(bid, iid)
		end
		local bIndex = 0
		if nil == buildCell then
			if bid == BUILDID.MATERIAL_WORKSHOP then
				bIndex = cityBuildConstDef.buildIndexDef.index_Material_WorkShop
			elseif bid == BUILDID.MIRACLE then
				bIndex = cityBuildConstDef.buildIndexDef.index_Miracle
			else
				local index = self:getCanBuildIndexByBid(bid)
				if index == 0 then
					self:gotoLockArea(delay)
					return
				else
					bIndex = index
				end
			end
		else
			bIndex = buildCell.info.index
		end
		local buildName = "build_" .. bIndex
		local build = self:getBufferNodeByName(buildName)
		local zoomScale = self:getZoomScale()
		local offset = self:getContainerOffsetWhenCenterTarget(build, true)
		local currentOffset = self.viewScrollView:getContentOffset()
		local duration = delay or self:getAnimDuration(currentOffset, offset)
		self:disableMoveForDuration(duration)
		self.viewScrollView:setContentOffsetInDuration(offset, duration)
		cityBuildConstDef = self.viewScrollView
		self.viewScrollView.msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP_HAND"
		self.viewScrollView.buildIndex = bIndex
		SoraDSendMessage(self.viewScrollView)
	elseif offsetType == MAINCITYVIEW_OFFSET_TYPE_BUILD_NO_HAND then
		local buildLogic = include("buildLogic")
		local buildRead = include("buildDescribeRead")
		local gametop = gModuleMgr.getObject("gametop")
		if buildLogic == nil or buildRead == nil or gametop == nil then
			return
		end
		if gametop == nil then
			return
		end
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local buildCell
		if gotomax == true then
			local maxLv, maxLvIid = cityCtrl:getBuildMaxLv(bid)
			buildCell = cityCtrl:getBuildCell(bid, maxLvIid)
		else
			buildCell = cityCtrl:getBuildCell(bid, iid)
		end
		local bIndex = 0
		if nil == buildCell then
			local index = self:getCanBuildIndexByBid(bid)
			if index == 0 then
				self:gotoLockArea(delay)
				return
			else
				bIndex = index
			end
		else
			bIndex = buildCell.info.index
		end
		local buildName = "build_" .. bIndex
		local build = self:getBufferNodeByName(buildName)
		local offset = self:getContainerOffsetWhenCenterTarget(build, true)
		local currentOffset = self.viewScrollView:getContentOffset()
		local duration = delay or self:getAnimDuration(currentOffset, offset)
		self:disableMoveForDuration(duration)
		self.viewScrollView:setContentOffsetInDuration(offset, duration)
	end
end
function mainCityMsg.setOffsetContainerWithSelectBuild(mainCity, target, data)
	local self = mainCity
	if data.offsetType == MAINCITYVIEW_OFFSET_TYPE_BUILD then
		local buildIndex = data.buildIndex
		local buildBtn = data.buildBtn
		local scale = data.scale
		local noOffsetDuration = data.noOffsetDuration
		local noScaleDuration = data.noScaleDuration
		local skip = data.skip
		if self.currentSelectBuild == nil and buildIndex == nil then
			return
		else
			local build
			if buildIndex ~= nil then
				build = self:getBufferNodeByName("build_" .. buildIndex)
			end
			if build == nil then
				build = self.currentSelectBuild
			end
			if build == nil then
				return
			end
			if skip then
				scale = self.preZoomScale
			end
			self.isNeedRecover = true
			local buildIndex = build:getTag()
			local buildType = SoraDGetBuildTypeByIndex(buildIndex)
			if buildType == 0 then
				_ENV = nil
				;(nil).noScaleDuration = noScaleDuration
				;(nil).noOffsetDuration = noOffsetDuration
				;(nil).offsetType = data.offsetType
				;(nil).xOffset = data.xOffset
				;(nil).yOffset = data.yOffset
				;(nil).skip = skip
				;(nil).ignorePreZoomScale = data.ignorePreZoomScale
				self:doOffsetContainerWithSelectBuild(build, scale or 1.0, nil)
			else
				_ENV = nil
				;(nil).noScaleDuration = noScaleDuration
				;(nil).noOffsetDuration = noOffsetDuration
				;(nil).offsetType = data.offsetType
				;(nil).xOffset = data.xOffset
				;(nil).yOffset = data.yOffset
				;(nil).skip = skip
				;(nil).ignorePreZoomScale = data.ignorePreZoomScale
				self:doOffsetContainerWithSelectBuild(build, scale or 1.3, nil)
			end
			return
		end
	elseif data.offsetType == MAINCITYVIEW_OFFSET_TYPE_LOCK_AREA then
		local areaid = data.areaid
		if areaid then
			local lockAreaName = "Panel_Area_Lock_" .. areaid
			local panelLockArea = self:getBufferNodeByName(lockAreaName)
			if panelLockArea then
				self.isNeedRecover = true
				self:doOffsetContainerWithSelectBuild(panelLockArea)
			end
		end
	elseif data.offsetType == MAINCITYVIEW_OFFSET_TYPE_RECOVER then
		if self.isNeedRecover == false then
			return
		end
		local scale = self.preZoomScale
		local offset = self.preContainerOffset
		self:setZoomScale(scale, true, self.zoomScaleDuration, true)
		local zoomScale = self.viewScrollView:getZoomScale()
		self:runContainerViewMove(offset, self.zoomScaleDuration)
		self:disableMoveForDuration(self.zoomScaleDuration)
		self.isNeedRecover = false
	end
end
function mainCityMsg.removeBuildTip(mainCity, target, data)
	local self = mainCity
	local buildIndex
	if data ~= nil then
		buildIndex = data.buildIndex
	end
	if buildIndex ~= nil then
		if self.cacheTip then
			self.cacheTip:hideTip()
		else
		end
		if self.currentSelectTip ~= nil and self.currentSelectTip:getBuildIndex() == buildIndex then
			self.currentSelectTip = nil
		end
		if self.currentSelectBuild and self.currentSelectBuild:getTag() == buildIndex then
			self:CancelBuildTint(self.currentSelectBuild)
			self.currentSelectBuild = nil
		end
	else
		if self.cacheTip then
			self.cacheTip:hideTip()
		else
		end
		if self.currentSelectTip ~= nil then
			self.currentSelectTip = nil
		end
		if self.currentSelectBuild then
			self:CancelBuildTint(self.currentSelectBuild)
			self.currentSelectBuild = nil
		end
	end
end
function mainCityMsg.addBuildTopTip(mainCity, target, data)
	local self = mainCity
	local buildIndex = data.buildIndex
	if nil == buildIndex then
		return
	end
	if buildIndex == cityBuildConstDef.OtherBuildDef.Gangkou then
		effectMainCityView.addBuildTopTipGangkou(self)
		return
	end
	local buildBtnName = "build_" .. buildIndex
	local buildBtn = self:getBufferNodeByName(buildBtnName)
	if nil == buildBtn then
		return
	end
	local x, y = buildBtn:getPosition()
	local buildTopTip = include("cityBuildTop")
	local buildTopTipType = data.buildTopTipType or cityBuildConstDef.topType.TOP_TYPE_TRAIN_FINISH
	local buildEntity = data.buildEntity
	local buildTopTipPosition = cc.p(x, y + 110)
	if buildIndex == 1052 or buildIndex == 1054 then
		buildTopTipPosition = cc.p(x, y + 60)
	end
	local bNeedAddToTopTipArray = false
	local tipImg
	if buildEntity then
		local buildState = buildEntity:getBuildState()
		local bid = buildEntity:getBuildBid()
		print("----------1111111")
		if buildEntity:getIsCanSpeedUpFree() == true and (buildState == BUILD_STATE.BUILDING or buildState == BUILD_STATE.UPGRADEING or buildState == BUILD_STATE.DEMOLISHING) then
			buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_FREE
			bNeedAddToTopTipArray = false
			print("----------xxxxxxxxx")
			local step = SoraDIsGameGuide()
			if step and 36001 <= step and step <= 36003 then
				cityBuildConstDef = nil
				;(nil).msg = "MESSAGE_SERVER_CLOSE_GUIDE"
				SoraDSendMessage(nil)
			end
		elseif buildEntity:getIsCanSpeedUpStrongFree() then
			buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_FREE
			bNeedAddToTopTipArray = false
		elseif (bid == BUILDID.COLLEGE or bid == BUILDID.MIRACLE) and buildEntity:getIsCanResearchFree() and buildState == BUILD_STATE.NORMAL then
			buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_FREE
			bNeedAddToTopTipArray = false
			print("----------yyyyyyyyyyy")
		elseif buildEntity:getIsNeedReqHelp() == true and (buildState == BUILD_STATE.BUILDING or buildState == BUILD_STATE.UPGRADEING or buildState == BUILD_STATE.NORMAL) then
			buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_REQ_HELP
			bNeedAddToTopTipArray = false
		elseif buildEntity:getHasAnyAllianceHelpList() == true then
			buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_HELP_ALL
			buildTopTipPosition = cc.p(x, y + 142)
			bNeedAddToTopTipArray = false
		else
			print("----------222222", bid)
			if bid == BUILDID.STABLES or bid == BUILDID.RANGE or bid == BUILDID.BARRACKS or bid == BUILDID.CHARIOT_PLANT then
				buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_TRAIN_FINISH
				bNeedAddToTopTipArray = false
			elseif bid == BUILDID.MONUMENT then
				buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_MONUMENT
				bNeedAddToTopTipArray = false
			elseif bid == BUILDID.FORTRESS then
				buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_TRAIN_TRAP
			elseif bid == BUILDID.FARM then
				buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_COLLECT_FOOD
				bNeedAddToTopTipArray = true
			elseif bid == BUILDID.SAWMILL then
				buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_COLLECT_WOOD
				bNeedAddToTopTipArray = true
			elseif bid == BUILDID.IRON_MINE then
				buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_COLLECT_IRON
				bNeedAddToTopTipArray = true
			elseif bid == BUILDID.STEEL then
				buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_COLLECT_STEEL
				bNeedAddToTopTipArray = true
			elseif bid == BUILDID.CRYSTAL_MINE then
				buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_CRYSTAL
				bNeedAddToTopTipArray = true
			elseif bid == BUILDID.HALL_OF_WAR then
				buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_ALLIANCE_WAR
				bNeedAddToTopTipArray = false
			elseif bid == BUILDID.MATERIAL_WORKSHOP then
				buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_TRAIN_MATERIAL
				bNeedAddToTopTipArray = false
			elseif bid == cityBuildConstDef.fixedBuildDef.HuoChuang then
				buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_HUOCHUANG
				bNeedAddToTopTipArray = false
			elseif bid == cityBuildConstDef.fixedBuildDef.LeisureCenter then
				bNeedAddToTopTipArray = false
				if buildTopTipType == cityBuildConstDef.topType.TOP_TYPE_PYRAMID_ACTIVITY and SoraDGetCastleLv() < CASTLE_LV8_LIMITED then
					return
				end
			end
		end
		local buildType = SoraDGetBuildTypeByBid(tonumber(buildEntity:getBuildBid()))
		print("buildType = ", buildType)
		if buildType == 0 then
			buildTopTipPosition = cc.p(x, y + 110)
			if bid == BUILDID.EMBASSY then
				buildTopTipPosition = cc.p(x, y + 142)
			elseif bid == BUILDID.TURRET then
				buildTopTipPosition = cc.p(x, y + 50)
			elseif bid == BUILDID.WALLS then
				buildTopTipPosition = cc.p(x, y + 70)
			elseif bid == BUILDID.MIRACLE then
				buildTopTipPosition = cc.p(x, y + 180)
			elseif bid == BUILDID.MONUMENT then
				buildTopTipPosition = cc.p(x - 40, y + 150)
			elseif bid == BUILDID.NEBULA_PALACE then
				buildTopTipPosition = cc.p(x - 20, y + 350)
			end
		else
			buildTopTipPosition = cc.p(x, y + 35)
			if bid == BUILDID.MATERIAL_WORKSHOP then
				buildTopTipPosition = cc.p(x, y + 110)
			end
			if bid == BUILDID.CRYSTAL_MINE then
				buildTopTipPosition = cc.p(x, y + 150)
			end
		end
	end
	print("buildTopTipPosition = ", buildTopTipPosition, "buildTopTipType = ", buildTopTipType)
	dump(buildTopTipPosition, "buildTopTipPosition")
	local buildTipNode = cityBuildCreator:createBuildTop(buildTopTipType, self.tblBatchNodesTopTip, buildTopTipPosition)
	local bid = buildEntity and tonumber(buildEntity:getBuildBid())
	if bid == BUILDID.MATERIAL_WORKSHOP then
		local stuffWorkshopCtrl = gametop.playertop_:getModule("stuffWorkshopCtrl")
		local doneId = stuffWorkshopCtrl:getDoneID()
		local itemDesRead = include("itemDesRead")
		buildTipNode:setIcon(itemDesRead.getIcon(doneId), cc.size(70, 70))
	end
	if buildTopTipType == cityBuildConstDef.topType.TOP_TYPE_FREE then
		local lang = SoraDGetDefaultLanguage()
		_ENV = buildTipNode.setIcon
		buildTipNode.setIcon[1] = "ar"
		buildTipNode.setIcon[2] = "en"
		tipImg = SoraDGetImageNameByLang("frame_free_font_%s.png", buildTipNode.setIcon)
		buildTipNode:setIcon(tipImg, nil, cc.p(0, 46))
	end
	if data.icon then
		buildTipNode:setIcon(data.icon, data.iconSize or cc.size(70, 70), data.iconPos)
	end
	local buildTipNodeName = "build_topTip_" .. buildIndex
	buildTipNode:setName(buildTipNodeName)
	local tempBuildTopTip = self:getBufferNodeByName(buildTipNodeName)
	if tempBuildTopTip ~= nil then
		self:delBufferNodeByName(buildTipNodeName)
		self:removeFromTopTipArray(tempBuildTopTip)
		tempBuildTopTip:removeNodeRelyOn()
		tempBuildTopTip:recycleNode()
		tempBuildTopTip:removeFromParent()
	end
	buildTipNode:setPosition(buildTopTipPosition)
	print("buildTipNode:", buildTipNode:getPosition())
	buildTipNode:setTag(buildIndex)
	buildTipNode.topType = buildTopTipType
	buildTipNode.topTipData = data.topTipData
	buildTipNode:addTo(self.containerView, 1402)
	buildTipNode:setLocalZOrder(1402)
	print("添加了一个topTip", buildTipNodeName, buildTipNode)
	self:addToBufferNodeArrayByName(buildTipNodeName, buildTipNode)
	local btnTip = SoraDGetChildByName(buildTipNode, "btn")
	if btnTip then
		btnTip:setTouchEnabled(true)
		btnTip:setTag(buildIndex)
		btnTip.topType = buildTopTipType
		btnTip.topTipData = data.topTipData
		if buildIndex == cityBuildConstDef.buildIndexDef.index_CommandHall then
			btnTip:addTouchEventListener(function(ref, type)
				self:onOtherTopTipCallBack(btnTip, ref, type)
			end)
		else
			btnTip:addTouchEventListener(function(ref, type)
				self:onTopTipCallBack(btnTip, ref, type)
			end)
		end
	end
	if bNeedAddToTopTipArray == true then
		self:addToTopTipArray(buildTipNode)
	end
	print("----------3333333")
	local guideStep = SoraDIsGameGuide()
	if guideStep and 2019 <= guideStep and guideStep <= 2021 then
		cityBuildConstDef = buildTipNode
		buildTipNode.msg = "MESSAGE_SERVER_GUIDE_STEP_ON"
		buildTipNode.step = 2022
		SoraDSendMessage(buildTipNode)
	end
	if buildEntity then
		local bid = tonumber(buildEntity:getBuildBid())
		local iid = tonumber(buildEntity:getIid())
		cityBuildConstDef = buildEntity:getIid()
		buildEntity:getIid().msg = "MESSAGE_MAINCITYVIEW_HERO_APPOINT_TIP"
		buildEntity:getIid().bid = bid
		buildEntity:getIid().iid = iid
		SoraDSendMessage(buildEntity:getIid())
	end
end
function mainCityMsg.removeBuildTopTip(mainCity, target, data)
	local self = mainCity
	local buildIndex = data.buildIndex
	if nil == buildIndex then
		return
	end
	if buildIndex == cityBuildConstDef.OtherBuildDef.Gangkou then
		effectMainCityView.removeBuildTopTipGangkou(self)
		return
	end
	local buildTopTipName = "build_topTip_" .. buildIndex
	local buildTopTipNode = self:getBufferNodeByName(buildTopTipName)
	if nil == buildTopTipNode then
		return
	end
	local topType = data.buildTopTipType
	if topType and topType ~= buildTopTipNode.topType then
		print("要删除的topType为", topType, "，和显示的类型不一致，无需删除")
		return
	end
	local optype = data.optype
	if optype then
		print("==data.optype==", optype)
		if optype == BUILD_OPERATE_TYPE.UPGRADE_STAR then
			local buildButton = self:getBufferNodeByName("build_" .. buildIndex)
			local buildNode = buildButton:getChildByName("buildName")
			if buildNode then
				buildNode:setIsCanSpeedUpStrongFree(false)
			end
		end
	end
	self:delBufferNodeByName(buildTopTipName)
	self:removeFromTopTipArray(buildTopTipNode)
	buildTopTipNode:removeNodeRelyOn()
	buildTopTipNode:recycleNode()
	buildTopTipNode:removeFromParent()
	local npcTipClient = include("npcTipClient")
	local tipInfo = npcTipClient:getTipInfo()
	if npcTipClient:getTopTipOn() == false and tipInfo and (tipInfo.bid ~= 0 or tipInfo.bIndex ~= 0) then
		cityBuildConstDef = npcTipClient
		npcTipClient.msg = "MESSAGE_MAINCITYVIEW_ADD_NPC_TOP_TIP"
		npcTipClient.bid = tipInfo.bid
		npcTipClient.bIndex = tipInfo.bIndex
		SoraDSendMessage(npcTipClient)
		npcTipClient:setTopTipOn(true)
	end
	local buildEntity = data.buildEntity
	if not buildEntity then
		local buildButton = self:getBufferNodeByName("build_" .. buildIndex)
		buildEntity = buildButton:getChildByName("buildName")
	end
	if buildEntity then
		local state = buildEntity:getState()
		if state == "harvesting" then
			buildEntity:onafterharvest()
		end
		print("state======", state)
		if state ~= "idle" and state ~= "demolishing" and buildEntity:getIsCanSpeedUpFree() then
			buildEntity:showTopTipEffect()
		end
	end
end
function mainCityMsg.addAnimWorker(mainCity, target, data)
	local self = mainCity
	local buildIndex = data.buildIndex
	local isHideHammer = data.isHideHammer
	if nil == buildIndex then
		return
	end
	local buildBtnName = "build_" .. buildIndex
	local buildBtn = self:getBufferNodeByName(buildBtnName)
	if nil == buildBtn then
		return
	end
	local x, y = buildBtn:getPosition()
	local buildWorker = include("cityBuildWorker")
	local buildWorkerAnimName = "animationBuildWorker1"
	local buildCell = cityCtrl:getBuildCellByIndex(buildIndex)
	if buildCell ~= nil then
		local bid = tonumber(buildCell.info.bid)
		if bid == BUILDID.CASTLE then
			buildWorkerAnimName = "animationBuildWorker2"
		elseif bid == BUILDID.WALLS then
			y = y - 80
		elseif bid == BUILDID.TURRET then
			y = y - 60
		elseif bid == BUILDID.HERO_TRAIN_GROUND then
			y = y - 40
		end
	end
	local buildWorkerNode = buildWorker.new(getCCSPath(buildWorkerAnimName))
	local buildWorkerNodeName = "build_buildWorker_" .. buildIndex
	buildWorkerNode:setName(buildWorkerNodeName)
	buildWorkerNode:setIsHideHammer(isHideHammer)
	buildWorkerNode:setPosition(cc.p(x, y))
	local zOrder = 1010
	buildWorkerNode:addTo(self.containerView, zOrder)
	self:addToBufferNodeArrayByName(buildWorkerNodeName, buildWorkerNode)
end
function mainCityMsg.removeAnimWorker(mainCity, target, data)
	local self = mainCity
	local buildIndex = data.buildIndex
	if nil == buildIndex then
		return
	end
	local buildWorkerNodeName = "build_buildWorker_" .. buildIndex
	local buildWorkerNode = self:getBufferNodeByName(buildWorkerNodeName)
	if nil == buildWorkerNode then
		return
	end
	self:delBufferNodeByName(buildWorkerNodeName)
	buildWorkerNode:hideAnimBuildWorker()
end
function mainCityMsg.addTroopSolider(mainCity, target, data)
	local self = mainCity
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	if guideCtrl:getCurMainCityGuideStep() ~= nil then
		return
	end
	local buildIndex = data.index
	local bid = data.bid
	local numberOfSolider = data.numberOfSolider
	local buildBtnName = "build_" .. buildIndex
	local buildBtn = self:getBufferNodeByName(buildBtnName)
	if nil == buildBtn then
		return
	end
	local beginPoint = cc.p(buildBtn:getPositionX(), buildBtn:getPositionY())
	local endPoint = cc.p(1194 + math.random(200, 400), 54 + math.random(300, 500))
	local cityBuildTroopsMatrix = include("cityBuildTroopsMatrix")
	local cityBuildTroopsMatrixNode = cityBuildTroopsMatrix.new()
	local imgName
	cityBuildTroopsMatrixNode:initWithUIType(cityBuildConstDef.uiType.UI_TYPE_ALONE, nil, imgName)
	cityBuildTroopsMatrixNode:setPosition(beginPoint.x, beginPoint.y)
	cityBuildTroopsMatrixNode:addTo(self.containerView, 450)
	local cityBuildFunction = include("cityBuildFunction")
	local ccpPointsArray = cityBuildFunction.GetTroopCCPointsByIndex(buildIndex)
	print(buildIndex, "buildIndex")
	dump(ccpPointsArray, "addTroopSolider")
	if ccpPointsArray == nil then
		return
	end
	_ENV = "addTroopSolider"
	;("addTroopSolider").bid = bid
	;("addTroopSolider").soldierNumber = 6
	;("addTroopSolider").realSoldierNumber = 1
	;("addTroopSolider").row = 5
	;("addTroopSolider").col = 5
	;("addTroopSolider").targetPointsArray = ccpPointsArray
	;("addTroopSolider").isShowParallelgram = false
	cityBuildTroopsMatrixNode:createTroops("addTroopSolider")
end
function mainCityMsg.enterMoveMode(mainCity, target, data)
	local self = mainCity
	self.isOnMoveMode = true
	self:updateMoveBtnArrayByType(0)
end
function mainCityMsg.leaveMoveMode(mainCity, target, data)
	local self = mainCity
	self.isOnMoveMode = false
	self.currentSelectMoveModeType = 0
	self.currentSelectMoveModeIndex = 0
	for i = 1, #self.currentMoveBtnArray do
		self:hideBuildMoveEffect(self.currentMoveBtnArray[i])
	end
	self.currentMoveBtnArray, _ENV = 1, (for index)
	self:hideBuildMoveTip()
	print("--离开移动模式")
	effectMainCityView.updateNightScene(self)
end
function mainCityMsg.exchangeBufferNode(mainCity, prevNodeName, afterNodeName)
	local self = mainCity
	local preNode = self:getBufferNodeByName(prevNodeName)
	local afterNode = self:getBufferNodeByName(afterNodeName)
	self:delBufferNodeByName(prevNodeName)
	self:delBufferNodeByName(afterNodeName)
	if preNode ~= nil then
		self:addToBufferNodeArrayByName(afterNodeName, preNode)
		preNode:setName(afterNodeName)
	end
	if afterNode ~= nil then
		self:addToBufferNodeArrayByName(prevNodeName, afterNode)
		afterNode:setName(prevNodeName)
	end
end
function mainCityMsg.exchangeBuild(mainCity, target, data)
	local self = mainCity
	local preIndex = data.preIndex
	local afterIndex = data.afterIndex
	if preIndex == nil or afterIndex == nil then
		return
	end
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local cityCell = cityCtrl:getCurCity()
	local prevBuildBtnName = "build_" .. preIndex
	local afterBuildBtnName = "build_" .. afterIndex
	local prevBtn = self:getBufferNodeByName(prevBuildBtnName)
	local afterBtn = self:getBufferNodeByName(afterBuildBtnName)
	if prevBtn == nil or afterBtn == nil then
		print("prevBtn == nil or afterBtn == nil")
		return
	end
	local preBuildEntity = prevBtn:getChildByName("buildName")
	local afterBuildEntity = afterBtn:getChildByName("buildName")
	if preBuildEntity ~= nil or afterBuildEntity ~= nil then
		if preBuildEntity ~= nil then
			preBuildEntity:retain()
			preBuildEntity:removeFromParent(false)
			preBuildEntity:addTo(afterBtn, 1)
			preBuildEntity:release()
			preBuildEntity:setBuildIndex(afterIndex)
			preBuildEntity:reBeginTime()
			if preBuildEntity.addOnTouchMessage then
				preBuildEntity.addOnTouchMessage()
			end
			local basePos = cc.p(afterBtn:getPositionX(), afterBtn:getPositionY())
			if 1 == SoraDGetBuildTypeByIndex(preIndex) then
				preBuildEntity:setBasePos(basePos)
				preBuildEntity:udpateViewWithBasePos()
			end
		end
		if afterBuildEntity ~= nil then
			afterBuildEntity:retain()
			afterBuildEntity:removeFromParent(false)
			afterBuildEntity:addTo(prevBtn, 1)
			afterBuildEntity:release()
			afterBuildEntity:setBuildIndex(preIndex)
			afterBuildEntity:reBeginTime()
			if afterBuildEntity.addOnTouchMessage then
				afterBuildEntity.addOnTouchMessage()
			end
			local basePos = cc.p(prevBtn:getPositionX(), prevBtn:getPositionY())
			if 1 == SoraDGetBuildTypeByIndex(afterIndex) then
				afterBuildEntity:setBasePos(basePos)
				afterBuildEntity:udpateViewWithBasePos()
			end
		end
		self:updateBuildTile(prevBtn)
		self:updateBuildTile(afterBtn)
	end
	do
		local prevNodeName = "build_buildWorker_" .. preIndex
		local afterNodeName = "build_buildWorker_" .. afterIndex
		local preNode = self:getBufferNodeByName(prevNodeName)
		local afterNode = self:getBufferNodeByName(afterNodeName)
		local prevPosX = prevBtn:getPositionX()
		local prevPosY = prevBtn:getPositionY()
		local afterPosX = afterBtn:getPositionX()
		local afterPosY = afterBtn:getPositionY()
		self:delBufferNodeByName(prevNodeName)
		self:delBufferNodeByName(afterNodeName)
		if preNode ~= nil then
			self:addToBufferNodeArrayByName(afterNodeName, preNode)
			preNode:setName(afterNodeName)
			preNode:setPosition(afterPosX, afterPosY)
		end
		if afterNode ~= nil then
			self:addToBufferNodeArrayByName(prevNodeName, afterNode)
			afterNode:setName(prevNodeName)
			afterNode:setPosition(prevPosX, prevPosY)
		end
	end
	do
		local prevNodeName = "build_coolingTip_" .. preIndex
		local afterNodeName = "build_coolingTip_" .. afterIndex
		mainCityMsg.exchangeBufferNode(self, prevNodeName, afterNodeName)
		local prevNodeName = "buildStar_coolingTip_" .. preIndex
		local afterNodeName = "buildStar_coolingTip_" .. afterIndex
		mainCityMsg.exchangeBufferNode(self, prevNodeName, afterNodeName)
		local prevNodeName = "endlessTreasure_coolingTip_" .. preIndex
		local afterNodeName = "endlessTreasure_coolingTip_" .. afterIndex
		mainCityMsg.exchangeBufferNode(self, prevNodeName, afterNodeName)
		mainCityMsg.updateCoolingPanelPos(self, preIndex)
		mainCityMsg.updateCoolingPanelPos(self, afterIndex)
	end
	do
		local prevNodeName = "build_workDoneEffect_" .. preIndex
		local afterNodeName = "build_workDoneEffect_" .. afterIndex
		local preNode = self:getBufferNodeByName(prevNodeName)
		local afterNode = self:getBufferNodeByName(afterNodeName)
		local prevPosX = prevBtn:getPositionX()
		local prevPosY = prevBtn:getPositionY()
		local afterPosX = afterBtn:getPositionX()
		local afterPosY = afterBtn:getPositionY()
		self:delBufferNodeByName(prevNodeName)
		self:delBufferNodeByName(afterNodeName)
		if preNode ~= nil then
			self:addToBufferNodeArrayByName(afterNodeName, preNode)
			preNode:setName(afterNodeName)
			preNode:setPosition(afterPosX, afterPosY)
		end
		if afterNode ~= nil then
			self:addToBufferNodeArrayByName(prevNodeName, afterNode)
			afterNode:setName(prevNodeName)
			afterNode:setPosition(prevPosX, prevPosY)
		end
	end
	do
		local prevNodeName = "build_topTip_" .. preIndex
		local afterNodeName = "build_topTip_" .. afterIndex
		local preNode = self:getBufferNodeByName(prevNodeName)
		local afterNode = self:getBufferNodeByName(afterNodeName)
		print("prevNodeName: " .. prevNodeName)
		dump(preNode, "preNode===")
		print("afterNodeName: " .. afterNodeName)
		dump(afterNode, "afterNode===")
		local preTag, afterTag
		if preNode ~= nil then
			preTag = preNode:getTag()
		end
		if afterNode ~= nil then
			afterTag = afterNode:getTag()
		end
		local prevPosX = prevBtn:getPositionX()
		local prevPosY = prevBtn:getPositionY()
		local afterPosX = afterBtn:getPositionX()
		local afterPosY = afterBtn:getPositionY()
		self:delBufferNodeByName(prevNodeName)
		self:delBufferNodeByName(afterNodeName)
		if preNode ~= nil then
			self:addToBufferNodeArrayByName(afterNodeName, preNode)
			self:removeFromTopTipArray(preNode)
			preNode:setName(afterNodeName)
			local buildType = SoraDGetBuildTypeByIndex(afterIndex)
			local basePos
			if buildType == 0 then
				basePos = cc.p(afterPosX, afterPosY + 130)
			else
				basePos = cc.p(afterPosX, afterPosY + afterBtn:getContentSize().height / 2)
			end
			preNode:setPosition(basePos)
			preNode:setBasePos(basePos)
			preNode:udpateViewWithBasePos()
			preNode:setTag(afterIndex)
			local btn = SoraDGetChildByName(preNode, "btn")
			if btn then
				btn:setTag(afterIndex)
			end
		end
		if afterNode ~= nil then
			self:addToBufferNodeArrayByName(prevNodeName, afterNode)
			self:removeFromTopTipArray(afterNode)
			afterNode:setName(prevNodeName)
			local buildType = SoraDGetBuildTypeByIndex(preIndex)
			local basePos
			if buildType == 0 then
				basePos = cc.p(prevPosX, prevPosY + 130)
			else
				basePos = cc.p(prevPosX, prevPosY + prevBtn:getContentSize().height / 2)
			end
			afterNode:setPosition(basePos)
			afterNode:setBasePos(basePos)
			afterNode:udpateViewWithBasePos()
			afterNode:setTag(preIndex)
			local btn = SoraDGetChildByName(afterNode, "btn")
			if btn then
				btn:setTag(preIndex)
			end
		end
		if 1 == SoraDGetBuildTypeByIndex(afterIndex) and preNode ~= nil then
			self:addToTopTipArray(preNode)
		end
		if 1 == SoraDGetBuildTypeByIndex(preIndex) and afterNode ~= nil then
			self:addToTopTipArray(afterNode)
			dump(self.currentTopTipArray)
		end
	end
	local buildType = SoraDGetBuildTypeByIndex(preIndex)
	if buildType == 1 then
		local preEtBoostBottomName = "et_boost_bottom_" .. preIndex
		local afterEtBoostBottomName = "et_boost_bottom_" .. afterIndex
		local prevPosX = prevBtn:getPositionX()
		local prevPosY = prevBtn:getPositionY()
		local afterPosX = afterBtn:getPositionX()
		local afterPosY = afterBtn:getPositionY()
		local zOrderPrev = prevBtn:getLocalZOrder()
		local zOrderAfter = afterBtn:getLocalZOrder()
		local preEtBoostBottomNode = self:getBufferNodeByName(preEtBoostBottomName)
		local afterEtBoostBottomNode = self:getBufferNodeByName(afterEtBoostBottomName)
		self:delBufferNodeByName(preEtBoostBottomName)
		self:delBufferNodeByName(afterEtBoostBottomName)
		if preEtBoostBottomNode ~= nil then
			self:addToBufferNodeArrayByName(afterEtBoostBottomName, preEtBoostBottomNode)
			preEtBoostBottomNode:setName(afterEtBoostBottomName)
			preEtBoostBottomNode:setPosition(cc.p(afterPosX, afterPosY))
		end
		if afterEtBoostBottomNode ~= nil then
			self:addToBufferNodeArrayByName(preEtBoostBottomName, afterEtBoostBottomNode)
			afterEtBoostBottomNode:setName(preEtBoostBottomName)
			afterEtBoostBottomNode:setPosition(cc.p(prevPosX, prevPosY))
		end
		local preEtBoostMiddleNode = self:getBufferNodeByName(preEtBoostMiddleName)
		local afterEtBoostMiddleNode = self:getBufferNodeByName(afterEtBoostMiddleName)
		self:delBufferNodeByName(preEtBoostMiddleName)
		self:delBufferNodeByName(afterEtBoostMiddleName)
		if preEtBoostMiddleNode ~= nil then
			self:addToBufferNodeArrayByName(afterEtBoostMiddleName, preEtBoostMiddleNode)
			preEtBoostMiddleNode:setLocalZOrder(zOrderAfter + 1)
			preEtBoostMiddleNode:setName(afterEtBoostMiddleName)
			preEtBoostMiddleNode:setPosition(cc.p(afterPosX, afterPosY))
		end
		if afterEtBoostMiddleNode ~= nil then
			self:addToBufferNodeArrayByName(preEtBoostMiddleName, afterEtBoostMiddleNode)
			afterEtBoostMiddleNode:setLocalZOrder(zOrderPrev + 1)
			afterEtBoostMiddleNode:setName(preEtBoostMiddleName)
			afterEtBoostMiddleNode:setPosition(cc.p(prevPosX, prevPosY))
		end
		local preEtBoostTopNode = self:getBufferNodeByName(preEtBoostTopName)
		local afterEtBoostTopNode = self:getBufferNodeByName(afterEtBoostTopName)
		self:delBufferNodeByName(preEtBoostTopName)
		self:delBufferNodeByName(afterEtBoostTopName)
		if preEtBoostTopNode ~= nil then
			preEtBoostTopNode:setLocalZOrder(zOrderAfter + 1)
			preEtBoostTopNode:setName(afterEtBoostTopName)
			preEtBoostTopNode:setPosition(cc.p(afterPosX, afterPosY))
		end
		if afterEtBoostTopNode ~= nil then
			afterEtBoostTopNode:setLocalZOrder(zOrderPrev + 1)
			afterEtBoostTopNode:setName(preEtBoostTopName)
			afterEtBoostTopNode:setPosition(cc.p(prevPosX, prevPosY))
		end
	end
	effectMainCityView.updateNightScene(mainCity)
	if preBuildEntity then
		local bid = tonumber(preBuildEntity:getBuildBid())
		local iid = tonumber(preBuildEntity:getIid())
		_ENV = preBuildEntity:getIid()
		preBuildEntity:getIid().msg = "MESSAGE_MAINCITYVIEW_HERO_APPOINT_TIP"
		preBuildEntity:getIid().bid = bid
		preBuildEntity:getIid().iid = iid
		SoraDSendMessage(preBuildEntity:getIid())
	end
	if afterBuildEntity then
		local bid = tonumber(afterBuildEntity:getBuildBid())
		local iid = tonumber(afterBuildEntity:getIid())
		_ENV = afterBuildEntity:getIid()
		afterBuildEntity:getIid().msg = "MESSAGE_MAINCITYVIEW_HERO_APPOINT_TIP"
		afterBuildEntity:getIid().bid = bid
		afterBuildEntity:getIid().iid = iid
		SoraDSendMessage(afterBuildEntity:getIid())
	end
	do
		local prevNodeName = "build_heroAppoint_topTip_" .. preIndex
		local afterNodeName = "build_heroAppoint_topTip_" .. afterIndex
		local preNode = self:getBufferNodeByName(prevNodeName)
		local afterNode = self:getBufferNodeByName(afterNodeName)
		if preNode and (not (not afterBuildEntity or cityltCtrl.getBuildHeroAppointCfg(tonumber(afterBuildEntity:getBuildBid()))) or not afterBuildEntity) then
			print("移除prevNodeName======", prevNodeName)
			self:delBufferNodeByName(prevNodeName)
			preNode:removeNodeRelyOn()
			preNode:recycleNode()
			preNode:removeFromParent()
		end
		if afterNode and (not (not preBuildEntity or cityltCtrl.getBuildHeroAppointCfg(tonumber(preBuildEntity:getBuildBid()))) or not preBuildEntity) then
			print("移除afterNodeName======", afterNodeName)
			self:delBufferNodeByName(afterNodeName)
			afterNode:removeNodeRelyOn()
			afterNode:recycleNode()
			afterNode:removeFromParent()
		end
	end
end
function mainCityMsg.addHarvestFloating(mainCity, target, data)
	local self = mainCity
	local buildIndex = data.index
	if nil == buildIndex then
		return
	end
	local isResReturnBack = data.isResReturnBack
	local buildEntity = data.buildEntity
	if nil == buildEntity then
		return
	end
	local bid = buildEntity:getBuildBid()
	local resId = gIDDef.FOOD
	if isResReturnBack then
		resId = gIDDef.FOOD
	elseif bid == BUILDID.FARM then
		resId = gIDDef.FOOD
	elseif bid == BUILDID.SAWMILL then
		resId = gIDDef.WOOD
	elseif bid == BUILDID.IRON_MINE then
		resId = gIDDef.IRON
	elseif bid == BUILDID.STEEL then
		resId = gIDDef.MITHRIL
	elseif bid == BUILDID.CRYSTAL_MINE then
		resId = gIDDef.CRYSTAL
	end
	local btnName = "build_" .. buildIndex
	local btn = self:getBufferNodeByName(btnName)
	local posBtn = cc.p(btn:getPositionX(), btn:getPositionY())
	local buffAdd = buffCtrl:getBuffEffect(gBuffEffect.CITY_RES_DOUBLE) or 0
	buffAdd = buffAdd / 1000 + 1
	if not isResReturnBack then
		local currentHarvest = buildEntity:getCurrentHarvest() * buffAdd
		_ENV = btn:getPositionY()
		btn:getPositionY().zOrder = 500
		btn:getPositionY().color = display.COLOR_GREEN
		btn:getPositionY().pos = cc.p(posBtn.x, posBtn.y)
		SoraDCreateWaveLabel("+" .. currentHarvest, self.containerView, btn:getPositionY())
	end
	if not isResReturnBack then
		local currentHarvest = buildEntity:getCurrentHarvest() * buffAdd
		local maxHarvest = buildEntity:getMaxHarvest()
		local numberOfSprite = 5
		numberOfSprite = math.min(4 + 10 * currentHarvest / maxHarvest, 10)
		self:addResCollectAnimation(resId, buildIndex, buildEntity, numberOfSprite)
	else
		local costRes = buildEntity:getCostRes()
		if costRes then
			for k, v in pairs(costRes) do
				if v.resid and (v.resid == gIDDef.FOOD or v.resid == gIDDef.WOOD or v.resid == gIDDef.IRON or v.resid == gIDDef.MITHRIL) then
					self:addResCollectAnimation(v.resid, buildIndex, buildEntity, 5)
				end
			end
		end
		buildEntity:setCostRes(nil)
	end
end
function mainCityMsg.buildQueueCallback(mainCity, target, data)
	local self = mainCity
	local optype = data.optype
	local index = data.index
	local bid = data.bid
	local iid = data.iid
	if optype == BUILD_OPERATE_TYPE.BUILD or optype == BUILD_OPERATE_TYPE.UPGRADE or optype == BUILD_OPERATE_TYPE.DEMOLISH then
		if optype == BUILD_OPERATE_TYPE.BUILD then
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_EFFECT_UPGRADE"
			;(nil).buildIndex = index
			;(nil).posEtUpgradeOffset = cc.p(0, 10)
			SoraDSendMessage(nil)
		elseif optype == BUILD_OPERATE_TYPE.DEMOLISH then
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_ANIM_BOOST"
			;(nil).buildIndex = index
			SoraDSendMessage(nil)
		end
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_COOLING_PANEL"
		;(nil).buildIndex = index
		SoraDSendMessage(nil)
		if bid == BUILDID.MIRACLE then
			self.castleModel = BUILD_CASTLE_MODEL.WARLV
			mainCityMsg.refreshCastleSkin(self)
		end
		gModuleMgr.sharedMgr("mildGuideManager"):updatePanelShow("mainCityView")
	elseif optype == QUEUE_OPERATE_TYPE.CANCLE then
		_ENV = gModuleMgr.sharedMgr("mildGuideManager")
		gModuleMgr.sharedMgr("mildGuideManager").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_COOLING_PANEL"
		gModuleMgr.sharedMgr("mildGuideManager").buildIndex = index
		gModuleMgr.sharedMgr("mildGuideManager").isCancel = true
		gModuleMgr.sharedMgr("mildGuideManager").costres = data.costres
		SoraDSendMessage((gModuleMgr.sharedMgr("mildGuideManager")))
	end
	effectMainCityView.updateNightScene(self)
end
function mainCityMsg.demolishBuild(mainCity, target, data)
	local self = mainCity
	local buildButton = self:getBufferNodeByName("build_" .. data.index)
	if buildButton ~= nil then
		local buildNode = buildButton:getChildByName("buildName")
		if buildNode then
			buildNode:setBlockState("demolishing")
			buildNode:changeState()
		end
	end
	effectMainCityView.updateNightScene(self)
end
function mainCityMsg.cancelDemolishBuild(mainCity, target, data)
	local self = mainCity
	local buildButton = self:getBufferNodeByName("build_" .. buildID)
	if buildButton ~= nil then
		local buildNode = buildButton:getChildByName("buildName")
		if buildNode then
			buildNode:setBlockState("reset")
			buildNode:changeState()
		end
	end
end
function mainCityMsg.cancelUpgradeBuild(mainCity, target, data)
	local self = mainCity
	local buildButton = self:getBufferNodeByName("build_" .. buildID)
	if buildButton ~= nil then
		local buildNode = buildButton:getChildByName("buildName")
		if buildNode then
			buildNode:setBlockState("reset")
			buildNode:changeState()
		end
	end
end
function mainCityMsg.addBuildPreview(mainCity, target, data)
	local self = mainCity
	local buildIndex = data.index
	local bid = data.bid
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_PREVIEW"
	;(nil).index = buildIndex
	SoraDSendMessage(nil)
	self:addBuild(buildIndex, bid)
end
function mainCityMsg.removeBuildPreview(mainCity, target, data)
	local self = mainCity
	local buildIndex = data.index
	local buildBtnName = "build_" .. buildIndex
	local buildButton = self:getBufferNodeByName(buildBtnName)
	if nil == buildButton then
		return
	end
	if buildButton then
		local buildContentNode = buildButton:getChildByName("buildName")
		if nil ~= buildContentNode then
			local buildCell = buildContentNode:getBuildCell()
			if buildCell ~= nil then
				return
			end
		end
	end
	_ENV = buildContentNode:getBuildCell()
	buildContentNode:getBuildCell().msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD"
	buildContentNode:getBuildCell().index = buildIndex
	SoraDSendMessage((buildContentNode:getBuildCell()))
end
function mainCityMsg.showHarvestArmyResult(mainCity, target, data)
	local self = mainCity
	local index = data.index
	local bid = data.bid
	local armyid = data.armyid
	local armycount = data.armycount
	local buildName = "build_" .. index
	local buildBtn = self:getBufferNodeByName(buildName)
	if nil == buildBtn then
		return
	end
	local buildEntity = buildBtn:getChildByName("buildName")
	if nil == buildEntity then
		return
	end
	if bid == BUILDID.STABLES or bid == BUILDID.RANGE or bid == BUILDID.BARRACKS or bid == BUILDID.CHARIOT_PLANT or bid == BUILDID.ELITE_PALACE then
		_ENV = "buildName"
		;("buildName").msg = "MESSAGE_MAINCITYVIEW_ADD_TROOP_SOLIDER"
		;("buildName").index = index
		;("buildName").bid = bid
		;("buildName").numberOfSolider = armycount
		SoraDSendMessage("buildName")
		if buildEntity:getState() ~= "idle" then
			buildEntity:setBlockState("idle")
			buildEntity:changeState()
		end
	elseif bid == BUILDID.FORTRESS or bid == BUILDID.BLACK_SMITH then
		if buildEntity:getState() ~= "idle" then
			buildEntity:setBlockState("idle")
			buildEntity:changeState()
		end
	elseif bid == BUILDID.MATERIAL_WORKSHOP then
		local items = data.items
		_ENV = "idle"
		;("idle").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
		;("idle").buildIndex = index
		SoraDSendMessage("idle")
		if buildBtn then
			local buildEntity = buildBtn:getChildByName("buildName")
			if buildEntity then
				buildEntity:hideBrightParticle()
			end
		end
		print("----------------buildEntity:getState()", buildEntity:getState())
		if buildEntity:getState() == "harvesting" then
			buildEntity:setBlockState("idle")
			buildEntity:changeState()
			return
		end
		if buildEntity:getState() == "working" then
		end
		return
	end
	if bid ~= BUILDID.BLACK_SMITH and bid ~= BUILDID.MATERIAL_WORKSHOP then
		self:trainArmyFinishEffect(cc.p(buildBtn:getPositionX(), buildBtn:getPositionY()))
	end
end
function mainCityMsg.buildBtnEvent(mainCity, target, data)
	local self = mainCity
	local index = data.index
	local ref = data.ref
	local eventType = data.eventType
	local buildName = "build_" .. index
	local buildBtn = self:getBufferNodeByName(buildName)
	if nil == buildBtn then
		return
	end
	if eventType == ccui.TouchEventType.began then
		buildBtn:setTouchEnabled(false)
		return
	end
	if eventType == ccui.TouchEventType.canceled then
		buildBtn:setTouchEnabled(true)
		buildBtn:setSwallowTouches(false)
		return
	end
	self:buildButtonCallFun(buildBtn, ref, eventType)
	if eventType == ccui.TouchEventType.ended then
		buildBtn:setTouchEnabled(true)
		buildBtn:setSwallowTouches(false)
	end
end
function mainCityMsg.armyQueueCallback(mainCity, target, data)
	local self = mainCity
	local bid = data.bid
	local iid = data.iid
	if nil == bid then
		return
	end
	local optype = data.optype
	if nil == optype then
		return
	end
	if optype == QUEUE_OPERATE_TYPE.CANCLE then
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local buildCellList = cityCtrl:getBuildCellList(tonumber(data.bid))
		for i = 1, #buildCellList do
			local buildCell = buildCellList[i]
			if nil ~= buildCell then
				local buildIndex = tonumber(buildCell.info.index)
				if tonumber(buildCell.info.state) == BUILD_STATE.NORMAL then
					_ENV = BUILD_STATE.NORMAL
					BUILD_STATE.NORMAL.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_COOLING_PANEL"
					BUILD_STATE.NORMAL.buildIndex = buildIndex
					BUILD_STATE.NORMAL.isCancel = true
					BUILD_STATE.NORMAL.costres = data.costres
					SoraDSendMessage(BUILD_STATE.NORMAL)
				end
			end
		end
	end
end
function mainCityMsg.addMatouTip(mainCity, target, data)
	local self = mainCity
	self:removeMatouTip()
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.PORT)
	if unlockLv <= SoraDGetCastleLv() then
		local timeTipNode = include("timeTip").new(getCCSPath("timeTip"))
		timeTipNode:setPosition(cc.p(self.buttonMaTou:getPositionX(), self.buttonMaTou:getPositionY() - 55))
		timeTipNode:setName("timeTip_Matou")
		timeTipNode:addTo(self.containerView, 1300)
	end
end
function mainCityMsg.removeMatouTip(mainCity, target, data)
	local self = mainCity
	if self.containerView:getChildByName("timeTip_Matou") then
		self.containerView:removeChildByName("timeTip_Matou", true)
	end
end
function mainCityMsg.msgUnLockArea(mainCity, target, data)
	local self = mainCity
	local areaid = data.areaid
	local lockAreaName = "Panel_Area_Lock_" .. areaid
	local panelLockArea = self:getBufferNodeByName(lockAreaName)
	if panelLockArea then
		panelLockArea:removeAllChildren()
		panelLockArea:setVisible(false)
		local openGroundInfo = cityltCtrl.getOpenGoundInfo(areaid)
		local minIndex = openGroundInfo.minIndex
		local maxIndex = openGroundInfo.maxIndex
		for i = minIndex, maxIndex do
			local buildName = "build_" .. i
			local build = self:getBufferNodeByName(buildName)
			if build then
				build:setVisible(true)
				self:addBuildTile(build)
			end
		end
	end
end
function mainCityMsg.msgUpdateLockArea(mainCity, target, data)
	local self = mainCity
	local cityCell = cityCtrl:getCurCity()
	local opengroundinfo = require("app." .. LocalTblPath .. ".config_server.opengroundinfo")
	for i, v in ipairs(opengroundinfo) do
		local lockAreaName = "Panel_Area_Lock_" .. v.areaid
		local panelLockArea = self:getBufferNodeByName(lockAreaName)
		local buildLockArea = SoraDGetChildByName(panelLockArea, "buildName")
		if buildLockArea and buildLockArea:getPreIsCanUnLock() == false then
			buildLockArea:updateView()
		end
	end
end
function mainCityMsg.msgUpdateAllianceHelpList(mainCity, target, data)
	local self = mainCity
	local buildCell = cityCtrl:getBuildCell(BUILDID.EMBASSY, 0)
	if buildCell then
		local bIndex = buildCell.info.index
		local buildName = "build_" .. bIndex
		local build = self:getBufferNodeByName(buildName)
		if build then
			local buildEntity = build:getChildByName("buildName")
			if buildEntity then
				buildEntity:updateAllianceHelpList()
			end
		end
	end
end
function mainCityMsg.addBuildAnimBoost(mainCity, target, data)
	local self = mainCity
	local buildIndex = data.buildIndex
	if nil == buildIndex then
		return
	end
	local buildBtnName = "build_" .. buildIndex
	local buildBtn = self:getBufferNodeByName(buildBtnName)
	if nil == buildBtn then
		return
	end
	self:addBuildAnimBoostBottom(buildIndex)
end
function mainCityMsg.removeBuildAnimBoost(mainCity, target, data)
	local self = mainCity
	local buildIndex = data.buildIndex
	if nil == buildIndex then
		return
	end
	local etBoostBottomName = "et_boost_bottom_" .. buildIndex
	local etBoostBottomNode = self:getBufferNodeByName(etBoostBottomName)
	if etBoostBottomNode ~= nil then
		self:delBufferNodeByName(etBoostBottomName)
		etBoostBottomNode:removeFromParent()
	end
end
function mainCityMsg.msgAddBuildEffectUpgrade(mainCity, target, data)
	local self = mainCity
	local buildIndex = data.buildIndex
	local posEtUpgradeOffset = data.posEtUpgradeOffset
	local build = self:getBufferNodeByName("build_" .. buildIndex)
	if build == nil then
		return
	end
	if 1050 == buildIndex then
		SoraDPlaySound("innercontrol", 7)
		userSDKManager.reportCastleLevel()
		_ENV = "innercontrol"
		;("innercontrol").msg = "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH"
		SoraDSendMessage("innercontrol")
		_ENV = "innercontrol"
		;("innercontrol").msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		;("innercontrol").eventID = gActivityTimeActivityID.ORIENT_PRINCE_GIFT
		SoraDSendMessage("innercontrol")
	else
		local cityltCtrl = include("cityltCtrl")
		local cityBuild = build:getChildByName("buildName")
		if cityBuild then
			if cityltCtrl.buildAttr(cityBuild:getBuildBid(), BUILD_ATTR.BTYPE) == 0 then
				SoraDPlaySound("innercontrol", 2)
			else
				SoraDPlaySound("innercontrol", 9)
			end
		end
	end
	local buildPos = cc.p(build:getPositionX(), build:getPositionY())
	local zOrder = build:getLocalZOrder() + 1
	if buildIndex == 1053 then
		zOrder = 45
	end
	_ENV, _ENV = build:getPositionY()
	_ENV, build:getPositionY().plist = build:getPositionY()
	build:getPositionY().x = 2.136
	_ENV, build[1], build:getPositionY().scale, build:getPositionY().y = build:getPositionY()
	build:getPositionY().plist = "et_jzsj_new_02.plist"
	_ENV, build:getPositionY().scale = build:getPositionY()
	build:getPositionY().x = -2
	_ENV, build[2], build:getPositionY().pos, build:getPositionY().y = build:getPositionY()
	build:getPositionY().plist = "et_jzsj_new_03.plist"
	_ENV, build:getPositionY().scale = build:getPositionY()
	build:getPositionY().x = -4
	build:getPositionY().pos, build:getPositionY().y = build:getPositionY()
	_ENV, build[3], build:getPositionY().rotate = build:getPositionY()
	_ENV, build:getPositionY().plist = build:getPositionY()
	build:getPositionY().x = 0.856
	_ENV, build:getPositionY().scale, build:getPositionY().y = build:getPositionY()
	build:getPositionY().x = -6
	_ENV, build[4], build:getPositionY().pos, build:getPositionY().y = build:getPositionY()
	_ENV, build:getPositionY().plist = build:getPositionY()
	build:getPositionY().x = 4.301
	_ENV, build:getPositionY().scale, build:getPositionY().y = build:getPositionY()
	build:getPositionY().x = -9
	_ENV, build[5], build:getPositionY().pos, build:getPositionY().y = build:getPositionY()
	build:getPositionY().plist = "et_jzsj_new_06.plist"
	_ENV, build:getPositionY().scale = build:getPositionY()
	build:getPositionY().x = -3
	_ENV, build[6], build:getPositionY().pos, build:getPositionY().y = build:getPositionY()
	_ENV, build:getPositionY().plist = build:getPositionY()
	build:getPositionY().x = 4.654
	_ENV, build:getPositionY().scale, build:getPositionY().y = build:getPositionY()
	build:getPositionY().x = 1.67
	build[7], build:getPositionY().pos, build:getPositionY().y = build:getPositionY()
	local param = build
	local et_node = SoraDCreateEffectNode(param, nil, true)
	local targetPos = cc.p(buildPos.x + posEtUpgradeOffset.x, buildPos.y + posEtUpgradeOffset.y)
	et_node:setPosition(targetPos)
	et_node:setLocalZOrder(zOrder + 1000)
	et_node:addTo(self.containerView)
	local actDelay = cca.delay(0.2)
	local callFunc = cca.callFunc(function()
		self:showEffectUpgrade2(buildPos, posEtUpgradeOffset, zOrder)
	end)
	_UPVALUE2_ = build:getPositionY()
	build:getPositionY()[1] = actDelay
	build:getPositionY()[2] = callFunc
	local seq = cca.seq(build:getPositionY())
	self:runAction(seq)
end
function mainCityMsg.sMsgCancelTechnology(mainCity, target, data)
	local self = mainCity
	local queueType = data.queueType
	local bid = tonumber(BUILDID.COLLEGE)
	if queueType == gQueueTypeDef.war_tech_research then
		bid = tonumber(BUILDID.MIRACLE)
	elseif queueType == gQueueTypeDef.craft_study then
		bid = tonumber(BUILDID.STAR_BRAVE_STATUE)
	elseif queueType == gQueueTypeDef.nebula_palace_technology then
		bid = tonumber(BUILDID.NEBULA_PALACE)
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local buildCell = cityCtrl:getBuildCell(bid, 0)
	if buildCell ~= nil then
		local buildIndex = tonumber(buildCell.info.index)
		_ENV = 0
		;(0).msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_COOLING_PANEL"
		;(0).buildIndex = buildIndex
		;(0).isCancel = true
		SoraDSendMessage(0)
	end
end
function mainCityMsg.msgShowTurretLock(mainCity, target, data)
	local self = mainCity
	local buildIndex = data.buildIndex
	if buildIndex then
		local img_lockName = "img_turret_lock_" .. buildIndex
		local img_lock = self:getBufferNodeByName(img_lockName)
		if img_lock then
			img_lock:setVisible(true)
		end
	end
end
function mainCityMsg.msgHideTurretLock(mainCity, target, data)
	local self = mainCity
	local buildIndex = data.buildIndex
	if buildIndex then
		local img_lockName = "img_turret_lock_" .. buildIndex
		local img_lock = self:getBufferNodeByName(img_lockName)
		if img_lock then
			img_lock:setVisible(false)
		end
	end
end
function mainCityMsg.weatherEffect(mainCity, target, data)
	local self = mainCity
	local period = SoraDGetDayPeriod()
	local isCfgNightOn = SoraDConfigGet("Game:GameOptionsView:nightSwitch~bool")
	if period ~= gDay.DAY_TIME and isCfgNightOn then
		effectMainCityView.removeWeatherEffect(self, nil, true)
		return
	end
	local wType = data.wType or cityBuildConstDef.weatherType.sunshine
	local oWType = data.oWType
	if wType == cityBuildConstDef.weatherType.sandstorm then
		wType = cityBuildConstDef.weatherType.sunshine
	end
	_ENV = cityBuildConstDef.weatherType
	_ENV, _ENV = nil, nil
	_ENV, (nil).plist = nil, "et_rain_environment_01.plist"
	;(nil).x = 11.13
	_ENV, (nil)[1], (nil).pos, (nil).y = nil, nil, nil, 129.28
	_ENV, (nil).plist = nil, "et_rain_environment_02.plist"
	;(nil).x = 28.34
	cityBuildConstDef.weatherType[cityBuildConstDef.weatherType.rain], (nil)[2], (nil).pos, (nil).y = nil, nil, nil, 111
	cityBuildConstDef.weatherType[cityBuildConstDef.weatherType.sandstorm], _ENV = nil, nil
	_ENV, _ENV = nil, nil
	;(nil).fileType = "csb"
	_ENV, (nil).fileName = nil, "nodeNormalSun"
	;(nil).x = 0
	;(nil).pos, (nil).y = nil, 0
	;(nil).rotate = 0
	;(nil).scale = 1.3
	cityBuildConstDef.weatherType[cityBuildConstDef.weatherType.sunshine], (nil)[1], (nil).autocull = nil, nil, false
	_ENV, _ENV = nil, nil
	;(nil).fileType = "csb"
	_ENV, (nil).fileName = nil, "nodeBurningSun"
	;(nil).x = 0
	;(nil).pos, (nil).y = nil, 0
	;(nil).rotate = 0
	;(nil).scale = 1.0
	cityBuildConstDef.weatherType[cityBuildConstDef.weatherType.heat], (nil)[1], (nil).autocull = nil, nil, false
	local weatherConfig = cityBuildConstDef.weatherType
	if self:getChildByName("particle_node" .. wType) then
		self:removeChildByName("particle_node" .. wType, true)
	end
	if wType == cityBuildConstDef.weatherType.sunshine or wType == cityBuildConstDef.weatherType.heat then
		self:removeWeatherEffect(wType, true)
		self:removeCloudEffect()
		local folder
		local parNode = SoraDCreateEffectNode(weatherConfig[wType], folder)
		parNode:setName("particle_node" .. wType)
		parNode:setPosition(cc.p(display.width - 10, display.height - 60))
		parNode:addTo(self, 1000)
		if wType == cityBuildConstDef.weatherType.sunshine then
			self:cloudRunEffect()
		end
		self:scrollViewDidOffset()
	elseif wType == cityBuildConstDef.weatherType.rain then
		self:removeWeatherEffect(wType, true)
		self:removeCloudEffect()
		local parNode = SoraDCreateEffectNode(weatherConfig[wType])
		parNode:setName("particle_node" .. wType)
		parNode:setPosition(cc.p(display.cx, display.cy))
		if wType == cityBuildConstDef.weatherType.heat or wType == cityBuildConstDef.weatherType.sunshine then
			parNode:setPosition(cc.p(display.width - 80, display.height - 80))
		end
		parNode:addTo(self, 1000)
		if wType == cityBuildConstDef.weatherType.sunshine then
			self:cloudRunEffect()
		end
		self:scrollViewDidOffset()
	elseif wType == cityBuildConstDef.weatherType.sandstorm then
		self:removeWeatherEffect(cityBuildConstDef.weatherType.rain)
		local oriWeather = function()
			if oWType and (oWType == cityBuildConstDef.weatherType.heat or oWType == cityBuildConstDef.weatherType.sunshine) then
				if not self:getChildByName("particle_node" .. oWType) then
					local oriParNode = SoraDCreateEffectNode(weatherConfig[oWType])
					oriParNode:setName("particle_node" .. oWType)
					oriParNode:setPosition(cc.p(display.cx, display.cy))
					oriParNode:setPosition(cc.p(display.width - 80, display.height - 80))
					oriParNode:addTo(self, 1000)
				end
				if oWType == cityBuildConstDef.weatherType.sunshine then
					self:cloudRunEffect()
				end
				self:scrollViewDidOffset()
			end
		end
		local sandstorm = function()
			self:removeWeatherEffect(wType)
			self:removeCloudEffect()
			local et_node = self:getChildByName("particle_node" .. cityBuildConstDef.weatherType.sandstorm)
			if et_node then
				SoraDResetEffectNode(et_node)
			else
				local parNode = SoraDCreateEffectNode(weatherConfig[cityBuildConstDef.weatherType.sandstorm])
				parNode:setName("particle_node" .. cityBuildConstDef.weatherType.sandstorm)
				parNode:setPosition(cc.p(0, display.cy))
				parNode:addTo(self, 1000)
			end
			self:removeWeatherEffect(oWType)
		end
		_UPVALUE4_ = self
		self[1] = cca.callFunc(oriWeather)
		self[2] = cca.delay(5)
		self[3] = cca.callFunc(sandstorm)
		self[4] = cca.delay(10)
		self[5] = cca.callFunc(oriWeather)
		self[6] = cca.callFunc(oriWeather)
		local seq = transition.sequence(self)
		self:runAction(seq)
	end
end
function mainCityMsg.msgUpdateBuildTipBox(mainCity, target, data)
	local self = mainCity
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_SHOW_TOP_TIP_ACTIVITY"
	SoraDSendMessage(nil)
	if self.hasCommunityCenterMsg == false then
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TIP_BOX"
		;(nil).buildIndex = cityBuildConstDef.OtherBuildDef.CommunityCenter
		SoraDSendMessage(nil)
	end
	local wishingWellBuildIndex = self:getBuildIndexByBid(BUILDID.WISHING_WELL)
	if wishingWellBuildIndex then
		_ENV = BUILDID.WISHING_WELL
		BUILDID.WISHING_WELL.msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TIP_BOX"
		BUILDID.WISHING_WELL.buildIndex = wishingWellBuildIndex
		SoraDSendMessage(BUILDID.WISHING_WELL)
	end
	if self.hasConquerGateMsg == false then
		_ENV = BUILDID.WISHING_WELL
		BUILDID.WISHING_WELL.msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TIP_BOX"
		BUILDID.WISHING_WELL.buildIndex = cityBuildConstDef.OtherBuildDef.ConquerGate
		SoraDSendMessage(BUILDID.WISHING_WELL)
		self.hasConquerGateMsg = true
	end
	if commonCheck.LEISURE_CENTER_EFFECT then
		_ENV = BUILDID.WISHING_WELL
		BUILDID.WISHING_WELL.msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TIP_BOX"
		BUILDID.WISHING_WELL.buildIndex = cityBuildConstDef.fixedBuildDef.LeisureCenter
		SoraDSendMessage(BUILDID.WISHING_WELL)
	end
end
function mainCityMsg.msgHideBuildTipBox(mainCity, target, data)
	print("mainCityMsg.msgHideBuildTipBox(mainCity, target, data)------")
	local buildIndex = data.index
	local self = mainCity
	local tipBoxName
	if buildIndex == cityBuildConstDef.OtherBuildDef.CommunityCenter then
		tipBoxName = "communityCenterTipBox"
	elseif buildIndex == cityBuildConstDef.OtherBuildDef.ActivityCenter then
		tipBoxName = "activityCenterTipBox"
	elseif buildIndex == cityBuildConstDef.OtherBuildDef.ConquerGate then
		tipBoxName = "ConquerGateTipBox"
	else
		if buildIndex == cityBuildConstDef.fixedBuildDef.LeisureCenter then
			tipBoxName = "LeisureTipsBox"
		else
		end
	end
	if tipBoxName then
		local tips = self.containerView:getChildByName(tipBoxName)
		if tips then
			tips:setVisible(false)
		end
	end
end
function mainCityMsg.msgShowBuildLock(mainCity, target, data)
	local self = mainCity
	local buildIndex = data.buildIndex
	if buildIndex == nil then
		return
	end
	local buildBtnName = "build_" .. buildIndex
	local buildBtn = self:getBufferNodeByName(buildBtnName)
	local x, y = buildBtn:getPosition()
	local zOrder = 200
	if 0 == SoraDGetBuildTypeByIndex(buildIndex) then
		zOrder = buildBtn:getLocalZOrder()
	end
	if buildBtn then
		local lockName = "build_lock_" .. buildIndex
		local spriteLock = self:getBufferNodeByName(lockName)
		if not spriteLock then
			spriteLock = display.newSprite("#" .. "frame_techtree_lock_01.png")
			spriteLock:setName(lockName)
			spriteLock:setScale(1.3)
			spriteLock:setPosition(cc.p(x, y + 26))
			spriteLock:addTo(self.containerView, zOrder + 1100)
			self:addToBufferNodeArrayByName(lockName, spriteLock)
		else
			spriteLock:setVisible(true)
		end
	end
end
function mainCityMsg.msgHideBuildLock(mainCity, target, data)
	local self = mainCity
	local buildIndex = data.buildIndex
	if buildIndex == nil then
		return
	end
	local lockName = "build_lock_" .. buildIndex
	local spriteLock = self:getBufferNodeByName(lockName)
	if spriteLock then
		self:delBufferNodeByName(lockName)
		spriteLock:removeFromParent()
	end
end
function mainCityMsg.msgShowCommunityCenterMsg(mainCity, target, data)
	local self = mainCity
	local buttonCommunityCenter = self:getBufferNodeByName("build_30005")
	if not buttonCommunityCenter then
		return
	end
	if not activityCenterUICtrl:isHaveNewFlag(gActivityCenterUIEnum.MAIN_CITY_BILLBOARD) then
		activityCenterUICtrl = activityCenterUICtrl
		activityCenterUICtrl.msg = "MESSAGE_MAINCITYVIEW_HIDE_COMMUNITYCENTER_MSG"
		SoraDSendMessage(activityCenterUICtrl)
		return
	end
	self.hasCommunityCenterMsg = true
	if self.tipBoxCommunity then
		self.tipBoxCommunity:setVisible(false)
	end
	local castleLv = 1
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local castleBcell = cityCtrl:getBuildCell(BUILDID.CASTLE, 0)
	if castleBcell then
		castleLv = tonumber(castleBcell.info.lv)
	end
	local getTipType = function()
		if data.serviceCount and data.serviceCount > 0 then
			return cityBuildConstDef.topType.TOP_TYPE_COMMUNITY_SERVICE
		elseif activityCenterUICtrl:isHaveNewFlag(gActivityCenterUIEnum.MAIN_CITY_BILLBOARD) then
			return cityBuildConstDef.topType.TOP_TYPE_COMMUNITY_BBS
		end
	end
	local deltaOffsetY = castleLv >= CASTLE_LV25_LIMITED and 76 or 76
	local deltaOffsetX = castleLv >= CASTLE_LV25_LIMITED and -7 or 0
	local btnCommunityPos = cc.p(buttonCommunityCenter:getPosition())
	local createBtnTip = function(...)
		local buildTopTipType = getTipType()
		local buildTopTipPosition = cc.p(btnCommunityPos.x + deltaOffsetX, btnCommunityPos.y + deltaOffsetY)
		local buildTipNode = cityBuildCreator:createBuildTop(buildTopTipType, self.tblBatchNodesTopTip, buildTopTipPosition)
		buildTipNode:setName("build_topTip_" .. cityBuildConstDef.OtherBuildDef.CommunityCenter)
		buildTipNode:setPosition(buildTopTipPosition)
		buildTipNode:setTag(cityBuildConstDef.OtherBuildDef.CommunityCenter)
		buildTipNode:addTo(self.containerView, 1800)
		local btnTip = SoraDGetChildByName(buildTipNode, "btn")
		btnTip:setTouchEnabled(true)
		btnTip:setTag(cityBuildConstDef.OtherBuildDef.CommunityCenter)
		btnTip.topType = buildTopTipType
		btnTip:addTouchEventListener(function(ref, type)
			self:onOtherTopTipCallBack(btnTip, ref, type)
		end)
		self.tipTopCommunity = buildTipNode
	end
	if self.tipTopCommunity == nil then
		createBtnTip()
	else
		local btnTip = SoraDGetChildByName(self.tipTopCommunity, "btn")
		if btnTip then
			local topType = btnTip.topType
			if topType ~= getTipType() then
				activityCenterUICtrl = buttonCommunityCenter:getPosition()
				buttonCommunityCenter:getPosition().msg = "MESSAGE_MAINCITYVIEW_HIDE_COMMUNITYCENTER_MSG"
				SoraDSendMessage(buttonCommunityCenter:getPosition())
				createBtnTip()
			else
				self.tipTopCommunity:setVisible(true)
				local buildTopTipPosition = cc.p(btnCommunityPos.x + deltaOffsetX, btnCommunityPos.y + deltaOffsetY)
				self.tipTopCommunity:setPosition(buildTopTipPosition)
				self.tipTopCommunity:setBasePos(buildTopTipPosition)
				self.tipTopCommunity:udpateViewWithBasePos()
			end
		end
	end
end
function mainCityMsg.msgHideCommunityCenterMsg(mainCity, target, data)
	local self = mainCity
	self.hasCommunityCenterMsg = false
	if self.tipTopCommunity then
		self.tipTopCommunity:setVisible(false)
		self.tipTopCommunity:removeNodeRelyOn()
		self.tipTopCommunity:recycleNode()
		self.tipTopCommunity:removeFromParent()
		self.tipTopCommunity = nil
	end
end
function mainCityMsg.msgHideConquerGateMsg(mainCity, target, data)
	local self = mainCity
	self.hasConquerGateMsg = false
	if self.tipBoxConquerGate then
		self.tipBoxConquerGate:setVisible(false)
		self.tipBoxConquerGate:removeNodeRelyOn()
		self.tipBoxConquerGate:recycleNode()
		self.tipBoxConquerGate:removeFromParent()
		self.tipBoxConquerGate = nil
	end
end
function mainCityMsg.msgFirstFightEnd(mainCity, target, data)
	local self = mainCity
	print("第一场战斗结束了")
	_ENV = "第一场战斗结束了"
	;("第一场战斗结束了").msg = "MESSAGE_MAIN_SCENE_IPHONEX"
	;("第一场战斗结束了").isShow = true
	SoraDSendMessage("第一场战斗结束了")
	self.isNeedFirstFight = false
	cityBuildFunction.isNeedFirstFight = false
	local viewScrollViewSize = cc.size(self:getContentSize().width, self:getContentSize().height - (self.hUITop + self.hUIBottom + display.iPhoneXOffset))
	self.viewScrollView:setViewSize(viewScrollViewSize)
	local viewScrollViewPos = cc.p(display.width / 2, self.hUIBottom + display.iPhoneXBottom + viewScrollViewSize.height / 2)
	self.viewScrollView:setPosition(viewScrollViewPos)
	_ENV = self.viewScrollView
	self.viewScrollView.msg = "MESSAGE_MAIN_UI_HIDDLE"
	self.viewScrollView.isHiddle = false
	SoraDSendMessage(self.viewScrollView)
	mainCityCreate.initAfterCreate(self)
end
function mainCityMsg.msgCleanMainCityGuide(mainCity, target, data)
	mainCityCreate.cleanMainCityGuide(mainCity)
end
function mainCityMsg.showLordSkillEffect(mainCity, target, data)
	local self = mainCity
	self:disableMoveForDuration()
	local skillID = data.data.skillID
	if not data.data.extraData then
		local _ENV, extraData = data.data.extraData, data.data.extraData
	end
	local err = data.data.err
	if err == gErrDef.Err_None then
		local trapType
		if next(extraData) then
			for k, v in pairs(extraData) do
				trapType = tonumber(k)
			end
		end
		self:showSkillEffectBySkillID(skillID, trapType)
	end
end
function mainCityMsg.msgUpdateGuardSoldierBox(mainCity, target, data)
	local self = mainCity
	local tipBoxName = "guardSoldierTipBox"
	if self.tipBoxGuardSoldier == nil then
		local node = display.newNode()
		self.containerView:addChild(node)
		node:setLocalZOrder(1202)
		self.tipBoxGuardSoldierNode = node
		local desItem = self:getOneGuardSoldierDes()
		local cityBuildTipBox = include("cityBuildTipBox")
		local cityBuildTipBoxNode = cityBuildTipBox.new()
		local soldierGuard = self:getBufferNodeByName("soldier_guard_2")
		_ENV = self
		self.boxType = cityBuildConstDef.TipBoxType.TEXT_TYPE_1
		self.content = i18n(desItem.des)
		self.handler = handler(self, self.onTipBoxCall)
		self.tag = cityBuildConstDef.OtherBuildDef.GuardSolider
		self.follow = soldierGuard
		self.maxWidth = 200
		self.autoDelete = true
		local self.jumpData, data = desItem.jumpData, self
		cityBuildTipBoxNode:initWithData(data)
		cityBuildTipBoxNode:setName(tipBoxName)
		if soldierGuard then
			local x, y = soldierGuard:getPosition()
			cityBuildTipBoxNode:setPosition(cc.p(x, y + 15))
		else
			cityBuildTipBoxNode:setPosition(cc.p(3035.0, 756.0))
		end
		self.tipBoxGuardSoldierNode:addChild(cityBuildTipBoxNode)
		self.tipBoxGuardSoldier = cityBuildTipBoxNode
	else
		self.tipBoxGuardSoldier:setVisible(true)
		local desItem = self:getOneGuardSoldierDes()
		local soldierGuard = self:getBufferNodeByName("soldier_guard_2")
		_ENV = self
		self.boxType = cityBuildConstDef.TipBoxType.TEXT_TYPE_1
		self.content = i18n(desItem.des)
		self.handler = handler(self, self.onTipBoxCall)
		self.tag = cityBuildConstDef.OtherBuildDef.GuardSolider
		self.follow = soldierGuard
		self.maxWidth = 200
		self.autoDelete = true
		local self.jumpData, data = desItem.jumpData, self
		self.tipBoxGuardSoldier:initWithData(data)
		if soldierGuard then
			local x, y = soldierGuard:getPosition()
			self.tipBoxGuardSoldier:setPosition(cc.p(x + 4, y + 17))
		else
			self.tipBoxGuardSoldier:setPosition(cc.p(3035.0, 756.0))
		end
	end
end
function mainCityMsg.msgShowCommandHallNpc(mainCity, target, data)
	local self = mainCity
	local commandHallCtrl = SoraDGetCtrl("commandHallCtrl")
	if not commandHallCtrl:getIsShowFighting() then
		return
	end
	commandHallCtrl:setIsShowFighting(false)
	local beginWork = function(show)
		if self.commandHallNpcEffect then
			self.commandHallNpcEffect:removeFromParent()
			self.commandHallNpcEffect = nil
		end
		if self.commandHallNpcSoundId then
			AudioEngine.stopEffect(self.commandHallNpcSoundId)
			self.commandHallNpcSoundId = nil
		end
		if self.tipBoxGuardSoldierNode then
			self.tipBoxGuardSoldierNode:setVisible(show)
			for i = 1, 4 do
				local soldierGuard = self:getBufferNodeByName("soldier_guard_" .. i)
				if soldierGuard then
					soldierGuard:setVisible(show)
				end
			end
		end
		if self.commandHallBox then
			self.commandHallBox:setVisible(show)
		end
	end
	beginWork(false)
	SoraDShowLoading(nil, nil, nil, true)
	if not commandHallCtrl:getFightingResult() then
		local _ENV, result = commandHallCtrl:getFightingResult(), commandHallCtrl:getFightingResult()
	end
	local effectName = "Node_tsdt_lose"
	if result.win then
		effectName = "Node_tsdt_win"
	end
	local effect = SoraDCreatAnimation(effectName)
	effect:addTo(self.containerView)
	effect:setLocalZOrder(1202)
	local commandHallUtil = include("commandHallUtil")
	local pos = commandHallUtil.getShowFightingPos()
	effect:setPosition(cc.p(pos.x - 600, pos.y - 700))
	effect:setName(effectName)
	_UPVALUE1_ = effectName
	effectName[1] = "Node_result"
	local Node_result = SoraDGetChildByFullPath(effect, effectName)
	if Node_result then
		Node_result:setVisible(false)
	end
	self.commandHallNpcEffect = effect
	self.commandHallNpcSoundId = SoraDPlaySound("mainCityGuide", "newplayer_fight")
	_UPVALUE3_ = cc.p(pos.x - 600, pos.y - 700)
	cc.p(pos.x - 600, pos.y - 700)[1] = cca.delay(5.0)
	cc.p(pos.x - 600, pos.y - 700)[2] = cca.callFunc(function()
		SoraDCloseLoading()
		if not commandHallCtrl:getFightingResult() then
			local _ENV, result = commandHallCtrl:getFightingResult(), commandHallCtrl:getFightingResult()
		end
		_ENV = nil
		;(nil).armyGroupID = result.armyGroupID
		uiManager:show("CommandHallResult", nil)
	end)
	cc.p(pos.x - 600, pos.y - 700)[3] = cca.delay(2.0)
	cc.p(pos.x - 600, pos.y - 700)[4] = cca.callFunc(function()
		beginWork(true)
	end)
	cc.p(pos.x - 600, pos.y - 700)[5] = cca.callFunc(function()
		beginWork(true)
	end)
	effect:runAction(cca.seq(cc.p(pos.x - 600, pos.y - 700)))
end
function mainCityMsg.msgShowCommandHallBox(mainCity, target, data)
	local self = mainCity
	local commandHallCtrl = SoraDGetCtrl("commandHallCtrl")
	local task = commandHallCtrl:getArmyGroupTaskData()
	if task and task.statue and task.statue == gCommandHallTaskStatue.FINISH then
		if not self.commandHallBox then
			self.commandHallBox = effectMainCityView.addCommandHallBox(self)
		end
		if self.commandHallNpcEffect then
			self.commandHallBox:setVisible(false)
		end
	elseif self.commandHallBox then
		self.commandHallBox:removeFromParent()
		self.commandHallBox = nil
	end
end
function mainCityMsg.msgUpdateMerchantView(mainCity, target, data)
	local self = mainCity
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local castleLV = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
	if castleLV < CASTLE_LV6_LIMITED then
		return
	end
	local storesCtrl = gametop.playertop_:getModule("storesCtrl")
	local ret = storesCtrl:isActOpen()
	if not ret then
		if self.tipBoxMerchant then
			self.tipBoxMerchant:removeFromParent()
			self.tipBoxMerchant = nil
		end
		if self.efffectMerchant then
			self.efffectMerchant:setVisible(false)
		end
		return
	end
	local tipBoxName = "merchantTipBox"
	if self.tipBoxMerchant == nil then
		local textContent = i18n("common_text_1516")
		local cityBuildTipBox = include("cityBuildTipBox")
		local cityBuildTipBoxNode = cityBuildTipBox.new()
		local btnMerchant = self:getBufferNodeByName("Button_Merchante")
		_ENV = self
		self.boxType = cityBuildConstDef.TipBoxType.TEXT_TYPE_1
		self.content = textContent
		self.handler = handler(self, self.onTipBoxCall)
		self.tag = cityBuildConstDef.OtherBuildDef.Merchant
		self.maxWidth = 200
		self.autoDelete = true
		local self.needCenter, data = true, self
		cityBuildTipBoxNode:initWithData(data)
		cityBuildTipBoxNode:setName(tipBoxName)
		local tipPos = cc.p(2200, 1240)
		if btnMerchant then
			tipPos.x = btnMerchant:getPositionX() + btnMerchant:getContentSize().width / 2
			tipPos.y = btnMerchant:getPositionY() + btnMerchant:getContentSize().height
		end
		cityBuildTipBoxNode:setPosition(tipPos)
		self.containerView:addChild(cityBuildTipBoxNode, 1061)
		self.tipBoxMerchant = cityBuildTipBoxNode
	else
		self.tipBoxMerchant:setVisible(true)
		local textContent = i18n("common_text_1516")
		local btnMerchant = self:getBufferNodeByName("Button_Merchante")
		_ENV = self
		self.boxType = cityBuildConstDef.TipBoxType.TEXT_TYPE_1
		self.content = textContent
		self.handler = handler(self, self.onTipBoxCall)
		self.tag = cityBuildConstDef.OtherBuildDef.Merchant
		self.maxWidth = 200
		self.autoDelete = true
		local self.needCenter, data = true, self
		self.tipBoxMerchant:initWithData(data)
		local tipPos = cc.p(2200, 1240)
		if btnMerchant then
			tipPos.x = btnMerchant:getPositionX() + btnMerchant:getContentSize().width / 2
			tipPos.y = btnMerchant:getPositionY() + btnMerchant:getContentSize().height
		end
		self.tipBoxMerchant:setPosition(tipPos)
	end
	if self.efffectMerchant then
		self.efffectMerchant:setVisible(true)
	else
		_ENV, _ENV = self.efffectMerchant, self.efffectMerchant.setVisible
		_ENV, self.efffectMerchant.plist = true, "et_shenmishangren_01.plist"
		;(true).x = 5
		self.efffectMerchant.pos, (true).y = true, 0
		self.efffectMerchant.scale = 1.855
		_ENV, self.efffectMerchant.setVisible[1], self.efffectMerchant.rotate = self.efffectMerchant, self.efffectMerchant, -21.36
		_ENV, self.efffectMerchant.plist = true, "et_shenmishangren_02.plist"
		;(true).x = 5
		self.efffectMerchant.pos, (true).y = true, 11
		self.efffectMerchant.setVisible[2], self.efffectMerchant.scale = self.efffectMerchant, 1.144
		local effectMerchantCfg = self.efffectMerchant.setVisible
		self.efffectMerchant = SoraDCreateEffectNode(effectMerchantCfg)
		self.containerView:addChild(self.efffectMerchant, 35)
		self.efffectMerchant:setPosition(cc.p(5920, 3250))
	end
end
function mainCityMsg.msgMainCityDownloadSuccess(mainCity, target, data)
	local self = mainCity
	local key = data.key
	print("key============", key, string.find(data.key, "castleSkin_"))
	if string.find(data.key, "castleSkin_") then
		local gametop = gModuleMgr.getObject("gametop")
		local dressCtrl = gametop.playertop_:getModule("dressCtrl")
		local skinID = self.selectSkinID or dressCtrl:getDressOfCastle()
		effectMainCityView.updateCastle(self, self.togglePeriod, skinID, nil, true)
	end
	if key == self.groundPetKey or key == self.skyPetKey then
		_ENV = gametop.playertop_:getModule("dressCtrl")
		gametop.playertop_:getModule("dressCtrl").msg = "MESSAGE_MAINCITYVIEW_UPDATE_PET_SHOW"
		SoraDSendMessage((gametop.playertop_:getModule("dressCtrl")))
	end
end
function mainCityMsg.refreshCastleSkin(mainCity, target, data)
	local self = mainCity
	local skinID = data and data.skinID or nil
	local isInit = false
	local isEnd = false
	if data and data.isInit then
		isInit = true
	end
	if data and data.isEnd then
		isEnd = true
	end
	effectMainCityView.updateCastle(self, self.togglePeriod, skinID, isInit, isEnd)
end
function mainCityMsg.msgToggleDark(mainCity, target, data)
	local self = mainCity
	local dayPeriod = SoraDGetDayPeriod()
	if self.togglePeriod == nil then
		self.togglePeriod = dayPeriod
	end
	if self.togglePeriod == gDay.DAY_DUSK then
		self.togglePeriod = gDay.DAY_NIGHT
	elseif self.togglePeriod == gDay.DAY_NIGHT then
		self.togglePeriod = gDay.DAY_DAWN
	elseif self.togglePeriod == gDay.DAY_DAWN then
		self.togglePeriod = gDay.DAY_TIME
	elseif self.togglePeriod == gDay.DAY_TIME then
		self.togglePeriod = gDay.DAY_DUSK
	end
	if self.togglePeriod == gDay.DAY_TIME then
		effectMainCityView.hideDark(self)
		mainCityCreate.initWeather(self)
		effectMainCityView.cloudRunEffect(self)
	else
		effectMainCityView.showDark(self, self.togglePeriod)
		effectMainCityView.removeWeatherEffect(self, nil, true)
		effectMainCityView.removeCloudEffect(self)
	end
	effectMainCityView.updateNightScene(self, self.togglePeriod)
end
function mainCityMsg.msgUpdateNightCfg(mainCity, target, data)
	local self = mainCity
	self.isCfgNightOn = SoraDConfigGet("Game:GameOptionsView:nightSwitch~bool")
	self:updatePeriod()
end
function mainCityMsg.addHarvestEffect(mainCity, target, data)
	local self = mainCity
	effectMainCityView.addHarvestEffect(self)
end
function mainCityMsg.msgRemoveHarvestEffect(mainCity, target, data)
	local self = mainCity
	effectMainCityView.msgRemoveHarvestEffect(self, target, data)
end
function mainCityMsg.msgUpdateHorseFlag(mainCity, target, data)
	local self = mainCity
	local createHorseFlag = function(angle, isFlipX)
		local node = display.newNode()
		node:setScale(0.4)
		local baseView = include("baseView")
		local btn = baseView.new(cc.size(200, 200), false)
		btn:setAnchorPoint(cc.p(0.5, 0.5))
		btn:setPosition(0, 0)
		btn:addTo(node)
		btn:addTouchEventListener(function(target, event)
			if event == ccui.TouchEventType.ended then
				local area = cityBuildHorseFlag.getAreaByPos(cc.p(node:getPositionX(), node:getPositionY()))
				if area then
					cityHorseCtrl:sendReceive(area)
				end
			end
		end)
		local sprite = display.newSprite("#zhuha_yd_" .. angle .. "_01.png")
		sprite:setFlippedX(isFlipX)
		sprite:setPosition(0, 0)
		sprite:setName("npcxd")
		sprite:addTo(node)
		return node
	end
	local function runHorseFlag(bPos, ePos, angle, isFlipX, beginPoint, endPoint)
		local zOrder = cityBuildHorseFlag.getZorderByIndex(endPoint)
		self.horseFlag:setLocalZOrder(zOrder)
		local npc = self.horseFlag:getChildByName("npcxd")
		npc:stopAllActions()
		npc:setFlippedX(isFlipX)
		local frames = display.newFrames("zhuha_yd_" .. angle .. "_%02d.png", 1, 16)
		local animation = display.newAnimation(frames, 0.075)
		npc:playAnimationForever(animation)
		local distance = cc.pGetDistance(bPos, ePos)
		local speed = 20
		self = nil
		;(nil)[1] = cca.moveTo(distance / speed, ePos.x, ePos.y)
		;(nil)[2] = cca.callFunc(function()
			cityBuildHorseFlag.setPrePoint(beginPoint)
			local newEndPoint = cityBuildHorseFlag.getEndPoint(beginPoint)
			local bPos = ePos
			local ePos = cityBuildHorseFlag.getPosByIndex(newEndPoint)
			local _, angle, isFlipX = worldMapFunction.getSoliderImgAngel(bPos, ePos)
			runHorseFlag(bPos, ePos, angle, isFlipX, beginPoint, newEndPoint)
		end)
		;(nil)[3] = cca.callFunc(function()
			cityBuildHorseFlag.setPrePoint(beginPoint)
			local newEndPoint = cityBuildHorseFlag.getEndPoint(beginPoint)
			local bPos = ePos
			local ePos = cityBuildHorseFlag.getPosByIndex(newEndPoint)
			local _, angle, isFlipX = worldMapFunction.getSoliderImgAngel(bPos, ePos)
			runHorseFlag(bPos, ePos, angle, isFlipX, beginPoint, newEndPoint)
		end)
		;(nil)[4] = cca.callFunc(function()
			cityBuildHorseFlag.setPrePoint(beginPoint)
			local newEndPoint = cityBuildHorseFlag.getEndPoint(beginPoint)
			local bPos = ePos
			local ePos = cityBuildHorseFlag.getPosByIndex(newEndPoint)
			local _, angle, isFlipX = worldMapFunction.getSoliderImgAngel(bPos, ePos)
			runHorseFlag(bPos, ePos, angle, isFlipX, beginPoint, newEndPoint)
		end)
		local action = cca.seq(nil)
		self.horseFlag:runAction(action)
	end
	if cityHorseCtrl:isCanReceive() then
		if self.horseFlag ~= nil then
			return
		end
		local beginPoint = cityBuildHorseFlag.getBeginPoint()
		local endPoint = cityBuildHorseFlag.getEndPoint(beginPoint)
		local bPos = cityBuildHorseFlag.getPosByIndex(beginPoint)
		local ePos = cityBuildHorseFlag.getPosByIndex(endPoint)
		local _, angle, isFlipX = worldMapFunction.getSoliderImgAngel(bPos, ePos)
		self.horseFlag = createHorseFlag(angle, isFlipX)
		self.horseFlag:setPosition(bPos)
		self.horseFlag:addTo(self.containerView, 1)
		runHorseFlag(bPos, ePos, angle, isFlipX, beginPoint, endPoint)
	elseif self.horseFlag then
		self.horseFlag:removeFromParent()
		self.horseFlag = nil
	end
end
function mainCityMsg.msgAutoCollectRes(mainCity, target, data)
	local self = mainCity
	local mainCityFunctions = include("mainCityFunctions")
	mainCityFunctions.autoCollectRes(self)
end
function mainCityMsg.msgShowBulletInBoardMsg(mainCity, target, data)
	dump(data, "公告栏数据")
	do return end
	local self = mainCity
	local eventType = data.eventType
	local count = data.count
	local msgActivityCount = 0
	local msgBulletinCount = 0
	local msgOtherCount = 0
	if eventType == cityBuildConstDef.eventTypeNoticeBoard.eventType_none then
	elseif eventType == cityBuildConstDef.eventTypeNoticeBoard.eventType_activity then
		if count ~= nil then
			msgActivityCount = count
		end
	elseif eventType == cityBuildConstDef.eventTypeNoticeBoard.eventType_notice then
		if count ~= nil then
			msgBulletinCount = count
		end
	elseif eventType == cityBuildConstDef.eventTypeNoticeBoard.eventType_other and count ~= nil then
		msgOtherCount = count
	end
	print("msgActivityCount, = ", msgActivityCount)
	if msgActivityCount == nil and msgBulletinCount == nil and msgOtherCount == nil then
		return
	end
	local buttonBulletInBoard = self:getBufferNodeByName("Button_bulletin_board")
	if not buttonBulletInBoard then
		return
	end
	local btnBulletinPos = cc.p(buttonBulletInBoard:getPosition())
	if tonumber(msgActivityCount) == 0 and tonumber(msgBulletinCount) == 0 and tonumber(msgOtherCount) == 0 then
		_ENV = msgOtherCount
		msgOtherCount.msg = "MESSAGE_MAINCITYVIEW_HIDE_BULLETINBOARD_MSG"
		SoraDSendMessage(msgOtherCount)
		return
	end
	self.hasBulletinMsg = true
	if self.tipBoxBulletIn then
		self.tipBoxBulletIn:setVisible(false)
	end
	local nodeName = "build_topTip_" .. cityBuildConstDef.OtherBuildDef.BulletInBoard
	if self.tipBoxBulletIn == nil then
		local buildTopTip = include("cityBuildTop")
		local buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_BULLETIN_BOARD
		local deltaOffsetY = 43
		local deltaOffsetX = 3
		local buildTopTipPosition = cc.p(btnBulletinPos.x + deltaOffsetX, btnBulletinPos.y + deltaOffsetY)
		local buildTipNode = cityBuildCreator:createBuildTop(buildTopTipType, self.tblBatchNodesTopTip, buildTopTipPosition)
		buildTipNode:setName("build_topTip_" .. cityBuildConstDef.OtherBuildDef.BulletInBoard)
		buildTipNode:setPosition(buildTopTipPosition)
		buildTipNode:setTag(cityBuildConstDef.OtherBuildDef.BulletInBoard)
		buildTipNode:addTo(self.containerView, 1300)
		local btnTip = SoraDGetChildByName(buildTipNode, "btn")
		btnTip:setTouchEnabled(true)
		btnTip:setTag(cityBuildConstDef.OtherBuildDef.BulletInBoard)
		btnTip.topType = buildTopTipType
		if msgActivityCount ~= nil and 0 < msgActivityCount then
			buildTipNode:setIcon("icon_notice_board_limit.png")
		elseif msgBulletinCount ~= nil and 0 < msgBulletinCount then
			buildTipNode:setIcon("icon_notice_board_suona.png")
		elseif msgOtherCount ~= nil and 0 < msgOtherCount then
			buildTipNode:setIcon("icon_notice_board_talk.png")
		end
		btnTip:addTouchEventListener(function(ref, type)
			self:onOtherTopTipCallBack(btnTip, ref, type)
		end)
		self.tipBoxBulletIn = buildTipNode
		self.tipBoxBulletIn:setVisible(IsArClient)
	else
		self.tipBoxBulletIn:setVisible(IsArClient)
		local deltaOffsetY = 43
		local deltaOffsetX = 3
		local buildTopTipPosition = cc.p(btnBulletinPos.x + deltaOffsetX, btnBulletinPos.y + deltaOffsetY)
		self.tipBoxBulletIn:setPosition(buildTopTipPosition)
		self.tipBoxBulletIn:setBasePos(buildTopTipPosition)
		self.tipBoxBulletIn:udpateViewWithBasePos()
		if msgActivityCount ~= nil and 0 < msgActivityCount then
		elseif msgBulletinCount ~= nil and 0 < msgBulletinCount then
		elseif msgOtherCount == nil or 0 < msgOtherCount then
		end
	end
	local bg_bulletin_board = self:getBufferNodeByName("BG_bulletin_board")
	if bg_bulletin_board then
		local dh = SoraDGetChildByName(bg_bulletin_board, "dh_gongshipai")
		if dh then
			dh:setVisible(true)
			_ENV = true
			;(true).beginOpacity = 0.4
			;(true).endOpacity = 1
			SoraDFadeINOUT(dh, true)
		end
	end
end
function mainCityMsg.msgHideBulletInBoardMsg(mainCity, target, data)
	local self = mainCity
	self.hasBulletinMsg = false
	if self.tipBoxBulletIn then
		self.tipBoxBulletIn:setVisible(false)
		self.tipBoxBulletIn:removeNodeRelyOn()
		self.tipBoxBulletIn:recycleNode()
		self.tipBoxBulletIn:removeFromParent()
		self.tipBoxBulletIn = nil
	end
	local bg_bulletin_board = self:getBufferNodeByName("BG_bulletin_board")
	if bg_bulletin_board then
		local dh = SoraDGetChildByName(bg_bulletin_board, "dh_gongshipai")
		if dh then
			dh:stopAllActions()
			dh:setVisible(false)
		end
	end
end
function mainCityMsg.msgJump(mainCity, target, data)
	local self = mainCity
	local jumpType = data.jumpType
	local bid = data.bid
	if jumpType == "cityInner" then
		self:gotoInnerCity()
	elseif jumpType == "cityOtherBuild" then
		if bid == cityBuildConstDef.OtherBuildDef.Gangkou then
			cityBuildConstDef = self
			self.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP_HAND"
			self.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD_TIP_HAND
			self.buildIndex = cityBuildConstDef.OtherBuildDef.Gangkou
			SoraDSendMessage(self)
		elseif bid == cityBuildConstDef.OtherBuildDef.Merchant then
			cityBuildConstDef = self
			self.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP_HAND"
			self.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD_TIP_HAND
			self.buildIndex = cityBuildConstDef.OtherBuildDef.Merchant
			SoraDSendMessage(self)
		elseif bid == cityBuildConstDef.OtherBuildDef.ActivityCenter then
			cityBuildConstDef = self
			self.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP_HAND"
			self.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD_TIP_HAND
			self.buildIndex = cityBuildConstDef.OtherBuildDef.ActivityCenter
			SoraDSendMessage(self)
		else
			cityBuildConstDef = self
			self.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP_HAND"
			self.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD_TIP_HAND
			self.buildIndex = bid
			SoraDSendMessage(self)
		end
	elseif jumpType == "cityFixedBuild" then
		if bid == cityBuildConstDef.fixedBuildDef.HuoChuang then
			cityBuildConstDef = self
			self.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP_HAND"
			self.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD_TIP_HAND
			self.fixedBuildIndex = cityBuildConstDef.fixedBuildDef.HuoChuang
			SoraDSendMessage(self)
		elseif bid == cityBuildConstDef.fixedBuildDef.LeisureCenter then
			cityBuildConstDef = self
			self.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP_HAND"
			self.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD_TIP_HAND
			self.fixedBuildIndex = cityBuildConstDef.fixedBuildDef.LeisureCenter
			SoraDSendMessage(self)
		elseif bid == cityBuildConstDef.fixedBuildDef.PetCenter then
			cityBuildConstDef = self
			self.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP_HAND"
			self.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD_TIP_HAND
			self.fixedBuildIndex = cityBuildConstDef.buildIndexDef.index_PetCenter
			SoraDSendMessage(self)
		elseif bid == cityBuildConstDef.fixedBuildDef.EpicBattle then
			cityBuildConstDef = self
			self.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP_HAND"
			self.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD_TIP_HAND
			self.fixedBuildIndex = cityBuildConstDef.buildIndexDef.index_EpicBattle
			SoraDSendMessage(self)
		else
			cityBuildConstDef = self
			self.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP_HAND"
			self.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD_TIP_HAND
			self.fixedBuildIndex = bid
			SoraDSendMessage(self)
		end
	end
end
function mainCityMsg.addBuildTopTipHuochuang(mainCity, target, data)
	local self = mainCity
	effectMainCityView.addBuildTopTipHuochuang(self)
end
function mainCityMsg.msgShowTopTipActivity(mainCity, target, data)
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.EVENT_CENTER)
	if unlockLv > SoraDGetCastleLv() then
		return
	end
	local mainCityFunctions = include("mainCityFunctions")
	local des, img, ret = mainCityFunctions.getOneActivityCenterDes(mainCity)
	if not ret then
		return
	end
	local self = mainCity
	local nodeName = "build_topTip_" .. cityBuildConstDef.OtherBuildDef.ActivityCenter
	local buildTipNode = self.containerView:getChildByName(nodeName)
	if buildTipNode then
		if buildTipNode.setIcon then
			buildTipNode:setIcon(img)
		end
		buildTipNode:setVisible(true)
		if buildTipNode.setAutoDelete then
			buildTipNode:setAutoDelete()
		end
		return
	end
	local buildTopTip = include("cityBuildTop")
	local buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_ACTIVITY
	local buildTopTipPosition = cc.p(self.buttonActivity:getPositionX() - 15, self.buttonActivity:getPositionY() + 150)
	local buildTipNode = cityBuildCreator:createBuildTop(buildTopTipType, self.tblBatchNodesTopTip, buildTopTipPosition)
	buildTipNode:setName("build_topTip_" .. cityBuildConstDef.OtherBuildDef.ActivityCenter)
	buildTipNode:setPosition(buildTopTipPosition)
	buildTipNode:setTag(cityBuildConstDef.OtherBuildDef.ActivityCenter)
	buildTipNode:addTo(self.containerView, 1300)
	if buildTipNode.setIcon then
		buildTipNode:setIcon(img)
	end
	if buildTipNode.setAutoDelete then
		buildTipNode:setAutoDelete()
	end
	local btnTip = SoraDGetChildByName(buildTipNode, "btn")
	if btnTip then
		btnTip:setTouchEnabled(true)
		btnTip:setTag(cityBuildConstDef.OtherBuildDef.ActivityCenter)
		btnTip.topType = buildTopTipType
		btnTip:addTouchEventListener(function(ref, type)
			self:onOtherTopTipCallBack(btnTip, ref, type)
		end)
	end
end
function mainCityMsg.msgHideTopTipActivity(mainCity, target, data)
	local self = mainCity
	local buildTopTipName = "build_topTip_" .. cityBuildConstDef.OtherBuildDef.ActivityCenter
	local buildTopTipNode = self:getBufferNodeByName(buildTopTipName)
	if nil == buildTopTipNode and self.containerView then
		buildTopTipNode = self.containerView:getChildByName(buildTopTipName)
	end
	if nil == buildTopTipNode then
		return
	end
	self:delBufferNodeByName(buildTopTipName)
	if buildTopTipNode.removeNodeRelyOn then
		buildTopTipNode:removeNodeRelyOn()
	end
	if buildTopTipNode.recycleNode then
		buildTopTipNode:recycleNode()
	end
	buildTopTipNode:removeFromParent()
end
function mainCityMsg.msgUpdateMagicLampTipBox(mainCity, target, data)
	local self = mainCity
	local bubbleType = data.bubbleType
	local jumpMagicPoolId = data.jumpMagicPoolId
	local jumpHatchType = data.jumpHatchType
	local jumpJinnType = data.jumpJinnType
	local bubbleIcon = data.bubbleIcon
	local buildTopTipName = "build_topTip_magicLamp"
	local button = self:getBufferNodeByName(buildTopTipName)
	local magicLampBuild = self:getBufferNodeByName("build_30010")
	if nil == magicLampBuild then
		return
	end
	if bubbleType == nil then
		if button then
			button:removeFromParent()
			self:delBufferNodeByName(buildTopTipName)
		end
	else
		local clickFunc = function()
			if bubbleType == "strength" or bubbleType == "star" or bubbleType == "class" or bubbleType == "star_river" then
				bubbleType = nil
				;(nil).curType = jumpJinnType
				uiManager:show("MagicLampMain", nil)
			elseif bubbleType == "pray" then
				local magicLampSkillLotteryCtrl = SoraDGetCtrl("magicLampSkillLotteryCtrl")
				magicLampSkillLotteryCtrl:setMagicPoolClick(jumpMagicPoolId)
				bubbleType = jumpJinnType
				jumpJinnType.magicPoolID = jumpMagicPoolId
				uiManager:show("MagicLampMaigcPowerMain", jumpJinnType)
				bubbleType = uiManager
				uiManager.msg = "MESSAGE_MAGICLAMP_UPDATE_BUBBLEDATA"
				SoraDSendMessage(uiManager)
			elseif bubbleType == "merge" then
				uiManager:show("MagicLampSkillHandbook")
			elseif bubbleType == "hatch_gift" or bubbleType == "hatch_up" then
				local magicLampHatchRead = include("magicLampHatchRead")
				local hatchCfg = magicLampHatchRead.getHatchCfg(jumpHatchType)
				bubbleType = jumpMagicPoolId
				jumpMagicPoolId.jinnType = hatchCfg.jinnType[2]
				jumpMagicPoolId.hatchType = jumpHatchType
				uiManager:show("MagicLampHatch", jumpMagicPoolId)
			end
		end
		if not button then
			button = ccui.Button:create()
			local sp = display.newSprite("#img_lampalert_dots.png")
			sp:addTo(button)
			sp:setPosition(cc.p(0, 0))
			button:addTo(self.containerView, 1300)
			local x, y = magicLampBuild:getPosition()
			button:setPosition(x + 150, y + 350)
			button:setName(buildTopTipName)
			self:addToBufferNodeArrayByName(buildTopTipName, button)
		end
		button:loadTextures(bubbleIcon, "", "", ccui.TextureResType.plistType)
		button:addTouchEventListener(function(ref, event)
			if event == ccui.TouchEventType.ended then
				clickFunc()
			end
		end)
	end
end
function mainCityMsg.msgUpdatePetTipBox(mainCity, target, data)
	local self = mainCity
	local petCtrl = gametop.playertop_:getModule("petCtrl")
	local petList = petCtrl:getPetList()
	if petList == nil or #petList == 0 then
		return
	end
	local tipBoxName = "petTipBox"
	if self.tipBoxPet == nil then
		local textContent = self:getOnePetDes()
		local cityBuildTipBox = include("cityBuildTipBox")
		local cityBuildTipBoxNode = cityBuildTipBox.new()
		local groundPet = self.containerView:getChildByName("groundPetNode")
		gametop = self.containerView
		self.containerView.boxType = cityBuildConstDef.TipBoxType.TEXT_TYPE_1
		self.containerView.content = textContent
		self.containerView.handler = handler(self, self.onTipBoxCall)
		self.containerView.tag = cityBuildConstDef.fixedBuildDef.PetCenter
		self.containerView.follow = groundPet
		self.containerView.maxWidth = 200
		self.containerView.delayTime = 8
		local self.containerView.autoDelete, data = true, self.containerView
		cityBuildTipBoxNode:initWithData(data)
		cityBuildTipBoxNode:setName(tipBoxName)
		if groundPet then
			local x, y = groundPet:getPosition()
			cityBuildTipBoxNode:setPosition(cc.p(x, y + 15))
		else
			cityBuildTipBoxNode:setPosition(cc.p(512.0, 580.0))
		end
		self.containerView:addChild(cityBuildTipBoxNode)
		cityBuildTipBoxNode:setLocalZOrder(1202)
		self.tipBoxPet = cityBuildTipBoxNode
	else
		self.tipBoxPet:setVisible(true)
		local textContent = self:getOnePetDes()
		local groundPet = self.containerView:getChildByName("groundPetNode")
		gametop = self.containerView
		self.containerView.boxType = cityBuildConstDef.TipBoxType.TEXT_TYPE_1
		self.containerView.content = textContent
		self.containerView.handler = handler(self, self.onTipBoxCall)
		self.containerView.tag = cityBuildConstDef.fixedBuildDef.PetCenter
		self.containerView.follow = groundPet
		self.containerView.maxWidth = 200
		self.containerView.delayTime = 8
		local self.containerView.autoDelete, data = true, self.containerView
		self.tipBoxPet:initWithData(data)
		if groundPet then
			local x, y = groundPet:getPosition()
			self.tipBoxPet:setPosition(cc.p(x, y + 17))
		else
			self.tipBoxPet:setPosition(cc.p(512.0, 580.0))
		end
	end
end
function mainCityMsg.msgOpenBuildByBid(mainCity, target, data)
	local self = mainCity
	local bid = data.bid
	local view = data.view
	local notOpen = data.notOpen or false
	local isGuide = data.isGuide
	local qType = data.qType
	local goOuterCity = data.goOuterCity
	if isGuide and qType then
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		_ENV = nil
		;(nil).bid = bid
		mildGuideManager:starMildByNewPlayerQuestID(qType, nil)
		return
	end
	if goOuterCity then
		self:gotoOuterCity(true)
		return
	end
	local buildEntity = cityBuildMgr:getBuildByBid(bid)
	if buildEntity then
		cityBuildConstDef = nil
		;(nil)[1] = cca.callFunc(function()
			local buildIndex = buildEntity:getBuildIndex()
			buildEntity = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
			;(nil).offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD
			;(nil).buildIndex = buildIndex
			;(nil).scale = 0.9
			;(nil).skip = true
			SoraDSendMessage(nil)
		end)
		;(nil)[2] = cca.delay(0.6)
		;(nil)[3] = cca.callFunc(function()
			if notOpen then
			elseif bid == BUILDID.HOSTPITAL then
				local lv = buildEntity:getBuildLv()
				uiManager:show("HospitalView"):setLV(lv)
			elseif bid == BUILDID.WISHING_WELL then
				uiManager:show("TreasureHuntView")
			elseif bid == BUILDID.WALLS then
				uiManager:show("defendView")
			elseif bid == cityBuildConstDef.fixedBuildDef.ResurrectionHall then
				uiManager:show("ResurgenceTreeView")
			else
				notOpen = lv
				lv.bid = bid
				uiManager:show("soldiersCampView", lv)
			end
		end)
		;(nil)[4] = cca.callFunc(function()
			if notOpen then
			elseif bid == BUILDID.HOSTPITAL then
				local lv = buildEntity:getBuildLv()
				uiManager:show("HospitalView"):setLV(lv)
			elseif bid == BUILDID.WISHING_WELL then
				uiManager:show("TreasureHuntView")
			elseif bid == BUILDID.WALLS then
				uiManager:show("defendView")
			elseif bid == cityBuildConstDef.fixedBuildDef.ResurrectionHall then
				uiManager:show("ResurgenceTreeView")
			else
				notOpen = lv
				lv.bid = bid
				uiManager:show("soldiersCampView", lv)
			end
		end)
		self:runAction(cca.seq(nil))
	end
end
function mainCityMsg.msgUpdatePyramidBattle(mainCity, target, data)
	if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
		return
	end
	local self = mainCity
	local gametop = gModuleMgr.getObject("gametop")
	local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
	local state = pyramidWarCtrl:getPyramidWarOpenState()
	local seasonType = pyramidWarCtrl:getPyramidWarSeasonType()
	if state == gPyramidWarOpenState.OPEN then
		effectMainCityView.showPyramidBattleEffect(self)
	else
		effectMainCityView.showPyramidBattleEffect(self, true)
	end
end
function mainCityMsg.msgUpdateLion(mainCity, target, data)
	local self = mainCity
	local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
	local isShow = pyramidWarCtrl:isShowTop3Btn()
	effectMainCityView.updateNightScene(self)
	if pyramidWarCtrl.pinnacleSeasonState == gPinnacleSeasonState.FINISH or pyramidWarCtrl.curSeasonType == gSeasonType.REGULAR_SEASON then
		effectMainCityView.showPyramidHonourBuildEffect(self)
	else
		effectMainCityView.showPyramidHonourBuildEffect(self, true)
	end
end
function mainCityMsg.msgLoginFinish(mainCity, target, data)
	print("内城对象重新初始化----------")
	local self = mainCity
	local isNeedFight = self:getIsNeedFirstFight()
	if isNeedFight then
		self:cleanFirstFight()
		_ENV = self
		self.msg = "MESSAGE_SERVER_GUIDE_STEP_END"
		self.step = 1007
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_FIRST_FIGHT_END"
		SoraDSendMessage(self)
	end
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	if guideCtrl:getCurMainCityGuideStep() ~= nil then
		return
	end
	if self.moveBuildTip then
		_ENV = guideCtrl
		guideCtrl.msg = "MESSAGE_MAINCITYVIEW_LEAVE_MOVE_MODE"
		SoraDSendMessage(guideCtrl)
	end
	if self.currentSelectTip then
		self:removeBuildTip()
	end
	if self.currentSelectBuild then
		self:CancelBuildTint(self.currentSelectBuild)
		self.currentSelectBuild = nil
	end
	self.collectBuilds, _ENV, self.isMoveOnBuild = self.CancelBuildTint, self.CancelBuildTint, false
	local _ENV, buildIndexs = self.CancelBuildTint, self.CancelBuildTint
	local _ENV, demolishAbleIndexs = self, self
	local _ENV, coolingAbleIndexes = self.currentSelectBuild, self.currentSelectBuild
	for i = 1050, 1067 do
		table.insert(buildIndexs, i)
		table.insert(demolishAbleIndexs, i)
		table.insert(coolingAbleIndexes, i)
	end
	for i = 1100, 1134 do
		table.insert(buildIndexs, i)
		table.insert(demolishAbleIndexs, i)
		table.insert(coolingAbleIndexes, i)
	end
	for i = 1151, 1152 do
		table.insert(buildIndexs, i)
		table.insert(coolingAbleIndexes, i)
	end
	for i = 1200, 1206 do
		table.insert(buildIndexs, i)
		table.insert(coolingAbleIndexes, i)
	end
	for i = 30001, 30006 do
		table.insert(buildIndexs, i)
	end
	for i, v in ipairs(coolingAbleIndexes) do
		_ENV = i
		i.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_COOLING_PANEL"
		i.buildIndex = v
		i.isReconnect = true
		SoraDSendMessage(i)
		_ENV = i
		i.msg = "MESSAGE_MAINCITYVIEW_REMOVE_STATUEBRAVE_COOLING_PANEL"
		i.buildIndex = v
		i.isReconnect = true
		SoraDSendMessage(i)
	end
	for i, v in ipairs(buildIndexs) do
		_ENV = i
		i.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
		i.buildIndex = v
		i.isReconnect = true
		SoraDSendMessage(i)
	end
	for i, v in ipairs(demolishAbleIndexs) do
		local gametop = gModuleMgr.getObject("gametop")
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local buildCell = cityCtrl:getBuildCellByIndex(v)
		if not buildCell then
			_ENV = v
			v.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD"
			v.index = v
			v.isReconnect = true
			SoraDSendMessage(v)
		end
	end
	print("需要重新初始化的建筑：", #buildIndexs)
	for i, v in ipairs(buildIndexs) do
		local buildName = "build_" .. v
		local buildButton = self:getBufferNodeByName(buildName)
		if buildButton then
			local cityBuild = buildButton:getChildByName("buildName")
			if cityBuild then
				cityBuild:reInit()
			end
		end
	end
	local mainCityFunctions = include("mainCityFunctions")
	mainCityFunctions.updateLockArea(self)
	_ENV = self
	self.msg = "MESSAGE_MAINCITYVIEW_UPDATE_SOLDIER_MATRIXS"
	SoraDSendMessage(self)
	_ENV = table.insert
	table.insert.isInit = true
	self:refreshCastleSkin(self, table.insert)
	_ENV = self
	self.msg = "MESSAGE_MAINCITYVIEW_UPDATE_MERCHANT_VIEW"
	SoraDSendMessage(self)
	mainCityCreate.initWithHuoChuangData(self)
	mainCityCreate.initMatouData(self)
	mainCityCreate.checkPromoteArmy(self)
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	if guideCtrl:isGuideNotCompleted(gGuideModule.CASTLE_UPGRADE_NEW) then
		guideCtrl:updateNewGuide()
	else
		_ENV = guideCtrl
		guideCtrl.msg = "MESSAGE_MAIN_AGREEMENT_BOX"
		SoraDSendMessage(guideCtrl)
		cityBuildFunction:checkGuide(true)
	end
end
function mainCityMsg.msgwillOpen(mainCity, target, data)
	mainCity:cleanMainCityView()
end
function mainCityMsg.msgChangeQuality(mainCity, target, data)
	local self = mainCity
	print("收到画质切换请求------, gIsGameHeighQuality = ", gIsGameHeighQuality)
	dump(data, "画质切换")
	if gIsGameHeighQuality then
		if self.cityWaterNode then
			self.cityWaterNode:setVisible(true)
		end
	elseif self.cityWaterNode then
		self.cityWaterNode:setVisible(false)
	end
end
function mainCityMsg.msgUpdateArmyPromoteTopTip(mainCity, target, data)
	local self = mainCity
	local gametop = gModuleMgr.getObject("gametop")
	local armyCtrl = gametop.playertop_:getModule("armyCtrl")
	local isPromoteArmy = armyCtrl:isArmyCanPromote()
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	local promoteQueue = queueCtrl:queryQueue(gQueueTypeDef.prompt_army)
	if isPromoteArmy and not promoteQueue then
		local nodeName = "build_topTip_" .. cityBuildConstDef.buildIndexDef.index_TroopFlag
		local buildTipNode = self:getBufferNodeByName(nodeName)
		if buildTipNode then
			return
		end
		local x, y = self.buttonMilitaryInfo:getPosition()
		local buildTopTipPosition = cc.p(x, y + 150)
		local buildTopTip = include("cityBuildTop")
		local buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_PROMOTE_ARMY
		buildTipNode = cityBuildCreator:createBuildTop(buildTopTipType, self.tblBatchNodesTopTip, buildTopTipPosition)
		buildTipNode:setName(nodeName)
		buildTipNode:setPosition(buildTopTipPosition)
		buildTipNode:setTag(cityBuildConstDef.buildIndexDef.index_TroopFlag)
		buildTipNode:addTo(self.containerView, 1300)
		self:addToBufferNodeArrayByName(nodeName, buildTipNode)
		local btnTip = SoraDGetChildByName(buildTipNode, "btn")
		btnTip:setTouchEnabled(true)
		btnTip:setTag(cityBuildConstDef.buildIndexDef.index_TroopFlag)
		btnTip:addTouchEventListener(function(ref, event)
			if event == ccui.TouchEventType.ended then
				uiManager:show("troopFlagView")
			end
		end)
	else
		_ENV = cityBuildCreator:createBuildTop(buildTopTipType, self.tblBatchNodesTopTip, buildTopTipPosition)
		cityBuildCreator:createBuildTop(buildTopTipType, self.tblBatchNodesTopTip, buildTopTipPosition).msg = "MESSAGE_MAINCITYVIEW_REMOVE_PROMOTE_TOP_TIP"
		SoraDSendMessage((cityBuildCreator:createBuildTop(buildTopTipType, self.tblBatchNodesTopTip, buildTopTipPosition)))
	end
end
function mainCityMsg.msgRemoveArmyPromoteTopTip(mainCity, target, data)
	local self = mainCity
	local mainCityFunctions = include("mainCityFunctions")
	local buildTopTipName = "build_topTip_" .. cityBuildConstDef.buildIndexDef.index_TroopFlag
	local buildTopTipNode = self:getBufferNodeByName(buildTopTipName)
	if nil == buildTopTipNode then
		return
	end
	self:delBufferNodeByName(buildTopTipName)
	buildTopTipNode:removeNodeRelyOn()
	buildTopTipNode:recycleNode()
	buildTopTipNode:removeFromParent()
end
function mainCityMsg.msgUpdateEpicWarTopTip(mainCity, target, data)
	local self = mainCity
end
function mainCityMsg.msgRemoveEpicWarTopTip(mainCity, target, data)
	local self = mainCity
	local mainCityFunctions = include("mainCityFunctions")
	local buildTopTipName = "build_topTip_" .. cityBuildConstDef.fixedBuildDef.EpicBattle
	local buildTopTipNode = self:getBufferNodeByName(buildTopTipName)
	if nil == buildTopTipNode then
		return
	end
	self:delBufferNodeByName(buildTopTipName)
	buildTopTipNode:removeNodeRelyOn()
	buildTopTipNode:recycleNode()
	buildTopTipNode:removeFromParent()
end
function mainCityMsg.msgUpdateEndlessTreasureTopTip(mainCity, target, data)
	local self = mainCity
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.ENDLESS_TREASURE)
	if unlockLv > SoraDGetCastleLv() then
		return
	end
	local endlessTreasureCtrl = gametop.playertop_:getModule("endlessTreasureCtrl")
	local isHaveReward = endlessTreasureCtrl:isHaveRewardTreasure()
	if isHaveReward then
		local mainCityFunctions = include("mainCityFunctions")
		local buildIndex = mainCityFunctions.getBuildIndexByBid(BUILDID.WISHING_WELL)
		local nodeName = "build_topTip_" .. buildIndex
		local buildTipNode = self:getBufferNodeByName(nodeName)
		if buildTipNode then
			return
		end
		local buildBtnName = "build_" .. buildIndex
		local buildBtn = self:getBufferNodeByName(buildBtnName)
		local x, y = buildBtn:getPosition()
		local buildTopTipPosition = cc.p(x - 3, y + 150)
		local buildTopTip = include("cityBuildTop")
		local buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_ENDLESS_TREASURE
		buildTipNode = cityBuildCreator:createBuildTop(buildTopTipType, self.tblBatchNodesTopTip, buildTopTipPosition)
		buildTipNode:setName(nodeName)
		buildTipNode:setPosition(buildTopTipPosition)
		buildTipNode:setTag(buildIndex)
		buildTipNode:addTo(self.containerView, 1300)
		self:addToBufferNodeArrayByName(nodeName, buildTipNode)
		local btnTip = SoraDGetChildByName(buildTipNode, "btn")
		btnTip:setTouchEnabled(true)
		btnTip:setTag(buildIndex)
		btnTip:addTouchEventListener(function(ref, event)
			if event == ccui.TouchEventType.ended then
				uiManager:show("EndlessTreasureView")
				_ENV = uiManager
				uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_ENDLESSTREASURE_TOP_TIP"
				SoraDSendMessage(uiManager)
			end
		end)
	else
		funUnlockRead = mainCityFunctions.getBuildIndexByBid(BUILDID.WISHING_WELL)
		mainCityFunctions.getBuildIndexByBid(BUILDID.WISHING_WELL).msg = "MESSAGE_MAINCITYVIEW_REMOVE_ENDLESSTREASURE_TOP_TIP"
		SoraDSendMessage((mainCityFunctions.getBuildIndexByBid(BUILDID.WISHING_WELL)))
	end
end
function mainCityMsg.msgRemoveEndlessTreasureTopTip(mainCity, target, data)
	local self = mainCity
	local mainCityFunctions = include("mainCityFunctions")
	local buildIndex = mainCityFunctions.getBuildIndexByBid(BUILDID.WISHING_WELL)
	local buildTopTipName = "build_topTip_" .. buildIndex
	local buildTopTipNode = self:getBufferNodeByName(buildTopTipName)
	if nil == buildTopTipNode then
		return
	end
	self:delBufferNodeByName(buildTopTipName)
	buildTopTipNode:removeNodeRelyOn()
	buildTopTipNode:recycleNode()
	buildTopTipNode:removeFromParent()
end
function mainCityMsg.msgUpdateAllianceTreasureTopTip(mainCity, target, data)
	local self = mainCity
	local allianceTreasureCtrl = gametop.playertop_:getModule("allianceTreasureCtrl")
	local freeTime = allianceTreasureCtrl:getNextFreeTime()
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local isJoin = allianceMgr:hasJoinAlliance()
	if not isJoin or 0 < freeTime then
		gametop = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_REMOVE_WAREHOUSE_GIFT_TOP_TIP"
		SoraDSendMessage(nil)
	elseif isJoin then
		local mainCityFunctions = include("mainCityFunctions")
		local depotIndex = mainCityFunctions.getBuildIndexByBid(BUILDID.DEPOT)
		local nodeName = "build_topTip_" .. depotIndex
		local buildTipNode = self:getBufferNodeByName(nodeName)
		if buildTipNode then
			return
		end
		local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
		local isInConquestWar = conquestWarCtrl:isPlayerConquestWarMigration()
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local depotBcell = cityCtrl:getBuildCell(BUILDID.DEPOT, 0)
		if isInConquestWar or tonumber(depotBcell.info.lv) < DEPOT_LV_ALLIANCE_TRRASURE then
			return
		end
		local buildBtnName = "build_" .. depotIndex
		local buildBtn = self:getBufferNodeByName(buildBtnName)
		local x, y = buildBtn:getPosition()
		local buildTopTipPosition = cc.p(x - 3, y + 150)
		local buildTopTip = include("cityBuildTop")
		local buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_ALLIANCETREASURE
		buildTipNode = cityBuildCreator:createBuildTop(buildTopTipType, self.tblBatchNodesTopTip, buildTopTipPosition)
		buildTipNode:setName(nodeName)
		buildTipNode:setPosition(buildTopTipPosition)
		buildTipNode:setTag(depotIndex)
		buildTipNode:addTo(self.containerView, 1300)
		self:addToBufferNodeArrayByName(nodeName, buildTipNode)
		local btnTip = SoraDGetChildByName(buildTipNode, "btn")
		btnTip:setTouchEnabled(true)
		btnTip:setTag(depotIndex)
		btnTip:addTouchEventListener(function(ref, event)
			if event == ccui.TouchEventType.ended then
				if not worldMapDefine.isInWarForbid(false, true) then
					if GLOBAL_GAME_ALLIANCE_MODE then
						uiManager:show("allianceStoreHouseView")
					else
						SoraDCreatePanel("allianceStoreHouseView"):show()
					end
				end
				_ENV = SoraDCreatePanel("allianceStoreHouseView")
				SoraDCreatePanel("allianceStoreHouseView").msg = "MESSAGE_MAINCITYVIEW_REMOVE_WAREHOUSE_GIFT_TOP_TIP"
				SoraDSendMessage((SoraDCreatePanel("allianceStoreHouseView")))
			end
		end)
	end
end
function mainCityMsg.msgRemoveAllianceTreasureTopTip(mainCity, target, data)
	local self = mainCity
	local mainCityFunctions = include("mainCityFunctions")
	local depotIndex = mainCityFunctions.getBuildIndexByBid(BUILDID.DEPOT)
	local buildTopTipName = "build_topTip_" .. depotIndex
	local buildTopTipNode = self:getBufferNodeByName(buildTopTipName)
	if nil == buildTopTipNode then
		return
	end
	self:delBufferNodeByName(buildTopTipName)
	buildTopTipNode:removeNodeRelyOn()
	buildTopTipNode:recycleNode()
	buildTopTipNode:removeFromParent()
end
function mainCityMsg.msgAddCastleGiftTopTip(mainCity, target, data)
	local self = mainCity
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_REMOVE_CASTLE_GIFT_TOP_TIP"
	SoraDSendMessage(nil)
	local dressCtrl = SoraDGetCtrl("dressCtrl")
	local isDressShow = dressCtrl:isShowMenuRed()
	local privilegeGiftCtrl = gametop.playertop_:getModule("privilegeGiftCtrl")
	if not privilegeGiftCtrl:getCurCanBuyRechargeID() then
		local _ENV, gift = privilegeGiftCtrl:getCurCanBuyRechargeID(), privilegeGiftCtrl:getCurCanBuyRechargeID()
	end
	_ENV = nil
	;(nil).byUID = true
	local clickTime = SoraDConfigGet("Game:MainCityView:castleGiftTipTime~integer", nil)
	print("isDressShow=====", isDressShow)
	if isDressShow or (clickTime == 0 or not serviceFunctions.isSameDay(clickTime)) and next(gift) then
		local nodeName = "build_topTip_" .. 1050
		local buildTipNode = self:getBufferNodeByName(nodeName)
		if buildTipNode then
			return
		end
		local buildBtnName = "build_" .. 1050
		local buildBtn = self:getBufferNodeByName(buildBtnName)
		local x, y = buildBtn:getPosition()
		local buildTopTipPosition = cc.p(x - 85, y + 240)
		local buildTopTip = include("cityBuildTop")
		local buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_CASTLE_GIFT
		buildTipNode = cityBuildCreator:createBuildTop(buildTopTipType, self.tblBatchNodesTopTip, buildTopTipPosition)
		buildTipNode:setName(nodeName)
		buildTipNode:setPosition(buildTopTipPosition)
		buildTipNode:setIcon(isDressShow and "icon_main_skin.png" or "icon_castleLv_privilege.png")
		buildTipNode:setTag(1050)
		buildTipNode:addTo(self.containerView, 1300)
		self:addToBufferNodeArrayByName(nodeName, buildTipNode)
		local btnTip = SoraDGetChildByName(buildTipNode, "btn")
		btnTip:setTouchEnabled(true)
		btnTip:setTag(1050)
		btnTip:addTouchEventListener(function(ref, event)
			if event == ccui.TouchEventType.ended then
				if isDressShow then
					uiManager:show("castleChangeView")
					local xOffset = display.size.width * 0.5 + 60
					_ENV = "castleChangeView"
					;("castleChangeView").msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
					;("castleChangeView").offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD
					;("castleChangeView").scale = 0.4
					;("castleChangeView").buildIndex = cityBuildConstDef.buildIndexDef.index_Castle
					;("castleChangeView").xOffset = xOffset
					;("castleChangeView").yOffset = display.rheight - 375
					SoraDSendMessage("castleChangeView")
					_ENV = "castleChangeView"
					;("castleChangeView").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
					SoraDSendMessage("castleChangeView")
				else
					_ENV = display.rheight - 375
					;(display.rheight - 375).privilegeType = gRechargePrivilegeType.castle
					;(display.rheight - 375).title = i18n("common_text_4030")
					;(display.rheight - 375).fromCenter = gRechargeActiveFromEnum.ROAD14
					uiManager:show("MagicLampPrivilegeView", display.rheight - 375)
				end
				_ENV = uiManager
				uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_CASTLE_GIFT_TOP_TIP"
				SoraDSendMessage(uiManager)
			end
		end)
	else
		_ENV = cityBuildCreator:createBuildTop(buildTopTipType, self.tblBatchNodesTopTip, buildTopTipPosition)
		cityBuildCreator:createBuildTop(buildTopTipType, self.tblBatchNodesTopTip, buildTopTipPosition).msg = "MESSAGE_MAINCITYVIEW_REMOVE_CASTLE_GIFT_TOP_TIP"
		SoraDSendMessage((cityBuildCreator:createBuildTop(buildTopTipType, self.tblBatchNodesTopTip, buildTopTipPosition)))
	end
end
function mainCityMsg.msgRemoveCastleGiftTopTip(mainCity, target, data)
	local self = mainCity
	local buildTopTipName = "build_topTip_" .. 1050
	local buildTopTipNode = self:getBufferNodeByName(buildTopTipName)
	if nil == buildTopTipNode then
		return
	end
	self:delBufferNodeByName(buildTopTipName)
	buildTopTipNode:removeNodeRelyOn()
	buildTopTipNode:recycleNode()
	buildTopTipNode:removeFromParent()
end
function mainCityMsg.msgKipchaksUpdate(mainCity, target, data)
	local self = mainCity
	self:kipchaksUpdate(target, data)
end
function mainCityMsg.msgAddShelterTopTip(mainCity, target, data)
	local self = mainCity
	if not (SoraDGetCtrl("warShelterCtrl"):hasNewInviteRecvRed() and SoraDGetCtrl("lordInfoCtrl"):isInSelfKid()) or not not worldMapDefine.isInWar() then
		return
	end
	local buildIndex = cityBuildConstDef.buildIndexDef.index_Watchtower
	local nodeName = "build_topTip_" .. buildIndex
	local buildTipNode = self:getBufferNodeByName(nodeName)
	if not buildTipNode then
		local buildBtnName = "build_" .. buildIndex
		local buildBtn = self:getBufferNodeByName(buildBtnName)
		local x, y = buildBtn:getPosition()
		local buildTopTipPosition = cc.p(x - 10, y + 160)
		local buildTopTip = include("cityBuildTop")
		local buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_WAR_SHELTER
		buildTipNode = cityBuildCreator:createBuildTop(buildTopTipType, self.tblBatchNodesTopTip, buildTopTipPosition)
		buildTipNode:setName(nodeName)
		buildTipNode:setPosition(buildTopTipPosition)
		buildTipNode:setTag(buildIndex)
		buildTipNode:addTo(self.containerView, 1300)
		self:addToBufferNodeArrayByName(nodeName, buildTipNode)
		local btnTip = SoraDGetChildByName(buildTipNode, "btn")
		btnTip:setTouchEnabled(true)
		btnTip:setTag(buildIndex)
		btnTip:addTouchEventListener(function(ref, event)
			if event == ccui.TouchEventType.ended then
				uiManager:show("ShelterView")
			end
		end)
	end
end
function mainCityMsg.msgRemoveShelterTopTip(mainCity, target, data)
	local self = mainCity
	local buildIndex = cityBuildConstDef.buildIndexDef.index_Watchtower
	local buildTopTipName = "build_topTip_" .. buildIndex
	local buildTopTipNode = self:getBufferNodeByName(buildTopTipName)
	if nil == buildTopTipNode then
		return
	end
	self:delBufferNodeByName(buildTopTipName)
	buildTopTipNode:removeNodeRelyOn()
	buildTopTipNode:recycleNode()
	buildTopTipNode:removeFromParent()
end
function mainCityMsg.msgAddArenaTopTip(mainCity, target, data)
	dump(mainCity, "mainCityMsg.msgAddArenaTopTip")
	dump(data, "mainCityMsg.msgAddArenaTopTip data")
	local self = mainCity
	local mainCityFunctions = include("mainCityFunctions")
	local drillIndex = mainCityFunctions.getBuildIndexByBid(BUILDID.DRILL_GROUDS)
	local setIcon = function(btNode, iconType)
		print("iconType = ", iconType)
		if gArenaTipEnum.haveAttackChange == iconType or gArenaTipEnum.underAttackAndWin == iconType then
			btNode:setIcon("icon_saleRoom_symbol.png", cc.size(70, 75), cc.p(2, 9))
		elseif gArenaTipEnum.rankFall == iconType then
			btNode:setIcon("icon_equip_arrow_01.png", cc.size(36, -47), cc.p(0, 67))
		elseif gArenaTipEnum.haveReward == iconType then
			btNode:setIcon("icon_recruitsupplies_box_01.png", cc.size(60, 65), cc.p(0, 15))
		end
	end
	local nodeName = "build_topTip_" .. drillIndex
	local buildTipNode = self:getBufferNodeByName(nodeName)
	if buildTipNode then
		setIcon(buildTipNode, data.iconType)
	else
		local mainCityFunctions = include("mainCityFunctions")
		local buildBtnName = "build_" .. drillIndex
		local buildBtn = self:getBufferNodeByName(buildBtnName)
		local x, y = buildBtn:getPosition()
		local buildTopTipPosition = cc.p(x - 10, y + 160)
		if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
			buildTopTipPosition = cc.p(x + 8, y + 130)
		end
		local buildTopTip = include("cityBuildTop")
		local buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_ARENA
		buildTipNode = cityBuildCreator:createBuildTop(buildTopTipType, self.tblBatchNodesTopTip, buildTopTipPosition)
		buildTipNode:setName(nodeName)
		setIcon(buildTipNode, data.iconType)
		buildTipNode:setPosition(buildTopTipPosition)
		buildTipNode:setTag(drillIndex)
		buildTipNode:addTo(self.containerView, 1300)
		self:addToBufferNodeArrayByName(nodeName, buildTipNode)
		local btnTip = SoraDGetChildByName(buildTipNode, "btn")
		btnTip:setTouchEnabled(true)
		btnTip:setTag(drillIndex)
		btnTip:addTouchEventListener(function(ref, event)
			if event == ccui.TouchEventType.ended then
				if not worldMapDefine.isInWarForbid(false, true) then
					uiManager:show("ArenaReadyView")
				end
				_ENV = uiManager
				uiManager.msg = "MESSAGE_SERVER_ARENA_TIPCHANGE"
				SoraDSendMessage(uiManager)
			end
		end)
	end
end
function mainCityMsg.msgRemoveArenaTopTip(mainCity, target, data)
	local self = mainCity
	local mainCityFunctions = include("mainCityFunctions")
	local drillIndex = mainCityFunctions.getBuildIndexByBid(BUILDID.DRILL_GROUDS)
	local buildTopTipName = "build_topTip_" .. drillIndex
	local buildTopTipNode = self:getBufferNodeByName(buildTopTipName)
	if nil == buildTopTipNode then
		return
	end
	self:delBufferNodeByName(buildTopTipName)
	buildTopTipNode:removeNodeRelyOn()
	buildTopTipNode:recycleNode()
	buildTopTipNode:removeFromParent()
end
function mainCityMsg.msgHeroAppointTopTip(mainCity, target, data)
	local self = mainCity
	if SoraDGetBuildStarLv() >= include("constantRead").getConstValue("HERO_APPOINT_LIMIT_LV") then
		local targetBid = data and data.bid
		local targetIid = data and data.iid
		local mainCityFunctions = include("mainCityFunctions")
		local cityltCtrl = include("cityltCtrl")
		local heroAppointCtrl = SoraDGetCtrl("heroAppointCtrl")
		local heroCtrl = SoraDGetCtrl("heroCtrl")
		local heroList = heroCtrl:getHaveHerosList()
		local _ENV, freeHeros = heroCtrl, heroCtrl
		for k, v in ipairs(heroList) do
			if not heroAppointCtrl:isHeroBeAppoint(tonumber(v)) then
				table.insert(freeHeros, tonumber(v))
			end
		end
		local delNode = function(bid, iid)
			local buildIndex = mainCityFunctions.getBuildIndexByBid(bid, iid)
			local buildTopTipName = "build_heroAppoint_topTip_" .. buildIndex
			print("buildTopTipName====", buildTopTipName)
			local buildTipNode = self:getBufferNodeByName(buildTopTipName)
			if buildTipNode then
				print("移除=====", buildTopTipName)
				self:delBufferNodeByName(buildTopTipName)
				buildTipNode:removeNodeRelyOn()
				buildTipNode:recycleNode()
				buildTipNode:removeFromParent()
			end
		end
		local addNode = function(bid, iid)
			local buildIndex = mainCityFunctions.getBuildIndexByBid(bid, iid)
			local isHaveOther = self:getBufferNodeIndex(buildIndex)
			local nodeName = "build_heroAppoint_topTip_" .. buildIndex
			if not isHaveOther then
				local buildBtnName = "build_" .. buildIndex
				local buildBtn = self:getBufferNodeByName(buildBtnName)
				local isLocked, unlocklevel = include("cityBuildBaseEntity"):getIsLocked(bid)
				if buildBtn and not isLocked and not heroAppointCtrl:getAppointHero(bid) then
					local buildEntity = buildBtn:getChildByName("buildName")
					if buildEntity and buildEntity:getBuildCell() then
						local buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_HERO_APPOINT_TIP
						local x, y = buildBtn:getPosition()
						local buildType = SoraDGetBuildTypeByBid(bid)
						local offSetY = 210
						if bid == BUILDID.TURRET then
							offSetY = 130
						elseif bid == BUILDID.WALLS then
							offSetY = 80
						end
						local buildTopTipPosition = cc.p(x, y + (buildType == 0 and offSetY or 90))
						local _buildTipNode = cityBuildCreator:createBuildTop(buildTopTipType, self.tblBatchNodesTopTip, buildTopTipPosition)
						_buildTipNode:setName(nodeName)
						_buildTipNode:setIcon("icon_saleRoom_symbol.png")
						_buildTipNode:setPosition(buildTopTipPosition)
						_buildTipNode:setTag(buildIndex)
						_buildTipNode:addTo(self.containerView, 1300)
						self:addToBufferNodeArrayByName(nodeName, _buildTipNode)
						local btnTip = SoraDGetChildByName(_buildTipNode, "btn")
						if btnTip then
							btnTip:setTouchEnabled(true)
							btnTip:setTag(buildIndex)
							btnTip:addTouchEventListener(function(ref, event)
								if event == ccui.TouchEventType.ended then
									local cfg = cityltCtrl.getBuildHeroAppointCfg(bid)
									if cfg then
										_ENV = nil
										;(nil).bid = bid
										uiManager:show("HeroAppointMain", nil)
									else
										print("移除nodeName======", nodeName)
										self:delBufferNodeByName(nodeName)
										_buildTipNode:removeNodeRelyOn()
										_buildTipNode:recycleNode()
										_buildTipNode:removeFromParent()
									end
								end
							end)
						else
							print("创建tip失败===========", bid, iid)
						end
					end
				end
			end
		end
		local buildList = cityltCtrl.getAllBuildHeroAppointCfg()
		if targetBid then
			delNode(targetBid, targetIid)
		else
			for k, v in pairs(buildList) do
				delNode(v.buildID, targetIid)
			end
		end
		if 0 < #freeHeros then
			if targetBid then
				addNode(targetBid, targetIid)
			else
				for k, v in pairs(buildList) do
					addNode(v.buildID, targetIid)
				end
			end
		end
	end
end
function mainCityMsg.msgAddNpcTopTip(mainCity, target, data)
	local self = mainCity
	local mainCityFunctions = include("mainCityFunctions")
	print("添加----------npc智能提示")
	dump(data, "data = ")
	local buildIndex = 0
	local bid = data.bid
	if bid ~= nil and bid ~= 0 then
		if data.bIndex and data.bIndex ~= 0 then
			buildIndex = data.bIndex
		else
			buildIndex = mainCityFunctions.getBuildIndexByBid(bid)
		end
	else
		buildIndex = data.bIndex
	end
	if nil == buildIndex or 0 == buildIndex then
		return
	end
	local buildBtnName = "build_" .. buildIndex
	local buildBtn = self:getBufferNodeByName(buildBtnName)
	if nil == buildBtn then
		return
	end
	local x, y = buildBtn:getPosition()
	local buildTopTipPosition = cc.p(x, y + 110)
	if buildIndex == 1052 or buildIndex == 1054 then
		buildTopTipPosition = cc.p(x, y + 60)
	end
	local buildType = SoraDGetBuildTypeByBid(bid)
	if buildType == 0 then
		buildTopTipPosition = cc.p(x, y + 110)
		if bid == BUILDID.EMBASSY then
			buildTopTipPosition = cc.p(x, y + 142)
		elseif bid == BUILDID.TURRET then
			buildTopTipPosition = cc.p(x, y + 30)
		elseif bid == BUILDID.WALLS then
			buildTopTipPosition = cc.p(x, y + 70)
		end
	else
		buildTopTipPosition = cc.p(x, y + 35)
		if bid == BUILDID.MATERIAL_WORKSHOP then
			buildTopTipPosition = cc.p(x, y + 110)
		end
	end
end
function mainCityMsg.msgRemoveNpcTopTip(mainCity, target, data)
	print("删除npc智能提示----------")
	dump(data, "npc数据")
	local mainCityFunctions = include("mainCityFunctions")
	local self = mainCity
	local buildIndex = 0
	local bid = data.bid
	if bid ~= nil and bid ~= 0 then
		if data.bIndex ~= nil and data.bIndex ~= 0 then
			buildIndex = data.bIndex
		else
			mainCityFunctions.getBuildIndexByBid(bid)
		end
	else
		buildIndex = data.bIndex
	end
	if nil == buildIndex or 0 == buildIndex then
		return
	end
	local buildTopTipName = "build_npc_topTip_" .. buildIndex
	local buildTopTipNode = self:getBufferNodeByName(buildTopTipName)
	if nil == buildTopTipNode then
		return
	end
end
function mainCityMsg.msgCollectBatchRes(mainCity, target, data)
	local self = mainCity
	dump(data, "mainCityMsg.msgCollectBatchRes(mainCity, target, data)", 10)
	local bid = data.bid
	if not bid then
		return
	end
	local buildlist = cityCtrl:getBuildList()
	if buildlist == nil then
		return
	end
	for k, buildcell in pairs(buildlist) do
		if tonumber(buildcell.info.bid) == bid then
			local index = tonumber(buildcell.info.index)
			local buildEntity = self:getBuildByIndex(index)
			if buildEntity and not buildEntity:getIsLocked() and buildEntity:getState() == "harvesting" then
				buildEntity:doHarvesting()
			end
		end
	end
end
function mainCityMsg.msgUpdateMasteryTopTip(mainCity, target, data)
	local self = mainCity
	local specializationRead = include("specializationRead")
	local canUnLock, mid = specializationRead.checkMasteryCanUnLock()
	self.canUnLockMid = mid
	local buildIndex = cityBuildConstDef.buildIndexDef.index_Mastery
	local nodeName = "build_topTip_" .. buildIndex
	local buildTipNode = self:getBufferNodeByName(nodeName)
	local canReceive = cityCtrl:checkMasteryDrawCanReceive()
	if canUnLock or canReceive then
		if buildTipNode then
			self:delBufferNodeByName(nodeName)
			buildTipNode:removeNodeRelyOn()
			buildTipNode:recycleNode()
			buildTipNode:removeFromParent()
		end
		local buildBtnName = "build_" .. buildIndex
		local buildBtn = self:getBufferNodeByName(buildBtnName)
		local x, y = buildBtn:getPosition()
		local buildTopTipPosition = cc.p(x, y + 120)
		local buildTopTip = include("cityBuildTop")
		local buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_MASTERY_UNLOCK
		if canReceive then
			buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_MASTERY_RECEIVE
		end
		buildTipNode = cityBuildCreator:createBuildTop(buildTopTipType, self.tblBatchNodesTopTip, buildTopTipPosition)
		buildTipNode:setName(nodeName)
		buildTipNode:setPosition(buildTopTipPosition)
		buildTipNode:setTag(buildIndex)
		buildTipNode:addTo(self.containerView, 1300)
		self:addToBufferNodeArrayByName(nodeName, buildTipNode)
		local btnTip = SoraDGetChildByName(buildTipNode, "btn")
		btnTip:setTouchEnabled(true)
		btnTip:setTag(buildIndex)
		btnTip:addTouchEventListener(function(ref, event)
			if event == ccui.TouchEventType.ended then
				if canReceive then
					cityCtrl:sendReqMasteryDrawReceive()
				else
					local penal = SoraDCreatePanel("masteryMainView")
					penal:show()
					penal:doDelayAction(self.canUnLockMid)
				end
			end
		end)
	else
		if nil == buildTipNode then
			return
		end
		self:delBufferNodeByName(nodeName)
		buildTipNode:removeNodeRelyOn()
		buildTipNode:recycleNode()
		buildTipNode:removeFromParent()
	end
end
function mainCityMsg.msgBuildUpgradeMsgBack(mainCity, target, data)
	if SoraDCurrentTopPanelFromManager() ~= nil then
		return
	end
	dump(data, "mainCityMsg.msgBuildUpgradeMsgBack")
	local bcell = cityCtrl:getBuildCellByIndex(data.index)
	local bid = bcell.info.bid
	local iid = bcell.info.iid
	_UPVALUE3_ = nil
	;(nil)[1] = data.mode
	;(nil)[2] = OPERATE_MODE.IMMEDIATELY
	;(nil)[3] = OPERATE_MODE.FREE
	dump(nil, "data.mode == OPERATE_MODE.IMMEDIATELY or data.mode == OPERATE_MODE.FREE")
	if tonumber(data.mode) == OPERATE_MODE.IMMEDIATELY or tonumber(data.mode) == OPERATE_MODE.FREE then
		_ENV = data.mode
		buildLogic.upgrade(data.index, tonumber(data.mode), data.mode, false, bid)
		_ENV = data.index
		data.index.msg = "MESSAGE_BUILD_UPGRADE"
		data.index.index = data.index
		data.index.bid = bid
		data.index.iid = iid
		SoraDSendMessage(data.index)
	end
end
function mainCityMsg.msgSettingQualityChange(mainCity, target, data)
	effectMainCityView.updateWaterEffect(mainCity)
end
return mainCityMsg
