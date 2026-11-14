local armyDes = include("armyDesRead")
local armyLogic = include("armyLogic")
local armyCtrl = SoraDGetCtrl("armyCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local buildDescribeRead = include("buildDescribeRead")
local armorSystemCtrl = SoraDGetCtrl("armorSystemCtrl")
local cityBuildMgr = include("cityBuildMgr")
local cityBuildConstDef = include("cityBuildConstDef")
local armorSystemRead = gModuleMgr.sharedMgr("armorSystemRead")
local cityltCtrl = include("cityltCtrl")
local buildLogic = include("buildLogic")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WarframeForgDetailPanel = class("WarframeForgDetailPanel", baseFguiPanel)
function WarframeForgDetailPanel:ctor(...)
	self.super.ctor(self, ...)
	print("WarframeForgDetailPanel:ctor", self.viewName)
end
function WarframeForgDetailPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "soldiersCampView"
	end
	return self._packageList
end
function WarframeForgDetailPanel:onInit()
	print("=======WarframeForgDetailPanel:onInit")
	self.costResList, _ENV = print, print
	self.needResList, _ENV, self.resNodeList, _ENV, self.forgQueue = print, print, print, print, nil
	self.armorNum = 0
	self.queueType = gQueueTypeDef.armor_forging
	self.fields.Com_title:initData(i18n("Soldiers_armor_text_19"), handler(self, self.onClickClose), handler(self, self.btnHelpClick))
	self.fields.Button_Left:addClickListener(handler(self, self.btnLeftClick))
	self.fields.Button_Right:addClickListener(handler(self, self.btnRightClick))
	self.fields.Button_Wear:setString(i18n("Soldiers_armor_text_26"))
	self.fields.Button_Wear:addClickListener(handler(self, self.btnWearClick))
	self.fields.Button_train:setString(i18n("common_text_1339"))
	self.fields.Button_train:addClickListener(handler(self, self.btnTrainClick))
	self.fields.Button_speedUp:addClickListener(handler(self, self.btnSpeedUpClickCallBack))
	self.fields.Button_speedUp:setString(i18n("common_text_018"))
	self.fields.Button_speedUpTool:setString(i18n("common_text_018"))
	self.fields.Button_speedUpTool:addClickListener(handler(self, self.btnSpeedUpToolClick))
	self.fields.ProgressBar:fixChildrenPos()
	self.btnExchange = self.fields.ProgressBar:getChildByName("Button_Exchange")
	self.labelSpeedUpTime = self.fields.ProgressBar:getChildByName("title_time")
	self.btnExchange:setString(i18n("Soldiers_armor_text_87"))
	self.btnExchange:addClickListener(handler(self, self.btnExchangeClick))
	self.fields.Com_slider:setSliderCallBack(handler(self, self.trainSoldierSlider))
	self.fields.List_res:setItemRenderer(handler(self, self.onResRender))
	self.isWarForbid = worldMapDefine.isInWarForbidSoldier(true)
	self.fields.Button_promoteT:setString(i18n("gilt_armor_text18"))
	self.fields.Button_promoteT:addClickListener(handler(self, self.onPromoteTClick))
	self.fields.Button_promoteT:setVisible(false)
end
function WarframeForgDetailPanel:onPromoteTClick()
	SoraDPlaySound()
	if not self.redBool then
		self.redBool = true
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:SoldiersCampView:pormoteT~bool", self.redBool, nil)
		self.fields.Button_promoteT:setReddot(not self.redBool)
	end
	local cfg = armorSystemRead:getArmorRefSoldierInfo(self.armorId)
	local armyID, isT = armyLogic.getCanTrainT(cfg.barrackID)
	_ENV = nil
	;(nil).armorId = self.armorId
	;(nil).armyID = armyID
	uiManager:show("soldiersPromoteTView", nil)
end
function WarframeForgDetailPanel:onResRender(index, obj)
	obj:initData(self.needResList[index + 1], self.needResList, self)
end
function WarframeForgDetailPanel:onShow()
	print("=======WarframeForgDetailPanel:onShow")
	self:initData(self.proxy.param.armorId)
	_ENV = self.proxy.param.armorId
	self.proxy.param.armorId.byUID = true
	self.redBool = SoraDConfigGet("Game:SoldiersCampView:pormoteT~bool", self.proxy.param.armorId) or false
	self.fields.Button_promoteT:setReddot(not self.redBool)
end
function WarframeForgDetailPanel:initData(armorId)
	self.armorId = tonumber(armorId)
	local cfg = armorSystemRead:getArmorRefSoldierInfo(self.armorId)
	self.newLv = cfg.newLv
	self.fields.Button_Wear:setVisible(self.newLv == 14 and commonCheck.GILT_ARMOR_WEAR or commonCheck.WARFRAME_WEAR)
	self.fields.bg:setURL(self.newLv == 14 and "bg_ghyz_bj04.png" or "bg_ghyz_bj01.png")
	self.armorType = armorSystemRead:getProperty(self.armorId, "armyType")
	self.forgQueue = queueCtrl:queryQueue(self.queueType)
	if self.forgQueue and tonumber(self.forgQueue.data.armorId) == self.armorId and self.forgQueue.timerNode.timer:getRemainTime() > 0 then
		self:updateTrainQueue()
		self.controllers.c1:setSelectedIndex(0)
	else
		if self.timer then
			SoraDManagerRemoveTimer(self, self.timer)
			self.timer = nil
		end
		self.controllers.c1:setSelectedIndex(1)
		self:initSlierNode()
		self:updateTrain()
	end
	self:initUIInfo()
	self:updateItemNum()
	self:updateBtnLeftAndRight()
	local cfg = armorSystemRead:getArmorRefSoldierInfo(self.armorId)
	local technologyCtrl = SoraDGetCtrl("technologyCtrl")
	local limitTechNum = technologyCtrl:getTechnologyPower(gTechnologyType.ARMOR_SOLIDER_PROMOTION_NUM) or 0
	self.fields.Button_promoteT:setVisible(cfg.newLv == 14 and 0 < limitTechNum and SoraDIsTWarframeOpen(self.armorId))
end
function WarframeForgDetailPanel:initUIInfo()
	self.fields.Text_name:setString(i18n(armorSystemRead:getProperty(self.armorId, "name")))
	self.fields.Label_Name:setString(i18n(armorSystemRead:getProperty(self.armorId, "name")))
	self.fields.Label_Name:setIcon(armorSystemRead:getProperty(self.armorId, "armyIcon"))
	self.fields.Lable_OwnSolider:setIcon(armyDes.getIcon(armorSystemCtrl:getArmyIdByArmorIdEx(self.armorId)))
	self.fields.Text_Describe:setString(i18n(armorSystemRead:getProperty(self.armorId, "des")))
	self.fields.Image_Warframe:setURL(armorSystemRead.getBigIcon(self.armorId))
	print("armorSystemCtrl:getArmyIdByArmorId(self.armorId),", armorSystemCtrl:getArmyIdByArmorIdEx(self.armorId))
end
function WarframeForgDetailPanel:updateItemNum()
	local armorNum = armorSystemCtrl:getArmorNumByID(self.armorId)
	armorSystemCtrl = nil
	;(nil).num = string.formatnumberthousands(armorNum)
	self.fields.Text_OwnWarframe:setString(i18n("common_text_063", nil))
	local soldierNum = armyCtrl:getArmyCountByLv(self.armorType, 12)
	armorSystemCtrl = i18n("common_text_063", nil)
	i18n("common_text_063", nil).num = string.formatnumberthousands(soldierNum)
	self.fields.Lable_OwnSolider:setString(i18n("common_text_063", i18n("common_text_063", nil)))
end
function WarframeForgDetailPanel:updateBtnLeftAndRight()
	self.lockArmorList = armorSystemRead:getUnlockArmorIDList(self.newLv)
	self.fields.Button_Left:setVisible(#self.lockArmorList > 1)
	self.fields.Button_Right:setVisible(#self.lockArmorList > 1)
	for i, v in ipairs(self.lockArmorList) do
		if v == self.armorId then
			if i == 1 then
				self.fields.Button_Left:setVisible(false)
			end
			if i == #self.lockArmorList then
				self.fields.Button_Right:setVisible(false)
			end
		end
	end
end
function WarframeForgDetailPanel:initSlierNode()
	local maxNum = buildLogic.getArmorMaxForgNum()
	self.armorNum = math.max(self.armorNum, maxNum)
	buildLogic = maxNum
	maxNum.maxValue = maxNum
	maxNum.minValue = 1
	maxNum.curValue = self.armorNum
	self.fields.Com_slider:initData(maxNum)
end
function WarframeForgDetailPanel:updateTrain()
	local resCost, timeCost = 0, 0
	self.costResList = armorSystemCtrl:getArmorForgingCostRes(self.armorId)
	SoraDSetNodeArrayVisible(self.resNodeList, false)
	self.needResList, armorSystemCtrl = SoraDSetNodeArrayVisible, SoraDSetNodeArrayVisible
	self.meteorResEnough, armorSystemCtrl, self.needRes = SoraDSetNodeArrayVisible, SoraDSetNodeArrayVisible, false
	for i, v in ipairs(self.costResList) do
		local curcount = cityCtrl:getResCount(v.id)
		local costRes = math.floor(v.count * self.armorNum)
		local _isreach = true
		if curcount < costRes then
			_isreach = false
		end
		if v.id ~= gIDDef.METEOR_CRYSTAL and v.id ~= gIDDef.GILDED_CRYSTAL then
			resCost = resCost + serviceFunctions.resConvertToGold(v.id, math.max(0, costRes - curcount))
		else
			self.meteorResEnough[v.id] = _isreach
			if not _isreach then
				self.fields.Button_train:setTitleColor(cc.c3b(255, 0, 0))
			else
				self.fields.Button_train:setTitleColor(cc.c3b(255, 255, 255))
			end
		end
		if not _isreach then
			self.needRes = true
		end
		print("curcount", curcount, costRes)
		armorSystemCtrl = curcount
		curcount.resid = v.id
		curcount.curcount = curcount
		curcount.rescount = costRes
		curcount.noDiscount = true
		table.insert(self.needResList, curcount)
	end
	self.fields.List_res:setNumItems(#self.needResList)
	local leftTime = math.floor(self.armorNum * armorSystemCtrl:getArmorForgTime(self.armorId))
	timeCost = serviceFunctions.timeConvertToGold(leftTime, true)
	self.fields.Text_trainTime:setString(SoraDConvertSecondToString(leftTime))
	self.resCostGold = resCost
end
function WarframeForgDetailPanel:updateTrainQueue()
	self:updateSpeedUpTool()
	self.forgQueue = queueCtrl:queryQueue(self.queueType)
	if self.forgQueue and self.forgQueue.timerNode.timer:getRemainTime() > 0 and not self.timer then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
	end
	self:openTimeUp()
end
function WarframeForgDetailPanel:updateSpeedUpTool()
	local centerPosX = self:getWidth() / 2
	if self:hasAnySpeedUpTool() then
		self.fields.Button_speedUpTool:setVisible(true)
		self.fields.Button_speedUp:setVisible(true)
		self.fields.Button_speedUpTool:setPositionX(centerPosX + SoraDFPosX(-180, 0))
		self.fields.Button_speedUp:setPositionX(centerPosX + SoraDFPosX(180, 0))
	else
		self.fields.Button_speedUpTool:setVisible(false)
		self.fields.Button_speedUp:setVisible(true)
		self.fields.Button_speedUp:setPositionX(centerPosX)
	end
	self.fields.Button_speedUpTool:setEnabled(not self.isWarForbid)
	self.fields.Button_speedUp:setEnabled(not self.isWarForbid)
end
function WarframeForgDetailPanel:openTimeUp(dt)
	self.forgQueue = queueCtrl:queryQueue(self.queueType)
	if self.forgQueue and self.forgQueue.timerNode.timer:getRemainTime() > 0 then
		local leftTime = self.forgQueue.timerNode.timer:getRemainTime()
		self.labelSpeedUpTime:setString(SoraDConvertSecondToString(leftTime))
		local totaltime = self.forgQueue.ottime or self.forgQueue.totaltime
		self.fields.ProgressBar:setValue(totaltime - leftTime)
		self.fields.ProgressBar:setMax(totaltime)
		self.fields.Button_speedUp:setCost(gIDDef.GOLD, serviceFunctions.timeConvertToGold(leftTime, true))
	else
		self:initData(self.armorId)
	end
end
function WarframeForgDetailPanel:btnHelpClick()
	SoraDPlaySound()
	userSDKManager.showSingleFAQ(_G.gSDKDef.FAQSingleType.STAR_BRAVE_STATUS)
end
function WarframeForgDetailPanel:btnLeftClick()
	SoraDPlaySound()
	if self.iscChanging then
		return
	end
	self.iscChanging = true
	local preArmorId
	for i, v in ipairs(self.lockArmorList) do
		if v == self.armorId then
			if i == 1 then
				return
			end
			preArmorId = self.lockArmorList[i - 1]
		end
	end
	self:initData(preArmorId)
	self.iscChanging = false
end
function WarframeForgDetailPanel:btnRightClick()
	SoraDPlaySound()
	if self.iscChanging then
		return
	end
	self.iscChanging = true
	local nextArmorId
	for i, v in ipairs(self.lockArmorList) do
		if v == self.armorId then
			if i == #self.lockArmorList then
				return
			end
			nextArmorId = self.lockArmorList[i + 1]
		end
	end
	self:initData(nextArmorId)
	self.iscChanging = false
end
function WarframeForgDetailPanel:btnWearClick()
	SoraDPlaySound()
	if worldMapDefine.isInWarForbidSoldier() then
		return
	end
	local trainList = armyLogic.getCanTrainList(armorSystemRead:getProperty(self.armorId, "barrackID"))
	local _ENV, armyData = armorSystemRead:getProperty(self.armorId, "barrackID")
	armyData.armyid = trainList[12].armyid
	_ENV = armorSystemRead:getProperty(self.armorId, "barrackID")
	armorSystemRead:getProperty(self.armorId, "barrackID").armyData = armyData
	armorSystemRead:getProperty(self.armorId, "barrackID").armorId = self.armorId
	uiManager:show("soldiersPromoteDetailView", armorSystemRead:getProperty(self.armorId, "barrackID"))
end
function WarframeForgDetailPanel:btnTrainClick()
	SoraDPlaySound()
	if worldMapDefine.isInWarForbidSoldier() then
		return
	end
	if self.forgQueue then
		SoraDShowMsgTip(i18n("Soldiers_armor_text_32"))
		self:initData(self.forgQueue.data.armorId)
	elseif self.needRes then
		local tableResData = self:getTableResData(true)
		local proxy = uiManager:getOrCreateProxy("CommonQuicklyadd")
		if proxy:checkNeedRes(tableResData) then
			uiManager:show("CommonQuicklyadd")
		elseif self.meteorResEnough[gIDDef.METEOR_CRYSTAL] == false then
			SoraDShowMsgTip(i18n("Soldiers_armor_text_90"))
		elseif self.meteorResEnough[gIDDef.GILDED_CRYSTAL] == false then
			_ENV = i18n("Soldiers_armor_text_90")
			i18n("Soldiers_armor_text_90").item = include("publicRead").getName(gIDDef.GILDED_CRYSTAL)
			SoraDShowMsgTip(i18n("gilt_armor_text16", i18n("Soldiers_armor_text_90")))
		else
			self:showResBuyView()
		end
	else
		self:trainArmySent(OPERATE_MODE.NORMAL)
	end
end
function WarframeForgDetailPanel:btnExchangeClick()
	SoraDPlaySound()
	uiManager:show("WarframeExchange")
end
function WarframeForgDetailPanel:btnSpeedUpToolClick()
	SoraDPlaySound()
	SoraDShowSpeedUpByItemBox(self.queueType, handler(self, self.speedUpCallBack))
end
function WarframeForgDetailPanel:btnSpeedUpClickCallBack()
	SoraDPlaySound()
	SoraDShowSpeedUpBox(self.forgQueue, handler(self, self.speedUpCallBack), i18n("common_text_765"))
end
function WarframeForgDetailPanel:speedUpCallBack(type)
	if type == MSGBOX_CALLBACK_SPEEDUP then
		self:initData(self.armorId)
	end
end
function WarframeForgDetailPanel:trainSoldierSlider(armorNum)
	self.armorNum = armorNum
	self:updateTrain()
end
function WarframeForgDetailPanel:trainArmySent(mode)
	local _buildEntity = self.buildEntity
	if _buildEntity and false == _buildEntity:checkCanTrainOrUpgrade() then
		return
	end
	local dailyArmorNum = armorSystemCtrl:getMothyGetArmorNum()
	local info = armorSystemRead:getArmorRefSoldierInfo(self.armorId)
	if info.protection_limit > 0 and dailyArmorNum >= info.protection_limit then
		armorSystemCtrl = nil
		;(nil).num = info.protection_limit
		SoraDShowMsgTip(i18n("gilt_armor_text17", nil))
		return
	end
	armorSystemCtrl = i18n("gilt_armor_text17", nil)
	i18n("gilt_armor_text17", nil).armorId = self.armorId
	i18n("gilt_armor_text17", nil).num = self.armorNum
	i18n("gilt_armor_text17", nil).mode = mode
	armorSystemCtrl:reqArmorSystemForging(i18n("gilt_armor_text17", nil))
	SoraDShowLoading(self)
end
function WarframeForgDetailPanel:showResBuyView()
	_ENV, _ENV = nil, nil
	;(nil).resToGold = self.resCostGold
	;(nil).needResData, (nil).retCostRes = nil, self:getTableResData()
	;(nil).viewType = RESBUYVIEW_TYPE.WARFRAME_FORG
	;(nil).handle = handler(self, self.resBuyCallBack)
	uiManager:show("buildCreateResBuy", nil)
end
function WarframeForgDetailPanel:hasAnySpeedUpTool()
	local ret = false
	if self.forgQueue then
		local gametop = gModuleMgr.getObject("gametop")
		local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
		local itemList = backpackCtrl:getSpeedUpItemList(self.queueType)
		if 0 < #itemList then
			ret = true
		end
	end
	return ret
end
function WarframeForgDetailPanel:getTableResData(includeMeteorCrystal)
	local _ENV, tableResData
	for i, v in ipairs(self.costResList) do
		local _ENV, resSingleData
		local curcount = cityCtrl:getResCount(v.id)
		local costRes = math.floor(v.count * self.armorNum)
		local _isreach = true
		if curcount < costRes and (includeMeteorCrystal or v.id ~= gIDDef.METEOR_CRYSTAL) then
			resSingleData.isreach = false
			resSingleData.resid = v.id
			resSingleData.rescount = costRes - curcount
			table.insert(tableResData, resSingleData)
		end
	end
	return tableResData
end
function WarframeForgDetailPanel:onHide()
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
end
return WarframeForgDetailPanel
