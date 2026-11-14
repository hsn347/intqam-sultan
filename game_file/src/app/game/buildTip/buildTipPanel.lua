local buildLogic = include("buildLogic")
local buildRead = include("buildDescribeRead")
local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local cityltCtrl = include("cityltCtrl")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local premiumStoreCtrl = SoraDGetCtrl("premiumStoreCtrl")
local cityBuildFunction = include("cityBuildFunction")
local cityBuildConstDef = include("cityBuildConstDef")
local specializationRead = include("specializationRead")
local funUnlockRead = include("funUnlockRead")
local constantRead = include("constantRead")
local mainCityFunctions = include("mainCityFunctions")
local worldMapWarDef = include("worldMapWarDef")
include("cityBuildingInfo")
local buildTipPanel = class("buildTipPanel", function(ccsFile)
	local view = include("baseView")
	return view.new(cc.size(0, 0), false)
end)
local ACTION_TIME = 0.13
local TIME_DELAY_INIT = 0.001
local tag_act_init_view = 30000
local tag_act_single_btn = 1000
local tag_act_tip_show_end = 999
function buildTipPanel:ctor()
	self:createUI()
	self.relyBuildBtnId = 1
	self.relyBuildCfgId = 1
	self.relyBuildIid = 0
	self.relyBuildUId = 1
	self.circleRadius = 260
	self.relyBuildEntity = nil
	self.circleOffsetNormal = 170
	self.circleOffsetCooling = 115
	self.tbBtnNotUse, _UPVALUE0_, self.tbBtnInuse, _UPVALUE0_, self.circleOffsetY = self.circleOffsetNormal, self.circleOffsetNormal, self.circleOffsetNormal, self.circleOffsetNormal, self.circleOffsetNormal
end
function buildTipPanel:createUI()
	self.heroNode = display.newNode()
	self.heroNode:addTo(self)
	self.heroNode:setScale(0.75)
	self.heroNode:setPosition(0, 240)
	self.heroNode:setVisible(false)
	local heroBg = display.newSprite("#frame_LegendaryKing_head_base.png")
	heroBg:setName("heroBg")
	heroBg:addTo(self.heroNode, 0)
	self.heroBg = heroBg
	local heroIcon = display.newSprite("#frame_LegendaryKing_green_add.png")
	heroIcon:setName("heroIcon")
	heroIcon:addTo(self.heroNode, 1)
	self.heroIcon = heroIcon
	local heroIcon = display.newSprite("#frame_LegendaryKing_head_square.png")
	heroIcon:addTo(self.heroNode, 2)
	self.Btn_hero = ccui.Button:create("bg_transparent.png", "bg_transparent.png", "bg_transparent.png", ccui.TextureResType.plistType)
	self.Btn_hero:ignoreContentAdaptWithSize(false)
	self.Btn_hero:setContentSize(cc.size(120, 120))
	self.Btn_hero:addTo(self.heroNode, 3)
	self.Btn_hero:addTouchEventListener(handler(self, self.onBtnHeroAppoint))
	local circleFrameBg = display.newSprite("#frame_main_build_03.png")
	circleFrameBg:addTo(self)
	circleFrameBg:setPosition(cc.p(0, -194))
	self.circleFrameBg = circleFrameBg
	local imgNameBg = ccui.ImageView:create()
	imgNameBg:loadTexture("title_main_build.png", ccui.TextureResType.plistType)
	imgNameBg:setScale9Enabled(true)
	imgNameBg:setCapInsets(cc.rect(55, 14, 112, 28))
	imgNameBg:setContentSize(cc.size(222, 56))
	imgNameBg:addTo(self)
	imgNameBg:setPosition(cc.p(0, 165))
	self.BuildingNameFrame = imgNameBg
	local labelName = ccui.Text:create()
	labelName:setFontSize(22)
	labelName:setColor(cc.c3b(208, 181, 126))
	labelName:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	labelName:addTo(self.BuildingNameFrame)
	labelName:setAnchorPoint(cc.p(0.5, 0.5))
	labelName:setPosition(cc.p(111, 30))
	self.LabelBuildName = labelName
	local starSingle = SoraDCreatePanel("masteryStarSingle")
	starSingle:addTo(self.circleFrameBg)
	starSingle:setPosition(cc.p(self.circleFrameBg:getContentSize().width / 2, 130))
	starSingle:setVisible(false)
	self.starSingle = starSingle
	premiumStoreCtrl:sendOpenPage()
	SoraDShowLoading(self)
	local currentScene = display.getRunningScene()
	if currentScene.name == "MainScene" then
		local currentView = currentScene:currentSceneShowView()
		local scale = currentView:getZoomScale(true)
		_ENV = cc.p(self.circleFrameBg:getContentSize().width / 2, 130)
		cc.p(self.circleFrameBg:getContentSize().width / 2, 130).scale = scale
		self:updateNameScale(nil, cc.p(self.circleFrameBg:getContentSize().width / 2, 130))
	end
end
function buildTipPanel:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SHOW_BUILD_TIP_BUTTON_HAND", handler(self, self.showBtnHand))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIP_REFRESH", function(...)
		SoraDCloseLoading(self)
		self:checkExclusiveVip()
	end)
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_SCALE_CHANGE", handler(self, self.updateNameScale))
end
function buildTipPanel:updateNameScale(target, data)
	local scale = 1
	if data.scale and data.scale < MAINCITY_DEFAULT_SCALE then
		scale = 1 + 0.5 * (MAINCITY_DEFAULT_SCALE - data.scale) / (MAINCITY_DEFAULT_SCALE - 0.35)
	end
	self:setScale(scale)
end
function buildTipPanel:setRelyBuildBtnId(buildBtnId)
	self.relyBuildBtnId = buildBtnId
end
function buildTipPanel:setRelyBuildCfgId(buildCfgId)
	self.relyBuildCfgId = buildCfgId
end
function buildTipPanel:setRelyBuildIid(buildIid)
	self.relyBuildIid = buildIid
end
function buildTipPanel:setRelyBuildUId(buildUId)
	self.relyBuildUId = buildUId
end
function buildTipPanel:getBuildIndex()
	return self.relyBuildBtnId
end
function buildTipPanel:setRelyBuildEntity(buildEntity)
	self.relyBuildEntity = buildEntity
end
function buildTipPanel:initView(scale)
	self.initZoomScale = scale
	if self.circleFrameBg then
		self.circleFrameBg:setPosition(0, -self.circleRadius + 50 + self.circleOffsetY)
	end
	if self.BuildingNameFrame then
		self.BuildingNameFrame:setScaleX(0.1)
	end
	if self.heroNode then
		self.heroNode:setVisible(false)
	end
	self:recycleAllBtns()
	self:stopAllActionsByTag(tag_act_tip_show_end)
	self:stopAllActionsByTag(tag_act_init_view)
	tag_act_init_view = self
	self[1] = cca.delay(TIME_DELAY_INIT)
	self[2] = cca.callFunc(function()
		self:delayInitView()
	end)
	self[3] = cca.callFunc(function()
		self:delayInitView()
	end)
	local seq = cca.seq(self)
	seq:setTag(tag_act_init_view)
	self:runAction(seq)
