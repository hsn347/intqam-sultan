local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local publicRead = include("publicRead")
local heroBiographyCtrl = SoraDGetCtrl("heroBiographyCtrl")
local soldierRushRead = include("soldierRushRead")
local heroNewTrialRead = include("heroNewTrialRead")
local heroNewTrialCtrl = SoraDGetCtrl("heroNewTrialCtrl")
_ENV = "heroNewTrialCtrl"
;("heroNewTrialCtrl").NOTOWN = 1
;("heroNewTrialCtrl").NOTORANGE = 2
local ("heroNewTrialCtrl").ORANGE, viewType = 3, "heroNewTrialCtrl"
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local newHeroDetailViewPanel = class("newHeroDetailViewPanel", baseFguiPanel)
function newHeroDetailViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("newHeroDetailViewPanel:ctor", self.viewName)
end
function newHeroDetailViewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "SoldierRush"
	end
	return self._packageList
end
function newHeroDetailViewPanel:onInit()
	print("=======newHeroDetailViewPanel:onInit")
	self.tableEXPLabelSpare, _ENV = print, print
	self.fields.et_quality:setAllFrameName("dh_yingxiongpz_%.2d.png", 0)
	self.fields.title:initData(i18n("hero_text_11"), handler(self, self.onClickMyClose))
	self.fields.title:setTitleWidthHeight(360, 80)
	self.viewType = viewType.NOTOWN
	self.buttonType = gHeroButtonType.NONE
	self.fields.Button_move:setSwallowTouches(true)
	self.fields.Button_move:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onInClick))
	self.fields.Button_move:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onOutClick))
	self.fields.List_btnLeft:setItemRenderer(handler(self, self.onBtnLeftRenderer))
	self.fields.List_btnRight:setItemRenderer(handler(self, self.onBtnRightRenderer))
	self.fields.Button_resurgence:addClickListener(handler(self, self.btnResurgenceClick))
	self.fields.Button_lArrow:addClickListener(handler(self, self.btnLHeroClick))
	self.fields.Button_rArrow:addClickListener(handler(self, self.btnRHeroClick))
	self.fields.skillList:setItemRenderer(handler(self, self.onItemRenderer))
	self.Text_tip = SoraDCreateTimerLabel(self, self.fields.Text_tip)
	self.fields.nlock:setVisible(false)
	self:hideUpgradeEffect()
	self:hideLvUpEffect()
	self.fields.Effect_bj:setIsLoop(false)
	self.fields.Effect_bj:setVisible(false)
	self.fields.com_skillStudy:setVisible(false)
	self:addEventListener(fgui.UIEventType.TouchEnd, function()
		_ENV = nil
		;(nil).msg = "MESSAGE_UI_HERO_RUSH_SKILL"
		SoraDSendMessage(nil)
	end)
end
function newHeroDetailViewPanel:onBtnLeftRenderer(index, obj)
	obj:initData(self.btnLeft[index + 1], self.heroID, self.heroClass)
end
function newHeroDetailViewPanel:onBtnRightRenderer(index, obj)
	obj:initData(self.btnRight[index + 1], self.heroID, self.heroClass)
end
function newHeroDetailViewPanel:setBtnWeapon()
	self.fields.under:setBtnWeapon()
end
function newHeroDetailViewPanel:onInClick(context)
	self.posBegin = context:getInput():getPosition()
end
function newHeroDetailViewPanel:onOutClick(context)
	self.posEnd = context:getInput():getPosition()
	if self.posBegin and self.posEnd then
		if self.posEnd.x - self.posBegin.x >= 30 then
			self:btnLHeroClick()
		elseif self.posEnd.x - self.posBegin.x <= -30 then
			self:btnRHeroClick()
		end
		self.posBegin = nil
		self.posEnd = nil
	end
end
function newHeroDetailViewPanel:getLeftOrRightHeroID()
	local pos = 1
	for k, v in ipairs(self.heroIDList) do
		if tonumber(v) == tonumber(self.heroID) then
			pos = k
			break
		end
	end
	local lPos = (pos - 1) % #self.heroIDList == 0 and #self.heroIDList or (pos - 1) % #self.heroIDList
	local rPos = pos + 1 > #self.heroIDList and (pos + 1) % #self.heroIDList or pos + 1
	return self.heroIDList[lPos], self.heroIDList[rPos]
end
function newHeroDetailViewPanel:btnLHeroClick(button, eventType)
	SoraDPlaySound()
	self.isLeftClick = true
	if SoraDFIsRA() then
		local _, rb = self:getLeftOrRightHeroID()
		if rb then
			self:jumpToHero(rb)
		end
	else
		local lb, _ = self:getLeftOrRightHeroID()
		if lb then
			self:jumpToHero(lb)
		end
	end
end
function newHeroDetailViewPanel:jumpToHero(hid)
	if heroCtrl:judgeMyHeroInJail(hid) then
		heroCtrl = nil
		;(nil).heroID = hid
		uiManager:show("HeroJailDetail", nil)
	else
		self:initData(hid)
		self:initHeadSpine()
		self:updateMildGuide()
	end
end
function newHeroDetailViewPanel:btnRHeroClick(button, eventType)
	SoraDPlaySound()
	self.isLeftClick = false
	if SoraDFIsRA() then
		local lb, _ = self:getLeftOrRightHeroID()
		if lb then
			self:jumpToHero(lb)
		end
	else
		local _, rb = self:getLeftOrRightHeroID()
		if rb then
			self:jumpToHero(rb)
		end
	end
