local gametop = gModuleMgr.getObject("gametop")
local armyCtrl = gametop.playertop_:getModule("armyCtrl")
local buffCtrl = gametop.playertop_:getModule("buffCtrl")
local cityEffectInfoRead = include("cityEffectInfoRead")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local buildLogic = include("buildLogic")
local armyDesRead = include("armyDesRead")
local armyltCtrl = include("armyltCtrl")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local epicBattleDispatchArmyView = class("epicBattleDispatchArmyView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("epicBattleDispatchArmyView")
	end
	return target
end)
local gSoldierSelectType = _G.gSoldierSelectType
local gHeroSelectBannerStyle = _G.gHeroSelectBannerStyle
function epicBattleDispatchArmyView:ctor()
	self.isHideCurrentSceneView = true
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("common_text_481"))
	self.nodeHero = SoraDGetExtendChildFromCCSByName(self, "CCS_heroSelectBanner_hero")
	self.nodeHero:setMode(gHeroSelectBannerStyle.epicDispatch)
	self.nodeHero:setInnerSelectCallBack(handler(self, self.updateHero))
	self.nodeHero:setRemoveCallBack(handler(self, self.updateHero))
	self.otherData, _ENV = self.nodeHero.setRemoveCallBack, self.nodeHero.setRemoveCallBack
	self.tableArmyData, _ENV, self.tableArmy, _ENV, self.tableSpare, _ENV, self.tableArmySingle, _ENV, self.targetPos = self.nodeHero.setRemoveCallBack, self.nodeHero.setRemoveCallBack, self.nodeHero.setRemoveCallBack, self.nodeHero.setRemoveCallBack, self.nodeHero.setRemoveCallBack, self.nodeHero.setRemoveCallBack, self.nodeHero.setRemoveCallBack, self.nodeHero.setRemoveCallBack, nil
	self.allowMaxCount = nil
	self.curCount = 0
	self.curWeight = 0
	self.isSelectFull = false
	self.btnQuickChoose = SoraDGetChildByName(self, "Button_quick")
	self.btnQuickChoose:setTitleText(i18n("common_text_852"))
	self.btnGo = SoraDGetChildByName(self, "Button_go")
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.labelNotice:setString(i18n("common_text_858"))
	self.btn_convene = SoraDGetChildByName(self, "Button_convene")
	self.btn_convene:setTitleText(i18n("common_text_3616"))
	self.text_percent = SoraDGetChildByName(self, "Text_5")
	self.text_percent:setString("%")
	self.btnFiler = SoraDGetChildByName(self, "Button_select")
	self.btnFiler:setTitleText(i18n("gem_btn_01"))
	self.labelCount = SoraDGetChildByName(self, "Text_count")
	self.labelCountTotal = SoraDGetChildByName(self, "Text_countTotal")
	self.btnCountPlus = SoraDGetChildByName(self, "Button_countPlus")
	self.btnCountPlus:setVisible(false)
	self.spriteCount = SoraDGetChildByName(self, "Sprite_count")
	self.labelWeight = SoraDGetChildByName(self, "Text_weight")
	self.labelWeight:setString("0")
	self.spriteWeight = SoraDGetChildByName(self, "Sprite_weight")
	self.btnPhysicalPlus = SoraDGetChildByName(self, "Button_physicalPlus")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_go")
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.topNode = SoraDGetChildByName(self, "Top_Node")
	self.armySlider = SoraDGetExtendChildFromCCSByName(self, "CCS_commonSlider_slider")
	_ENV = "CCS_commonSlider_slider"
	;("CCS_commonSlider_slider").maxValue = 100
	;("CCS_commonSlider_slider").minValue = 0
	_ENV, ("CCS_commonSlider_slider").curValue = handler(self, self.scrollEventCallBack)
	;("CCS_commonSlider_slider").editBoxData, handler(self, self.scrollEventCallBack).color = handler(self, self.scrollEventCallBack)
	self.armySlider:initData("CCS_commonSlider_slider")
	self.armySlider:setSliderCallBack(handler(self, self.armyChange))
	self.btnTeam = SoraDGetChildByName(self, "Button_team")
	self.btnTeam:setVisible(false)
	self.btnQuickChoose:addTouchEventListener(handler(self, self.btnQuickClickCallBack))
	self.btnGo:addTouchEventListener(handler(self, self.btnGoClickCallBack))
	self.btnPhysicalPlus:addTouchEventListener(handler(self, self.btnPhysicalPlusClickCallBack))
	self.btn_convene:addTouchEventListener(handler(self, self.btnConveneClickCallBack))
	self.btnFiler:addTouchEventListener(handler(self, self.OnBtnFilerClick))
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self.btnGo:setTitleText(i18n("arena_btn_04"))
	self.labelGoTitle = SoraDGetChildByName(self, "Text_btnGoTitle")
	self.labelGoTitle:setString(i18n("common_text_481"))
	self.btnGo:removeChildByName("Text_btnGoTitle")
	self.btnGo:removeChildByName("Text_time")
	self.btnGo:removeChildByName("icon_hourglass_3")
