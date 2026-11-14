local buildLogic = include("buildLogic")
local buildRead = include("buildDescribeRead")
local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local cityBuildFunction = include("cityBuildFunction")
local armyCtrl = gametop.playertop_:getModule("armyCtrl")
local allianceHelp = gametop.playertop_:getModule("allianceHelp")
local cityltCtrl = include("cityltCtrl")
local cityBuildConstDef = include("cityBuildConstDef")
local cityBuildViewDef = include("cityBuildViewDef")
local guideCtrl = SoraDGetCtrl("guideCtrl")
local funUnlockRead = include("funUnlockRead")
include("cityBuildingInfo")
local cityBuildBaseEntity = class("cityBuildBaseEntity", function(target)
	local cityBuildClass = include("cityBuildBase")
	return cityBuildClass.new()
end)
_ENV = "cityBuildBaseEntity"
;("cityBuildBaseEntity").CITYBUILD_HARVESTSTATE_UNDEFINED = 0
;("cityBuildBaseEntity").CITYBUILD_HARVESTSTATE_NONE = 1
;("cityBuildBaseEntity").CITYBUILD_HARVESTSTATE_SOME = 2
local ("cityBuildBaseEntity").CITYBUILD_HARVESTSTATE_MUCH, CITYBUILD_HARVESTSTATE = 3, "cityBuildBaseEntity"
function cityBuildBaseEntity:ctor()
	self.singleIsMoved = false
	self.isCancel = false
	self.isReconnected = false
	self.hasNpcTip = false
	self.udpateIsCanUpGradeTime = -1
	self.blockState = "idle"
	self.buffid = 0
	self.isShowBuff = false
	self.buildIndex = 0
	self.isCanSpeedUpFree = false
	self.isCanResearchFree = false
	self.queueDirty = false
	self.harvestState = CITYBUILD_HARVESTSTATE.CITYBUILD_HARVESTSTATE_UNDEFINED
	self.posEtUpgradeOffset = cc.p(0, 10)
	self.isTraining = false
	self:initStateMachine()
	self.isShowWarLv = false
end
function cityBuildBaseEntity:loadBaseView()
	local bid = self:getBuildBid()
	if bid ~= nil then
		self:loadBaseViewByBid(bid)
	end
	local buildBtn = self.buildBtn
	if buildBtn then
		buildBtn:setTouchEnabled(true)
		buildBtn:setSwallowTouches(false)
		buildBtn:addTouchEventListener(function(ref, type)
			self:buildButtonCallFun(ref, type)
		end)
	end
	self:hideBuildLv()
end
function cityBuildBaseEntity:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_CITYBUFF_DISAPPEAR", handler(self, self.sMsgRemoveBuff))
	SoraDAddMessage(self, "MESSAGE_SERVER_UPDATE_BUILD_CAN_UPGRADE", handler(self, self.sMsgUpdateBuildCanUpgrade))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_TRAIN_ARMY_IMMDIATELY_BACK", handler(self, self.sMsgTrainArmyImmediatelyBack))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_BUILD_TRAIN_FAILED", handler(self, self.sMsgBuildTrainFailed))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_BUILDSTAR_QUEQUE_CALLBACK", handler(self, self.updateStarLv))
	SoraDAddMessage(self, "MESSAGE_BUILD_STAR_UPGRADE", handler(self, self.updateStarLv))
end
function cityBuildBaseEntity:updateLvScale(target, data)
	local scale = 1
	if data.scale < MAINCITY_DEFAULT_SCALE then
		scale = 1 + 0.5 * (MAINCITY_DEFAULT_SCALE - data.scale) / (MAINCITY_DEFAULT_SCALE - 0.35)
	end
	self.buildLvBg:setScale(scale)
	self.textLv:setScale(scale)
	self:updateLvPos()
end
function cityBuildBaseEntity:sMsgUpdateBuildCanUpgrade(target, data)
	local needUpdate = true
	if self.udpateIsCanUpGradeTime > 0 and os.time() - self.udpateIsCanUpGradeTime <= 1 then
		needUpdate = false
		local uniqueKey = self:getBuildBid() .. "_" .. self:getBuildIndex()
		self.upgradeTimeHandle = SoraDDelayCallOnce("cityBuildBaseEntity_UpdateUpgrade" .. uniqueKey, function()
			self.upgradeTimeHandle = nil
			if tolua.isnull(self) then
				return
			end
			if self.udpateIsCanUpGrade then
				self:udpateIsCanUpGrade()
			end
			if self.updateStarLv then
				self:updateStarLv()
			end
		end, 0.5, true)
	end
	if self.udpateIsCanUpGrade and needUpdate then
		self:udpateIsCanUpGrade()
	end
	if self.updateStarLv and needUpdate then
		self:updateStarLv()
	end
	self.udpateIsCanUpGradeTime = os.time()
end
function cityBuildBaseEntity:initWithBuildCell(buildCell)
	if nil == buildCell then
		return
	end
	self:endTime()
	self:setBuildIndex(tonumber(buildCell.info.index))
	self:setBuildBid(tonumber(buildCell.info.bid))
	self:setState(tonumber(buildCell.info.state))
	self:updateLv()
	_UPVALUE3_ = self
	self[1] = gQueueTypeDef.build_star_queue_privilege
	self[2] = gQueueTypeDef.build_star_queue
	self[3] = gQueueTypeDef.glorious_upgrade
	for _, _queueType in ipairs(self) do
		local queue = queueCtrl:queryQueue(_queueType)
		if queue and tonumber(queue.data.bid) == tonumber(buildCell.info.bid) and tonumber(queue.data.iid) == tonumber(buildCell.info.iid) then
			_ENV = tonumber(buildCell.info.state)
			tonumber(buildCell.info.state).queueType = _queueType
			self:updateStarLv(nil, tonumber(buildCell.info.state))
		else
			self:updateStarLv()
		end
	end
	local bid = tonumber(self:getBuildBid())
	if bid == BUILDID.FARM or bid == BUILDID.SAWMILL or bid == BUILDID.IRON_MINE or bid == BUILDID.STEEL or bid == BUILDID.CRYSTAL_MINE then
		if self.harvestState == CITYBUILD_HARVESTSTATE.CITYBUILD_HARVESTSTATE_UNDEFINED then
			self:setHarvestState(CITYBUILD_HARVESTSTATE.CITYBUILD_HARVESTSTATE_NONE, false)
		end
		self:beginTime()
		self:updateTime()
	else
	end
	if bid == BUILDID.EMBASSY then
		self:updateAllianceHelpList()
	end
	if self:getIsOpening() then
		self:showAnimBuildWorker(true)
		self:showBuildLock()
	end
	if bid == BUILDID.WISHING_WELL then
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_UPDATE_WISHINGWELL_VIEW"
		SoraDSendMessage(self)
	elseif bid == BUILDID.HOSTPITAL then
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_UPDATE_HOSPTIAL_VIEW"
		SoraDSendMessage(self)
	elseif bid == BUILDID.BLACK_SMITH then
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_UPDATE_BLACKSMITH_VIEW"
		SoraDSendMessage(self)
	elseif bid == BUILDID.HALL_OF_WAR then
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_UPDATE_HALLOFWAR_VIEW"
		SoraDSendMessage(self)
	elseif bid == BUILDID.ELITE_PALACE then
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_UPDATE_ELITE_PALACE_VIEW"
		SoraDSendMessage(self)
	elseif bid == BUILDID.CRYSTAL_MINE then
		_ENV = self
		self.msg = "MESSAGE_MAINCITY_UPDATE_CRYSTAL_MINE"
		SoraDSendMessage(self)
	elseif bid == BUILDID.NEBULA_PALACE then
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_UPDATE_NEBULA_PALACE"
		SoraDSendMessage(self)
	elseif (bid == BUILDID.MARKET or bid == BUILDID.DRILL_GROUDS) and self.checkGuide then
		self:checkGuide()
	end
	self:showBuildLv()
	self:onAfterInitWithBuildCell()
end
function cityBuildBaseEntity:onAfterInitWithBuildCell()
end
function cityBuildBaseEntity:initWithoutCell()
	self:endTime()
	local bid = tonumber(self:getBuildBid())
	if bid == BUILDID.MATERIAL_WORKSHOP then
		self:setState(BUILD_STATE.NORMAL)
		if false == cityBuildBaseEntity:getIsCanHarvestTrain() then
			self.timerHandlerDelay = SoraDCreateDelayTimer(self, handler(self, self.delayUpdateState), 3)
		end
	end
	self:onAfterInitWithoutBuildCell()
end
function cityBuildBaseEntity:onAfterInitWithoutBuildCell()
end
function cityBuildBaseEntity:getBuildCell()
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local buildCell = cityCtrl:getBuildCellByIndex(self.buildIndex)
	return buildCell
end
function cityBuildBaseEntity:setState(buildState)
	if buildState == BUILD_STATE.NORMAL then
		local buildType = SoraDGetBuildTypeByBid(self:getBuildBid())
		if buildType == 0 then
			if self:getIsCanHarvestTrain() then
				self:setBlockState("harvesting")
			elseif self:getIsTraining() then
				self:setBlockState("working")
			else
				self:setBlockState("idle")
			end
		elseif buildType == 1 then
			local buildBid = self:getBuildBid()
			if buildBid == BUILDID.HOSTPITAL and true == self:getIsTraining() then
				self:setBlockState("working")
			elseif buildBid == BUILDID.MATERIAL_WORKSHOP then
				self:setBlockState("idle")
				self:changeState()
				if self:getIsCanHarvestTrain() then
					self:setBlockState("harvesting")
					self:changeState()
				end
				if true == self:getIsTraining() then
					self:setBlockState("working")
					self:changeState()
				end
				return
			else
				self:setBlockState("idle")
				self:changeState()
				return
			end
		end
	elseif buildState == BUILD_STATE.BUILDING then
		if nil ~= self:getBuildQueue() then
			self:setBlockState("building")
		else
			print("Error!! queue is nil, bid ", self:getBuildBid())
			self:setBlockState("idle")
		end
	elseif buildState == BUILD_STATE.UPGRADEING then
		if nil ~= self:getBuildQueue() then
			self:setBlockState("building")
		else
			print("Error!! queue is nil, bid ", self:getBuildBid())
			self:setBlockState("idle")
		end
	elseif buildState == BUILD_STATE.DEMOLISHING then
		if nil ~= self:getBuildQueue() then
			self:setBlockState("demolishing")
		else
			print("Error!! queue is nil, bid ", self:getBuildBid())
			self:setBlockState("idle")
		end
	end
	self:changeState()
end
function cityBuildBaseEntity:getTrainingAidAndCount()
	local queue = self:getTrainingQueue()
	local bid = self:getBuildBid()
	if nil == queue then
		return
	end
	local aid = tonumber(queue.data.armyid)
	local armycount = tonumber(queue.data.armycount)
	if bid == BUILDID.COLLEGE then
		aid = tonumber(queue.data.technologyID)
		armycount = tonumber(queue.data.currentLevel)
	elseif bid == BUILDID.BLACK_SMITH then
		aid = tonumber(queue.data.eid)
		armycount = 1
	elseif bid == BUILDID.MATERIAL_WORKSHOP then
		aid = tonumber(queue.data.ID)
		armycount = 1
	end
	return aid, armycount
end
function cityBuildBaseEntity:showTopTipEffect()
	local bid = self:getBuildBid()
	local buildState = self:getBuildState()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP"
	;(nil).buildIndex = self.buildIndex
	;(nil).buildEntity = self
	SoraDSendMessage(nil)
end
function cityBuildBaseEntity:hideTopTipEffect()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
	;(nil).buildIndex = self.buildIndex
	;(nil).buildEntity = self
	SoraDSendMessage(nil)
