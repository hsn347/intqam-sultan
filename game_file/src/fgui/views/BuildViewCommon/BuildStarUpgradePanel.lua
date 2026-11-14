local buffCtrl = SoraDGetCtrl("buffCtrl")
local radiantDecreeCtrl = SoraDGetCtrl("radiantDecreeCtrl")
local buildLogic = include("buildLogic")
local buildRead = include("buildDescribeRead")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local luckyBlessCtrl = SoraDGetCtrl("luckyBlessCtrl")
local cityltCtrl = include("cityltCtrl")
local BuildCreateInfoPanel = require("fgui.views.BuildViewCommon.BuildCreateInfoPanel")
local BuildStarUpgradePanel = class("BuildStarUpgradePanel", BuildCreateInfoPanel)
local CAN_BUILD = 0
local CANT_BY_BUILD = 1
local CANT_BY_BUILDER = 2
local CANT_BY_RES = 3
local CANT_BY_TOOL = 4
local NEED_BUY_BUILDER = 5
function BuildStarUpgradePanel:ctor(...)
	BuildStarUpgradePanel.super.ctor(self, ...)
	print("BuildStarUpgradePanel:ctor", self.viewName)
end
function BuildStarUpgradePanel:onInit()
	print("=======BuildStarUpgradePanel:onInit")
	self.fields.resourceMenu:updateResource()
	self.labelName = self.fields.Com_name
	self.btnUp = self.fields.Button_up
	self.btnUpNow = self.fields.Button_upNow
	self.labelFreeTip = self.fields.Text_freeTip
	self.labelLuckyDay = self.fields.Text_luckyDay
	self.labelLuckyDay:setVisible(false)
	self.btnHelp = self.fields.Com_name:getChild("Button_help")
	self.btnHelp:addClickEventListener(handler(self, self.btnHelpCallBack))
	self.btnUp:setCostIcon("icon_hourglass.png")
	self.btnUp:addClickEventListener(handler(self, self.btnUpCallBack))
	self.btnUpNow:addClickEventListener(handler(self, self.btnUpNowCallBack))
	self.fields.List_buff:setItemRenderer(handler(self, self.onBuffItemRenderer))
	self.fields.List_des:setItemRenderer(handler(self, self.onDesItemRenderer))
	self.scrollUp = self.fields.ScrollView_up
	self.imgLight = self.scrollUp:getChild("Image_light")
	self.imgLight:setVisible(false)
	self.fields.Label_title:setString(i18n("common_text_726"))
	self.buffBuildType = BUILD_ENUM.CASTLE_STAR
	if not SoraDFIsRA() then
		self.btnUp:fixPos()
		self.btnUpNow:fixPos()
	end
end
function BuildStarUpgradePanel:onShow()
	print("=======BuildStarUpgradePanel:onShow")
	_ENV = "=======BuildStarUpgradePanel:onShow"
	;("=======BuildStarUpgradePanel:onShow").isHideMainUI = true
	SoraDHideCurrentSceneViewAndMainUI("=======BuildStarUpgradePanel:onShow")
	local param = self.param
	if param.upgradeStarData then
		self:initUpgradeStarData(param.upgradeStarData)
	end
end
function BuildStarUpgradePanel:resUpdate()
	self:reloadScroll(false)
	if self.viewType == BUILD_OPERATE_TYPE.UPGRADE_STAR then
		self:initUpgradeStarData(self.upgradeStarData)
	end
end
function BuildStarUpgradePanel:updateLuckyBless()
	local luckyData = luckyBlessCtrl:getLuckyData()
	if luckyData.curEffectType == gLuckyBlessActivityEffectType.BUILD_STRENGTH then
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
function BuildStarUpgradePanel:openLuckyTime(dt)
	local luckyData = luckyBlessCtrl:getLuckyData()
	local leftTime = luckyBlessCtrl:getRealTime()
	luckyBlessCtrl = nil
	;(nil).num = string.format("%d%%", luckyData.discount / 10)
	;(nil).time = SoraDConvertSecondToString(leftTime)
	self.labelLuckyDay:setString(i18n("lucky_text_26", nil))
	if leftTime <= 0 or not self.luckyBlessIsOpen then
		SoraDManagerRemoveTimer(self, self.luckyBlessTimer)
		self.luckyBlessTimer = nil
	end
