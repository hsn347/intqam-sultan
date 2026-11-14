local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local cityBuildFunction = include("cityBuildFunction")
local cityBuildConstDef = include("cityBuildConstDef")
local wallsCtrl = gametop.playertop_:getModule("wallsCtrl")
local timeRewardCtrl = gametop.playertop_:getModule("timeRewardCtrl")
local loginRewardCtrl = gametop.playertop_:getModule("loginRewardCtrl")
local kingdomWeatherCtrl = gametop.playertop_:getModule("kingdomWeatherCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local cityHorseCtrl = gametop.playertop_:getModule("cityHorseCtrl")
local cityBuildSpritePool = include("cityBuildSpritePool")
local cityBuildMgr = include("cityBuildMgr")
local mainCityDefine = include("mainCityDefine")
local effectMainCityView = include("effectMainCityView")
local mainCityFunctions = include("mainCityFunctions")
local mainCityBuildingMove = include("mainCityBuildingMove")
local mainCityABMManager = include("mainCityABMManager")
local funUnlockRead = include("funUnlockRead")
local _ENV, mainCityCreate = "funUnlockRead", "funUnlockRead"
function mainCityCreate.ctor(mainCity, param)
	local self = mainCity
	local cityBuildSoldierPool = include("cityBuildSoldierPool")
	self.gameIdlePopAction = nil
	self.isNeedFirstFight = mainCity:getIsNeedFirstFight()
	self.minScale = 0.35
	self.minLimitScale = 0.5
	self.defaultScale = MAINCITY_DEFAULT_SCALE
	self.normalScale = MAINCITY_DEFAULT_SCALE
	self.maxScale = 1.0
	self.maxLimitScale = 2.0
	self.inertia = 1.4
	self.initScrollViewScale = 1.4
	self.normlScrollViewScale = 1.0
	self.zoomScaleDuration = 0.3
	self.initZoomScaleDuration = 0.6
	self.autoMoveSpeed = 2700
	self.autoMoveSpeedSlow = 800
	local mainUIScale = math.min(1, display.height / 1136)
	self.hUITop = 43 * mainUIScale
	self.hUIBottom = 74 * mainUIScale
	self.tipBoxCount = 1
	self.tipBoxMaxCount = 12
	self.darkCount = 1
	self.soldierBoxCount = 1
	self.soldierBoxMaxCount = 12
	self.petBoxCount = 1
	self.petBoxMaxCount = 20
	self.soldierBoxCountOffset = 8
	self.isSoldierBoxCountOffset = true
	self.merchantBoxCount = 1
	self.merchantBoxMaxCount = 10
	self.darkMaxCount = 10
	self.conquerBoxCount = 1
	self.conquerBoxMaxCount = 180
	self.castleModel = BUILD_CASTLE_MODEL.CLASSICAL
	self.viewModelWall = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1
	self.isMoved = false
	self.isMoveOnBuild = false
	self.currentSelectBuild = nil
	self.currentSelectTip = nil
	self.viewScrollView = nil
	self.containerView = nil
	self.touchlayer = nil
	self.isNeedRecover = false
	self.preContainerOffset = nil
	self.preContainerOffsetTip = nil
	self.isOnMoveMode = false
	self.currentSelectMoveModeIndex = 0
	self.afterSelectMoveModeIndex = 0
	self.currentTopTipArray, _ENV, self.currentMoveBtnArray, _ENV, self.currentSelectMoveModeType = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1, cityBuildConstDef.VIEWMODEL.VIEWMODEL_1, cityBuildConstDef.VIEWMODEL.VIEWMODEL_1, cityBuildConstDef.VIEWMODEL.VIEWMODEL_1, 0
	self.bufferNodeArray, _ENV, self.isOnCollectMode = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1, cityBuildConstDef.VIEWMODEL.VIEWMODEL_1, false
	self.hasCommunityCenterMsg = false
	self.hasConquerGateMsg = false
	self.isBuildBtnEnable = true
	self.isShowDark = false
	self.collectBuilds, _ENV, self.currentDayPeriod = cityBuildConstDef.VIEWMODEL.VIEWMODEL_1, cityBuildConstDef.VIEWMODEL.VIEWMODEL_1, nil
	self.isCfgNightOn = SoraDConfigGet("Game:GameOptionsView:nightSwitch~bool")
	self:setContentSize(display.realSize)
	self:setAnchorPoint(cc.p(0.5, 0.5))
	self:setPosition(cc.p(display.cx, display.rcy))
	local factionCtrl = SoraDGetCtrl("factionCtrl")
	local cfg = factionCtrl:getFactionMainCityCfg()
	self.containerView = cc.CSLoader:createNode(getCCSPath(cfg.container))
	local viewScrollViewSize = cc.size(self:getContentSize().width, self:getContentSize().height - (self.hUITop + self.hUIBottom + display.iPhoneXOffset))
	if self.isNeedFirstFight == true then
		viewScrollViewSize = cc.size(self:getContentSize().width, self:getContentSize().height)
	end
	self.zoomMinOffsetX = viewScrollViewSize.width - self.containerView:getContentSize().width
	self.zoomMinOffsetY = viewScrollViewSize.height - self.containerView:getContentSize().height
	self.viewScrollView = cc.ScrollView:create(viewScrollViewSize)
	self.viewScrollView:setContainer(self.containerView)
	self.viewScrollView:setMinScale(self.minScale)
	self.viewScrollView:setMaxScale(self.maxScale)
	self.viewScrollView:setZoomScale(self.normalScale)
	self.zoomScale = self.normalScale
	self.viewScrollView:setBounceable(false)
	self.viewScrollView:setInertiaValue(self.inertia)
	self.viewScrollView:setFixMaxPos(true)
	if self.isNeedFirstFight == true then
		self.initScrollViewScale = 1.0
		self.viewScrollView:setZoomScale(self.defaultScale)
	else
		self.initScrollViewScale = display.height / viewScrollViewSize.height
	end
	self.viewScrollView:ignoreAnchorPointForPosition(false)
	self.viewScrollView:setAnchorPoint(cc.p(0.5, 0.5))
	self.viewScrollView:setPosition(cc.p(display.width / 2, display.rheight / 2))
	self.viewScrollView:setScale(self.initScrollViewScale)
	self:addChild(self.viewScrollView, 0)
	self.viewScrollView:setDelegate()
	self.viewScrollView:registerScriptHandler(handler(self, self.scrollViewDidZoom), cc.SCROLLVIEW_SCRIPT_ZOOM)
	self.viewScrollView:registerScriptHandler(handler(self, self.scrollViewDidOffset), cc.SCROLLVIEW_SCRIPT_SCROLL)
	self.viewScrollView:setClippingToBounds(false)
	self.touchlayer = ccui.Layout:create()
	self.touchlayer:setContentSize(self.containerView:getContentSize())
	self.touchlayer:addTo(self.containerView, 2000)
	self.touchlayer:setTouchEnabled(true)
	self.touchlayer:setSwallowTouches(false)
	self.touchlayer:addTouchEventListener(function(ref, type)
		self:viewOnClick(ref, type)
	end)
	self.OLD_RAMADAN_SWITCH = RAMADAN_SWITCH
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	RAMADAN_SWITCH = RAMADAN_SWITCH and guideCtrl:getCurMainCityGuideStep() == nil
	mainCityCreate.createBatchNodes(self)
	mainCityCreate.initBufferNodeArray(self)
	mainCityCreate.initBuild(self)
	mainCityFunctions.reArrangeZorder(self)
	mainCityCreate.initMainCityPos(self)
	if param ~= nil then
		self.initOtherData = param
	end
	self:addWaterFallEffect()
	self:addPetFlyBird()
	local director = cc.Director:getInstance()
	director:setProjection(cc.DIRECTOR_PROJECTION2_D)
	self:initCityGroupNode()
	if not self.isNeedFirstFight then
		self.viewScrollView:setContentOffset(cc.p(-1900 - display.cx, -1150 - display.cy))
	end
end
function mainCityCreate.initCityGroupNode(mainCity)
	local self = mainCity
	local createGroupNode = function(groupID, zOrder)
		local node = display.newNode()
		node:setGroupID(groupID, true)
		node:addTo(self.containerView, zOrder)
	end
	createGroupNode(mainCityDefine.CITY_TARGET_GROUPID.GROUP_HALLTOP, mainCityDefine.CITY_TARGET_ZORDER.bg)
	createGroupNode(mainCityDefine.CITY_TARGET_GROUPID.GROUP_WALL, mainCityDefine.CITY_TARGET_ZORDER.wall)
	createGroupNode(mainCityDefine.CASTLE_TARGET_GROUPID.GROUP_CASTLE_BG, mainCityDefine.CITY_TARGET_ZORDER.castle_bg)
	createGroupNode(mainCityDefine.CASTLE_TARGET_GROUPID.GROUP_CASTLE_B_ACT, mainCityDefine.CITY_TARGET_ZORDER.castle_b_act)
	createGroupNode(mainCityDefine.CASTLE_TARGET_GROUPID.GROUP_CASTLE_B_EFFECT, mainCityDefine.CITY_TARGET_ZORDER.castle_b_effect)
	createGroupNode(mainCityDefine.CASTLE_TARGET_GROUPID.GROUP_CASTLE, mainCityDefine.CITY_TARGET_ZORDER.castle_skin)
	createGroupNode(mainCityDefine.CASTLE_TARGET_GROUPID.GROUP_CASTLE_DH, mainCityDefine.CITY_TARGET_ZORDER.castle_dh)
	createGroupNode(mainCityDefine.CASTLE_TARGET_GROUPID.GROUP_CASTLE_EXTRA, mainCityDefine.CITY_TARGET_ZORDER.castle_extra)
	createGroupNode(mainCityDefine.CASTLE_TARGET_GROUPID.GROUP_CASTLE_TOP_ACT, mainCityDefine.CITY_TARGET_ZORDER.castle_top_act)
	createGroupNode(mainCityDefine.CASTLE_TARGET_GROUPID.GROUP_CASTLE_TOP_EFFECT, mainCityDefine.CITY_TARGET_ZORDER.castle_top_effect)
	createGroupNode(mainCityDefine.CASTLE_TARGET_GROUPID.GROUP_CASTLE_ANIMATION, mainCityDefine.CITY_TARGET_ZORDER.castle_animation)
	createGroupNode(mainCityDefine.CASTLE_TARGET_GROUPID.GROUP_CASTLE_OTHER, mainCityDefine.CITY_TARGET_ZORDER.castle_other)
	createGroupNode(mainCityDefine.CITY_TARGET_GROUPID.GROUP_NIGHT_COMMON, mainCityDefine.CITY_TARGET_ZORDER.night_common)
	createGroupNode(mainCityDefine.CITY_TARGET_GROUPID.GROUP_NIGHT_BUILD, mainCityDefine.CITY_TARGET_ZORDER.night_wall)
	createGroupNode(mainCityDefine.CITY_TARGET_GROUPID.GROUP_BUILD_SHOW_NAME_BG, mainCityDefine.CITY_TARGET_ZORDER.show_nameBg)
	createGroupNode(mainCityDefine.CITY_TARGET_GROUPID.GROUP_BUILD_SHOW_NAME, mainCityDefine.CITY_TARGET_ZORDER.show_name)
	createGroupNode(mainCityDefine.CASTLE_TARGET_GROUPID.GROUP_CASTLE_NIGHT_SKIN, mainCityDefine.CITY_TARGET_ZORDER.castle_night_skin)
	createGroupNode(mainCityDefine.CASTLE_TARGET_GROUPID.GROUP_CASTLE_NIGHT_ACT, mainCityDefine.CITY_TARGET_ZORDER.castle_night_act)
	createGroupNode(mainCityDefine.CASTLE_TARGET_GROUPID.GROUP_CASTLE_NIGHT_B_EFFECT, mainCityDefine.CITY_TARGET_ZORDER.castle_night_b_effect)
	createGroupNode(mainCityDefine.CASTLE_TARGET_GROUPID.GROUP_CASTLE_NIGHT_DH, mainCityDefine.CITY_TARGET_ZORDER.castle_night_dh)
	createGroupNode(mainCityDefine.CASTLE_TARGET_GROUPID.GROUP_CASTLE_NIGHT_TOP_ACT, mainCityDefine.CITY_TARGET_ZORDER.castle_night_top_act)
	createGroupNode(mainCityDefine.CASTLE_TARGET_GROUPID.GROUP_CASTLE_NIGHT_TOP_EFFECT, mainCityDefine.CITY_TARGET_ZORDER.castle_night_top_effect)
	createGroupNode(mainCityDefine.CASTLE_TARGET_GROUPID.GROUP_CASTLE_NIGHT_ANIMATION, mainCityDefine.CITY_TARGET_ZORDER.castle_night_animation)
	createGroupNode(mainCityDefine.CASTLE_TARGET_GROUPID.GROUP_CASTLE_NIGHT_EXTRA, mainCityDefine.CITY_TARGET_ZORDER.castle_night_extra)
	createGroupNode(mainCityDefine.CITY_TARGET_GROUPID.GROUP_OTHER, mainCityDefine.CITY_TARGET_ZORDER.other)
end
function mainCityCreate.createBatchNodes(mainCity)
	local self = mainCity
	self.batchNodeOuterTiles = display.newNode()
	self.containerView:addChild(self.batchNodeOuterTiles, 69)
	self.batchNodeOuterTiles:setPosition(cc.p(0, 0))
	self.batchNodeOuterBuilds = display.newNode()
	self.containerView:addChild(self.batchNodeOuterBuilds, 70)
	self.batchNodeOuterBuilds:setPosition(cc.p(0, 0))
	self.batchNodeOuterBuildNpc = display.newNode()
	self.containerView:addChild(self.batchNodeOuterBuildNpc, 71)
	self.batchNodeOuterBuildNpc:setPosition(cc.p(0, 0))
	self.batchNodeOuterBuildCommon = display.newNode()
	self.containerView:addChild(self.batchNodeOuterBuildCommon, 72)
	self.batchNodeOuterBuildCommon:setPosition(cc.p(0, 0))
	self.batchNodeKipchaks = display.newNode()
	self.containerView:addChild(self.batchNodeKipchaks, 73)
	self.batchNodeKipchaks:setPosition(cc.p(0, 0))
	_ENV = self.batchNodeKipchaks.setPosition
	self.batchNodeKipchaks.setPosition.mainCityOuter = self.batchNodeOuterBuilds
	self.batchNodeKipchaks.setPosition.mainCityNpc = self.batchNodeOuterBuildNpc
	self.batchNodeKipchaks.setPosition.mainCityCommon = self.batchNodeOuterBuildCommon
	self.tblBatchNodesOuter, self.batchNodeKipchaks.setPosition.mainCityKipchaks = self.batchNodeKipchaks.setPosition, self.batchNodeKipchaks
	self.batchNodeTopTip = display.newNode()
	self.containerView:addChild(self.batchNodeTopTip, 402)
	self.batchNodeTopTip:setPosition(cc.p(0, 0))
	_ENV = self.batchNodeTopTip.setPosition
	self.tblBatchNodesTopTip, self.batchNodeTopTip.setPosition.default = self.batchNodeTopTip.setPosition, self.batchNodeTopTip
	self.batchNodeCityOthers = display.newNode()
	self.containerView:addChild(self.batchNodeCityOthers, 1)
	self.batchNodeCityOthers:setPosition(cc.p(0, 0))
	self.batchNodeCityEffect = display.newNode()
	self.containerView:addChild(self.batchNodeCityEffect, 2)
	self.batchNodeCityEffect:setPosition(cc.p(0, 0))
	self.batchNodeSoldierGuards = display.newNode()
	self.containerView:addChild(self.batchNodeSoldierGuards)
	self.batchNodeSoldierGuards:setLocalZOrder(mainCityDefine.CITY_TARGET_ZORDER.npc)
	self.batchNodeSoldierGuards:setPosition(cc.p(0, 0))
	if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
		self.batchNodeSoldierGuards:setPosition(cc.p(100, -10))
	end
	self.batchNodeNpc = display.newNode()
	self.containerView:addChild(self.batchNodeNpc)
	self.batchNodeNpc:setLocalZOrder(mainCityDefine.CITY_TARGET_ZORDER.npc)
	self.batchNodeNpc:setPosition(cc.p(0, 0))
	self.batchNodeXiyiNpc = display.newNode()
	self.containerView:addChild(self.batchNodeXiyiNpc)
	self.batchNodeXiyiNpc:setLocalZOrder(mainCityDefine.CITY_TARGET_ZORDER.npc)
	self.batchNodeXiyiNpc:setPosition(cc.p(0, 0))
	self.batchNodeCollect = display.newNode()
	if self.batchNodeCollect then
		self.batchNodeCollect:removeAllChildren(true)
		self.batchNodeCollect:stopAllActions()
		self.batchNodeCollect:removeFromParent(true)
		self.batchNodeCollect = nil
	end
	if self.batchNodeCollect == nil then
		self.batchNodeCollect = display.newNode()
		display.getRunningScene():addChild(self.batchNodeCollect, 1000)
		self.batchNodeCollect:setPosition(cc.p(0, 0))
		self.batchNodeCollect:setName("mainCityView_batchNode_collect")
	else
	end
end
function mainCityCreate.createFightBatchNode(mainCity)
	local self = mainCity
	if self.batchNodeFightBullet == nil then
		self.batchNodeFightBullet = display.newNode()
		self.containerView:addChild(self.batchNodeFightBullet, 50)
	end
	if self.batchNodeFightBuilds == nil then
		self.batchNodeFightBuilds = display.newNode()
		self.containerView:addChild(self.batchNodeFightBuilds, 20)
	end
	if self.batchNodeFightBuildWalls == nil then
		self.batchNodeFightBuildWalls = display.newNode()
		self.containerView:addChild(self.batchNodeFightBuildWalls, 30)
	end
	if self.batchNodeFightSoldiers == nil then
		self.batchNodeFightSoldiers = display.newNode()
		self.containerView:addChild(self.batchNodeFightSoldiers, 45)
	end
	if self.effectFightNode == nil then
		self.effectFightNode = display.newNode()
		self.containerView:addChild(self.effectFightNode, 55)
	end
end
function mainCityCreate.initOriginBuild(mainCity)
	local self = mainCity
	local btnBuildChengmeng = self:getBufferNodeByName("build_1053")
	if btnBuildChengmeng then
		btnBuildChengmeng:setSwallowTouches(false)
		btnBuildChengmeng:addTouchEventListener(function(ref, type)
			self:buildButtonCallFun(btnBuildChengmeng, ref, type)
		end)
	end
	local btnBuildJiantaL = self:getBufferNodeByName("build_1052")
	if btnBuildJiantaL then
		btnBuildJiantaL:addTouchEventListener(function(ref, type)
			self:buildButtonCallFun(btnBuildJiantaL, ref, type)
		end)
	end
	local btnBuildJiantaR = self:getBufferNodeByName("build_1054")
	if btnBuildJiantaR then
		btnBuildJiantaR:addTouchEventListener(function(ref, type)
			self:buildButtonCallFun(btnBuildJiantaR, ref, type)
		end)
	end
	local btnBuildWatchtower = self:getBufferNodeByName("build_1055")
	if btnBuildWatchtower then
		btnBuildWatchtower:setSwallowTouches(false)
		btnBuildWatchtower:addTouchEventListener(function(ref, type)
			self:buildButtonCallFun(btnBuildWatchtower, ref, type)
		end)
	end
end
function mainCityCreate.initBuild(mainCity)
	local self = mainCity
	mainCityCreate.initOriginBuild(self)
	for i = 1050, 1067 do
		local buildName = "build_" .. i
		local buildButton = self:getBufferNodeByName(buildName)
		if buildButton then
			buildButton:setSwallowTouches(false)
			buildButton:setTag(i)
			buildButton:addTouchEventListener(function(ref, type)
				self:buildButtonCallFun(buildButton, ref, type)
			end)
		end
	end
	local btnBuildChengmeng = self:getBufferNodeByName("build_1053")
	local build_cq_item_name = "Button_Cq"
	local build_cq_item = self:getBufferNodeByName(build_cq_item_name)
	if build_cq_item then
		build_cq_item:setSwallowTouches(false)
		build_cq_item:setLayer(29)
		build_cq_item:setAlpha(0)
		build_cq_item:addTouchEventListener(function(ref, type)
			self:buildButtonCallFun(btnBuildChengmeng, ref, type)
		end)
	end
	for i = 1100, 1134 do
		local buildBtnName = "build_" .. i
		local buildBtn = self:getBufferNodeByName(buildBtnName)
		if buildBtn then
			buildBtn:setTag(i)
			buildBtn:setSwallowTouches(false)
			buildBtn:addTouchEventListener(function(ref, type)
				self:buildButtonCallFun(buildBtn, ref, type)
			end)
		end
	end
	for i = 1, 10 do
		local buildBtnName = "kipchaks_" .. i
		local buildBtn = self:getBufferNodeByName(buildBtnName)
		if buildBtn then
			buildBtn:setVisible(false)
			buildBtn:setTag(i)
			buildBtn:setSwallowTouches(false)
			buildBtn:addTouchEventListener(function(ref, type)
				self:kipchaksButtonCallFun(buildBtn, ref, type)
			end)
		end
	end
	self:kipchaksUpdate()
	local buttonMilitaryInfo = SoraDGetChildByName(self.containerView, "Button_MilitaryInfo")
	if nil ~= buttonMilitaryInfo then
		buttonMilitaryInfo:setSwallowTouches(false)
		buttonMilitaryInfo:addTouchEventListener(function(ref, type)
			self:otherBuildButtonCallFun(buttonMilitaryInfo, ref, type)
		end)
		self.buttonMilitaryInfo = buttonMilitaryInfo
	end
	local buttonMerchante = SoraDGetChildByName(self.containerView, "Button_Merchante")
	if nil ~= buttonMerchante then
		buttonMerchante:setSwallowTouches(false)
		buttonMerchante:addTouchEventListener(function(ref, type)
			self:otherBuildButtonCallFun(buttonMerchante, ref, type)
		end)
		self.buttonMerchante = buttonMerchante
		function mainCityCreate(ref, type)
			self:otherBuildButtonCallFun(buttonMerchante, ref, type)
		end
		mainCityCreate, (function(ref, type)
			self:otherBuildButtonCallFun(buttonMerchante, ref, type)
		end).name = i18n("common_text_441"), i18n("common_text_441")
		i18n("common_text_441").x = 140
		;(function(ref, type)
			self:otherBuildButtonCallFun(buttonMerchante, ref, type)
		end).pos, i18n("common_text_441").y = i18n("common_text_441"), 0
		SoraDShowNameOnTouchEvent(self.buttonMerchante, function(ref, type)
			self:otherBuildButtonCallFun(buttonMerchante, ref, type)
		end)
	end
	local buttonActivity = SoraDGetChildByName(self.containerView, "Button_Activity")
	if nil ~= buttonActivity then
		buttonActivity:setSwallowTouches(false)
		buttonActivity:addTouchEventListener(function(ref, type)
			self:otherBuildButtonCallFun(buttonActivity, ref, type)
		end)
		self.buttonActivity = buttonActivity
	end
	local buttonEpicBattle = SoraDGetChildByName(self.containerView, "build_30006")
	if nil ~= buttonEpicBattle then
		self.buttonEpicBattle = buttonEpicBattle
	end
	local buttonMonument = SoraDGetChildByName(self.containerView, "build_30007")
	if nil ~= buttonMonument then
		self.buttonMonument = buttonMonument
	end
	local buttonPyramidBattle = SoraDGetChildByName(self.containerView, "build_20008")
	if nil ~= buttonPyramidBattle then
		print("buttonPyramidBattle ---初始化-----")
		buttonPyramidBattle:setTouchEnabled(true)
		buttonPyramidBattle:addTouchEventListener(function(ref, type)
			self:otherBuildButtonCallFun(buttonPyramidBattle, ref, type)
		end)
		buttonPyramidBattle:setSwallowTouches(false)
		self.buttonPyramidBattle = buttonPyramidBattle
	end
	local buttonLion = SoraDGetChildByName(self.containerView, "Button_lion")
	if nil ~= buttonLion then
		buttonLion:setSwallowTouches(false)
		buttonLion:addTouchEventListener(function(ref, type)
			self:otherBuildButtonCallFun(buttonLion, ref, type)
		end)
		self.buttonLion = buttonLion
		function mainCityCreate(ref, type)
			self:otherBuildButtonCallFun(buttonLion, ref, type)
		end
		mainCityCreate, (function(ref, type)
			self:otherBuildButtonCallFun(buttonLion, ref, type)
		end).name = i18n("common_text_4068"), i18n("common_text_4068")
		i18n("common_text_4068").x = 60
		;(function(ref, type)
			self:otherBuildButtonCallFun(buttonLion, ref, type)
		end).pos, i18n("common_text_4068").y = i18n("common_text_4068"), 60
		SoraDShowNameOnTouchEvent(buttonLion, function(ref, type)
			self:otherBuildButtonCallFun(buttonLion, ref, type)
		end)
		mainCityCreate = buttonLion
		buttonLion.msg = "MESSAGE_MAINCITY_LION_MSG"
		SoraDSendMessage(buttonLion)
	end
	local buttonMaTou = SoraDGetChildByName(self.containerView, "Button_MaTou")
	if nil ~= buttonMaTou then
		buttonMaTou:setTouchEnabled(true)
		buttonMaTou:setSwallowTouches(false)
		buttonMaTou:addTouchEventListener(function(ref, type)
			self:otherBuildButtonCallFun(buttonMaTou, ref, type)
		end)
		self.buttonMaTou = buttonMaTou
		self.buttonMaTou:setTag(cityBuildConstDef.OtherBuildDef.Gangkou)
	end
	local buttonConquer = SoraDGetChildByName(self.containerView, "Button_conquer")
	if nil ~= buttonConquer then
		buttonConquer:setTouchEnabled(true)
		buttonConquer:setSwallowTouches(false)
		buttonConquer:addTouchEventListener(function(ref, type)
			self:otherBuildButtonCallFun(buttonConquer, ref, type)
		end)
		self.buttonConquer = buttonConquer
		self.buttonConquer:setTag(cityBuildConstDef.OtherBuildDef.ConquerGate)
	end
	local buttonBulletInBoard = SoraDGetChildByName(self.containerView, "Button_bulletin_board")
	if nil ~= buttonBulletInBoard then
		buttonBulletInBoard:setTouchEnabled(false)
		buttonBulletInBoard:setSwallowTouches(false)
		buttonBulletInBoard:addTouchEventListener(function(ref, type)
			self:otherBuildButtonCallFun(buttonBulletInBoard, ref, type)
		end)
		self.buttonBulletInBoard = buttonBulletInBoard
		self.buttonBulletInBoard:setTag(cityBuildConstDef.OtherBuildDef.BulletInBoard)
	end
	local buildIndex = cityBuildConstDef.buildIndexDef.index_CommandHall
	local buildName = "build_" .. buildIndex
	local btnBuild = SoraDGetChildByName(self.containerView, buildName)
	if nil ~= btnBuild then
		btnBuild:setTouchEnabled(true)
		btnBuild:addTouchEventListener(function(ref, type)
			self:otherBuildButtonCallFun(btnBuild, ref, type)
		end)
		btnBuild:setSwallowTouches(false)
		btnBuild:setTag(buildIndex)
		mainCityCreate = buildIndex
		mainCityCreate, buildIndex.name = i18n("commandhall_text_1"), i18n("commandhall_text_1")
		i18n("commandhall_text_1").x = 200
		buildIndex.pos, i18n("commandhall_text_1").y = i18n("commandhall_text_1"), 0
		SoraDShowNameOnTouchEvent(btnBuild, buildIndex)
	end
	for i = 30001, 30007 do
		local buildButton = mainCityCreate.setBuildBtn(self, i)
		if i == cityBuildConstDef.fixedBuildDef.LeisureCenter then
			self.buttonLeisureCenter = buildButton
		elseif i == cityBuildConstDef.fixedBuildDef.HuoChuang then
			self.buttonHuoChuang = buildButton
		elseif i == cityBuildConstDef.buildIndexDef.index_PetCenter then
			self.buttonPetCenter = buildButton
		elseif i == cityBuildConstDef.buildIndexDef.index_ResurrectionHall then
			self.buttonResurrectionHall = buildButton
		elseif i == cityBuildConstDef.buildIndexDef.index_ServiceCenter then
			self.buttonServiceCenter = buildButton
		elseif i == cityBuildConstDef.buildIndexDef.index_EpicBattle then
			self.buttonEpicBattle = buildButton
		end
	end
	if not IsArClient then
		for i = 30008, 30008 do
			mainCityCreate.setBuildBtn(self, i)
		end
	end
	for i = 30010, 30011 do
		mainCityCreate.setBuildBtn(self, i)
	end
	for i = 1200, 1206 do
		mainCityCreate.setBuildBtn(self, i)
	end
	for i = 1151, 1152 do
		mainCityCreate.setBuildBtn(self, i)
	end
	local index = cityBuildConstDef.buildIndexDef.index_HuoChuang
	local buildName = "build_" .. index
	self.btnHuoChuang = self:getBufferNodeByName(buildName)
	local index = cityBuildConstDef.buildIndexDef.index_PetCenter
	local buildName = "build_" .. index
	self.btnPetCenter = self:getBufferNodeByName(buildName)
	if commonCheck.GARDEN then
		mainCityCreate.setBuildBtn(self, BUILDID.GARDEN)
	end
end
function mainCityCreate.setBuildBtn(mainCity, i)
	local self = mainCity
	local buildName = "build_" .. i
	local buildButton = self:getBufferNodeByName(buildName)
	if buildButton then
		buildButton:setSwallowTouches(false)
		buildButton:setTag(i)
		buildButton:addTouchEventListener(function(ref, type)
			self:buildButtonCallFun(buildButton, ref, type)
		end)
	end
	return buildButton
end
function mainCityCreate.initBufferNodeArray(mainCity)
	local self = mainCity
	local allChildren = self.containerView:getChildren()
	for i, v in ipairs(allChildren) do
		self:addToBufferNodeArrayByName(v:getName(), v)
	end
	for i = 1, 18 do
		local bg_hallName = string.format("BG_hall__%02d_2", i)
		local bghallItem = self:getBufferNodeByName(bg_hallName)
		if bghallItem then
			local texture = bghallItem:getTexture()
			if texture:hasMipmaps() then
				texture:setTexParameters(gl.LINEAR_MIPMAP_NEAREST, gl.LINEAR_MIPMAP_NEAREST, gl.CLAMP_TO_EDGE, gl.CLAMP_TO_EDGE)
			else
				texture:setTexParameters(gl.NEAREST, gl.NEAREST, gl.CLAMP_TO_EDGE, gl.CLAMP_TO_EDGE)
			end
		end
	end
	local newCityBgNode = self:getBufferNodeByName("CCS_mainCityViewBG_bg")
	if newCityBgNode then
		local arrChild = newCityBgNode:getChildren()
		for i, v in ipairs(arrChild) do
			local texture = v:getTexture()
			if texture:hasMipmaps() then
				texture:setTexParameters(gl.LINEAR_MIPMAP_NEAREST, gl.LINEAR_MIPMAP_NEAREST, gl.CLAMP_TO_EDGE, gl.CLAMP_TO_EDGE)
			else
				texture:setTexParameters(gl.NEAREST, gl.NEAREST, gl.CLAMP_TO_EDGE, gl.CLAMP_TO_EDGE)
			end
		end
	end
end
function mainCityCreate.initAfterCreate(mainCity)
	local self = mainCity
	local guideCtrl = gametop.playertop_:getModule("guideCtrl")
	local mainCityGuideStep = guideCtrl:getCurMainCityGuideStep()
	if mainCityGuideStep ~= nil then
		mainCityCreate.createMainCityGuide(self, mainCityGuideStep)
	end
	if self.isNeedFirstFight == true then
		mainCityCreate.showFirstEnter(self)
		return
	elseif mainCityGuideStep ~= nil then
		return
	end
	self:updatePeriod()
	mainCityCreate.initWithBuildData(self)
	mainCityCreate.initWithHuoChuangData(self)
	mainCityCreate.initMatouData(self)
	self:initCelebrateGift()
	gametop = self
	self.msg = "MESSAGE_MAINCITYVIEW_PYRAMID_BATTLE_MSG"
	SoraDSendMessage(self)
	self:msgUpdateLion()
	mainCityBuildingMove:init(self)
	mainCityABMManager:init(self)
	local commandHallCtrl = SoraDGetCtrl("commandHallCtrl")
	commandHallCtrl:updateBuildTopTip()
end
function mainCityCreate.initWeather(mainCity, ...)
	local self = mainCity
	local period = SoraDGetDayPeriod()
	local isCfgNightOn = SoraDConfigGet("Game:GameOptionsView:nightSwitch~bool")
	if period == gDay.DAY_TIME or not isCfgNightOn then
		local wType, oWType = kingdomWeatherCtrl:getKingdomWeather()
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_WEATHER_NOTIFY_MSG"
		;(nil).wType = wType
		;(nil).oWType = oWType
		SoraDSendMessage(nil)
	end
end
function mainCityCreate.initWithHuoChuangData(mainCity, ...)
	local self = mainCity
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.CARGO_SHIP)
	if unlockLv > SoraDGetCastleLv() then
		return
	end
	local isCanReceive = loginRewardCtrl:getCanReceive()
	if isCanReceive then
		self:addBuildEffect(cityBuildConstDef.OtherBuildDef.HuoChuang)
	else
		self:removeBuildEffect(cityBuildConstDef.OtherBuildDef.HuoChuang)
	end
	effectMainCityView.addBuildTopTipHuochuang(self)