end
function cityBuildBaseEntity:showWorkDone()
	local bid = tonumber(self:getBuildBid())
	if bid == BUILDID.STABLES or bid == BUILDID.RANGE or bid == BUILDID.BARRACKS or bid == BUILDID.FORTRESS or bid == BUILDID.CHARIOT_PLANT or bid == BUILDID.ELITE_PALACE then
		self:showTopTipEffect()
		self:showAnimWorking(false)
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		self.buildIndex = self.buildIndex
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_WORK_DONE_EFFECT"
		self.buildIndex = self.buildIndex
		self.buildEntity = self
		SoraDSendMessage(self)
	elseif bid == BUILDID.BLACK_SMITH then
		self:showTopTipEffect()
		self:hideAnimWorking()
		self:showGlow()
		self:hideZAnimation()
		self:showBrightParticle()
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		self.buildIndex = self.buildIndex
		SoraDSendMessage(self)
	elseif bid == BUILDID.MATERIAL_WORKSHOP then
		self:hideAnimWorking()
		self:showTopTipEffect()
		self:showBrightParticle()
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		self.buildIndex = self.buildIndex
		SoraDSendMessage(self)
	elseif bid == BUILDID.FARM or bid == BUILDID.SAWMILL or bid == BUILDID.IRON_MINE or bid == BUILDID.STEEL or bid == BUILDID.CRYSTAL_MINE then
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		self.buildIndex = self.buildIndex
		SoraDSendMessage(self)
		self:showTopTipEffect()
	elseif bid == BUILDID.STAR_BRAVE_STATUE then
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		self.buildIndex = self.buildIndex
		SoraDSendMessage(self)
	end
end
function cityBuildBaseEntity:hideWorkDone()
	self:hideTopTipEffect()
	if self:getBuildBid() == BUILDID.BLACK_SMITH then
		self:hideBrightParticle()
	end
	_ENV = self
	self.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_WORK_DONE_EFFECT"
	self.buildIndex = self.buildIndex
	self.buildEntity = self
	SoraDSendMessage(self)
end
function cityBuildBaseEntity:setBuildIndex(buildIndex)
	self.buildIndex = tonumber(buildIndex)
end
function cityBuildBaseEntity:getBuildIndex()
	return self.buildIndex
end
function cityBuildBaseEntity:getIid()
	local buildCell = self:getBuildCell()
	if nil == buildCell then
		return 0
	end
	return tonumber(buildCell.info.iid)
end
function cityBuildBaseEntity:getBuildBid()
	if self.bid ~= 0 then
		return self.bid
	end
	local buildCell = self:getBuildCell()
	if nil == buildCell then
		return 0
	end
	self.bid = buildCell.info.bid
	return self.bid
end
function cityBuildBaseEntity:setBlockState(blockState)
	self.blockState = blockState
end
function cityBuildBaseEntity:getBuildLv()
	local buildCell = self:getBuildCell()
	if nil == buildCell then
		return 1
	end
	return tonumber(buildCell.info.lv)
end
function cityBuildBaseEntity:getBuildStarLv()
	local buildCell = self:getBuildCell()
	if nil == buildCell then
		return 0
	end
	return tonumber(buildCell.info.starLv) or 0
end
function cityBuildBaseEntity:setLv(buildLv)
	self.buildLvTip:setLv(buildLv)
end
function cityBuildBaseEntity:hideBuildLv()
	if self.textLv then
		self.textLv:setVisible(false)
	end
	if self.buildLvBg then
		self.buildLvBg:setVisible(false)
	end
	if self.imgUpgrade then
		self.imgUpgrade:setVisible(false)
	end
end
function cityBuildBaseEntity:showBuildLv()
	if self:getIsLocked() == true then
		return
	end
	if self:getIsOpening() == true then
		return
	end
	if self:getBuildBid() == BUILDID.ELITE_PALACE then
		return
	end
	if self:getBuildBid() == BUILDID.MIRACLE then
		local buildLv = self:getBuildLv()
		local isWarLv, warLv = buildLogic.isBuildWarLv(buildLv)
		if not isWarLv or warLv == 0 then
			return
		end
	elseif self:getBuildBid() == BUILDID.STAR_BRAVE_STATUE then
		local starLv = self:getBuildStarLv()
		print("buildStarLv-3", starLv)
		if starLv <= 0 then
			return
		end
	end
	if self.textLv then
		self.textLv:setVisible(true)
	end
	if self.buildLvBg then
		self.buildLvBg:setVisible(true)
	end
end
function cityBuildBaseEntity:updateLv()
	local bid = self:getBuildBid()
	if bid == BUILDID.MATERIAL_WORKSHOP then
		return
	end
	local buildLv = self:getBuildLv()
	local buildStarLv = self:getBuildStarLv()
	local isShowWarLv, textLv = SoraDGetBuildWarLv(buildLv)
	self:updateTextLv()
	local buildLogic = include("buildLogic")
	local buildRead = include("buildDescribeRead")
	local gametop = gModuleMgr.getObject("gametop")
	if buildLogic == nil or buildRead == nil or gametop == nil then
		return
	end
	if gametop == nil then
		return
	end
	self:udpateIsCanUpGrade()
	if self:getBuildBid() == BUILDID.CASTLE then
		_ENV = BUILDID.CASTLE
		BUILDID.CASTLE.msg = "MESSAGE_MAINCITYVIEW_UPDATE_LOCK_AREA"
		SoraDSendMessage(BUILDID.CASTLE)
		if buildLv >= CASTLE_LV4_LIMITED then
			_ENV = BUILDID.CASTLE
			BUILDID.CASTLE.msg = "MESSAGE_MAINCITYVIEW_UPDATE_PET_CENTER_VIEW"
			SoraDSendMessage(BUILDID.CASTLE)
			_ENV = BUILDID.CASTLE
			BUILDID.CASTLE.msg = "MESSAGE_GREEN_POINT_UPDATE"
			BUILDID.CASTLE.type = GREEN_POINT_NOTICE_TYPE.HUNT
			SoraDSendMessage(BUILDID.CASTLE)
		end
		if buildLv >= CASTLE_LV6_LIMITED then
			_ENV = BUILDID.CASTLE
			BUILDID.CASTLE.msg = "MESSAGE_MAINCITYVIEW_UPDATE_RESURRECTION_HALL_VIEW"
			SoraDSendMessage(BUILDID.CASTLE)
			_ENV = BUILDID.CASTLE
			BUILDID.CASTLE.msg = "MESSAGE_MAINCITYVIEW_UPDATE_HISTORY_VIEW"
			SoraDSendMessage(BUILDID.CASTLE)
		end
		if buildLv >= CASTLE_LV7_LIMITED then
			_ENV = BUILDID.CASTLE
			BUILDID.CASTLE.msg = "MESSAGE_MAINCITYVIEW_UPDATE_LOCK_TURRET"
			SoraDSendMessage(BUILDID.CASTLE)
			_ENV = BUILDID.CASTLE
			BUILDID.CASTLE.msg = "MESSAGE_MAINCITYVIEW_UPDATE_TRAIN_HALL_VIEW"
			SoraDSendMessage(BUILDID.CASTLE)
		end
		if buildLv >= CASTLE_LV8_LIMITED then
			_ENV = BUILDID.CASTLE
			BUILDID.CASTLE.msg = "MESSAGE_MAINCITYVIEW_UPDATE_DEFENDWALL_VIEW"
			SoraDSendMessage(BUILDID.CASTLE)
		end
		if buildLv >= CASTLE_LV16_LIMITED then
			_ENV = BUILDID.CASTLE
			BUILDID.CASTLE.msg = "MESSAGE_MAINCITYVIEW_UPDATE_ELITE_PALACE_VIEW"
			SoraDSendMessage(BUILDID.CASTLE)
			_ENV = BUILDID.CASTLE
			BUILDID.CASTLE.msg = "MESSAGE_MAINCITYVIEW_UPDATE_PRISON_VIEW"
			SoraDSendMessage(BUILDID.CASTLE)
		end
		if buildLv >= CASTLE_LV19_LIMITED then
			_ENV = BUILDID.CASTLE
			BUILDID.CASTLE.msg = "MESSAGE_MAINCITYVIEW_UPDATE_MONUMENT_VIEW"
			SoraDSendMessage(BUILDID.CASTLE)
		end
		if buildLv >= CASTLE_LV15_LIMITED then
			_ENV = BUILDID.CASTLE
			BUILDID.CASTLE.msg = "MESSAGE_MAINCITYVIEW_UPDATE_MASTERY_VIEW"
			SoraDSendMessage(BUILDID.CASTLE)
		end
		if buildLv >= CASTLE_LV10_LIMITED then
			_ENV = BUILDID.CASTLE
			BUILDID.CASTLE.msg = "MESSAGE_MAINCITYVIEW_UPDATE_BLACKSMITH_VIEW"
			SoraDSendMessage(BUILDID.CASTLE)
			_ENV = BUILDID.CASTLE
			BUILDID.CASTLE.msg = "MESSAGE_MAINCITYVIEW_UPDATE_MATERIAL_WORKSHOP_VIEW"
			SoraDSendMessage(BUILDID.CASTLE)
		end
		if buildLv >= CASTLE_LV25_LIMITED then
			_ENV = BUILDID.CASTLE
			BUILDID.CASTLE.msg = "MESSAGE_MAINCITYVIEW_UPDATE_COMMUNITY_VIEW"
			SoraDSendMessage(BUILDID.CASTLE)
		end
		if 30 <= buildLv then
			_ENV = BUILDID.CASTLE
			BUILDID.CASTLE.msg = "MESSAGE_MAINCITY_UPDATE_CRYSTAL_MINE"
			SoraDSendMessage(BUILDID.CASTLE)
		end
	end
	if not isShowWarLv and self.isShowWarLv == true and self.buildLvBg then
		self.buildLvBg:setSpriteFrame("icon_main_build_lv.png")
		self.isShowWarLv = false
	end
	if isShowWarLv and self.buildLvBg and not self.isShowWarLv then
		self.buildLvBg:setSpriteFrame("icon_main_build_warlv.png")
		self.isShowWarLv = true
	end
	if self:getBuildBid() == BUILDID.TURRET then
		self:updateIsLock()
	end
	if self:getBuildBid() == BUILDID.MIRACLE and isShowWarLv and 0 < textLv then
		self:showBuildLv()
	end
	self:updateViewModel()
	self:updateLvPos()
end
function cityBuildBaseEntity:udpateIsCanUpGrade()
	local bid = self:getBuildBid()
	local iid = self:getIid()
	if bid == 0 then
		return
	end
	if true == self:getIsOpening() then
		return
	end
	if self.isFixedBuild then
		return
	end
	local isCanUpgrade = buildLogic.isShowUpgrade(self:getBuildBid(), self:getIid())
	local buildCell = self:getBuildCell()
	if buildCell ~= nil then
		self:setIsCanUpgrade(isCanUpgrade)
	end
end
function cityBuildBaseEntity:updateStarLv(event, data)
	if data and data.index and data.index ~= self:getBuildIndex() then
		return
	end
	local buildCell = self:getBuildCell()
	if not buildCell then
		return
	end
	local starLv = self:getBuildStarLv()
	if 0 < starLv then
		self:updateStarLvBgLight()
	end
	self:udpateIsCanUpgradeStar()
	self:refreshBuildStarState(data)
	self:updateStarLvPos()
