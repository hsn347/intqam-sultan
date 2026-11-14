local gametop = gModuleMgr.getObject("gametop")
local armyCtrl = SoraDGetCtrl("armyCtrl")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local buildLogic = include("buildLogic")
local armyDesRead = include("armyDesRead")
local armyltCtrl = include("armyltCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local arenaCtrl = SoraDGetCtrl("arenaCtrl")
local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ArenaTeamSetViewPanel = class("ArenaTeamSetViewPanel", baseFguiPanel)
_ENV = "ArenaTeamSetViewPanel"
;("ArenaTeamSetViewPanel").fight = 1
;("ArenaTeamSetViewPanel").save = 2
local ("ArenaTeamSetViewPanel").partyFight, BUTTON_TYPE = 3, "ArenaTeamSetViewPanel"
local gSoldierSelectType = _G.gSoldierSelectType
local gHeroSelectBannerStyle = _G.gHeroSelectBannerStyle
function ArenaTeamSetViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ArenaTeamSetViewPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
	include("worldMapDefine")
	include("worldMapFunction")
end
function ArenaTeamSetViewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CommonDispatch"
	end
	return self._packageList
end
function ArenaTeamSetViewPanel:onInit()
	print("=======ArenaTeamSetViewPanel:onInit")
	self.bufflist_c, _ENV, self.detail_c, _ENV, self.readyArmsList, _ENV, self.readyHeroList, _ENV, self.tableArmyData, _ENV, self.tableArmy, _ENV = print, print, print, print, print, print, print, print, print, print, print, print
	local ret, logtb = buildLogic.getArenaExpArmyCount()
	self.allCount = ret.total
	self.allowMaxCount = nil
	self.heroCount = 0
	self.armRuneCount = 0
	self.armyDivineBeastCount = 0
	self.heroSpeedAdd = 0
	self.heroWeightAdd = 0
	self.heroChange = true
	self.curCount = 0
	self.curWeight = 0
	self.isSelectFull = false
	self.fields.Com_title:initData("", handler(self, self.onClickClose))
	self.fields.List_troops:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_army:setItemRenderer(handler(self, self.onArmyRenderer))
	self.fields.Button_weightHelp:addClickListener(handler(self, self.btnPhysicalPlusClickCallBack))
	self.fields.Button_select:setString(i18n("common_text_4924"))
	self.fields.Button_select:addClickListener(handler(self, self.OnBtnFilerClick))
	self.fields.Button_quick:setString(i18n("common_text_852"))
	self.fields.Button_quick:addClickListener(handler(self, self.btnQuickClickCallBack))
	self.fields.Button_go:setString(i18n("common_text_195"))
	self.fields.Button_go:addClickListener(handler(self, self.btnGoClickCallBack))
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
	self.nodeHero = self.fields.heroBanner
	self.nodeHero:setMode(gHeroSelectBannerStyle.arena)
	self.nodeHero:setInnerSelectCallBack(handler(self, self.updateHero))
	self.nodeHero:setRemoveCallBack(handler(self, self.updateHero))
	self.nodeHero:setArtifactUpdateCallBack(handler(self, self.updateHero))
	self.nodeHero:setDivineBeastUpdateCallBack(handler(self, self.updateHero))
	self:createTeamBtns()
	self:updateHero()
	if not SoraDFIsRA() then
		self.fields.Com_weight:fixPos()
		self.fields.Com_weight:fixChildrenPos()
		self.fields.Button_weightHelp:fixPos()
		self.fields.Com_count:fixPos()
		self.fields.Com_count:fixChildrenPos()
	end
end
function ArenaTeamSetViewPanel:onShow()
	print("=======ArenaTeamSetViewPanel:onShow")
	local param = self.param
	if param.req4fight then
		self:req4fight(param.battleType, param.fightData, param.blockID, param.fatherPanel)
	end
	if param.req4result then
		self:req4result(param.battleType, param.guideHandle)
	end
	if param.req4partyFight then
		self:req4partyFight(param.partyID)
	end
end
local heroInfo2armsID = function(tbl)
	if not tbl then
		tbl, _ENV = nil, nil
	end
	local _ENV, ret
	for _, v in ipairs(tbl) do
		table.insert(ret, v.armsID)
	end
	return ret
end
local heroInfo2DivineBeastID = function(tbl)
	if not tbl then
		tbl, _ENV = nil, nil
	end
	local _ENV, ret
	for _, v in ipairs(tbl) do
		table.insert(ret, v.beastId)
	end
	return ret
end
function ArenaTeamSetViewPanel:req4fight(battleType, fightData, blockID, fatherPanel)
	self.btnType = BUTTON_TYPE.fight
	self.battleType = battleType
	self.battleFightData = fightData
	self.blockID = blockID
	self.fPanel = fatherPanel
	self.fields.Com_title:setTitle(i18n("common_text_287"))
	self.myInfo = arenaCtrl:getBattleInfo(self.battleType)
	BUTTON_TYPE = self.battleType
	self.battleType.byUID = true
	self.armySetting = SoraDConfigGet("Game:ArenaReadyView:dispatchArmy~table", self.battleType)
	BUTTON_TYPE = self.battleType
	self.battleType.byUID = true
	self.readyHeroList = SoraDConfigGet("Game:ArenaReadyView:dispatchHero~table", self.battleType)
	BUTTON_TYPE = self.battleType
	self.battleType.byUID = true
	self.readyArmsList = SoraDConfigGet("Game:ArenaReadyView:dispatchArms~table", self.battleType)
	BUTTON_TYPE = self.battleType
	self.battleType.byUID = true
	self.divineBeastList = SoraDConfigGet("Game:ArenaReadyView:dispatchDivineBeasts~table", self.battleType)
	self:initData()
end
function ArenaTeamSetViewPanel:req4result(battleType, guideHandle)
	self.btnType = BUTTON_TYPE.save
	self.battleType = battleType
	self.guideHandle = guideHandle
	self.fields.Com_title:setTitle(i18n("arena_columntext_01"))
	self.myInfo = arenaCtrl:getBattleInfo(self.battleType)
	dump(self.myInfo, "self.myInfo")
	self.armySetting = self.myInfo.armyInfo
	self.readyHeroList = self.myInfo.heroInfo
	self.readyArmsList = heroInfo2armsID(self.myInfo.armsInfo)
	self.divineBeastList = heroInfo2DivineBeastID(self.myInfo.divineBeastInfo)
	self:initData()
end
function ArenaTeamSetViewPanel:armyChange(armyPer)
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
	self.fields.slider:setSliderCurValue(math.ceil(armyPer), armyPer)
	self:updateView()
	return true
end
function ArenaTeamSetViewPanel:createTeamBtns()
	local totalNum = armyCtrl:getArmyCompileCount()
	self.fields.List_troops:setNumItems(totalNum)
	self.fields.List_troops:resizeToFit(totalNum)
end
function ArenaTeamSetViewPanel:onItemRenderer(index, obj)
	local compiletype = index + 1
	local tName = armyCtrl:getArmyCompileName(compiletype) or compiletype
	obj:setString(tName)
	obj:setTag(compiletype)
	obj:addClickListener(handler(self, self.btnTeamClickCallBack))
end
function ArenaTeamSetViewPanel:btnTeamClickCallBack(EventContext)
	SoraDPlaySound()
	armyCtrl:getArmyCompile(EventContext:getSender():getTag())
	SoraDShowLoading(self:displayObject())
end
function ArenaTeamSetViewPanel:adaptTeam(target, redata)
	SoraDCloseLoading(self:displayObject())
	if redata and redata.redata then
		local compile = redata.redata
		local heroList = redata.heroList
		local armsList = redata.armsList
		local divineBeastList = redata.divineBeastList
		local notEnough = false
		local noneCompile = true
		local heroIDList, lieutenantList = heroCtrl:getHeroAndLieutenant(heroList)
		self.nodeHero:filterHerosByMode(heroIDList, armsList, lieutenantList, divineBeastList)
		if next(compile) ~= nil then
			for _, v in pairs(compile) do
				if 0 < v then
					noneCompile = false
					break
				end
			end
		end
		if noneCompile then
			SoraDShowMsgBox(i18n("common_text_1449"), i18n("common_text_204"))
			return
		end
		self:resetArmySelect()
		local recordCount = 0
		local scaleCount = 1
		local needAdd = self.allCount
		for _, v in pairs(compile) do
			recordCount = recordCount + v
		end
		if recordCount > self.allCount then
			scaleCount = self.allCount / recordCount
		end
		for k, v in pairs(compile) do
			if 0 < v then
				local notFind = true
				local armyid = tonumber(k)
				local data = self.tableArmyData[armyid]
				if data then
					if v > data.armycount then
						notEnough = true
					end
					self:setCurValByArmyid(armyid, math.floor(v * scaleCount))
					needAdd = needAdd - math.floor(v * scaleCount)
					notFind = false
				end
				if notFind then
					notEnough = true
				end
			end
		end
		if scaleCount < 1 and 0 < needAdd then
			for k, v in pairs(compile) do
				if 0 < v then
					local armyid = tonumber(k)
					local data = self.tableArmyData[armyid]
					if data then
						local armycount = self:getArmyCount(armyid)
						self:setCurValByArmyid(armyid, armycount)
						needAdd = needAdd - (armycount - math.floor(v * scaleCount))
					end
				end
				if needAdd <= 0 then
					break
				end
			end
		end
		if 1 > math.ceil(scaleCount) then
			SoraDShowMsgBox(i18n("common_text_2025"), i18n("common_text_204"))
		elseif notEnough then
			SoraDShowMsgBox(i18n("common_text_1447"), i18n("common_text_204"))
		end
		self:updateView()
	end
end
function ArenaTeamSetViewPanel:initData(armyViewData)
	local armyIDList = armyCtrl:getArmyIDList()
	self.armyIDList, armyCtrl = armyCtrl, armyCtrl
	for _, v in ipairs(armyIDList) do
		local armyID = v % 1000
		local armyLv = armyID % 100
		local weight = armyDesRead.getFreeWeightAndSp(v)
		local soldierType = armyltCtrl.getSoldierType(v)
		armyCtrl = v
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
	self.curCount = 0
	for _, v in ipairs(self.armyIDList) do
		local id = v.id
		local haveCount = armyCtrl:getArmyCount(id, ARMY_OPTYPE.ALL_ARMY)
		if 0 < haveCount then
			table.insert(self.tableArmy, id)
			armyCtrl = self.tableArmy
			self.tableArmy.armyid = id
			self.tableArmy.armycount = haveCount
			self.tableArmy.curCount = 0
			self.tableArmyData[id], self.tableArmy.weight = self.tableArmy, v.weight
		end
	end
	self:sortTableArmy()
	self.fields.Text_notice:setVisible(0 >= #self.tableArmy)
	self.fields.Button_convene:setVisible(0 >= #self.tableArmy)
	self:updateCountLabel()
	self:initScroll()
	if BUTTON_TYPE.fight == self.btnType then
		self.fields.Button_go:setTitleText(i18n("common_text_008"))
	elseif BUTTON_TYPE.save == self.btnType then
		self.fields.Button_go:setEnabled(false)
	end
	self:readyChoose()
end
function ArenaTeamSetViewPanel:sortTableArmy(isNeedUpdate)
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
		local isInTableArmy = false
		for _, v2 in ipairs(self.tableArmy) do
			if v2 == id then
				isInTableArmy = true
				break
			end
		end
		if isInTableArmy then
			table.insert(newTableArmy, id)
		end
	end
	self.tableArmy = newTableArmy
	if isNeedUpdate then
		print("isNeedUpdate", isNeedUpdate)
		self.fields.List_army:setNumItems(#self.tableArmy)
	end
end
function ArenaTeamSetViewPanel:readyChoose(...)
	local heroIDList, lieutenantList = heroCtrl:getHeroAndLieutenant(self.readyHeroList)
	dump(self.readyHeroList, "self.readyHeroList")
	dump(lieutenantList, "self.readyHeroList")
	self.nodeHero:filterHerosByMode(heroIDList, self.readyArmsList, lieutenantList, self.divineBeastList)
	self:updateHero()
	local heroCtrl, armySetting = self.updateHero, self.updateHero
	if self.armySetting and next(self.armySetting) then
		for _, v in ipairs(self.armySetting) do
			armySetting[v.id] = v.num
		end
	end
	dump(armySetting, "armySetting")
	if armySetting and next(armySetting) then
		for armyid in pairs(self.tableArmyData) do
			if armySetting[armyid] then
				print("armySetting=", armyid)
				local singleMax = self:getArmyCount(armyid)
				self:setCurValByArmyid(armyid, math.min(singleMax, armySetting[armyid]))
			else
				self:setCurValByArmyid(armyid, 0)
			end
		end
	end
	self:updateView()
end
function ArenaTeamSetViewPanel:updateMaxCount(maxCount)
	self.allowMaxCount = maxCount
	if self.isSelectFull and self.curCount > self.allCount then
		self:quickChoose(self.isSelectFull)
	end
end
function ArenaTeamSetViewPanel:initScroll()
	for __, v in pairs(self.tableArmyData) do
		v.sliderChangeHandle = handler(self, self.singleSliderChange)
	end
	self.fields.List_army:setNumItems(#self.tableArmy)
end
function ArenaTeamSetViewPanel:onArmyRenderer(index, obj)
	local armyid = self.tableArmy[index + 1]
	obj:initData(self.tableArmyData[armyid], index + 1)
end
function ArenaTeamSetViewPanel:singleSliderChange(target, data)
	local curCount = self:setCurValByArmyid(data.armyid, data.armycount)
	if curCount < data.armycount then
		target:setCurVal(curCount)
		return true
	end
	self:setBtnBright()
	self:updateLabelAndWeight()
	self:updateCountLabel()
end
function ArenaTeamSetViewPanel:updateView()
	self:updateScroll()
	self:setBtnBright()
	self:updateLabelAndWeight()
	self:updateCountLabel()
end
function ArenaTeamSetViewPanel:setBtnBright(...)
	if self.curCount > 0 then
		self.fields.Button_go:setEnabled(true)
	else
		self.fields.Button_go:setEnabled(false)
	end
end
function ArenaTeamSetViewPanel:updateScroll()
	for i = 1, self.fields.List_army:getNumItems() do
		self.fields.List_army:getChildAt(i - 1):updateView()
	end
end
function ArenaTeamSetViewPanel:updateLabelAndWeight()
	_ENV = nil
	;(nil).var1 = self.curCount
	;(nil).var2 = fguiHelper.getColorString(self.inBuff and "#00FF00" or "#F0E6D2", self.allCount)
	local countStr = i18n("%{var1}/%{var2}", nil)
	self.fields.Com_count:setString(countStr)
	self.curWeight = 0
	local addWeight = 1 + kingdomMapCtrl:getArmyWeightPlus() + self.heroWeightAdd
	for _, v in pairs(self.tableArmyData) do
		self.curWeight = self.curWeight + v.weight * v.curCount * addWeight
	end
	self.fields.Com_weight:setString(string.formatnumberthousands(math.floor(self.curWeight)))
end
function ArenaTeamSetViewPanel:btnPhysicalPlusClickCallBack()
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("common_text_987"))
end
function ArenaTeamSetViewPanel:btnConveneClickCallBack()
	SoraDPlaySound()
	SoraDCreatePanel("armyBuildingsView"):show()
end
function ArenaTeamSetViewPanel:updateBtnText()
	if self.isSelectFull then
		self.fields.Button_quick:setTitleText(i18n("common_btn_18"))
	else
		self.fields.Button_quick:setTitleText(i18n("common_text_852"))
	end
end
function ArenaTeamSetViewPanel:quickChoose(isFull)
	self:quickChoose_hero(isFull)
	self:quickChoose_army(isFull)
	self:updateBtnText()
end
function ArenaTeamSetViewPanel:quickChoose_hero(isFull)
	print("isFull", isFull)
	if isFull then
		self.nodeHero:autoFillHeros()
	else
		self.nodeHero:clearHeros()
	end
	self:updateHero()
end
function ArenaTeamSetViewPanel:quickChoose_army(isFull)
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
function ArenaTeamSetViewPanel:btnQuickClickCallBack()
	SoraDPlaySound()
	self:quickChoose(not self.isSelectFull)
end
function ArenaTeamSetViewPanel:btnGoClickCallBack()
	SoraDPlaySound()
	if self.curCount > self.allCount and self.heroChange then
		SoraDShowMsgTip(i18n("hero_text_02"))
		self:resetArmySelect()
		self:updateView()
		self.isSelectFull = false
		return
	end
	local _ENV, dispatchArmyList = self.updateView, self.updateView
	for _, v in pairs(self.tableArmyData) do
		if v.curCount > 0 then
			_ENV = i18n("hero_text_02")
			i18n("hero_text_02").id = v.armyid
			i18n("hero_text_02").num = math.floor(v.curCount)
			table.insert(dispatchArmyList, i18n("hero_text_02"))
		end
	end
	local armsInfo = self.nodeHero:exportArms()
	local heroMergeList = self.nodeHero:exportNewHeros()
	local divineBeastInfo = self.nodeHero:exportDivineBeast()
	if BUTTON_TYPE.save == self.btnType then
		SoraDShowLoading(self:displayObject())
		arenaCtrl:req2setMyArmy(self.battleType, dispatchArmyList, heroMergeList, armsInfo, divineBeastInfo, self.detail_c, self.bufflist_c)
	elseif BUTTON_TYPE.fight == self.btnType then
		if self.fPanel and not tolua.isnull(self.fPanel) then
			SoraDShowLoading(self.fPanel:displayObject())
		end
		_ENV = self.fPanel:displayObject()
		self.fPanel:displayObject().byUID = true
		SoraDConfigSet("Game:ArenaReadyView:dispatchArmy~table", dispatchArmyList, self.fPanel:displayObject())
		_ENV = self.fPanel:displayObject()
		self.fPanel:displayObject().byUID = true
		SoraDConfigSet("Game:ArenaReadyView:dispatchHero~table", heroMergeList, self.fPanel:displayObject())
		_ENV = self.fPanel:displayObject()
		self.fPanel:displayObject().byUID = true
		SoraDConfigSet("Game:ArenaReadyView:dispatchArms~table", armsInfo, self.fPanel:displayObject())
		_ENV = self.fPanel:displayObject()
		self.fPanel:displayObject().byUID = true
		SoraDConfigSet("Game:ArenaReadyView:dispatchDivineBeasts~table", divineBeastInfo, self.fPanel:displayObject())
		_ENV = self.fPanel:displayObject()
		self.fPanel:displayObject().myInfo = self.myInfo
		self.fPanel:displayObject().enemyInfo = self.battleFightData
		self.fPanel:displayObject().battleType = self.battleType
		uiManager:show("ArenaResultView", self.fPanel:displayObject())
		arenaCtrl:reqChallengePlayer(self.battleFightData.uid, self.battleFightData.rank, self.battleFightData.nickName, self.battleType, self.blockID, dispatchArmyList, heroMergeList, armsInfo, divineBeastInfo)
		self:removeFromParent()
	elseif BUTTON_TYPE.partyFight == self.btnType then
		local partyCtrl = SoraDGetCtrl("partyCtrl")
		partyCtrl:sendAttackBandit(false, self.partyID, dispatchArmyList, heroMergeList, armsInfo, divineBeastInfo)
		self:removeFromParent()
	end
end
function ArenaTeamSetViewPanel:resetArmySelect()
	for _, v in pairs(self.tableArmyData) do
		v.curCount = 0
	end
	self.curCount = 0
end
function ArenaTeamSetViewPanel:getArmyCurCount(armyid)
	local armyData = self.tableArmyData[armyid]
	if armyData then
		return armyData.curCount
	end
	return 0
end
function ArenaTeamSetViewPanel:getArmyCount(armyid)
	local armyData = self.tableArmyData[armyid]
	if armyData then
		return armyData.armycount
	end
	return 0
end
function ArenaTeamSetViewPanel:setCurValMax(armyid)
	local armyMax = self:getArmyCount(armyid)
	self:setCurValByArmyid(armyid, armyMax)
end
function ArenaTeamSetViewPanel:setCurValByArmyid(armyid, curCount)
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
function ArenaTeamSetViewPanel:setCurValByIndex(index, curCount)
	local armyid = self.tableArmy[index]
	if checknumber(armyid) > 0 then
		return self:setCurValByArmyid(armyid, curCount)
	else
		print("setCurValByIndex error", index, curCount)
	end
	return 0
end
function ArenaTeamSetViewPanel:setSuccess(target, redata)
	self.fields.Button_go:setEnabled(false)
	SoraDShowMsgTip(i18n("arena_text_34"))
	SoraDCloseLoading(self:displayObject())
	self:removeFromParent()
end
function ArenaTeamSetViewPanel:onHide()
	if self.guideHandle then
		self.guideHandle()
	end
end
function ArenaTeamSetViewPanel:selectArmyTypeByFun(sortFun)
	table.sort(self.armyIDList, sortFun)
	self:resetArmySelect()
	for _, v in ipairs(self.armyIDList) do
		self:setCurValMax(v.id)
	end
	self:updateView()
end
function ArenaTeamSetViewPanel:selectArmyType_imp(selectType)
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
function ArenaTeamSetViewPanel:OnBtnFilerClick()
	SoraDPlaySound()
	uiManager:show("worldDispatchArmySelectView")
end
function ArenaTeamSetViewPanel:selectArmyType(target, redata)
	dump(redata, "ArenaTeamSetViewPanel:selectArmyType", 10)
	if redata and redata.selectType then
		self:selectArmyType_imp(redata.selectType)
	elseif redata and redata.sort then
		self:sortTableArmy(true)
	end
end
function ArenaTeamSetViewPanel:updateHero()
	local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
	local heroInfo = self.nodeHero:exportHeros()
	local lieutenantInfo = self.nodeHero:exportLieutenantHeros()
	local revertHeros = self.nodeHero:exporLieutenant2MainHeroMap()
	local heroBuff = heroltCtrl:getSomeSkillValue(heroInfo, nil, lieutenantInfo, revertHeros)
	local heroSpeedAdd = heroBuff[gBuffEffect.MARCH_SPEED_BOOST] or 0
	local heroWeightAdd = heroBuff[gBuffEffect.SOLDIER_LOAD_BOOST] or 0
	local heroCount = heroltCtrl:getHerosMarchCapacity(heroInfo)
	local hero_dressAdd = 0
	local ret, add = heroltCtrl:isHaveDressHero(heroInfo)
	if next(heroBuff) and ret then
		hero_dressAdd = add
		local _ENV, lieRetTab = next(heroBuff), next(heroBuff)
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
	self.heroSpeedAdd = heroSpeedAdd
	self.heroWeightAdd = heroWeightAdd / 1000
	self.armRuneCount = 0
	local armsList = self.nodeHero:exportArms()
	for k, v in ipairs(armsList) do
		local buffList = godArmsRuneCtrl:getRuneBuff(v)
		local runeAdd = buffList[gBuffEffect.MARCH_VALUE_LIMIT_BOOST] and buffList[gBuffEffect.MARCH_VALUE_LIMIT_BOOST].val or 0
		self.armRuneCount = self.armRuneCount + runeAdd
	end
	local divineBeastInfo = self.nodeHero:exportDivineBeast()
	self.armyDivineBeastCount = divineBeastCtrl:getDispatchAddCount(divineBeastInfo, gBuffEffect.MARCH_VALUE_LIMIT_BOOST)
	print("heroCount,hero_dressAdd======", heroCount, hero_dressAdd)
	print("容量：" .. self.heroCount, self.armRuneCount, self.heroWeightAdd, self.heroSpeedAdd, self.heroMarchMonsterAdd)
	self.detail_c.heroAddNum = self.heroCount
	self.detail_c.godarmsadd = self.armRuneCount
	self.detail_c.armyDivineBeastAddCount = self.armyDivineBeastCount
	if 0 < self.heroCount + self.armRuneCount + self.armyDivineBeastCount then
		self.heroChange = true
	end
	self:updateLabelAndWeight()
	self:updateCountLabel()
	self:updateScroll()
	self:setBtnBright()
end
function ArenaTeamSetViewPanel:updateCountLabel()
	local ret, logtb, buffList = buildLogic.getArenaExpArmyCount()
	if self.allowMaxCount then
		self.allCount = math.min(ret.total + self.heroCount + self.armRuneCount + self.armyDivineBeastCount, self.allowMaxCount)
	else
		self.allCount = ret.total + self.heroCount + self.armRuneCount + self.armyDivineBeastCount
	end
	for k, v in pairs(logtb) do
		self.detail_c[k] = v
	end
	self.bufflist_c = buffList
	self.inBuff = ret.total > ret.unchangesize
	buildLogic = pairs(logtb)
	pairs(logtb).var1 = self.curCount
	pairs(logtb).var2 = fguiHelper.getColorString(self.inBuff and "#00FF00" or "#F0E6D2", self.allCount)
	local countStr = i18n("%{var1}/%{var2}", pairs(logtb))
	self.fields.Com_count:setString(countStr)
end
function ArenaTeamSetViewPanel:req4partyFight(partyID)
	local ret = buildLogic.getExpArmyCount()
	self.allCount = ret.total
	self.btnType = BUTTON_TYPE.partyFight
	self.partyID = partyID
	self.battleType = gArenaBattleType.ARENA_LOCAL
	self.fields.Com_title:setTitle(i18n("common_text_481"))
	self.myInfo = arenaCtrl:getBattleInfo(self.battleType)
	self.armySetting = self.myInfo.armyInfo
	self.readyHeroList = self.myInfo.heroInfo
	self.readyArmsList = heroInfo2armsID(self.myInfo.armsInfo)
	self.divineBeastList = heroInfo2DivineBeastID(self.myInfo.divineBeastInfo)
	self:initData()
end
return ArenaTeamSetViewPanel
