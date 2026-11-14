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
local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local BuildCreateInfoPanel = require("fgui.views.BuildViewCommon.BuildCreateInfoPanel")
local BuildUpgradeStatueBravePanel = class("BuildUpgradeStatueBravePanel", BuildCreateInfoPanel)
local CAN_BUILD = 0
local CANT_BY_BUILD = 1
local CANT_BY_BUILDER = 2
local CANT_BY_RES = 3
local CANT_BY_TOOL = 4
local NEED_BUY_BUILDER = 5
function BuildUpgradeStatueBravePanel:ctor(...)
	BuildUpgradeStatueBravePanel.super.ctor(self, ...)
	self.isHideCurrentSceneView = true
end
function BuildUpgradeStatueBravePanel:onInit()
	print("=======BuildCreateInfoPanel:onInit")
	self.fields.resourceMenu:updateResource()
	self.labelName = self.fields.Com_name
	self.labelDes = self.fields.Text_buildDes
	self.btnUp = self.fields.Button_up
	self.btnUpNow = self.fields.Button_upNow
	self.labelFreeTip = self.fields.Text_freeTip
	self.fields.Com_name:getChild("Button_help"):setVisible(false)
	self.labelLuckyDay = self.fields.Text_luckyDay
	self.labelLuckyDay:setVisible(false)
	self.spBrave = self.fields.sprite_Statue
	self.fields.Button_help:addClickEventListener(handler(self, self.btnHelpCallBack))
	self.btnUp:setCostIcon("icon_hourglass.png")
	self.btnUp:addClickEventListener(handler(self, self.btnUpCallBack))
	self.btnUpNow:addClickEventListener(handler(self, self.btnUpNowCallBack))
	self.fields.List_buff:setItemRenderer(handler(self, self.onBuffItemRenderer))
	self.scrollUp = self.fields.ScrollView_up
	self.imgLight = self.scrollUp:getChild("Image_light")
	self.imgLight:setVisible(false)
	self.fields.Label_title:setString(i18n("common_text_726"))
	self.buffBuildType = BUILD_ENUM.GLORIOUS_STATUE
	if not SoraDFIsRA() then
		self.btnUp:fixPos()
		self.btnUpNow:fixPos()
	end
end
function BuildUpgradeStatueBravePanel:onShow()
	print("=======BuildUpgradeStatueBravePanel:onShow")
	self.controllers.c_type:setSelectedIndex(1)
	local param = self.param
	if param.upgradeBraveData then
		self:initUpgradeStarData(param.upgradeBraveData)
	end
end
function BuildUpgradeStatueBravePanel:updateLuckyBless()
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
function BuildUpgradeStatueBravePanel:openLuckyTime(dt)
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
function BuildUpgradeStatueBravePanel:updateListBuffData(...)
	self:updateRadiantDecreeBuff()
	self:updateWarOrderBuff()
	self:updateBuff_9001601()
	self:updateBuff_9001656()
	self:updateBuff_9001710()
	self:updateListBuff()
end
function BuildUpgradeStatueBravePanel:updateRadiantDecreeBuff()
	local activityID = gActivityTimeActivityID.RADIANT_DECREE_ACTIVITY
	local state, leftTime = radiantDecreeCtrl:getStateInfo()
	if state == gActivityState.OPEN and radiantDecreeCtrl:canUnlockStatue() then
		self.buffData[activityID] = true
		self.radiantDecreeIsOpen = radiantDecreeCtrl:isBuffEffect(self.tableBuildInfo.buildID.bid, self.tableBuildInfo.buildID.iid)
	else
		self.buffData[activityID] = nil
		self.radiantDecreeIsOpen = false
	end
end
function BuildUpgradeStatueBravePanel:resUpdate()
	self:reloadScroll(false)
	if self.viewType == BUILD_OPERATE_TYPE.UPGRADE_STAR then
		self:initUpgradeStarData(self.upgradeStarData)
	end
end
function BuildUpgradeStatueBravePanel:initUpgradeStarData(buildID)
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
function BuildUpgradeStatueBravePanel:initUpgradeStarView(...)
	local bid = self.tableBuildInfo.buildID.bid
	local iid = self.tableBuildInfo.buildID.iid
	local buildCell = cityCtrl:getBuildCell(bid, iid)
	if not buildLogic.isBuildingStarUnlock(bid, iid) or buildLogic.buildStarLvIsFull(bid, iid) then
		self:runActClose()
		return
	end
	self.btnUp:setString(i18n("ice_carnival_text03"))
	self.btnUpNow:setString(i18n("Soldiers_armor_btn_01"))
	local quality, lv, starLv = SoraDGetBuildQuality()
	local cityltCtrl = include("cityltCtrl")
	self.labelName:setString(cityltCtrl.getStarBraveStatueLvStr(starLv))
	self.labelDes:setString(i18n(buildRead.getDes(self.tableBuildInfo.buildID.bid)))
	self.spBrave:initQuality(quality)
	self.fields.Image_Down:setSpriteFrame(16 <= quality and "bg_ghyz_bj_new.png" or "bg_ghyz_bj.png")