end
function cityBuildBaseEntity:checkBuildGuide()
end
function cityBuildBaseEntity:updateStarLvBgLight()
	local starLv = self:getBuildStarLv()
	self.buildLvBg:setSpriteFrame("icon_main_buildstar_lv.png")
	self:updateTextLv()
	if not self.spStarLight then
		local sprite = display.newSprite()
		sprite:addTo(self.buildLvBg)
		sprite:setPosition(83, 35)
		self.spStarLight = sprite
	end
	local iconName = cityltCtrl.getBuildStarLight(starLv, self:getBuildBid())
	self.spStarLight:setSpriteFrame(iconName)
	local level = cityltCtrl.getBuildStarColor(starLv, self:getBuildBid())
	local fileName = string.format("Node_buildStar_light_%d", level)
	local effect = self.buildStar_light
	if effect and effect:getName() ~= fileName then
		effect:removeFromParent()
		self.buildStar_light = nil
	end
	if not self.buildStar_light and getCCSPath(fileName) then
		local effect = SoraDCreatAnimation(fileName)
		effect:addTo(self.buildLvBg)
		effect:setPosition(83, 35)
		effect:setName(fileName)
		self.buildStar_light = effect
	end
end
function cityBuildBaseEntity:updateTextLv(...)
	local buildLv = self:getBuildLv()
	if self:getBuildState() == BUILD_STATE.BUILDING and buildLv == 1 then
		self:setTextLv(0)
		return
	end
	local isShowWarLv, textLv = SoraDGetBuildWarLv(buildLv)
	local starLv = self:getBuildStarLv()
	if 0 < starLv then
		self:setTextLv(string.format("%d-%d", textLv, starLv))
	else
		self:setTextLv(textLv)
	end
end
function cityBuildBaseEntity:udpateIsCanUpgradeStar()
	local bid = self:getBuildBid()
	local iid = self:getIid()
	if bid == 0 then
		return
	end
	if bid ~= BUILDID.CASTLE and guideCtrl:isGuideNotCompleted(gGuideModule.CITY_STAR_LV) then
		return
	end
	local isUnlock = buildLogic.isBuildingStarUnlock(bid, iid)
	if not isUnlock then
		self:setIsCanUpgradeStar(false)
		return
	end
	local starLv = self:getBuildStarLv()
	local reduce = buildLogic.getUpgradeStarCostReducePercent(bid, starLv)
	_ENV = nil
	;(nil).isQuick = true
	;(nil).totalReduceRate = reduce
	local ret, data = buildLogic.isCanUpgradeStar(bid, iid, nil)
	if not ret then
		self:setIsCanUpgradeStar(false)
		return
	end
	local err = buildLogic.checkUpgradeStarCond(OPERATE_MODE.NORMAL, data)
	if err == gErrDef.Err_None then
		self:setIsCanUpgradeStar(true)
	else
		self:setIsCanUpgradeStar(false)
	end
end
function cityBuildBaseEntity:refreshBuildStarState(data)
	if data then
		if data.queueType == gQueueTypeDef.build_star_queue then
			_ENV = gQueueTypeDef.build_star_queue
			gQueueTypeDef.build_star_queue.msg = "MESSAGE_MAINCITYVIEW_UPDATE_BUILDSTAR_COOLING_PANEL"
			gQueueTypeDef.build_star_queue.buildIndex = self.buildIndex
			gQueueTypeDef.build_star_queue.buildEntity = self
			SoraDSendMessage(gQueueTypeDef.build_star_queue)
		elseif data.queueType == gQueueTypeDef.build_star_queue_privilege then
			_ENV = gQueueTypeDef.build_star_queue_privilege
			gQueueTypeDef.build_star_queue_privilege.msg = "MESSAGE_MAINCITYVIEW_UPDATE_BUILDSTAR_SECOND_QUEUE_COOLING_PANEL"
			gQueueTypeDef.build_star_queue_privilege.buildIndex = self.buildIndex
			gQueueTypeDef.build_star_queue_privilege.buildEntity = self
			SoraDSendMessage(gQueueTypeDef.build_star_queue_privilege)
		end
	end
end
function cityBuildBaseEntity:initStateMachine()
	self.fsm_, _ENV = nil, nil
	cc.GameObject.extend(self.fsm_):addComponent("components.behavior.StateMachine"):exportMethods()
	_ENV, _UPVALUE6_, _ENV = nil, nil, "components.behavior.StateMachine"
	_UPVALUE6_, (nil).name = nil, "reset"
	;(nil).from, (nil)[1] = nil, "none"
	;(nil).from, (nil)[2] = nil, "locking"
	;(nil).from, (nil)[3] = nil, "building"
	;(nil).from, (nil)[4] = nil, "harvesting"
	;(nil).from, (nil)[5] = nil, "demolishing"
	;(nil).from, (nil)[6] = nil, "working"
	_ENV, (nil).to = nil, "idle"
	;(nil).name = "lock"
	;(nil).from = "none"
	_ENV, (nil).to = "none", "locking"
	_UPVALUE4_, ("none").name = "locking", "build"
	;("none").from, ("locking")[1] = "locking", "none"
	;("none").from, ("locking")[2] = "locking", "idle"
	;("none").from, ("locking")[3] = "locking", "working"
	;("none").from, ("locking")[4] = "locking", "harvesting"
	_ENV, ("none").to = "locking", "building"
	_UPVALUE3_, ("locking").name = "none", "work"
	;("locking").from, ("none")[1] = "none", "none"
	;("locking").from, ("none")[2] = "none", "idle"
	;("locking").from, ("none")[3] = "none", "harvesting"
	_ENV, ("locking").to = "none", "working"
	_UPVALUE3_, ("none").name = "none", "harvest"
	;("none").from, ("none")[1] = "none", "none"
	;("none").from, ("none")[2] = "none", "idle"
	;("none").from, ("none")[3] = "none", "working"
	_ENV, ("none").to = "none", "harvesting"
	_UPVALUE4_, ("none").name = "none", "demolish"
	;("none").from, ("none")[1] = "none", "none"
	;("none").from, ("none")[2] = "none", "idle"
	;("none").from, ("none")[3] = "none", "working"
	;("none").from, ("none")[4] = "none", "harvesting"
	;("none").to = "demolishing"
	_ENV, ("components.behavior.StateMachine").events, (nil)[1] = nil, nil, nil
	_ENV, ("components.behavior.StateMachine").events, (nil)[2] = nil, nil, nil
	_ENV, ("components.behavior.StateMachine").events, (nil)[3] = nil, nil, "none"
	_ENV, ("components.behavior.StateMachine").events, (nil)[4] = nil, nil, "locking"
	_ENV, ("components.behavior.StateMachine").events, (nil)[5] = nil, nil, "none"
	_ENV, ("components.behavior.StateMachine").events, (nil)[6] = nil, nil, "none"
	;(nil).onbeforereset = handler(self, self.onbeforereset)
	;(nil).onafterreset = handler(self, self.onafterreset)
	;(nil).onbeforelock = handler(self, self.onbeforelock)
	;(nil).onafterlock = handler(self, self.onafterlock)
	;(nil).onbeforebuild = handler(self, self.onbeforebuild)
	;(nil).onafterbuild = handler(self, self.onafterbuild)
	;(nil).onbeforework = handler(self, self.onbeforework)
	;(nil).onafterwork = handler(self, self.onafterwork)
	;(nil).onbeforedemolish = handler(self, self.onbeforedemolish)
	;(nil).onafterdemolish = handler(self, self.onafterdemolish)
	;(nil).onbeforeharvest = handler(self, self.onbeforeharvest)
	;(nil).onafterharvest = handler(self, self.onafterharvest)
	;(nil).onenteridle = handler(self, self.onenteridle)
	;(nil).onleaveidle = handler(self, self.onleaveidle)
	;(nil).onenterlocking = handler(self, self.onenterlocking)
	;(nil).onleavelocking = handler(self, self.onleavelocking)
	;(nil).onenterbuilding = handler(self, self.onenterbuilding)
	;(nil).onleavebuilding = handler(self, self.onleavebuilding)
	;(nil).onenterworking = handler(self, self.onenterworking)
	;(nil).onleaveworking = handler(self, self.onleaveworking)
	;(nil).onenterdemolishing = handler(self, self.onenterdemolishing)
	;(nil).onleavedemolishing = handler(self, self.onleavedemolishing)
	;(nil).onenterharvesting = handler(self, self.onenterharvesting)
	;(nil).onleaveharvesting = handler(self, self.onleaveharvesting)
	;(nil).onchangestate = handler(self, self.onchangestate)
	;(nil).onbeforeevent = handler(self, self.onbeforeevent)
	;(nil).onafterevent = handler(self, self.onafterevent)
	;(nil).onenterstate = handler(self, self.onenterstate)
	;("components.behavior.StateMachine").callbacks, (nil).onleavestate = nil, handler(self, self.onleavestate)
	self.fsm_:setupState("components.behavior.StateMachine")
end
function cityBuildBaseEntity:onbeforereset(event)
end
function cityBuildBaseEntity:onbeforelock(event)
end
function cityBuildBaseEntity:onbeforebuild(event)
end
function cityBuildBaseEntity:onbeforework(event)
end
function cityBuildBaseEntity:onbeforedemolish(event)
end
function cityBuildBaseEntity:onafterreset(event)
	self:hideAnimBuildWorker()
	self:hideAnimWorking()
	self:hideGlow()
	self:hideWorkDone()
	self:showZAnimation()
	self:setHarvestState(CITYBUILD_HARVESTSTATE.CITYBUILD_HARVESTSTATE_NONE, false)
	self.isCanSpeedUpFree = false
	self.isCancel = false
	local bid = self:getBuildBid()
	self:setQueueDirty(true)
	if bid ~= nil and bid == BUILDID.HOSTPITAL and true == self:getIsTraining() then
		self:setBlockState("working")
		self:changeState()
	end
	if bid ~= nil and bid == BUILDID.EMBASSY then
		self:updateAllianceHelpList()
	end
	self:updateViewAfterReset()
	if self:getIsCanSpeedUpStrongFree() or self:getIsNeedReqHelp() then
		self:showTopTipEffect()
	end
	if bid ~= nil and bid == BUILDID.ELITE_PALACE then
		self:hideZAnimation()
	end
end
function cityBuildBaseEntity:onafterlock(event)
end
function cityBuildBaseEntity:onafterbuild(event)
	self:setQueueDirty(true)
	local bid = tonumber(self:getBuildBid())
	local iid = tonumber(self:getIid())
	local queueType = tonumber(buildLogic.getQueueType(bid, iid))
	if queueType == nil then
		self:setBlockState("idle")
		self:changeState()
		self:updateLv()
		return
	else
		self.queueType = queueType
	end
	local queue = queueCtrl:queryQueue(queueType)
	if queue == nil then
		self:setBlockState("idle")
		self:changeState()
		self:updateLv()
		return
	else
		self.queue = queue
	end
	local remainTime = self.queue.timerNode.timer:getRemainTime()
	if remainTime <= 0 then
		self:setBlockState("idle")
		self:changeState()
		self:updateLv()
		return
	end
	self:showAnimBuildWorker()
	self:showCoolingPanel()
end
function cityBuildBaseEntity:onafterwork(event)
	print("[FSM] FINISH EVENT: work")
	self:setQueueDirty(true)
	self:showAnimWorking()
	local bid = self:getBuildBid()
	if bid == BUILDID.FARM or bid == BUILDID.SAWMILL or bid == BUILDID.IRON_MINE or bid == BUILDID.STEEL or bid == BUILDID.CRYSTAL_MINE then
	else
		self:showCoolingPanel()
	end
