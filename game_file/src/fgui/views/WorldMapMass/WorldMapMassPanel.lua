local worldMapDefine = include("worldMapDefine")
local buffCtrl = SoraDGetCtrl("buffCtrl")
local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WorldMapMassPanel = class("WorldMapMassPanel", baseFguiPanel)
local maxMassArmyCount = 9999999
_UPVALUE5_ = baseFguiPanel
baseFguiPanel[1] = "common_text_143"
baseFguiPanel[2] = "common_text_144"
baseFguiPanel[3] = "common_text_145"
baseFguiPanel[4] = "common_text_146"
local baseFguiPanel[5], soldierTypeNameTable = "common_text_3772", baseFguiPanel
function WorldMapMassPanel:ctor(...)
	self.super.ctor(self, ...)
	print("WorldMapMassPanel:ctor", self.viewName)
end
function WorldMapMassPanel:getPackageList()
	_UPVALUE1_ = nil
	;(nil)[1] = "BuildWatchTower"
	return nil
end
function WorldMapMassPanel:onInit()
	print("=======WorldMapMassPanel:onInit")
	self.checkQueueSpeedBox, _ENV, self.checkBox, _ENV, self.massData, _ENV = print, print, print, print, print, print
	self.curCheckIndex = 1
	_UPVALUE16_, self.massTime_add = print, 0
	self.lvCfg, print[1] = print, 1
	self.lvCfg, print[2] = print, 2
	self.lvCfg, print[3] = print, 3
	self.lvCfg, print[4] = print, 4
	self.lvCfg, print[5] = print, 5
	self.lvCfg, print[6] = print, 6
	self.lvCfg, print[7] = print, 7
	self.lvCfg, print[8] = print, 8
	self.lvCfg, print[9] = print, 9
	self.lvCfg, print[10] = print, 10
	self.lvCfg, print[11] = print, 11
	self.lvCfg, print[12] = print, 11.5
	self.lvCfg, print[13] = print, 12
	self.lvCfg, print[14] = print, 12.5
	self.lvCfg, print[15] = print, 13
	self.lvCfg, print[16] = print, 14
	if not IsArClient then
		_UPVALUE15_ = IsArClient
		self.lvCfg, IsArClient[1] = IsArClient, 1
		self.lvCfg, IsArClient[2] = IsArClient, 2
		self.lvCfg, IsArClient[3] = IsArClient, 3
		self.lvCfg, IsArClient[4] = IsArClient, 4
		self.lvCfg, IsArClient[5] = IsArClient, 5
		self.lvCfg, IsArClient[6] = IsArClient, 6
		self.lvCfg, IsArClient[7] = IsArClient, 7
		self.lvCfg, IsArClient[8] = IsArClient, 8
		self.lvCfg, IsArClient[9] = IsArClient, 9
		self.lvCfg, IsArClient[10] = IsArClient, 10
		self.lvCfg, IsArClient[11] = IsArClient, 11
		self.lvCfg, IsArClient[12] = IsArClient, 11.5
		self.lvCfg, IsArClient[13] = IsArClient, 12
		self.lvCfg, IsArClient[14] = IsArClient, 12.5
		self.lvCfg, IsArClient[15] = IsArClient, 13
	end
	self.cfgLv = SoraDConfigGet("Game:worldMapMassView:armyForbidLv~integer") or 1
	self.armyForbidLv = self.lvCfg[self.cfgLv]
	self.ccs_bg = self.fields.Panel_bg
	self.ccs_bg:setString(i18n("common_text_467"))
	for i = 1, 5 do
		self.checkBox[i] = self.fields["Button_time" .. i]
		self.checkBox[i]:addClickListener(handler(self, self.checkBoxClick))
		self.checkBox[i]:setTag(i)
		if not SoraDFIsRA() then
			self.checkBox[i]:fixPos()
			self.checkBox[i]:fixChildrenPos()
		end
	end
	for i = 1, 2 do
		self.checkQueueSpeedBox[i] = self.fields["Button_queueSpeed" .. i]
		self.checkQueueSpeedBox[i]:addClickListener(handler(self, self.checkQueueSpeedBoxClick))
		self.checkQueueSpeedBox[i]:setTag(i)
		if not SoraDFIsRA() then
			self.checkQueueSpeedBox[i]:fixPos()
			self.checkQueueSpeedBox[i]:fixChildrenPos()
		end
	end
	self.checkQueueSpeedBox[1]:setString(i18n("common_text_4519"))
	self.checkQueueSpeedBox[2]:setString(i18n("common_text_4518"))
	self.fields.cbNum:addClickListener(handler(self, self.checkArmyCountBoxClick))
	self.fields.cbNum:setString(i18n("common_text_4886"))
	if worldMapDefine.isInTeamStatus() then
		self.fields.Text_2:setString(i18n("free_team_text_72"))
	else
		self.fields.Text_2:setString(i18n("common_text_468"))
	end
	self.fields.txtLieutenant:setString(i18n("lieutenant_text_01"))
	self.fields.txt_no1:setString(i18n("common_text_4899"))
	self.fields.txt_no2:setString(i18n("common_text_4900"))
	self.fields.list_hero:setItemRenderer(handler(self, self.onHeroRenderer))
	self.fields.list_lieutenant:setItemRenderer(handler(self, self.onLieutenantRenderer))
	self.fields.Button_yes:setString(i18n("common_text_204"))
	self.fields.Button_no:setString(i18n("common_text_185"))
	self.fields.Button_yes:addClickListener(handler(self, self.btnYesClick))
	self.fields.Button_no:addClickListener(handler(self, self.btnNoClick))
	self.fields.Node_title_time:setString(i18n("atlantiswar_text_0279"))
	self.fields.Node_title_lv:setString(i18n("atlantiswar_text_0280"))
	self.fields.Node_title_army:setString(i18n("common_text_4524"))
	self.fields.Node_title_queue:setString(i18n("common_text_4510"))
	self.fields.txt_queue:setString(i18n("common_text_4511"))
	self.fields.btn_whiteList:setString(i18n("common_text_4891"))
	self.fields.btn_whiteList:addClickListener(handler(self, self.btnWhiteListClick))
	self.fields.Node_title_armyNum:setString(i18n("common_text_4885"))
	self.fields.txtInputMin:addEventListener(fgui.UIEventType.Submit, handler(self, self.inputMinEvent))
	self.fields.txtInputMax:addEventListener(fgui.UIEventType.Submit, handler(self, self.inputMaxEvent))
	self:initDropDownBox()
	self.armyForbidData, _ENV = self.initDropDownBox, self.initDropDownBox
	if not SoraDConfigGet("Game:worldMapMassView:armyForbidData~table") then
		local _ENV, data = SoraDConfigGet("Game:worldMapMassView:armyForbidData~table"), SoraDConfigGet("Game:worldMapMassView:armyForbidData~table")
	end
	for _, v in pairs(gArmyClass) do
		if data[tostring(v)] then
			self.armyForbidData[v] = false
		else
			self.armyForbidData[v] = true
		end
		local Button_army = self.fields["Button_army" .. v]
		if Button_army then
			Button_army:setSelected(self.armyForbidData[v])
			Button_army:setTag(v)
			Button_army:addClickListener(handler(self, self.btnCheckClickCallBack))
			Button_army:setString(i18n(soldierTypeNameTable[v]))
			if not SoraDFIsRA() then
				Button_army:fixPos()
				Button_army:fixChildrenPos()
			end
		end
	end
	if not SoraDFIsRA() then
		self.fields.Button_yes:fixPos()
		self.fields.Button_no:fixPos()
		self.fields.inputCountBg:fixPos()
		self.fields.inputCountBg2:fixPos()
		self.fields.txtInputMin:fixPos()
		self.fields.txtInputMax:fixPos()
		self.fields.cbNum:fixPos()
		self.fields.cbNum:fixChildrenPos()
		self.fields.line:fixPos()
	end
