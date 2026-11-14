local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local HeroHuntingSelectItem = class("heroHuntingSelectItem", function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroHuntingSelectItem")
	end
	return target
end)
function HeroHuntingSelectItem:ctor()
	self.stateList, _ENV = nil, nil
	self.spHeroBg = SoraDGetChildByName(self, "Sprite_headBg")
	self.spHeroHead = SoraDGetChildByName(self, "Sprite_head")
	self.nodeLoadBar = SoraDGetChildByName(self, "Node_loadBar")
	self.loadBar = SoraDGetChildByName(self, "LoadingBar_loadBar")
	self.txtLoadBar = SoraDGetChildByName(self, "Text_loadBar")
	self.txtLv = SoraDGetChildByName(self, "Text_lv")
	self.spClass = SoraDGetChildByName(self, "Sprite_class")
	self.spLight = SoraDGetChildByName(self, "Sprite_light")
	self.spriteName = SoraDGetChildByName(self, "sprite_name")
	self.spLight:setVisible(false)
	self.txtName = SoraDGetChildByName(self, "Text_name")
	self.txtTip = SoraDGetChildByName(self, "Text_arg")
	self.btnItem = SoraDGetChildByName(self, "Button_item")
	self.btnItem:addTouchEventListener(handler(self, self.btnItemClick))
	self.btnItem:setSwallowTouches(false)
end
local colorGray = cc.c3b(123, 123, 123)
local colorNormal = cc.c3b(255, 255, 255)
function HeroHuntingSelectItem:initData(heroID)
	self.heroID = heroID
	self.heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	self.heroDesInfo = heroltCtrl.getHeroInfo(self.heroID)
	self:initView()
end
function HeroHuntingSelectItem:initView(...)
	self.spHeroHead:setSpriteFrame(self.heroDesInfo.herIcon)
	self.spClass:setSpriteFrame(heroltCtrl.getHeroClassTypeInfo(self.heroID).icon)
	self.spHeroBg:setSpriteFrame(heroltCtrl.getBg(self.heroInfo.quality))
	self.txtLv:setString(self.heroInfo.level)
	if self.heroInfo.level >= gHeroMaxLevel then
		self.loadBar:setPercent(100)
	else
		local maxExp = heroltCtrl:getHeroLevelInfo(self.heroID, self.heroInfo.level).exp
		self.loadBar:setPercent(self.heroInfo.level_exp / maxExp * 100)
	end
	local heroName = heroltCtrl.getHeroNamePng(self.heroID)
	if heroName then
		self.txtName:setVisible(false)
		self.spriteName:setVisible(true)
		self.spriteName:setSpriteFrame(heroName)
	else
		self.txtName:setVisible(true)
		self.spriteName:setVisible(false)
		self.txtName:setString(i18n(self.heroDesInfo.herName))
	end
	heroltCtrl = i18n(self.heroDesInfo.herName)
	i18n(self.heroDesInfo.herName).num = heroCtrl:getHeroHuntingRate(self.heroID)
	local strTip = i18n("common_text_4418", i18n(self.heroDesInfo.herName))
	self.txtTip:setString(strTip)
	self:initState()
end
function HeroHuntingSelectItem:judgeCanBeSelected(...)
	if not heroCtrl:judgeHeroInStates(self.heroID, self.stateList) then
		return self.heroInfo.state
	end
end
function HeroHuntingSelectItem:initState(...)
	if self:judgeCanBeSelected() then
		SoraDGetCSBFather(self):setColor(colorGray)
	else
		SoraDGetCSBFather(self):setColor(colorNormal)
	end
end
function HeroHuntingSelectItem:setClickCallBack(handle)
	self.clickHandler = handle
end
function HeroHuntingSelectItem:setCancelLightBack(handle)
	self.cancelLightHandler = handle
end
function HeroHuntingSelectItem:setMeCheck(bool)
	self.spLight:setVisible(bool)
end
function HeroHuntingSelectItem:setFilteHeroState(states)
	self.stateList = states
end
function HeroHuntingSelectItem:btnItemClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			return
		else
		end
		SoraDPlaySound()
		local reason = self:judgeCanBeSelected()
		if gHeroState.HERO_STATE_DEAD == reason then
			SoraDShowMsgTip(i18n("mail_title_16"))
		elseif gHeroState.HERO_STATE_CAPTURED == reason then
			SoraDShowMsgTip(i18n("mail_title_18"))
		elseif gHeroState.HERO_STATE_BATTLE == reason or gHeroState.HERO_STATE_ESCAPE == reason then
			SoraDShowMsgTip(i18n("herotrain_text_19"))
		elseif reason then
			SoraDShowMsgTip("herotrain_text_19")
		elseif self.spLight:isVisible() then
			self.cancelLightHandler(self.heroID)
		else
			self.clickHandler(self.heroID)
		end
	end
end
function HeroHuntingSelectItem:setScroll(scroll)
	self.scroll = scroll
end
return HeroHuntingSelectItem