end
function cityBuildBaseEntity:onafterdemolish(event)
	local bid = tonumber(self:getBuildBid())
	local iid = tonumber(self:getIid())
	local queueType = tonumber(buildLogic.getQueueType(bid, iid))
	if queueType == nil then
		return
	else
		self.queueType = queueType
	end
	local queue = queueCtrl:queryQueue(queueType)
	if queue == nil then
		return
	else
		self.queue = queue
	end
	local remainTime = self.queue.timerNode.timer:getRemainTime()
	if remainTime <= 0 then
		self:setBlockState("idle")
		self:changeState()
		self:updateLv()
		return
	end
	self:showAnimBuildWorker()
	self:showCoolingPanel()
end
function cityBuildBaseEntity:onenteridle(event)
end
function cityBuildBaseEntity:onleaveidle(event)
end
function cityBuildBaseEntity:onenterlocking(event)
end
function cityBuildBaseEntity:onleavelocking(event)
end
function cityBuildBaseEntity:onenterbuilding(event)
end
function cityBuildBaseEntity:onleavebuilding(event)
	if not self:getIsCancel() and not self:getIsReconnected() then
		self:showEffectUpgrade()
	end
	local bid = self:getBuildBid()
	if bid == BUILDID.WISHING_WELL then
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_UPDATE_WISHINGWELL_VIEW"
		SoraDSendMessage(nil)
	end
	self:updateViewAfterBuild()
end
function cityBuildBaseEntity:onenterworking(event)
end
function cityBuildBaseEntity:onleaveworking(event)
end
function cityBuildBaseEntity:onenterdemolishing(event)
end
function cityBuildBaseEntity:onleavedemolishing(event)
end
function cityBuildBaseEntity:onchangestate(event)
end
function cityBuildBaseEntity:onbeforeevent(event)
end
function cityBuildBaseEntity:onafterevent(event)
end
function cityBuildBaseEntity:onenterstate(event)
end
function cityBuildBaseEntity:onleavestate(event)
end
function cityBuildBaseEntity:onbeforeharvest(event)
end
function cityBuildBaseEntity:onafterharvest(event)
	self:setQueueDirty(true)
	if self:getBuildState() ~= BUILD_STATE.NORMAL then
		return
	end
	self:showWorkDone()
end
function cityBuildBaseEntity:onenterharvesting(event)
end
function cityBuildBaseEntity:onleaveharvesting(event)
end
function cityBuildBaseEntity:changeState()
	local fsmState = self:getState()
	if fsmState == self.blockState then
		return
	end
	if self.blockState == "idle" then
		self.fsm_:doEvent("reset")
	elseif self.blockState == "locking" then
		self.fsm_:doEvent("lock")
	elseif self.blockState == "building" then
		self.fsm_:doEvent("build")
	elseif self.blockState == "working" then
		self.fsm_:doEvent("work")
	elseif self.blockState == "demolishing" then
		self.fsm_:doEvent("demolish")
	elseif self.blockState == "harvesting" then
		self.fsm_:doEvent("harvest")
	end
end
function cityBuildBaseEntity:getState()
	return self.fsm_:getState()
end
function cityBuildBaseEntity:showGlow()
	local buildLv = self:getBuildLv()
	local isWarLv, warLv = buildLogic.isBuildWarLv(buildLv)
	if isWarLv and warLv >= CASTLE_MIN_WARLV then
		local buildGlowWar = self.buildGlowWar
		if buildGlowWar == nil then
			buildGlowWar = self:loadNodeByName("buildGlowWar")
		end
		if buildGlowWar == nil then
			self:loadNodeByName("buildGlow")
		end
	else
		local buildGlow = self.buildGlow
		if buildGlow == nil then
			buildGlow = self:loadNodeByName("buildGlow")
		end
	end
end
function cityBuildBaseEntity:hideGlow()
	local buildGlow = self.buildGlow
	if buildGlow then
		buildGlow:stopAllActions()
		cityBuildFunction:removeFromRelyOnTable(self.tblNodeRelyOn, buildGlow)
		buildGlow:removeFromParent()
		self.buildGlow = nil
	end
	local buildGlowWar = self.buildGlowWar
	if buildGlowWar then
		buildGlowWar:stopAllActions()
		cityBuildFunction:removeFromRelyOnTable(self.tblNodeRelyOn, buildGlowWar)
		buildGlowWar:removeFromParent()
		self.buildGlowWar = nil
	end
end
function cityBuildBaseEntity:showCoolingPanel()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_COOLING_PANEL"
	;(nil).buildIndex = self.buildIndex
	;(nil).buildEntity = self
	SoraDSendMessage(nil)
end
function cityBuildBaseEntity:hideCoolingPanel()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_COOLING_PANEL"
	;(nil).buildIndex = self.buildIndex
	;(nil).buildEntity = self
	SoraDSendMessage(nil)
end
function cityBuildBaseEntity:showAnimWorking(showGlow)
	self:hideZAnimation()
	local showGlow = showGlow or true
	if showGlow then
		self:showGlow()
	else
		self:hideGlow()
	end
	for i = 1, 10 do
		local nodeName = "buildAnimationType1_" .. i
		local nodeCfgItem = self:getCfgItemByName(nodeName)
		if nodeCfgItem ~= nil and self[nodeName] ~= nil then
			break
		end
		local node = self:loadNodeByName(nodeName)
		if node == nil then
			break
		end
	end
	if self:getBuildBid() == BUILDID.BLACK_SMITH then
		self:showNormalParticle()
	end
	if self:getBuildBid() == BUILDID.MATERIAL_WORKSHOP then
		self:showNormalParticle()
		self:showAnimWorkingSpecific()
	end
	self:showWorkingEffect()
end
function cityBuildBaseEntity:showAnimWorkingSpecific()
end
function cityBuildBaseEntity:hideAnimWorkingSpecific()
end
function cityBuildBaseEntity:hideAnimWorking()
	self:hideGlow()
	for i = 1, 10 do
		local nodeName = "buildAnimationType1_" .. i
		local node = self[nodeName]
		cityBuildFunction:removeFromRelyOnTable(self.tblNodeRelyOn, node)
		if node ~= nil then
			self[nodeName] = nil
			node:removeFromParent()
		else
			break
		end
	end
	if self:getBuildBid() == BUILDID.BLACK_SMITH then
		self:hideNormalParticle()
	end
	if self:getBuildBid() == BUILDID.MATERIAL_WORKSHOP then
		self:hideNormalParticle()
		self:hideAnimWorkingSpecific()
	end
	self:removeWorkingEffect()
end
function cityBuildBaseEntity:showAnimNormal()
end
function cityBuildBaseEntity:hideAnimNormal()
end
function cityBuildBaseEntity:showAnimBoost()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_ANIM_BOOST"
	;(nil).buildIndex = self.buildIndex
	;(nil).buildEntity = self
	SoraDSendMessage(nil)
end
function cityBuildBaseEntity:hideAnimBoost()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_ANIM_BOOST"
	;(nil).buildIndex = self.buildIndex
	;(nil).buildEntity = self
	SoraDSendMessage(nil)
end
function cityBuildBaseEntity:showAnimBuildWorker(isHideHammer)
	self:hideZAnimation()
	print(self.buildIndex)
	_ENV = self.buildIndex
	self.buildIndex.msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_ANIM_WORKER"
	self.buildIndex.buildIndex = self.buildIndex
	self.buildIndex.buildEntity = self
	self.buildIndex.isHideHammer = isHideHammer
	SoraDSendMessage(self.buildIndex)
end
function cityBuildBaseEntity:autoUpdateState()
end
function cityBuildBaseEntity:hideAnimBuildWorker()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_ANIM_WORKER"
	;(nil).buildIndex = self.buildIndex
	;(nil).buildEntity = self
	SoraDSendMessage(nil)
end
function cityBuildBaseEntity:showNormalParticle()
	for i = 1, 10 do
		local nodeName = "buildParticleNormal_" .. i
		local nodeCfgItem = self:getCfgItemByName(nodeName)
		if nodeCfgItem ~= nil and self[nodeName] ~= nil then
			break
		end
		local node = self:loadNodeByName(nodeName)
		if node == nil then
			break
		end
	end
	self:loadNodeByName("buildCsdNormal")
end
function cityBuildBaseEntity:hideNormalParticle()
	for i = 1, 10 do
		local nodeName = "buildParticleNormal_" .. i
		local node = self[nodeName]
		if node ~= nil then
			self[nodeName] = nil
			node:removeFromParent()
		else
			break
		end
	end
	local nodeName = "buildCsdNormal"
	local node = self[nodeName]
	if node ~= nil then
		self[nodeName] = nil
		node:removeFromParent()
	end
end
function cityBuildBaseEntity:showBrightParticle()
	for i = 1, 10 do
		local nodeName = "buildParticleBright_" .. i
		local nodeCfgItem = self:getCfgItemByName(nodeName)
		if nodeCfgItem ~= nil and self[nodeName] ~= nil then
			break
		end
		local node = self:loadNodeByName(nodeName)
		if node == nil then
			break
		end
	end
	self:loadNodeByName("buildCsdBright")
end
function cityBuildBaseEntity:hideBrightParticle()
	for i = 1, 10 do
		local nodeName = "buildParticleBright_" .. i
		local node = self[nodeName]
		if node ~= nil then
			self[nodeName] = nil
			node:removeFromParent()
		else
			break
		end
	end
	local nodeName = "buildCsdBright"
	local node = self[nodeName]
	if node ~= nil then
		self[nodeName] = nil
		node:removeFromParent()
	end
end
function cityBuildBaseEntity:showEffectUpgrade()
	local buildIndex = self:getBuildIndex()
	local posEtUpgradeOffset = cc.p(self.posEtUpgradeOffset.x, self.posEtUpgradeOffset.y)
	_ENV = self.posEtUpgradeOffset.y
	self.posEtUpgradeOffset.y.msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_EFFECT_UPGRADE"
	self.posEtUpgradeOffset.y.buildIndex = buildIndex
	self.posEtUpgradeOffset.y.posEtUpgradeOffset = posEtUpgradeOffset
	SoraDSendMessage(self.posEtUpgradeOffset.y)
end
function cityBuildBaseEntity:beginTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
		self.timeHandler = nil
	end
	self:updateTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function cityBuildBaseEntity:endTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
		self.timeHandler = nil
	end
end
function cityBuildBaseEntity:getCurrentHarvest()
	local currentHarvest = 0
	local buildCell = self:getBuildCell()
	if buildCell and buildCell.info and buildCell.info.curres then
		currentHarvest = math.floor(tonumber(buildCell.info.curres))
	else
		currentHarvest = 0
	end
	return currentHarvest
end
function cityBuildBaseEntity:getMaxHarvest()
	local bid = self:getBuildBid()
	local lv = self:getBuildLv()
	local iid = self:getIid()
	local outputmax = buildLogic.getResOututMaxCount(bid, lv, iid)
	local maxCount = outputmax.total
	return maxCount
end
function cityBuildBaseEntity:getIsHarvestMuch(currentCount, maxCount)
	local percentage = currentCount / maxCount
	if 0.0167 <= percentage then
		return true
	end
	return false
end
function cityBuildBaseEntity:updateTime(time)
	local buildState = self:getBuildState()
	if buildState == BUILD_STATE.BUILDING or buildState == BUILD_STATE.UPGRADEING or buildState == BUILD_STATE.DEMOLISHING or buildState == BUILD_STATE.LOCK then
		return
	end
	local bid = self:getBuildBid()
	local iid = self:getIid()
	self:updateBuff()
	local currentHarvest = self:getCurrentHarvest()
	local maxHarvest = self:getMaxHarvest()
	local harvestState = self:getHarvestState()
	if currentHarvest == 0 and "working" ~= self:getState() then
		self:setBlockState("working")
		self:changeState()
	end
	if 0 < currentHarvest and harvestState == CITYBUILD_HARVESTSTATE.CITYBUILD_HARVESTSTATE_NONE then
		if "working" ~= self:getState() then
			self:setBlockState("working")
			self:changeState()
		end
		self:setHarvestState(CITYBUILD_HARVESTSTATE.CITYBUILD_HARVESTSTATE_SOME, true)
	end
	if true == self:getIsHarvestMuch(currentHarvest, maxHarvest) and harvestState == CITYBUILD_HARVESTSTATE.CITYBUILD_HARVESTSTATE_SOME then
		self:setHarvestState(CITYBUILD_HARVESTSTATE.CITYBUILD_HARVESTSTATE_MUCH, true)
		self:setBlockState("harvesting")
		self:changeState()
		if self.turnToHarvestView then
			self:turnToHarvestView(true)
		end
	end