end
function WorldMapMassPanel:onShow()
	print("=======WorldMapMassPanel:onShow")
	if self.curCheckIndex and self.checkBox[self.curCheckIndex] then
		self.checkBox[self.curCheckIndex]:setSelected(false)
	end
	self.curCheckIndex = 1
	local checkBox = self.checkBox[self.curCheckIndex]
	checkBox:setSelected(true)
	self.comboBoxIndex = 1
	self:initDropDownBox()
	self.armyForbidData, _ENV = self.initDropDownBox, self.initDropDownBox
	if not SoraDConfigGet("Game:worldMapMassView:armyForbidData~table") then
		local _ENV, data = SoraDConfigGet("Game:worldMapMassView:armyForbidData~table"), SoraDConfigGet("Game:worldMapMassView:armyForbidData~table")
	end
	for _, v in pairs(gArmyClass) do
		if data[tostring(v)] then
			self.armyForbidData[v] = false
		else
			self.armyForbidData[v] = true
		end
		local Button_army = self.fields["Button_army" .. v]
		if Button_army then
			Button_army:setSelected(self.armyForbidData[v])
		end
	end
	if not SoraDConfigGet("Game:worldMapMassView:dataExt~table") then
		local _ENV, dataExt = SoraDConfigGet("Game:worldMapMassView:dataExt~table"), SoraDConfigGet("Game:worldMapMassView:dataExt~table")
	end
	dump(dataExt, "dataExt")
	self.minArmyCount = math.min(tonumber(dataExt.minArmyCount or "1"), 1)
	self.maxArmyCount = math.min(tonumber(dataExt.maxArmyCount or tostring(maxMassArmyCount)), maxMassArmyCount)
	self.fields.txtInputMin:setString(string.formatnumberthousands(self.minArmyCount))
	self.fields.txtInputMax:setString(string.formatnumberthousands(self.maxArmyCount))
	self.isArmyCountLimitOpen = dataExt.isArmyCountLimitOpen or false
	self.isForbidSpeed = dataExt.isForbidSpeed or false
	dump(self.isForbidSpeed, "self.isForbidSpeed")
	self.checkQueueSpeedBox[1]:setSelected(self.isForbidSpeed)
	self.checkQueueSpeedBox[2]:setSelected(not self.isForbidSpeed)
	self:updateArmyCountLimitState()
	if self.param and self.param.massData then
		self:bindData(self.param.massData)
	elseif self.param and self.param.troopData then
		self:bindTroopData(self.param.troopData)
	end
	self.massTime_add = 0
	local worldMapWarDef = include("worldMapWarDef")
	buffCtrl, self.tableMassTime = worldMapWarDef.getTableMassTime(), worldMapWarDef.getTableMassTime()
	worldMapWarDef.getTableMassTime()[1] = gBuffSource.ATLANTIS_SKILL
	local worldMapWarDef.getTableMassTime()[2], config = gBuffSource.ROARING_FLAME_WAR, worldMapWarDef.getTableMassTime()
	for __, source in ipairs(config) do
		local skill_add = buffCtrl:getBuffEffect(gBuffEffect.MASS_TIME_REDUCE, source) or 0
		self.massTime_add = self.massTime_add + skill_add
	end
	self:refreshMassTime()
