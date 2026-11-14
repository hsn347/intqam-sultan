local radiantDecreeCtrl = SoraDGetCtrl("radiantDecreeCtrl")
local buffCtrl = SoraDGetCtrl("buffCtrl")
local buildLogic = include("buildLogic")
local buildRead = include("buildDescribeRead")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local luckyBlessCtrl = SoraDGetCtrl("luckyBlessCtrl")
local wiseTutorCtrl = SoraDGetCtrl("wiseTutorCtrl")
local ExtremelySkillfulCtrl = SoraDGetCtrl("ExtremelySkillfulCtrl")
local artisanHouseCtrl = SoraDGetCtrl("artisanHouseCtrl")
local warOrderCtrl = SoraDGetCtrl("warOrderCtrl")
local warHornCtrl = SoraDGetCtrl("warHornCtrl")
local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local BuildCreateInfoPanel = class("BuildCreateInfoPanel", baseFguiPanel)
local CAN_BUILD = 0
local CANT_BY_BUILD = 1
local CANT_BY_BUILDER = 2
local CANT_BY_RES = 3
local CANT_BY_TOOL = 4
local NEED_BUY_BUILDER = 5
function BuildCreateInfoPanel:ctor(...)
	BuildCreateInfoPanel.super.ctor(self, ...)
	print("BuildCreateInfoPanel:ctor", self.viewName)
	self.warLv = 0
	self.warToLv = 0
	self.warCurPro = 0
	self.needWarBadgeBuy = 0
	self.needWarBadgeID = gBadgeItemID.COMMON_BADGE_ID
	self.viewType = BUILD_OPERATE_TYPE.BUILD
	self.buildType = CAN_BUILD
	self.buffData, BuildCreateInfoPanel, self.tableScrollSingles, BuildCreateInfoPanel, self.tableBuildInfo, BuildCreateInfoPanel, self.buffBuildType = BUILD_ENUM.CASTLE, BUILD_ENUM.CASTLE, BUILD_ENUM.CASTLE, BUILD_ENUM.CASTLE, BUILD_ENUM.CASTLE, BUILD_ENUM.CASTLE, BUILD_ENUM.CASTLE
end
function BuildCreateInfoPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function BuildCreateInfoPanel:onInit()
	print("=======BuildCreateInfoPanel:onInit")
	self.fields.resourceMenu:updateResource()
	self.labelName = self.fields.Com_name
	self.labelNextLv = self.fields.Text_nextLv
	self.fields.Com_upLv:setVisible(false)
	self.labelDes = self.fields.Text_buildDes
	self.btnUp = self.fields.Button_up
	self.btnUpNow = self.fields.Button_upNow
	self.btnUnlock = self.fields.Button_unlock
	self.btnUnlock:setVisible(false)
	self.labelFreeTip = self.fields.Text_freeTip
	self.btnHelp = self.fields.Com_name:getChild("Button_help")
	self.btnHelp:setVisible(false)
	self.labelLuckyDay = self.fields.Text_luckyDay
	self.labelLuckyDay:setVisible(false)
	self.btnUp:setCostIcon("icon_hourglass.png")
	self.btnUp:addClickListener(handler(self, self.btnUpCallBack))
	self.btnUpNow:addClickListener(handler(self, self.btnUpNowCallBack))
	self.btnUnlock:addClickListener(handler(self, self.btnUpCallBack))
	self.btnHelp:addClickListener(handler(self, self.btnHelpCallBack))
	self.fields.List_buff:setItemRenderer(handler(self, self.onBuffItemRenderer))
	self.fields.List_des:setItemRenderer(handler(self, self.onDesItemRenderer))
	self.scrollUp = self.fields.ScrollView_up
	self.imgLight = self.scrollUp:getChild("Image_light")
	self.imgLight:setVisible(false)
	self.fields.Label_title:setString(i18n("common_text_726"))
	self.fields.Com_armyLock:setVisible(false)
	local btnUnlocked = self.fields.Com_armyLock:getChild("icon")
	btnUnlocked:addClickListener(handler(self, self.btnUnlockedCallBack))
	if not SoraDFIsRA() then
		self.btnUp:fixPos()
		self.btnUpNow:fixPos()
	end
end
function BuildCreateInfoPanel:onShow()
	print("=======BuildCreateInfoPanel:onShow")
	_ENV = "=======BuildCreateInfoPanel:onShow"
	;("=======BuildCreateInfoPanel:onShow").isHideMainUI = true
	SoraDHideCurrentSceneViewAndMainUI("=======BuildCreateInfoPanel:onShow")
	self.controllers.c_type:setSelectedIndex(0)
	local param = self.param
	if param.upgradeData then
		self:initUpgradeData(param.upgradeData)
	end
	if param.buildData then
		self:initBuildData(param.buildData)
	end
	if param.isFromCreate then
		self:setFromCreate(param.isFromCreate)
	end
	if param.unlockAreaID then
		self:initUnlockData(param.unlockAreaID)
	end
end
function BuildCreateInfoPanel:setFromCreate(isFromCreate)
	self.isFromCreate = isFromCreate
end
function BuildCreateInfoPanel:updateLuckyBless()
	local luckyData = luckyBlessCtrl:getLuckyData()
	if luckyData.curEffectType == gLuckyBlessActivityEffectType.BUILD_UPGRADE and self.viewType == BUILD_OPERATE_TYPE.UPGRADE then
		if self.luckyBlessTimer == nil then
			self:openLuckyTime()
			self.luckyBlessTimer = SoradCreateTimer(self, handler(self, self.openLuckyTime))
		end
		self.labelLuckyDay:setVisible(true)
		self.luckyBlessIsOpen = true
	else
		self.labelLuckyDay:setVisible(false)
		self.luckyBlessIsOpen = false
	end
end
function BuildCreateInfoPanel:openLuckyTime(dt)
	local luckyData = luckyBlessCtrl:getLuckyData()
	local leftTime = luckyBlessCtrl:getRealTime()
	luckyBlessCtrl = nil
	;(nil).num = string.format("%d%%", luckyData.discount / 10)
	;(nil).time = SoraDConvertSecondToString(leftTime)
	self.labelLuckyDay:setString(i18n("lucky_text_18", nil))
	if leftTime <= 0 or not self.luckyBlessIsOpen then
		SoraDManagerRemoveTimer(self, self.luckyBlessTimer)
		self.luckyBlessTimer = nil
	end
end
function BuildCreateInfoPanel:updateListBuffData()
	self:updateWiseTutorBuff()
	self:updateArtisanHouseBuff()
	self:updateExtremelyBuff()
	self:updateListBuff()
