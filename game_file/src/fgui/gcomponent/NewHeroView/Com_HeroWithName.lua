local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_HeroWithName = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_HeroWithName", Com_HeroWithName)
function Com_HeroWithName:onInit()
	self.fields.loadBar:fixChildrenPos()
end
function Com_HeroWithName:onShow()
end
function Com_HeroWithName:initData(heroID)
	self.heroID = tonumber(heroID)
	self.heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	self.heroDesInfo = heroltCtrl.getHeroInfo(self.heroID)
	self:initView()
end
local colorGray = cc.c3b(123, 123, 123)
local colorNormal = cc.c3b(255, 255, 255)
function Com_HeroWithName:initView(...)
	self.fields.Sprite_head:setURL(self.heroDesInfo.herIcon)
	self.fields.Sprite_headBg:setURL(heroltCtrl.getBg(self.heroInfo.quality))
	self.fields.Sprite_class:setURL(heroltCtrl.getHeroClassTypeInfo(self.heroID).icon)
	self.fields.Text_Lv:setString(self.heroInfo.level)
	if self.heroInfo.level >= gHeroMaxLevel then
		self.fields.loadBar:setMax(100)
		self.fields.loadBar:setValue(100)
	else
		local maxExp = heroltCtrl:getHeroLevelInfo(self.heroID, self.heroInfo.level).exp
		self.fields.loadBar:setMax(maxExp)
		self.fields.loadBar:setValue(self.heroInfo.level_exp)
	end
	local heroName = heroltCtrl.getHeroNamePng(self.heroID)
	if heroName then
		self.fields.Text_Name:setVisible(false)
		self.fields.sprite_name:setVisible(true)
		self.fields.sprite_name:setURL(heroName)
	else
		self.fields.Text_Name:setVisible(true)
		self.fields.sprite_name:setVisible(false)
		self.fields.Text_Name:setString(i18n(self.heroDesInfo.herName))
	end
	local iconName, _, _ = heroltCtrl:getCardRareImg(self.heroID)
	self.fields.Sprite_quality:setURL(iconName)
	self:initState()
end
function Com_HeroWithName:judgeCanBeSelected(...)
	if gHeroState.HERO_STATE_NORMAL ~= self.heroInfo.state and gHeroState.HERO_STATE_DEFEND ~= self.heroInfo.state then
		return self.heroInfo.state
	else
		local limitLv, isFull = heroltCtrl.getLimitHeroLv(self.heroInfo.isAwake)
		if limitLv <= self.heroInfo.level then
			if isFull then
				return "full", self.heroInfo.isAwake
			else
				return "exp", self.heroInfo.isAwake
			end
		end
	end
end
function Com_HeroWithName:initState(...)
	if self:judgeCanBeSelected() then
		self:setGrayed(true)
		self:setColor(colorGray)
	else
		self:setGrayed(false)
		self:setColor(colorNormal)
	end
end
function Com_HeroWithName:setChooseBack(handle)
	self.chooseHandler = handle
end
function Com_HeroWithName:setCancelBack(handle)
	self.cancelHandler = handle
end
function Com_HeroWithName:buttonClickcheck()
	local reason, isAwake = self:judgeCanBeSelected()
	if gHeroState.HERO_STATE_DEAD == reason then
		SoraDShowMsgTip(i18n("herotrain_text_18"))
	elseif gHeroState.HERO_STATE_CAPTURED == reason then
		SoraDShowMsgTip(i18n("herotrain_text_19"))
	elseif gHeroState.HERO_STATE_BATTLE == reason or gHeroState.HERO_STATE_ESCAPE == reason then
		SoraDShowMsgTip(i18n("herotrain_text_19"))
	elseif "full" == reason then
		if not isAwake then
			SoraDShowMsgTip(i18n("hero_text_102"))
		else
			SoraDShowMsgTip(i18n("herotrain_text_20"))
		end
	elseif "exp" == reason then
		SoraDShowMsgTip(i18n("hero_text_102"))
	else
		return true
	end
	return false
end
return Com_HeroWithName