end
function BuildUpgradeStatueBravePanel:initScroll()
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
	;(nil).name = "_retPreMagic"
	_ENV, (nil)[5], (nil).singleType = nil, nil, BUILD_CONDITION_TYPE_MAGIC
	;(nil).name = "_retCostItems"
	_ENV, (nil)[6], (nil).singleType = nil, nil, BUILD_CONDITION_TYPE_ITEM
	;(nil).name = "_retCostTools"
	;(nil).singleType = BUILD_CONDITION_TYPE_TOOL
	;(nil).buildType = CANT_BY_TOOL
	_ENV, (nil)[7], (nil).ignorReach = nil, nil, true
	;(nil).name = "_retCostRes"
	;(nil).singleType = BUILD_CONDITION_TYPE_RES
	;(nil).buildType = CANT_BY_RES
	;(nil)[8], (nil).ignorReach = nil, true
	local condConfig
	local isMet = true
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
		if data.singleType == BUILD_CONDITION_TYPE_RES or data.singleType == BUILD_CONDITION_TYPE_ITEM then
			local radiantIsReach = singleInfo:radiantBlessOpen(true, self.luckyBlessIsOpen)
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
function BuildUpgradeStatueBravePanel:refreshTextTip(buildData)
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
			self.labelFreeTip:setString(i18n("Soldiers_armor_text_96", cc.c3b(234, 23, 22)))
		else
			local itemName1 = notreach[1]
			local itemName2 = notreach[2]
			_ENV = i18n("Soldiers_armor_text_96", cc.c3b(234, 23, 22))
			i18n("Soldiers_armor_text_96", cc.c3b(234, 23, 22)).name1 = itemName1
			i18n("Soldiers_armor_text_96", cc.c3b(234, 23, 22)).name2 = itemName2
			self.labelFreeTip:setString(i18n("Soldiers_armor_text_97", i18n("Soldiers_armor_text_96", cc.c3b(234, 23, 22))))
		end
	end
end
function BuildUpgradeStatueBravePanel:btnHelpCallBack()
	SoraDPlaySound()
	_ENV = nil
	;(nil).bid = self.tableBuildInfo.buildID.bid
	uiManager:show("BuildStatueBraveNextLvInfo", nil)
end
function BuildUpgradeStatueBravePanel:getNeedList(resid)
	local _ENV, tableResNeedBuy
	for i, v in ipairs(self.tableBuildInfo.buildData._retCostRes) do
		if not v.isreach then
			local needBuyRes = v.rescount - v.curcount
			local costResCount = v.rescount
			if self.luckyBlessIsOpen then
				costResCount = luckyBlessCtrl:getResult(v.rescount)
			end
			local subPercent = buildLogic.getActivityBuff(gBuffEffect.RADIANT_DECREE_UPGRADE_COST_RES_REDUCE_STATUE, self.tableBuildInfo.buildID)
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
			local needBuyRes = v.toolcount - v.curcount
			local costResCount = v.toolcount
			if BUILD_STAR_COSTITEM[v.toolid] then
				local subPercent = 1
				if v.toolid == gBadgeItemID.AMBER_ID then
					subPercent = buildLogic.getActivityBuff(gBuffEffect.RADIANT_DECREE_AMBER_REDUCE_STATUE, self.tableBuildInfo.buildID)
				elseif v.toolid == gBadgeItemID.STELLAR_ID then
					subPercent = buildLogic.getActivityBuff(gBuffEffect.RADIANT_DECREE_ASTRAL_MINE_REDUCE_STATUE, self.tableBuildInfo.buildID)
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
function BuildUpgradeStatueBravePanel:btnUpCallBack()
	SoraDPlaySound()
	if self.buildType == CANT_BY_RES or self.buildType == CANT_BY_TOOL then
		local resBuyType = RESBUYVIEW_TYPE.BUILD_STATUE_BRAVE
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
function BuildUpgradeStatueBravePanel:resBuyCallBack()
	self:upgradeStar(OPERATE_MODE.GOLD_REPLACE)
end
function BuildUpgradeStatueBravePanel:upgradeMsgBack(target, data)
	local _bid = self.tableBuildInfo.buildID.bid
	local _iid = self.tableBuildInfo.buildID.iid
	local _index = self.tableBuildInfo.buildType.buildIndex
	local _data = self.tableBuildInfo.buildData
	local _buildEntity = self.tableBuildInfo.buildID.buildEntity
	local _mode = tonumber(data.mode)
	local _queueType = gQueueTypeDef.glorious_upgrade
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
		self:initUpgradeStarData(buildInfo)
		self:reloadScroll(true)
		SoraDRemoveAllPrePanelFromManager(self, true)
	else
		SoraDRemoveAllPrePanelFromManager(self)
	end