end
local colorGray = cc.c3b(123, 123, 123)
local colorNormal = cc.c3b(65, 35, 15)
function WorldMapMassPanel:updateArmyCountLimitState()
	local enable = self.isArmyCountLimitOpen
	_UPVALUE5_ = nil
	;(nil)[1] = "inputCountBg"
	;(nil)[2] = "txtInputMin"
	;(nil)[3] = "inputCountBg2"
	;(nil)[4] = "txtInputMax"
	local (nil)[5], powerObjects = "line", nil
	self.fields.cbNum:setSelected(not enable)
	self.fields.txtInputMin:setTouchable(enable)
	self.fields.txtInputMax:setTouchable(enable)
	for i, v in ipairs(powerObjects) do
		self.fields[v]:setColor(enable and display.COLOR_WHITE or colorGray)
	end
	if enable then
		self.fields.txtInputMin:setColor(colorNormal)
		self.fields.txtInputMax:setColor(colorNormal)
	end
end
function WorldMapMassPanel:bindData(massData)
	self.controllers.c1:setSelectedIndex(0)
	self.massMode = true
	self.massData = massData
	if self.massData and (gMapObjTypeDef.mapTypeWrathBeast == self.massData.instanceType or gMapObjTypeDef.mapTypeHeroBattleBoss1 == self.massData.instanceType or gMapObjTypeDef.mapTypeHeroBattleBoss2 == self.massData.instanceType or gMapObjTypeDef.fireDragon2 == self.massData.instanceType or gBossType.lostRuinsBoss == self.massData.classID or gBossType.snowWolfLostBoss == self.massData.classID or gBossType.windTowerBoss == self.massData.classID or gMapObjTypeDef.sweetMeatRobber == self.massData.instanceType or gMapObjTypeDef.nebulaDefenceWarBuilding == self.massData.instanceType or self:checkIsEndlessTrialBoss()) then
		_UPVALUE4_ = self:checkIsEndlessTrialBoss()
		self.tableMassTime, self:checkIsEndlessTrialBoss()[1] = self:checkIsEndlessTrialBoss(), 60
		self.tableMassTime, self:checkIsEndlessTrialBoss()[2] = self:checkIsEndlessTrialBoss(), 120
		self.tableMassTime, self:checkIsEndlessTrialBoss()[3] = self:checkIsEndlessTrialBoss(), 300
		self.tableMassTime, self:checkIsEndlessTrialBoss()[4] = self:checkIsEndlessTrialBoss(), 600
		self:refreshMassTime()
	end