end
function cityBuildBaseEntity:getHarvestState()
	return self.harvestState
end
function cityBuildBaseEntity:setHarvestState(harvestState, bShowAnimation)
	if self.harvestState == harvestState then
		return
	end
	self.harvestState = harvestState
	if self.harvestState == CITYBUILD_HARVESTSTATE.CITYBUILD_HARVESTSTATE_NONE then
		if bShowAnimation == true then
		else
		end
	elseif self.harvestState == CITYBUILD_HARVESTSTATE.CITYBUILD_HARVESTSTATE_SOME then
		if bShowAnimation == true then
		else
		end
	elseif self.harvestState == CITYBUILD_HARVESTSTATE.CITYBUILD_HARVESTSTATE_MUCH then
	end
end
function cityBuildBaseEntity:getBuildState()
	local buildCell = self:getBuildCell()
	if nil == buildCell then
		return 0
	end
	return tonumber(buildCell.info.state)
end
function cityBuildBaseEntity:getBuildStarState()
	local buildCell = self:getBuildCell()
	if nil == buildCell then
		return 0
	end
	return tonumber(buildCell.info.stateEx)
end
function cityBuildBaseEntity:getIsCanSpeedUpFree()
	return self.isCanSpeedUpFree
end
function cityBuildBaseEntity:setIsCanSpeedUpFree(isCanSpeedUpFree)
	self.isCanSpeedUpFree = isCanSpeedUpFree
end
function cityBuildBaseEntity:getIsCanSpeedUpStrongFree()
	return self.isCanSpeedUpStrongFree
end
function cityBuildBaseEntity:setIsCanSpeedUpStrongFree(isCanSpeedUpStrongFree)
	self.isCanSpeedUpStrongFree = isCanSpeedUpStrongFree
end
function cityBuildBaseEntity:getIsCanResearchFree()
	return self.isCanResearchFree
end
function cityBuildBaseEntity:setIsCanResearchFree(isCanResearchFree)
	self.isCanResearchFree = isCanResearchFree
end
function cityBuildBaseEntity:getIsNeedReqHelp()
	if not self:getReqHelpQueueTypeList() then
		local _UPVALUE0_, queueTypeList = self:getReqHelpQueueTypeList(), self:getReqHelpQueueTypeList()
	end
	return 0 < #queueTypeList
end
function cityBuildBaseEntity:getReqHelpQueueTypeList(...)
	local queueCtrl, ret
	local queueType = self:getQueueType()
	if queueType and queueCtrl:isNeedReqHelp(queueType) then
		table.insert(ret, queueType)
	end
	local queueType = self:getBuildStarQueueType()
	if queueType and queueCtrl:isNeedReqHelp(queueType) then
		table.insert(ret, queueType)
	end
	return ret
end
function cityBuildBaseEntity:doReqHelp()
	if not self:getReqHelpQueueTypeList() then
		local _ENV, queueTypeList = self:getReqHelpQueueTypeList(), self:getReqHelpQueueTypeList()
	end
	for i, queueType in ipairs(queueTypeList) do
		self:doReqHelpByQueueType(queueType)
	end
end
function cityBuildBaseEntity:doReqHelpByQueueType(queueType)
	local _ENV, data
	local bid = self:getBuildBid()
	if queueType == gQueueTypeDef.build_star_queue or queueType == gQueueTypeDef.build_star_queue_privilege or queueType == gQueueTypeDef.glorious_upgrade then
		_ENV = gQueueTypeDef.glorious_upgrade
		gQueueTypeDef.glorious_upgrade.bid = self:getBuildBid()
		data, gQueueTypeDef.glorious_upgrade.starLv = gQueueTypeDef.glorious_upgrade, self:getBuildStarLv() + 1
	elseif self:getBuildState() == BUILD_STATE.NORMAL then
		if bid == BUILDID.HOSTPITAL then
			data = nil
		elseif bid == BUILDID.COLLEGE then
			local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
			local collegeData = technologyCtrl:studyingTechnology()
			_ENV = technologyCtrl
			data, technologyCtrl.techid = technologyCtrl, tonumber(collegeData.technologyID)
		elseif bid == BUILDID.MIRACLE then
			local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
			local collegeData = technologyCtrl:studyingTechnology(gQueueTypeDef.war_tech_research)
			_ENV = technologyCtrl
			data, technologyCtrl.techid = technologyCtrl, tonumber(collegeData.technologyID)
		elseif bid == BUILDID.BLACK_SMITH then
			local eid, count = self:getTrainingAidAndCount()
			_ENV = technologyCtrl
			data, technologyCtrl.equipid = technologyCtrl, eid
		elseif bid == BUILDID.STAR_BRAVE_STATUE then
			local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
			local collegeData = technologyCtrl:studyingTechnology(queueType)
			dump(collegeData, "collegeData")
			_ENV = dump
			data, dump.techid = dump, tonumber(collegeData.technologyID)
		else
			data = nil
		end
	elseif self:getBuildState() == BUILD_STATE.BUILDING or self:getBuildState() == BUILD_STATE.UPGRADEING then
		_ENV = self:getBuildState()
		self:getBuildState().bid = self:getBuildBid()
		data, self:getBuildState().blv = self:getBuildState(), self:getBuildLv() + 1
	end
	allianceHelp:reqAllianceHelp(queueType, data)
end
function cityBuildBaseEntity:doSpeedUpFree()
	local queue = self:getQueue()
	if queue ~= nil then
		queueCtrl:speedUpQueueReq(tonumber(queue.qtype), SPEEDUP_TYPE.FREE)
	end
end
function cityBuildBaseEntity:doSpeedUpStrongFree()
	local queueType = self:getBuildStarQueueType()
	if queueType then
		queueCtrl:speedUpQueueReq(queueType, SPEEDUP_TYPE.FREE)
	end
end
function cityBuildBaseEntity:doSpeedUpResearchFree()
	local queue = self:getQueue()
	if queue ~= nil then
		queueCtrl:speedUpQueueReq(tonumber(queue.qtype), SPEEDUP_TYPE.FREE)
	end
end
function cityBuildBaseEntity:getIsCanHarvestTrain()
	local isCanHarvestTrain = false
	local bid = self:getBuildBid()
	if bid == BUILDID.BLACK_SMITH then
		local gametop = gModuleMgr.getObject("gametop")
		local equipmentCtrl = gametop.playertop_:getModule("equipmentCtrl")
		return equipmentCtrl:canGetEquipment()
	elseif bid == BUILDID.MATERIAL_WORKSHOP then
		local stuffWorkshopCtrl = gametop.playertop_:getModule("stuffWorkshopCtrl")
		local doneId = stuffWorkshopCtrl:getDoneID()
		return doneId ~= nil and doneId ~= 0
	end
	if bid == BUILDID.ELITE_PALACE then
		print("elite")
	end
	local trainedArmy = armyCtrl:getTrainArmy(bid)
	if trainedArmy ~= nil then
		self.trainedArmy = trainedArmy
		isCanHarvestTrain = true
	end
	return isCanHarvestTrain
end
function cityBuildBaseEntity:getIsTraining()
	local bTraining = false
	local bid = self:getBuildBid()
	local queueType
	queueType = buildRead.getQueueType(bid)
	local queue = queueCtrl:queryQueue(queueType)
	if queue == nil then
		bTraining = false
	else
		bTraining = false
		if self:getBuildState() == BUILD_STATE.NORMAL then
			local remainTime = queue.timerNode.timer:getRemainTime()
			if remainTime <= 0 then
				bTraining = false
			else
				bTraining = true
			end
		end
	end
	return bTraining
end
function cityBuildBaseEntity:getPromotingQueue()
	local queueType = gQueueTypeDef.prompt_army
	local queue = queueCtrl:queryQueue(queueType)
	return queue
end
function cityBuildBaseEntity:getTrainingQueue()
	local bid = self:getBuildBid()
	local queueType = buildRead.getQueueType(bid)
	if queueType == nil then
		return
	end
	local queue = queueCtrl:queryQueue(queueType)
	return queue
end
function cityBuildBaseEntity:setQueueDirty(v)
	self.queueDirty = v
end
function cityBuildBaseEntity:getQueue()
	if self.queue ~= nil and self.queueDirty ~= true then
		return self.queue
	else
		if self:getIsTraining() then
			self.queue = self:getTrainingQueue()
		else
			self.queue = self:getBuildQueue()
		end
		self.queueDirty = false
	end
	return self.queue
end
function cityBuildBaseEntity:getBuildQueue()
	local bid = self:getBuildBid()
	local iid = self:getIid()
	local queueType = tonumber(buildLogic.getQueueType(bid, iid))
	if queueType == nil then
		return
	end
	return queueCtrl:queryQueue(queueType)
end
function cityBuildBaseEntity:getQueueType()
	local queueType
	if self:getIsTraining() then
		queueType = self:getTrainingQueueType()
	else
		queueType = self:getBuildQueueType()
	end
	return queueType
end
function cityBuildBaseEntity:getTrainingQueueType()
	local bid = self:getBuildBid()
	local queueType = tonumber(buildRead.getQueueType(bid))
	return queueType
end
function cityBuildBaseEntity:getBuildQueueType()
	local bid = self:getBuildBid()
	local iid = self:getIid()
	local queueType = tonumber(buildLogic.getQueueType(bid, iid))
	return queueType
end
function cityBuildBaseEntity:getBuildStarQueueType()
	local queue = self:getBuildStarQueue()
	if queue == nil then
		queue = self:getBuildStarSecondQueue()
	end
	if queue == nil then
		queue = self:getBuildStatueBraveQueue()
	end
	if queue then
		return tonumber(queue.qtype)
	end
end
function cityBuildBaseEntity:getBuildStarQueue(...)
	local bid = self:getBuildBid()
	local iid = self:getIid()
	local queue = queueCtrl:queryQueue(gQueueTypeDef.build_star_queue)
	if queue and tonumber(queue.data.bid) == tonumber(bid) and tonumber(queue.data.iid) == tonumber(iid) then
		return queue
	end
end
function cityBuildBaseEntity:getBuildStarSecondQueue(...)
	local bid = self:getBuildBid()
	local iid = self:getIid()
	local queue = queueCtrl:queryQueue(gQueueTypeDef.build_star_queue_privilege)
	if queue and tonumber(queue.data.bid) == tonumber(bid) and tonumber(queue.data.iid) == tonumber(iid) then
		return queue
	end
end
function cityBuildBaseEntity:getBuildStatueBraveQueue(...)
	local bid = self:getBuildBid()
	local iid = self:getIid()
	local queue = queueCtrl:queryQueue(gQueueTypeDef.glorious_upgrade)
	if queue and tonumber(queue.data.bid) == tonumber(bid) then
		return queue
	end
end
function cityBuildBaseEntity:getBuildDiggingQueue(...)
	local bid = self:getBuildBid()
	local queue = queueCtrl:queryQueue(gQueueTypeDef.endless_treasure_queue)
	if queue and bid == BUILDID.WISHING_WELL then
		return queue
	end