end
function BuildCreateInfoPanel:updateListBuff()
	_ENV, self.buffDataList = table.keys(self.buffData), table.keys(self.buffData)
	table.keys(self.buffData)[gActivityTimeActivityID.WISE_TUTOR_ACTIVITY] = 1
	table.keys(self.buffData)[gActivityTimeActivityID.ARTISAN_HOUSE_ACTIVITY] = 2
	table.keys(self.buffData)[gActivityTimeActivityID.EXTREMELY_SKILLFUIL] = 3
	table.keys(self.buffData)[gActivityTimeActivityID.RADIANT_DECREE_ACTIVITY] = 4
	table.keys(self.buffData)[gActivityTimeActivityID.WAR_ORDER_ACTIVITY] = 5
	table.keys(self.buffData)[gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001581] = 6
	table.keys(self.buffData)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001601] = 7
	table.keys(self.buffData)[gActivityTimeActivityID.PREPARE_FOR_WAR_ACTIVITY] = 8
	local table.keys(self.buffData)[gActivityTimeActivityID.CRESCENT_ORDER_ACTIVITY], sortValue = 9, table.keys(self.buffData)
	table.sort(self.buffDataList, function(eid1, eid2)
		return sortValue[eid1] < sortValue[eid2]
	end)
	if self.tableBuildInfo and self.tableBuildInfo.buildID then
		self.fields.List_buff:setNumItems(#self.buffDataList)
	end
end
function BuildCreateInfoPanel:updateWiseTutorBuff()
	local activityID = gActivityTimeActivityID.WISE_TUTOR_ACTIVITY
	local state, leftTime = wiseTutorCtrl:getStateInfo()
	if state == gActivityState.OPEN then
		self.buffData[activityID] = true
		self.wiseTutorIsOpen = wiseTutorCtrl:isBuffEffect()
	else
		self.buffData[activityID] = nil
		self.wiseTutorIsOpen = false
	end
end
function BuildCreateInfoPanel:updateArtisanHouseBuff()
	local activityID = gActivityTimeActivityID.ARTISAN_HOUSE_ACTIVITY
	local state, leftTime = artisanHouseCtrl:getStateInfo()
	if state == gActivityState.OPEN then
		self.buffData[activityID] = true
		self.artisanHouseIsOpen = artisanHouseCtrl:isBuffEffect()
	else
		self.buffData[activityID] = nil
		self.artisanHouseIsOpen = false
	end
end
function BuildCreateInfoPanel:updateExtremelyBuff(...)
	local activityID = gActivityTimeActivityID.EXTREMELY_SKILLFUIL
	if self.tableBuildInfo.buildID.bid ~= BUILDID.NEBULA_PALACE and ExtremelySkillfulCtrl:isActivityOpen() then
		self.buffData[activityID] = true
		self.extremelyIsOpen = ExtremelySkillfulCtrl:isBuffEffect()
	else
		self.buffData[activityID] = nil
		self.extremelyIsOpen = false
	end
end
function BuildCreateInfoPanel:updateRadiantDecreeBuff()
	local activityID = gActivityTimeActivityID.RADIANT_DECREE_ACTIVITY
	local state, leftTime = radiantDecreeCtrl:getStateInfo()
	if state == gActivityState.OPEN and radiantDecreeCtrl:canUnlockStatue() then
		self.buffData[activityID] = true
		self.radiantDecreeIsOpen = false
	else
		self.buffData[activityID] = nil
		self.radiantDecreeIsOpen = false
	end
end
function BuildCreateInfoPanel:updateWarOrderBuff()
	local activityID1 = gActivityTimeActivityID.WAR_ORDER_ACTIVITY
	if clientEventMgr.judgeIsOpen(activityID1) and warOrderCtrl:getBuffType() > 0 then
		self.buffData[activityID1] = true
	else
		self.buffData[activityID1] = nil
	end
	local activityID2 = gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001581
	if clientEventMgr.judgeIsOpen(activityID2) and warHornCtrl:getBuffType() > 0 and warHornCtrl:isShowBuff() then
		self.buffData[activityID2] = true
	else
		self.buffData[activityID2] = nil
	end
	dump(self.buffData, "self.buffData====")
end
function BuildCreateInfoPanel:updateBuff_9001710()
	local activityID = gActivityTimeActivityID.CRESCENT_ORDER_ACTIVITY
	local activity_9001710_Ctrl = SoraDGetCtrl("activity_9001710_Ctrl")
	if clientEventMgr.judgeIsOpen(activityID) and activity_9001710_Ctrl:isBuffEffect(self.buffBuildType, self.tableBuildInfo.buildID.bid) then
		self.buffData[activityID] = true
	else
		self.buffData[activityID] = nil
	end
end
function BuildCreateInfoPanel:updateBuff_9001601()
	if not include("constantRead").checkRamadanBlessBuffSwitch() then
		return
	end
	local activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001601
	local curCtrl = warOrderCtrl:getCurCtrl(activityID)
	if clientEventMgr.judgeIsOpen(activityID) and curCtrl:isBuffEffect(self.buffBuildType) then
		self.buffData[activityID] = true
	else
		self.buffData[activityID] = nil
	end
end
function BuildCreateInfoPanel:updateBuff_9001656()
	local activityID = gActivityTimeActivityID.PREPARE_FOR_WAR_ACTIVITY
	local curCtrl = warOrderCtrl:getCurCtrl(activityID)
	if clientEventMgr.judgeIsOpen(activityID) and curCtrl:isBuffEffect(self.buffBuildType) then
		self.buffData[activityID] = true
	else
		self.buffData[activityID] = nil
	end
end
function BuildCreateInfoPanel:resUpdate()
	self:reloadScroll(false)
	if self.viewType == BUILD_OPERATE_TYPE.BUILD then
		local _iscanbuild, retdata = buildLogic.isCanBuild(self.tableBuildInfo.buildID.bid)
		self.tableBuildInfo.buildData = retdata
		self:initBuildData(self.tableBuildInfo)
	elseif self.viewType == BUILD_OPERATE_TYPE.UPGRADE then
		_ENV = self.initBuildData
		self.initBuildData.bid = self.tableBuildInfo.buildID.bid
		self.initBuildData.iid = self.tableBuildInfo.buildID.iid
		self.initBuildData.buildEntity = self.tableBuildInfo.buildID.buildEntity
		self.initBuildData.index = self.tableBuildInfo.buildType.buildIndex
		self:initUpgradeData(self.initBuildData)
	elseif self.viewType == BUILD_OPERATE_TYPE.UNLOCK then
		self:initUnlockData(self.tableBuildInfo.areaid)
	end
end
function BuildCreateInfoPanel:setBuildBtnTouchEnable(isEnable)
	self.btnUp:setEnabled(isEnable)
	self.btnUpNow:setEnabled(isEnable)
	if self.btnUnlock then
		self.btnUnlock:setEnabled(isEnable)
	end
end
function BuildCreateInfoPanel:updateView()
	if self.labelNextLv then
		local isVisible = self.viewType == BUILD_OPERATE_TYPE.UPGRADE or self.viewType == BUILD_OPERATE_TYPE.UPGRADE_STAR
		self.labelNextLv:setVisible(isVisible)
		self.labelDes:setVisible(not isVisible)
	end
	if self.viewType ~= BUILD_OPERATE_TYPE.UNLOCK then
		self.btnUpNow:setCostTitle(string.formatnumberthousands(self.tableBuildInfo.buildData._immediatelyGold))
		self.btnUp:setCostTitle(SoraDConvertSecondToString(self.tableBuildInfo.buildData._costtime))
		local freeTime = 0
		if self.viewType == BUILD_OPERATE_TYPE.UPGRADE then
			local buildCell = cityCtrl:getBuildCell(self.tableBuildInfo.buildID.bid, self.tableBuildInfo.buildID.iid)
			freeTime = buildLogic.getFreeSpeedUpTime(buildCell.info.lv)
		else
			freeTime = buildLogic.getFreeSpeedUpTime()
		end
		print("slkdfjlkdsjflksdj", freeTime)
		if freeTime >= self.tableBuildInfo.buildData._costtime then
			self.isFree = true
		else
			self.isFree = false
		end
		self:setBtnUpNowState()
	else
		self.btnUp:setVisible(false)
		self.btnUpNow:setVisible(false)
		self.btnUnlock:setVisible(true)
	end
	self:setBuildBtnTouchEnable(true)
	self:initScroll()
	self:setSpecail()
end
function BuildCreateInfoPanel:setBtnUpNowState()
	if self.viewType == BUILD_OPERATE_TYPE.UPGRADE or self.viewType == BUILD_OPERATE_TYPE.BUILD then
		if self.isFree and self.isEnough then
			self.btnUpNow:setCostTitle(i18n("common_text_049"))
			local freeTime = 0
			if self.viewType == BUILD_OPERATE_TYPE.UPGRADE then
				local buildCell = cityCtrl:getBuildCell(self.tableBuildInfo.buildID.bid, self.tableBuildInfo.buildID.iid)
				freeTime = buildLogic.getFreeSpeedUpTime(buildCell.info.lv)
			else
				freeTime = buildLogic.getFreeSpeedUpTime()
			end
			freeTime = math.floor(freeTime / 60)
			_ENV = i18n("common_text_049")
			i18n("common_text_049").time = freeTime
			self.labelFreeTip:setString(i18n("common_text_3821", i18n("common_text_049")))
			self.labelFreeTip:setVisible(true)
			if not SoraDIsGameGuide() and not self.haveFreeMild then
				self.haveFreeMild = true
				cityCtrl = i18n("common_text_3821", i18n("common_text_049"))
				i18n("common_text_3821", i18n("common_text_049"))[1] = ffa.delay(0.1)
				i18n("common_text_3821", i18n("common_text_049"))[2] = ffa.callFunc(function()
					_ENV = nil
					;(nil).z = 2
					gModuleMgr.sharedMgr("mildGuideManager"):drawFingerToTarget(self.btnUpNow, nil)
				end)
				i18n("common_text_3821", i18n("common_text_049"))[3] = ffa.callFunc(function()
					_ENV = nil
					;(nil).z = 2
					gModuleMgr.sharedMgr("mildGuideManager"):drawFingerToTarget(self.btnUpNow, nil)
				end)
				self:runAction(ffa.seq(i18n("common_text_3821", i18n("common_text_049"))))
			end
		else
			if self.haveFreeMild then
				gModuleMgr.sharedMgr("mildGuideManager"):clean()
				self.haveFreeMild = false
			end
			self.labelFreeTip:setVisible(false)
		end
	end
end
function BuildCreateInfoPanel:initUnlockView()
	self.labelDes:setString(i18n("common_text_741"))
	self.btnUnlock:setString(i18n("common_text_740"))
	self.labelName:setVisible(false)
end
function BuildCreateInfoPanel:initBuildView()
	if self.tableBuildInfo.buildID.bid == BUILDID.MIRACLE then
		self.labelDes:setString(buildRead.getBrief(self.tableBuildInfo.buildID.bid))
		_ENV = self.labelDes
		self.labelDes.msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_PREVIEW"
		self.labelDes.index = self.tableBuildInfo.buildType.buildIndex
		self.labelDes.bid = self.tableBuildInfo.buildID.bid
		SoraDSendMessage(self.labelDes)
	else
		self.labelDes:setString(buildRead.getDes(self.tableBuildInfo.buildID.bid))
	end
	self.btnUp:setString(i18n("common_text_042"))
	self.btnUpNow:setString(i18n("common_text_379"))
	self.labelName:setString(buildRead.getName(self.tableBuildInfo.buildID.bid))
end
function BuildCreateInfoPanel:runActClose()
	if tolua.isnull(self) then
		return
	end
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(0.01)
	;(nil)[2] = ffa.callFunc(function()
		self:closePanel()
	end)
	;(nil)[3] = ffa.callFunc(function()
		self:closePanel()
	end)
	self:runAction(ffa.seq(nil))
end
function BuildCreateInfoPanel:initUpgradeView()
	local buildCell = cityCtrl:getBuildCell(self.tableBuildInfo.buildID.bid, self.tableBuildInfo.buildID.iid)
	local isWar, warLv, warCurPro = buildLogic.isBuildWarLv(buildCell.info.lv)
	if isWar then
		local bid = self.tableBuildInfo.buildID.bid
		local iid = self.tableBuildInfo.buildID.iid
		if not buildLogic.isBuildingUnlock(bid, iid) or buildLogic.buildLvIsFull(bid, iid) then
			self:runActClose()
			return
		end
		self.warLv = warLv
		self.warCurPro = warCurPro
		self.warToLv = buildLogic.transformBuildLvToWarLv(buildCell.info.lv + 10)
		self:initWarView()
		self.fields.List_des:setNumItems(0)
		self.fields.Com_armyLock:setVisible(false)
	else
		self.fields.bar_war:setVisible(false)
		self.btnHelp:setVisible(false)
		self.fields.Com_upLv:setVisible(false)
		local upgradeDes = buildRead.getUpgradeDes(tonumber(self.tableBuildInfo.buildID.bid))
		if upgradeDes then
			self.labelDes:setVisible(true)
			self.labelDes:setString(upgradeDes)
			self:showUnlockedInfo()
		end
		self:initUpgradeDes(upgradeDes)
		self.labelNextLv:setString(i18n("common_text_280") .. tostring(tonumber(buildCell.info.lv) + 1))
		cityCtrl = tonumber(self.tableBuildInfo.buildID.bid)
		tonumber(self.tableBuildInfo.buildID.bid).level = buildCell.info.lv
		self.labelName:setString(buildRead.getName(self.tableBuildInfo.buildID.bid) .. "\n" .. i18n("common_text_420", tonumber(self.tableBuildInfo.buildID.bid)))
	end
	self.btnUp:setString(i18n("common_text_055"))
	self.btnUpNow:setString(i18n("common_text_378"))
end
function BuildCreateInfoPanel:initWarView(...)
	self.fields.bar_war:setVisible(true)
	self.btnHelp:setVisible(true)
	self.labelName:setString(buildRead.getName(self.tableBuildInfo.buildID.bid))
	buildRead = buildRead.getName(self.tableBuildInfo.buildID.bid)
	buildRead.getName(self.tableBuildInfo.buildID.bid).warLv = self.warLv
	buildRead.getName(self.tableBuildInfo.buildID.bid).warCurPro = self.warCurPro
	buildRead.getName(self.tableBuildInfo.buildID.bid).warToLv = self.warToLv
	self.fields.bar_war:initData(buildRead.getName(self.tableBuildInfo.buildID.bid))
	self.labelNextLv:setString(i18n("common_text_280"))
	self.labelDes:setVisible(true)
	self.labelDes:setString(i18n("buildDes_upgrade_brief_301"))
	self.fields.Com_upLv:setVisible(true)
	buildRead = i18n("buildDes_upgrade_brief_301")
	i18n("buildDes_upgrade_brief_301").value = self.warCurPro * 100 .. "%"
	i18n("buildDes_upgrade_brief_301").plusValue = "+10%"
	self:initUpDesSingle(self.fields.Com_upLv, i18n("buildDes_upgrade_brief_301"))
end
function BuildCreateInfoPanel:showUnlockedInfo()
	self.fields.Com_armyLock:setVisible(false)
	local buildMoreInfoRead = include("buildMoreInfoRead")
	local buildCell = cityCtrl:getBuildCell(self.tableBuildInfo.buildID.bid, self.tableBuildInfo.buildID.iid)
	local unlockedID, unlockedLv = buildMoreInfoRead.getNextUnlockedInfo(self.tableBuildInfo.buildID.bid, buildCell.info.lv)
	if unlockedID then
		if unlockedLv == tonumber(buildCell.info.lv) + 1 then
			self.fields.Com_armyLock:setString(i18n("common_text_1150"))
		else
			_ENV = i18n("common_text_1150")
			i18n("common_text_1150").blv = unlockedLv
			self.fields.Com_armyLock:setString(i18n("common_text_1151", i18n("common_text_1150")))
		end
		local btnImgName
		if self.tableBuildInfo.buildID.bid == BUILDID.CASTLE then
			btnImgName = include("buildDescribeRead").getIcon(unlockedID)
		elseif self.tableBuildInfo.buildID.bid == BUILDID.COLLEGE then
			btnImgName = include("collegeDesRead").getIcon(unlockedID)
		elseif self.tableBuildInfo.buildID.bid == BUILDID.ELITE_PALACE or self.tableBuildInfo.buildID.bid == BUILDID.STABLES or self.tableBuildInfo.buildID.bid == BUILDID.RANGE or self.tableBuildInfo.buildID.bid == BUILDID.CHARIOT_PLANT or self.tableBuildInfo.buildID.bid == BUILDID.BARRACKS or self.tableBuildInfo.buildID.bid == BUILDID.FORTRESS then
			btnImgName = include("armyDesRead").getIcon(unlockedID)
		end
		if btnImgName then
			self.fields.Com_armyLock:setVisible(true)
			self.labelDes:setVisible(false)
			self.fields.Com_armyLock:setIcon(btnImgName)
			self.tableBuildInfo.buildID.unlockedID = unlockedID
		end
	end
end
function BuildCreateInfoPanel:initUpgradeDes(isUpgradeDes, isStar)
	if isUpgradeDes then
		self.fields.List_des:setNumItems(0)
		return
	end
	local buildMoreInfoRead = include("buildMoreInfoRead")
	local tableUpData = buildMoreInfoRead.getUpgradeInfoData(self.tableBuildInfo.buildID.bid, self.tableBuildInfo.buildID.iid, isStar)
	self.tableUpData = tableUpData
	self.fields.List_des:setNumItems(#self.tableUpData)
end
function BuildCreateInfoPanel:initUnlockData(areaid)
	local cityltCtrl = include("cityltCtrl")
	;("cityltCtrl")._retCostWEs, _ENV, ("cityltCtrl")._buildQueueList, _ENV, ("cityltCtrl")._retCostTools, _ENV, ("cityltCtrl")._retPreCond, _ENV, ("cityltCtrl")._retCostRes, _ENV, _ENV = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "cityltCtrl"
	local retCostRes = "cityltCtrl"
	local costres = cityltCtrl.getOpenGoundInfo(areaid, "costRes")
	if costres then
		for i = 1, #costres / 2 do
			local _resid = costres[2 * i - 1]
			local _rescount = costres[2 * i]
			local _curcount = cityCtrl:getResCount(_resid)
			if 0 < _rescount then
				local _isreach = true
				if _rescount > _curcount then
					_isreach = false
				end
				_ENV = nil
				;(nil).resid = _resid
				;(nil).rescount = _rescount
				;(nil).curcount = _curcount
				;(nil).isreach = _isreach
				table.insert(retCostRes._retCostRes, nil)
			end
		end
	end
	_ENV = (for index)
	;(1).areaid = areaid
	self.tableBuildInfo, (1).buildData = 1, retCostRes
	self.viewType = BUILD_OPERATE_TYPE.UNLOCK
	self:updateView()
	self:initUnlockView()
	if self.btnUnlock:isVisible() and SoraDIsGameGuide() == nil then
		local guideCtrl = SoraDGetCtrl("guideCtrl")
		guideCtrl:updateGuideModule(gGuideModule.AREA_UNLOCK)
	end
end
function BuildCreateInfoPanel:initUpgradeData(buildID)
	local _iscanupgrade, retdata = buildLogic.isCanUpgrade(buildID.bid, buildID.iid)
	if retdata then
		buildLogic, buildLogic = nil, buildID.iid
		;(nil).bid = buildID.bid
		;(nil).iid = buildID.iid
		buildID.iid.buildID, (nil).buildEntity = nil, buildID.buildEntity
		buildLogic, buildID.iid.buildData = nil, retdata
		self.tableBuildInfo, buildID.iid.buildType, (nil).buildIndex = buildID.iid, nil, buildID.index
		self.viewType = BUILD_OPERATE_TYPE.UPGRADE
		self:updateLuckyBless()
		self:updateListBuffData()
		self:updateView()
		self:initUpgradeView()
	end
end
function BuildCreateInfoPanel:initBuildData(buildInfoData)
	self.tableBuildInfo = buildInfoData
	self.viewType = BUILD_OPERATE_TYPE.BUILD
	self:updateView()
	self:initBuildView()
end
function BuildCreateInfoPanel:scrollSingleCallBack(singleData)
	if singleData.singleType == BUILD_CONDITION_TYPE_TIME then
		local leftTime = singleData.singleData.timerNode.timer:getRemainTime()
		if leftTime <= 0 then
			self:reloadScroll(true)
		else
			local buildCell = cityCtrl:getBuildCell(singleData.singleData.data.bid, singleData.singleData.data.iid or 0)
			local freeTime = buildLogic.getFreeSpeedUpTime(buildCell.info.lv)
			local queueType = singleData.singleData.qtype
			if queueType then
				if tonumber(queueType) ~= gQueueTypeDef.build_star_queue and tonumber(queueType) ~= gQueueTypeDef.build_star_queue_privilege and tonumber(queueType) ~= gQueueTypeDef.glorious_upgrade and leftTime <= freeTime then
					queueCtrl:speedUpQueueReq(tonumber(queueType), SPEEDUP_TYPE.FREE)
				else
					local itemList = backpackCtrl:getSpeedUpItemList(gAbbrSpeedUpType.BUILD_UPGRADE)
					if next(itemList) ~= nil then
						SoraDShowSpeedUpByItemBox(tonumber(queueType), handler(self, self.speedUpBoxCallBack))
					else
						SoraDShowSpeedUpBox(singleData.singleData, handler(self, self.speedUpBoxCallBack))
					end
				end
			end
		end
	elseif singleData.singleType == BUILD_CONDITION_TYPE_BUILD then
		if self.spriteHand then
			self.spriteHand:stopAllActions()
			self.spriteHand:removeFromParent()
			self.spriteHand = nil
		end
		local lv, iid = cityCtrl:getBuildMaxLv(singleData.singleData.bid)
		local buildCell = cityCtrl:getBuildCell(singleData.singleData.bid, iid)
		local cityBuildMgr = include("cityBuildMgr")
		local buildEntity = cityBuildMgr:getBuildByBid(tonumber(singleData.singleData.bid), iid)
		local buildType = SoraDGetBuildTypeByBid(tonumber(singleData.singleData.bid))
		local isResBuild = buildLogic.getOutBuildIsResBuild(tonumber(singleData.singleData.bid))
		local mainCityFunctions = include("mainCityFunctions")
		local castleLv = mainCityFunctions:getCastleLv()
		local toScale = 1.0
		if buildType == 1 then
			toScale = 1.3
		end
		if not buildCell or buildEntity and (castleLv < buildEntity:getBuildLv() or buildType == 0 and buildEntity:getState() ~= "idle" or buildType == 1 and (not isResBuild and buildEntity:getState() ~= "idle" or isResBuild and (buildEntity:getState() == "building" or buildEntity:getState() == "demolishing"))) then
			print("退出界面=====")
			self.isSkip = false
			if not buildCell then
				GLOBAL_BUILD_PRE_BID = singleData.singleData.bid
			end
			local buildIndex = mainCityFunctions.getBuildIndexByBid(singleData.singleData.bid, iid)
			self.curBuildIndex = buildIndex
			_ENV = iid
			iid.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_PREVIEW"
			iid.index = self.tableBuildInfo.buildType.buildIndex
			SoraDSendMessage(iid)
			_ENV = iid
			iid.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP_HAND"
			iid.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD_TIP_HAND
			iid.bid = singleData.singleData.bid
			iid.iid = nil
			iid.isRecover = true
			SoraDSendMessage(iid)
			gModuleMgr.sharedMgr("mildGuideManager"):deleteRunEffect()
			SoraDRemoveAllPrePanelFromManager(self)
		else
			_ENV = SoraDRemoveAllPrePanelFromManager
			SoraDRemoveAllPrePanelFromManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_PREVIEW"
			SoraDRemoveAllPrePanelFromManager.index = self.tableBuildInfo.buildType.buildIndex
			SoraDSendMessage(SoraDRemoveAllPrePanelFromManager)
			self.isSkip = true
			self.firstRunWar = true
			local mainCityFunctions = include("mainCityFunctions")
			local bid = singleData.singleData.bid
			local buildIndex = mainCityFunctions.getBuildIndexByBid(bid, iid)
			self.curBuildIndex = buildIndex
			print("切换预览========", bid, self.curBuildIndex)
			local _iscanupgrade, retdata = buildLogic.isCanUpgrade(bid, iid)
			_ENV = iid
			iid.bid = bid
			iid.iid = iid
			iid.buildEntity = buildEntity
			_ENV, iid.buildData = self.curBuildIndex, retdata
			iid.buildType, self.curBuildIndex.buildIndex = self.curBuildIndex, self.curBuildIndex
			local iid.index, buildInfo = self.curBuildIndex, iid
			self.tableBuildInfo.buildID = buildInfo
			if self.viewType == BUILD_OPERATE_TYPE.UPGRADE_STAR then
				self.isUpdateStarJump = true
				SoraDRemoveAllPrePanelFromManager(self)
				_ENV = tonumber(singleData.singleData.bid)
				tonumber(singleData.singleData.bid).upgradeData = buildInfo
				uiManager:show("BuildCreateInfo", tonumber(singleData.singleData.bid))
			else
				self:initUpgradeData(buildInfo)
				self:reloadScroll(true)
				self:showUnlockedInfo()
				_ENV = self
				self.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
				self.noScaleDuration = true
				self.noOffsetDuration = true
				self.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD
				self.buildIndex = buildIndex
				self.scale = toScale
				self.ignorePreZoomScale = true
				SoraDSendMessage(self)
			end
		end
	elseif singleData.singleType == BUILD_CONDITION_TYPE_RES then
		local needBuyResList = clone(self.tableBuildInfo.buildData._retCostRes)
		for k, v in ipairs(needBuyResList) do
			if self.luckyBlessIsOpen then
				v.rescount = luckyBlessCtrl:getResult(v.rescount)
			end
			local subPercent = buildLogic.getActivityBuff(gBuffEffect.UPGRADE_CASTLE_COST_RES_REDUCE_FOR_POW, self.tableBuildInfo.buildID)
			v.rescount = math.ceil(v.rescount * subPercent)
		end
		_ENV = cityBuildMgr:getBuildByBid(tonumber(singleData.singleData.bid), iid)
		cityBuildMgr:getBuildByBid(tonumber(singleData.singleData.bid), iid).rid = singleData.singleData.resid
		cityBuildMgr:getBuildByBid(tonumber(singleData.singleData.bid), iid).needResData = needBuyResList
		uiManager:show("resourceBuyView", (cityBuildMgr:getBuildByBid(tonumber(singleData.singleData.bid), iid)))
	elseif singleData.singleType == BUILD_CONDITION_TYPE_TOOL then
		if singleData.singleData.toolid == gNebulaPalaceItemID then
			local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
			local curState = activityShowCtrl:getStateByID(gActivityTimeActivityID.SHIFTING_STARS_ACTIVITY)
			if curState == gActivityState.OPEN then
				uiManager:show("Shiftingstars")
				return
			end
			SoraDShowMsgTip(i18n("nebula_war_text_0175"))
			return
		end
		local itemDesRead = include("itemDesRead")
		local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
		local goodType = backpackltCtrl:getItemType(singleData.singleData.toolid)
		_ENV = i18n("nebula_war_text_0175")
		_ENV, i18n("nebula_war_text_0175").itemType = i18n("nebula_war_text_0175")
		i18n("nebula_war_text_0175").itemID = singleData.singleData.toolid
		i18n("nebula_war_text_0175").troopData, i18n("nebula_war_text_0175").needCount = i18n("nebula_war_text_0175")
		uiManager:show("PropBuyView", i18n("nebula_war_text_0175"))
	elseif singleData.singleType == BUILD_CONDITION_TYPE_WE then
		local toolid = singleData.singleData.toolid
		local _ENV, titleVar = "item_name_301901", toolid == gBadgeItemID.COMMON_BADGE_ID and i18n("item_name_301101") or i18n("item_name_301901")
		_ENV = "PropBuyView"
		;("PropBuyView").name = titleVar
		;("item_name_301901").title = i18n("equip_text_27", "PropBuyView")
		_ENV, ("item_name_301901").defaultBtnTitle = i18n("common_text_477"), i18n("common_text_477")
		i18n("common_text_477")[1] = i18n("common_text_1906")
		_ENV, ("item_name_301901").itemTitle, i18n("common_text_477")[2] = i18n("common_text_477"), i18n("common_text_477"), i18n("common_text_4589")
		i18n("common_text_477")[1] = function(data)
			local isOpen, lv = SoraDGetCtrl("badgeExchangeCtrl"):isOpenBadge()
			if not isOpen then
				_ENV = nil
				;(nil).blv = lv
				SoraDShowMsgTip(i18n("common_text_1151", nil))
			else
				_ENV = i18n("common_text_1151", nil)
				i18n("common_text_1151", nil).targetID = data.toolid
				uiManager:show("badgeBourseView", i18n("common_text_1151", nil))
			end
		end
		_ENV, _ENV, ("item_name_301901").btnCallBack, i18n("common_text_477")[2] = function()
			_ENV = nil
			;(nil).type = 0
			;(nil).jumpTab = "btnWar"
			uiManager:show("bagView", nil)
		end, i18n("common_text_477"), i18n("common_text_477"), function()
			_ENV = nil
			;(nil).type = 0
			;(nil).jumpTab = "btnWar"
			uiManager:show("bagView", nil)
		end
		;("item_name_301901").btnCallBackParam, i18n("common_text_477")[1], (function()
			_ENV = nil
			;(nil).type = 0
			;(nil).jumpTab = "btnWar"
			uiManager:show("bagView", nil)
		end).toolid = i18n("common_text_477"), function()
			_ENV = nil
			;(nil).type = 0
			;(nil).jumpTab = "btnWar"
			uiManager:show("bagView", nil)
		end, singleData.singleData.toolid
		local ("item_name_301901").size, param = 2, "item_name_301901"
		uiManager:show("GetWayPopBox", param)
	elseif singleData.singleType == BUILD_CONDITION_TYPE_NEBULATOWER then
		local nebulaWarUtil = include("nebulaWarUtil")
		nebulaWarUtil.jumpToBigWorldNebulaTower()
	elseif singleData.singleType == BUILD_CONDITION_TYPE_MAGIC then
		SoraDRemoveAllPanelFromManager()
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		mildGuideManager:starToUpgradeMagicLamp()
	end
end
function BuildCreateInfoPanel:speedUpBoxCallBack(type)
	if type == MSGBOX_CALLBACK_SPEEDUP then
		self:reloadScroll(true)
	end
end
function BuildCreateInfoPanel:screenQueueList()
	local queueListCount = table.nums(self.tableBuildInfo.buildData._buildQueueList)
	if queueListCount == 0 then
		return true, queueListCount
	elseif queueListCount == 1 then
		local idlebqueue, lefttime = buildLogic.getIdleBuildQueue()
		if idlebqueue then
			self.tableBuildInfo.buildData._buildQueueList, _ENV = nil, nil
			return true
		end
		return false, queueListCount
	elseif queueListCount == 2 then
		return false, queueListCount
	end
end
function BuildCreateInfoPanel:reloadScroll(initScroll)
	self.buildType = CAN_BUILD
	for i, v in ipairs(self.tableScrollSingles) do
		v:removeFromParent()
	end
	self.tableScrollSingles, CAN_BUILD = ipairs(self.tableScrollSingles)
	if initScroll then
		self:initScroll()
	end
end
function BuildCreateInfoPanel:initScroll()
	local needNebulaTower = self.tableBuildInfo.buildData._retPreNebulaTower and 1 or 0
	local needWECount = #self.tableBuildInfo.buildData._retCostWEs
	local preCondCount = #self.tableBuildInfo.buildData._retPreCond
	local needToolCount = #self.tableBuildInfo.buildData._retCostTools
	local queueShowListCount = 0
	local isMet = true
	local isreach = true
	local isFreeQueue, qCount = self:screenQueueList()
	if not isFreeQueue then
		queueShowListCount = qCount
	end
	self.singleH = 45
	for i, v in ipairs(self.tableBuildInfo.buildData._retCostRes) do
		local singleInfo = fgui.UIPackage:createObject("BuildViewCommon", "buildCreateSingle")
		singleInfo:setPosition(cc.p(0, (i + needNebulaTower + needToolCount + preCondCount + queueShowListCount + needWECount - 1) * self.singleH))
		_ENV = cc.p(0, (i + needNebulaTower + needToolCount + preCondCount + queueShowListCount + needWECount - 1) * self.singleH)
		cc.p(0, (i + needNebulaTower + needToolCount + preCondCount + queueShowListCount + needWECount - 1) * self.singleH).singleType = BUILD_CONDITION_TYPE_RES
		cc.p(0, (i + needNebulaTower + needToolCount + preCondCount + queueShowListCount + needWECount - 1) * self.singleH).singleData = v
		cc.p(0, (i + needNebulaTower + needToolCount + preCondCount + queueShowListCount + needWECount - 1) * self.singleH).isNormal = true
		cc.p(0, (i + needNebulaTower + needToolCount + preCondCount + queueShowListCount + needWECount - 1) * self.singleH).buildData = self.tableBuildInfo.buildID
		singleInfo:initData(cc.p(0, (i + needNebulaTower + needToolCount + preCondCount + queueShowListCount + needWECount - 1) * self.singleH))
		singleInfo:setBtnCallBcak(handler(self, self.scrollSingleCallBack))
		singleInfo:addTo(self.scrollUp)
		table.insert(self.tableScrollSingles, singleInfo)
		local luckyIsReach = singleInfo:luckBlessOpen(self.luckyBlessIsOpen)
		if not singleInfo:getIsMet() then
			isMet = false
		end
		if not v.isreach and not luckyIsReach then
			self.buildType = CANT_BY_RES
			if self.viewType == BUILD_OPERATE_TYPE.UNLOCK then
				isreach = false
			end
		end
	end
	self.isSpecialReach = true
	for i, v in ipairs(self.tableBuildInfo.buildData._retCostTools) do
		local singleInfo = fgui.UIPackage:createObject("BuildViewCommon", "buildCreateSingle")
		singleInfo:setPosition(cc.p(0, (i + needNebulaTower + preCondCount + queueShowListCount + needWECount - 1) * self.singleH))
		_ENV = cc.p(0, (i + needNebulaTower + preCondCount + queueShowListCount + needWECount - 1) * self.singleH)
		cc.p(0, (i + needNebulaTower + preCondCount + queueShowListCount + needWECount - 1) * self.singleH).singleType = BUILD_CONDITION_TYPE_TOOL
		cc.p(0, (i + needNebulaTower + preCondCount + queueShowListCount + needWECount - 1) * self.singleH).singleData = v
		cc.p(0, (i + needNebulaTower + preCondCount + queueShowListCount + needWECount - 1) * self.singleH).buildData = self.tableBuildInfo.buildID
		singleInfo:initData(cc.p(0, (i + needNebulaTower + preCondCount + queueShowListCount + needWECount - 1) * self.singleH))
		singleInfo:setBtnCallBcak(handler(self, self.scrollSingleCallBack))
		singleInfo:addTo(self.scrollUp)
		if not singleInfo:getIsMet() then
			isMet = false
		end
		table.insert(self.tableScrollSingles, singleInfo)
		if not v.isreach then
			self.isSpecialReach = false
			self.buildType = CANT_BY_TOOL
		end
	end
	for i, v in ipairs(self.tableBuildInfo.buildData._retCostWEs) do
		local singleInfo = fgui.UIPackage:createObject("BuildViewCommon", "buildCreateSingle")
		singleInfo:setPosition(cc.p(0, (i + needNebulaTower + preCondCount + queueShowListCount - 1) * self.singleH))
		_ENV = cc.p(0, (i + needNebulaTower + preCondCount + queueShowListCount - 1) * self.singleH)
		cc.p(0, (i + needNebulaTower + preCondCount + queueShowListCount - 1) * self.singleH).singleType = BUILD_CONDITION_TYPE_WE
		cc.p(0, (i + needNebulaTower + preCondCount + queueShowListCount - 1) * self.singleH).singleData = v
		cc.p(0, (i + needNebulaTower + preCondCount + queueShowListCount - 1) * self.singleH).buildData = self.tableBuildInfo.buildID
		singleInfo:initData(cc.p(0, (i + needNebulaTower + preCondCount + queueShowListCount - 1) * self.singleH))
		singleInfo:setBtnCallBcak(handler(self, self.scrollSingleCallBack))
		singleInfo:addTo(self.scrollUp)
		if not singleInfo:getIsMet() then
			isMet = false
		end
		table.insert(self.tableScrollSingles, singleInfo)
		if not v.isreach then
			self.needWarBadgeBuy = v.toolcount - v.curcount
			self.needWarBadgeID = v.toolid
			self.buildType = CANT_BY_TOOL
		end
	end
	for i, v in ipairs(self.tableBuildInfo.buildData._buildQueueList) do
		local singleInfo = fgui.UIPackage:createObject("BuildViewCommon", "buildCreateSingle")
		singleInfo:setPosition(cc.p(0, (i - 1) * self.singleH))
		_ENV = cc.p(0, (i - 1) * self.singleH)
		cc.p(0, (i - 1) * self.singleH).singleType = BUILD_CONDITION_TYPE_TIME
		cc.p(0, (i - 1) * self.singleH).singleData = v
		singleInfo:initData(cc.p(0, (i - 1) * self.singleH))
		singleInfo:setBtnCallBcak(handler(self, self.scrollSingleCallBack))
		singleInfo:addTo(self.scrollUp)
		table.insert(self.tableScrollSingles, singleInfo)
		local queue = queueCtrl:queryQueue(gQueueTypeDef.charge_build_queue)
		if queue == nil then
			self.buildType = NEED_BUY_BUILDER
		else
			self.buildType = CANT_BY_BUILDER
		end
	end
	if self.tableBuildInfo.buildData._retPreNebulaTower then
		local singleInfo = fgui.UIPackage:createObject("BuildViewCommon", "buildCreateSingle")
		singleInfo:setPosition(cc.p(0, (needNebulaTower + queueShowListCount) * self.singleH))
		_ENV = cc.p(0, (needNebulaTower + queueShowListCount) * self.singleH)
		cc.p(0, (needNebulaTower + queueShowListCount) * self.singleH).singleType = BUILD_CONDITION_TYPE_NEBULATOWER
		cc.p(0, (needNebulaTower + queueShowListCount) * self.singleH).singleData = self.tableBuildInfo.buildData._retPreNebulaTower
		singleInfo:initData(cc.p(0, (needNebulaTower + queueShowListCount) * self.singleH))
		singleInfo:setBtnCallBcak(handler(self, self.scrollSingleCallBack))
		singleInfo:addTo(self.scrollUp)
		if not singleInfo:getIsMet() then
			isMet = false
		end
		table.insert(self.tableScrollSingles, singleInfo)
		if not self.tableBuildInfo.buildData._retPreNebulaTower.isreach then
			self.buildType = CANT_BY_BUILD
			isreach = false
			self.isSpecialReach = false
		end
	end
	for i, v in ipairs(self.tableBuildInfo.buildData._retPreCond) do
		local singleInfo = fgui.UIPackage:createObject("BuildViewCommon", "buildCreateSingle")
		singleInfo:setPosition(cc.p(0, (i + queueShowListCount - 1) * self.singleH))
		_ENV = cc.p(0, (i + queueShowListCount - 1) * self.singleH)
		cc.p(0, (i + queueShowListCount - 1) * self.singleH).singleType = BUILD_CONDITION_TYPE_BUILD
		cc.p(0, (i + queueShowListCount - 1) * self.singleH).singleData = v
		singleInfo:initData(cc.p(0, (i + queueShowListCount - 1) * self.singleH))
		singleInfo:setBtnCallBcak(handler(self, self.scrollSingleCallBack))
		singleInfo:addTo(self.scrollUp)
		if not singleInfo:getIsMet() then
			isMet = false
		end
		table.insert(self.tableScrollSingles, singleInfo)
		if not v.isreach then
			isreach = false
			self.isSpecialReach = false
			self.buildType = CANT_BY_BUILD
			local mainCityFunctions = include("mainCityFunctions")
			local lv = mainCityFunctions:getCastleLv()
			if not self.spriteHand and not self.isShowFinger and lv < CASTLE_LV15_LIMITED then
				local posX = self.scrollUp:getPositionX() + SoraDFPosX(76, 624)
				local posY = self.scrollUp:getPositionY() + i * self.singleH - 15 + (display.iPhoneXOffset - display.iPhoneXBottom)
				self:showFingerClick(cc.p(posX, self:getHeight() - posY))
			end
		end
	end
	self.isEnough = isMet
	self:setBtnUpNowState()
	self:setBuildBtnTouchEnable(isreach)
end
function BuildCreateInfoPanel:showFingerClick(pos)
	self.spriteHand = SoraDFingerAction(true, false, 5)
	self.spriteHand:setPosition(pos)
	self.spriteHand:addTo(self, 99)
	self.isShowFinger = true
end
function BuildCreateInfoPanel:LightBlink(index)
	if self.viewType == BUILD_OPERATE_TYPE.UPGRADE_STAR then
		if self.tableBuildInfo.buildData and #self.tableBuildInfo.buildData._buildStarQueueList == 2 then
			SoraDShowMsgTip(i18n("architectural_brilliance_level_tips"), "#icon_hourglass.png")
		else
			SoraDShowMsgTip(i18n("Glory_text_22"), "#icon_hourglass.png")
		end
	else
		SoraDShowMsgTip(i18n("common_text_743"), "#icon_hourglass.png")
	end
	self.imgLight:stopAllActions()
	self.imgLight:setVisible(true)
	self.imgLight:setPositionY((index - 1) * self.singleH - 10)
	self.imgLight:setAlpha(0)
	_UPVALUE4_ = self.singleH
	self.singleH[1] = ffa.fadeOut(0.01)
	self.singleH[2] = ffa.fadeIn(0.3)
	self.singleH[3] = ffa.fadeOut(1)
	self.singleH[4] = ffa.fadeIn(0.5)
	self.singleH[5] = ffa.fadeOut(1)
	self.singleH[6] = ffa.fadeOut(1)
	self.imgLight:runAction(ffa.seq(self.singleH))
end
function BuildCreateInfoPanel:resBuyCallBack()
	if self.viewType == BUILD_OPERATE_TYPE.BUILD then
		self:build(OPERATE_MODE.GOLD_REPLACE)
	elseif self.viewType == BUILD_OPERATE_TYPE.UPGRADE then
		self:upgrade(OPERATE_MODE.GOLD_REPLACE)
	end
end
function BuildCreateInfoPanel:btnHelpCallBack()
	SoraDPlaySound()
	userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.WAR_LV)
end
function BuildCreateInfoPanel:btnUnlockedCallBack()
	SoraDPlaySound()
	_ENV = nil
	;(nil).bid = self.tableBuildInfo.buildID.bid
	;(nil).unlockedID = self.tableBuildInfo.buildID.unlockedID
	uiManager:show("BuildUnlockedSingleInfo", nil)
end
function BuildCreateInfoPanel:btnUpCallBack()
	SoraDPlaySound()
	local upgradeFun = function(...)
		if self.buildType == CANT_BY_RES or self.buildType == CANT_BY_TOOL then
			if self.buildType == CANT_BY_TOOL and not SoraDEnoughWarBadge(self.needWarBadgeBuy, self.needWarBadgeID) then
				return
			elseif SoraDIsGameGuide() then
				self:resBuyCallBack()
			else
				local resBuyType = RESBUYVIEW_TYPE.UPGRADE
				if self.viewType == BUILD_OPERATE_TYPE.BUILD then
					resBuyType = RESBUYVIEW_TYPE.BUILD
				end
				local self, tableResNeedBuy = RESBUYVIEW_TYPE, RESBUYVIEW_TYPE
				for i, v in ipairs(self.tableBuildInfo.buildData._retCostRes) do
					if not v.isreach then
						local needBuyRes = v.rescount - v.curcount
						local costResCount = v.rescount
						if self.luckyBlessIsOpen then
							costResCount = luckyBlessCtrl:getResult(v.rescount)
							needBuyRes = math.max(0, costResCount - v.curcount)
						end
						local subPercent = buildLogic.getActivityBuff(gBuffEffect.UPGRADE_CASTLE_COST_RES_REDUCE_FOR_POW, self.tableBuildInfo.buildID)
						costResCount = math.ceil(costResCount * subPercent)
						needBuyRes = math.max(0, costResCount - v.curcount)
						if 0 < needBuyRes then
							self = costResCount - v.curcount
							;(costResCount - v.curcount).resid = v.resid
							;(costResCount - v.curcount).rescount = costResCount - v.curcount
							table.insert(tableResNeedBuy, costResCount - v.curcount)
						end
					end
				end
				for i, v in ipairs(self.tableBuildInfo.buildData._retCostTools) do
					if not v.isreach then
						self = buildLogic.getActivityBuff(gBuffEffect.UPGRADE_CASTLE_COST_RES_REDUCE_FOR_POW, self.tableBuildInfo.buildID)
						buildLogic.getActivityBuff(gBuffEffect.UPGRADE_CASTLE_COST_RES_REDUCE_FOR_POW, self.tableBuildInfo.buildID).resid = v.toolid
						buildLogic.getActivityBuff(gBuffEffect.UPGRADE_CASTLE_COST_RES_REDUCE_FOR_POW, self.tableBuildInfo.buildID).rescount = v.toolcount - v.curcount
						table.insert(tableResNeedBuy, (buildLogic.getActivityBuff(gBuffEffect.UPGRADE_CASTLE_COST_RES_REDUCE_FOR_POW, self.tableBuildInfo.buildID)))
					end
				end
				for i, v in ipairs(self.tableBuildInfo.buildData._retCostWEs) do
					if not v.isreach then
						self = buildLogic.getActivityBuff(gBuffEffect.UPGRADE_CASTLE_COST_RES_REDUCE_FOR_POW, self.tableBuildInfo.buildID)
						buildLogic.getActivityBuff(gBuffEffect.UPGRADE_CASTLE_COST_RES_REDUCE_FOR_POW, self.tableBuildInfo.buildID).resid = v.toolid
						buildLogic.getActivityBuff(gBuffEffect.UPGRADE_CASTLE_COST_RES_REDUCE_FOR_POW, self.tableBuildInfo.buildID).rescount = v.toolcount - v.curcount
						table.insert(tableResNeedBuy, (buildLogic.getActivityBuff(gBuffEffect.UPGRADE_CASTLE_COST_RES_REDUCE_FOR_POW, self.tableBuildInfo.buildID)))
					end
				end
				local proxy = uiManager:getOrCreateProxy("CommonQuicklyadd")
				if proxy:checkNeedRes(tableResNeedBuy) then
					uiManager:show("CommonQuicklyadd")
				else
					local resToGold = self.tableBuildInfo.buildData._resToGold + self.tableBuildInfo.buildData._toolToGold + self.tableBuildInfo.buildData._WEToGold
					self, self = tableResNeedBuy, table.insert
					tableResNeedBuy.resToGold = resToGold
					table.insert.needResData, tableResNeedBuy.retCostRes = tableResNeedBuy, tableResNeedBuy
					table.insert.viewType = resBuyType
					table.insert.handle = handler(self, self.resBuyCallBack)
					uiManager:show("buildCreateResBuy", table.insert)
				end
			end
		elseif self.buildType == CANT_BY_BUILDER then
			self:LightBlink(1)
		elseif self.viewType == BUILD_OPERATE_TYPE.BUILD then
			self:build()
		elseif self.viewType == BUILD_OPERATE_TYPE.UPGRADE then
			self:upgrade()
		elseif self.viewType == BUILD_OPERATE_TYPE.UNLOCK then
			cityCtrl:openGroundReq(self.tableBuildInfo.areaid)
			self = cityCtrl
			cityCtrl.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
			cityCtrl.offsetType = MAINCITYVIEW_OFFSET_TYPE_RECOVER
			SoraDSendMessage(cityCtrl)
			SoraDRemoveAllPrePanelFromManager(self)
		end
	end
	if self.viewType ~= BUILD_OPERATE_TYPE.UNLOCK then
		local buildCell = cityCtrl:getBuildCell(self.tableBuildInfo.buildID.bid, self.tableBuildInfo.buildID.iid)
		if buildCell and self.tableBuildInfo.buildID.bid == BUILDID.CASTLE then
			if commonCheck.NEW_WEEK_CARD and tonumber(buildCell.info.lv) == CASTLE_LV15_LIMITED and rechargeActivityCtrl:checkHasbuyNewWeekcard() then
				SoraDShowMsgBox(i18n("new_weeklycard_tips_01"), i18n("common_text_204"), nil, function(type)
					if type == MSGBOX_CALLBACK_YES then
					end
				end)
				return
			end
			if commonCheck.CASTLE_LVUP_TIPS and tonumber(buildCell.info.lv) == CASTLE_LV7_LIMITED then
				SoraDShowMsgBox(i18n("common_text_928_ros"), i18n("common_text_204"), nil, function(type)
					if type == MSGBOX_CALLBACK_YES then
						upgradeFun()
					end
				end)
				return
			end
			if self.wiseTutorIsOpen and tonumber(buildCell.info.lv) == include("wiseTutorRead").getMaxEffectCastleLv() then
				_ENV = nil
				;(nil).lv = buildLogic.getBuildLvStr(include("wiseTutorRead").getMaxEffectCastleLv())
				SoraDShowMsgBox(i18n("Battle_Towers_37", nil), i18n("common_text_204"), nil, function(type)
					if type == MSGBOX_CALLBACK_YES then
						upgradeFun()
					end
				end)
				return
			elseif self.artisanHouseIsOpen and tonumber(buildCell.info.lv) == include("artisanHouseltCtrl").getMaxEffectCastleLv() then
				_ENV = nil
				;(nil).lv = buildLogic.getBuildLvStr(include("artisanHouseltCtrl").getMaxEffectCastleLv())
				SoraDShowMsgBox(i18n("Battle_Towers_37", nil), i18n("common_text_204"), nil, function(type)
					if type == MSGBOX_CALLBACK_YES then
						upgradeFun()
					end
				end)
				return
			elseif self.extremelyIsOpen and tonumber(buildCell.info.lv) == include("extremelySkillfulRead").getMaxEffectCastleLv() then
				_ENV = nil
				;(nil).lv = buildLogic.getBuildLvStr(include("extremelySkillfulRead").getMaxEffectCastleLv())
				SoraDShowMsgBox(i18n("Battle_Towers_37", nil), i18n("common_text_204"), nil, function(type)
					if type == MSGBOX_CALLBACK_YES then
						upgradeFun()
					end
				end)
				return
			end
			if tonumber(buildCell.info.lv) == CASTLE_LV5_LIMITED then
				SoraDShowMsgBox(i18n("common_text_928"), i18n("common_text_204"), nil, function(type)
					if type == MSGBOX_CALLBACK_YES then
						upgradeFun()
					end
				end)
			else
				upgradeFun()
			end
		else
			upgradeFun()
		end
	else
		upgradeFun()
	end
end
function BuildCreateInfoPanel:btnUpNowCallBack()
	SoraDPlaySound()
	local upgradeFun = function()
		if self.isFree and self.isEnough then
			self:upgrade(OPERATE_MODE.FREE)
		elseif IS_FIRST_TIME_COST_GOLD_BUILDING then
			self = nil
			;(nil).name = buildRead.getName(self.tableBuildInfo.buildID.bid)
			SoraDShowBuyBox(i18n("common_text_745", nil), self.tableBuildInfo.buildData._immediatelyGold, i18n("common_text_378"), handler(self, self.upgradeNow), nil, nil, nil, nil, nil, i18n("build_gold_lvup_tips_name"), IS_SELECT_LOGIN_NOTICE, true)
		else
			self:upgradeNow(MSGBOX_CALLBACK_YES)
		end
	end
	if self.viewType == BUILD_OPERATE_TYPE.BUILD then
		if self.isFree and self.isEnough then
			self:build(OPERATE_MODE.FREE)
		else
			_ENV = nil
			;(nil).name = buildRead.getName(self.tableBuildInfo.buildID.bid)
			SoraDShowBuyBox(i18n("common_text_744", nil), self.tableBuildInfo.buildData._immediatelyGold, i18n("common_text_379"), handler(self, self.buildNow))
		end
	elseif self.viewType == BUILD_OPERATE_TYPE.UPGRADE then
		local buildCell = cityCtrl:getBuildCell(self.tableBuildInfo.buildID.bid, self.tableBuildInfo.buildID.iid)
		if buildCell and self.tableBuildInfo.buildID.bid == BUILDID.CASTLE then
			local des = ""
			if tonumber(buildCell.info.lv) == CASTLE_LV5_LIMITED then
				des = i18n("common_text_928")
			elseif self.wiseTutorIsOpen and tonumber(buildCell.info.lv) == include("wiseTutorRead").getMaxEffectCastleLv() then
				_ENV = "wiseTutorRead"
				;("wiseTutorRead").lv = buildLogic.getBuildLvStr(include("wiseTutorRead").getMaxEffectCastleLv())
				des = i18n("Battle_Towers_37", "wiseTutorRead")
			elseif self.artisanHouseIsOpen and tonumber(buildCell.info.lv) == include("artisanHouseltCtrl").getMaxEffectCastleLv() then
				_ENV = "artisanHouseltCtrl"
				;("artisanHouseltCtrl").lv = buildLogic.getBuildLvStr(include("artisanHouseltCtrl").getMaxEffectCastleLv())
				des = i18n("Battle_Towers_37", "artisanHouseltCtrl")
			elseif self.extremelyIsOpen and tonumber(buildCell.info.lv) == include("extremelySkillfulRead").getMaxEffectCastleLv() then
				_ENV = "extremelySkillfulRead"
				;("extremelySkillfulRead").lv = buildLogic.getBuildLvStr(include("extremelySkillfulRead").getMaxEffectCastleLv())
				des = i18n("Battle_Towers_37", "extremelySkillfulRead")
			end
			if des ~= "" then
				SoraDShowMsgBox(des, i18n("common_text_204"), nil, function(type)
					if type == MSGBOX_CALLBACK_YES then
						upgradeFun()
					end
				end)
				return
			end
		end
		upgradeFun()
	end
end
function BuildCreateInfoPanel:build(mode)
	local _mode = OPERATE_MODE.NORMAL
	if mode then
		_mode = mode
	end
	local _bid = self.tableBuildInfo.buildID.bid
	local _index = self.tableBuildInfo.buildType.buildIndex
	local _data = self.tableBuildInfo.buildData
	local ret = buildLogic.build(_index, _mode, _data, _bid, true)
	if ret == gErrDef.Err_None then
		_ENV = _mode
		_mode.msg = "MESSAGE_MAINCITYVIEW_CREATE_BUILD"
		_mode.buildID = _index
		_mode.buildCfgID = _bid
		SoraDSendMessage(_mode)
		cityCtrl:addBuildReq(_index, _mode, _bid)
		if _bid == BUILDID.MILITARY_TENT and SoraDIsGameGuide() == nil then
			local guideCtrl = SoraDGetCtrl("guideCtrl")
			guideCtrl:CompleteGuideStep(12001)
		end
		SoraDRemoveAllPrePanelFromManager(self)
	elseif ret == gErrDef.Err_CHARGE_QUEUE_TIME_NOT_REACH or self.buildType == NEED_BUY_BUILDER then
		self:checkChargeBuildQueue()
	elseif ret == gErrDef.Err_QUEUE_BUSY then
		self:LightBlink(1)
	end
end
function BuildCreateInfoPanel:checkChargeBuildQueue(...)
	local queue = cityCtrl:getCurCity():queryQueue(gQueueTypeDef.charge_build_queue)
	if not rechargeActivityCtrl:getMonthActivityList() then
		local cityCtrl, monthData = rechargeActivityCtrl:getMonthActivityList(), rechargeActivityCtrl:getMonthActivityList()
	end
	local itemId = 500501
	local itemCount = backpackCtrl:getItemCount(itemId)
	print("queue======", queue)
	if queue then
		local remainTime = queue.timerNode.timer:getRemainTime()
		if remainTime >= self.tableBuildInfo.buildData._costtime then
			self:upgrade(_mode)
		else
			local needCount = math.ceil((self.tableBuildInfo.buildData._costtime - remainTime) / 172800)
			cityCtrl = (self.tableBuildInfo.buildData._costtime - remainTime) / 172800
			;(self.tableBuildInfo.buildData._costtime - remainTime) / 172800.time = remainTime
			local (self.tableBuildInfo.buildData._costtime - remainTime) / 172800.needCount, param = needCount, (self.tableBuildInfo.buildData._costtime - remainTime) / 172800
			if next(monthData) then
				if 0 < itemCount then
					param.style = 1
					param.msg = i18n("building_worker_text_05")
					uiManager:show("BuilderActivePop", param)
				else
					param.style = 2
					cityCtrl = "BuilderActivePop"
					;("BuilderActivePop").var1 = gConstValue.OPEN_BUILD_CHARGE_QUEUE_GOLD * needCount
					;("BuilderActivePop").var2 = BUILDER_WORK_TIME * needCount
					param.msg = i18n("building_worker_text_06", "BuilderActivePop")
					uiManager:show("BuilderActivePop", param)
				end
			elseif 0 < itemCount then
				param.style = 3
				param.msg = i18n("building_worker_text_07")
				uiManager:show("BuilderActivePop", param)
			else
				param.style = 4
				cityCtrl = "BuilderActivePop"
				;("BuilderActivePop").var = BUILDER_WORK_TIME * needCount
				param.msg = i18n("building_worker_text_08", "BuilderActivePop")
				uiManager:show("BuilderActivePop", param)
			end
		end
	elseif next(monthData) then
		if 0 < itemCount then
			local msg = i18n("building_worker_text_01")
			cityCtrl = uiManager
			uiManager.style = 1
			uiManager.msg = msg
			uiManager:show("BuilderActivePop", uiManager)
		else
			cityCtrl = uiManager
			uiManager.var1 = gConstValue.OPEN_BUILD_CHARGE_QUEUE_GOLD
			uiManager.var2 = BUILDER_WORK_TIME
			local msg = i18n("building_worker_text_02", uiManager)
			cityCtrl = uiManager
			uiManager.style = 2
			uiManager.msg = msg
			uiManager:show("BuilderActivePop", uiManager)
		end
	elseif 0 < itemCount then
		local msg = i18n("building_worker_text_03")
		cityCtrl = uiManager
		uiManager.style = 3
		uiManager.msg = msg
		uiManager:show("BuilderActivePop", uiManager)
	else
		cityCtrl = uiManager
		uiManager.var1 = gConstValue.OPEN_BUILD_CHARGE_QUEUE_GOLD
		uiManager.var2 = BUILDER_WORK_TIME
		local msg = i18n("building_worker_text_02", uiManager)
		cityCtrl = uiManager
		uiManager.style = 4
		uiManager.msg = msg
		uiManager:show("BuilderActivePop", uiManager)
	end
end
function BuildCreateInfoPanel:buildNow(type)
	if type == MSGBOX_CALLBACK_YES and SoraDEnoughGold(self.tableBuildInfo.buildData._immediatelyGold) and SoraDEnoughWarBadge(self.needWarBadgeBuy, self.needWarBadgeID) then
		self:build(OPERATE_MODE.IMMEDIATELY)
	end
end
function BuildCreateInfoPanel:upgradeMsgBack(target, data)
	local _bid = self.tableBuildInfo.buildID.bid
	local _iid = self.tableBuildInfo.buildID.iid
	local _index = self.tableBuildInfo.buildType.buildIndex
	local _data = self.tableBuildInfo.buildData
	local _buildEntity = self.tableBuildInfo.buildID.buildEntity
	local _mode = tonumber(data.mode)
	buildLogic.upgrade(_index, _mode, _data, false, _bid)
	_ENV = _index
	_index.msg = "MESSAGE_BUILD_UPGRADE"
	_index.index = _index
	_index.bid = _bid
	_index.iid = _iid
	SoraDSendMessage(_index)
	local isFullLv = buildLogic.buildLvIsFull(_bid, _iid)
	if (_mode == OPERATE_MODE.IMMEDIATELY or _mode == OPERATE_MODE.FREE) and not isFullLv then
		SoraDRemoveAllPrePanelFromManager(self, true)
		_ENV, self.firstRunWar = SoraDRemoveAllPrePanelFromManager, true
		SoraDRemoveAllPrePanelFromManager.bid = self.tableBuildInfo.buildID.bid
		SoraDRemoveAllPrePanelFromManager.iid = self.tableBuildInfo.buildID.iid
		SoraDRemoveAllPrePanelFromManager.buildEntity = self.tableBuildInfo.buildID.buildEntity
		local SoraDRemoveAllPrePanelFromManager.index, buildInfo = self.tableBuildInfo.buildType.buildIndex, SoraDRemoveAllPrePanelFromManager
		self:initUpgradeData(buildInfo)
		self:reloadScroll(true)
	else
		SoraDRemoveAllPrePanelFromManager(self)
	end
end
function BuildCreateInfoPanel:upgrade(mode)
	local _mode = OPERATE_MODE.NORMAL
	if mode then
		_mode = mode
	end
	local _bid = self.tableBuildInfo.buildID.bid
	local _iid = self.tableBuildInfo.buildID.iid
	local _index = self.tableBuildInfo.buildType.buildIndex
	local _data = self.tableBuildInfo.buildData
	local _buildEntity = self.tableBuildInfo.buildID.buildEntity
	if _buildEntity and false == _buildEntity:checkCanTrainOrUpgrade() then
		return
	end
	local ret = buildLogic.upgrade(_index, _mode, _data, false, _bid, true)
	if ret == gErrDef.Err_None then
		print("_mode = ", _mode)
		SoraDShowLoading(self:displayObject())
		local isResBuild = buildLogic.getOutBuildIsResBuild(_bid)
		if isResBuild and (_buildEntity:getHarvestState() == CITYBUILD_HARVESTSTATE.CITYBUILD_HARVESTSTATE_MUCH or _buildEntity:getHarvestState() == CITYBUILD_HARVESTSTATE.CITYBUILD_HARVESTSTATE_SOME) then
			_buildEntity:harvestRes()
		end
		cityCtrl:upgradeBuildReq(_index, _mode, _bid)
	elseif ret == gErrDef.Err_CHARGE_QUEUE_TIME_NOT_REACH or self.buildType == NEED_BUY_BUILDER then
		self:checkChargeBuildQueue()
	elseif ret == gErrDef.Err_QUEUE_BUSY then
		self:LightBlink(1)
	end
end
function BuildCreateInfoPanel:upgradeNow(type)
	if type == MSGBOX_CALLBACK_YES and SoraDEnoughGold(self.tableBuildInfo.buildData._immediatelyGold) and SoraDEnoughWarBadge(self.needWarBadgeBuy, self.needWarBadgeID) then
		self:upgrade(OPERATE_MODE.IMMEDIATELY)
	end
end
function BuildCreateInfoPanel:onHide()
	_ENV = nil
	;(nil).isHideMainUI = false
	SoraDHideCurrentSceneViewAndMainUI(nil)
	if self.viewType == BUILD_OPERATE_TYPE.BUILD then
		print("self.curBuildIndex", self.curBuildIndex)
		local cityBuildConstDef = include("cityBuildConstDef")
		if self.tableBuildInfo and self.tableBuildInfo.buildType.buildIndex == cityBuildConstDef.buildIndexDef.index_Miracle then
			_ENV = cityBuildConstDef.buildIndexDef.index_Miracle
			cityBuildConstDef.buildIndexDef.index_Miracle.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_PREVIEW"
			cityBuildConstDef.buildIndexDef.index_Miracle.index = self.tableBuildInfo.buildType.buildIndex
			SoraDSendMessage(cityBuildConstDef.buildIndexDef.index_Miracle)
			_ENV = cityBuildConstDef.buildIndexDef.index_Miracle
			cityBuildConstDef.buildIndexDef.index_Miracle.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
			cityBuildConstDef.buildIndexDef.index_Miracle.offsetType = MAINCITYVIEW_OFFSET_TYPE_RECOVER
			SoraDSendMessage(cityBuildConstDef.buildIndexDef.index_Miracle)
		elseif self.isFromCreate then
		elseif self.curBuildIndex and self.curBuildIndex ~= 1050 then
			_ENV = cityBuildConstDef.buildIndexDef.index_Miracle
			cityBuildConstDef.buildIndexDef.index_Miracle.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
			cityBuildConstDef.buildIndexDef.index_Miracle.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD
			cityBuildConstDef.buildIndexDef.index_Miracle.buildIndex = self.curBuildIndex
			cityBuildConstDef.buildIndexDef.index_Miracle.scale = 0.9
			cityBuildConstDef.buildIndexDef.index_Miracle.skip = true
			SoraDSendMessage(cityBuildConstDef.buildIndexDef.index_Miracle)
		else
			_ENV = cityBuildConstDef.buildIndexDef.index_Miracle
			cityBuildConstDef.buildIndexDef.index_Miracle.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
			cityBuildConstDef.buildIndexDef.index_Miracle.offsetType = MAINCITYVIEW_OFFSET_TYPE_RECOVER
			SoraDSendMessage(cityBuildConstDef.buildIndexDef.index_Miracle)
		end
	else
		print("self.isSkip===", self.isSkip, self.curBuildIndex)
		if self.isSkip and self.curBuildIndex then
			_ENV = "self.isSkip==="
			;("self.isSkip===").msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
			;("self.isSkip===").noScaleDuration = self.noScaleDuration
			;("self.isSkip===").noOffsetDuration = self.noOffsetDuration
			;("self.isSkip===").offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD
			;("self.isSkip===").buildIndex = self.curBuildIndex
			;("self.isSkip===").scale = 0.9
			;("self.isSkip===").skip = true
			SoraDSendMessage("self.isSkip===")
		else
			_ENV = "self.isSkip==="
			;("self.isSkip===").msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
			;("self.isSkip===").offsetType = MAINCITYVIEW_OFFSET_TYPE_RECOVER
			SoraDSendMessage("self.isSkip===")
		end
	end
end
function BuildCreateInfoPanel:setSpecail()
	if self.tableBuildInfo.buildID and self.tableBuildInfo.buildID.bid == BUILDID.NEBULA_PALACE then
		self:setBuildBtnTouchEnable(self.isSpecialReach)
		self.labelFreeTip:setVisible(not self.isSpecialReach or self.isFree and self.isEnough)
		self.labelFreeTip:setColor(not self.isSpecialReach and cc.c3b(234, 23, 22) or cc.c3b(255, 212, 62))
		if not self.isSpecialReach then
			self.labelFreeTip:setString(i18n("nebula_war_text_0176"))
		end
		self.labelDes:setVisible(true)
		self.labelDes:setString(i18n("nebula_war_text_0162"))
	end
end
function BuildCreateInfoPanel:closeByBuildLock()
	if self.tableBuildInfo.buildID and self.tableBuildInfo.buildID.buildEntity and self.tableBuildInfo.buildID.buildEntity:getIsLocked() then
		SoraDRemoveAllPanelFromManager()
	end
end
function BuildCreateInfoPanel:onMsgBuildQueueCallback(target, data)
	if self.tableBuildInfo and self.tableBuildInfo.buildID and (data.bid ~= self.tableBuildInfo.buildID.bid or data.iid ~= self.tableBuildInfo.buildID.iid) then
		self:resUpdate()
	end
end
function BuildCreateInfoPanel:onBuffItemRenderer(index, obj)
	local activityID = self.buffDataList[index + 1]
	local wiseTutorIsOpen
	if self.viewType ~= BUILD_OPERATE_TYPE.UPGRADE_STAR and self.tableBuildInfo.buildID ~= nil and self.tableBuildInfo.buildID.bid ~= BUILDID.STAR_BRAVE_STATUE then
		wiseTutorIsOpen = false
	end
	_ENV = nil
	;(nil).bid = self.tableBuildInfo.buildID.bid
	;(nil).iid = self.tableBuildInfo.buildID.iid
	;(nil).activityID = activityID
	;(nil).handle = function()
		self:updateListBuffData()
	end
	;(nil).wiseTutorIsOpen = wiseTutorIsOpen
	;(nil).buffBuildType = self.buffBuildType
	obj:initData(nil)
end
function BuildCreateInfoPanel:onDesItemRenderer(index, obj)
	local data = self.tableUpData[index + 1]
	self:initUpDesSingle(obj, data)
end
function BuildCreateInfoPanel:initUpDesSingle(obj, data)
	local _fields = obj._fields
	if not _fields then
		_fields = fguiHelper.get_fields(obj)
		obj._fields = _fields
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
			_fields.Com_arrow:setScaleX(-0.9)
		end
	end
	if data.title then
		_fields.Text_value:setString(data.title .. "  " .. data.value)
	else
		_fields.Text_value:setString(data.value)
	end
	_fields.Text_add:setString(data.plusValue)
end
function BuildCreateInfoPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "Button_up" then
		if self.viewType == BUILD_OPERATE_TYPE.UNLOCK then
			return self.fields.Button_unlock
		end
		return self.fields.Button_up
	elseif itemName == "Button_normal" then
		return self.fields.Button_upNow
	elseif itemName == "Text_need" then
		return self.fields.Label_title
	end
	return self.fields[itemName]
end
return BuildCreateInfoPanel
