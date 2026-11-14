local buildLogic = include("buildLogic")
local buildRead = include("buildDescribeRead")
local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local armyLogic = include("armyLogic")
local armyCtrl = gametop.playertop_:getModule("armyCtrl")
local itemDesRead = include("itemDesRead")
local equipDesRead = include("equipDesRead")
local cityBuildConstDef = include("cityBuildConstDef")
local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
local specializationRead = include("specializationRead")
local armyDes = include("armyDesRead")
local cityBuildCoolingTip = class("cityBuildCoolingTip", function(target)
	if target == nil then
		return SoraDCreateBasePanel("cityCoolingTip")
	elseif type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function cityBuildCoolingTip:ctor()
	self:setNodeEventEnabled(true)
	self.buildIndex = 0
	self.buildEntity = nil
	self.isFlag = false
	self.labelTime = SoraDGetChildByName(self, "textTime")
	self.spriteIcon = SoraDGetChildByName(self, "iconImg")
	local loadingBg = SoraDGetChildByName(self, "spriteLoadingBarBg")
	self.loadingBar = SoraDGetChildByName(loadingBg, "LoadingBar_bar")
	self.loadingBar:setScale9Enabled(true)
	self.loadingBar:setCapInsets(cc.rect(4, 4, 4, 1))
	self.coolingData, _ENV, self.labelTip = SoraDGetChildByName(self, "textTip"), SoraDGetChildByName(self, "textTip"), SoraDGetChildByName(self, "textTip")
	self.isFree = false
	self.isNeedReqHelp = false
	_ENV, self.isResearchFree = SoraDGetChildByName(self, "textTip"), false
	SoraDGetChildByName(self, "textTip").buildEntity = nil
	SoraDGetChildByName(self, "textTip").icon = "icon_jianzao.png"
	local SoraDGetChildByName(self, "textTip").tip, coolingData = i18n("common_text_046"), SoraDGetChildByName(self, "textTip")
	self:initData(coolingData)
end
function cityBuildCoolingTip:setBuildIndex(buildIndex)
	self.buildIndex = buildIndex
end
function cityBuildCoolingTip:setBuildEntity(buildEntity)
	self.buildEntity = buildEntity
end
function cityBuildCoolingTip:resetData()
	_ENV = nil
	;(nil).buildEntity = nil
	;(nil).icon = "icon_main_build_09.png"
	local (nil).tip, coolingData = i18n("common_text_046"), nil
	self:initData(coolingData)
end
function cityBuildCoolingTip:beginCooling()
	local queue = self:getQueue()
	if queue == nil then
		return
	end
	self.labelTime:setVisible(true)
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self:updateTime()
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function cityBuildCoolingTip:updateTime()
	local queue = self:getQueue()
	if queue == nil then
		return
	end
	local totalTime = queue.ottime or queue.totaltime
	local remainTime = queue.timerNode.timer:getRemainTime()
	self.labelTime:setString(SoraDConvertSecondToString(remainTime))
	local percentage = (totalTime - remainTime) * 100 / totalTime
	if false == self.isBuildCooling then
		self.loadingBar:setPercent(percentage)
		return
	end
	self.loadingBar:setPercent(percentage)
	if not self.buildEntity then
		return
	end
	local bid = self.buildEntity:getBuildBid()
	local buildState = self.buildEntity:getBuildState()
	local buildLv = self.buildEntity:getBuildLv()
	if tonumber(queue.qtype) == gQueueTypeDef.build_star_queue or tonumber(queue.qtype) == gQueueTypeDef.build_star_queue_privilege or tonumber(queue.qtype) == gQueueTypeDef.glorious_upgrade then
		local freeSpeedUpTime = buildLogic.getFreeStrongTime()
		if remainTime <= freeSpeedUpTime and not self.isStartFree then
			self.isStartFree = true
			self.buildEntity:setIsCanSpeedUpStrongFree(true)
			_ENV = self.buildEntity
			self.buildEntity.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
			self.buildEntity.buildIndex = self.buildEntity:getBuildIndex()
			SoraDSendMessage(self.buildEntity)
			_ENV = self.buildEntity
			self.buildEntity.msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP"
			self.buildEntity.buildIndex = self.buildEntity:getBuildIndex()
			self.buildEntity.buildEntity = self.buildEntity
			SoraDSendMessage(self.buildEntity)
		elseif self:checkAllianceHelp() then
		elseif remainTime > freeSpeedUpTime and self.isStartFree == true then
			self.isStartFree = false
			self.buildEntity:setIsCanSpeedUpStrongFree(false)
			_ENV = self.buildEntity
			self.buildEntity.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
			self.buildEntity.buildIndex = self.buildEntity:getBuildIndex()
			self.buildEntity.buildEntity = self.buildEntity
			SoraDSendMessage(self.buildEntity)
			self.buildEntity:updateTopTip()
		end
	elseif (buildState == BUILD_STATE.BUILDING or buildState == BUILD_STATE.UPGRADEING or buildState == BUILD_STATE.DEMOLISHING) and tonumber(queue.qtype) ~= gQueueTypeDef.endless_treasure_queue then
		local freeSpeedUpTime = buildLogic.getFreeSpeedUpTime(buildLv)
		if remainTime <= freeSpeedUpTime and self.isFree == false then
			self.isFree = true
			self.buildEntity:setIsCanSpeedUpFree(true)
			_ENV = self.buildEntity
			self.buildEntity.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
			self.buildEntity.buildIndex = self.buildEntity:getBuildIndex()
			SoraDSendMessage(self.buildEntity)
			_ENV = self.buildEntity
			self.buildEntity.msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP"
			self.buildEntity.buildIndex = self.buildEntity:getBuildIndex()
			self.buildEntity.buildEntity = self.buildEntity
			SoraDSendMessage(self.buildEntity)
		elseif self:checkAllianceHelp() then
		elseif remainTime > freeSpeedUpTime and self.isFree == true then
			self.isFree = false
			self.buildEntity:setIsCanSpeedUpFree(false)
			_ENV = self.buildEntity
			self.buildEntity.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
			self.buildEntity.buildIndex = self.buildEntity:getBuildIndex()
			self.buildEntity.buildEntity = self.buildEntity
			SoraDSendMessage(self.buildEntity)
			self.buildEntity:updateTopTip()
		end
	elseif buildState == BUILD_STATE.NORMAL then
		local freeResearchTime = technologyCtrl:getFreeSpeedUpTime()
		if bid == BUILDID.COLLEGE or bid == BUILDID.MIRACLE then
			if remainTime <= freeResearchTime and self.isResearchFree == false then
				self.isResearchFree = true
				self.buildEntity:setIsCanResearchFree(true)
				_ENV = self.buildEntity
				self.buildEntity.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
				self.buildEntity.buildIndex = self.buildEntity:getBuildIndex()
				SoraDSendMessage(self.buildEntity)
				_ENV = self.buildEntity
				self.buildEntity.msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP"
				self.buildEntity.buildIndex = self.buildEntity:getBuildIndex()
				self.buildEntity.buildEntity = self.buildEntity
				SoraDSendMessage(self.buildEntity)
			elseif self:checkAllianceHelp() then
			elseif remainTime > freeResearchTime and self.isResearchFree == true then
				self.isResearchFree = false
				self.buildEntity:setIsCanResearchFree(false)
				_ENV = self.buildEntity
				self.buildEntity.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
				self.buildEntity.buildIndex = self.buildEntity:getBuildIndex()
				self.buildEntity.buildEntity = self.buildEntity
				SoraDSendMessage(self.buildEntity)
			end
		else
			self:checkAllianceHelp()
		end
	end
end
function cityBuildCoolingTip:checkAllianceHelp()
	if self.buildEntity and self.isNeedReqHelp == false and self.buildEntity:getIsNeedReqHelp() then
		self.isNeedReqHelp = true
		_ENV = self.buildEntity
		self.buildEntity.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		self.buildEntity.buildIndex = self.buildEntity:getBuildIndex()
		SoraDSendMessage(self.buildEntity)
		_ENV = self.buildEntity
		self.buildEntity.msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP"
		self.buildEntity.buildIndex = self.buildEntity:getBuildIndex()
		self.buildEntity.buildEntity = self.buildEntity
		SoraDSendMessage(self.buildEntity)
		return true
	elseif self.buildEntity and self.isNeedReqHelp == true and self.buildEntity:getIsNeedReqHelp() == false then
		self.isNeedReqHelp = false
		_ENV = self.buildEntity
		self.buildEntity.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
		self.buildEntity.buildIndex = self.buildEntity:getBuildIndex()
		self.buildEntity.buildEntity = self.buildEntity
		SoraDSendMessage(self.buildEntity)
		self.buildEntity:updateTopTip()
		return true
	end
	return false
end
function cityBuildCoolingTip:getQueue(...)
	local queue
	if self.coolingType == BUILD_COOLING_TYPE.PROMPT_ARMY then
		queue = queueCtrl:queryQueue(gQueueTypeDef.prompt_army)
	elseif self.coolingType == BUILD_COOLING_TYPE.MAGIC_LAMP_BREAK then
		queue = queueCtrl:queryQueue(gQueueTypeDef.magic_lamp_jinn_star)
	elseif self.coolingType == BUILD_COOLING_TYPE.MAGIC_LAMP_STRENGTH then
		queue = queueCtrl:queryQueue(gQueueTypeDef.magic_lamp_jinn_level)
	elseif self.coolingType == BUILD_COOLING_TYPE.MAGIC_LAMP_CLASS then
		queue = queueCtrl:queryQueue(gQueueTypeDef.magic_lamp_jinn_class)
	elseif self.coolingType == BUILD_COOLING_TYPE.MAGIC_LAMP_HATCH_UPGRADE then
		queue = queueCtrl:queryQueue(gQueueTypeDef.magic_lamp_hatch_level)
	elseif self.coolingType == BUILD_COOLING_TYPE.GARDEN_BUILD then
		queue = queueCtrl:queryQueue(gQueueTypeDef.garden_build_upgrade)
	elseif self.coolingType == BUILD_COOLING_TYPE.GARDEN_TECH then
		queue = queueCtrl:queryQueue(gQueueTypeDef.garden_technology)
	elseif self.buildEntity then
		if self.coolingType == BUILD_COOLING_TYPE.BUILD_STAR then
			queue = self.buildEntity:getBuildStarQueue()
		elseif self.coolingType == BUILD_COOLING_TYPE.BUILD_STAR_SECOND then
			queue = self.buildEntity:getBuildStarSecondQueue()
		elseif self.coolingType == BUILD_COOLING_TYPE.DIG_TREASURE then
			queue = queueCtrl:queryQueue(gQueueTypeDef.endless_treasure_queue)
		elseif self.coolingType == BUILD_COOLING_TYPE.BUILD_STATUE_BRAVE then
			queue = queueCtrl:queryQueue(gQueueTypeDef.glorious_upgrade)
		else
			queue = self.buildEntity:getQueue()
		end
	end
	return queue
end
function cityBuildCoolingTip:initData(coolingData)
	dump(coolingData, "cityBuildCoolingTip")
	local rotation = 0
	local scale = 1
	local index = coolingData.index
	if index ~= nil then
		self:setBuildIndex(index)
	end
	local buildEntity = coolingData.buildEntity
	if buildEntity ~= nil then
		self:setBuildEntity(buildEntity)
	end
	self.coolingType = coolingData.coolingType
	if not self.coolingType then
		if index == cityBuildConstDef.buildIndexDef.index_TroopFlag then
			self.coolingType = BUILD_COOLING_TYPE.PROMPT_ARMY
		elseif index == cityBuildConstDef.buildIndexDef.index_Mastery then
			self.coolingType = BUILD_COOLING_TYPE.BUILD_MASTERY
		else
			self.coolingType = BUILD_COOLING_TYPE.BUILD_ALL
		end
	end
	if self.coolingType == BUILD_COOLING_TYPE.BUILD_STAR or self.coolingType == BUILD_COOLING_TYPE.BUILD_STAR_SECOND then
		_ENV = buildEntity
		buildEntity.build = ""
		coolingData.tip = i18n("Glory_text_31", buildEntity)
		coolingData.icon = "icon_main_build_star.png"
	elseif self.coolingType == BUILD_COOLING_TYPE.PROMPT_ARMY then
		coolingData.icon = "icon_jh.png"
		local armyid = coolingData.data.armyid
		local armycount = coolingData.data.armycount
		local armyName = armyDes.getName(armyid)
		_ENV = nil
		;(nil).name = armyName
		;(nil).num = armycount
		local strTip = i18n("common_text_036", nil)
		coolingData.tip = strTip
		rotation = 90
		scale = 0.5
	elseif self.coolingType == BUILD_COOLING_TYPE.BUILD_MASTERY then
		coolingData.icon = "icon_updating_specialization.png"
		local bid = coolingData.data.bid
		local buildName = specializationRead.getMasteryName(bid)
		local lev = coolingData.data.lev
		_ENV = nil
		;(nil).name = buildName
		;(nil).num = lev
		coolingData.tip = i18n("common_text_036", nil)
	elseif self.coolingType == BUILD_COOLING_TYPE.DIG_TREASURE then
		coolingData.icon = "icon_main_build_11.png"
		coolingData.tip = i18n("endless_treasures_text_03")
	elseif self.coolingType == BUILD_COOLING_TYPE.BUILD_STATUE_BRAVE then
		coolingData.icon = "icon_main_build_star.png"
		coolingData.tip = i18n("Soldiers_armor_text_59")
	elseif self.coolingType == BUILD_COOLING_TYPE.GARDEN_BUILD then
		coolingData.icon = "icon_main_build_09.png"
		local manorCityUtil = include("manorCityUtil")
		local tipStr = ""
		local queueName = manorCityUtil.getQueueShowName(gQueueTypeDef.garden_build_upgrade)
		if queueName then
			tipStr = queueName .. i18n("common_text_056")
			self.labelTip:setVisible(true)
		else
			self:setIdleState()
		end
		coolingData.tip = tipStr
	elseif self.coolingType == BUILD_COOLING_TYPE.GARDEN_TECH then
		coolingData.icon = "icon_main_build_05.png"
		local manorCityUtil = include("manorCityUtil")
		local tipStr = ""
		local queueName = manorCityUtil.getQueueShowName(gQueueTypeDef.garden_technology)
		if queueName then
			_ENV = true
			;(true).techName = queueName
			tipStr = i18n("garden_text_48", true)
			self.labelTip:setVisible(true)
		else
			self:setIdleState()
		end
		coolingData.tip = tipStr
	else
		if not self.buildEntity then
			return
		end
		local buildState
		local bid = 0
		local iid = 0
		if buildEntity then
			buildState = tonumber(buildEntity:getBuildState())
			bid = self.buildEntity:getBuildBid()
			iid = self.buildEntity:getIid()
		end
		local isBuildCooling = true
		if buildState == BUILD_STATE.BUILDING then
			coolingData.tip = i18n("common_text_043")
			coolingData.icon = "icon_main_build_09.png"
			isBuildCooling = true
			self.isBuildCooling = isBuildCooling
		elseif buildState == BUILD_STATE.UPGRADEING then
			coolingData.tip = i18n("common_text_056")
			coolingData.icon = "icon_main_build_03.png"
			isBuildCooling = true
			self.isBuildCooling = isBuildCooling
		elseif buildState == BUILD_STATE.DEMOLISHING then
			coolingData.tip = i18n("common_text_038")
			coolingData.icon = "icon_main_build_09.png"
			isBuildCooling = true
			self.isBuildCooling = isBuildCooling
		elseif buildState == BUILD_STATE.NORMAL then
			isBuildCooling = false
			self.isBuildCooling = isBuildCooling
			if bid == BUILDID.STABLES then
				coolingData.icon = "icon_main_build_04.png"
				local armyid, armycount = buildEntity:getTrainingAidAndCount()
				local armyName = armyDes.getName(armyid)
				_ENV = buildEntity:getBuildState()
				buildEntity:getBuildState().name = armyName
				buildEntity:getBuildState().num = armycount
				local strTip = i18n("common_text_036", buildEntity:getBuildState())
				coolingData.tip = strTip
			elseif bid == BUILDID.RANGE then
				coolingData.icon = "icon_main_build_01.png"
				local armyid, armycount = buildEntity:getTrainingAidAndCount()
				local armyName = armyDes.getName(armyid)
				_ENV = buildEntity:getBuildState()
				buildEntity:getBuildState().name = armyName
				buildEntity:getBuildState().num = armycount
				local strTip = i18n("common_text_036", buildEntity:getBuildState())
				coolingData.tip = strTip
			elseif bid == BUILDID.FORTRESS then
				coolingData.icon = "icon_main_build_06.png"
				local armyid, armycount = buildEntity:getTrainingAidAndCount()
				local armyName = armyDes.getName(armyid)
				_ENV = buildEntity:getBuildState()
				buildEntity:getBuildState().name = armyName
				buildEntity:getBuildState().num = armycount
				local strTip = i18n("common_text_036", buildEntity:getBuildState())
				coolingData.tip = strTip
			elseif bid == BUILDID.BARRACKS then
				coolingData.icon = "icon_main_build_07.png"
				local armyid, armycount = buildEntity:getTrainingAidAndCount()
				local armyName = armyDes.getName(armyid)
				_ENV = buildEntity:getBuildState()
				buildEntity:getBuildState().name = armyName
				buildEntity:getBuildState().num = armycount
				local strTip = i18n("common_text_036", buildEntity:getBuildState())
				coolingData.tip = strTip
			elseif bid == BUILDID.CHARIOT_PLANT then
				coolingData.icon = "icon_main_build_02.png"
				local armyid, armycount = buildEntity:getTrainingAidAndCount()
				local armyName = armyDes.getName(armyid)
				_ENV = buildEntity:getBuildState()
				buildEntity:getBuildState().name = armyName
				buildEntity:getBuildState().num = armycount
				local strTip = i18n("common_text_036", buildEntity:getBuildState())
				coolingData.tip = strTip
			elseif bid == BUILDID.BLACK_SMITH then
				coolingData.icon = "icon_main_build_08.png"
				local armyid, armycount = buildEntity:getTrainingAidAndCount()
				local armyName = equipDesRead.getName(armyid)
				local strTip = armyName
				coolingData.tip = strTip
				isBuildCooling = true
				self.isBuildCooling = isBuildCooling
			elseif bid == BUILDID.HOSTPITAL then
				coolingData.icon = "icon_main_build_10.png"
				local buildDescribeRead = include("buildDescribeRead")
				local queueType = buildDescribeRead.getQueueType(bid)
				local armyCtrl = gametop.playertop_:getModule("armyCtrl")
				local curingNum = armyCtrl:getCuringArmyCount(queueType)
				if curingNum == nil then
					curingNum = 0
				end
				local strTip = i18n("common_text_064") .. " " .. SoraDConvertNumberWithUnit(curingNum)
				coolingData.tip = strTip
				isBuildCooling = true
				self.isBuildCooling = isBuildCooling
			elseif bid == BUILDID.COLLEGE then
				coolingData.icon = "icon_main_build_05.png"
				local collegeDesRead = include("collegeDesRead")
				local gametop = gModuleMgr.getObject("gametop")
				local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
				local collegeData = technologyCtrl:studyingTechnology()
				local strTechName = collegeDesRead.getName(tonumber(collegeData.technologyID))
				local strTip = strTechName
				coolingData.tip = strTip
				isBuildCooling = true
				self.isBuildCooling = isBuildCooling
			elseif bid == BUILDID.NEBULA_PALACE then
				coolingData.icon = "icon_main_build_05.png"
				local collegeDesRead = include("collegeDesRead")
				local gametop = gModuleMgr.getObject("gametop")
				local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
				local collegeData = technologyCtrl:studyingTechnology(gQueueTypeDef.nebula_palace_technology)
				local strTechName = collegeDesRead.getName(tonumber(collegeData.technologyID))
				local strTip = strTechName
				coolingData.tip = strTip
				isBuildCooling = true
				self.isBuildCooling = isBuildCooling
			elseif bid == BUILDID.MIRACLE then
				coolingData.icon = "icon_main_build_05.png"
				local collegeDesRead = include("collegeDesRead")
				local gametop = gModuleMgr.getObject("gametop")
				local technologyCtrl = gametop.playertop_:getModule("technologyCtrl")
				local collegeData = technologyCtrl:studyingTechnology(gQueueTypeDef.war_tech_research)
				local strTechName = collegeDesRead.getName(tonumber(collegeData.technologyID))
				local strTip = strTechName
				coolingData.tip = strTip
				isBuildCooling = true
				self.isBuildCooling = isBuildCooling
			elseif bid == BUILDID.MATERIAL_WORKSHOP then
				coolingData.icon = "icon_workshop_working.png"
				local aid, acount = buildEntity:getTrainingAidAndCount()
				local strTip = itemDesRead.getName(aid)
				coolingData.tip = strTip
				isBuildCooling = true
				self.isBuildCooling = isBuildCooling
			elseif bid == BUILDID.ELITE_PALACE then
				coolingData.icon = "icon_Elite_train.png"
				local armyid, armycount = buildEntity:getTrainingAidAndCount()
				local armyName = armyDes.getName(armyid)
				_ENV = strTechName
				strTechName.name = armyName
				strTechName.num = armycount
				local strTip = i18n("common_text_036", strTechName)
				coolingData.tip = strTip
			elseif bid == BUILDID.STAR_BRAVE_STATUE then
				local strTip
				coolingData.icon = "icon_main_build_08.png"
				isBuildCooling = false
				local queueType = buildRead.getQueueType(bid)
				if queueType == gQueueTypeDef.craft_study then
					local collegeDesRead = include("collegeDesRead")
					local collegeData = technologyCtrl:studyingTechnology(gQueueTypeDef.craft_study)
					strTip = collegeDesRead.getName(tonumber(collegeData.technologyID))
					coolingData.icon = "icon_main_build_armor_forging.png"
					isBuildCooling = true
				else
					local queueData = self:getQueue().data
					local armorSystemRead = gModuleMgr.sharedMgr("armorSystemRead")
					dump(queueData, "queueData")
					_ENV = "queueData"
					;("queueData").name = i18n(armorSystemRead:getProperty(tonumber(queueData.armorId), "name"))
					;("queueData").var = string.formatnumberthousands(queueData.count)
					strTip = i18n("Soldiers_armor_text_5", "queueData")
				end
				coolingData.tip = strTip
				isBuildCooling = true
				self.isBuildCooling = isBuildCooling
			elseif bid == BUILDID.MAGIC_LAMP then
				local strTip
				coolingData.icon = "icon_main_build_08.png"
				isBuildCooling = false
				if self.coolingType == BUILD_COOLING_TYPE.MAGIC_LAMP_BREAK then
					strTip = i18n("magic_lamp_text_019")
				elseif self.coolingType == BUILD_COOLING_TYPE.MAGIC_LAMP_STRENGTH then
					strTip = i18n("magic_lamp_text_017")
				elseif self.coolingType == BUILD_COOLING_TYPE.MAGIC_LAMP_CLASS then
					strTip = i18n("magic_lamp_text_018")
				elseif self.coolingType == BUILD_COOLING_TYPE.MAGIC_LAMP_HATCH_UPGRADE then
					strTip = i18n("Jinn_hatch_text_33")
				end
				coolingData.tip = strTip
				isBuildCooling = true
				self.isBuildCooling = isBuildCooling
			end
		end
	end
	self.coolingData = coolingData
	self.labelTip:setString(coolingData.tip)
	local frameNo = display.newSpriteFrame(coolingData.icon)
	self.spriteIcon:setSpriteFrame(frameNo)
	self.spriteIcon:setRotation(rotation)
	self.spriteIcon:setScale(scale)
	local queue = self:getQueue()
	if queue == nil then
		return
	end
	local remainTime = queue.timerNode.timer:getRemainTime()
	if 0 < remainTime then
		self:setVisible(true)
	end
end
function cityBuildCoolingTip:endCooling()
	SoraDManagerRemoveTimer(self, self.timeHandler)
	self.labelTime:setString("")
	self.loadingBar:setPercent(0)
	self:setVisible(false)
	local buildEntity = self.buildEntity
	if buildEntity then
		local bid = buildEntity:getBuildBid()
		local iid = buildEntity:getIid()
		if buildEntity.fsm_:getState() == "working" then
			if bid == BUILDID.HOSTPITAL then
				buildEntity:setBlockState("idle")
			elseif true == buildEntity:getIsCanHarvestTrain() then
				buildEntity:setBlockState("harvesting")
			else
				if buildEntity:getIsCancel() == true then
					print("TODO: 添加资源返还动画")
					_ENV = "TODO: 添加资源返还动画"
					;("TODO: 添加资源返还动画").msg = "MESSAGE_MAINCITYVIEW_ADD_HARVEST_FLOATING"
					;("TODO: 添加资源返还动画").index = buildEntity:getBuildIndex()
					;("TODO: 添加资源返还动画").buildEntity = self.buildEntity
					;("TODO: 添加资源返还动画").isResReturnBack = true
					SoraDSendMessage("TODO: 添加资源返还动画")
				end
				buildEntity:setBlockState("idle")
			end
			buildEntity:setIsWaitTraining(false)
		elseif buildEntity.fsm_:getState() == "building" then
			if buildEntity:getIsCancel() == true then
				print("TODO: 添加资源返还动画")
				_ENV = "TODO: 添加资源返还动画"
				;("TODO: 添加资源返还动画").msg = "MESSAGE_MAINCITYVIEW_ADD_HARVEST_FLOATING"
				;("TODO: 添加资源返还动画").index = buildEntity:getBuildIndex()
				;("TODO: 添加资源返还动画").buildEntity = self.buildEntity
				;("TODO: 添加资源返还动画").isResReturnBack = true
				SoraDSendMessage("TODO: 添加资源返还动画")
			end
			buildEntity:setBlockState("idle")
		elseif buildEntity.fsm_:getState() == "demolishing" then
			local buildCell = buildEntity:getBuildCell()
			if nil == buildCell then
				_ENV = "idle"
				;("idle").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD"
				;("idle").index = buildEntity:getBuildIndex()
				SoraDSendMessage("idle")
				return
			else
				_ENV = "idle"
				;("idle").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
				;("idle").buildIndex = buildIndex
				SoraDSendMessage("idle")
				buildEntity:setBlockState("idle")
			end
		end
		buildEntity:changeState()
		buildEntity:updateLv()
		buildEntity:setIsCanSpeedUpFree(false)
		buildEntity:setIsCanResearchFree(false)
	end
	self.buildEntity = nil
end
function cityBuildCoolingTip:setIdleState()
	self.loadingBar:setPercent(0)
	self.labelTime:setVisible(true)
	self.labelTime:setString(i18n("herotrain_text_01"))
	self.labelTip:setVisible(false)
end
function cityBuildCoolingTip:onExit()
	SoraDRemoveMessageByTarget(self)
	SoraDManagerRemoveTimerByTarget(self)
	self:freeImages()
	self:onExitOther()
end
return cityBuildCoolingTip