end
function buildTipPanel:delayInitView()
	if nil == self.relyBuildBtnId or nil == self.relyBuildCfgId then
		return
	end
	local nationCtrl = SoraDGetCtrl("factionCtrl")
	local relyBuildData = nationCtrl:getCityBuildTipsInfo(self.relyBuildCfgId)
	if nil == relyBuildData then
		return
	end
	self.LabelBuildName:setString(i18n(relyBuildData.BuildingName))
	if self.LabelBuildName:getContentSize().width > 160 then
		self.BuildingNameFrame:setContentSize(cc.size(self.LabelBuildName:getContentSize().width + 30, 56))
		self.LabelBuildName:setPositionX(self.BuildingNameFrame:getContentSize().width / 2)
	end
	local buildEntity = self.relyBuildEntity
	if nil == buildEntity then
		if relyBuildData.CityBuildingState == EnumCityBuildingStates.eCBS_Normal then
			_ENV = self.BuildingNameFrame
			local OpList = self:fillBtnOpList(self.BuildingNameFrame, relyBuildData.NormalOperateList)
			local buttonList = self:GetButtonArrayByOpList(OpList)
			self:RearrangeBtnByCircle(buttonList)
		end
		return
	end
	local buildBid = buildEntity:getBuildBid()
	local iid = buildEntity:getIid()
	local baseData = nationCtrl:getCityBuildTipsInfo(buildBid)
	local buildType = SoraDGetBuildTypeByBid(buildBid)
	local buildState = tonumber(buildEntity:getBuildState())
	if buildState == BUILD_STATE.BUILDING then
		if buildEntity:getBuildQueue() == nil then
			buildState = BUILD_STATE.NORMAL
		end
	elseif buildState == BUILD_STATE.UPGRADEING then
		if buildEntity:getBuildQueue() == nil then
			buildState = BUILD_STATE.NORMAL
		end
	elseif buildState == BUILD_STATE.DEMOLISHING and buildEntity:getBuildQueue() == nil then
		buildState = BUILD_STATE.NORMAL
	end
	self.buildBid = tonumber(buildBid)
	local appointCfg = cityltCtrl.getBuildHeroAppointCfg(self.buildBid)
	local isLocked, unlocklevel = include("cityBuildBaseEntity"):getIsLocked(self.buildBid)
	local isSuitStarLv = SoraDGetBuildStarLv() >= constantRead.getConstValue("HERO_APPOINT_LIMIT_LV")
	local isShow = not (not (appointCfg and isSuitStarLv) or isLocked) and true or false
	self.heroNode:setVisible(isShow)
	if isShow then
		self:updateHeroNode(self.buildBid)
	end
	if buildBid == BUILDID.STAR_BRAVE_STATUE then
		self.BuildingNameFrame:setPositionY(230)
	else
		self.BuildingNameFrame:setPositionY(165)
	end
	local _ENV, OpList = self.BuildingNameFrame.setPositionY, self.BuildingNameFrame.setPositionY
	local operateType = "NormalOperateList"
	if buildState == BUILD_STATE.NORMAL then
		self.circleOffsetY = self.circleOffsetNormal
		if true == buildEntity:getIsTraining() then
			self.circleOffsetY = self.circleOffsetCooling
			operateType = "TrainingOperateList"
		else
			operateType = "NormalOperateList"
			if buildEntity and buildEntity:getBuildLv() >= CASTLE_MAXLV_NOWAR then
				OpList[BOP_NAME.BOP_UPGRADE] = false
				if cityltCtrl.isOpenWL(buildBid) and not buildLogic.buildLvIsFull(buildBid, iid) then
					OpList[BOP_NAME.BOP_WAR] = true
				end
				if not buildLogic.isBuildingUnlock(buildBid, iid) or buildLogic.buildLvIsFull(buildBid, iid) then
					OpList[BOP_NAME.BOP_WAR] = false
				end
			end
			if buildEntity and buildLogic.buildLvIsFull(buildBid, iid) then
				OpList[BOP_NAME.BOP_UPGRADE] = false
			end
		end
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local castleBcell = cityCtrl:getBuildCell(BUILDID.CASTLE, 0)
		if tonumber(buildBid) == 30001 then
			if tonumber(castleBcell.info.lv) >= CASTLE_MAXLV_NOWAR then
				OpList[BOP_NAME.BOP_BADGEBOURSE] = true
			end
			OpList[BOP_NAME.BOP_FRIEND] = true
			if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.EXOTIC_PAVILION_ACTIVITY) then
				OpList[BOP_NAME.BOP_FOREIGN_PAVILION] = true
			end
			local isSuitStarLv = SoraDGetBuildStarLv() >= constantRead.getConstValue("HERO_APPOINT_LIMIT_LV")
			if isSuitStarLv and GAME_HERO_APPOINT_MODE then
				OpList[BOP_NAME.BOP_HEROTASK] = true
			end
		end
		if tonumber(buildBid) == BUILDID.CASTLE then
			local privilegeGiftCtrl = gametop.playertop_:getModule("privilegeGiftCtrl")
			local ret = privilegeGiftCtrl:getCurCanBuyRechargeID()
			local starRet = privilegeGiftCtrl:getCurStarLvCanBuyRechargeID()
			if ret and next(ret) then
				OpList[BOP_NAME.BOP_CITY_GIFT] = true
			end
			if starRet and next(starRet) then
				OpList[BOP_NAME.BOP_CITY_GIFT] = true
			end
		end
		if tonumber(buildBid) == BUILDID.HERO_PRISON and IsArClient then
			OpList[BOP_NAME.BOP_MONUMENT] = true
		end
		if tonumber(buildBid) == BUILDID.NEWBORN_TREE then
			local beastCanyonCtrl = SoraDGetCtrl("beastCanyonCtrl")
			local activityID = gActivityTimeActivityID.DIVINE_BEAST_CANYON_ACTIVITY
			if not beastCanyonCtrl:checkActivityShow(activityID) then
				OpList[BOP_NAME.BOP_NEWBORN_BEAST_CANYON] = false
			end
			local activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001650
			if not beastCanyonCtrl:checkActivityShow(activityID) then
				OpList[BOP_NAME.BOP_NEWBORN_ELITEBEAST_CANYON] = false
				OpList[BOP_NAME.BOP_EXCHANGE_9001650] = false
			end
		end
		if tonumber(buildBid) == BUILDID.DEPOT then
			local allianceMgr = gametop.playertop_:getModule("allianceMgr")
			local isJoinAllliance = allianceMgr:hasJoinAlliance()
			local depotBcell = cityCtrl:getBuildCell(BUILDID.DEPOT, 0)
			if tonumber(depotBcell.info.lv) >= DEPOT_LV_ALLIANCE_TRRASURE and isJoinAllliance then
				OpList[BOP_NAME.BOP_ALLIANCE_TREASURE] = true
			end
		end
		if tonumber(buildBid) == cityBuildConstDef.fixedBuildDef.ResurrectionHall then
			local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
			if lordInfoCtrl:getBaseInfo().isSrcKingdomWarEnabled then
				OpList[BOP_NAME.BOP_RESUSCITATE] = true
			end
		end
		if tonumber(buildBid) == cityBuildConstDef.fixedBuildDef.HuoChuang then
			OpList[BOP_NAME.BOP_PREMIUM_VIP_MALL] = true
		end
		if tonumber(buildBid) == BUILDID.HALL_OF_WAR and SoraDIsMilitaryFOpen() then
			OpList[BOP_NAME.BOP_MILITARY_FORTRESS] = true
		end
		if buildType == 1 then
			_ENV = BOP_NAME.BOP_MILITARY_FORTRESS
			BOP_NAME.BOP_MILITARY_FORTRESS[BUILDID.FARM] = true
			BOP_NAME.BOP_MILITARY_FORTRESS[BUILDID.SAWMILL] = true
			BOP_NAME.BOP_MILITARY_FORTRESS[BUILDID.IRON_MINE] = true
			BOP_NAME.BOP_MILITARY_FORTRESS[BUILDID.STEEL] = true
			local BOP_NAME.BOP_MILITARY_FORTRESS[BUILDID.CRYSTAL_MINE], config = true, BOP_NAME.BOP_MILITARY_FORTRESS
			if config[buildBid] then
				local boostToolNum = buildEntity:getBoostToolNum(buildBid)
				if 0 < boostToolNum and false == buildEntity:getHasBuff() then
					OpList.OpBoostByTool = true
				end
			elseif buildBid == BUILDID.HOSTPITAL and true == buildEntity:getIsTraining() and true == self:getHasAnySpeedUpTool() then
				OpList.OpSpeedUpByTool = true
			end
		elseif buildType == 0 and true == buildEntity:getIsTraining() and true == self:getHasAnySpeedUpTool() then
			OpList.OpSpeedUpByTool = true
		end
	elseif buildState == BUILD_STATE.BUILDING then
		operateType = "CoolingOperateList"
		if true == self:getHasAnySpeedUpTool() then
			OpList.OpSpeedUpByTool = true
		end
		self.circleOffsetY = self.circleOffsetCooling
		local buttonList = self:GetButtonArrayByOpList(OpList)
		self:RearrangeBtnByCircle(buttonList)
		self.buttonList = buttonList
	elseif buildState == BUILD_STATE.UPGRADEING then
		operateType = "CoolingOperateList"
		if true == self:getHasAnySpeedUpTool() then
			OpList.OpSpeedUpByTool = true
		end
		if tonumber(buildBid) == BUILDID.CASTLE then
			local privilegeGiftCtrl = gametop.playertop_:getModule("privilegeGiftCtrl")
			local ret = privilegeGiftCtrl:getCurCanBuyRechargeID()
			if ret and next(ret) then
				OpList[BOP_NAME.BOP_CITY_GIFT] = true
			end
		end
		if tonumber(buildBid) == BUILDID.DEPOT then
			local allianceMgr = gametop.playertop_:getModule("allianceMgr")
			local isJoinAllliance = allianceMgr:hasJoinAlliance()
			local depotBcell = cityCtrl:getBuildCell(BUILDID.DEPOT, 0)
			if tonumber(depotBcell.info.lv) >= DEPOT_LV_ALLIANCE_TRRASURE and isJoinAllliance then
				OpList[BOP_NAME.BOP_ALLIANCE_TREASURE] = true
			end
		end
		if tonumber(buildBid) == BUILDID.HALL_OF_WAR and SoraDIsMilitaryFOpen() then
			OpList[BOP_NAME.BOP_MILITARY_FORTRESS] = true
		end
		self.circleOffsetY = self.circleOffsetCooling
	elseif buildState == BUILD_STATE.DEMOLISHING then
		operateType = "CoolingOperateList"
		if true == self:getHasAnySpeedUpTool() then
			OpList.OpSpeedUpByTool = true
		end
		self.circleOffsetY = self.circleOffsetCooling
	else
		return
	end
	if tonumber(buildBid) == BUILDID.WALLS then
		local privilegeGiftCtrl = gametop.playertop_:getModule("privilegeGiftCtrl")
		local ret = privilegeGiftCtrl:getCurWallGiftRechargeID()
		if ret and next(ret) then
			OpList[BOP_NAME.BOP_CITY_LEVEL_GIFT] = true
		end
	end
	if not IsArClient and self:checkBuildMastery(buildBid, buildState) then
		OpList[BOP_NAME.BOP_MASTERY] = true
	end
	if tonumber(buildBid) == BUILDID.CARGO_SHIP and self:checkExclusiveVip() then
		OpList[BOP_NAME.BOP_EXCLUSIVE_VIP] = true
	end
	if tonumber(buildBid) == BUILDID.BLACK_SMITH then
		OpList[BOP_NAME.BOP_ARTIFACT] = commonCheck.ARTIFACT
		OpList[BOP_NAME.BOP_HEROWEAPON] = serviceFunctions.systemTime() >= constantRead.getConstValue("HERO_WEAPON_OPEN_TIME")
	end
	if tonumber(buildBid) == BUILDID.MAGIC_LAMP then
		local breakQueue, classQueue, strengthQueue, hatchUpQueue = buildEntity:getCoolingQueue()
		if breakQueue ~= nil then
			OpList[BOP_NAME.BOP_MAGICLAMP_BREAK] = true
		end
		if classQueue ~= nil then
			OpList[BOP_NAME.BOP_MAGICLAMP_CLASS] = true
		end
		if strengthQueue ~= nil then
			OpList[BOP_NAME.BOP_MAGICLAMP_STRENGTH] = true
		end
		if hatchUpQueue ~= nil then
			OpList[BOP_NAME.BOP_MAGICLAMP_HATCH_UPGRADE] = true
		end
		local magicLampHatchCtrl = SoraDGetCtrl("magicLampHatchCtrl")
		local hatchData = magicLampHatchCtrl:getHatchData(gJinnType.JINN_ONE)
		if hatchData ~= nil then
			OpList[BOP_NAME.BOP_MAGICLAMP_HATCH] = true
		end
	end
	if tonumber(buildBid) == BUILDID.WATCH_TOWER then
		OpList[BOP_NAME.BOP_SHELTER] = SoraDGetCtrl("lordInfoCtrl"):isInSelfKid() and not worldMapDefine.isInWar()
	end
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	if commonCheck.BUILD_STAR and (buildBid == BUILDID.CASTLE or not guideCtrl:isGuideNotCompleted(gGuideModule.CITY_STAR_LV)) then
		local isFullLv = buildLogic.buildStarLvIsFull(buildBid, iid)
		local isUnlock = buildLogic.isBuildingStarUnlock(buildBid, iid)
		local isOpenStar = cityltCtrl.isOpenStar(buildBid)
		local isEnoughLv = buildEntity:getBuildLv() >= CASTLE_LV90_LIMITED
		if tonumber(buildBid) == BUILDID.STAR_BRAVE_STATUE then
			isEnoughLv = true
		end
		print("==isOpenStar,isUnlock,isEnoughLv,isFullLv==", isOpenStar, isUnlock, isEnoughLv, isFullLv)
		if isOpenStar and isUnlock and isEnoughLv and not isFullLv then
			local buildStarState = tonumber(buildEntity:getBuildStarState())
			if buildStarState == BUILD_STAR_STATE.NORMAL then
				if tonumber(buildBid) == BUILDID.STAR_BRAVE_STATUE then
					OpList[BOP_NAME.BOP_STATUEBRAVE] = true
				else
					OpList[BOP_NAME.BOP_STARUPGRADE] = true
				end
			elseif buildStarState == BUILD_STAR_STATE.UPGRADEING then
				OpList[BOP_NAME.BOP_STARSPEEDUP] = true
			end
		end
	end
	if tonumber(buildBid) == BUILDID.STAR_BRAVE_STATUE then
		if not SoraDIsBrave8Level() and not SoraDIsGildedArmorOpen() then
			OpList[BOP_NAME.BOP_WARFRAMEFORG] = false
			OpList[BOP_NAME.BOP_WARFRAMESTOREROOM] = false
		end
		if not IsArClient and serviceFunctions.systemTime() < constantRead.getConstValue("SOLDIERS_ARMOR_LIMIT_TIME_ROS") then
			OpList[BOP_NAME.BOP_WARFRAMEFORG] = false
			OpList[BOP_NAME.BOP_WARFRAMESTOREROOM] = false
		end
		if operateType == "TrainingOperateList" then
			OpList[BOP_NAME.BOP_STATUEBRAVE] = false
			if buildRead.getQueueType(buildBid) == gQueueTypeDef.craft_study then
				OpList[BOP_NAME.BOP_WARFRAMEFORG] = false
			else
				OpList[BOP_NAME.BOP_PROCESSSTUDY] = false
			end
		elseif tonumber(buildEntity:getBuildStarState()) == BUILD_STAR_STATE.UPGRADEING then
			OpList[BOP_NAME.BOP_WARFRAMEFORG] = false
			OpList[BOP_NAME.BOP_PROCESSSTUDY] = false
		end
	end
	OpList = self:fillBtnOpList(OpList, baseData[operateType])
	if buildState == BUILD_STATE.NORMAL then
		local bid = tonumber(buildBid)
		if worldMapDefine.isInWarForbidSoldier(true) then
			if bid == BUILDID.STABLES or bid == BUILDID.RANGE or bid == BUILDID.CHARIOT_PLANT or bid == BUILDID.BARRACKS or bid == BUILDID.FORTRESS or bid == BUILDID.ELITE_PALACE then
				OpList[BOP_NAME.BOP_SPEED_UP_BY_GOLD] = nil
				OpList[BOP_NAME.BOP_SPEED_UP_BY_TOOL] = nil
			elseif buildBid == BUILDID.MARKET then
				OpList[BOP_NAME.BOP_TRADE] = nil
			end
		elseif worldMapWarDef.isInWarForbidMarket() and buildBid == BUILDID.MARKET then
			OpList[BOP_NAME.BOP_TRADE] = nil
		end
		if worldMapDefine.isInRadiance() and buildBid == BUILDID.HOSTPITAL then
			OpList[BOP_NAME.BOP_SPEED_UP_BY_GOLD] = nil
		end
		if buildBid == BUILDID.EMBASSY and worldMapDefine.inInCrossWar() then
			OpList[BOP_NAME.BOP_INTETIOR] = nil
		end
	end
	if tonumber(buildBid) == BUILDID.MAGIC_LAMP then
		local magicLampSkillLotteryCtrl = SoraDGetCtrl("magicLampSkillLotteryCtrl")
		if not magicLampSkillLotteryCtrl:getIsUnlock() then
			OpList[BOP_NAME.BOP_MAGICLAMP_PRAY] = nil
			OpList[BOP_NAME.BOP_MAGICLAMP_SKILL] = nil
		end
		local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
		if OpList[BOP_NAME.BOP_MAGICLAMP_SKILL] then
			magicLampSkillCtrl:updateGuideSkill()
		end
		if OpList[BOP_NAME.BOP_MAGICLAMP] then
			magicLampSkillCtrl:updateGuideActive()
		end
	end
	if tonumber(buildBid) == BUILDID.NEBULA_PALACE and not commonCheck.METEOR_MAIGC then
		OpList[BOP_NAME.BOP_METEOR_MAGIC] = nil
	end
	local buttonList = self:GetButtonArrayByOpList(OpList)
	self:RearrangeBtnByCircle(buttonList)
	self.buttonList = buttonList
	dump(OpList, "fillBtnOpList", 10)
	dump(buildState, "buildState", 10)
	dump(buildBid, "buildBid", 10)