end
function BuildStarUpgradePanel:updateListBuffData(...)
	self:updateRadiantDecreeBuff()
	self:updateExtremelyBuff()
	self:updateWarOrderBuff()
	self:updateBuff_9001601()
	self:updateBuff_9001656()
	self:updateBuff_9001710()
	self:updateListBuff()
end
function BuildStarUpgradePanel:updateRadiantDecreeBuff()
	local activityID = gActivityTimeActivityID.RADIANT_DECREE_ACTIVITY
	local state, leftTime = radiantDecreeCtrl:getStateInfo()
	if state == gActivityState.OPEN then
		local bid = self.tableBuildInfo.buildID.bid
		if bid == BUILDID.STAR_BRAVE_STATUE then
			if radiantDecreeCtrl:canUnlockStatue() then
				self.buffData[activityID] = true
				self.radiantDecreeIsOpen = true
			else
				self.buffData[activityID] = nil
				self.radiantDecreeIsOpen = false
			end
		else
			self.buffData[activityID] = true
			self.radiantDecreeIsOpen = true
		end
	else
		self.buffData[activityID] = nil
		self.radiantDecreeIsOpen = false
	end
end
function BuildStarUpgradePanel:initUpgradeStarData(buildID)
	self.upgradeStarData = buildID
	self.isNormal = false
	local _iscanupgrade, retdata = buildLogic.isCanUpgradeStar(buildID.bid, buildID.iid)
	if retdata then
		buildLogic, buildLogic = nil, buildID.iid
		;(nil).bid = buildID.bid
		;(nil).iid = buildID.iid
		buildID.iid.buildID, (nil).buildEntity = nil, buildID.buildEntity
		buildLogic, buildID.iid.buildData = nil, retdata
		self.tableBuildInfo, buildID.iid.buildType, (nil).buildIndex = buildID.iid, nil, buildID.index
		self.viewType = BUILD_OPERATE_TYPE.UPGRADE_STAR
		self:updateLuckyBless()
		self:updateListBuffData()
		self:updateView()
		self:initUpgradeStarView()
	end
end
function BuildStarUpgradePanel:setBtnUpNowState(...)
	BuildStarUpgradePanel.super.setBtnUpNowState(self, ...)
	if self.viewType == BUILD_OPERATE_TYPE.UPGRADE_STAR then
		local enough = SoraDEnoughGold(self.tableBuildInfo.buildData._immediatelyGold, true)
		local color = enough and cc.c3b(255, 251, 213) or cc.c3b(190, 40, 40)
		self.btnUpNow:setGoldColor(color)
		self.btnUpNow:setTitleColor(color)
	end
end
function BuildStarUpgradePanel:initUpgradeStarView(...)
	local bid = self.tableBuildInfo.buildID.bid
	local iid = self.tableBuildInfo.buildID.iid
	local buildCell = cityCtrl:getBuildCell(bid, iid)
	if not buildLogic.isBuildingStarUnlock(bid, iid) or buildLogic.buildStarLvIsFull(bid, iid) then
		self:runActClose()
		return
	end
	self.btnUp:setString(i18n("Glory_text_10"))
	self.btnUpNow:setString(i18n("Glory_text_14"))
	self:initUpgradeDes()
	local starLv = tonumber(buildCell.info.starLv)
	local nextLv = starLv + 1
	self.fields.Text_nextLv:setString(i18n("common_text_280") .. tostring(nextLv))
	local level = cityltCtrl.getBuildStarColor(starLv, bid)
	self.buildStarColor = level
	local _fields = fguiHelper.get_fields(self.fields.Com_star)
	local _controllers = fguiHelper.get_controllers(self.fields.Com_star)
	_controllers.c_star:setSelectedIndex(level)
	_controllers.c_light:setSelectedIndex(math.max(0, level - 1))
	for i = 1, 5 do
		local Image_light = _fields["Image_light" .. i]
		Image_light:setTouchEnabled(level <= i)
		Image_light:setTag(i)
		Image_light:addClickListener(handler(self, self.btnLightCallBack))
	end
	self.labelName:setString(buildRead.getName(self.tableBuildInfo.buildID.bid))