end
function mainCityCreate.initMatouData(mainCity, ...)
	local self = mainCity
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.PORT)
	if unlockLv <= SoraDGetCastleLv() then
		local onlineRewardData = timeRewardCtrl:getTimeRewardData()
		self.isCanGetReward = 1
		self.rewardOnline, funUnlockRead, self.rewardCount = timeRewardCtrl, timeRewardCtrl, 0
		self.isAllReceive = 0
		if onlineRewardData then
			self.isCanGetReward = onlineRewardData.isReceive
			self.rewardCount = onlineRewardData.sequence
			self.rewardOnline = onlineRewardData.reward
			self.isAllReceive = onlineRewardData.isAllReceive or 0
		end
		if self.isCanGetReward == 2 then
			funUnlockRead = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_DELETE_MATOU_TIP"
			SoraDSendMessage(nil)
			funUnlockRead = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_EFFECT"
			;(nil).buildIndex = cityBuildConstDef.OtherBuildDef.Gangkou
			SoraDSendMessage(nil)
			funUnlockRead = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP"
			;(nil).buildIndex = cityBuildConstDef.OtherBuildDef.Gangkou
			SoraDSendMessage(nil)
		else
			funUnlockRead = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
			;(nil).buildIndex = cityBuildConstDef.OtherBuildDef.Gangkou
			SoraDSendMessage(nil)
			if self.isAllReceive == 1 then
				funUnlockRead = nil
				;(nil).msg = "MESSAGE_MAINCITYVIEW_DELETE_MATOU_TIP"
				SoraDSendMessage(nil)
				funUnlockRead = nil
				;(nil).msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_EFFECT"
				;(nil).buildIndex = cityBuildConstDef.OtherBuildDef.Gangkou
				SoraDSendMessage(nil)
			elseif onlineRewardData then
				funUnlockRead = nil
				;(nil).msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_EFFECT"
				;(nil).buildIndex = cityBuildConstDef.OtherBuildDef.Gangkou
				SoraDSendMessage(nil)
				funUnlockRead = nil
				;(nil).msg = "MESSAGE_MAINCITYVIEW_ADD_MATOU_TIP"
				SoraDSendMessage(nil)
			end
		end
	end