end
function buildTipPanel:fillBtnOpList(source, baseCfg)
	dump(source, "source", 10)
	dump(baseCfg, "baseCfg", 10)
	local nationCtrl = SoraDGetCtrl("factionCtrl")
	local _ENV, opList = "factionCtrl", "factionCtrl"
	for _, v in ipairs(baseCfg) do
		if v ~= 0 then
			local info = nationCtrl:getBuildTipButtonCfgById(v)
			opList[info.OpName] = v
		end
	end
	local BTBED = require_data("build_tips_btn_enum_data")
	for k, v in pairs(source) do
		if v then
			opList[k] = BTBED.data[k]
		else
			opList[k] = nil
		end
	end
	for k, v in pairs(opList) do
		local unlockLv = funUnlockRead.getLvByOpName(k)
		if unlockLv and unlockLv > SoraDGetCastleLv() then
			opList[k] = nil
		end
	end
	return opList
end
function buildTipPanel:RearrangeBtnByCircle(arrayButtons)
	self:buildTipShowBegin()
	local numberOfBtns = #arrayButtons
	local radius = self.circleRadius
	local sep = 6
	if 4 <= numberOfBtns then
		sep = 7
	end
	local deltaAngle = 180 / sep
	local deltaAngleRadius = math.rad(deltaAngle)
	local beginAngleRadius = -math.pi + (math.pi - deltaAngleRadius * (numberOfBtns - 1)) / 2
	for i, v in ipairs(arrayButtons) do
		local itemAngleRad = beginAngleRadius + (i - 1) * deltaAngleRadius
		local xPosBegin = math.cos(itemAngleRad) * radius / 2
		local yPosBegin = math.sin(itemAngleRad) * radius / 2 + self.circleOffsetY
		local xPosEnd = math.cos(itemAngleRad) * radius
		local yPosEnd = math.sin(itemAngleRad) * radius + self.circleOffsetY
		v:setPosition(xPosBegin, yPosBegin)
		v:setScale(0.5)
		v:setLocalZOrder(#arrayButtons - i + 1)
		local scaleAction = cca.scaleTo(ACTION_TIME, 1.0)
		local moveToActin = cca.moveTo(ACTION_TIME, xPosEnd, yPosEnd)
		tag_act_single_btn = xPosEnd
		xPosEnd[1] = moveToActin
		xPosEnd[2] = scaleAction
		local spawnAction = cca.spawn(xPosEnd)
		spawnAction:setTag(tag_act_single_btn)
		v:stopAllActionsByTag(tag_act_single_btn)
		v:runAction(spawnAction)
		v:setVisible(true)
	end
	if self.circleFrameBg then
		self.circleFrameBg:stopAllActions()
		self.circleFrameBg:setPosition(0, -self.circleRadius + 50 + self.circleOffsetY)
		self.circleFrameBg:runAction(cca.moveBy(ACTION_TIME, 0, -30))
	end
	if self.BuildingNameFrame then
		self.BuildingNameFrame:stopAllActions()
		self.BuildingNameFrame:setScaleX(0.1)
		self.BuildingNameFrame:runAction(cca.scaleTo(ACTION_TIME, 1))
	end
	self:stopAllActionsByTag(tag_act_tip_show_end)
	local delay = cca.delay(ACTION_TIME + 0.02)
	local callFunc = cca.callFunc(function()
		self:buildTipShowEnd()
	end)
	tag_act_single_btn = cca.scaleTo(ACTION_TIME, 1)
	cca.scaleTo(ACTION_TIME, 1)[1] = delay
	cca.scaleTo(ACTION_TIME, 1)[2] = callFunc
	local seqAct = cca.seq(cca.scaleTo(ACTION_TIME, 1))
	seqAct:setTag(tag_act_tip_show_end)
	self:runAction(seqAct)
	local mid = math.ceil(#arrayButtons / 2)
	if 1 < mid then
		for i = 1, #arrayButtons do
			arrayButtons[i]:setLocalZOrder(#arrayButtons - math.abs(i - mid))
		end
	end
end
function buildTipPanel:buildTipShowBegin()
	print("界面动画开始")
	local buildEntity = self:getBuildEntity()
	local bid = buildEntity and tonumber(buildEntity:getBuildBid()) or nil
	if bid then
		local guideCtrl = gametop.playertop_:getModule("guideCtrl")
		if guideCtrl:isGuideNotCompleted(gGuideModule.CITY_STAR_LV) and (SoraDGetBuildStarLv() > 0 or queueCtrl:queryQueue(gQueueTypeDef.build_star_queue)) then
			guideCtrl:testCompleteGuide(gGuideStep.CITY_STAR_LV_STEP_1)
		end
		if bid == BUILDID.BLACK_SMITH then
			if guideCtrl:updateGuideModule(gGuideModule.SMITHY) then
				gModuleMgr.sharedMgr("mildGuideManager"):clean()
				return
			end
		elseif bid == cityBuildConstDef.buildIndexDef.index_PetCenter then
			if guideCtrl:updateGuideModule(gGuideModule.PET_UNLOCK) then
				gModuleMgr.sharedMgr("mildGuideManager"):clean()
				return
			end
		elseif bid == 301 then
			if guideCtrl:updateGuideModule(gGuideModule.MIRACLE_BUILDING) then
				gModuleMgr.sharedMgr("mildGuideManager"):clean()
				return
			end
		elseif bid == BUILDID.CASTLE then
			if guideCtrl:isGuideNotCompleted(gGuideModule.CITY_STAR_LV) then
				if buildEntity and (0 < buildEntity:getBuildStarLv() or buildEntity:getBuildStarQueue()) then
					guideCtrl:testCompleteGuide(gGuideStep.CITY_STAR_LV_STEP_1)
				elseif SoraDCheckIsOpenBuildStar() then
					guideCtrl:updateGuideModule(gGuideModule.CITY_STAR_LV)
				end
			end
		elseif bid == BUILDID.ELITE_PALACE then
			local guideCtrl = SoraDGetCtrl("guideCtrl")
			if guideCtrl:isGuideNotCompleted(gGuideModule.ELITE_PALACE) then
				guideCtrl:updateGuideModule(gGuideModule.ELITE_PALACE)
			end
		elseif bid == BUILDID.CHARIOT_PLANT then
			if guideCtrl:isStep(gGuideStep.TRAIN_ARMY_STEP_2) then
				guideCtrl:CompleteGuideStep(nil, gGuideStep.TRAIN_ARMY_STEP_2)
			else
				print("训练============", buildEntity:getState())
				if buildEntity:getState() == "idle" then
					guideCtrl:updateGuideModule(gGuideModule.TRAIN_ARMY)
				end
			end
		elseif bid == BUILDID.STABLES or bid == BUILDID.RANGE or bid == BUILDID.BARRACKS then
			if guideCtrl:isStep(gGuideStep.TRAIN_ARMY_STEP_2) then
				guideCtrl:CompleteGuideStep(nil, gGuideStep.TRAIN_ARMY_STEP_2)
			else
				print("状态======", mainCityFunctions.isBuildIdleByBid(BUILDID.CHARIOT_PLANT))
				if mainCityFunctions.isBuildIdleByBid(BUILDID.CHARIOT_PLANT) then
					guideCtrl:updateGuideModule(gGuideModule.TRAIN_ARMY, false, 2)
				end
			end
		end
	end
end
function buildTipPanel:buildTipShowEnd()
	print("界面动画结束")
	local guideStep = SoraDIsGameGuide()
	if guideStep then
		if guideStep == 2020 then
			_ENV = nil
			;(nil).msg = "MESSAGE_SERVER_GUIDE_STEP_ON"
			;(nil).step = 2021
			SoraDSendMessage(nil)
		end
	else
		local buildEntity = self:getBuildEntity()
		local needbid = gModuleMgr.sharedMgr("mildGuideManager"):getVariate("buildTipPanel", "bid")
		local queuePriority = gModuleMgr.sharedMgr("mildGuideManager"):getVariate("buildTipPanel", "queuePriority")
		local isMild = gModuleMgr.sharedMgr("mildGuideManager"):getVariate("buildTipPanel", "isMild")
		if needbid and buildEntity then
			gametop = "buildTipPanel"
			;("buildTipPanel")[1] = needbid
			;("buildTipPanel")[2] = tonumber(buildEntity:getBuildBid())
			;("buildTipPanel")[3] = tonumber(buildEntity:getBuildBid())
			;("buildTipPanel")[4] = tonumber(buildEntity:getBuildBid())
			;("buildTipPanel")[5] = tonumber(buildEntity:getBuildBid())
			dump("buildTipPanel", "needbid == tonumber(buildEntity:getBuildBid())")
			if needbid == tonumber(buildEntity:getBuildBid()) then
				local isQueuePriority = false
				if queuePriority then
					if type(queuePriority) == "table" and next(queuePriority) ~= nil then
						isQueuePriority = true
					elseif type(queuePriority) == "boolean" then
						isQueuePriority = queuePriority
					end
				end
				dump(buildEntity:getQueueType(), isQueuePriority, "buildEntity:getQueueType() and isQueuePriority")
				if buildEntity:getQueueType() and isQueuePriority then
					local btnSingle = self:getBtnByOpName("OpSpeedUpByTool")
					if btnSingle == nil then
						btnSingle = self:getBtnByOpName("OpSpeedUpByGold")
					end
					gModuleMgr.sharedMgr("mildGuideManager"):clean()
					if btnSingle then
						_ENV = buildEntity:getBuildBid()
						buildEntity:getBuildBid().isMild = isMild
						gModuleMgr.sharedMgr("mildGuideManager"):drawFingerToTarget(btnSingle, buildEntity:getBuildBid())
					end
					if not SoraDIsGameGuide() then
						local newPlayerTaskCtrl = gametop.playertop_:getModule("newPlayerTaskCtrl")
						if tonumber(buildEntity:getBuildBid()) == BUILDID.COLLEGE and not newPlayerTaskCtrl:isTaskFinish(4103104) then
							_ENV = 4103104
							;(4103104).byUID = true
							if SoraDConfigGet("Game:Guide:collegeSpeed~bool", 4103104) then
								_ENV = "Game:Guide:collegeSpeed~bool"
								;("Game:Guide:collegeSpeed~bool").msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
								;("Game:Guide:collegeSpeed~bool").step = 60001
								SoraDSendMessage("Game:Guide:collegeSpeed~bool")
								_ENV = buildEntity:getBuildBid()
								buildEntity:getBuildBid().byUID = true
								SoraDConfigSet("Game:Guide:collegeSpeed~bool", false, buildEntity:getBuildBid())
						end
						elseif tonumber(buildEntity:getBuildBid()) == BUILDID.STABLES and not newPlayerTaskCtrl:isTaskFinish(4103105) then
							_ENV = 4103105
							;(4103105).byUID = true
							if SoraDConfigGet("Game:Guide:stablesSpeed~bool", 4103105) then
								_ENV = "Game:Guide:stablesSpeed~bool"
								;("Game:Guide:stablesSpeed~bool").msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
								;("Game:Guide:stablesSpeed~bool").step = 60002
								SoraDSendMessage("Game:Guide:stablesSpeed~bool")
								_ENV = buildEntity:getBuildBid()
								buildEntity:getBuildBid().byUID = true
								SoraDConfigSet("Game:Guide:stablesSpeed~bool", false, buildEntity:getBuildBid())
							end
						end
					end
				else
					gModuleMgr.sharedMgr("mildGuideManager"):updatePanelShow("mainCityView")
				end
			else
				gModuleMgr.sharedMgr("mildGuideManager"):clean()
			end
		end
	end
end
function buildTipPanel:buttonInfoCall(ref, type)
	if type == ccui.TouchEventType.ended then
		print("buttonInfoCall Click!")
		_ENV = print
		print.bid = self.relyBuildCfgId
		print.iid = self.relyBuildIid
		print.btype = SoraDGetBuildTypeByBid(self.relyBuildCfgId)
		print.bstate = self:getBuildState()
		local print.buildEntity, buildInfoData = self.relyBuildEntity, print
		_ENV = nil
		;(nil).buildInfoData = buildInfoData
		uiManager:show("BuildInfo", nil)
		if self.relyBuildCfgId ~= BUILDID.STAR_BRAVE_STATUE then
			_ENV = BUILDID.STAR_BRAVE_STATUE
			BUILDID.STAR_BRAVE_STATUE.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
			BUILDID.STAR_BRAVE_STATUE.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD
			SoraDSendMessage(BUILDID.STAR_BRAVE_STATUE)
		end
		_ENV = BUILDID.STAR_BRAVE_STATUE
		BUILDID.STAR_BRAVE_STATUE.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(BUILDID.STAR_BRAVE_STATUE)
	end
end
function buildTipPanel:buttonUpgradeCall(ref, type)
	if type == ccui.TouchEventType.ended then
		printf(" upgrade :" .. self.relyBuildCfgId .. " : " .. self.relyBuildIid .. " : " .. self.relyBuildBtnId)
		_ENV, _ENV = self.relyBuildIid, " : "
		self.relyBuildIid.bid = self.relyBuildCfgId
		self.relyBuildIid.iid = self.relyBuildIid
		self.relyBuildIid.index = self.relyBuildBtnId
		;(" : ").upgradeData, self.relyBuildIid.buildEntity = self.relyBuildIid, self:getBuildEntity()
		uiManager:show("BuildCreateInfo", " : ")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
		uiManager.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD
		SoraDSendMessage(uiManager)
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonStarUpgradeCall(ref, type)
	if type == ccui.TouchEventType.ended then
		_ENV, _ENV = nil, nil
		;(nil).bid = self.relyBuildCfgId
		;(nil).iid = self.relyBuildIid
		;(nil).index = self.relyBuildBtnId
		;(nil).upgradeStarData, (nil).buildEntity = nil, self:getBuildEntity()
		uiManager:show("BuildStarUpgrade", nil)
		local posX, posY = buildLogic.getBuildStarJumpOffset(self.relyBuildBtnId)
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
		;(nil).offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD
		;(nil).xOffset = posX
		;(nil).yOffset = posY
		SoraDSendMessage(nil)
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(nil)
	end
end
function buildTipPanel:buttonTrainCall(ref, type)
	if type == ccui.TouchEventType.ended then
		_ENV = nil
		;(nil).bid = self.relyBuildCfgId
		uiManager:show("soldiersCampView", nil)
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonTradeCall(ref, type)
	if type == ccui.TouchEventType.ended then
		local gametop = gModuleMgr.getObject("gametop")
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		if allianceMgr:hasJoinAlliance() then
			if GLOBAL_GAME_ALLIANCE_MODE then
				uiManager:show("allianceMemberList")
			else
				local panel = SoraDCreatePanel("allianceMemberList")
				panel:initData()
				panel:show()
			end
		else
			uiManager:show("marketNoAlliance")
		end
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonAuctionCall(ref, type)
	if type == ccui.TouchEventType.ended then
		if not include("pyramidWarltCtrl").checkPwXianXiaSai() then
			return
		end
		if SoraDGetCtrl("salesRoomAgCtrl"):checkOpenCond() then
			local guideCtrl = SoraDGetCtrl("guideCtrl")
			if guideCtrl:isGuideNotCompleted(gGuideModule.AUCTION_INSIDE) then
				uiManager:show("tradeBoardView")
			elseif SoraDGetCtrl("activityShowCtrl"):isActivityOpen(gActivityTimeActivityID.NEW_SALESROOM_ACTIVITY) then
				_ENV = nil
				;(nil).tag = 2
				uiManager:show("tradeBoardView", nil)
			elseif SoraDGetCtrl("activityShowCtrl"):isActivityOpen(gActivityTimeActivityID.SALESROOM_ACTIVITY) then
				uiManager:show("tradeBoardView")
			else
				_ENV = nil
				;(nil).tag = 2
				uiManager:show("tradeBoardView", nil)
			end
		end
		_ENV = uiManager.show
		uiManager.show.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager.show)
	end
end
function buildTipPanel:buttonResearchCall(ref, type)
	if type == ccui.TouchEventType.ended then
		uiManager:show("collegeView")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonBuildTrapCall(ref, type)
	if type == ccui.TouchEventType.ended then
		_ENV = nil
		;(nil).bid = self.relyBuildCfgId
		uiManager:show("soldiersCampView", nil)
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonHelpAllCall(ref, type)
	if type == ccui.TouchEventType.ended then
		print("buttonHelpAllCall Click!")
		_ENV = "buttonHelpAllCall Click!"
		;("buttonHelpAllCall Click!").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage("buttonHelpAllCall Click!")
	end
end
function buildTipPanel:buttonHelpCall(ref, type)
	if type == ccui.TouchEventType.ended then
		uiManager:show("EmbassyView")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonReinforcementsCall(ref, type)
	if type == ccui.TouchEventType.ended then
		print("buttonReinforcementsCall Click!")
		uiManager:show("ReinforcementsView")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonWishCall(ref, type)
	if type == ccui.TouchEventType.ended then
		print("buttonWishCall Click!")
		uiManager:show("TreasureHuntView")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonETreasureCall(ref, type)
	if type == ccui.TouchEventType.ended then
		print("buttonETreasureCall Click!")
		local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.ENDLESS_TREASURE)
		if unlockLv > SoraDGetCastleLv() then
			_ENV = nil
			;(nil).name = i18n("endless_treasures_text_01")
			;(nil).lv = unlockLv
			SoraDShowMsgTip(i18n("common_text_2122", nil))
		else
			uiManager:show("EndlessTreasureView")
			_ENV = uiManager
			uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
			SoraDSendMessage(uiManager)
		end
	end
end
function buildTipPanel:buttonAllianceBattleCall(ref, type)
	if type == ccui.TouchEventType.ended then
		print("buttonAllianceBattleCall click ")
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		if not allianceMgr:hasJoinAlliance(true) then
			SoraDShowMsgTip(i18n("common_text_3692"))
		else
			uiManager:show("AllianceWarView")
		end
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonDefendCall(ref, type)
	if type == ccui.TouchEventType.ended then
		print("buttonDefendCall Click!")
		uiManager:show("defendView")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonMilitaryInfoCall(ref, type)
	if type == ccui.TouchEventType.ended then
		uiManager:show("WatchTowerView")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonCityInfoCall(ref, type)
	if type == ccui.TouchEventType.ended then
		uiManager:show("cityInfoView")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonCityBuffCall(ref, type)
	if type == ccui.TouchEventType.ended then
		uiManager:show("citybuffView")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonHealCall(ref, type)
	if type == ccui.TouchEventType.ended then
		local lv = 0
		local buildEntity = self.relyBuildEntity
		if nil ~= buildEntity then
			lv = buildEntity:getBuildLv()
		end
		uiManager:show("HospitalView"):setLV(lv)
		_ENV = uiManager:show("HospitalView")
		uiManager:show("HospitalView").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage((uiManager:show("HospitalView")))
	end
end
function buildTipPanel:buttonCollectCall(ref, type)
	if type == ccui.TouchEventType.ended then
		print("buttonCollectCall Click!")
		local buildEntity = self:getBuildEntity()
		if buildEntity then
			buildEntity:doHarvesting()
		end
		_ENV = buildEntity
		buildEntity.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(buildEntity)
	end
end
function buildTipPanel:buttonSpeedUpByGoldCall(ref, type)
	if type == ccui.TouchEventType.ended then
		print("buttonSpeedUpByGoldCall Click!")
	end
end
function buildTipPanel:buttonSpeedUpByToolCall(ref, type)
	if type == ccui.TouchEventType.ended then
		print("buttonSpeedUpByToolCall Click!")
		_ENV = "buttonSpeedUpByToolCall Click!"
		;("buttonSpeedUpByToolCall Click!").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage("buttonSpeedUpByToolCall Click!")
	end
end
function buildTipPanel:buttonForgingCall(ref, type)
	if type == ccui.TouchEventType.ended then
		print("buttonForgingCall Click!")
		uiManager:show("smithyView")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonStorageBoxCall(ref, type)
	if type == ccui.TouchEventType.ended then
		print("buttonStorageBoxCall Click!")
		uiManager:show("storageBoxView")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonBoostCall(ref, type)
	if type == ccui.TouchEventType.ended then
		print("buttonBoostCall Click!")
		_ENV = "buttonBoostCall Click!"
		;("buttonBoostCall Click!").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage("buttonBoostCall Click!")
	end
end
function buildTipPanel:buttonBoostByToolCall(ref, type)
	if type == ccui.TouchEventType.ended then
		print("buttonBoostByToolCall Click!")
		_ENV = "buttonBoostByToolCall Click!"
		;("buttonBoostByToolCall Click!").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage("buttonBoostByToolCall Click!")
	end
end
function buildTipPanel:buttonPyramidCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local castleBcell = cityCtrl:getBuildCell(BUILDID.CASTLE, 0)
		if not castleBcell then
			_ENV = BUILDID.CASTLE
			BUILDID.CASTLE.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
			SoraDSendMessage(BUILDID.CASTLE)
			return
		end
		local castleLV = castleBcell.info.lv
		if tonumber(castleLV) < CASTLE_LV8_LIMITED then
			local spriteName = "#btn_pyramid.png"
			_ENV = nil
			;(nil).blv = CASTLE_LV8_LIMITED
			SoraDShowMsgTip(i18n("common_text_1151", nil), spriteName)
		else
			uiManager:show("pyramidMain")
		end
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonAllianceTreasureCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if not worldMapDefine.isInWarForbid(false, true) then
			local gametop = gModuleMgr.getObject("gametop")
			local allianceMgr = gametop.playertop_:getModule("allianceMgr")
			local isJoinAllliance = allianceMgr:hasJoinAlliance()
			local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
			local isInConquestWar = conquestWarCtrl:isPlayerConquestWarMigration()
			if isInConquestWar then
				SoraDShowMsgTip(i18n("common_text_2166"))
			elseif isJoinAllliance then
				if GLOBAL_GAME_ALLIANCE_MODE then
					uiManager:show("allianceStoreHouseView")
				else
					SoraDCreatePanel("allianceStoreHouseView"):show()
				end
				_ENV = "allianceStoreHouseView"
				;("allianceStoreHouseView").position = 1
				userSDKManager.logEvent(gSDKDef.TDonEvent.click_alliance_treasure, "allianceStoreHouseView")
			else
				uiManager:show("AllianceJoinView")
			end
		end
		_ENV = gametop.playertop_:getModule("allianceMgr")
		gametop.playertop_:getModule("allianceMgr").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage((gametop.playertop_:getModule("allianceMgr")))
	end
end
function buildTipPanel:buttonArenaCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if not include("pyramidWarltCtrl").checkPwXianXiaSai() then
			return
		end
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		local isOpen = activityShowCtrl:isActivityOpen(gActivityTimeActivityID.ARENA_ACTIVITY)
		if lordInfoCtrl:getSourceKid() > 0 then
			SoraDShowMsgTip(i18n("common_text_3041"))
		elseif worldMapDefine.isInWarForbid(false, true) then
		elseif not isOpen then
			SoraDShowMsgTip(i18n("common_text_699"))
		else
			local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.ARENA)
			if unlockLv <= SoraDGetCastleLv() then
				local kingdomCtrl = gametop.playertop_:getModule("kingdomCtrl")
				if kingdomCtrl:getCanMoveOut(gametop.playertop_:getKingdomID()) then
					SoraDShowMsgTip(i18n("migrate_notice_05"))
				else
					uiManager:show("ArenaReadyView")
				end
			else
				_ENV = "ArenaReadyView"
				;("ArenaReadyView").name = i18n("buildDes_name_121")
				;("ArenaReadyView").lv = unlockLv
				SoraDShowMsgTip(i18n("common_text_2122", "ArenaReadyView"))
			end
		end
		_ENV = SoraDShowMsgTip
		SoraDShowMsgTip.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(SoraDShowMsgTip)
	end