end
function epicBattleDispatchArmyView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_CITYBUFF_ADD", function(target, data)
		if data.data and data.data.effectType == 19 then
			self:updateCountLabel()
		end
	end)
	SoraDAddMessage(self, "MESSAGE_ARMY_SELECT_TYPE", handler(self, self.selectArmyType))
end
function epicBattleDispatchArmyView:armyChange(armyPer)
	self:resetArmySelect()
	local canUseCount = 0
	for _, v in pairs(self.tableArmyData) do
		canUseCount = canUseCount + v.armycount
	end
	armyPer = math.min(armyPer, self.allCount * 100 / canUseCount)
	for armyid in pairs(self.tableArmyData) do
		local singleMax = self:getArmyCount(armyid)
		local canUseSingle = math.ceil(singleMax * armyPer / 100)
		self:setCurValByArmyid(armyid, canUseSingle)
	end
	_ENV = armyPer
	armyPer.notBack = true
	self.armySlider:updateSlier(math.ceil(armyPer), armyPer)
	self:updateView()
end
function epicBattleDispatchArmyView:updateCountLabel()
	self.labelCount:setString(tostring(self.curCount) .. "/")
	self.labelCountTotal:setString(tostring(self.allCount))
	self.labelCountTotal:setColor(self.curCount == self.allCount and display.COLOR_GREEN or display.COLOR_WHITE)
end
function epicBattleDispatchArmyView:btnTeamClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		armyCtrl:getArmyCompile(button:getTag())
		SoraDShowLoading(self)
	end