end
function cityBuildBaseEntity:getHasSpeedUpCooling()
	if self:getBuildBid() == BUILDID.HOSTPITAL and worldMapDefine.isInPyramid() then
		local cdQueue = armyCtrl:getHostpitalPyramidWarCDQueueTime()
		if 0 < cdQueue then
			return true
		end
	end
	return false
end
function cityBuildBaseEntity:getSpeedUpCoolingTime()
	if self:getBuildBid() == BUILDID.HOSTPITAL then
		return armyCtrl:getHostpitalPyramidWarCDQueueTime()
	end
	return 0
end
function cityBuildBaseEntity:doHarvesting()
	local buildType = SoraDGetBuildTypeByBid(self:getBuildBid())
	local bid = self:getBuildBid()
	print("cityBuildBaseEntity:doHarvestin:", bid)
	if buildType == 0 then
		if bid == BUILDID.STABLES or bid == BUILDID.RANGE or bid == BUILDID.BARRACKS or bid == BUILDID.FORTRESS or bid == BUILDID.CHARIOT_PLANT or bid == BUILDID.BLACK_SMITH or bid == BUILDID.MATERIAL_WORKSHOP or bid == BUILDID.ELITE_PALACE then
			self:harvestTrainArmy()
		else
			self.fsm_:doEvent("reset")
		end
	elseif bid == BUILDID.MATERIAL_WORKSHOP then
		self:harvestTrainArmy()
	else
		self:harvestRes()
	end
end
function cityBuildBaseEntity:harvestTrainArmy()
	local bid = self:getBuildBid()
	SoraDPlaySound("trainsoilder", bid)
	if bid == BUILDID.BLACK_SMITH then
		SoraDGetEquip()
	elseif bid == BUILDID.MATERIAL_WORKSHOP then
		local stuffWorkshopCtrl = gametop.playertop_:getModule("stuffWorkshopCtrl")
		stuffWorkshopCtrl:sendGetStuff()
	else
		if (bid == BUILDID.STABLES or bid == BUILDID.RANGE or bid == BUILDID.CHARIOT_PLANT or bid == BUILDID.BARRACKS or bid == BUILDID.FORTRESS or bid == BUILDID.ELITE_PALACE) and worldMapDefine.isInWarForbidSoldier() then
			return
		end
		armyCtrl:getTrainArmyReq(bid)
	end
end
function cityBuildBaseEntity:harvestRes()
	local bid = self:getBuildBid()
	local iid = self:getIid()
	local buildType = SoraDGetBuildTypeByBid(bid)
	local index = tonumber(self:getBuildIndex())
	if buildType == 0 then
	else
		_ENV = self:getBuildIndex()
		self:getBuildIndex().msg = "MESSAGE_MAINCITYVIEW_ADD_HARVEST_FLOATING"
		self:getBuildIndex().index = self:getBuildIndex()
		self:getBuildIndex().buildEntity = self
		SoraDSendMessage(self:getBuildIndex())
		self:setHarvestState(CITYBUILD_HARVESTSTATE.CITYBUILD_HARVESTSTATE_NONE, false)
	end
	SoraDPlaySound("trainsoilder", bid)
	cityCtrl:collectResReq(bid, iid)
	self.fsm_:doEvent("reset")
	if self.turnToNormalView then
		self:turnToNormalView(true)
	end
end
function cityBuildBaseEntity:harvestBatchRes()
	local bid = self:getBuildBid()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_COLLECT_BATCH_RES"
	;(nil).bid = bid
	SoraDSendMessage(nil)
end
function cityBuildBaseEntity:canHarvestBatchRes()
	local bid = self:getBuildBid()
	if gCanHarvestBatchRes[bid] then
		return true
	else
		return false
	end
end
function cityBuildBaseEntity:buildButtonCallFun(ref, type)
	if type == ccui.TouchEventType.began then
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_BUILD_BTN_EVENT"
		;(nil).index = self:getBuildIndex()
		;(nil).ref = ref
		;(nil).eventType = type
		SoraDSendMessage(nil)
	elseif type == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINCITYVIEW_BUILD_BTN_EVENT"
			;(nil).index = self:getBuildIndex()
			;(nil).ref = ref
			;(nil).eventType = ccui.TouchEventType.canceled
			SoraDSendMessage(nil)
			return
		end
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_BUILD_BTN_EVENT"
		;(nil).index = self:getBuildIndex()
		;(nil).ref = ref
		;(nil).eventType = type
		SoraDSendMessage(nil)
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = ref:getTouchBeganPosition()
		local touchmovePoint = ref:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		_ENV = ref:getTouchMovePosition()
		ref:getTouchMovePosition().msg = "MESSAGE_MAINCITYVIEW_BUILD_BTN_EVENT"
		ref:getTouchMovePosition().index = self:getBuildIndex()
		ref:getTouchMovePosition().ref = ref
		ref:getTouchMovePosition().eventType = type
		SoraDSendMessage((ref:getTouchMovePosition()))
		self.singleIsMoved = false
	end
end
function cityBuildBaseEntity:showLock()
	local img_lock = self.img_lock
	if img_lock then
		img_lock:setVisible(true)
	end
end
function cityBuildBaseEntity:hideLock()
	local img_lock = self.img_lock
	if img_lock then
		img_lock:setVisible(false)
	end
end
function cityBuildBaseEntity:getIsLockVisible()
	local isLockVisible = false
	local bid = self:getBuildBid()
	if bid == BUILDID.CRYSTAL_MINE then
		local castleBid = BUILDID.CASTLE
		local buildCell = cityCtrl:getBuildCell(castleBid, 0)
		if nil == buildCell then
			return isLockVisible
		end
		local castleLv = tonumber(buildCell.info.lv)
		if castleLv < 30 then
			isLockVisible = true
		end
	end
	return isLockVisible
end
function cityBuildBaseEntity:getIsLocked(tempbid)
	local isLocked = false
	local bid = tempbid ~= nil and tempbid or self:getBuildBid()
	local unlocklevel = cityltCtrl.buildAttr(tonumber(bid), BUILD_ATTR.UNLOCKLEVEL)
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	if not lordInfoCtrl:isNewLord() then
		unlocklevel = cityltCtrl.buildAttr(tonumber(bid), BUILD_ATTR.OLDUNLOCKLEVEL)
	end
	if unlocklevel then
		local buildCell = cityCtrl:getBuildCell(BUILDID.CASTLE, 0)
		if buildCell then
			local castleLv = tonumber(buildCell.info.lv)
			isLocked = unlocklevel > castleLv
		end
		if bid == BUILDID.NEBULA_PALACE then
			local nebulaPalaceCell = cityCtrl:getBuildCell(bid, 0)
			isLocked = isLocked or nebulaPalaceCell == nil or tonumber(nebulaPalaceCell.info.state) == BUILD_STATE.LOCK
		elseif bid == BUILDID.MAGIC_LAMP then
			isLocked = isLocked or not SoraDGetCtrl("magicLampCtrl"):getIsUnlock()
		elseif bid == BUILDID.NEWBORN_TREE then
			isLocked = isLocked or not SoraDGetCtrl("divineBeastCtrl"):getIsUnlock()
		elseif bid == BUILDID.STAR_BRAVE_STATUE then
			isLocked = isLocked or 0 >= self:getBuildStarLv()
		end
		return isLocked, unlocklevel
	else
		if bid == BUILDID.TURRET then
			local castleBid = BUILDID.CASTLE
			local buildCell = cityCtrl:getBuildCell(castleBid, 0)
			if nil == buildCell then
				return isLocked
			end
			local castleLv = tonumber(buildCell.info.lv)
			if castleLv >= CASTLE_LV7_LIMITED then
				isLocked = false
			else
				isLocked = true
			end
		elseif bid == BUILDID.BLACK_SMITH then
			local castleBid = BUILDID.CASTLE
			local buildCell = cityCtrl:getBuildCell(castleBid, 0)
			if nil == buildCell then
				return isLocked
			end
			local castleLv = tonumber(buildCell.info.lv)
			if castleLv >= CASTLE_LV10_LIMITED then
				isLocked = false
			else
				isLocked = true
			end
		elseif bid == BUILDID.MATERIAL_WORKSHOP then
			local castleBid = BUILDID.CASTLE
			local buildCell = cityCtrl:getBuildCell(castleBid, 0)
			if nil == buildCell then
				return isLocked
			end
			local castleLv = tonumber(buildCell.info.lv)
			if castleLv >= CASTLE_LV10_LIMITED then
				isLocked = false
			else
				isLocked = true
			end
		elseif bid == cityBuildConstDef.fixedBuildDef.PetCenter then
			local castleBid = BUILDID.CASTLE
			local buildCell = cityCtrl:getBuildCell(castleBid, 0)
			if nil == buildCell then
				return isLocked, CASTLE_LV16_LIMITED
			end
			local castleLv = tonumber(buildCell.info.lv)
			if castleLv >= CASTLE_LV16_LIMITED then
				isLocked = false
			else
				isLocked = true
			end
			unlocklevel = CASTLE_LV16_LIMITED
		elseif bid == BUILDID.ELITE_PALACE then
			local castleBid = BUILDID.CASTLE
			local buildCell = cityCtrl:getBuildCell(castleBid, 0)
			if nil == buildCell then
				return isLocked, CASTLE_LV20_LIMITED
			end
			local castleLv = tonumber(buildCell.info.lv)
			if castleLv >= CASTLE_LV20_LIMITED then
				isLocked = false
			else
				isLocked = true
			end
			unlocklevel = CASTLE_LV20_LIMITED
		elseif bid == BUILDID.HERO_TRAIN_GROUND then
			local castleBid = BUILDID.CASTLE
			local buildCell = cityCtrl:getBuildCell(castleBid, 0)
			if nil == buildCell then
				return isLocked, CASTLE_LV15_LIMITED
			end
			local castleLv = tonumber(buildCell.info.lv)
			if castleLv >= CASTLE_LV15_LIMITED then
				isLocked = false
			else
				isLocked = true
			end
			unlocklevel = CASTLE_LV15_LIMITED
		elseif bid == BUILDID.HERO_CENOTAPH then
			local castleBid = BUILDID.CASTLE
			local buildCell = cityCtrl:getBuildCell(castleBid, 0)
			if nil == buildCell then
				return isLocked
			end
			local castleLv = tonumber(buildCell.info.lv)
			if castleLv >= CASTLE_LV19_LIMITED then
				isLocked = false
			else
				isLocked = true
			end
		elseif bid == BUILDID.HERO_PRISON then
			local castleBid = BUILDID.CASTLE
			local buildCell = cityCtrl:getBuildCell(castleBid, 0)
			if nil == buildCell then
				return isLocked, CASTLE_LV20_LIMITED
			end
			local castleLv = tonumber(buildCell.info.lv)
			if castleLv >= CASTLE_LV20_LIMITED then
				isLocked = false
			else
				isLocked = true
			end
			unlocklevel = CASTLE_LV20_LIMITED
		elseif bid == cityBuildConstDef.fixedBuildDef.EpicBattle then
			local castleBid = BUILDID.CASTLE
			local buildCell = cityCtrl:getBuildCell(castleBid, 0)
			if nil == buildCell then
				return isLocked
			end
			local castleLv = tonumber(buildCell.info.lv)
			local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.SOLDIER_GAME)
			if castleLv >= unlockLv then
				isLocked = false
			else
				isLocked = true
			end
		elseif bid == BUILDID.MONUMENT then
			local castleBid = BUILDID.CASTLE
			local buildCell = cityCtrl:getBuildCell(castleBid, 0)
			if nil == buildCell then
				return isLocked
			end
			local castleLv = tonumber(buildCell.info.lv)
			local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.LEGEND_HISTORY)
			if castleLv >= unlockLv then
				isLocked = false
			else
				isLocked = true
			end
			unlocklevel = unlockLv
		elseif bid == cityBuildConstDef.fixedBuildDef.ResurrectionHall then
			local castleBid = BUILDID.CASTLE
			local buildCell = cityCtrl:getBuildCell(castleBid, 0)
			if nil == buildCell then
				return isLocked
			end
			local castleLv = tonumber(buildCell.info.lv)
			if castleLv < CASTLE_LV6_LIMITED then
				isLocked = true
			end
			if isLocked ~= true then
				local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
				print("lordInfoCtrl:getBaseInfo().isSrcKingWarEnabled ", lordInfoCtrl:getBaseInfo().isSrcKingWarEnabled)
				if not lordInfoCtrl:getBaseInfo().isSrcKingWarEnabled then
					isLocked = true
				end
			end
		elseif bid == BUILDID.CRYSTAL_MINE then
			local castleBid = BUILDID.CASTLE
			local buildCell = cityCtrl:getBuildCell(castleBid, 0)
			if nil == buildCell then
				return isLocked
			end
			local castleLv = tonumber(buildCell.info.lv)
			local isShowWarLv, textLv = SoraDGetBuildWarLv(castleLv)
			print("isShowWarLv = ", isShowWarLv, ", textLv = ", textLv)
			if not isShowWarLv or textLv < 3 then
				isLocked = true
			else
				isLocked = false
			end
		elseif bid == BUILDID.NEBULA_PALACE then
			local castleBid = BUILDID.CASTLE
			local buildCell = cityCtrl:getBuildCell(castleBid, 0)
			if nil == buildCell then
				return isLocked
			end
			local nebulaPalaceCell = cityCtrl:getBuildCell(bid, 0)
			if nil == nebulaPalaceCell then
				return isLocked
			end
			local castleLv = tonumber(buildCell.info.lv)
			isLocked = castleLv < NEBULA_WARS_BUILD_305 or tonumber(nebulaPalaceCell.info.state) == BUILD_STATE.LOCK
		end
		return isLocked, unlocklevel
	end