end
function buildTipPanel:buttonDiscussCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if userSDKManager.sdkMessageCount then
			userSDKManager.sdkMessageCount.bbsCount = 0
			userSDKManager_sdkMessageCallBack()
		end
		local activityCenterUICtrl = SoraDGetCtrl("activityCenterUICtrl")
		activityCenterUICtrl:sendClearNewMsg(gActivityCenterUIEnum.MAIN_CITY_BILLBOARD)
		userSDKManager.showSocial()
		_ENV = activityCenterUICtrl
		activityCenterUICtrl.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(activityCenterUICtrl)
	end
end
function buildTipPanel:buttonSupportCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if userSDKManager.sdkMessageCount then
			userSDKManager.sdkMessageCount.serviceCount = 0
			userSDKManager_sdkMessageCallBack()
		end
		userSDKManager.showFAQs()
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(nil)
	end
end
function buildTipPanel:buttonInfoCenterCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if userSDKManager.sdkMessageCount then
			userSDKManager.sdkMessageCount.serviceCount = 0
			userSDKManager_sdkMessageCallBack()
		end
		if userSDKManager.isEN() then
			userSDKManager.openSDKLink("https://ros.onemt.com/index/home")
		else
			userSDKManager.openNoticeBorad()
		end
		_ENV = "https://ros.onemt.com/index/home"
		;("https://ros.onemt.com/index/home").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage("https://ros.onemt.com/index/home")
	end
