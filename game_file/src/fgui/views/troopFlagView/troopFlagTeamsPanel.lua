local armyDesRead = include("armyDesRead")
local buildLogic = include("buildLogic")
local armyltCtrl = include("armyltCtrl")
local armyCtrl = SoraDGetCtrl("armyCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local gSoldierSelectType = _G.gSoldierSelectType
local gHeroSelectBannerStyle = _G.gHeroSelectBannerStyle
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local troopFlagTeamsPanel = class("troopFlagTeamsPanel", baseFguiPanel)
function troopFlagTeamsPanel:ctor(...)
	self.super.ctor(self, ...)
	print("troopFlagTeamsPanel:ctor", self.viewName)
	self.isInNebulaAllStar = worldMapDefine.isInNebulaAllStar()
end
function troopFlagTeamsPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CommonDispatch"
	end
	return self._packageList
end
function troopFlagTeamsPanel:onInit()
	print("=======troopFlagTeamsPanel:onInit")
	self.tableArmy, _ENV = print, print
	self.allCount = 0
	self.curCount = 0
	self.curWeight = 0
	self.troopID = 0
	self.troopName = nil
	self.heroCount = 0
	self.armRuneCount = 0
	self.armyDivineBeastCount = 0
	self.heroWeightAdd = 0
	self.nowCount = 0
	self.fields.Com_title:initData("", handler(self, self.onClickClose))
	self.fields.Button_changeName:addClickListener(handler(self, self.btnChangeNameClick))
	self.fields.Text_warning:setString(i18n("common_text_1428"))
	self.fields.List_army:setItemRenderer(handler(self, self.onArmyRenderer))
	self.fields.Button_select:setString(i18n("common_text_4924"))
	self.fields.Button_select:addClickListener(handler(self, self.btnFilerClick))
	self.fields.Button_go:setString(i18n("common_text_195"))
	self.fields.Button_go:addClickListener(handler(self, self.btnGoClick))
	self.fields.Text_notice:setString(i18n("common_text_858"))
	self.fields.Button_convene:setString(i18n("common_text_3616"))
	self.fields.Button_convene:addClickListener(handler(self, self.btnConveneClickCallBack))
	self.fields.Text_notice:setVisible(false)
	self.fields.Button_convene:setVisible(false)
	self.fields.slider:setTitle("%")
	_ENV = "%"
	;("%").maxValue = 100
	;("%").minValue = 0
	;("%").curValue = 0
	self.fields.slider:initData("%")
	self.fields.slider:setMinValue(0)
	self.fields.slider:setSliderCallBack(handler(self, self.armyChange))
	self.fields.heroBanner:setMode(gHeroSelectBannerStyle.setteam)
	self.fields.heroBanner:setInnerSelectCallBack(handler(self, self.updateHero))
	self.fields.heroBanner:setRemoveCallBack(handler(self, self.updateHero))
	self.fields.heroBanner:setArtifactUpdateCallBack(handler(self, self.updateHero))
	self.fields.heroBanner:setDivineBeastUpdateCallBack(handler(self, self.updateHero))
	self.fields.slider:setInpuBoxFixPos(96, 96)
	self.fields.Button_select:fixPos()
	self.fields.Button_go:fixPos()
	self.fields.Com_weight:fixPos()
	self.fields.Com_weight:fixChildrenPos()
	self.fields.Com_count:fixPos()
	self.fields.Com_count:fixChildrenPos()
	if self.isInNebulaAllStar then
		self.fields.Com_weight:setIcon("frame_qmx_zaiyingshibing.png")
		self.fields.Text_notice:setString(i18n("NebulaAllstar_393"))
	end
end
function troopFlagTeamsPanel:onArmyRenderer(index, obj)
	obj:initData(self.tableArmy[index + 1], index + 1)
end
function troopFlagTeamsPanel:onShow()
	print("=======troopFlagTeamsPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.troopID = self.param.troopID or 1
	self:initTitleText(armyCtrl:getArmyCompileName(self.troopID) or self.troopID)
	self:req4result(self.troopID)
end
function troopFlagTeamsPanel:req4result(troopID)
	self.troopID = troopID
	SoraDShowLoading(self)
	armyCtrl:getArmyCompile(self.troopID)
end
function troopFlagTeamsPanel:armyChange(armyPer)
	local canUseCount = 0
	for i = 1, self.fields.List_army:getNumItems() do
		canUseCount = canUseCount + self.fields.List_army:getChildAt(i - 1):getMaxNum()
	end
	local nowCount = self.nowCount
	if self.isInNebulaAllStar then
		local totalArmy = nebulaAllStarCtrl:getTroopFlagTotalArmy()
		nowCount = math.min(totalArmy, nowCount)
	end
	armyPer = math.min(armyPer, nowCount * 100 / canUseCount)
	for i = 1, self.fields.List_army:getNumItems() do
		local single = self.fields.List_army:getChildAt(i - 1)
		local singleMax = single:getMaxNum()
		local canUseSingle = math.ceil(singleMax * armyPer / 100)
		single:setCurVal(canUseSingle)
	end
	nebulaAllStarCtrl = armyPer
	armyPer.notBack = true
	self.fields.slider:setSliderCurValue(math.ceil(armyPer), armyPer)
	return true
end
function troopFlagTeamsPanel:initTitleText(tStr)
	self.fields.Com_title:updateTitle(tStr)
	self.fields.Com_title:setSmallHelpIcon("btn_baoshi_mingzi.png", true)
end
function troopFlagTeamsPanel:initData(target, data)
	SoraDCloseLoading(self)
	local _ENV, armySetting = SoraDCloseLoading, SoraDCloseLoading
	local _ENV, heroList = self, self
	local _ENV, armsList
	local _ENV, divineBeastList
	if data and data.redata then
		armySetting = data.redata
		heroList = data.heroList
		armsList = data.armsList
		divineBeastList = data.divineBeastList
	end
	local heroIDList, lieutenantList = heroCtrl:getHeroAndLieutenant(heroList)
	self.fields.heroBanner:initHeros(heroIDList, armsList, nil, lieutenantList, divineBeastList)
	self:updateHeroWeightAndCount()
	self:updateHero()
	local armyIDList = armyCtrl:getArmyIDList()
	self.armyIDList, _ENV = armyCtrl, armyCtrl
	for _, v in ipairs(armyIDList) do
		local armyID = v % 1000
		local armyLv = armyID % 100
		local weight = armyDesRead.getFreeWeightAndSp(v)
		local soldierType = armyltCtrl.getSoldierType(v)
		_ENV = v
		v.id = v
		v.armyID = armyID
		v.level = armyLv
		v.weight = weight
		local v.soldierType, tableArmyID = soldierType, v
		table.insert(self.armyIDList, tableArmyID)
	end
	table.sort(self.armyIDList, function(army1, army2)
		if army1.level ~= army2.level then
			return army1.level > army2.level
		end
		return army1.armyID < army2.armyID
	end)
	self.nowCount = buildLogic.getExpArmyCount().total + self.heroCount + self.armRuneCount + self.armyDivineBeastCount
	for _, v in ipairs(self.armyIDList) do
		local id = v.id
		local haveCount = 0
		if self.isInNebulaAllStar then
			haveCount = nebulaAllStarCtrl:getTroopFlagTotalArmy()
		else
			haveCount = armyCtrl:getArmyCount(id, ARMY_OPTYPE.NORMAL_ARMY)
		end
		if 0 < haveCount then
			local recordCount = math.min(self.nowCount, armySetting[tostring(id)] or 0)
			local curCount = haveCount < recordCount and haveCount or recordCount
			_ENV = self.armyIDList
			self.armyIDList.armyid = id
			self.armyIDList.armycount = haveCount
			self.armyIDList.curCount = curCount
			self.armyIDList.weight = v.weight
			table.insert(self.tableArmy, self.armyIDList)
			self.allCount = self.allCount + curCount
		end
	end
	self:sortTableArmy()
	self:initScroll()
	self:updateLabelAndWeight()
	self.inBuff = buildLogic.getExpArmyCount().total > buildLogic.getExpArmyCount().unchangesize
	_ENV = lieutenantList
	lieutenantList.var1 = self.curCount
	lieutenantList.var2 = fguiHelper.getColorString(self.inBuff and "#00FF00" or "#F0E6D2", self.nowCount)
	self.fields.Com_count:setString(i18n("%{var1}/%{var2}", lieutenantList))
	self.fields.Text_notice:setVisible(0 >= #self.tableArmy)
	if not self.isInNebulaAllStar then
		self.fields.Button_convene:setVisible(0 >= #self.tableArmy)
	end
	self.fields.Button_go:setEnabled(false)
end
function troopFlagTeamsPanel:sortTableArmy(isNeedUpdate)
	self.sortType = SoraDConfigGet("Game:worldDispatchArmySelectViewPanel:saveSort~integer")
	for _, v in ipairs(self.armyIDList) do
		v.sortOrder = v.soldierType == self.sortType and 100 or 0
	end
	table.sort(self.armyIDList, function(army1, army2)
		if army1.isForbid ~= army2.isForbid then
			return army2.isForbid
		end
		if army1.sortOrder ~= army2.sortOrder then
			return army1.sortOrder > army2.sortOrder
		end
		if army1.level ~= army2.level then
			return army2.level < army1.level
		end
		return army1.armyID < army2.armyID
	end)
	local _ENV, newTableArmy = table.sort, table.sort
	for _, v in ipairs(self.armyIDList) do
		local id = v.id
		local armyData
		for _, v2 in ipairs(self.tableArmy) do
			if v2.armyid == id then
				armyData = v2
				break
			end
		end
		if armyData then
			table.insert(newTableArmy, armyData)
		end
	end
	dump(newTableArmy, "sortTableArmy1", 10)
	dump(self.tableArmy, "sortTableArmy2", 10)
	self.tableArmy = newTableArmy
	if isNeedUpdate then
		print("isNeedUpdate", isNeedUpdate)
		self.fields.List_army:setNumItems(#self.tableArmy)
	end
end
function troopFlagTeamsPanel:countTheMax(index)
	local maxLimit = self.nowCount
	if self.isInNebulaAllStar then
		local totalArmy = nebulaAllStarCtrl:getTroopFlagTotalArmy()
		maxLimit = math.min(totalArmy, maxLimit)
	end
	local otherTotal = 0
	for i = 1, self.fields.List_army:getNumItems() do
		if i ~= index then
			local single = self.fields.List_army:getChildAt(i - 1)
			otherTotal = otherTotal + single:getCurNum()
		end
	end
	return maxLimit - otherTotal
end
function troopFlagTeamsPanel:updateCount()
	self.nowCount = buildLogic.getExpArmyCount().total + self.heroCount + self.armRuneCount + self.armyDivineBeastCount
	if self.allCount > self.nowCount then
		local _scale = self.nowCount / self.allCount
		for _, v in ipairs(self.tableArmy) do
			v.curCount = math.floor(v.curCount * _scale)
		end
	end
	buildLogic = nil
	;(nil).var1 = self.curCount
	;(nil).var2 = fguiHelper.getColorString(self.inBuff and "#00FF00" or "#F0E6D2", self.nowCount)
	self.fields.Com_count:setString(i18n("%{var1}/%{var2}", nil))
	self:countTheMax()
end
function troopFlagTeamsPanel:initScroll()
	for i, v in ipairs(self.tableArmy) do
		v.sliderChangeHandle = handler(self, self.singleSliderChange)
	end
	self.fields.List_army:setNumItems(#self.tableArmy)
	self:bindData()
end
function troopFlagTeamsPanel:bindData()
	for i, v in ipairs(self.tableArmy) do
		self.fields.List_army:getChildAt(i - 1):setCurVal(v.curCount)
	end
end
function troopFlagTeamsPanel:singleSliderChange(target, data)
	self.curCount = 0
	for _, v in ipairs(self.tableArmy) do
		if v.armyid == data.armyid then
			v.curCount = data.armycount
		end
		self.curCount = self.curCount + v.curCount
	end
	local nowCount = self.nowCount
	if self.isInNebulaAllStar then
		local totalArmy = nebulaAllStarCtrl:getTroopFlagTotalArmy()
		nowCount = math.min(totalArmy, nowCount)
	end
	if nowCount < self.curCount then
		local count = self:countTheMax(data.index)
		if count < 0 then
			count = 0
		end
		if count ~= target:getCurNum() then
			self.fields.List_army:getChildAt(data.index - 1):setCurVal(count)
			return true
		end
	end
	dump(data, "singleSliderChange==data==")
	self:updateLabelAndWeight()
end
function troopFlagTeamsPanel:renameFunc(target, data)
	if data.redata and data.redata.tid and tonumber(data.redata.tid) == tonumber(self.troopID) then
		self:initTitleText(data.redata.tName)
		_ENV = nil
		;(nil).num = data.redata.tName
		SoraDShowMsgTip(i18n("common_text_1427", nil))
	end
end
function troopFlagTeamsPanel:selectArmyType(target, data)
	if data and data.selectType then
		self:selectArmyType_imp(data.selectType)
	elseif data and data.sort then
		self:sortTableArmy(true)
	end
end
function troopFlagTeamsPanel:setTeamBack(target, data)
	local err = data.err
	if err == gErrDef.Err_None then
		local compiletype = data.compiletype
		if compiletype then
			local tName = armyCtrl:getArmyCompileName(compiletype) or compiletype
			_ENV = nil
			;(nil).num = tName
			SoraDShowMsgTip(i18n("common_text_1427", nil))
		end
	else
		SoraDShowMsgTip(i18n("hero_text_02"))
		self:resetArmySelect()
		self:updateCount()
		self:updateLabelAndWeight()
		self:updateScroll()
	end
end
function troopFlagTeamsPanel:updateHero()
	self:updateHeroWeightAndCount()
	print("容量：" .. self.heroCount, self.heroWeightAdd, self.armRuneCount, self.armyDivineBeastCount)
	self:updateCount()
	self:updateLabelAndWeight()
end
function troopFlagTeamsPanel:btnConveneClickCallBack()
	SoraDPlaySound()
	SoraDCreatePanel("armyBuildingsView"):show()
end
function troopFlagTeamsPanel:btnGoClick()
	SoraDPlaySound()
	local armytb = self:transTroop(self.tableArmy)
	local armsList = self.fields.heroBanner:exportArms()
	local divineBeastList = self.fields.heroBanner:exportDivineBeast()
	armyCtrl:setArmyCompile(armytb, self.troopID, self.fields.heroBanner:exportNewHeros(), armsList, divineBeastList)
	self.fields.Button_go:setEnabled(false)
end
function troopFlagTeamsPanel:transTroop(armyTbl)
	local _ENV, reTbl
	for _, v in ipairs(armyTbl) do
		if v.curCount > 0 then
			reTbl[tostring(v.armyid)] = math.floor(v.curCount)
		end
	end
	return reTbl
end
function troopFlagTeamsPanel:setCurValMax(armyid)
	for _, v in ipairs(self.tableArmy) do
		if v.armyid == armyid then
			local armyData = v
			local curCount = armyData.armycount
			local curArmyCount = self.curCount
			if armyData.curCount > 0 then
				curArmyCount = self.curCount - armyData.curCount
				if curArmyCount < 0 then
					print("setCurValByArmyid curCount error", armyid, curCount)
					return 0
				end
			end
			local nowCount = self.nowCount
			if self.isInNebulaAllStar then
				local totalArmy = nebulaAllStarCtrl:getTroopFlagTotalArmy()
				nowCount = math.min(totalArmy, nowCount)
			end
			if nowCount < curArmyCount + curCount and 0 < curCount then
				curCount = nowCount - curArmyCount
				curCount = math.max(curCount, 0)
			end
			print("curCount,self.nowCount======", curCount, self.nowCount)
			curCount = math.min(curCount, self.nowCount)
			armyData.curCount = curCount
			self.curCount = curArmyCount + curCount
			return curCount
		end
	end
	return 0
end
function troopFlagTeamsPanel:resetArmySelect()
	for _, v in pairs(self.tableArmy) do
		v.curCount = 0
	end
	self.curCount = 0
end
function troopFlagTeamsPanel:updateScroll()
	for i = 1, self.fields.List_army:getNumItems() do
		self.fields.List_army:getChildAt(i - 1):updateView()
	end
end
function troopFlagTeamsPanel:selectArmyTypeByFun(sortFun)
	table.sort(self.armyIDList, sortFun)
	self:resetArmySelect()
	for _, v in ipairs(self.armyIDList) do
		self:setCurValMax(v.id)
	end
	self:updateLabelAndWeight()
	self:updateScroll()
end
function troopFlagTeamsPanel:selectArmyType_imp(selectType)
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
function troopFlagTeamsPanel:btnFilerClick()
	SoraDPlaySound()
	uiManager:show("worldDispatchArmySelectView")
end
function troopFlagTeamsPanel:updateLabelAndWeight()
	_ENV = nil
	;(nil).var1 = self.curCount
	;(nil).var2 = fguiHelper.getColorString(self.inBuff and "#00FF00" or "#F0E6D2", self.nowCount)
	self.fields.Com_count:setString(i18n("%{var1}/%{var2}", nil))
	if self.curCount > 0 and self.curCount <= self.nowCount then
		self.fields.Button_go:setEnabled(true)
	else
		self.fields.Button_go:setEnabled(false)
	end
	if self.isInNebulaAllStar then
		local totalArmy = nebulaAllStarCtrl:getTroopFlagTotalArmy()
		local remainCount = math.max(0, totalArmy - self.curCount)
		self.fields.Com_weight:setString(string.formatnumberthousands(remainCount))
		return
	end
	self.curWeight = 0
	local addWeight = 1 + kingdomMapCtrl:getArmyWeightPlus()
	for _, v in pairs(self.tableArmy) do
		self.curWeight = self.curWeight + v.weight * v.curCount * addWeight
	end
	self.fields.Com_weight:setString(string.formatnumberthousands(math.floor(self.curWeight)))
end
function troopFlagTeamsPanel:updateHeroWeightAndCount()
	local heroInfo = self.fields.heroBanner:exportHeros()
	local lieutenantInfo = self.fields.heroBanner:exportLieutenantHeros()
	local revertHeros = self.fields.heroBanner:exporLieutenant2MainHeroMap()
	local heroBuff = heroltCtrl:getSomeSkillValue(heroInfo, nil, lieutenantInfo, revertHeros)
	local heroWeightAdd = heroBuff[gBuffEffect.SOLDIER_LOAD_BOOST] or 0
	local heroCount = heroltCtrl:getHerosMarchCapacity(heroInfo)
	local hero_dressAdd = 0
	local ret, add = heroltCtrl:isHaveDressHero(heroInfo)
	if next(heroBuff) and ret then
		hero_dressAdd = add
		local heroltCtrl, lieRetTab = next(heroBuff), next(heroBuff)
		if commonCheck.HERO_COMBOS_SKILL then
			for _, v in ipairs(lieutenantInfo) do
				local hInfo = heroCtrl:getHeroInfoByID(v)
				local mainHeroID = revertHeros and revertHeros[tostring(v)]
				lieRetTab = heroCtrl:getLieutenantBuffList(lieRetTab, hInfo, nil, true, mainHeroID)
			end
		end
		if lieRetTab[gBuffEffect.MARCH_VALUE_LIMIT_BOOST] then
			heroCount = heroCount + lieRetTab[gBuffEffect.MARCH_VALUE_LIMIT_BOOST]
		end
		local _ret, _add = heroltCtrl:isHaveDressHero(lieutenantInfo)
		if _ret then
			heroCount = heroCount - _add
		end
	end
	self.heroCount = heroCount - hero_dressAdd
	self.heroWeightAdd = heroWeightAdd / 1000
	self.armRuneCount = 0
	local armsList = self.fields.heroBanner:exportArms()
	for k, v in ipairs(armsList) do
		local buffList = godArmsRuneCtrl:getRuneBuff(v)
		local runeAdd = buffList[gBuffEffect.MARCH_VALUE_LIMIT_BOOST] and buffList[gBuffEffect.MARCH_VALUE_LIMIT_BOOST].val or 0
		self.armRuneCount = self.armRuneCount + runeAdd
	end
	local divineBeastInfo = self.fields.heroBanner:exportDivineBeast()
	self.armyDivineBeastCount = divineBeastCtrl:getDispatchAddCount(divineBeastInfo, gBuffEffect.MARCH_VALUE_LIMIT_BOOST)
end
function troopFlagTeamsPanel:btnChangeNameClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).troopID = self.troopID
	;(nil).renameType = 7
	uiManager:show("lordEquipRename", nil)
end
return troopFlagTeamsPanel