end
function cityBuildBaseEntity:checkBuildClick()
	return true
end
function cityBuildBaseEntity:onClickBuildTopTip()
end
function cityBuildBaseEntity:updateIsLock()
	local bid = self:getBuildBid()
	cityBuildConstDef = self
	local self[1], checkLockVisible = BUILDID.CRYSTAL_MINE, self
	local isNeedCheckVisible = false
	for i = 1, #checkLockVisible do
		if checkLockVisible[i] == bid then
			isNeedCheckVisible = true
			break
		end
	end
	if isNeedCheckVisible then
		if self:getIsLockVisible() then
			self:setVisible(false)
			return
		else
			self:setVisible(true)
		end
	end
	if bid == BUILDID.TURRET then
		local isLocked = self:getIsLocked()
		if isLocked then
			if self.showLock then
				self:showLock()
			end
		else
			if self.hideLock then
				self:hideLock()
			end
			self:showBuildLv()
		end
	end
	_UPVALUE18_ = isLocked
	self:getIsLocked()[1] = BUILDID.BLACK_SMITH
	self:getIsLocked()[2] = BUILDID.MATERIAL_WORKSHOP
	self:getIsLocked()[3] = cityBuildConstDef.fixedBuildDef.PetCenter
	self:getIsLocked()[4] = BUILDID.ELITE_PALACE
	self:getIsLocked()[5] = cityBuildConstDef.fixedBuildDef.ResurrectionHall
	self:getIsLocked()[6] = BUILDID.CRYSTAL_MINE
	self:getIsLocked()[7] = cityBuildConstDef.fixedBuildDef.EpicBattle
	self:getIsLocked()[8] = BUILDID.HERO_TRAIN_GROUND
	self:getIsLocked()[9] = BUILDID.HERO_PRISON
	self:getIsLocked()[10] = BUILDID.MONUMENT
	self:getIsLocked()[11] = cityBuildConstDef.fixedBuildDef.Mastery
	self:getIsLocked()[12] = BUILDID.NEBULA_PALACE
	self:getIsLocked()[13] = BUILDID.NEWBORN_TREE
	self:getIsLocked()[14] = BUILDID.MAGIC_LAMP
	self:getIsLocked()[15] = BUILDID.WALLS
	self:getIsLocked()[16] = BUILDID.EMBASSY
	self:getIsLocked()[17] = BUILDID.LESURE_CENTER
	self:getIsLocked()[18] = BUILDID.WATCH_TOWER
	local self:getIsLocked()[19], checkLockTb = BUILDID.GARDEN, self:getIsLocked()
	local isNeedCheck = false
	for i = 1, #checkLockTb do
		if checkLockTb[i] == bid then
			isNeedCheck = true
			break
		end
	end
	if isNeedCheck then
		local isLocked = self:getIsLocked()
		if isLocked then
			if self.showBuildLock then
				self:showBuildLock()
			end
		else
			if self.hideBuildLock then
				self:hideBuildLock()
			end
			local isNeedRefreshHarvestEffect = false
			cityBuildConstDef = self
			local self[1], checkHarvestTb = BUILDID.CRYSTAL_MINE, self
			for i, v in ipairs(checkHarvestTb) do
				if bid == v then
					isNeedRefreshHarvestEffect = true
					break
				end
			end
			if isNeedRefreshHarvestEffect then
				_ENV = ipairs(checkHarvestTb)
				ipairs(checkHarvestTb).msg = "MESSAGE_MAINCITY_UPDATE_HARVEST_EFFECT"
				SoraDSendMessage(ipairs(checkHarvestTb))
			end
		end
	end
end
function cityBuildBaseEntity:getHasAnyAllianceHelpList()
	local ret = false
	local bid = self:getBuildBid()
	if bid ~= BUILDID.EMBASSY then
		return ret
	end
	local gametop = gModuleMgr.getObject("gametop")
	local allianceHelp = gametop.playertop_:getModule("allianceHelp")
	if true == allianceHelp:getIsCanHelp() then
		ret = true
	end
	return ret
end
function cityBuildBaseEntity:updateAllianceHelpList()
	local bid = self:getBuildBid()
	if bid ~= BUILDID.EMBASSY then
		return
	end
	local gametop = gModuleMgr.getObject("gametop")
	local allianceHelp = gametop.playertop_:getModule("allianceHelp")
	local canhelp = allianceHelp:getIsCanHelp()
	local buildState = self:getBuildState()
	if canhelp then
		print("有需要帮助所有的联盟成员")
		if buildState == BUILD_STATE.NORMAL then
			self:showTopTipEffect()
		end
	elseif buildState == BUILD_STATE.NORMAL then
		self:hideTopTipEffect()
	end
end
_ENV, cityBuildBaseEntity.doAllianceHelpAll = function(self)
	local gametop = gModuleMgr.getObject("gametop")
	local allianceHelp = gametop.playertop_:getModule("allianceHelp")
	allianceHelp:reqHelpAll()
end, function(self)
	local gametop = gModuleMgr.getObject("gametop")
	local allianceHelp = gametop.playertop_:getModule("allianceHelp")
	allianceHelp:reqHelpAll()
end
;(function(self)
	local gametop = gModuleMgr.getObject("gametop")
	local allianceHelp = gametop.playertop_:getModule("allianceHelp")
	allianceHelp:reqHelpAll()
end)[tostring(BUILDID.FARM)] = 501501
;(function(self)
	local gametop = gModuleMgr.getObject("gametop")
	local allianceHelp = gametop.playertop_:getModule("allianceHelp")
	allianceHelp:reqHelpAll()
end)[tostring(BUILDID.SAWMILL)] = 501401
;(function(self)
	local gametop = gModuleMgr.getObject("gametop")
	local allianceHelp = gametop.playertop_:getModule("allianceHelp")
	allianceHelp:reqHelpAll()
end)[tostring(BUILDID.IRON_MINE)] = 501601
;(function(self)
	local gametop = gModuleMgr.getObject("gametop")
	local allianceHelp = gametop.playertop_:getModule("allianceHelp")
	allianceHelp:reqHelpAll()
end)[tostring(BUILDID.STEEL)] = 501701
local (function(self)
	local gametop = gModuleMgr.getObject("gametop")
	local allianceHelp = gametop.playertop_:getModule("allianceHelp")
	allianceHelp:reqHelpAll()
end)[tostring(BUILDID.CRYSTAL_MINE)], searchBoostToolTable = 503201, function(self)
	local gametop = gModuleMgr.getObject("gametop")
	local allianceHelp = gametop.playertop_:getModule("allianceHelp")
	allianceHelp:reqHelpAll()
end
function cityBuildBaseEntity:getBoostToolId(bid)
	if bid == nil then
		bid = self:getBuildBid()
	end
	local itemId = 0
	itemId = searchBoostToolTable[tostring(bid)]
	return itemId
end
function cityBuildBaseEntity:getBoostToolNum(bid)
	if bid == nil then
		bid = self:getBuildBid()
	end
	local gametop = gModuleMgr.getObject("gametop")
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local itemId = self:getBoostToolId(bid)
	local itemCount = 0
	if itemId ~= nil then
		itemCount = backpackCtrl:getItemCount(itemId)
	end
	return itemCount
end
function cityBuildBaseEntity:getBoostGold()
	local bid = self:getBuildBid()
	local blv = self:getBuildLv()
	local starlv = self:getBuildStarLv()
	return cityltCtrl.getBoostGold(bid, blv, starlv)
end
function cityBuildBaseEntity:doBoostCallBack(eventType)
	if eventType == MSGBOX_CALLBACK_YES then
		print("点击了确认，消耗金币提速")
		self:doRequestBoostByGold()
		self:showAnimBoost()
	end
end
function cityBuildBaseEntity:getBufferid()
	return self.bufferid
end
function cityBuildBaseEntity:getBuffEffectType(bid)
	if bid == nil then
		bid = self:getBuildBid()
	end
	if bid == BUILDID.FARM then
		return gBuffEffect.FOOD_OUTPUT_BOOST
	elseif bid == BUILDID.SAWMILL then
		return gBuffEffect.WOOD_OUTPUT_BOOST
	elseif bid == BUILDID.IRON_MINE then
		return gBuffEffect.IRON_OUTPUT_BOOST
	elseif bid == BUILDID.STEEL then
		return gBuffEffect.MITHRIL_OUTPUT_BOOST
	elseif bid == BUILDID.CRYSTAL_MINE then
		return gBuffEffect.CRYSTAL_OUTPUT_BOOST
	end
end
function cityBuildBaseEntity:getBuff()
	local effectType = self:getBuffEffectType()
	local bid = self:getBuildBid()
	local iid = self:getIid()
	if effectType then
		local gametop = gModuleMgr.getObject("gametop")
		local buffCtrl = gametop.playertop_:getModule("buffCtrl")
		local buff = buffCtrl:getResourceBoostBuff(effectType, bid, iid)
		return buff
	end
end
function cityBuildBaseEntity:getHasBuff()
	local ret = false
	local remainTime = self:getBuffTime()
	if remainTime and 0 < remainTime then
		ret = true
	end
	return ret
end
function cityBuildBaseEntity:getBuffRemainTime()
	local buff = self:getBuff()
	if buff then
		return buff:getRemainTime()
	end
end
function cityBuildBaseEntity:getBuffTime()
	local buff = self:getBuff()
	if buff then
		return buff:getProperty("time")
	end
end
function cityBuildBaseEntity:getIsShowBuff()
	return self.isShowBuff