end
function buildTipPanel:buttonNaviNoticeCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if userSDKManager.showNaviNotice then
			userSDKManager.showNaviNotice()
		else
			SoraDShowMsgTip(i18n("magic_lamp_text_160"))
		end
		_ENV = i18n("magic_lamp_text_160")
		i18n("magic_lamp_text_160").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(i18n("magic_lamp_text_160"))
	end
end
function buildTipPanel:buttonMonumentCall(target, eventType)
	if SoraDGetCastleLv() < CASTLE_LV19_LIMITED then
		_ENV = nil
		;(nil).lv = CASTLE_LV19_LIMITED
		SoraDShowMsgTip(i18n("common_text_3868", nil), "#btn_main_monument.png")
	else
		uiManager:show("HeroMonument")
	end
	_ENV = uiManager
	uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
	SoraDSendMessage(uiManager)
end
function buildTipPanel:buttonTrainHallCall(target, eventType)
	local worldMapWarDef = include("worldMapWarDef")
	worldMapWarDef.openHeroTrainListView()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
	SoraDSendMessage(nil)
end
function buildTipPanel:buttonMonumentLegendCall(target, eventType)
	uiManager:show("LegendMain")
	_ENV = uiManager
	uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
	SoraDSendMessage(uiManager)
end
function buildTipPanel:buttonIntetiorCall(target, eventType)
	local intetiorUtil = include("intetiorUtil")
	intetiorUtil:openView()
	_ENV = intetiorUtil
	intetiorUtil.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
	SoraDSendMessage(intetiorUtil)
end
function buildTipPanel:buttonVipCall(target, eventType)
	if not include("pyramidWarltCtrl").checkPwXianXiaSai() then
		return
	end
	uiManager:show("exclusiveVipView")
	_ENV = uiManager
	uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
	SoraDSendMessage(uiManager)
end
function buildTipPanel:buttonPrisonCall(target, eventType)
	uiManager:show("HeroJailList")
	_ENV = uiManager
	uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
	SoraDSendMessage(uiManager)
end
function buildTipPanel:buttonMasteryCall(target, eventType)
	local bid = self.relyBuildCfgId
	local iid = self.relyBuildIid
	local mid = specializationRead.getMasteryID(bid)
	local state = specializationRead.getMasteryState(bid, mid)
	if state == specializationRead.MASTERY_STATE.canLock then
		local penal = SoraDCreatePanel("masteryMainView")
		penal:show()
		penal:doDelayAction(mid)
		specializationRead = penal
		penal.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(penal)
		return
	end
	specializationRead = SoraDSendMessage
	SoraDSendMessage.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
	SoraDSendMessage(SoraDSendMessage)
	mainCityFunctions.masteryJumpToDetailView(bid, iid, false)
end
function buildTipPanel:buttonMainMasteryCall(...)
	SoraDCreatePanel("masteryMainView"):show()
end
function buildTipPanel:buttonDrawingCall(...)
	SoraDCreatePanel("masteryDrawView"):show()
	_ENV = SoraDCreatePanel("masteryDrawView")
	SoraDCreatePanel("masteryDrawView").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
	SoraDSendMessage((SoraDCreatePanel("masteryDrawView")))
end
function buildTipPanel:buttonFriendCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		uiManager:show("friendView")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonBadgeBourseCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local badgeExchangeCtrl = gametop.playertop_:getModule("badgeExchangeCtrl")
		local castleBcell = cityCtrl:getBuildCell(BUILDID.CASTLE, 0)
		if not castleBcell then
			_ENV = BUILDID.CASTLE
			BUILDID.CASTLE.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
			SoraDSendMessage(BUILDID.CASTLE)
			return
		end
		local isOpen, lv = badgeExchangeCtrl:isOpenBadge()
		if not isOpen then
			local spriteName = "#301101.png"
			_ENV = nil
			;(nil).blv = lv
			SoraDShowMsgTip(i18n("common_text_1151", nil), spriteName)
		else
			uiManager:show("badgeBourseView")
		end
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonCityDecorateCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		uiManager:show("castleChangeView")
		local xOffset = display.size.width * 0.5
		xOffset = xOffset + 60
		local scale = 0.45
		print("xOffset = ", xOffset)
		print("display.size.height = ", display.size.height, ", yOffset = ", display.size.height - 375)
		_ENV = "display.size.height = "
		;("display.size.height = ").msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
		;("display.size.height = ").offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD
		;("display.size.height = ").scale = scale
		;("display.size.height = ").buildIndex = cityBuildConstDef.buildIndexDef.index_Castle
		;("display.size.height = ").xOffset = xOffset
		;("display.size.height = ").yOffset = display.rheight - 375
		SoraDSendMessage("display.size.height = ")
		_ENV = "display.size.height = "
		;("display.size.height = ").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage("display.size.height = ")
	end