end
function BuildStarUpgradePanel:initUpgradeDes()
	local buildMoreInfoRead = include("buildMoreInfoRead")
	local tableUpData = buildMoreInfoRead.getUpgradeStarInfoData(self.tableBuildInfo.buildID.bid, self.tableBuildInfo.buildID.iid)
	for i, v in ipairs(tableUpData) do
		v.index = i
		v.plusValue = v.nextValue
	end
	table.sort(tableUpData, function(a, b)
		if a.isPlus ~= b.isPlus then
			return a.isPlus
		else
			return a.index < b.index
		end
	end)
	self.tableUpData = tableUpData
	self.fields.List_des:setNumItems(#self.tableUpData)
end
function BuildStarUpgradePanel:btnLightCallBack(EventContext)
	SoraDPlaySound()
	local tag = EventContext:getSender():getTag()
	print("==BuildStarUpgradePanel:btnLightCallBack==", tag)
	if tag == self.buildStarColor then
		local lv = cityltCtrl.getBuildStarLv(tag + 1, self.tableBuildInfo.buildID.bid)
		_ENV = nil
		;(nil).lv = lv
		SoraDShowMsgTip(i18n("Glory_text_11", nil))
	else
		_UPVALUE3_ = cityltCtrl.getBuildStarLv(tag + 1, self.tableBuildInfo.buildID.bid)
		cityltCtrl.getBuildStarLv(tag + 1, self.tableBuildInfo.buildID.bid)[1] = i18n("Glorious_text_11")
		cityltCtrl.getBuildStarLv(tag + 1, self.tableBuildInfo.buildID.bid)[2] = i18n("Glorious_text_12")
		cityltCtrl.getBuildStarLv(tag + 1, self.tableBuildInfo.buildID.bid)[3] = i18n("Glorious_text_13")
		cityltCtrl.getBuildStarLv(tag + 1, self.tableBuildInfo.buildID.bid)[4] = i18n("Glorious_text_14")
		local cityltCtrl.getBuildStarLv(tag + 1, self.tableBuildInfo.buildID.bid)[5], starNameTab = i18n("Glorious_text_14")
		_ENV = i18n("Glorious_text_14")
		i18n("Glorious_text_14").light = starNameTab[self.buildStarColor]
		SoraDShowMsgTip(i18n("Gather_text_18", i18n("Glorious_text_14")))
	end
end
function BuildStarUpgradePanel:initScroll()
	_ENV, _ENV = nil, nil
	;(nil).name = "_buildStarQueueList"
	;(nil).singleType = BUILD_CONDITION_TYPE_TIME
	_ENV, (nil)[1], (nil).ignorReach = nil, nil, true
	;(nil).name = "_buildQueueList"
	_ENV, (nil)[2], (nil).singleType = nil, nil, BUILD_CONDITION_TYPE_TIME
	;(nil).name = "_retPreCond"
	_ENV, (nil)[3], (nil).singleType = nil, nil, BUILD_CONDITION_TYPE_BUILD
	;(nil).name = "_retPreStar"
	_ENV, (nil)[4], (nil).singleType = nil, nil, BUILD_CONDITION_TYPE_STAR
	;(nil).name = "_retCostItems"
	_ENV, (nil)[5], (nil).singleType = nil, nil, BUILD_CONDITION_TYPE_ITEM
	;(nil).name = "_retCostTools"
	;(nil).singleType = BUILD_CONDITION_TYPE_TOOL
	;(nil).buildType = CANT_BY_TOOL
	_ENV, (nil)[6], (nil).ignorReach = nil, nil, true
	;(nil).name = "_retCostRes"
	;(nil).singleType = BUILD_CONDITION_TYPE_RES
	;(nil).buildType = CANT_BY_RES
	;(nil)[7], (nil).ignorReach = nil, true
	local condConfig
	local isMet = true
	local luckyIsReach = false
	self.singleH = 45
	local startH = 0
	local createSingleItem = function(data, singleData)
		local singleInfo = fgui.UIPackage:createObject("BuildViewCommon", "buildCreateSingle")
		_ENV = "buildCreateSingle"
		;("buildCreateSingle").singleType = data.singleType
		;("buildCreateSingle").singleData = singleData
		;("buildCreateSingle").isNormal = false
		;("buildCreateSingle").buildData = self.tableBuildInfo.buildID
		singleInfo:initData("buildCreateSingle")
		singleInfo:setBtnCallBcak(handler(self, self.scrollSingleCallBack))
		singleInfo:addTo(self.scrollUp)
		singleInfo:setPosition(cc.p(0, startH))
		if self.luckyBlessIsOpen and data.singleType == BUILD_CONDITION_TYPE_RES then
			singleData.isreach = luckyIsReach
		end
		if data.singleType == BUILD_CONDITION_TYPE_RES or data.singleType == BUILD_CONDITION_TYPE_ITEM then
			local radiantIsReach = singleInfo:radiantBlessOpen(self.upgradeStarData.bid == BUILDID.STAR_BRAVE_STATUE, self.luckyBlessIsOpen)
			singleData.isreach = radiantIsReach
		end
		if (not singleInfo:getIsMet() or data.singleType == BUILD_CONDITION_TYPE_TIME) and data.buildType then
			self.buildType = data.buildType
		end
		table.insert(self.tableScrollSingles, singleInfo)
	end
	self.labelFreeTip:setVisible(false)
	for i, v in ipairs(condConfig) do
		local buildData = self.tableBuildInfo.buildData[v.name]
		for m, n in ipairs(buildData) do
			if v.singleType == BUILD_CONDITION_TYPE_RES then
				n.rescount = n.rescount
				n.isreach = n.curcount >= n.rescount
			end
			createSingleItem(v, n)
		end
		if v.singleType == BUILD_CONDITION_TYPE_ITEM then
			self:refreshTextTip(buildData)
		end
	end
	self.isEnough = isMet
	self:setBtnUpNowState()
	self:setBuildBtnTouchEnable(isMet)
end
function BuildStarUpgradePanel:refreshTextTip(buildData)
	local itemDesRead = include("itemDesRead")
	local _ENV, notreach = "itemDesRead", "itemDesRead"
	for i, v in ipairs(buildData) do
		if not v.isreach and BUILD_STAR_COSTITEM[v.toolid] then
			table.insert(notreach, itemDesRead.getName(v.toolid))
		end
	end
	if 0 < #notreach then
		self.labelFreeTip:setVisible(true)
		self.labelFreeTip:setColor(cc.c3b(234, 23, 22))
		if #notreach == 1 then
			local itemName = notreach[1]
			_ENV = cc.c3b(234, 23, 22)
			cc.c3b(234, 23, 22).name = itemName
			self.labelFreeTip:setString(i18n("Glory_text_62", cc.c3b(234, 23, 22)))
		else
			local itemName1 = notreach[1]
			local itemName2 = notreach[2]
			_ENV = i18n("Glory_text_62", cc.c3b(234, 23, 22))
			i18n("Glory_text_62", cc.c3b(234, 23, 22)).name1 = itemName1
			i18n("Glory_text_62", cc.c3b(234, 23, 22)).name2 = itemName2
			self.labelFreeTip:setString(i18n("Glory_text_63", i18n("Glory_text_62", cc.c3b(234, 23, 22))))
		end
	end
end
function BuildStarUpgradePanel:btnHelpCallBack()
	SoraDPlaySound()
	userSDKManager.showFAQSection(gSDKDef.FAQSectionType.BUILD_STAR)
end
function BuildStarUpgradePanel:getNeedList(resid)
	local _ENV, tableResNeedBuy
	for i, v in ipairs(self.tableBuildInfo.buildData._retCostRes) do
		if not v.isreach then
			local needBuyRes = v.rescount - v.curcount
			local costResCount = v.rescount
			if self.luckyBlessIsOpen then
				costResCount = luckyBlessCtrl:getResult(v.rescount)
			end
			local subPercent = buildLogic.getActivityBuff(gBuffEffect.RADIANT_DECREE_UPGRADE_COST_RES_REDUCE, self.tableBuildInfo.buildID)
			costResCount = math.ceil(costResCount * subPercent)
			needBuyRes = math.max(0, costResCount - v.curcount)
			if 0 < needBuyRes then
				_ENV = costResCount - v.curcount
				;(costResCount - v.curcount).resid = v.resid
				;(costResCount - v.curcount).rescount = costResCount
				table.insert(tableResNeedBuy, costResCount - v.curcount)
			end
		end
	end
	for i, v in ipairs(self.tableBuildInfo.buildData._retCostItems) do
		if not v.isreach then
			local costResCount = v.toolcount
			local needBuyRes = costResCount - v.curcount
			if BUILD_STAR_COSTITEM[v.toolid] then
				local subPercent = 1
				if v.toolid == gBadgeItemID.AMBER_ID then
					subPercent = buildLogic.getActivityBuff(gBuffEffect.RADIANT_DECREE_AMBER_REDUCE, self.tableBuildInfo.buildID)
				elseif v.toolid == gBadgeItemID.STELLAR_ID then
					subPercent = buildLogic.getActivityBuff(gBuffEffect.RADIANT_DECREE_ASTRAL_MINE_REDUCE, self.tableBuildInfo.buildID)
				end
				costResCount = math.ceil(costResCount * subPercent)
				needBuyRes = math.max(0, costResCount - v.curcount)
			end
			if 0 < needBuyRes then
				_ENV = 0
				;(0).resid = v.toolid
				;(0).rescount = costResCount
				table.insert(tableResNeedBuy, 0)
			end
		end
	end
	local rescount = 0
	if resid then
		for k, v in ipairs(tableResNeedBuy) do
			if resid == v.resid then
				rescount = v.rescount
				break
			end
		end
	end
	return tableResNeedBuy, rescount
end
function BuildStarUpgradePanel:btnUpCallBack(button, type)
	SoraDPlaySound()
	if self.buildType == CANT_BY_RES or self.buildType == CANT_BY_TOOL then
		local resBuyType = RESBUYVIEW_TYPE.UPGRADE_STAR
		local tableResNeedBuy = self:getNeedList()
		local proxy = uiManager:getOrCreateProxy("CommonQuicklyadd")
		if proxy:checkNeedRes(tableResNeedBuy) then
			uiManager:show("CommonQuicklyadd")
		else
			_ENV, _ENV = nil, nil
			;(nil).resToGold = self.tableBuildInfo.buildData._resToGold + self.tableBuildInfo.buildData._toolToGold
			;(nil).needResData, (nil).retCostRes = nil, tableResNeedBuy
			;(nil).viewType = resBuyType
			;(nil).handle = handler(self, self.resBuyCallBack)
			uiManager:show("buildCreateResBuy", nil)
		end
	elseif self.buildType == CANT_BY_BUILDER then
		self:LightBlink(1)
	else
		self:upgradeStar()
	end
end
function BuildStarUpgradePanel:resBuyCallBack()
	self:upgradeStar(OPERATE_MODE.GOLD_REPLACE)
end
function BuildStarUpgradePanel:upgradeMsgBack(target, data)
	local _mode = tonumber(data.mode)
	local _bid = self.tableBuildInfo.buildID.bid
	local _iid = self.tableBuildInfo.buildID.iid
	local _index = self.tableBuildInfo.buildType.buildIndex
	local _data = self.tableBuildInfo.buildData
	local _queueType = gQueueTypeDef.build_star_queue
	local _buildEntity = self.tableBuildInfo.buildID.buildEntity
	local _iscanupgrade, retdata = buildLogic.isCanUpgradeStar(_bid, _iid)
	for i, v in ipairs(retdata._buildStarQueueList) do
		if tonumber(v.qtype) == _queueType then
			_queueType = gQueueTypeDef.build_star_queue_privilege
		end
	end
	if BUILDID.STAR_BRAVE_STATUE == _bid then
		_queueType = gQueueTypeDef.glorious_upgrade
	end
	buildLogic.upgradeStar(_index, _mode, _data, _bid, _queueType)
	_ENV = _index
	_index.msg = "MESSAGE_BUILD_STAR_UPGRADE"
	_index.index = _index
	_index.bid = _bid
	_index.iid = _iid
	_index.queueType = _queueType
	SoraDSendMessage(_index)
	local isFullLv = buildLogic.buildStarLvIsFull(_bid, _iid)
	if (_mode == OPERATE_MODE.IMMEDIATELY or _mode == OPERATE_MODE.FREE) and not isFullLv then
		_ENV, self.firstRunWar = OPERATE_MODE.FREE, true
		OPERATE_MODE.FREE.bid = _bid
		OPERATE_MODE.FREE.iid = _iid
		OPERATE_MODE.FREE.buildEntity = _buildEntity
		local OPERATE_MODE.FREE.index, buildInfo = _index, OPERATE_MODE.FREE
		if not tolua.isnull(self) then
			self:initUpgradeStarData(buildInfo)
			self:reloadScroll(true)
		end
		SoraDRemoveAllPrePanelFromManager(self, true)
	else
		SoraDRemoveAllPrePanelFromManager(self)
	end
end
function BuildStarUpgradePanel:upgradeStar(mode)
	local _mode = mode or OPERATE_MODE.NORMAL
	local _bid = self.tableBuildInfo.buildID.bid
	local _iid = self.tableBuildInfo.buildID.iid
	local _index = self.tableBuildInfo.buildType.buildIndex
	local _data = self.tableBuildInfo.buildData
	local _buildEntity = self.tableBuildInfo.buildID.buildEntity
	local _queueType = gQueueTypeDef.build_star_queue
	local _iscanupgrade, retdata = buildLogic.isCanUpgradeStar(_bid, _iid)
	for i, v in ipairs(retdata._buildStarQueueList) do
		if tonumber(v.qtype) == _queueType then
			_queueType = gQueueTypeDef.build_star_queue_privilege
		end
	end
	if BUILDID.STAR_BRAVE_STATUE == _bid then
		_queueType = gQueueTypeDef.glorious_upgrade
	end
	local buildStarState = tonumber(_buildEntity:getBuildStarState())
	if buildStarState == BUILD_STAR_STATE.UPGRADEING then
		_ENV = _buildEntity:getBuildStarState()
		_buildEntity:getBuildStarState().build = ""
		SoraDShowMsgTip(i18n("Glory_text_31", _buildEntity:getBuildStarState()))
		SoraDRemoveAllPrePanelFromManager(self)
		return
	end
	local ret = buildLogic.upgradeStar(_index, _mode, _data, _bid, _queueType, true)
	if ret == gErrDef.Err_None then
		SoraDShowLoading(self:displayObject())
		cityCtrl:upgradeBuildStarReq(_index, _mode, _bid)
	elseif ret == gErrDef.Err_QUEUE_BUSY then
		self:LightBlink(1)
	end
end
function BuildStarUpgradePanel:btnUpNowCallBack()
	SoraDPlaySound()
	if SoraDEnoughGold(self.tableBuildInfo.buildData._immediatelyGold) then
		_ENV = nil
		;(nil).build = buildRead.getName(self.tableBuildInfo.buildID.bid)
		SoraDShowBuyBox(i18n("Glory_text_23", nil), self.tableBuildInfo.buildData._immediatelyGold, i18n("Glory_text_14"), handler(self, self.upgradeStarNow))
	end
end
function BuildStarUpgradePanel:upgradeStarNow(type)
	if type == MSGBOX_CALLBACK_YES and SoraDEnoughGold(self.tableBuildInfo.buildData._immediatelyGold) then
		self:upgradeStar(OPERATE_MODE.IMMEDIATELY)
	end
end
function BuildStarUpgradePanel:scrollSingleCallBack(singleData)
	if singleData.singleType == BUILD_CONDITION_TYPE_STAR then
		local _bid = singleData.singleData.bid
		local lv, iid = cityCtrl:getBuildMaxLv(_bid)
		local isLvEnough = true
		if lv < CASTLE_LV90_LIMITED then
			isLvEnough = false
		else
			lv, iid = cityCtrl:getBuildMaxStarLvEx(_bid)
		end
		local buildCell = cityCtrl:getBuildCell(_bid, iid)
		local cityBuildMgr = include("cityBuildMgr")
		local buildEntity = cityBuildMgr:getBuildByBid(tonumber(_bid), iid)
		local buildType = SoraDGetBuildTypeByBid(tonumber(_bid))
		local toScale = 1.0
		if buildType == 1 then
			toScale = 1.3
		end
		local mainCityFunctions = include("mainCityFunctions")
		local buildIndex = mainCityFunctions.getBuildIndexByBid(_bid, iid)
		self.curBuildIndex = buildIndex
		if _bid == BUILDID.STAR_BRAVE_STATUE then
			_ENV, _ENV = tonumber(_bid)
			tonumber(_bid).bid = _bid
			tonumber(_bid).iid = iid
			tonumber(_bid).index = buildIndex
			tonumber(_bid).upgradeBraveData, tonumber(_bid).buildEntity = tonumber(_bid)
			uiManager:show("BuildUpgradeStatueBrave", tonumber(_bid))
			self.isSkip = true
			self.noScaleDuration = true
			self.noOffsetDuration = true
			SoraDRemoveAllPrePanelFromManager(self)
		elseif not (buildCell and isLvEnough) or buildEntity and buildEntity:getState() == "demolishing" then
			self.isSkip = false
			GLOBAL_BUILD_PRE_BID = _bid
			_ENV = buildEntity
			buildEntity.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP_HAND"
			buildEntity.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD_TIP_HAND
			buildEntity.bid = _bid
			buildEntity.iid = nil
			buildEntity.isRecover = true
			SoraDSendMessage(buildEntity)
			SoraDRemoveAllPrePanelFromManager(self)
			if not isLvEnough then
				SoraDShowMsgTip(i18n("Glory_text_41"))
			end
		else
			_ENV, self.isSkip = SoraDShowMsgTip, true
			SoraDShowMsgTip.bid = _bid
			SoraDShowMsgTip.iid = iid
			SoraDShowMsgTip.buildEntity = buildEntity
			local SoraDShowMsgTip.index, buildInfo = buildIndex, SoraDShowMsgTip
			self:initUpgradeStarData(buildInfo)
			self:reloadScroll(true)
			local posX, posY = buildLogic.getBuildStarJumpOffset(buildIndex)
			_ENV = i18n("Glory_text_41")
			i18n("Glory_text_41").msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
			i18n("Glory_text_41").ignorePreZoomScale = true
			i18n("Glory_text_41").noScaleDuration = true
			i18n("Glory_text_41").noOffsetDuration = true
			i18n("Glory_text_41").offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD
			i18n("Glory_text_41").buildIndex = buildIndex
			i18n("Glory_text_41").scale = toScale
			i18n("Glory_text_41").xOffset = posX
			i18n("Glory_text_41").yOffset = posY
			SoraDSendMessage(i18n("Glory_text_41"))
		end
	elseif singleData.singleType == BUILD_CONDITION_TYPE_BUILD then
		SoraDRemoveAllPrePanelFromManager(self)
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		_ENV = cityCtrl:getBuildCell(_bid, iid)
		cityCtrl:getBuildCell(_bid, iid).bid = singleData.singleData.bid
		cityCtrl:getBuildCell(_bid, iid).lv = singleData.singleData.blv
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.BUILD_UPGRADE, (cityCtrl:getBuildCell(_bid, iid)))
	elseif singleData.singleType == BUILD_CONDITION_TYPE_ITEM then
		local quickuseitem = require_data("quickuseitem").data
		local toolid = singleData.singleData.toolid
		local toolcount = singleData.singleData.toolcount
		if quickuseitem[toolid] then
			local needBuyResList, toolcount = self:getNeedList(toolid)
			_ENV = 1.3
			;(1.3).needID = toolid
			;(1.3).needCount = toolcount
			uiManager:show("commonQuickUseView", 1.3)
		else
			SoraDShowMsgTip(i18n("Glory_text_61"))
		end
	elseif singleData.singleType == BUILD_CONDITION_TYPE_RES then
		local needBuyResList = self:getNeedList()
		_ENV = i18n("Glory_text_61")
		i18n("Glory_text_61").rid = singleData.singleData.resid
		i18n("Glory_text_61").needResData = needBuyResList
		uiManager:show("resourceBuyView", i18n("Glory_text_61"))
	else
		BuildStarUpgradePanel.super.scrollSingleCallBack(self, singleData)
	end
end
function BuildStarUpgradePanel:onHide()
	_ENV = nil
	;(nil).isHideMainUI = false
	SoraDHideCurrentSceneViewAndMainUI(nil)
	if self.isUpdateStarJump then
		return
	end
	BuildStarUpgradePanel.super.onHide(self)
end
function BuildStarUpgradePanel:onMsgBuildStarQueueCallback(target, data)
	if self.tableBuildInfo and (data.bid ~= self.tableBuildInfo.buildID.bid or data.iid ~= self.tableBuildInfo.buildID.iid) then
		self:resUpdate()
	end
end
function BuildStarUpgradePanel:onMsgBuildQueueCallback(target, data)
	if self.tableBuildInfo and data.bid == self.tableBuildInfo.buildID.bid and data.iid == self.tableBuildInfo.buildID.iid and data.optype == BUILD_OPERATE_TYPE.DEMOLISH then
		SoraDRemoveAllPanelFromManager()
	end
end
return BuildStarUpgradePanel