end
function newHeroDetailViewPanel:onItemRenderer(index, obj)
	obj:initData(self.skillList[index + 1])
end
function newHeroDetailViewPanel:btnResurgenceClick()
	SoraDPlaySound()
	if backpackCtrl:getItemCount(gHeroSpecialItems.resurgencefruit) > 0 then
		SoraDShowMsgBox(i18n("hero_text_43"), i18n("common_text_054"), nil, function(eventType)
			if MSGBOX_CALLBACK_YES == eventType then
				heroCtrl:resurgenceHeroReq(self.heroID, gHeroSpeedUpType.ITEM)
			end
		end)
	else
		local itemInfo = gModuleMgr.sharedMgr("shopltCtrl"):getShopItemByItemID(gHeroSpecialItems.resurgencefruit)
		if itemInfo then
			local needGold = fguiHelper.getColorString("#FFFF00", string.formatnumberthousands(itemInfo.price))
			_ENV = string.formatnumberthousands(itemInfo.price)
			_ENV = string.formatnumberthousands(itemInfo.price)
			string.formatnumberthousands(itemInfo.price).gold = needGold
			string.formatnumberthousands(itemInfo.price).content = i18n("hero_text_44", string.formatnumberthousands(itemInfo.price))
			string.formatnumberthousands(itemInfo.price).confirmString = i18n("common_text_054")
			string.formatnumberthousands(itemInfo.price).cancelString = i18n("heroDes_text_07")
			string.formatnumberthousands(itemInfo.price).confirmFunc = function()
				heroCtrl:resurgenceHeroReq(self.heroID, gHeroSpeedUpType.GOLD)
			end
			uiManager:show("MessageBox", string.formatnumberthousands(itemInfo.price))
		else
			SoraDShowMsgTip(i18n("hero_text_45"))
		end
	end
end
function newHeroDetailViewPanel:onShow()
	print("=======newHeroDetailViewPanel:onShow")
	self:initData(self.param.heroID, self.param.heroClass)
	self:initHeadSpine()
	self.heroPosY = self.fields.Com_hero:getPositionY()
	self.bgPosY = self.fields.bg:getPositionY()
end
function newHeroDetailViewPanel:endShow()
	print("=======newHeroDetailViewPanel:endShow")
	self:updateMildGuide()
end
function newHeroDetailViewPanel:onHide()
	print("=======newHeroDetailViewPanel:onHide")
end
function newHeroDetailViewPanel:close()
	SoraDPlaySound()
	if self.fields.com_skillStudy:isVisible() then
		_ENV = self.fields.com_skillStudy
		self.fields.com_skillStudy.msg = "MESSAGE_UI_HERODETAIL_SKILL_STUDY"
		self.fields.com_skillStudy.isShow = false
		SoraDSendMessage(self.fields.com_skillStudy)
	else
		self:closePanel()
	end
end
function newHeroDetailViewPanel:onDispose()
	print("=======newHeroDetailViewPanel:onDispose")
	_ENV = "=======newHeroDetailViewPanel:onDispose"
	;("=======newHeroDetailViewPanel:onDispose").msg = "MESSAGE_UI_HERO_REFRESHLISTVIEW"
	;("=======newHeroDetailViewPanel:onDispose").noJump = true
	SoraDSendMessage("=======newHeroDetailViewPanel:onDispose")
end
function newHeroDetailViewPanel:playUpgradeEffect()
	self.fields.Particle_1:setVisible(true)
	self.fields.Particle_2:setVisible(true)
	self.fields.Particle_3:setVisible(true)
	self.fields.Particle_4:setVisible(true)
	self.fields.Particle_1:resetSystem()
	self.fields.Particle_2:resetSystem()
	self.fields.Particle_3:resetSystem()
	self.fields.Particle_4:resetSystem()
end
function newHeroDetailViewPanel:hideUpgradeEffect()
	self.fields.Particle_1:setVisible(false)
	self.fields.Particle_2:setVisible(false)
	self.fields.Particle_3:setVisible(false)
	self.fields.Particle_4:setVisible(false)
	self.fields.Particle_1:stopSystem()
	self.fields.Particle_2:stopSystem()
	self.fields.Particle_3:stopSystem()
	self.fields.Particle_4:stopSystem()
end
function newHeroDetailViewPanel:playLvUpEffect()
	self.fields.Particle_lvup1:setVisible(true)
	self.fields.Particle_lvup2:setVisible(true)
	self.fields.Particle_lvup3:setVisible(true)
	self.fields.Particle_lvup4:setVisible(true)
	self.fields.Particle_lvup5:setVisible(true)
	self.fields.Particle_lvup1:resetSystem()
	self.fields.Particle_lvup2:resetSystem()
	self.fields.Particle_lvup3:resetSystem()
	self.fields.Particle_lvup4:resetSystem()
	self.fields.Particle_lvup5:resetSystem()
end
function newHeroDetailViewPanel:hideLvUpEffect()
	self.fields.Particle_lvup1:setVisible(false)
	self.fields.Particle_lvup2:setVisible(false)
	self.fields.Particle_lvup3:setVisible(false)
	self.fields.Particle_lvup4:setVisible(false)
	self.fields.Particle_lvup5:setVisible(false)
	self.fields.Particle_lvup1:stopSystem()
	self.fields.Particle_lvup2:stopSystem()
	self.fields.Particle_lvup3:stopSystem()
	self.fields.Particle_lvup4:stopSystem()
	self.fields.Particle_lvup5:stopSystem()