end
function buildTipPanel:buttonCityGiftCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if not include("pyramidWarltCtrl").checkPwXianXiaSai() then
			return
		end
		local gametop = gModuleMgr.getObject("gametop")
		local privilegeGiftCtrl = gametop.playertop_:getModule("privilegeGiftCtrl")
		local gift = privilegeGiftCtrl:getCurCanBuyRechargeID()
		local starGift = privilegeGiftCtrl:getCurStarLvCanBuyRechargeID()
		if not next(starGift) then
			_ENV = nil
			;(nil).privilegeType = gRechargePrivilegeType.castle
			;(nil).title = i18n("common_text_4030")
			;(nil).fromCenter = gRechargeActiveFromEnum.ROAD15
			uiManager:show("MagicLampPrivilegeView", nil)
		else
			_ENV = nil
			;(nil).privilegeType = gRechargePrivilegeType.star
			;(nil).title = i18n("common_text_4030")
			;(nil).fromCenter = gRechargeActiveFromEnum.ROAD15
			uiManager:show("MagicLampPrivilegeView", nil)
		end
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_CASTLE_GIFT_TOP_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonWallGiftCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		_ENV = nil
		;(nil).privilegeType = gRechargePrivilegeType.wall
		;(nil).title = i18n("common_text_4498_ROS")
		;(nil).fromCenter = gRechargeActiveFromEnum.ROAD15
		uiManager:show("MagicLampPrivilegeView", nil)
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonWarCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		print("打开战争等级界面")
		printf(" upgrade :" .. self.relyBuildCfgId .. " : " .. self.relyBuildIid .. " : " .. self.relyBuildBtnId)
		_ENV, _ENV = self.relyBuildIid, " : "
		self.relyBuildIid.bid = self.relyBuildCfgId
		self.relyBuildIid.iid = self.relyBuildIid
		self.relyBuildIid.index = self.relyBuildBtnId
		;(" : ").upgradeData, self.relyBuildIid.buildEntity = self.relyBuildIid, self:getBuildEntity()
		uiManager:show("BuildCreateInfo", " : ")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
		uiManager.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD
		SoraDSendMessage(uiManager)
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonFaceBookTreasureCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local castleBcell = cityCtrl:getBuildCell(BUILDID.CASTLE, 0)
		if not castleBcell then
			_ENV = BUILDID.CASTLE
			BUILDID.CASTLE.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
			SoraDSendMessage(BUILDID.CASTLE)
			return
		end
		local castleLV = castleBcell.info.lv
		if tonumber(castleLV) < CASTLE_LV6_LIMITED then
			local spriteName = "#fbchest_01.png"
			_ENV = nil
			;(nil).blv = CASTLE_LV6_LIMITED
			SoraDShowMsgTip(i18n("common_text_1151", nil), spriteName)
		else
			SoraDCreatePanel("faceTreasureView"):show()
		end
		_ENV = SoraDCreatePanel("faceTreasureView")
		SoraDCreatePanel("faceTreasureView").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage((SoraDCreatePanel("faceTreasureView")))
	end
end
function buildTipPanel:buttonMilitaryPointCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		_ENV = nil
		;(nil).isTool = true
		uiManager:show("militaryRankSkillView", nil)
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonCounterSysCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if worldMapDefine.inInCrossWar() then
			SoraDShowMsgTip(i18n("common_text_3302"))
		else
			local panel = uiManager:show("AllianceCounterSysView")
			panel:tabChange(2)
		end
		_ENV = panel.tabChange
		panel.tabChange.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(panel.tabChange)
	end
end
function buildTipPanel:buttonDailySignCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		uiManager:show("LuckyCard")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonMonthGiftCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if GLOBAL_GAME_RECHARGE_MODE then
			_ENV = nil
			;(nil).toCategory = gRechargeCenterCategory.MONTH
			;(nil).toNodeTag = 0
			uiManager:show("rechargeView", nil)
		else
			local panel = SoraDCreatePanel("rechargeView")
			panel:expect2SelectTab(gRechargeCenterCategory.MONTH)
			panel:show()
		end
		_ENV = panel.show
		panel.show.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(panel.show)
	end
end
function buildTipPanel:buttonResuscitateCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if self.relyBuildCfgId == BUILDID.HOSTPITAL then
			local cityBuildConstDef = include("cityBuildConstDef")
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_GO_TO_BUILD"
			;(nil).buildID = cityBuildConstDef.fixedBuildDef.ResurrectionHall
			;(nil).delay = 0.5
			;(nil).isSelected = true
			;(nil).isShowHand = true
			SoraDSendMessage(nil)
		else
			if not worldMapDefine.isInWarForbid(false, false) then
				uiManager:show("ResurgenceTreeView")
			end
			_ENV = uiManager
			uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
			SoraDSendMessage(uiManager)
		end
	end
end
function buildTipPanel:buttonDailyRewardCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		_ENV = nil
		;(nil).tab = 2
		uiManager:show("questView", nil)
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonUnDefinedCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		print("Undefined Call buildTipPanel:buttonUnDefinedCall")
		_ENV = "Undefined Call buildTipPanel:buttonUnDefinedCall"
		;("Undefined Call buildTipPanel:buttonUnDefinedCall").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage("Undefined Call buildTipPanel:buttonUnDefinedCall")
	end
end
function buildTipPanel:buttonPetCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		uiManager:show("PetFguiView")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonPetMapCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDCreatePanel("petMapView"):show()
		_ENV = SoraDCreatePanel("petMapView")
		SoraDCreatePanel("petMapView").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage((SoraDCreatePanel("petMapView")))
	end
end
function buildTipPanel:buttonStringOfLifeCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if not worldMapDefine.isInWarForbid(false, false) then
			uiManager:show("LifeSpringsView")
		end
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonPremiumVipMallCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		uiManager:show("rechargeVipFrame")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
		_ENV = "rechargeVipFrame"
		;("rechargeVipFrame").byUID = true
		local clickTime = SoraDConfigGet("Game:MainCityView:clickPremiumVipMallBtn~integer", "rechargeVipFrame")
		if clickTime == 0 or not serviceFunctions.isSameDay(clickTime) then
			_ENV = nil
			;(nil).byUID = true
			SoraDConfigSet("Game:MainCityView:clickPremiumVipMallBtn~integer", serviceFunctions.systemTime(), nil)
		end
	end
end
function buildTipPanel:buttonWarGemCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		uiManager:show("WarGemMain")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonWarTechnologyCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		uiManager:show("warTechView")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonGodEquipmentCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if SoraDGetCastleLv() < CASTLE_LV40_LIMITED then
			_ENV = nil
			;(nil).level = 1
			SoraDShowMsgTip(i18n("common_text_4094", nil))
			return
		end
		local panel = SoraDCreatePanel("godEquipmentView")
		panel:show()
		_ENV = panel
		panel.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(panel)
	end
end
function buildTipPanel:buttonArtifactCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.ARTIFACT)
		if unlockLv > SoraDGetCastleLv() then
			_ENV = nil
			;(nil).level = unlockLv
			SoraDShowMsgTip(i18n("common_text_2417", nil))
			return
		end
		uiManager:show("ArtifactView")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonHeroWeaponCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		uiManager:show("HeroWeaponMain")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonPetExchangeCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		_ENV = nil
		;(nil).selTabIndex = target.selTabIndex
		uiManager:show("PetExchangeView", nil)
		target.selTabIndex = nil
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
		_ENV = "PetExchangeView"
		;("PetExchangeView").byUID = true
		local clickTime = SoraDConfigGet("Game:MainCityView:clickPetExchangeBtn~integer", "PetExchangeView")
		if clickTime == 0 or not serviceFunctions.isSameDay(clickTime) then
			local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
			local ret = backpackCtrl:getPetPointItemList()
			if ret and 0 < #ret then
				_ENV = nil
				;(nil).byUID = true
				SoraDConfigSet("Game:MainCityView:clickPetExchangeBtn~integer", serviceFunctions.systemTime(), nil)
			end
		end
	end
end
function buildTipPanel:buttonSwitchFactionCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		_ENV = nil
		;(nil).channel = gSDKDef.shareChannel.faction_button_click
		userSDKManager.logEvent(gSDKDef.TDonEvent.pet_share_begin, nil)
		local panel = SoraDCreatePanel("factionSwitchView")
		panel:init()
		panel:show()
		_ENV = panel
		panel.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(panel)
	end
end
function buildTipPanel:buttonStarSpeedUpCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		local buildEntity = self:getBuildEntity()
		local buildBid = buildEntity:getBuildBid()
		local iid = buildEntity:getIid()
		local queue
		_UPVALUE3_ = nil
		;(nil)[1] = gQueueTypeDef.build_star_queue
		;(nil)[2] = gQueueTypeDef.build_star_queue_privilege
		;(nil)[3] = gQueueTypeDef.glorious_upgrade
		for _, _queueType in ipairs(nil) do
			local _queue = queueCtrl:queryQueue(_queueType)
			if _queue and tonumber(_queue.data.bid) == tonumber(buildBid) and tonumber(_queue.data.iid) == tonumber(iid) then
				queue = _queue
				break
			end
		end
		if queue == nil then
			_ENV = ipairs(nil)
			ipairs(nil).msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
			SoraDSendMessage(ipairs(nil))
			return
		end
		local speedUpItemList = self:getSpeedUpItemList(queue.qtype)
		if 0 < #speedUpItemList then
			SoraDShowSpeedUpByItemBox(queue.qtype)
		else
			local msgDes = i18n("Glory_text_30")
			dump(queue.data, "queue.data")
			if tonumber(queue.data.bid) == BUILDID.STAR_BRAVE_STATUE then
				msgDes = i18n("Soldiers_armor_text_69")
			end
			SoraDShowSpeedUpBox(queue, nil, msgDes)
		end
		_ENV = SoraDShowSpeedUpBox
		SoraDShowSpeedUpBox.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(SoraDShowSpeedUpBox)
	end
end
function buildTipPanel:buttonProcessStudyCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		uiManager:show("ArmorTechnology")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonWarframeForgCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		uiManager:show("WarframeForg")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonWarframeStoreroomCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		uiManager:show("WarframeStoreRoom")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonUpStatueBraveCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		_ENV, _ENV = nil, nil
		;(nil).bid = self.relyBuildCfgId
		;(nil).iid = self.relyBuildIid
		;(nil).index = self.relyBuildBtnId
		;(nil).upgradeBraveData, (nil).buildEntity = nil, self:getBuildEntity()
		uiManager:show("BuildUpgradeStatueBrave", nil)
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonMilitaryFortressCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		local panel = SoraDCreatePanel("militaryFortressMainView")
		panel:show()
		_ENV = panel
		panel.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(panel)
	end