end
function WorldMapMassPanel:bindTroopData(troopData)
	self.massMode = false
	self.controllers.c1:setSelectedIndex(1)
	self.troopData = troopData
	dump(self.troopData, "troopData")
	self.lieutenants, _ENV, self.heros, _ENV = dump, dump, dump, dump
	if self.troopData and self.troopData.from then
		if not self.troopData.from.heroInfo then
			_ENV = self.troopData.from.heroInfo
		end
		self.heros = self.troopData.from.heroInfo
		if not SoraDGetCtrl("heroCtrl"):getLieutenantByHeroList(self.heros) then
			_ENV = SoraDGetCtrl("heroCtrl"):getLieutenantByHeroList(self.heros)
		end
		self.lieutenants = SoraDGetCtrl("heroCtrl"):getLieutenantByHeroList(self.heros)
	end
	self.fields.txt_no1:setVisible(#self.heros == 0)
	self.fields.txt_no2:setVisible(#self.lieutenants == 0)
	self.fields.list_hero:setNumItems(#self.heros)
	self.fields.list_lieutenant:setNumItems(#self.lieutenants)
	self.isForbidSpeed = not not self.troopData.isForbidSpeed
	self.checkQueueSpeedBox[1]:setSelected(self.isForbidSpeed)
	self.checkQueueSpeedBox[2]:setSelected(not self.isForbidSpeed)
	if self.troopData.data then
		self.minArmyCount = self.troopData.data.massSlaveArmyMinNum or 1
		self.maxArmyCount = self.troopData.data.massSlaveArmyMaxNum or maxMassArmyCount
		self.fields.txtInputMin:setString(string.formatnumberthousands(self.minArmyCount))
		self.fields.txtInputMax:setString(string.formatnumberthousands(self.maxArmyCount))
		self.isArmyCountLimitOpen = self.troopData.data.massSlaveArmyMaxNum ~= nil
		self:updateArmyCountLimitState()
		if not self.troopData.data.massSlaveForbidArmyClass then
			local _ENV, massSlaveForbidArmyClass = self.troopData.data.massSlaveForbidArmyClass, self.troopData.data.massSlaveForbidArmyClass
		end
		for _, v in pairs(gArmyClass) do
			if massSlaveForbidArmyClass[tostring(v)] then
				self.armyForbidData[v] = false
			else
				self.armyForbidData[v] = true
			end
			local Button_army = self.fields["Button_army" .. v]
			if Button_army then
				Button_army:setSelected(self.armyForbidData[v])
			end
		end
		if self.troopData.data.massSlaveArmyMinLv then
			self.armyForbidLv = self.troopData.data.massSlaveArmyMinLv
			local defaultClick = 1
			for i, v in ipairs(self.childData) do
				if v.lv == self.armyForbidLv then
					defaultClick = i
					break
				end
			end
			self.fields.ComboBox_lv:setSelectedIndex(defaultClick - 1 or 0)
			self:onComboBoxChanged()
		end
	end
end
function WorldMapMassPanel:checkIsEndlessTrialBoss(...)
	if gMapObjTypeDef.mapObjTypeBoss == self.massData.instanceType and self.massData.classID >= gBossType.endlessTrialBoss1 and self.massData.classID <= gBossType.endlessTrialBoss8 then
		return true
	end
end
function WorldMapMassPanel:checkBoxClick(EventContext)
	SoraDPlaySound()
	local checkBox = self.checkBox[self.curCheckIndex]
	if checkBox == EventContext:getSender() then
		EventContext:getSender():setSelected(true)
		return
	end
	checkBox:setSelected(false)
	local button = EventContext:getSender()
	self.curCheckIndex = button:getTag()
end
function WorldMapMassPanel:checkQueueSpeedBoxClick(EventContext)
	SoraDPlaySound()
	local tag = EventContext:getSender():getTag()
	local curIndex = self.isForbidSpeed and 1 or 2
	local checkBox = self.checkQueueSpeedBox[curIndex]
	if checkBox == EventContext:getSender() then
		EventContext:getSender():setSelected(true)
		return
	end
	checkBox:setSelected(false)
	local button = EventContext:getSender()
	self.isForbidSpeed = button:getTag() == 1
end
function WorldMapMassPanel:checkArmyCountBoxClick(EventContext)
	SoraDPlaySound()
	self.isArmyCountLimitOpen = not self.fields.cbNum:isSelected()
	self:updateArmyCountLimitState()
end
function WorldMapMassPanel:btnYesClick()
	SoraDPlaySound()
	self:inputMinEvent()
	self:inputMaxEvent()
	if not self.massMode then
		local massSlaveArmyMinNum, massSlaveArmyMaxNum
		if self.isArmyCountLimitOpen then
			massSlaveArmyMinNum = self.minArmyCount
			massSlaveArmyMaxNum = self.maxArmyCount
			if massSlaveArmyMinNum > massSlaveArmyMaxNum then
				return
			end
		end
		kingdomMapCtrl:reqSetMass(self.troopData.id, self:getArmyForbidData(), self.armyForbidLv, massSlaveArmyMaxNum, massSlaveArmyMinNum, self.isForbidSpeed)
		self:close()
		return
	end
	if SoraDEnoughTroops() then
		local dispatchPanel = uiManager:show("WorldDispatchArmyView")
		local massSlaveForbidArmyClass = self:getArmyForbidData()
		local massSlaveArmyMinLv = self.armyForbidLv
		local massSlaveArmyMinNum, massSlaveArmyMaxNum
		if self.isArmyCountLimitOpen then
			massSlaveArmyMinNum = self.minArmyCount
			massSlaveArmyMaxNum = self.maxArmyCount
			if massSlaveArmyMinNum > massSlaveArmyMaxNum then
				return
			end
		end
		_ENV = self.isArmyCountLimitOpen
		_ENV, self.isArmyCountLimitOpen.toPoint = self.massData.uPos, self.massData.uPos
		self.massData.uPos.massTime = self.tableMassTime[self.curCheckIndex]
		self.massData.uPos.realDispatchType = self.massData.realDispatchType
		self.massData.uPos.mainInstanceType = self.massData.instanceType
		self.massData.uPos.massSlaveForbidArmyClass = massSlaveForbidArmyClass
		self.massData.uPos.massSlaveArmyMinLv = massSlaveArmyMinLv
		self.massData.uPos.massSlaveArmyMinNum = massSlaveArmyMinNum
		self.massData.uPos.massSlaveArmyMaxNum = massSlaveArmyMaxNum
		self.isArmyCountLimitOpen.otherData, self.massData.uPos.isForbidSpeed = self.massData.uPos, self.isForbidSpeed
		self.isArmyCountLimitOpen.dispatchType = self.massData.dispatchType
		local self.isArmyCountLimitOpen.instanceID, data = self.massData.instanceID, self.isArmyCountLimitOpen
		if self.massData.instanceType then
			data.instanceType = self.massData.instanceType
		else
			data.instanceType = gMapObjTypeDef.mapObjTypePlayer
		end
		dispatchPanel:initData(data, true)
	end
	self:close()
end
function WorldMapMassPanel:btnNoClick()
	SoraDPlaySound("uicontrol", 1)
	self:inputMinEvent()
	self:inputMaxEvent()
	self:close()
end
function WorldMapMassPanel:refreshMassTime(...)
	if self.massTime_add > 0 then
		for i = 1, #self.tableMassTime do
			local massTime = self.tableMassTime[i] - self.massTime_add
			local Button_time = self.fields["Button_time" .. i]
			Button_time:setString(SoraDConvertSecondToStringNoDayNoHour(massTime))
		end
		return
	end
	for i = 1, #self.tableMassTime do
		local Button_time = self.fields["Button_time" .. i]
		_ENV = SoraDConvertSecondToStringNoDayNoHour(massTime)
		SoraDConvertSecondToStringNoDayNoHour(massTime).count = math.ceil(self.tableMassTime[i] / 60)
		Button_time:setString(i18n("common_text_445", SoraDConvertSecondToStringNoDayNoHour(massTime)))
	end
end
function WorldMapMassPanel:checkUnselected()
	local num = 0
	for _, v in ipairs(self.armyForbidData) do
		if v then
			num = num + 1
		end
	end
	return 2 < num
end
function WorldMapMassPanel:setCheck(check, selected)
	local tag = check:getTag()
	if selected then
		self.armyForbidData[tag] = true
	else
		if not self:checkUnselected() then
			SoraDShowMsgTip(i18n("common_text_4525"))
			check:setSelected(true)
			return
		end
		self.armyForbidData[tag] = false
	end
end
function WorldMapMassPanel:btnCheckClickCallBack(EventContext)
	SoraDPlaySound()
	local button = EventContext:getSender()
	local isSelected = button:isSelected()
	self:setCheck(button, isSelected)
end
function WorldMapMassPanel:btnWhiteListClick(EventContext)
	SoraDPlaySound()
	local mapClassType = worldMapDefine.getKingdomMapClassByKingdomId()
	if mapClassType ~= gKingdomClassType.normal and mapClassType ~= gKingdomClassType.nebula and mapClassType ~= gKingdomClassType.legendLord then
		SoraDShowMsgTip(i18n("common_text_4884"))
		return
	end
	uiManager:show("WorldMassWhite")
end
function WorldMapMassPanel:getArmyForbidData()
	local _ENV, data
	for i, v in ipairs(self.armyForbidData) do
		if not v then
			data[tostring(i)] = true
		end
	end
	return next(data) and data
end
function WorldMapMassPanel:onHide(...)
	SoraDConfigSet("Game:worldMapMassView:armyForbidLv~integer", self.cfgLv)
	if not self:getArmyForbidData() then
		local _ENV, data = self:getArmyForbidData(), self:getArmyForbidData()
	end
	SoraDConfigSet("Game:worldMapMassView:armyForbidData~table", data)
	_ENV = SoraDConfigSet
	SoraDConfigSet.isArmyCountLimitOpen = self.isArmyCountLimitOpen
	SoraDConfigSet.isForbidSpeed = self.isForbidSpeed
	SoraDConfigSet.minArmyCount = self.minArmyCount
	local SoraDConfigSet.maxArmyCount, dataExt = self.maxArmyCount, SoraDConfigSet
	dump(dataExt, "WorldMapMassPanel:onHide")
	SoraDConfigSet("Game:worldMapMassView:dataExt~table", dataExt)
end
function WorldMapMassPanel:initDropDownBox(...)
	local armyDesRead = include("armyDesRead")
	local _ENV, childData = "armyDesRead", "armyDesRead"
	for i = #self.lvCfg, 1, -1 do
		local lv = self.lvCfg[i]
		local title = armyDesRead.getMassLimitArmyLvStr(lv)
		if lv == 1 then
			_ENV = nil
			;(nil).title = i18n("atlantiswar_text_0435")
			;(nil).lv = lv
			table.insert(childData, 1, nil)
		else
			_ENV = 1
			;(1).title = title
			;(1).lv = lv
			table.insert(childData, 1)
		end
	end
	local defaultClick = 1
	for i, v in ipairs(childData) do
		if v.lv == self.armyForbidLv then
			defaultClick = i
			break
		end
	end
	self.childData = childData
	local _ENV, items = ipairs(childData)
	for i, v in ipairs(self.childData) do
		table.insert(items, v.title)
	end
	_ENV = armyDesRead.getMassLimitArmyLvStr(lv)
	armyDesRead.getMassLimitArmyLvStr(lv).items = items
	armyDesRead.getMassLimitArmyLvStr(lv).selectedIndex = defaultClick
	armyDesRead.getMassLimitArmyLvStr(lv).changedCallback = handler(self, self.onComboBoxChanged)
	self:setComboBox(self.fields.ComboBox_lv, (armyDesRead.getMassLimitArmyLvStr(lv)))
	self:btnChooseRankClick(defaultClick)
	local dropdown = self.fields.ComboBox_lv:getDropdown()
	self.comboBoxList = dropdown:getChildByName("list")
	self.fields.ComboBox_lv:addClickListener(function()
		self.comboBoxList:setSelectedIndex(self.comboBoxIndex - 1)
	end)
end
function WorldMapMassPanel:onComboBoxChanged(...)
	local index = self.fields.ComboBox_lv:getSelectedIndex()
	self:btnChooseRankClick(index + 1)
end
function WorldMapMassPanel:btnChooseRankClick(index)
	print("==WorldMapMassPanel:btnChooseRankClick==", index, #self.childData)
	self.comboBoxIndex = index
	local title = self.childData[index].title
	_ENV = #self.childData
	_ENV, _ENV, (#self.childData).var = nil, nil, title
	;(nil).var, (nil).color = nil, "#D2AA64"
	local titleStr = i18n_html("atlantiswar_text_0281", #self.childData, nil)
	self.fields.ComboBox_lv:setTitle(titleStr)
	local lv = self.childData[index].lv
	if self.armyForbidLv == lv then
		return
	end
	self.armyForbidLv = lv
	self.cfgLv = table.indexof(self.lvCfg, self.armyForbidLv)
end
function WorldMapMassPanel:initKingdomBattleView(...)
	self.fields.Button_time5:setVisible(true)
	local bgSize = self.ccs_bg:getContentSize()
	local offsetY = self.fields.Button_time3:getPositionY() - self.fields.Button_time1:getPositionY()
	self.ccs_bg:setContentSize(cc.size(bgSize.width, bgSize.height + math.abs(offsetY)))
end
function WorldMapMassPanel:inputMinEvent(event, target)
	local oldInput = self.fields.txtInputMin:getText()
	print("oldInput , ", oldInput, maxMassArmyCount)
	if oldInput ~= "" then
		local subString = string.gsub(oldInput, "[^%d]+", "")
		local newInput = math.floor(tonumber(subString) or 0)
		print("inputMinEvent", newInput)
		if newInput <= 1 then
			newInput = 1
		elseif newInput > maxMassArmyCount then
			newInput = maxMassArmyCount
		elseif newInput > self.maxArmyCount then
			newInput = self.maxArmyCount
		end
		self.minArmyCount = newInput
		local strInput = string.formatnumberthousands(newInput)
		_UPVALUE2_ = newInput
		newInput[1] = strInput
		newInput[2] = newInput
		dump(newInput, "inputMinEvent")
		self.fields.txtInputMin:setString(strInput)
	else
		self.minArmyCount = 1
	end
end
function WorldMapMassPanel:inputMaxEvent(event, target)
	local oldInput = self.fields.txtInputMax:getText()
	print("oldInput , ", oldInput)
	if oldInput ~= "" then
		local subString = string.gsub(oldInput, "[^%d]+", "")
		local newInput = math.floor(tonumber(subString) or 0)
		_ENV = subString
		subString.newInput = newInput
		subString.minArmyCount = self.minArmyCount
		subString.maxArmyCount = self.maxArmyCount
		dump(subString, "inputMaxEvent")
		if newInput <= self.minArmyCount then
			newInput = self.minArmyCount
		elseif newInput > maxMassArmyCount then
			newInput = maxMassArmyCount
		end
		local strInput = string.formatnumberthousands(newInput)
		self.maxArmyCount = newInput
		self.fields.txtInputMax:setString(strInput)
	else
		self.maxArmyCount = maxMassArmyCount
	end
end
function WorldMapMassPanel:onHeroRenderer(index, obj)
	local data = self.heros[index + 1]
	obj:initData(data)
end
function WorldMapMassPanel:onLieutenantRenderer(index, obj)
	local data = self.lieutenants[index + 1]
	obj:initData(data)
end
return WorldMapMassPanel
