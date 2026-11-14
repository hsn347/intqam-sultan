local armyLogic = include("armyLogic")
local armyDesRead = include("armyDesRead")
local armorSystemRead = include("armorSystemRead")
local armyltCtrl = include("armyltCtrl")
local armorSystemCtrl = SoraDGetCtrl("armorSystemCtrl")
local armyCtrl = SoraDGetCtrl("armyCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local publicRead = include("publicRead")
local constantRead = include("constantRead")
local MAX_NUM = 1000000
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local soldiersPromoteTViewPanel = class("soldiersPromoteTViewPanel", baseFguiPanel)
function soldiersPromoteTViewPanel:ctor(...)
	self.isLRU = true
	soldiersPromoteTViewPanel.super.ctor(self, ...)
	print("soldiersPromoteTViewPanel:ctor", self.viewName)
end
function soldiersPromoteTViewPanel:onInit()
	print("=======soldiersPromoteTViewPanel:onInit")
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_title:initData(i18n("gilt_armor_text18"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.Text_tip = SoraDCreateTimerLabel(self, self.fields.Text_tip)
	self.Text_tip:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("gilt_armor_text21", nil)
	end)
	self.fields.Btn_ownDetail:addClickListener(handler(self, self.btnOwnDetailClick))
	self.fields.List_res:setAlignCenter(true)
	self.fields.List_res:setItemRenderer(handler(self, self.onResRender))
	self.fields.Com_slider:setSliderCallBack(handler(self, self.onSliderChange))
	self.fields.Text_left:addClickListener(handler(self, self.onTextEvent))
	self.fields.Button_promote:setString(i18n("arms_promotion_btn_01"))
	self.fields.Button_promote:addClickListener(handler(self, self.btnPromoteClick))
end
function soldiersPromoteTViewPanel:onTextEvent()
	SoraDPlaySound()
	local ret = technologyCtrl:getTechDataByType(gTechnologyType.ARMOR_SOLIDER_PROMOTION_NUM)
	if 0 < #ret then
		local _ENV, canLvupList = #ret, #ret
		local _ENV, maxList = gTechnologyType.ARMOR_SOLIDER_PROMOTION_NUM, gTechnologyType.ARMOR_SOLIDER_PROMOTION_NUM
		for _, v in ipairs(ret) do
			if v.lv == v.maxLv then
				table.insert(maxList, v.id)
			elseif v.isUnlock then
				table.insert(canLvupList, v.id)
			end
		end
		table.sort(canLvupList)
		table.sort(maxList)
		local toTechID = canLvupList[1] or maxList[1]
		_ENV = nil
		;(nil).technologyID = toTechID
		uiManager:show("ArmorTechnology", nil)
		_ENV = nil
		;(nil).technologyID = toTechID
		uiManager:show("ArmorTechnologyDetail", nil)
	end
end
function soldiersPromoteTViewPanel:onResRender(index, obj)
	_ENV = index + 1
	obj:initData(self.resList[index + 1], index + 1, self)
	obj:setResColor(cc.c3b(255, 251, 213))
end
function soldiersPromoteTViewPanel:endShow()
	print("=======soldiersPromoteTViewPanel:endShow")
	self.armorId = self.param and self.param.armorId
	self.armyID = self.param and self.param.armyID
	self.giltCost = constantRead.getConstValueArray("T14_UP_GILT_COST")
	armyDesRead, self.tabsetArray, _ENV, self.tag = constantRead.getConstValueArray("T14_UP_GILT_COST"), constantRead.getConstValueArray("T14_UP_GILT_COST"), constantRead.getConstValueArray("T14_UP_GILT_COST"), 1
	constantRead.getConstValueArray("T14_UP_GILT_COST")[1] = BUILDID.CHARIOT_PLANT
	constantRead.getConstValueArray("T14_UP_GILT_COST")[2] = BUILDID.STABLES
	constantRead.getConstValueArray("T14_UP_GILT_COST")[3] = BUILDID.RANGE
	local constantRead.getConstValueArray("T14_UP_GILT_COST")[4], buildIDCfg = BUILDID.BARRACKS, constantRead.getConstValueArray("T14_UP_GILT_COST")
	for k, v in ipairs(buildIDCfg) do
		local armyID = armyLogic.getCanTrainT(v)
		local armorId = armorSystemRead:getArmorIdByArmyId(armyID)
		local t13ArmorId = armorSystemRead:getT13ArmorID(armorId)
		_ENV = armorId
		armorId.isArmorID = true
		armorId.armorID = armorId
		local isOpenT14 = SoraDIsGildedArmorOpen(armorId)
		_ENV = nil
		;(nil).isArmorID = true
		;(nil).armorID = t13ArmorId
		local isOpenT13 = SoraDIsBrave8Level(nil)
		local isLock = not isOpenT13 or not isOpenT14
		_ENV = nil
		;(nil).title = armyDesRead.getName(armyID)
		;(nil).tag = k
		;(nil).armyID = armyID
		;(nil).armorId = armorId
		;(nil).t13ArmorId = t13ArmorId
		;(nil).isLock = isLock
		;(nil).isOpenT13 = isOpenT13
		;(nil).isOpenT14 = isOpenT14
		table.insert(self.tabsetArray, nil)
		if self.param and self.param.isFromLv13 then
			local sourceArmyID = armorSystemCtrl:getArmyIdByArmorId(armorId, 13)
			if sourceArmyID == self.armyID then
				self.tag = k
			end
		elseif self.armyID == armyID then
			self.tag = k
		end
	end
	_ENV = ipairs(buildIDCfg)
	ipairs(buildIDCfg).defaultClick = self.tag
	ipairs(buildIDCfg).tabsetArray = self.tabsetArray
	ipairs(buildIDCfg).callback = handler(self, self.onTabClick)
	self.fields.com_Tab:initView(ipairs(buildIDCfg))
end
function soldiersPromoteTViewPanel:onTabClick(tag)
	if self.tabsetArray[tag].isLock then
		local t13Name = i18n(armorSystemRead:getProperty(self.tabsetArray[tag].t13ArmorId, "name"))
		local t14Name = i18n(armorSystemRead:getProperty(self.tabsetArray[tag].armorId, "name"))
		local armyNameStr = t14Name
		if not self.tabsetArray[tag].isOpenT13 and not self.tabsetArray[tag].isOpenT14 then
			armyNameStr = t13Name .. "+" .. t14Name
		elseif not self.tabsetArray[tag].isOpenT13 then
			armyNameStr = t13Name
		elseif not self.tabsetArray[tag].isOpenT14 then
			armyNameStr = t14Name
		end
		_ENV = armorSystemRead:getProperty(self.tabsetArray[tag].armorId, "name")
		armorSystemRead:getProperty(self.tabsetArray[tag].armorId, "name").army = armyNameStr
		SoraDShowMsgTip(i18n("gilt_armor_text20", armorSystemRead:getProperty(self.tabsetArray[tag].armorId, "name")))
		self.fields.com_Tab:setTabIndex(self.tag)
		return
	end
	self.tag = tag
	self:updateView()
end
function soldiersPromoteTViewPanel:updateView()
	local armorId = self.tabsetArray[self.tag].armorId
	local sourceArmyID = armorSystemCtrl:getArmyIdByArmorId(armorId, 13)
	self.sourceArmyID = sourceArmyID
	self.fields.Com_armyFrom:initData(sourceArmyID)
	self.fields.Lab_nameFrom:setString(armyDesRead.getName(sourceArmyID))
	local armyCount = armyCtrl:getArmyCount(sourceArmyID, ARMY_OPTYPE.ALL_ARMY)
	local canPromoteCount = armyCtrl:getNormalArmyCount(sourceArmyID)
	armorSystemCtrl = armyDesRead.getName(sourceArmyID)
	armyDesRead.getName(sourceArmyID).num = string.formatnumberthousands(armyCount)
	self.fields.Text_own:setString(i18n("gilt_armor_text23", armyDesRead.getName(sourceArmyID)))
	local targetArmyID = self.tabsetArray[self.tag].armyID
	self.fields.Com_armyTo:initData(targetArmyID)
	self.fields.Lab_nameTo:setString(armyDesRead.getName(targetArmyID))
	local limitTechNum = technologyCtrl:getTechnologyPower(gTechnologyType.ARMOR_SOLIDER_PROMOTION_NUM) or 0
	self.leftPromoteCount = math.max(0, limitTechNum - armorSystemCtrl:getMothyGetArmorNum())
	armorSystemCtrl = self.leftPromoteCount
	self.leftPromoteCount.u = true
	self.leftPromoteCount.c = true
	self.leftPromoteCount.name = "clickNum"
	self.leftPromoteCount.color = 0 < self.leftPromoteCount and "#70C723" or "#BE2828"
	local rStr = SoraDWrapHtmlTagByStyle(string.formatnumberthousands(self.leftPromoteCount), self.leftPromoteCount)
	armorSystemCtrl = armyDesRead.getName(targetArmyID)
	armyDesRead.getName(targetArmyID).num = rStr
	self.fields.Text_left:setString(i18n("gilt_armor_text22", armyDesRead.getName(targetArmyID)) .. "\n" .. i18n("gilt_armor_text31"))
	armorSystemCtrl = i18n("gilt_armor_text31")
	i18n("gilt_armor_text31").army1 = fguiHelper.getColorString("#FFD43E", armyDesRead.getName(sourceArmyID))
	i18n("gilt_armor_text31").army2 = fguiHelper.getColorString("#FFD43E", armyDesRead.getName(targetArmyID))
	i18n("gilt_armor_text31").num = fguiHelper.getColorString("#70C723", self.giltCost[2])
	i18n("gilt_armor_text31").item = fguiHelper.getColorString("#70C723", publicRead.getName(self.giltCost[1]))
	self.fields.Text_describe:setString(i18n("gilt_armor_text24", (i18n("gilt_armor_text31"))))
	self:setNumTip(sourceArmyID)
	local maxVal = math.min(MAX_NUM, canPromoteCount, self.leftPromoteCount)
	armorSystemCtrl = self.leftPromoteCount
	self.leftPromoteCount.maxValue = maxVal
	self.leftPromoteCount.minValue = 1
	self.leftPromoteCount.curValue = maxVal
	self.fields.Com_slider:initData(self.leftPromoteCount)
	self.selectCount = math.max(1, maxVal)
	self:updateRes()
	self:updateTabRed()
	self.Text_tip:beginTime(serviceFunctions.getNextMonthFirstDayTime())
end
function soldiersPromoteTViewPanel:updateRes()
	local resID = self.giltCost[1]
	local resCount = self.giltCost[2]
	armyCtrl, armyCtrl = nil, nil
	;(nil).resID = self.sourceArmyID
	;(nil).rescount = self.selectCount
	;(nil).curcount = armyCtrl:getArmyCount(self.sourceArmyID, ARMY_OPTYPE.ALL_ARMY)
	;(nil).noDiscount = true
	armyCtrl, (nil)[1], (nil).isT13Army = nil, nil, true
	;(nil).resID = resID
	;(nil).rescount = self.selectCount * resCount
	;(nil).curcount = cityCtrl:getResCount(resID)
	;(nil).noDiscount = true
	self.resList, (nil)[2], (nil).showOwn = nil, nil, true
	self.fields.List_res:setNumItems(#self.resList)
	armyCtrl = self.fields.List_res.setNumItems
	self.fields.List_res.setNumItems.resID = resID
	self.fields.List_res.setNumItems.rescount = resCount
	self.fields.List_res.setNumItems.curcount = cityCtrl:getResCount(resID)
	local self.fields.List_res.setNumItems.noDiscount, showRes = true, self.fields.List_res.setNumItems
	armyCtrl = resID
	self.fields.com_res:initData(showRes, resID, self)
	self.fields.com_res:setResColor(cc.c3b(255, 251, 213))
end
function soldiersPromoteTViewPanel:onSliderChange(val)
	self.selectCount = math.max(1, val)
	self:updateRes()
end
function soldiersPromoteTViewPanel:updateTabRed()
	local leftNum = armorSystemCtrl:getMothyPromoteNum()
	local resID = self.giltCost[1]
	local resCount = self.giltCost[2]
	for tag = 1, #self.tabsetArray do
		local armorId = self.tabsetArray[tag].armorId
		local sourceArmyID = armorSystemCtrl:getArmyIdByArmorId(armorId, 13)
		local armyNum = armyCtrl:getNormalArmyCount(sourceArmyID)
		local _isreach = 0 < armyNum and resCount <= cityCtrl:getResCount(resID)
		self.fields.com_Tab:setBtnRedDot(tag, _isreach and 0 < leftNum and not self.tabsetArray[tag].isLock)
	end
end
function soldiersPromoteTViewPanel:setNumTip(sourceArmyID)
	self.fields.Com_numTip:getChild("Text_tip"):setString(i18n("gilt_armor_text34"))
	local allArmyNum = armyCtrl:getArmyCount(sourceArmyID, ARMY_OPTYPE.ALL_ARMY)
	local woundedArmyNum = armyCtrl:getArmyCount(sourceArmyID, ARMY_OPTYPE.WOUNDED_ARMY)
	local outArmyNum = armyCtrl:getArmyQueueCount(sourceArmyID)
	self.canProCount = math.max(0, allArmyNum - outArmyNum)
	_ENV = i18n("gilt_armor_text34")
	i18n("gilt_armor_text34").num = string.formatnumberthousands(self.canProCount)
	self.fields.Com_numTip:getChild("Text_num1"):setString(i18n("gilt_armor_text32", i18n("gilt_armor_text34")))
	_ENV = i18n("gilt_armor_text32", i18n("gilt_armor_text34"))
	i18n("gilt_armor_text32", i18n("gilt_armor_text34")).num = string.formatnumberthousands(woundedArmyNum)
	self.fields.Com_numTip:getChild("Text_num2"):setString(i18n("gilt_armor_text36", i18n("gilt_armor_text32", i18n("gilt_armor_text34"))))
	_ENV = i18n("gilt_armor_text36", i18n("gilt_armor_text32", i18n("gilt_armor_text34")))
	i18n("gilt_armor_text36", i18n("gilt_armor_text32", i18n("gilt_armor_text34"))).num = string.formatnumberthousands(outArmyNum)
	self.fields.Com_numTip:getChild("Text_num3"):setString(i18n("gilt_armor_text33", i18n("gilt_armor_text36", i18n("gilt_armor_text32", i18n("gilt_armor_text34")))))
end
function soldiersPromoteTViewPanel:hideTips()
	self.fields.Com_numTip:setVisible(false)
end
function soldiersPromoteTViewPanel:btnOwnDetailClick()
	SoraDPlaySound()
	local isVisible = self.fields.Com_numTip:isVisible()
	self.fields.Com_numTip:setVisible(not isVisible)
end
function soldiersPromoteTViewPanel:btnPromoteClick()
	SoraDPlaySound()
	if worldMapDefine.isInWar() then
		SoraDShowMsgTip(i18n("conquestwar_text_46"))
		return
	end
	local isLock = self.tabsetArray[self.tag].isLock
	local armyID = self.tabsetArray[self.tag].armyID
	if isLock then
		_ENV = i18n("conquestwar_text_46")
		i18n("conquestwar_text_46").army = armyDesRead.getName(armyID)
		SoraDShowMsgTip(i18n("gilt_armor_text26", i18n("conquestwar_text_46")))
		return
	end
	local selectArmyNum = self.fields.Com_slider:getSliderCurValue()
	if selectArmyNum > self.leftPromoteCount then
		SoraDShowMsgTip(i18n("gilt_armor_text28"))
		return
	end
	if selectArmyNum > self.canProCount then
		SoraDShowMsgTip(i18n("gilt_armor_text27"))
		return
	end
	local resID = self.giltCost[1]
	local resCount = self.giltCost[2]
	if selectArmyNum * resCount > cityCtrl:getResCount(resID) then
		_ENV = resID
		resID.item = publicRead.getName(resID)
		SoraDShowMsgTip(i18n("Glory_text_19", resID))
		return
	end
	armorSystemCtrl:reqArmorPromote(self.sourceArmyID, selectArmyNum, self.tabsetArray[self.tag].armyID)
end
function soldiersPromoteTViewPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("Payment_activity_optimization_text_09")
	;(nil).content = i18n("gilt_armor_rule01")
	uiManager:show("RuleView", nil)
end
return soldiersPromoteTViewPanel