end
function buildTipPanel:buttonHeroTaskCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		uiManager:show("HeroKnowledgeMain")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonForeignPavilionCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.FOREIGNPAVILION)
		if unlockLv > SoraDGetCastleLv() then
			_ENV = nil
			;(nil).lv = unlockLv
			SoraDShowMsgTip(i18n("common_text_1973", nil))
			return
		end
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local castleBcell = cityCtrl:getBuildCell(BUILDID.CASTLE, 0)
		if not castleBcell then
			_ENV = BUILDID.CASTLE
			BUILDID.CASTLE.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
			SoraDSendMessage(BUILDID.CASTLE)
			return
		end
		if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.EXOTIC_PAVILION_ACTIVITY) then
			local exoticPavilionCtrl = SoraDGetCtrl("exoticPavilionCtrl")
			if exoticPavilionCtrl:getCurStage() == 1 and exoticPavilionCtrl:getCurStep() <= 3 then
				_ENV, gametop = exoticPavilionCtrl, exoticPavilionCtrl:getCurStep()
				exoticPavilionCtrl.img = "girl"
				_ENV, exoticPavilionCtrl.str = i18n("exitic_pavillion_text_0147"), i18n("exitic_pavillion_text_0147")
				i18n("exitic_pavillion_text_0147").callback = function()
					uiManager:show("ForeignPavilionActivity")
				end
				exoticPavilionCtrl:getCurStep()[1] = exoticPavilionCtrl
				local exoticPavilionCtrl:getCurStep()[2], noticeData = i18n("exitic_pavillion_text_0147"), exoticPavilionCtrl:getCurStep()
				gModuleMgr.sharedMgr("mildGuideManager"):createNoticeLine(noticeData)
			else
				uiManager:show("ForeignPavilionActivity")
			end
		else
			SoraDShowMsgTip(i18n("common_text_2486"))
		end
		_ENV = i18n("common_text_2486")
		i18n("common_text_2486").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(i18n("common_text_2486"))
	end
end
function buildTipPanel:buttonMeteorMagicCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		uiManager:show("MeteoriteUI")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonNebulaTechCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		uiManager:show("NebulaAreaTech")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonNebulaTechRewardCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		uiManager:show("NewbulaAreaTechReward")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonMagicLampCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		uiManager:show("MagicLampMain")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonMagicLampGiftCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		print("===========神灯特权礼包入口===========")
		uiManager:show("MagicLampPrivilegeView")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonMagicLampPrayCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		uiManager:show("MagicLampMaigcPowerMain")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonMagicLampHatchCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		local magicLampHatchRead = include("magicLampHatchRead")
		local hatchCfg = magicLampHatchRead.getHatchCfg(gJinnType.JINN_ONE)
		_ENV = nil
		;(nil).jinnType = hatchCfg.jinnType[2]
		;(nil).hatchType = hatchCfg.type
		uiManager:show("MagicLampHatch", nil)
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonMagicLampBreakCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		local queue = queueCtrl:queryQueue(gQueueTypeDef.magic_lamp_jinn_star)
		if queue == nil then
			_ENV = gQueueTypeDef.magic_lamp_jinn_star
			gQueueTypeDef.magic_lamp_jinn_star.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
			SoraDSendMessage(gQueueTypeDef.magic_lamp_jinn_star)
			return
		end
		local speedUpItemList = self:getSpeedUpItemList(queue.qtype)
		if 0 < #speedUpItemList then
			SoraDShowSpeedUpByItemBox(queue.qtype)
		else
			SoraDShowSpeedUpBox(queue, nil, i18n("common_text_765"))
		end
		_ENV = queue
		queue.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(queue)
	end
end
function buildTipPanel:buttonMagicLampStrengthCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		local queue = queueCtrl:queryQueue(gQueueTypeDef.magic_lamp_jinn_level)
		if queue == nil then
			_ENV = gQueueTypeDef.magic_lamp_jinn_level
			gQueueTypeDef.magic_lamp_jinn_level.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
			SoraDSendMessage(gQueueTypeDef.magic_lamp_jinn_level)
			return
		end
		local speedUpItemList = self:getSpeedUpItemList(queue.qtype)
		if 0 < #speedUpItemList then
			SoraDShowSpeedUpByItemBox(queue.qtype)
		else
			SoraDShowSpeedUpBox(queue, nil, i18n("common_text_765"))
		end
		_ENV = queue
		queue.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(queue)
	end
end
function buildTipPanel:buttonMagicLampClassCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		local queue = queueCtrl:queryQueue(gQueueTypeDef.magic_lamp_jinn_class)
		if queue == nil then
			_ENV = gQueueTypeDef.magic_lamp_jinn_class
			gQueueTypeDef.magic_lamp_jinn_class.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
			SoraDSendMessage(gQueueTypeDef.magic_lamp_jinn_class)
			return
		end
		local speedUpItemList = self:getSpeedUpItemList(queue.qtype)
		if 0 < #speedUpItemList then
			SoraDShowSpeedUpByItemBox(queue.qtype)
		else
			SoraDShowSpeedUpBox(queue, nil, i18n("common_text_765"))
		end
		_ENV = queue
		queue.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(queue)
	end
end
function buildTipPanel:buttonMagicLampHatchUpgradeCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		local queue = queueCtrl:queryQueue(gQueueTypeDef.magic_lamp_hatch_level)
		if queue == nil then
			_ENV = gQueueTypeDef.magic_lamp_hatch_level
			gQueueTypeDef.magic_lamp_hatch_level.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
			SoraDSendMessage(gQueueTypeDef.magic_lamp_hatch_level)
			return
		end
		local speedUpItemList = self:getSpeedUpItemList(queue.qtype)
		if 0 < #speedUpItemList then
			SoraDShowSpeedUpByItemBox(queue.qtype)
		else
			SoraDShowSpeedUpBox(queue, nil, i18n("common_text_765"))
		end
		_ENV = queue
		queue.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(queue)
	end
end
function buildTipPanel:buttonMagicLampSkillCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		uiManager:show("MagicLampSkillMain")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonNewbronBeastCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		uiManager:show("MythicalCreaturesView")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:buttonNewbronBeastCanyonCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		clientEventMgr.singleClickEvent(gActivityTimeActivityID.DIVINE_BEAST_CANYON_ACTIVITY)
		_ENV = gActivityTimeActivityID.DIVINE_BEAST_CANYON_ACTIVITY
		gActivityTimeActivityID.DIVINE_BEAST_CANYON_ACTIVITY.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(gActivityTimeActivityID.DIVINE_BEAST_CANYON_ACTIVITY)
	end
