local baseComponent = require("fgui.base.baseComponent")
local heroHuntingSelectItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceHuntView/heroHuntingSelectItem", heroHuntingSelectItem)
local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
function heroHuntingSelectItem:onInit()
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
	self.txtTip = SoraDGetChildByName(self, "Text_arg")
	self.btnItem = SoraDGetChildByName(self, "Button_item")
	self.btnItem:addEventListener(fgui.UIEventType.Click, handler(self, self.btnItemClick))
	self.btnItem:setSwallowTouches(false)
end
local colorGray = cc.c3b(123, 123, 123)
local colorNormal = cc.c3b(255, 255, 255)
function heroHuntingSelectItem:onShow()
end
function heroHuntingSelectItem:initData(heroID)
	self.heroID = heroID
	self.heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	self.heroDesInfo = heroltCtrl.getHeroInfo(self.heroID)
	self:initView()
end
function heroHuntingSelectItem:initView(...)
	self.spHeroHead:setSpriteFrame(self.heroDesInfo.herIcon)
	self.spClass:setSpriteFrame(heroltCtrl.getHeroClassTypeInfo(self.heroID).icon)
	self.spHeroBg:setSpriteFrame(heroltCtrl.getBg(self.heroInfo.quality))
	self.txtLv:setString(self.heroInfo.level)
	if self.heroInfo.level >= gHeroMaxLevel then
		self.loadBar:setValue(100)
	else
		local maxExp = heroltCtrl:getHeroLevelInfo(self.heroID, self.heroInfo.level).exp
		self.loadBar:setValue(self.heroInfo.level_exp / maxExp * 100)
	end
	local heroName = heroltCtrl.getHeroNamePng(self.heroID)
	self.spriteName:setVisible(true)
	self.spriteName:setURL(heroName)
	heroltCtrl = heroName
	heroName.num = heroCtrl:getHeroHuntingRate(self.heroID)
	local strTip = i18n("common_text_4418", heroName)
	self.txtTip:setString(strTip)
	self:initState()
end
function heroHuntingSelectItem:judgeCanBeSelected(...)
	if not heroCtrl:judgeHeroInStates(self.heroID, self.stateList) then
		return self.heroInfo.state
	end
end
function heroHuntingSelectItem:initState(...)
	if self:judgeCanBeSelected() then
		self:setGrayed(true)
	else
		self:setGrayed(false)
	end
end
function heroHuntingSelectItem:setClickCallBack(handle)
	self.clickHandler = handle
end
function heroHuntingSelectItem:setCancelLightBack(handle)
	self.cancelLightHandler = handle
end
function heroHuntingSelectItem:setMeCheck(bool)
	self.spLight:setVisible(bool)
end
function heroHuntingSelectItem:setFilteHeroState(states)
	self.stateList = states
end
function heroHuntingSelectItem:btnItemClick(button, eventType)
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
function heroHuntingSelectItem:setScroll(scroll)
	self.scroll = scroll
end
return heroHuntingSelectItem