end
function newHeroDetailViewPanel:initData(heroID, heroClass, isIgnorSound)
	self.heroID = tonumber(heroID)
	self.heroClass = heroClass
	self.heroIDList = heroCtrl:getAllHerosListByRule()
	if not isIgnorSound then
		heroltCtrl:playHeroSound(self.heroID)
	end
	self:refreshData()
	self:initView()
	local newActivityRead = include("newActivityRead")
	local heroNewTrialCtrl = SoraDGetCtrl("heroNewTrialCtrl")
	local dialogueID = tonumber(self.heroID .. "01")
	if newActivityRead:getDialogues(dialogueID) and not heroNewTrialCtrl:checkFinishGuide(self.heroID) then
		_ENV = heroNewTrialCtrl:checkFinishGuide(self.heroID)
		heroNewTrialCtrl:checkFinishGuide(self.heroID).type = "activity"
		heroNewTrialCtrl:checkFinishGuide(self.heroID).dialogueID = dialogueID
		local heroNewTrialCtrl:checkFinishGuide(self.heroID).callback, dialogueParam = function(...)
			heroNewTrialCtrl:reqGuide(self.heroID)
		end, heroNewTrialCtrl:checkFinishGuide(self.heroID)
		uiManager:show("MainCityGuideDialog", dialogueParam)
	end
end
function newHeroDetailViewPanel:updateView()
	if self.fields.com_skillStudy:isVisible() then
		self:updateBtnChip()
		self.fields.under:updatePower()
		return
	end
	self:initData(self.heroID, self.heroClass, true)
end
function newHeroDetailViewPanel:refreshData()
	self.heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	self.heroExInfo = heroltCtrl.getHeroInfo(self.heroID)
	self.maxQuality = heroltCtrl:getHeroAwakeMaxQuality(self.heroID)
	if self.heroInfo then
		self.viewType = self.heroInfo.quality >= self.maxQuality and viewType.ORANGE or viewType.NOTORANGE
		self.heroLevelInfo = heroltCtrl:getHeroLevelInfo(self.heroID, self.heroInfo.level)
		self.heroUpgradeInfo = heroltCtrl:getUpgradeInfo(self.heroID, self.heroInfo.quality)
		self.heroNextUpgradeInfo = heroltCtrl:getUpgradeInfo(self.heroID, self.heroInfo.quality + 1)
		local isOrangeHero = self.heroNextUpgradeInfo == nil
		self.itemID = isOrangeHero and self.heroUpgradeInfo.heroCard[1] or self.heroNextUpgradeInfo.heroCard[1]
		self.needNum = isOrangeHero and self.heroUpgradeInfo.heroCard[2] or self.heroNextUpgradeInfo.heroCard[2]
		self.itemNum = backpackCtrl:getItemCount(self.itemID)
		if self.heroInfo.isAwake then
			self.buttonType = self.heroInfo.level >= gHeroAwakeMaxLevel and gHeroButtonType.MAXLV or gHeroButtonType.WAKED
		else
			local heroID, upgradeType = heroCtrl:getUpgradeQueue()
			if heroID and heroID == self.heroID then
				self.buttonType = upgradeType == gHeroSysUpType.UPGRADE and gHeroButtonType.SPEEDUP or gHeroButtonType.WAKING
			elseif self.heroInfo.quality >= self.maxQuality then
				if self.heroInfo.level < gHeroMaxLevel then
					self.buttonType = gHeroButtonType.LIMITLV
				else
					local awakeInfo = heroltCtrl:getAwakeInfo(self.heroID)
					if awakeInfo.itemCount > backpackCtrl:getItemCount(awakeInfo.item) then
						self.buttonType = gHeroButtonType.LIMITCHIP
						self.needNum = awakeInfo.itemCount
					else
						self.buttonType = gHeroButtonType.WAKEUP
					end
				end
			else
				self.buttonType = self.itemNum >= self.needNum and self.heroNextUpgradeInfo and gHeroButtonType.UPGRADE or gHeroButtonType.GAINCHIP
			end
		end
	else
		self.viewType = viewType.NOTOWN
		self.heroLevelInfo = heroltCtrl:getHeroLevelInfo(self.heroID, 1)
		self.heroUpgradeInfo = heroltCtrl:getUpgradeInfo(self.heroID, gHeroQuality.WHITE)
		self.heroNextUpgradeInfo = heroltCtrl:getUpgradeInfo(self.heroID, gHeroQuality.WHITE + 1)
		local itemNum, needNum, itemID = heroltCtrl:judgeUpgradeItem(self.heroID, gHeroQuality.WHITE)
		self.itemID = itemID
		self.needNum = needNum
		self.itemNum = itemNum
		self.buttonType = self.itemNum < self.itemNum and gHeroButtonType.GAINCHIP or gHeroButtonType.GAINHERO
	end
	if not heroltCtrl:getExchangeInfo(self.heroExInfo.itemID) then
		heroCtrl = heroltCtrl:getExchangeInfo(self.heroExInfo.itemID)
	end
	self.exInfo = heroltCtrl:getExchangeInfo(self.heroExInfo.itemID)
	self.isCanExchange = self.exInfo.changeID ~= nil
	self.fields.Button_chip:setVisible(self.isCanExchange and self.viewType ~= viewType.NOTOWN)
	self:updateBtnChip()