end
function buildTipPanel:buttonNewbronEliteBeastCanyonCall(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		clientEventMgr.singleClickEvent(gActivityTimeActivityID.NORMAL_ACTIVITY_9001650)
		_ENV = gActivityTimeActivityID.NORMAL_ACTIVITY_9001650
		gActivityTimeActivityID.NORMAL_ACTIVITY_9001650.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(gActivityTimeActivityID.NORMAL_ACTIVITY_9001650)
	end
end
function buildTipPanel:onClickBtnExchange9001650(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		local activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001650
		_ENV = nil
		;(nil).activityID = activityID
		;(nil).defaultClick = 2
		uiManager:show("BeastCanyonExchange", nil)
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:onClickBtnShelter(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		uiManager:show("ShelterView")
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
function buildTipPanel:onClickBtnGardenCity(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(nil)
		local manorCityUtil = include("manorCityUtil")
		manorCityUtil.gotoGardenCity()
	end
end
function buildTipPanel:onClickBtnGardenWar(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(nil)
		local manorCityUtil = include("manorCityUtil")
		manorCityUtil.gotoGardenWar()
	end
end
function buildTipPanel:GetButtonArrayByOpList(opList)
	local _ENV, arrButtonList
	local _ENV, arrOpList
	for k, v in pairs(opList) do
		_ENV = nil
		;(nil).OpName = k
		;(nil).btnId = v
		table.insert(arrOpList, nil)
	end
	table.sort(arrOpList, function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end)
	_ENV = table.sort
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_DETAIL], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonInfoCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_UPGRADE], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonUpgradeCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_TRADE], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonTradeCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_RESEARCH], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonResearchCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_BUILD], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonBuildTrapCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_TRAIN], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonTrainCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_HELP], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonHelpCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_REINFORCEMENTS], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonReinforcementsCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_WISH], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonWishCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_ENDLESSTREASURE], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonETreasureCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_ALLIANCEBATTLE], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonAllianceBattleCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_DEFEND], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonDefendCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_MILITARYINFO], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonMilitaryInfoCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_CITY_INFO], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonCityInfoCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_CITY_BUFF], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonCityBuffCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_HEAL], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonHealCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_COLLECT], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonCollectCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_SPEED_UP_BY_GOLD], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonSpeedUpByGoldCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_SPEED_UP_BY_TOOL], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonSpeedUpByToolCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_BOOST], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonBoostCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_FORGING], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonForgingCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_STORAGEBOX], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonStorageBoxCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_BOOST_BY_TOOL], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonBoostByToolCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_PYRAMID], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonPyramidCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_BADGEBOURSE], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonBadgeBourseCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_FRIEND], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonFriendCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_CITY_DECORATE], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonCityDecorateCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_WAR], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonWarCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_MILITARY_POINT], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonMilitaryPointCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_COUNTER_SYS], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonCounterSysCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_DAILYSIGN], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonDailySignCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_MONTH_GIFT], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonMonthGiftCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_RESUSCITATE], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonResuscitateCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_DAILYREWARD], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonDailyRewardCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_AUCTION], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonAuctionCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_PET], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonPetCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_PET_MAP], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonPetMapCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_STRING_OF_LIFE], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonStringOfLifeCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_PREMIUM_VIP_MALL], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonPremiumVipMallCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_PET_EXCHANGE], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonPetExchangeCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_WAR_GEM], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonWarGemCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_WAR_TECHNOLOGY], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonWarTechnologyCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_GOD_EQUIPMENT], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonGodEquipmentCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_ARTIFACT], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonArtifactCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_HEROWEAPON], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonHeroWeaponCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_CITY_GIFT], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonCityGiftCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_ALLIANCE_TREASURE], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonAllianceTreasureCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_ARENA], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonArenaCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_DISCUSS], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonDiscussCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_SUPPORT], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonSupportCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_INFOCENTER], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonInfoCenterCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_NAVINOTICE], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonNaviNoticeCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_MONUMENT], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonMonumentCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_TRAINHALL], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonTrainHallCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_PRISON], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonPrisonCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_MASTERY], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonMasteryCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_MAINMASTERY], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonMainMasteryCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_DRAWING], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonDrawingCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_MONUMENT_LEGEND], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonMonumentLegendCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_INTETIOR], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonIntetiorCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_EXCLUSIVE_VIP], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonVipCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_STARUPGRADE], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonStarUpgradeCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_STARSPEEDUP], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonStarSpeedUpCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_PROCESSSTUDY], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonProcessStudyCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_WARFRAMEFORG], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonWarframeForgCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_WARFRAMESTOREROOM], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonWarframeStoreroomCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_STATUEBRAVE], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonUpStatueBraveCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_MILITARY_FORTRESS], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonMilitaryFortressCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_CITY_LEVEL_GIFT], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonWallGiftCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_FOREIGN_PAVILION], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonForeignPavilionCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_HEROTASK], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonHeroTaskCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_METEOR_MAGIC], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonMeteorMagicCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_NEBULA_TECHNOLOGY], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonNebulaTechCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_NEBULA_TECHNOLOGY_REWARD], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonNebulaTechRewardCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_MAGICLAMP_GIFT], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonMagicLampGiftCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_MAGICLAMP], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonMagicLampCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_MAGICLAMP_PRAY], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonMagicLampPrayCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_MAGICLAMP_HATCH], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonMagicLampHatchCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_MAGICLAMP_BREAK], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonMagicLampBreakCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_MAGICLAMP_STRENGTH], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonMagicLampStrengthCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_MAGICLAMP_CLASS], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonMagicLampClassCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_MAGICLAMP_HATCH_UPGRADE], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonMagicLampHatchUpgradeCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_MAGICLAMP_SKILL], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonMagicLampSkillCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_NEWBORN_TREE_BEAST], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonNewbronBeastCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_NEWBORN_BEAST_CANYON], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonNewbronBeastCanyonCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_NEWBORN_ELITEBEAST_CANYON], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.buttonNewbronEliteBeastCanyonCall)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_EXCHANGE_9001650], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.onClickBtnExchange9001650)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_SHELTER], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.onClickBtnShelter)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	table.sort[BOP_NAME.BOP_GARDEN_CITY], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.onClickBtnGardenCity)
	function _ENV(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end
	_ENV, table.sort[BOP_NAME.BOP_GARDEN_WAR], (function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end).handler = BOP_NAME.BOP_GARDEN_WAR, function(lhs, rhs)
		local nationCtrl = SoraDGetCtrl("factionCtrl")
		local lhsData = nationCtrl:getBuildTipButtonCfgById(lhs.btnId)
		local rhsData = nationCtrl:getBuildTipButtonCfgById(rhs.btnId)
		if lhsData.OpSortIndex ~= rhsData.OpSortIndex then
			if SoraDFIsRA() then
				return lhsData.OpSortIndex > rhsData.OpSortIndex
			else
				return lhsData.OpSortIndex < rhsData.OpSortIndex
			end
		end
		if SoraDFIsRA() then
			return lhs.btnId < rhs.btnId
		else
			return lhs.btnId > rhs.btnId
		end
	end, handler(self, self.onClickBtnGardenWar)
	table.sort.undefined, BOP_NAME.BOP_GARDEN_WAR.handler = BOP_NAME.BOP_GARDEN_WAR, handler(self, self.buttonUnDefinedCall)
	local op_config = table.sort
	for k, v in pairs(arrOpList) do
		local config = op_config[v.OpName] or op_config.undefined
		if v.OpName == BOP_NAME.BOP_MAGICLAMP_GIFT then
			local giftList = SoraDGetCtrl("magicLampCtrl"):getMagicLampGift()
			if 0 < #giftList then
				_ENV = nil
				;(nil).opType = v
				;(nil).buildEntity = self:getBuildEntity()
				;(nil).handler = config.handler
				arrButtonList[#arrButtonList + 1] = self:createButtonByOpType(nil)
			end
		else
			_ENV = self
			self.opType = v
			self.buildEntity = self:getBuildEntity()
			self.handler = config.handler
			arrButtonList[#arrButtonList + 1] = self:createButtonByOpType(self)
		end
	end
	return arrButtonList
end
function buildTipPanel:getBuildState()
	local buildLogic = include("buildLogic")
	local buildRead = include("buildDescribeRead")
	local gametop = gModuleMgr.getObject("gametop")
	if buildLogic == nil or buildRead == nil or gametop == nil then
		return 0
	end
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local buildCell = cityCtrl:getBuildCell(self.relyBuildCfgId, self.relyBuildIid)
	if buildCell == nil then
		return 0
	end
	return tonumber(buildCell.info.state)
end
function buildTipPanel:recycleAllBtns()
	for i = 1, #self.tbBtnInuse do
		local btn = table.remove(self.tbBtnInuse, #self.tbBtnInuse)
		btn:setVisible(false)
		btn:reset()
		table.insert(self.tbBtnNotUse, btn)
	end
end
function buildTipPanel:createButtonByOpType(opType)
	local buildTipButtonNode
	if #self.tbBtnNotUse > 0 then
		buildTipButtonNode = table.remove(self.tbBtnNotUse, #self.tbBtnNotUse)
	else
		local buildTipButton = include("buildTipButton")
		buildTipButtonNode = buildTipButton.new(getCCSPath("buildTipButton"))
		buildTipButtonNode:addTo(self, 1)
	end
	buildTipButtonNode:initWithData(opType)
	table.insert(self.tbBtnInuse, buildTipButtonNode)
	return buildTipButtonNode
end
function buildTipPanel:getBuildEntity()
	return self.relyBuildEntity
end
function buildTipPanel:getHasAnySpeedUpTool()
	local ret = false
	local buildEntity = self:getBuildEntity()
	local queueType = buildEntity:getQueueType()
	if queueType == gQueueTypeDef.radiance_war_hostpital_queue then
		return true
	end
	local speedUpItemList = self:getSpeedUpItemList(queueType)
	if 0 < #speedUpItemList then
		ret = true
	end
	return ret
end
function buildTipPanel:getSpeedUpItemList(queueType)
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local itemList = backpackCtrl:getSpeedUpItemListByQueueType(queueType)
	return itemList
end
function buildTipPanel:getBtnByOpName(opName)
	for k, v in pairs(self.buttonList) do
		if v:getOpName() == opName then
			return v
		end
	end
end
function buildTipPanel:showBtnHand(target, data)
	local delay = data.delay or 0
	local btnName = data.btnName
	if delay then
		_UPVALUE1_ = nil
		;(nil)[1] = cca.delay(delay)
		;(nil)[2] = cca.callFunc(function()
			local btn = self:getBtnByOpName(btnName)
			if btn then
				local x, y = 0, 0
				local buildTopTipHand = include("cityBuildTopTipHand")
				local buildTopTipHandNode = buildTopTipHand.new(getCCSPath("cityBuildTopTipHand"))
				buildTopTipHandNode:setName(buildTopTipHandNodeName)
				buildTopTipHandNode:setPosition(cc.p(x + 20, y + 80))
				buildTopTipHandNode:addTo(btn, 2)
			end
		end)
		;(nil)[3] = cca.callFunc(function()
			local btn = self:getBtnByOpName(btnName)
			if btn then
				local x, y = 0, 0
				local buildTopTipHand = include("cityBuildTopTipHand")
				local buildTopTipHandNode = buildTopTipHand.new(getCCSPath("cityBuildTopTipHand"))
				buildTopTipHandNode:setName(buildTopTipHandNodeName)
				buildTopTipHandNode:setPosition(cc.p(x + 20, y + 80))
				buildTopTipHandNode:addTo(btn, 2)
			end
		end)
		self:runAction(cca.seq(nil))
	end
end
function buildTipPanel:hideTip()
	self:stopAllActionsByTag(tag_act_tip_show_end)
	self:setVisible(false)
	self:recycleAllBtns()
end
function buildTipPanel:checkBuildMastery(buildBid, buildState)
	self:hideMasteryStar()
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	if guideCtrl:isGuideNotCompleted(gGuideModule.BUILD_MASTERY) then
		return
	end
	local maxLv = specializationRead.getMasteryMaxLv(buildBid)
	if maxLv and 0 < maxLv then
		if buildState == BUILD_STATE.NORMAL then
			local buildEntity = self.relyBuildEntity
			if not buildEntity:getIsTraining() and (tonumber(buildBid) ~= cityBuildConstDef.fixedBuildDef.Mastery or not buildEntity:getIsUpgrading()) then
				self:showMasteryStar(buildBid)
			end
		end
		return true
	end
end
function buildTipPanel:checkExclusiveVip()
	local isOpen = false
	local exaltedPrivilegeCtrl = SoraDGetCtrl("exaltedPrivilegeCtrl")
	local exclusiveVipRead = include("exclusiveVipRead")
	local totalScore = exaltedPrivilegeCtrl:getTotalScores()
	local curPrivilegeList, curSore = exclusiveVipRead:getPrivilegeList(totalScore)
	local welfareInfo = exaltedPrivilegeCtrl:getWelfareInfo()
	local totalRecharge = premiumStoreCtrl:getDollor()
	local historyInfo, nextHistoryInfo = exclusiveVipRead:getReachRechargeInfo(totalRecharge)
	local needWeekGold = exclusiveVipRead:getWeeklyRechargeNeedGold()
	local weekTotalRecharge = exaltedPrivilegeCtrl:getWeekRechargeGold()
	local weekNeedHistoryRechargeGold = exclusiveVipRead:getweeklyHistoryRechargeNeedGold()
	local packageList, isPackageExit = exclusiveVipRead:getRechargeGiftInfo(totalRecharge)
	local isHistoryReach = false
	local isWeekReach = false
	if not historyInfo then
		if totalRecharge >= nextHistoryInfo.charge_amount then
			isHistoryReach = true
		end
	elseif totalRecharge >= historyInfo.charge_amount then
		isHistoryReach = true
	end
	if totalRecharge >= weekNeedHistoryRechargeGold then
		isWeekReach = true
	end
	print("buildTipPanel按钮觉醒条件：", table.nums(curPrivilegeList), table.nums(welfareInfo), isPackageExit, isHistoryReach, isWeekReach)
	if table.nums(curPrivilegeList) > 0 or table.nums(welfareInfo) > 0 or isPackageExit or isHistoryReach or isWeekReach then
		isOpen = true
	end
	return isOpen
end
function buildTipPanel:showMasteryStar(bid)
	local mid = specializationRead.getMasteryID(bid)
	local mastery = cityCtrl:getMasteryByMid(mid)
	if mastery then
		self.starSingle:setVisible(true)
		specializationRead = true
		;(true).lev = mastery.lev
		self.starSingle:initData(true)
	else
		self:hideMasteryStar()
	end
end
function buildTipPanel:hideMasteryStar(...)
	if self.starSingle then
		self.starSingle:setVisible(false)
	end
end
function buildTipPanel:updateHeroNode(bid)
	local heroAppointCtrl = SoraDGetCtrl("heroAppointCtrl")
	local heroCtrl = SoraDGetCtrl("heroCtrl")
	local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
	local heroID = heroAppointCtrl:getAppointHero(bid)
	local heroBg = self.heroNode:getChildByName("heroBg")
	local heroIcon = self.heroNode:getChildByName("heroIcon")
	if heroID then
		local heroInfo = heroCtrl:getHeroInfoByID(heroID)
		heroBg:setSpriteFrame(heroltCtrl.getCubeBg(heroInfo.quality))
		heroBg:setScale(0.85)
		local cfg = heroltCtrl.getHeroInfo(heroID)
		self.heroIcon:setSpriteFrame(cfg.herIcon)
		self.heroIcon:setScale(0.9)
	else
		heroBg:setSpriteFrame("frame_LegendaryKing_head_base.png")
		heroBg:setScale(1)
		self.heroIcon:setSpriteFrame("frame_LegendaryKing_green_add.png")
		self.heroIcon:setScale(1)
	end
end
function buildTipPanel:onBtnHeroAppoint(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("英雄任命===========")
		_ENV = nil
		;(nil).bid = self.buildBid
		uiManager:show("HeroAppointMain", nil)
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	end
end
return buildTipPanel