end
function mainCityCreate.checkCastleGift(mainCity)
	local dressCtrl = SoraDGetCtrl("dressCtrl")
	if dressCtrl:isShowMenuRed() then
		_ENV = dressCtrl
		dressCtrl.msg = "MESSAGE_MAINCITYVIEW_ADD_CASTLE_GIFT_TOP_TIP"
		SoraDSendMessage(dressCtrl)
		return
	end
	local privilegeGiftCtrl = gametop.playertop_:getModule("privilegeGiftCtrl")
	if not privilegeGiftCtrl:getCurCanBuyRechargeID() then
		local _ENV, gift = privilegeGiftCtrl:getCurCanBuyRechargeID(), privilegeGiftCtrl:getCurCanBuyRechargeID()
	end
	if not privilegeGiftCtrl:getCurStarLvCanBuyRechargeID() then
		local _ENV, starGift = privilegeGiftCtrl:getCurStarLvCanBuyRechargeID(), privilegeGiftCtrl:getCurStarLvCanBuyRechargeID()
	end
	local isShow = false
	if next(gift) or next(starGift) then
		isShow = true
	end
	_ENV = nil
	;(nil).byUID = true
	local clickTime = SoraDConfigGet("Game:MainCityView:castleGiftTipTime~integer", nil)
	if (clickTime == 0 or not serviceFunctions.isSameDay(clickTime)) and isShow then
		_ENV = clickTime
		clickTime.msg = "MESSAGE_MAINCITYVIEW_ADD_CASTLE_GIFT_TOP_TIP"
		SoraDSendMessage(clickTime)
	end
