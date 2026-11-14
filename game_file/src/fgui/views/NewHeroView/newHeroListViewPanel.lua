local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroBiographyCtrl = gametop.playertop_:getModule("heroBiographyCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local constantRead = include("constantRead")
local heroNewTrialCtrl = SoraDGetCtrl("heroNewTrialCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local newHeroListViewPanel = class("newHeroListViewPanel", baseFguiPanel)
function newHeroListViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("newHeroListViewPanel:ctor", self.viewName)
end
function newHeroListViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function newHeroListViewPanel:onInit()
	print("=======newHeroListViewPanel:onInit")
	self.isHideCurrentSceneView = true
	self.curTag = 1
	self.curClass = gHeroListViewAllClass
	self.curSortType = gHeroSortType.quality
	self.jumpToBestHero = self.param and self.param.jumpToBestHero or false
	self.fields.Com_Title:initData(i18n("hero_title_07"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.List_btns:setItemRenderer(handler(self, self.onBtnsRenderer))
	self.fields.List_btns:addClickListener(handler(self, self.onClickBtnList))
	self.fields.Button_story:setString(i18n("Biography_text_11"))
	self.fields.Button_story:addClickListener(handler(self, self.onClickBtnStory))
	self.fields.Button_temple:setString(i18n("hero_palace_text_01"))
	self.fields.Button_temple:addClickListener(handler(self, self.onClickBtnTemple))
	local isUnlockTemple = GAME_HERO_TEMPLE_MODE and SoraDGetBuildStarLv() >= constantRead.getConstValue("HERO_PALACE_UNLOCK_STAR_LEVEL")
	self.fields.Button_temple:setVisible(isUnlockTemple)
	self.fields.Button_trial:setString(i18n("hero_experience_04"))
	self.fields.Button_trial:addClickListener(handler(self, self.onClickBtnTrial))
	self.isUnlockTrial = heroNewTrialCtrl:isOpenHeroTrial()
	self.fields.Button_trial:setVisible(self.isUnlockTrial)
	self.fields.Button_story:setPositionX(SoraDFPosX(self:getWidth() - 80, self:getWidth()))
	if isUnlockTemple then
		self.fields.Button_temple:setPositionX(SoraDFPosX(self:getWidth() - 200, self:getWidth()))
		if self.isUnlockTrial then
			self.fields.Button_trial:setPositionX(SoraDFPosX(self:getWidth() - 320, self:getWidth()))
		end
	elseif self.isUnlockTrial then
		self.fields.Button_trial:setPositionX(SoraDFPosX(self:getWidth() - 200, self:getWidth()))
	end
	heroNewTrialCtrl = self.fields.Button_trial.setPositionX
	heroltCtrl, self.fields.Button_trial.setPositionX[1] = i18n("hero_text_112"), i18n("hero_text_112")
	heroltCtrl, self.fields.Button_trial.setPositionX[2] = i18n("hero_text_112"), i18n("hero_text_113")
	heroltCtrl, self.fields.Button_trial.setPositionX[3] = i18n("hero_text_112"), i18n("hero_text_114")
	heroltCtrl, self.fields.Button_trial.setPositionX[4] = i18n("hero_text_112"), i18n("hero_text_114")
	heroltCtrl, self.fields.Button_trial.setPositionX[5] = i18n("hero_text_112"), i18n("hero_text_114")
	heroltCtrl, self.fields.Button_trial.setPositionX[6] = i18n("hero_text_112"), i18n("hero_text_114")
	heroltCtrl, self.fields.Button_trial.setPositionX[7] = i18n("hero_text_112"), i18n("hero_text_114")
	local heroltCtrl, self.fields.Button_trial.setPositionX[8], items = i18n("hero_text_112"), i18n("hero_text_114")
	i18n("hero_text_112")[1] = gHeroSortType.quality
	i18n("hero_text_112")[2] = gHeroSortType.level
	local i18n("hero_text_112")[3], values = gHeroSortType.rarity, i18n("hero_text_112")
	_ENV = i18n("hero_text_114")
	i18n("hero_text_114").items = items
	i18n("hero_text_114").values = values
	i18n("hero_text_114").changedCallback = handler(self, self.onComboBoxClick)
	self:setComboBox(self.fields.ComboBox_sort, i18n("hero_text_114"))
	local dropdown = self.fields.ComboBox_sort:getDropdown()
	self.comboBoxList = dropdown:getChildByName("list")
	self.fields.ComboBox_sort:addClickListener(function()
		SoraDPlaySound()
		self.comboBoxList:setSelectedIndex(self.curSortType - 1)
	end)
	self.fields.ComboBox_sort:fixChildrenPos()
	self.fields.List_hero_have:setVirtual()
	self.fields.List_hero_have:setItemRenderer(handler(self, self.onHaveRenderer))
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	if guideCtrl:isGuideNotCompleted(gGuideModule.HERO_UPGRADE) then
		local isAllWhite, heroName = heroltCtrl:getUpgradeGuideInfo()
		if isAllWhite and heroName ~= "" then
			guideCtrl:updateGuideModule(gGuideModule.HERO_UPGRADE)
		end
	end
	self.fields.ComboBox_sort:fixPos()
	self.fields.Text_friendNum:fixPos()
end
function newHeroListViewPanel:updateBtnTrialRedStatus()
	if not self.isUnlockTrial then
		return
	end
	local ret, num = heroNewTrialCtrl:getTrialAfkStatusAndNum()
	self.fields.Button_trial:setReddot(ret, num)
end
function newHeroListViewPanel:onHaveRenderer(index, obj)
	obj:setName("item" .. index)
	if index <= #self.haveHeros - 1 then
		obj:initData(self.haveHeros[index + 1])
	else
		index = index - #self.haveHeros
		obj:initData(self.noHaveHeros[index + 1])
	end
	gModuleMgr.sharedMgr("mildGuideManager"):deleteRunEffect(obj)
end
function newHeroListViewPanel:onNoRenderer(index, obj)
	obj:initData(self.noHaveHeros[index + 1])
	gModuleMgr.sharedMgr("mildGuideManager"):deleteRunEffect(obj)
end
function newHeroListViewPanel:onBtnsRenderer(index, obj)
	obj:initData(index, self.curClass)
end
function newHeroListViewPanel:onComboBoxClick()
	SoraDPlaySound()
	self.curSortType = tonumber(self.fields.ComboBox_sort:getValue())
	print("self.curSortType", self.curSortType)
	self:initData(self.curClass, self.curSortType)
end
function newHeroListViewPanel:onShow()
	print("=======newHeroListViewPanel:onShow")
	self:initHeroByClass()
	self.haveHeros = heroCtrl:getHaveHerosListByRule(self.curSortType)
	if #self.haveHeros == 0 then
		self.curTag = 2
	end
end
function newHeroListViewPanel:updateData()
	self:initData(self.curClass, self.curSortType)
end
function newHeroListViewPanel:initData(classType, sortType)
	self.curClass = classType or self.curClass
	self.curSortType = sortType or self.curSortType
	self.haveHeros = heroCtrl:getHaveHerosListByRule(self.curSortType)
	self.noHaveHeros = heroCtrl:getNoHaveHerosListByRule()
	if self.curClass and self.curClass > 0 then
		self.haveHeros = heroltCtrl.filterHeroClass(#heroltCtrl.heroClassesInfo + 1 - self.curClass, self.haveHeros)
		self.noHaveHeros = heroltCtrl.filterHeroClass(#heroltCtrl.heroClassesInfo + 1 - self.curClass, self.noHaveHeros)
	end
	local comStr = string.format("%s%d/%d", i18n("common_text_318"), #self.haveHeros, #self.noHaveHeros + #self.haveHeros)
	self.fields.Text_friendNum:setString(comStr)
	local num = heroBiographyCtrl:getUnlockHeroStoryNum()
	self.fields.Button_story:setReddot(0 < num, num)
	self:updateHeroList()
end
function newHeroListViewPanel:initHeroByClass(class)
	self.curClass = class or self.curClass
	self.fields.List_btns:setNumItems(#heroltCtrl.heroClassesInfo + 1)
	self:initData(self.curClass, self.curSortType)
	self.fields.List_btns:setSelectedIndex(self.curClass)
end
function newHeroListViewPanel:onClickTab(tag)
	print("onClickTab======", tag)
	self.curTag = tag
	self.fields.List_hero_have:setVisible(tag == 1)
	self:initData(self.curClass, self.curSortType)
end
function newHeroListViewPanel:onClickHelp()
	SoraDPlaySound()
	if IsArClient then
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.HERO_SYS)
	else
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.HERO_SYS)
	end
end
function newHeroListViewPanel:onClickBtnList()
	SoraDPlaySound()
	local index = self.fields.List_btns:getSelectedIndex()
	self.curClass = index
	self:initData(self.curClass, self.curSortType)
end
function newHeroListViewPanel:onClickBtnStory()
	SoraDPlaySound()
	if SoraDGetCastleLv() >= CASTLE_LV40_LIMITED then
		uiManager:show("HeroCollectedBiographies")
	else
		_ENV = nil
		;(nil).level = 1
		SoraDShowMsgTip(i18n("common_text_3962", nil))
	end
end
function newHeroListViewPanel:onClickBtnTemple()
	SoraDPlaySound()
	uiManager:show("HeroTempleMain")
end
function newHeroListViewPanel:onClickBtnTrial()
	SoraDPlaySound()
	uiManager:show("HeroNewTrialHookView")
end
function newHeroListViewPanel:endShow()
	if not SoraDIsGameGuide() and not self.jumpToBestHero then
		local noHaveHeros = heroCtrl:getNoHaveHerosListByRule()
		for k, v in pairs(noHaveHeros) do
			local itemNum, needNum, itemID = heroltCtrl:judgeUpgradeItem(v)
			local activeTime = heroltCtrl:getUpgradeActiveTime(v) or 0
			if needNum <= itemNum and activeTime == 0 then
				print("-- 有可解锁英雄 --", v)
				local index = 1
				for ki, vi in ipairs(self.noHaveHeros) do
					if vi == v then
						index = ki
						break
					end
				end
				gModuleMgr.sharedMgr("mildGuideManager"):starToHeroUnlockQuality()
				break
			end
		end
	end
	if self.jumpToBestHero then
		local heroID
		for k, v in ipairs(self.haveHeros) do
			local rarity = heroltCtrl:getRarity(tonumber(v))
			if rarity >= gHeroRarity.GREEN then
				local posIndex = k - 1
				self.fields.List_hero_have:scrollToView(posIndex)
				heroID = tonumber(v)
				break
			end
		end
		if heroID then
			_ENV = ipairs(self.haveHeros)
			ipairs(self.haveHeros).heroID = heroID
			gModuleMgr.sharedMgr("mildGuideManager"):starToHeroClick(ipairs(self.haveHeros))
		end
	end
	self.jumpUnlockHero = self.param and self.param.jumpUnlockHero
	if self.jumpUnlockHero then
		self:jumpToUnlockHero(self.jumpUnlockHero)
	end
end
function newHeroListViewPanel:jumpToUnlockHero(heroID)
	if not self.jumpToBestHero then
		local index = 1
		for ki, vi in ipairs(self.noHaveHeros) do
			if vi == heroID then
				index = ki
				break
			end
		end
		local posIndex = index - 1 + #self.haveHeros
		self.fields.List_hero_have:scrollToView(posIndex)
		_ENV = posIndex
		posIndex.heroID = heroID
		gModuleMgr.sharedMgr("mildGuideManager"):starToHeroUnlockQuality(posIndex)
	end
end
function newHeroListViewPanel:getUnlockChild(heroID)
	local index = 1
	for ki, vi in ipairs(self.noHaveHeros) do
		if vi == heroID then
			index = ki
			break
		end
	end
	local posIndex = index - 1 + #self.haveHeros
	self.fields.List_hero_have:scrollToView(posIndex)
	return self.fields.List_hero_have:getChild("item" .. posIndex)
end
function newHeroListViewPanel:getCanUpChild(heroID)
	local index = 1
	for ki, vi in ipairs(self.haveHeros) do
		if vi == heroID then
			index = ki
			break
		end
	end
	return self.fields.List_hero_have:getChildAt(index - 1)
end
function newHeroListViewPanel:getCanClickChild(heroID)
	local index = 1
	for ki, vi in ipairs(self.haveHeros) do
		if tonumber(vi) == heroID then
			index = ki
			break
		end
	end
	local posIndex = index - 1
	self.fields.List_hero_have:scrollToView(posIndex)
	return self.fields.List_hero_have:getChild("item" .. posIndex)
end
function newHeroListViewPanel:updateHeroList(...)
	self.fields.List_hero_have:setNumItems(#self.haveHeros + #self.noHaveHeros)
	self:updateBtnTrialRedStatus()
end
function newHeroListViewPanel:onMsgUpdateHeroNewTrial(target, event)
	local subMsg = event.subMsg
	if subMsg == "cliam" or subMsg == "afkCliam" or subMsg == "afkInit" then
		self:updateHeroList()
	end
end
function newHeroListViewPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "heroListUnlockHero" then
		if parameters.heroID then
			return self:getUnlockChild(parameters.heroID):getTouchBtn()
		else
			self.fields.List_hero_have:scrollToView(#self.haveHeros)
			return self.fields.List_hero_have:getChild("item" .. #self.haveHeros):getTouchBtn()
		end
	elseif itemName == "heroListUnlockedHero" then
		self.fields.List_hero_have:scrollToView(#self.haveHeros - 1)
		return self.fields.List_hero_have:getChild("item" .. #self.haveHeros - 1):getTouchBtn()
	elseif itemName == "heroListCanUpHero" then
		local heroID = heroltCtrl.canUpQualityHero
		return self:getCanUpChild(heroID):getTouchBtn()
	elseif itemName == "heroListClick" then
		return self:getCanClickChild(parameters.heroID):getTouchBtn()
	else
		return self.fields[itemName]
	end
end
return newHeroListViewPanel