end
function newHeroDetailViewPanel:updateBtnChip()
	self.fields.Button_chip:initData(self.heroID, publicRead.getIcon(self.exInfo.changeID), backpackCtrl:getItemCount(self.exInfo.changeID), self.exInfo.changeNum)
end
function newHeroDetailViewPanel:updateTaskRedStatus()
	local __, getAwardNum = heroBiographyCtrl:isAllTaskFinish(self.heroID)
	self.btnRight = self:setBtnRed(self.btnRight, gHeroBtnStyleType.task, getAwardNum)
	local isStoryAwardGot = heroBiographyCtrl:isStoryAwardGot(self.heroID)
	if not isStoryAwardGot and self.viewType ~= viewType.NOTOWN then
		self.fields.Com_operate:setStoryRed(true)
		self.btnRight = self:setBtnRed(self.btnRight, gHeroBtnStyleType.story, 1)
	else
		self.fields.Com_operate:setStoryRed(false)
		self.btnRight = self:setBtnRed(self.btnRight, gHeroBtnStyleType.story, 0)
	end
	self:updateBtnTrialRedStatus()
	self.fields.List_btnRight:setNumItems(#self.btnRight)
	local rs = heroCtrl:isHeroHaveActiveRed(self.heroID)
	self.btnLeft = self:setBtnRed(self.btnLeft, gHeroBtnStyleType.dress, rs and 1 or 0)
	self.fields.List_btnLeft:setNumItems(#self.btnLeft)
end
function newHeroDetailViewPanel:setBtnRed(list, style, redNum)
	for k, v in ipairs(list) do
		if v.style == style then
			v.red = redNum
		end
	end
	return list
end
function newHeroDetailViewPanel:addBtnStyle(list, style, redNum)
	local ret = false
	for k, v in ipairs(list) do
		if v.style == style then
			ret = true
			break
		end
	end
	if not ret then
		_ENV = ipairs(list)
		ipairs(list).style = style
		ipairs(list).red = redNum
		table.insert(list, ipairs(list))
	end
	return list
end
function newHeroDetailViewPanel:updateBiographyRedStatus()
	local unlockNum = heroBiographyCtrl:getHeroUnlockBiographyNum(self.heroID)
	self.isHaveBiograpghy = 0 <= unlockNum
	if self.isHaveBiograpghy then
		self.btnRight = self:addBtnStyle(self.btnRight, gHeroBtnStyleType.biography, unlockNum)
	end
	self.fields.List_btnRight:setNumItems(#self.btnRight)
end
function newHeroDetailViewPanel:updateUnder()
	self.fields.under:initData(self.heroID, self.viewType == viewType.ORANGE, self.buttonType, self.viewType ~= viewType.NOTOWN, self.needNum, self.itemNum)
end
function newHeroDetailViewPanel:initView()
	self.btnRight, _UPVALUE0_, self.btnLeft, _UPVALUE0_ = nil, nil, nil, nil
	self:initBase()
	self:initSkillBoard()
	self:updateTaskRedStatus()
	self:updateBiographyRedStatus()
	self:updateUnder()
	self:setBtnWeapon()
end
function newHeroDetailViewPanel:initSkillBoard()
	local ret = self.viewType == viewType.NOTOWN
	local skillIDs = table.keys(not ret and self.heroInfo.skillList or heroltCtrl:getMaxQualitySkillInfoByHeroID(self.heroID))
	table.sort(skillIDs)
	local self.skillList, viewType, skillList = heroltCtrl, heroltCtrl, not ret and self.heroInfo.skillList or heroltCtrl:getMaxQualitySkillInfoByHeroID(self.heroID)
	local maxQuality = heroltCtrl:getHeroAwakeMaxQuality(self.heroID)
	for i, v in ipairs(skillIDs) do
		local skillData = skillList[v]
		viewType = nil
		;(nil).index = i
		;(nil).skillID = v
		viewType, (nil).quality = ret and maxQuality or self.heroInfo.quality, ret and maxQuality or self.heroInfo.quality
		;(ret and maxQuality or self.heroInfo.quality).isActive = ret and true or skillData.isActive
		;(ret and maxQuality or self.heroInfo.quality).isPreView = ret
		;(nil).otherData, (ret and maxQuality or self.heroInfo.quality).skillLv = ret and maxQuality or self.heroInfo.quality, skillData.activeLevel
		table.insert(self.skillList, nil)
	end
	self.fields.skillList:setNumItems(#self.skillList)
end
function newHeroDetailViewPanel:initStateView()
	if self.viewType ~= viewType.NOTOWN and self.heroInfo and gHeroState.HERO_STATE_DEAD == self.heroInfo.state then
		self.fields.Button_resurgence:setVisible(true)
		self.fields.bg:setGrayed(true)
		self.fields.Com_hero:setEffectColor(cc.c3b(120, 120, 120))
	else
		self.fields.Button_resurgence:setVisible(false)
		self.fields.bg:setGrayed(false)
		self.fields.Com_hero:setEffectColor(cc.c3b(255, 255, 255))
	end
end
function newHeroDetailViewPanel:initHeadSpine()
	local dressID = heroCtrl:getHeroDressSeting(self.heroID)
	local viewBg, isNewBg = heroltCtrl:getDressViewBg(dressID)
	if self.preViewBg and self.preViewBg ~= viewBg then
		self.fields.bg:setSpriteFrame(viewBg)
	else
		self.fields.bg:setSpriteFrame(viewBg)
	end
	local viewBgWidth = self.fields.bg:getWidth()
	if viewBgWidth < 852 then
		self.fields.bg:setScale(self:getWidth() / viewBgWidth)
	else
		self.fields.bg:setScale(1)
	end
	self.preViewBg = viewBg
	local cfg, spineCfg = heroltCtrl:getHeroSpineCfg(dressID)
	local isUsm = cfg.isUsm or false
	self.fields.Com_hero:initData(self.heroID)
	self.fields.Com_hero:playOpacityAct()
	if not isUsm then
		self.fields.Com_hero:playOffsetXAct(0.3, self.isLeftClick)
	end
	self.transitions.t0:play(1, 0, 0, -1)
	self:initStateView()
end
function newHeroDetailViewPanel:initBase()
	self.fields.Sprite_heroname:setSpriteFrame(heroltCtrl.getHeroNamePng(self.heroID, true))
	local fileName, rarity, color = heroltCtrl:getCardRareImg(self.heroID)
	self.fields.Sprite_quality:setSpriteFrame(fileName)
	self.fields.et_quality:setColor(color)
	local heroClassInfo = heroltCtrl.getHeroClassTypeInfo(self.heroID, self.heroClass)
	if heroClassInfo then
		self.fields.Sprite_heroClass:setSpriteFrame(heroClassInfo.icon)
	end
	if self.viewType == viewType.NOTOWN then
		heroltCtrl = heroltCtrl.getHeroNamePng(self.heroID, true)
		heroltCtrl.getHeroNamePng(self.heroID, true).num = string.formatnumberthousands(self.heroLevelInfo.march_add)
		self.fields.Lab_limit:setString(i18n("hero_text_12", heroltCtrl.getHeroNamePng(self.heroID, true)))
		self.fields.chipItem:initData(self.heroID, self.itemNum, self.needNum, self.itemID)
		self.controllers.c1:setSelectedIndex(0)
		local activeTime = heroltCtrl:getUpgradeActiveTime(self.heroID) or 0
		if activeTime and 0 < activeTime and activeTime > serviceFunctions.systemTime() then
			self.Text_tip:setTimeLast(function(strTime)
				_ENV = nil
				;(nil).time = strTime
				return i18n("notactivate_text_3", nil)
			end)
			self.Text_tip:setTimeEndListener(function()
				self.fields.nlock:setVisible(false)
				self.Text_tip:setString(i18n("heroDes_text_06"))
			end)
			self.Text_tip:beginTime(activeTime - serviceFunctions.systemTime())
			self.fields.nlock:setVisible(true)
			self.fields.nlock:fixPos()
		else
			self.fields.nlock:setVisible(false)
			self.Text_tip:endTime()
			self.Text_tip:setString(i18n("heroDes_text_06"))
		end
		self.btnLeft = self:addBtnStyle(self.btnLeft, gHeroBtnStyleType.story, 0)
		if heroNewTrialCtrl:unlockTrialAfk(self.heroID) then
			self.btnRight = self:addBtnStyle(self.btnRight, gHeroBtnStyleType.trialAfk, 0)
		elseif heroNewTrialCtrl:unlockTrial(self.heroID) then
			self.btnRight = self:addBtnStyle(self.btnRight, gHeroBtnStyleType.trial, 0)
		end
	else
		if GAME_HERO_TEMPLE_MODE then
			self.btnLeft = self:addBtnStyle(self.btnLeft, gHeroBtnStyleType.attribute, 0)
		end
		if heroNewTrialCtrl:unlockTrialAfk(self.heroID) then
			self.btnRight = self:addBtnStyle(self.btnRight, gHeroBtnStyleType.trialAfk, 0)
		elseif heroNewTrialCtrl:unlockTrial(self.heroID) then
			self.btnRight = self:addBtnStyle(self.btnRight, gHeroBtnStyleType.trial, 0)
		else
			local isAllTaskFinish = heroBiographyCtrl:isAllTaskFinish(self.heroID)
			if not isAllTaskFinish then
				self.btnRight = self:addBtnStyle(self.btnRight, gHeroBtnStyleType.task, 0)
			end
		end
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Com_operate:initData(self.heroID)
	end
	if 1 < #heroltCtrl:getHeroDress(self.heroID) then
		self.btnLeft = self:addBtnStyle(self.btnLeft, gHeroBtnStyleType.dress, 0)
	end
	self.fields.List_btnLeft:setNumItems(#self.btnLeft)
end
function newHeroDetailViewPanel:feedHeroBack(data)
	if self.heroInfo == nil then
		return
	end
	local oldLevel = self.heroInfo.level
	self:refreshData()
	if oldLevel < self.heroInfo.level then
		self:initSkillBoard()
		self:playLvUpEffect()
		SoraDPlaySound("uicontrol", 3)
	end
	if data and data.itemID then
		local result = backpackltCtrl:getResult(data.itemID)
		if result and result[1] then
			local EXP = result[1].count * data.itemNum * activityShowCtrl:getClassType(gActivityTimeActivityID.SUPER_COMMANDER) / 1000
			local times = data and data.times or 1
			self:SoraDCreateWaveBMP(EXP .. "EXP", times)
		end
	end
	self:updateUnder()
	if self.needGuide == true then
		_ENV = 1
		;(1).byUID = true
		local guideData = SoraDConfigGet("Game:heroList:guide~table", 1)
		guideData.heroUpgrade = true
		_ENV = self
		self.byUID = true
		SoraDConfigSet("Game:heroList:guide~table", guideData, self)
		self.needGuide = nil
	end
end
function newHeroDetailViewPanel:SoraDCreateWaveBMP(showText, times)
	print("SoraDCreateWaveBMP")
	local _ENV, text = "%s x %d", 1 < times and string.format("%s x %d", showText, times) or showText or "NA"
	;("%s x %d").color = cc.c3b(255, 255, 0)
	;("%s x %d").fontSize = 18
	;("%s x %d").pos = cc.p(0, 0)
	;("%s x %d").zOrder = 10
	;("%s x %d").duration = 0.4
	;("%s x %d").moveH = 155
	;("%s x %d").scale = 1.2
	local ("%s x %d").font, param = "res/fonts/baojishuzi0-9.fnt", "%s x %d"
	local waveLabel
	if #self.tableEXPLabelSpare >= 20 then
		waveLabel = table.remove(self.tableEXPLabelSpare, 1)
		waveLabel:stopAllActions()
		waveLabel:setOpacity(255)
		waveLabel:setVisible(true)
		waveLabel:setString(text)
	else
		_ENV = waveLabel
		waveLabel.text = text
		waveLabel.font = param.font
		waveLabel = display.newBMFontLabel(waveLabel)
		self.fields.et_expShow:setContent(waveLabel)
	end
	table.insert(self.tableEXPLabelSpare, waveLabel)
	waveLabel:setCascadeColorEnabled(false)
	waveLabel:setColor(param.color)
	waveLabel:setScale(param.scale)
	waveLabel:setPosition(param.pos)
	local baseScale = param.scale
	if 1 < times then
		self.fields.Effect_bj:setVisible(true)
		self.fields.Effect_bj:playOnce()
		waveLabel:setScale(0.1 * baseScale)
		waveLabel:setOpacity(0)
		_UPVALUE6_ = waveLabel
		_UPVALUE1_ = 0.24
		;(0.24)[1] = cca.fadeTo(0.06666666666666667, 1)
		;(0.24)[2] = cca.scaleTo(0.06666666666666667, 2)
		;(0.24)[3] = cca.scaleTo(0.06666666666666667, 2)
		;(0.24)[4] = cca.scaleTo(0.06666666666666667, 2)
		;(0.24)[5] = cca.scaleTo(0.06666666666666667, 2)
		waveLabel[1] = cca.delay(0.06666666666666667)
		waveLabel[2] = cca.fadeTo(0.016666666666666666, 0.24)
		waveLabel[3] = cca.spawn(0.24)
		waveLabel[4] = cca.scaleTo(0.08333333333333333, 1.68 * baseScale)
		waveLabel[5] = cca.scaleTo(0.05, 1.0 * baseScale)
		waveLabel[6] = cca.scaleTo(0.08333333333333333, 1.07 * baseScale)
		waveLabel[7] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
		waveLabel[8] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
		waveLabel[9] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
		local seqPrepare = cca.seq(waveLabel)
		local moveBy = cca.moveBy(param.duration, 0, param.moveH)
		local fadeTo = cca.fadeTo(param.duration, 0)
		_UPVALUE2_ = 0
		;(0)[1] = moveBy
		;(0)[2] = fadeTo
		local spawn = cca.spawn(0)
		local callFunc = cca.callFunc(function()
			waveLabel:setVisible(false)
		end)
		_UPVALUE3_ = fadeTo
		fadeTo[1] = seqPrepare
		fadeTo[2] = spawn
		fadeTo[3] = callFunc
		local seq = cca.seq(fadeTo)
		waveLabel:runAction(seq)
		self:showCritical(param)
	else
		_UPVALUE1_ = cca.moveBy(param.duration, 0, param.moveH)
		_UPVALUE1_ = cca.spawn(0)
		cca.spawn(0)[1] = cca.moveBy(param.duration, 0, param.moveH)
		cca.spawn(0)[2] = cca.fadeTo(param.duration, 0)
		cca.spawn(0)[3] = cca.fadeTo(param.duration, 0)
		cca.spawn(0)[4] = cca.fadeTo(param.duration, 0)
		cca.spawn(0)[5] = cca.fadeTo(param.duration, 0)
		cca.spawn(0)[6] = cca.fadeTo(param.duration, 0)
		cca.spawn(0)[7] = cca.fadeTo(param.duration, 0)
		cca.moveBy(param.duration, 0, param.moveH)[1] = cca.spawn((cca.spawn(0)))
		cca.moveBy(param.duration, 0, param.moveH)[2] = cca.callFunc(function()
			waveLabel:setVisible(false)
		end)
		cca.moveBy(param.duration, 0, param.moveH)[3] = cca.callFunc(function()
			waveLabel:setVisible(false)
		end)
		cca.moveBy(param.duration, 0, param.moveH)[4] = cca.callFunc(function()
			waveLabel:setVisible(false)
		end)
		cca.moveBy(param.duration, 0, param.moveH)[5] = cca.callFunc(function()
			waveLabel:setVisible(false)
		end)
		cca.moveBy(param.duration, 0, param.moveH)[6] = cca.callFunc(function()
			waveLabel:setVisible(false)
		end)
		cca.moveBy(param.duration, 0, param.moveH)[7] = cca.callFunc(function()
			waveLabel:setVisible(false)
		end)
		cca.moveBy(param.duration, 0, param.moveH)[8] = cca.callFunc(function()
			waveLabel:setVisible(false)
		end)
		cca.moveBy(param.duration, 0, param.moveH)[9] = cca.callFunc(function()
			waveLabel:setVisible(false)
		end)
		local action = cca.seq((cca.moveBy(param.duration, 0, param.moveH)))
		waveLabel:runAction(action)
	end
	return waveLabel
end
function newHeroDetailViewPanel:showCritical(param)
	if not self.spCritical then
		local spName = SoraDFIsRA() and "#baojialabo.png" or "#baojiyingwen.png"
		self.spCritical = display.newSprite(spName)
		self.fields.et_expShow:setContent(self.spCritical)
		self.spCritical:setPosition(cc.p(0, -40))
	else
		self.spCritical:setVisible(true)
	end
	local baseScale = param.scale
	self.spCritical:setScale(0.1 * baseScale)
	self.spCritical:setOpacity(0)
	_UPVALUE6_ = self.spCritical
	_UPVALUE1_ = 0.24
	;(0.24)[1] = cca.fadeTo(0.06666666666666667, 1)
	;(0.24)[2] = cca.scaleTo(0.06666666666666667, 2)
	;(0.24)[3] = cca.scaleTo(0.06666666666666667, 2)
	;(0.24)[4] = cca.scaleTo(0.06666666666666667, 2)
	;(0.24)[5] = cca.scaleTo(0.06666666666666667, 2)
	self.spCritical[1] = cca.delay(0.06666666666666667)
	self.spCritical[2] = cca.fadeTo(0.016666666666666666, 0.24)
	self.spCritical[3] = cca.spawn(0.24)
	self.spCritical[4] = cca.scaleTo(0.08333333333333333, 1.68 * baseScale)
	self.spCritical[5] = cca.scaleTo(0.05, 1.0 * baseScale)
	self.spCritical[6] = cca.scaleTo(0.08333333333333333, 1.07 * baseScale)
	self.spCritical[7] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	self.spCritical[8] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	self.spCritical[9] = cca.scaleTo(0.08333333333333333, 1.0 * baseScale)
	local seqPrepare = cca.seq(self.spCritical)
	_UPVALUE2_ = cca.delay(0.06666666666666667)
	cca.delay(0.06666666666666667)[1] = seqPrepare
	cca.delay(0.06666666666666667)[2] = cca.delay(param.duration * 0.5)
	cca.delay(0.06666666666666667)[3] = cca.fadeOut(param.duration * 0.6)
	cca.delay(0.06666666666666667)[4] = cca.fadeOut(param.duration * 0.6)
	cca.delay(0.06666666666666667)[5] = cca.fadeOut(param.duration * 0.6)
	cca.delay(0.06666666666666667)[6] = cca.fadeOut(param.duration * 0.6)
	cca.delay(0.06666666666666667)[7] = cca.fadeOut(param.duration * 0.6)
	cca.delay(0.06666666666666667)[8] = cca.fadeOut(param.duration * 0.6)
	local seqAct = cca.seq((cca.delay(0.06666666666666667)))
	self.spCritical:stopAllActions()
	self.spCritical:runAction(seqAct)
end
function newHeroDetailViewPanel:upgradeBack()
	self:refreshData()
	self:initView()
	SoraDPlaySound("innerbuildsound", 124)
	self:playUpgradeEffect()
end
function newHeroDetailViewPanel:resurgenceBack()
	self:refreshData()
	self:initStateView()
	self:updateUnder()
end
function newHeroDetailViewPanel:noticeRefresh(redata)
	if redata and redata.affectHeros then
		if redata.affectHeros[tostring(self.heroID)] then
			self:refreshData()
			self:initView()
		end
	else
		self:refreshData()
		self:initView()
	end
end
function newHeroDetailViewPanel:jailNoticeRefresh()
	self:refreshData()
	if self.heroInfo and gHeroState.HERO_STATE_CAPTURED == self.heroInfo.state then
		local heroID = self.heroID
		SoraDRemoveAllAfterPanelFromManager(self)
		_ENV = nil
		;(nil).heroID = heroID
		uiManager:show("HeroJailDetail", nil)
		return
	end
	self:initView()
end
function newHeroDetailViewPanel:recevieItemChangeMsg(redata)
	if redata and redata.itemType then
		if gItemType.LEADER_POINT == redata.itemType then
			self:updateUnder()
		end
		if gItemType.HERO_CHIP == redata.itemType then
			self:updateUnder()
		end
	end
end
function newHeroDetailViewPanel:uiSkillStudy(target, data)
	if data and data.isShow then
		local heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
		if not heroInfo.powerSkillBack then
			local heroCtrl, powerSkillBack = heroInfo.powerSkillBack, heroInfo.powerSkillBack
		end
		local isAwaked = next(powerSkillBack) ~= nil
		local heroExInfo = heroltCtrl.getHeroInfo(self.heroID)
		if not isAwaked or not i18n("heroskill_title_03") then
			heroCtrl = nil
			;(nil).name = i18n(heroExInfo.herName)
		end
		self.fields.title:updateTitle((i18n("heroskill_title_02", nil)))
		self.fields.com_skillStudy:setVisible(true)
		self.fields.com_skillStudy:initData(self.heroID)
		self.fields.com_skillStudy:runActIn()
		self.fields.Com_hero:runAction(ffa.moveTo(0.2, self.fields.Com_hero:getPositionX(), self.heroPosY - 100))
		self.fields.bg:runAction(ffa.moveTo(0.2, self.fields.bg:getPositionX(), self.bgPosY - 100))
		self:setTopOtherShow(false)
	else
		self.fields.title:updateTitle(i18n("hero_text_11"))
		self.fields.com_skillStudy:runActOut()
		self.fields.Com_hero:runAction(ffa.moveTo(0.2, self.fields.Com_hero:getPositionX(), self.heroPosY))
		self.fields.bg:runAction(ffa.moveTo(0.2, self.fields.bg:getPositionX(), self.bgPosY))
		self:setTopOtherShow(true)
	end
end
function newHeroDetailViewPanel:setTopOtherShow(ret)
	if ret then
		self.fields.Com_operate:runAction(ffa.fadeIn(0.3))
		self.fields.List_btnRight:runAction(ffa.fadeIn(0.3))
		self.fields.List_btnLeft:runAction(ffa.fadeIn(0.3))
	else
		self.fields.Com_operate:runAction(ffa.fadeOut(0.3))
		self.fields.List_btnRight:runAction(ffa.fadeOut(0.3))
		self.fields.List_btnLeft:runAction(ffa.fadeOut(0.3))
	end
end
function newHeroDetailViewPanel:uiSkillPop(data)
	self.fields.skillPop:setVisible(data.isShow)
	if data.isShow then
		self.fields.skillPop:initData(self.heroID, data.skillID, data.quality, data.otherData)
		self.fields.skillPop:setPositionY(380 + data.index * 89)
	end
end
function newHeroDetailViewPanel:updateMildGuide()
	if self.viewType == viewType.NOTOWN then
	else
		if SoraDIsGameGuide() ~= nil then
			return
		end
		local heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
		if heroInfo == nil then
			return
		end
		if heroCtrl:getUpgradeQueue() == self.heroID and self.needNum < self.itemNum or heroInfo.level >= gHeroAwakeMaxLevel then
			gModuleMgr.sharedMgr("mildGuideManager"):clean()
		end
		if gHeroState.HERO_STATE_DEAD ~= heroInfo.state and not heroCtrl:getUpgradeQueue() ~= self.heroID and heroInfo.level < gHeroAwakeMaxLevel then
			viewType = nil
			;(nil).byUID = true
			local guideData = SoraDConfigGet("Game:heroList:guide~table", nil)
			if guideData.heroUpQuality and not guideData.heroUpgrade then
				self.needGuide = true
				gModuleMgr.sharedMgr("mildGuideManager"):starToHeroUpgrade()
			end
		end
	end
end
function newHeroDetailViewPanel:onClickMyClose()
	self:onClickClose()
	local proxy = uiManager:getProxy("HeroJailDetail")
	if proxy then
		proxy:getPanel():removeFromParent()
	end
end
function newHeroDetailViewPanel:updateBtnTrialRedStatus(...)
	if heroNewTrialCtrl:unlockTrialAfk(self.heroID) then
		local ret, num = heroNewTrialCtrl:getTrialAfkStatusAndNum(self.heroID)
		self.btnRight = self:setBtnRed(self.btnRight, gHeroBtnStyleType.trialAfk, num)
	elseif heroNewTrialCtrl:unlockTrial(self.heroID) then
		local ret, num = heroNewTrialCtrl:getTaskStatusAndNum(self.heroID)
		self.btnRight = self:setBtnRed(self.btnRight, gHeroBtnStyleType.trial, num)
	end
end
function newHeroDetailViewPanel:onMsgUpdateHeroNewTrial(target, event)
	local subMsg = event.subMsg
	if subMsg == "cliam" and heroNewTrialCtrl:unlockTrialAfk(self.heroID) then
		for __, v in ipairs(self.btnRight) do
			if v.style == gHeroBtnStyleType.trial then
				v.style = gHeroBtnStyleType.trialAfk
				break
			end
		end
	end
	if subMsg == "cliam" or subMsg == "afkCliam" or subMsg == "afkInit" then
		self:updateBtnTrialRedStatus()
		self.fields.List_btnRight:setNumItems(#self.btnRight)
	end
end
function newHeroDetailViewPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "feedHeroEXP" then
		return self.fields.under:getOwnItem()
	elseif itemName == "heroSkillItem_1" then
		return self.fields.skillList:getChildAt(0)
	elseif itemName == "Button_upgrade" then
		return self.fields.under:getBtnUpgrade()
	elseif itemName == "feed_guide_panel" then
		return self.fields.under:getFeedGuidePanel()
	elseif itemName == "Button_trialAfk" then
		return self:getButtonByBtnStyle(gHeroBtnStyleType.trialAfk)
	else
		return self.fields[itemName]
	end
end
function newHeroDetailViewPanel:getButtonByBtnStyle(style)
	local index
	for i, v in ipairs(self.btnRight) do
		if v.style == style then
			index = i
			break
		end
	end
	if index then
		return self.fields.List_btnRight:getChildAt(index - 1)
	end
	for i, v in ipairs(self.btnLeft) do
		if v.style == style then
			index = i
			break
		end
	end
	if index then
		return self.fields.List_btnLeft:getChildAt(index - 1)
	end
end
return newHeroDetailViewPanel