end
function epicBattleDispatchArmyView:initData(data, targetPos)
	self.data = data
	dump(self.data, "self.data====")
	self.targetPos = targetPos
	local armyIDList = epicWarCtrl:getCurArmyList()
	local oriList = epicWarCtrl:getOriArmyList()
	self.armyIDList, _ENV = epicWarCtrl, epicWarCtrl
	local total = 0
	for aid, v in pairs(armyIDList) do
		armyID = tonumber(aid)
		local armyLv = armyID % 100
		local weight = armyDesRead.getFreeWeightAndSp(armyID)
		local soldierType = armyltCtrl.getSoldierType(armyID)
		_ENV = armyID
		armyID.armyID = armyID
		armyID.level = armyLv
		armyID.weight = weight
		local armyID.soldierType, tableArmyID = soldierType, armyID
		table.insert(self.armyIDList, tableArmyID)
		total = total + v
	end
	table.sort(self.armyIDList, function(army1, army2)
		if army1.level ~= army2.level then
			return army2.level < army1.level
		end
		return army1.armyID < army2.armyID
	end)
	local oriTotal = 0
	for k, v in pairs(oriList) do
		oriTotal = oriTotal + v
	end
	self.curCount = total
	self.allCount = oriTotal
	for _, v in ipairs(self.armyIDList) do
		local id = v.armyID
		local haveCount = armyIDList[tostring(id)]
		if 0 < haveCount then
			table.insert(self.tableArmy, id)
			_ENV = self.tableArmy
			self.tableArmy.armyid = id
			self.tableArmy.armycount = haveCount
			self.tableArmy.curCount = 0
			self.tableArmyData[id], self.tableArmy.weight = self.tableArmy, v.weight
		end
	end
	self.labelNotice:setVisible(0 >= #self.tableArmy)
	self.btn_convene:setVisible(0 >= #self.tableArmy)
	self.labelCount:setString(tostring(self.curCount) .. "/")
	self.labelCountTotal:setString(tostring(self.allCount))
	self:initScroll()
	self:quickChoose(true)
end
function epicBattleDispatchArmyView:updateMaxCount(maxCount)
	self.allowMaxCount = maxCount
	self:updateCountLabel()
	if self.isSelectFull and self.curCount > self.allCount then
		self:quickChoose(self.isSelectFull)
	end
end
function epicBattleDispatchArmyView:initScroll()
	self.scroll:removeAllChildren()
	local scrollH = math.max(self.scroll:getContentSize().height, 130 * #self.tableArmy)
	self.scroll:setInnerContainerSize(cc.size(640, scrollH))
	for i, armyid in ipairs(self.tableArmy) do
		local posY = scrollH - 5 - (i - 1) * 130
		_ENV = cc.size(640, scrollH)
		cc.size(640, scrollH).armyid = armyid
		cc.size(640, scrollH).posY = posY
		cc.size(640, scrollH).point = nil
		table.insert(self.tableArmySingle, cc.size(640, scrollH))
	end
	self:updateScrollList()
end
function epicBattleDispatchArmyView:updateScrollList()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	_ENV = self.scroll
	self.scroll.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scroll.endY, tableShowH = offsetY + 1.5 * scrollH, self.scroll
	for i, v in ipairs(self.tableArmySingle) do
		if v.point then
			if v.posY < tableShowH.beginY or v.posY > tableShowH.endY then
				v.point:setVisible(false)
				table.insert(self.tableSpare, v.point)
				v.point = nil
			end
		elseif tableShowH.beginY <= v.posY and tableShowH.endY >= v.posY then
			local single
			if 0 < #self.tableSpare then
				single = table.remove(self.tableSpare)
				single:setVisible(true)
			else
				single = SoraDCreatePanel("worldDispatchArmySingle")
				single:setSliderChangeBack(handler(self, self.singleSliderChange))
				single:setScroll(self.scroll)
				single:addTo(self.scroll)
				single:setVisible(true)
			end
			local armyData = self.tableArmyData[v.armyid]
			if armyData then
				single:initData(armyData)
			end
			single:setPosition(cc.p(0, v.posY))
			single:setLocalZOrder(i)
			v.point = single
		end
	end
end
function epicBattleDispatchArmyView:singleSliderChange(target, data)
	self:setCurValByArmyid(data.armyid, data.armycount)
	self:updateView()
end
function epicBattleDispatchArmyView:updateView()
	self:updateLabelAndWeight()
	self:updateScroll()
	self:setBtnBright()
end
function epicBattleDispatchArmyView:updateScroll()
	for _, v in pairs(self.tableArmySingle) do
		if v.point then
			v.point:updateView()
		end
	end
end
function epicBattleDispatchArmyView:updateLabelAndWeight()
	self.labelCount:setString(tostring(self.curCount) .. "/")
	self.labelCountTotal:setString(tostring(self.allCount))
	self.curWeight = 0
	local addWeight = 1 + kingdomMapCtrl:getArmyWeightPlus()
	for _, v in pairs(self.tableArmyData) do
		self.curWeight = self.curWeight + v.weight * v.curCount * addWeight
	end
	self.labelWeight:setString(string.formatnumberthousands(math.floor(self.curWeight)))
end
function epicBattleDispatchArmyView:btnPhysicalPlusClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("common_text_987"))
	end
end
function epicBattleDispatchArmyView:btnConveneClickCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("召集士兵")
		SoraDCreatePanel("armyBuildingsView"):show()
	end
end
function epicBattleDispatchArmyView:btnFatClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:resetArmySelect()
		local _ENV, tableWeight = self.resetArmySelect, self.resetArmySelect
		for i, v in pairs(self.tableArmyData) do
			local curWeight = v.weight
			local insertI = #tableWeight + 1
			for j, w in ipairs(tableWeight) do
				if curWeight > w.weight then
					insertI = j
					break
				end
			end
			_ENV = nil
			;(nil).armyid = i
			;(nil).weight = curWeight
			table.insert(tableWeight, insertI, nil)
		end
		for _, v in ipairs(tableWeight) do
			self:setCurValMax(v.armyid)
		end
		self:updateView()
	end
end
function epicBattleDispatchArmyView:showTip(target)
	self.imgFatTip:setOpacity(0)
	self.imgFatTip:stopAllActions()
	self.imgFastTip:setOpacity(0)
	self.imgFastTip:stopAllActions()
	_UPVALUE2_ = nil
	;(nil)[1] = cca.fadeIn(0.5)
	;(nil)[2] = cca.delay(3)
	;(nil)[3] = cca.fadeOut(0.5)
	;(nil)[4] = cca.fadeOut(0.5)
	target:runAction(cca.seq(nil))
end
function epicBattleDispatchArmyView:btnFastClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local haveQB = false
		for _, armyid in ipairs(self.tableArmy) do
			if armyltCtrl.getSoldierType(armyid) == gSoldierType.SOLDIER_TYPE_QIBING then
				haveQB = true
				break
			end
		end
		if haveQB then
			self:resetArmySelect()
			for _, armyid in ipairs(self.tableArmy) do
				if armyltCtrl.getSoldierType(armyid) == gSoldierType.SOLDIER_TYPE_QIBING then
					self:setCurValMax(armyid)
				end
			end
			self:updateView()
		else
			SoraDShowMsgTip(i18n("common_text_2751"), "#icon_fight_speed_rank.png")
		end
	end
end
function epicBattleDispatchArmyView:setBtnBright(...)
	if self.curCount > 0 then
		self.btnGo:setTouchEnabled(true)
		self.btnGo:setBright(true)
	else
		self.btnGo:setTouchEnabled(false)
		self.btnGo:setBright(false)
	end
end
function epicBattleDispatchArmyView:updateBtnText()
	if self.isSelectFull then
		self.btnQuickChoose:setTitleText(i18n("common_btn_18"))
	else
		self.btnQuickChoose:setTitleText(i18n("common_text_852"))
	end
end
function epicBattleDispatchArmyView:quickChoose(isFull)
	self:quickChoose_hero(isFull)
	self:quickChoose_army(isFull)
	self:updateBtnText()
end
function epicBattleDispatchArmyView:quickChoose_hero(isFull)
	if isFull then
		self.nodeHero:filterHerosByMode(epicWarCtrl:getCurHeroList())
	else
		self.nodeHero:clearHeros()
	end
	self:updateHero()
end
function epicBattleDispatchArmyView:quickChoose_army(isFull)
	local armyData = gModuleMgr.sharedMgr("mildGuideManager"):getVariate(self.__cname, "armyData")
	if armyData then
		for armyid in pairs(self.tableArmyData) do
			if armyData[armyid] then
				local singleMax = self:getArmyCount(armyid)
				self:setCurValByArmyid(armyid, math.min(singleMax, armyData[armyid]))
			else
				self:setCurValByArmyid(armyid, 0)
			end
		end
	elseif isFull then
		for _, armyid in pairs(self.tableArmy) do
			self:setCurValMax(armyid)
		end
	else
		self:resetArmySelect()
	end
	self:updateView()
	self.isSelectFull = isFull
end
function epicBattleDispatchArmyView:btnQuickClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:quickChoose(not self.isSelectFull)
	end
end
function epicBattleDispatchArmyView:btnGoClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local _ENV, dispatchArmyList = SoraDPlaySound, SoraDPlaySound
		for _, v in pairs(self.tableArmyData) do
			if v.curCount > 0 then
				_ENV = nil
				;(nil).id = v.armyid
				;(nil).num = v.curCount
				table.insert(dispatchArmyList, nil)
			end
		end
		local heroInfo = self.nodeHero:exportHeros()
		if self.curCount > self.allCount and self.heroChange then
			SoraDShowMsgTip(i18n("hero_text_02"))
			self:resetArmySelect()
			self:updateView()
			self.isSelectFull = false
			self:updateBtnText()
			return
		elseif 0 < #dispatchArmyList then
			epicWarCtrl:sendReqTriggerEvent(self.targetPos, heroInfo, dispatchArmyList)
			SoraDShowLoading()
			self:removeFromParent()
		else
			SoraDShowMsgBox(i18n("notice_0158"), i18n("common_text_204"))
		end
	end
end
function epicBattleDispatchArmyView:resetArmySelect()
	if self.tableArmyData and next(self.tableArmyData) then
		for _, v in pairs(self.tableArmyData) do
			v.curCount = 0
		end
	end
	self.curCount = 0
end
function epicBattleDispatchArmyView:getArmyCurCount(armyid)
	local armyData = self.tableArmyData[armyid]
	if armyData then
		return armyData.curCount
	end
	return 0
end
function epicBattleDispatchArmyView:getArmyCount(armyid)
	local armyData = self.tableArmyData[armyid]
	if armyData then
		return armyData.armycount
	end
	return 0
end
function epicBattleDispatchArmyView:setCurValMax(armyid)
	local armyMax = self:getArmyCount(armyid)
	self:setCurValByArmyid(armyid, armyMax)
end
function epicBattleDispatchArmyView:setCurValByArmyid(armyid, curCount)
	local armyData = self.tableArmyData[armyid]
	if not armyData then
		print("setCurValByArmyid error", armyid, curCount)
		return 0
	end
	if curCount > armyData.armycount then
		print("setCurValByArmyid armycount error", armyid, curCount)
		return 0
	end
	local curArmyCount = self.curCount
	if 0 < armyData.curCount then
		curArmyCount = self.curCount - armyData.curCount
		if curArmyCount < 0 then
			print("setCurValByArmyid curCount error", armyid, curCount)
			return 0
		end
	end
	if curArmyCount + curCount > self.allCount and 0 < curCount then
		curCount = self.allCount - curArmyCount
	end
	armyData.curCount = curCount
	self.curCount = curArmyCount + curCount
	return curCount
end
function epicBattleDispatchArmyView:setCurValByIndex(index, curCount)
	local armyid = self.tableArmy[index]
	if checknumber(armyid) > 0 then
		return self:setCurValByArmyid(armyid, curCount)
	else
		print("setCurValByIndex error", index, curCount)
	end
	return 0
end
function epicBattleDispatchArmyView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:updateScrollList()
	end
end
function epicBattleDispatchArmyView:selectArmyTypeByFun(sortFun)
	table.sort(self.armyIDList, sortFun)
	self:resetArmySelect()
	for _, v in ipairs(self.armyIDList) do
		self:setCurValMax(v.id)
	end
	self:updateView()
end
function epicBattleDispatchArmyView:selectArmyType_imp(selectType)
	local createFunBytype = function(armyType)
		local sortFun = function(army1, army2)
			if army1.soldierType ~= army2.soldierType and (army1.soldierType == armyType or army2.soldierType == armyType) then
				return army1.soldierType == armyType
			end
			if army1.level ~= army2.level then
				return army1.level > army2.level
			end
			return army1.armyID < army2.armyID
		end
		return sortFun
	end
	if selectType == gSoldierSelectType.SOLDIER_SELECT_TYPE_BUBING then
		local sortFun = createFunBytype(gSoldierType.SOLDIER_TYPE_BUBING)
		self:selectArmyTypeByFun(sortFun)
	elseif selectType == gSoldierSelectType.SOLDIER_SELECT_TYPE_QIBING then
		local sortFun = createFunBytype(gSoldierType.SOLDIER_TYPE_QIBING)
		self:selectArmyTypeByFun(sortFun)
	elseif selectType == gSoldierSelectType.SOLDIER_SELECT_TYPE_GONGBING then
		local sortFun = createFunBytype(gSoldierType.SOLDIER_TYPE_GONGBING)
		self:selectArmyTypeByFun(sortFun)
	elseif selectType == gSoldierSelectType.SOLDIER_SELECT_TYPE_CHEBING then
		local sortFun = createFunBytype(gSoldierType.SOLDIER_TYPE_CHEBING)
		self:selectArmyTypeByFun(sortFun)
	elseif selectType == gSoldierSelectType.SOLDIER_SELECT_TYPE_WEIGHT then
		local sortFun = function(army1, army2)
			if army1.weight ~= army2.weight then
				return army1.weight > army2.weight
			end
			if army1.level ~= army2.level then
				return army1.level > army2.level
			end
			return army1.armyID < army2.armyID
		end
		self:selectArmyTypeByFun(sortFun)
	elseif selectType == gSoldierSelectType.SOLDIER_SELECT_TYPE_LEVEL then
		local sortFun = function(army1, army2)
			if army1.level ~= army2.level then
				return army1.level > army2.level
			end
			return army1.armyID < army2.armyID
		end
		self:selectArmyTypeByFun(sortFun)
	end
end
function epicBattleDispatchArmyView:OnBtnFilerClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		uiManager:show("worldDispatchArmySelectView")
	end
end
function epicBattleDispatchArmyView:selectArmyType(target, redata)
	if redata and redata.selectType then
		self:selectArmyType_imp(redata.selectType)
	end
end
function epicBattleDispatchArmyView:updateHero()
	local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
	local heroInfo = self.nodeHero:exportHeros()
	local lieutenantInfo = self.nodeHero:exportLieutenantHeros()
	local heroBuff = heroltCtrl:getSomeSkillValue(heroInfo, nil, lieutenantInfo)
	local heroWeightAdd = heroBuff[gBuffEffect.SOLDIER_LOAD_BOOST] or 0
	local heroCount = heroltCtrl:getHerosMarchCapacity(heroInfo)
	self.heroCount = heroCount
	self.heroWeightAdd = heroWeightAdd / 1000
	if 0 < self.heroCount then
		self.heroChange = true
	end
	self:updateCountLabel()
	self:updateLabelAndWeight()
	if display.height / display.width < 1.5 then
		_UPVALUE1_ = nil
		_UPVALUE1_, (nil)[1] = self.scroll, self.scroll
		self.scroll[1] = self.scroll
		self.nodeHero:setFitHeroTacticUIs(nil, self.scroll)
	else
		_UPVALUE3_ = nil
		_UPVALUE1_, (nil)[1] = self.scroll, self.scroll
		_UPVALUE1_, (nil)[2] = self.scroll, self.labelNotice
		_UPVALUE1_, (nil)[3] = self.scroll, self.btn_convene
		self.scroll[1] = self.scroll
		self.nodeHero:setFitHeroTacticUIs(nil, self.scroll)
	end
end
function epicBattleDispatchArmyView:gameGuide_getTarget(itemName, parameters)
	if itemName == "Button_go" then
		self.curCount = 0
		if parameters.armyData then
			for armyid, v in pairs(self.tableArmyData) do
				if parameters.armyData[armyid] then
					v.curCount = math.min(v.armycount, parameters.armyData[armyid])
				else
					v.curCount = 0
				end
				self.curCount = self.curCount + v.curCount
			end
		end
		if self.curCount <= 0 then
			self:quickChoose(true)
		else
			self:updateView()
		end
	end
	return SoraDGetChildByName(self, itemName)
end
return epicBattleDispatchArmyView