end
function BuildUpgradeStatueBravePanel:upgradeStar(mode)
	local _mode = mode or OPERATE_MODE.NORMAL
	local _bid = self.tableBuildInfo.buildID.bid
	local _index = self.tableBuildInfo.buildType.buildIndex
	local _data = self.tableBuildInfo.buildData
	local _queueType = gQueueTypeDef.glorious_upgrade
	local ret = buildLogic.upgradeStar(_index, _mode, _data, _bid, _queueType, true)
	if ret == gErrDef.Err_None then
		SoraDShowLoading(self:displayObject())
		cityCtrl:upgradeBuildStarReq(_index, _mode, _bid)
	elseif ret == gErrDef.Err_QUEUE_BUSY then
		self:LightBlink(1)
	end
end
function BuildUpgradeStatueBravePanel:btnUpNowCallBack()
	SoraDPlaySound()
	if SoraDEnoughGold(self.tableBuildInfo.buildData._immediatelyGold) then
		_ENV = nil
		;(nil).build = buildRead.getName(self.tableBuildInfo.buildID.bid)
		SoraDShowBuyBox(i18n("Soldiers_armor_text_67", nil), self.tableBuildInfo.buildData._immediatelyGold, i18n("Soldiers_armor_btn_01"), handler(self, self.upgradeStarNow))
	end
end
function BuildUpgradeStatueBravePanel:upgradeStarNow(type)
	if type == MSGBOX_CALLBACK_YES and SoraDEnoughGold(self.tableBuildInfo.buildData._immediatelyGold) then
		self:upgradeStar(OPERATE_MODE.IMMEDIATELY)
	end
end
function BuildUpgradeStatueBravePanel:scrollSingleCallBack(singleData)
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
		if not (buildCell and isLvEnough) or buildEntity and buildEntity:getState() == "demolishing" then
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
			_ENV = i18n("Glory_text_41")
			i18n("Glory_text_41").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_PREVIEW"
			i18n("Glory_text_41").index = self.tableBuildInfo.buildType.buildIndex
			SoraDSendMessage(i18n("Glory_text_41"))
			_ENV, self.isSkip = SoraDSendMessage, true
			SoraDSendMessage.bid = _bid
			SoraDSendMessage.iid = iid
			SoraDSendMessage.buildEntity = buildEntity
			local SoraDSendMessage.index, buildInfo = buildIndex, SoraDSendMessage
			_ENV = i18n("Glory_text_41")
			i18n("Glory_text_41").upgradeStarData = buildInfo
			uiManager:show("BuildStarUpgrade", i18n("Glory_text_41"))
			local posX, posY = buildLogic.getBuildStarJumpOffset(buildIndex)
			_ENV = i18n("Glory_text_41")
			i18n("Glory_text_41").msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
			i18n("Glory_text_41").noScaleDuration = true
			i18n("Glory_text_41").noOffsetDuration = true
			i18n("Glory_text_41").offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD
			i18n("Glory_text_41").buildIndex = buildIndex
			i18n("Glory_text_41").scale = toScale
			i18n("Glory_text_41").xOffset = posX
			i18n("Glory_text_41").yOffset = posY
			SoraDSendMessage(i18n("Glory_text_41"))
			_ENV = i18n("Glory_text_41")
			i18n("Glory_text_41").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
			SoraDSendMessage(i18n("Glory_text_41"))
			self:removeFromParent()
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
			_ENV = uiManager
			uiManager.itemID = toolid
			uiManager:show("CommonSourceGuide", uiManager)
		end
	elseif singleData.singleType == BUILD_CONDITION_TYPE_RES then
		local needBuyResList = self:getNeedList()
		_ENV = uiManager
		uiManager.rid = singleData.singleData.resid
		uiManager.needResData = needBuyResList
		uiManager:show("resourceBuyView", uiManager)
	else
		BuildUpgradeStatueBravePanel.super.scrollSingleCallBack(self, singleData)
	end
end
function BuildUpgradeStatueBravePanel:onHide()
	if self.isUpdateStarJump then
		return
	end
end
function BuildUpgradeStatueBravePanel:onMsgBuildStarQueueCallback(target, data)
	if self.tableBuildInfo and (data.bid ~= self.tableBuildInfo.buildID.bid or data.iid ~= self.tableBuildInfo.buildID.iid) then
		self:resUpdate()
	end
end
function BuildUpgradeStatueBravePanel:onMsgBuildQueueCallback(target, data)
	if self.tableBuildInfo and data.bid == self.tableBuildInfo.buildID.bid and data.iid == self.tableBuildInfo.buildID.iid and data.optype == BUILD_OPERATE_TYPE.DEMOLISH then
		SoraDRemoveAllPanelFromManager()
	end
end
return BuildUpgradeStatueBravePanel