end
function mainCityCreate.checkEndlessTreasure(mainCity)
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_ADD_ENDLESSTREASURE_TOP_TIP"
	SoraDSendMessage(nil)
end
function mainCityCreate.checkAllianceTreasure(mainCity)
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_ADD_WAREHOUSE_GIFT_TOP_TIP"
	SoraDSendMessage(nil)
end
function mainCityCreate.checkFriend(mainCity)
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_FRIEND_UPDATE_TIP"
	SoraDSendMessage(nil)
end
function mainCityCreate.checkEpicWar(mainCity)
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_ADD_EPICWAR_TOP_TIP"
	SoraDSendMessage(nil)
end
function mainCityCreate.checkPromoteArmy(mainCity)
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_ADD_PROMOTE_TOP_TIP"
	SoraDSendMessage(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_UPDATE_FLAG_COOLING_PANEL"
	SoraDSendMessage(nil)
end
function mainCityCreate.checkMastery(mainCity)
	if not IsArClient then
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_UPDATE_MASTERY_VIEW"
		SoraDSendMessage(nil)
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_UPDATE_MASTERY_COOLING_PANEL"
		SoraDSendMessage(nil)
		_ENV = nil
		;(nil).msg = "MESSAGE_UPDATE_MASTERY_TOP_TIP"
		SoraDSendMessage(nil)
	end
end
function mainCityCreate.initPlayerLevelOffLine(mainCity)
	local self = mainCity
	_ENV = nil
	;(nil).msg = "MESSAGE_MAIN_AGREEMENT_BOX"
	SoraDSendMessage(nil)
	local isShow = false
	local isPop = lordInfoCtrl:getLordUpgradePopStatus()
	if isPop then
		_ENV = nil
		;(nil).msg = "MESSAGE_LORDINFO_UPGRADE_LEVEL"
		SoraDSendMessage(nil)
		isShow = true
	end
	local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
	if remainsTeamCtrl:isHasInvitedInfo() then
		_ENV = remainsTeamCtrl
		remainsTeamCtrl.msg = "MESSAGE_SERVER_REMAINS_TEAM_INVITED_INFO"
		SoraDSendMessage(remainsTeamCtrl)
		isShow = true
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	if cityCtrl:getCastleUpgradePopStatus() then
		_ENV = cityCtrl
		cityCtrl.msg = "MESSAGE_MAINCITYVIEW_CASTLE_LEVELUP"
		SoraDSendMessage(cityCtrl)
		isShow = true
	end
	return isShow
end
function mainCityCreate.initWithBuildData(mainCity)
	local self = mainCity
	local buildCellTurretL = cityCtrl:getBuildCellByIndex(1052)
	local buildCellWall = cityCtrl:getBuildCellByIndex(1053)
	local buildCellTurretR = cityCtrl:getBuildCellByIndex(1054)
	local buildCellWatchTower = cityCtrl:getBuildCellByIndex(1055)
	print("begin --- 初始化建筑~~~")
	self:addBuild(1052, tonumber(buildCellTurretL.info.bid))
	self:addBuild(1053, tonumber(buildCellWall.info.bid))
	self:addBuild(1054, tonumber(buildCellTurretR.info.bid))
	self:addBuild(1055, tonumber(buildCellWatchTower.info.bid))
	self:addBuild(30010, BUILDID.MAGIC_LAMP)
	self:addBuild(30011, BUILDID.NEWBORN_TREE)
	effectMainCityView.updateCommunityView(self)
	effectMainCityView.updateStarBraveStatueView(self)
	mainCityCreate.updateBuildBtnVisible(self)
	self:loadFixedBuilds()
	cityBuildSpritePool:init()
	self:setMainCityEnabled(false)
	print("mainCityCreate.initWithBuildData --- 初始化建筑动画播放~~~")
	local actDelay = cca.delay(0.1)
	local callFunc = cca.callFunc(function()
		mainCityCreate.createInnerCityBuilds(self)
		mainCityCreate.checkBuildLockVisible(self)
	end)
	effectMainCityView = BUILDID.NEWBORN_TREE
	BUILDID.NEWBORN_TREE[1] = actDelay
	BUILDID.NEWBORN_TREE[2] = callFunc
	local seq = cca.seq(BUILDID.NEWBORN_TREE)
	self:runAction(seq)
end
function mainCityCreate.initMainCityPos(mainCity)
	local self = mainCity
	if self.isNeedFirstFight == true then
		local Button_Chengbao = self:getBufferNodeByName("build_1050")
		local posX = Button_Chengbao:getPositionX()
		local posY = Button_Chengbao:getPositionY() + 500
		local retPos = self:getContainerOffsetWhenPosPoint(cc.p(posX, posY), cc.p(display.width / 2, display.rheight / 2), false, true)
		print("隐藏UI---------")
		_ENV = "隐藏UI---------"
		;("隐藏UI---------").msg = "MESSAGE_MAIN_UI_HIDDLE"
		;("隐藏UI---------").isHiddle = true
		SoraDSendMessage("隐藏UI---------")
		self.viewScrollView:setContentOffset(retPos)
		cityBuildFunction:setIsFirstLogin(false)
		return
	end
	local hasCargo = false
	local hasWuzi = false
	local retPos = self:getDefaultMainCityPos()
	local isLogin = false
	local preScale = self.defaultScale
	retPos, isLogin = cityBuildFunction:getCurrentMainCityPos(retPos)
	self.isLogin = isLogin
	if self.isLogin then
		print("隐藏UI---------")
		_ENV = "隐藏UI---------"
		;("隐藏UI---------").msg = "MESSAGE_MAIN_UI_HIDDLE"
		;("隐藏UI---------").isHiddle = true
		SoraDSendMessage("隐藏UI---------")
	end
	if hasCargo then
		if self.isLogin then
			self:setZoomScale(self.normalScale, false)
			retPos = self:getDefaultMainCityMantouPos()
			self.viewScrollView:setContentOffset(retPos)
			return
		else
			retPos = self:getDefaultMainCityPos()
			retPos, isLogin, preScale = cityBuildFunction:getCurrentMainCityPos(retPos)
			retPos = cityBuildFunction:getTransformedPos(retPos, preScale, self.defaultScale)
			self:setZoomScale(self.defaultScale, false)
			self.viewScrollView:setContentOffset(retPos)
		end
	elseif hasWuzi then
		if self.isLogin then
			self:setZoomScale(self.normalScale, false)
			retPos = self:getDefaultMainCityHuochuangPos()
			self.viewScrollView:setContentOffset(retPos)
			return
		else
			retPos = self:getDefaultMainCityPos()
			retPos, isLogin, preScale = cityBuildFunction:getCurrentMainCityPos(retPos)
			retPos = cityBuildFunction:getTransformedPos(retPos, preScale, self.defaultScale)
			self:setZoomScale(self.defaultScale, false)
			self.viewScrollView:setContentOffset(retPos)
		end
	elseif self.isLogin then
		retPos = self:getDefaultMainCityPos()
		cityBuildFunction:getCurrentMainCityPos(retPos)
		self:setZoomScale(self.normalScale, false)
		retPos = self:getDefaultMainCityPos()
		self.viewScrollView:setContentOffset(retPos)
		return
	else
		retPos = self:getDefaultMainCityPos()
		retPos, isLogin, preScale = cityBuildFunction:getCurrentMainCityPos(retPos)
		retPos = cityBuildFunction:getTransformedPos(retPos, preScale, self.defaultScale)
		self:setZoomScale(self.defaultScale, false)
		self.viewScrollView:setContentOffset(retPos)
		return
	end
end
function mainCityCreate.createInnerCityBuilds(mainCity)
	local self = mainCity
	print("begin === 创建内城建筑")
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local buildlist = cityCtrl:getBuildList()
	for k, buildcellItem in pairs(buildlist) do
		if buildcellItem.info and buildcellItem.info.index then
			local buildIndex = tonumber(buildcellItem.info.index)
			if buildIndex < 1100 and buildIndex ~= 1052 and buildIndex ~= 1053 and buildIndex ~= 1054 and buildIndex ~= 1055 then
				local cellIndexName = "build_" .. buildIndex
				local buildBtn = self:getBufferNodeByName(cellIndexName)
				if buildBtn then
					local buildEntity = buildBtn:getChildByName("buildName")
					if nil == buildEntity then
						self:addBuild(tonumber(buildIndex), tonumber(buildcellItem.info.bid))
					else
						buildBtn:setCascadeOpacityEnabled(false)
						buildBtn:setOpacity(0)
						buildEntity:initWithBuildCell(buildcellItem)
					end
				end
			end
		end
	end
	if commonCheck.GARDEN then
		self:addBuild(BUILDID.GARDEN, BUILDID.GARDEN)
	end
	print("end === 创建内城建筑")
	mainCityCreate.createOuterCityBuilds(self)
end
function mainCityCreate.createOuterCityBuilds(mainCity)
	local self = mainCity
	print("begin === 创建外城建筑")
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local buildlist = cityCtrl:getBuildList()
	for k, buildcellItem in pairs(buildlist) do
		if buildcellItem.info and buildcellItem.info.index then
			local buildIndex = tonumber(buildcellItem.info.index)
			if 1100 <= buildIndex then
				local cellIndexName = "build_" .. buildIndex
				local buildBtn = self:getBufferNodeByName(cellIndexName)
				if buildBtn then
					local buildEntity = buildBtn:getChildByName("buildName")
					if nil == buildEntity then
						self:addBuild(tonumber(buildIndex), tonumber(buildcellItem.info.bid))
					else
						buildBtn:setCascadeOpacityEnabled(false)
						buildBtn:setOpacity(0)
						buildEntity:initWithBuildCell(buildcellItem)
					end
				end
			end
		end
	end
	print("end === 创建外城建筑")
	cityBuildMgr:initWithData(self)
	local delay = cca.delay(0.016666666666666666)
	local callFunc2 = cca.callFunc(function()
		mainCityCreate.delayInitWithBuildData(mainCity)
	end)
	mainCityCreate = tonumber(buildcellItem.info.index)
	tonumber(buildcellItem.info.index)[1] = delay
	tonumber(buildcellItem.info.index)[2] = callFunc2
	self:runAction(cca.seq((tonumber(buildcellItem.info.index))))
	effectMainCityView.addHarvestEffect(self)
end
function mainCityCreate.delayInitWithBuildData(mainCity)
	local self = mainCity
	userSDKManager.timeInfo.t_maincity.tend = SoraDGetSocketTime()
	userSDKManager.timeInfo.t_maincityp.tbegin = SoraDGetSocketTime()
	print("内城创建结束------")
	mainCityFunctions.updateLockArea(self)
	self:updateBuildTiles()
	if SoraDIsGameGuide() == nil then
		self:autoUpdateViewScrollViewPos()
		self:setZoomScale(self.defaultScale, false)
		local isAgreeMent = cityBuildFunction:checkUserAgreement()
		cityBuildFunction:checkGuide(isAgreeMent)
		local soldierRushCtrl = SoraDGetCtrl("soldierRushCtrl")
		_ENV = nil
		;(nil).byUID = true
		local isGuide = SoraDConfigGet("Game:SoldierRush:hookGuide~bool", nil)
		local isSvrGuide = SoraDGetCtrl("guideCtrl"):isGuideNotCompleted(gGuideModule.SOLDIER_RUSH_AFK)
		print("isSvrGuide,isGuide=====", isSvrGuide, isGuide)
		if isSvrGuide then
			if isGuide then
				_ENV = isGuide
				isGuide.byUID = true
				SoraDConfigSet("Game:SoldierRush:hookGuide~bool", true, isGuide)
				SoraDGetCtrl("guideCtrl"):CompleteGuideStep(950103)
			elseif soldierRushCtrl:isHaveRecord() then
				SoraDGetCtrl("guideCtrl"):updateGuideModule(gGuideModule.SOLDIER_RUSH_AFK)
			end
		end
	else
		self:setZoomScale(self.defaultScale, false)
		self:autoUpdateViewScrollViewPos()
	end
	self:loadSoldiers()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
	self:updateTime()
	self.timeHandlerPerFrame = SoradCreateTimer(self, handler(self, self.updateTimePerFrame), true)
	self:updateTimePerFrame()
	_ENV = self
	self.msg = "MESSAGE_MAINCITYVIEW_UPDATE_WALL_VIEW"
	SoraDSendMessage(self)
	local buildBtnName = "build_" .. 1053
	local build = self:getBufferNodeByName(buildBtnName)
	if build then
		local buildEntity = build:getChildByName("buildName")
		local viewModelWall = buildEntity:getViewModel()
		_ENV = handler(self, self.updateTime)
		handler(self, self.updateTime).msg = "MESSAGE_MAINCITYVIEW_UPDATE_TURRET_OFFSET"
		handler(self, self.updateTime).viewModel = viewModelWall
		SoraDSendMessage(handler(self, self.updateTime))
	end
	_ENV = buildEntity:getViewModel()
	buildEntity:getViewModel().msg = "MESSAGE_MAINCITYVIEW_UPDATE_WALL_EFFECT"
	SoraDSendMessage((buildEntity:getViewModel()))
	_ENV = buildEntity:getViewModel()
	buildEntity:getViewModel().msg = "MESSAGE_MAINCITYVIEW_UPDATE_HOSPTIAL_VIEW"
	SoraDSendMessage((buildEntity:getViewModel()))
	_ENV = buildEntity:getViewModel()
	buildEntity:getViewModel().msg = "MESSAGE_QUEST_NOTICE_RECOMMEND_UPDATE"
	SoraDSendMessage((buildEntity:getViewModel()))
	cityHorseCtrl:sendInit()
	effectMainCityView.showEagle(self)
	effectMainCityView.addEffectActivityCenter(self)
	mainCityCreate.initPlayerLevelOffLine(self)
	if SoraDIsGameGuide() == nil then
		if self.initOtherData ~= nil then
			local otherData = self.initOtherData
			local bDealed = mainCityCreate.dealWithInitData(self, otherData)
			if bDealed == false then
				self:autoUpdateMainCityPos()
			end
		else
			self:autoUpdateMainCityPos()
			if self.isLogin and not wallsCtrl:isDestruction() and SoraDIsGameGuide() == nil and not SoraDJumpToBuyGift() then
				local isDebug = false
				if isDebug then
					cityBuildFunction:checkPopUpWindow()
				elseif xpcall(function()
					cityBuildFunction:checkPopUpWindow()
				end, function()
					print(debug.traceback())
				end) then
				else
					print("cityBuildFunction:checkPopUpWindow 异常了，请处理-------@ct")
				end
			end
		end
	else
		self:setMainCityEnabled(true)
	end
	_ENV = self
	self.msg = "MESSAGE_MAINCITYVIEW_UPDATE_BUILD_TIP_BOX"
	SoraDSendMessage(self)
	_ENV = self
	self.msg = "MESSAGE_MAINCITYVIEW_UPDATE_MERCHANT_VIEW"
	SoraDSendMessage(self)
	_ENV = self
	self.msg = "MESSAGE_WALLS_NOTIFY_SUCCESS"
	SoraDSendMessage(self)
	local wallsCtrl = gametop.playertop_:getModule("wallsCtrl")
	if wallsCtrl:isDestruction() then
		_ENV = wallsCtrl
		wallsCtrl.msg = "MESSAGE_WALLS_DEFENCE_DESTROY"
		SoraDSendMessage(wallsCtrl)
	end
	if self.isLogin then
		print("--加载完成 显示mainUI")
		local actDelay = cca.delay(0.15)
		local callFunc = cca.callFunc(function()
			print("-----发送显示UI---")
			_ENV = "-----发送显示UI---"
			;("-----发送显示UI---").msg = "MESSAGE_MAIN_UI_HIDDLE"
			;("-----发送显示UI---").isHiddle = false
			;("-----发送显示UI---").isLogin = self.isLogin
			SoraDSendMessage("-----发送显示UI---")
		end)
		cityBuildFunction = handler(self, self.updateTime)
		handler(self, self.updateTime)[1] = actDelay
		handler(self, self.updateTime)[2] = callFunc
		local seq = cca.seq(handler(self, self.updateTime))
		self:runAction(seq)
	end
	_ENV = cca.callFunc(function()
		print("-----发送显示UI---")
		_ENV = "-----发送显示UI---"
		;("-----发送显示UI---").msg = "MESSAGE_MAIN_UI_HIDDLE"
		;("-----发送显示UI---").isHiddle = false
		;("-----发送显示UI---").isLogin = self.isLogin
		SoraDSendMessage("-----发送显示UI---")
	end)
	cca.callFunc(function()
		print("-----发送显示UI---")
		_ENV = "-----发送显示UI---"
		;("-----发送显示UI---").msg = "MESSAGE_MAIN_UI_HIDDLE"
		;("-----发送显示UI---").isHiddle = false
		;("-----发送显示UI---").isLogin = self.isLogin
		SoraDSendMessage("-----发送显示UI---")
	end).msg = "MESSAGE_MAINCITYVIEW_CLOSE_FIRST_FIGHT"
	SoraDSendMessage((cca.callFunc(function()
		print("-----发送显示UI---")
		_ENV = "-----发送显示UI---"
		;("-----发送显示UI---").msg = "MESSAGE_MAIN_UI_HIDDLE"
		;("-----发送显示UI---").isHiddle = false
		;("-----发送显示UI---").isLogin = self.isLogin
		SoraDSendMessage("-----发送显示UI---")
	end)))
	if SoraDGetFactionType() == FACTION_TYPE.FACTION_NORMAL then
		local buildFirst = self:getBufferNodeByName("city_First_build_castle")
		if buildFirst then
			buildFirst:setVisible(false)
		end
	end
	effectMainCityView.addWaveEffect(self)
	effectMainCityView.addSoldierGuard(self)
	effectMainCityView.addHarborWorker(self)
	effectMainCityView.addActivityCentetNpc(self)
	effectMainCityView.addCastleGateNpc(self)
	effectMainCityView.addXiyiAnimation(self)
	effectMainCityView.addConquerGateAnimation(self)
	_ENV = self
	self.msg = "MESSAGE_SERVER_UPDATE_IDLE_GUIDE"
	SoraDSendMessage(self)
	_ENV = false
	;(false).isInit = true
	self:refreshCastleSkin(self, false)
	mainCityCreate.checkCastleGift(self)
	mainCityCreate.checkEndlessTreasure(self)
	mainCityCreate.checkAllianceTreasure(self)
	mainCityCreate.checkFriend(self)
	mainCityCreate.checkEpicWar(self)
	mainCityCreate.checkPromoteArmy(self)
	mainCityCreate.checkMastery(self)
	self:initVisibleArea()
	self:enableShack()
	_ENV = self
	self.msg = "MESSAGE_MAINCITYVIEW_UPDATE_PET_SHOW"
	SoraDSendMessage(self)
	userSDKManager.timeInfo.t_maincityp.tend = SoraDGetSocketTime()
	userSDKManager.timeInfo.t_total.tend = SoraDGetSocketTime()
	if SoraDIsGameGuide() == nil then
		local npcTipClient = include("npcTipClient")
		npcTipClient:cleanTipInfo()
		if npcTipClient:hasTip() then
			print("-------产生了npc智能提示-----------")
			local tipInfo = npcTipClient:getOrCreateTipInfo()
			if tipInfo.bid ~= 0 or tipInfo.bIndex ~= 0 then
				npcTipClient:setTopTipOn(true)
				_ENV = npcTipClient
				npcTipClient.msg = "MESSAGE_MAINCITYVIEW_ADD_NPC_TOP_TIP"
				npcTipClient.bid = tipInfo.bid
				npcTipClient.bIndex = tipInfo.bIndex
				SoraDSendMessage(npcTipClient)
			end
		else
			print("------没有产生npc智能提示 ---------")
		end
	end
	SoraDCloseSwitcherView()
	_ENV = print
	print.msg = "MESSAGE_MAINCITYVIEW_HERO_APPOINT_TIP"
	SoraDSendMessage(print)
	_ENV = print
	print.msg = "MESSAGE_MAINCITYVIEW_ADD_SHELTER_TOP_TIP"
	SoraDSendMessage(print)
	local isNeedHideAutoTrans = false
	if device.platform == "ios" then
		local iOSVersion = userSDKManager.getDeviceOSVersion()
		iOSVersion = iOSVersion and string.match(iOSVersion, "%d+.%d+")
		if iOSVersion and tonumber(iOSVersion) < 8.4 then
			isNeedHideAutoTrans = true
		end
	end
	if isNeedHideAutoTrans then
		local settingCtrl = gametop.playertop_:getModule("settingCtrl")
		print("检测到8.4以下ios系统，开启自动翻译&所有的自动翻译")
		settingCtrl:setAutoTranslateSwitchOn()
		local _ENV, checkList = settingCtrl.setAutoTranslateSwitchOn, settingCtrl.setAutoTranslateSwitchOn
		for k, v in pairs(settingCtrl:getTLList()) do
			checkList[k] = true
		end
		dump(checkList, "checkList")
		settingCtrl:setTranslateLanguage(checkList)
	end
end
function mainCityCreate.dealWithInitData(mainCity, otherData)
	local self = mainCity
	local bDealed = false
	if otherData.msg == "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP_HAND" then
		local offsetType = otherData.offsetType
		local bid = otherData.bid
		local iid = otherData.iid
		local isLockArea = otherData.isLockArea
		local delay = otherData.delay
		if offsetType == MAINCITYVIEW_OFFSET_TYPE_BUILD_TIP_HAND then
			local isLockArea = otherData.isLockArea
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP_HAND"
			;(nil).offsetType = offsetType
			;(nil).bid = bid
			;(nil).iid = iid
			;(nil).isLockArea = isLockArea
			;(nil).delay = delay
			SoraDSendMessage(nil)
			bDealed = true
		end
	elseif otherData.msg == "MESSAGE_MAINCITYVIEW_ENTER_MOVE_MODE" then
		_ENV = otherData.bid
		otherData.bid.msg = "MESSAGE_MAINCITYVIEW_ENTER_MOVE_MODE"
		SoraDSendMessage(otherData.bid)
		bDealed = true
	elseif otherData.msg == "MESSAGE_TRIGGER_SKILLS" then
		_UPVALUE1_ = otherData.isLockArea
		otherData.isLockArea[1] = cca.delay(1.5)
		otherData.isLockArea[2] = cca.callFunc(function()
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_LORD_SKILL_EFFECT"
			;(nil).data = otherData
			SoraDSendMessage(nil)
		end)
		otherData.isLockArea[3] = cca.callFunc(function()
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_LORD_SKILL_EFFECT"
			;(nil).data = otherData
			SoraDSendMessage(nil)
		end)
		otherData.isLockArea[4] = cca.callFunc(function()
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_LORD_SKILL_EFFECT"
			;(nil).data = otherData
			SoraDSendMessage(nil)
		end)
		otherData.isLockArea[5] = cca.callFunc(function()
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_LORD_SKILL_EFFECT"
			;(nil).data = otherData
			SoraDSendMessage(nil)
		end)
		otherData.isLockArea[6] = cca.callFunc(function()
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_LORD_SKILL_EFFECT"
			;(nil).data = otherData
			SoraDSendMessage(nil)
		end)
		otherData.isLockArea[7] = cca.callFunc(function()
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_LORD_SKILL_EFFECT"
			;(nil).data = otherData
			SoraDSendMessage(nil)
		end)
		otherData.isLockArea[8] = cca.callFunc(function()
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_LORD_SKILL_EFFECT"
			;(nil).data = otherData
			SoraDSendMessage(nil)
		end)
		otherData.isLockArea[9] = cca.callFunc(function()
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_LORD_SKILL_EFFECT"
			;(nil).data = otherData
			SoraDSendMessage(nil)
		end)
		otherData.isLockArea[10] = cca.callFunc(function()
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_LORD_SKILL_EFFECT"
			;(nil).data = otherData
			SoraDSendMessage(nil)
		end)
		otherData.isLockArea[11] = cca.callFunc(function()
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_LORD_SKILL_EFFECT"
			;(nil).data = otherData
			SoraDSendMessage(nil)
		end)
		otherData.isLockArea[12] = cca.callFunc(function()
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_LORD_SKILL_EFFECT"
			;(nil).data = otherData
			SoraDSendMessage(nil)
		end)
		self:runAction(cca.seq(otherData.isLockArea))
		bDealed = true
	elseif otherData.msg == "MESSAGE_MAINCITYVIEW_MOVETO_BUILDBYBID" then
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_MOVETO_BUILDBYBID"
		self.bid = otherData.bid
		self.view = otherData.view
		self.goOuterCity = otherData.goOuterCity
		self.notOpen = otherData.notOpen
		self.isGuide = otherData.isGuide
		self.qType = otherData.qType
		SoraDSendMessage(self)
		bDealed = true
	elseif otherData.msg == "MESSAGE_MAINCITYVIEW_OFFSET_BUILD" then
		local offsetType = otherData.offsetType
		local buildIndex = otherData.buildIndex
		local xOffset = otherData.xOffset
		local yOffset = otherData.yOffset
		local scale = otherData.scale
		local noOffsetDuration = otherData.noOffsetDuration
		local noScaleDuration = otherData.noScaleDuration
		local handle = otherData.handle
		local delay = otherData.delay or 0
		_ENV = cca.seq(otherData.isLockArea)
		cca.seq(otherData.isLockArea).msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
		cca.seq(otherData.isLockArea).offsetType = offsetType
		cca.seq(otherData.isLockArea).buildIndex = buildIndex
		cca.seq(otherData.isLockArea).scale = scale
		cca.seq(otherData.isLockArea).xOffset = xOffset
		cca.seq(otherData.isLockArea).yOffset = yOffset
		cca.seq(otherData.isLockArea).noOffsetDuration = noOffsetDuration
		cca.seq(otherData.isLockArea).noScaleDuration = noScaleDuration
		SoraDSendMessage(cca.seq(otherData.isLockArea))
		if handle and delay then
			_UPVALUE1_ = cca.seq(otherData.isLockArea)
			cca.seq(otherData.isLockArea)[1] = cca.delay(delay)
			cca.seq(otherData.isLockArea)[2] = cca.callFunc(handle)
			cca.seq(otherData.isLockArea)[3] = cca.callFunc(handle)
			self:runAction(cca.seq(cca.seq(otherData.isLockArea)))
		end
		bDealed = true
	elseif otherData.msg == "MESSAGE_MAINCITYVIEW_MOVETO_BUILDBYBID" then
		SoraDSendMessage(otherData)
	end
	return bDealed
end
function mainCityCreate.createBuildByCfgId(mainCity, buildButtonIndex, buildCfgItem)
	local self = mainCity
	local buildButtonName = "build_" .. buildButtonIndex
	local buildButton = self:getBufferNodeByName(buildButtonName)
	if nil == buildButton then
		return
	end
	local buildPos = cc.p(buildButton:getPositionX(), buildButton:getPositionY())
	local buildType = SoraDGetBuildTypeByIndex(buildButtonIndex)
	if buildType == 1 then
		self:delBuildTile(buildButton)
	end
	local buildCfgId = buildCfgItem.BuildingCfgId
	local buildEntityExist = buildButton:getChildByName("buildName")
	if buildEntityExist ~= nil then
		local gametop = gModuleMgr.getObject("gametop")
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local buildCell = cityCtrl:getBuildCellByIndex(buildButtonIndex)
		if buildCell ~= nil then
			buildEntityExist:setBuildIndex(buildButtonIndex)
			buildEntityExist:initWithBuildCell(buildCell)
		else
			buildEntityExist:setBuildIndex(buildButtonIndex)
		end
		return buildEntityExist
	end
	do
		local gametop = gModuleMgr.getObject("gametop")
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local buildCell = cityCtrl:getBuildCellByIndex(buildButtonIndex)
		local bid = buildCfgId
		local cityBuildCreator = include("cityBuildCreator")
		local buildContentNode
		if buildType == 0 then
			buildContentNode = cityBuildCreator:createBuild(bid)
		elseif buildType == 1 then
			buildContentNode = cityBuildCreator:createBuild(bid, self.tblBatchNodesOuter, buildPos)
		end
		buildButton:add(buildContentNode, 1)
		buildContentNode:setName("buildName")
		buildContentNode:setTag(buildCfgItem.BuildingUId)
		buildContentNode:ignoreAnchorPointForPosition(false)
		buildContentNode:setAnchorPoint(cc.p(0.5, 0.5))
		buildContentNode:setPosition(cc.p(buildButton:getContentSize().width / 2, buildButton:getContentSize().height / 2))
		if buildCell ~= nil then
			buildContentNode:setBuildIndex(buildButtonIndex)
			buildContentNode:initWithBuildCell(buildCell)
		else
			buildContentNode:setBuildIndex(buildButtonIndex)
			buildContentNode:initWithoutCell()
		end
		return buildContentNode
	end
end
function mainCityCreate.showFirstEnter(mainCity)
	local self = mainCity
	for i = 1, 4 do
		local cqName = "Sprite_Cq_" .. i
		local spriteCqItem = self:getBufferNodeByName(cqName)
		if spriteCqItem then
			spriteCqItem:setVisible(false)
		end
		local jtName = "Sprite_Jt_" .. i
		local spriteJtItem = self:getBufferNodeByName(jtName)
		if spriteJtItem then
			spriteJtItem:setVisible(false)
		end
	end
	local spriteJiantachengduoR = self:getBufferNodeByName("Sprite_Jiantachengduo_R")
	local spriteJiantachengduoL = self:getBufferNodeByName("Sprite_Jiantachengduo_L")
	if spriteJiantachengduoR then
		spriteJiantachengduoR:setVisible(false)
	end
	if spriteJiantachengduoL then
		spriteJiantachengduoL:setVisible(false)
	end
	self.isSkipClick = false
	local lang = SoraDGetDefaultLanguage()
	_UPVALUE2_ = self:getBufferNodeByName(cqName)
	self:getBufferNodeByName(cqName)[1] = "ar"
	self:getBufferNodeByName(cqName)[2] = "en"
	local btnRes = SoraDGetImageNameByLang("res/video/icon_xsyd_%s.png", (self:getBufferNodeByName(cqName)))
	local csbNode = display.getRunningScene()
	_ENV = self:getBufferNodeByName(cqName)
	self:getBufferNodeByName(cqName).usmUrl = "gameCG.usm"
	self:getBufferNodeByName(cqName).onCompleteFun = function(_video)
		self:createFightView()
		if self.isSkipClick then
			self = nil
			;(nil).jump = 302811010
			userSDKManager.logEvent(gSDKDef.TDonEvent.game_cg_play_complete, nil)
		else
			self = nil
			userSDKManager.logEvent(gSDKDef.TDonEvent.game_cg_play_complete, nil)
		end
		SoraDGetCtrl("guideCtrl"):setSkipFirstFight(true)
	end
	self:getBufferNodeByName(cqName).onPanelClick = function(_video)
		if not _video.isAddBtn then
			_video:addSkipButton(" ", false, btnRes, true)
		end
	end
	self:getBufferNodeByName(cqName).onStopfunc = function(_video)
		print("==onStopfunc==")
	end
	self:getBufferNodeByName(cqName).onSkipfunc = function(_video)
		self.isSkipClick = true
	end
	self:getBufferNodeByName(cqName).needRemove = true
	self:getBufferNodeByName(cqName).pauseMusice = true
	local self:getBufferNodeByName(cqName).displaySize, data = cc.size(640, 1386), self:getBufferNodeByName(cqName)
	local videoPlayer = SoraDCreateVideoPlayerSingle(data)
	if videoPlayer then
		videoPlayer:play()
		videoPlayer:setContentSize(cc.size(640, 1386))
		local lang = SoraDGetDefaultLanguage()
		_UPVALUE2_ = cc.size(640, 1386)
		cc.size(640, 1386)[1] = "ar"
		cc.size(640, 1386)[2] = "en"
		local btnRes = SoraDGetImageNameByLang("res/video/icon_xsyd_%s.png", cc.size(640, 1386))
		SoraDCallOnNextFrame(videoPlayer, function()
			if not videoPlayer.isAddBtn then
				videoPlayer:addSkipButton(" ", false, btnRes, true)
			end
		end, 0.5)
	end
end
function mainCityCreate.cleanFirstFight(mainCity)
	local self = mainCity
	if self.batchNodeFightSoldiers then
		self.batchNodeFightSoldiers:removeFromParent()
		self.batchNodeFightSoldiers = nil
	end
	if self.batchNodeFightBullet then
		self.batchNodeFightBullet:removeFromParent()
		self.batchNodeFightBullet = nil
	end
	if self.batchNodeFightBuilds then
		self.batchNodeFightBuilds:removeFromParent()
		self.batchNodeFightBuilds = nil
	end
	if self.batchNodeFightBuildWalls then
		self.batchNodeFightBuildWalls:removeFromParent()
		self.batchNodeFightBuildWalls = nil
	end
	if self.effectFightNode then
		self.effectFightNode:removeFromParent()
		self.effectFightNode = nil
	end
	for i = 1, 4 do
		local cqName = "Sprite_Cq_" .. i
		local spriteCqItem = self:getBufferNodeByName(cqName)
		if spriteCqItem then
			spriteCqItem:setVisible(true)
		end
		local jtName = "Sprite_Jt_" .. i
		local spriteJtItem = self:getBufferNodeByName(jtName)
		if spriteJtItem then
			spriteJtItem:setVisible(true)
		end
	end
end
function mainCityCreate.createFightView(mainCity)
	local self = mainCity
	local delay = cca.delay(0.1)
	local callFunc = cca.callFunc(function()
		mainCityCreate.createFightBatchNode(self)
		local cityBuildFirstFight = include("cityBuildFirstFight")
		local cityBuildFirstFightNode = cityBuildFirstFight.new()
		cityBuildFirstFightNode:initWithData(self)
		cityBuildFirstFightNode:show()
		if SoraDGetFactionType() == FACTION_TYPE.FACTION_NORMAL then
			local buildFirst = self:getBufferNodeByName("city_First_build_castle")
			if buildFirst then
				buildFirst:setVisible(true)
			end
		end
	end)
	_UPVALUE2_ = nil
	;(nil)[1] = delay
	;(nil)[2] = callFunc
	self:runAction(cca.seq(nil))
end
function mainCityCreate.createMainCityGuide(mainCity, mainCityGuideStep)
	local self = mainCity
	if self.mainCityGuide then
		return
	end
	local mainCityGuide = SoraDCreatePanel("mainCityGuide")
	self.mainCityGuide = mainCityGuide
	mainCityGuide:addTo(self.viewScrollView, 2000)
	mainCityGuide:setName("mainCityGuide")
	mainCityGuide:initData(self, mainCityGuideStep, self.isNeedFirstFight)
	mainCityGuide:setPosition(cc.p(mainCityGuide:getContentSize().width / 2, mainCityGuide:getContentSize().height / 2))
	local dikuai = display.newSprite("#mc_dikuai.png")
	dikuai:setPosition(3031, 1532)
	dikuai:addTo(self.viewScrollView)
	dikuai:setName("MainCityGuideDiKuai")
	_ENV = dikuai
	dikuai.msg = "MESSAGE_MAIN_UI_HIDDLE"
	dikuai.isHiddle = false
	SoraDSendMessage(dikuai)
	local img_turret_lock_1052 = self:getBufferNodeByName("img_turret_lock_1052")
	local img_turret_lock_1054 = self:getBufferNodeByName("img_turret_lock_1054")
	if img_turret_lock_1054 then
		img_turret_lock_1054:setVisible(false)
	end
	if img_turret_lock_1052 then
		img_turret_lock_1052:setVisible(false)
	end
	_UPVALUE8_ = img_turret_lock_1052.setVisible
	img_turret_lock_1052.setVisible[1] = "tree03_01_2"
	img_turret_lock_1052.setVisible[2] = "tree01_01_2"
	img_turret_lock_1052.setVisible[3] = "tree02_01_2"
	img_turret_lock_1052.setVisible[4] = "tree02_01_3"
	img_turret_lock_1052.setVisible[5] = "tree02_01_6"
	img_turret_lock_1052.setVisible[6] = "tree01_01_5"
	img_turret_lock_1052.setVisible[7] = "tree01_01_3"
	local img_turret_lock_1052.setVisible[8], trees = "tree03_01_3", img_turret_lock_1052.setVisible
	for i, v in ipairs(trees) do
		local tree = SoraDGetChildByName(self, v)
		if tree then
			tree:setVisible(false)
		end
	end
	local img_merchant = self:getBufferNodeByName("Img_Lvxingshanren")
	if img_merchant then
		img_merchant:setVisible(false)
	end
	for i = 1, 4 do
		local cqName = "Sprite_Cq_" .. i
		local spriteCqItem = self:getBufferNodeByName(cqName)
		if spriteCqItem then
			spriteCqItem:setVisible(false)
		end
		local jtName = "Sprite_Jt_" .. i
		local spriteJtItem = self:getBufferNodeByName(jtName)
		if spriteJtItem then
			spriteJtItem:setVisible(false)
		end
	end
end
function mainCityCreate.cleanMainCityGuide(mainCity)
	local self = mainCity
	SoraDCloseLoading()
	if self.mainCityGuide == nil then
		return
	end
	self.mainCityGuide = nil
	local img_turret_lock_1052 = self:getBufferNodeByName("img_turret_lock_1052")
	local img_turret_lock_1054 = self:getBufferNodeByName("img_turret_lock_1054")
	if img_turret_lock_1054 then
		img_turret_lock_1054:setVisible(true)
	end
	if img_turret_lock_1052 then
		img_turret_lock_1052:setVisible(true)
	end
	_UPVALUE8_ = img_turret_lock_1052.setVisible
	img_turret_lock_1052.setVisible[1] = "tree03_01_2"
	img_turret_lock_1052.setVisible[2] = "tree01_01_2"
	img_turret_lock_1052.setVisible[3] = "tree02_01_2"
	img_turret_lock_1052.setVisible[4] = "tree02_01_3"
	img_turret_lock_1052.setVisible[5] = "tree02_01_6"
	img_turret_lock_1052.setVisible[6] = "tree01_01_5"
	img_turret_lock_1052.setVisible[7] = "tree01_01_3"
	local img_turret_lock_1052.setVisible[8], trees = "tree03_01_3", img_turret_lock_1052.setVisible
	for i, v in ipairs(trees) do
		local tree = SoraDGetChildByName(self, v)
		if tree then
			tree:setVisible(true)
		end
	end
	for i = 1, 4 do
		local cqName = "Sprite_Cq_" .. i
		local spriteCqItem = self:getBufferNodeByName(cqName)
		if spriteCqItem then
			spriteCqItem:setVisible(true)
		end
		local jtName = "Sprite_Jt_" .. i
		local spriteJtItem = self:getBufferNodeByName(jtName)
		if spriteJtItem then
			spriteJtItem:setVisible(true)
		end
	end
	local img_merchant = self:getBufferNodeByName("Img_Lvxingshanren")
	if img_merchant then
		img_merchant:setVisible(true)
	end
	local dikuai = SoraDGetChildByName(self, "MainCityGuideDiKuai")
	if dikuai then
		dikuai:removeFromParent()
	end
	RAMADAN_SWITCH = self.OLD_RAMADAN_SWITCH
	mainCityFunctions.reArrangeZorder(self)
	mainCityCreate.initAfterCreate(self)
end
function mainCityCreate.updateBuildBtnVisible(mainCity)
	local self = mainCity
	local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
	local regionType = nebulaActivityCtrl:getKingdomRegionType()
	dump(regionType, "mainCityCreate.updateBuildBtnVisible")
	local buildList = cityCtrl:getBuildCellList(BUILDID.NEBULA_PALACE)
	local btn_1206 = self:getBufferNodeByName("build_1206")
	local isNebulaShow = 0 < #buildList and regionType == NEBULA_REGION_TYPE.HEGEMONY_REGION
	if btn_1206 then
		btn_1206:setVisible(isNebulaShow)
	end
	local btn_30010 = self:getBufferNodeByName("build_30010")
	if btn_30010 then
		local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
		local isShowBuild = magicLampCtrl:getIsBuildShow()
		btn_30010:setVisible(isShowBuild)
	end
	local btn_30011 = self:getBufferNodeByName("build_30011")
	if btn_30011 then
		local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
		local activity_9001656_Ctrl = SoraDGetCtrl("activity_9001656_Ctrl")
		local doStage = activity_9001656_Ctrl:getDoStage()
		btn_30011:setVisible(divineBeastCtrl:getIsFuncOpen() and (regionType == NEBULA_REGION_TYPE.HEGEMONY_REGION or 1 <= doStage))
	end
end
function mainCityCreate.checkBuildLockVisible(mainCity)
	local self = mainCity
	_UPVALUE1_ = nil
	local (nil)[1], config = BUILDID.GARDEN, nil
	for __, buildId in ipairs(config) do
		local buildName = "build_" .. buildId
		local buildBtn = self:getBufferNodeByName(buildName)
		if buildBtn then
			local buildEntity = buildBtn:getChildByName("buildName")
			if buildEntity then
				local isLockVisible = buildEntity:getIsLockVisible()
				buildBtn:setVisible(isLockVisible)
			end
		end
	end
end
return mainCityCreate