end
function cityBuildBaseEntity:updateBuff()
	local buff = self:getBuff()
	if buff then
		local remainTime = self:getBuffRemainTime()
		if 0 < remainTime and false == self:getIsShowBuff() then
			self:showAnimBoost()
			self.isShowBuff = true
		elseif remainTime == 0 and true == self:getIsShowBuff() then
			self:hideAnimBoost()
			self.buffid = 0
			self.isShowBuff = false
		end
	elseif self:getIsShowBuff() then
		self:hideAnimBoost()
		self.buffid = 0
		self.isShowBuff = false
	end
end
function cityBuildBaseEntity:sMsgRemoveBuff(target, data)
	local buffid = data.buffid
	if self.buffid == buffid then
		self:hideAnimBoost()
		self.buffid = 0
		self.isShowBuff = false
	end
end
function cityBuildBaseEntity:doRequestBoostByGold()
	local bid = self:getBuildBid()
	local iid = self:getIid()
	local toolid = self:getBoostToolId(bid)
	print("请求金币提速: bid ,iid", bid, iid)
	cityCtrl:speedUpResReq(bid, iid, BUILD_EXCHANGE_MODE.GOLD)
end
function cityBuildBaseEntity:doRequestBoostByTool()
	local bid = self:getBuildBid()
	local iid = self:getIid()
	local toolid = self:getBoostToolId(bid)
	print("请求道具提速: bid ,iid, toolid", bid, iid, toolid)
	cityCtrl:speedUpResReq(bid, iid, BUILD_EXCHANGE_MODE.TOOLS, toolid)
end
function cityBuildBaseEntity:updateViewModel()
end
function cityBuildBaseEntity:getViewModelByLv(lv, tblViewModelCfg)
	return cityBuildViewDef.getViewModelByLv(lv, tblViewModelCfg)
end
function cityBuildBaseEntity:getIsOpening()
	return false
end
function cityBuildBaseEntity:getIsCanMove()
	local bid = self:getBuildBid()
	local ret = false
	ret = cityltCtrl.buildAttr(bid, BUILD_ATTR.ISEXCHANGE)
	if ret == 0 then
		ret = false
	elseif ret == 1 then
		ret = true
	end
	return ret
end
function cityBuildBaseEntity:showBuildLock()
	local buildIndex = self:getBuildIndex()
	print("showBuildLock.buildIndex====", buildIndex)
	_ENV = "showBuildLock.buildIndex===="
	;("showBuildLock.buildIndex====").msg = "MESSAGE_MAINCITYVIEW_SHOW_BUILD_LOCK"
	;("showBuildLock.buildIndex====").buildIndex = buildIndex
	SoraDSendMessage("showBuildLock.buildIndex====")
end
function cityBuildBaseEntity:hideBuildLock()
	local buildIndex = self:getBuildIndex()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_HIDE_BUILD_LOCK"
	;(nil).buildIndex = buildIndex
	SoraDSendMessage(nil)
	local bid = self:getBuildBid()
	if bid ~= BUILDID.MATERIAL_WORKSHOP then
		self:showBuildLv()
	end
end
function cityBuildBaseEntity:checkCanTrainOrUpgrade()
	local canTrainOrUpgrade = true
	if self.isWaitTraining == true then
		self:showIsTrainningTip()
		canTrainOrUpgrade = false
		return canTrainOrUpgrade
	end
	local bid = self:getBuildBid()
	if bid == BUILDID.STABLES or bid == BUILDID.RANGE or bid == BUILDID.BARRACKS or bid == BUILDID.FORTRESS or bid == BUILDID.CHARIOT_PLANT or bid == BUILDID.BLACK_SMITH or bid == BUILDID.HOSTPITAL then
		if true == self:getIsTraining() then
			self:showIsTrainningTip()
			canTrainOrUpgrade = false
			return canTrainOrUpgrade
		end
		if "working" == self:getState() then
			self:showIsTrainningTip()
			canTrainOrUpgrade = false
			return canTrainOrUpgrade
		end
		if "harvesting" == self:getState() then
			self:showIsTrainningTip()
			canTrainOrUpgrade = false
			return canTrainOrUpgrade
		end
		if "building" == self:getState() then
			self:showIsBuildingTip()
			canTrainOrUpgrade = false
			return canTrainOrUpgrade
		end
	end
	return canTrainOrUpgrade
end
function cityBuildBaseEntity:setIsWaitTraining(isWaitTraining)
	if isWaitTraining then
		print("设置为等待训练返回")
	else
		print("重置训练返回")
	end
	self.isWaitTraining = isWaitTraining
end
function cityBuildBaseEntity:getIsWaitTrainig()
	return self.isWaitTraining
end
function cityBuildBaseEntity:sMsgBuildTrainFailed(target, data)
	local bid = data.bid
	local iid = data.iid
	if bid == self:getBuildBid() then
		if iid and iid == self:getIid() then
			print("训练失败，重置标记---")
			self:setIsWaitTraining(false)
		elseif iid == nil then
			print("训练失败，重置标记---")
			self:setIsWaitTraining(false)
		end
	end
end
function cityBuildBaseEntity:showInvalidOpTip()
	local buildDescribeRead = include("buildDescribeRead")
	local bid = self:getBuildBid()
	local spriteName = buildDescribeRead.getIcon(bid, true)
	SoraDShowMsgTip(i18n("common_text_1028"), spriteName)
end
function cityBuildBaseEntity:showIsTrainningTip()
	local buildDescribeRead = include("buildDescribeRead")
	local bid = self:getBuildBid()
	local spriteName = buildDescribeRead.getIcon(bid, true)
	SoraDShowMsgTip(i18n("common_text_1131"), spriteName)
end
function cityBuildBaseEntity:showIsBuildingTip()
	local buildDescribeRead = include("buildDescribeRead")
	local bid = self:getBuildBid()
	local spriteName = buildDescribeRead.getIcon(bid, true)
	SoraDShowMsgTip(i18n("common_text_1132"), spriteName)
end
function cityBuildBaseEntity:reBeginTime()
	local bid = tonumber(self:getBuildBid())
	if bid == BUILDID.FARM or bid == BUILDID.SAWMILL or bid == BUILDID.IRON_MINE or bid == BUILDID.STEEL or bid == BUILDID.CRYSTAL_MINE then
		if self.harvestState == CITYBUILD_HARVESTSTATE.CITYBUILD_HARVESTSTATE_UNDEFINED then
			self:setHarvestState(CITYBUILD_HARVESTSTATE.CITYBUILD_HARVESTSTATE_NONE, false)
		end
		self:beginTime()
		self:updateTime()
	end
end
function cityBuildBaseEntity:sMsgTrainArmyImmediatelyBack(target, data)
	local targetBid = data.bid
	if not targetBid then
		return
	end
	if tonumber(targetBid) == self:getBuildBid() then
		self:setIsWaitTraining(false)
	end
end
function cityBuildBaseEntity:setIsCancel(value)
	self.isCancel = value or false
end
function cityBuildBaseEntity:setIsReconnected(value)
	self.isReconnected = value or false
end
function cityBuildBaseEntity:getIsReconnected()
	return self.isReconnected
end
function cityBuildBaseEntity:getIsCancel()
	return self.isCancel
end
function cityBuildBaseEntity:setCostRes(costRes)
	self.costRes = costRes
end
function cityBuildBaseEntity:getCostRes()
	return self.costRes
end
function cityBuildBaseEntity:updateLvPos()
	local buildIndex = self:getBuildIndex()
	if buildIndex then
		local posLvBg, posUpgrade, posTextLv = cityBuildViewDef.getBuildLvPosByIndex(buildIndex)
		if self.buildLvBg and posLvBg then
			self.buildLvBg:setPosition(posLvBg)
		end
		local x, y = self.buildLvBg:getPosition()
		local scaleX = self.buildLvBg:getScaleX()
		local scaleY = self.buildLvBg:getScaleY()
		if self.imgUpgrade then
			self.imgUpgrade:setPosition(cc.p(x + 50 * scaleX, y + 20 * scaleY))
		end
		if self.textLv then
			self.textLv:setPosition(cc.p(x + 23 * scaleX, y + 5 * scaleY))
		end
		self:updateStarLvPos()
	end
end
function cityBuildBaseEntity:updateStarLvPos(...)
	local starLv = self:getBuildStarLv()
	if 0 < starLv then
		local x, y = self.buildLvBg:getPosition()
		local scaleX = self.buildLvBg:getScaleX()
		local scaleY = self.buildLvBg:getScaleY()
		if self.textLv then
			self.textLv:setPosition(cc.p(x + 23 * scaleX, y - 10 * scaleY))
		end
		if self.imgUpgrade then
			self.imgUpgrade:setPosition(cc.p(x + 70 * scaleX, y + 20 * scaleY))
		end
	end
end
function cityBuildBaseEntity:delayUpdateState()
	print("延时刷新到了----------------")
	local bid = tonumber(self:getBuildBid())
	if bid == BUILDID.MATERIAL_WORKSHOP and self.blockState == "idle" and self:getIsCanHarvestTrain() then
		self:setBlockState("harvesting")
		self:changeState()
	end
end
function cityBuildBaseEntity:showWorkingEffect()
end
function cityBuildBaseEntity:removeWorkingEffect()
end
function cityBuildBaseEntity:onExitOther()
	if self.upgradeTimeHandle ~= nil then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.upgradeTimeHandle)
		self.upgradeTimeHandle = nil
	end
end
function cityBuildBaseEntity:reInit()
	self:setIsReconnected(true)
	self:setBlockState("idle")
	self:changeState()
	print(string.format("内城建筑:index = %d, bid = %d, iid = %d 重新初始化", self:getBuildIndex(), self:getBuildBid(), self:getIid()))
	local buildCell = self:getBuildCell()
	if buildCell then
		self:initWithBuildCell(buildCell)
	else
		self:initWithoutCell()
	end
	self:setIsReconnected(false)
	self:onAfterReconnected()
end
function cityBuildBaseEntity:onAfterReconnected()
end
function cityBuildBaseEntity:isIdle()
	local isIdle = true
	if isIdle then
		local queue = self:getQueue()
		if queue ~= nil then
			isIdle = false
		end
	end
	if isIdle then
		local state = self:getState()
		print("state = ", state)
		if state ~= "idle" and state ~= "none" then
			isIdle = false
		end
	end
	if isIdle and self:getIsLocked() then
		isIdle = false
	end
	if isIdle and self:getIsNeedReqHelp() then
		isIdle = false
	end
	if isIdle and self:getHasAnyAllianceHelpList() then
		isIdle = false
	end
	if isIdle and self:hasGuide() then
		isIdle = false
	end
	if isIdle and not self:isCustomIdle() then
		isIdle = false
	end
	return isIdle
end
function cityBuildBaseEntity:isCustomIdle()
	return true
end
function cityBuildBaseEntity:setHasNpcTip(value)
	self.hasNpcTip = value
end
function cityBuildBaseEntity:hasNpcTip()
	return self.hasNpcTip
end
function cityBuildBaseEntity:claimNpcTipReward()
	local bid = self:getBuildBid()
	local blv = self:getBuildLv()
	local bIndex = self:getBuildIndex()
	local npcTipClient = include("npcTipClient")
	npcTipClient:reqTipReward(bid, blv)
	self.hasNpcTip = false
	_ENV = npcTipClient
	npcTipClient.msg = "MESSAGE_MAINCITYVIEW_REMOVE_NPC_TOP_TIP"
	npcTipClient.bid = bid
	npcTipClient.bIndex = bIndex
	SoraDSendMessage(npcTipClient)
end
function cityBuildBaseEntity:hasGuide()
	local hasGuide = false
	return hasGuide
end
function cityBuildBaseEntity:updateTopTip()
end
function cityBuildBaseEntity:updateViewAfterBuild()
end
function cityBuildBaseEntity:updateViewAfterReset()
	self:updateTopTip()
end
return cityBuildBaseEntity
