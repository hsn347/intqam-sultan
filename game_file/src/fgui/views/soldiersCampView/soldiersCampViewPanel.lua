local cityBuildMgr = include("cityBuildMgr")
local armyLogic = include("armyLogic")
local armyDesRead = include("armyDesRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local armyCtrl = SoraDGetCtrl("armyCtrl")
local armorSystemCtrl = SoraDGetCtrl("armorSystemCtrl")
local luckyBlessCtrl = SoraDGetCtrl("luckyBlessCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local publicRead = include("publicRead")
local armyltCtrl = include("armyltCtrl")
local buildRead = include("buildDescribeRead")
local armorSystemRead = gModuleMgr.sharedMgr("armorSystemRead")
local eliteSoldiersDef = include("eliteSoldiersDef")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local prefabDef = include("prefabDef")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local soldiersCampViewPanel = class("soldiersCampViewPanel", baseFguiPanel)
function soldiersCampViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("soldiersCampViewPanel:ctor", self.viewName)
end
function soldiersCampViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function soldiersCampViewPanel:onInit()
	print("=======soldiersCampViewPanel:onInit")
	self.bid = self.param.bid
	self.trainType = TRAIN_TYPE.SOLDIERS
	if self.bid == BUILDID.FORTRESS then
		self.trainType = TRAIN_TYPE.TRAP
	end
	self.soldierList, _ENV, self.buildEntity = cityBuildMgr:getBuildByBid(self.bid), cityBuildMgr:getBuildByBid(self.bid), cityBuildMgr:getBuildByBid(self.bid)
	self.curIndex = self.param.toIndex
	self.armyCount = 1
	self.luckyBlessIsOpen = false
	self.trainGold = 0
	self.needResList, _ENV, self.showModel = self.param.toIndex, self.param.toIndex, 0
	self.isWarForbid = worldMapDefine.isInWarForbidSoldier(true)
	self:bindBtnClose()
	self.isHideCurrentSceneView = true
	self.fields.resourceMenu:hideStone(true)
	self.fields.List_res:setAlignCenter(true)
	self.fields.List_res:setItemRenderer(handler(self, self.onResRender))
	self.fields.List_soldier:setItemRenderer(handler(self, self.onSoldierRender))
	self.fields.List_soldier:getScrollPane():AddEventListener1(fgui.UIEventType.Scroll, handler(self, self.onScrollItem))
	self.fields.List_soldier:getScrollPane():AddEventListener1(fgui.UIEventType.ScrollEnd, handler(self, self.onScrollEndItem))
	self.fields.List_skill:setItemRenderer(handler(self, self.onSkillRender))
	self.fields.Button_tip:addClickListener(handler(self, self.onTipClick))
	self.fields.Button_tool:addClickListener(handler(self, self.onToolClick))
	if self.trainType == TRAIN_TYPE.SOLDIERS then
		self.fields.Button_train:setString(i18n("common_text_061"))
		self.fields.Button_trainNow:setString(i18n("common_text_317"))
	else
		self.fields.Button_train:setString(i18n("common_text_042"))
		self.fields.Button_trainNow:setString(i18n("common_text_379"))
	end
	self.fields.Button_train:addClickListener(handler(self, self.onTrainClick))
	self.fields.Button_trainNow:addClickListener(handler(self, self.onTrainNowClick))
	self.fields.Button_trainNow:setGoldColor(cc.c3b(255, 255, 0))
	self.fields.Button_speed:setString(i18n("common_text_018"))
	self.fields.Button_speed:addClickListener(handler(self, self.onSpeedClick))
	self.fields.Button_wear:setString(i18n("Soldiers_armor_text_26"))
	self.fields.Button_wear:addClickListener(handler(self, self.onWearClick))
	self.fields.Button_promoteT:setString(i18n("gilt_armor_text18"))
	self.fields.Button_promoteT:addClickListener(handler(self, self.onPromoteTClick))
	self.fields.Button_promoteT:setVisible(false)
	self.fields.slider:setSliderCallBack(handler(self, self.onSliderChange))
	self.backpackResList, _ENV, self.isQuick = self.fields.slider.setSliderCallBack, self.fields.slider.setSliderCallBack, false
	self.fields.Com_skip:initData(self.isQuick, i18n("soldier_quick_train01"), handler(self, self.onClickQuick))
	self.fields.Com_skip:setVisible(false)
	self.fields.Text_tool:fixPos()
	self.fields.Button_tip:fixPos()
	self.fields.Button_tool:fixPos()
	self.fields.slider:setInpuBoxFixPos(100, 100)
end
function soldiersCampViewPanel:quickTrain(target, data)
	self.isQuick = not self.isQuick
	self.fields.Com_skip:setSelected(self.isQuick)
end
function soldiersCampViewPanel:onClickQuick(ret)
	if self.isQuick then
		self.backpackResList, _ENV, self.isQuick = self.isQuick, self.isQuick, ret
		self.fields.Com_skip:setSelected(self.isQuick)
	else
		self.fields.Com_skip:setSelected(self.isQuick)
		uiManager:show("soldiersQuickTrain")
	end
end
function soldiersCampViewPanel:onScrollItem()
	local offsetX = self.fields.List_soldier:getScrollPane():getPositionX()
	local listW = self.fields.List_soldier:getContentSize().width
	local scrollW = self.fields.List_soldier:getInnerContainerSize().width
	local centerX = offsetX + listW / 2
	for i = 1, self.fields.List_soldier:getNumItems() do
		local objW = self.fields.List_soldier:getChildAt(i - 1):getContentSize().width
		local objOffsetX = self.fields.List_soldier:getChildAt(i - 1):getX() + objW / 2 - offsetX - listW / 2
		self.fields.List_soldier:getChildAt(i - 1):setRatio((listW - math.abs(objOffsetX) * 0.25) / listW)
	end
end
function soldiersCampViewPanel:onScrollEndItem()
	local midIndex = 0
	local ratio = 0
	for i = 1, self.fields.List_soldier:getNumItems() do
		if ratio <= self.fields.List_soldier:getChildAt(i - 1):getRatio() and not self.fields.List_soldier:getChildAt(i - 1):isEmptyCom() then
			ratio = self.fields.List_soldier:getChildAt(i - 1):getRatio()
			midIndex = i
		end
	end
	self.curIndex = midIndex
	self:updateView()
end
function soldiersCampViewPanel:playMoveAct()
	local target, pos
	if self.fields.Com_trap:isVisible() then
		target = self.fields.Com_trap
		pos = self.fields.Com_trap:getPosition()
	elseif self.fields.Com_army:isVisible() then
		target = self.fields.Com_army
		pos = self.fields.Com_army:getPosition()
	end
	self:playOffsetXAct(target, pos, 0.3)
end
function soldiersCampViewPanel:playOffsetXAct(obj, pos, time)
	local offsetX = 100
	obj:setPositionX(pos.x + offsetX)
	obj:setOpacity(0)
	_UPVALUE1_ = nil
	;(nil)[1] = cca.moveTo(time or 0.3, pos.x, pos.y)
	;(nil)[2] = cca.fadeIn(time or 0.3)
	;(nil)[3] = cca.fadeIn(time or 0.3)
	;(nil)[4] = cca.fadeIn(time or 0.3)
	obj:runAction(cca.spawn(nil))
end
function soldiersCampViewPanel:onResRender(index, obj)
	obj:initData(self.resList[index + 1], self.needResList, self)
end
function soldiersCampViewPanel:onSoldierRender(index, obj)
	obj:initData(self.soldierList[index + 1], index + 1, self.curIndex)
end
function soldiersCampViewPanel:onSkillRender(index, obj)
	obj:initData(self.skillList[index + 1])
end
function soldiersCampViewPanel:onShow()
	print("=======soldiersCampViewPanel:onShow")
	if self.bid == BUILDID.FORTRESS then
		self.controllers.c2:setSelectedIndex(2)
	elseif self.bid == BUILDID.BARRACKS then
		self.controllers.c2:setSelectedIndex(1)
	else
		self.controllers.c2:setSelectedIndex(0)
	end
	self.fields.shadow:setVisible(self.bid ~= BUILDID.FORTRESS)
	self.spineArmyPos = cc.p(self:getWidth() / 2, self.fields.Com_army:getPositionY())
	_ENV = self.fields.Com_army:getPositionY()
	self.fields.Com_army:getPositionY().byUID = true
	if not SoraDConfigGet("Game:SoldiersCampView:trainSoldiersLog~table", self.fields.Com_army:getPositionY()) then
		_ENV = SoraDConfigGet("Game:SoldiersCampView:trainSoldiersLog~table", self.fields.Com_army:getPositionY())
	end
	self.trainSoldiersLog = SoraDConfigGet("Game:SoldiersCampView:trainSoldiersLog~table", self.fields.Com_army:getPositionY())
	local trainedArmy = armyCtrl:getTrainArmy(self.bid)
	if trainedArmy then
		armyCtrl:getTrainArmyReq(self.bid)
	end
	local curIndex = 1
	self.soldierList, curIndex = armyLogic.getCanTrainList(self.bid)
	_ENV = self.fields.Com_army:getPositionY()
	self.fields.Com_army:getPositionY().isEmpty = true
	table.insert(self.soldierList, 1, self.fields.Com_army:getPositionY())
	_ENV = self.fields.Com_army:getPositionY()
	self.fields.Com_army:getPositionY().isEmpty = true
	table.insert(self.soldierList, 1, self.fields.Com_army:getPositionY())
	_ENV = 1
	;(1).isEmpty = true
	table.insert(self.soldierList, 1)
	_ENV = 1
	;(1).isEmpty = true
	table.insert(self.soldierList, 1)
	curIndex = curIndex + 2
	local trainLog = self.trainSoldiersLog[tostring(self.bid)]
	if not self.curIndex then
		if not trainLog then
			self.curIndex = curIndex
			_ENV = self.bid
			self.bid.maxArmyId = self.soldierList[curIndex].armyid
			self.trainSoldiersLog[tostring(self.bid)], self.bid.trainArmyId = self.bid, self.soldierList[curIndex].armyid
		else
			local newTrainArmyId = self.soldierList[curIndex].armyid
			if newTrainArmyId ~= trainLog.maxArmyId then
				self.curIndex = curIndex
				trainLog.maxArmyId = newTrainArmyId
			else
				local lastTrainArmyId = trainLog.trainArmyId
				for i, v in ipairs(self.soldierList) do
					if v.armyid == lastTrainArmyId then
						self.curIndex = i
						break
					end
				end
				if not self.curIndex then
					self.curIndex = curIndex
				end
			end
		end
	else
		self.curIndex = self.curIndex + 2
		if not trainLog then
			_ENV = self.bid
			self.bid.maxArmyId = self.soldierList[curIndex].armyid
			self.trainSoldiersLog[tostring(self.bid)], self.bid.trainArmyId = self.bid, self.soldierList[curIndex].armyid
		end
	end
	self.fields.resourceMenu:updateResource()
	self:updateView()
	self:updateLuckyBless()
end
function soldiersCampViewPanel:resetWarframeSlider()
	self.armorId = armorSystemRead:getArmorIdByArmyId(self.armyID)
	local armorNum = armorSystemCtrl:getArmorNumByID(self.armorId)
	local armyNum = armorSystemCtrl:getArmyNumByArmorId(self.armorId)
	armorSystemRead = nil
	;(nil).maxValue = math.min(include("constantRead").getConstValue("ARMOR_WEAR_LIMIT_NUM"), math.max(armorNum, armyNum))
	;(nil).minValue = 1
	;(nil).curValue = math.min(armorNum, armyNum)
	self.fields.slider:initData(nil)
	self:updateWearView()
end
function soldiersCampViewPanel:updateWearView()
	armorSystemCtrl, armorSystemCtrl = nil, nil
	;(nil).resID = self.armorId
	;(nil).rescount = self.armyCount
	;(nil).curcount = armorSystemCtrl:getArmorNumByID(self.armorId)
	;(nil).isArmor = true
	armorSystemCtrl, (nil)[1], (nil).noDiscount = nil, nil, true
	;(nil).resID = armorSystemCtrl:getArmyIdByArmorId(self.armorId)
	;(nil).rescount = self.armyCount
	;(nil).curcount = armorSystemCtrl:getArmyNumByArmorId(self.armorId)
	;(nil).isArmor = true
	self.resList, (nil)[2], (nil).noDiscount = nil, nil, true
	self.fields.List_res:setNumItems(#self.resList)
	local _isreach = true
	for i, v in ipairs(self.resList) do
		if v.curcount < v.rescount or v.curcount <= 0 then
			_isreach = false
		end
	end
	self.fields.Button_wear:setTitleColor(_isreach and display.COLOR_WHITE or display.COLOR_RED)
	self:updateBtnPromoteT()
end
function soldiersCampViewPanel:updateBtnPromoteT()
	local cfg = armorSystemRead:getArmorRefSoldierInfo(self.armorId)
	local technologyCtrl = SoraDGetCtrl("technologyCtrl")
	local limitTechNum = technologyCtrl:getTechnologyPower(gTechnologyType.ARMOR_SOLIDER_PROMOTION_NUM) or 0
	self.fields.Button_promoteT:setVisible(cfg.newLv == 13 and 0 < limitTechNum and SoraDIsTWarframeOpen(nil, self.armorId))
	local leftPNum = armorSystemCtrl:getMothyPromoteNum()
	local armyNum = armyCtrl:getNormalArmyCount(self.armyID)
	armorSystemRead = self.armorId
	self.armorId.byUID = true
	self.redBool = SoraDConfigGet("Game:SoldiersCampView:pormoteT~bool", self.armorId) or false
	self.fields.Button_promoteT:setReddot(0 < leftPNum and 0 < armyNum or not self.redBool)
end
function soldiersCampViewPanel:hasAnySpeedUpTool()
	local ret = false
	if self.trianQueue then
		local queueType = self.trianQueue.qtype
		local itemList = backpackCtrl:getSpeedUpItemListByQueueType(queueType)
		if 0 < #itemList then
			ret = true
		end
	end
	return ret
end
function soldiersCampViewPanel:updateMode()
	self.trianQueue = queueCtrl:queryQueue(buildRead.getQueueType(self.bid))
	local leftTime = 0
	if self.trianQueue then
		leftTime = self.trianQueue.timerNode.timer:getRemainTime()
	end
	if self.trianQueue and 0 < leftTime then
		if self:hasAnySpeedUpTool() then
			self.showModel = SoraDFIsRA() and 2 or 6
			self.fields.Button_speed:setEnabled(not self.isWarForbid)
		else
			self.showModel = 3
		end
		self:openTimeUp()
	else
		self.showModel = SoraDFIsRA() and 0 or 5
		if self.bid == BUILDID.ELITE_PALACE then
			self.showModel = 1
		end
	end
	self.fields.Button_trainNow:setEnabled(not self.isWarForbid)
	self.controllers.c1:setSelectedIndex(self.showModel)
end
function soldiersCampViewPanel:armyTrainDone()
	self:close()
end
function soldiersCampViewPanel:updateView(target, data)
	self.preArmyID = self.armyID
	self.armyID = self.soldierList[self.curIndex].armyid
	self.fields.List_soldier:setNumItems(#self.soldierList)
	self.fields.List_soldier:scrollToView(self.curIndex - 1)
	local armyLv = serviceFunctions.getArmyViewLev(self.armyID)
	if self.bid ~= BUILDID.FORTRESS and (self.bid == BUILDID.ELITE_PALACE or armyLogic.isStarArmy(self.armyID) or 110 <= armyLv) then
		local modelType = armyDesRead.getModelType(self.armyID)
		local alv = armyLogic.getArmyLV(self.armyID)
		local spineCfg, spineInfo
		if self.armyID ~= self.preArmyID then
			self.fields.Com_army:initData(self.armyID)
		end
		self.fields.Com_army:setVisible(true)
		self.fields.Com_trap:setVisible(false)
	elseif self.bid == BUILDID.FORTRESS then
		self.fields.Com_trap:setVisible(true)
		self.fields.Com_army:setVisible(false)
		self.fields.Com_trap:initData(self.armyID)
	else
		self.fields.Com_army:setVisible(true)
		self.fields.Com_army:initData(self.armyID)
		self.fields.Com_trap:setVisible(false)
	end
	if self.bid == BUILDID.FORTRESS then
		self.controllers.c2:setSelectedIndex(2)
	elseif self.bid == BUILDID.BARRACKS then
		self.controllers.c2:setSelectedIndex(1)
	else
		self.controllers.c2:setSelectedIndex(140 <= armyLv and 3 or 0)
	end
	if self.preArmyID == self.armyID then
	else
		self:playMoveAct()
	end
	self.fields.Com_baseInfo:initData(self.armyID, self.bid, self.trainType)
	self.fields.Com_num:initData(self.armyID, self.bid, self.trainType)
	self.skillList = armyDesRead.getSkill(self.armyID)
	self.fields.List_skill:setNumItems(#self.skillList)
	self.fields.Button_promoteT:setVisible(false)
	if armyltCtrl.isWarframeArmyID(self.armyID) then
		self.showModel = 4
		self:resetWarframeSlider()
		self.controllers.c1:setSelectedIndex(self.showModel)
		self.fields.Com_skip:setVisible(false)
	else
		self:updateMode()
		self:updateToolTrainInfo()
		self:iniResSingle()
		local curCanValue = math.max(self:getMaxCampCount(), self.armyCount)
		if SoraDIsGameGuide() then
			curCanValue = 10
		end
		self.canTrain = armyLogic.getMaxTrainCount(self.bid).total
		if self.bid == BUILDID.FORTRESS then
			self.canTrain = armyLogic.getMaxTrapBuildCount(self.armyID)
		end
		_ENV = self.bid
		self.bid.maxValue = self.canTrain
		self.bid.minValue = 1
		self.bid.curValue = data and self.armyCount or curCanValue
		self.fields.slider:initData(self.bid)
		if self.trainType == TRAIN_TYPE.SOLDIERS then
			local canTrain = armyLogic.getMaxTrainCount(self.bid).total
			local isCanTrain = true
			if self.bid == BUILDID.ELITE_PALACE then
				isCanTrain = 0 < canTrain
			end
			local enable = isCanTrain and not self.isWarForbid
			self.fields.Button_train:setBright(enable)
			self.fields.Button_trainNow:setBright(enable)
			local maxArmyLv = self:getMaxOpenArmyLv()
			self.fields.Com_skip:setVisible(self.bid ~= BUILDID.ELITE_PALACE and 12 <= maxArmyLv)
		else
			self.fields.Com_skip:setVisible(false)
			local canTrain = armyLogic.getMaxTrapBuildCount(self.armyID)
			local isCanTrain = 0 < canTrain and not self.isWarForbid
			self.fields.Button_train:setBright(isCanTrain)
			self.fields.Button_trainNow:setBright(isCanTrain)
		end
	end
end
function soldiersCampViewPanel:getMaxOpenArmyLv()
	_UPVALUE4_ = nil
	;(nil)[1] = BUILDID.CHARIOT_PLANT
	;(nil)[2] = BUILDID.STABLES
	;(nil)[3] = BUILDID.RANGE
	local (nil)[4], bidList = BUILDID.BARRACKS, nil
	local maxArmyLv = 1
	for _, bid in ipairs(bidList) do
		local soldierList, curIndex = armyLogic.getCanTrainList(bid)
		for k, v in ipairs(soldierList) do
			local armyLv = serviceFunctions.getArmyViewLev(v.armyid)
			maxArmyLv = math.max(maxArmyLv, armyLv / 10)
		end
	end
	return maxArmyLv
end
function soldiersCampViewPanel:getMaxCampCount()
	self.trianQueue = queueCtrl:queryQueue(buildRead.getQueueType(self.bid))
	if self.trianQueue then
		return 0
	end
	local resTrain = 0
	local ret = armyLogic.isCanTrain(self.bid, self.armyID)
	local retdata = armyLogic.getTrainResCast(self.bid, self.armyID)
	for i, v in ipairs(retdata._costRes) do
		if 0 < v.rescount then
			if resTrain == 0 then
				resTrain = math.max(1, math.floor(v.curcount / v.rescount))
			else
				resTrain = math.min(resTrain, math.floor(v.curcount / v.rescount))
			end
		end
	end
	local canTrain = 0
	if self.trainType == TRAIN_TYPE.SOLDIERS then
		if self.bid == BUILDID.ELITE_PALACE then
			local eliteTrain = 0
			if retdata._costElitePointInfo then
				local costElitePointInfo = retdata._costElitePointInfo
				eliteTrain = math.floor(costElitePointInfo.currentElitePoint / costElitePointInfo.costElitePoint)
			end
			canTrain = math.min(armyLogic.getMaxTrainCount(self.bid).total, eliteTrain)
		else
			canTrain = armyLogic.getMaxTrainCount(self.bid).total
		end
	else
		canTrain = math.min(resTrain, armyLogic.getMaxTrapBuildCount(self.armyID))
	end
	return canTrain
end
function soldiersCampViewPanel:updateArmyInfo()
	self.fields.Com_num:initData(self.armyID, self.bid, self.trainType)
	self.fields.List_soldier:setNumItems(#self.soldierList)
end
function soldiersCampViewPanel:buildQueueCallback(target, event)
	if self.buildEntity and self.buildEntity:getState() == "harvesting" then
		self:close()
	end
end
function soldiersCampViewPanel:updateLuckyBless()
	local luckyData = luckyBlessCtrl:getLuckyData()
	if luckyData.curEffectType == gLuckyBlessActivityEffectType.TRAIN_SOLDIERS and not armyltCtrl.isWarframeArmyID(self.armyID) then
		local leftTime = luckyBlessCtrl:getRealTime()
		self.fields.Com_lucky:setVisible(true)
		self.fields.Com_lucky:setTime(leftTime, luckyData.discount / 10)
		self.luckyBlessIsOpen = true
	else
		self.fields.Com_lucky:setVisible(false)
		self.luckyBlessIsOpen = false
	end
	self:updateTrainNode()
end
function soldiersCampViewPanel:trainNow(target, data)
	if tonumber(data.bid) == self.bid then
		self:updateView()
		SoraDCloseLoading(self.fields.Button_trainNow)
	end
end
function soldiersCampViewPanel:onSliderChange(val)
	self.armyCount = val
	print("val========", val)
	self:updateTrainNode()
end
function soldiersCampViewPanel:trainSelect(target, data)
	if data.toID then
		for k, v in ipairs(self.soldierList) do
			if v.armyid == data.toID then
				self.curIndex = k
				break
			end
		end
	elseif data.index then
		self.curIndex = data.index
	end
	self.fields.List_soldier:setNumItems(#self.soldierList)
	self:updateView()
end
function soldiersCampViewPanel:iniResSingle()
	_UPVALUE5_ = nil
	self.resList, _ENV, (nil)[1] = gIDDef.FOOD, gIDDef.FOOD, gIDDef.FOOD
	self.resList, _ENV, (nil)[2] = gIDDef.FOOD, gIDDef.FOOD, gIDDef.WOOD
	self.resList, _ENV, (nil)[3] = gIDDef.FOOD, gIDDef.FOOD, gIDDef.IRON
	self.resList, _ENV, (nil)[4] = gIDDef.FOOD, gIDDef.FOOD, gIDDef.MITHRIL
	local self.resList, _ENV, (nil)[5], resArray = gIDDef.FOOD, gIDDef.FOOD, gIDDef.CRYSTAL, nil
	local retdata = armyLogic.getTrainResCast(self.bid, self.armyID)
	for k, v in ipairs(resArray) do
		if SoraDResIsLock(v) and retdata._costRes[k] then
			_ENV = nil
			;(nil).resID = v
			;(nil).rescount = math.ceil(retdata._costRes[k].rescount * self.armyCount)
			;(nil).curcount = retdata._costRes[k].curcount
			table.insert(self.resList, nil)
		end
	end
	if self.bid == BUILDID.ELITE_PALACE then
		_ENV = ipairs(resArray)
		ipairs(resArray).resID = gIDDef.ELITE_POINT
		ipairs(resArray).rescount = retdata._costElitePointInfo.costElitePoint * self.armyCount
		ipairs(resArray).curcount = retdata._costElitePointInfo.currentElitePoint
		table.insert(self.resList, ipairs(resArray))
	end
	self.fields.List_res:setNumItems(#self.resList)
end
function soldiersCampViewPanel:updateTrainNode()
	if armyltCtrl.isWarframeArmyID(self.armyID) then
		self:updateWearView()
		return
	end
	local retdata = armyLogic.getTrainResCast(self.bid, self.armyID)
	local leftTime = math.floor(self.armyCount * retdata._costTime)
	self.fields.Lab_timer:setString(SoraDConvertSecondToString(leftTime))
	self.needRes = false
	self.needResList, armyltCtrl, self.needElite = self.fields.Lab_timer.setString, self.fields.Lab_timer.setString, false
	for i, v in ipairs(retdata._costRes) do
		local costRes = math.ceil(v.rescount * self.armyCount)
		armyltCtrl = v.rescount * self.armyCount
		;(v.rescount * self.armyCount).resid = v.resid
		;(v.rescount * self.armyCount).curcount = v.curcount
		local (v.rescount * self.armyCount).rescount, needResSingle = costRes, v.rescount * self.armyCount
		local _isreach = true
		if costRes > v.curcount then
			_isreach = false
		end
		if self.luckyBlessIsOpen then
			local luckyResCount = luckyBlessCtrl:getResult(v.rescount)
			_isreach = v.curcount >= math.ceil(luckyResCount * self.armyCount)
			needResSingle.rescount = math.ceil(luckyResCount * self.armyCount)
		end
		if not _isreach then
			self.needRes = true
		end
		table.insert(self.needResList, needResSingle)
	end
	if retdata._costElitePointInfo then
		local costElitePointInfo = retdata._costElitePointInfo
		local costRes = costElitePointInfo.costElitePoint * self.armyCount
		local _isreach = true
		if costRes > costElitePointInfo.currentElitePoint then
			_isreach = false
		end
		if not _isreach then
			self.needElite = true
		end
	end
	self:iniResSingle()
	local resCost = 0
	for i = 0, #self.resList - 1 do
		resCost = resCost + self.fields.List_res:getChildAt(i):getResCost()
	end
	self.trianQueue = queueCtrl:queryQueue(buildRead.getQueueType(self.bid))
	if self.trianQueue then
		self.armyCount = tonumber(self.trianQueue.data.armycount)
		local queueTime = self.trianQueue.timerNode.timer:getRemainTime()
		if 0 < queueTime then
			local timeCost = serviceFunctions.timeConvertToGold(queueTime, true)
			self.trainGold = timeCost
			self.fields.Button_trainNow:setCostNum(self.trainGold)
		else
			local timeCost = serviceFunctions.timeConvertToGold(leftTime, true)
			self.trainGold = resCost + timeCost
			self.fields.Button_trainNow:setCostNum(self.trainGold)
		end
	else
		local timeCost = serviceFunctions.timeConvertToGold(leftTime, true)
		self.trainGold = resCost + timeCost
		self.fields.Button_trainNow:setCostNum(self.trainGold)
	end
end
function soldiersCampViewPanel:updateToolTrainInfo(target, data)
	if self.bid ~= BUILDID.ELITE_PALACE and self.bid ~= BUILDID.FORTRESS then
		local toolAddInfo = armyCtrl:getSingleAddInfo()
		if toolAddInfo and next(toolAddInfo) then
			self.fields.Button_tip:setVisible(toolAddInfo.itemCount > 0)
			self.fields.Text_tool:setVisible(toolAddInfo.itemCount > 0)
			_ENV = nil
			;(nil).addCount = toolAddInfo.addCount
			_ENV = nil
			;(nil).itemCount = toolAddInfo.itemCount
			self.fields.Text_tool:setString(i18n("common_text_3529", nil) .. " " .. i18n("common_text_3528", nil))
		end
		local ret = backpackCtrl:getItemsByEffect(gItemEffectDef.SINGLE_TRAIN_ADD_COUNT)
		self.fields.Button_tool:setVisible(ret)
		if data then
			self.canTrain = armyLogic.getMaxTrainCount(self.bid).total
			_ENV = ret
			ret.maxValue = self.canTrain
			ret.minValue = 1
			ret.curValue = self.armyCount
			self.fields.slider:initData(ret)
		end
	else
		self.fields.Button_tool:setVisible(false)
		self.fields.Button_tip:setVisible(false)
		self.fields.Text_tool:setVisible(false)
	end
end
function soldiersCampViewPanel:onTipClick()
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("common_text_4353"))
end
function soldiersCampViewPanel:onToolClick()
	SoraDPlaySound()
	local panel = SoraDCreatePanel("trainArmyLimitView")
	panel:initData(gItemType.SINGLE_TRAIN_ADD_COUNT)
	panel:show()
end
function soldiersCampViewPanel:onTrainClick()
	SoraDPlaySound()
	if not self.fields.Button_train:isBright() then
		if self.isWarForbid then
			worldMapDefine.showWarTips()
			return
		end
		if self.trainType == TRAIN_TYPE.SOLDIERS then
			SoraDShowMsgTip(i18n("common_text_3232"))
		else
			_ENV = self.fields.Com_num
			gModuleMgr.sharedMgr("mildGuideManager"):drawFingerToTarget(self.fields.Com_num:getTrapBtn(), self.fields.Com_num)
		end
	elseif self.needElite then
		SoraDShowMsgTip(i18n("common_text_3230"), publicRead.getIcon(gIDDef.ELITE_POINT, true))
	elseif self.needRes then
		if SoraDIsGameGuide() then
			self:resBuyCallBack()
		elseif self.isQuick then
			local isOwnEnoughRes = true
			self.optResList, _ENV, self.backpackResTmp, _ENV = self, self, self, self
			self.backpackResList = self:getQuickTrainResList()
			for _, v in ipairs(self.backpackResList) do
				if v.type == 99 and v.count > 0 then
					table.insert(self.optResList, v)
				end
			end
			table.sort(self.optResList, function(a, b)
				if a.quality == b.quality then
					return a.priority < b.priority
				else
					return a.quality < b.quality
				end
			end)
			local tableResData, resCostGold = self:getResTmp()
			for _, need in ipairs(tableResData) do
				if not self:isBackpackResEnough(need.resid, need.rescount) then
					isOwnEnoughRes = false
					break
				end
			end
			print("isOwnEnoughRes====", isOwnEnoughRes)
			if not isOwnEnoughRes then
				SoraDShowMsgTip(i18n("soldier_quick_train02"))
				self.backpackResList, _ENV, self.isQuick = SoraDShowMsgTip, SoraDShowMsgTip, false
				self.fields.Com_skip:setSelected(self.isQuick)
			else
				self:checkIsMaxSingleAdd(OPERATE_MODE.NORMAL)
			end
		else
			self:showResBuyView()
		end
	else
		self:checkIsMaxSingleAdd(OPERATE_MODE.NORMAL)
	end
end
function soldiersCampViewPanel:getResTmp()
	local armyLogic, tableResData
	local retdata = armyLogic.getTrainResCast(self.bid, self.armyID)
	local resCostGold = 0
	for i, v in ipairs(retdata._costRes) do
		local costRes = math.ceil(v.rescount * self.armyCount)
		local armyLogic, resSingleData = v.rescount * self.armyCount, v.rescount * self.armyCount
		resSingleData.rescount = v.rescount * self.armyCount
		resSingleData.isreach = true
		local needBuyRes = resSingleData.rescount - v.curcount
		if self.luckyBlessIsOpen then
			needBuyRes = luckyBlessCtrl:getResult(resSingleData.rescount) - v.curcount
			resCostGold = resCostGold + serviceFunctions.resConvertToGold(v.resid, needBuyRes)
		else
			resCostGold = resCostGold + serviceFunctions.resConvertToGold(v.resid, math.max(0, costRes - v.curcount))
		end
		if 0 < needBuyRes then
			resSingleData.isreach = false
			resSingleData.resid = v.resid
			resSingleData.rescount = math.ceil(needBuyRes)
			table.insert(tableResData, resSingleData)
		end
	end
	return tableResData, resCostGold
end
function soldiersCampViewPanel:showResBuyView()
	local resBuyType = RESBUYVIEW_TYPE.TRAIN_TRAP
	if self.trainType == TRAIN_TYPE.SOLDIERS then
		resBuyType = RESBUYVIEW_TYPE.TRAIN_ARMY
	end
	local tableResData, resCostGold = self:getResTmp()
	self.resCostGold = resCostGold
	local proxy = uiManager:getOrCreateProxy("CommonQuicklyadd")
	if next(tableResData) and proxy:checkNeedRes(tableResData) then
		uiManager:show("CommonQuicklyadd")
		return
	end
	_ENV, _ENV = nil, nil
	;(nil).resToGold = self.resCostGold
	;(nil).needResData, (nil).retCostRes = nil, tableResData
	;(nil).viewType = resBuyType
	;(nil).handle = handler(self, self.resBuyCallBack)
	uiManager:show("buildCreateResBuy", nil)
end
function soldiersCampViewPanel:isBackpackResEnough(resID, resCount)
